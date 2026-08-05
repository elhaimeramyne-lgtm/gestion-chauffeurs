/**
 * Routes de l'organigramme dynamique.
 *
 * GET  /org/tree           — arbre complet (pour affichage hiérarchique)
 * GET  /org/flat           — liste plate (pour les selects dans la plateforme)
 * GET  /org/nodes/:id      — détail d'une unité
 * POST /org/nodes          — créer une unité (ADMIN+)
 * PATCH /org/nodes/:id     — modifier nom, chef, tel, parent (ADMIN+)
 * DELETE /org/nodes/:id    — supprimer (soft + cascade) (ADMIN+)
 * GET  /org/qualites       — liste de toutes les "qualités" (remplace LIGNE_QUALITES)
 */
import { Router } from 'express';
import { eq, isNull, asc, and } from 'drizzle-orm';
import { z } from 'zod';
import { db, orgNodesTable } from '../db.js';
import { requireAuth, requirePermission } from '../middleware/auth.js';
import type { OrgNodeRow } from '../schema/orgNodes.js';

const router = Router();
router.use(requireAuth);

/* ── Helpers ─────────────────────────────────────────────────────── */

export interface OrgNodeTree extends OrgNodeRow {
  children: OrgNodeTree[];
}

function buildTree(nodes: OrgNodeRow[], parentId: number | null = null): OrgNodeTree[] {
  return nodes
    .filter((n) => n.parentId === parentId && !n.deletedAt)
    .sort((a, b) => a.sortOrder - b.sortOrder)
    .map((n) => ({ ...n, children: buildTree(nodes, n.id) }));
}

/* ── Arbre complet ─────────────────────────────────────────────────── */
router.get('/org/tree', async (_req, res) => {
  const nodes = await db
    .select()
    .from(orgNodesTable)
    .where(isNull(orgNodesTable.deletedAt))
    .orderBy(asc(orgNodesTable.sortOrder));
  const tree = buildTree(nodes, null);
  res.json({ tree, total: nodes.length });
});

/* ── Liste plate (pour selects) ────────────────────────────────────── */
router.get('/org/flat', async (_req, res) => {
  const nodes = await db
    .select()
    .from(orgNodesTable)
    .where(isNull(orgNodesTable.deletedAt))
    .orderBy(asc(orgNodesTable.sortOrder));
  res.json({ nodes });
});

/* ── "Qualités" — remplace LIGNE_QUALITES ──────────────────────────── */
router.get('/org/qualites', async (_req, res) => {
  const nodes = await db
    .select({ id: orgNodesTable.id, name: orgNodesTable.name, type: orgNodesTable.type })
    .from(orgNodesTable)
    .where(isNull(orgNodesTable.deletedAt))
    .orderBy(asc(orgNodesTable.sortOrder));

  // Renvoie toutes les entités comme liste de qualités (ordre : d'abord les
  // entités de haut niveau, puis les divisions, puis les services)
  const ORDER = ['direction', 'inspection', 'entite', 'sous-direction', 'division', 'service'];
  const sorted = nodes.sort((a, b) => {
    const ia = ORDER.indexOf(a.type);
    const ib = ORDER.indexOf(b.type);
    return ia - ib;
  });
  res.json({ qualites: sorted.map((n) => n.name) });
});

/* ── Détail d'une unité ───────────────────────────────────────────── */
router.get('/org/nodes/:id', async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide' });
  const [node] = await db.select().from(orgNodesTable).where(eq(orgNodesTable.id, id));
  if (!node || node.deletedAt) return res.status(404).json({ error: 'Unité introuvable' });
  // Enfants directs
  const children = await db
    .select()
    .from(orgNodesTable)
    .where(and(eq(orgNodesTable.parentId, id), isNull(orgNodesTable.deletedAt)))
    .orderBy(asc(orgNodesTable.sortOrder));
  res.json({ node, children });
});

/* ── Créer une unité (ADMIN+) ─────────────────────────────────────── */
const createSchema = z.object({
  type: z.enum(['direction', 'sous-direction', 'division', 'service', 'inspection', 'entite']),
  name: z.string().min(2).max(200),
  shortName: z.string().max(50).optional(),
  parentId: z.number().int().positive().optional(),
  sortOrder: z.number().int().default(0),
  chefNom: z.string().max(100).optional(),
  telephone: z.string().max(30).optional(),
  notes: z.string().max(500).optional(),
});

