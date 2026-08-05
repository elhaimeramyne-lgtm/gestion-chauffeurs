import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { FileSpreadsheet, FileText, Trash2, Loader2, Filter, Mail, MessageCircle } from 'lucide-react';
import { api, ApiError } from '../lib/api';
import { useAuth } from '../context/AuthContext';
import type { Facture } from '../types';
import { PageHeader, Card, Button, Badge, StatCard, Modal } from '../components/ui/Kit';
import { exportFacturesToExcel } from '../lib/facturesExport';
import { exportFacturesToPdf } from '../lib/facturesPdf';

const PAGE_SIZE = 25;

interface FactureRow {
  id: number;
  custcode: string;
  nd: string | null;
  nom: string | null;
  refFacture: string;
  montant: number;
  mois: string | null;
  echeance: string | null;
  produit: string | null;
  statut: 'reglee' | 'impayee';
}

const toFacture = (r: FactureRow): Facture => ({
  ...r,
  id: String(r.id),
  coordinationRegionale: null,
  delegation: null,
  domiciliation: null,
  sourceSheet: null,
  createdAt: '',
  updatedAt: ''
});

export default function FacturesPage() {
  const { t } = useTranslation();
  const { canEdit } = useAuth();

  const [rows, setRows] = useState<Facture[]>([]);
  const [total, setTotal] = useState(0);
  const [page, setPage] = useState(1);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // ── Envoi par e-mail ──
  const [emailTarget, setEmailTarget] = useState<Facture | null>(null);
  const [emailTo, setEmailTo] = useState('');
  const [emailSending, setEmailSending] = useState(false);
  const [emailResult, setEmailResult] = useState<string | null>(null);

  // ── Envoi par WhatsApp ──
  const [waTarget, setWaTarget] = useState<Facture | null>(null);
  const [waTo, setWaTo] = useState('');
  const [waSending, setWaSending] = useState(false);
  const [waResult, setWaResult] = useState<string | null>(null);

  // ── Recherche avancée ──
  const [search, setSearch] = useState('');
  const [statut, setStatut] = useState<'' | 'reglee' | 'impayee'>('');
  const [produit, setProduit] = useState('');
  const [produits, setProduits] = useState<string[]>([]);
  const [montantMin, setMontantMin] = useState('');
  const [montantMax, setMontantMax] = useState('');
  const [dateFrom, setDateFrom] = useState('');
  const [dateTo, setDateTo] = useState('');
  const [showFilters, setShowFilters] = useState(false);

  useEffect(() => {
    api
      .get<{ produits: string[] }>('/factures/produits')
      .then((res) => setProduits(res.produits))
      .catch(() => {});
  }, []);

  const load = () => {
    setLoading(true);
    setError(null);
    const params = new URLSearchParams();
    if (search) params.set('search', search);
    if (statut) params.set('statut', statut);
    if (produit) params.set('produit', produit);
    if (montantMin) params.set('montantMin', montantMin);
    if (montantMax) params.set('montantMax', montantMax);
    if (dateFrom) params.set('dateFrom', dateFrom);
    if (dateTo) params.set('dateTo', dateTo);
    params.set('page', String(page));
    params.set('pageSize', String(PAGE_SIZE));

    api
      .get<{ factures: FactureRow[]; total: number }>(`/factures?${params.toString()}`)
      .then((res) => {
        setRows(res.factures.map(toFacture));
        setTotal(res.total);
      })
      .catch((err) => setError(err instanceof ApiError ? err.message : t('factures.loadError')))
      .finally(() => setLoading(false));
  };

  useEffect(() => {
    const timer = setTimeout(load, 250); // debounce
    return () => clearTimeout(timer);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [search, statut, produit, montantMin, montantMax, dateFrom, dateTo, page]);

  const handleSendEmail = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!emailTarget) return;
    setEmailSending(true);
    setEmailResult(null);
    try {
      await api.post(`/email/facture/${emailTarget.id}`, { to: emailTo });
      setEmailResult(t('factures.emailSentSuccess'));
      setTimeout(() => { setEmailTarget(null); setEmailTo(''); setEmailResult(null); }, 1500);
    } catch (err) {
      setEmailResult(err instanceof ApiError ? err.message : t('factures.sendFailed'));
    } finally {
      setEmailSending(false);
    }
  };

  const handleSendWhatsApp = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!waTarget) return;
    setWaSending(true);
    setWaResult(null);
    try {
      await api.post(`/whatsapp/facture/${waTarget.id}`, { to: waTo });
      setWaResult(t('factures.waSentSuccess'));
      setTimeout(() => { setWaTarget(null); setWaTo(''); setWaResult(null); }, 1500);
    } catch (err) {
      setWaResult(err instanceof ApiError ? err.message : t('factures.sendFailed'));
    } finally {
      setWaSending(false);
    }
  };

  const handleDelete = async (f: Facture) => {
    if (!confirm(t('factures.deleteConfirm', { ref: f.refFacture, code: f.custcode }))) return;
    try {
      await api.delete(`/factures/${f.id}`);
      load();
    } catch (err) {
      setError(err instanceof ApiError ? err.message : t('factures.deleteError'));
    }
  };

  const buildFilterParams = () => {
    const params = new URLSearchParams();
    if (search) params.set('search', search);
    if (statut) params.set('statut', statut);
    if (produit) params.set('produit', produit);
    if (montantMin) params.set('montantMin', montantMin);
    if (montantMax) params.set('montantMax', montantMax);
    if (dateFrom) params.set('dateFrom', dateFrom);
    if (dateTo) params.set('dateTo', dateTo);
    params.set('page', '1');
    params.set('pageSize', '100');
    return params;
  };

  const handleExportExcel = async () => {
    // Excel côté client à partir de la page courante suffit pour un export rapide ;
    // pour un export complet, augmente pageSize côté serveur (max 100).
    const res = await api.get<{ factures: FactureRow[] }>(`/factures?${buildFilterParams().toString()}`);
    await exportFacturesToExcel(res.factures.map(toFacture));
  };

  const handleExportPdf = async () => {
    const res = await api.get<{ factures: FactureRow[] }>(`/factures?${buildFilterParams().toString()}`);
    const activeFilters = [search, statut, produit].filter(Boolean).length;
    exportFacturesToPdf(res.factures.map(toFacture), activeFilters > 0 ? `${activeFilters} ${t('factures.activeFiltersLabel')}` : undefined);
  };

  const totalPages = Math.max(1, Math.ceil(total / PAGE_SIZE));

  const resetFilters = () => {
    setSearch('');
    setStatut('');
    setProduit('');
    setMontantMin('');
    setMontantMax('');
    setDateFrom('');
    setDateTo('');
    setPage(1);
  };

  return (
    <div>
      <PageHeader
        eyebrow={t('factures.eyebrow')}
        title={t('factures.title')}
        description={t('factures.description')}
        action={
          <div className="flex gap-2">
            <Button variant="secondary" onClick={handleExportExcel}>
              <FileSpreadsheet size={14} /> {t('factures.exportExcel')}
            </Button>
            <Button variant="secondary" onClick={handleExportPdf}>
              <FileText size={14} /> {t('factures.exportPdf')}
            </Button>
          </div>
        }
      />

      <div className="grid sm:grid-cols-3 gap-4 mb-6">
        <StatCard label={t('factures.statResults')} value={String(total)} color="blue" />
        <StatCard label={t('factures.statPage')} value={`${page} / ${totalPages}`} color="violet" />
        <StatCard label={t('factures.statActiveFilters')} value={String([search, statut, produit, montantMin, montantMax, dateFrom, dateTo].filter(Boolean).length)} color="orange" />
      </div>

      {error && <p className="text-sm text-signal-roseDark bg-signal-rose/10 rounded-lg px-3 py-2 mb-4">{error}</p>}

      <Card className="p-5 mb-5">
        <div className="flex items-center justify-between mb-3">
          <div className="relative flex-1 max-w-md">
            <input
              value={search}
              onChange={(e) => { setSearch(e.target.value); setPage(1); }}
              placeholder={t('factures.searchPlaceholder')}
              className="focus-ring w-full rounded-lg border border-ink-200 px-3 py-2 text-sm"
            />
          </div>
          <button
            onClick={() => setShowFilters((s) => !s)}
            className="focus-ring flex items-center gap-1.5 text-xs font-medium text-ink-600 hover:text-ink-900 px-3 py-2"
          >
            <Filter size={13} /> {t('factures.advancedSearch')}
          </button>
        </div>

        {showFilters && (
          <div className="grid sm:grid-cols-3 lg:grid-cols-6 gap-3 pt-3 border-t border-ink-100">
            <label className="block text-xs text-ink-500">
              <span>{t('factures.filterStatut')}</span>
              <select
                value={statut}
                onChange={(e) => { setStatut(e.target.value as typeof statut); setPage(1); }}
                className="focus-ring mt-1 w-full rounded-lg border border-ink-200 px-2 py-1.5 text-sm"
              >
                <option value="">{t('factures.filterAll')}</option>
                <option value="reglee">{t('factures.filterReglee')}</option>
                <option value="impayee">{t('factures.filterImpayee')}</option>
              </select>
            </label>
            <label className="block text-xs text-ink-500">
              <span>{t('factures.filterProduit')}</span>
              <select
                value={produit}
                onChange={(e) => { setProduit(e.target.value); setPage(1); }}
                className="focus-ring mt-1 w-full rounded-lg border border-ink-200 px-2 py-1.5 text-sm"
              >
                <option value="">{t('factures.filterAll')}</option>
                {produits.map((p) => (
                  <option key={p} value={p}>{p}</option>
                ))}
              </select>
            </label>
            <label className="block text-xs text-ink-500">
              <span>{t('factures.filterMontantMin')}</span>
              <input
                type="number"
                value={montantMin}
                onChange={(e) => { setMontantMin(e.target.value); setPage(1); }}
                className="focus-ring mt-1 w-full rounded-lg border border-ink-200 px-2 py-1.5 text-sm"
              />
            </label>
            <label className="block text-xs text-ink-500">
              <span>{t('factures.filterMontantMax')}</span>
              <input
                type="number"
                value={montantMax}
                onChange={(e) => { setMontantMax(e.target.value); setPage(1); }}
                className="focus-ring mt-1 w-full rounded-lg border border-ink-200 px-2 py-1.5 text-sm"
              />
            </label>
            <label className="block text-xs text-ink-500">
              <span>{t('factures.filterEcheanceFrom')}</span>
              <input
                value={dateFrom}
                onChange={(e) => { setDateFrom(e.target.value); setPage(1); }}
                placeholder="JJ/MM/AAAA"
                className="focus-ring mt-1 w-full rounded-lg border border-ink-200 px-2 py-1.5 text-sm"
              />
            </label>
            <label className="block text-xs text-ink-500">
              <span>{t('factures.filterEcheanceTo')}</span>
              <input
                value={dateTo}
                onChange={(e) => { setDateTo(e.target.value); setPage(1); }}
                placeholder="JJ/MM/AAAA"
                className="focus-ring mt-1 w-full rounded-lg border border-ink-200 px-2 py-1.5 text-sm"
              />
            </label>
            <div className="sm:col-span-3 lg:col-span-6">
              <Button variant="secondary" onClick={resetFilters}>{t('factures.resetFilters')}</Button>
            </div>
          </div>
        )}
      </Card>

      <Card className="overflow-hidden">
        <table className="w-full text-sm">
          <thead>
            <tr className="bg-ink-50 text-left text-xs text-ink-500 uppercase tracking-wide">
              <th className="px-4 py-3">{t('factures.colCustcode')}</th>
              <th className="px-4 py-3">{t('factures.colNom')}</th>
              <th className="px-4 py-3">{t('factures.colRef')}</th>
              <th className="px-4 py-3">{t('factures.colMontant')}</th>
              <th className="px-4 py-3">{t('factures.colEcheance')}</th>
              <th className="px-4 py-3">{t('factures.colProduit')}</th>
              <th className="px-4 py-3">{t('factures.colStatut')}</th>
              {canEdit && <th className="px-4 py-3">{t('common.actions')}</th>}
            </tr>
          </thead>
          <tbody>
            {rows.map((f) => (
              <tr key={f.id} className="border-t border-ink-50">
                <td className="px-4 py-2.5 font-mono text-xs text-ink-800">{f.custcode}</td>
                <td className="px-4 py-2.5 text-ink-700">{f.nom || '—'}</td>
                <td className="px-4 py-2.5 font-mono text-xs text-ink-600">{f.refFacture}</td>
                <td className="px-4 py-2.5 text-ink-800">{f.montant.toLocaleString('fr-FR')} DH</td>
                <td className="px-4 py-2.5 text-ink-500 text-xs">{f.echeance || '—'}</td>
                <td className="px-4 py-2.5 text-ink-600 text-xs">{f.produit || '—'}</td>
                <td className="px-4 py-2.5">
                  <Badge tone={f.statut === 'reglee' ? 'good' : 'bad'}>{f.statut === 'reglee' ? t('factures.filterReglee') : t('factures.filterImpayee')}</Badge>
                </td>
                {canEdit && (
                  <td className="px-4 py-2.5">
                    <div className="flex items-center gap-1">
                      <button
                        title={t('factures.sendEmailButton')}
                        onClick={() => { setEmailTarget(f); setEmailTo(''); setEmailResult(null); }}
                        className="focus-ring p-1.5 rounded-md text-ink-500 hover:bg-ink-100 hover:text-ink-800"
                      >
                        <Mail size={14} />
                      </button>
                      <button
                        title={t('factures.sendWhatsAppButton')}
                        onClick={() => { setWaTarget(f); setWaTo(''); setWaResult(null); }}
                        className="focus-ring p-1.5 rounded-md text-ink-500 hover:bg-ink-100 hover:text-ink-800"
                      >
                        <MessageCircle size={14} />
                      </button>
                      <button
                        title={t('common.delete')}
                        onClick={() => handleDelete(f)}
                        className="focus-ring p-1.5 rounded-md text-ink-500 hover:bg-signal-rose/10 hover:text-signal-rose"
                      >
                        <Trash2 size={14} />
                      </button>
                    </div>
                  </td>
                )}
              </tr>
            ))}
            {!loading && rows.length === 0 && (
              <tr>
                <td colSpan={8} className="px-4 py-10 text-center text-ink-400">
                  {loading ? (
                    <Loader2 size={16} className="animate-spin inline" />
                  ) : (
                    t('factures.noResults')
                  )}
                </td>
              </tr>
            )}
          </tbody>
        </table>

        {totalPages > 1 && (
          <div className="flex items-center justify-between px-4 py-3 border-t border-ink-100 text-xs">
            <p className="text-ink-400">{total} {t('factures.factureCount')}</p>
            <div className="flex items-center gap-2">
              <Button variant="secondary" onClick={() => setPage((p) => Math.max(1, p - 1))} disabled={page === 1}>
                {t('common.previous')}
              </Button>
              <span className="text-ink-600 font-medium">{page} / {totalPages}</span>
              <Button variant="secondary" onClick={() => setPage((p) => Math.min(totalPages, p + 1))} disabled={page === totalPages}>
                {t('common.next')}
              </Button>
            </div>
          </div>
        )}
      </Card>

      <Modal open={Boolean(emailTarget)} onClose={() => setEmailTarget(null)} title={t('factures.sendEmailTitle')} width="sm">
        <form onSubmit={handleSendEmail} className="space-y-4">
          <p className="text-sm text-ink-500">
            {t('factures.colRef')} <b>{emailTarget?.refFacture}</b> ({emailTarget?.custcode})
          </p>
          <label className="block text-xs text-ink-500">
            <span>{t('factures.recipientEmail')}</span>
            <input
              type="email"
              required
              value={emailTo}
              onChange={(e) => setEmailTo(e.target.value)}
              className="focus-ring mt-1 w-full rounded-lg border border-ink-200 px-3 py-2 text-sm"
            />
          </label>
          {emailResult && (
            <p className={`text-sm rounded-lg px-3 py-2 ${emailResult.includes('succès') || emailResult.includes('نجاح') ? 'bg-signal-emerald/10 text-signal-emeraldDark' : 'bg-signal-rose/10 text-signal-roseDark'}`}>
              {emailResult}
            </p>
          )}
          <div className="flex justify-end gap-2">
            <Button type="button" variant="secondary" onClick={() => setEmailTarget(null)}>{t('common.cancel')}</Button>
            <Button type="submit" disabled={emailSending}>
              {emailSending ? <Loader2 size={14} className="animate-spin" /> : <Mail size={14} />} {t('common.send')}
            </Button>
          </div>
        </form>
      </Modal>

      <Modal open={Boolean(waTarget)} onClose={() => setWaTarget(null)} title={t('factures.sendWhatsAppTitle')} width="sm">
        <form onSubmit={handleSendWhatsApp} className="space-y-4">
          <p className="text-sm text-ink-500">
            {t('factures.colRef')} <b>{waTarget?.refFacture}</b> ({waTarget?.custcode})
          </p>
          <label className="block text-xs text-ink-500">
            <span>{t('factures.recipientPhone')}</span>
            <input
              required
              value={waTo}
              onChange={(e) => setWaTo(e.target.value)}
              placeholder="212612345678"
              className="focus-ring mt-1 w-full rounded-lg border border-ink-200 px-3 py-2 text-sm"
            />
          </label>
          {waResult && (
            <p className={`text-sm rounded-lg px-3 py-2 ${waResult.includes('succès') || waResult.includes('نجاح') ? 'bg-signal-emerald/10 text-signal-emeraldDark' : 'bg-signal-rose/10 text-signal-roseDark'}`}>
              {waResult}
            </p>
          )}
          <div className="flex justify-end gap-2">
            <Button type="button" variant="secondary" onClick={() => setWaTarget(null)}>{t('common.cancel')}</Button>
            <Button type="submit" disabled={waSending}>
              {waSending ? <Loader2 size={14} className="animate-spin" /> : <MessageCircle size={14} />} {t('common.send')}
            </Button>
          </div>
        </form>
      </Modal>
    </div>
  );
}
