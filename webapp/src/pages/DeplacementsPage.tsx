import { useEffect, useMemo, useState } from 'react';
import QRCode from 'qrcode';
import {
  Plus, Search, MapPin, Car, User as UserIcon, CalendarDays, Gauge, Flag, Ban,
  AlertTriangle, Pencil, Trash2, X, Users, Printer, FileSpreadsheet,
  ArrowRight, Play, Home, CheckSquare, Square
} from 'lucide-react';
import { PageHeader, Card, Badge, Button, Modal, EmptyState, StatCard } from '../components/ui/Kit';
import { useParcAuto } from '../context/ParcAutoContext';
import { useOrg } from '../context/OrgContext';
import { printOrdreMission, exportDeplacementsToExcel } from '../lib/parcAutoExport';
import {
  type Deplacement, type DeplacementStatut, type DeplacementPassager, type PassagerInput,
  type Vehicule, type MissionEvent,
  DEPLACEMENT_STATUT_LABELS, DEPLACEMENT_STATUT_TONE, VEHICULE_STATUT_LABELS, VEHICULE_STATUT_TONE,
  CHAUFFEUR_STATUT_LABELS, DEPLACEMENT_ETAPES, DEPLACEMENT_ETAPE_COLOR
} from '../types/parcAuto';

const STATUT_TABS: { value: string; label: string }[] = [
  { value: '', label: 'Tous' },
  { value: 'creee', label: 'Créées' },
  { value: 'en_attente_acceptation', label: 'En attente' },
  { value: 'acceptee', label: 'Acceptées' },
  { value: 'en_route', label: 'En route' },
  { value: 'arrive', label: 'Arrivé' },
  { value: 'mission_en_cours', label: 'Mission en cours' },
  { value: 'terminee', label: 'Terminée' },
  { value: 'retour', label: 'Retour' },
  { value: 'arrive_siege', label: 'Arrivé siège' },
  { value: 'cloturee', label: 'Clôturées' },
  { value: 'annule', label: 'Annulés' }
];

function toDMY(iso: string): string { const [y, m, d] = iso.split('-'); return `${d}/${m}/${y}`; }

function VehiculeIndisponibleAlert({ vehicule }: { vehicule: Vehicule }) {
  if (vehicule.statut === 'disponible') return null;
  let message: string;
  if (vehicule.statut === 'en_mission') {
    const m = vehicule.missionActuelle;
    message = m
      ? `Ce véhicule est actuellement en mission à ${m.destination || 'une destination non précisée'}. Chauffeur : ${m.chauffeurNom || 'non désigné'}. Retour prévu : ${m.dateRetourPrevue || 'non précisé'}.`
      : 'Ce véhicule est actuellement en mission.';
  } else if (vehicule.statut === 'maintenance') {
    message = 'Ce véhicule est actuellement en maintenance et ne peut pas être réservé.';
  } else {
    message = 'Ce véhicule est actuellement hors service et ne peut pas être réservé.';
  }
  return (
    <div className="flex items-start gap-2 text-xs rounded-lg px-3 py-2" style={{ color: 'var(--accent-warn)', background: 'rgba(245,158,11,0.08)', border: '1px solid rgba(245,158,11,0.25)' }}>
      <AlertTriangle size={14} className="shrink-0 mt-0.5" />
      <span>{message}</span>
    </div>
  );
}

