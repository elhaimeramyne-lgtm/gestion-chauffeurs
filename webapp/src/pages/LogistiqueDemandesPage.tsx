import { useEffect, useMemo, useState } from 'react';
import { useSearchParams } from 'react-router-dom';
import {
  Plus, Search, RefreshCw, Phone, CalendarDays, Send, Clock, User as UserIcon
} from 'lucide-react';
import { PageHeader, Card, Badge, Button, Modal, EmptyState } from '../components/ui/Kit';
import { useLogistique } from '../context/LogistiqueContext';
import { useOrg } from '../context/OrgContext';
import { useAuth } from '../context/AuthContext';
import { TRANSITIONS } from '../lib/logistiqueWorkflow';
import {
  type ServiceRequest, type ServiceRequestEvent, type ServiceRequestType, type ServiceRequestPriority,
  type ServiceRequestStatus, TYPE_LABELS, PRIORITY_LABELS, STATUS_LABELS, STATUS_TONE, PRIORITY_TONE,
  STATUS_FLOW_ORDER
} from '../types/logistique';

const STATUS_TABS: { value: string; label: string }[] = [
  { value: '', label: 'Toutes' },
  ...STATUS_FLOW_ORDER.map((s) => ({ value: s, label: STATUS_LABELS[s] })),
  { value: 'annulee', label: 'Annulées' },
  { value: 'archivee', label: 'Archivées' }
];

