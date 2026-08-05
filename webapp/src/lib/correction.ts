import type {
  ColumnMapping,
  CorrectionOutcome,
  CorrectionRowResult,
  CorrectionRule,
  ParsedFile,
  ParsedSheet,
  SheetRule
} from '../types';
import { normalizeRef, toNumber, formatDateFr } from './excel';
import { findSheetRule } from './rulesLookup';

const MONTANT_TOLERANCE = 0.01;

interface SourceCandidate {
  refRaw: string;
  refNorm: string;
  montant: number | null;
  echeanceRaw: string | null;
}

/** Retrouve, parmi les fichiers actuellement importés d'un rôle donné, celui
 *  qui contient une feuille du nom demandé (et cette feuille). On ne se base
 *  plus sur un identifiant de fichier : il change à chaque réimport, alors
 *  que le nom de la feuille reste stable et que les règles sont maintenant
 *  partagées entre postes. */
function findFileAndSheet(files: ParsedFile[], sheetName: string): { file: ParsedFile; sheet: ParsedSheet } | null {
  for (const file of files) {
    const sheet = file.sheets.find((s) => s.sheetName === sheetName);
    if (sheet) return { file, sheet };
  }
  return null;
}

function findMapping(rules: SheetRule[], role: 'impayes' | 'reglements', sheetName: string): ColumnMapping | null {
  return findSheetRule(rules, role, sheetName)?.mapping ?? null;
}

/** Diagnostique précisément pourquoi une règle de correction ne peut pas être
 *  calculée, pour afficher un message exploitable plutôt qu'un simple
 *  "vérifiez la page Règles de colonnes" générique. Retourne une liste vide
 *  si tout est en ordre (dans ce cas computeCorrection doit réussir). */
export function diagnoseCorrectionRule(
  rule: CorrectionRule,
  impayesFiles: ParsedFile[],
  reglementFiles: ParsedFile[],
  rules: SheetRule[]
): string[] {
  const issues: string[] = [];

  const source = findFileAndSheet(impayesFiles, rule.sourceSheetName);
  const target = findFileAndSheet(reglementFiles, rule.targetSheetName);

  if (!source) {
    issues.push(
      `La feuille « ${rule.sourceSheetName} » n'est présente dans aucun fichier d'impayés actuellement importé. Importez le fichier correspondant sur la page Import.`
    );
  }
  if (!target) {
    issues.push(
      `La feuille « ${rule.targetSheetName} » n'est présente dans aucun fichier de règlements actuellement importé. Importez le fichier correspondant sur la page Import.`
    );
  }
  if (issues.length > 0) return issues;

  const sourceMapping = findMapping(rules, 'impayes', rule.sourceSheetName);
  const targetMapping = findMapping(rules, 'reglements', rule.targetSheetName);

  if (!sourceMapping) {
    issues.push(
      `Aucune correspondance de colonnes n'a encore été enregistrée pour « ${rule.sourceSheetName} ». Ouvrez la page Règles de colonnes : cette feuille doit y apparaître pour que la correspondance se sauvegarde automatiquement.`
    );
  } else {
    if (!sourceMapping.custcode) issues.push(`Le champ « Code client » n'est pas mappé pour « ${rule.sourceSheetName} ».`);
    if (!sourceMapping.refFacture)
      issues.push(`Le champ « Référence facture » n'est pas mappé pour « ${rule.sourceSheetName} ».`);
  }

  if (!targetMapping) {
    issues.push(
      `Aucune correspondance de colonnes n'a encore été enregistrée pour « ${rule.targetSheetName} ». Ouvrez la page Règles de colonnes : cette feuille doit y apparaître pour que la correspondance se sauvegarde automatiquement.`
    );
  } else {
    if (!targetMapping.custcode) issues.push(`Le champ « Code client » n'est pas mappé pour « ${rule.targetSheetName} ».`);
    if (!targetMapping.refFacture)
      issues.push(`Le champ « Référence facture » n'est pas mappé pour « ${rule.targetSheetName} ».`);
  }

  return issues;
}

