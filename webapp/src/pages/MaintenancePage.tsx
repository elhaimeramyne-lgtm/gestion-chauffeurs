import { useEffect, useMemo, useRef, useState } from 'react';
import { useSearchParams } from 'react-router-dom';
import { Plus, Wrench, FileText, Upload, ExternalLink, Pencil, Trash2, CreditCard } from 'lucide-react';
import { PageHeader, Card, StatCard, Badge, Button, Modal, EmptyState } from '../components/ui/Kit';
import { useMaintenance } from '../context/MaintenanceContext';
import { useParcAuto } from '../context/ParcAutoContext';
import {
  type MaintenanceRecord, type MaintenanceType, type MaintenanceCreateInput,
  MAINTENANCE_TYPE_LABELS, MAINTENANCE_TYPE_COLOR
} from '../types/parcAuto';

const MAINTENANCE_TYPES_ORDER: MaintenanceType[] = [
  'vidange', 'pneus', 'batterie', 'freins', 'embrayage', 'courroie', 'reparation', 'accident', 'autre'
];

/* ── Formulaire intervention (création ou modification) ──────────────── */
function MaintenanceForm({ initial, defaultVehiculeId, onClose }: { initial?: MaintenanceRecord | null; defaultVehiculeId?: number | null; onClose: () => void }) {
  const { createMaintenance, updateMaintenance } = useMaintenance();
  const { vehicules } = useParcAuto();
  const [vehiculeId, setVehiculeId] = useState(initial ? String(initial.vehiculeId) : (defaultVehiculeId ? String(defaultVehiculeId) : ''));
  const [type, setType] = useState<MaintenanceType>(initial?.type ?? 'vidange');
  const [date, setDate] = useState('');
  const [kilometrage, setKilometrage] = useState(initial?.kilometrage != null ? String(initial.kilometrage) : '');
  const [garage, setGarage] = useState(initial?.garage ?? '');
  const [description, setDescription] = useState(initial?.description ?? '');
  const [piecesRemplacees, setPiecesRemplacees] = useState(initial?.piecesRemplacees ?? '');
  const [cout, setCout] = useState(initial?.cout != null ? String(initial.cout) : '0');
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const toDMY = (iso: string) => { const [y, m, d] = iso.split('-'); return `${d}/${m}/${y}`; };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!vehiculeId || (!initial && !date)) return;
    setSaving(true);
    setError(null);
    try {
      const commonPatch: Partial<MaintenanceCreateInput> = {
        type,
        kilometrage: kilometrage ? Number(kilometrage) : undefined,
        garage: garage.trim() || undefined,
        description: description.trim() || undefined,
        piecesRemplacees: piecesRemplacees.trim() || undefined,
        cout: cout ? Number(cout) : undefined
      };
      if (initial) {
        await updateMaintenance(initial.id, { ...commonPatch, date: date ? toDMY(date) : undefined });
      } else {
        await createMaintenance({ ...commonPatch, vehiculeId: Number(vehiculeId), type, date: toDMY(date) } as MaintenanceCreateInput);
      }
      onClose();
    } catch {
      setError("Impossible d'enregistrer cette intervention.");
    } finally {
      setSaving(false);
    }
  };

  return (
    <form className="space-y-3" onSubmit={handleSubmit}>
      <div className="grid grid-cols-2 gap-3">
        <label>
          <span>Véhicule *</span>
          <select required disabled={Boolean(initial)} value={vehiculeId} onChange={(e) => setVehiculeId(e.target.value)} className={initial ? 'opacity-60' : ''}>
            <option value="">— Choisir —</option>
            {vehicules.map((v) => (
              <option key={v.id} value={v.id}>{v.immatriculation} — {v.marque} {v.modele}</option>
            ))}
          </select>
        </label>
        <label>
          <span>Type d'intervention *</span>
          <select required value={type} onChange={(e) => setType(e.target.value as MaintenanceType)}>
            {MAINTENANCE_TYPES_ORDER.map((t) => (
              <option key={t} value={t}>{MAINTENANCE_TYPE_LABELS[t]}</option>
            ))}
          </select>
        </label>
      </div>
      <div className="grid grid-cols-2 gap-3">
        <label>
          <span>Date {initial?.date ? `(actuelle : ${initial.date})` : ''} {!initial && '*'}</span>
          <input required={!initial} type="date" value={date} onChange={(e) => setDate(e.target.value)} />
        </label>
        <label>
          <span>Kilométrage</span>
          <input type="number" min={0} value={kilometrage} onChange={(e) => setKilometrage(e.target.value)} placeholder="125000" />
        </label>
      </div>
      <div className="grid grid-cols-2 gap-3">
        <label>
          <span>Garage / prestataire</span>
          <input value={garage} onChange={(e) => setGarage(e.target.value)} placeholder="Garage Al Amal" />
        </label>
        <label>
          <span>Dépense (DH)</span>
          <input type="number" min={0} step="0.01" value={cout} onChange={(e) => setCout(e.target.value)} />
        </label>
      </div>
      <label>
        <span>Pièces remplacées</span>
        <input value={piecesRemplacees} onChange={(e) => setPiecesRemplacees(e.target.value)} placeholder="Plaquettes, disques, filtre à huile…" />
      </label>
      <label>
        <span>Description</span>
        <textarea rows={2} value={description} onChange={(e) => setDescription(e.target.value)} placeholder="Détails de l'intervention…" />
      </label>
      {error && (
        <p className="text-xs rounded-lg px-3 py-2" style={{ color: 'var(--accent-err)', background: 'rgba(239,68,68,0.08)', border: '1px solid rgba(239,68,68,0.2)' }}>{error}</p>
      )}
      <div className="flex justify-end gap-2 pt-2">
        <Button variant="secondary" type="button" onClick={onClose}>Annuler</Button>
        <Button variant="primary" type="submit" disabled={saving}>
          <Plus size={13} /> {saving ? 'Enregistrement…' : initial ? 'Enregistrer' : "Ajouter l'intervention"}
        </Button>
      </div>
    </form>
  );
}

