/**
 * AdminMissionDashboard — Tableau de bord professionnel pour le suivi
 * en temps réel des missions (déplacements).
 *
 * Affiche :
 *   - Statistiques globales avec tous les statuts
 *   - Cartes missions complètes avec tous les détails
 *   - Filtres par statut, recherche, date
 *   - Timeline + métriques pour chaque mission
 *   - Informations : passagers, chauffeur, véhicule, service, durée, ville
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import {
  Car, MapPin, Users, Clock, Loader2,
  RefreshCw, Search, ChevronDown, ChevronUp, Eye, X, CalendarDays,
  Gauge, Navigation, User as UserIcon, Building2, Fuel, Route,
  StickyNote, Camera, PenLine, History, Play, Home, Flag, Ban, ArrowRight,
  CheckCircle2
} from 'lucide-react';
import { api } from '../../lib/api';
import { useOrg } from '../../context/OrgContext';
import type {
  Deplacement, DeplacementStatut, DeplacementDetail, MissionEvent,
  MissionPhoto, DeplacementPassager, Vehicule, Chauffeur
} from '../../types/parcAuto';
import {
  DEPLACEMENT_STATUT_LABELS, DEPLACEMENT_STATUT_TONE,
  DEPLACEMENT_ETAPES, DEPLACEMENT_ETAPE_COLOR
} from '../../types/parcAuto';

/* ── Types ─────────────────────────────────────────────────────────── */

interface DashboardStats {
  total: number;
  creee: number;
  enAttente: number;
  acceptee: number;
  enRoute: number;
  arrive: number;
  missionEnCours: number;
  terminee: number;
  retour: number;
  arriveSiege: number;
  cloturee: number;
  annule: number;
  actives: number;
}

interface DashboardData {
  deplacements: Deplacement[];
  vehicules: Vehicule[];
  chauffeurs: Chauffeur[];
}

/* ── Helpers ────────────────────────────────────────────────────────── */

function formatDuree(minutes: number | null): string {
  if (minutes == null) return '—';
  const h = Math.floor(minutes / 60);
  const m = minutes % 60;
  return `${h}h${m.toString().padStart(2, '0')}m`;
}

/* ── Composant de carte statistique ─────────────────────────────────── */

function StatCard({ label, value, color }: { label: string; value: number; color: string }) {
  return (
    <div
      className="rounded-xl px-3 py-2.5 transition-colors hover:bg-[var(--card-hover)]"
      style={{ background: 'var(--card)', border: '1px solid var(--border)' }}
    >
      <p className="text-xl font-bold" style={{ color }}>{value}</p>
      <p className="text-[10px] mt-0.5 truncate" style={{ color: 'var(--text-ter)' }}>{label}</p>
    </div>
  );
}

/* ═══════════════════════════════════════════════════════════════════════
 * MODAL DE DÉTAIL COMPLET
 * ═══════════════════════════════════════════════════════════════════════ */