function toDMY(iso: string): string {
  const [y, m, d] = iso.split('-');
  return `${d}/${m}/${y}`;
}
function formatDateTime(iso: string): string {
  return new Date(iso).toLocaleString('fr-FR', { day: '2-digit', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit' });
}

/* ── Formulaire de nouvelle demande ─────────────────────────────────── */
function CreateForm({ onClose, onCreated }: { onClose: () => void; onCreated: () => void }) {
  const { createDemande } = useLogistique();
  const { nodes } = useOrg();
  const [serviceDemandeurId, setServiceDemandeurId] = useState<number | ''>('');
  const [demandeurNom, setDemandeurNom] = useState('');
  const [demandeurTelephone, setDemandeurTelephone] = useState('');
  const [type, setType] = useState<ServiceRequestType>('autre');
  const [objet, setObjet] = useState('');
  const [description, setDescription] = useState('');
  const [priorite, setPriorite] = useState<ServiceRequestPriority>('normale');
  const [dateSouhaitee, setDateSouhaitee] = useState('');
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const sortedNodes = useMemo(() => [...nodes].sort((a, b) => a.name.localeCompare(b.name)), [nodes]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!serviceDemandeurId || !demandeurNom.trim() || !objet.trim()) return;
    setSaving(true);
    setError(null);
    try {
      await createDemande({
        serviceDemandeurId: Number(serviceDemandeurId),
        demandeurNom: demandeurNom.trim(),
        demandeurTelephone: demandeurTelephone.trim() || undefined,
        type,
        objet: objet.trim(),
        description: description.trim() || undefined,
        priorite,
        dateSouhaitee: dateSouhaitee ? toDMY(dateSouhaitee) : undefined
      });
      onCreated();
      onClose();
    } catch {
      setError("Impossible de créer la demande. Vérifiez les champs et réessayez.");
    } finally {
      setSaving(false);
    }
  };

  return (
    <form className="space-y-3" onSubmit={handleSubmit}>
      <label>
        <span>Service / Direction demandeur *</span>
        <select required value={serviceDemandeurId} onChange={(e) => setServiceDemandeurId(e.target.value ? Number(e.target.value) : '')}>
          <option value="">— Sélectionner —</option>
          {sortedNodes.map((n) => (
            <option key={n.id} value={n.id}>{n.name}</option>
          ))}
        </select>
      </label>

      <div className="grid grid-cols-2 gap-3">
        <label>
          <span>Nom du demandeur *</span>
          <input required value={demandeurNom} onChange={(e) => setDemandeurNom(e.target.value)} placeholder="Nom et prénom" />
        </label>
        <label>
          <span>Téléphone</span>
          <input value={demandeurTelephone} onChange={(e) => setDemandeurTelephone(e.target.value)} placeholder="0537…" />
        </label>
      </div>

      <div className="grid grid-cols-2 gap-3">
        <label>
          <span>Type de demande *</span>
          <select value={type} onChange={(e) => setType(e.target.value as ServiceRequestType)}>
            {(Object.keys(TYPE_LABELS) as ServiceRequestType[]).map((t) => (
              <option key={t} value={t}>{TYPE_LABELS[t]}</option>
            ))}
          </select>
        </label>
        <label>
          <span>Priorité</span>
          <select value={priorite} onChange={(e) => setPriorite(e.target.value as ServiceRequestPriority)}>
            {(Object.keys(PRIORITY_LABELS) as ServiceRequestPriority[]).map((p) => (
              <option key={p} value={p}>{PRIORITY_LABELS[p]}</option>
            ))}
          </select>
        </label>
      </div>

      <label>
        <span>Objet *</span>
        <input required value={objet} onChange={(e) => setObjet(e.target.value)} placeholder="Ex : Demande de véhicule pour mission" />
      </label>

      <label>
        <span>Description</span>
        <textarea rows={3} value={description} onChange={(e) => setDescription(e.target.value)} placeholder="Détails complémentaires…" />
      </label>

      <label>
        <span>Date souhaitée</span>
        <input type="date" value={dateSouhaitee} onChange={(e) => setDateSouhaitee(e.target.value)} />
      </label>

      {error && (
        <p className="text-xs rounded-lg px-3 py-2" style={{ color: 'var(--accent-err)', background: 'rgba(239,68,68,0.08)', border: '1px solid rgba(239,68,68,0.2)' }}>
          {error}
        </p>
      )}

      <div className="flex justify-end gap-2 pt-2">
        <Button variant="secondary" type="button" onClick={onClose}>Annuler</Button>
        <Button variant="primary" type="submit" disabled={saving}>
          <Send size={13} /> {saving ? 'Envoi…' : 'Soumettre la demande'}
        </Button>
      </div>
    </form>
  );
}

/* ── Panneau détail + workflow ──────────────────────────────────────── */
function DetailPanel({ id, onClose }: { id: number; onClose: () => void }) {
  const { fetchDetail, transitionStatut, agents } = useLogistique();
  const { nodes } = useOrg();
  const { hasMinRole } = useAuth();
  const [demande, setDemande] = useState<ServiceRequest | null>(null);
  const [events, setEvents] = useState<ServiceRequestEvent[]>([]);
  const [loading, setLoading] = useState(true);
  const [commentaire, setCommentaire] = useState('');
  const [agentAffecteId, setAgentAffecteId] = useState<number | ''>('');
  const [acting, setActing] = useState<ServiceRequestStatus | null>(null);
  const [error, setError] = useState<string | null>(null);

  const load = () => {
    setLoading(true);
    fetchDetail(id)
      .then((res) => { setDemande(res.demande); setEvents(res.events); })
      .catch(() => setError('Impossible de charger le détail de cette demande.'))
      .finally(() => setLoading(false));
  };

  useEffect(() => { load(); /* eslint-disable-next-line react-hooks/exhaustive-deps */ }, [id]);

  const serviceName = demande ? (nodes.find((n) => n.id === demande.serviceDemandeurId)?.name ?? '—') : '—';
  const agentName = demande?.agentAffecteId
    ? (agents.find((a) => a.id === demande.agentAffecteId)?.displayName ?? agents.find((a) => a.id === demande.agentAffecteId)?.username)
    : null;

  const transitions = demande ? TRANSITIONS[demande.statut] : [];
  const needsAgentPicker = transitions.some((t) => t.requiresAgent);

  const handleAction = async (to: ServiceRequestStatus, requiresAgent?: boolean) => {
    if (requiresAgent && !agentAffecteId) {
      setError('Merci de sélectionner un agent avant d\'affecter cette demande.');
      return;
    }
    setActing(to);
    setError(null);
    try {
      await transitionStatut(id, to, {
        commentaire: commentaire.trim() || undefined,
        agentAffecteId: agentAffecteId ? Number(agentAffecteId) : undefined
      });
      setCommentaire('');
      load();
    } catch {
      setError("Cette action a échoué. Vérifiez vos droits ou réessayez.");
    } finally {
      setActing(null);
    }
  };

  return (
    <Modal open onClose={onClose} title={demande ? demande.numero : 'Demande'} width="lg">
      {loading || !demande ? (
        <p className="text-sm py-8 text-center" style={{ color: 'var(--text-ter)' }}>Chargement…</p>
      ) : (
        <div className="space-y-5">
          <div className="flex flex-wrap items-center gap-2">
            <Badge tone={STATUS_TONE[demande.statut]}>{STATUS_LABELS[demande.statut]}</Badge>
            <Badge tone={PRIORITY_TONE[demande.priorite]}>{PRIORITY_LABELS[demande.priorite]}</Badge>
            <Badge>{TYPE_LABELS[demande.type]}</Badge>
          </div>

          <div>
            <h4 className="text-base font-bold" style={{ color: 'var(--text-pri)' }}>{demande.objet}</h4>
            {demande.description && (
              <p className="text-sm mt-1.5" style={{ color: 'var(--text-sec)' }}>{demande.description}</p>
            )}
          </div>

          <div className="grid grid-cols-2 gap-3 text-sm">
            <div>
              <p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Service demandeur</p>
              <p style={{ color: 'var(--text-pri)' }}>{serviceName}</p>
            </div>
            <div>
              <p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Demandeur</p>
              <p className="flex items-center gap-1.5" style={{ color: 'var(--text-pri)' }}>
                <UserIcon size={12} style={{ color: 'var(--text-ter)' }} /> {demande.demandeurNom}
                {demande.demandeurTelephone && (
                  <span className="flex items-center gap-1 ml-2 text-xs" style={{ color: 'var(--text-ter)' }}>
                    <Phone size={11} /> {demande.demandeurTelephone}
                  </span>
                )}
              </p>
            </div>
            {demande.dateSouhaitee && (
              <div>
                <p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Date souhaitée</p>
                <p className="flex items-center gap-1.5" style={{ color: 'var(--text-pri)' }}>
                  <CalendarDays size={12} style={{ color: 'var(--text-ter)' }} /> {demande.dateSouhaitee}
                </p>
              </div>
            )}
            {agentName && (
              <div>
                <p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Agent affecté</p>
                <p style={{ color: 'var(--text-pri)' }}>{agentName}</p>
              </div>
            )}
          </div>

          {/* Historique */}
          <div>
            <p className="text-xs font-semibold mb-2 flex items-center gap-1.5" style={{ color: 'var(--text-ter)' }}>
              <Clock size={12} /> Historique
            </p>
            <div className="space-y-2 max-h-48 overflow-y-auto pr-1">
              {events.map((e) => (
                <div key={e.id} className="flex items-start gap-2 text-xs rounded-lg px-3 py-2" style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}>
                  <Badge tone={STATUS_TONE[e.statut]} className="shrink-0">{STATUS_LABELS[e.statut]}</Badge>
                  <div className="min-w-0 flex-1">
                    {e.commentaire && <p style={{ color: 'var(--text-sec)' }}>{e.commentaire}</p>}
                    <p style={{ color: 'var(--text-ter)' }}>{e.actionPar} · {formatDateTime(e.createdAt)}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Actions workflow */}
          {transitions.length > 0 && (
            <div className="space-y-2 pt-3" style={{ borderTop: '1px solid var(--border)' }}>
              <label>
                <span>Commentaire (optionnel)</span>
                <textarea rows={2} value={commentaire} onChange={(e) => setCommentaire(e.target.value)} placeholder="Précision sur cette étape…" />
              </label>
              {needsAgentPicker && (
                <label>
                  <span>Agent à affecter</span>
                  <select value={agentAffecteId} onChange={(e) => setAgentAffecteId(e.target.value ? Number(e.target.value) : '')}>
                    <option value="">— Sélectionner un agent —</option>
                    {agents.map((a) => (
                      <option key={a.id} value={a.id}>{a.displayName || a.username}</option>
                    ))}
                  </select>
                </label>
              )}
              {error && (
                <p className="text-xs rounded-lg px-3 py-2" style={{ color: 'var(--accent-err)', background: 'rgba(239,68,68,0.08)', border: '1px solid rgba(239,68,68,0.2)' }}>
                  {error}
                </p>
              )}
              <div className="flex flex-wrap gap-2 justify-end">
                {transitions.map((t) => {
                  const allowed = hasMinRole(t.minRole);
                  return (
                    <Button
                      key={t.to}
                      variant={t.tone}
                      disabled={!allowed || acting !== null}
                      onClick={() => handleAction(t.to, t.requiresAgent)}
                    >
                      {acting === t.to ? 'En cours…' : t.label}
                      {!allowed && ' (droits insuffisants)'}
                    </Button>
                  );
                })}
              </div>
            </div>
          )}
        </div>
      )}
    </Modal>
  );
}

/* ── Page principale ─────────────────────────────────────────────────── */
export default function LogistiqueDemandesPage() {
  const [searchParams, setSearchParams] = useSearchParams();
  const { demandes, loading, error, setFilters, reload } = useLogistique();
  const { nodes } = useOrg();

  const [statutTab, setStatutTab] = useState(searchParams.get('statut') ?? '');
  const [priorite, setPriorite] = useState(searchParams.get('priorite') ?? '');
  const [search, setSearch] = useState(searchParams.get('q') ?? '');
  const [showCreate, setShowCreate] = useState(false);
  const [selectedId, setSelectedId] = useState<number | null>(null);

  useEffect(() => {
    setFilters({ statut: statutTab || undefined, priorite: priorite || undefined, search: search || undefined });
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
        title="Demandes de services"
        description="Toutes les demandes soumises par les directions et services de l'établissement."
        action={
          <Button variant="primary" onClick={() => setShowCreate(true)}>
            <Plus size={14} /> Nouvelle demande
          </Button>
        }
      />

      {/* Filtres */}
      <div className="flex flex-wrap items-center gap-2 mb-4">
        <div className="relative flex-1 min-w-48 max-w-72">
          <Search size={13} className="absolute left-3 top-1/2 -translate-y-1/2" style={{ color: 'var(--text-ter)' }} />
          <input
            value={search} onChange={(e) => setSearch(e.target.value)}
            placeholder="Rechercher (n°, objet, demandeur)…"
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
          {(Object.keys(PRIORITY_LABELS) as ServiceRequestPriority[]).map((p) => (
            <option key={p} value={p}>{PRIORITY_LABELS[p]}</option>
          ))}
        </select>
        <button onClick={reload}
          className="focus-ring flex items-center gap-1.5 text-xs px-3 py-2 rounded-xl transition-colors"
          style={{ background: 'var(--glass-bg)', border: '1px solid var(--border)', color: 'var(--text-sec)' }}>
          <RefreshCw size={12} /> Actualiser
        </button>
      </div>

      {/* Onglets statut */}
      <div className="flex flex-wrap gap-1.5 mb-5">
        {STATUS_TABS.map((tab) => (
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

      {/* Liste */}
      {!loading && demandes.length === 0 ? (
        <EmptyState
          title="Aucune demande"
          description="Aucune demande ne correspond aux filtres sélectionnés."
          action={<Button variant="primary" onClick={() => setShowCreate(true)}><Plus size={14} /> Créer une demande</Button>}
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
                  <span className="text-sm font-medium flex-1 min-w-40 truncate" style={{ color: 'var(--text-pri)' }}>{d.objet}</span>
                  <span className="text-xs hidden lg:inline" style={{ color: 'var(--text-ter)' }}>{serviceName}</span>
                  <Badge>{TYPE_LABELS[d.type]}</Badge>
                  <Badge tone={PRIORITY_TONE[d.priorite]}>{PRIORITY_LABELS[d.priorite]}</Badge>
                  <Badge tone={STATUS_TONE[d.statut]}>{STATUS_LABELS[d.statut]}</Badge>
                  <span className="text-xs shrink-0 hidden sm:inline" style={{ color: 'var(--text-ter)' }}>
                    {new Date(d.createdAt).toLocaleDateString('fr-FR')}
                  </span>
                </button>
              );
            })}
          </div>
        </Card>
      )}

      {showCreate && (
        <Modal open onClose={() => setShowCreate(false)} title="Nouvelle demande de service" width="md">
          <CreateForm onClose={() => setShowCreate(false)} onCreated={reload} />
        </Modal>
      )}

      {selectedId != null && <DetailPanel id={selectedId} onClose={() => { setSelectedId(null); reload(); }} />}
    </div>
  );
}
