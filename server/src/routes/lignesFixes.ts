import { Router } from 'express';
import { z } from 'zod';
import { and, eq, isNull } from 'drizzle-orm';
import { db, lignesFixesTable } from '../db.js';
import { requireAuth, requirePermission } from '../middleware/auth.js';

const router = Router();
router.use(requireAuth);

router.get('/lignes-fixes', async (_req, res) => {
  const rows = await db
    .select()
    .from(lignesFixesTable)
    .where(isNull(lignesFixesTable.deletedAt))
    .orderBy(lignesFixesTable.id);
  res.json({ lignesFixes: rows });
});

const ligneFixeSchema = z.object({
  nd: z.string().min(1),
  custcode: z.string().nullable().optional(),
  coordinationRegionale: z.string().nullable().optional(),
  delegation: z.string().nullable().optional(),
  domiciliation: z.string().nullable().optional(),
  personne: z.string().nullable().optional(),
  qualite: z.string().nullable().optional(),
  date: z.string().nullable().optional(),
  serviceId: z.number().int().positive().nullable().optional(),
  consommationMensuelleDh: z.number().int().min(0).nullable().optional()
});

router.post('/lignes-fixes', requirePermission('business.write'), async (req, res) => {
  const parsed = ligneFixeSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: parsed.error.issues[0]?.message ?? 'Données invalides.' });
  }
  const [row] = await db.insert(lignesFixesTable).values(parsed.data).returning();
  res.status(201).json({ ligneFixe: row });
});

const bulkSchema = z.array(ligneFixeSchema);

router.post('/lignes-fixes/bulk', requirePermission('business.write'), async (req, res) => {
  const parsed = bulkSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: 'Liste de lignes fixes invalide.' });
  }
  if (parsed.data.length === 0) return res.json({ lignesFixes: [] });
  const rows = await db.insert(lignesFixesTable).values(parsed.data).returning();
  res.status(201).json({ lignesFixes: rows });
});

router.patch('/lignes-fixes/:id', requirePermission('business.write'), async (req, res) => {
  const id = Number(req.params.id);
  const parsed = ligneFixeSchema.partial().safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: 'Données invalides.' });
  }
  const [row] = await db
    .update(lignesFixesTable)
    .set({ ...parsed.data, updatedAt: new Date() })
    .where(and(eq(lignesFixesTable.id, id), isNull(lignesFixesTable.deletedAt)))
    .returning();
  if (!row) return res.status(404).json({ error: 'Ligne fixe introuvable.' });
  res.json({ ligneFixe: row });
});

// Suppression douce : la ligne part dans la Corbeille (Administration).
router.delete('/lignes-fixes/:id', requirePermission('business.delete'), async (req, res) => {
  const id = Number(req.params.id);
  const [row] = await db
    .update(lignesFixesTable)
    .set({ deletedAt: new Date(), deletedBy: req.user!.username })
    .where(and(eq(lignesFixesTable.id, id), isNull(lignesFixesTable.deletedAt)))
    .returning();
  if (!row) return res.status(404).json({ error: 'Ligne fixe introuvable.' });
  res.json({ ok: true });
});

router.delete('/lignes-fixes', requirePermission('business.delete'), async (req, res) => {
  await db
    .update(lignesFixesTable)
    .set({ deletedAt: new Date(), deletedBy: req.user!.username })
    .where(isNull(lignesFixesTable.deletedAt));
  res.json({ ok: true });
});

export default router;
