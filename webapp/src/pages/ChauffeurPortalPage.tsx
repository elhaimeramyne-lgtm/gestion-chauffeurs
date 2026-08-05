import { useEffect, useState } from 'react';
import {
  LogOut, Car, MapPin, CalendarDays, Gauge, Flag, Loader2, Truck, Users, RefreshCw, Bell
} from 'lucide-react';
import { useAuth } from '../context/AuthContext';
import { api, ApiError } from '../lib/api';
import { Button, Badge } from '../components/ui/Kit';
import {
  type DeplacementStatut, DEPLACEMENT_STATUT_LABELS, DEPLACEMENT_STATUT_TONE
} from '../types/parcAuto';

interface PortalMission {
  id: number;
  numero: string;
  objet: string;
  destination: string | null;
  dateDepart: string;
  dateRetourPrevue: string | null;
  kilometrageDepart: number | null;
  kilometrageRetour: number | null;
  statut: DeplacementStatut;
  vehiculeLabel: string | null;
  serviceNom: string | null;
}

interface PassagerInfo {
  id: number;
  nom: string;
  serviceId: number | null;
}

function MissionActionPanel({ mission, onDone }: { mission: PortalMission; onDone: () => void }) {
  const [kilometrageDepart, setKilometrageDepart] = useState('');
  const [kilometrageRetour, setKilometrageRetour] = useState('');
  const [rapport, setRapport] = useState('');
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleStart = async () => {
    setSaving(true);
    setError(null);
    try {
      await api.patch(`/chauffeur-portal/missions/${mission.id}/statut`, {
        statut: 'mission_en_cours',
        kilometrageDepart: kilometrageDepart ? Number(kilometrageDepart) : undefined
      });
      onDone();
    } catch {
      setError("Impossible de démarrer la mission. Le véhicule n'est peut-être plus disponible.");
    } finally {
      setSaving(false);
    }
  };

  const handleFinish = async () => {
    setSaving(true);
    setError(null);
    try {
      await api.patch(`/chauffeur-portal/missions/${mission.id}/statut`, {
        statut: 'cloturee',
        kilometrageRetour: kilometrageRetour ? Number(kilometrageRetour) : undefined,
        rapportMission: rapport.trim() || undefined
      });
      onDone();
    } catch {
      setError('Impossible de terminer la mission.');
    } finally {
      setSaving(false);
    }
  };

  if (mission.statut === 'en_attente_acceptation' || mission.statut === 'acceptee') {
    return (
      <div className="mt-3 pt-3 space-y-2" style={{ borderTop: '1px solid var(--border)' }}>
        <label>
          <span className="text-xs">Kilométrage au départ (optionnel)</span>
          <input type="number" min={0} value={kilometrageDepart} onChange={(e) => setKilometrageDepart(e.target.value)} />
        </label>
        {error && <p className="text-xs" style={{ color: 'var(--accent-err)' }}>{error}</p>}
        <Button variant="primary" disabled={saving} onClick={handleStart} className="w-full justify-center">
          <Gauge size={14} /> {saving ? 'Démarrage…' : 'Accepter et démarrer la mission'}
        </Button>
      </div>
    );
  }

  if (mission.statut === 'mission_en_cours' || mission.statut === 'en_route') {
    return (
      <div className="mt-3 pt-3 space-y-2" style={{ borderTop: '1px solid var(--border)' }}>
        <label>
          <span className="text-xs">Kilométrage au retour (optionnel)</span>
          <input type="number" min={0} value={kilometrageRetour} onChange={(e) => setKilometrageRetour(e.target.value)} />
        </label>
        <label>
          <span className="text-xs">Rapport de mission (optionnel)</span>
          <textarea rows={2} value={rapport} onChange={(e) => setRapport(e.target.value)} placeholder="Un mot sur le déroulement de la mission…" />
        </label>
        {error && <p className="text-xs" style={{ color: 'var(--accent-err)' }}>{error}</p>}
        <Button variant="primary" disabled={saving} onClick={handleFinish} className="w-full justify-center">
          <Flag size={14} /> {saving ? 'Clôture…' : 'Je suis arrivé — terminer la mission'}
        </Button>
      </div>
    );
  }

  return null;
}