router.post('/org/nodes', requirePermission('org.manage'), async (req, res) => {
  const parsed = createSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.flatten() });
  const { type, name, shortName, parentId, sortOrder, chefNom, telephone, notes } = parsed.data;

  const [node] = await db
    .insert(orgNodesTable)
    .values({ type, name, shortName, parentId: parentId ?? null, sortOrder, chefNom, telephone, notes })
    .returning();
  res.status(201).json({ node });
});

/* ── Modifier une unité (ADMIN+) ─────────────────────────────────────── */
const patchSchema = z.object({
  name: z.string().min(2).max(200).optional(),
  shortName: z.string().max(50).optional().nullable(),
  parentId: z.number().int().positive().optional().nullable(),
  sortOrder: z.number().int().optional(),
  chefNom: z.string().max(100).optional().nullable(),
  telephone: z.string().max(30).optional().nullable(),
  notes: z.string().max(500).optional().nullable(),
});

router.patch('/org/nodes/:id', requirePermission('org.manage'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide' });

  const parsed = patchSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.flatten() });

  const [updated] = await db
    .update(orgNodesTable)
    .set({ ...parsed.data, updatedAt: new Date() })
    .where(eq(orgNodesTable.id, id))
    .returning();

  if (!updated) return res.status(404).json({ error: 'Unité introuvable' });
  res.json({ node: updated });
});

/* ── Réordonner / déplacer plusieurs unités en une transaction (ADMIN+) ──
 * Utilisé par l'arbre interactif pour : monter, descendre, remonter/
 * descendre d'un niveau hiérarchique, ou déplacer vers un nouveau parent.
 * Empêche de créer un cycle (une unité ne peut pas devenir sa propre
 * descendant) et vérifie que tous les unités existent bel et bien. */
const reorderSchema = z.object({
  updates: z
    .array(
      z.object({
        id: z.number().int().positive(),
        parentId: z.number().int().positive().nullable(),
        sortOrder: z.number().int(),
      })
    )
    .min(1)
    .max(200),
});

router.patch('/org/reorder', requirePermission('org.manage'), async (req, res) => {
  const parsed = reorderSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.flatten() });
  const { updates } = parsed.data;

  const allNodes = await db
    .select()
    .from(orgNodesTable)
    .where(isNull(orgNodesTable.deletedAt));
  const byId = new Map(allNodes.map((n) => [n.id, n]));

  for (const u of updates) {
    if (!byId.has(u.id)) {
      return res.status(404).json({ error: `Unité ${u.id} introuvable.` });
    }
    if (u.parentId !== null && !byId.has(u.parentId)) {
      return res.status(404).json({ error: `Parent ${u.parentId} introuvable.` });
    }
  }

  // Anti-cycle : le nouveau parent ne doit jamais être l'unité elle-même
  // ni l'un de ses descendants (en tenant compte des autres reparentages
  // du même lot).
  const parentOverride = new Map(updates.map((u) => [u.id, u.parentId]));
  const effectiveParent = (id: number): number | null =>
    parentOverride.has(id) ? parentOverride.get(id)! : byId.get(id)!.parentId;

  for (const u of updates) {
    let cur = u.parentId;
    const seen = new Set<number>();
    while (cur !== null) {
      if (cur === u.id) {
        return res.status(400).json({ error: `Déplacement invalide : « ${byId.get(u.id)!.name} » ne peut pas devenir son propre descendant.` });
      }
      if (seen.has(cur)) break;
      seen.add(cur);
      cur = effectiveParent(cur);
    }
  }

  await db.transaction(async (tx) => {
    for (const u of updates) {
      await tx
        .update(orgNodesTable)
        .set({ parentId: u.parentId, sortOrder: u.sortOrder, updatedAt: new Date() })
        .where(eq(orgNodesTable.id, u.id));
    }
  });

  res.json({ ok: true, updated: updates.length });
});

/* ── Supprimer une unité (ADMIN+) — soft delete cascade ──────────────── */
router.delete('/org/nodes/:id', requirePermission('org.manage'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide' });

  // Soft-delete récursif via CTE
  const { sql } = await import('drizzle-orm');
  await db.execute(sql`
    WITH RECURSIVE desc_ids AS (
      SELECT id FROM iam.org_nodes WHERE id = ${id}
      UNION ALL
      SELECT n.id FROM iam.org_nodes n
      INNER JOIN desc_ids d ON n.parent_id = d.id
      WHERE n.deleted_at IS NULL
    )
    UPDATE iam.org_nodes SET deleted_at = NOW(), updated_at = NOW()
    WHERE id IN (SELECT id FROM desc_ids)
  `);

  res.json({ ok: true });
});

export default router;
