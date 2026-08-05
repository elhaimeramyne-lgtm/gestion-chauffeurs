import { Router } from 'express';
import { z } from 'zod';
import { and, eq, isNull } from 'drizzle-orm';
import { db, sheetRulesTable, customFieldsTable } from '../db.js';
import { requireAuth, requirePermission } from '../middleware/auth.js';

const router = Router();
router.use(requireAuth);

// ── Règles de colonnes (par feuille) ────────────────────────────────────

router.get('/sheet-rules', async (_req, res) => {
  const rows = await db.select().from(sheetRulesTable);
  res.json({ rules: rows });
});

const upsertSheetRuleSchema = z.object({
  role: z.string().min(1),
  sheetName: z.string().min(1),
  mapping: z.record(z.string(), z.unknown())
});

router.put('/sheet-rules', requirePermission('business.write'), async (req, res) => {
  const parsed = upsertSheetRuleSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: parsed.error.issues[0]?.message ?? 'Données invalides.' });
  }
  const { role, sheetName, mapping } = parsed.data;

  const [existing] = await db
    .select()
    .from(sheetRulesTable)
    .where(and(eq(sheetRulesTable.role, role), eq(sheetRulesTable.sheetName, sheetName)))
    .limit(1);

  let row;
  if (existing) {
    [row] = await db
      .update(sheetRulesTable)
      .set({ mapping, updatedBy: req.user!.username, updatedAt: new Date() })
      .where(eq(sheetRulesTable.id, existing.id))
      .returning();
  } else {
    [row] = await db
      .insert(sheetRulesTable)
      .values({ role, sheetName, mapping, updatedBy: req.user!.username })
      .returning();
  }
  res.json({ rule: row });
});

// ── Champs personnalisés ─────────────────────────────────────────────────

router.get('/custom-fields', async (_req, res) => {
  const rows = await db.select().from(customFieldsTable).where(isNull(customFieldsTable.deletedAt));
  res.json({ customFields: rows });
});

const createCustomFieldSchema = z.object({ label: z.string().min(1) });

router.post('/custom-fields', requirePermission('business.write'), async (req, res) => {
  const parsed = createCustomFieldSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: 'Le nom du champ est requis.' });
  }
  const [row] = await db
    .insert(customFieldsTable)
    .values({ label: parsed.data.label, useAsMatchKey: true })
    .returning();
  res.status(201).json({ customField: row });
});

const updateCustomFieldSchema = z.object({ useAsMatchKey: z.boolean().optional(), label: z.string().min(1).optional() });

router.patch('/custom-fields/:id', requirePermission('business.write'), async (req, res) => {
  const id = Number(req.params.id);
  const parsed = updateCustomFieldSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: 'Données invalides.' });
  }
  const [row] = await db
    .update(customFieldsTable)
    .set({ ...parsed.data, updatedAt: new Date() })
    .where(and(eq(customFieldsTable.id, id), isNull(customFieldsTable.deletedAt)))
    .returning();
  if (!row) return res.status(404).json({ error: 'Champ introuvable.' });
  res.json({ customField: row });
});

// Suppression douce : le champ part dans la Corbeille (Administration).
router.delete('/custom-fields/:id', requirePermission('business.delete'), async (req, res) => {
  const id = Number(req.params.id);
  const [row] = await db
    .update(customFieldsTable)
    .set({ deletedAt: new Date(), deletedBy: req.user!.username })
    .where(and(eq(customFieldsTable.id, id), isNull(customFieldsTable.deletedAt)))
    .returning();
  if (!row) return res.status(404).json({ error: 'Champ introuvable.' });
  res.json({ ok: true });
});

export default router;
