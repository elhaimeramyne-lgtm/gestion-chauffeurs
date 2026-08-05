import { useMemo, useState } from 'react';
import type { ComparisonRow, CustomFieldDef, MatchStatus } from '../../types';
import { Badge } from '../ui/Kit';

const PAGE_SIZE = 25;

export default function ResultsTable({
  rows,
  customFields = []
}: {
  rows: ComparisonRow[];
  customFields?: CustomFieldDef[];
}) {
  const [filter, setFilter] = useState<MatchStatus | 'all'>('all');
  const [search, setSearch] = useState('');
  const [page, setPage] = useState(0);

  const filtered = useMemo(() => {
    let list = rows;
    if (filter !== 'all') list = list.filter((r) => r.status === filter);
    if (search.trim()) {
      const q = search.trim().toUpperCase();
      list = list.filter(
        (r) => r.refFacture.toUpperCase().includes(q) || (r.nom ?? '').toUpperCase().includes(q)
      );
    }
    return list;
  }, [rows, filter, search]);

  const pageCount = Math.max(1, Math.ceil(filtered.length / PAGE_SIZE));
  const currentPage = Math.min(page, pageCount - 1);
  const visible = filtered.slice(currentPage * PAGE_SIZE, currentPage * PAGE_SIZE + PAGE_SIZE);

  return (
    <div>
      <div className="flex flex-wrap items-center gap-2 mb-4">
        <div className="flex gap-1.5">
          {(
            [
              ['all', 'Toutes'],
              ['reglee', 'Réglées'],
              ['impayee', 'Toujours impayées']
            ] as [MatchStatus | 'all', string][]
          ).map(([value, label]) => (
            <button
              key={value}
              onClick={() => {
                setFilter(value);
                setPage(0);
              }}
              className={`focus-ring px-3 py-1.5 rounded-full text-xs font-medium transition-colors ${
                filter === value ? 'bg-ink-950 text-white' : 'bg-ink-100 text-ink-600 hover:bg-ink-200'
              }`}
            >
              {label}
            </button>
          ))}
        </div>
        <input
          value={search}
          onChange={(e) => {
            setSearch(e.target.value);
            setPage(0);
          }}
          placeholder="Rechercher une référence ou un nom…"
          className="focus-ring ml-auto w-full sm:w-64 rounded-lg border border-ink-200 px-3 py-1.5 text-sm"
        />
      </div>

      <div className="overflow-x-auto rounded-xl border border-ink-100">
        <table className="w-full text-sm">
          <thead>
            <tr className="bg-ink-50 text-left text-xs text-ink-500 uppercase tracking-wide">
              <th className="px-3 py-2.5">Référence</th>
              <th className="px-3 py-2.5">Statut</th>
              <th className="px-3 py-2.5">Montant</th>
              <th className="px-3 py-2.5">Échéance</th>
              <th className="px-3 py-2.5">Client</th>
              {customFields.map((cf) => (
                <th key={cf.id} className="px-3 py-2.5">
                  {cf.label}
                </th>
              ))}
              <th className="px-3 py-2.5">Source</th>
            </tr>
          </thead>
          <tbody>
            {visible.map((r, i) => (
              <tr
                key={`${r.refFacture}-${i}`}
                className={`border-t border-ink-50 ${
                  r.status === 'reglee' ? 'bg-signal-moss/[0.04]' : 'bg-signal-rose/[0.04]'
                }`}
              >
                <td className="px-3 py-2 font-mono text-xs text-ink-700 whitespace-nowrap">{r.refFacture}</td>
                <td className="px-3 py-2">
                  <Badge tone={r.status === 'reglee' ? 'good' : 'bad'}>
                    {r.status === 'reglee' ? 'Réglée' : 'Toujours impayée'}
                  </Badge>
                  {r.matchedByFieldId && (
                    <div className="text-[10px] text-ink-400 mt-0.5">
                      via {customFields.find((cf) => cf.id === r.matchedByFieldId)?.label ?? 'champ personnalisé'}
                    </div>
                  )}
                </td>
                <td className="px-3 py-2 text-ink-700 whitespace-nowrap">
                  {r.montant !== null ? `${r.montant.toLocaleString('fr-FR')} DH` : '—'}
                </td>
                <td className="px-3 py-2 text-ink-700 whitespace-nowrap">{r.echeance ?? '—'}</td>
                <td className="px-3 py-2 text-ink-700 max-w-[220px] truncate">{r.nom ?? '—'}</td>
                {customFields.map((cf) => (
                  <td key={cf.id} className="px-3 py-2 text-ink-700 whitespace-nowrap">
                    {r.custom?.[cf.id] ?? '—'}
                  </td>
                ))}
                <td className="px-3 py-2 text-ink-400 text-xs whitespace-nowrap">{r.sourceSheet}</td>
              </tr>
            ))}
            {visible.length === 0 && (
              <tr>
                <td colSpan={6 + customFields.length} className="px-3 py-8 text-center text-ink-400 text-sm">
                  Aucun résultat pour ces filtres.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>

      {pageCount > 1 && (
        <div className="flex items-center justify-between mt-3 text-xs text-ink-500">
          <span>
            {filtered.length} ligne(s) · page {currentPage + 1} / {pageCount}
          </span>
          <div className="flex gap-1.5">
            <button
              disabled={currentPage === 0}
              onClick={() => setPage((p) => p - 1)}
              className="focus-ring px-2.5 py-1 rounded-lg border border-ink-200 disabled:opacity-40"
            >
              Précédent
            </button>
            <button
              disabled={currentPage >= pageCount - 1}
              onClick={() => setPage((p) => p + 1)}
              className="focus-ring px-2.5 py-1 rounded-lg border border-ink-200 disabled:opacity-40"
            >
              Suivant
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
