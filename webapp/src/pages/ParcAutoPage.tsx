import { useMemo, useState, useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Plus, Search, Car, Gauge, ShieldAlert, Wrench, CheckCircle2, Fuel, Clock,
  MapPin, Pencil, Trash2, FileSpreadsheet, Droplet, CreditCard, History, AlertTriangle,
  User as UserIcon, Camera, UserPlus, UserMinus
} from 'lucide-react';
import { PageHeader, Card, StatCard, Badge, Button, Modal, EmptyState } from '../components/ui/Kit';
import { useParcAuto } from '../context/ParcAutoContext';
import { exportVehiculesToExcel } from '../lib/parcAutoExport';
import {
  type Vehicule, type VehiculeEvent, type Deplacement, type VehiculeStatut, type VehiculeCarburant, type VehiculeAffectation,
  VEHICULE_STATUT_LABELS, VEHICULE_STATUT_TONE, CARBURANT_LABELS,
  DEPLACEMENT_STATUT_LABELS, DEPLACEMENT_STATUT_TONE,
  ETAT_PNEUS_LABELS, ETAT_PNEUS_TONE, ETAT_BATTERIE_LABELS, ETAT_BATTERIE_TONE,
  ETAT_FREINS_LABELS, ETAT_FREINS_TONE, ETAT_ECLAIRAGE_LABELS, ETAT_ECLAIRAGE_TONE,
  ETAT_CLIMATISATION_LABELS, ETAT_CLIMATISATION_TONE
} from '../types/parcAuto';

const STATUT_TABS: { value: string; label: string }[] = [
  { value: '', label: 'Tous' },
  { value: 'disponible', label: 'Disponibles' },
  { value: 'en_mission', label: 'En mission' },
  { value: 'maintenance', label: 'Maintenance' },
  { value: 'hors_service', label: 'Hors service' }
];

