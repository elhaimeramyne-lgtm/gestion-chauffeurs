import React, { createContext, useCallback, useContext, useEffect, useMemo, useState } from 'react';
import type {
  ComparisonResult,
  CorrectionRule,
  CustomFieldDef,
  Ligne,
  LigneInput,
  LigneFixe,
  LigneFixeInput,
  JournalEntry,
  JournalEntryInput,
  ParsedFile,
  ParsedRow,
  SheetRule
} from '../types';
import { api } from '../lib/api';
import { useAuth } from './AuthContext';

// ── Formes brutes renvoyées par l'API (voir server/src/schema) ─────────────
interface SheetRuleRow {
  id: number;
  role: string;
  sheetName: string;
  mapping: Record<string, unknown>;
}
interface CustomFieldRow {
  id: number;
  label: string;
  useAsMatchKey: boolean;
}
interface CorrectionRuleRow {
  id: number;
  sourceSheetName: string;
  targetSheetName: string;
}
interface LigneRow {
  id: number;
  categorie: string;
  typeForfait: string | null;
  typeMobile: string | null;
  icc: string | null;
  imei: string | null;
  affecte: string | null;
  /** Civilité : stockée en base depuis la mise à jour du schéma */
  civilite: string | null;
  personne: string | null;
  qualite: string | null;
  date: string | null;
  pin: string | null;
  puk: string | null;
  serviceId: number | null;
  consommationMensuelleDh: number | null;
  createdAt: string;
  updatedAt: string;
}
interface LigneFixeRow {
  id: number;
  nd: string;
  custcode: string | null;
  coordinationRegionale: string | null;
  delegation: string | null;
  domiciliation: string | null;
  personne: string | null;
  qualite: string | null;
  date: string | null;
  serviceId: number | null;
  consommationMensuelleDh: number | null;
  createdAt: string;
  updatedAt: string;
}
interface JournalEntryRow {
  id: number;
  direction: string | null;
  service: string;
  journal1: string | null;
  journal2: string | null;
  journal3: string | null;
  createdAt: string;
  updatedAt: string;
}

const toSheetRule = (r: SheetRuleRow): SheetRule => ({
  fileId: '',
  fileName: '',
  role: r.role as SheetRule['role'],
  sheetName: r.sheetName,
  mapping: r.mapping as unknown as SheetRule['mapping']
});
const toCustomField = (r: CustomFieldRow): CustomFieldDef => ({
  id: String(r.id),
  label: r.label,
  useAsMatchKey: r.useAsMatchKey
});
const toCorrectionRule = (r: CorrectionRuleRow): CorrectionRule => ({
  id: String(r.id),
  sourceSheetName: r.sourceSheetName,
  targetSheetName: r.targetSheetName
});
const toLigne = (r: LigneRow): Ligne => ({
  ...r,
  id: String(r.id),
  // Normalise la civilité : si absente ou invalide en base, on garde null
  // (le formulaire affiche null → valeur sauvegardée, pas de fallback Mme)
  civilite: (r.civilite as 'Mme' | 'Mlle' | 'M.' | null) ?? null
});
const toLigneFixe = (r: LigneFixeRow): LigneFixe => ({ ...r, id: String(r.id) });
const toJournalEntry = (r: JournalEntryRow): JournalEntry => ({ ...r, id: String(r.id) });

