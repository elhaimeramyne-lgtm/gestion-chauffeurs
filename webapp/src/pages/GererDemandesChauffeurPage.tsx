/**
 * GererDemandesChauffeurPage — vue « responsable » du module Logistique.
 *
 * Permet de traiter les demandes de chauffeur soumises par les services :
 *   en_attente  → assigner un chauffeur (assignee)
 *   assignee    → valider (choisir un véhicule) → crée automatiquement
 *                 l'ordre de mission (validee)
 *   en_attente / assignee → refuser (refusee)
 *
 * Workflow et endpoints définis dans server/src/routes/demandeChauffeur.ts
 */
import { useEffect, useMemo, useState } from 'react';
import { useSearchParams } from 'react-router-dom';
import {
  Search, RefreshCw, Phone, UserCheck, XCircle, Car, ClipboardList
} from 'lucide-react';
import { PageHeader, Card, Badge, Button, Modal, EmptyState } from '../components/ui/Kit';
import { useOrg } from '../context/OrgContext';
import { useParcAuto } from '../context/ParcAutoContext';
import { api } from '../lib/api';
import type { Chauffeur } from '../types/parcAuto';

/* ── Types locaux (miroir du schéma serveur demandeChauffeur) ─────────── */
type DemandePriorite = 'normale' | 'urgente' | 'critique';
type DemandeStatut = 'en_attente' | 'assignee' | 'confirmee' | 'validee' | 'refusee' | 'terminee';

interface DemandeChauffeur {
  id: number;
  numero: string;
  serviceDemandeurId: number;
  demandeurNom: string;
  demandeurTelephone: string | null;
  priorite: DemandePriorite;
  chauffeurId: number | null;
  statut: DemandeStatut;
  missionId: number | null;
  observations: string | null;
  motifRefus: string | null;
  createdBy: string;
  assignePar: string | null;
  validePar: string | null;
  createdAt: string;
  updatedAt: string;
  chauffeur?: Chauffeur | null;
}

const STATUT_LABELS: Record<DemandeStatut, string> = {
  en_attente: 'En attente',
  assignee: 'Chauffeur assigné',
  confirmee: 'Accepté par le chauffeur',
  validee: 'Validée',
  refusee: 'Refusée',
  terminee: 'Terminée'
};

const STATUT_TONE: Record<DemandeStatut, 'default' | 'good' | 'bad' | 'warn' | 'info'> = {
  en_attente: 'warn',
  assignee: 'info',
  confirmee: 'good',
  validee: 'good',
  refusee: 'bad',
  terminee: 'default'
};

const PRIORITE_LABELS: Record<DemandePriorite, string> = {
  normale: 'Normale',
  urgente: 'Urgente',
  critique: 'Critique'
};

const PRIORITE_TONE: Record<DemandePriorite, 'default' | 'good' | 'bad' | 'warn' | 'info'> = {
  normale: 'default',
  urgente: 'warn',
  critique: 'bad'
};

const STATUT_TABS: { value: string; label: string }[] = [
  { value: '', label: 'Toutes' },
  { value: 'en_attente', label: STATUT_LABELS.en_attente },
  { value: 'assignee', label: STATUT_LABELS.assignee },
  { value: 'confirmee', label: STATUT_LABELS.confirmee },
  { value: 'validee', label: STATUT_LABELS.validee },
  { value: 'refusee', label: STATUT_LABELS.refusee },
  { value: 'terminee', label: STATUT_LABELS.terminee }
];

function isoToDMY(iso: string): string {
  const [y, m, d] = iso.split('-');
  return `${d}/${m}/${y}`;
}

