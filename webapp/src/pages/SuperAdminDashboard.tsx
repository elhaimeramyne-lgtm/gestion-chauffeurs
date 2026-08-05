import { useEffect, useState } from 'react';
import {
  Users, ShieldCheck, Smartphone, Landmark, Receipt, AlertCircle,
  TrendingUp, TrendingDown, AlertTriangle, Info, Wallet
} from 'lucide-react';
import {
  ResponsiveContainer, BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip,
  PieChart, Pie, Cell, LineChart, Line, AreaChart, Area
} from 'recharts';
import { useTranslation } from 'react-i18next';
import { api, ApiError } from '../lib/api';
import { PageHeader, Card, StatCard, Badge } from '../components/ui/Kit';
import { ROLE_LABELS } from '../lib/navItems';
import { useCountUp } from '../lib/useCountUp';

interface DashboardStats {
  users: { total: number; admins: number; active: number; byRole: { role: string; value: number }[] };
  lignes: { mobiles: number; fixes: number; actives: number; byCategorie: { categorie: string; value: number }[] };
  factures: { total: number; reglees: number; impayees: number; montantImpaye: number };
  monthComparison: { currentMonthTotal: number; previousMonthTotal: number; deltaPct: number | null };
  monthlyTrend: { month: string; montant: number; count: number }[];
  topDirections: { direction: string; montant: number; count: number }[];
  alerts: { level: 'critical' | 'warning' | 'info'; message: string }[];
  activityByDay: { day: string; value: number }[];
  recentActivity: Array<{
    id: number;
    username: string | null;
    action: string;
    entity: string;
    entityId: string | null;
    statusCode: number;
    createdAt: string;
  }>;
}

const ROLE_COLORS: Record<string, string> = {
  SUPER_ADMIN: '#ec4899',
  ADMIN: '#a855f7',
  USER: '#22d3ee'
};

const ACTION_LABELS: Record<string, string> = {
  create: 'Création',
  update: 'Modification',
  delete: 'Suppression'
};

const ALERT_STYLES: Record<string, { icon: typeof AlertTriangle; color: string; bg: string; border: string }> = {
  critical: { icon: AlertTriangle, color: 'var(--accent-err)', bg: 'rgba(239,68,68,0.08)', border: 'rgba(239,68,68,0.25)' },
  warning: { icon: AlertCircle, color: 'var(--accent-warn)', bg: 'rgba(245,158,11,0.08)', border: 'rgba(245,158,11,0.25)' },
  info: { icon: Info, color: '#22d3ee', bg: 'rgba(34,211,238,0.08)', border: 'rgba(34,211,238,0.25)' }
};

function formatDay(day: string): string {
  const d = new Date(`${day}T00:00:00`);
  return d.toLocaleDateString('fr-FR', { day: '2-digit', month: 'short' });
}

function formatMonth(month: string): string {
  const d = new Date(`${month}-01T00:00:00`);
  return d.toLocaleDateString('fr-FR', { month: 'short', year: '2-digit' });
}

function formatDH(n: number): string {
  return `${Math.round(n).toLocaleString('fr-FR')} DH`;
}

function AnimatedValue({ value, format }: { value: number; format?: (n: number) => string }) {
  const animated = useCountUp(value);
  return <>{format ? format(animated) : animated.toLocaleString('fr-FR')}</>;
}

