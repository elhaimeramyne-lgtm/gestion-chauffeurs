import { useMemo, useRef, useState } from 'react';
import { FileUp, Plus, Minus, RefreshCw, AlertTriangle, GitCompareArrows } from 'lucide-react';
import { PageHeader, Card, Button, StatCard, Badge } from '../components/ui/Kit';
import { parseGenericExcel, computeDiff, guessKeyColumn, type GenericSheet, type DiffResult } from '../lib/excelDiff';
import { useTranslation } from 'react-i18next';

function FileSlot({
  label, sheet, onPick
}: {
  label: string;
  sheet: GenericSheet | null;
  onPick: (file: File) => void;
}) {
  const inputRef = useRef<HTMLInputElement>(null);
  return (
    <Card className="p-5">
      <p className="text-xs font-mono uppercase tracking-widest mb-3" style={{ color: 'var(--text-ter)' }}>{label}</p>
      <button
        onClick={() => inputRef.current?.click()}
        className="focus-ring w-full flex flex-col items-center justify-center gap-2 rounded-xl py-8 transition-colors"
        style={{ border: '1.5px dashed var(--border-md)', background: 'var(--bg)' }}
      >
        <FileUp size={20} style={{ color: 'var(--accent)' }} />
        <span className="text-sm" style={{ color: 'var(--text-sec)' }}>
          {sheet ? `${sheet.rows.length} ligne(s) chargée(s)` : 'Choisir un fichier Excel'}
        </span>
      </button>
      <input
        ref={inputRef}
        type="file"
        accept=".xlsx,.xls"
        className="hidden"
        onChange={(e) => {
          const file = e.target.files?.[0];
          if (file) onPick(file);
          e.target.value = '';
        }}
      />
    </Card>
  );
}

