import { useCallback, useEffect, useState } from 'react';
import {
  ScrollText, LogIn, Mail, MessageCircle, Download, Filter, X,
  TrendingUp, Users, AlertTriangle, Activity
} from 'lucide-react';
import {
  ResponsiveContainer, BarChart, Bar, XAxis, YAxis, Tooltip, CartesianGrid,
  PieChart, Pie, Cell, LineChart, Line
} from 'recharts';
import { api, ApiError } from '../lib/api';
import { PageHeader, Card, Badge } from '../components/ui/Kit';
import { useTranslation } from 'react-i18next';

/* ── Types ─────────────────────────────────────────────────────────── */
interface AuditLog {
  id: number; userId: number | null; username: string | null; role: string | null;
  action: string; entity: string; entityId: string | null;
  method: string; path: string; statusCode: number; ipAddress: string | null; createdAt: string;
}
interface ConnectionLog {
  id: number; userId: number | null; username: string; success: boolean;
  reason: string | null; ipAddress: string | null; createdAt: string;
}
interface EmailLog {
  id: number; toAddress: string; subject: string; kind: string; success: boolean;
  error: string | null; sentBy: string | null; createdAt: string;
}
interface WhatsAppLog {
  id: number; toPhone: string; message: string; kind: string; status: string;
  error: string | null; sentBy: string | null; sentAt: string;
}
interface AuditSummary {
  byAction: { action: string; value: number }[];
  topEntities: { entity: string; value: number }[];
  byHour: { hour: number; value: number }[];
  topUsers: { username: string; value: number }[];
  errorRate: number;
  totalActions: number;
}

/* ── Labels ────────────────────────────────────────────────────────── */
const ACTION_LABELS: Record<string, string> = {
  create: 'Création', update: 'Modification', delete: 'Suppression'
};
const ACTION_COLORS: Record<string, string> = {
  create: 'var(--accent2)', update: '#22d3ee', delete: 'var(--accent-err)'
};
const REASON_LABELS: Record<string, string> = {
  unknown_username: "Nom d'utilisateur inconnu", bad_password: 'Mot de passe incorrect',
  account_disabled: 'Compte désactivé', bad_2fa_code: 'Code 2FA incorrect'
};
const EMAIL_KIND_LABELS: Record<string, string> = { facture: 'Facture', test: 'Test SMTP', autre: 'Autre' };
const WHATSAPP_STATUS_LABELS: Record<string, string> = {
  queued: 'En attente', sent: 'Envoyé', delivered: 'Distribué', read: 'Lu', failed: 'Échec'
};

const PIE_COLORS = ['#a855f7', '#22d3ee', 'var(--accent2)', 'var(--accent-warn)', 'var(--accent-err)', '#ec4899', '#6366f1', '#fb923c'];

const API_BASE = (import.meta.env.VITE_API_URL as string | undefined) ?? 'http://localhost:5000/api';

type Tab = 'history' | 'connections' | 'emails' | 'whatsapp' | 'analytics';

/* ── Onglets ────────────────────────────────────────────────────────── */
function TabBar({ tab, setTab }: { tab: Tab; setTab: (t: Tab) => void }) {
  const items: Array<{ id: Tab; label: string; icon: typeof ScrollText }> = [
    { id: 'history', label: 'Actions', icon: ScrollText },
    { id: 'connections', label: 'Connexions', icon: LogIn },
    { id: 'emails', label: 'E-mails', icon: Mail },
    { id: 'whatsapp', label: 'WhatsApp', icon: MessageCircle },
    { id: 'analytics', label: 'Analytique', icon: Activity },
  ];
  return (
    <div className="flex gap-1 mb-5 overflow-x-auto" style={{ borderBottom: '1px solid var(--border)' }}>
      {items.map((it) => (
        <button
          key={it.id}
          onClick={() => setTab(it.id)}
          className="focus-ring flex items-center gap-1.5 px-3 py-2.5 text-sm font-medium border-b-2 -mb-px transition-colors whitespace-nowrap"
          style={{
            borderBottomColor: tab === it.id ? 'var(--accent)' : 'transparent',
            color: tab === it.id ? 'var(--accent)' : 'var(--text-sec)'
          }}
        >
          <it.icon size={14} />
          {it.label}
        </button>
      ))}
    </div>
  );
}