function MissionCard({ mission, onDone }: { mission: PortalMission; onDone: () => void }) {
  const [expanded, setExpanded] = useState(mission.statut === 'en_attente_acceptation' || mission.statut === 'acceptee' || mission.statut === 'mission_en_cours' || mission.statut === 'en_route');
  const [passagers, setPassagers] = useState<PassagerInfo[] | null>(null);

  useEffect(() => {
    if (expanded && passagers === null) {
      api.get<{ passagers: PassagerInfo[] }>(`/chauffeur-portal/missions/${mission.id}`)
        .then((res) => setPassagers(res.passagers))
        .catch(() => setPassagers([]));
    }
  }, [expanded, mission.id, passagers]);

  return (
    <div
      className="rounded-2xl p-4"
      style={{ background: 'var(--card)', border: '1px solid var(--border)' }}
    >
      <div className="flex items-start justify-between gap-2 cursor-pointer" onClick={() => setExpanded((e) => !e)}>
        <div>
          <p className="text-xs font-mono" style={{ color: 'var(--text-ter)' }}>{mission.numero}</p>
          <p className="text-sm font-semibold mt-0.5" style={{ color: 'var(--text-pri)' }}>{mission.objet}</p>
        </div>
        <Badge tone={DEPLACEMENT_STATUT_TONE[mission.statut]}>{DEPLACEMENT_STATUT_LABELS[mission.statut]}</Badge>
      </div>

      {expanded && (
        <div className="mt-3 space-y-1.5 text-sm">
          {mission.destination && (
            <p className="flex items-center gap-1.5" style={{ color: 'var(--text-sec)' }}>
              <MapPin size={13} style={{ color: 'var(--text-ter)' }} /> {mission.destination}
            </p>
          )}
          {mission.vehiculeLabel && (
            <p className="flex items-center gap-1.5" style={{ color: 'var(--text-sec)' }}>
              <Car size={13} style={{ color: 'var(--text-ter)' }} /> {mission.vehiculeLabel}
            </p>
          )}
          <p className="flex items-center gap-1.5" style={{ color: 'var(--text-sec)' }}>
            <CalendarDays size={13} style={{ color: 'var(--text-ter)' }} />
            Départ {mission.dateDepart}{mission.dateRetourPrevue ? ` · Retour prévu ${mission.dateRetourPrevue}` : ''}
          </p>
          {mission.serviceNom && (
            <p className="text-xs" style={{ color: 'var(--text-ter)' }}>Service demandeur : {mission.serviceNom}</p>
          )}
          {passagers && passagers.length > 0 && (
            <p className="flex items-center gap-1.5 text-xs" style={{ color: 'var(--text-ter)' }}>
              <Users size={12} /> {passagers.map((p) => p.nom).join(', ')}
            </p>
          )}

          {(mission.statut === 'en_attente_acceptation' || mission.statut === 'acceptee' || mission.statut === 'mission_en_cours' || mission.statut === 'en_route') && (
            <MissionActionPanel mission={mission} onDone={onDone} />
          )}
        </div>
      )}
    </div>
  );
}

