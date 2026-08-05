/**
 * OrganigrammePage — Gestion dynamique de la structure organisationnelle.
 *
 * Fonctionnalités :
 *  - Arbre visuel hiérarchique (Direction → Sous-Dir → Division → Service)
 *  - Clic sur une unité : fiche détail (chef, téléphone, notes, unités rattachées)
 *  - Modifier nom, chef, téléphone, notes, parent (transfert de service)
 *  - Ajouter une unité rattachée, supprimer une unité (avec confirmation)
 *  - Export de l'organigramme en JSON
 */
import { useEffect, useMemo, useState } from 'react';
import {
  Building2, ChevronRight, ChevronDown, Phone, User, Edit3, Plus, Trash2,
  Save, X, AlertTriangle, Download, Search, RefreshCw, MoveRight, ImageIcon, List,
  ArrowUp, ArrowDown, CornerUpLeft, CornerDownRight, Move
} from 'lucide-react';
import { useOrg, type OrgNode, type OrgNodeTree, type OrgNodeType, type OrgPatchInput } from '../context/OrgContext';
import { useAuth } from '../context/AuthContext';
import { PageHeader, Card } from '../components/ui/Kit';
import {
  moveUp as computeMoveUp,
  moveDown as computeMoveDown,
  promoteLevel as computePromoteLevel,
  demoteIntoPreviousSibling as computeDemote,
  moveToParent as computeMoveToParent,
  getDescendantIds,
  buildTreeFromNodes,
} from '../lib/orgTreeOps';

/* ── Constantes ─────────────────────────────────────────────────── */
const TYPE_LABELS: Record<OrgNodeType | string, string> = {
  direction: 'Direction',
  'sous-direction': 'Sous-Direction',
  division: 'Division',
  service: 'Service',
  inspection: 'Inspection',
  entite: 'Entité rattachée',
};
const TYPE_COLORS: Record<string, string> = {
  direction:       '#00d4ff',
  'sous-direction':'#a855f7',
  division:        'var(--accent2)',
  service:         'var(--accent-warn)',
  inspection:      'var(--accent-err)',
  entite:          '#94a3b8',
};
const TYPE_BG: Record<string, string> = {
  direction:       'rgba(0,212,255,0.10)',
  'sous-direction':'rgba(168,85,247,0.10)',
  division:        'rgba(34,197,94,0.10)',
  service:         'rgba(245,158,11,0.10)',
  inspection:      'rgba(239,68,68,0.10)',
  entite:          'rgba(148,163,184,0.08)',
};
const CHILD_TYPES: Record<string, OrgNodeType[]> = {
  direction:       ['sous-direction', 'inspection', 'entite'],
  'sous-direction':['division', 'service'],
  division:        ['service'],
  service:         [],
  inspection:      ['division', 'service'],
  entite:          ['division', 'service'],
};

/* ── Badge type ──────────────────────────────────────────────────── */
function TypeBadge({ type }: { type: string }) {
  return (
    <span
      className="inline-flex items-center rounded-full px-2 py-0.5 text-[10px] font-semibold uppercase tracking-wide"
      style={{ background: TYPE_BG[type], color: TYPE_COLORS[type], border: `1px solid ${TYPE_COLORS[type]}30` }}
    >
      {TYPE_LABELS[type] ?? type}
    </span>
  );
}

/* ── Sélecteur "Déplacer vers…" ─────────────────────────────────────
 * Modale légère listant toutes les unités valides comme nouveau parent
 * (exclut l'unité elle-même, ses unités rattachées, et son parent actuel). */
function MoveToPicker({ node, allNodes, onPick, onClose }: {
  node: OrgNode;
  allNodes: OrgNode[];
  onPick: (newParentId: number) => void;
  onClose: () => void;
}) {
  const [q, setQ] = useState('');
  const excluded = new Set<number>([node.id, ...getDescendantIds(allNodes, node.id)]);
  if (node.parentId !== null) excluded.add(node.parentId);
  const candidates = allNodes
    .filter((n) => !excluded.has(n.id))
    .filter((n) => !q.trim() || n.name.toLowerCase().includes(q.toLowerCase()))
    .sort((a, b) => a.name.localeCompare(b.name));

  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center p-4"
      style={{ background: 'rgba(0,0,0,0.6)', backdropFilter: 'blur(4px)' }}
      onClick={onClose}
    >
      <div
        className="w-full max-w-md rounded-2xl p-4"
        style={{ background: 'var(--surface)', border: '1px solid var(--border)', boxShadow: '0 20px 60px rgba(0,0,0,0.5)' }}
        onClick={(e) => e.stopPropagation()}
      >
        <div className="flex items-center justify-between mb-3">
          <h3 className="text-sm font-semibold" style={{ color: 'var(--text-pri)' }}>
            Déplacer « {node.name} » vers…
          </h3>
          <button onClick={onClose} className="p-1 rounded-lg hover:bg-[var(--card-hover)]" style={{ color: 'var(--text-ter)' }}>
            <X size={14} />
          </button>
        </div>
        <div className="relative mb-3">
          <Search size={13} className="absolute left-3 top-1/2 -translate-y-1/2" style={{ color: 'var(--text-ter)' }} />
          <input
            autoFocus value={q} onChange={(e) => setQ(e.target.value)}
            placeholder="Chercher un nouvel emplacement…"
            className="w-full text-sm pl-8 pr-3 py-2 rounded-lg outline-none"
            style={{ background: 'var(--bg)', border: '1px solid var(--border)', color: 'var(--text-pri)' }}
          />
        </div>
        <div className="max-h-72 overflow-y-auto space-y-1">
          {candidates.length === 0 && (
            <p className="text-xs text-center py-6" style={{ color: 'var(--text-ter)' }}>Aucun emplacement trouvé.</p>
          )}
          {candidates.map((n) => (
            <button
              key={n.id}
              onClick={() => onPick(n.id)}
              className="w-full flex items-center gap-2 text-left px-2.5 py-2 rounded-lg transition-colors hover:bg-[var(--card-hover)]"
            >
              <span className="rounded-full shrink-0" style={{ width: 6, height: 6, background: TYPE_COLORS[n.type] ?? '#94a3b8' }} />
              <TypeBadge type={n.type} />
              <span className="text-sm truncate" style={{ color: 'var(--text-pri)' }}>{n.name}</span>
            </button>
          ))}
        </div>
      </div>
    </div>
  );
}

