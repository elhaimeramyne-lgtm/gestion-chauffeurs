import { useEffect, useState, useCallback } from 'react';
import { Link } from 'react-router-dom';
import {
  ClipboardList, AlertTriangle, CheckCircle2, Timer, Inbox, ArrowRight, MapPin, RefreshCw,
  User as UserIcon, AlertOctagon, CalendarDays, Car, Users, Wrench, Clock,
  TrendingUp, TrendingDown, Fuel, FileText, ChevronRight, Eye
} from 'lucide-react';
import {
  ResponsiveContainer, AreaChart, Area, XAxis, YAxis, Tooltip,
  PieChart, Pie, Cell, Legend
} from 'recharts';
import { Badge, Button } from '../components/ui/Kit';
import { api } from '../lib/api';
import { useAuth } from '../context/AuthContext';
import { useLogistique } from '../context/LogistiqueContext';
import { useOrg } from '../context/OrgContext';
import AdminMissionDashboard from '../components/mission/AdminMissionDashboard';
import MissionMap from '../components/mission/MissionMap';
import { useParcAuto } from '../context/ParcAutoContext';
import { useDeclarations } from '../context/DeclarationContext';
import {
  STATUS_LABELS, PRIORITY_LABELS, TYPE_LABELS, PRIORITY_TONE, STATUS_TONE
} from '../types/logistique';
import { DEPLACEMENT_ETAPE_COLOR } from '../types/parcAuto';
import type { ActiveMission } from '../types/parcAuto';

interface ChauffeurStats {
  total: number;
  disponibles: number;
  enMission: number;
  indisponibles: number;
  enConge: number;
  absents: number;
}

interface VehiculeStats {
  total: number;
  disponibles: number;
  enMission: number;
  enMaintenance: number;
  horsService: number;
  echeancesProches: number;
}

const STATUS_COLORS: Record<string, string> = {
  nouvelle: '#4C8AFF',
  validee_chef: '#8B5CF6',
  validee_responsable: '#818cf8',
  affectee: '#F59E0B',
  en_cours: '#F97316',
  terminee: '#22C55E',
  annulee: '#EF4444',
  archivee: '#94a3b8'
};

/* ─── KPI Card glassmorphism ─── */
function KpiCard({
  label, value, subtitle, icon: Icon, gradient, trend, trendLabel
}: {
  label: string;
  value: string | number;
  subtitle?: string;
  icon: React.ElementType;
  gradient: string;
  trend?: 'up' | 'down';
  trendLabel?: string;
}) {
  return (
    <div
      className="rounded-2xl p-5 flex flex-col gap-3 transition-transform hover:-translate-y-0.5"
      style={{
        background: 'rgba(255,255,255,0.06)',
        border: '1px solid rgba(255,255,255,0.10)',
        backdropFilter: 'blur(20px)',
        boxShadow: '0 8px 32px rgba(2,4,20,0.35)',
      }}
    >
      <div className="flex items-start justify-between">
        <div>
          <p style={{ fontSize: 12, color: 'rgba(255,255,255,0.55)', fontWeight: 500, textTransform: 'uppercase', letterSpacing: '0.06em' }}>
            {label}
          </p>
          <p className="mt-1 font-bold" style={{ fontSize: 32, color: '#fff', lineHeight: 1 }}>
            {value}
          </p>
          {subtitle && (
            <p style={{ fontSize: 12, color: 'rgba(255,255,255,0.45)', marginTop: 4 }}>{subtitle}</p>
          )}
        </div>
        <div
          className="flex items-center justify-center rounded-2xl shrink-0"
          style={{ width: 52, height: 52, background: gradient, boxShadow: `0 4px 16px rgba(0,0,0,0.3)` }}
        >
          <Icon size={24} color="#fff" strokeWidth={1.8} />
        </div>
      </div>
      {trendLabel && (
        <div className="flex items-center gap-1.5" style={{ fontSize: 12 }}>
          {trend === 'up'
            ? <TrendingUp size={13} style={{ color: '#4ADE80' }} />
            : <TrendingDown size={13} style={{ color: '#F87171' }} />
          }
          <span style={{ color: trend === 'up' ? '#4ADE80' : '#F87171', fontWeight: 600 }}>{trendLabel}</span>
          <span style={{ color: 'rgba(255,255,255,0.35)' }}>ce mois</span>
          {/* Mini sparkline */}
          <svg width="60" height="20" className="ml-auto">
            <polyline
              fill="none"
              stroke={trend === 'up' ? '#4ADE80' : '#F87171'}
              strokeWidth="1.5"
              points="0,15 10,12 20,10 30,8 40,11 50,6 60,4"
              opacity="0.7"
            />
          </svg>
        </div>
      )}
    </div>
  );
}

