import { useCallback, useEffect, useRef, useState } from 'react';
import type { DriverSection } from '../components/layout/DriverLayout';
import {
  LogOut, MapPin, Car, CalendarDays, Clock, Flag, Gauge, Navigation, CheckCircle2,
  Users, StickyNote, History, Camera, PenLine, Play, Home, ArrowRight, Loader2,
  ChevronDown, ChevronUp, Image, RefreshCw, Bell, ShieldAlert, Wrench, CreditCard,
  BarChart3, AlertTriangle, AlertOctagon, Sun, Moon
} from 'lucide-react';
import { Button, Badge, Modal } from '../components/ui/Kit';
import { useAuth } from '../context/AuthContext';
import { getTheme, setTheme, type Theme } from '../lib/theme';
import { api, ApiError } from '../lib/api';
import type {
  Deplacement, DeplacementStatut, DeplacementDetail, MissionEvent, MissionPhoto,
  Vehicule, DeplacementPassager as PassagerType, Alerte,
  EtatPneus, EtatBatterie, EtatFreins, EtatEclairage, EtatClimatisation,
  DeclarationCategorie, DeclarationUrgence
} from '../types/parcAuto';
import {
  DEPLACEMENT_STATUT_LABELS, DEPLACEMENT_ETAPES, DEPLACEMENT_ETAPE_COLOR,
  NEXT_ACTION, ETAT_PNEUS_LABELS, ETAT_BATTERIE_LABELS, ETAT_FREINS_LABELS,
  ETAT_ECLAIRAGE_LABELS, ETAT_CLIMATISATION_LABELS,
  DECLARATION_CATEGORIES, DECLARATION_CATEGORIE_LABELS, DECLARATION_URGENCE_LABELS
} from '../types/parcAuto';

/* ═══════════════════════════════════════════════════════════════════════
 * TYPES
 * ═══════════════════════════════════════════════════════════════════════ */

interface MaMissionResponse {
  deplacement: Deplacement | null;
  vehicule?: Vehicule | null;
  serviceName?: string | null;
  passagers?: PassagerType[];
  events?: MissionEvent[];
  pendingDemande?: {
    id: number;
    numero: string;
    priorite: 'normale' | 'urgente' | 'critique';
    demandeurNom: string;
    demandeurTelephone: string | null;
    observations: string | null;
    serviceName: string | null;
  } | null;
  confirmedDemandeNumero?: string | null;
}

interface HistoriqueEntry {
  id: number;
  numero: string;
  destination: string | null;
  dateDepart: string;
  statut: DeplacementStatut;
  objet: string;
}

interface PortalDashboard {
  chauffeur: { jawazNumero: string | null; jawazSolde: number } | null;
  vehicule: Vehicule | null;
  alertes: Alerte[];
  stats: {
    missionsTerminees: number;
    kmParcourus: number;
    dureeTotaleMin: number;
    consommationMoyenne: number | null;
    photosEnvoyees: number;
    missionsEnRetard: number;
  };
}

interface NotificationItem {
  id: string;
  kind: string;
  color: 'red' | 'green' | 'orange' | 'blue';
  message: string;
  createdAt: string;
}

/** Renvoie, pour une date JJ/MM/AAAA, le nombre de jours restants et une
 *  couleur d'état (vert / orange / rouge) — utilisé pour l'assurance, la
 *  visite technique et la vidange dans le tableau de bord. */
function echeanceStatut(dateStr: string | null): { joursRestants: number | null; tone: 'good' | 'warn' | 'bad' } {
  if (!dateStr) return { joursRestants: null, tone: 'good' };
  const m = /^(\d{2})\/(\d{2})\/(\d{4})$/.exec(dateStr);
  if (!m) return { joursRestants: null, tone: 'good' };
  const date = new Date(Number(m[3]), Number(m[2]) - 1, Number(m[1]));
  const diffMs = date.getTime() - new Date().setHours(0, 0, 0, 0);
  const jours = Math.round(diffMs / (24 * 60 * 60 * 1000));
  if (jours < 0) return { joursRestants: jours, tone: 'bad' };
  if (jours <= 30) return { joursRestants: jours, tone: 'warn' };
  return { joursRestants: jours, tone: 'good' };
}

function toneColor(tone: 'good' | 'warn' | 'bad'): string {
  return tone === 'bad' ? 'var(--accent-err)' : tone === 'warn' ? 'var(--accent-warn)' : '#4ade80';
}

/** État de la vidange à partir du kilométrage actuel vs. le seuil prévu. */
function vidangeEtatKm(kmActuel: number, kmProchain: number | null): { label: string; tone: 'good' | 'warn' | 'bad' } | null {
  if (kmProchain == null) return null;
  const reste = kmProchain - kmActuel;
  if (reste <= 0) return { label: `Dépassée de ${Math.abs(reste).toLocaleString('fr-FR')} km`, tone: 'bad' };
  if (reste <= 500) return { label: `${reste.toLocaleString('fr-FR')} km restants`, tone: 'warn' };
  return { label: `${reste.toLocaleString('fr-FR')} km restants`, tone: 'good' };
}

/* ═══════════════════════════════════════════════════════════════════════
 * "SIGNALER UN PROBLÈME"
 * ═══════════════════════════════════════════════════════════════════════ */
function DeclarationForm({ onClose, onSubmitted }: { onClose: () => void; onSubmitted: () => void }) {
  const [categorie, setCategorie] = useState<DeclarationCategorie>('autre');
  const [description, setDescription] = useState('');
  const [urgence, setUrgence] = useState<DeclarationUrgence>('normal');
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [created, setCreated] = useState<{ id: number } | null>(null);
  const [uploadingMedia, setUploadingMedia] = useState(false);
  const [mediaCount, setMediaCount] = useState(0);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);
    setError(null);
    try {
      const res = await api.post<{ declaration: { id: number } }>('/ma-mission/declarations', {
        categorie, description: description.trim() || undefined, urgence
      });
      setCreated({ id: res.declaration.id });
      onSubmitted();
    } catch (err) {
      setError(err instanceof ApiError ? err.message : "Impossible d'envoyer cette déclaration.");
    } finally {
      setSaving(false);
    }
  };

  const handleMediaFile = async (file: File) => {
    if (!created) return;
    setUploadingMedia(true);
    const formData = new FormData();
    formData.append('media', file);
    try {
      await fetch(`/api/ma-mission/declarations/${created.id}/media`, { method: 'POST', credentials: 'include', body: formData });
      setMediaCount((c) => c + 1);
    } catch {
      setError("Échec de l'envoi du fichier.");
    } finally {
      setUploadingMedia(false);
    }
  };

  if (created) {
    return (
      <div className="text-center py-2">
        <div className="w-12 h-12 rounded-full mx-auto mb-3 flex items-center justify-center" style={{ background: 'rgba(34,197,94,0.15)' }}>
          <CheckCircle2 size={22} style={{ color: 'var(--accent2)' }} />
        </div>
        <p className="text-sm mb-1" style={{ color: 'var(--text-pri)' }}>Déclaration envoyée</p>
        <p className="text-xs mb-4" style={{ color: 'var(--text-ter)' }}>Le responsable du parc a été notifié. Vous pouvez joindre une ou plusieurs photos, ou une vidéo.</p>
        <div className="flex items-center justify-center gap-2 mb-2">
          <Button variant="secondary" type="button" onClick={() => fileInputRef.current?.click()} disabled={uploadingMedia}>
            <Camera size={13} /> {uploadingMedia ? 'Envoi…' : 'Ajouter une photo / vidéo'}
          </Button>
          <input ref={fileInputRef} type="file" accept="image/*,video/*" hidden onChange={(e) => e.target.files?.[0] && handleMediaFile(e.target.files[0])} />
        </div>
        {mediaCount > 0 && <p className="text-xs mb-4" style={{ color: 'var(--text-ter)' }}>{mediaCount} fichier(s) joint(s).</p>}
        {error && <p className="text-xs mb-3" style={{ color: 'var(--accent-err)' }}>{error}</p>}
        <Button variant="primary" onClick={onClose}>Terminé</Button>
      </div>
    );
  }

  return (
    <form className="space-y-3" onSubmit={handleSubmit}>
      <label>
        <span>Catégorie</span>
        <select value={categorie} onChange={(e) => setCategorie(e.target.value as DeclarationCategorie)}>
          {DECLARATION_CATEGORIES.map((c) => <option key={c} value={c}>{DECLARATION_CATEGORIE_LABELS[c]}</option>)}
        </select>
      </label>
      <label>
        <span>Description</span>
        <textarea rows={3} value={description} onChange={(e) => setDescription(e.target.value)} placeholder="Décrivez le problème rencontré…" />
      </label>
      <div>
        <span className="block mb-1.5 text-sm" style={{ color: 'var(--text-sec)' }}>Niveau d'urgence</span>
        <div className="flex gap-2">
          {(['normal', 'urgent', 'critique'] as const).map((u) => {
            const active = urgence === u;
            const color = u === 'critique' ? 'var(--accent-err)' : u === 'urgent' ? 'var(--accent-warn)' : '#60a5fa';
            return (
              <button
                type="button" key={u} onClick={() => setUrgence(u)}
                className="flex-1 text-xs py-2 rounded-lg transition-colors focus-ring"
                style={{
                  background: active ? `${color}29` : 'var(--glass-bg)',
                  border: `1px solid ${active ? color : 'var(--border)'}`,
                  color: active ? color : 'var(--text-sec)'
                }}
              >
                {DECLARATION_URGENCE_LABELS[u]}
              </button>
            );
          })}
        </div>
      </div>
      {error && (
        <p className="text-xs rounded-lg px-3 py-2" style={{ color: 'var(--accent-err)', background: 'rgba(239,68,68,0.08)', border: '1px solid rgba(239,68,68,0.2)' }}>{error}</p>
      )}
      <div className="flex justify-end gap-2 pt-2">
        <Button variant="secondary" type="button" onClick={onClose}>Annuler</Button>
        <Button variant="primary" type="submit" disabled={saving}>
          <AlertOctagon size={13} /> {saving ? 'Envoi…' : 'Envoyer'}
        </Button>
      </div>
    </form>
  );
}