/* ── Unité de l'arbre ────────────────────────────────────────────── */
function TreeNode({
  node, depth, selected, onSelect, expandedIds, toggleExpand
}: {
  node: OrgNodeTree;
  depth: number;
  selected: number | null;
  onSelect: (n: OrgNode) => void;
  expandedIds: Set<number>;
  toggleExpand: (id: number) => void;
}) {
  const isExpanded = expandedIds.has(node.id);
  const hasChildren = node.children.length > 0;
  const isSelected = selected === node.id;
  const color = TYPE_COLORS[node.type] ?? '#94a3b8';

  const { isAdmin } = useAuth();
  const { nodes, reorderNodes } = useOrg();
  const [showMovePicker, setShowMovePicker] = useState(false);

  const isRoot = node.parentId === null;
  const siblings = nodes.filter((n) => n.parentId === node.parentId).sort((a, b) => a.sortOrder - b.sortOrder);
  const idx = siblings.findIndex((n) => n.id === node.id);
  const isFirst = idx <= 0;
  const isLast = idx === siblings.length - 1;
  const parent = node.parentId !== null ? nodes.find((n) => n.id === node.parentId) : undefined;
  const canPromote = !!parent && parent.parentId !== null;

  const runUpdates = (updates: ReturnType<typeof computeMoveUp>) => {
    if (updates.length > 0) reorderNodes(updates).catch(() => {});
  };

  return (
    <div>
      <div
        className="flex items-center gap-1.5 cursor-pointer rounded-lg px-2 py-1.5 group transition-all"
        style={{
          marginLeft: depth * 16,
          background: isSelected ? `${color}15` : 'transparent',
          border: `1px solid ${isSelected ? color + '40' : 'transparent'}`,
        }}
        onClick={() => onSelect(node)}
      >
        {/* Toggle expand */}
        <button
          className="shrink-0 flex items-center justify-center rounded transition-colors hover:bg-[var(--card-hover)]"
          style={{ width: 18, height: 18, opacity: hasChildren ? 1 : 0.2 }}
          onClick={(e) => { e.stopPropagation(); if (hasChildren) toggleExpand(node.id); }}
        >
          {hasChildren
            ? (isExpanded ? <ChevronDown size={11} /> : <ChevronRight size={11} />)
            : <span style={{ width: 11, height: 11, display: 'block', borderLeft: `2px solid ${color}`, borderBottom: `2px solid ${color}`, borderRadius: '0 0 0 3px', margin: '0 0 0 3px' }} />
          }
        </button>

        {/* Dot couleur */}
        <span className="rounded-full shrink-0" style={{ width: 7, height: 7, background: color, boxShadow: `0 0 5px ${color}60` }} />

        {/* Nom */}
        <span
          className="flex-1 text-sm leading-snug truncate"
          style={{ color: isSelected ? color : 'var(--text-pri)', fontWeight: isSelected ? 600 : 400 }}
        >
          {node.name}
        </span>

        {/* Badges infos */}
        <div className="shrink-0 flex items-center gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
          {node.telephone && <Phone size={10} style={{ color: 'var(--text-ter)' }} />}
          {node.chefNom   && <User  size={10} style={{ color: 'var(--text-ter)' }} />}
        </div>

        {/* Actions de repositionnement (admin uniquement) */}
        {isAdmin && !isRoot && (
          <div
            className="shrink-0 flex items-center gap-0.5 opacity-0 group-hover:opacity-100 focus-within:opacity-100 transition-opacity"
            onClick={(e) => e.stopPropagation()}
          >
            <button
              title="Monter (même niveau)"
              disabled={isFirst}
              onClick={() => runUpdates(computeMoveUp(nodes, node.id))}
              className="p-1 rounded-md transition-colors hover:bg-[var(--card-hover)] disabled:opacity-20 disabled:pointer-events-none"
              style={{ color: 'var(--text-sec)' }}
            >
              <ArrowUp size={12} />
            </button>
            <button
              title="Descendre (même niveau)"
              disabled={isLast}
              onClick={() => runUpdates(computeMoveDown(nodes, node.id))}
              className="p-1 rounded-md transition-colors hover:bg-[var(--card-hover)] disabled:opacity-20 disabled:pointer-events-none"
              style={{ color: 'var(--text-sec)' }}
            >
              <ArrowDown size={12} />
            </button>
            <button
              title="Remonter d'un niveau hiérarchique"
              disabled={!canPromote}
              onClick={() => runUpdates(computePromoteLevel(nodes, node.id))}
              className="p-1 rounded-md transition-colors hover:bg-[var(--card-hover)] disabled:opacity-20 disabled:pointer-events-none"
              style={{ color: 'var(--text-sec)' }}
            >
              <CornerUpLeft size={12} />
            </button>
            <button
              title="Rattacher au frère précédent"
              disabled={isFirst}
              onClick={() => runUpdates(computeDemote(nodes, node.id))}
              className="p-1 rounded-md transition-colors hover:bg-[var(--card-hover)] disabled:opacity-20 disabled:pointer-events-none"
              style={{ color: 'var(--text-sec)' }}
            >
              <CornerDownRight size={12} />
            </button>
            <button
              title="Déplacer vers un autre emplacement…"
              onClick={() => setShowMovePicker(true)}
              className="p-1 rounded-md transition-colors hover:bg-[var(--card-hover)]"
              style={{ color: 'var(--accent)' }}
            >
              <Move size={12} />
            </button>
          </div>
        )}
      </div>

      {showMovePicker && (
        <MoveToPicker
          node={node}
          allNodes={nodes}
          onClose={() => setShowMovePicker(false)}
          onPick={(newParentId) => {
            runUpdates(computeMoveToParent(nodes, node.id, newParentId));
            setShowMovePicker(false);
          }}
        />
      )}

      {/* Unités rattachées */}
      {isExpanded && hasChildren && (
        <div className="animate-fade-in">
          {node.children.map((child) => (
            <TreeNode
              key={child.id}
              node={child}
              depth={depth + 1}
              selected={selected}
              onSelect={onSelect}
              expandedIds={expandedIds}
              toggleExpand={toggleExpand}
            />
          ))}
        </div>
      )}
    </div>
  );
}

