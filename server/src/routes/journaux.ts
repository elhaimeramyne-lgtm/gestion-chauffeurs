import { Router } from 'express';
import { z } from 'zod';
import { and, eq, isNull } from 'drizzle-orm';
import { db, journalEntriesTable } from '../db.js';
import { requireAuth, requirePermission } from '../middleware/auth.js';

const router = Router();
router.use(requireAuth);

router.get('/journal-entries', async (_req, res) => {
  const rows = await db
    .select()
    .from(journalEntriesTable)
    .where(isNull(journalEntriesTable.deletedAt))
    .orderBy(journalEntriesTable.id);
  res.json({ entries: rows });
});

const entrySchema = z.object({
  direction: z.string().nullable().optional(),
  service: z.string().min(1),
  journal1: z.string().nullable().optional(),
  journal2: z.string().nullable().optional(),
  journal3: z.string().nullable().optional()
});

router.post('/journal-entries', requirePermission('business.write'), async (req, res) => {
  const parsed = entrySchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: parsed.error.issues[0]?.message ?? 'Données invalides.' });
  }
  const [row] = await db.insert(journalEntriesTable).values(parsed.data).returning();
  res.status(201).json({ entry: row });
});

const bulkSchema = z.array(entrySchema);

router.post('/journal-entries/bulk', requirePermission('business.write'), async (req, res) => {
  const parsed = bulkSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: 'Liste invalide.' });
  }
  if (parsed.data.length === 0) return res.json({ entries: [] });
  const rows = await db.insert(journalEntriesTable).values(parsed.data).returning();
  res.status(201).json({ entries: rows });
});

router.patch('/journal-entries/:id', requirePermission('business.write'), async (req, res) => {
  const id = Number(req.params.id);
  const parsed = entrySchema.partial().safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: 'Données invalides.' });
  }
  const [row] = await db
    .update(journalEntriesTable)
    .set({ ...parsed.data, updatedAt: new Date() })
    .where(and(eq(journalEntriesTable.id, id), isNull(journalEntriesTable.deletedAt)))
    .returning();
  if (!row) return res.status(404).json({ error: 'Entrée introuvable.' });
  res.json({ entry: row });
});

// Suppression douce : part dans la Corbeille (Administration).
router.delete('/journal-entries/:id', requirePermission('business.delete'), async (req, res) => {
  const id = Number(req.params.id);
  const [row] = await db
    .update(journalEntriesTable)
    .set({ deletedAt: new Date(), deletedBy: req.user!.username })
    .where(and(eq(journalEntriesTable.id, id), isNull(journalEntriesTable.deletedAt)))
    .returning();
  if (!row) return res.status(404).json({ error: 'Entrée introuvable.' });
  res.json({ ok: true });
});

export default router;
