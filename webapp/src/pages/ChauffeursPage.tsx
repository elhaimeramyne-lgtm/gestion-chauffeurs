import { useEffect, useMemo, useRef, useState } from 'react';
import {
  Plus, Search, User as UserIcon, Phone, Mail, MapPin, Cake, CreditCard, Car, Building2,
  Pencil, Trash2, KeyRound, Check, Camera, FileText, Upload, ExternalLink
} from 'lucide-react';
import { PageHeader, Card, Badge, Button, Modal, EmptyState, StatCard } from '../components/ui/Kit';
import { useParcAuto } from '../context/ParcAutoContext';
import { useAuth } from '../context/AuthContext';
import { useOrg } from '../context/OrgContext';
import { api } from '../lib/api';
import {
  type Chauffeur, type ChauffeurCreateInput, PERMIS_CATEGORIES,
  CHAUFFEUR_STATUT_LABELS, CHAUFFEUR_STATUT_TONE
} from '../types/parcAuto';

const STATUT_TABS: { value: string; label: string }[] = [
  { value: '', label: 'Tous' },
  { value: 'disponible', label: 'Disponibles' },
  { value: 'en_mission', label: 'En mission' },
  { value: 'indisponible', label: 'Indisponibles' },
  { value: 'en_conge', label: 'En congé' },
  { value: 'absent', label: 'Absents' }
];

/** État d'une échéance (permis) à partir d'une date JJ/MM/AAAA. */
function echeanceEtat(dateStr: string | null): { label: string; tone: 'good' | 'warn' | 'bad' } | null {
  if (!dateStr) return null;
  const m = /^(\d{2})\/(\d{2})\/(\d{4})$/.exec(dateStr);
  if (!m) return null;
  const date = new Date(Number(m[3]), Number(m[2]) - 1, Number(m[1]));
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const jours = Math.round((date.getTime() - today.getTime()) / 86_400_000);
  if (jours < 0) return { label: `Expiré depuis ${Math.abs(jours)} j`, tone: 'bad' };
  if (jours <= 30) return { label: `Expire dans ${jours} j`, tone: 'warn' };
  return { label: `Valide jusqu'au ${dateStr}`, tone: 'good' };
}

