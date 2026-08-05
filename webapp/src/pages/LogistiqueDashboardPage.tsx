import { useEffect, useState, useCallback } from 'react';
import { Link } from 'react-router-dom';
import {
  ClipboardList, Clock, AlertTriangle, CheckCircle2, Timer, Inbox, ArrowRight, MapPin, RefreshCw, User as UserIcon, AlertOctagon, CalendarDays,
  Car, Users, Wrench, XCircle
} from 'lucide-react';
import {
  ResponsiveContainer, BarChart, Bar, XAxis, YAxis, Tooltip,
  PieChart, Pie, Cell
} from 'recharts';
import { PageHeader, Card, StatCard, Badge, Button, STAT_COLORS } from '../components/ui/Kit';
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
  nouvelle: '#6366f1',
  validee_chef: '#a855f7',
  validee_responsable: '#818cf8',
  affectee: 'var(--accent-warn)',
  en_cours: '#fb923c',
  terminee: 'var(--accent2)',
  annulee: 'var(--accent-err)',
  archivee: '#94a3b8'
};

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
    } catch {
      // ignore
    }
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
    } catch {
      // ignore
    } finally {
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
    .slice(0, 6);

  const parDirectionChart = (stats?.parDirection ?? []).slice(0, 8).map((d) => ({ direction: d.name, count: d.count }));
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

  return (
    <div>
      <div className="flex flex-wrap items-center justify-between gap-3 mb-6">
        <div>
          <h1 className="flex items-center gap-2" style={{ color: 'var(--text-pri)' }}>
            Bonjour, {(user?.displayName || user?.username || '').split(' ')[0] || 'Admin'} <span aria-hidden>👋</span>
          </h1>
          <p className="text-sm mt-1" style={{ color: 'var(--text-sec)' }}>Voici un aperçu de votre flotte aujourd'hui.</p>
        </div>
        <div
          className="flex items-center gap-2 px-4 py-2.5 rounded-xl text-sm"
          style={{ background: 'var(--card)', border: '1px solid var(--border)', boxShadow: 'var(--shadow-card)' }}
        >
          <CalendarDays size={15} style={{ color: 'var(--text-ter)' }} />
          <div>
            <p className="font-semibold leading-tight" style={{ color: 'var(--text-pri)' }}>
              {today.toLocaleDateString('fr-FR', { day: '2-digit', month: 'long', year: 'numeric' })}
            </p>
            <p className="text-[11px] leading-tight capitalize" style={{ color: 'var(--text-ter)' }}>
              {today.toLocaleDateString('fr-FR', { weekday: 'long' })}
            </p>
          </div>
        </div>
      </div>

      <PageHeader
        eyebrow="Service de la Logistique et des Moyens Generaux"
        title="Tableau de bord Logistique"
        description="Vue d ensemble des demandes recues de l ensemble des directions et services de l etablissement."
        action={
          <Link to="/logistique/demandes">
            <Button variant="primary">
              <ClipboardList size={14} /> Voir les demandes
            </Button>
          </Link>
        }
      />

      {/* Raccourcis rapides */}
      <Card className="p-5 mb-6">
        <h3 className="text-sm font-semibold mb-4" style={{ color: 'var(--text-pri)' }}>Raccourcis rapides</h3>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
          {([
            { to: '/logistique/deplacements', label: 'Nouvelle mission', icon: ClipboardList, color: STAT_COLORS.blue },
            { to: '/logistique/demande-chauffeur', label: 'Demander chauffeur', icon: UserIcon, color: STAT_COLORS.violet },
            { to: '/logistique/parc-auto', label: 'Ajouter véhicule', icon: MapPin, color: STAT_COLORS.green },
            { to: '/logistique/demandes', label: 'Nouvelle demande', icon: Inbox, color: STAT_COLORS.orange }
          ] as const).map(({ to, label, icon: Icon, color }) => (
            <Link
              key={label}
              to={to}
              className="flex flex-col items-center justify-center gap-2.5 rounded-xl px-3 py-5 text-center transition-transform hover:-translate-y-0.5"
              style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}
            >
              <span
                className="flex items-center justify-center rounded-xl"
                style={{ width: 40, height: 40, background: `linear-gradient(135deg, ${color.from} 0%, ${color.to} 100%)`, boxShadow: `0 4px 12px -2px ${color.from}77`, color: '#fff' }}
              >
                <Icon size={18} />
              </span>
              <span className="text-xs font-semibold" style={{ color: 'var(--text-pri)' }}>{label}</span>
            </Link>
          ))}
        </div>
      </Card>

      {/* KPI */}
      <div className="grid grid-cols-2 md:grid-cols-3 xl:grid-cols-6 gap-3 mb-6">
        <StatCard label="Recues aujourd hui" value={stats?.todayCount ?? '---'} icon={<Inbox size={16} />} color="blue" />
        <StatCard label="En attente de validation" value={stats?.enAttente ?? '---'} icon={<Clock size={16} />} color="violet" />
        <StatCard label="Urgentes / critiques" value={stats?.urgentes ?? '---'} icon={<AlertTriangle size={16} />} color={stats && stats.urgentes > 0 ? 'red' : 'indigo'} />
        <StatCard label="Terminees ce mois" value={stats?.termineesMois ?? '---'} icon={<CheckCircle2 size={16} />} color="green" />
        <StatCard label="Total demandes" value={stats?.total ?? '---'} icon={<ClipboardList size={16} />} color="orange" />
        <StatCard
          label="Delai moyen de traitement"
          value={stats?.delaiMoyenHeures != null ? `${stats.delaiMoyenHeures} h` : '---'}
          icon={<Timer size={16} />}
          color="indigo"
        />
      </div>

      {/* KPI temps réel — Chauffeurs & Véhicules disponibles */}
      {(chauffeurStats || vehiculeStats) && (
        <Card className="p-5 mb-6">
          <div className="flex items-center justify-between mb-4">
            <div className="flex items-center gap-2">
              <RefreshCw size={13} style={{ color: 'var(--accent2)' }} />
              <h3 className="text-sm font-semibold" style={{ color: 'var(--text-pri)' }}>Disponibilité en temps réel</h3>
            </div>
            <span className="text-[10px] px-2 py-0.5 rounded-full font-semibold" style={{ background: 'rgba(74,222,128,0.12)', color: 'var(--accent2)' }}>
              ● LIVE
            </span>
          </div>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
            {/* Chauffeurs */}
            <Link to="/logistique/chauffeurs" className="group rounded-xl p-3 transition-colors hover:bg-[var(--card-hover)]" style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}>
              <div className="flex items-center gap-2 mb-2">
                <Users size={14} style={{ color: 'var(--accent2)' }} />
                <span className="text-[11px] font-semibold uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Chauffeurs</span>
              </div>
              <p className="text-2xl font-bold mb-1" style={{ color: 'var(--text-pri)' }}>
                {chauffeurStats?.disponibles ?? '—'}
                <span className="text-xs font-normal ml-1" style={{ color: 'var(--text-ter)' }}>/ {chauffeurStats?.total ?? '—'}</span>
              </p>
              <p className="text-[11px]" style={{ color: 'var(--accent2)' }}>disponibles</p>
            </Link>

            <Link to="/logistique/chauffeurs" className="group rounded-xl p-3 transition-colors hover:bg-[var(--card-hover)]" style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}>
              <div className="flex items-center gap-2 mb-2">
                <UserIcon size={14} style={{ color: 'var(--accent-warn)' }} />
                <span className="text-[11px] font-semibold uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>En mission</span>
              </div>
              <p className="text-2xl font-bold mb-1" style={{ color: 'var(--text-pri)' }}>{chauffeurStats?.enMission ?? '—'}</p>
              <p className="text-[11px]" style={{ color: 'var(--accent-warn)' }}>chauffeur(s)</p>
            </Link>

            {/* Véhicules */}
            <Link to="/logistique/parc-auto" className="group rounded-xl p-3 transition-colors hover:bg-[var(--card-hover)]" style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}>
              <div className="flex items-center gap-2 mb-2">
                <Car size={14} style={{ color: '#818cf8' }} />
                <span className="text-[11px] font-semibold uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Véhicules</span>
              </div>
              <p className="text-2xl font-bold mb-1" style={{ color: 'var(--text-pri)' }}>
                {vehiculeStats?.disponibles ?? '—'}
                <span className="text-xs font-normal ml-1" style={{ color: 'var(--text-ter)' }}>/ {vehiculeStats?.total ?? '—'}</span>
              </p>
              <p className="text-[11px]" style={{ color: '#818cf8' }}>disponibles</p>
            </Link>

            <Link to="/logistique/parc-auto" className="group rounded-xl p-3 transition-colors hover:bg-[var(--card-hover)]" style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}>
              <div className="flex items-center gap-2 mb-2">
                <Wrench size={14} style={{ color: 'var(--accent-err)' }} />
                <span className="text-[11px] font-semibold uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Maintenance</span>
              </div>
              <p className="text-2xl font-bold mb-1" style={{ color: 'var(--text-pri)' }}>{vehiculeStats?.enMaintenance ?? '—'}</p>
              <p className="text-[11px]" style={{ color: 'var(--accent-err)' }}>
                {vehiculeStats?.horsService ? `+ ${vehiculeStats.horsService} hors service` : 'véhicule(s)'}
              </p>
            </Link>
          </div>

          {/* Missions actives par statut */}
          {!missionsLoading && activeMissions.length > 0 && (
            <div className="mt-4 pt-4" style={{ borderTop: '1px solid var(--border)' }}>
              <p className="text-[11px] font-semibold uppercase tracking-wide mb-3" style={{ color: 'var(--text-ter)' }}>Missions actives ({activeMissions.length})</p>
              <div className="flex flex-wrap gap-2">
                {Object.entries({
                  'En route': missionStats.enRoute,
                  'Arrivé': missionStats.arrive,
                  'Mission en cours': missionStats.missionEnCours,
                  'Retour': missionStats.retour,
                }).filter(([, v]) => v > 0).map(([label, count]) => (
                  <span key={label} className="flex items-center gap-1.5 rounded-full px-3 py-1 text-xs font-medium" style={{ background: 'var(--bg)', border: '1px solid var(--border)', color: 'var(--text-sec)' }}>
                    <span className="rounded-full inline-block" style={{ width: 6, height: 6, background: 'var(--accent2)' }} />
                    {label} <span className="font-bold">{count}</span>
                  </span>
                ))}
                {missionStats.avecGps > 0 && (
                  <span className="flex items-center gap-1.5 rounded-full px-3 py-1 text-xs font-medium" style={{ background: 'var(--bg)', border: '1px solid rgba(74,222,128,0.3)', color: 'var(--accent2)' }}>
                    <MapPin size={10} /> GPS actif : {missionStats.avecGps}
                  </span>
                )}
              </div>
            </div>
          )}
        </Card>
      )}

      {/* Alertes Parc Automobile & Chauffeurs */}
      {alertesResume && alertesResume.total > 0 && (
        <Card className="p-5 mb-6">
          <div className="flex items-center gap-2 mb-4">
            <AlertTriangle size={16} style={{ color: 'var(--accent-warn)' }} />
            <h3 className="text-sm font-semibold" style={{ color: 'var(--text-pri)' }}>Alertes Parc Automobile & Chauffeurs</h3>
          </div>
          <div className="grid grid-cols-2 md:grid-cols-6 gap-2">
            {([
              { count: alertesResume.vehiculesAAssurer, label: 'véhicule(s) à assurer', to: '/logistique/parc-auto' },
              { count: alertesResume.visitesExpirees, label: 'visite(s) technique(s) expirée(s)', to: '/logistique/parc-auto' },
              { count: alertesResume.vidangesAFaire, label: 'vidange(s) à faire', to: '/logistique/maintenance' },
              { count: alertesResume.jawazARecharger, label: 'Jawaz à recharger', to: '/logistique/parc-auto' },
              { count: alertesResume.permisExpires, label: 'chauffeur(s) avec permis expiré', to: '/logistique/chauffeurs' },
              { count: alertesResume.pneusAlerte, label: 'pneus à vérifier / remplacer', to: '/logistique/parc-auto' }
            ] as const).map((item) => (
              <Link
                key={item.label}
                to={item.to}
                className="rounded-lg px-3 py-2.5 text-center transition-colors hover:bg-[var(--card-hover)]"
                style={{ background: 'var(--bg)', border: `1px solid ${item.count > 0 ? 'rgba(239,68,68,0.3)' : 'var(--border)'}` }}
              >
                <p className="text-lg font-bold" style={{ color: item.count > 0 ? 'var(--accent-err)' : 'var(--text-pri)' }}>{item.count}</p>
                <p className="text-[10px] leading-snug" style={{ color: 'var(--text-ter)' }}>{item.label}</p>
              </Link>
            ))}
          </div>
        </Card>
      )}

      {/* Déclarations chauffeur ("Signaler un problème") */}
      {declarationsResume && declarationsResume.nouvelles + declarationsResume.enCours > 0 && (
        <Card className="p-5 mb-6">
          <div className="flex items-center justify-between mb-4">
            <div className="flex items-center gap-2">
              <AlertOctagon size={16} style={{ color: 'var(--accent-err)' }} />
              <h3 className="text-sm font-semibold" style={{ color: 'var(--text-pri)' }}>Déclarations chauffeur</h3>
            </div>
            <Link to="/logistique/declarations" className="text-xs flex items-center gap-1" style={{ color: 'var(--accent)' }}>
              Voir tout <ArrowRight size={12} />
            </Link>
          </div>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-2">
            {([
              { count: declarationsResume.nouvelles, label: 'nouvelles', tone: declarationsResume.nouvelles > 0 ? 'var(--accent-err)' : undefined },
              { count: declarationsResume.urgentes, label: 'urgentes', tone: declarationsResume.urgentes > 0 ? 'var(--accent-warn)' : undefined },
              { count: declarationsResume.enCours, label: 'en cours', tone: undefined },
              { count: declarationsResume.termineesCetteSemaine, label: 'terminées cette semaine', tone: undefined }
            ] as const).map((item) => (
              <div key={item.label} className="rounded-lg px-3 py-2.5 text-center" style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}>
                <p className="text-lg font-bold" style={{ color: item.tone ?? 'var(--text-pri)' }}>{item.count}</p>
                <p className="text-[10px] leading-snug" style={{ color: 'var(--text-ter)' }}>{item.label}</p>
              </div>
            ))}
          </div>
        </Card>
      )}

      {/* Carte temps reel des missions actives */}
      <Card className="p-5 mb-6">
        <div className="flex items-center justify-between mb-4">
          <div className="flex items-center gap-2">
            <MapPin size={16} style={{ color: 'var(--accent)' }} />
            <h3 className="text-sm font-semibold" style={{ color: 'var(--text-pri)' }}>
              Carte temps reel - Missions actives
            </h3>
            <span className="text-[10px] px-1.5 py-0.5 rounded-full" style={{ background: 'rgba(34,197,94,0.15)', color: '#22c55e' }}>
              {activeMissions.length} mission{activeMissions.length !== 1 ? 's' : ''}
            </span>
          </div>
          <button
            onClick={loadActiveMissions}
            className="p-1.5 rounded-lg transition-colors hover:bg-[var(--card-hover)]"
            style={{ color: 'var(--text-ter)' }}
            title="Actualiser la carte"
          >
            <RefreshCw size={14} />
          </button>
        </div>

        {/* Mini KPIs missions */}
        <div className="grid grid-cols-2 md:grid-cols-5 gap-2 mb-4">
          <div className="rounded-lg px-3 py-2 text-center" style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}>
            <p className="text-lg font-bold" style={{ color: DEPLACEMENT_ETAPE_COLOR.en_route }}>{missionStats.enRoute}</p>
            <p className="text-[10px]" style={{ color: 'var(--text-ter)' }}>En route</p>
          </div>
          <div className="rounded-lg px-3 py-2 text-center" style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}>
            <p className="text-lg font-bold" style={{ color: DEPLACEMENT_ETAPE_COLOR.arrive }}>{missionStats.arrive}</p>
            <p className="text-[10px]" style={{ color: 'var(--text-ter)' }}>Arrive</p>
          </div>
          <div className="rounded-lg px-3 py-2 text-center" style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}>
            <p className="text-lg font-bold" style={{ color: DEPLACEMENT_ETAPE_COLOR.mission_en_cours }}>{missionStats.missionEnCours}</p>
            <p className="text-[10px]" style={{ color: 'var(--text-ter)' }}>En mission</p>
          </div>
          <div className="rounded-lg px-3 py-2 text-center" style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}>
            <p className="text-lg font-bold" style={{ color: DEPLACEMENT_ETAPE_COLOR.retour }}>{missionStats.retour}</p>
            <p className="text-[10px]" style={{ color: 'var(--text-ter)' }}>Retour</p>
          </div>
          <div className="rounded-lg px-3 py-2 text-center" style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}>
            <p className="text-lg font-bold" style={{ color: '#22c55e' }}>{missionStats.avecGps}</p>
            <p className="text-[10px]" style={{ color: 'var(--text-ter)' }}>Avec GPS</p>
          </div>

        </div>
        {/* Carte */}
        {missionsLoading ? (
          <div className="flex items-center justify-center py-12">
            <p className="text-sm" style={{ color: 'var(--text-ter)' }}>Chargement de la carte...</p>
          </div>
        ) : (
          <MissionMap
            missions={activeMissions}
            height={420}
            onMissionClick={() => {}}
          />
        )}

        {/* Liste miniature des missions */}
        {activeMissions.length > 0 && (
          <div className="mt-3 space-y-1">
            <p className="text-[10px] uppercase tracking-wide font-semibold" style={{ color: 'var(--text-ter)' }}>
              Missions actives ({activeMissions.length})
            </p>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-1.5">
              {activeMissions.map((m) => {
                const statut = m.deplacement.statut;
                const color = DEPLACEMENT_ETAPE_COLOR[statut];
                return (
                  <div
                    key={m.deplacement.id}
                    className="flex items-center gap-2 rounded-lg px-2.5 py-1.5 text-xs"
                    style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}
                  >
                    <span className="rounded-full shrink-0" style={{ width: 7, height: 7, background: color }} />
                    <span className="font-mono font-medium" style={{ color: 'var(--text-pri)' }}>{m.deplacement.numero}</span>
                    <span className="truncate" style={{ color: 'var(--text-sec)' }}>
                      {m.deplacement.destination ?? '---'}
                    </span>
                    {m.chauffeur && (
                      <span className="shrink-0 flex items-center gap-0.5 ml-auto" style={{ color: 'var(--text-ter)' }}>
                        <UserIcon size={10} /> {m.chauffeur.nom}
                      </span>
                    )}
                    {m.lastGpsPoint?.vitesse != null && (
                      <span className="shrink-0" style={{ color: 'var(--text-ter)' }}>
                        {m.lastGpsPoint.vitesse.toFixed(0)} km/h
                      </span>
                    )}
                  </div>
                );
              })}
            </div>
          </div>
        )}
      </Card>

      {/* Graphiques */}
      <div className="grid grid-cols-1 xl:grid-cols-2 gap-4 mb-6">
        <Card className="p-5">
          <h3 className="text-sm font-semibold mb-4" style={{ color: 'var(--text-pri)' }}>
            Activite par direction / service demandeur
          </h3>
          {parDirectionChart.length === 0 ? (
            <p className="text-sm py-10 text-center" style={{ color: 'var(--text-ter)' }}>
              Aucune demande enregistree pour le moment.
            </p>
          ) : (
            <ResponsiveContainer width="100%" height={260}>
              <BarChart data={parDirectionChart} layout="vertical" margin={{ left: 8 }}>
                <defs>
                  <linearGradient id="logisDirGrad" x1="0" y1="0" x2="1" y2="0">
                    <stop offset="0%" stopColor="#6366F1" />
                    <stop offset="100%" stopColor="#8B5CF6" />
                  </linearGradient>
                </defs>
                <XAxis type="number" allowDecimals={false} tick={{ fontSize: 10, fill: 'var(--text-ter)' }} />
                <YAxis type="category" dataKey="direction" width={150} tick={{ fontSize: 11, fill: 'var(--text-sec)' }} />
                <Tooltip contentStyle={{ background: 'var(--card)', border: '1px solid var(--border)', borderRadius: 8, fontSize: 12 }} />
                <Bar dataKey="count" name="Demandes" fill="url(#logisDirGrad)" radius={[0, 8, 8, 0]} isAnimationActive />
              </BarChart>
            </ResponsiveContainer>
          )}
        </Card>

        <Card className="p-5">
          <h3 className="text-sm font-semibold mb-4" style={{ color: 'var(--text-pri)' }}>
            Repartition par statut
          </h3>
          {parStatutChart.length === 0 ? (
            <p className="text-sm py-10 text-center" style={{ color: 'var(--text-ter)' }}>
              Aucune demande enregistree pour le moment.
            </p>
          ) : (
            <div className="flex items-center gap-4">
              <ResponsiveContainer width="55%" height={220}>
                <PieChart>
                  <Pie data={parStatutChart} dataKey="value" nameKey="name" innerRadius={45} outerRadius={80} paddingAngle={2}>
                    {parStatutChart.map((entry) => (
                      <Cell key={entry.statut} fill={STATUS_COLORS[entry.statut] ?? '#94a3b8'} />
                    ))}
                  </Pie>
                  <Tooltip contentStyle={{ background: 'var(--card)', border: '1px solid var(--border)', borderRadius: 8, fontSize: 12 }} />
                </PieChart>
              </ResponsiveContainer>
              <div className="flex-1 space-y-1.5">
                {parStatutChart.map((entry) => (
                  <div key={entry.statut} className="flex items-center justify-between text-xs">
                    <span className="flex items-center gap-1.5" style={{ color: 'var(--text-sec)' }}>
                      <span className="rounded-full shrink-0" style={{ width: 7, height: 7, background: STATUS_COLORS[entry.statut] ?? '#94a3b8' }} />
                      {entry.name}
                    </span>
                    <span className="font-semibold" style={{ color: 'var(--text-pri)' }}>{entry.value}</span>
                  </div>
                ))}
              </div>
            </div>
          )}
        </Card>
      </div>

      {/* Admin Mission Dashboard */}
      <div className="mt-8 mb-6">
        <Card className="p-5">
          <AdminMissionDashboard />
        </Card>
      </div>

      {/* Demandes urgentes */}
      <Card className="p-5">
        <div className="flex items-center justify-between mb-4">
          <h3 className="text-sm font-semibold" style={{ color: 'var(--text-pri)' }}>
            Demandes urgentes / critiques en attente
          </h3>
          <Link to="/logistique/demandes?priorite=urgente" className="text-xs flex items-center gap-1" style={{ color: 'var(--accent)' }}>
            Tout voir <ArrowRight size={12} />
          </Link>
        </div>
        {urgentesEnAttente.length === 0 ? (
          <p className="text-sm py-6 text-center" style={{ color: 'var(--text-ter)' }}>
            {loading ? 'Chargement...' : 'Aucune demande urgente en attente.'}
          </p>
        ) : (
          <div className="space-y-2">
            {urgentesEnAttente.map((d) => {
              const serviceName = nodes.find((n) => n.id === d.serviceDemandeurId)?.name ?? '---';
              return (
                <Link
                  key={d.id}
                  to={`/logistique/demandes?q=${encodeURIComponent(d.numero)}`}
                  className="flex items-center gap-3 rounded-lg px-3 py-2 transition-colors hover:bg-[var(--card-hover)]"
                  style={{ border: '1px solid var(--border)' }}
                >
                  <Badge tone={PRIORITY_TONE[d.priorite]}>{PRIORITY_LABELS[d.priorite]}</Badge>
                  <span className="text-xs font-mono" style={{ color: 'var(--text-ter)' }}>{d.numero}</span>
                  <span className="text-sm flex-1 truncate" style={{ color: 'var(--text-pri)' }}>{d.objet}</span>
                  <span className="text-xs hidden md:inline" style={{ color: 'var(--text-ter)' }}>{serviceName}</span>
                  <span className="text-xs hidden sm:inline" style={{ color: 'var(--text-ter)' }}>{TYPE_LABELS[d.type]}</span>
                  <Badge tone={STATUS_TONE[d.statut]}>{STATUS_LABELS[d.statut]}</Badge>
                </Link>
              );
            })}
          </div>
        )}
      </Card>
    </div>
  );
}