/* ── Panel filtres (onglet history) ─────────────────────────────────── */
interface AuditFilters {
  action: string; entity: string; username: string; from: string; to: string;
}
function FilterPanel({
  filters, setFilters, users, entities, onExport, loading
}: {
  filters: AuditFilters;
  setFilters: (f: AuditFilters) => void;
  users: { username: string }[];
  entities: string[];
  onExport: () => void;
  loading: boolean;
}) {
  const hasFilters = !!(filters.action || filters.entity || filters.username || filters.from || filters.to);
  return (
    <div
      className="mb-4 rounded-xl px-4 py-3 flex flex-wrap gap-3 items-end"
      style={{ background: 'var(--glass-bg)', border: '1px solid var(--border)' }}
    >
      <div className="flex items-center gap-1.5 text-sm font-semibold" style={{ color: 'var(--accent)', minWidth: 90 }}>
        <Filter size={13} /> Filtres
      </div>

      {/* Action */}
      <div className="flex flex-col gap-1">
        <label className="text-[11px]" style={{ color: 'var(--text-ter)' }}>Action</label>
        <select
          value={filters.action}
          onChange={(e) => setFilters({ ...filters, action: e.target.value })}
          className="text-xs rounded-lg px-2 py-1.5"
          style={{ background: 'var(--bg)', border: '1px solid var(--border)', color: 'var(--text-pri)', minWidth: 130 }}
        >
          <option value="">Toutes</option>
          <option value="create">Création</option>
          <option value="update">Modification</option>
          <option value="delete">Suppression</option>
        </select>
      </div>

      {/* Entité */}
      <div className="flex flex-col gap-1">
        <label className="text-[11px]" style={{ color: 'var(--text-ter)' }}>Ressource</label>
        <select
          value={filters.entity}
          onChange={(e) => setFilters({ ...filters, entity: e.target.value })}
          className="text-xs rounded-lg px-2 py-1.5"
          style={{ background: 'var(--bg)', border: '1px solid var(--border)', color: 'var(--text-pri)', minWidth: 130 }}
        >
          <option value="">Toutes</option>
          {entities.map((e) => <option key={e} value={e}>{e}</option>)}
        </select>
      </div>

      {/* Utilisateur */}
      <div className="flex flex-col gap-1">
        <label className="text-[11px]" style={{ color: 'var(--text-ter)' }}>Utilisateur</label>
        <select
          value={filters.username}
          onChange={(e) => setFilters({ ...filters, username: e.target.value })}
          className="text-xs rounded-lg px-2 py-1.5"
          style={{ background: 'var(--bg)', border: '1px solid var(--border)', color: 'var(--text-pri)', minWidth: 150 }}
        >
          <option value="">Tous</option>
          {users.map((u) => <option key={u.username} value={u.username}>{u.username}</option>)}
        </select>
      </div>

      {/* Du */}
      <div className="flex flex-col gap-1">
        <label className="text-[11px]" style={{ color: 'var(--text-ter)' }}>Du</label>
        <input
          type="date" value={filters.from}
          onChange={(e) => setFilters({ ...filters, from: e.target.value })}
          className="text-xs rounded-lg px-2 py-1.5"
          style={{ background: 'var(--bg)', border: '1px solid var(--border)', color: 'var(--text-pri)' }}
        />
      </div>

      {/* Au */}
      <div className="flex flex-col gap-1">
        <label className="text-[11px]" style={{ color: 'var(--text-ter)' }}>Au</label>
        <input
          type="date" value={filters.to}
          onChange={(e) => setFilters({ ...filters, to: e.target.value })}
          className="text-xs rounded-lg px-2 py-1.5"
          style={{ background: 'var(--bg)', border: '1px solid var(--border)', color: 'var(--text-pri)' }}
        />
      </div>

      <div className="flex gap-2 ml-auto">
        {hasFilters && (
          <button
            onClick={() => setFilters({ action: '', entity: '', username: '', from: '', to: '' })}
            className="focus-ring flex items-center gap-1 text-xs px-3 py-1.5 rounded-lg transition-colors"
            style={{ background: 'rgba(239,68,68,0.08)', border: '1px solid rgba(239,68,68,0.25)', color: 'var(--accent-err)' }}
          >
            <X size={11} /> Réinitialiser
          </button>
        )}
        <button
          onClick={onExport}
          disabled={loading}
          className="focus-ring flex items-center gap-1.5 text-xs px-3 py-1.5 rounded-lg font-medium transition-colors"
          style={{ background: 'rgba(34,211,238,0.08)', border: '1px solid rgba(34,211,238,0.25)', color: 'var(--accent)' }}
        >
          <Download size={12} /> Exporter CSV
        </button>
      </div>
    </div>
  );
}