/* ═══════════════════════════════════════════════════════════════════════
 * COMPOSANT PRINCIPAL
 * ═══════════════════════════════════════════════════════════════════════ */

export default function MaMissionPage({ section = 'missions', standaloneHeader = true }: { section?: DriverSection; standaloneHeader?: boolean }) {
  const { user, logout } = useAuth();
  const [data, setData] = useState<MaMissionResponse | null>(null);
  const [historique, setHistorique] = useState<HistoriqueEntry[]>([]);
  const [dashboard, setDashboard] = useState<PortalDashboard | null>(null);
  const [notifications, setNotifications] = useState<NotificationItem[]>([]);
  const [unreadCount, setUnreadCount] = useState(0);
  const [lastUpdated, setLastUpdated] = useState<Date | null>(null);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const [acting, setActing] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [detailView, setDetailView] = useState(false);
  const [detail, setDetail] = useState<DeplacementDetail | null>(null);
  const [showSignaturePad, setShowSignaturePad] = useState(false);
  const [showDashboard, setShowDashboard] = useState(true);
  const [showDeclarationForm, setShowDeclarationForm] = useState(false);
  const [savingEtat, setSavingEtat] = useState<string | null>(null);
  const [theme, setThemeState] = useState<Theme>('light');
  useEffect(() => { setThemeState(getTheme()); }, []);
  const toggleTheme = () => {
    const next: Theme = theme === 'dark' ? 'light' : 'dark';
    setTheme(next);
    setThemeState(next);
  };

  /** Charge la mission, l'historique, le tableau de bord et les
   *  notifications. Le portail chauffeur ne s'actualise JAMAIS tout seul —
   *  c'est uniquement le bouton « Actualiser » (ou une action réussie) qui
   *  déclenche ce chargement, d'où l'horodatage « Actualisé manuellement ». */
  const load = useCallback(() => {
    setRefreshing(true);
    Promise.all([
      api.get<MaMissionResponse>('/ma-mission'),
      api.get<{ historique: HistoriqueEntry[] }>('/ma-mission/historique'),
      api.get<PortalDashboard>('/ma-mission/dashboard').catch(() => null),
      api.get<{ notifications: NotificationItem[]; unreadCount: number }>('/notifications').catch(() => null)
    ])
      .then(([missionRes, histRes, dashRes, notifRes]) => {
        setData(missionRes);
        setHistorique(histRes.historique);
        if (dashRes) setDashboard(dashRes);
        if (notifRes) {
          setNotifications(notifRes.notifications);
          setUnreadCount(notifRes.unreadCount);
        }
        setLastUpdated(new Date());
        setError(null);
      })
      .catch(() => setError("Impossible de charger votre mission."))
      .finally(() => { setLoading(false); setRefreshing(false); });
  }, []);

  useEffect(() => { load(); }, [load]);

  // Actualisation automatique — reprend le même intervalle que le tableau de bord admin,
  // pour que le chauffeur voie sans recharger une nouvelle mission assignée, un changement
  // de statut, etc. setRefreshing() n'affiche qu'un discret indicateur, pas un écran de chargement.
  useEffect(() => {
    const interval = setInterval(load, 15_000);
    return () => clearInterval(interval);
  }, [load]);

  const handleEtatChange = async (field: 'etatPneus' | 'etatBatterie' | 'etatFreins' | 'etatEclairage' | 'etatClimatisation', value: string) => {
    if (!value) return;
    setSavingEtat(field);
    try {
      await api.patch('/ma-mission/vehicule/etat', { [field]: value });
      load();
    } catch {
      setError('Impossible de mettre à jour cet état.');
    } finally {
      setSavingEtat(null);
    }
  };

  const markNotificationsRead = () => {
    if (unreadCount === 0) return;
    api.post('/notifications/mark-read', {}).then(() => setUnreadCount(0)).catch(() => {});
  };

  const deplacement = data?.deplacement ?? null;
  const action = deplacement ? NEXT_ACTION[deplacement.statut] : undefined;

  // Charger le détail (timeline, photos) quand on ouvre la vue détail
  const loadDetail = useCallback(async () => {
    if (!deplacement) return;
    try {
      const res = await api.get<DeplacementDetail>(`/ma-mission/${deplacement.id}/detail`);
      setDetail(res);
    } catch {
      // ignore
    }
  }, [deplacement]);

  useEffect(() => {
    if (detailView && deplacement) loadDetail();
  }, [detailView, deplacement, loadDetail]);

  const tryGetCoords = (): Promise<{ lat?: number; lng?: number }> => {
    return new Promise((resolve) => {
      if (!('geolocation' in navigator)) return resolve({});
      const timer = setTimeout(() => resolve({}), 4000);
      navigator.geolocation.getCurrentPosition(
        (pos) => { clearTimeout(timer); resolve({ lat: pos.coords.latitude, lng: pos.coords.longitude }); },
        () => { clearTimeout(timer); resolve({}); },
        { enableHighAccuracy: false, timeout: 3500 }
      );
    });
  };

  const handleAction = async () => {
    if (!deplacement || !action) return;
    setActing(true);
    setError(null);
    try {
      const coords = await tryGetCoords();
      const body: Record<string, unknown> = { ...coords };

      // Ajouter des champs spécifiques selon l'action
      if (action.endpoint === 'demarrer' || action.endpoint === 'arrive-siege') {
        const km = prompt('Kilométrage actuel (optionnel) :');
        if (km && !isNaN(Number(km))) {
          if (action.endpoint === 'demarrer') body.kilometrageDepart = Number(km);
          else body.kilometrageRetour = Number(km);
        }
      }
      if (action.endpoint === 'terminer') {
        const obs = prompt('Observations sur la mission (optionnel) :');
        if (obs) body.observations = obs;
      }

      await api.post(`/ma-mission/${deplacement.id}/${action.endpoint}`, body);
      load();
      setDetailView(false);
    } catch (err) {
      setError(err instanceof ApiError ? err.message : "Cette action a échoué.");
    } finally {
      setActing(false);
    }
  };

  const handleDemandeAction = async (demandeId: number, decision: 'accepter' | 'refuser') => {
    setActing(true);
    setError(null);
    try {
      let body: Record<string, unknown> | undefined;
      if (decision === 'refuser') {
        const motif = prompt('Motif du refus (optionnel) :');
        body = motif ? { motif } : {};
      }
      await api.post(`/ma-mission/demande/${demandeId}/${decision}`, body);
      load();
    } catch (err) {
      setError(err instanceof ApiError ? err.message : "Cette action a échoué.");
    } finally {
      setActing(false);
    }
  };

  const handlePhotoUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    if (!deplacement || !e.target.files?.length) return;
    const file = e.target.files[0];
    const type = prompt('Type de photo (depart, arrivee, bon_livraison, retour, autre) :') || 'autre';
    const formData = new FormData();
    formData.append('photo', file);
    formData.append('type', type);
    try {
      await fetch(`/api/ma-mission/${deplacement.id}/photo`, {
        method: 'POST',
        credentials: 'include',
        body: formData,
      });
      loadDetail();
    } catch {
      setError("Impossible d'uploader la photo.");
    }
  };

  const handleSaveSignature = async (signatureDataUrl: string) => {
    if (!deplacement) return;
    try {
      await api.post(`/ma-mission/${deplacement.id}/signature`, { signature: signatureDataUrl });
      setShowSignaturePad(false);
      setError(null);
    } catch {
      setError("Impossible d'enregistrer la signature.");
    }
  };

  const isEtapeAtteinte = (etape: DeplacementStatut): boolean => {
    if (!deplacement) return false;
    if (deplacement.statut === 'annule') return false;
    const curIdx = DEPLACEMENT_ETAPES.indexOf(deplacement.statut);
    const etaIdx = DEPLACEMENT_ETAPES.indexOf(etape);
    if (curIdx === -1 || etaIdx === -1) return false;
    return etaIdx <= curIdx;
  };

  return (
    <div className={standaloneHeader ? 'min-h-screen flex flex-col' : 'flex flex-col'} style={{ background: 'var(--bg)' }}>
      {/* En-tête (masqué si intégré dans DriverLayout) */}
      {standaloneHeader && (
      <header className="flex items-center justify-between px-5 py-4" style={{ borderBottom: '1px solid var(--border)' }}>
        <div>
          <p className="text-sm font-bold" style={{ color: 'var(--text-pri)' }}>{user?.displayName ?? user?.username}</p>
          <p className="text-xs" style={{ color: 'var(--text-ter)' }}>Portail Chauffeur</p>
        </div>
        <div className="flex items-center gap-2">
          {showSignaturePad && deplacement && (
            <SignaturePad
              onSave={handleSaveSignature}
              onCancel={() => setShowSignaturePad(false)}
            />
          )}
          <button
            onClick={toggleTheme}
            className="p-2 rounded-lg transition-colors hover:bg-[var(--card-hover)]"
            style={{ color: 'var(--text-ter)' }}
            title={theme === 'dark' ? 'Passer en mode clair' : 'Passer en mode sombre'}
          >
            {theme === 'dark' ? <Sun size={17} /> : <Moon size={17} />}
          </button>
          <button
            onClick={load}
            disabled={refreshing}
            className="relative p-2 rounded-lg transition-colors hover:bg-[var(--card-hover)]"
            style={{ color: 'var(--text-ter)' }}
            title="Actualiser (manuel)"
          >
            <RefreshCw size={16} className={refreshing ? 'animate-spin' : ''} />
            {unreadCount > 0 && (
              <span
                className="absolute flex items-center justify-center rounded-full text-[9px] font-bold"
                style={{ top: -2, right: -2, minWidth: 14, height: 14, padding: '0 3px', background: 'var(--accent)', color: 'var(--text-inv)' }}
              >
                {unreadCount > 9 ? '9+' : unreadCount}
              </span>
            )}
          </button>
          <button onClick={() => logout()} className="p-2 rounded-lg transition-colors hover:bg-[var(--card-hover)]" style={{ color: 'var(--text-ter)' }} title="Se déconnecter">
            <LogOut size={18} />
          </button>
        </div>
      </header>
      )}

      <main className="flex-1 flex items-start justify-center p-4 pt-10">
        <div className="w-full max-w-md space-y-5">
          {/* Titre section */}
          {!standaloneHeader && (
            <div className="text-center">
              <h1 className="text-lg font-bold tracking-wide" style={{ color: 'var(--text-pri)' }}>
                {section === 'missions' ? 'MA MISSION' : section === 'vehicule' ? 'MON VÉHICULE' : section === 'notifications' ? 'NOTIFICATIONS' : section === 'profil' ? 'MON PROFIL' : 'PARAMÈTRES'}
              </h1>
              <p className="text-[11px] mt-1 flex items-center justify-center gap-1" style={{ color: 'var(--text-ter)' }}>
                Actualisé manuellement {lastUpdated ? `· ${lastUpdated.toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' })}` : ''}
              </p>
            </div>
          )}
          {standaloneHeader && (
          <div className="text-center">
            <h1 className="text-lg font-bold tracking-wide" style={{ color: 'var(--text-pri)' }}>MA MISSION ACTUELLE</h1>
            <p className="text-[11px] mt-1 flex items-center justify-center gap-1" style={{ color: 'var(--text-ter)' }}>
              Actualisé manuellement {lastUpdated ? `· dernière actualisation à ${lastUpdated.toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' })}` : ''}
            </p>
          </div>
          )}

          {/* Notifications — centre non temps réel : uniquement rafraîchi via le bouton ci-dessus */}
          {(section === 'notifications' || section === 'missions') && notifications.length > 0 && (
            <div className="rounded-2xl overflow-hidden" style={{ background: 'var(--card)', border: '1px solid var(--border)' }}>
              <div className="px-4 py-2.5 flex items-center justify-between" style={{ borderBottom: '1px solid var(--border)' }}>
                <p className="text-xs font-bold uppercase tracking-wide flex items-center gap-1.5" style={{ color: 'var(--text-ter)' }}>
                  <Bell size={12} /> Notifications
                </p>
                {unreadCount > 0 ? (
                  <button onClick={markNotificationsRead} className="text-[11px]" style={{ color: 'var(--accent)' }}>Marquer comme lu</button>
                ) : (
                  <span className="text-[11px]" style={{ color: 'var(--text-ter)' }}>à jour</span>
                )}
              </div>
              <div className="max-h-44 overflow-y-auto">
                {notifications.slice(0, 8).map((n) => (
                  <div key={n.id} className="flex items-start gap-2 px-4 py-2.5" style={{ borderBottom: '1px solid var(--border)' }}>
                    <span className="rounded-full shrink-0 mt-1.5" style={{ width: 6, height: 6, background: n.color === 'red' ? 'var(--accent-err)' : n.color === 'orange' ? 'var(--accent-warn)' : n.color === 'green' ? 'var(--accent2)' : '#22d3ee' }} />
                    <p className="text-xs leading-snug" style={{ color: 'var(--text-sec)' }}>{n.message}</p>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Alertes : assurance, visite technique, vidange, Jawaz, permis, disponibilité */}
          {(section === 'vehicule' || section === 'notifications') && dashboard && dashboard.alertes.length > 0 && (
            <div className="rounded-2xl overflow-hidden" style={{ background: 'var(--card)', border: '1px solid var(--border)' }}>
              <div className="px-4 py-3 flex items-center gap-1.5" style={{ borderBottom: '1px solid var(--border)' }}>
                <AlertTriangle size={13} style={{ color: 'var(--accent-warn)' }} />
                <p className="text-xs font-bold uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Alertes</p>
              </div>
              <div>
                {dashboard.alertes.map((a, i) => (
                  <div key={i} className="flex items-start gap-2 px-4 py-2.5" style={{ borderBottom: i < dashboard.alertes.length - 1 ? '1px solid var(--border)' : 'none' }}>
                    <span className="rounded-full shrink-0 mt-1.5" style={{ width: 6, height: 6, background: a.niveau === 'rouge' ? 'var(--accent-err)' : 'var(--accent-warn)' }} />
                    <p className="text-xs leading-snug" style={{ color: 'var(--text-sec)' }}>{a.message}</p>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Tableau de bord : statut du véhicule habituel, Jawaz, statistiques */}
          {section === 'vehicule' && dashboard && (
            <div className="rounded-2xl overflow-hidden" style={{ background: 'var(--card)', border: '1px solid var(--border)' }}>
              <button
                onClick={() => setShowDashboard((s) => !s)}
                className="w-full px-4 py-3 flex items-center justify-between"
                style={{ borderBottom: showDashboard ? '1px solid var(--border)' : 'none' }}
              >
                <p className="text-xs font-bold uppercase tracking-wide flex items-center gap-1.5" style={{ color: 'var(--text-ter)' }}>
                  <BarChart3 size={12} /> Tableau de bord
                </p>
                {showDashboard ? <ChevronUp size={14} style={{ color: 'var(--text-ter)' }} /> : <ChevronDown size={14} style={{ color: 'var(--text-ter)' }} />}
              </button>

              {showDashboard && (
                <div className="px-4 py-4 space-y-4">
                  {/* Statistiques cumulées */}
                  <div>
                    <p className="text-[11px] uppercase tracking-wide mb-2" style={{ color: 'var(--text-ter)' }}>Mes statistiques</p>
                    <div className="grid grid-cols-3 gap-2">
                      <div className="rounded-lg px-2 py-2.5 text-center" style={{ background: 'var(--bg)' }}>
                        <p className="text-base font-bold" style={{ color: 'var(--text-pri)' }}>{dashboard.stats.missionsTerminees}</p>
                        <p className="text-[10px]" style={{ color: 'var(--text-ter)' }}>Missions terminées</p>
                      </div>
                      <div className="rounded-lg px-2 py-2.5 text-center" style={{ background: 'var(--bg)' }}>
                        <p className="text-base font-bold" style={{ color: 'var(--text-pri)' }}>{dashboard.stats.kmParcourus.toLocaleString('fr-FR')}</p>
                        <p className="text-[10px]" style={{ color: 'var(--text-ter)' }}>Km parcourus</p>
                      </div>
                      <div className="rounded-lg px-2 py-2.5 text-center" style={{ background: 'var(--bg)' }}>
                        <p className="text-base font-bold" style={{ color: 'var(--text-pri)' }}>{Math.floor(dashboard.stats.dureeTotaleMin / 60)}h</p>
                        <p className="text-[10px]" style={{ color: 'var(--text-ter)' }}>Temps de conduite</p>
                      </div>
                      <div className="rounded-lg px-2 py-2.5 text-center" style={{ background: 'var(--bg)' }}>
                        <p className="text-base font-bold" style={{ color: 'var(--text-pri)' }}>{dashboard.stats.photosEnvoyees}</p>
                        <p className="text-[10px]" style={{ color: 'var(--text-ter)' }}>Photos envoyées</p>
                      </div>
                      <div className="rounded-lg px-2 py-2.5 text-center" style={{ background: 'var(--bg)' }}>
                        <p className="text-base font-bold" style={{ color: dashboard.stats.missionsEnRetard > 0 ? 'var(--accent-err)' : 'var(--text-pri)' }}>{dashboard.stats.missionsEnRetard}</p>
                        <p className="text-[10px]" style={{ color: 'var(--text-ter)' }}>Missions en retard</p>
                      </div>
                      <div className="rounded-lg px-2 py-2.5 text-center" style={{ background: 'var(--bg)' }}>
                        <p className="text-base font-bold" style={{ color: 'var(--text-pri)' }}>{dashboard.stats.consommationMoyenne != null ? `${dashboard.stats.consommationMoyenne} L` : '—'}</p>
                        <p className="text-[10px]" style={{ color: 'var(--text-ter)' }}>Consommation moy.</p>
                      </div>
                    </div>
                  </div>

                  {/* Véhicule habituel */}
                  {dashboard.vehicule && (
                    <div>
                      <p className="text-[11px] uppercase tracking-wide mb-2" style={{ color: 'var(--text-ter)' }}>Mon véhicule</p>
                      <div className="rounded-lg px-3 py-2.5 mb-2" style={{ background: 'var(--bg)' }}>
                        <p className="text-sm font-semibold flex items-center gap-1.5" style={{ color: 'var(--text-pri)' }}>
                          <Car size={13} style={{ color: 'var(--text-ter)' }} /> {dashboard.vehicule.marque} {dashboard.vehicule.modele} — {dashboard.vehicule.immatriculation}
                        </p>
                        <p className="text-xs mt-1" style={{ color: 'var(--text-ter)' }}>{dashboard.vehicule.kilometrage.toLocaleString('fr-FR')} km</p>
                      </div>
                      <div className="grid grid-cols-3 gap-2">
                        {([
                          { label: 'Assurance', icon: <ShieldAlert size={12} />, value: dashboard.vehicule.assuranceExpiration },
                          { label: 'Visite technique', icon: <CheckCircle2 size={12} />, value: dashboard.vehicule.visiteTechniqueExpiration }
                        ] as const).map((item) => {
                          const { tone } = echeanceStatut(item.value);
                          return (
                            <div key={item.label} className="rounded-lg px-2 py-2 text-center" style={{ background: 'var(--bg)', border: `1px solid ${toneColor(tone)}33` }}>
                              <p className="flex items-center justify-center gap-1 text-[10px] mb-1" style={{ color: 'var(--text-ter)' }}>{item.icon} {item.label}</p>
                              <p className="text-[11px] font-semibold" style={{ color: toneColor(tone) }}>{item.value ?? '—'}</p>
                            </div>
                          );
                        })}
                        {(() => {
                          const vidangeKm = vidangeEtatKm(dashboard.vehicule.kilometrage, dashboard.vehicule.kilometrageProchaineVidange);
                          const vidangeDate = echeanceStatut(dashboard.vehicule.vidangeExpiration);
                          const tone = vidangeKm?.tone ?? vidangeDate.tone;
                          const label = vidangeKm?.label ?? dashboard.vehicule.vidangeExpiration ?? '—';
                          return (
                            <div className="rounded-lg px-2 py-2 text-center" style={{ background: 'var(--bg)', border: `1px solid ${toneColor(tone)}33` }}>
                              <p className="flex items-center justify-center gap-1 text-[10px] mb-1" style={{ color: 'var(--text-ter)' }}><Wrench size={12} /> Vidange</p>
                              <p className="text-[11px] font-semibold" style={{ color: toneColor(tone) }}>{label}</p>
                            </div>
                          );
                        })()}
                      </div>

                      {/* Détail vidange (suivi kilométrique) */}
                      {dashboard.vehicule.kilometrageProchaineVidange != null && (
                        <div className="rounded-lg px-3 py-2.5 mt-2" style={{ background: 'var(--bg)' }}>
                          <p className="text-[11px] uppercase tracking-wide mb-1.5" style={{ color: 'var(--text-ter)' }}>Vidange</p>
                          <div className="grid grid-cols-3 gap-2 text-center mb-1.5">
                            <div>
                              <p className="text-[10px]" style={{ color: 'var(--text-ter)' }}>Dernière</p>
                              <p className="text-xs font-semibold" style={{ color: 'var(--text-pri)' }}>{dashboard.vehicule.kilometrageDerniereVidange != null ? `${dashboard.vehicule.kilometrageDerniereVidange.toLocaleString('fr-FR')} km` : '—'}</p>
                            </div>
                            <div>
                              <p className="text-[10px]" style={{ color: 'var(--text-ter)' }}>Prochaine</p>
                              <p className="text-xs font-semibold" style={{ color: 'var(--text-pri)' }}>{dashboard.vehicule.kilometrageProchaineVidange.toLocaleString('fr-FR')} km</p>
                            </div>
                            <div>
                              <p className="text-[10px]" style={{ color: 'var(--text-ter)' }}>Reste</p>
                              {(() => {
                                const etat = vidangeEtatKm(dashboard.vehicule.kilometrage, dashboard.vehicule.kilometrageProchaineVidange);
                                return <p className="text-xs font-semibold" style={{ color: etat ? toneColor(etat.tone) : 'var(--text-pri)' }}>{etat?.label ?? '—'}</p>;
                              })()}
                            </div>
                          </div>
                        </div>
                      )}

                      {/* États déclarés — modifiables directement par le chauffeur */}
                      <div className="rounded-lg px-3 py-2.5 mt-2" style={{ background: 'var(--bg)' }}>
                        <p className="text-[11px] uppercase tracking-wide mb-1.5" style={{ color: 'var(--text-ter)' }}>États du véhicule</p>
                        <div className="grid grid-cols-2 gap-2">
                          <label className="block">
                            <span className="text-[10px]" style={{ color: 'var(--text-ter)' }}>Pneus</span>
                            <select value={dashboard.vehicule.etatPneus ?? ''} disabled={savingEtat === 'etatPneus'} onChange={(e) => handleEtatChange('etatPneus', e.target.value)} className="text-xs">
                              <option value="" disabled>— Choisir —</option>
                              {(Object.keys(ETAT_PNEUS_LABELS) as EtatPneus[]).map((k) => <option key={k} value={k}>{ETAT_PNEUS_LABELS[k]}</option>)}
                            </select>
                          </label>
                          <label className="block">
                            <span className="text-[10px]" style={{ color: 'var(--text-ter)' }}>Batterie</span>
                            <select value={dashboard.vehicule.etatBatterie ?? ''} disabled={savingEtat === 'etatBatterie'} onChange={(e) => handleEtatChange('etatBatterie', e.target.value)} className="text-xs">
                              <option value="" disabled>— Choisir —</option>
                              {(Object.keys(ETAT_BATTERIE_LABELS) as EtatBatterie[]).map((k) => <option key={k} value={k}>{ETAT_BATTERIE_LABELS[k]}</option>)}
                            </select>
                          </label>
                          <label className="block">
                            <span className="text-[10px]" style={{ color: 'var(--text-ter)' }}>Freins</span>
                            <select value={dashboard.vehicule.etatFreins ?? ''} disabled={savingEtat === 'etatFreins'} onChange={(e) => handleEtatChange('etatFreins', e.target.value)} className="text-xs">
                              <option value="" disabled>— Choisir —</option>
                              {(Object.keys(ETAT_FREINS_LABELS) as EtatFreins[]).map((k) => <option key={k} value={k}>{ETAT_FREINS_LABELS[k]}</option>)}
                            </select>
                          </label>
                          <label className="block">
                            <span className="text-[10px]" style={{ color: 'var(--text-ter)' }}>Éclairage</span>
                            <select value={dashboard.vehicule.etatEclairage ?? ''} disabled={savingEtat === 'etatEclairage'} onChange={(e) => handleEtatChange('etatEclairage', e.target.value)} className="text-xs">
                              <option value="" disabled>— Choisir —</option>
                              {(Object.keys(ETAT_ECLAIRAGE_LABELS) as EtatEclairage[]).map((k) => <option key={k} value={k}>{ETAT_ECLAIRAGE_LABELS[k]}</option>)}
                            </select>
                          </label>
                          <label className="block col-span-2">
                            <span className="text-[10px]" style={{ color: 'var(--text-ter)' }}>Climatisation</span>
                            <select value={dashboard.vehicule.etatClimatisation ?? ''} disabled={savingEtat === 'etatClimatisation'} onChange={(e) => handleEtatChange('etatClimatisation', e.target.value)} className="text-xs">
                              <option value="" disabled>— Choisir —</option>
                              {(Object.keys(ETAT_CLIMATISATION_LABELS) as EtatClimatisation[]).map((k) => <option key={k} value={k}>{ETAT_CLIMATISATION_LABELS[k]}</option>)}
                            </select>
                          </label>
                        </div>
                      </div>
                    </div>
                  )}

                  {/* Toujours visible, même sans véhicule habituel (utilise alors le
                   *  véhicule de la mission active, voir POST /ma-mission/declarations). */}
                  <button
                    type="button"
                    onClick={() => setShowDeclarationForm(true)}
                    className="w-full flex items-center justify-center gap-1.5 text-xs font-semibold py-2.5 rounded-lg transition-colors focus-ring"
                    style={{ background: 'rgba(239,68,68,0.12)', border: '1px solid rgba(239,68,68,0.3)', color: 'var(--accent-err)' }}
                  >
                    <AlertOctagon size={13} /> Signaler un problème
                  </button>

                  {/* Jawaz — priorité au badge du véhicule, à défaut le badge personnel du chauffeur */}
                  {(() => {
                    const jawaz = dashboard.vehicule?.jawazNumero
                      ? { numero: dashboard.vehicule.jawazNumero, solde: dashboard.vehicule.jawazSolde, seuil: dashboard.vehicule.jawazSeuilAlerte, derniereRecharge: dashboard.vehicule.jawazDerniereRecharge }
                      : dashboard.chauffeur?.jawazNumero
                        ? { numero: dashboard.chauffeur.jawazNumero, solde: dashboard.chauffeur.jawazSolde, seuil: 100, derniereRecharge: null }
                        : null;
                    if (!jawaz) return null;
                    return (
                      <div>
                        <p className="text-[11px] uppercase tracking-wide mb-2" style={{ color: 'var(--text-ter)' }}>Jawaz</p>
                        <div className="rounded-lg px-3 py-2.5" style={{ background: 'var(--bg)' }}>
                          <div className="flex items-center justify-between">
                            <p className="text-xs flex items-center gap-1.5" style={{ color: 'var(--text-sec)' }}>
                              <CreditCard size={13} style={{ color: 'var(--text-ter)' }} /> {jawaz.numero}
                            </p>
                            <p className="text-sm font-semibold" style={{ color: jawaz.solde < jawaz.seuil ? 'var(--accent-err)' : 'var(--text-pri)' }}>
                              {jawaz.solde.toLocaleString('fr-FR')} DH
                            </p>
                          </div>
                          {jawaz.derniereRecharge && (
                            <p className="text-[10px] mt-1.5 pt-1.5" style={{ color: 'var(--text-ter)', borderTop: '1px solid var(--border)' }}>Dernière recharge : {jawaz.derniereRecharge}</p>
                          )}
                        </div>
                      </div>
                    );
                  })()}
                </div>
              )}
            </div>
          )}

          {/* Chargement */}
          {section === 'missions' && loading && (
            <div className="flex items-center justify-center py-12">
              <Loader2 size={24} className="animate-spin" style={{ color: 'var(--text-ter)' }} />
            </div>
          )}

          {/* Demande assignée : le chauffeur peut l'accepter ou la refuser directement */}
          {section === 'missions' && !loading && !deplacement && data?.pendingDemande && (
            <div className="rounded-2xl p-5" style={{ background: 'var(--card)', border: '1px solid var(--border)' }}>
              <div className="flex items-center justify-between mb-3">
                <p className="text-sm font-bold" style={{ color: 'var(--text-pri)' }}>Nouvelle demande — {data.pendingDemande.numero}</p>
                <Badge tone={data.pendingDemande.priorite === 'critique' ? 'bad' : data.pendingDemande.priorite === 'urgente' ? 'warn' : 'good'}>
                  {data.pendingDemande.priorite === 'critique' ? 'Critique' : data.pendingDemande.priorite === 'urgente' ? 'Urgente' : 'Normale'}
                </Badge>
              </div>
              <div className="space-y-1 mb-4 text-sm" style={{ color: 'var(--text-sec)' }}>
                {data.pendingDemande.serviceName && <p><span style={{ color: 'var(--text-ter)' }}>Service : </span>{data.pendingDemande.serviceName}</p>}
                <p><span style={{ color: 'var(--text-ter)' }}>Demandeur : </span>{data.pendingDemande.demandeurNom}</p>
                {data.pendingDemande.demandeurTelephone && <p><span style={{ color: 'var(--text-ter)' }}>Téléphone : </span>{data.pendingDemande.demandeurTelephone}</p>}
                {data.pendingDemande.observations && <p><span style={{ color: 'var(--text-ter)' }}>Observations : </span>{data.pendingDemande.observations}</p>}
              </div>
              <div className="flex gap-2">
                <Button variant="primary" disabled={acting} onClick={() => handleDemandeAction(data.pendingDemande!.id, 'accepter')} className="flex-1 justify-center py-2.5">
                  {acting ? <Loader2 size={16} className="animate-spin" /> : 'Accepter'}
                </Button>
                <Button variant="secondary" disabled={acting} onClick={() => handleDemandeAction(data.pendingDemande!.id, 'refuser')} className="flex-1 justify-center py-2.5">
                  Refuser
                </Button>
              </div>
            </div>
          )}

          {/* Demande acceptée par le chauffeur, en attente que le responsable crée l'ordre de mission */}
          {section === 'missions' && !loading && !deplacement && !data?.pendingDemande && data?.confirmedDemandeNumero && (
            <div className="text-center rounded-2xl p-8" style={{ background: 'var(--card)', border: '1px solid var(--border)' }}>
              <Loader2 size={28} className="animate-spin" style={{ color: '#f59e0b', margin: '0 auto 12px' }} />
              <p className="text-sm font-medium" style={{ color: 'var(--text-pri)' }}>Demande {data.confirmedDemandeNumero} acceptée</p>
              <p className="text-xs mt-1" style={{ color: 'var(--text-ter)' }}>Le responsable du parc prépare votre ordre de mission.</p>
            </div>
          )}

          {/* Pas de mission */}
          {section === 'missions' && !loading && !deplacement && !data?.pendingDemande && !data?.confirmedDemandeNumero && (
            <div className="text-center rounded-2xl p-8" style={{ background: 'var(--card)', border: '1px solid var(--border)' }}>
              <CheckCircle2 size={28} style={{ color: '#4ade80', margin: '0 auto 12px' }} />
              <p className="text-sm font-medium" style={{ color: 'var(--text-pri)' }}>Aucune mission en cours</p>
              <p className="text-xs mt-1" style={{ color: 'var(--text-ter)' }}>Vous serez notifié dès qu'une mission vous sera affectée.</p>
            </div>
          )}

          {/* Carte mission active */}
          {section === 'missions' && !loading && deplacement && (
            <div className="rounded-2xl overflow-hidden" style={{ background: 'var(--card)', border: '1px solid var(--border)' }}>
              {/* En-tête mission */}
              <div className="px-5 py-4" style={{ borderBottom: '1px solid var(--border)' }}>
                <div className="flex items-center justify-between mb-2">
                  <span className="text-xs font-mono font-semibold" style={{ color: 'var(--text-ter)' }}>{deplacement.numero}</span>
                  <Badge tone={deplacement.statut === 'annule' ? 'bad' : deplacement.statut === 'cloturee' ? 'good' : 'warn'}>
                    {DEPLACEMENT_STATUT_LABELS[deplacement.statut]}
                  </Badge>
                </div>

                {/* Barre de progression */}
                <div className="flex items-center gap-1">
                  {DEPLACEMENT_ETAPES.slice(0, 5).map((etape) => (
                    <span
                      key={etape}
                      className="block h-1.5 flex-1 rounded-full"
                      style={{
                        background: isEtapeAtteinte(etape)
                          ? DEPLACEMENT_ETAPE_COLOR[etape]
                          : 'var(--border)'
                      }}
                    />
                  ))}
                </div>
                <div className="flex items-center gap-1 mt-1">
                  {DEPLACEMENT_ETAPES.slice(5).map((etape) => (
                    <span
                      key={etape}
                      className="block h-1.5 flex-1 rounded-full"
                      style={{
                        background: isEtapeAtteinte(etape)
                          ? DEPLACEMENT_ETAPE_COLOR[etape]
                          : 'var(--border)'
                      }}
                    />
                  ))}
                </div>
              </div>

              {/* Contenu */}
              <div className="px-5 py-5 space-y-4">
                <div>
                  <p className="text-[11px] uppercase tracking-wide mb-1" style={{ color: 'var(--text-ter)' }}>Destination</p>
                  <p className="text-base font-bold flex items-center gap-2" style={{ color: 'var(--text-pri)' }}>
                    <MapPin size={15} style={{ color: 'var(--text-ter)' }} /> {deplacement.destination ?? '—'}
                  </p>
                </div>
                <div>
                  <p className="text-[11px] uppercase tracking-wide mb-1" style={{ color: 'var(--text-ter)' }}>Objet</p>
                  <p className="text-sm" style={{ color: 'var(--text-sec)' }}>{deplacement.objet}</p>
                </div>
                {data?.vehicule && (
                  <div>
                    <p className="text-[11px] uppercase tracking-wide mb-1" style={{ color: 'var(--text-ter)' }}>Véhicule</p>
                    <p className="text-sm flex items-center gap-2" style={{ color: 'var(--text-sec)' }}>
                      <Car size={14} style={{ color: 'var(--text-ter)' }} /> {data.vehicule.marque} {data.vehicule.modele} — {data.vehicule.immatriculation}
                    </p>
                  </div>
                )}
                <div className="grid grid-cols-2 gap-3">
                  <div>
                    <p className="text-[11px] uppercase tracking-wide mb-1" style={{ color: 'var(--text-ter)' }}>Date</p>
                    <p className="text-sm flex items-center gap-2" style={{ color: 'var(--text-sec)' }}>
                      <CalendarDays size={14} style={{ color: 'var(--text-ter)' }} /> {deplacement.dateDepart}
                    </p>
                  </div>
                  {(deplacement.heureDepartPrevue || deplacement.heureDepart) && (
                    <div>
                      <p className="text-[11px] uppercase tracking-wide mb-1" style={{ color: 'var(--text-ter)' }}>Heure</p>
                      <p className="text-sm flex items-center gap-2" style={{ color: 'var(--text-sec)' }}>
                        <Clock size={14} style={{ color: 'var(--text-ter)' }} /> {deplacement.heureDepartPrevue ?? deplacement.heureDepart}
                      </p>
                    </div>
                  )}
                </div>
                {data?.passagers && data.passagers.length > 0 && (
                  <div>
                    <p className="text-[11px] uppercase tracking-wide mb-1" style={{ color: 'var(--text-ter)' }}>Passagers</p>
                    <div className="space-y-1">
                      {data.passagers.map((p, i) => (
                        <p key={p.id ?? i} className="text-sm flex items-center gap-2" style={{ color: 'var(--text-sec)' }}>
                          <Users size={13} style={{ color: 'var(--text-ter)' }} /> {p.nom}{p.serviceId ? ` (service #${p.serviceId})` : ''}
                        </p>
                      ))}
                    </div>
                  </div>
                )}
                {deplacement.observations && (
                  <div>
                    <p className="text-[11px] uppercase tracking-wide mb-1" style={{ color: 'var(--text-ter)' }}>Observations</p>
                    <p className="text-sm flex items-start gap-2" style={{ color: 'var(--text-sec)' }}>
                      <StickyNote size={13} style={{ color: 'var(--text-ter)', marginTop: 2 }} /> {deplacement.observations}
                    </p>
                  </div>
                )}

                {/* Actions rapides (photos, signature) */}
                {deplacement.statut !== 'cloturee' && deplacement.statut !== 'annule' && (
                  <div className="flex gap-2 pt-2">
                    <label className="flex-1">
                      <div className="flex items-center justify-center gap-1.5 px-3 py-2 rounded-lg text-xs font-medium cursor-pointer transition-colors"
                        style={{ background: 'var(--bg)', color: 'var(--text-sec)', border: '1px solid var(--border)' }}>
                        <Camera size={14} /> Photo
                      </div>
                      <input type="file" accept="image/*" capture="environment" className="hidden" onChange={handlePhotoUpload} />
                    </label>
                    <button
                      onClick={() => setShowSignaturePad(true)}
                      className="flex-1 flex items-center justify-center gap-1.5 px-3 py-2 rounded-lg text-xs font-medium transition-colors"
                      style={{ background: 'var(--bg)', color: 'var(--text-sec)', border: '1px solid var(--border)' }}
                    >
                      <PenLine size={14} /> Signature
                    </button>
                    <button
                      onClick={() => setDetailView(!detailView)}
                      className="flex items-center justify-center gap-1.5 px-3 py-2 rounded-lg text-xs font-medium transition-colors"
                      style={{ background: 'var(--bg)', color: 'var(--text-sec)', border: '1px solid var(--border)' }}
                    >
                      {detailView ? <ChevronUp size={14} /> : <ChevronDown size={14} />} Détail
                    </button>
                  </div>
                )}

                {/* Vue détail (timeline, photos) */}
                {detailView && (
                  <MissionDetailView detail={detail} deplacement={deplacement} onRefresh={loadDetail} />
                )}
              </div>

              {/* Erreur */}
              {error && (
                <p className="mx-5 mb-3 text-xs rounded-lg px-3 py-2" style={{ color: 'var(--accent-err)', background: 'rgba(239,68,68,0.08)', border: '1px solid rgba(239,68,68,0.2)' }}>{error}</p>
              )}

              {/* Bouton d'action principal */}
              {action ? (
                <div className="px-5 pb-5">
                  <Button variant="primary" onClick={handleAction} disabled={acting} className="w-full justify-center py-3 text-base">
                    {acting ? <Loader2 size={16} className="animate-spin" /> : <ArrowRight size={16} />}
                    {acting ? 'Enregistrement…' : action.label}
                  </Button>
                </div>
              ) : deplacement.statut === 'cloturee' ? (
                <div className="px-5 pb-5 text-center">
                  <p className="text-sm" style={{ color: '#4ade80' }}>Mission clôturée — merci !</p>
                </div>
              ) : deplacement.statut === 'annule' ? (
                <div className="px-5 pb-5 text-center">
                  <p className="text-sm" style={{ color: 'var(--accent-err)' }}>Mission annulée.</p>
                </div>
              ) : null}
            </div>
          )}

          {/* Historique — chaque mission est cliquable pour voir le détail */}
          {section === 'missions' && !loading && historique.length > 0 && (
            <div className="rounded-2xl overflow-hidden" style={{ background: 'var(--card)', border: '1px solid var(--border)' }}>
              <div className="px-5 py-3 flex items-center gap-2" style={{ borderBottom: '1px solid var(--border)' }}>
                <History size={14} style={{ color: 'var(--text-ter)' }} />
                <p className="text-xs font-bold uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Historique ({historique.length})</p>
              </div>
              <div>
                {historique.slice(0, 15).map((h) => (
                  <button
                    key={h.id}
                    onClick={async () => {
                      try {
                        setDetail(null);
                        const res = await api.get<DeplacementDetail>(`/ma-mission/${h.id}/detail`);
                        setDetail(res);
                      } catch {
                        setError("Impossible de charger les détails de cette mission.");
                      }
                    }}
                    className="w-full flex items-center justify-between px-5 py-3 text-left transition-colors hover:bg-[var(--card-hover)]"
                    style={{ borderBottom: '1px solid var(--border)' }}
                  >
                    <div className="min-w-0">
                      <p className="text-sm font-mono truncate" style={{ color: 'var(--text-pri)' }}>{h.numero}</p>
                      <p className="text-xs truncate" style={{ color: 'var(--text-ter)' }}>{h.destination ?? h.objet ?? '—'} · {h.dateDepart}</p>
                    </div>
                    <Badge tone={h.statut === 'annule' ? 'bad' : 'good'}>{DEPLACEMENT_STATUT_LABELS[h.statut]}</Badge>
                  </button>
                ))}
              </div>
            </div>
          )}

          {/* Détail d'une mission historique (timeline, métriques) */}
          {detail && (!deplacement || detail.deplacement.id !== (data?.deplacement?.id ?? -1)) && (
            <div className="rounded-2xl overflow-hidden" style={{ background: 'var(--card)', border: '1px solid var(--border)' }}>
              <div className="px-5 py-3 flex items-center justify-between" style={{ borderBottom: '1px solid var(--border)' }}>
                <p className="text-xs font-bold uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>
                  Détail · {detail.deplacement.numero}
                </p>
                <button onClick={() => setDetail(null)} className="text-xs" style={{ color: 'var(--accent)' }}>Fermer</button>
              </div>
              <div className="px-5 py-4">
                <MissionDetailView detail={detail} deplacement={detail.deplacement} onRefresh={() => {}} />
              </div>
            </div>
          )}

          {/* ── Section Profil ── */}
          {section === 'profil' && (
            <div className="rounded-2xl p-5 space-y-4" style={{ background: 'var(--card)', border: '1px solid var(--border)' }}>
              <p className="text-xs font-bold uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Mon profil</p>
              <div className="flex items-center gap-3">
                <div className="flex items-center justify-center rounded-full text-base font-bold"
                  style={{ width: 44, height: 44, background: 'var(--grad-brand)', color: '#fff', flexShrink: 0 }}>
                  {(user?.displayName ?? user?.username ?? '?').slice(0, 1).toUpperCase()}
                </div>
                <div>
                  <p className="text-sm font-semibold" style={{ color: 'var(--text-pri)' }}>{user?.displayName ?? user?.username}</p>
                  <p className="text-xs" style={{ color: 'var(--text-ter)' }}>Chauffeur</p>
                </div>
              </div>
              {dashboard?.chauffeur && (
                <div className="rounded-xl p-3 space-y-1.5" style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}>
                  {dashboard.chauffeur.jawazNumero && (
                    <p className="text-xs" style={{ color: 'var(--text-sec)' }}>
                      <span style={{ color: 'var(--text-ter)' }}>Jawaz : </span>{dashboard.chauffeur.jawazNumero} — {dashboard.chauffeur.jawazSolde.toLocaleString('fr-FR')} DH
                    </p>
                  )}
                </div>
              )}
            </div>
          )}

          {/* ── Section Paramètres ── */}
          {section === 'parametres' && (
            <div className="rounded-2xl p-5 space-y-4" style={{ background: 'var(--card)', border: '1px solid var(--border)' }}>
              <p className="text-xs font-bold uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Paramètres</p>
              <div className="flex items-center justify-between py-2">
                <span className="text-sm" style={{ color: 'var(--text-sec)' }}>Thème sombre</span>
                <button
                  onClick={toggleTheme}
                  className="relative shrink-0 rounded-full transition-colors"
                  style={{ width: 34, height: 19, background: theme === 'dark' ? 'var(--grad-brand)' : 'rgba(0,0,0,0.14)' }}
                >
                  <span className="absolute rounded-full transition-transform"
                    style={{ width: 15, height: 15, top: 2, left: 2, background: '#fff', transform: theme === 'dark' ? 'translateX(15px)' : 'translateX(0)' }} />
                </button>
              </div>
              <div style={{ height: 1, background: 'var(--border)' }} />
              <button
                onClick={() => logout()}
                className="flex items-center gap-2 text-sm font-medium transition-colors"
                style={{ color: 'var(--accent-err)' }}
              >
                <LogOut size={15} /> Se déconnecter
              </button>
            </div>
          )}
        </div>
      </main>

      {showDeclarationForm && (
        <Modal open onClose={() => setShowDeclarationForm(false)} title="Signaler un problème" width="md">
          <DeclarationForm onClose={() => setShowDeclarationForm(false)} onSubmitted={load} />
        </Modal>
      )}
    </div>
  );
}

/* ═══════════════════════════════════════════════════════════════════════
 * VUE DÉTAIL (Timeline + Photos)
 * ═══════════════════════════════════════════════════════════════════════ */

function MissionDetailView({
  detail,
  deplacement,
  onRefresh
}: {
  detail: DeplacementDetail | null;
  deplacement: Deplacement;
  onRefresh: () => void;
}) {
  if (!detail) {
    return <p className="text-xs text-center py-4" style={{ color: 'var(--text-ter)' }}>Chargement du détail…</p>;
  }

  const events = detail.events ?? [];
  const photos = detail.photos ?? [];

  return (
    <div className="space-y-3 pt-2">
      {/* Timeline */}
      <div>
        <p className="text-[11px] uppercase tracking-wide mb-2" style={{ color: 'var(--text-ter)' }}>Timeline</p>
        <div className="space-y-2">
          {events.length === 0 && (
            <p className="text-xs" style={{ color: 'var(--text-ter)' }}>Aucun événement enregistré.</p>
          )}
          {events.map((event) => (
            <div key={event.id} className="flex items-start gap-2">
              <div className="w-2 h-2 rounded-full mt-1.5 shrink-0"
                style={{ background: DEPLACEMENT_ETAPE_COLOR[event.statut as DeplacementStatut] ?? 'var(--text-ter)' }}
              />
              <div className="flex-1 min-w-0">
                <div className="flex items-center justify-between">
                  <p className="text-xs font-medium" style={{ color: 'var(--text-pri)' }}>
                    {DEPLACEMENT_STATUT_LABELS[event.statut as DeplacementStatut] ?? event.statut}
                  </p>
                  <span className="text-[10px]" style={{ color: 'var(--text-ter)' }}>
                    {new Date(event.createdAt).toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' })}
                  </span>
                </div>
                <p className="text-[11px]" style={{ color: 'var(--text-ter)' }}>par {event.actionPar}</p>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Photos */}
      {photos.length > 0 && (
        <div>
          <p className="text-[11px] uppercase tracking-wide mb-2" style={{ color: 'var(--text-ter)' }}>Photos ({photos.length})</p>
          <div className="grid grid-cols-3 gap-2">
            {photos.map((photo) => (
              <div key={photo.id} className="rounded-lg overflow-hidden" style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}>
                <div className="aspect-square flex items-center justify-center">
                  <Image size={24} style={{ color: 'var(--text-ter)' }} />
                </div>
                <p className="text-[10px] px-1 py-1 truncate" style={{ color: 'var(--text-ter)' }}>{photo.originalName ?? photo.filename}</p>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Métriques (statistiques) */}
      {(deplacement.dureeMission != null || deplacement.distanceKm != null || deplacement.consommationCarburant != null) && (
        <div>
          <p className="text-[11px] uppercase tracking-wide mb-2" style={{ color: 'var(--text-ter)' }}>Métriques</p>
          <div className="grid grid-cols-3 gap-2">
            {deplacement.dureeMission != null && (
              <div className="rounded-lg px-3 py-2 text-center" style={{ background: 'var(--bg)' }}>
                <p className="text-lg font-bold" style={{ color: 'var(--text-pri)' }}>{Math.floor(deplacement.dureeMission / 60)}h{deplacement.dureeMission % 60}m</p>
                <p className="text-[10px]" style={{ color: 'var(--text-ter)' }}>Durée</p>
              </div>
            )}
            {deplacement.distanceKm != null && (
              <div className="rounded-lg px-3 py-2 text-center" style={{ background: 'var(--bg)' }}>
                <p className="text-lg font-bold" style={{ color: 'var(--text-pri)' }}>{deplacement.distanceKm} km</p>
                <p className="text-[10px]" style={{ color: 'var(--text-ter)' }}>Distance</p>
              </div>
            )}
            {deplacement.consommationCarburant != null && (
              <div className="rounded-lg px-3 py-2 text-center" style={{ background: 'var(--bg)' }}>
                <p className="text-lg font-bold" style={{ color: 'var(--text-pri)' }}>{deplacement.consommationCarburant} L</p>
                <p className="text-[10px]" style={{ color: 'var(--text-ter)' }}>Carburant</p>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
}

/* ═══════════════════════════════════════════════════════════════════════
 * SIGNATURE PAD (Canvas-based signature capture)
 * ═══════════════════════════════════════════════════════════════════════ */

function SignaturePad({
  onSave,
  onCancel
}: {
  onSave: (dataUrl: string) => void;
  onCancel: () => void;
}) {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const [isDrawing, setIsDrawing] = useState(false);
  const [hasContent, setHasContent] = useState(false);

  const startDrawing = (e: React.MouseEvent | React.TouchEvent) => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;
    setIsDrawing(true);
    const rect = canvas.getBoundingClientRect();
    const x = 'touches' in e ? e.touches[0].clientX - rect.left : e.clientX - rect.left;
    const y = 'touches' in e ? e.touches[0].clientY - rect.top : e.clientY - rect.top;
    ctx.beginPath();
    ctx.moveTo(x, y);
  };

  const draw = (e: React.MouseEvent | React.TouchEvent) => {
    if (!isDrawing) return;
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;
    const rect = canvas.getBoundingClientRect();
    const x = 'touches' in e ? e.touches[0].clientX - rect.left : e.clientX - rect.left;
    const y = 'touches' in e ? e.touches[0].clientY - rect.top : e.clientY - rect.top;
    ctx.lineTo(x, y);
    ctx.strokeStyle = 'var(--text-pri)';
    ctx.lineWidth = 2;
    ctx.stroke();
    setHasContent(true);
  };

  const stopDrawing = () => {
    setIsDrawing(false);
  };

  const clearCanvas = () => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    setHasContent(false);
  };

  const handleSave = () => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    onSave(canvas.toDataURL('image/png'));
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4" style={{ background: 'rgba(0,0,0,0.5)' }}>
      <div className="rounded-2xl p-4 w-full max-w-sm" style={{ background: 'var(--card)', border: '1px solid var(--border)' }}>
        <p className="text-sm font-semibold mb-3" style={{ color: 'var(--text-pri)' }}>Signature</p>
        <canvas
          ref={canvasRef}
          width={320}
          height={160}
          className="w-full rounded-lg touch-none"
          style={{ background: 'var(--bg)', border: '1px solid var(--border)', cursor: 'crosshair' }}
          onMouseDown={startDrawing}
          onMouseMove={draw}
          onMouseUp={stopDrawing}
          onMouseLeave={stopDrawing}
          onTouchStart={startDrawing}
          onTouchMove={draw}
          onTouchEnd={stopDrawing}
        />
        <div className="flex items-center justify-end gap-2 mt-3">
          <button onClick={clearCanvas} className="px-3 py-1.5 text-xs rounded-lg" style={{ color: 'var(--text-ter)' }}>
            Effacer
          </button>
          <button onClick={onCancel} className="px-3 py-1.5 text-xs rounded-lg" style={{ color: 'var(--text-ter)' }}>
            Annuler
          </button>
          <Button variant="primary" onClick={handleSave} disabled={!hasContent} className="text-xs py-1.5">
            Enregistrer
          </Button>
        </div>
      </div>
    </div>
  );
}