interface AppState {
  impayesFiles: ParsedFile[];
  reglementFiles: ParsedFile[];
  rules: SheetRule[];
  customFields: CustomFieldDef[];
  correctionRules: CorrectionRule[];
  comparisonResult: ComparisonResult | null;
  lignes: Ligne[];
  lignesFixes: LigneFixe[];
  journalEntries: JournalEntry[];
  /** true une fois les données partagées (règles, lignes, etc.) chargées
   *  depuis le serveur après connexion. */
  dataLoaded: boolean;
  addFile: (file: ParsedFile) => void;
  removeFile: (id: string) => void;
  upsertRule: (rule: SheetRule) => void;
  addCustomField: (label: string) => void;
  removeCustomField: (id: string) => void;
  toggleCustomFieldMatchKey: (id: string) => void;
  addCorrectionRule: (rule: Omit<CorrectionRule, 'id'>) => void;
  removeCorrectionRule: (id: string) => void;
  updateSheetRows: (fileId: string, sheetName: string, rows: ParsedRow[]) => void;
  setComparisonResult: (result: ComparisonResult | null) => void;
  addLigne: (input: LigneInput) => void;
  addLignes: (inputs: LigneInput[]) => void;
  updateLigne: (id: string, input: Partial<LigneInput>) => void;
  removeLigne: (id: string) => void;
  removeAllLignes: () => void;
  addLigneFixe: (input: LigneFixeInput) => void;
  addLignesFixes: (inputs: LigneFixeInput[]) => void;
  updateLigneFixe: (id: string, input: Partial<LigneFixeInput>) => void;
  removeLigneFixe: (id: string) => void;
  removeAllLignesFixes: () => void;
  addJournalEntry: (input: JournalEntryInput) => void;
  addJournalEntries: (inputs: JournalEntryInput[]) => void;
  updateJournalEntry: (id: string, input: Partial<JournalEntryInput>) => void;
  removeJournalEntry: (id: string) => void;
  transferLigne: (
    id: string,
    data: { nouvellePersonne: string; nouveauAffecte: string | null; nouvelleQualite: string | null }
  ) => void;
  resetAll: () => void;
}

const AppContext = createContext<AppState | null>(null);