export default function SuperAdminDashboard() {
  const { t } = useTranslation();
  const [stats, setStats] = useState<DashboardStats | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    api
      .get<DashboardStats>('/dashboard/stats')
      .then(setStats)
      .catch((err) => setError(err instanceof ApiError ? err.message : 'Erreur de chargement.'))
      .finally(() => setLoading(false));
  }, []);

  if (loading) {
    return (
      <div>
        <PageHeader eyebrow={t('dashboard.eyebrow')} title={t('dashboard.title')} />
        <p className="text-sm text-ink-400">Chargement des statistiques…</p>
      </div>
    );
  }

  if (error || !stats) {
    return (
      <div>
        <PageHeader eyebrow={t('dashboard.eyebrow')} title={t('dashboard.title')} />
        <p className="text-sm text-signal-roseDark bg-signal-rose/10 rounded-lg px-3 py-2">
          {error ?? 'Impossible de charger les statistiques.'}
        </p>
      </div>
    );
  }

  const activityData = stats.activityByDay.map((a) => ({ ...a, label: formatDay(a.day) }));
  const roleData = stats.users.byRole.map((r) => ({
    name: ROLE_LABELS[r.role] ?? r.role,
    value: r.value,
    color: ROLE_COLORS[r.role] ?? '#6366f1'
  }));
  const trendData = stats.monthlyTrend.map((m) => ({ ...m, label: formatMonth(m.month) }));
  const directionsData = [...stats.topDirections].reverse();

  const delta = stats.monthComparison.deltaPct;
  const deltaUp = delta !== null && delta >= 0;

  return (
    <div>
      <PageHeader
        eyebrow={t('dashboard.eyebrow')}
        title={t('dashboard.title')}
        description={t('dashboard.description')}
      />

      {stats.alerts.length > 0 && (
        <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-3 mb-6">
          {stats.alerts.map((a, i) => {
            const style = ALERT_STYLES[a.level];
            const Icon = style.icon;
            return (
              <div
                key={i}
                className="flex items-start gap-2.5 rounded-2xl px-4 py-3 text-sm"
                style={{ background: style.bg, border: `1px solid ${style.border}`, color: 'var(--text-pri)' }}
              >
                <Icon size={16} style={{ color: style.color, flexShrink: 0, marginTop: 2 }} />
                <span>{a.message}</span>
              </div>
            );
          })}
        </div>
      )}

      <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-3 mb-4 stagger">
        <StatCard label={t('dashboard.users')} value={<AnimatedValue value={stats.users.total} />} icon={<Users size={15} />} />
        <StatCard label={t('dashboard.admins')} value={<AnimatedValue value={stats.users.admins} />} icon={<ShieldCheck size={15} />} />
        <StatCard label={t('dashboard.activeLignes')} value={<AnimatedValue value={stats.lignes.actives} />} icon={<Smartphone size={15} />} />
        <StatCard label={t('dashboard.lignesFixes')} value={<AnimatedValue value={stats.lignes.fixes} />} icon={<Landmark size={15} />} />
        <StatCard label={t('dashboard.factures')} value={<AnimatedValue value={stats.factures.total} />} icon={<Receipt size={15} />} />
        <StatCard
          label={t('dashboard.impayees')}
          value={<AnimatedValue value={stats.factures.impayees} />}
          tone={stats.factures.impayees > 0 ? 'bad' : 'good'}
          icon={<AlertCircle size={15} />}
        />
      </div>

      <div className="grid sm:grid-cols-2 gap-3 mb-7">
        <Card className="p-5 flex items-center justify-between">
          <div>
            <p className="text-xs font-mono uppercase tracking-widest mb-2" style={{ color: 'var(--text-ter)' }}>
              {t('dashboard.monthSpending')}
            </p>
            <p className="text-2xl font-bold" style={{ color: 'var(--text-pri)' }}>
              <AnimatedValue value={stats.monthComparison.currentMonthTotal} format={formatDH} />
            </p>
          </div>
          <span
            className="flex items-center justify-center rounded-xl shrink-0"
            style={{ width: 40, height: 40, background: 'linear-gradient(135deg, rgba(34,211,238,0.16) 0%, rgba(168,85,247,0.20) 100%)', border: '1px solid rgba(168,85,247,0.22)', color: 'var(--accent)' }}
          >
            <Wallet size={18} />
          </span>
        </Card>
        <Card className="p-5 flex items-center justify-between">
          <div>
            <p className="text-xs font-mono uppercase tracking-widest mb-2" style={{ color: 'var(--text-ter)' }}>
              {t('dashboard.monthComparison')}
            </p>
            {delta === null ? (
              <p className="text-sm" style={{ color: 'var(--text-sec)' }}>{t('dashboard.noDataLastMonth')}</p>
            ) : (
              <p className="text-2xl font-bold flex items-center gap-1.5" style={{ color: deltaUp ? 'var(--accent-err)' : 'var(--accent2)' }}>
                {deltaUp ? <TrendingUp size={18} /> : <TrendingDown size={18} />}
                {Math.abs(delta).toFixed(1)}%
              </p>
            )}
          </div>
        </Card>
      </div>

      {stats.factures.total === 0 && (
        <p className="text-xs text-ink-400 mb-6">
          {t('dashboard.noComparisonYet')}
        </p>
      )}

      <div className="grid lg:grid-cols-3 gap-4 mb-4">
        <Card className="lg:col-span-2 p-5">
          <p className="text-xs font-mono uppercase tracking-widest mb-4" style={{ color: 'var(--text-ter)' }}>
            {t('dashboard.activityChart')}
          </p>
          <ResponsiveContainer width="100%" height={220}>
            <LineChart data={activityData}>
              <defs>
                <linearGradient id="lineGlow" x1="0" y1="0" x2="1" y2="0">
                  <stop offset="0%" stopColor="#22d3ee" />
                  <stop offset="100%" stopColor="#a855f7" />
                </linearGradient>
              </defs>
              <CartesianGrid strokeDasharray="3 3" stroke="var(--border)" />
              <XAxis dataKey="label" tick={{ fontSize: 11, fill: 'var(--text-ter)' }} />
              <YAxis allowDecimals={false} tick={{ fontSize: 11, fill: 'var(--text-ter)' }} />
              <Tooltip
                contentStyle={{ background: 'var(--card)', border: '1px solid var(--border)', borderRadius: 8, fontSize: 12 }}
              />
              <Line
                type="monotone"
                dataKey="value"
                name="Actions"
                stroke="url(#lineGlow)"
                strokeWidth={3}
                dot={{ r: 3, fill: '#a855f7', strokeWidth: 0 }}
                activeDot={{ r: 5 }}
                isAnimationActive
              />
            </LineChart>
          </ResponsiveContainer>
        </Card>

        <Card className="p-5">
          <p className="text-xs font-mono uppercase tracking-widest mb-4" style={{ color: 'var(--text-ter)' }}>
            {t('dashboard.rolesChart')}
          </p>
          <ResponsiveContainer width="100%" height={220}>
            <PieChart>
              <defs>
                {roleData.map((entry, i) => (
                  <linearGradient key={entry.name} id={`roleGrad-${i}`} x1="0" y1="0" x2="1" y2="1">
                    <stop offset="0%" stopColor={entry.color} stopOpacity={0.95} />
                    <stop offset="100%" stopColor={entry.color} stopOpacity={0.55} />
                  </linearGradient>
                ))}
              </defs>
              <Pie data={roleData} dataKey="value" nameKey="name" innerRadius={45} outerRadius={75} paddingAngle={4} stroke="none" isAnimationActive>
                {roleData.map((entry, i) => (
                  <Cell key={entry.name} fill={`url(#roleGrad-${i})`} />
                ))}
              </Pie>
              <Tooltip
                contentStyle={{ background: 'var(--card)', border: '1px solid var(--border)', borderRadius: 8, fontSize: 12 }}
              />
            </PieChart>
          </ResponsiveContainer>
          <div className="flex flex-wrap gap-2 mt-2 justify-center">
            {roleData.map((r) => (
              <span key={r.name} className="flex items-center gap-1.5 text-xs" style={{ color: 'var(--text-sec)' }}>
                <span className="w-2 h-2 rounded-full" style={{ background: r.color }} />
                {r.name} ({r.value})
              </span>
            ))}
          </div>
        </Card>
      </div>

      <div className="grid lg:grid-cols-3 gap-4 mb-4">
        <Card className="lg:col-span-2 p-5">
          <p className="text-xs font-mono uppercase tracking-widest mb-4" style={{ color: 'var(--text-ter)' }}>
            {t('dashboard.trendChart')}
          </p>
          {trendData.length === 0 ? (
            <p className="text-sm py-10 text-center" style={{ color: 'var(--text-ter)' }}>Pas encore de données.</p>
          ) : (
            <ResponsiveContainer width="100%" height={220}>
              <AreaChart data={trendData}>
                <defs>
                  <linearGradient id="trendFill" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="0%" stopColor="#a855f7" stopOpacity={0.4} />
                    <stop offset="100%" stopColor="#a855f7" stopOpacity={0} />
                  </linearGradient>
                  <linearGradient id="trendLine" x1="0" y1="0" x2="1" y2="0">
                    <stop offset="0%" stopColor="#22d3ee" />
                    <stop offset="100%" stopColor="#ec4899" />
                  </linearGradient>
                </defs>
                <CartesianGrid strokeDasharray="3 3" stroke="var(--border)" />
                <XAxis dataKey="label" tick={{ fontSize: 11, fill: 'var(--text-ter)' }} />
                <YAxis tick={{ fontSize: 11, fill: 'var(--text-ter)' }} tickFormatter={(v) => `${(v / 1000).toFixed(0)}k`} />
                <Tooltip
                  formatter={(v) => formatDH(Number(v))}
                  contentStyle={{ background: 'var(--card)', border: '1px solid var(--border)', borderRadius: 8, fontSize: 12 }}
                />
                <Area type="monotone" dataKey="montant" name="Montant" stroke="url(#trendLine)" strokeWidth={3} fill="url(#trendFill)" isAnimationActive />
              </AreaChart>
            </ResponsiveContainer>
          )}
        </Card>

        <Card className="p-5">
          <p className="text-xs font-mono uppercase tracking-widest mb-4" style={{ color: 'var(--text-ter)' }}>
            {t('dashboard.directionsChart')}
          </p>
          {directionsData.length === 0 ? (
            <p className="text-sm py-10 text-center" style={{ color: 'var(--text-ter)' }}>Pas encore de données.</p>
          ) : (
            <ResponsiveContainer width="100%" height={Math.max(220, directionsData.length * 28)}>
              <BarChart data={directionsData} layout="vertical" margin={{ left: 8 }}>
                <defs>
                  <linearGradient id="dirGrad" x1="0" y1="0" x2="1" y2="0">
                    <stop offset="0%" stopColor="#22d3ee" />
                    <stop offset="100%" stopColor="#ec4899" />
                  </linearGradient>
                </defs>
                <XAxis type="number" tick={{ fontSize: 10, fill: 'var(--text-ter)' }} tickFormatter={(v) => `${(v / 1000).toFixed(0)}k`} />
                <YAxis type="category" dataKey="direction" width={110} tick={{ fontSize: 11, fill: 'var(--text-sec)' }} />
                <Tooltip
                  formatter={(v) => formatDH(Number(v))}
                  contentStyle={{ background: 'var(--card)', border: '1px solid var(--border)', borderRadius: 8, fontSize: 12 }}
                />
                <Bar dataKey="montant" name="Montant" fill="url(#dirGrad)" radius={[0, 8, 8, 0]} isAnimationActive />
              </BarChart>
            </ResponsiveContainer>
          )}
        </Card>
      </div>

      {stats.lignes.byCategorie.length > 0 && (
        <Card className="p-5 mb-7">
          <p className="text-xs font-mono uppercase tracking-widest mb-4" style={{ color: 'var(--text-ter)' }}>
            {t('dashboard.categorieChart')}
          </p>
          <ResponsiveContainer width="100%" height={200}>
            <BarChart data={stats.lignes.byCategorie}>
              <defs>
                <linearGradient id="barGrad" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="0%" stopColor="#22d3ee" />
                  <stop offset="100%" stopColor="#a855f7" />
                </linearGradient>
              </defs>
              <CartesianGrid strokeDasharray="3 3" stroke="var(--border)" />
              <XAxis dataKey="categorie" tick={{ fontSize: 11, fill: 'var(--text-ter)' }} />
              <YAxis allowDecimals={false} tick={{ fontSize: 11, fill: 'var(--text-ter)' }} />
              <Tooltip
                contentStyle={{ background: 'var(--card)', border: '1px solid var(--border)', borderRadius: 8, fontSize: 12 }}
              />
              <Bar dataKey="value" name="Lignes" fill="url(#barGrad)" radius={[8, 8, 0, 0]} isAnimationActive />
            </BarChart>
          </ResponsiveContainer>
        </Card>
      )}

      <Card className="overflow-hidden">
        <div className="px-4 py-3 border-b" style={{ borderColor: 'var(--border)' }}>
          <p className="text-xs font-mono uppercase tracking-widest" style={{ color: 'var(--text-ter)' }}>
            {t('dashboard.recentActivity')}
          </p>
        </div>
        <table className="w-full text-sm">
          <tbody>
            {stats.recentActivity.map((log) => (
              <tr key={log.id} className="border-t border-ink-50">
                <td className="px-4 py-2.5 text-ink-500 text-xs whitespace-nowrap">
                  {new Date(log.createdAt).toLocaleString('fr-FR')}
                </td>
                <td className="px-4 py-2.5 text-ink-800 font-medium">{log.username ?? 'Système'}</td>
                <td className="px-4 py-2.5">
                  <Badge tone={log.action === 'delete' ? 'bad' : log.action === 'create' ? 'good' : 'default'}>
                    {ACTION_LABELS[log.action] ?? log.action}
                  </Badge>
                </td>
                <td className="px-4 py-2.5 text-ink-600 font-mono text-xs">
                  {log.entity}
                  {log.entityId ? ` #${log.entityId}` : ''}
                </td>
              </tr>
            ))}
            {stats.recentActivity.length === 0 && (
              <tr>
                <td colSpan={4} className="px-4 py-8 text-center text-ink-400">
                  {t('dashboard.noActivity')}
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </Card>
    </div>
  );
}