export default function ChauffeurPortalPage() {
  const { user, logout } = useAuth();
  const [missions, setMissions] = useState<PortalMission[] | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [tick, setTick] = useState(0);
  const [unreadCount, setUnreadCount] = useState(0);

  const reload = () => setTick((t) => t + 1);

  useEffect(() => {
    api.get<{ missions: PortalMission[] }>('/chauffeur-portal/missions')
      .then((res) => setMissions(res.missions))
      .catch((err) => {
        const detail = err instanceof ApiError ? err.message : null;
        setError(detail || "Impossible de charger vos missions. Contactez le Service Logistique si le problème persiste.");
      });
  }, [tick]);

  // Notification : nouvelles missions assignées depuis la dernière visite.
  // Marquées comme "vues" dès l'ouverture du portail, puisque la liste des
  // missions ci-dessous constitue déjà la confirmation de lecture.
  useEffect(() => {
    api.get<{ unreadCount: number }>('/notifications')
      .then((res) => {
        setUnreadCount(res.unreadCount);
        if (res.unreadCount > 0) api.post('/notifications/mark-read', {}).catch(() => {});
      })
      .catch(() => {});
  }, [tick]);

  const enCours = missions?.filter((m) => m.statut === 'mission_en_cours' || m.statut === 'en_route') ?? [];
  const aVenir = missions?.filter((m) => m.statut === 'en_attente_acceptation' || m.statut === 'acceptee') ?? [];
  const historique = missions?.filter((m) => m.statut === 'cloturee' || m.statut === 'annule') ?? [];

  return (
    <div className="min-h-screen" style={{ background: 'var(--bg)' }}>
      <div className="sticky top-0 z-10 px-4 py-3 flex items-center justify-between" style={{ background: 'var(--card)', borderBottom: '1px solid var(--border)' }}>
        <div className="flex items-center gap-2">
          <div className="w-8 h-8 rounded-full flex items-center justify-center" style={{ background: 'rgba(99,102,241,0.14)' }}>
            <Truck size={16} style={{ color: '#6366f1' }} />
          </div>
          <div>
            <p className="text-sm font-semibold" style={{ color: 'var(--text-pri)' }}>{user?.displayName || user?.username}</p>
            <p className="text-[11px]" style={{ color: 'var(--text-ter)' }}>Portail chauffeur</p>
          </div>
        </div>
        <div className="flex items-center gap-1">
          <button onClick={reload} className="tbl-btn focus-ring" title="Actualiser"><RefreshCw size={15} /></button>
          <button onClick={logout} className="tbl-btn focus-ring" title="Se déconnecter"><LogOut size={15} /></button>
        </div>
      </div>

      <div className="max-w-lg mx-auto px-4 py-5 space-y-6">
        {error && (
          <p className="text-sm rounded-lg px-3 py-2" style={{ color: 'var(--accent-err)', background: 'rgba(239,68,68,0.08)', border: '1px solid rgba(239,68,68,0.2)' }}>{error}</p>
        )}

        {unreadCount > 0 && (
          <div className="flex items-center gap-2 text-sm rounded-lg px-3 py-2" style={{ color: '#6366f1', background: 'rgba(99,102,241,0.08)', border: '1px solid rgba(99,102,241,0.25)' }}>
            <Bell size={14} className="shrink-0" />
            <span>{unreadCount} nouvelle{unreadCount > 1 ? 's' : ''} mission{unreadCount > 1 ? 's' : ''} assignée{unreadCount > 1 ? 's' : ''}.</span>
          </div>
        )}

        {missions === null && !error && (
          <div className="flex items-center justify-center py-12">
            <Loader2 size={20} className="animate-spin" style={{ color: 'var(--text-ter)' }} />
          </div>
        )}

        {missions !== null && (
          <>
            {enCours.length > 0 && (
              <section>
                <h2 className="text-xs font-semibold uppercase tracking-wide mb-2" style={{ color: 'var(--text-ter)' }}>Mission en cours</h2>
                <div className="space-y-3">
                  {enCours.map((m) => <MissionCard key={m.id} mission={m} onDone={reload} />)}
                </div>
              </section>
            )}

            <section>
              <h2 className="text-xs font-semibold uppercase tracking-wide mb-2" style={{ color: 'var(--text-ter)' }}>
                Missions à venir {aVenir.length > 0 && `(${aVenir.length})`}
              </h2>
              {aVenir.length === 0 ? (
                <p className="text-sm py-6 text-center" style={{ color: 'var(--text-ter)' }}>Aucune mission planifiée pour le moment.</p>
              ) : (
                <div className="space-y-3">
                  {aVenir.map((m) => <MissionCard key={m.id} mission={m} onDone={reload} />)}
                </div>
              )}
            </section>

            {historique.length > 0 && (
              <section>
                <h2 className="text-xs font-semibold uppercase tracking-wide mb-2" style={{ color: 'var(--text-ter)' }}>Historique récent</h2>
                <div className="space-y-3">
                  {historique.slice(0, 10).map((m) => <MissionCard key={m.id} mission={m} onDone={reload} />)}
                </div>
              </section>
            )}
          </>
        )}
      </div>
    </div>
  );
}