function computeSummary(results: CorrectionRowResult[]): CorrectionOutcome['summary'] {
  return {
    total: results.length,
    remplacees: results.filter((r) => r.status === 'remplacee').length,
    inchangees: results.filter((r) => r.status === 'inchangee').length,
    conflits: results.filter((r) => r.status === 'conflit').length,
    nonTrouvees: results.filter((r) => r.status === 'non_trouvee').length
  };
}

/** Calcule, pour une règle de correction, le nouveau REF_FACT (et, si mappée
 *  des deux côtés, l'ÉCHÉANCE) de chaque ligne de la feuille cible
 *  (règlements) en le recherchant dans la feuille source (impayés) via le
 *  code client (CUSTCODE) commun aux deux feuilles.
 *
 *  - Si le code client n'existe pas côté source : "non_trouvee".
 *  - Si le code client existe côté source avec un seul REF_FACT : on
 *    l'utilise directement ("remplacee" ou "inchangee" selon le cas), et on
 *    reprend son échéance en même temps (l'opérateur change les deux à
 *    chaque période).
 *  - Si plusieurs REF_FACT différents existent pour ce client (plusieurs
 *    factures impayées en même temps), on tente de départager grâce au
 *    MONTANT ; si ça ne suffit pas, on remplace quand même en prenant la
 *    facture la plus récente rencontrée dans le fichier source, mais la
 *    ligne est marquée `ambiguous` pour que l'utilisateur puisse la relire
 *    et corriger si besoin (voir mergeManualOverrides). On ne bloque jamais
 *    le remplacement par défaut. */
export function computeCorrection(
  rule: CorrectionRule,
  impayesFiles: ParsedFile[],
  reglementFiles: ParsedFile[],
  rules: SheetRule[]
): CorrectionOutcome | null {
  const source = findFileAndSheet(impayesFiles, rule.sourceSheetName);
  const target = findFileAndSheet(reglementFiles, rule.targetSheetName);
  const sourceSheet = source?.sheet ?? null;
  const targetSheet = target?.sheet ?? null;
  const sourceMapping = findMapping(rules, 'impayes', rule.sourceSheetName);
  const targetMapping = findMapping(rules, 'reglements', rule.targetSheetName);

  if (!sourceSheet || !targetSheet || !sourceMapping || !targetMapping) return null;
  if (!sourceMapping.custcode || !sourceMapping.refFacture) return null;
  if (!targetMapping.custcode || !targetMapping.refFacture) return null;

  const echeanceMapped = Boolean(sourceMapping.echeance && targetMapping.echeance);

  const sourceByCustcode = new Map<string, SourceCandidate[]>();
  for (const row of sourceSheet.rows) {
    const custNorm = normalizeRef(row[sourceMapping.custcode]);
    if (!custNorm) continue;
    const refRaw = row[sourceMapping.refFacture];
    const refNorm = normalizeRef(refRaw);
    if (!refNorm) continue;
    const montant = sourceMapping.montant ? toNumber(row[sourceMapping.montant]) : null;
    const echeanceRaw = sourceMapping.echeance ? formatDateFr(row[sourceMapping.echeance]) || null : null;

    const list = sourceByCustcode.get(custNorm) ?? [];
    if (!list.some((c) => c.refNorm === refNorm)) {
      list.push({ refRaw: String(refRaw ?? refNorm), refNorm, montant, echeanceRaw });
    }
    sourceByCustcode.set(custNorm, list);
  }

  const results: CorrectionRowResult[] = [];

  targetSheet.rows.forEach((row, index) => {
    const custRaw = row[targetMapping.custcode as string];
    const custNorm = normalizeRef(custRaw);
    const refRaw = row[targetMapping.refFacture as string];
    const originalRef = String(refRaw ?? '');
    const originalNorm = normalizeRef(refRaw);
    const originalEcheance = echeanceMapped ? formatDateFr(row[targetMapping.echeance as string]) : undefined;
    const custcodeLabel = String(custRaw ?? custNorm);

    if (!custNorm) {
      results.push({ targetRowIndex: index, custcode: '', originalRef, newRef: null, status: 'non_trouvee' });
      return;
    }

    const candidates = sourceByCustcode.get(custNorm);
    if (!candidates || candidates.length === 0) {
      results.push({ targetRowIndex: index, custcode: custcodeLabel, originalRef, newRef: null, status: 'non_trouvee' });
      return;
    }

    const finalize = (
      candidate: SourceCandidate,
      matchedBy: CorrectionRowResult['matchedBy'],
      ambiguous: boolean
    ) => {
      results.push({
        targetRowIndex: index,
        custcode: custcodeLabel,
        originalRef,
        newRef: candidate.refRaw,
        originalEcheance,
        newEcheance: echeanceMapped ? candidate.echeanceRaw : undefined,
        status: candidate.refNorm === originalNorm ? 'inchangee' : 'remplacee',
        matchedBy,
        ambiguous,
        candidates:
          candidates.length > 1
            ? candidates.map((c) => ({ ref: c.refRaw, echeance: echeanceMapped ? c.echeanceRaw : null }))
            : undefined
      });
    };

    if (candidates.length === 1) {
      finalize(candidates[0], 'custcode', false);
      return;
    }

    // Plusieurs factures impayées différentes pour ce client : on tente de
    // départager avec le montant du règlement, s'il est disponible.
    const targetMontant = targetMapping.montant ? toNumber(row[targetMapping.montant]) : null;
    if (targetMontant !== null) {
      const montantMatches = candidates.filter(
        (c) => c.montant !== null && Math.abs(c.montant - targetMontant) < MONTANT_TOLERANCE
      );
      if (montantMatches.length === 1) {
        finalize(montantMatches[0], 'custcode+montant', false);
        return;
      }
    }

    // Toujours ambigu : on remplace quand même, en prenant la facture la plus
    // récente (dernière rencontrée dans le fichier source), et on marque la
    // ligne comme à vérifier plutôt que de bloquer le remplacement.
    finalize(candidates[candidates.length - 1], 'automatique', true);
  });

  return { rule, results, summary: computeSummary(results) };
}