/* ── Panneau de traitement d'une demande ───────────────────────────────── */
function TraiterPanel({ id, onClose, onDone }: { id: number; onClose: () => void; onDone: () => void }) {
  const { nodes } = useOrg();
  const { vehicules } = useParcAuto();
  const [demande, setDemande] = useState<DemandeChauffeur | null>(null);
  const [chauffeursDispo, setChauffeursDispo] = useState<Chauffeur[]>([]);
  const [loading, setLoading] = useState(true);
  const [acting, setActing] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // Formulaire assignation
  const [chauffeurId, setChauffeurId] = useState<number | ''>('');

  // Formulaire validation
  const [vehiculeId, setVehiculeId] = useState<number | ''>('');
  const [objet, setObjet] = useState('');
  const [destination, setDestination] = useState('');
  const [dateDepart, setDateDepart] = useState('');
  const [dateRetourPrevue, setDateRetourPrevue] = useState('');
  const [heureDepartPrevue, setHeureDepartPrevue] = useState('');
  const [validationObs, setValidationObs] = useState('');

  // Formulaire refus
  const [motifRefus, setMotifRefus] = useState('');
  const [showRefus, setShowRefus] = useState(false);

  const load = () => {
    setLoading(true);
    setError(null);
    Promise.all([
      api.get<{ demande: DemandeChauffeur }>(`/demande-chauffeur/${id}`),
      api.get<{ chauffeurs: Chauffeur[] }>('/demande-chauffeur/chauffeurs-disponibles')
    ])
      .then(([demandeRes, chauffeursRes]) => {
        setDemande(demandeRes.demande);
        setChauffeursDispo(chauffeursRes.chauffeurs);
      })
      .catch(() => setError('Impossible de charger cette demande.'))
      .finally(() => setLoading(false));
  };

  useEffect(() => { load(); /* eslint-disable-next-line react-hooks/exhaustive-deps */ }, [id]);

  const serviceName = demande ? (nodes.find((n) => n.id === demande.serviceDemandeurId)?.name ?? '—') : '—';
  const vehiculesDisponibles = useMemo(() => vehicules.filter((v) => v.statut === 'disponible'), [vehicules]);

  const handleAssigner = async () => {
    if (!chauffeurId) { setError('Merci de sélectionner un chauffeur.'); return; }
    setActing(true);
    setError(null);
    try {
      await api.patch(`/demande-chauffeur/${id}/assigner`, { chauffeurId: Number(chauffeurId) });
      onDone();
      load();
    } catch (err: any) {
      setError(err?.message ?? "Impossible d'assigner ce chauffeur.");
    } finally {
      setActing(false);
    }
  };

  const handleValider = async () => {
    if (!vehiculeId || !dateDepart) { setError('Véhicule et date de départ requis.'); return; }
    setActing(true);
    setError(null);
    try {
      await api.post(`/demande-chauffeur/${id}/valider`, {
        vehiculeId: Number(vehiculeId),
        objet: objet.trim() || undefined,
        destination: destination.trim() || undefined,
        dateDepart: isoToDMY(dateDepart),
        dateRetourPrevue: dateRetourPrevue ? isoToDMY(dateRetourPrevue) : undefined,
        heureDepartPrevue: heureDepartPrevue || undefined,
        observations: validationObs.trim() || undefined
      });
      onDone();
      onClose();
    } catch (err: any) {
      setError(err?.message ?? 'Impossible de valider cette demande.');
    } finally {
      setActing(false);
    }
  };

  const handleRefuser = async () => {
    setActing(true);
    setError(null);
    try {
      await api.patch(`/demande-chauffeur/${id}/refuser`, { motifRefus: motifRefus.trim() || undefined });
      onDone();
      onClose();
    } catch (err: any) {
      setError(err?.message ?? 'Impossible de refuser cette demande.');
    } finally {
      setActing(false);
    }
  };

  return (
    <Modal open onClose={onClose} title={demande ? `Demande ${demande.numero}` : 'Demande'} width="md">
      <div className="modal-body space-y-4">
        {loading || !demande ? (
          <p className="text-sm" style={{ color: 'var(--text-sec)' }}>Chargement…</p>
        ) : (
          <>
            <div className="flex flex-wrap items-center gap-2">
              <Badge tone={STATUT_TONE[demande.statut]}>{STATUT_LABELS[demande.statut]}</Badge>
              <Badge tone={PRIORITE_TONE[demande.priorite]}>{PRIORITE_LABELS[demande.priorite]}</Badge>
            </div>

            <div className="grid grid-cols-2 gap-3 text-sm">
              <div>
                <p style={{ color: 'var(--text-ter)' }}>Service demandeur</p>
                <p style={{ color: 'var(--text-pri)' }}>{serviceName}</p>
              </div>
              <div>
                <p style={{ color: 'var(--text-ter)' }}>Demandeur</p>
                <p style={{ color: 'var(--text-pri)' }}>{demande.demandeurNom}</p>
              </div>
              {demande.demandeurTelephone && (
                <div>
                  <p style={{ color: 'var(--text-ter)' }}>Téléphone</p>
                  <p className="flex items-center gap-1" style={{ color: 'var(--text-pri)' }}>
                    <Phone size={12} /> {demande.demandeurTelephone}
                  </p>
                </div>
              )}
              <div>
                <p style={{ color: 'var(--text-ter)' }}>Soumise le</p>
                <p style={{ color: 'var(--text-pri)' }}>{new Date(demande.createdAt).toLocaleString('fr-FR')}</p>
              </div>
            </div>

            {demande.observations && (
              <div>
                <p className="text-xs mb-1" style={{ color: 'var(--text-ter)' }}>Observations</p>
                <p className="text-sm rounded-lg px-3 py-2" style={{ background: 'var(--glass-bg)', border: '1px solid var(--border)', color: 'var(--text-sec)' }}>
                  {demande.observations}
                </p>
              </div>
            )}

            {demande.chauffeur && (
              <div>
                <p className="text-xs mb-1" style={{ color: 'var(--text-ter)' }}>Chauffeur assigné</p>
                <p className="text-sm" style={{ color: 'var(--text-pri)' }}>{demande.chauffeur.nom}</p>
              </div>
            )}

            {demande.motifRefus && (
              <div>
                <p className="text-xs mb-1" style={{ color: 'var(--text-ter)' }}>Motif de refus</p>
                <p className="text-sm rounded-lg px-3 py-2" style={{ color: 'var(--accent-err)', background: 'rgba(239,68,68,0.08)', border: '1px solid rgba(239,68,68,0.2)' }}>
                  {demande.motifRefus}
                </p>
              </div>
            )}

            {error && (
              <p className="text-xs rounded-lg px-3 py-2" style={{ color: 'var(--accent-err)', background: 'rgba(239,68,68,0.08)', border: '1px solid rgba(239,68,68,0.2)' }}>
                {error}
              </p>
            )}

            {/* Étape 1 : assigner un chauffeur */}
            {demande.statut === 'en_attente' && !showRefus && (
              <div className="space-y-3 pt-2" style={{ borderTop: '1px solid var(--border)' }}>
                <label>
                  <span>Chauffeur à assigner</span>
                  <select value={chauffeurId} onChange={(e) => setChauffeurId(e.target.value ? Number(e.target.value) : '')}>
                    <option value="">— Sélectionner un chauffeur disponible —</option>
                    {chauffeursDispo.map((c) => (
                      <option key={c.id} value={c.id}>{c.nom}</option>
                    ))}
                  </select>
                </label>
                {chauffeursDispo.length === 0 && (
                  <p className="text-xs" style={{ color: 'var(--text-ter)' }}>Aucun chauffeur disponible actuellement.</p>
                )}
                <div className="flex flex-wrap justify-end gap-2">
                  <Button variant="danger" disabled={acting} onClick={() => setShowRefus(true)}>
                    <XCircle size={13} /> Refuser
                  </Button>
                  <Button variant="primary" disabled={acting || !chauffeurId} onClick={handleAssigner}>
                    <UserCheck size={13} /> {acting ? 'En cours…' : 'Assigner'}
                  </Button>
                </div>
              </div>
            )}

            {/* En attente de la réponse du chauffeur : rien à faire côté responsable, sauf annuler */}
            {demande.statut === 'assignee' && !showRefus && (
              <div className="space-y-3 pt-2" style={{ borderTop: '1px solid var(--border)' }}>
                <p className="text-sm" style={{ color: 'var(--text-sec)' }}>
                  En attente de la réponse du chauffeur {demande.chauffeur?.nom ?? ''} — il doit accepter ou refuser depuis son portail avant de pouvoir valider l'ordre de mission.
                </p>
                <div className="flex flex-wrap justify-end gap-2">
                  <Button variant="danger" disabled={acting} onClick={() => setShowRefus(true)}>
                    <XCircle size={13} /> Annuler la demande
                  </Button>
                </div>
              </div>
            )}

            {/* Étape 2 : valider (choisir un véhicule) → crée l'OM — seulement une fois le chauffeur a accepté */}
            {demande.statut === 'confirmee' && !showRefus && (
              <div className="space-y-3 pt-2" style={{ borderTop: '1px solid var(--border)' }}>
                <label>
                  <span>Véhicule *</span>
                  <select value={vehiculeId} onChange={(e) => setVehiculeId(e.target.value ? Number(e.target.value) : '')}>
                    <option value="">— Sélectionner un véhicule disponible —</option>
                    {vehiculesDisponibles.map((v) => (
                      <option key={v.id} value={v.id}>{v.immatriculation} — {v.marque} {v.modele}</option>
                    ))}
                  </select>
                </label>
                <label>
                  <span>Objet de la mission</span>
                  <input value={objet} onChange={(e) => setObjet(e.target.value)} placeholder="Ex : Transport de documents" />
                </label>
                <label>
                  <span>Destination</span>
                  <input value={destination} onChange={(e) => setDestination(e.target.value)} placeholder="Ex : Casablanca" />
                </label>
                <div className="grid grid-cols-2 gap-3">
                  <label>
                    <span>Date de départ *</span>
                    <input type="date" value={dateDepart} onChange={(e) => setDateDepart(e.target.value)} />
                  </label>
                  <label>
                    <span>Heure de départ</span>
                    <input type="time" value={heureDepartPrevue} onChange={(e) => setHeureDepartPrevue(e.target.value)} />
                  </label>
                </div>
                <label>
                  <span>Date de retour prévue</span>
                  <input type="date" value={dateRetourPrevue} onChange={(e) => setDateRetourPrevue(e.target.value)} />
                </label>
                <label>
                  <span>Observations</span>
                  <textarea rows={2} value={validationObs} onChange={(e) => setValidationObs(e.target.value)} placeholder="Précisions complémentaires…" />
                </label>
                <div className="flex flex-wrap justify-end gap-2">
                  <Button variant="danger" disabled={acting} onClick={() => setShowRefus(true)}>
                    <XCircle size={13} /> Refuser
                  </Button>
                  <Button variant="primary" disabled={acting || !vehiculeId || !dateDepart} onClick={handleValider}>
                    <Car size={13} /> {acting ? 'En cours…' : 'Valider et créer l\u2019ordre de mission'}
                  </Button>
                </div>
              </div>
            )}

            {/* Refus (accessible depuis en_attente ou assignee) */}
            {showRefus && (
              <div className="space-y-3 pt-2" style={{ borderTop: '1px solid var(--border)' }}>
                <label>
                  <span>Motif de refus (optionnel)</span>
                  <textarea rows={2} value={motifRefus} onChange={(e) => setMotifRefus(e.target.value)} placeholder="Raison du refus…" />
                </label>
                <div className="flex flex-wrap justify-end gap-2">
                  <Button variant="secondary" disabled={acting} onClick={() => setShowRefus(false)}>Annuler</Button>
                  <Button variant="danger" disabled={acting} onClick={handleRefuser}>
                    <XCircle size={13} /> {acting ? 'En cours…' : 'Confirmer le refus'}
                  </Button>
                </div>
              </div>
            )}
          </>
        )}
      </div>
    </Modal>
  );
}