/* ── Page principale ────────────────────────────────────────────────── */
export default function JournalPage() {
  const { t } = useTranslation();
  const [tab, setTab] = useState<Tab>('history');
  const [logs, setLogs] = useState<AuditLog[]>([]);
  const [connections, setConnections] = useState<ConnectionLog[]>([]);
  const [emails, setEmails] = useState<EmailLog[]>([]);
  const [whatsapp, setWhatsapp] = useState<WhatsAppLog[]>([]);
  const [summary, setSummary] = useState<AuditSummary | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Filtres audit
  const [filters, setFilters] = useState<AuditFilters>({ action: '', entity: '', username: '', from: '', to: '' });
  const [auditUsers, setAuditUsers] = useState<{ username: string }[]>([]);
  const [auditEntities, setAuditEntities] = useState<string[]>([]);

  // Pagination
  const [offset, setOffset] = useState(0);
  const LIMIT = 50;

  // Charger les utilisateurs et entités disponibles pour les filtres
  useEffect(() => {
    api.get<{ users: { username: string }[] }>('/audit-logs/users')
      .then((r) => setAuditUsers(r.users))
      .catch(() => {});
    // Entités statiques connues
    setAuditEntities(['lignes', 'lignes-fixes', 'factures', 'users', 'calendar', 'settings', 'corrections', 'trash']);
  }, []);

  const buildAuditQS = useCallback((f: AuditFilters, off: number) => {
    const p = new URLSearchParams({ limit: String(LIMIT), offset: String(off) });
    if (f.action) p.set('action', f.action);
    if (f.entity) p.set('entity', f.entity);
    if (f.username) {
      const found = auditUsers.find((u) => u.username === f.username);
      if (found) p.set('userId', String((found as { userId?: number }).userId ?? ''));
    }
    if (f.from) p.set('from', f.from);
    if (f.to) p.set('to', `${f.to}T23:59:59`);
    return p.toString();
  }, [auditUsers]);

  useEffect(() => {
    setOffset(0);
  }, [filters]);

  useEffect(() => {
    setLoading(true);
    setError(null);

    if (tab === 'history') {
      api.get<{ logs: AuditLog[] }>(`/audit-logs?${buildAuditQS(filters, offset)}`)
        .then((r) => setLogs(r.logs))
        .catch((e) => setError(e instanceof ApiError ? e.message : 'Erreur'))
        .finally(() => setLoading(false));
    } else if (tab === 'connections') {
      api.get<{ logs: ConnectionLog[] }>('/connection-logs?limit=100')
        .then((r) => setConnections(r.logs))
        .catch((e) => setError(e instanceof ApiError ? e.message : 'Erreur'))
        .finally(() => setLoading(false));
    } else if (tab === 'emails') {
      api.get<{ logs: EmailLog[] }>('/email/logs?limit=100')
        .then((r) => setEmails(r.logs))
        .catch((e) => setError(e instanceof ApiError ? e.message : 'Erreur'))
        .finally(() => setLoading(false));
    } else if (tab === 'whatsapp') {
      api.get<{ logs: WhatsAppLog[] }>('/whatsapp/logs?limit=100')
        .then((r) => setWhatsapp(r.logs))
        .catch((e) => setError(e instanceof ApiError ? e.message : 'Erreur'))
        .finally(() => setLoading(false));
    } else if (tab === 'analytics') {
      Promise.all([
        api.get<AuditSummary>('/audit-logs/summary'),
      ]).then(([s]) => {
        setSummary(s);
      }).catch((e) => setError(e instanceof ApiError ? e.message : 'Erreur'))
        .finally(() => setLoading(false));
    }
  }, [tab, filters, offset, buildAuditQS]);

  const handleExportCSV = () => {
    const p = new URLSearchParams();
    if (filters.action) p.set('action', filters.action);
    if (filters.entity) p.set('entity', filters.entity);
    if (filters.from) p.set('from', filters.from);
    if (filters.to) p.set('to', `${filters.to}T23:59:59`);
    const url = `${API_BASE}/audit-logs/export?${p.toString()}`;
    const a = document.createElement('a');
    a.href = url;
    a.download = '';
    a.click();
  };

  /* ── Rendu ────────────────────────────────────────────────────────── */
  return (
    <div>
      <PageHeader
        eyebrow={t('journal.eyebrow')}
        title={t('journal.title')}
        description={t('journal.description')}
      />

      <TabBar tab={tab} setTab={setTab} />

      {error && (
        <p className="text-sm rounded-lg px-3 py-2 mb-4" style={{ color: 'var(--accent-err)', background: 'rgba(239,68,68,0.08)', border: '1px solid rgba(239,68,68,0.2)' }}>
          {error}
        </p>
      )}

      {/* ── Onglet : Historique des actions ─────────────────────────── */}
      {tab === 'history' && (
        <>
          <FilterPanel
            filters={filters}
            setFilters={setFilters}
            users={auditUsers}
            entities={auditEntities}
            onExport={handleExportCSV}
            loading={loading}
          />
          <Card className="overflow-hidden">
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr style={{ borderBottom: '1px solid var(--border)', background: 'var(--bg)' }}>
                    {['Date', 'Utilisateur', 'Rôle', 'Action', 'Ressource', 'Chemin', 'Statut', 'IP'].map((h) => (
                      <th key={h} className="px-3 py-3 text-left text-xs font-semibold uppercase tracking-wide"
                        style={{ color: 'var(--text-ter)', whiteSpace: 'nowrap' }}>
                        {h}
                      </th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {logs.map((log) => (
                    <tr key={log.id} className="transition-colors hover:bg-[var(--card-hover)]"
                      style={{ borderBottom: '1px solid var(--border)' }}>
                      <td className="px-3 py-2.5 whitespace-nowrap text-xs" style={{ color: 'var(--text-ter)' }}>
                        {new Date(log.createdAt).toLocaleString('fr-FR')}
                      </td>
                      <td className="px-3 py-2.5 font-medium text-sm" style={{ color: 'var(--text-pri)' }}>
                        {log.username ?? 'Système'}
                      </td>
                      <td className="px-3 py-2.5 text-xs" style={{ color: 'var(--text-ter)' }}>
                        {log.role ?? '—'}
                      </td>
                      <td className="px-3 py-2.5">
                        <span
                          className="inline-flex items-center rounded-full px-2 py-0.5 text-xs font-semibold"
                          style={{
                            background: `${ACTION_COLORS[log.action] ?? '#94a3b8'}20`,
                            color: ACTION_COLORS[log.action] ?? '#94a3b8',
                            border: `1px solid ${ACTION_COLORS[log.action] ?? '#94a3b8'}40`
                          }}
                        >
                          {ACTION_LABELS[log.action] ?? log.action}
                        </span>
                      </td>
                      <td className="px-3 py-2.5 font-mono text-xs" style={{ color: 'var(--accent)' }}>
                        {log.entity}{log.entityId ? ` #${log.entityId}` : ''}
                      </td>
                      <td className="px-3 py-2.5 text-xs max-w-xs truncate" style={{ color: 'var(--text-sec)' }}>
                        {log.method} {log.path}
                      </td>
                      <td className="px-3 py-2.5">
                        <Badge tone={log.statusCode < 400 ? 'good' : 'bad'}>{log.statusCode}</Badge>
                      </td>
                      <td className="px-3 py-2.5 font-mono text-xs" style={{ color: 'var(--text-ter)' }}>
                        {log.ipAddress ?? '—'}
                      </td>
                    </tr>
                  ))}
                  {!loading && logs.length === 0 && (
                    <tr><td colSpan={8} className="px-4 py-10 text-center text-sm" style={{ color: 'var(--text-ter)' }}>
                      Aucune action correspondant aux filtres.
                    </td></tr>
                  )}
                </tbody>
              </table>
            </div>

            {/* Pagination */}
            <div className="flex items-center justify-between px-4 py-3" style={{ borderTop: '1px solid var(--border)' }}>
              <span className="text-xs" style={{ color: 'var(--text-ter)' }}>
                {offset + 1} – {offset + logs.length}
              </span>
              <div className="flex gap-2">
                <button
                  disabled={offset === 0}
                  onClick={() => setOffset(Math.max(0, offset - LIMIT))}
                  className="focus-ring text-xs px-3 py-1.5 rounded-lg disabled:opacity-40 transition-colors"
                  style={{ background: 'var(--glass-bg)', border: '1px solid var(--border)', color: 'var(--text-sec)' }}
                >
                  ← Précédent
                </button>
                <button
                  disabled={logs.length < LIMIT}
                  onClick={() => setOffset(offset + LIMIT)}
                  className="focus-ring text-xs px-3 py-1.5 rounded-lg disabled:opacity-40 transition-colors"
                  style={{ background: 'var(--glass-bg)', border: '1px solid var(--border)', color: 'var(--text-sec)' }}
                >
                  Suivant →
                </button>
              </div>
            </div>
          </Card>
        </>
      )}

      {/* ── Onglet : Connexions ─────────────────────────────────────── */}
      {tab === 'connections' && (
        <Card className="overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr style={{ borderBottom: '1px solid var(--border)', background: 'var(--bg)' }}>
                  {['Date', 'Utilisateur', 'Résultat', 'Détail', 'Adresse IP'].map((h) => (
                    <th key={h} className="px-3 py-3 text-left text-xs font-semibold uppercase tracking-wide"
                      style={{ color: 'var(--text-ter)' }}>{h}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {connections.map((c) => (
                  <tr key={c.id} className="transition-colors hover:bg-[var(--card-hover)]"
                    style={{ borderBottom: '1px solid var(--border)' }}>
                    <td className="px-3 py-2.5 whitespace-nowrap text-xs" style={{ color: 'var(--text-ter)' }}>
                      {new Date(c.createdAt).toLocaleString('fr-FR')}
                    </td>
                    <td className="px-3 py-2.5 font-medium" style={{ color: 'var(--text-pri)' }}>{c.username}</td>
                    <td className="px-3 py-2.5">
                      <Badge tone={c.success ? 'good' : 'bad'}>{c.success ? 'Réussie' : 'Échouée'}</Badge>
                    </td>
                    <td className="px-3 py-2.5 text-xs" style={{ color: 'var(--text-sec)' }}>
                      {c.reason ? REASON_LABELS[c.reason] ?? c.reason : '—'}
                    </td>
                    <td className="px-3 py-2.5 font-mono text-xs" style={{ color: 'var(--text-ter)' }}>{c.ipAddress ?? '—'}</td>
                  </tr>
                ))}
                {!loading && connections.length === 0 && (
                  <tr><td colSpan={5} className="px-4 py-10 text-center text-sm" style={{ color: 'var(--text-ter)' }}>
                    Aucune connexion enregistrée.
                  </td></tr>
                )}
              </tbody>
            </table>
          </div>
        </Card>
      )}

      {/* ── Onglet : E-mails ────────────────────────────────────────── */}
      {tab === 'emails' && (
        <Card className="overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr style={{ borderBottom: '1px solid var(--border)', background: 'var(--bg)' }}>
                  {['Date', 'Destinataire', 'Sujet', 'Type', 'Envoyé par', 'Résultat'].map((h) => (
                    <th key={h} className="px-3 py-3 text-left text-xs font-semibold uppercase tracking-wide"
                      style={{ color: 'var(--text-ter)' }}>{h}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {emails.map((e) => (
                  <tr key={e.id} className="transition-colors hover:bg-[var(--card-hover)]"
                    style={{ borderBottom: '1px solid var(--border)' }}>
                    <td className="px-3 py-2.5 whitespace-nowrap text-xs" style={{ color: 'var(--text-ter)' }}>
                      {new Date(e.createdAt).toLocaleString('fr-FR')}
                    </td>
                    <td className="px-3 py-2.5 font-medium text-sm" style={{ color: 'var(--text-pri)' }}>{e.toAddress}</td>
                    <td className="px-3 py-2.5 text-xs max-w-xs truncate" style={{ color: 'var(--text-sec)' }}>{e.subject}</td>
                    <td className="px-3 py-2.5"><Badge>{EMAIL_KIND_LABELS[e.kind] ?? e.kind}</Badge></td>
                    <td className="px-3 py-2.5 text-xs" style={{ color: 'var(--text-ter)' }}>{e.sentBy ?? '—'}</td>
                    <td className="px-3 py-2.5">
                      <span title={e.error ?? undefined}>
                        <Badge tone={e.success ? 'good' : 'bad'}>{e.success ? 'Envoyé' : 'Échec'}</Badge>
                      </span>
                    </td>
                  </tr>
                ))}
                {!loading && emails.length === 0 && (
                  <tr><td colSpan={6} className="px-4 py-10 text-center text-sm" style={{ color: 'var(--text-ter)' }}>
                    Aucun e-mail envoyé pour le moment.
                  </td></tr>
                )}
              </tbody>
            </table>
          </div>
        </Card>
      )}

      {/* ── Onglet : WhatsApp ───────────────────────────────────────── */}
      {tab === 'whatsapp' && (
        <Card className="overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr style={{ borderBottom: '1px solid var(--border)', background: 'var(--bg)' }}>
                  {['Date', 'Numéro', 'Message', 'Type', 'Envoyé par', 'Statut'].map((h) => (
                    <th key={h} className="px-3 py-3 text-left text-xs font-semibold uppercase tracking-wide"
                      style={{ color: 'var(--text-ter)' }}>{h}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {whatsapp.map((w) => (
                  <tr key={w.id} className="transition-colors hover:bg-[var(--card-hover)]"
                    style={{ borderBottom: '1px solid var(--border)' }}>
                    <td className="px-3 py-2.5 whitespace-nowrap text-xs" style={{ color: 'var(--text-ter)' }}>
                      {new Date(w.sentAt).toLocaleString('fr-FR')}
                    </td>
                    <td className="px-3 py-2.5 font-mono text-sm font-medium" style={{ color: 'var(--text-pri)' }}>{w.toPhone}</td>
                    <td className="px-3 py-2.5 text-xs max-w-xs truncate" style={{ color: 'var(--text-sec)' }}>{w.message}</td>
                    <td className="px-3 py-2.5"><Badge>{EMAIL_KIND_LABELS[w.kind] ?? w.kind}</Badge></td>
                    <td className="px-3 py-2.5 text-xs" style={{ color: 'var(--text-ter)' }}>{w.sentBy ?? '—'}</td>
                    <td className="px-3 py-2.5">
                      <span title={w.error ?? undefined}>
                        <Badge tone={w.status === 'failed' ? 'bad' : w.status === 'read' ? 'good' : 'default'}>
                          {WHATSAPP_STATUS_LABELS[w.status] ?? w.status}
                        </Badge>
                      </span>
                    </td>
                  </tr>
                ))}
                {!loading && whatsapp.length === 0 && (
                  <tr><td colSpan={6} className="px-4 py-10 text-center text-sm" style={{ color: 'var(--text-ter)' }}>
                    Aucun message WhatsApp envoyé pour le moment.
                  </td></tr>
                )}
              </tbody>
            </table>
          </div>
        </Card>
      )}

      {/* ── Onglet : Analytique ─────────────────────────────────────── */}
      {tab === 'analytics' && summary && (
        <div className="space-y-5">
          {/* KPI cards */}
          <div className="grid grid-cols-2 gap-4 sm:grid-cols-4">
            {[
              { label: 'Actions (30j)', value: summary.totalActions.toLocaleString('fr-FR'), icon: Activity, color: '#22d3ee' },
              { label: 'Taux d\'erreurs', value: `${summary.errorRate.toFixed(1)} %`, icon: AlertTriangle, color: 'var(--accent-err)' },
              { label: 'Top utilisateur', value: summary.topUsers[0]?.username ?? '—', icon: Users, color: '#a855f7' },
              { label: 'Ressource active', value: summary.topEntities[0]?.entity ?? '—', icon: TrendingUp, color: 'var(--accent2)' },
            ].map((kpi) => (
              <div key={kpi.label} className="rounded-xl p-4 flex items-center gap-3"
                style={{ background: 'var(--glass-bg)', border: '1px solid var(--border)' }}>
                <span className="rounded-lg p-2" style={{ background: `${kpi.color}18`, border: `1px solid ${kpi.color}40` }}>
                  <kpi.icon size={16} style={{ color: kpi.color }} />
                </span>
                <div>
                  <p className="text-xs" style={{ color: 'var(--text-ter)' }}>{kpi.label}</p>
                  <p className="text-sm font-bold truncate max-w-[100px]" style={{ color: 'var(--text-pri)' }}>{kpi.value}</p>
                </div>
              </div>
            ))}
          </div>

          <div className="grid grid-cols-1 gap-5 lg:grid-cols-2">
            {/* Répartition par action */}
            <div className="rounded-2xl p-4" style={{ background: 'var(--glass-bg)', border: '1px solid var(--border)' }}>
              <p className="text-sm font-semibold mb-3" style={{ color: 'var(--text-pri)' }}>Actions par type (30 derniers jours)</p>
              <ResponsiveContainer width="100%" height={200}>
                <BarChart data={summary.byAction}>
                  <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.06)" />
                  <XAxis dataKey="action" tick={{ fill: 'var(--text-ter)', fontSize: 12 }}
                    tickFormatter={(v) => ACTION_LABELS[v] ?? v} />
                  <YAxis tick={{ fill: 'var(--text-ter)', fontSize: 11 }} />
                  <Tooltip
                    contentStyle={{ background: 'var(--surface)', border: '1px solid var(--border)', borderRadius: 10 }}
                    labelStyle={{ color: 'var(--text-pri)' }}
                    itemStyle={{ color: 'var(--text-sec)' }}
                    formatter={(v, _n, p) =>
                      [Number(v), ACTION_LABELS[(p as { payload?: { action?: string } }).payload?.action ?? ''] ?? (p as { payload?: { action?: string } }).payload?.action ?? '']}
                  />
                  <Bar dataKey="value" radius={[6, 6, 0, 0]}>
                    {summary.byAction.map((entry) => (
                      <Cell key={entry.action} fill={ACTION_COLORS[entry.action] ?? '#a855f7'} />
                    ))}
                  </Bar>
                </BarChart>
              </ResponsiveContainer>
            </div>

            {/* Top ressources */}
            <div className="rounded-2xl p-4" style={{ background: 'var(--glass-bg)', border: '1px solid var(--border)' }}>
              <p className="text-sm font-semibold mb-3" style={{ color: 'var(--text-pri)' }}>Ressources les plus modifiées</p>
              <ResponsiveContainer width="100%" height={200}>
                <PieChart>
                  <Pie
                    data={summary.topEntities}
                    dataKey="value"
                    nameKey="entity"
                    cx="50%" cy="50%" outerRadius={75} label={(props) => {
                      const entry = summary.topEntities[props.index ?? 0];
                      const pct = ((props.percent ?? 0) * 100).toFixed(0);
                      return `${entry?.entity ?? ''} (${pct}%)`;
                    }}
                    labelLine={{ stroke: 'var(--text-ter)' }}
                  >
                    {summary.topEntities.map((_, i) => (
                      <Cell key={i} fill={PIE_COLORS[i % PIE_COLORS.length]} />
                    ))}
                  </Pie>
                  <Tooltip
                    contentStyle={{ background: 'var(--surface)', border: '1px solid var(--border)', borderRadius: 10 }}
                    itemStyle={{ color: 'var(--text-sec)' }}
                  />
                </PieChart>
              </ResponsiveContainer>
            </div>

            {/* Activité par heure */}
            <div className="rounded-2xl p-4" style={{ background: 'var(--glass-bg)', border: '1px solid var(--border)' }}>
              <p className="text-sm font-semibold mb-3" style={{ color: 'var(--text-pri)' }}>Activité par heure de la journée</p>
              <ResponsiveContainer width="100%" height={200}>
                <LineChart data={
                  Array.from({ length: 24 }, (_, h) => ({
                    hour: h,
                    value: summary.byHour.find((r) => r.hour === h)?.value ?? 0
                  }))
                }>
                  <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.06)" />
                  <XAxis dataKey="hour" tick={{ fill: 'var(--text-ter)', fontSize: 11 }}
                    tickFormatter={(h: number) => `${h}h`} />
                  <YAxis tick={{ fill: 'var(--text-ter)', fontSize: 11 }} />
                  <Tooltip
                    contentStyle={{ background: 'var(--surface)', border: '1px solid var(--border)', borderRadius: 10 }}
                    labelStyle={{ color: 'var(--text-pri)' }}
                    labelFormatter={(h) => `${Number(h)}h00`}
                    itemStyle={{ color: 'var(--text-sec)' }}
                  />
                  <Line type="monotone" dataKey="value" stroke="#a855f7" strokeWidth={2}
                    dot={false} activeDot={{ r: 4, fill: '#a855f7' }} />
                </LineChart>
              </ResponsiveContainer>
            </div>

            {/* Top utilisateurs */}
            <div className="rounded-2xl p-4" style={{ background: 'var(--glass-bg)', border: '1px solid var(--border)' }}>
              <p className="text-sm font-semibold mb-3" style={{ color: 'var(--text-pri)' }}>Top 10 utilisateurs les plus actifs</p>
              <div className="space-y-2">
                {summary.topUsers.map((u, i) => (
                  <div key={u.username} className="flex items-center gap-3">
                    <span className="text-xs font-mono shrink-0 w-5 text-right" style={{ color: 'var(--text-ter)' }}>
                      #{i + 1}
                    </span>
                    <div className="flex-1 rounded-full overflow-hidden h-5 relative"
                      style={{ background: 'var(--bg)' }}>
                      <div
                        className="h-full rounded-full flex items-center pl-2 transition-all"
                        style={{
                          width: `${Math.max(5, (u.value / (summary.topUsers[0]?.value ?? 1)) * 100)}%`,
                          background: `${PIE_COLORS[i % PIE_COLORS.length]}40`,
                          borderRight: `2px solid ${PIE_COLORS[i % PIE_COLORS.length]}`
                        }}
                      >
                        <span className="text-xs font-medium truncate" style={{ color: 'var(--text-pri)' }}>
                          {u.username}
                        </span>
                      </div>
                    </div>
                    <span className="text-xs font-bold shrink-0" style={{ color: PIE_COLORS[i % PIE_COLORS.length] }}>
                      {u.value.toLocaleString('fr-FR')}
                    </span>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>
      )}

      {tab === 'analytics' && !summary && !loading && (
        <p className="text-sm text-center py-10" style={{ color: 'var(--text-ter)' }}>
          Aucune donnée analytique disponible.
        </p>
      )}
    </div>
  );
}