/** Superpose des choix manuels (faits par l'utilisateur dans l'interface pour
 *  des lignes ambiguës) sur un résultat déjà calculé, sans relancer tout le
 *  calcul. `overrides` associe l'index de ligne cible à la référence facture
 *  choisie manuellement (ou `null` pour garder le résultat automatique).
 *  L'échéance associée à ce choix est reprise automatiquement depuis la
 *  liste de candidats de la ligne. */
export function mergeManualOverrides(
  outcome: CorrectionOutcome,
  overrides: Record<number, string | null>
): CorrectionOutcome {
  if (Object.keys(overrides).length === 0) return outcome;

  const results = outcome.results.map((r) => {
    if (!(r.targetRowIndex in overrides)) return r;
    const chosen = overrides[r.targetRowIndex];
    if (!chosen) return r; // pas de choix fait : on garde le résultat automatique
    const chosenNorm = normalizeRef(chosen);
    const originalNorm = normalizeRef(r.originalRef);
    const chosenCandidate = r.candidates?.find((c) => c.ref === chosen);
    return {
      ...r,
      newRef: chosen,
      newEcheance: chosenCandidate ? chosenCandidate.echeance : r.newEcheance,
      status: (chosenNorm === originalNorm ? 'inchangee' : 'remplacee') as CorrectionRowResult['status'],
      matchedBy: 'manuel' as const
    };
  });

  return { ...outcome, results, summary: computeSummary(results) };
}

/** Applique les remplacements calculés (REF_FACT et, si mappée, ÉCHÉANCE) à
 *  une copie des lignes de la feuille cible : seules les lignes au statut
 *  "remplacee" ou "inchangee" sont écrites (jamais les lignes en échec de
 *  recherche). */
export function applyCorrectionToRows(
  targetSheet: ParsedSheet,
  targetMapping: ColumnMapping,
  outcome: CorrectionOutcome
): ParsedSheet['rows'] {
  const refCol = targetMapping.refFacture as string;
  const echeanceCol = targetMapping.echeance;
  const rows = targetSheet.rows.map((row) => ({ ...row }));
  for (const result of outcome.results) {
    if (result.status !== 'remplacee' && result.status !== 'inchangee') continue;
    if (result.newRef !== null) {
      rows[result.targetRowIndex][refCol] = result.newRef;
    }
    if (echeanceCol && result.newEcheance) {
      rows[result.targetRowIndex][echeanceCol] = result.newEcheance;
    }
  }
  return rows;
}