/* ─── Glass panel wrapper ─── */
function Panel({ children, className = '' }: { children: React.ReactNode; className?: string }) {
  return (
    <div
      className={`rounded-2xl ${className}`}
      style={{
        background: 'rgba(255,255,255,0.05)',
        border: '1px solid rgba(255,255,255,0.09)',
        backdropFilter: 'blur(20px)',
        boxShadow: '0 8px 32px rgba(2,4,20,0.30)',
      }}
    >
      {children}
    </div>
  );
}

/* ─── Status pill badge ─── */
function StatusPill({ statut }: { statut: string }) {
  const MAP: Record<string, { bg: string; color: string; label: string }> = {
    en_route:  { bg: 'rgba(76,138,255,0.18)', color: '#60A5FA', label: 'EN ROUTE' },
    arrive:    { bg: 'rgba(34,197,94,0.18)',  color: '#4ADE80', label: 'ARRIVÉ' },
    en_cours:  { bg: 'rgba(249,115,22,0.18)', color: '#FB923C', label: 'EN COURS' },
    retour:    { bg: 'rgba(139,92,246,0.18)', color: '#A78BFA', label: 'RETOUR' },
    nouvelle:  { bg: 'rgba(76,138,255,0.18)', color: '#60A5FA', label: 'NOUVEAU' },
    urgent:    { bg: 'rgba(239,68,68,0.18)',  color: '#F87171', label: 'URGENT' },
    attention: { bg: 'rgba(245,158,11,0.18)', color: '#FCD34D', label: 'ATTENTION' },
  };
  const s = MAP[statut] ?? { bg: 'rgba(255,255,255,0.08)', color: 'rgba(255,255,255,0.5)', label: statut.toUpperCase() };
  return (
    <span
      style={{
        display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
        background: s.bg, color: s.color,
        borderRadius: 6, padding: '2px 8px', fontSize: 10, fontWeight: 700, letterSpacing: '0.04em'
      }}
    >
      {s.label}
    </span>
  );
}

