/**
 * orgTreeOps — calcule les listes de mises à jour {id, parentId, sortOrder}
 * à envoyer à `reorderNodes` pour déplacer une unité dans l'organigramme.
 *
 * Toutes les fonctions sont pures : elles prennent la liste plate actuelle
 * des unités et renvoient uniquement les changements nécessaires, sans
 * muter quoi que ce soit. Ça permet de les tester facilement et de garder
 * la logique métier hors des composants React.
 */
import type { OrgNode, OrgNodeTree } from '../context/OrgContext';

export type ReorderUpdate = { id: number; parentId: number | null; sortOrder: number };

/** Reconstruit l'arbre hiérarchique à partir de la liste plate des unités.
 *  Utilisé pour un rendu instantané après une mise à jour optimiste
 *  (monter/descendre/déplacer), sans attendre le prochain aller-retour
 *  serveur — évite l'effet "ça ne bouge pas" le temps du round-trip. */
export function buildTreeFromNodes(nodes: OrgNode[], parentId: number | null = null): OrgNodeTree[] {
  return nodes
    .filter((n) => n.parentId === parentId)
    .sort((a, b) => a.sortOrder - b.sortOrder)
    .map((n) => ({ ...n, children: buildTreeFromNodes(nodes, n.id) }));
}

function siblingsOf(nodes: OrgNode[], parentId: number | null): OrgNode[] {
  return nodes
    .filter((n) => n.parentId === parentId)
    // Tri stable : sortOrder d'abord, id en repli pour départager les
    // valeurs identiques/dupliquées (ex : unités ajoutés manuellement qui
    // démarrent tous à 0).
    .sort((a, b) => a.sortOrder - b.sortOrder || a.id - b.id);
}

/** Renvoie les mises à jour de sortOrder pour renuméroter proprement
 *  (0, 1, 2, …) une liste de frères déjà triée. */
function reindexUpdates(sorted: OrgNode[]): ReorderUpdate[] {
  return sorted.map((n, i) => ({ id: n.id, parentId: n.parentId, sortOrder: i }));
}

/** Échange la position de l'unité avec celle de son frère précédent, puis
 *  renumérote toute la fratrie (0, 1, 2…). Renuméroter systématiquement
 *  — plutôt que d'échanger seulement les deux valeurs de sortOrder —
 *  évite tout blocage si des frères partagent déjà le même sortOrder
 *  (données historiques, unités ajoutés manuellement, etc.). */
export function moveUp(nodes: OrgNode[], nodeId: number): ReorderUpdate[] {
  const node = nodes.find((n) => n.id === nodeId);
  if (!node) return [];
  const siblings = siblingsOf(nodes, node.parentId);
  const idx = siblings.findIndex((n) => n.id === nodeId);
  if (idx <= 0) return [];
  const reordered = [...siblings];
  [reordered[idx - 1], reordered[idx]] = [reordered[idx], reordered[idx - 1]];
  return reindexUpdates(reordered);
}

/** Échange la position de l'unité avec celle de son frère suivant, puis
 *  renumérote toute la fratrie. Voir note sur moveUp ci-dessus. */
export function moveDown(nodes: OrgNode[], nodeId: number): ReorderUpdate[] {
  const node = nodes.find((n) => n.id === nodeId);
  if (!node) return [];
  const siblings = siblingsOf(nodes, node.parentId);
  const idx = siblings.findIndex((n) => n.id === nodeId);
  if (idx === -1 || idx >= siblings.length - 1) return [];
  const reordered = [...siblings];
  [reordered[idx], reordered[idx + 1]] = [reordered[idx + 1], reordered[idx]];
  return reindexUpdates(reordered);
}

/** Remonte l'unité d'un niveau hiérarchique : il devient frère de son
 *  ancien parent, positionné juste après lui. Impossible si le parent
 *  est déjà la racine (pas de grand-parent). */
export function promoteLevel(nodes: OrgNode[], nodeId: number): ReorderUpdate[] {
  const node = nodes.find((n) => n.id === nodeId);
  if (!node || node.parentId === null) return [];
  const parent = nodes.find((n) => n.id === node.parentId);
  if (!parent || parent.parentId === null) return [];
  const grandParentId = parent.parentId;

  // Renuméroter les frères restants de l'ancien parent (sans l'unité).
  const oldSiblingsRemaining = siblingsOf(nodes, node.parentId).filter((n) => n.id !== nodeId);
  const updates: ReorderUpdate[] = reindexUpdates(oldSiblingsRemaining);

  // Insérer l'unité juste après son ancien parent, dans la fratrie du
  // grand-parent, puis renuméroter proprement l'ensemble.
  const grandSiblings = siblingsOf(nodes, grandParentId);
  const parentIdx = grandSiblings.findIndex((n) => n.id === parent.id);
  const newGrandSiblings = [
    ...grandSiblings.slice(0, parentIdx + 1),
    node,
    ...grandSiblings.slice(parentIdx + 1),
  ];
  newGrandSiblings.forEach((n, i) => {
    updates.push({ id: n.id, parentId: grandParentId, sortOrder: i });
  });

  return updates;
}

/** Rattache l'unité comme dernière unité rattachée à son frère précédent
 *  (descend d'un niveau hiérarchique). Impossible s'il n'y a pas de
 *  frère précédent. */
export function demoteIntoPreviousSibling(nodes: OrgNode[], nodeId: number): ReorderUpdate[] {
  const node = nodes.find((n) => n.id === nodeId);
  if (!node) return [];
  const siblings = siblingsOf(nodes, node.parentId);
  const idx = siblings.findIndex((n) => n.id === nodeId);
  if (idx <= 0) return [];
  const newParent = siblings[idx - 1];

  const updates: ReorderUpdate[] = [];
  // Renuméroter les frères restants de l'ancien parent.
  const oldSiblingsRemaining = siblings.filter((n) => n.id !== nodeId);
  updates.push(...reindexUpdates(oldSiblingsRemaining));

  // Ajouter l'unité comme dernière unité rattachée du nouveau parent.
  const newParentChildren = siblingsOf(nodes, newParent.id);
  updates.push({ id: node.id, parentId: newParent.id, sortOrder: newParentChildren.length });

  return updates;
}

/** Déplace l'unité vers n'importe quel autre parent choisi librement,
 *  en dernière position parmi ses nouveaux frères. */
export function moveToParent(nodes: OrgNode[], nodeId: number, newParentId: number): ReorderUpdate[] {
  const node = nodes.find((n) => n.id === nodeId);
  if (!node || node.parentId === newParentId) return [];

  const updates: ReorderUpdate[] = [];
  const oldSiblingsRemaining = siblingsOf(nodes, node.parentId).filter((n) => n.id !== nodeId);
  updates.push(...reindexUpdates(oldSiblingsRemaining));

  const newSiblings = siblingsOf(nodes, newParentId);
  updates.push({ id: node.id, parentId: newParentId, sortOrder: newSiblings.length });

  return updates;
}

/** Ensemble des IDs unités rattachées d'une unité (pour empêcher de le déplacer
 *  sous lui-même dans le sélecteur "Déplacer vers…"). */
export function getDescendantIds(nodes: OrgNode[], nodeId: number): Set<number> {
  const out = new Set<number>();
  const stack = nodes.filter((n) => n.parentId === nodeId).map((n) => n.id);
  while (stack.length) {
    const cur = stack.pop()!;
    if (out.has(cur)) continue;
    out.add(cur);
    nodes.filter((n) => n.parentId === cur).forEach((n) => stack.push(n.id));
  }
  return out;
}