/* ── Formulaire chauffeur (création ou modification) ─────────────────── */
function ChauffeurForm({ initial, onClose }: { initial?: Chauffeur | null; onClose: () => void }) {
  const { createChauffeur, updateChauffeur, vehicules } = useParcAuto();
  const { nodes: services } = useOrg();

  // Informations générales
  const [nom, setNom] = useState(initial?.nom ?? '');
  const [cin, setCin] = useState(initial?.cin ?? '');
  const [telephone, setTelephone] = useState(initial?.telephone ?? '');
  const [email, setEmail] = useState(initial?.email ?? '');
  const [adresse, setAdresse] = useState(initial?.adresse ?? '');
  const [dateNaissance, setDateNaissance] = useState('');
  // Permis
  const [permisCats, setPermisCats] = useState<string[]>(
    (initial?.permis ?? '').split(',').map((s) => s.trim()).filter(Boolean)
  );
  const [permisNumero, setPermisNumero] = useState(initial?.permisNumero ?? '');
  const [permisDateObtention, setPermisDateObtention] = useState('');
  const [permisDateExpiration, setPermisDateExpiration] = useState('');
  // Affectation
  const [serviceId, setServiceId] = useState(initial?.serviceId ? String(initial.serviceId) : '');
  const [responsable, setResponsable] = useState(initial?.responsable ?? '');
  const [vehiculeHabituelId, setVehiculeHabituelId] = useState(initial?.vehiculeHabituel ? String(initial.vehiculeHabituel.id) : '');
  // Jawaz personnel
  const [jawazNumero, setJawazNumero] = useState(initial?.jawazNumero ?? '');
  const [jawazSolde, setJawazSolde] = useState(initial?.jawazSolde != null ? String(initial.jawazSolde) : '');
  // Notes
  const [notes, setNotes] = useState(initial?.notes ?? '');
  const [remarques, setRemarques] = useState(initial?.remarques ?? '');

  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const toDMY = (iso: string) => { const [y, m, d] = iso.split('-'); return `${d}/${m}/${y}`; };
  const togglePermisCat = (cat: string) => {
    setPermisCats((prev) => (prev.includes(cat) ? prev.filter((c) => c !== cat) : [...prev, cat]));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!nom.trim()) return;
    setSaving(true);
    setError(null);
    try {
      const input: ChauffeurCreateInput = {
        nom: nom.trim(),
        cin: cin.trim() || undefined,
        telephone: telephone.trim() || undefined,
        email: email.trim() || undefined,
        adresse: adresse.trim() || undefined,
        dateNaissance: dateNaissance ? toDMY(dateNaissance) : undefined,
        permis: permisCats.length ? permisCats.join(', ') : undefined,
        permisNumero: permisNumero.trim() || undefined,
        permisDateObtention: permisDateObtention ? toDMY(permisDateObtention) : undefined,
        permisDateExpiration: permisDateExpiration ? toDMY(permisDateExpiration) : undefined,
        serviceId: serviceId ? Number(serviceId) : (initial ? null : undefined),
        responsable: responsable.trim() || undefined,
        vehiculeHabituelId: vehiculeHabituelId ? Number(vehiculeHabituelId) : (initial ? null : undefined),
        jawazNumero: jawazNumero.trim() || undefined,
        jawazSolde: jawazSolde.trim() ? Number(jawazSolde) : undefined,
        notes: notes.trim() || undefined,
        remarques: remarques.trim() || undefined
      };
      if (initial) await updateChauffeur(initial.id, input);
      else await createChauffeur(input);
      onClose();
    } catch {
      setError("Impossible d'enregistrer ce chauffeur.");
    } finally {
      setSaving(false);
    }
  };

  return (
    <form className="space-y-3 max-h-[70vh] overflow-y-auto pr-1" onSubmit={handleSubmit}>
      {/* Informations générales */}
      <p className="text-xs font-semibold flex items-center gap-1.5" style={{ color: 'var(--text-ter)' }}><UserIcon size={12} /> Informations générales</p>
      <label>
        <span>Nom complet *</span>
        <input required value={nom} onChange={(e) => setNom(e.target.value)} placeholder="Mohamed Alaoui" />
      </label>
      <div className="grid grid-cols-2 gap-3">
        <label>
          <span>CIN</span>
          <input value={cin} onChange={(e) => setCin(e.target.value)} placeholder="AB123456" />
        </label>
        <label>
          <span>Téléphone</span>
          <input value={telephone} onChange={(e) => setTelephone(e.target.value)} placeholder="06XX XX XX XX" />
        </label>
      </div>
      <div className="grid grid-cols-2 gap-3">
        <label>
          <span>Email</span>
          <input type="email" value={email} onChange={(e) => setEmail(e.target.value)} placeholder="nom@entraide.ma" />
        </label>
        <label>
          <span>Date de naissance {initial?.dateNaissance ? `(actuelle : ${initial.dateNaissance})` : ''}</span>
          <input type="date" value={dateNaissance} onChange={(e) => setDateNaissance(e.target.value)} />
        </label>
      </div>
      <label>
        <span>Adresse</span>
        <input value={adresse} onChange={(e) => setAdresse(e.target.value)} placeholder="Adresse complète" />
      </label>

      {/* Permis */}
      <div className="pt-2" style={{ borderTop: '1px solid var(--border)' }}>
        <p className="text-xs font-semibold mb-2 pt-2 flex items-center gap-1.5" style={{ color: 'var(--text-ter)' }}><CreditCard size={12} /> Permis de conduire</p>
        <div className="flex flex-wrap gap-1.5 mb-3">
          {PERMIS_CATEGORIES.map((cat) => (
            <button
              type="button"
              key={cat}
              onClick={() => togglePermisCat(cat)}
              className="text-xs px-3 py-1.5 rounded-full transition-colors font-mono"
              style={{
                background: permisCats.includes(cat) ? 'rgba(99,102,241,0.14)' : 'var(--glass-bg)',
                border: `1px solid ${permisCats.includes(cat) ? 'rgba(99,102,241,0.35)' : 'var(--border)'}`,
                color: permisCats.includes(cat) ? '#6366f1' : 'var(--text-sec)'
              }}
            >
              {cat}
            </button>
          ))}
        </div>
        <label>
          <span>Numéro du permis</span>
          <input value={permisNumero} onChange={(e) => setPermisNumero(e.target.value)} placeholder="12/A/345678" />
        </label>
        <div className="grid grid-cols-2 gap-3 mt-3">
          <label>
            <span>Date d'obtention {initial?.permisDateObtention ? `(actuelle : ${initial.permisDateObtention})` : ''}</span>
            <input type="date" value={permisDateObtention} onChange={(e) => setPermisDateObtention(e.target.value)} />
          </label>
          <label>
            <span>Date d'expiration {initial?.permisDateExpiration ? `(actuelle : ${initial.permisDateExpiration})` : ''}</span>
            <input type="date" value={permisDateExpiration} onChange={(e) => setPermisDateExpiration(e.target.value)} />
          </label>
        </div>
      </div>

      {/* Affectation */}
      <div className="pt-2" style={{ borderTop: '1px solid var(--border)' }}>
        <p className="text-xs font-semibold mb-2 pt-2 flex items-center gap-1.5" style={{ color: 'var(--text-ter)' }}><Car size={12} /> Affectation</p>
        <div className="grid grid-cols-2 gap-3">
          <label>
            <span>Véhicule habituel</span>
            <select value={vehiculeHabituelId} onChange={(e) => setVehiculeHabituelId(e.target.value)}>
              <option value="">— Aucun —</option>
              {vehicules.map((v) => (
                <option key={v.id} value={v.id}>{v.immatriculation} — {v.marque} {v.modele}</option>
              ))}
            </select>
          </label>
          <label>
            <span>Service</span>
            <select value={serviceId} onChange={(e) => setServiceId(e.target.value)}>
              <option value="">— Non renseigné —</option>
              {services.map((s) => (
                <option key={s.id} value={s.id}>{s.name}</option>
              ))}
            </select>
          </label>
        </div>
        <label className="block mt-3">
          <span>Responsable</span>
          <input value={responsable} onChange={(e) => setResponsable(e.target.value)} placeholder="Nom du responsable hiérarchique" />
        </label>
      </div>

      {/* Jawaz personnel */}
      <div className="pt-2" style={{ borderTop: '1px solid var(--border)' }}>
        <p className="text-xs font-semibold mb-2 pt-2 flex items-center gap-1.5" style={{ color: 'var(--text-ter)' }}><CreditCard size={12} /> Jawaz personnel (si attribué)</p>
        <div className="grid grid-cols-2 gap-3">
          <label>
            <span>Numéro Jawaz</span>
            <input value={jawazNumero} onChange={(e) => setJawazNumero(e.target.value)} placeholder="JW-000000" />
          </label>
          <label>
            <span>Solde Jawaz (DH)</span>
            <input type="number" min={0} step="0.01" value={jawazSolde} onChange={(e) => setJawazSolde(e.target.value)} placeholder="0" />
          </label>
        </div>
      </div>

      {/* Notes */}
      <div className="pt-2" style={{ borderTop: '1px solid var(--border)' }}>
        <p className="text-xs font-semibold mb-2 pt-2" style={{ color: 'var(--text-ter)' }}>Notes</p>
        <label>
          <span>Observations</span>
          <textarea rows={2} value={notes} onChange={(e) => setNotes(e.target.value)} placeholder="Observations générales…" />
        </label>
        <label className="block mt-3">
          <span>Remarques</span>
          <textarea rows={2} value={remarques} onChange={(e) => setRemarques(e.target.value)} placeholder="Remarques complémentaires…" />
        </label>
      </div>

      {error && (
        <p className="text-xs rounded-lg px-3 py-2" style={{ color: 'var(--accent-err)', background: 'rgba(239,68,68,0.08)', border: '1px solid rgba(239,68,68,0.2)' }}>{error}</p>
      )}
      <div className="flex justify-end gap-2 pt-2 sticky bottom-0" style={{ background: 'var(--surface, transparent)' }}>
        <Button variant="secondary" type="button" onClick={onClose}>Annuler</Button>
        <Button variant="primary" type="submit" disabled={saving}>
          <Plus size={13} /> {saving ? 'Enregistrement…' : initial ? 'Enregistrer' : 'Ajouter le chauffeur'}
        </Button>
      </div>
    </form>
  );
}