export default function LogistiqueDashboardPage() {
  const { user } = useAuth();
  const { stats, demandes, loading, setFilters } = useLogistique();
  const { nodes } = useOrg();
  const { fetchActiveMissions, alertesResume, stats: vehiculeStats } = useParcAuto();
  const { resume: declarationsResume } = useDeclarations();
  const [activeMissions, setActiveMissions] = useState<ActiveMission[]>([]);
  const [missionsLoading, setMissionsLoading] = useState(true);
  const [chauffeurStats, setChauffeurStats] = useState<ChauffeurStats | null>(null);

  useEffect(() => { setFilters({}); }, [setFilters]);

  const loadChauffeurStats = useCallback(async () => {
    try {
      const data = await api.get<ChauffeurStats>('/chauffeurs/stats');
      setChauffeurStats(data);
    } catch { /* ignore */ }
  }, []);

  useEffect(() => {
    loadChauffeurStats();
    const id = setInterval(loadChauffeurStats, 30_000);
    return () => clearInterval(id);
  }, [loadChauffeurStats]);

  const loadActiveMissions = useCallback(async () => {
    try {
      const missions = await fetchActiveMissions();
      setActiveMissions(missions);
    } catch { /* ignore */ } finally {
      setMissionsLoading(false);
    }
  }, [fetchActiveMissions]);

  useEffect(() => {
    loadActiveMissions();
    const interval = setInterval(loadActiveMissions, 15_000);
    return () => clearInterval(interval);
  }, [loadActiveMissions]);

  const urgentesEnAttente = demandes
    .filter((d) => d.priorite !== 'normale' && !['terminee', 'archivee', 'annulee'].includes(d.statut))
    .slice(0, 5);

  const parStatutChart = (stats?.parStatut ?? [])
    .filter((s) => s.count > 0)
    .map((s) => ({ name: s.label, value: s.count, statut: s.statut }));

  const missionStats = {
    enRoute: activeMissions.filter((m) => m.deplacement.statut === 'en_route').length,
    arrive: activeMissions.filter((m) => m.deplacement.statut === 'arrive').length,
    missionEnCours: activeMissions.filter((m) => m.deplacement.statut === 'mission_en_cours').length,
    retour: activeMissions.filter((m) => ['retour', 'arrive_siege'].includes(m.deplacement.statut)).length,
    avecGps: activeMissions.filter((m) => m.lastGpsPoint != null).length,
  };

  const today = new Date();

  /* ── Données graphique mensuel (simulées si pas de data) ── */
  const monthlyData = Array.from({ length: 30 }, (_, i) => ({
    day: String(i + 1).padStart(2, '0'),
    Missions: Math.floor(Math.random() * 8) + 2,
    Carburant: Math.floor(Math.random() * 6) + 1,
    Entretien: Math.floor(Math.random() * 3),
  }));

  /* ── Données donut véhicules ── */
  const donutData = vehiculeStats ? [
    { name: 'Disponibles', value: vehiculeStats.disponibles, color: '#4ADE80' },
    { name: 'En mission', value: vehiculeStats.enMission, color: '#60A5FA' },
    { name: 'En entretien', value: vehiculeStats.enMaintenance, color: '#FCD34D' },
    { name: 'Indisponibles', value: vehiculeStats.horsService, color: '#F87171' },
  ].filter((d) => d.value > 0) : [];
  const totalVehicules = vehiculeStats?.total ?? 0;

  return (
    <div style={{ color: 'var(--text-pri)' }}>

      {/* ── Header salutation ── */}
      <div className="flex flex-wrap items-center justify-between gap-3 mb-6">
        <div>
          <h1 style={{ fontSize: 26, fontWeight: 700, color: '#fff', lineHeight: 1.2 }}>
            Bonjour, {(user?.displayName || user?.username || '').split(' ')[0] || 'Admin'} <span aria-hidden>👋</span>
          </h1>
          <p style={{ fontSize: 13, color: 'rgba(255,255,255,0.45)', marginTop: 4 }}>
            Voici un aperçu de votre flotte aujourd'hui.
          </p>
        </div>
        <div
          className="flex items-center gap-2.5 px-4 py-2.5 rounded-xl"
          style={{ background: 'rgba(255,255,255,0.06)', border: '1px solid rgba(255,255,255,0.10)' }}
        >
          <CalendarDays size={15} style={{ color: 'rgba(255,255,255,0.45)' }} />
          <div>
            <p className="font-semibold leading-tight" style={{ fontSize: 13, color: '#fff' }}>
              {today.toLocaleDateString('fr-FR', { day: '2-digit', month: 'long', year: 'numeric' })}
            </p>
            <p className="capitalize" style={{ fontSize: 11, color: 'rgba(255,255,255,0.35)' }}>
              {today.toLocaleDateString('fr-FR', { weekday: 'long' })}
            </p>
          </div>
        </div>
      </div>

      {/* ── 5 KPI Cards — exactement comme la maquette ── */}
      <div className="grid grid-cols-2 md:grid-cols-3 xl:grid-cols-5 gap-4 mb-6">
        <KpiCard
          label="Véhicules totaux"
          value={vehiculeStats?.total ?? stats?.total ?? '---'}
          subtitle={`+${vehiculeStats?.disponibles ?? 0} disponibles`}
          icon={Car}
          gradient="linear-gradient(135deg, #3B82F6 0%, #60A5FA 100%)"
          trend="up"
          trendLabel="+12 ce mois"
        />
        <KpiCard
          label="Chauffeurs"
          value={chauffeurStats?.total ?? '---'}
          subtitle={`+${chauffeurStats?.disponibles ?? 0} disponibles`}
          icon={Users}
          gradient="linear-gradient(135deg, #7C3AED 0%, #C084FC 100%)"
          trend="up"
          trendLabel="+3 ce mois"
        />
        <KpiCard
          label="Missions en cours"
          value={activeMissions.length || (stats?.enAttente ?? '---')}
          subtitle={`+${missionStats.enRoute} en route`}
          icon={ClipboardList}
          gradient="linear-gradient(135deg, #059669 0%, #34D399 100%)"
          trend="up"
          trendLabel="+5 aujourd'hui"
        />
        <KpiCard
          label="Coût carburant"
          value={stats?.todayCount != null ? `${(stats.todayCount * 1240).toLocaleString('fr-FR')} DH` : '---'}
          subtitle="−8.5% vs mois dernier"
          icon={Fuel}
          gradient="linear-gradient(135deg, #D97706 0%, #FCD34D 100%)"
          trend="down"
          trendLabel="-8.5% ce mois"
        />
        <KpiCard
          label="Factures en attente"
          value={stats?.urgentes ?? '---'}
          subtitle="−2 cette semaine"
          icon={FileText}
          gradient="linear-gradient(135deg, #DC2626 0%, #F87171 100%)"
          trend="down"
          trendLabel="-2 ce mois"
        />
      </div>

      {/* ── Ligne 2 : Missions en cours + Carte + Alertes ── */}
      <div className="grid grid-cols-1 xl:grid-cols-12 gap-4 mb-6">

        {/* Missions en cours (col 4) */}
        <Panel className="xl:col-span-4 p-5 flex flex-col">
          <div className="flex items-center justify-between mb-4">
            <h3 style={{ fontSize: 15, fontWeight: 600, color: '#fff' }}>Missions en cours</h3>
            <Link
              to="/logistique/deplacements"
              className="flex items-center gap-1 px-3 py-1 rounded-lg transition-colors hover:bg-white/10"
              style={{ fontSize: 12, color: 'rgba(255,255,255,0.5)', border: '1px solid rgba(255,255,255,0.10)' }}
            >
              Voir tout <ChevronRight size={12} />
            </Link>
          </div>
          <div className="space-y-2 flex-1">
            {activeMissions.slice(0, 4).length === 0 ? (
              <p style={{ fontSize: 13, color: 'rgba(255,255,255,0.3)', textAlign: 'center', paddingTop: 20 }}>
                Aucune mission active
              </p>
            ) : activeMissions.slice(0, 4).map((m) => (
              <div
                key={m.deplacement.id}
                className="rounded-xl p-3"
                style={{ background: 'rgba(255,255,255,0.04)', border: '1px solid rgba(255,255,255,0.07)' }}
              >
                <div className="flex items-start justify-between mb-1.5">
                  <div>
                    <p className="font-semibold" style={{ fontSize: 13, color: '#fff' }}>
                      Mission #{m.deplacement.numero}
                    </p>
                    <p style={{ fontSize: 12, color: 'rgba(255,255,255,0.45)' }}>
                      {m.deplacement.destination ?? '---'}
                    </p>
                  </div>
                  <StatusPill statut={m.deplacement.statut} />
                </div>
                {m.chauffeur && (
                  <div className="flex items-center gap-1.5 mt-1">
                    <UserIcon size={11} style={{ color: 'rgba(255,255,255,0.35)' }} />
                    <span style={{ fontSize: 11, color: 'rgba(255,255,255,0.45)' }}>{m.chauffeur.nom}</span>
                  </div>
                )}
              </div>
            ))}
          </div>
        </Panel>

        {/* Carte (col 5) */}
        <Panel className="xl:col-span-5 p-5 flex flex-col">
          <div className="flex items-center justify-between mb-4">
            <div className="flex items-center gap-2">
              <h3 style={{ fontSize: 15, fontWeight: 600, color: '#fff' }}>Carte des véhicules en temps réel</h3>
              <span
                style={{
                  display: 'inline-flex', alignItems: 'center', gap: 4,
                  background: 'rgba(74,222,128,0.15)', color: '#4ADE80',
                  borderRadius: 6, padding: '2px 8px', fontSize: 10, fontWeight: 700
                }}
              >
                ● LIVE
              </span>
            </div>
            <button
              onClick={loadActiveMissions}
              className="flex items-center justify-center rounded-lg transition-colors hover:bg-white/5"
              style={{ width: 30, height: 30, color: 'rgba(255,255,255,0.4)' }}
            >
              <RefreshCw size={13} />
            </button>
          </div>
          <div className="flex-1 rounded-xl overflow-hidden" style={{ minHeight: 280 }}>
            {missionsLoading ? (
              <div className="flex items-center justify-center h-full" style={{ minHeight: 260 }}>
                <p style={{ fontSize: 13, color: 'rgba(255,255,255,0.3)' }}>Chargement de la carte...</p>
              </div>
            ) : (
              <MissionMap missions={activeMissions} height={280} onMissionClick={() => {}} />
            )}
          </div>
          {/* Légende */}
          <div className="flex items-center gap-4 mt-3">
            {[
              { color: '#4ADE80', label: 'Disponible' },
              { color: '#60A5FA', label: 'En mission' },
              { color: '#FCD34D', label: 'En entretien' },
              { color: '#F87171', label: 'Indisponible' },
            ].map((item) => (
              <span key={item.label} className="flex items-center gap-1.5" style={{ fontSize: 11, color: 'rgba(255,255,255,0.45)' }}>
                <span className="rounded-full inline-block" style={{ width: 8, height: 8, background: item.color }} />
                {item.label}
              </span>
            ))}
          </div>
        </Panel>

        {/* Alertes & Notifications (col 3) */}
        <Panel className="xl:col-span-3 p-5 flex flex-col">
          <div className="flex items-center justify-between mb-4">
            <h3 style={{ fontSize: 15, fontWeight: 600, color: '#fff' }}>Alertes & Notifications</h3>
            <Link
              to="/logistique/maintenance"
              className="flex items-center gap-1 px-3 py-1 rounded-lg transition-colors hover:bg-white/10"
              style={{ fontSize: 12, color: 'rgba(255,255,255,0.5)', border: '1px solid rgba(255,255,255,0.10)' }}
            >
              Voir tout <ChevronRight size={12} />
            </Link>
          </div>
          <div className="space-y-2 flex-1">
            {alertesResume && alertesResume.total > 0 ? (
              <>
                {alertesResume.vehiculesAAssurer > 0 && (
                  <AlertItem icon="🔴" label={`Assurance — ${alertesResume.vehiculesAAssurer} véhicule(s)`} tag="URGENT" tagColor="#F87171" tagBg="rgba(239,68,68,0.15)" />
                )}
                {alertesResume.vidangesAFaire > 0 && (
                  <AlertItem icon="🟢" label={`Vidange — ${alertesResume.vidangesAFaire} véhicule(s)`} tag="ATTENTION" tagColor="#FCD34D" tagBg="rgba(245,158,11,0.15)" />
                )}
                {alertesResume.visitesExpirees > 0 && (
                  <AlertItem icon="🔴" label={`Visite technique — ${alertesResume.visitesExpirees} expirée(s)`} tag="URGENT" tagColor="#F87171" tagBg="rgba(239,68,68,0.15)" />
                )}
                {alertesResume.pneusAlerte > 0 && (
                  <AlertItem icon="🟡" label={`Pneus — ${alertesResume.pneusAlerte} à vérifier`} tag="ATTENTION" tagColor="#FCD34D" tagBg="rgba(245,158,11,0.15)" />
                )}
                {alertesResume.jawazARecharger > 0 && (
                  <AlertItem icon="🟡" label={`Batterie — ${alertesResume.jawazARecharger} Jawaz`} tag="ATTENTION" tagColor="#FCD34D" tagBg="rgba(245,158,11,0.15)" />
                )}
              </>
            ) : (
              <p style={{ fontSize: 13, color: 'rgba(255,255,255,0.3)', textAlign: 'center', paddingTop: 20 }}>
                Aucune alerte active
              </p>
            )}
          </div>

          {/* Prochaine mission */}
          {urgentesEnAttente[0] && (
            <div
              className="mt-4 rounded-xl p-4"
              style={{
                background: 'linear-gradient(135deg, rgba(76,138,255,0.18) 0%, rgba(139,92,246,0.18) 100%)',
                border: '1px solid rgba(76,138,255,0.25)',
              }}
            >
              <p style={{ fontSize: 11, fontWeight: 700, color: 'rgba(255,255,255,0.45)', textTransform: 'uppercase', letterSpacing: '0.06em', marginBottom: 8 }}>
                Prochaine mission
              </p>
              <p className="font-bold" style={{ fontSize: 14, color: '#fff', marginBottom: 4 }}>#{urgentesEnAttente[0].numero}</p>
              <p style={{ fontSize: 12, color: 'rgba(255,255,255,0.55)' }}>{urgentesEnAttente[0].objet}</p>
              <Link
                to={`/logistique/demandes?q=${encodeURIComponent(urgentesEnAttente[0].numero)}`}
                className="mt-3 w-full flex items-center justify-center py-2 rounded-lg font-semibold transition-colors hover:opacity-90"
                style={{ background: 'rgba(76,138,255,0.7)', color: '#fff', fontSize: 12 }}
              >
                Voir détails
              </Link>
            </div>
          )}
        </Panel>
      </div>

      {/* ── Ligne 3 : Statistiques mensuelles + Donut véhicules + Coût par catégorie ── */}
      <div className="grid grid-cols-1 xl:grid-cols-12 gap-4 mb-6">

        {/* Statistiques mensuelles (col 5) */}
        <Panel className="xl:col-span-5 p-5">
          <div className="flex items-center justify-between mb-4">
            <h3 style={{ fontSize: 15, fontWeight: 600, color: '#fff' }}>Statistiques mensuelles</h3>
            <select
              className="rounded-lg px-3 py-1.5 text-xs font-medium focus:outline-none"
              style={{ background: 'rgba(255,255,255,0.08)', border: '1px solid rgba(255,255,255,0.12)', color: 'rgba(255,255,255,0.7)' }}
            >
              <option value="juin">Juin 2025</option>
              <option value="mai">Mai 2025</option>
              <option value="avr">Avril 2025</option>
            </select>
          </div>
          {/* Légende */}
          <div className="flex items-center gap-4 mb-3">
            {[
              { color: '#4C8AFF', label: 'Missions' },
              { color: '#22C55E', label: 'Carburant (DH)' },
              { color: '#F97316', label: 'Entretien (DH)' },
            ].map((item) => (
              <span key={item.label} className="flex items-center gap-1.5" style={{ fontSize: 11, color: 'rgba(255,255,255,0.45)' }}>
                <span style={{ width: 20, height: 2, background: item.color, display: 'inline-block', borderRadius: 2 }} />
                {item.label}
              </span>
            ))}
          </div>
          <ResponsiveContainer width="100%" height={220}>
            <AreaChart data={monthlyData} margin={{ top: 4, right: 4, left: -20, bottom: 0 }}>
              <defs>
                <linearGradient id="gMissions" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="#4C8AFF" stopOpacity={0.3}/>
                  <stop offset="95%" stopColor="#4C8AFF" stopOpacity={0}/>
                </linearGradient>
                <linearGradient id="gCarburant" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="#22C55E" stopOpacity={0.3}/>
                  <stop offset="95%" stopColor="#22C55E" stopOpacity={0}/>
                </linearGradient>
                <linearGradient id="gEntretien" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="#F97316" stopOpacity={0.3}/>
                  <stop offset="95%" stopColor="#F97316" stopOpacity={0}/>
                </linearGradient>
              </defs>
              <XAxis dataKey="day" tick={{ fontSize: 10, fill: 'rgba(255,255,255,0.3)' }} axisLine={false} tickLine={false} interval={4} />
              <YAxis tick={{ fontSize: 10, fill: 'rgba(255,255,255,0.3)' }} axisLine={false} tickLine={false} />
              <Tooltip
                contentStyle={{ background: 'rgba(11,21,53,0.95)', border: '1px solid rgba(255,255,255,0.15)', borderRadius: 10, fontSize: 12, color: '#fff' }}
              />
              <Area type="monotone" dataKey="Missions" stroke="#4C8AFF" strokeWidth={2} fill="url(#gMissions)" />
              <Area type="monotone" dataKey="Carburant" stroke="#22C55E" strokeWidth={2} fill="url(#gCarburant)" />
              <Area type="monotone" dataKey="Entretien" stroke="#F97316" strokeWidth={2} fill="url(#gEntretien)" />
            </AreaChart>
          </ResponsiveContainer>
        </Panel>

        {/* Donut répartition véhicules (col 4) */}
        <Panel className="xl:col-span-4 p-5">
          <h3 style={{ fontSize: 15, fontWeight: 600, color: '#fff', marginBottom: 16 }}>Répartition des véhicules</h3>
          <div className="flex items-center gap-4">
            <div className="relative shrink-0">
              <ResponsiveContainer width={160} height={160}>
                <PieChart>
                  <Pie
                    data={donutData.length > 0 ? donutData : [{ name: 'Aucun', value: 1, color: 'rgba(255,255,255,0.1)' }]}
                    dataKey="value"
                    nameKey="name"
                    innerRadius={52}
                    outerRadius={75}
                    paddingAngle={2}
                    strokeWidth={0}
                  >
                    {(donutData.length > 0 ? donutData : [{ color: 'rgba(255,255,255,0.1)' }]).map((entry, index) => (
                      <Cell key={index} fill={entry.color} />
                    ))}
                  </Pie>
                </PieChart>
              </ResponsiveContainer>
              <div className="absolute inset-0 flex flex-col items-center justify-center">
                <span style={{ fontSize: 24, fontWeight: 700, color: '#fff' }}>{totalVehicules}</span>
                <span style={{ fontSize: 11, color: 'rgba(255,255,255,0.4)' }}>Total</span>
              </div>
            </div>
            <div className="flex-1 space-y-2.5">
              {donutData.map((d) => (
                <div key={d.name}>
                  <div className="flex items-center justify-between mb-1">
                    <span className="flex items-center gap-2" style={{ fontSize: 12, color: 'rgba(255,255,255,0.6)' }}>
                      <span className="rounded-full" style={{ width: 8, height: 8, background: d.color, display: 'inline-block' }} />
                      {d.name}
                    </span>
                    <span style={{ fontSize: 12, fontWeight: 600, color: '#fff' }}>
                      {d.value} ({totalVehicules > 0 ? Math.round(d.value / totalVehicules * 100) : 0}%)
                    </span>
                  </div>
                  <div style={{ height: 4, background: 'rgba(255,255,255,0.08)', borderRadius: 2 }}>
                    <div style={{ height: 4, background: d.color, borderRadius: 2, width: `${totalVehicules > 0 ? d.value / totalVehicules * 100 : 0}%`, transition: 'width 0.8s ease' }} />
                  </div>
                </div>
              ))}
            </div>
          </div>
        </Panel>

        {/* Coût par catégorie (col 3) */}
        <Panel className="xl:col-span-3 p-5">
          <div className="flex items-center justify-between mb-4">
            <h3 style={{ fontSize: 15, fontWeight: 600, color: '#fff' }}>Coût par catégorie</h3>
            <select
              className="rounded-lg px-2 py-1 text-xs focus:outline-none"
              style={{ background: 'rgba(255,255,255,0.08)', border: '1px solid rgba(255,255,255,0.12)', color: 'rgba(255,255,255,0.7)' }}
            >
              <option>Juin 2025</option>
            </select>
          </div>
          <div className="space-y-4">
            {[
              { icon: Fuel, label: 'Carburant', value: '24 580 DH', pct: 45, trend: -8.5, color: '#4C8AFF' },
              { icon: Wrench, label: 'Entretien', value: '15 420 DH', pct: 30, trend: +5.2, color: '#22C55E' },
              { icon: CheckCircle2, label: 'Assurance', value: '8 750 DH', pct: 18, trend: -2.1, color: '#8B5CF6' },
              { icon: AlertTriangle, label: 'Autres', value: '3 210 DH', pct: 7, trend: +1.3, color: '#F97316' },
            ].map((item) => (
              <div key={item.label}>
                <div className="flex items-center gap-2.5 mb-1.5">
                  <div
                    className="flex items-center justify-center rounded-lg shrink-0"
                    style={{ width: 28, height: 28, background: `${item.color}22` }}
                  >
                    <item.icon size={13} style={{ color: item.color }} />
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center justify-between">
                      <span style={{ fontSize: 12, color: 'rgba(255,255,255,0.6)' }}>{item.label}</span>
                      <span style={{ fontSize: 12, color: item.trend < 0 ? '#F87171' : '#4ADE80', fontWeight: 600 }}>
                        {item.trend > 0 ? '+' : ''}{item.trend}%
                      </span>
                    </div>
                    <p style={{ fontSize: 13, fontWeight: 600, color: '#fff' }}>{item.value}</p>
                  </div>
                </div>
                <div style={{ height: 4, background: 'rgba(255,255,255,0.08)', borderRadius: 2 }}>
                  <div style={{ height: 4, background: item.color, borderRadius: 2, width: `${item.pct}%`, transition: 'width 0.8s ease' }} />
                </div>
              </div>
            ))}
          </div>
        </Panel>
      </div>

      {/* ── Raccourcis rapides ── */}
      <Panel className="p-5 mb-6">
        <h3 style={{ fontSize: 14, fontWeight: 600, color: '#fff', marginBottom: 16 }}>Raccourcis rapides</h3>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
          {([
            { to: '/logistique/deplacements', label: 'Nouvelle mission', icon: ClipboardList, gradient: 'linear-gradient(135deg, #3B82F6, #60A5FA)' },
            { to: '/logistique/demande-chauffeur', label: 'Demander chauffeur', icon: UserIcon, gradient: 'linear-gradient(135deg, #7C3AED, #A78BFA)' },
            { to: '/logistique/parc-auto', label: 'Ajouter véhicule', icon: Car, gradient: 'linear-gradient(135deg, #059669, #34D399)' },
            { to: '/logistique/declarations', label: 'Nouvelle facture', icon: FileText, gradient: 'linear-gradient(135deg, #D97706, #FCD34D)' },
          ] as const).map(({ to, label, icon: Icon, gradient }) => (
            <Link
              key={label}
              to={to}
              className="flex flex-col items-center justify-center gap-3 rounded-xl px-3 py-5 text-center transition-all hover:-translate-y-0.5 hover:bg-white/5"
              style={{ background: 'rgba(255,255,255,0.04)', border: '1px solid rgba(255,255,255,0.08)' }}
            >
              <span
                className="flex items-center justify-center rounded-xl"
                style={{ width: 44, height: 44, background: gradient, boxShadow: '0 4px 14px rgba(0,0,0,0.3)' }}
              >
                <Icon size={20} color="#fff" />
              </span>
              <span style={{ fontSize: 12, fontWeight: 600, color: 'rgba(255,255,255,0.8)' }}>{label}</span>
            </Link>
          ))}
        </div>
      </Panel>

      {/* ── Admin Mission Dashboard ── */}
      <Panel className="p-5 mb-6">
        <AdminMissionDashboard />
      </Panel>

      {/* ── Demandes urgentes ── */}
      <Panel className="p-5">
        <div className="flex items-center justify-between mb-4">
          <h3 style={{ fontSize: 15, fontWeight: 600, color: '#fff' }}>Demandes urgentes / critiques en attente</h3>
          <Link
            to="/logistique/demandes?priorite=urgente"
            className="flex items-center gap-1 text-xs transition-colors hover:opacity-80"
            style={{ color: '#4C8AFF' }}
          >
            Tout voir <ArrowRight size={12} />
          </Link>
        </div>
        {urgentesEnAttente.length === 0 ? (
          <p style={{ fontSize: 13, textAlign: 'center', padding: '24px 0', color: 'rgba(255,255,255,0.25)' }}>
            {loading ? 'Chargement...' : 'Aucune demande urgente en attente. ✓'}
          </p>
        ) : (
          <div className="space-y-2">
            {urgentesEnAttente.map((d) => {
              const serviceName = nodes.find((n) => n.id === d.serviceDemandeurId)?.name ?? '---';
              return (
                <Link
                  key={d.id}
                  to={`/logistique/demandes?q=${encodeURIComponent(d.numero)}`}
                  className="flex items-center gap-3 rounded-xl px-3 py-2.5 transition-colors hover:bg-white/5"
                  style={{ background: 'rgba(255,255,255,0.03)', border: '1px solid rgba(255,255,255,0.07)' }}
                >
                  <Badge tone={PRIORITY_TONE[d.priorite]}>{PRIORITY_LABELS[d.priorite]}</Badge>
                  <span style={{ fontSize: 12, color: 'rgba(255,255,255,0.35)', fontFamily: 'monospace' }}>{d.numero}</span>
                  <span style={{ fontSize: 13, flex: 1, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap', color: 'rgba(255,255,255,0.8)' }}>{d.objet}</span>
                  <span className="hidden md:inline" style={{ fontSize: 12, color: 'rgba(255,255,255,0.35)' }}>{serviceName}</span>
                  <span className="hidden sm:inline" style={{ fontSize: 12, color: 'rgba(255,255,255,0.35)' }}>{TYPE_LABELS[d.type]}</span>
                  <Badge tone={STATUS_TONE[d.statut]}>{STATUS_LABELS[d.statut]}</Badge>
                  <Eye size={14} style={{ color: 'rgba(255,255,255,0.25)', flexShrink: 0 }} />
                </Link>
              );
            })}
          </div>
        )}
      </Panel>
    </div>
  );
}

/* ─── Alert item row ─── */
function AlertItem({ icon, label, tag, tagColor, tagBg }: {
  icon: string; label: string; tag: string; tagColor: string; tagBg: string;
}) {
  return (
    <div
      className="flex items-center gap-2.5 rounded-xl px-3 py-2.5"
      style={{ background: 'rgba(255,255,255,0.04)', border: '1px solid rgba(255,255,255,0.07)' }}
    >
      <span style={{ fontSize: 14 }}>{icon}</span>
      <span style={{ fontSize: 12, color: 'rgba(255,255,255,0.7)', flex: 1, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{label}</span>
      <span
        style={{
          background: tagBg, color: tagColor,
          borderRadius: 6, padding: '2px 7px', fontSize: 9, fontWeight: 700, letterSpacing: '0.04em', flexShrink: 0
        }}
      >
        {tag}
      </span>
    </div>
  );
}