/* ── Formulaire d'édition ─────────────────────────────────────────── */
interface EditFormProps {
  node: OrgNode;
  allNodes: OrgNode[];
  onSave: (patch: OrgPatchInput) => void;
  onCancel: () => void;
  saving: boolean;
}
function EditForm({ node, allNodes, onSave, onCancel, saving }: EditFormProps) {
  const [name, setName] = useState(node.name);
  const [chefNom, setChefNom] = useState(node.chefNom ?? '');
  const [telephone, setTelephone] = useState(node.telephone ?? '');
  const [notes, setNotes] = useState(node.notes ?? '');
  const [parentId, setParentId] = useState<number | null>(node.parentId);

  // Empêcher de choisir un descendant comme parent
  const forbidden = new Set<number>();
  function collectDesc(id: number) {
    forbidden.add(id);
    allNodes.filter((n) => n.parentId === id).forEach((c) => collectDesc(c.id));
  }
  collectDesc(node.id);

  const validParents = allNodes.filter(
    (n) => !forbidden.has(n.id) && n.id !== node.id
  );

  return (
    <form
      className="space-y-3"
      onSubmit={(e) => {
        e.preventDefault();
        onSave({
          name: name.trim(),
          chefNom: chefNom.trim() || null,
          telephone: telephone.trim() || null,
          notes: notes.trim() || null,
          parentId,
        });
      }}
    >
      <div>
        <label className="text-xs mb-1 block" style={{ color: 'var(--text-ter)' }}>Nom *</label>
        <input
          required value={name} onChange={(e) => setName(e.target.value)}
          className="w-full text-sm rounded-lg px-3 py-2 outline-none"
          style={{ background: 'var(--bg)', border: '1px solid var(--border)', color: 'var(--text-pri)' }}
        />
      </div>
      <div className="grid grid-cols-2 gap-3">
        <div>
          <label className="text-xs mb-1 block" style={{ color: 'var(--text-ter)' }}>Chef / Responsable</label>
          <input
            value={chefNom} onChange={(e) => setChefNom(e.target.value)} placeholder="Nom et prénom"
            className="w-full text-sm rounded-lg px-3 py-2 outline-none"
            style={{ background: 'var(--bg)', border: '1px solid var(--border)', color: 'var(--text-pri)' }}
          />
        </div>
        <div>
          <label className="text-xs mb-1 block" style={{ color: 'var(--text-ter)' }}>Téléphone</label>
          <input
            value={telephone} onChange={(e) => setTelephone(e.target.value)} placeholder="0537…"
            className="w-full text-sm rounded-lg px-3 py-2 outline-none"
            style={{ background: 'var(--bg)', border: '1px solid var(--border)', color: 'var(--text-pri)' }}
          />
        </div>
      </div>
      {/* Transfert vers une autre division/sous-direction */}
      {node.type === 'service' && (
        <div>
          <label className="text-xs mb-1 flex items-center gap-1" style={{ color: 'var(--text-ter)' }}>
            <MoveRight size={11} /> Transférer vers (parent)
          </label>
          <select
            value={parentId ?? ''}
            onChange={(e) => setParentId(e.target.value ? Number(e.target.value) : null)}
            className="w-full text-sm rounded-lg px-3 py-2 outline-none"
            style={{ background: 'var(--bg)', border: '1px solid var(--border)', color: 'var(--text-pri)' }}
          >
            <option value="">— Aucun parent —</option>
            {validParents
              .filter((n) => ['sous-direction', 'division', 'inspection', 'entite'].includes(n.type))
              .map((n) => (
                <option key={n.id} value={n.id}>
                  [{TYPE_LABELS[n.type]}] {n.name}
                </option>
              ))}
          </select>
        </div>
      )}
      <div>
        <label className="text-xs mb-1 block" style={{ color: 'var(--text-ter)' }}>Notes internes</label>
        <textarea
          value={notes} onChange={(e) => setNotes(e.target.value)} rows={2} placeholder="Observations, informations complémentaires…"
          className="w-full text-sm rounded-lg px-3 py-2 outline-none resize-none"
          style={{ background: 'var(--bg)', border: '1px solid var(--border)', color: 'var(--text-pri)' }}
        />
      </div>
      <div className="flex gap-2 justify-end">
        <button type="button" onClick={onCancel}
          className="focus-ring text-xs px-3 py-1.5 rounded-lg transition-colors"
          style={{ background: 'var(--bg)', border: '1px solid var(--border)', color: 'var(--text-sec)' }}>
          Annuler
        </button>
        <button type="submit" disabled={saving}
          className="focus-ring flex items-center gap-1.5 text-xs px-3 py-1.5 rounded-lg font-semibold transition-colors disabled:opacity-40"
          style={{ background: 'var(--grad-btn)', color: '#fff' }}>
          <Save size={12} /> {saving ? 'Enregistrement…' : 'Enregistrer'}
        </button>
      </div>
    </form>
  );
}

