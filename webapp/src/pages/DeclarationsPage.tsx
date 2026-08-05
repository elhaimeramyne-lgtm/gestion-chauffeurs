import { useEffect, useMemo, useState } from 'react';
import { AlertOctagon, Car, User as UserIcon, Image as ImageIcon, Video, ExternalLink, History } from 'lucide-react';
import { PageHeader, Card, StatCard, Badge, Button, Modal, EmptyState } from '../components/ui/Kit';
import { useDeclarations } from '../context/DeclarationContext';
import {
  type Declaration, type DeclarationStatut,
  DECLARATION_CATEGORIE_LABELS, DECLARATION_URGENCE_LABELS, DECLARATION_URGENCE_TONE,
  DECLARATION_STATUTS, DECLARATION_STATUT_LABELS, DECLARATION_STATUT_TONE
} from '../types/parcAuto';

const STATUT_TABS: { value: DeclarationStatut | ''; label: string }[] = [
  { value: '', label: 'Toutes' },
  { value: 'nouvelle', label: 'Nouvelles' },
  { value: 'en_cours', label: 'En cours' },
  { value: 'validee', label: 'Validées' },
  { value: 'reparation_programmee', label: 'Réparation programmée' },
  { value: 'terminee', label: 'Terminées' },
  { value: 'archivee', label: 'Archivées' }
];

/** Prochain statut logique dans le workflow (peut être ignoré au profit d'un autre choix). */
function statutSuivant(statut: DeclarationStatut): DeclarationStatut | null {
  const idx = DECLARATION_STATUTS.indexOf(statut);
  return idx >= 0 && idx < DECLARATION_STATUTS.length - 1 ? DECLARATION_STATUTS[idx + 1] : null;
}