function MissionDetailModal({
  detail,
  chauffeursMap,
  vehiculesMap,
  serviceName,
  onClose,
}: {
  detail: DeplacementDetail;
  chauffeursMap: Map<number, Chauffeur>;
  vehiculesMap: Map<number, Vehicule>;
  serviceName: string;
  onClose: () => void;
}) {
  const { deplacement, events, photos, passagers } = detail;
  const chauffeur = deplacement.chauffeurId ? chauffeursMap.get(deplacement.chauffeurId) : null;
  const vehicule = deplacement.vehiculeId ? vehiculesMap.get(deplacement.vehiculeId) : null;

  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center p-4"
      style={{ background: 'rgba(0,0,0,0.5)' }}
      onClick={onClose}
    >
      <div
        className="rounded-2xl overflow-hidden w-full max-w-2xl max-h-[85vh] overflow-y-auto"
        style={{ background: 'var(--card)', border: '1px solid var(--border)' }}
        onClick={(e) => e.stopPropagation()}
      >
        {/* En-tête */}
        <div className="px-5 py-4 sticky top-0 z-10 flex items-center justify-between"
          style={{ background: 'var(--card)', borderBottom: '1px solid var(--border)' }}>
          <div>
            <p className="text-sm font-bold" style={{ color: 'var(--text-pri)' }}>
              {deplacement.numero} — {deplacement.objet}
            </p>
            <p className="text-xs" style={{ color: 'var(--text-ter)' }}>
              {deplacement.destination ?? '—'} · {serviceName}
            </p>
          </div>
          <button onClick={onClose} className="p-1.5 rounded-lg hover:bg-[var(--card-hover)] transition-colors">
            <X size={16} style={{ color: 'var(--text-ter)' }} />
          </button>
        </div>

        <div className="px-5 py-4 space-y-5">
          {/* Statut + progression */}
          <div className="flex items-center justify-between">
            <span
              className="px-2 py-1 rounded text-xs font-medium"
              style={{
                background: `${DEPLACEMENT_ETAPE_COLOR[deplacement.statut]}20`,
                color: DEPLACEMENT_ETAPE_COLOR[deplacement.statut],
              }}
            >
              {DEPLACEMENT_STATUT_LABELS[deplacement.statut]}
            </span>
          </div>

          <div className="flex items-center gap-1">
            {DEPLACEMENT_ETAPES.map((etape) => {
              const curIdx = DEPLACEMENT_ETAPES.indexOf(deplacement.statut);
              const etaIdx = DEPLACEMENT_ETAPES.indexOf(etape);
              return (
                <span
                  key={etape}
                  className="block h-2 flex-1 rounded-full"
                  style={{
                    background: etaIdx <= curIdx ? DEPLACEMENT_ETAPE_COLOR[etape] : 'var(--border)',
                  }}
                />
              );
            })}
          </div>

          {/* Grille d'informations */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-3">
            <div className="rounded-lg p-3" style={{ background: 'var(--bg)' }}>
              <p className="text-[10px] uppercase tracking-wide font-semibold mb-2" style={{ color: 'var(--text-ter)' }}>Mission</p>
              <div className="space-y-1.5 text-xs">
                <p><span style={{ color: 'var(--text-ter)' }}>Ville :</span> <span className="font-medium" style={{ color: 'var(--text-pri)' }}>{deplacement.destination ?? '—'}</span></p>
                <p><span style={{ color: 'var(--text-ter)' }}>Objet :</span> <span className="font-medium" style={{ color: 'var(--text-pri)' }}>{deplacement.objet}</span></p>
                <p><span style={{ color: 'var(--text-ter)' }}>Service :</span> <span className="font-medium" style={{ color: 'var(--text-pri)' }}>{serviceName}</span></p>
                <p><span style={{ color: 'var(--text-ter)' }}>Date départ :</span> <span className="font-medium" style={{ color: 'var(--text-pri)' }}>{deplacement.dateDepart}</span></p>
                {deplacement.dateRetourPrevue && <p><span style={{ color: 'var(--text-ter)' }}>Retour prévu :</span> <span className="font-medium" style={{ color: 'var(--text-pri)' }}>{deplacement.dateRetourPrevue}</span></p>}
              </div>
            </div>
            <div className="rounded-lg p-3" style={{ background: 'var(--bg)' }}>
              <p className="text-[10px] uppercase tracking-wide font-semibold mb-2" style={{ color: 'var(--text-ter)' }}>Chauffeur & Véhicule</p>
              <div className="space-y-1.5 text-xs">
                {chauffeur ? (
                  <>
                    <p><span style={{ color: 'var(--text-ter)' }}>Nom :</span> <span className="font-medium" style={{ color: 'var(--text-pri)' }}>{chauffeur.nom}</span></p>
                    {chauffeur.telephone && <p><span style={{ color: 'var(--text-ter)' }}>Tél :</span> <span className="font-medium" style={{ color: 'var(--text-pri)' }}>{chauffeur.telephone}</span></p>}
                    {chauffeur.permis && <p><span style={{ color: 'var(--text-ter)' }}>Permis :</span> <span className="font-medium" style={{ color: 'var(--text-pri)' }}>{chauffeur.permis}</span></p>}
                  </>
                ) : <p style={{ color: 'var(--text-ter)' }}>Non assigné</p>}
                {vehicule && (
                  <p className="mt-1"><span style={{ color: 'var(--text-ter)' }}>Véhicule :</span> <span className="font-medium" style={{ color: 'var(--text-pri)' }}>{vehicule.marque} {vehicule.modele} ({vehicule.immatriculation})</span></p>
                )}
              </div>
            </div>
            <div className="rounded-lg p-3" style={{ background: 'var(--bg)' }}>
              <p className="text-[10px] uppercase tracking-wide font-semibold mb-2" style={{ color: 'var(--text-ter)' }}>Métriques</p>
              <div className="space-y-1.5 text-xs">
                <p><span style={{ color: 'var(--text-ter)' }}>Km départ :</span> <span className="font-medium" style={{ color: 'var(--text-pri)' }}>{deplacement.kilometrageDepart?.toLocaleString('fr-FR') ?? '—'} km</span></p>
                <p><span style={{ color: 'var(--text-ter)' }}>Km retour :</span> <span className="font-medium" style={{ color: 'var(--text-pri)' }}>{deplacement.kilometrageRetour?.toLocaleString('fr-FR') ?? '—'} km</span></p>
                <p><span style={{ color: 'var(--text-ter)' }}>Durée :</span> <span className="font-medium" style={{ color: 'var(--text-pri)' }}>{formatDuree(deplacement.dureeMission)}</span></p>
                {deplacement.distanceKm != null && <p><span style={{ color: 'var(--text-ter)' }}>Distance :</span> <span className="font-medium" style={{ color: 'var(--text-pri)' }}>{deplacement.distanceKm} km</span></p>}
                {deplacement.consommationCarburant != null && <p><span style={{ color: 'var(--text-ter)' }}>Carburant :</span> <span className="font-medium" style={{ color: 'var(--text-pri)' }}>{deplacement.consommationCarburant} L</span></p>}
              </div>
            </div>
          </div>

          {/* Passagers */}
          {passagers && passagers.length > 0 && (
            <div className="rounded-lg p-3" style={{ background: 'var(--bg)' }}>
              <p className="text-[10px] uppercase tracking-wide font-semibold mb-2 flex items-center gap-1">
                <Users size={12} /> Personnel transporté ({passagers.length})
              </p>
              <div className="space-y-1">
                {passagers.map((p) => (
                  <div key={p.id} className="text-xs flex items-center justify-between">
                    <span className="font-medium" style={{ color: 'var(--text-pri)' }}>{p.nom}</span>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Timeline complète */}
          <div>
            <p className="text-[10px] uppercase tracking-wide font-semibold mb-2 flex items-center gap-1">
              <History size={12} /> Timeline ({events.length} événement{events.length > 1 ? 's' : ''})
            </p>
            <div className="space-y-2">
              {events.length === 0 && (
                <p className="text-xs" style={{ color: 'var(--text-ter)' }}>Aucun événement.</p>
              )}
              {events.map((event) => (
                <div key={event.id} className="flex items-start gap-2">
                  <div
                    className="w-2.5 h-2.5 rounded-full mt-0.5 shrink-0"
                    style={{ background: DEPLACEMENT_ETAPE_COLOR[event.statut as DeplacementStatut] ?? 'var(--text-ter)' }}
                  />
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center justify-between">
                      <p className="text-xs font-medium" style={{ color: 'var(--text-pri)' }}>
                        {DEPLACEMENT_STATUT_LABELS[event.statut as DeplacementStatut] ?? event.statut}
                      </p>
                      <span className="text-[10px]" style={{ color: 'var(--text-ter)' }}>
                        {new Date(event.createdAt).toLocaleString('fr-FR', {
                          day: '2-digit', month: '2-digit', hour: '2-digit', minute: '2-digit'
                        })}
                      </span>
                    </div>
                    <p className="text-[11px]" style={{ color: 'var(--text-ter)' }}>par {event.actionPar}</p>
                    {event.commentaire && event.commentaire !== event.actionPar && (
                      <p className="text-[11px]" style={{ color: 'var(--text-sec)' }}>{event.commentaire}</p>
                    )}
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Photos */}
          {photos && photos.length > 0 && (
            <div>
              <p className="text-[10px] uppercase tracking-wide font-semibold mb-2 flex items-center gap-1">
                <Camera size={12} /> Photos ({photos.length})
              </p>
              <div className="grid grid-cols-3 sm:grid-cols-4 gap-2">
                {photos.map((photo) => (
                  <div key={photo.id} className="rounded-lg overflow-hidden" style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}>
                    <div className="aspect-square flex items-center justify-center">
                      <Camera size={20} style={{ color: 'var(--text-ter)' }} />
                    </div>
                    <div className="px-1 py-0.5">
                      <p className="text-[9px] truncate" style={{ color: 'var(--text-ter)' }}>{photo.originalName ?? photo.filename}</p>
                      <p className="text-[8px]" style={{ color: 'var(--text-ter)' }}>{photo.type}</p>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

/* ═══════════════════════════════════════════════════════════════════════
 * COMPOSANT PRINCIPAL
 * ═══════════════════════════════════════════════════════════════════════ */

export default function AdminMissionDashboard() {
  const { nodes } = useOrg();
  const [data, setData] = useState<DashboardData | null>(null);
  const [stats, setStats] = useState<DashboardStats | null>(null);
  const [selectedMission, setSelectedMission] = useState<DeplacementDetail | null>(null);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [statutFilter, setStatutFilter] = useState<DeplacementStatut | 'all'>('all');
  const [expandedId, setExpandedId] = useState<number | null>(null);
  const [tick, setTick] = useState(0);

  const loadData = useCallback(async () => {
    setLoading(true);
    try {
      const [depRes, vehRes, chaufRes] = await Promise.all([
        api.get<{ deplacements: Deplacement[] }>('/parc-auto/deplacements'),
        api.get<{ vehicules: Vehicule[] }>('/parc-auto/vehicules'),
        api.get<{ chauffeurs: Chauffeur[] }>('/chauffeurs'),
      ]);
      const all = depRes.deplacements;

      setData({
        deplacements: all,
        vehicules: vehRes.vehicules,
        chauffeurs: chaufRes.chauffeurs,
      });

      setStats({
        total: all.length,
        creee: all.filter((m) => m.statut === 'creee').length,
        enAttente: all.filter((m) => m.statut === 'en_attente_acceptation').length,
        acceptee: all.filter((m) => m.statut === 'acceptee').length,
        enRoute: all.filter((m) => m.statut === 'en_route').length,
        arrive: all.filter((m) => m.statut === 'arrive').length,
        missionEnCours: all.filter((m) => m.statut === 'mission_en_cours').length,
        terminee: all.filter((m) => m.statut === 'terminee').length,
        retour: all.filter((m) => m.statut === 'retour').length,
        arriveSiege: all.filter((m) => m.statut === 'arrive_siege').length,
        cloturee: all.filter((m) => m.statut === 'cloturee').length,
        annule: all.filter((m) => m.statut === 'annule').length,
        actives: all.filter((m) => !['cloturee', 'annule'].includes(m.statut)).length,
      });
    } catch {
      // ignore
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { loadData(); }, [loadData, tick]);
  // Auto-refresh every 15s
  useEffect(() => {
    const interval = setInterval(() => setTick((t) => t + 1), 15_000);
    return () => clearInterval(interval);
  }, []);

  const loadMissionDetail = async (id: number) => {
    try {
      const res = await api.get<DeplacementDetail>(`/parc-auto/deplacements/${id}`);
      setSelectedMission(res);
    } catch {
      // ignore
    }
  };

  const vehiculesMap = useMemo(() => {
    const map = new Map<number, Vehicule>();
    data?.vehicules.forEach((v) => map.set(v.id, v));
    return map;
  }, [data?.vehicules]);

  const chauffeursMap = useMemo(() => {
    const map = new Map<number, Chauffeur>();
    data?.chauffeurs.forEach((c) => map.set(c.id, c));
    return map;
  }, [data?.chauffeurs]);

  const filtered = useMemo(() => {
    return (data?.deplacements ?? []).filter((m) => {
      if (statutFilter !== 'all' && m.statut !== statutFilter) return false;
      if (search.trim()) {
        const s = search.toLowerCase();
        const chauffeur = m.chauffeurId ? chauffeursMap.get(m.chauffeurId) : null;
        const vehicule = m.vehiculeId ? vehiculesMap.get(m.vehiculeId) : null;
        return (
          m.numero.toLowerCase().includes(s) ||
          m.objet.toLowerCase().includes(s) ||
          (m.destination?.toLowerCase().includes(s) ?? false) ||
          (chauffeur?.nom?.toLowerCase().includes(s) ?? false) ||
          (vehicule?.immatriculation?.toLowerCase().includes(s) ?? false)
        );
      }
      return true;
    });
  }, [data?.deplacements, statutFilter, search, chauffeursMap, vehiculesMap]);

  const isEtapeAtteinte = (statut: DeplacementStatut, etape: DeplacementStatut) => {
    const curIdx = DEPLACEMENT_ETAPES.indexOf(statut);
    const etaIdx = DEPLACEMENT_ETAPES.indexOf(etape);
    if (curIdx === -1 || etaIdx === -1) return false;
    return etaIdx <= curIdx;
  };

  return (
    <div className="space-y-6">
      {/* En-tête avec rafraîchissement */}
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-lg font-bold" style={{ color: 'var(--text-pri)' }}>
            Tableau de bord des missions
          </h2>
          <p className="text-xs" style={{ color: 'var(--text-ter)' }}>
            Suivi en temps réel · Actualisation automatique toutes les 15s
          </p>
        </div>
        <button
          onClick={() => setTick((t) => t + 1)}
          className="p-2 rounded-lg transition-colors hover:bg-[var(--card-hover)]"
          style={{ color: 'var(--text-ter)' }}
          title="Actualiser"
        >
          <RefreshCw size={16} className={loading ? 'animate-spin' : ''} />
        </button>
      </div>

      {/* Statistiques complètes */}
      {stats && (
        <div className="space-y-3">
          <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-2">
            <StatCard label="Total" value={stats.total} color="#6b7280" />
            <StatCard label="Actives" value={stats.actives} color="#3b82f6" />
            <StatCard label="Créées" value={stats.creee} color="#6b7280" />
            <StatCard label="En attente" value={stats.enAttente} color="#f59e0b" />
            <StatCard label="Acceptées" value={stats.acceptee} color="#22c55e" />
            <StatCard label="En route" value={stats.enRoute} color="#3b82f6" />
          </div>
          <div className="grid grid-cols-2 md:grid-cols-5 gap-2">
            <StatCard label="Arrivé" value={stats.arrive} color="#8b5cf6" />
            <StatCard label="Mission en cours" value={stats.missionEnCours} color="#22c55e" />
            <StatCard label="Terminée" value={stats.terminee} color="#14b8a6" />
            <StatCard label="Retour" value={stats.retour} color="#f97316" />
            <StatCard label="Arrivé siège" value={stats.arriveSiege} color="#06b6d4" />
          </div>
          <div className="grid grid-cols-2 gap-2">
            <StatCard label="Clôturées" value={stats.cloturee} color="#10b981" />
            <StatCard label="Annulées" value={stats.annule} color="#ef4444" />
          </div>
        </div>
      )}

      {/* Filtres professionnels */}
      <div className="flex flex-wrap items-center gap-2">
        <div className="relative flex-1 min-w-[200px]">
          <Search size={14} className="absolute left-3 top-1/2 -translate-y-1/2" style={{ color: 'var(--text-ter)' }} />
          <input
            type="text"
            placeholder="Rechercher (n°, objet, ville, chauffeur, immatriculation…)"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="w-full pl-9 pr-3 py-2 rounded-lg text-sm"
            style={{ background: 'var(--bg)', color: 'var(--text-pri)', border: '1px solid var(--border)' }}
          />
        </div>
        <select
          value={statutFilter}
          onChange={(e) => setStatutFilter(e.target.value as DeplacementStatut | 'all')}
          className="px-3 py-2 rounded-lg text-sm"
          style={{ background: 'var(--bg)', color: 'var(--text-pri)', border: '1px solid var(--border)' }}
        >
          <option value="all">Tous les statuts</option>
          {DEPLACEMENT_ETAPES.map((s) => (
            <option key={s} value={s}>{DEPLACEMENT_STATUT_LABELS[s]}</option>
          ))}
          <option value="annule">Annulé</option>
        </select>
      </div>

      {/* Indicateur de résultats */}
      {!loading && (
        <p className="text-xs" style={{ color: 'var(--text-ter)' }}>
          {filtered.length} mission{filtered.length !== 1 ? 's' : ''} trouvée{filtered.length !== 1 ? 's' : ''}
        </p>
      )}

      {/* Chargement */}
      {loading && (
        <div className="flex items-center justify-center py-12">
          <Loader2 size={24} className="animate-spin" style={{ color: 'var(--text-ter)' }} />
        </div>
      )}

      {/* Aucune mission */}
      {!loading && filtered.length === 0 && (
        <div className="text-center py-12">
          <CheckCircle2 size={32} className="mx-auto mb-2" style={{ color: 'var(--text-ter)' }} />
          <p className="text-sm" style={{ color: 'var(--text-ter)' }}>Aucune mission trouvée.</p>
        </div>
      )}

      {/* Liste des missions — cartes professionnelles */}
      <div className="space-y-3">
        {filtered.map((mission) => {
          const chauffeur = mission.chauffeurId ? chauffeursMap.get(mission.chauffeurId) : null;
          const vehicule = mission.vehiculeId ? vehiculesMap.get(mission.vehiculeId) : null;
          const serviceName = nodes.find((n) => n.id === mission.serviceDemandeurId)?.name ?? '—';
          const isExpanded = expandedId === mission.id;

          return (
            <div
              key={mission.id}
              className="rounded-xl overflow-hidden transition-all"
              style={{
                background: 'var(--card)',
                border: `1px solid ${
                  isExpanded ? DEPLACEMENT_ETAPE_COLOR[mission.statut] : 'var(--border)'
                }`,
                boxShadow: isExpanded ? `0 0 0 1px ${DEPLACEMENT_ETAPE_COLOR[mission.statut]}40` : 'none',
              }}
            >
              {/* En-tête cliquable */}
              <div
                className="px-4 py-3 flex items-center justify-between cursor-pointer hover:bg-[var(--card-hover)] transition-colors"
                onClick={() => setExpandedId(isExpanded ? null : mission.id)}
              >
                <div className="flex items-center gap-3 min-w-0 flex-1">
                  <div
                    className="w-3 h-3 rounded-full shrink-0"
                    style={{ background: DEPLACEMENT_ETAPE_COLOR[mission.statut] ?? 'var(--text-ter)' }}
                  />
                  <div className="min-w-0 flex-1">
                    <div className="flex items-center gap-2">
                      <p className="text-sm font-semibold" style={{ color: 'var(--text-pri)' }}>
                        {mission.numero}
                      </p>
                      <span
                        className="px-1.5 py-0.5 rounded text-[10px] font-medium"
                        style={{
                          background: `${DEPLACEMENT_ETAPE_COLOR[mission.statut]}20`,
                          color: DEPLACEMENT_ETAPE_COLOR[mission.statut],
                        }}
                      >
                        {DEPLACEMENT_STATUT_LABELS[mission.statut]}
                      </span>
                    </div>
                    <p className="text-xs truncate" style={{ color: 'var(--text-ter)' }}>
                      {mission.objet}
                      {mission.destination ? ` · ${mission.destination}` : ''}
                      {chauffeur ? ` · ${chauffeur.nom}` : ''}
                    </p>
                  </div>
                </div>
                <div className="flex items-center gap-2 shrink-0">
                  <button
                    onClick={(e) => { e.stopPropagation(); loadMissionDetail(mission.id); }}
                    className="p-1.5 rounded-lg hover:bg-[var(--card-hover)] transition-colors"
                    style={{ color: 'var(--text-ter)' }}
                    title="Voir le détail complet"
                  >
                    <Eye size={14} />
                  </button>
                  {isExpanded ? <ChevronUp size={16} style={{ color: 'var(--text-ter)' }} /> : <ChevronDown size={16} style={{ color: 'var(--text-ter)' }} />}
                </div>
              </div>

              {/* Contenu étendu — TOUS les détails */}
              {isExpanded && (
                <div className="px-4 pb-4 space-y-4" style={{ borderTop: '1px solid var(--border)' }}>
                  {/* Barre de progression */}
                  <div className="pt-3">
                    <p className="text-[10px] uppercase tracking-wide mb-1.5" style={{ color: 'var(--text-ter)' }}>Progression</p>
                    <div className="flex items-center gap-1">
                      {DEPLACEMENT_ETAPES.map((etape) => (
                        <span
                          key={etape}
                          className="block h-2 flex-1 rounded-full transition-all duration-500"
                          style={{
                            background: isEtapeAtteinte(mission.statut, etape)
                              ? DEPLACEMENT_ETAPE_COLOR[etape]
                              : 'var(--border)',
                          }}
                        />
                      ))}
                    </div>
                    <div className="flex items-center justify-between mt-0.5">
                      {DEPLACEMENT_ETAPES.map((etape) => (
                        <span
                          key={etape}
                          className="text-[7px] uppercase text-center"
                          style={{
                            color: isEtapeAtteinte(mission.statut, etape)
                              ? DEPLACEMENT_ETAPE_COLOR[etape]
                              : 'var(--text-ter)',
                            width: `${100 / DEPLACEMENT_ETAPES.length}%`,
                          }}
                        >
                          {etape === 'en_attente_acceptation' ? 'Attente' :
                           etape === 'mission_en_cours' ? 'Mission' :
                           etape === 'arrive_siege' ? 'Siège' :
                           DEPLACEMENT_STATUT_LABELS[etape].slice(0, 6)}
                        </span>
                      ))}
                    </div>
                  </div>

                  {/* Grille des informations principales */}
                  <div className="grid grid-cols-1 md:grid-cols-3 gap-3">
                    {/* Colonne 1 : Mission */}
                    <div className="space-y-2 rounded-lg p-3" style={{ background: 'var(--bg)' }}>
                      <p className="text-[10px] uppercase tracking-wide font-semibold" style={{ color: 'var(--text-ter)' }}>Mission</p>
                      <div className="space-y-1.5 text-xs">
                        <div className="flex items-center gap-1.5">
                          <MapPin size={11} style={{ color: 'var(--text-ter)' }} />
                          <span style={{ color: 'var(--text-sec)' }}>Ville :</span>
                          <span className="font-medium" style={{ color: 'var(--text-pri)' }}>{mission.destination ?? '—'}</span>
                        </div>
                        <div className="flex items-center gap-1.5">
                          <StickyNote size={11} style={{ color: 'var(--text-ter)' }} />
                          <span style={{ color: 'var(--text-sec)' }}>Objet :</span>
                          <span className="font-medium" style={{ color: 'var(--text-pri)' }}>{mission.objet}</span>
                        </div>
                        <div className="flex items-center gap-1.5">
                          <Building2 size={11} style={{ color: 'var(--text-ter)' }} />
                          <span style={{ color: 'var(--text-sec)' }}>Service :</span>
                          <span className="font-medium" style={{ color: 'var(--text-pri)' }}>{serviceName}</span>
                        </div>
                        <div className="flex items-center gap-1.5">
                          <CalendarDays size={11} style={{ color: 'var(--text-ter)' }} />
                          <span style={{ color: 'var(--text-sec)' }}>Départ :</span>
                          <span className="font-medium" style={{ color: 'var(--text-pri)' }}>{mission.dateDepart}</span>
                        </div>
                        {mission.dateRetourPrevue && (
                          <div className="flex items-center gap-1.5">
                            <CalendarDays size={11} style={{ color: 'var(--text-ter)' }} />
                            <span style={{ color: 'var(--text-sec)' }}>Retour prévu :</span>
                            <span className="font-medium" style={{ color: 'var(--text-pri)' }}>{mission.dateRetourPrevue}</span>
                          </div>
                        )}
                        {mission.heureDepartPrevue && (
                          <div className="flex items-center gap-1.5">
                            <Clock size={11} style={{ color: 'var(--text-ter)' }} />
                            <span style={{ color: 'var(--text-sec)' }}>Heure départ :</span>
                            <span className="font-medium" style={{ color: 'var(--text-pri)' }}>{mission.heureDepartPrevue}</span>
                          </div>
                        )}
                      </div>
                    </div>

                    {/* Colonne 2 : Chauffeur & Véhicule */}
                    <div className="space-y-2 rounded-lg p-3" style={{ background: 'var(--bg)' }}>
                      <p className="text-[10px] uppercase tracking-wide font-semibold" style={{ color: 'var(--text-ter)' }}>Chauffeur & Véhicule</p>
                      <div className="space-y-1.5 text-xs">
                        {chauffeur ? (
                          <>
                            <div className="flex items-center gap-1.5">
                              <UserIcon size={11} style={{ color: 'var(--text-ter)' }} />
                              <span style={{ color: 'var(--text-sec)' }}>Chauffeur :</span>
                              <span className="font-medium" style={{ color: 'var(--text-pri)' }}>{chauffeur.nom}</span>
                            </div>
                            {chauffeur.telephone && (
                              <div className="flex items-center gap-1.5">
                                <span style={{ color: 'var(--text-ter)' }}>📞</span>
                                <span style={{ color: 'var(--text-sec)' }}>Tél :</span>
                                <span className="font-medium" style={{ color: 'var(--text-pri)' }}>{chauffeur.telephone}</span>
                              </div>
                            )}
                            {chauffeur.permis && (
                              <div className="flex items-center gap-1.5">
                                <span style={{ color: 'var(--text-ter)' }}>🪪</span>
                                <span style={{ color: 'var(--text-sec)' }}>Permis :</span>
                                <span className="font-medium" style={{ color: 'var(--text-pri)' }}>{chauffeur.permis}</span>
                              </div>
                            )}
                          </>
                        ) : (
                          <p style={{ color: 'var(--text-ter)' }}>Aucun chauffeur assigné</p>
                        )}
                        {vehicule && (
                          <>
                            <div className="flex items-center gap-1.5 mt-1">
                              <Car size={11} style={{ color: 'var(--text-ter)' }} />
                              <span style={{ color: 'var(--text-sec)' }}>Véhicule :</span>
                              <span className="font-medium" style={{ color: 'var(--text-pri)' }}>
                                {vehicule.marque} {vehicule.modele} — {vehicule.immatriculation}
                              </span>
                            </div>
                          </>
                        )}
                      </div>
                    </div>

                    {/* Colonne 3 : Métriques */}
                    <div className="space-y-2 rounded-lg p-3" style={{ background: 'var(--bg)' }}>
                      <p className="text-[10px] uppercase tracking-wide font-semibold" style={{ color: 'var(--text-ter)' }}>Métriques</p>
                      <div className="space-y-1.5 text-xs">
                        <div className="flex items-center gap-1.5">
                          <Gauge size={11} style={{ color: 'var(--text-ter)' }} />
                          <span style={{ color: 'var(--text-sec)' }}>Km départ :</span>
                          <span className="font-medium" style={{ color: 'var(--text-pri)' }}>
                            {mission.kilometrageDepart != null ? `${mission.kilometrageDepart.toLocaleString('fr-FR')} km` : '—'}
                          </span>
                        </div>
                        <div className="flex items-center gap-1.5">
                          <Gauge size={11} style={{ color: 'var(--text-ter)' }} />
                          <span style={{ color: 'var(--text-sec)' }}>Km retour :</span>
                          <span className="font-medium" style={{ color: 'var(--text-pri)' }}>
                            {mission.kilometrageRetour != null ? `${mission.kilometrageRetour.toLocaleString('fr-FR')} km` : '—'}
                          </span>
                        </div>
                        <div className="flex items-center gap-1.5">
                          <Clock size={11} style={{ color: 'var(--text-ter)' }} />
                          <span style={{ color: 'var(--text-sec)' }}>Durée :</span>
                          <span className="font-medium" style={{ color: 'var(--text-pri)' }}>
                            {formatDuree(mission.dureeMission)}
                          </span>
                        </div>
                        <div className="flex items-center gap-1.5">
                          <Route size={11} style={{ color: 'var(--text-ter)' }} />
                          <span style={{ color: 'var(--text-sec)' }}>Distance :</span>
                          <span className="font-medium" style={{ color: 'var(--text-pri)' }}>
                            {mission.distanceKm != null ? `${mission.distanceKm} km` : '—'}
                          </span>
                        </div>
                        <div className="flex items-center gap-1.5">
                          <Fuel size={11} style={{ color: 'var(--text-ter)' }} />
                          <span style={{ color: 'var(--text-sec)' }}>Carburant :</span>
                          <span className="font-medium" style={{ color: 'var(--text-pri)' }}>
                            {mission.consommationCarburant != null ? `${mission.consommationCarburant} L` : '—'}
                          </span>
                        </div>
                      </div>
                    </div>
                  </div>

                  {/* Observations */}
                  {(mission.observations || mission.observationsChauffeur || mission.notesCloture) && (
                    <div className="rounded-lg p-3" style={{ background: 'var(--bg)' }}>
                      <p className="text-[10px] uppercase tracking-wide font-semibold mb-1.5" style={{ color: 'var(--text-ter)' }}>Observations</p>
                      <div className="space-y-1 text-xs">
                        {mission.observations && (
                          <p style={{ color: 'var(--text-sec)' }}><span className="font-medium" style={{ color: 'var(--text-pri)' }}>Consignes :</span> {mission.observations}</p>
                        )}
                        {mission.observationsChauffeur && (
                          <p style={{ color: 'var(--text-sec)' }}><span className="font-medium" style={{ color: 'var(--text-pri)' }}>Chauffeur :</span> {mission.observationsChauffeur}</p>
                        )}
                        {mission.notesCloture && (
                          <p style={{ color: 'var(--text-sec)' }}><span className="font-medium" style={{ color: 'var(--text-pri)' }}>Clôture :</span> {mission.notesCloture}</p>
                        )}
                      </div>
                    </div>
                  )}

                  {/* Horodatages réels */}
                  {(mission.heureDepartReelle || mission.heureArriveeReelle || mission.heureRetourReelle || mission.heureCloture) && (
                    <div className="rounded-lg p-3" style={{ background: 'var(--bg)' }}>
                      <p className="text-[10px] uppercase tracking-wide font-semibold mb-1.5" style={{ color: 'var(--text-ter)' }}>Horodatages réels</p>
                      <div className="grid grid-cols-2 gap-1.5 text-xs">
                        {mission.heureDepartReelle && (
                          <div className="flex items-center gap-1">
                            <ArrowRight size={10} style={{ color: '#3b82f6' }} />
                            <span style={{ color: 'var(--text-sec)' }}>Départ : {new Date(mission.heureDepartReelle).toLocaleString('fr-FR')}</span>
                          </div>
                        )}
                        {mission.heureArriveeReelle && (
                          <div className="flex items-center gap-1">
                            <MapPin size={10} style={{ color: '#8b5cf6' }} />
                            <span style={{ color: 'var(--text-sec)' }}>Arrivée : {new Date(mission.heureArriveeReelle).toLocaleString('fr-FR')}</span>
                          </div>
                        )}
                        {mission.heureRetourReelle && (
                          <div className="flex items-center gap-1">
                            <Home size={10} style={{ color: '#f97316' }} />
                            <span style={{ color: 'var(--text-sec)' }}>Retour : {new Date(mission.heureRetourReelle).toLocaleString('fr-FR')}</span>
                          </div>
                        )}
                        {mission.heureCloture && (
                          <div className="flex items-center gap-1">
                            <CheckCircle2 size={10} style={{ color: '#10b981' }} />
                            <span style={{ color: 'var(--text-sec)' }}>Clôture : {new Date(mission.heureCloture).toLocaleString('fr-FR')}</span>
                          </div>
                        )}
                      </div>
                    </div>
                  )}

                  {/* Signatures */}
                  {(mission.signatureChauffeur || mission.signatureResponsable) && (
                    <div className="flex gap-2 text-xs">
                      {mission.signatureChauffeur && (
                        <div className="flex items-center gap-1">
                          <PenLine size={11} style={{ color: '#22c55e' }} />
                          <span style={{ color: 'var(--text-sec)' }}>Signature chauffeur ✓</span>
                        </div>
                      )}
                      {mission.signatureResponsable && (
                        <div className="flex items-center gap-1">
                          <PenLine size={11} style={{ color: '#3b82f6' }} />
                          <span style={{ color: 'var(--text-sec)' }}>Signature responsable ✓</span>
                        </div>
                      )}
                    </div>
                  )}

                  {/* Bouton détail complet */}
                  <button
                    onClick={() => loadMissionDetail(mission.id)}
                    className="flex items-center gap-1.5 text-xs font-medium px-3 py-1.5 rounded-lg transition-colors"
                    style={{ background: 'var(--bg)', color: 'var(--accent)', border: '1px solid var(--border)' }}
                  >
                    <Eye size={13} /> Voir la timeline complète + photos
                  </button>
                </div>
              )}
            </div>
          );
        })}
      </div>

      {/* Modal de détail complet */}
      {selectedMission && (
        <MissionDetailModal
          detail={selectedMission}
          chauffeursMap={chauffeursMap}
          vehiculesMap={vehiculesMap}
          serviceName={nodes.find((n) => n.id === selectedMission.deplacement.serviceDemandeurId)?.name ?? '—'}
          onClose={() => setSelectedMission(null)}
        />
      )}
    </div>
  );
}