export default function DiffPage() {
  const { t } = useTranslation();
  const [sheetA, setSheetA] = useState<GenericSheet | null>(null);
  const [sheetB, setSheetB] = useState<GenericSheet | null>(null);
  const [keyColumn, setKeyColumn] = useState('');
  const [result, setResult] = useState<DiffResult | null>(null);
  const [loading, setLoading] = useState(false);
  const [tab, setTab] = useState<'added' | 'removed' | 'changed' | 'errors'>('added');

  const commonHeaders = useMemo(() => {
    if (!sheetA || !sheetB) return [];
    return sheetA.headers.filter((h) => sheetB.headers.includes(h));
  }, [sheetA, sheetB]);

  const handlePick = async (slot: 'A' | 'B', file: File) => {
    setLoading(true);
    setResult(null);
    try {
      const parsed = await parseGenericExcel(file);
      if (slot === 'A') setSheetA(parsed);
      else setSheetB(parsed);

      const other = slot === 'A' ? sheetB : sheetA;
      if (other) {
        const guess = guessKeyColumn(
          slot === 'A' ? parsed.headers : sheetA!.headers,
          slot === 'A' ? sheetB!.headers : parsed.headers
        );
        if (guess) setKeyColumn(guess);
      }
    } finally {
      setLoading(false);
    }
  };

  const handleCompare = () => {
    if (!sheetA || !sheetB || !keyColumn) return;
    setResult(computeDiff(sheetA, sheetB, keyColumn));
    setTab('added');
  };

  return (
    <div>
      <PageHeader
        eyebrow={t('diffPage.eyebrow', 'Étape 4')}
        title={t('diffPage.title')}
        description={t('diffPage.description')}
      />

      <div className="grid sm:grid-cols-2 gap-4 mb-5">
        <FileSlot label="Fichier A (ancien)" sheet={sheetA} onPick={(f) => handlePick('A', f)} />
        <FileSlot label="Fichier B (nouveau)" sheet={sheetB} onPick={(f) => handlePick('B', f)} />
      </div>

      {sheetA && sheetB && (
        <Card className="p-5 mb-6 flex flex-wrap items-end gap-4">
          <label className="block text-xs" style={{ color: 'var(--text-ter)' }}>
            <span className="block mb-1.5 uppercase tracking-widest font-mono">Colonne-clé (identifiant unique)</span>
            <select
              value={keyColumn}
              onChange={(e) => setKeyColumn(e.target.value)}
              className="focus-ring rounded-lg border px-3 py-2 text-sm"
              style={{ borderColor: 'var(--border)', background: 'var(--card)', color: 'var(--text-pri)', minWidth: 220 }}
            >
              <option value="">— Choisir —</option>
              {commonHeaders.map((h) => (
                <option key={h} value={h}>{h}</option>
              ))}
            </select>
          </label>
          <Button onClick={handleCompare} disabled={!keyColumn || loading}>
            <GitCompareArrows size={15} /> Comparer
          </Button>
          {commonHeaders.length === 0 && (
            <p className="text-xs text-signal-roseDark">Ces deux fichiers n'ont aucune colonne en commun.</p>
          )}
        </Card>
      )}

      {result && (
        <>
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 mb-6 stagger">
            <StatCard label="Nouvelles lignes" value={`+${result.added.length}`} tone="good" icon={<Plus size={15} />} />
            <StatCard label="Lignes supprimées" value={`-${result.removed.length}`} tone="bad" icon={<Minus size={15} />} />
            <StatCard label="Montants différents" value={String(result.changed.filter((c) => c.montantChanged).length)} icon={<RefreshCw size={15} />} />
            <StatCard label="Erreurs (clé manquante)" value={String(result.errors.length)} tone={result.errors.length > 0 ? 'bad' : 'good'} icon={<AlertTriangle size={15} />} />
          </div>

          <div className="flex gap-1 mb-4 border-b" style={{ borderColor: 'var(--border)' }}>
            {([
              ['added', `Ajoutées (${result.added.length})`],
              ['removed', `Supprimées (${result.removed.length})`],
              ['changed', `Modifiées (${result.changed.length})`],
              ['errors', `Erreurs (${result.errors.length})`]
            ] as const).map(([id, label]) => (
              <button
                key={id}
                onClick={() => setTab(id)}
                className="focus-ring px-3 py-2 text-sm font-medium border-b-2 -mb-px transition-colors"
                style={{
                  borderColor: tab === id ? 'var(--accent)' : 'transparent',
                  color: tab === id ? 'var(--text-pri)' : 'var(--text-ter)'
                }}
              >
                {label}
              </button>
            ))}
          </div>

          <Card className="overflow-hidden">
            {tab === 'added' && (
              <SimpleTable rows={result.added} headers={sheetB?.headers ?? []} emptyLabel="Aucune ligne ajoutée." />
            )}
            {tab === 'removed' && (
              <SimpleTable rows={result.removed} headers={sheetA?.headers ?? []} emptyLabel="Aucune ligne supprimée." />
            )}
            {tab === 'changed' && (
              <ChangedTable rows={result.changed} keyColumn={result.keyColumn} />
            )}
            {tab === 'errors' && (
              <div>
                {result.errors.length === 0 ? (
                  <p className="px-4 py-8 text-center text-sm" style={{ color: 'var(--text-ter)' }}>Aucune erreur détectée.</p>
                ) : (
                  <table className="w-full text-sm">
                    <thead>
                      <tr className="bg-ink-50 text-left text-xs text-ink-500 uppercase tracking-wide">
                        <th className="px-4 py-3">Fichier</th>
                        <th className="px-4 py-3">Raison</th>
                        <th className="px-4 py-3">Contenu de la ligne</th>
                      </tr>
                    </thead>
                    <tbody>
                      {result.errors.map((e, i) => (
                        <tr key={i} className="border-t border-ink-50">
                          <td className="px-4 py-2.5"><Badge tone="bad">{e.source === 'A' ? 'Fichier A' : 'Fichier B'}</Badge></td>
                          <td className="px-4 py-2.5 text-ink-600">{e.reason}</td>
                          <td className="px-4 py-2.5 text-ink-500 text-xs font-mono truncate max-w-md">
                            {Object.values(e.row).filter(Boolean).join(' · ')}
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                )}
              </div>
            )}
          </Card>
        </>
      )}
    </div>
  );
}

function SimpleTable({ rows, headers, emptyLabel }: { rows: Record<string, string>[]; headers: string[]; emptyLabel: string }) {
  if (rows.length === 0) {
    return <p className="px-4 py-8 text-center text-sm" style={{ color: 'var(--text-ter)' }}>{emptyLabel}</p>;
  }
  const visibleHeaders = headers.slice(0, 6);
  return (
    <div className="overflow-x-auto">
      <table className="w-full text-sm">
        <thead>
          <tr className="bg-ink-50 text-left text-xs text-ink-500 uppercase tracking-wide">
            {visibleHeaders.map((h) => <th key={h} className="px-4 py-3 whitespace-nowrap">{h}</th>)}
          </tr>
        </thead>
        <tbody>
          {rows.slice(0, 200).map((r, i) => (
            <tr key={i} className="border-t border-ink-50">
              {visibleHeaders.map((h) => <td key={h} className="px-4 py-2.5 text-ink-700 whitespace-nowrap">{r[h] || '—'}</td>)}
            </tr>
          ))}
        </tbody>
      </table>
      {rows.length > 200 && (
        <p className="px-4 py-2 text-xs text-ink-400">Affichage limité aux 200 premières lignes ({rows.length} au total).</p>
      )}
    </div>
  );
}

function ChangedTable({ rows, keyColumn }: { rows: import('../lib/excelDiff').DiffChangedRow[]; keyColumn: string }) {
  if (rows.length === 0) {
    return <p className="px-4 py-8 text-center text-sm" style={{ color: 'var(--text-ter)' }}>Aucune ligne modifiée.</p>;
  }
  return (
    <div className="overflow-x-auto">
      <table className="w-full text-sm">
        <thead>
          <tr className="bg-ink-50 text-left text-xs text-ink-500 uppercase tracking-wide">
            <th className="px-4 py-3">{keyColumn}</th>
            <th className="px-4 py-3">Champs modifiés</th>
            <th className="px-4 py-3">Avant → Après</th>
          </tr>
        </thead>
        <tbody>
          {rows.slice(0, 200).map((r) => (
            <tr key={r.key} className="border-t border-ink-50">
              <td className="px-4 py-2.5 font-mono text-xs text-ink-800">{r.key}</td>
              <td className="px-4 py-2.5">
                <div className="flex flex-wrap gap-1">
                  {r.changedFields.map((f) => (
                    <Badge key={f} tone={r.montantChanged && f.toUpperCase().includes('MONT') ? 'bad' : 'default'}>{f}</Badge>
                  ))}
                </div>
              </td>
              <td className="px-4 py-2.5 text-xs text-ink-600">
                {r.changedFields.slice(0, 3).map((f) => (
                  <div key={f}>
                    <span className="text-ink-400">{f}:</span> {r.before[f] || '—'} <span className="text-ink-400">→</span> {r.after[f] || '—'}
                  </div>
                ))}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
      {rows.length > 200 && (
        <p className="px-4 py-2 text-xs text-ink-400">Affichage limité aux 200 premières lignes ({rows.length} au total).</p>
      )}
    </div>
  );
}
