import { Router } from 'express';
import { z } from 'zod';
import { and, eq, isNull } from 'drizzle-orm';
import { db, correctionRulesTable } from '../db.js';
import { requireAuth, requirePermission } from '../middleware/auth.js';

const router = Router();
router.use(requireAuth);

router.get('/correction-rules', async (_req, res) => {
  const rows = await db.select().from(correctionRulesTable).where(isNull(correctionRulesTable.deletedAt));
  res.json({ correctionRules: rows });
});

const createSchema = z.object({
  sourceSheetName: z.string().min(1),
  targetSheetName: z.string().min(1)
});

router.post('/correction-rules', requirePermission('business.write'), async (req, res) => {
  const parsed = createSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: 'Feuille source et feuille cible requises.' });
  }
  const [row] = await db
    .insert(correctionRulesTable)
    .values({ ...parsed.data, createdBy: req.user!.username })
    .onConflictDoNothing()
    .returning();
  if (!row) {
    return res.status(409).json({ error: 'Cette règle existe déjà.' });
  }
  res.status(201).json({ correctionRule: row });
});

// Suppression douce : la règle part dans la Corbeille (Administration).
router.delete('/correction-rules/:id', requirePermission('business.delete'), async (req, res) => {
  const id = Number(req.params.id);
  const [row] = await db
    .update(correctionRulesTable)
    .set({ deletedAt: new Date(), deletedBy: req.user!.username })
    .where(and(eq(correctionRulesTable.id, id), isNull(correctionRulesTable.deletedAt)))
    .returning();
  if (!row) return res.status(404).json({ error: 'Règle introuvable.' });
  res.json({ ok: true });
});

export default router;