/** Créer (ou réinitialiser) l'accès au portail chauffeur — identifiant et
 *  mot de passe que le chauffeur utilisera pour se connecter et suivre ses
 *  missions (accepter, en route, arrivé). */
function CompteForm({ chauffeur, onClose }: { chauffeur: Chauffeur; onClose: () => void }) {
  const [username, setUsername] = useState(chauffeur.nom.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/[^a-z0-9]+/g, '.').replace(/^\.|\.$/g, ''));
  const [password, setPassword] = useState('');
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!password || password.length < 6) {
      setError('Le mot de passe doit contenir au moins 6 caractères.');
      return;
    }
    setSaving(true);
    setError(null);
    try {
      await api.post(`/chauffeurs/${chauffeur.id}/compte`, { username, password });
      setSuccess(true);
    } catch {
      setError("Impossible de créer cet accès (identifiant peut-être déjà utilisé).");
    } finally {
      setSaving(false);
    }
  };

  if (success) {
    return (
      <div className="text-center py-4">
        <div className="w-12 h-12 rounded-full mx-auto mb-3 flex items-center justify-center" style={{ background: 'rgba(34,197,94,0.15)' }}>
          <Check size={22} style={{ color: 'var(--accent2)' }} />
        </div>
        <p className="text-sm mb-1" style={{ color: 'var(--text-pri)' }}>Accès créé pour {chauffeur.nom}</p>
        <p className="text-xs mb-4" style={{ color: 'var(--text-ter)' }}>
          Identifiant : <strong>{username}</strong> — communiquez ce mot de passe au chauffeur de façon sécurisée.
        </p>
        <Button variant="primary" onClick={onClose}>Fermer</Button>
      </div>
    );
  }

  return (
    <form className="space-y-3" onSubmit={handleSubmit}>
      <p className="text-xs" style={{ color: 'var(--text-ter)' }}>
        {chauffeur.userId
          ? "Ce chauffeur a déjà un accès — définir un nouveau mot de passe ci-dessous le réinitialisera."
          : "Crée un compte de connexion pour que ce chauffeur puisse suivre ses missions depuis son portail (accepter, en route, arrivé)."}
      </p>
      <label>
        <span>Identifiant</span>
        <input required disabled={Boolean(chauffeur.userId)} value={username} onChange={(e) => setUsername(e.target.value)} className={chauffeur.userId ? 'opacity-60' : ''} />
      </label>
      <label>
        <span>Mot de passe {chauffeur.userId ? '(nouveau)' : ''}</span>
        <input required type="text" minLength={6} value={password} onChange={(e) => setPassword(e.target.value)} placeholder="Au moins 6 caractères" />
      </label>
      {error && (
        <p className="text-xs rounded-lg px-3 py-2" style={{ color: 'var(--accent-err)', background: 'rgba(239,68,68,0.08)', border: '1px solid rgba(239,68,68,0.2)' }}>{error}</p>
      )}
      <div className="flex justify-end gap-2 pt-2">
        <Button variant="secondary" type="button" onClick={onClose}>Annuler</Button>
        <Button variant="primary" type="submit" disabled={saving}>
          <KeyRound size={13} /> {saving ? 'Enregistrement…' : chauffeur.userId ? 'Réinitialiser le mot de passe' : "Créer l'accès"}
        </Button>
      </div>
    </form>
  );
}