export function AppProvider({ children }: { children: React.ReactNode }) {
  const { user, canEdit } = useAuth();

  const [impayesFiles, setImpayesFiles] = useState<ParsedFile[]>([]);
  const [reglementFiles, setReglementFiles] = useState<ParsedFile[]>([]);
  const [rules, setRules] = useState<SheetRule[]>([]);
  const [customFields, setCustomFields] = useState<CustomFieldDef[]>([]);
  const [correctionRules, setCorrectionRules] = useState<CorrectionRule[]>([]);
  const [comparisonResult, setComparisonResult] = useState<ComparisonResult | null>(null);
  const [lignes, setLignes] = useState<Ligne[]>([]);
  const [lignesFixes, setLignesFixes] = useState<LigneFixe[]>([]);
  const [journalEntries, setJournalEntries] = useState<JournalEntry[]>([]);
  const [dataLoaded, setDataLoaded] = useState(false);

  // Charge les données partagées depuis le serveur une fois l'utilisateur
  // connecté ; les remet à zéro à la déconnexion.
  useEffect(() => {
    // Un compte CHAUFFEUR n'a aucune permission métier (voir
    // lib/permissions.ts côté serveur) et n'utilise que le portail dédié :
    // inutile de déclencher ces appels, qui échoueraient systématiquement
    // en 403 en arrière-plan.
    if (!user || user.role === 'CHAUFFEUR') {
      setRules([]);
      setCustomFields([]);
      setCorrectionRules([]);
      setLignes([]);
      setLignesFixes([]);
      setJournalEntries([]);
      setDataLoaded(false);
      return;
    }

    let cancelled = false;
    setDataLoaded(false);

    Promise.all([
      api.get<{ rules: SheetRuleRow[] }>('/sheet-rules'),
      api.get<{ customFields: CustomFieldRow[] }>('/custom-fields'),
      api.get<{ correctionRules: CorrectionRuleRow[] }>('/correction-rules'),
      api.get<{ lignes: LigneRow[] }>('/lignes'),
      api.get<{ lignesFixes: LigneFixeRow[] }>('/lignes-fixes'),
      api.get<{ entries: JournalEntryRow[] }>('/journal-entries')
    ])
      .then(([rulesRes, customFieldsRes, correctionRulesRes, lignesRes, lignesFixesRes, journalRes]) => {
        if (cancelled) return;
        setRules(rulesRes.rules.map(toSheetRule));
        setCustomFields(customFieldsRes.customFields.map(toCustomField));
        setCorrectionRules(correctionRulesRes.correctionRules.map(toCorrectionRule));
        setLignes(lignesRes.lignes.map(toLigne));
        setLignesFixes(lignesFixesRes.lignesFixes.map(toLigneFixe));
        setJournalEntries(journalRes.entries.map(toJournalEntry));
      })
      .catch(() => {
        // La page reste utilisable même si le chargement échoue (ex: serveur
        // momentanément indisponible) ; les actions d'écriture échoueront
        // alors proprement avec un message d'erreur.
      })
      .finally(() => {
        if (!cancelled) setDataLoaded(true);
      });

    return () => {
      cancelled = true;
    };
  }, [user]);

  const addFile = useCallback((file: ParsedFile) => {
    if (file.role === 'impayes') {
      setImpayesFiles((prev) => [...prev, file]);
    } else {
      setReglementFiles((prev) => [...prev, file]);
    }
  }, []);

  const removeFile = useCallback((id: string) => {
    setImpayesFiles((prev) => prev.filter((f) => f.id !== id));
    setReglementFiles((prev) => prev.filter((f) => f.id !== id));
  }, []);

  const upsertRule = useCallback(
    (rule: SheetRule) => {
      // Mise à jour optimiste locale, immédiate, pour une UI réactive...
      setRules((prev) => {
        const idx = prev.findIndex((r) => r.role === rule.role && r.sheetName === rule.sheetName);
        if (idx === -1) return [...prev, rule];
        const next = [...prev];
        next[idx] = rule;
        return next;
      });
      // ...puis synchronisée avec le serveur si l'utilisateur a le droit
      // d'écrire (sinon la modification reste locale à cette session).
      if (!canEdit) return;
      api
        .put<{ rule: SheetRuleRow }>('/sheet-rules', { role: rule.role, sheetName: rule.sheetName, mapping: rule.mapping })
        .catch(() => {
          // Échec silencieux : l'utilisateur voit toujours son changement
          // localement : mieux vaut ça qu'une erreur bloquante pendant la
          // frappe. Une vraie notification pourrait être ajoutée ici.
        });
    },
    [canEdit]
  );

  const addCustomField = useCallback(
    (label: string) => {
      const trimmed = label.trim();
      if (!trimmed || !canEdit) return;
      api.post<{ customField: CustomFieldRow }>('/custom-fields', { label: trimmed }).then((res) => {
        setCustomFields((prev) => [...prev, toCustomField(res.customField)]);
      });
    },
    [canEdit]
  );

  const removeCustomField = useCallback(
    (id: string) => {
      setCustomFields((prev) => prev.filter((f) => f.id !== id));
      setRules((prev) =>
        prev.map((r) => {
          if (!(id in r.mapping.custom)) return r;
          const nextCustom = { ...r.mapping.custom };
          delete nextCustom[id];
          return { ...r, mapping: { ...r.mapping, custom: nextCustom } };
        })
      );
      if (!canEdit) return;
      api.delete(`/custom-fields/${id}`).catch(() => {});
    },
    [canEdit]
  );

  const toggleCustomFieldMatchKey = useCallback(
    (id: string) => {
      const field = customFields.find((f) => f.id === id);
      const nextValue = !field?.useAsMatchKey;
      setCustomFields((prev) => prev.map((f) => (f.id === id ? { ...f, useAsMatchKey: nextValue } : f)));
      if (!canEdit) return;
      api.patch(`/custom-fields/${id}`, { useAsMatchKey: nextValue }).catch(() => {});
    },
    [canEdit, customFields]
  );

  const addCorrectionRule = useCallback(
    (rule: Omit<CorrectionRule, 'id'>) => {
      if (!canEdit) return;
      api
        .post<{ correctionRule: CorrectionRuleRow }>('/correction-rules', rule)
        .then((res) => {
          setCorrectionRules((prev) => [...prev, toCorrectionRule(res.correctionRule)]);
        })
        .catch(() => {
          // Le plus probable : la règle existe déjà côté serveur.
        });
    },
    [canEdit]
  );

  const removeCorrectionRule = useCallback(
    (id: string) => {
      setCorrectionRules((prev) => prev.filter((r) => r.id !== id));
      if (!canEdit) return;
      api.delete(`/correction-rules/${id}`).catch(() => {});
    },
    [canEdit]
  );

  const updateSheetRows = useCallback((fileId: string, sheetName: string, rows: ParsedRow[]) => {
    const updateList = (list: ParsedFile[]) =>
      list.map((f) =>
        f.id !== fileId
          ? f
          : { ...f, sheets: f.sheets.map((s) => (s.sheetName === sheetName ? { ...s, rows } : s)) }
      );
    setImpayesFiles(updateList);
    setReglementFiles(updateList);
  }, []);

  const addLigne = useCallback(
    (input: LigneInput) => {
      if (!canEdit) return;
      api.post<{ ligne: LigneRow }>('/lignes', input).then((res) => {
        setLignes((prev) => [...prev, toLigne(res.ligne)]);
      });
    },
    [canEdit]
  );

  const addLignes = useCallback(
    (inputs: LigneInput[]) => {
      if (!canEdit || inputs.length === 0) return;
      api.post<{ lignes: LigneRow[] }>('/lignes/bulk', inputs).then((res) => {
        setLignes((prev) => [...prev, ...res.lignes.map(toLigne)]);
      });
    },
    [canEdit]
  );

  const updateLigne = useCallback(
    (id: string, input: Partial<LigneInput>) => {
      setLignes((prev) =>
        prev.map((l) => (l.id === id ? { ...l, ...input, updatedAt: new Date().toISOString() } : l))
      );
      if (!canEdit) return;
      api.patch(`/lignes/${id}`, input).catch(() => {});
    },
    [canEdit]
  );

  const removeLigne = useCallback(
    (id: string) => {
      setLignes((prev) => prev.filter((l) => l.id !== id));
      if (!canEdit) return;
      api.delete(`/lignes/${id}`).catch(() => {});
    },
    [canEdit]
  );

  const removeAllLignes = useCallback(() => {
    setLignes([]);
    if (!canEdit) return;
    api.delete('/lignes').catch(() => {});
  }, [canEdit]);

  const addLigneFixe = useCallback(
    (input: LigneFixeInput) => {
      if (!canEdit) return;
      api.post<{ ligneFixe: LigneFixeRow }>('/lignes-fixes', input).then((res) => {
        setLignesFixes((prev) => [...prev, toLigneFixe(res.ligneFixe)]);
      });
    },
    [canEdit]
  );

  const addLignesFixes = useCallback(
    (inputs: LigneFixeInput[]) => {
      if (!canEdit || inputs.length === 0) return;
      api.post<{ lignesFixes: LigneFixeRow[] }>('/lignes-fixes/bulk', inputs).then((res) => {
        setLignesFixes((prev) => [...prev, ...res.lignesFixes.map(toLigneFixe)]);
      });
    },
    [canEdit]
  );

  const updateLigneFixe = useCallback(
    (id: string, input: Partial<LigneFixeInput>) => {
      setLignesFixes((prev) =>
        prev.map((l) => (l.id === id ? { ...l, ...input, updatedAt: new Date().toISOString() } : l))
      );
      if (!canEdit) return;
      api.patch(`/lignes-fixes/${id}`, input).catch(() => {});
    },
    [canEdit]
  );

  const removeLigneFixe = useCallback(
    (id: string) => {
      setLignesFixes((prev) => prev.filter((l) => l.id !== id));
      if (!canEdit) return;
      api.delete(`/lignes-fixes/${id}`).catch(() => {});
    },
    [canEdit]
  );

  const removeAllLignesFixes = useCallback(() => {
    setLignesFixes([]);
    if (!canEdit) return;
    api.delete('/lignes-fixes').catch(() => {});
  }, [canEdit]);

  const addJournalEntry = useCallback(
    (input: JournalEntryInput) => {
      if (!canEdit) return;
      api.post<{ entry: JournalEntryRow }>('/journal-entries', input).then((res) => {
        setJournalEntries((prev) => [...prev, toJournalEntry(res.entry)]);
      });
    },
    [canEdit]
  );

  const addJournalEntries = useCallback(
    (inputs: JournalEntryInput[]) => {
      if (!canEdit || inputs.length === 0) return;
      api.post<{ entries: JournalEntryRow[] }>('/journal-entries/bulk', inputs).then((res) => {
        setJournalEntries((prev) => [...prev, ...res.entries.map(toJournalEntry)]);
      });
    },
    [canEdit]
  );

  const updateJournalEntry = useCallback(
    (id: string, input: Partial<JournalEntryInput>) => {
      setJournalEntries((prev) =>
        prev.map((e) => (e.id === id ? { ...e, ...input, updatedAt: new Date().toISOString() } : e))
      );
      if (!canEdit) return;
      api.patch(`/journal-entries/${id}`, input).catch(() => {});
    },
    [canEdit]
  );

  const removeJournalEntry = useCallback(
    (id: string) => {
      setJournalEntries((prev) => prev.filter((e) => e.id !== id));
      if (!canEdit) return;
      api.delete(`/journal-entries/${id}`).catch(() => {});
    },
    [canEdit]
  );

  const transferLigne = useCallback(
    (
      id: string,
      data: { nouvellePersonne: string; civilite?: string | null; nouveauAffecte: string | null; nouvelleQualite: string | null }
    ) => {
      setLignes((prev) =>
        prev.map((l) =>
          l.id === id
            ? {
                ...l,
                personne: data.nouvellePersonne,
                civilite: (data.civilite as 'Mme' | 'Mlle' | 'M.' | null) ?? l.civilite,
                affecte: data.nouveauAffecte ?? l.affecte,
                qualite: data.nouvelleQualite ?? l.qualite,
                updatedAt: new Date().toISOString()
              }
            : l
        )
      );
      if (!canEdit) return;
      api.post(`/lignes/${id}/transfer`, data).catch(() => {});
    },
    [canEdit]
  );

  const resetAll = useCallback(() => {
    setImpayesFiles([]);
    setReglementFiles([]);
    setComparisonResult(null);
  }, []);

  const value = useMemo<AppState>(
    () => ({
      impayesFiles,
      reglementFiles,
      rules,
      customFields,
      correctionRules,
      comparisonResult,
      lignes,
      lignesFixes,
      journalEntries,
      dataLoaded,
      addFile,
      removeFile,
      upsertRule,
      addCustomField,
      removeCustomField,
      toggleCustomFieldMatchKey,
      addCorrectionRule,
      removeCorrectionRule,
      updateSheetRows,
      setComparisonResult,
      addLigne,
      addLignes,
      updateLigne,
      removeLigne,
      removeAllLignes,
      transferLigne,
      addLigneFixe,
      addLignesFixes,
      updateLigneFixe,
      removeLigneFixe,
      removeAllLignesFixes,
      addJournalEntry,
      addJournalEntries,
      updateJournalEntry,
      removeJournalEntry,
      resetAll
    }),
    [
      impayesFiles,
      reglementFiles,
      rules,
      customFields,
      correctionRules,
      comparisonResult,
      lignes,
      lignesFixes,
      journalEntries,
      dataLoaded,
      addFile,
      removeFile,
      upsertRule,
      addCustomField,
      removeCustomField,
      toggleCustomFieldMatchKey,
      addCorrectionRule,
      removeCorrectionRule,
      updateSheetRows,
      addLigne,
      addLignes,
      updateLigne,
      removeLigne,
      removeAllLignes,
      transferLigne,
      addLigneFixe,
      addLignesFixes,
      updateLigneFixe,
      removeLigneFixe,
      removeAllLignesFixes,
      addJournalEntry,
      addJournalEntries,
      updateJournalEntry,
      removeJournalEntry,
      resetAll
    ]
  );

  return <AppContext.Provider value={value}>{children}</AppContext.Provider>;
}

export function useApp(): AppState {
  const ctx = useContext(AppContext);
  if (!ctx) throw new Error('useApp doit être utilisé à l’intérieur de <AppProvider>');
  return ctx;
}
