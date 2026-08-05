import { useMemo, useRef, useState } from 'react';
import { Plus, Upload, FileSpreadsheet, Trash2, Pencil, ShieldAlert, History } from 'lucide-react';
import { useApp } from '../context/AppContext';
import { useAuth } from '../context/AuthContext';
import { useOrg } from '../context/OrgContext';
import type { LigneFixe, LigneFixeInput } from '../types';
import { useTranslation } from 'react-i18next';
import { PageHeader, Button, Badge, StatCard, EmptyState } from '../components/ui/Kit';
import LigneFixeFormModal from '../components/lignes/LigneFixeFormModal';
import ConfirmModal from '../components/lignes/ConfirmModal';
import HistoryModal from '../components/lignes/HistoryModal';
import { parseLignesFixesWorkbook } from '../lib/lignesFixesImport';
import { exportLignesFixesToExcel } from '../lib/lignesFixesExport';
import { detectDuplicates } from '../lib/duplicateDetection';
import DuplicateReviewModal from '../components/lignes/DuplicateReviewModal';

const ROWS_PER_PAGE = 25;

export default function LignesFixesPage() {
  const { t } = useTranslation();
  const { lignesFixes, addLigneFixe, addLignesFixes, updateLigneFixe, removeLigneFixe, removeAllLignesFixes } = useApp();
  const { canEdit, isAdmin } = useAuth();
  const { nodes } = useOrg();
  const serviceName = (id: number | null) => (id ? nodes.find((n) => n.id === id)?.name ?? '—' : '—');

  const [search, setSearch] = useState('');
  const [delegationFilter, setDelegationFilter] = useState('Toutes');
  const [page, setPage] = useState(1);

  const [formOpen, setFormOpen] = useState(false);
  const [editing, setEditing] = useState<LigneFixe | null>(null);
  const [deleteTarget, setDeleteTarget] = useState<LigneFixe | null>(null);
  const [deleteAllOpen, setDeleteAllOpen] = useState(false);
  const [historyTarget, setHistoryTarget] = useState<LigneFixe | null>(null);
  const [isImporting, setIsImporting] = useState(false);
  const [dupeCheck, setDupeCheck] = useState<ReturnType<typeof detectDuplicates<LigneFixeInput>> | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const delegations = useMemo(() => {
    const distinct = Array.from(new Set(lignesFixes.map((l) => l.delegation).filter(Boolean))) as string[];
    return ['Toutes', ...distinct];
  }, [lignesFixes]);

  const filtered = useMemo(() => {
    const lower = search.toLowerCase();
    return lignesFixes.filter((l) => {
      const matchesSearch =
        !search ||
        [l.nd, l.custcode, l.coordinationRegionale, l.delegation, l.domiciliation, l.personne, l.qualite]
          .filter(Boolean)
          .some((v) => v!.toLowerCase().includes(lower));
      const matchesDelegation = delegationFilter === 'Toutes' || l.delegation === delegationFilter;
      return matchesSearch && matchesDelegation;
    });
  }, [lignesFixes, search, delegationFilter]);

  const totalPages = Math.max(1, Math.ceil(filtered.length / ROWS_PER_PAGE));
  const paginated = filtered.slice((page - 1) * ROWS_PER_PAGE, page * ROWS_PER_PAGE);

  const stats = useMemo(
    () => ({
      total: lignesFixes.length,
      avecCustcode: lignesFixes.filter((l) => l.custcode).length,
      nonAffectees: lignesFixes.filter((l) => !l.personne).length
    }),
    [lignesFixes]
  );

  const handleFileImport = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    setIsImporting(true);
    try {
      const rows = await parseLignesFixesWorkbook(file);
      const result = detectDuplicates<LigneFixeInput>(
        rows,
        lignesFixes as unknown as LigneFixeInput[],
        (r) => r.nd || null
      );
      if (result.duplicatesOfExisting.length > 0 || result.duplicatesWithinFile.length > 0) {
        setDupeCheck(result);
      } else {
        addLignesFixes(result.clean);
        setSearch('');
        setPage(1);
      }
    } finally {
      setIsImporting(false);
      if (fileInputRef.current) fileInputRef.current.value = '';
    }
  };

  const handleFormSubmit = (data: LigneFixeInput) => {
    if (editing) {
      updateLigneFixe(editing.id, data);
    } else {
      addLigneFixe(data);
    }
    setFormOpen(false);
    setEditing(null);
  };

  return (
    <div>
      <PageHeader
        eyebrow={t('lignesFixes.eyebrow')}
        title={t('lignesFixes.title')}
        description={t('lignesFixes.description')}
        action={
          <Button variant="secondary" onClick={async () => { await exportLignesFixesToExcel(filtered); }}>
            <FileSpreadsheet size={14} /> Excel
          </Button>
        }
      />

      <div className="grid sm:grid-cols-3 gap-4 mb-6">
        <StatCard label="Total lignes fixes" value={String(stats.total)} />
        <StatCard label="Avec CUSTCODE" value={String(stats.avecCustcode)} />
        <StatCard label="Sans bénéficiaire" value={String(stats.nonAffectees)} tone={stats.nonAffectees > 0 ? 'bad' : 'good'} />
      </div>

      <div className="rounded-2xl p-5 mb-5" style={{ background: 'var(--card)', border: '1px solid var(--border)' }}>
        <div className="grid lg:grid-cols-[2fr_1fr] gap-3 mb-4">
          <label className="block">
            <span className="block text-xs font-semibold uppercase tracking-wider mb-1.5" style={{ color: 'var(--text-ter)' }}>
              Recherche
            </span>
            <input
              value={search}
              onChange={(e) => { setSearch(e.target.value); setPage(1); }}
              placeholder="ND, CUSTCODE, délégation, personne…"
              className="dark-input focus-ring"
            />
          </label>
          <label className="block">
            <span className="block text-xs font-semibold uppercase tracking-wider mb-1.5" style={{ color: 'var(--text-ter)' }}>
              Délégation
            </span>
            <select
              value={delegationFilter}
              onChange={(e) => { setDelegationFilter(e.target.value); setPage(1); }}
              className="dark-input focus-ring"
              style={{ cursor: 'pointer' }}
            >
              {delegations.map((d) => <option key={d} value={d}>{d}</option>)}
            </select>
          </label>
        </div>

        {canEdit && (
          <div className="flex flex-wrap gap-2 pt-3" style={{ borderTop: '1px solid var(--border)' }}>
            <Button onClick={() => { setEditing(null); setFormOpen(true); }}>
              <Plus size={14} /> Ajouter une ligne fixe
            </Button>
            <Button variant="secondary" onClick={() => fileInputRef.current?.click()} disabled={isImporting}>
              <Upload size={14} /> {isImporting ? 'Import…' : 'Importer Excel'}
            </Button>
            <input ref={fileInputRef} type="file" accept=".xlsx,.xls" onChange={handleFileImport} className="hidden" />
            <Button variant="danger" onClick={() => setDeleteAllOpen(true)} disabled={lignesFixes.length === 0}>
              <ShieldAlert size={14} /> Supprimer tout
            </Button>
          </div>
        )}
      </div>

      {lignesFixes.length === 0 ? (
        <EmptyState
          title="Aucune ligne fixe enregistrée"
          description="Ajoutez une ligne manuellement ou importez un fichier Excel (colonnes ND-SUP, CUSTCODE, Coordination Régionale, Délégation, Domiciliation, PERSONNE, QUALITE, DATE)."
          action={
            canEdit ? (
              <Button onClick={() => { setEditing(null); setFormOpen(true); }}>
                <Plus size={15} /> Ajouter une ligne fixe
              </Button>
            ) : undefined
          }
        />
      ) : (
        <div className="rounded-2xl overflow-hidden" style={{ background: 'var(--card)', border: '1px solid var(--border)' }}>
          <div className="overflow-x-auto">
            <table className="dark-table">
              <thead>
                <tr>
                  <th>ND</th>
                  <th>CUSTCODE</th>
                  <th>Coord. régionale</th>
                  <th>Délégation</th>
                  <th>Domiciliation</th>
                  <th>Personne</th>
                  <th>Qualité</th>
                  <th>Service</th>
                  <th>Date</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {paginated.map((l) => (
                  <tr key={l.id}>
                    <td style={{ fontFamily: 'var(--font-mono, monospace)', fontSize: 12 }}>{l.nd}</td>
                    <td>{l.custcode || '—'}</td>
                    <td>{l.coordinationRegionale || '—'}</td>
                    <td>{l.delegation || '—'}</td>
                    <td>{l.domiciliation || '—'}</td>
                    <td style={{ color: 'var(--text-pri)' }}>{l.personne || '—'}</td>
                    <td><Badge>{l.qualite || '—'}</Badge></td>
                    <td style={{ color: 'var(--text-sec)' }}>{serviceName(l.serviceId)}</td>
                    <td style={{ whiteSpace: 'nowrap' }}>{l.date || '—'}</td>
                    <td>
                      <div className="flex items-center gap-1">
                        {canEdit && (
                          <button title="Modifier" className="tbl-btn focus-ring"
                            onClick={() => { setEditing(l); setFormOpen(true); }}>
                            <Pencil size={14} />
                          </button>
                        )}
                        {isAdmin && (
                          <button title="Historique" className="tbl-btn focus-ring"
                            onClick={() => setHistoryTarget(l)}>
                            <History size={14} />
                          </button>
                        )}
                        {canEdit && (
                          <button title="Supprimer" className="tbl-btn danger focus-ring"
                            onClick={() => setDeleteTarget(l)}>
                            <Trash2 size={14} />
                          </button>
                        )}
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          {totalPages > 1 && (
            <div className="flex items-center justify-between px-4 py-3" style={{ borderTop: '1px solid var(--border)', fontSize: 13 }}>
              <p style={{ color: 'var(--text-ter)' }}>
                {filtered.length === 0 ? 0 : (page - 1) * ROWS_PER_PAGE + 1}–{Math.min(page * ROWS_PER_PAGE, filtered.length)} sur {filtered.length}
              </p>
              <div className="flex items-center gap-2">
                <Button variant="secondary" onClick={() => setPage((p) => Math.max(1, p - 1))} disabled={page === 1}>
                  Précédent
                </Button>
                <span style={{ color: 'var(--text-sec)', fontWeight: 600 }}>{page} / {totalPages}</span>
                <Button variant="secondary" onClick={() => setPage((p) => Math.min(totalPages, p + 1))} disabled={page === totalPages}>
                  Suivant
                </Button>
              </div>
            </div>
          )}
        </div>
      )}

      <LigneFixeFormModal
        open={formOpen}
        onClose={() => { setFormOpen(false); setEditing(null); }}
        initialData={editing}
        onSubmit={handleFormSubmit}
      />

      <ConfirmModal
        open={Boolean(deleteTarget)}
        onClose={() => setDeleteTarget(null)}
        onConfirm={() => { if (deleteTarget) removeLigneFixe(deleteTarget.id); }}
        title="Supprimer cette ligne fixe ?"
        description="Cette action l'envoie dans la Corbeille (Administration), d'où elle reste restaurable."
        confirmLabel="Supprimer"
        danger
      />

      <ConfirmModal
        open={deleteAllOpen}
        onClose={() => setDeleteAllOpen(false)}
        onConfirm={removeAllLignesFixes}
        title="Supprimer TOUTES les lignes fixes ?"
        description="Toutes les lignes fixes seront envoyées dans la Corbeille."
        confirmLabel="Oui, tout supprimer"
        danger
      />

      <HistoryModal
        open={Boolean(historyTarget)}
        onClose={() => setHistoryTarget(null)}
        entity="lignes-fixes"
        entityId={historyTarget?.id ?? null}
        title={historyTarget ? `Historique — ${historyTarget.nd}` : 'Historique'}
      />

      {dupeCheck && (
        <DuplicateReviewModal
          open={Boolean(dupeCheck)}
          onClose={() => setDupeCheck(null)}
          cleanCount={dupeCheck.clean.length}
          duplicatesOfExisting={dupeCheck.duplicatesOfExisting}
          duplicatesWithinFile={dupeCheck.duplicatesWithinFile}
          labelOf={(r) => r.nd || r.personne || 'Ligne sans identifiant'}
          onImportCleanOnly={() => {
            addLignesFixes(dupeCheck.clean);
            setDupeCheck(null);
            setSearch('');
            setPage(1);
          }}
          onImportAll={() => {
            addLignesFixes([
              ...dupeCheck.clean,
              ...dupeCheck.duplicatesOfExisting.map((d) => d.row),
              ...dupeCheck.duplicatesWithinFile.map((d) => d.row)
            ]);
            setDupeCheck(null);
            setSearch('');
            setPage(1);
          }}
        />
      )}
    </div>
  );
}