/* ── Page principale ───────────────────────────────────────────────────── */
export default function GererDemandesChauffeurPage() {
  const [searchParams, setSearchParams] = useSearchParams();
  const { nodes } = useOrg();

  const [demandes, setDemandes] = useState<DemandeChauffeur[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const [statutTab, setStatutTab] = useState(searchParams.get('statut') ?? 'en_attente');
  const [priorite, setPriorite] = useState(searchParams.get('priorite') ?? '');
  const [search, setSearch] = useState(searchParams.get('q') ?? '');
  const [selectedId, setSelectedId] = useState<number | null>(null);

  const load = () => {
    setLoading(true);
    setError(null);
    const params = new URLSearchParams();
    if (statutTab) params.set('statut', statutTab);
    if (priorite) params.set('priorite', priorite);
    if (search) params.set('search', search);
    api.get<{ demandes: DemandeChauffeur[] }>(`/demande-chauffeur?${params.toString()}`)
      .then((res) => setDemandes(res.demandes))
      .catch(() => setError('Impossible de charger les demandes de chauffeur.'))
      .finally(() => setLoading(false));
  };

  useEffect(() => {
    load();
    const next = new URLSearchParams();
    if (statutTab) next.set('statut', statutTab);
    if (priorite) next.set('priorite', priorite);
    if (search) next.set('q', search);
    setSearchParams(next, { replace: true });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [statutTab, priorite, search]);

  return (
    <div>
      <PageHeader
        eyebrow="Service de la Logistique et des Moyens Généraux"
        title="Gérer les demandes de chauffeur"
        description="Assignez un chauffeur, validez la mission ou refusez les demandes soumises par les services."
      />

      {/* Filtres */}
      <div className="flex flex-wrap items-center gap-2 mb-4">
        <div className="relative flex-1 min-w-48 max-w-72">
          <Search size={13} className="absolute left-3 top-1/2 -translate-y-1/2" style={{ color: 'var(--text-ter)' }} />
          <input
            value={search} onChange={(e) => setSearch(e.target.value)}
            placeholder="Rechercher (n°, demandeur)…"
            className="w-full text-sm pl-9 pr-3 py-2 rounded-xl outline-none"
            style={{ background: 'var(--glass-bg)', border: '1px solid var(--border)', color: 'var(--text-pri)' }}
          />
        </div>
        <select
          value={priorite} onChange={(e) => setPriorite(e.target.value)}
          className="text-sm px-3 py-2 rounded-xl outline-none"
          style={{ background: 'var(--glass-bg)', border: '1px solid var(--border)', color: 'var(--text-pri)' }}
        >
          <option value="">Toutes priorités</option>
          {(Object.keys(PRIORITE_LABELS) as DemandePriorite[]).map((p) => (
            <option key={p} value={p}>{PRIORITE_LABELS[p]}</option>
          ))}
        </select>
        <button onClick={load}
          className="focus-ring flex items-center gap-1.5 text-xs px-3 py-2 rounded-xl transition-colors"
          style={{ background: 'var(--glass-bg)', border: '1px solid var(--border)', color: 'var(--text-sec)' }}>
          <RefreshCw size={12} /> Actualiser
        </button>
      </div>

      {/* Onglets statut */}
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

      {error && (
        <p className="text-sm rounded-lg px-3 py-2 mb-4"
          style={{ color: 'var(--accent-err)', background: 'rgba(239,68,68,0.08)', border: '1px solid rgba(239,68,68,0.2)' }}>
          {error}
        </p>
      )}

      {!loading && demandes.length === 0 ? (
        <EmptyState
          title="Aucune demande"
          description="Aucune demande de chauffeur ne correspond aux filtres sélectionnés."
          action={<Button variant="secondary" onClick={() => { setStatutTab(''); setPriorite(''); setSearch(''); }}><ClipboardList size={14} /> Réinitialiser les filtres</Button>}
        />
      ) : (
        <Card className="overflow-hidden">
          <div className="divide-y" style={{ borderColor: 'var(--border)' }}>
            {demandes.map((d) => {
              const serviceName = nodes.find((n) => n.id === d.serviceDemandeurId)?.name ?? '—';
              return (
                <button
                  key={d.id}
                  onClick={() => setSelectedId(d.id)}
                  className="w-full flex flex-wrap items-center gap-3 px-4 py-3 text-left transition-colors hover:bg-[var(--card-hover)]"
                >
                  <span className="text-xs font-mono shrink-0" style={{ color: 'var(--text-ter)' }}>{d.numero}</span>
                  <span className="text-sm font-medium flex-1 min-w-40 truncate" style={{ color: 'var(--text-pri)' }}>{d.demandeurNom}</span>
                  <span className="text-xs hidden lg:inline" style={{ color: 'var(--text-ter)' }}>{serviceName}</span>
                  {d.chauffeur && (
                    <span className="text-xs hidden md:inline" style={{ color: 'var(--text-ter)' }}>{d.chauffeur.nom}</span>
                  )}
                  <Badge tone={PRIORITE_TONE[d.priorite]}>{PRIORITE_LABELS[d.priorite]}</Badge>
                  <Badge tone={STATUT_TONE[d.statut]}>{STATUT_LABELS[d.statut]}</Badge>
                  <span className="text-xs shrink-0 hidden sm:inline" style={{ color: 'var(--text-ter)' }}>
                    {new Date(d.createdAt).toLocaleDateString('fr-FR')}
                  </span>
                </button>
              );
            })}
          </div>
        </Card>
      )}

      {selectedId != null && (
        <TraiterPanel id={selectedId} onClose={() => setSelectedId(null)} onDone={load} />
      )}
    </div>
  );
}