/* ── Détail d'une intervention (documents, factures, édition) ────────── */
function MaintenanceDetail({ record, onClose }: { record: MaintenanceRecord; onClose: () => void }) {
  const { deleteMaintenance, uploadDocument, deleteDocument } = useMaintenance();
  const [editing, setEditing] = useState(false);
  const [confirmDelete, setConfirmDelete] = useState(false);
  const [uploading, setUploading] = useState<'facture' | 'document' | null>(null);
  const [error, setError] = useState<string | null>(null);
  const factureInputRef = useRef<HTMLInputElement>(null);
  const documentInputRef = useRef<HTMLInputElement>(null);

  const handleUpload = async (type: 'facture' | 'document', file: File) => {
    setUploading(type);
    try { await uploadDocument(record.id, type, file); } catch { setError("Échec de l'envoi du fichier."); } finally { setUploading(null); }
  };
  const handleDeleteDoc = async (docId: number) => {
    try { await deleteDocument(record.id, docId); } catch { setError('Impossible de supprimer ce document.'); }
  };
  const handleDelete = async () => {
    try { await deleteMaintenance(record.id); onClose(); } catch { setError('Impossible de supprimer cette intervention.'); setConfirmDelete(false); }
  };

  if (editing) {
    return (
      <Modal open onClose={() => setEditing(false)} title="Modifier l'intervention" width="md">
        <MaintenanceForm initial={record} onClose={() => { setEditing(false); onClose(); }} />
      </Modal>
    );
  }

  return (
    <Modal open onClose={onClose} title={`${MAINTENANCE_TYPE_LABELS[record.type]} — ${record.vehicule?.immatriculation ?? ''}`} width="md">
      <div className="space-y-4">
        <div className="flex items-center justify-between">
          <Badge>{record.date}</Badge>
          <div className="flex items-center gap-1">
            <button title="Modifier" className="tbl-btn focus-ring" onClick={() => setEditing(true)}><Pencil size={14} /></button>
            <button title="Supprimer" className="tbl-btn danger focus-ring" onClick={() => setConfirmDelete(true)}><Trash2 size={14} /></button>
          </div>
        </div>

        {error && (
          <p className="text-xs rounded-lg px-3 py-2" style={{ color: 'var(--accent-err)', background: 'rgba(239,68,68,0.08)', border: '1px solid rgba(239,68,68,0.2)' }}>{error}</p>
        )}

        <div className="grid grid-cols-2 gap-3 text-sm">
          {record.vehicule && (
            <div className="col-span-2"><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Véhicule</p><p className="font-mono" style={{ color: 'var(--text-pri)' }}>{record.vehicule.immatriculation} — {record.vehicule.marque} {record.vehicule.modele}</p></div>
          )}
          {record.kilometrage != null && (
            <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Kilométrage</p><p style={{ color: 'var(--text-pri)' }}>{record.kilometrage.toLocaleString('fr-FR')} km</p></div>
          )}
          <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Dépense</p><p style={{ color: 'var(--text-pri)' }}>{record.cout.toLocaleString('fr-FR')} DH</p></div>
          {record.garage && (
            <div className="col-span-2"><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Garage</p><p style={{ color: 'var(--text-pri)' }}>{record.garage}</p></div>
          )}
          {record.piecesRemplacees && (
            <div className="col-span-2"><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>Pièces remplacées</p><p style={{ color: 'var(--text-pri)' }}>{record.piecesRemplacees}</p></div>
          )}
        </div>
        {record.description && <p className="text-sm" style={{ color: 'var(--text-sec)' }}>{record.description}</p>}

        <div className="pt-3" style={{ borderTop: '1px solid var(--border)' }}>
          <p className="text-xs font-semibold mb-2 flex items-center gap-1.5" style={{ color: 'var(--text-ter)' }}><FileText size={12} /> Factures & documents</p>
          <div className="space-y-1.5 mb-2">
            {record.documents.map((doc) => (
              <div key={doc.id} className="flex items-center justify-between text-xs rounded-lg px-3 py-2" style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}>
                <span className="flex items-center gap-1.5 min-w-0" style={{ color: 'var(--text-sec)' }}>
                  <Badge tone={doc.type === 'facture' ? 'info' : 'default'}>{doc.type === 'facture' ? 'Facture' : 'Document'}</Badge>
                  <span className="truncate">{doc.originalName ?? doc.filename}</span>
                </span>
                <div className="flex items-center gap-2 shrink-0">
                  <a href={doc.url} target="_blank" rel="noreferrer" title="Voir" style={{ color: '#6366f1' }}><ExternalLink size={13} /></a>
                  <button title="Supprimer" onClick={() => handleDeleteDoc(doc.id)} style={{ color: 'var(--accent-err)' }}><Trash2 size={13} /></button>
                </div>
              </div>
            ))}
            {record.documents.length === 0 && <p className="text-xs" style={{ color: 'var(--text-ter)' }}>Aucun document joint.</p>}
          </div>
          <div className="flex flex-wrap gap-2">
            <Button variant="secondary" type="button" onClick={() => factureInputRef.current?.click()}>
              <Upload size={12} /> {uploading === 'facture' ? '…' : 'Joindre une facture'}
            </Button>
            <Button variant="secondary" type="button" onClick={() => documentInputRef.current?.click()}>
              <Upload size={12} /> {uploading === 'document' ? '…' : 'Joindre un document'}
            </Button>
            <input ref={factureInputRef} type="file" accept="image/*,application/pdf" hidden onChange={(e) => e.target.files?.[0] && handleUpload('facture', e.target.files[0])} />
            <input ref={documentInputRef} type="file" accept="image/*,application/pdf" hidden onChange={(e) => e.target.files?.[0] && handleUpload('document', e.target.files[0])} />
          </div>
        </div>
      </div>

      {confirmDelete && (
        <Modal open onClose={() => setConfirmDelete(false)} title="Supprimer cette intervention ?" width="sm">
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

export default function MaintenancePage() {
  const { maintenances, loading } = useMaintenance();
  const { vehicules } = useParcAuto();
  const [searchParams, setSearchParams] = useSearchParams();
  const vehiculeIdParam = searchParams.get('vehiculeId');
  const [vehiculeFilter, setVehiculeFilter] = useState(vehiculeIdParam ?? '');
  const [typeTab, setTypeTab] = useState<MaintenanceType | ''>('');
  const [showForm, setShowForm] = useState(false);
  const [selectedId, setSelectedId] = useState<number | null>(null);

  useEffect(() => { if (vehiculeIdParam) setVehiculeFilter(vehiculeIdParam); }, [vehiculeIdParam]);

  const filtered = useMemo(() => {
    return maintenances.filter((m) => {
      if (vehiculeFilter && String(m.vehiculeId) !== vehiculeFilter) return false;
      if (typeTab && m.type !== typeTab) return false;
      return true;
    });
  }, [maintenances, vehiculeFilter, typeTab]);

  const totalDepense = useMemo(() => filtered.reduce((sum, m) => sum + m.cout, 0), [filtered]);
  const totalDocuments = useMemo(() => filtered.reduce((sum, m) => sum + m.documents.length, 0), [filtered]);
  const filterVehicule = vehiculeFilter ? vehicules.find((v) => String(v.id) === vehiculeFilter) : null;
  const selected = selectedId != null ? maintenances.find((m) => m.id === selectedId) ?? null : null;

  return (
    <div>
      <PageHeader
        eyebrow="Service de la Logistique et des Moyens Généraux"
        title="Maintenance"
        description={filterVehicule
          ? `Historique d'entretien de ${filterVehicule.immatriculation} — ${filterVehicule.marque} ${filterVehicule.modele}.`
          : "Historique complet d'entretien et de réparations de l'ensemble du parc : pneus, batterie, freins, embrayage, courroie, réparations, accidents…"}
        action={<Button variant="primary" onClick={() => setShowForm(true)}><Plus size={14} /> Nouvelle intervention</Button>}
      />

      <div className="grid grid-cols-2 md:grid-cols-3 gap-3 mb-6">
        <StatCard label="Interventions" value={filtered.length} icon={<Wrench size={16} />} color="blue" />
        <StatCard label="Dépense totale" value={`${totalDepense.toLocaleString('fr-FR')} DH`} icon={<CreditCard size={16} />} color="orange" />
        <StatCard label="Documents joints" value={totalDocuments} icon={<FileText size={16} />} color="violet" />
      </div>

      <div className="flex flex-wrap items-center gap-2 mb-4">
        <select
          value={vehiculeFilter}
          onChange={(e) => { setVehiculeFilter(e.target.value); setSearchParams(e.target.value ? { vehiculeId: e.target.value } : {}); }}
          className="text-sm px-3 py-2 rounded-xl outline-none min-w-56"
          style={{ background: 'var(--glass-bg)', border: '1px solid var(--border)', color: 'var(--text-pri)' }}
        >
          <option value="">Tous les véhicules</option>
          {vehicules.map((v) => (
            <option key={v.id} value={v.id}>{v.immatriculation} — {v.marque} {v.modele}</option>
          ))}
        </select>
      </div>

      <div className="flex flex-wrap gap-1.5 mb-5">
        {[{ value: '' as const, label: 'Tous' }, ...MAINTENANCE_TYPES_ORDER.map((t) => ({ value: t, label: MAINTENANCE_TYPE_LABELS[t] }))].map((tab) => (
          <button
            key={tab.value}
            onClick={() => setTypeTab(tab.value)}
            className="text-xs px-3 py-1.5 rounded-full transition-colors"
            style={{
              background: typeTab === tab.value ? 'rgba(99,102,241,0.14)' : 'var(--glass-bg)',
              border: `1px solid ${typeTab === tab.value ? 'rgba(99,102,241,0.35)' : 'var(--border)'}`,
              color: typeTab === tab.value ? '#6366f1' : 'var(--text-sec)'
            }}
          >
            {tab.label}
          </button>
        ))}
      </div>

      {!loading && filtered.length === 0 ? (
        <EmptyState
          title="Aucune intervention"
          description="Aucune intervention de maintenance ne correspond aux filtres sélectionnés."
          action={<Button variant="primary" onClick={() => setShowForm(true)}><Plus size={14} /> Ajouter une intervention</Button>}
        />
      ) : (
        <div className="space-y-2">
          {filtered.map((m) => (
            <Card key={m.id} className="p-4 cursor-pointer transition-colors hover:bg-[var(--card-hover)]" onClick={() => setSelectedId(m.id)}>
              <div className="flex items-center gap-3">
                <div className="w-1.5 self-stretch rounded-full shrink-0" style={{ background: MAINTENANCE_TYPE_COLOR[m.type] }} />
                <div className="min-w-0 flex-1">
                  <div className="flex items-center gap-2 flex-wrap">
                    <p className="text-sm font-semibold" style={{ color: 'var(--text-pri)' }}>{MAINTENANCE_TYPE_LABELS[m.type]}</p>
                    <span className="text-xs" style={{ color: 'var(--text-ter)' }}>{m.date}</span>
                    {!vehiculeFilter && m.vehicule && <Badge className="font-mono">{m.vehicule.immatriculation}</Badge>}
                  </div>
                  <p className="text-xs truncate" style={{ color: 'var(--text-sec)' }}>
                    {[m.garage, m.kilometrage != null ? `${m.kilometrage.toLocaleString('fr-FR')} km` : null, m.description].filter(Boolean).join(' · ') || 'Aucun détail renseigné'}
                  </p>
                </div>
                <div className="text-right shrink-0">
                  <p className="text-sm font-semibold" style={{ color: 'var(--text-pri)' }}>{m.cout.toLocaleString('fr-FR')} DH</p>
                  {m.documents.length > 0 && (
                    <p className="text-xs flex items-center gap-1 justify-end" style={{ color: 'var(--text-ter)' }}><FileText size={10} /> {m.documents.length}</p>
                  )}
                </div>
              </div>
            </Card>
          ))}
        </div>
      )}

      {showForm && (
        <Modal open onClose={() => setShowForm(false)} title="Nouvelle intervention" width="md">
          <MaintenanceForm defaultVehiculeId={vehiculeFilter ? Number(vehiculeFilter) : null} onClose={() => setShowForm(false)} />
        </Modal>
      )}

      {selected && <MaintenanceDetail record={selected} onClose={() => setSelectedId(null)} />}
    </div>
  );
}