/* ── Formulaire de rattachement d'une unité ─────────────────────────────────── */
function AddChildForm({ parentNode, onAdd, onCancel }: {
  parentNode: OrgNode;
  onAdd: (type: OrgNodeType, name: string) => void;
  onCancel: () => void;
}) {
  const possibleTypes = CHILD_TYPES[parentNode.type] ?? [];
  const [type, setType] = useState<OrgNodeType>(possibleTypes[0] ?? 'service');
  const [name, setName] = useState('');
  if (possibleTypes.length === 0) return null;
  return (
    <form
      className="mt-3 rounded-xl p-3 space-y-2"
      style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}
      onSubmit={(e) => { e.preventDefault(); if (name.trim()) { onAdd(type, name.trim()); setName(''); } }}
    >
      <p className="text-xs font-semibold" style={{ color: 'var(--accent)' }}>Ajouter une unité rattachée</p>
      <div className="grid grid-cols-2 gap-2">
        <select value={type} onChange={(e) => setType(e.target.value as OrgNodeType)}
          className="text-xs rounded-lg px-2 py-1.5 outline-none"
          style={{ background: 'var(--bg)', border: '1px solid var(--border)', color: 'var(--text-pri)' }}>
          {possibleTypes.map((t) => <option key={t} value={t}>{TYPE_LABELS[t]}</option>)}
        </select>
        <input required value={name} onChange={(e) => setName(e.target.value)}
          placeholder="Nom de l'unité"
          className="text-xs rounded-lg px-2 py-1.5 outline-none"
          style={{ background: 'var(--bg)', border: '1px solid var(--border)', color: 'var(--text-pri)' }} />
      </div>
      <div className="flex gap-2">
        <button type="button" onClick={onCancel}
          className="focus-ring text-xs px-2 py-1 rounded-lg" style={{ color: 'var(--text-ter)' }}>Annuler</button>
        <button type="submit"
          className="focus-ring text-xs px-3 py-1 rounded-lg font-semibold"
          style={{ background: 'rgba(34,197,94,0.12)', border: '1px solid rgba(34,197,94,0.3)', color: 'var(--accent2)' }}>
          <Plus size={10} className="inline mr-1" />Ajouter
        </button>
      </div>
    </form>
  );
}