function formatDateTime(iso: string): string {
  return new Date(iso).toLocaleString('fr-FR', { day: '2-digit', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit' });
}

/** Nombre de jours restants avant une date d'échéance (négatif si dépassée). */
function joursAvant(dateIso: string): number {
  const diff = new Date(dateIso).getTime() - Date.now();
  return Math.round(diff / 86_400_000);
}

/** État de la vidange à partir du kilométrage actuel vs. le seuil prévu. */
function vidangeEtat(kmActuel: number, kmProchain?: number | null): { label: string; tone: 'good' | 'warn' | 'bad' } | null {
  if (kmProchain == null) return null;
  const reste = kmProchain - kmActuel;
  if (reste <= 0) return { label: `Dépassée de ${Math.abs(reste).toLocaleString('fr-FR')} km`, tone: 'bad' };
  if (reste <= 500) return { label: `${reste.toLocaleString('fr-FR')} km restants`, tone: 'warn' };
  return { label: `${reste.toLocaleString('fr-FR')} km restants`, tone: 'good' };
}

/** État du solde Jawaz par rapport au seuil d'alerte configuré. */
function jawazEtat(solde: number, seuil: number): { label: string; tone: 'good' | 'warn' | 'bad' } {
  if (solde <= 0) return { label: 'Vide', tone: 'bad' };
  if (solde < seuil) return { label: 'Solde bas', tone: 'bad' };
  if (solde < seuil * 2) return { label: 'À surveiller', tone: 'warn' };
  return { label: 'OK', tone: 'good' };
}

/* ── Formulaire véhicule (création ou modification) ──────────────────── */
function VehiculeForm({ initial, onClose }: { initial?: Vehicule | null; onClose: () => void }) {
  const { createVehicule, updateVehicule } = useParcAuto();
  const [immatriculation, setImmatriculation] = useState(initial?.immatriculation ?? '');
  const [marque, setMarque] = useState(initial?.marque ?? '');
  const [modele, setModele] = useState(initial?.modele ?? '');
  const [annee, setAnnee] = useState(initial?.annee ? String(initial.annee) : '');
  const [carburant, setCarburant] = useState<VehiculeCarburant>(initial?.carburant ?? 'diesel');
  const [kilometrage, setKilometrage] = useState(initial ? String(initial.kilometrage) : '0');
  const [assuranceExpiration, setAssuranceExpiration] = useState('');
  const [visiteTechniqueExpiration, setVisiteTechniqueExpiration] = useState('');
  const [derniereVidange, setDerniereVidange] = useState('');
  const [vidangeExpiration, setVidangeExpiration] = useState('');
  const [kilometrageDerniereVidange, setKilometrageDerniereVidange] = useState(initial?.kilometrageDerniereVidange ? String(initial.kilometrageDerniereVidange) : '');
  const [kilometrageProchaineVidange, setKilometrageProchaineVidange] = useState(initial?.kilometrageProchaineVidange ? String(initial.kilometrageProchaineVidange) : '');
  const [typeHuile, setTypeHuile] = useState(initial?.typeHuile ?? '');
  const [garageVidange, setGarageVidange] = useState(initial?.garageVidange ?? '');
  const [vidangeObservations, setVidangeObservations] = useState(initial?.vidangeObservations ?? '');
  const [jawazNumero, setJawazNumero] = useState(initial?.jawazNumero ?? '');
  const [jawazSolde, setJawazSolde] = useState(initial ? String(initial.jawazSolde ?? 0) : '0');
  const [jawazDerniereRecharge, setJawazDerniereRecharge] = useState('');
  const [jawazSeuilAlerte, setJawazSeuilAlerte] = useState(initial ? String(initial.jawazSeuilAlerte ?? 100) : '100');
  const [notes, setNotes] = useState(initial?.notes ?? '');
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const toDMY = (iso: string) => { const [y, m, d] = iso.split('-'); return `${d}/${m}/${y}`; };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!marque.trim() || !modele.trim() || (!initial && !immatriculation.trim())) return;
    setSaving(true);
    setError(null);
    try {
      if (initial) {
        await updateVehicule(initial.id, {
          marque: marque.trim(),
          modele: modele.trim(),
          annee: annee ? Number(annee) : undefined,
          carburant,
          kilometrage: kilometrage ? Number(kilometrage) : 0,
          assuranceExpiration: assuranceExpiration ? toDMY(assuranceExpiration) : undefined,
          visiteTechniqueExpiration: visiteTechniqueExpiration ? toDMY(visiteTechniqueExpiration) : undefined,
          derniereVidange: derniereVidange ? toDMY(derniereVidange) : undefined,
          vidangeExpiration: vidangeExpiration ? toDMY(vidangeExpiration) : undefined,
          kilometrageDerniereVidange: kilometrageDerniereVidange ? Number(kilometrageDerniereVidange) : undefined,
          kilometrageProchaineVidange: kilometrageProchaineVidange ? Number(kilometrageProchaineVidange) : undefined,
          typeHuile: typeHuile.trim() || undefined,
          garageVidange: garageVidange.trim() || undefined,
          vidangeObservations: vidangeObservations.trim() || undefined,
          jawazNumero: jawazNumero.trim() || undefined,
          jawazSolde: jawazSolde ? Number(jawazSolde) : undefined,
          jawazDerniereRecharge: jawazDerniereRecharge ? toDMY(jawazDerniereRecharge) : undefined,
          jawazSeuilAlerte: jawazSeuilAlerte ? Number(jawazSeuilAlerte) : undefined,
          notes: notes.trim() || undefined
        });
      } else {
        await createVehicule({
          immatriculation: immatriculation.trim().toUpperCase(),
          marque: marque.trim(),
          modele: modele.trim(),
          annee: annee ? Number(annee) : undefined,
          carburant,
          kilometrage: kilometrage ? Number(kilometrage) : 0,
          assuranceExpiration: assuranceExpiration ? toDMY(assuranceExpiration) : undefined,
          visiteTechniqueExpiration: visiteTechniqueExpiration ? toDMY(visiteTechniqueExpiration) : undefined,
          derniereVidange: derniereVidange ? toDMY(derniereVidange) : undefined,
          vidangeExpiration: vidangeExpiration ? toDMY(vidangeExpiration) : undefined,
          kilometrageDerniereVidange: kilometrageDerniereVidange ? Number(kilometrageDerniereVidange) : undefined,
          kilometrageProchaineVidange: kilometrageProchaineVidange ? Number(kilometrageProchaineVidange) : undefined,
          typeHuile: typeHuile.trim() || undefined,
          garageVidange: garageVidange.trim() || undefined,
          vidangeObservations: vidangeObservations.trim() || undefined,
          jawazNumero: jawazNumero.trim() || undefined,
          jawazSolde: jawazSolde ? Number(jawazSolde) : undefined,
          jawazDerniereRecharge: jawazDerniereRecharge ? toDMY(jawazDerniereRecharge) : undefined,
          jawazSeuilAlerte: jawazSeuilAlerte ? Number(jawazSeuilAlerte) : undefined,
          notes: notes.trim() || undefined
        });
      }
      onClose();
    } catch {
      setError(initial ? "Impossible d'enregistrer les modifications." : "Impossible d'ajouter ce véhicule (immatriculation déjà utilisée ?).");
    } finally {
      setSaving(false);
    }
  };

  return (
    <form className="space-y-3" onSubmit={handleSubmit}>
      <div className="grid grid-cols-2 gap-3">
        <label>
          <span>Immatriculation *</span>
          <input required disabled={Boolean(initial)} value={immatriculation} onChange={(e) => setImmatriculation(e.target.value)} placeholder="12345-A-6" className={initial ? 'opacity-60' : ''} />
        </label>
        <label>
          <span>Année</span>
          <input type="number" value={annee} onChange={(e) => setAnnee(e.target.value)} placeholder="2022" />
        </label>
      </div>
      <div className="grid grid-cols-2 gap-3">
        <label>
          <span>Marque *</span>
          <input required value={marque} onChange={(e) => setMarque(e.target.value)} placeholder="Dacia" />
        </label>
        <label>
          <span>Modèle *</span>
          <input required value={modele} onChange={(e) => setModele(e.target.value)} placeholder="Duster" />
        </label>
      </div>
      <div className="grid grid-cols-2 gap-3">
        <label>
          <span>Carburant</span>
          <select value={carburant} onChange={(e) => setCarburant(e.target.value as VehiculeCarburant)}>
            {(Object.keys(CARBURANT_LABELS) as VehiculeCarburant[]).map((c) => (
              <option key={c} value={c}>{CARBURANT_LABELS[c]}</option>
            ))}
          </select>
        </label>
        <label>
          <span>Kilométrage actuel</span>
          <input type="number" min={0} value={kilometrage} onChange={(e) => setKilometrage(e.target.value)} />
        </label>
      </div>
      <div className="grid grid-cols-2 gap-3">
        <label>
          <span>Expiration assurance {initial?.assuranceExpiration ? `(actuelle : ${initial.assuranceExpiration})` : ''}</span>
          <input type="date" value={assuranceExpiration} onChange={(e) => setAssuranceExpiration(e.target.value)} />
        </label>
        <label>
          <span>Expiration visite technique {initial?.visiteTechniqueExpiration ? `(actuelle : ${initial.visiteTechniqueExpiration})` : ''}</span>
          <input type="date" value={visiteTechniqueExpiration} onChange={(e) => setVisiteTechniqueExpiration(e.target.value)} />
        </label>
      </div>
      <div className="grid grid-cols-2 gap-3">
        <label>
          <span>Date vidange {initial?.derniereVidange ? `(dernière : ${initial.derniereVidange})` : ''}</span>
          <input type="date" value={derniereVidange} onChange={(e) => setDerniereVidange(e.target.value)} />
        </label>
        <label>
          <span>Expiration vidange {initial?.vidangeExpiration ? `(actuelle : ${initial.vidangeExpiration})` : ''}</span>
          <input type="date" value={vidangeExpiration} onChange={(e) => setVidangeExpiration(e.target.value)} />
        </label>
      </div>

      <div className="pt-2" style={{ borderTop: '1px solid var(--border)' }}>
        <p className="text-xs font-semibold mb-2 pt-2 flex items-center gap-1.5" style={{ color: 'var(--text-ter)' }}><Droplet size={12} /> Entretien — vidange</p>
        <div className="grid grid-cols-2 gap-3">
          <label>
            <span>Km lors de la dernière vidange</span>
            <input type="number" min={0} value={kilometrageDerniereVidange} onChange={(e) => setKilometrageDerniereVidange(e.target.value)} placeholder="120000" />
          </label>
          <label>
            <span>Prochaine vidange à (km)</span>
            <input type="number" min={0} value={kilometrageProchaineVidange} onChange={(e) => setKilometrageProchaineVidange(e.target.value)} placeholder="130000" />
          </label>
        </div>
        <div className="grid grid-cols-2 gap-3 mt-3">
          <label>
            <span>Type d'huile</span>
            <input value={typeHuile} onChange={(e) => setTypeHuile(e.target.value)} placeholder="5W30" />
          </label>
          <label>
            <span>Garage</span>
            <input value={garageVidange} onChange={(e) => setGarageVidange(e.target.value)} placeholder="Garage Al Amal" />
          </label>
        </div>
        <label className="block mt-3">
          <span>Observations vidange</span>
          <textarea rows={2} value={vidangeObservations} onChange={(e) => setVidangeObservations(e.target.value)} placeholder="Filtre à huile changé, niveau vérifié…" />
        </label>
      </div>

      <div className="pt-2" style={{ borderTop: '1px solid var(--border)' }}>
        <p className="text-xs font-semibold mb-2 pt-2 flex items-center gap-1.5" style={{ color: 'var(--text-ter)' }}><CreditCard size={12} /> Jawaz</p>
        <div className="grid grid-cols-2 gap-3">
          <label>
            <span>Numéro Jawaz</span>
            <input value={jawazNumero} onChange={(e) => setJawazNumero(e.target.value)} placeholder="JW-000000" />
          </label>
          <label>
            <span>Solde actuel (DH) {initial?.jawazSolde !== undefined ? `(actuel : ${initial.jawazSolde} DH)` : ''}</span>
            <input type="number" min={0} step="0.01" value={jawazSolde} onChange={(e) => setJawazSolde(e.target.value)} />
          </label>
        </div>
        <div className="grid grid-cols-2 gap-3 mt-3">
          <label>
            <span>Dernière recharge {initial?.jawazDerniereRecharge ? `(actuelle : ${initial.jawazDerniereRecharge})` : ''}</span>
            <input type="date" value={jawazDerniereRecharge} onChange={(e) => setJawazDerniereRecharge(e.target.value)} />
          </label>
          <label>
            <span>Seuil d'alerte (DH)</span>
            <input type="number" min={0} step="0.01" value={jawazSeuilAlerte} onChange={(e) => setJawazSeuilAlerte(e.target.value)} />
          </label>
        </div>
      </div>

      <label>
        <span>Notes</span>
        <textarea rows={2} value={notes} onChange={(e) => setNotes(e.target.value)} placeholder="Équipements, remarques…" />
      </label>
      {error && (
        <p className="text-xs rounded-lg px-3 py-2" style={{ color: 'var(--accent-err)', background: 'rgba(239,68,68,0.08)', border: '1px solid rgba(239,68,68,0.2)' }}>{error}</p>
      )}
      <div className="flex justify-end gap-2 pt-2">
        <Button variant="secondary" type="button" onClick={onClose}>Annuler</Button>
        <Button variant="primary" type="submit" disabled={saving}>
          <Plus size={13} /> {saving ? 'Enregistrement…' : initial ? 'Enregistrer' : 'Ajouter le véhicule'}
        </Button>
      </div>
    </form>
  );
}

