import { useMemo, useState } from 'react';
import { Trash2, Download, CheckCheck, AlertTriangle } from 'lucide-react';
import type { CorrectionRule, CorrectionStatus, ParsedFile, SheetRule } from '../../types';
import {
  computeCorrection,
  applyCorrectionToRows,
  diagnoseCorrectionRule,
  mergeManualOverrides
} from '../../lib/correction';
import { exportCorrectedFile, downloadBlob } from '../../lib/export';
import { findSheetRule } from '../../lib/rulesLookup';
import { Card, Badge, Button } from '../ui/Kit';

const STATUS_LABELS: Record<CorrectionStatus, string> = {
  remplacee: 'Remplacée',
  inchangee: 'Déjà correcte',
  conflit: 'Conflit',
  non_trouvee: 'Code client introuvable'
};

const STATUS_TONE: Record<CorrectionStatus, 'good' | 'bad' | 'default'> = {
  remplacee: 'good',
  inchangee: 'default',
  conflit: 'bad',
  non_trouvee: 'bad'
};

const MATCHED_BY_LABELS: Record<string, string> = {
  custcode: 'via code client',
  'custcode+montant': 'via code client + montant',
  automatique: 'choix auto (plusieurs factures)',
  manuel: 'choisi manuellement'
};

export default function CorrectionRuleCard({
  rule,
  impayesFiles,
  reglementFiles,
  rules,
  onRemove,
  onApplyRows,
  canEdit
}: {
  rule: CorrectionRule;
  impayesFiles: ParsedFile[];
  reglementFiles: ParsedFile[];
  rules: SheetRule[];
  onRemove: (id: string) => void;
  onApplyRows: (fileId: string, sheetName: string, rows: ReturnType<typeof applyCorrectionToRows>) => void;
  canEdit: boolean;
}) {
  const [filter, setFilter] = useState<CorrectionStatus | 'all' | 'ambiguous'>('all');
  const [isExporting, setIsExporting] = useState(false);
  const [applied, setApplied] = useState(false);
  const [manualOverrides, setManualOverrides] = useState<Record<number, string | null>>({});

  const rawOutcome = useMemo(
    () => computeCorrection(rule, impayesFiles, reglementFiles, rules),
    [rule, impayesFiles, reglementFiles, rules]
  );

  const outcome = useMemo(
    () => (rawOutcome ? mergeManualOverrides(rawOutcome, manualOverrides) : null),
    [rawOutcome, manualOverrides]
  );

  const sourceFile = impayesFiles.find((f) => f.sheets.some((s) => s.sheetName === rule.sourceSheetName));
  const targetFile = reglementFiles.find((f) => f.sheets.some((s) => s.sheetName === rule.targetSheetName));

  if (!outcome) {
    const issues = diagnoseCorrectionRule(rule, impayesFiles, reglementFiles, rules);
    return (
      <Card className="p-5">
        <div className="flex items-center justify-between gap-3 mb-2">
          <p className="text-sm font-semibold text-ink-800">
            {rule.sourceSheetName} → {rule.targetSheetName}
          </p>
          {canEdit && (
            <button
              onClick={() => onRemove(rule.id)}
              className="focus-ring text-ink-400 hover:text-signal-rose transition-colors"
              title="Supprimer cette règle"
            >
              <Trash2 size={14} />
            </button>
          )}
        </div>
        <div className="text-sm text-signal-roseDark bg-signal-rose/10 rounded-lg px-4 py-3">
          <p className="font-medium mb-1.5">Cette règle ne peut pas encore être calculée :</p>
          <ul className="list-disc list-inside space-y-1">
            {issues.length > 0 ? (
              issues.map((issue, i) => <li key={i}>{issue}</li>)
            ) : (
              <li>Cause inconnue — vérifiez la page Règles de colonnes.</li>
            )}
          </ul>
        </div>
      </Card>
    );
  }

  const hasEcheance = outcome.results.some((r) => r.originalEcheance !== undefined);
  const ambiguousCount = outcome.results.filter((r) => r.ambiguous && r.matchedBy !== 'manuel').length;

  const filteredResults = outcome.results.filter((r) => {
    if (filter === 'all') return true;
    if (filter === 'ambiguous') return r.ambiguous;
    return r.status === filter;
  });

  const handleApply = () => {
    const targetMapping = findSheetRule(rules, 'reglements', rule.targetSheetName)?.mapping;
    const targetSheet = targetFile?.sheets.find((s) => s.sheetName === rule.targetSheetName);
    if (!targetMapping || !targetSheet || !targetFile) return;
    const rows = applyCorrectionToRows(targetSheet, targetMapping, outcome);
    onApplyRows(targetFile.id, rule.targetSheetName, rows);
    setApplied(true);
  };

  const handleExport = async () => {
    if (!targetFile) return;
    setIsExporting(true);
    try {
      const blob = await exportCorrectedFile(targetFile, [outcome], rules);
      downloadBlob(blob, `${targetFile.fileName.replace(/\.xlsx?$/i, '')}-corrige-${Date.now()}.xlsx`);
    } finally {
      setIsExporting(false);
    }
  };

  const setOverride = (targetRowIndex: number, value: string) => {
    setManualOverrides((prev) => ({ ...prev, [targetRowIndex]: value || null }));
  };

  return (
    <Card className="p-5">
      <div className="flex flex-wrap items-center justify-between gap-3 mb-1">
        <div>
          <p className="text-sm font-semibold text-ink-800">
            {sourceFile?.fileName ?? rule.sourceSheetName} · {rule.sourceSheetName} <span className="text-ink-300">→</span>{' '}
            {targetFile?.fileName ?? rule.targetSheetName} · {rule.targetSheetName}
          </p>
          <p className="text-xs text-ink-400 mt-0.5">
            Correspondance sur le code client (CUSTCODE){hasEcheance ? ', REF_FACT et ÉCHÉANCE mis à jour ensemble' : ''}
            ; le montant départage si plusieurs factures existent, sinon la plus récente est prise
            automatiquement
          </p>
        </div>
        {canEdit && (
          <button
            onClick={() => onRemove(rule.id)}
            className="focus-ring text-ink-400 hover:text-signal-rose transition-colors"
            title="Supprimer cette règle"
          >
            <Trash2 size={14} />
          </button>
        )}
      </div>

      <div className="flex flex-wrap gap-1.5 my-4">
        {(
          [
            ['all', `Toutes (${outcome.summary.total})`],
            ['remplacee', `Remplacées (${outcome.summary.remplacees})`],
            ['inchangee', `Déjà correctes (${outcome.summary.inchangees})`],
            ['ambiguous', `À vérifier (${ambiguousCount})`],
            ['non_trouvee', `Introuvables (${outcome.summary.nonTrouvees})`]
          ] as [CorrectionStatus | 'all' | 'ambiguous', string][]
        ).map(([value, label]) => (
          <button
            key={value}
            onClick={() => setFilter(value)}
            className={`focus-ring px-3 py-1.5 rounded-full text-xs font-medium transition-colors ${
              filter === value ? 'bg-ink-950 text-white' : 'bg-ink-100 text-ink-600 hover:bg-ink-200'
            }`}
          >
            {label}
          </button>
        ))}
      </div>

      {ambiguousCount > 0 && (
        <p className="flex items-start gap-2 text-xs text-signal-amberDark bg-signal-amber/10 rounded-lg px-3 py-2 mb-3">
          <AlertTriangle size={14} className="shrink-0 mt-0.5" />
          {ambiguousCount} ligne(s) ont un code client associé à plusieurs factures impayées : le
          remplacement a été fait avec la plus récente trouvée, mais vous pouvez changer le choix
          dans le menu déroulant de la colonne « Nouveau REF_FACT » (filtre « À vérifier »).
        </p>
      )}

      <div className="overflow-x-auto rounded-xl border border-ink-100 max-h-96 overflow-y-auto">
        <table className="w-full text-sm">
          <thead className="sticky top-0 bg-ink-50">
            <tr className="text-left text-xs text-ink-500 uppercase tracking-wide">
              <th className="px-3 py-2.5">Code client</th>
              <th className="px-3 py-2.5">REF_FACT actuel</th>
              <th className="px-3 py-2.5">Nouveau REF_FACT</th>
              {hasEcheance && <th className="px-3 py-2.5">Échéance</th>}
              <th className="px-3 py-2.5">Statut</th>
            </tr>
          </thead>
          <tbody>
            {filteredResults.slice(0, 500).map((r) => (
              <tr key={r.targetRowIndex} className="border-t border-ink-50">
                <td className="px-3 py-2 font-mono text-xs text-ink-700 whitespace-nowrap">
                  {r.custcode || '—'}
                </td>
                <td className="px-3 py-2 font-mono text-xs text-ink-700 whitespace-nowrap">
                  {r.originalRef || '—'}
                </td>
                <td className="px-3 py-2 font-mono text-xs text-ink-700 whitespace-nowrap">
                  {r.ambiguous && r.candidates ? (
                    <select
                      value={manualOverrides[r.targetRowIndex] ?? r.newRef ?? ''}
                      onChange={(e) => setOverride(r.targetRowIndex, e.target.value)}
                      className="focus-ring rounded-lg border border-signal-amber/50 bg-white px-2 py-1 text-xs text-ink-800"
                    >
                      {r.candidates.map((c) => (
                        <option key={c.ref} value={c.ref}>
                          {c.ref}
                          {c.echeance ? ` (${c.echeance})` : ''}
                        </option>
                      ))}
                    </select>
                  ) : (
                    (r.newRef ?? '—')
                  )}
                </td>
                {hasEcheance && (
                  <td className="px-3 py-2 text-xs text-ink-700 whitespace-nowrap">
                    {r.newEcheance && r.newEcheance !== r.originalEcheance ? (
                      <span>
                        <span className="text-ink-400 line-through mr-1">{r.originalEcheance || '—'}</span>
                        <span className="font-medium">{r.newEcheance}</span>
                      </span>
                    ) : (
                      r.originalEcheance || '—'
                    )}
                  </td>
                )}
                <td className="px-3 py-2">
                  <Badge tone={STATUS_TONE[r.status]}>{STATUS_LABELS[r.status]}</Badge>
                  {r.matchedBy && (r.status === 'remplacee' || r.status === 'inchangee') && (
                    <div className="text-[10px] text-ink-400 mt-0.5">{MATCHED_BY_LABELS[r.matchedBy]}</div>
                  )}
                </td>
              </tr>
            ))}
            {filteredResults.length === 0 && (
              <tr>
                <td colSpan={hasEcheance ? 5 : 4} className="px-3 py-8 text-center text-ink-400 text-sm">
                  Aucune ligne pour ce filtre.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
      {filteredResults.length > 500 && (
        <p className="text-xs text-ink-400 mt-2">
          Aperçu limité aux 500 premières lignes ({filteredResults.length} au total pour ce filtre).
          L'export contient toutes les lignes.
        </p>
      )}

      <div className="flex flex-wrap gap-2 mt-4">
        <Button variant="secondary" onClick={handleExport} disabled={isExporting || !targetFile}>
          <Download size={15} />
          {isExporting ? 'Export…' : 'Télécharger le fichier corrigé'}
        </Button>
        <Button variant={applied ? 'ghost' : 'primary'} onClick={handleApply} disabled={outcome.summary.remplacees === 0}>
          <CheckCheck size={15} />
          {applied ? 'Appliqué à cette session' : `Appliquer dans l'application (${outcome.summary.remplacees})`}
        </Button>
      </div>
    </Card>
  );
}
