import { useMemo, useRef, useState } from 'react';
import { Plus, Upload, Download, FileSpreadsheet, Trash2, Pencil, ArrowRightLeft, Printer, ShieldAlert, History } from 'lucide-react';
import { useApp } from '../context/AppContext';
import { useAuth } from '../context/AuthContext';
import { useOrg } from '../context/OrgContext';
import type { Ligne, LigneInput } from '../types';
import { useTranslation } from 'react-i18next';
import { PageHeader, Card, Button, Badge, StatCard, EmptyState } from '../components/ui/Kit';
import LigneFormModal from '../components/lignes/LigneFormModal';
import TransferIccModal, { TransferSubmitData } from '../components/lignes/TransferIccModal';
import ConfirmModal from '../components/lignes/ConfirmModal';
import HistoryModal from '../components/lignes/HistoryModal';
import { parseLignesWorkbook } from '../lib/lignesImport';
import { exportLignesToExcel, exportLignesToCSV, printBonReaffectation } from '../lib/lignesExport';
import { detectDuplicates } from '../lib/duplicateDetection';
import DuplicateReviewModal from '../components/lignes/DuplicateReviewModal';

const ROWS_PER_PAGE = 25;

export default function LignesPage() {
  const { t } = useTranslation();
  const { lignes, addLigne, addLignes, updateLigne, removeLigne, removeAllLignes, transferLigne } = useApp();
  const { canEdit, isAdmin } = useAuth();
  const { nodes } = useOrg();
  const serviceName = (id: number | null) => (id ? nodes.find((n) => n.id === id)?.name ?? '—' : '—');

  const [search, setSearch] = useState('');
  const [categorieFilter, setCategorieFilter] = useState('Toutes');
  const [affectationFilter, setAffectationFilter] = useState<'all' | 'affected' | 'notAffected'>('all');
  const [page, setPage] = useState(1);

  const [formOpen, setFormOpen] = useState(false);
  const [editing, setEditing] = useState<Ligne | null>(null);
  const [transferOpen, setTransferOpen] = useState(false);
  const [transferTarget, setTransferTarget] = useState<Ligne | null>(null);
  const [deleteTarget, setDeleteTarget] = useState<Ligne | null>(null);
  const [deleteAllOpen, setDeleteAllOpen] = useState(false);
  const [historyTarget, setHistoryTarget] = useState<Ligne | null>(null);
  const [isImporting, setIsImporting] = useState(false);
  const [dupeCheck, setDupeCheck] = useState<ReturnType<typeof detectDuplicates<LigneInput>> | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const categories = useMemo(() => {
    const distinct = Array.from(new Set(lignes.map((l) => l.categorie).filter(Boolean)));
    return ['Toutes', ...distinct];
  }, [lignes]);

  const filtered = useMemo(() => {
    const lower = search.toLowerCase();
    return lignes.filter((l) => {
      const matchesSearch =
        !search ||
        [l.categorie, l.typeForfait, l.typeMobile, l.icc, l.imei, l.affecte, l.personne, l.qualite, l.date]
          .filter(Boolean)
          .some((v) => v!.toLowerCase().includes(lower));
      const matchesCategorie = categorieFilter === 'Toutes' || l.categorie === categorieFilter;
      const matchesAffectation =
        affectationFilter === 'all' ||
        (affectationFilter === 'affected' && Boolean(l.affecte)) ||
        (affectationFilter === 'notAffected' && !l.affecte);
      return matchesSearch && matchesCategorie && matchesAffectation;
    });
  }, [lignes, search, categorieFilter, affectationFilter]);

  const totalPages = Math.max(1, Math.ceil(filtered.length / ROWS_PER_PAGE));
  const paginated = filtered.slice((page - 1) * ROWS_PER_PAGE, page * ROWS_PER_PAGE);

  const stats = useMemo(
    () => ({
      total: lignes.length,
      cat1: lignes.filter((l) => l.categorie?.toLowerCase() === 'cat 1').length,
      cat2: lignes.filter((l) => l.categorie?.toLowerCase() === 'cat 2').length,
      nonAffectees: lignes.filter((l) => !l.affecte).length
    }),
    [lignes]
  );

  const handleFileImport = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    setIsImporting(true);
    try {
      const rows = await parseLignesWorkbook(file);
      const result = detectDuplicates<LigneInput>(
        rows,
        lignes as unknown as LigneInput[],
        (r) => r.icc || r.imei || null
      );
      if (result.duplicatesOfExisting.length > 0 || result.duplicatesWithinFile.length > 0) {
        setDupeCheck(result);
      } else {
        addLignes(result.clean);
        setSearch('');
        setPage(1);
      }
    } finally {
      setIsImporting(false);
      if (fileInputRef.current) fileInputRef.current.value = '';
    }
  };

  const handleFormSubmit = (data: LigneInput) => {
    if (editing) {
      updateLigne(editing.id, data);
    } else {
      addLigne(data);
    }
    setFormOpen(false);
    setEditing(null);
  };

  const handleTransferSubmit = (data: TransferSubmitData) => {
    if (!transferTarget) return;
    transferLigne(transferTarget.id, data);
    if (data.generateBon) {
      printBonReaffectation({
        ligne: transferTarget,
        nouvellePersonne: data.nouvellePersonne,
        civilite: data.civilite ?? 'Mme',
        nouveauAffecte: data.nouveauAffecte,
        nouvelleQualite: data.nouvelleQualite
      });
    }
    setTransferOpen(false);
    setTransferTarget(null);
  };

  return (
    <div>
      <PageHeader
        eyebrow={t('lignes.eyebrow')}
        title={t('lignes.title')}
        description={t('lignes.description')}
        action={
          <div className="flex flex-wrap gap-2">
            <Button variant="secondary" onClick={async () => { await exportLignesToExcel(filtered); }}>
              <FileSpreadsheet size={14} /> Excel
            </Button>
            <Button variant="secondary" onClick={() => exportLignesToCSV(filtered)}>
              <Download size={14} /> CSV
            </Button>
          </div>
        }
      />

      <div className="grid sm:grid-cols-4 gap-4 mb-6">
        <StatCard label={t('lignes.statTotal')} value={String(stats.total)} />
        <StatCard label="CAT 1" value={String(stats.cat1)} />
        <StatCard label="CAT 2" value={String(stats.cat2)} />
        <StatCard label={t('lignes.statNonAffectees')} value={String(stats.nonAffectees)} tone={stats.nonAffectees > 0 ? 'bad' : 'good'} />
      </div>

      {/* ── Filtres + actions ── */}
      <div className="rounded-2xl p-5 mb-5" style={{ background: 'var(--card)', border: '1px solid var(--border)' }}>
        <div className="grid lg:grid-cols-[2fr_1fr_1fr] gap-3 mb-4">
          <label className="block">
            <span className="block text-xs font-semibold uppercase tracking-wider mb-1.5" style={{ color: 'var(--text-ter)' }}>
              Recherche
            </span>
            <input
              value={search}
              onChange={(e) => { setSearch(e.target.value); setPage(1); }}
              placeholder="Catégorie, mobile, ICC, personne…"
              className="dark-input focus-ring"
            />
          </label>
          <label className="block">
            <span className="block text-xs font-semibold uppercase tracking-wider mb-1.5" style={{ color: 'var(--text-ter)' }}>
              Catégorie
            </span>
            <select
              value={categorieFilter}
              onChange={(e) => { setCategorieFilter(e.target.value); setPage(1); }}
              className="dark-input focus-ring"
              style={{ cursor: 'pointer' }}
            >
              {categories.map((c) => <option key={c} value={c}>{c}</option>)}
            </select>
          </label>
          <label className="block">
            <span className="block text-xs font-semibold uppercase tracking-wider mb-1.5" style={{ color: 'var(--text-ter)' }}>
              Affectation
            </span>
            <select
              value={affectationFilter}
              onChange={(e) => { setAffectationFilter(e.target.value as typeof affectationFilter); setPage(1); }}
              className="dark-input focus-ring"
              style={{ cursor: 'pointer' }}
            >
              <option value="all">Toutes</option>
              <option value="affected">Affectées</option>
              <option value="notAffected">Non affectées</option>
            </select>
          </label>
        </div>

        {canEdit && (
          <div className="flex flex-wrap gap-2 pt-3" style={{ borderTop: '1px solid var(--border)' }}>
            <Button onClick={() => { setEditing(null); setFormOpen(true); }}>
              <Plus size={14} /> Ajouter une ligne
            </Button>
            <Button variant="secondary" onClick={() => fileInputRef.current?.click()} disabled={isImporting}>
              <Upload size={14} /> {isImporting ? 'Import…' : 'Importer Excel'}
            </Button>
            <input ref={fileInputRef} type="file" accept=".xlsx,.xls" onChange={handleFileImport} className="hidden" />
            <Button variant="danger" onClick={() => setDeleteAllOpen(true)} disabled={lignes.length === 0}>
              <ShieldAlert size={14} /> Supprimer tout
            </Button>
          </div>
        )}
      </div>

      {lignes.length === 0 ? (
        <EmptyState
          title="Aucune ligne enregistrée"
          description="Ajoutez une ligne manuellement ou importez un fichier Excel (colonnes CATEGORIE, TYPE FORFAIT, TYPE MOBILE, ICC, IMEI, AFFECTE, PERSONNE, QUALITE, DATE)."
          action={
            canEdit ? (
              <Button
                onClick={() => {
                  setEditing(null);
                  setFormOpen(true);
                }}
              >
                <Plus size={15} />
                Ajouter une ligne
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
                  <th>{t('lignes.colCategorie')}</th>
                  <th>{t('lignes.colForfait')}</th>
                  <th>{t('lignes.colMobile')}</th>
                  <th>{t('lignes.colIcc')}</th>
                  <th>{t('lignes.colImei')}</th>
                  <th>{t('lignes.colQualite')}</th>
                  <th>{t('lignes.colPersonne')}</th>
                  <th>{t('lignes.colFonction')}</th>
                  <th>Service</th>
                  <th>{t('lignes.colDate')}</th>
                  <th>{t('common.actions')}</th>
                </tr>
              </thead>
              <tbody>
                {paginated.map((l) => (
                  <tr key={l.id}>
                    <td><Badge>{l.categorie || '—'}</Badge></td>
                    <td>{l.typeForfait || '—'}</td>
                    <td>{l.typeMobile || '—'}</td>
                    <td style={{ fontFamily: 'var(--font-mono, monospace)', fontSize: 12 }}>{l.icc || '—'}</td>
                    <td style={{ fontFamily: 'var(--font-mono, monospace)', fontSize: 12 }}>{l.imei || '—'}</td>
                    <td style={{ color: 'var(--text-pri)' }}>{l.affecte || '—'}</td>
                    <td style={{ color: 'var(--text-pri)' }}>{l.personne || '—'}</td>
                    <td><Badge>{l.qualite || '—'}</Badge></td>
                    <td style={{ color: 'var(--text-sec)' }}>{serviceName(l.serviceId)}</td>
                    <td style={{ whiteSpace: 'nowrap' }}>{l.date || '—'}</td>
                    <td>
                      <div className="flex items-center gap-1">
                        {canEdit && (
                          <>
                            <button title="Modifier" className="tbl-btn focus-ring"
                              onClick={() => { setEditing(l); setFormOpen(true); }}>
                              <Pencil size={14} />
                            </button>
                            <button title="Transférer" className="tbl-btn focus-ring"
                              onClick={() => { setTransferTarget(l); setTransferOpen(true); }}>
                              <ArrowRightLeft size={14} />
                            </button>
                          </>
                        )}
                        {isAdmin && (
                          <button title="Historique" className="tbl-btn focus-ring"
                            onClick={() => setHistoryTarget(l)}>
                            <History size={14} />
                          </button>
                        )}
                        <button title="Imprimer bon" className="tbl-btn focus-ring"
                          onClick={() => printBonReaffectation({
                            ligne: l, nouvellePersonne: l.personne || '',
                            civilite: l.civilite ?? 'Mme',
                            nouveauAffecte: l.affecte, nouvelleQualite: l.qualite
                          })}>
                          <Printer size={14} />
                        </button>
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
            <div
              className="flex items-center justify-between px-4 py-3"
              style={{ borderTop: '1px solid var(--border)', fontSize: 13 }}
            >
              <p style={{ color: 'var(--text-ter)' }}>
                {filtered.length === 0 ? 0 : (page - 1) * ROWS_PER_PAGE + 1}–{Math.min(page * ROWS_PER_PAGE, filtered.length)} sur {filtered.length}
              </p>
              <div className="flex items-center gap-2">
                <Button variant="secondary" onClick={() => setPage((p) => Math.max(1, p - 1))} disabled={page === 1}>
                  Précédent
                </Button>
                <span style={{ color: 'var(--text-sec)', fontWeight: 600 }}>
                  {page} / {totalPages}
                </span>
                <Button variant="secondary" onClick={() => setPage((p) => Math.min(totalPages, p + 1))} disabled={page === totalPages}>
                  Suivant
                </Button>
              </div>
            </div>
          )}
        </div>
      )}

      <LigneFormModal
        open={formOpen}
        onClose={() => {
          setFormOpen(false);
          setEditing(null);
        }}
        initialData={editing}
        onSubmit={handleFormSubmit}
      />

      <TransferIccModal
        open={transferOpen}
        onClose={() => {
          setTransferOpen(false);
          setTransferTarget(null);
        }}
        ligne={transferTarget}
        onSubmit={handleTransferSubmit}
      />

      <ConfirmModal
        open={Boolean(deleteTarget)}
        onClose={() => setDeleteTarget(null)}
        onConfirm={() => {
          if (deleteTarget) removeLigne(deleteTarget.id);
        }}
        title="Supprimer cette ligne ?"
        description="Cette action est irréversible."
        confirmLabel="Supprimer"
        danger
      />

      <ConfirmModal
        open={deleteAllOpen}
        onClose={() => setDeleteAllOpen(false)}
        onConfirm={removeAllLignes}
        title="Supprimer TOUTES les lignes ?"
        description="Vous êtes sur le point de supprimer toutes les lignes enregistrées. Cette action est définitive et irréversible."
        confirmLabel="Oui, tout supprimer"
        danger
      />

      <HistoryModal
        open={Boolean(historyTarget)}
        onClose={() => setHistoryTarget(null)}
        entity="lignes"
        entityId={historyTarget?.id ?? null}
        title={historyTarget ? `Historique — ${historyTarget.personne || historyTarget.icc || 'Ligne'}` : 'Historique'}
      />

      {dupeCheck && (
        <DuplicateReviewModal
          open={Boolean(dupeCheck)}
          onClose={() => setDupeCheck(null)}
          cleanCount={dupeCheck.clean.length}
          duplicatesOfExisting={dupeCheck.duplicatesOfExisting}
          duplicatesWithinFile={dupeCheck.duplicatesWithinFile}
          labelOf={(r) => r.personne || r.icc || r.imei || 'Ligne sans identifiant'}
          onImportCleanOnly={() => {
            addLignes(dupeCheck.clean);
            setDupeCheck(null);
            setSearch('');
            setPage(1);
          }}
          onImportAll={() => {
            addLignes([
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