function DeclarationDetail({ declarationId, onClose }: { declarationId: number; onClose: () => void }) {
  const { fetchDeclarationDetail, updateStatut } = useDeclarations();
  const [declaration, setDeclaration] = useState<Declaration | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [commentaire, setCommentaire] = useState('');
  const [acting, setActing] = useState(false);

  const load = () => {
    setLoading(true);
    fetchDeclarationDetail(declarationId)
      .then(setDeclaration)
      .catch(() => setError('Impossible de charger cette déclaration.'))
      .finally(() => setLoading(false));
  };
  useEffect(() => { load(); /* eslint-disable-next-line react-hooks/exhaustive-deps */ }, [declarationId]);

  const handleTransition = async (statut: DeclarationStatut) => {
    setActing(true);
    setError(null);
    try {
      await updateStatut(declarationId, statut, commentaire.trim() || undefined);
      setCommentaire('');
      load();
    } catch {
      setError('Impossible de mettre à jour le statut.');
    } finally {
      setActing(false);
    }
  };

  const suivant = declaration ? statutSuivant(declaration.statut) : null;

  return (
    <Modal open onClose={onClose} title={declaration ? `${DECLARATION_CATEGORIE_LABELS[declaration.categorie]} — ${declaration.vehicule?.immatriculation ?? ''}` : 'Déclaration'} width="lg">
      {loading || !declaration ? (
        <p className="text-sm py-8 text-center" style={{ color: 'var(--text-ter)' }}>Chargement…</p>
      ) : (
        <div className="space-y-4">
          <div className="flex flex-wrap items-center gap-2">
            <Badge tone={DECLARATION_STATUT_TONE[declaration.statut]}>{DECLARATION_STATUT_LABELS[declaration.statut]}</Badge>
            <Badge tone={DECLARATION_URGENCE_TONE[declaration.urgence]}>{DECLARATION_URGENCE_LABELS[declaration.urgence]}</Badge>
            <Badge>{DECLARATION_CATEGORIE_LABELS[declaration.categorie]}</Badge>
          </div>

          {error && (
            <p className="text-xs rounded-lg px-3 py-2" style={{ color: 'var(--accent-err)', background: 'rgba(239,68,68,0.08)', border: '1px solid rgba(239,68,68,0.2)' }}>{error}</p>
          )}

          <div className="grid grid-cols-2 gap-3 text-sm">
            {declaration.vehicule && (
              <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}><Car size={10} className="inline mr-1" />Véhicule</p><p className="font-mono" style={{ color: 'var(--text-pri)' }}>{declaration.vehicule.immatriculation} — {declaration.vehicule.marque} {declaration.vehicule.modele}</p></div>
            )}
            {declaration.chauffeur && (
              <div><p className="text-[11px] uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}><UserIcon size={10} className="inline mr-1" />Chauffeur</p><p style={{ color: 'var(--text-pri)' }}>{declaration.chauffeur.nom}</p></div>
            )}
          </div>

          {declaration.description && (
            <p className="text-sm rounded-lg px-3 py-2.5" style={{ color: 'var(--text-sec)', background: 'var(--bg)' }}>{declaration.description}</p>
          )}

          {declaration.media && declaration.media.length > 0 && (
            <div>
              <p className="text-xs font-semibold mb-2" style={{ color: 'var(--text-ter)' }}>Photos / vidéo</p>
              <div className="grid grid-cols-3 gap-2">
                {declaration.media.map((m) => (
                  <a key={m.id} href={m.url} target="_blank" rel="noreferrer" className="rounded-lg overflow-hidden flex flex-col items-center justify-center gap-1 py-4 focus-ring" style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}>
                    {m.type === 'video' ? <Video size={18} style={{ color: 'var(--text-ter)' }} /> : <ImageIcon size={18} style={{ color: 'var(--text-ter)' }} />}
                    <span className="text-[10px] flex items-center gap-1" style={{ color: 'var(--text-ter)' }}><ExternalLink size={9} /> Ouvrir</span>
                  </a>
                ))}
              </div>
            </div>
          )}

          <div className="pt-3" style={{ borderTop: '1px solid var(--border)' }}>
            <p className="text-xs font-semibold mb-2" style={{ color: 'var(--text-ter)' }}>Traitement</p>
            <textarea rows={2} value={commentaire} onChange={(e) => setCommentaire(e.target.value)} placeholder="Commentaire (facultatif)…" className="mb-2" />
            <div className="flex flex-wrap gap-2">
              {suivant && (
                <Button variant="primary" onClick={() => handleTransition(suivant)} disabled={acting}>
                  → {DECLARATION_STATUT_LABELS[suivant]}
                </Button>
              )}
              {DECLARATION_STATUTS.filter((s) => s !== declaration.statut && s !== suivant).map((s) => (
                <Button key={s} variant="secondary" onClick={() => handleTransition(s)} disabled={acting}>
                  {DECLARATION_STATUT_LABELS[s]}
                </Button>
              ))}
            </div>
          </div>

          {declaration.events && declaration.events.length > 0 && (
            <div className="pt-3" style={{ borderTop: '1px solid var(--border)' }}>
              <p className="text-xs font-semibold mb-2 flex items-center gap-1.5" style={{ color: 'var(--text-ter)' }}><History size={12} /> Historique</p>
              <div className="space-y-1.5">
                {declaration.events.map((ev) => (
                  <div key={ev.id} className="text-xs flex items-center justify-between rounded-lg px-3 py-2" style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}>
                    <span style={{ color: 'var(--text-sec)' }}>{DECLARATION_STATUT_LABELS[ev.statut]} {ev.commentaire ? `— ${ev.commentaire}` : ''}</span>
                    <span style={{ color: 'var(--text-ter)' }}>{ev.actionPar} · {new Date(ev.createdAt).toLocaleString('fr-FR', { day: '2-digit', month: 'short', hour: '2-digit', minute: '2-digit' })}</span>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>
      )}
    </Modal>
  );
}

export default function DeclarationsPage() {
  const { declarations, loading } = useDeclarations();
  const [statutTab, setStatutTab] = useState<DeclarationStatut | ''>('');
  const [selectedId, setSelectedId] = useState<number | null>(null);

  const filtered = useMemo(() => {
    return declarations.filter((d) => (statutTab ? d.statut === statutTab : d.statut !== 'archivee'));
  }, [declarations, statutTab]);

  const urgentesCount = declarations.filter((d) => d.statut !== 'terminee' && d.statut !== 'archivee' && (d.urgence === 'urgent' || d.urgence === 'critique')).length;

  return (
    <div>
      <PageHeader
        eyebrow="Service de la Logistique et des Moyens Généraux"
        title="Déclarations chauffeur"
        description="Problèmes signalés par les chauffeurs depuis leur portail — traitement et suivi jusqu'à résolution."
      />

      <div className="grid grid-cols-2 md:grid-cols-3 gap-3 mb-6">
        <StatCard label="Nouvelles" value={declarations.filter((d) => d.statut === 'nouvelle').length} tone={declarations.some((d) => d.statut === 'nouvelle') ? 'bad' : 'default'} icon={<AlertOctagon size={15} />} />
        <StatCard label="Urgentes / critiques" value={urgentesCount} tone={urgentesCount > 0 ? 'bad' : 'default'} icon={<AlertOctagon size={15} />} />
        <StatCard label="En traitement" value={declarations.filter((d) => ['en_cours', 'validee', 'reparation_programmee'].includes(d.statut)).length} icon={<History size={15} />} />
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
        <EmptyState title="Aucune déclaration" description="Aucune déclaration ne correspond aux filtres sélectionnés." />
      ) : (
        <div className="space-y-2">
          {filtered.map((d) => (
            <Card key={d.id} className="p-4 cursor-pointer transition-colors hover:bg-[var(--card-hover)]" onClick={() => setSelectedId(d.id)}>
              <div className="flex items-center gap-3">
                <div className="w-1.5 self-stretch rounded-full shrink-0" style={{ background: d.urgence === 'critique' ? 'var(--accent-err)' : d.urgence === 'urgent' ? 'var(--accent-warn)' : '#60a5fa' }} />
                <div className="min-w-0 flex-1">
                  <div className="flex items-center gap-2 flex-wrap">
                    <p className="text-sm font-semibold" style={{ color: 'var(--text-pri)' }}>{DECLARATION_CATEGORIE_LABELS[d.categorie]}</p>
                    {d.vehicule && <Badge className="font-mono">{d.vehicule.immatriculation}</Badge>}
                    <Badge tone={DECLARATION_URGENCE_TONE[d.urgence]}>{DECLARATION_URGENCE_LABELS[d.urgence]}</Badge>
                  </div>
                  <p className="text-xs truncate" style={{ color: 'var(--text-sec)' }}>
                    {d.chauffeur?.nom ?? 'Chauffeur inconnu'} · {d.description || 'Aucune description'}
                  </p>
                </div>
                <div className="text-right shrink-0">
                  <Badge tone={DECLARATION_STATUT_TONE[d.statut]}>{DECLARATION_STATUT_LABELS[d.statut]}</Badge>
                  {(d.mediaCount ?? 0) > 0 && (
                    <p className="text-xs flex items-center gap-1 justify-end mt-1" style={{ color: 'var(--text-ter)' }}><ImageIcon size={10} /> {d.mediaCount}</p>
                  )}
                </div>
              </div>
            </Card>
          ))}
        </div>
      )}

      {selectedId != null && <DeclarationDetail declarationId={selectedId} onClose={() => setSelectedId(null)} />}
    </div>
  );
}