/* ── Panel détail d'une unité ───────────────────────────────────── */
function NodeDetail({ node, allNodes, onClose }: {
  node: OrgNode;
  allNodes: OrgNode[];
  onClose: () => void;
}) {
  const { patchNode, deleteNode, createNode, reload } = useOrg();
  const { isAdmin } = useAuth();
  const [editing, setEditing] = useState(false);
  const [addingChild, setAddingChild] = useState(false);
  const [saving, setSaving] = useState(false);
  const [confirmDelete, setConfirmDelete] = useState(false);
  const [localNode, setLocalNode] = useState(node);

  // Resync si l'unité sélectionnée change
  useEffect(() => { setLocalNode(node); setEditing(false); setAddingChild(false); setConfirmDelete(false); }, [node]);

  const children = allNodes.filter((n) => n.parentId === node.id);
  const parent = node.parentId ? allNodes.find((n) => n.id === node.parentId) : null;
  const color = TYPE_COLORS[node.type] ?? '#94a3b8';

  const handleSave = async (patch: OrgPatchInput) => {
    setSaving(true);
    try {
      const updated = await patchNode(node.id, patch);
      setLocalNode(updated);
      setEditing(false);
    } finally { setSaving(false); }
  };

  const handleAddChild = async (type: OrgNodeType, name: string) => {
    await createNode({ type, name, parentId: node.id });
    setAddingChild(false);
    reload();
  };

  const handleDelete = async () => {
    await deleteNode(node.id);
    onClose();
  };

  return (
    <div className="flex flex-col h-full">
      {/* En-tête */}
      <div className="px-5 py-4 shrink-0" style={{ borderBottom: '1px solid var(--border)' }}>
        <div className="flex items-start justify-between gap-2">
          <div className="flex-1 min-w-0">
            <TypeBadge type={localNode.type} />
            <h2 className="text-base font-bold mt-1.5 leading-tight" style={{ color: 'var(--text-pri)' }}>
              {localNode.name}
            </h2>
            {parent && (
              <p className="text-xs mt-0.5" style={{ color: 'var(--text-ter)' }}>
                ↳ {parent.name}
              </p>
            )}
          </div>
          <button onClick={onClose} className="focus-ring p-1.5 rounded-lg transition-colors hover:bg-[var(--card-hover)] shrink-0"
            style={{ color: 'var(--text-ter)' }}>
            <X size={14} />
          </button>
        </div>
      </div>

      {/* Corps */}
      <div className="flex-1 overflow-y-auto px-5 py-4 space-y-4">
        {editing ? (
          <EditForm
            node={localNode}
            allNodes={allNodes}
            onSave={handleSave}
            onCancel={() => setEditing(false)}
            saving={saving}
          />
        ) : (
          <>
            {/* Informations */}
            <div className="space-y-2.5">
              <InfoRow icon={<User size={13} />} label="Chef / Responsable" value={localNode.chefNom} />
              <InfoRow icon={<Phone size={13} />} label="Téléphone" value={localNode.telephone} />
              {localNode.notes && (
                <div className="rounded-lg p-3" style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}>
                  <p className="text-xs mb-1" style={{ color: 'var(--text-ter)' }}>Notes</p>
                  <p className="text-sm" style={{ color: 'var(--text-sec)' }}>{localNode.notes}</p>
                </div>
              )}
            </div>

            {/* Unités rattachées directes */}
            {children.length > 0 && (
              <div>
                <p className="text-xs font-semibold mb-2" style={{ color: 'var(--text-ter)' }}>
                  {children.length} élément(s) rattaché(s)
                </p>
                <div className="space-y-1">
                  {children.map((c) => (
                    <div key={c.id} className="flex items-center gap-2 rounded-lg px-3 py-2"
                      style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}>
                      <span className="rounded-full shrink-0"
                        style={{ width: 6, height: 6, background: TYPE_COLORS[c.type] ?? '#94a3b8' }} />
                      <span className="text-sm flex-1 truncate" style={{ color: 'var(--text-pri)' }}>{c.name}</span>
                      <TypeBadge type={c.type} />
                    </div>
                  ))}
                </div>
              </div>
            )}

            {/* Actions admin */}
            {isAdmin && (
              <div className="space-y-2 pt-2" style={{ borderTop: '1px solid var(--border)' }}>
                <div className="flex gap-2 flex-wrap">
                  <button onClick={() => setEditing(true)}
                    className="focus-ring flex items-center gap-1.5 text-xs px-3 py-1.5 rounded-lg transition-colors"
                    style={{ background: 'rgba(34,211,238,0.08)', border: '1px solid rgba(34,211,238,0.25)', color: 'var(--accent)' }}>
                    <Edit3 size={12} /> Modifier
                  </button>
                  {CHILD_TYPES[localNode.type]?.length > 0 && (
                    <button onClick={() => setAddingChild(true)}
                      className="focus-ring flex items-center gap-1.5 text-xs px-3 py-1.5 rounded-lg transition-colors"
                      style={{ background: 'rgba(34,197,94,0.08)', border: '1px solid rgba(34,197,94,0.25)', color: 'var(--accent2)' }}>
                      <Plus size={12} /> Ajouter une unité rattachée
                    </button>
                  )}
                  {localNode.type !== 'direction' && (
                    <button onClick={() => setConfirmDelete(true)}
                      className="focus-ring flex items-center gap-1.5 text-xs px-3 py-1.5 rounded-lg transition-colors"
                      style={{ background: 'rgba(239,68,68,0.08)', border: '1px solid rgba(239,68,68,0.25)', color: 'var(--accent-err)' }}>
                      <Trash2 size={12} /> Supprimer
                    </button>
                  )}
                </div>
                {addingChild && (
                  <AddChildForm parentNode={localNode} onAdd={handleAddChild} onCancel={() => setAddingChild(false)} />
                )}
                {confirmDelete && (
                  <div className="rounded-xl p-3 space-y-2"
                    style={{ background: 'rgba(239,68,68,0.06)', border: '1px solid rgba(239,68,68,0.25)' }}>
                    <div className="flex items-center gap-2">
                      <AlertTriangle size={14} style={{ color: 'var(--accent-err)' }} />
                      <p className="text-xs font-semibold" style={{ color: 'var(--accent-err)' }}>
                        Supprimer « {localNode.name} » et tous ses éléments ?
                      </p>
                    </div>
                    <p className="text-xs" style={{ color: 'var(--text-ter)' }}>
                      Cette action supprimera aussi toutes les unités rattachées (divisions, services). Elle est irréversible.
                    </p>
                    <div className="flex gap-2">
                      <button onClick={() => setConfirmDelete(false)}
                        className="focus-ring text-xs px-3 py-1.5 rounded-lg"
                        style={{ background: 'var(--bg)', border: '1px solid var(--border)', color: 'var(--text-sec)' }}>
                        Annuler
                      </button>
                      <button onClick={handleDelete}
                        className="focus-ring text-xs px-3 py-1.5 rounded-lg font-semibold"
                        style={{ background: 'var(--accent-err)', color: '#fff' }}>
                        Confirmer la suppression
                      </button>
                    </div>
                  </div>
                )}
              </div>
            )}
          </>
        )}
      </div>
    </div>
  );
}