/* ── Panneau détail chauffeur (fiche complète) ────────────────────────── */
function ChauffeurDetail({ id, onClose }: { id: number; onClose: () => void }) {
  const { fetchChauffeurDetail, setChauffeurStatut, deleteChauffeur, uploadChauffeurPhoto, uploadChauffeurDocument } = useParcAuto();
  const { nodes: services } = useOrg();
  const { isAdmin } = useAuth();
  const [chauffeur, setChauffeur] = useState<Chauffeur | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [editing, setEditing] = useState(false);
  const [confirmDelete, setConfirmDelete] = useState(false);
  const [compteOpen, setCompteOpen] = useState(false);
  const [uploading, setUploading] = useState<string | null>(null);

  const photoInputRef = useRef<HTMLInputElement>(null);
  const cinInputRef = useRef<HTMLInputElement>(null);
  const permisInputRef = useRef<HTMLInputElement>(null);
  const medicalInputRef = useRef<HTMLInputElement>(null);

  const load = () => {
    setLoading(true);
    fetchChauffeurDetail(id)
      .then(setChauffeur)
      .catch(() => setError('Impossible de charger ce chauffeur.'))
      .finally(() => setLoading(false));
  };
  useEffect(() => { load(); /* eslint-disable-next-line react-hooks/exhaustive-deps */ }, [id]);

  const handlePhotoFile = async (file: File) => {
    setUploading('photo');
    try { await uploadChauffeurPhoto(id, file); load(); } catch { setError("Échec de l'envoi de la photo."); } finally { setUploading(null); }
  };
  const handleDocFile = async (type: 'cin' | 'permis' | 'medical', file: File) => {
    setUploading(type);
    try { await uploadChauffeurDocument(id, type, file); load(); } catch { setError("Échec de l'envoi du document."); } finally { setUploading(null); }
  };

  const handleDelete = async () => {
    try { await deleteChauffeur(id); onClose(); } catch { setError('Impossible de supprimer ce chauffeur.'); setConfirmDelete(false); }
  };

  const serviceName = chauffeur?.serviceId ? services.find((s) => s.id === chauffeur.serviceId)?.name ?? null : null;
  const permisEtat = chauffeur ? echeanceEtat(chauffeur.permisDateExpiration) : null;

  if (editing && chauffeur) {
    return (
      <Modal open onClose={() => setEditing(false)} title={`Modifier ${chauffeur.nom}`} width="lg">
        <ChauffeurForm initial={chauffeur} onClose={() => { setEditing(false); load(); }} />
      </Modal>
    );
  }

  return (
    <Modal open onClose={onClose} title={chauffeur?.nom ?? 'Chauffeur'} width="lg">
      {loading || !chauffeur ? (
        <p className="text-sm py-8 text-center" style={{ color: 'var(--text-ter)' }}>Chargement…</p>
      ) : (
        <div className="space-y-5">
          <div className="flex items-start justify-between">
            <div className="flex items-center gap-3">
              <div className="relative">
                {chauffeur.photoUrl ? (
                  <img src={chauffeur.photoUrl} alt="" className="w-16 h-16 rounded-full object-cover" />
                ) : (
                  <div className="w-16 h-16 rounded-full flex items-center justify-center" style={{ background: 'rgba(99,102,241,0.14)' }}>
                    <UserIcon size={26} style={{ color: '#6366f1' }} />
                  </div>
                )}
                <button
                  title="Changer la photo"
                  onClick={() => photoInputRef.current?.click()}
                  className="absolute -bottom-1 -right-1 w-6 h-6 rounded-full flex items-center justify-center focus-ring"
                  style={{ background: 'var(--accent)', color: '#fff' }}
                >
                  {uploading === 'photo' ? <span className="text-[9px]">…</span> : <Camera size={12} />}
                </button>
                <input ref={photoInputRef} type="file" accept="image/*" hidden onChange={(e) => e.target.files?.[0] && handlePhotoFile(e.target.files[0])} />
              </div>
              <div>
                <Badge tone={CHAUFFEUR_STATUT_TONE[chauffeur.statut]}>{CHAUFFEUR_STATUT_LABELS[chauffeur.statut]}</Badge>
                {chauffeur.userId && (
                  <span className="ml-2 text-xs inline-flex items-center gap-1" style={{ color: 'var(--accent2)' }}><Check size={11} /> Portail activé</span>
                )}
              </div>
            </div>
            <div className="flex items-center gap-1">
              {isAdmin && (
                <button title={chauffeur.userId ? 'Réinitialiser le mot de passe' : 'Créer un accès portail'} className="tbl-btn focus-ring" onClick={() => setCompteOpen(true)}>
                  <KeyRound size={14} />
                </button>
              )}
              <button title="Modifier" className="tbl-btn focus-ring" onClick={() => setEditing(true)}>
                <Pencil size={14} />
              </button>
              <button title="Supprimer" className="tbl-btn danger focus-ring" onClick={() => setConfirmDelete(true)}>
                <Trash2 size={14} />
              </button>
            </div>
          </div>

          {error && (
            <p className="text-xs rounded-lg px-3 py-2" style={{ color: 'var(--accent-err)', background: 'rgba(239,68,68,0.08)', border: '1px solid rgba(239,68,68,0.2)' }}>{error}</p>
          )}

          {/* Informations générales */}
          <div>
            <p className="text-xs font-semibold mb-2 flex items-center gap-1.5" style={{ color: 'var(--text-ter)' }}><UserIcon size={12} /> Informations générales</p>
            <div className="grid grid-cols-2 gap-3 text-sm">
              {chauffeur.cin && <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>CIN</p><p style={{ color: 'var(--text-pri)' }}>{chauffeur.cin}</p></div>}
              {chauffeur.telephone && <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}><Phone size={10} className="inline mr-1" />Téléphone</p><p style={{ color: 'var(--text-pri)' }}>{chauffeur.telephone}</p></div>}
              {chauffeur.email && <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}><Mail size={10} className="inline mr-1" />Email</p><p style={{ color: 'var(--text-pri)' }}>{chauffeur.email}</p></div>}
              {chauffeur.dateNaissance && <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}><Cake size={10} className="inline mr-1" />Naissance</p><p style={{ color: 'var(--text-pri)' }}>{chauffeur.dateNaissance}</p></div>}
              {chauffeur.adresse && <div className="col-span-2"><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}><MapPin size={10} className="inline mr-1" />Adresse</p><p style={{ color: 'var(--text-pri)' }}>{chauffeur.adresse}</p></div>}
            </div>
          </div>

          {/* Permis */}
          <div className="pt-3" style={{ borderTop: '1px solid var(--border)' }}>
            <p className="text-xs font-semibold mb-2 flex items-center gap-1.5" style={{ color: 'var(--text-ter)' }}><CreditCard size={12} /> Permis de conduire</p>
            {chauffeur.permis && (
              <div className="flex flex-wrap gap-1.5 mb-2">
                {chauffeur.permis.split(',').map((c) => c.trim()).filter(Boolean).map((cat) => (
                  <Badge key={cat} tone="info">{cat}</Badge>
                ))}
              </div>
            )}
            <div className="grid grid-cols-2 gap-3 text-sm">
              {chauffeur.permisNumero && <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Numéro</p><p className="font-mono" style={{ color: 'var(--text-pri)' }}>{chauffeur.permisNumero}</p></div>}
              {chauffeur.permisDateObtention && <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Obtenu le</p><p style={{ color: 'var(--text-pri)' }}>{chauffeur.permisDateObtention}</p></div>}
            </div>
            {permisEtat && <div className="mt-2"><Badge tone={permisEtat.tone}>{permisEtat.label}</Badge></div>}
          </div>

          {/* Affectation */}
          {(chauffeur.vehiculeHabituel || serviceName || chauffeur.responsable) && (
            <div className="pt-3" style={{ borderTop: '1px solid var(--border)' }}>
              <p className="text-xs font-semibold mb-2 flex items-center gap-1.5" style={{ color: 'var(--text-ter)' }}><Car size={12} /> Affectation</p>
              <div className="grid grid-cols-2 gap-3 text-sm">
                {chauffeur.vehiculeHabituel && (
                  <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Véhicule habituel</p><p className="font-mono" style={{ color: 'var(--text-pri)' }}>{chauffeur.vehiculeHabituel.immatriculation} — {chauffeur.vehiculeHabituel.marque} {chauffeur.vehiculeHabituel.modele}</p></div>
                )}
                {serviceName && <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}><Building2 size={10} className="inline mr-1" />Service</p><p style={{ color: 'var(--text-pri)' }}>{serviceName}</p></div>}
                {chauffeur.responsable && <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Responsable</p><p style={{ color: 'var(--text-pri)' }}>{chauffeur.responsable}</p></div>}
              </div>
            </div>
          )}

          {/* Jawaz personnel */}
          {chauffeur.jawazNumero && (
            <div className="pt-3" style={{ borderTop: '1px solid var(--border)' }}>
              <p className="text-xs font-semibold mb-2 flex items-center gap-1.5" style={{ color: 'var(--text-ter)' }}><CreditCard size={12} /> Jawaz personnel</p>
              <div className="grid grid-cols-2 gap-3 text-sm">
                <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Numéro</p><p className="font-mono" style={{ color: 'var(--text-pri)' }}>{chauffeur.jawazNumero}</p></div>
                <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Solde</p><p style={{ color: 'var(--text-pri)' }}>{chauffeur.jawazSolde.toLocaleString('fr-FR')} DH</p></div>
              </div>
            </div>
          )}

          {/* Documents */}
          <div className="pt-3" style={{ borderTop: '1px solid var(--border)' }}>
            <p className="text-xs font-semibold mb-2 flex items-center gap-1.5" style={{ color: 'var(--text-ter)' }}><FileText size={12} /> Documents</p>
            <div className="space-y-1.5">
              {([
                { key: 'cin' as const, label: 'Scan CIN', url: chauffeur.scanCinUrl, ref: cinInputRef },
                { key: 'permis' as const, label: 'Scan permis', url: chauffeur.scanPermisUrl, ref: permisInputRef },
                { key: 'medical' as const, label: 'Certificat médical', url: chauffeur.certificatMedicalUrl, ref: medicalInputRef }
              ]).map((doc) => (
                <div key={doc.key} className="flex items-center justify-between text-xs rounded-lg px-3 py-2" style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}>
                  <span style={{ color: 'var(--text-sec)' }}>{doc.label}</span>
                  <div className="flex items-center gap-2">
                    {doc.url && (
                      <a href={doc.url} target="_blank" rel="noreferrer" className="flex items-center gap-1 focus-ring" style={{ color: '#6366f1' }}>
                        <ExternalLink size={12} /> Voir
                      </a>
                    )}
                    <button type="button" className="flex items-center gap-1 focus-ring" style={{ color: 'var(--text-ter)' }} onClick={() => doc.ref.current?.click()}>
                      <Upload size={12} /> {uploading === doc.key ? '…' : doc.url ? 'Remplacer' : 'Ajouter'}
                    </button>
                    <input ref={doc.ref} type="file" accept="image/*,application/pdf" hidden onChange={(e) => e.target.files?.[0] && handleDocFile(doc.key, e.target.files[0])} />
                  </div>
                </div>
              ))}
            </div>
          </div>

          {(chauffeur.notes || chauffeur.remarques) && (
            <div className="pt-3 space-y-2" style={{ borderTop: '1px solid var(--border)' }}>
              {chauffeur.notes && <p className="text-sm" style={{ color: 'var(--text-sec)' }}><span className="text-[11px] uppercase tracking-wide block" style={{ color: 'var(--text-ter)' }}>Observations</span>{chauffeur.notes}</p>}
              {chauffeur.remarques && <p className="text-sm" style={{ color: 'var(--text-sec)' }}><span className="text-[11px] uppercase tracking-wide block" style={{ color: 'var(--text-ter)' }}>Remarques</span>{chauffeur.remarques}</p>}
            </div>
          )}

          {/* Changer statut */}
          <div className="pt-3" style={{ borderTop: '1px solid var(--border)' }}>
            <p className="text-xs font-semibold mb-2" style={{ color: 'var(--text-ter)' }}>Changer le statut</p>
            <div className="flex flex-wrap gap-2">
              {(['disponible', 'en_mission', 'indisponible', 'en_conge', 'absent'] as const).filter((s) => s !== chauffeur.statut).map((s) => (
                <Button key={s} variant="secondary" onClick={async () => { await setChauffeurStatut(id, s); load(); }}>
                  {CHAUFFEUR_STATUT_LABELS[s]}
                </Button>
              ))}
            </div>
          </div>
        </div>
      )}

      {compteOpen && chauffeur && (
        <Modal open onClose={() => setCompteOpen(false)} title={chauffeur.userId ? 'Réinitialiser le mot de passe' : 'Créer un accès portail'} width="sm">
          <CompteForm chauffeur={chauffeur} onClose={() => { setCompteOpen(false); load(); }} />
        </Modal>
      )}

      {confirmDelete && (
        <Modal open onClose={() => setConfirmDelete(false)} title="Supprimer ce chauffeur ?" width="sm">
          <p className="text-sm mb-4" style={{ color: 'var(--text-sec)' }}>
            « {chauffeur?.nom} » sera retiré du répertoire. Cette action est irréversible.
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

export default function ChauffeursPage() {
  const { chauffeurs, loading } = useParcAuto();
  const { isAdmin } = useAuth();
  const [statutTab, setStatutTab] = useState('');
  const [search, setSearch] = useState('');
  const [showForm, setShowForm] = useState(false);
  const [selectedId, setSelectedId] = useState<number | null>(null);

  const filtered = useMemo(() => {
    return chauffeurs.filter((c) => {
      if (statutTab && c.statut !== statutTab) return false;
      if (search.trim()) {
        const s = search.toLowerCase();
        if (!c.nom.toLowerCase().includes(s) && !(c.telephone ?? '').toLowerCase().includes(s) && !(c.cin ?? '').toLowerCase().includes(s)) return false;
      }
      return true;
    });
  }, [chauffeurs, statutTab, search]);

  return (
    <div>
      <PageHeader
        eyebrow="Service de la Logistique et des Moyens Généraux"
        title="Chauffeurs"
        description="Répertoire des chauffeurs, géré indépendamment des comptes de la plateforme."
        action={<Button variant="primary" onClick={() => setShowForm(true)}><Plus size={14} /> Nouveau chauffeur</Button>}
      />

      <div className="grid grid-cols-2 md:grid-cols-4 gap-3 mb-6">
        <StatCard label="Chauffeurs" value={chauffeurs.length} icon={<UserIcon size={16} />} color="blue" />
        <StatCard label="Disponibles" value={chauffeurs.filter((c) => c.statut === 'disponible').length} icon={<Check size={16} />} color="green" />
        <StatCard label="En mission" value={chauffeurs.filter((c) => c.statut === 'en_mission').length} icon={<Car size={16} />} color="orange" />
        <StatCard
          label="Permis < 30 j"
          value={chauffeurs.filter((c) => c.permisDateExpiration && Math.round((new Date(c.permisDateExpiration).getTime() - Date.now()) / 86_400_000) <= 30).length}
          icon={<CreditCard size={16} />}
          color={chauffeurs.some((c) => c.permisDateExpiration && Math.round((new Date(c.permisDateExpiration).getTime() - Date.now()) / 86_400_000) <= 30) ? 'red' : 'violet'}
        />
      </div>

      <div className="flex flex-wrap items-center gap-2 mb-4">
        <div className="relative flex-1 min-w-48 max-w-72">
          <Search size={13} className="absolute left-3 top-1/2 -translate-y-1/2" style={{ color: 'var(--text-ter)' }} />
          <input
            value={search} onChange={(e) => setSearch(e.target.value)}
            placeholder="Nom, téléphone, CIN…"
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
          title="Aucun chauffeur"
          description="Ajoutez vos chauffeurs manuellement — ils apparaîtront ensuite dans toutes les listes de sélection des déplacements."
          action={<Button variant="primary" onClick={() => setShowForm(true)}><Plus size={14} /> Ajouter un chauffeur</Button>}
        />
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-4">
          {filtered.map((c) => {
            const statutColor =
              c.statut === 'disponible' ? '#22C55E' :
              c.statut === 'en_mission' ? '#F59E0B' :
              c.statut === 'en_conge' ? '#6366F1' :
              c.statut === 'absent' ? '#94A3B8' : '#EF4444';
            const permisJours = c.permisDateExpiration ? Math.round((new Date(c.permisDateExpiration).getTime() - Date.now()) / 86_400_000) : null;
            const permisAlerte = permisJours != null && permisJours <= 30;
            return (
              <Card key={c.id} className="p-4 cursor-pointer transition-transform hover:-translate-y-0.5" onClick={() => setSelectedId(c.id)}>
                <div className="flex items-start gap-3 mb-2.5">
                  <div className="relative shrink-0">
                    {c.photoUrl ? (
                      <img src={c.photoUrl} alt="" className="w-12 h-12 rounded-full object-cover" style={{ boxShadow: `0 0 0 2px var(--card), 0 0 0 4px ${statutColor}` }} />
                    ) : (
                      <div
                        className="w-12 h-12 rounded-full flex items-center justify-center"
                        style={{ background: `linear-gradient(135deg, ${statutColor}33 0%, ${statutColor}18 100%)`, boxShadow: `0 0 0 2px var(--card), 0 0 0 4px ${statutColor}` }}
                      >
                        <UserIcon size={18} style={{ color: statutColor }} />
                      </div>
                    )}
                  </div>
                  <div className="min-w-0 flex-1">
                    <p className="text-sm font-semibold truncate" style={{ color: 'var(--text-pri)' }}>{c.nom}</p>
                    {c.telephone && (
                      <p className="text-xs flex items-center gap-1" style={{ color: 'var(--text-ter)' }}>
                        <Phone size={11} /> {c.telephone}
                      </p>
                    )}
                  </div>
                  <Badge tone={CHAUFFEUR_STATUT_TONE[c.statut]}>{CHAUFFEUR_STATUT_LABELS[c.statut]}</Badge>
                </div>
                <div className="flex flex-wrap items-center gap-1.5">
                  {c.permis && <Badge tone="default"><CreditCard size={10} className="inline mr-1" />{c.permis}</Badge>}
                  {c.vehiculeHabituel && <Badge tone="info"><Car size={10} className="inline mr-1" />{c.vehiculeHabituel.immatriculation}</Badge>}
                  {c.jawazNumero && <Badge>Jawaz {c.jawazSolde.toLocaleString('fr-FR')} DH</Badge>}
                  {permisAlerte && (
                    <Badge tone={permisJours! <= 0 ? 'bad' : 'warn'}>
                      Permis {permisJours! <= 0 ? 'expiré' : `${permisJours} j`}
                    </Badge>
                  )}
                </div>
                {isAdmin && (
                  <p className="text-xs mt-2.5 pt-2.5" style={{ borderTop: '1px solid var(--border)' }}>
                    {c.userId ? (
                      <span className="flex items-center gap-1" style={{ color: 'var(--accent2)' }}><Check size={11} /> Portail activé</span>
                    ) : (
                      <span style={{ color: 'var(--text-ter)' }}>Pas encore d'accès portail</span>
                    )}
                  </p>
                )}
              </Card>
            );
          })}
        </div>
      )}

      {showForm && (
        <Modal open onClose={() => setShowForm(false)} title="Nouveau chauffeur" width="lg">
          <ChauffeurForm onClose={() => setShowForm(false)} />
        </Modal>
      )}

      {selectedId != null && <ChauffeurDetail id={selectedId} onClose={() => setSelectedId(null)} />}
    </div>
  );
}