/** Responsabilité du véhicule : chauffeur en charge, affectation / retrait, historique. */
function AffectationSection({ vehicule, onChanged }: { vehicule: Vehicule; onChanged: () => void }) {
  const { chauffeurs, assignVehicule, unassignVehicule, fetchAffectations } = useParcAuto();
  const [showHistorique, setShowHistorique] = useState(false);
  const [historique, setHistorique] = useState<VehiculeAffectation[]>([]);
  const [loadingHistorique, setLoadingHistorique] = useState(false);
  const [assigning, setAssigning] = useState(false);
  const [selectedChauffeurId, setSelectedChauffeurId] = useState('');
  const [error, setError] = useState<string | null>(null);

  const chauffeurResponsable = vehicule.chauffeurAttitreId != null ? chauffeurs.find((c) => c.id === vehicule.chauffeurAttitreId) ?? null : null;

  const handleAssign = async () => {
    if (!selectedChauffeurId) return;
    setAssigning(true);
    setError(null);
    try {
      await assignVehicule(vehicule.id, Number(selectedChauffeurId));
      setSelectedChauffeurId('');
      setHistorique([]);
      onChanged();
    } catch {
      setError("Impossible d'affecter ce véhicule.");
    } finally {
      setAssigning(false);
    }
  };

  const handleUnassign = async () => {
    setAssigning(true);
    setError(null);
    try {
      await unassignVehicule(vehicule.id);
      setHistorique([]);
      onChanged();
    } catch {
      setError("Impossible de retirer l'affectation.");
    } finally {
      setAssigning(false);
    }
  };

  const toggleHistorique = () => {
    if (!showHistorique && historique.length === 0) {
      setLoadingHistorique(true);
      fetchAffectations(vehicule.id)
        .then(setHistorique)
        .catch(() => setError("Impossible de charger l'historique des affectations."))
        .finally(() => setLoadingHistorique(false));
    }
    setShowHistorique((v) => !v);
  };

  return (
    <div className="pt-3" style={{ borderTop: '1px solid var(--border)' }}>
      <p className="text-xs font-semibold mb-2 flex items-center gap-1.5" style={{ color: 'var(--text-ter)' }}><UserIcon size={12} /> Responsabilité du véhicule</p>

      {chauffeurResponsable ? (
        <div className="flex items-center justify-between rounded-lg px-3 py-2.5" style={{ background: 'var(--bg)' }}>
          <div>
            <p className="text-sm font-medium" style={{ color: 'var(--text-pri)' }}>{chauffeurResponsable.nom}</p>
            <p className="text-xs" style={{ color: 'var(--text-ter)' }}>Chauffeur responsable</p>
          </div>
          <button title="Retirer l'affectation" className="tbl-btn danger focus-ring" onClick={handleUnassign} disabled={assigning}>
            <UserMinus size={14} />
          </button>
        </div>
      ) : (
        <p className="text-xs mb-2" style={{ color: 'var(--text-ter)' }}>Aucun chauffeur responsable pour l'instant.</p>
      )}

      <div className="flex items-center gap-2 mt-2">
        <select value={selectedChauffeurId} onChange={(e) => setSelectedChauffeurId(e.target.value)} className="flex-1">
          <option value="">{chauffeurResponsable ? '— Remplacer par —' : '— Choisir un chauffeur —'}</option>
          {chauffeurs.filter((c) => c.id !== vehicule.chauffeurAttitreId).map((c) => (
            <option key={c.id} value={c.id}>{c.nom}</option>
          ))}
        </select>
        <Button variant="secondary" type="button" onClick={handleAssign} disabled={!selectedChauffeurId || assigning}>
          <UserPlus size={13} /> {chauffeurResponsable ? 'Remplacer' : 'Affecter'}
        </Button>
      </div>

      {error && <p className="text-xs mt-2" style={{ color: 'var(--accent-err)' }}>{error}</p>}

      <button type="button" className="text-xs mt-2 flex items-center gap-1 focus-ring" style={{ color: 'var(--text-ter)' }} onClick={toggleHistorique}>
        <History size={11} /> {showHistorique ? 'Masquer' : 'Voir'} l'historique des affectations
      </button>
      {showHistorique && (
        <div className="mt-2 space-y-1.5">
          {loadingHistorique ? (
            <p className="text-xs" style={{ color: 'var(--text-ter)' }}>Chargement…</p>
          ) : historique.length === 0 ? (
            <p className="text-xs" style={{ color: 'var(--text-ter)' }}>Aucune affectation enregistrée.</p>
          ) : (
            historique.map((a) => (
              <div key={a.id} className="text-xs rounded-lg px-3 py-2 flex items-center justify-between gap-2" style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}>
                <span style={{ color: 'var(--text-sec)' }}>{a.chauffeurNom}</span>
                <span className="text-right" style={{ color: 'var(--text-ter)' }}>{a.dateAffectation} → {a.dateFin ?? 'en cours'}<br />validé par {a.responsable}</span>
              </div>
            ))
          )}
        </div>
      )}
    </div>
  );
}

