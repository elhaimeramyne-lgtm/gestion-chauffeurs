import type { ComparisonResult, ComparisonRow, CustomFieldDef, ParsedFile, SheetRule } from '../types';
import { normalizeRef, toNumber, toDateLabel } from './excel';
import { findSheetRule } from './rulesLookup';

interface SettledData {
  /** Références de facture trouvées côté règlements. */
  refs: Set<string>;
  /** Pour chaque champ personnalisé utilisé comme clé de rapprochement,
   *  l'ensemble des valeurs normalisées trouvées côté règlements. */
  customValues: Map<string, Set<string>>;
}

/** Construit l'ensemble des références de facture (et, le cas échéant, des
 *  valeurs de champs personnalisés utilisés comme clé) trouvées dans les
 *  fichiers de règlement (paiements reçus), en s'appuyant sur les règles de
 *  colonnes configurées par l'utilisateur pour chaque feuille. */
function buildSettledData(
  reglementFiles: ParsedFile[],
  rules: SheetRule[],
  matchKeyFields: CustomFieldDef[]
): SettledData {
  const refs = new Set<string>();
  const customValues = new Map<string, Set<string>>(matchKeyFields.map((f) => [f.id, new Set<string>()]));

  for (const file of reglementFiles) {
    for (const sheet of file.sheets) {
      const rule = findSheetRule(rules, file.role, sheet.sheetName);
      const refCol = rule?.mapping.refFacture;
      const customCols = rule?.mapping.custom ?? {};

      for (const row of sheet.rows) {
        if (refCol) {
          const ref = normalizeRef(row[refCol]);
          if (ref) refs.add(ref);
        }
        for (const field of matchKeyFields) {
          const col = customCols[field.id];
          if (!col) continue;
          const value = normalizeRef(row[col]);
          if (value) customValues.get(field.id)?.add(value);
        }
      }
    }
  }

  return { refs, customValues };
}

/** Compare les factures impayées aux règlements reçus et produit, pour chaque
 *  ligne d'impayé, un statut "réglée" (trouvée côté paiements, via la
 *  référence facture ou via un champ personnalisé marqué comme clé de
 *  rapprochement) ou "toujours impayée" (absente des règlements). */
export function runComparison(
  impayesFiles: ParsedFile[],
  reglementFiles: ParsedFile[],
  rules: SheetRule[],
  customFields: CustomFieldDef[] = []
): ComparisonResult {
  const matchKeyFields = customFields.filter((f) => f.useAsMatchKey);
  const settled = buildSettledData(reglementFiles, rules, matchKeyFields);
  const rows: ComparisonRow[] = [];

  for (const file of impayesFiles) {
    for (const sheet of file.sheets) {
      const rule = findSheetRule(rules, file.role, sheet.sheetName);
      const mapping = rule?.mapping;
      if (!mapping?.refFacture) continue;

      for (const row of sheet.rows) {
        const rawRef = row[mapping.refFacture];
        const ref = normalizeRef(rawRef);
        if (!ref) continue;

        const custom: Record<string, string | null> = {};
        for (const field of customFields) {
          const col = mapping.custom[field.id];
          custom[field.id] = col ? String(row[col] ?? '') || null : null;
        }

        let isSettled = settled.refs.has(ref);
        let matchedByFieldId: string | undefined;
        if (!isSettled) {
          for (const field of matchKeyFields) {
            const value = custom[field.id] ? normalizeRef(custom[field.id]) : '';
            if (value && settled.customValues.get(field.id)?.has(value)) {
              isSettled = true;
              matchedByFieldId = field.id;
              break;
            }
          }
        }

        rows.push({
          refFacture: String(rawRef ?? ref),
          status: isSettled ? 'reglee' : 'impayee',
          montant: mapping.montant ? toNumber(row[mapping.montant]) : null,
          echeance: mapping.echeance ? toDateLabel(row[mapping.echeance]) : null,
          custcode: mapping.custcode ? String(row[mapping.custcode] ?? '') || null : null,
          nom: mapping.nom ? String(row[mapping.nom] ?? '') || null : null,
          produit: mapping.produit ? String(row[mapping.produit] ?? '') || null : null,
          custom,
          matchedByFieldId,
          sourceFile: file.fileName,
          sourceSheet: sheet.sheetName
        });
      }
    }
  }

  const reglees = rows.filter((r) => r.status === 'reglee');
  const impayees = rows.filter((r) => r.status === 'impayee');
  const sum = (list: ComparisonRow[]) => list.reduce((acc, r) => acc + (r.montant ?? 0), 0);

  return {
    rows,
    summary: {
      total: rows.length,
      reglees: reglees.length,
      impayees: impayees.length,
      montantTotal: sum(rows),
      montantRegle: sum(reglees),
      montantImpaye: sum(impayees),
      runAt: new Date().toISOString()
    }
  };
}