/* ── Ligne info ──────────────────────────────────────────────────── */
function InfoRow({ icon, label, value }: { icon: React.ReactNode; label: string; value: string | null | undefined }) {
  if (!value) return (
    <div className="flex items-center gap-2">
      <span style={{ color: 'var(--text-ter)' }}>{icon}</span>
      <span className="text-xs" style={{ color: 'var(--text-ter)' }}>{label} : —</span>
    </div>
  );
  return (
    <div className="flex items-start gap-2">
      <span className="mt-0.5" style={{ color: 'var(--accent)' }}>{icon}</span>
      <div>
        <p className="text-[11px]" style={{ color: 'var(--text-ter)' }}>{label}</p>
        <p className="text-sm font-medium" style={{ color: 'var(--text-pri)' }}>{value}</p>
      </div>
    </div>
  );
}

/* ── Page principale ─────────────────────────────────────────────── */
export default function OrganigrammePage() {
  const { nodes, loading, error, reload, createNode } = useOrg();
  const { isAdmin } = useAuth();
  const [selected, setSelected] = useState<OrgNode | null>(null);
  const [expandedIds, setExpandedIds] = useState<Set<number>>(new Set());
  const [search, setSearch] = useState('');
  const [addingRoot, setAddingRoot] = useState(false);
  const [newRootName, setNewRootName] = useState('');
  const [view, setView] = useState<'tree' | 'schema'>('tree');

  // Arbre reconstruit à partir de la liste plate `nodes`, qui elle est
  // mise à jour de façon optimiste dès qu'on clique une flèche. Ça
  // garantit un déplacement visible immédiatement, sans attendre le
  // prochain rechargement serveur.
  const tree = useMemo(() => buildTreeFromNodes(nodes), [nodes]);

  // Expand automatique des ancêtres de l'unité sélectionnée
  useEffect(() => {
    if (!selected) return;
    const toExpand = new Set<number>();
    let cur: OrgNode | undefined = selected;
    while (cur?.parentId) {
      toExpand.add(cur.parentId);
      cur = nodes.find((n) => n.id === cur!.parentId);
    }
    setExpandedIds((prev) => new Set([...prev, ...toExpand]));
  }, [selected, nodes]);

  // Expand tout au chargement initial
  useEffect(() => {
    if (nodes.length > 0 && expandedIds.size === 0) {
      setExpandedIds(new Set(nodes.filter((n) => ['direction', 'sous-direction', 'inspection', 'entite'].includes(n.type)).map((n) => n.id)));
    }
  }, [nodes]);

  const toggleExpand = (id: number) => {
    setExpandedIds((prev) => {
      const next = new Set(prev);
      next.has(id) ? next.delete(id) : next.add(id);
      return next;
    });
  };

  // Filtrage par recherche
  const filteredTree = search.trim().length >= 2
    ? filterTree(tree, search.toLowerCase())
    : tree;

  function filterTree(nodes: OrgNodeTree[], q: string): OrgNodeTree[] {
    return nodes
      .map((n) => ({ ...n, children: filterTree(n.children, q) }))
      .filter((n) => n.name.toLowerCase().includes(q) || n.children.length > 0 || (n.chefNom ?? '').toLowerCase().includes(q));
  }

  const handleExport = () => {
    const blob = new Blob([JSON.stringify(tree, null, 2)], { type: 'application/json' });
    const a = document.createElement('a');
    a.href = URL.createObjectURL(blob);
    a.download = `organigramme-${new Date().toISOString().slice(0, 10)}.json`;
    a.click();
  };

  return (
    <div>
      <PageHeader
        eyebrow="Structure organisationnelle"
        title="Organigramme"
        description="Gérez la hiérarchie complète de la Direction : sous-directions, divisions et services. Toute la plateforme utilise cette structure comme source de vérité."
      />

      {/* Onglets Vue arbre / Schéma officiel */}
      <div className="flex gap-1 mb-5" style={{ borderBottom: '1px solid var(--border)' }}>
        {([
          { id: 'tree',   label: 'Arbre interactif', icon: List },
          { id: 'schema', label: 'Schéma officiel',  icon: ImageIcon },
        ] as const).map(({ id, label, icon: Icon }) => (
          <button
            key={id}
            onClick={() => setView(id)}
            className="focus-ring flex items-center gap-1.5 px-4 py-2.5 text-sm font-medium border-b-2 -mb-px transition-colors"
            style={{
              borderBottomColor: view === id ? 'var(--accent)' : 'transparent',
              color: view === id ? 'var(--accent)' : 'var(--text-sec)',
            }}
          >
            <Icon size={14} />
            {label}
          </button>
        ))}
      </div>

      {/* ── Vue Schéma officiel ─────────────────────────────────────── */}
      {view === 'schema' && (
        <div
          className="rounded-2xl overflow-hidden"
          style={{ background: 'var(--glass-bg)', border: '1px solid var(--border)' }}
        >
          <div className="px-4 py-3 flex items-center justify-between" style={{ borderBottom: '1px solid var(--border)' }}>
            <div className="flex items-center gap-2">
              <ImageIcon size={14} style={{ color: 'var(--accent)' }} />
              <span className="text-sm font-semibold" style={{ color: 'var(--text-pri)' }}>
                Organigramme officiel — Entraide Nationale
              </span>
            </div>
            <a
              href="/organigramme.jpg"
              download="organigramme-entraide-nationale.jpg"
              className="focus-ring flex items-center gap-1.5 text-xs px-3 py-1.5 rounded-lg transition-colors"
              style={{ background: 'rgba(34,211,238,0.08)', border: '1px solid rgba(34,211,238,0.25)', color: 'var(--accent)' }}
            >
              <Download size={12} /> Télécharger
            </a>
          </div>
          <div className="p-4 overflow-auto">
            <img
              src="/organigramme.jpg"
              alt="Organigramme officiel Entraide Nationale"
              className="w-full rounded-xl"
              style={{ maxWidth: '100%', cursor: 'zoom-in' }}
              onClick={(e) => {
                const img = e.currentTarget;
                if (img.style.maxWidth === '100%') {
                  img.style.maxWidth = 'none';
                  img.style.cursor = 'zoom-out';
                } else {
                  img.style.maxWidth = '100%';
                  img.style.cursor = 'zoom-in';
                }
              }}
            />
            <p className="text-xs text-center mt-2" style={{ color: 'var(--text-ter)' }}>
              Cliquez sur l'image pour zoomer / dézoomer
            </p>
          </div>
        </div>
      )}

      {/* ── Vue Arbre interactif ────────────────────────────────────── */}
      {view === 'tree' && (<>
      <div className="flex flex-wrap items-center gap-3 mb-5">
        <div className="relative flex-1 min-w-48 max-w-64">
          <Search size={13} className="absolute left-3 top-1/2 -translate-y-1/2" style={{ color: 'var(--text-ter)' }} />
          <input
            value={search} onChange={(e) => setSearch(e.target.value)}
            placeholder="Rechercher une unité…"
            className="w-full text-sm pl-9 pr-3 py-2 rounded-xl outline-none"
            style={{ background: 'var(--glass-bg)', border: '1px solid var(--border)', color: 'var(--text-pri)' }}
          />
        </div>
        <button onClick={reload}
          className="focus-ring flex items-center gap-1.5 text-xs px-3 py-2 rounded-xl transition-colors"
          style={{ background: 'var(--glass-bg)', border: '1px solid var(--border)', color: 'var(--text-sec)' }}>
          <RefreshCw size={12} /> Actualiser
        </button>
        <button onClick={handleExport}
          className="focus-ring flex items-center gap-1.5 text-xs px-3 py-2 rounded-xl transition-colors"
          style={{ background: 'var(--glass-bg)', border: '1px solid var(--border)', color: 'var(--text-sec)' }}>
          <Download size={12} /> Export JSON
        </button>
        {isAdmin && (
          <button onClick={() => setAddingRoot(true)}
            className="focus-ring flex items-center gap-1.5 text-xs px-3 py-2 rounded-xl font-semibold transition-colors"
            style={{ background: 'rgba(34,197,94,0.08)', border: '1px solid rgba(34,197,94,0.3)', color: 'var(--accent2)' }}>
            <Plus size={12} /> Nouvelle entité racine
          </button>
        )}
      </div>

      {/* Légende types */}
      <div className="flex flex-wrap gap-2 mb-4">
        {Object.entries(TYPE_LABELS).map(([t, label]) => (
          <span key={t} className="flex items-center gap-1.5 text-[11px] px-2 py-0.5 rounded-full"
            style={{ background: TYPE_BG[t], color: TYPE_COLORS[t], border: `1px solid ${TYPE_COLORS[t]}30` }}>
            <span className="rounded-full" style={{ width: 5, height: 5, background: TYPE_COLORS[t] }} />
            {label}
          </span>
        ))}
      </div>

      {isAdmin && (
        <div
          className="flex flex-wrap items-center gap-x-3 gap-y-1 mb-4 text-[11px] px-3 py-2 rounded-lg"
          style={{ background: 'var(--glass-bg)', border: '1px solid var(--border)', color: 'var(--text-ter)' }}
        >
          <span style={{ color: 'var(--text-sec)' }}>Au survol d'une unité :</span>
          <span className="flex items-center gap-1"><ArrowUp size={11} /> monter</span>
          <span className="flex items-center gap-1"><ArrowDown size={11} /> descendre</span>
          <span className="flex items-center gap-1"><CornerUpLeft size={11} /> remonter d'un niveau</span>
          <span className="flex items-center gap-1"><CornerDownRight size={11} /> rattacher au frère précédent</span>
          <span className="flex items-center gap-1"><Move size={11} /> déplacer vers n'importe quel emplacement</span>
        </div>
      )}

      {error && (
        <p className="text-sm rounded-lg px-3 py-2 mb-4"
          style={{ color: 'var(--accent-err)', background: 'rgba(239,68,68,0.08)', border: '1px solid rgba(239,68,68,0.2)' }}>
          {error}
        </p>
      )}

      {/* Layout arbre + détail */}
      <div className="flex gap-4" style={{ minHeight: 600 }}>
        {/* Colonne arbre */}
        <div className="flex-1 min-w-0">
          <Card className="h-full overflow-hidden flex flex-col">
            <div className="px-4 py-3 shrink-0 flex items-center justify-between"
              style={{ borderBottom: '1px solid var(--border)' }}>
              <div className="flex items-center gap-2">
                <Building2 size={15} style={{ color: 'var(--accent)' }} />
                <span className="text-sm font-semibold" style={{ color: 'var(--text-pri)' }}>
                  {nodes.length} unités
                </span>
              </div>
              {loading && <span className="text-xs animate-pulse" style={{ color: 'var(--text-ter)' }}>Chargement…</span>}
            </div>
            <div className="flex-1 overflow-y-auto p-3 space-y-0.5">
              {filteredTree.map((node) => (
                <TreeNode
                  key={node.id}
                  node={node}
                  depth={0}
                  selected={selected?.id ?? null}
                  onSelect={(n) => setSelected(n)}
                  expandedIds={expandedIds}
                  toggleExpand={toggleExpand}
                />
              ))}
              {filteredTree.length === 0 && !loading && (
                <p className="text-sm text-center py-12" style={{ color: 'var(--text-ter)' }}>
                  {search ? 'Aucune unité ne correspond à la recherche.' : 'Organigramme vide.'}
                </p>
              )}
            </div>

            {/* Formulaire ajout entité racine */}
            {addingRoot && (
              <div className="px-4 py-3 shrink-0" style={{ borderTop: '1px solid var(--border)' }}>
                <form className="flex gap-2 items-center"
                  onSubmit={async (e) => {
                    e.preventDefault();
                    if (newRootName.trim()) {
                      await createNode({ type: 'sous-direction', name: newRootName.trim(), parentId: undefined });
                      setNewRootName('');
                      setAddingRoot(false);
                    }
                  }}>
                  <input autoFocus value={newRootName} onChange={(e) => setNewRootName(e.target.value)}
                    placeholder="Nom de l'entité racine"
                    className="flex-1 text-sm rounded-lg px-3 py-1.5 outline-none"
                    style={{ background: 'var(--bg)', border: '1px solid var(--border)', color: 'var(--text-pri)' }} />
                  <button type="submit"
                    className="focus-ring text-xs px-3 py-1.5 rounded-lg font-semibold"
                    style={{ background: 'rgba(34,197,94,0.12)', border: '1px solid rgba(34,197,94,0.3)', color: 'var(--accent2)' }}>
                    Ajouter
                  </button>
                  <button type="button" onClick={() => setAddingRoot(false)}
                    className="focus-ring text-xs px-2 py-1.5 rounded-lg"
                    style={{ color: 'var(--text-ter)' }}>
                    <X size={12} />
                  </button>
                </form>
              </div>
            )}
          </Card>
        </div>

        {/* Panel détail (slide-in) */}
        {selected && (
          <div
            className="shrink-0 animate-fade-in"
            style={{
              width: 'min(380px, calc(50vw - 20px))',
              borderRadius: 16,
              overflow: 'hidden',
              background: 'var(--surface)',
              border: `1px solid ${TYPE_COLORS[selected.type] ?? 'var(--border)'}40`,
              boxShadow: `0 4px 32px rgba(0,0,0,0.3), 0 0 0 1px ${TYPE_COLORS[selected.type] ?? '#94a3b8'}15 inset`,
              display: 'flex',
              flexDirection: 'column',
            }}
          >
            <NodeDetail
              node={nodes.find((n) => n.id === selected.id) ?? selected}
              allNodes={nodes}
              onClose={() => setSelected(null)}
            />
          </div>
        )}
      </div>
      </>)}
    </div>
  );
}