/* ── Panneau détail véhicule ─────────────────────────────────────────── */
function VehiculeDetail({ id, onClose }: { id: number; onClose: () => void }) {
  const navigate = useNavigate();
  const { fetchVehiculeDetail, setVehiculeStatut, deleteVehicule, uploadVehiculePhoto } = useParcAuto();
  const [vehicule, setVehicule] = useState<Vehicule | null>(null);
  const [events, setEvents] = useState<VehiculeEvent[]>([]);
  const [deplacements, setDeplacements] = useState<Deplacement[]>([]);
  const [loading, setLoading] = useState(true);
  const [acting, setActing] = useState<VehiculeStatut | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [editing, setEditing] = useState(false);
  const [confirmDelete, setConfirmDelete] = useState(false);
  const [uploadingPhoto, setUploadingPhoto] = useState(false);
  const photoInputRef = useRef<HTMLInputElement>(null);

  const load = () => {
    setLoading(true);
    fetchVehiculeDetail(id)
      .then((res) => { setVehicule(res.vehicule); setEvents(res.events); setDeplacements(res.deplacements); })
      .catch(() => setError('Impossible de charger ce véhicule.'))
      .finally(() => setLoading(false));
  };
  useEffect(() => { load(); /* eslint-disable-next-line react-hooks/exhaustive-deps */ }, [id]);

  const handlePhotoFile = async (file: File) => {
    setUploadingPhoto(true);
    try { await uploadVehiculePhoto(id, file); load(); } catch { setError("Échec de l'envoi de la photo."); } finally { setUploadingPhoto(false); }
  };

  const handleStatut = async (statut: VehiculeStatut) => {
    setActing(statut);
    setError(null);
    try {
      await setVehiculeStatut(id, statut);
      load();
    } catch {
      setError("Ce changement de statut a échoué (véhicule peut-être en mission).");
    } finally {
      setActing(null);
    }
  };

  const handleDelete = async () => {
    try {
      await deleteVehicule(id);
      onClose();
    } catch {
      setError('Impossible de supprimer ce véhicule.');
      setConfirmDelete(false);
    }
  };

  const otherStatuts: VehiculeStatut[] = vehicule
    ? (['disponible', 'maintenance', 'hors_service'] as VehiculeStatut[]).filter((s) => s !== vehicule.statut)
    : [];

  if (editing && vehicule) {
    return (
      <Modal open onClose={() => setEditing(false)} title={`Modifier ${vehicule.immatriculation}`} width="md">
        <VehiculeForm initial={vehicule} onClose={() => { setEditing(false); load(); }} />
      </Modal>
    );
  }

  return (
    <Modal open onClose={onClose} title={vehicule ? `${vehicule.immatriculation} — ${vehicule.marque} ${vehicule.modele}` : 'Véhicule'} width="lg">
      {loading || !vehicule ? (
        <p className="text-sm py-8 text-center" style={{ color: 'var(--text-ter)' }}>Chargement…</p>
      ) : (
        <div className="space-y-5">
          <div className="flex items-center justify-between">
            <div className="relative">
              {vehicule.photoUrl ? (
                <img src={vehicule.photoUrl} alt="" className="w-14 h-14 rounded-xl object-cover" />
              ) : (
                <div className="w-14 h-14 rounded-xl flex items-center justify-center" style={{ background: 'rgba(99,102,241,0.14)' }}>
                  <Car size={22} style={{ color: 'var(--accent)' }} />
                </div>
              )}
              <button
                title="Changer la photo"
                onClick={() => photoInputRef.current?.click()}
                className="absolute -bottom-1 -right-1 w-5 h-5 rounded-full flex items-center justify-center focus-ring"
                style={{ background: 'var(--accent)', color: '#fff' }}
              >
                {uploadingPhoto ? <span className="text-[8px]">…</span> : <Camera size={10} />}
              </button>
              <input ref={photoInputRef} type="file" accept="image/*" hidden onChange={(e) => e.target.files?.[0] && handlePhotoFile(e.target.files[0])} />
            </div>
            <div className="flex items-center gap-1">
              <button title="Historique de maintenance" className="tbl-btn focus-ring" onClick={() => navigate(`/logistique/maintenance?vehiculeId=${id}`)}>
                <History size={14} />
              </button>
              <button title="Modifier" className="tbl-btn focus-ring" onClick={() => setEditing(true)}>
                <Pencil size={14} />
              </button>
              <button title="Supprimer" className="tbl-btn danger focus-ring" onClick={() => setConfirmDelete(true)}>
                <Trash2 size={14} />
              </button>
            </div>
          </div>

          {vehicule.statut === 'en_mission' && vehicule.missionActuelle && (
            <div className="flex items-start gap-2 text-sm rounded-lg px-3 py-2.5" style={{ color: 'var(--accent-warn)', background: 'rgba(245,158,11,0.10)', border: '1px solid rgba(245,158,11,0.28)' }}>
              <MapPin size={15} className="shrink-0 mt-0.5" />
              <div>
                <p className="font-medium">En mission à {vehicule.missionActuelle.destination || 'destination non précisée'}</p>
                <p className="text-xs mt-0.5 opacity-90">
                  Chauffeur : {vehicule.missionActuelle.chauffeurNom || 'non désigné'} · Retour prévu : {vehicule.missionActuelle.dateRetourPrevue || 'non précisé'}
                </p>
              </div>
            </div>
          )}
          <div className="flex flex-wrap items-center gap-2">
            <Badge tone={VEHICULE_STATUT_TONE[vehicule.statut]}>{VEHICULE_STATUT_LABELS[vehicule.statut]}</Badge>
            <Badge><Fuel size={11} className="inline mr-1" />{CARBURANT_LABELS[vehicule.carburant]}</Badge>
            <Badge><Gauge size={11} className="inline mr-1" />{vehicule.kilometrage.toLocaleString('fr-FR')} km</Badge>
          </div>

          <AffectationSection vehicule={vehicule} onChanged={load} />

          {(vehicule.etatPneus || vehicule.etatBatterie || vehicule.etatFreins || vehicule.etatEclairage || vehicule.etatClimatisation) && (
            <div className="pt-3" style={{ borderTop: '1px solid var(--border)' }}>
              <p className="text-xs font-semibold mb-2" style={{ color: 'var(--text-ter)' }}>États déclarés par le chauffeur</p>
              <div className="flex flex-wrap gap-1.5">
                {vehicule.etatPneus && <Badge tone={ETAT_PNEUS_TONE[vehicule.etatPneus]}>Pneus : {ETAT_PNEUS_LABELS[vehicule.etatPneus]}</Badge>}
                {vehicule.etatBatterie && <Badge tone={ETAT_BATTERIE_TONE[vehicule.etatBatterie]}>Batterie : {ETAT_BATTERIE_LABELS[vehicule.etatBatterie]}</Badge>}
                {vehicule.etatFreins && <Badge tone={ETAT_FREINS_TONE[vehicule.etatFreins]}>Freins : {ETAT_FREINS_LABELS[vehicule.etatFreins]}</Badge>}
                {vehicule.etatEclairage && <Badge tone={ETAT_ECLAIRAGE_TONE[vehicule.etatEclairage]}>Éclairage : {ETAT_ECLAIRAGE_LABELS[vehicule.etatEclairage]}</Badge>}
                {vehicule.etatClimatisation && <Badge tone={ETAT_CLIMATISATION_TONE[vehicule.etatClimatisation]}>Climatisation : {ETAT_CLIMATISATION_LABELS[vehicule.etatClimatisation]}</Badge>}
              </div>
            </div>
          )}

          <div className="grid grid-cols-2 gap-3 text-sm">
            {vehicule.annee && (
              <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Année</p><p style={{ color: 'var(--text-pri)' }}>{vehicule.annee}</p></div>
            )}
            {vehicule.assuranceExpiration && (
              <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Assurance</p><p style={{ color: 'var(--text-pri)' }}>{vehicule.assuranceExpiration}</p></div>
            )}
            {vehicule.visiteTechniqueExpiration && (
              <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Visite technique</p><p style={{ color: 'var(--text-pri)' }}>{vehicule.visiteTechniqueExpiration}</p></div>
            )}
            {vehicule.derniereVidange && (
              <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Dernière vidange</p><p style={{ color: 'var(--text-pri)' }}>{vehicule.derniereVidange}</p></div>
            )}
            {vehicule.vidangeExpiration && (
              <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Prochaine vidange</p><p style={{ color: 'var(--text-pri)' }}>{vehicule.vidangeExpiration}</p></div>
            )}
          </div>

          {/* Entretien — vidange (suivi kilométrique) */}
          {(vehicule.kilometrageDerniereVidange != null || vehicule.kilometrageProchaineVidange != null || vehicule.typeHuile || vehicule.garageVidange) && (
            <div className="pt-3" style={{ borderTop: '1px solid var(--border)' }}>
              <p className="text-xs font-semibold mb-2 flex items-center gap-1.5" style={{ color: 'var(--text-ter)' }}><Droplet size={12} /> Entretien — vidange</p>
              <div className="grid grid-cols-2 gap-3 text-sm mb-2">
                {vehicule.kilometrageDerniereVidange != null && (
                  <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Dernière vidange</p><p style={{ color: 'var(--text-pri)' }}>{vehicule.kilometrageDerniereVidange.toLocaleString('fr-FR')} km</p></div>
                )}
                {vehicule.kilometrageProchaineVidange != null && (
                  <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Prochaine</p><p style={{ color: 'var(--text-pri)' }}>{vehicule.kilometrageProchaineVidange.toLocaleString('fr-FR')} km</p></div>
                )}
                {vehicule.typeHuile && (
                  <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Type d'huile</p><p style={{ color: 'var(--text-pri)' }}>{vehicule.typeHuile}</p></div>
                )}
                {vehicule.garageVidange && (
                  <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Garage</p><p style={{ color: 'var(--text-pri)' }}>{vehicule.garageVidange}</p></div>
                )}
              </div>
              {(() => {
                const etat = vidangeEtat(vehicule.kilometrage, vehicule.kilometrageProchaineVidange);
                return etat ? <Badge tone={etat.tone}>Reste {etat.label}</Badge> : null;
              })()}
              {vehicule.vidangeObservations && <p className="text-xs mt-2" style={{ color: 'var(--text-sec)' }}>{vehicule.vidangeObservations}</p>}
            </div>
          )}

          {/* Jawaz */}
          {(vehicule.jawazNumero || vehicule.jawazSolde > 0) && (
            <div className="pt-3" style={{ borderTop: '1px solid var(--border)' }}>
              <p className="text-xs font-semibold mb-2 flex items-center gap-1.5" style={{ color: 'var(--text-ter)' }}><CreditCard size={12} /> Jawaz</p>
              <div className="grid grid-cols-2 gap-3 text-sm mb-2">
                {vehicule.jawazNumero && (
                  <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Numéro</p><p className="font-mono" style={{ color: 'var(--text-pri)' }}>{vehicule.jawazNumero}</p></div>
                )}
                <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Solde actuel</p><p style={{ color: 'var(--text-pri)' }}>{vehicule.jawazSolde.toLocaleString('fr-FR')} DH</p></div>
                {vehicule.jawazDerniereRecharge && (
                  <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Dernière recharge</p><p style={{ color: 'var(--text-pri)' }}>{vehicule.jawazDerniereRecharge}</p></div>
                )}
              </div>
              <Badge tone={jawazEtat(vehicule.jawazSolde, vehicule.jawazSeuilAlerte).tone}>{jawazEtat(vehicule.jawazSolde, vehicule.jawazSeuilAlerte).label}</Badge>
            </div>
          )}

          {vehicule.notes && <p className="text-sm" style={{ color: 'var(--text-sec)' }}>{vehicule.notes}</p>}

          {/* Changer statut */}
          <div className="pt-3" style={{ borderTop: '1px solid var(--border)' }}>
            <p className="text-xs font-semibold mb-2" style={{ color: 'var(--text-ter)' }}>Changer le statut</p>
            {vehicule.statut === 'en_mission' && (
              <p className="text-xs mb-2" style={{ color: 'var(--text-ter)' }}>
                Ce véhicule est en mission — clôturez le déplacement en cours (page Déplacements) pour le libérer.
              </p>
            )}
            {error && (
              <p className="text-xs rounded-lg px-3 py-2 mb-2" style={{ color: 'var(--accent-err)', background: 'rgba(239,68,68,0.08)', border: '1px solid rgba(239,68,68,0.2)' }}>{error}</p>
            )}
            <div className="flex flex-wrap gap-2">
              {otherStatuts.map((s) => (
                <Button key={s} variant="secondary" disabled={acting !== null} onClick={() => handleStatut(s)}>
                  {acting === s ? 'En cours…' : VEHICULE_STATUT_LABELS[s]}
                </Button>
              ))}
            </div>
          </div>

          {/* Déplacements liés */}
          {deplacements.length > 0 && (
            <div>
              <p className="text-xs font-semibold mb-2" style={{ color: 'var(--text-ter)' }}>Déplacements récents</p>
              <div className="space-y-1.5">
                {deplacements.map((d) => (
                  <div key={d.id} className="flex items-center gap-2 text-xs rounded-lg px-3 py-2" style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}>
                    <span className="font-mono" style={{ color: 'var(--text-ter)' }}>{d.numero}</span>
                    <span className="flex-1 truncate" style={{ color: 'var(--text-sec)' }}>{d.objet}</span>
                    <Badge tone={DEPLACEMENT_STATUT_TONE[d.statut]}>{DEPLACEMENT_STATUT_LABELS[d.statut]}</Badge>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Historique */}
          <div>
            <p className="text-xs font-semibold mb-2 flex items-center gap-1.5" style={{ color: 'var(--text-ter)' }}><Clock size={12} /> Historique</p>
            <div className="space-y-1.5 max-h-40 overflow-y-auto pr-1">
              {events.map((e) => (
                <div key={e.id} className="flex items-start gap-2 text-xs rounded-lg px-3 py-2" style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}>
                  <Badge tone={VEHICULE_STATUT_TONE[e.statut]} className="shrink-0">{VEHICULE_STATUT_LABELS[e.statut]}</Badge>
                  <div className="min-w-0 flex-1">
                    {e.commentaire && <p style={{ color: 'var(--text-sec)' }}>{e.commentaire}</p>}
                    <p style={{ color: 'var(--text-ter)' }}>{e.actionPar} · {formatDateTime(e.createdAt)}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {confirmDelete && (
        <Modal open onClose={() => setConfirmDelete(false)} title="Supprimer ce véhicule ?" width="sm">
          <p className="text-sm mb-4" style={{ color: 'var(--text-sec)' }}>
            « {vehicule?.immatriculation} » sera retiré du parc. Cette action est irréversible.
          </p>
          <div className="flex justify-end gap-2">
            <Button variant="secondary" onClick={() => setConfirmDelete(false)}>Annuler</Button>
            <Button variant="danger" onClick={handleDelete}>Supprimer</Button>
          </div>
        </Modal>
      )}
    </Modal>
  );
}

/* ── Page principale ─────────────────────────────────────────────────── */
export default function ParcAutoPage() {
  const { vehicules, stats, loading } = useParcAuto();
  const [statutTab, setStatutTab] = useState('');
  const [search, setSearch] = useState('');
  const [showCreate, setShowCreate] = useState(false);
  const [selectedId, setSelectedId] = useState<number | null>(null);

  const filtered = useMemo(() => {
    return vehicules.filter((v) => {
      if (statutTab && v.statut !== statutTab) return false;
      if (search.trim()) {
        const s = search.toLowerCase();
        if (!v.immatriculation.toLowerCase().includes(s) && !v.marque.toLowerCase().includes(s) && !v.modele.toLowerCase().includes(s)) return false;
      }
      return true;
    });
  }, [vehicules, statutTab, search]);

  return (
    <div>
      <PageHeader
        eyebrow="Service de la Logistique et des Moyens Généraux"
        title="Parc Automobile"
        description="Suivi de l'ensemble des véhicules de l'établissement : disponibilité, échéances, historique."
        action={
          <div className="flex items-center gap-2">
            <Button variant="secondary" onClick={() => exportVehiculesToExcel(filtered)}>
              <FileSpreadsheet size={14} /> Exporter Excel
            </Button>
            <Button variant="primary" onClick={() => setShowCreate(true)}><Plus size={14} /> Nouveau véhicule</Button>
          </div>
        }
      />

      <div className="grid grid-cols-2 md:grid-cols-5 gap-3 mb-6">
        <StatCard label="Véhicules" value={stats?.total ?? '—'} icon={<Car size={16} />} color="blue" />
        <StatCard label="Disponibles" value={stats?.disponibles ?? '—'} icon={<CheckCircle2 size={16} />} color="green" />
        <StatCard label="En mission" value={stats?.enMission ?? '—'} icon={<Gauge size={16} />} color="orange" />
        <StatCard label="En maintenance" value={stats?.enMaintenance ?? '—'} icon={<Wrench size={16} />} color={stats && stats.enMaintenance > 0 ? 'red' : 'violet'} />
        <StatCard label="Échéances < 30 j" value={stats?.echeancesProches ?? '—'} icon={<ShieldAlert size={16} />} color={stats && stats.echeancesProches > 0 ? 'red' : 'indigo'} />
      </div>

      <div className="flex flex-wrap items-center gap-2 mb-4">
        <div className="relative flex-1 min-w-48 max-w-72">
          <Search size={13} className="absolute left-3 top-1/2 -translate-y-1/2" style={{ color: 'var(--text-ter)' }} />
          <input
            value={search} onChange={(e) => setSearch(e.target.value)}
            placeholder="Immatriculation, marque, modèle…"
            className="w-full text-sm pl-9 pr-3 py-2 rounded-xl outline-none"
            style={{ background: 'var(--glass-bg)', border: '1px solid var(--border)', color: 'var(--text-pri)' }}
          />
        </div>
      </div>

      <div className="flex flex-wrap gap-1.5 mb-5">
        {STATUT_TABS.map((tab) => (
          <button
            key={tab.value}
            onClick={() => setStatutTab(tab.value)}
            className="text-xs px-3 py-1.5 rounded-full transition-colors"
            style={{
              background: statutTab === tab.value ? 'rgba(99,102,241,0.14)' : 'var(--glass-bg)',
              border: `1px solid ${statutTab === tab.value ? 'rgba(99,102,241,0.35)' : 'var(--border)'}`,
              color: statutTab === tab.value ? '#6366f1' : 'var(--text-sec)'
            }}
          >
            {tab.label}
          </button>
        ))}
      </div>

      {!loading && filtered.length === 0 ? (
        <EmptyState
          title="Aucun véhicule"
          description="Aucun véhicule ne correspond aux filtres sélectionnés."
          action={<Button variant="primary" onClick={() => setShowCreate(true)}><Plus size={14} /> Ajouter un véhicule</Button>}
        />
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-4">
          {filtered.map((v) => {
            const statutColor =
              v.statut === 'disponible' ? '#22C55E' :
              v.statut === 'en_mission' ? '#F59E0B' :
              v.statut === 'maintenance' ? '#6366F1' : '#EF4444';
            const vidange = vidangeEtat(v.kilometrage, v.kilometrageProchaineVidange);
            const jawaz = v.jawazNumero ? jawazEtat(v.jawazSolde, v.jawazSeuilAlerte) : null;
            const assuranceProche = v.assuranceExpiration ? joursAvant(v.assuranceExpiration) : null;
            const visiteProche = v.visiteTechniqueExpiration ? joursAvant(v.visiteTechniqueExpiration) : null;
            const chips: { label: string; tone: 'good' | 'warn' | 'bad' }[] = [];
            if (assuranceProche != null && assuranceProche <= 30) chips.push({ label: assuranceProche <= 0 ? 'Assurance expirée' : `Assurance ${assuranceProche} j`, tone: assuranceProche <= 0 ? 'bad' : 'warn' });
            if (visiteProche != null && visiteProche <= 30) chips.push({ label: visiteProche <= 0 ? 'Visite expirée' : `Visite ${visiteProche} j`, tone: visiteProche <= 0 ? 'bad' : 'warn' });
            if (vidange && vidange.tone !== 'good') chips.push({ label: `Vidange ${vidange.label}`, tone: vidange.tone });
            if (jawaz && jawaz.tone !== 'good') chips.push({ label: `Jawaz : ${jawaz.label}`, tone: jawaz.tone });

            return (
              <Card
                key={v.id}
                className="p-0 cursor-pointer overflow-hidden transition-transform hover:-translate-y-0.5"
                onClick={() => setSelectedId(v.id)}
                style={{ borderTop: `3px solid ${statutColor}` }}
              >
                {/* Photo ou vignette dégradée par défaut */}
                <div
                  className="h-32 flex items-center justify-center relative"
                  style={
                    v.photoUrl
                      ? { backgroundImage: `url(${v.photoUrl})`, backgroundSize: 'cover', backgroundPosition: 'center' }
                      : { background: `linear-gradient(135deg, ${statutColor}22 0%, ${statutColor}0D 100%)` }
                  }
                >
                  {!v.photoUrl && <Car size={36} style={{ color: statutColor, opacity: 0.55 }} />}
                  <span className="absolute top-2 right-2">
                    <Badge tone={VEHICULE_STATUT_TONE[v.statut]}>{VEHICULE_STATUT_LABELS[v.statut]}</Badge>
                  </span>
                </div>

                <div className="p-4">
                  <p className="text-sm font-bold font-mono" style={{ color: 'var(--text-pri)' }}>{v.immatriculation}</p>
                  <p className="text-xs mb-2" style={{ color: 'var(--text-sec)' }}>{v.marque} {v.modele}{v.annee ? ` · ${v.annee}` : ''}</p>

                  <div className="flex items-center gap-3 text-xs" style={{ color: 'var(--text-ter)' }}>
                    <span className="flex items-center gap-1"><Gauge size={11} /> {v.kilometrage.toLocaleString('fr-FR')} km</span>
                    <span className="flex items-center gap-1"><Fuel size={11} /> {CARBURANT_LABELS[v.carburant]}</span>
                  </div>

                  {chips.length > 0 && (
                    <div className="flex flex-wrap gap-1.5 mt-3 pt-3" style={{ borderTop: '1px solid var(--border)' }}>
                      {chips.map((c) => (
                        <Badge key={c.label} tone={c.tone}>{c.label}</Badge>
                      ))}
                    </div>
                  )}

                  {v.statut === 'en_mission' && v.missionActuelle && (
                    <p className="text-xs mt-3 pt-3 flex items-center gap-1.5" style={{ color: 'var(--accent-warn)', borderTop: chips.length > 0 ? undefined : '1px solid var(--border)' }}>
                      <MapPin size={11} className="shrink-0" />
                      {v.missionActuelle.destination || 'Destination non précisée'} · retour {v.missionActuelle.dateRetourPrevue || 'non précisé'}
                    </p>
                  )}
                </div>
              </Card>
            );
          })}
        </div>
      )}

      {showCreate && (
        <Modal open onClose={() => setShowCreate(false)} title="Nouveau véhicule" width="md">
          <VehiculeForm onClose={() => setShowCreate(false)} />
        </Modal>
      )}

      {selectedId != null && <VehiculeDetail id={selectedId} onClose={() => setSelectedId(null)} />}
    </div>
  );
}