function PassagersEditor({ passagers, onChange }: { passagers: PassagerInput[]; onChange: (p: PassagerInput[]) => void }) {
  const { nodes } = useOrg();
  const sortedNodes = useMemo(() => [...nodes].sort((a, b) => a.name.localeCompare(b.name)), [nodes]);

  const update = (idx: number, patch: Partial<PassagerInput>) => {
    onChange(passagers.map((p, i) => (i === idx ? { ...p, ...patch } : p)));
  };
  const remove = (idx: number) => onChange(passagers.filter((_, i) => i !== idx));
  const add = () => onChange([...passagers, { nom: '', serviceId: null }]);

  return (
    <div>
      <div className="flex items-center justify-between mb-1.5">
        <span className="text-xs font-medium" style={{ color: 'var(--text-sec)' }}>Personnel transporté</span>
        <button type="button" onClick={add} className="text-xs flex items-center gap-1" style={{ color: 'var(--accent)' }}>
          <Plus size={12} /> Ajouter une personne
        </button>
      </div>
      {passagers.length === 0 ? (
        <p className="text-xs" style={{ color: 'var(--text-ter)' }}>Aucune personne transportée ajoutée.</p>
      ) : (
        <div className="space-y-2">
          {passagers.map((p, idx) => (
            <div key={idx} className="flex items-center gap-2">
              <input
                value={p.nom}
                onChange={(e) => update(idx, { nom: e.target.value })}
                placeholder="Nom de la personne"
                className="flex-1"
              />
              <select
                value={p.serviceId ?? ''}
                onChange={(e) => update(idx, { serviceId: e.target.value ? Number(e.target.value) : null })}
                className="flex-1"
              >
                <option value="">— Service —</option>
                {sortedNodes.map((n) => (
                  <option key={n.id} value={n.id}>{n.name}</option>
                ))}
              </select>
              <button type="button" onClick={() => remove(idx)} className="p-1.5 rounded-md hover:bg-[var(--card-hover)]" style={{ color: 'var(--text-ter)' }}>
                <X size={14} />
              </button>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

/* ── Formulaire (création ou modification) ──────────────────────────── */
function DeplacementForm({ initial, initialPassagers, onClose }: {
  initial?: Deplacement | null;
  initialPassagers?: DeplacementPassager[];
  onClose: () => void;
}) {
  const { vehicules, chauffeurs, createDeplacement, updateDeplacement } = useParcAuto();
  const { nodes } = useOrg();

  const [vehiculeId, setVehiculeId] = useState<number | ''>(initial?.vehiculeId ?? '');
  const [chauffeurId, setChauffeurId] = useState<number | ''>(initial?.chauffeurId ?? '');
  const [serviceDemandeurId, setServiceDemandeurId] = useState<number | ''>(initial?.serviceDemandeurId ?? '');
  const [objet, setObjet] = useState(initial?.objet ?? '');
  const [destination, setDestination] = useState(initial?.destination ?? '');
  const [dateDepart, setDateDepart] = useState('');
  const [dateRetourPrevue, setDateRetourPrevue] = useState('');
  const [passagers, setPassagers] = useState<PassagerInput[]>(
    (initialPassagers ?? []).map((p) => ({ nom: p.nom, serviceId: p.serviceId }))
  );
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const sortedNodes = useMemo(() => [...nodes].sort((a, b) => a.name.localeCompare(b.name)), [nodes]);
  const selectedVehicule = vehiculeId ? vehicules.find((v) => v.id === vehiculeId) : null;
  const selectedChauffeur = chauffeurId ? chauffeurs.find((c) => c.id === chauffeurId) : null;
  const vehiculeBloque = selectedVehicule && selectedVehicule.statut !== 'disponible' && selectedVehicule.id !== initial?.vehiculeId;
  const chauffeurBloque = selectedChauffeur && selectedChauffeur.statut !== 'disponible' && selectedChauffeur.id !== initial?.chauffeurId;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!vehiculeId || !serviceDemandeurId || !objet.trim() || (!initial && !dateDepart)) return;
    if (vehiculeBloque || chauffeurBloque) return;
    setSaving(true);
    setError(null);
    try {
      if (initial) {
        await updateDeplacement(initial.id, {
          vehiculeId: Number(vehiculeId),
          chauffeurId: chauffeurId ? Number(chauffeurId) : undefined,
          objet: objet.trim(),
          destination: destination.trim() || undefined,
          dateRetourPrevue: dateRetourPrevue ? toDMY(dateRetourPrevue) : undefined,
          passagers
        });
      } else {
        await createDeplacement({
          vehiculeId: Number(vehiculeId),
          chauffeurId: chauffeurId ? Number(chauffeurId) : undefined,
          serviceDemandeurId: Number(serviceDemandeurId),
          objet: objet.trim(),
          destination: destination.trim() || undefined,
          dateDepart: toDMY(dateDepart),
          dateRetourPrevue: dateRetourPrevue ? toDMY(dateRetourPrevue) : undefined,
          passagers
        });
      }
      onClose();
    } catch (err) {
      setError(err instanceof Error && err.message ? err.message : "Impossible d'enregistrer l'ordre de mission.");
    } finally {
      setSaving(false);
    }
  };

  return (
    <form className="space-y-3" onSubmit={handleSubmit}>
      <label>
        <span>Véhicule *</span>
        <select required value={vehiculeId} onChange={(e) => setVehiculeId(e.target.value ? Number(e.target.value) : '')}>
          <option value="">— Sélectionner —</option>
          {vehicules.map((v) => (
            <option key={v.id} value={v.id}>
              {v.immatriculation} — {v.marque} {v.modele} · {VEHICULE_STATUT_LABELS[v.statut]}
            </option>
          ))}
        </select>
      </label>
      {selectedVehicule && <VehiculeIndisponibleAlert vehicule={selectedVehicule} />}

      <div className="grid grid-cols-2 gap-3">
        <label>
          <span>Chauffeur</span>
          <select value={chauffeurId} onChange={(e) => setChauffeurId(e.target.value ? Number(e.target.value) : '')}>
            <option value="">— Non désigné —</option>
            {chauffeurs.map((c) => (
              <option key={c.id} value={c.id}>{c.nom} · {CHAUFFEUR_STATUT_LABELS[c.statut]}</option>
            ))}
          </select>
          {chauffeurs.length === 0 && (
            <span className="text-[11px]" style={{ color: 'var(--text-ter)' }}>
              Aucun chauffeur enregistré — ajoutez-en dans la page « Chauffeurs ».
            </span>
          )}
        </label>
        <label>
          <span>Service demandeur *</span>
          <select required value={serviceDemandeurId} onChange={(e) => setServiceDemandeurId(e.target.value ? Number(e.target.value) : '')}>
            <option value="">— Sélectionner —</option>
            {sortedNodes.map((n) => (
              <option key={n.id} value={n.id}>{n.name}</option>
            ))}
          </select>
        </label>
      </div>
      {selectedChauffeur && chauffeurBloque && (
        <p className="text-xs rounded-lg px-3 py-2" style={{ color: 'var(--accent-warn)', background: 'rgba(245,158,11,0.08)', border: '1px solid rgba(245,158,11,0.25)' }}>
          Ce chauffeur n'est pas disponible actuellement ({CHAUFFEUR_STATUT_LABELS[selectedChauffeur.statut]}).
        </p>
      )}

      <label>
        <span>Objet de la mission *</span>
        <input required value={objet} onChange={(e) => setObjet(e.target.value)} placeholder="Ex : Transport de matériel vers l'antenne régionale" />
      </label>
      <label>
        <span>Destination</span>
        <input value={destination} onChange={(e) => setDestination(e.target.value)} placeholder="Ville / lieu" />
      </label>

      <div className="grid grid-cols-2 gap-3">
        {!initial && (
          <label>
            <span>Date de départ *</span>
            <input required type="date" value={dateDepart} onChange={(e) => setDateDepart(e.target.value)} />
          </label>
        )}
        <label className={initial ? 'col-span-2' : ''}>
          <span>Date de retour prévue</span>
          <input type="date" value={dateRetourPrevue} onChange={(e) => setDateRetourPrevue(e.target.value)} />
        </label>
      </div>

      <div className="pt-2" style={{ borderTop: '1px solid var(--border)' }}>
        <PassagersEditor passagers={passagers} onChange={setPassagers} />
      </div>

      {error && (
        <p className="text-xs rounded-lg px-3 py-2" style={{ color: 'var(--accent-err)', background: 'rgba(239,68,68,0.08)', border: '1px solid rgba(239,68,68,0.2)' }}>{error}</p>
      )}

      <div className="flex justify-end gap-2 pt-2">
        <Button variant="secondary" type="button" onClick={onClose}>Annuler</Button>
        <Button variant="primary" type="submit" disabled={saving || Boolean(vehiculeBloque) || Boolean(chauffeurBloque)}>
          <Plus size={13} /> {saving ? 'Enregistrement…' : initial ? 'Enregistrer' : "Créer l'ordre de mission"}
        </Button>
      </div>
    </form>
  );
}

/* ── Panneau détail + workflow ───────────────────────────────────────── */
function DetailPanel({ id, onClose }: { id: number; onClose: () => void }) {
  const { vehicules, chauffeurs, fetchDeplacementDetail, transitionDeplacement, deleteDeplacement } = useParcAuto();
  const { nodes } = useOrg();
  const [deplacement, setDeplacement] = useState<Deplacement | null>(null);
  const [passagers, setPassagers] = useState<DeplacementPassager[]>([]);
  const [events, setEvents] = useState<MissionEvent[]>([]);
  const [loading, setLoading] = useState(true);
  const [kilometrageDepart, setKilometrageDepart] = useState('');
  const [kilometrageRetour, setKilometrageRetour] = useState('');
  const [rapportMission, setRapportMission] = useState('');
  const [acting, setActing] = useState<DeplacementStatut | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [editing, setEditing] = useState(false);
  const [confirmDelete, setConfirmDelete] = useState(false);
  const [qrPreview, setQrPreview] = useState<string | null>(null);

  useEffect(() => {
    if (!deplacement) { setQrPreview(null); return; }
    QRCode.toDataURL(`ORDRE-MISSION:${deplacement.numero}:${deplacement.statut}`, { width: 120, margin: 1 })
      .then(setQrPreview)
      .catch(() => setQrPreview(null));
  }, [deplacement?.numero, deplacement?.statut]);

  const load = () => {
    setLoading(true);
    fetchDeplacementDetail(id)
      .then((res) => { setDeplacement(res.deplacement); setPassagers(res.passagers ?? []); setEvents(res.events ?? []); })
      .catch(() => setError('Impossible de charger ce déplacement.'))
      .finally(() => setLoading(false));
  };
  useEffect(() => { load(); /* eslint-disable-next-line react-hooks/exhaustive-deps */ }, [id]);

  // Auto-refresh every 15 seconds for live tracking
  useEffect(() => {
    if (!deplacement || deplacement.statut === 'cloturee' || deplacement.statut === 'annule') return;
    const interval = setInterval(load, 15_000);
    return () => clearInterval(interval);
  }, [deplacement?.id, deplacement?.statut]);

  const vehicule = deplacement ? vehicules.find((v) => v.id === deplacement.vehiculeId) : null;
  const chauffeur = deplacement?.chauffeurId ? chauffeurs.find((c) => c.id === deplacement.chauffeurId) : null;
  const serviceName = deplacement ? nodes.find((n) => n.id === deplacement.serviceDemandeurId)?.name ?? '—' : '—';

  useEffect(() => {
    if (vehicule) setKilometrageDepart(String(vehicule.kilometrage));
  }, [vehicule?.id]);

  const handleAction = async (statut: DeplacementStatut) => {
    if (!deplacement) return;
    setActing(statut);
    setError(null);
    try {
      await transitionDeplacement(deplacement.id, statut, {
        kilometrageDepart: kilometrageDepart ? Number(kilometrageDepart) : undefined,
        kilometrageRetour: kilometrageRetour ? Number(kilometrageRetour) : undefined,
        rapportMission: rapportMission.trim() || undefined,
      });
      onClose();
    } catch {
      setError('Cette action a échoué. Vérifiez les informations saisies.');
    } finally {
      setActing(null);
    }
  };

  const handleDelete = async () => {
    if (!deplacement) return;
    try {
      await deleteDeplacement(deplacement.id);
      onClose();
    } catch {
      setError('Impossible de supprimer ce déplacement.');
      setConfirmDelete(false);
    }
  };

  if (editing && deplacement) {
    return (
      <Modal open onClose={() => setEditing(false)} title={`Modifier ${deplacement.numero}`} width="md">
        <DeplacementForm initial={deplacement} initialPassagers={passagers} onClose={() => { setEditing(false); load(); }} />
      </Modal>
    );
  }

  return (
    <Modal open onClose={onClose} title={deplacement?.numero ?? 'Déplacement'} width="lg">
      {loading || !deplacement ? (
        <p className="text-sm py-8 text-center" style={{ color: 'var(--text-ter)' }}>Chargement…</p>
      ) : (
        <div className="space-y-5">
          <div className="flex flex-wrap items-center justify-between gap-2">
            <div className="flex flex-wrap items-center gap-2">
              <Badge tone={DEPLACEMENT_STATUT_TONE[deplacement.statut]}>{DEPLACEMENT_STATUT_LABELS[deplacement.statut]}</Badge>
              {vehicule && <Badge tone={VEHICULE_STATUT_TONE[vehicule.statut]}><Car size={11} className="inline mr-1" />{vehicule.immatriculation}</Badge>}
            </div>
            <div className="flex items-center gap-1">
              {qrPreview && (
                <img
                  src={qrPreview}
                  alt="QR code de l'ordre de mission"
                  title="QR code — vérification de l'ordre de mission"
                  className="w-8 h-8 rounded-md shrink-0"
                  style={{ border: '1px solid var(--border)', background: '#fff', padding: 2 }}
                />
              )}
              <button title="Imprimer l'ordre de mission" className="tbl-btn focus-ring" onClick={() => printOrdreMission({
                deplacement, vehicule: vehicule ?? null, chauffeur: chauffeur ?? null, serviceNom: serviceName,
                passagers, passagerServiceNom: (sid) => nodes.find((n) => n.id === sid)?.name ?? '—'
              })}>
                <Printer size={14} />
              </button>
              {(deplacement.statut === 'creee' || deplacement.statut === 'en_attente_acceptation') && (
                <>
                  <button title="Modifier" className="tbl-btn focus-ring" onClick={() => setEditing(true)}>
                    <Pencil size={14} />
                  </button>
                  <button title="Supprimer" className="tbl-btn danger focus-ring" onClick={() => setConfirmDelete(true)}>
                    <Trash2 size={14} />
                  </button>
                </>
              )}
            </div>
          </div>

          <div>
            <h4 className="text-base font-bold" style={{ color: 'var(--text-pri)' }}>{deplacement.objet}</h4>
            {deplacement.destination && (
              <p className="text-sm mt-1 flex items-center gap-1.5" style={{ color: 'var(--text-sec)' }}>
                <MapPin size={12} /> {deplacement.destination}
              </p>
            )}
          </div>

          <div className="grid grid-cols-2 gap-3 text-sm">
            <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Service demandeur</p><p style={{ color: 'var(--text-pri)' }}>{serviceName}</p></div>
            {chauffeur && (
              <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Chauffeur</p>
                <p className="flex items-center gap-1.5" style={{ color: 'var(--text-pri)' }}><UserIcon size={12} style={{ color: 'var(--text-ter)' }} /> {chauffeur.nom}</p>
              </div>
            )}
            <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Départ</p>
              <p className="flex items-center gap-1.5" style={{ color: 'var(--text-pri)' }}><CalendarDays size={12} style={{ color: 'var(--text-ter)' }} /> {deplacement.dateDepart}</p>
            </div>
            {deplacement.dateRetourPrevue && (
              <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Retour prévu</p><p style={{ color: 'var(--text-pri)' }}>{deplacement.dateRetourPrevue}</p></div>
            )}
            {deplacement.kilometrageDepart != null && (
              <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Km au départ</p><p style={{ color: 'var(--text-pri)' }}>{deplacement.kilometrageDepart.toLocaleString('fr-FR')} km</p></div>
            )}
            {deplacement.kilometrageRetour != null && (
              <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Km au retour</p><p style={{ color: 'var(--text-pri)' }}>{deplacement.kilometrageRetour.toLocaleString('fr-FR')} km</p></div>
            )}
          </div>

          {passagers.length > 0 && (
            <div>
              <p className="text-[11px] uppercase tracking-wide mb-1.5 flex items-center gap-1.5" style={{ color: 'var(--text-ter)' }}>
                <Users size={12} /> Personnel transporté
              </p>
              <div className="space-y-1">
                {passagers.map((p) => (
                  <div key={p.id} className="flex items-center justify-between text-sm rounded-lg px-3 py-1.5" style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}>
                    <span style={{ color: 'var(--text-pri)' }}>{p.nom}</span>
                    <span className="text-xs" style={{ color: 'var(--text-ter)' }}>{nodes.find((n) => n.id === p.serviceId)?.name ?? '—'}</span>
                  </div>
                ))}
              </div>
            </div>
          )}

          {deplacement.rapportMission && (
            <div>
              <p className="text-[11px] uppercase tracking-wide mb-1" style={{ color: 'var(--text-ter)' }}>Rapport de mission</p>
              <p className="text-sm" style={{ color: 'var(--text-sec)' }}>{deplacement.rapportMission}</p>
            </div>
          )}

          {error && (
            <p className="text-xs rounded-lg px-3 py-2" style={{ color: 'var(--accent-err)', background: 'rgba(239,68,68,0.08)', border: '1px solid rgba(239,68,68,0.2)' }}>{error}</p>
          )}

          {/* Barre de progression live — montre l'avancement du chauffeur dans les 9 étapes */}
          {deplacement.statut !== 'annule' && (
            <div className="pt-2">
              <p className="text-[11px] uppercase tracking-wide mb-2" style={{ color: 'var(--text-ter)' }}>Progression de la mission</p>
              <div className="flex items-center gap-1">
                {DEPLACEMENT_ETAPES.map((etape, idx) => {
                  const curIdx = DEPLACEMENT_ETAPES.indexOf(deplacement.statut);
                  const etaIdx = DEPLACEMENT_ETAPES.indexOf(etape);
                  const atteinte = etaIdx <= curIdx;
                  return (
                    <div key={etape} className="flex-1 flex flex-col items-center gap-0.5">
                      <div
                        className="w-full h-2 rounded-full transition-all duration-500"
                        style={{ background: atteinte ? DEPLACEMENT_ETAPE_COLOR[etape] : 'var(--border)' }}
                      />
                      <span className="text-[8px] uppercase text-center leading-tight" style={{ color: atteinte ? DEPLACEMENT_ETAPE_COLOR[etape] : 'var(--text-ter)' }}>
                        {DEPLACEMENT_STATUT_LABELS[etape].slice(0, 4)}
                      </span>
                    </div>
                  );
                })}
              </div>
            </div>
          )}

          {/* Timeline des événements live */}
          {events.length > 0 && (
            <div>
              <p className="text-[11px] uppercase tracking-wide mb-2 flex items-center gap-1.5" style={{ color: 'var(--text-ter)' }}>
                <span>Timeline</span>
                <span className="text-[10px] px-1.5 py-0.5 rounded-full" style={{ background: 'rgba(99,102,241,0.14)', color: '#6366f1' }}>
                  {events.length} événement{events.length > 1 ? 's' : ''}
                </span>
              </p>
              <div className="space-y-1.5 max-h-48 overflow-y-auto">
                {events.map((event, idx) => (
                  <div key={event.id ?? idx} className="flex items-start gap-2 text-xs">
                    <div
                      className="w-2 h-2 rounded-full mt-1 shrink-0"
                      style={{ background: DEPLACEMENT_ETAPE_COLOR[event.statut as DeplacementStatut] ?? 'var(--text-ter)' }}
                    />
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center justify-between">
                        <span className="font-medium" style={{ color: 'var(--text-pri)' }}>
                          {DEPLACEMENT_STATUT_LABELS[event.statut as DeplacementStatut] ?? event.statut}
                        </span>
                        <span style={{ color: 'var(--text-ter)' }}>
                          {new Date(event.createdAt).toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' })}
                        </span>
                      </div>
                      <span style={{ color: 'var(--text-ter)' }}>par {event.actionPar}</span>
                      {event.commentaire && event.commentaire !== event.actionPar && (
                        <p style={{ color: 'var(--text-sec)' }}>{event.commentaire}</p>
                      )}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Workflow actions by status */}
          {deplacement.statut === 'creee' && (
            <div className="space-y-2 pt-3" style={{ borderTop: '1px solid var(--border)' }}>
              <div className="flex justify-end gap-2">
                <Button variant="primary" disabled={acting !== null} onClick={() => handleAction('en_attente_acceptation')}>
                  <ArrowRight size={13} /> {acting === 'en_attente_acceptation' ? 'Envoi…' : 'Soumettre au chauffeur'}
                </Button>
              </div>
            </div>
          )}

          {deplacement.statut === 'en_attente_acceptation' && (
            <div className="space-y-2 pt-3" style={{ borderTop: '1px solid var(--border)' }}>
              <p className="text-xs" style={{ color: 'var(--text-ter)' }}>En attente d'acceptation par le chauffeur.</p>
              <div className="flex justify-end gap-2">
                <Button variant="danger" disabled={acting !== null} onClick={() => handleAction('annule')}>
                  <Ban size={13} /> {acting === 'annule' ? 'Annulation…' : 'Annuler la mission'}
                </Button>
              </div>
            </div>
          )}

          {deplacement.statut === 'acceptee' && (
            <div className="space-y-2 pt-3" style={{ borderTop: '1px solid var(--border)' }}>
              <p className="text-xs" style={{ color: 'var(--text-ter)' }}>Mission acceptée par le chauffeur. En attente de départ.</p>
              <label>
                <span>Kilométrage au départ</span>
                <input type="number" min={0} value={kilometrageDepart} onChange={(e) => setKilometrageDepart(e.target.value)} />
              </label>
              <div className="flex justify-end gap-2">
                <Button variant="danger" disabled={acting !== null} onClick={() => handleAction('annule')}>
                  <Ban size={13} /> {acting === 'annule' ? 'Annulation…' : 'Annuler la mission'}
                </Button>
                <Button variant="primary" disabled={acting !== null} onClick={() => handleAction('en_route')}>
                  <Gauge size={13} /> {acting === 'en_route' ? 'Démarrage…' : 'Démarrer la mission'}
                </Button>
              </div>
            </div>
          )}

          {deplacement.statut === 'en_route' && (
            <div className="space-y-2 pt-3" style={{ borderTop: '1px solid var(--border)' }}>
              <p className="text-xs" style={{ color: 'var(--text-ter)' }}>Chauffeur en route vers la destination.</p>
              <div className="flex justify-end">
                <Button variant="primary" disabled={acting !== null} onClick={() => handleAction('arrive')}>
                  <MapPin size={13} /> {acting === 'arrive' ? '…' : 'Marquer arrivé'}
                </Button>
              </div>
            </div>
          )}

          {deplacement.statut === 'arrive' && (
            <div className="space-y-2 pt-3" style={{ borderTop: '1px solid var(--border)' }}>
              <p className="text-xs" style={{ color: 'var(--text-ter)' }}>Chauffeur arrivé sur site.</p>
              <div className="flex justify-end">
                <Button variant="primary" disabled={acting !== null} onClick={() => handleAction('mission_en_cours')}>
                  <Play size={13} /> {acting === 'mission_en_cours' ? '…' : 'Commencer mission'}
                </Button>
              </div>
            </div>
          )}

          {deplacement.statut === 'mission_en_cours' && (
            <div className="space-y-2 pt-3" style={{ borderTop: '1px solid var(--border)' }}>
              <p className="text-xs" style={{ color: 'var(--text-ter)' }}>Mission en cours sur site.</p>
              <div className="flex justify-end">
                <Button variant="primary" disabled={acting !== null} onClick={() => handleAction('terminee')}>
                  <Flag size={13} /> {acting === 'terminee' ? '…' : 'Terminer la mission'}
                </Button>
              </div>
            </div>
          )}

          {deplacement.statut === 'terminee' && (
            <div className="space-y-2 pt-3" style={{ borderTop: '1px solid var(--border)' }}>
              <p className="text-xs" style={{ color: 'var(--text-ter)' }}>Mission terminée. Le chauffeur doit retourner au siège.</p>
              <label>
                <span>Kilométrage au retour</span>
                <input type="number" min={0} value={kilometrageRetour} onChange={(e) => setKilometrageRetour(e.target.value)} />
              </label>
              <label>
                <span>Rapport de mission</span>
                <textarea rows={2} value={rapportMission} onChange={(e) => setRapportMission(e.target.value)} placeholder="Compte-rendu de la mission…" />
              </label>
              <div className="flex justify-end">
                <Button variant="primary" disabled={acting !== null} onClick={() => handleAction('retour')}>
                  <ArrowRight size={13} /> {acting === 'retour' ? '…' : 'Retour au siège'}
                </Button>
              </div>
            </div>
          )}

          {deplacement.statut === 'retour' && (
            <div className="space-y-2 pt-3" style={{ borderTop: '1px solid var(--border)' }}>
              <p className="text-xs" style={{ color: 'var(--text-ter)' }}>Chauffeur en retour vers le siège.</p>
              <div className="flex justify-end">
                <Button variant="primary" disabled={acting !== null} onClick={() => handleAction('arrive_siege')}>
                  <Home size={13} /> {acting === 'arrive_siege' ? '…' : 'Arrivé au siège'}
                </Button>
              </div>
            </div>
          )}

          {deplacement.statut === 'arrive_siege' && (
            <div className="space-y-2 pt-3" style={{ borderTop: '1px solid var(--border)' }}>
              <p className="text-xs" style={{ color: 'var(--text-ter)' }}>Chauffeur arrivé au siège. Clôturez la mission.</p>
              <label>
                <span>Consommation carburant (L)</span>
                <input type="number" min={0} step={0.1} value={kilometrageRetour} onChange={(e) => setKilometrageRetour(e.target.value)} />
              </label>
              <label>
                <span>Distance parcourue (km)</span>
                <input type="number" min={0} value={kilometrageDepart} onChange={(e) => setKilometrageDepart(e.target.value)} />
              </label>
              <div className="flex justify-end">
                <Button variant="primary" disabled={acting !== null} onClick={() => handleAction('cloturee')}>
                  <Flag size={13} /> {acting === 'cloturee' ? '…' : 'Clôturer la mission'}
                </Button>
              </div>
            </div>
          )}
        </div>
      )}

      {confirmDelete && (
        <Modal open onClose={() => setConfirmDelete(false)} title="Supprimer cet ordre de mission ?" width="sm">
          <p className="text-sm mb-4" style={{ color: 'var(--text-sec)' }}>Cette action est irréversible.</p>
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
export default function DeplacementsPage() {
  const { deplacements, vehicules, chauffeurs, loading, bulkDeleteDeplacements } = useParcAuto();
  const { nodes } = useOrg();
  const [statutTab, setStatutTab] = useState('');
  const [search, setSearch] = useState('');
  const [showCreate, setShowCreate] = useState(false);
  const [selectedId, setSelectedId] = useState<number | null>(null);
  const [selectMode, setSelectMode] = useState(false);
  const [selectedIds, setSelectedIds] = useState<Set<number>>(new Set());
const [confirmBulkDelete, setConfirmBulkDelete] = useState(false);
  const [bulkDeleting, setBulkDeleting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const filtered = useMemo(() => {
    return deplacements.filter((d) => {
      if (statutTab && d.statut !== statutTab) return false;
      if (search.trim()) {
        const s = search.toLowerCase();
        if (!d.numero.toLowerCase().includes(s) && !d.objet.toLowerCase().includes(s) && !(d.destination ?? '').toLowerCase().includes(s)) return false;
      }
      return true;
    });
  }, [deplacements, statutTab, search]);

  return (
    <div>
      <PageHeader
        eyebrow="Service de la Logistique et des Moyens Généraux"
        title="Déplacements"
        description="Ordres de mission, réservation de véhicules et suivi des tournées."
action={
          <div className="flex items-center gap-2">
            <Button variant="secondary" onClick={() => { setSelectMode(!selectMode); setSelectedIds(new Set()); }}>
              {selectMode ? <X size={14} /> : <CheckSquare size={14} />} {selectMode ? 'Annuler' : 'Sélectionner'}
            </Button>
            {selectMode && selectedIds.size > 0 && (
              <Button variant="danger" onClick={() => setConfirmBulkDelete(true)} disabled={bulkDeleting}>
                <Trash2 size={14} /> Supprimer ({selectedIds.size})
              </Button>
            )}
            <Button variant="secondary" onClick={() => exportDeplacementsToExcel(filtered)}>
              <FileSpreadsheet size={14} /> Exporter Excel
            </Button>
            <Button variant="primary" onClick={() => setShowCreate(true)}><Plus size={14} /> Nouvel ordre de mission</Button>
          </div>
        }
      />

      <div className="grid grid-cols-2 md:grid-cols-4 gap-3 mb-6">
        <StatCard label="Total" value={deplacements.length} icon={<MapPin size={16} />} color="blue" />
        <StatCard
          label="En attente"
          value={deplacements.filter((d) => ['creee', 'en_attente_acceptation'].includes(d.statut)).length}
          icon={<CalendarDays size={16} />}
          color="orange"
        />
        <StatCard
          label="En cours"
          value={deplacements.filter((d) => ['acceptee', 'en_route', 'arrive', 'mission_en_cours', 'retour', 'arrive_siege'].includes(d.statut)).length}
          icon={<Car size={16} />}
          color="violet"
        />
        <StatCard
          label="Clôturées"
          value={deplacements.filter((d) => d.statut === 'cloturee').length}
          icon={<Flag size={16} />}
          color="green"
        />
      </div>

{chauffeurs.length === 0 && (
        <div className="flex items-start gap-2 text-xs rounded-lg px-3 py-2 mb-4" style={{ color: 'var(--accent-warn)', background: 'rgba(245,158,11,0.08)', border: '1px solid rgba(245,158,11,0.25)' }}>
          <AlertTriangle size={14} className="shrink-0 mt-0.5" />
          <span>Aucun chauffeur enregistré. Ajoutez vos chauffeurs dans la page « Chauffeurs » avant de créer des ordres de mission.</span>
        </div>
      )}

      {error && (
        <p className="text-xs rounded-lg px-3 py-2 mb-4" style={{ color: 'var(--accent-err)', background: 'rgba(239,68,68,0.08)', border: '1px solid rgba(239,68,68,0.2)' }}>{error}</p>
      )}

      <div className="flex flex-wrap items-center gap-2 mb-4">
        <div className="relative flex-1 min-w-48 max-w-72">
          <Search size={13} className="absolute left-3 top-1/2 -translate-y-1/2" style={{ color: 'var(--text-ter)' }} />
          <input
            value={search} onChange={(e) => setSearch(e.target.value)}
            placeholder="N°, objet, destination…"
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
          title="Aucun ordre de mission"
          description="Aucun déplacement ne correspond aux filtres sélectionnés."
          action={<Button variant="primary" onClick={() => setShowCreate(true)}><Plus size={14} /> Créer un ordre de mission</Button>}
        />
      ) : (
        <Card className="overflow-hidden">
          <div className="divide-y" style={{ borderColor: 'var(--border)' }}>
            {filtered.map((d) => {
              const vehicule = vehicules.find((v) => v.id === d.vehiculeId);
              const chauffeur = d.chauffeurId ? chauffeurs.find((c) => c.id === d.chauffeurId) : null;
              const serviceName = nodes.find((n) => n.id === d.serviceDemandeurId)?.name ?? '—';
              const isSelected = selectedIds.has(d.id);
              const canDelete = !['en_route', 'arrive', 'mission_en_cours', 'terminee', 'retour', 'arrive_siege'].includes(d.statut);
              return (
                <div
                  key={d.id}
                  className="flex items-center gap-2 px-1"
                  style={{ borderLeft: `3px solid ${DEPLACEMENT_ETAPE_COLOR[d.statut]}` }}
                >
                  {selectMode && canDelete && (
                    <button
                      onClick={() => {
                        const next = new Set(selectedIds);
                        if (isSelected) next.delete(d.id); else next.add(d.id);
                        setSelectedIds(next);
                      }}
                      className="p-2 shrink-0"
                      style={{ color: isSelected ? '#6366f1' : 'var(--text-ter)' }}
                    >
                      {isSelected ? <CheckSquare size={16} /> : <Square size={16} />}
                    </button>
                  )}
                  <button
                    onClick={() => setSelectedId(d.id)}
                    className="flex-1 flex flex-wrap items-center gap-3 px-3 py-3 text-left transition-colors hover:bg-[var(--card-hover)]"
                  >
                    <span
                      className="w-2 h-2 rounded-full shrink-0"
                      style={{ background: DEPLACEMENT_ETAPE_COLOR[d.statut] }}
                    />
                    <span className="text-xs font-mono shrink-0" style={{ color: 'var(--text-ter)' }}>{d.numero}</span>
                    <span className="text-sm font-medium flex-1 min-w-40 truncate" style={{ color: 'var(--text-pri)' }}>{d.objet}</span>
                    {vehicule && <span className="text-xs hidden lg:inline font-mono" style={{ color: 'var(--text-ter)' }}>{vehicule.immatriculation}</span>}
                    {chauffeur && <span className="text-xs hidden lg:inline" style={{ color: 'var(--text-ter)' }}>{chauffeur.nom}</span>}
                    <span className="text-xs hidden md:inline" style={{ color: 'var(--text-ter)' }}>{serviceName}</span>
                    <span className="text-xs shrink-0" style={{ color: 'var(--text-ter)' }}>{d.dateDepart}</span>
                    <Badge tone={DEPLACEMENT_STATUT_TONE[d.statut]}>{DEPLACEMENT_STATUT_LABELS[d.statut]}</Badge>
                  </button>
                </div>
              );
            })}
          </div>
        </Card>
      )}

      {showCreate && (
        <Modal open onClose={() => setShowCreate(false)} title="Nouvel ordre de mission" width="md">
          <DeplacementForm onClose={() => setShowCreate(false)} />
        </Modal>
      )}

{selectedId != null && <DetailPanel id={selectedId} onClose={() => setSelectedId(null)} />}

      {confirmBulkDelete && (
        <Modal open onClose={() => setConfirmBulkDelete(false)} title={`Supprimer ${selectedIds.size} ordre(s) de mission ?`} width="sm">
          <p className="text-sm mb-4" style={{ color: 'var(--text-sec)' }}>
            Cette action est irréversible. Les ordres de mission en cours (En route, Arrivé, Mission en cours, etc.) ne seront pas supprimés.
          </p>
          <div className="flex justify-end gap-2">
            <Button variant="secondary" onClick={() => setConfirmBulkDelete(false)}>Annuler</Button>
            <Button variant="danger" onClick={async () => {
              setBulkDeleting(true);
              try {
                await bulkDeleteDeplacements(Array.from(selectedIds));
                setConfirmBulkDelete(false);
                setSelectedIds(new Set());
                setSelectMode(false);
              } catch {
                setError('Impossible de supprimer certains ordres de mission.');
              } finally {
                setBulkDeleting(false);
              }
            }} disabled={bulkDeleting}>
              {bulkDeleting ? 'Suppression…' : 'Supprimer'}
            </Button>
          </div>
        </Modal>
      )}
    </div>
  );
}
