import { Router } from 'express';
import { z } from 'zod';
import { and, eq, isNull } from 'drizzle-orm';
import { db, lignesTable } from '../db.js';
import { requireAuth, requirePermission } from '../middleware/auth.js';

const router = Router();
router.use(requireAuth);

router.get('/lignes', async (_req, res) => {
  const rows = await db.select().from(lignesTable).where(isNull(lignesTable.deletedAt)).orderBy(lignesTable.id);
  res.json({ lignes: rows });
});

const CIVILITES = ['Mme', 'Mlle', 'M.'] as const;

const ligneSchema = z.object({
  categorie: z.string().min(1),
  typeForfait: z.string().nullable().optional(),
  typeMobile: z.string().nullable().optional(),
  icc: z.string().nullable().optional(),
  imei: z.string().nullable().optional(),
  affecte: z.string().nullable().optional(),
  /** Civilité — sauvegardée et restituée telle quelle */
  civilite: z.enum(CIVILITES).nullable().optional(),
  personne: z.string().nullable().optional(),
  qualite: z.string().nullable().optional(),
  date: z.string().nullable().optional(),
  pin: z.string().max(20).nullable().optional(),
  puk: z.string().max(20).nullable().optional(),
  serviceId: z.number().int().positive().nullable().optional(),
  consommationMensuelleDh: z.number().int().min(0).nullable().optional()
});

router.post('/lignes', requirePermission('business.write'), async (req, res) => {
  const parsed = ligneSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: parsed.error.issues[0]?.message ?? 'Données invalides.' });
  }
  const [row] = await db.insert(lignesTable).values(parsed.data).returning();
  res.status(201).json({ ligne: row });
});

const bulkSchema = z.array(ligneSchema);

router.post('/lignes/bulk', requirePermission('business.write'), async (req, res) => {
  const parsed = bulkSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: 'Liste de lignes invalide.' });
  }
  if (parsed.data.length === 0) return res.json({ lignes: [] });
  const rows = await db.insert(lignesTable).values(parsed.data).returning();
  res.status(201).json({ lignes: rows });
});

router.patch('/lignes/:id', requirePermission('business.write'), async (req, res) => {
  const id = Number(req.params.id);
  const parsed = ligneSchema.partial().safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: 'Données invalides.' });
  }
  const [row] = await db
    .update(lignesTable)
    .set({ ...parsed.data, updatedAt: new Date() })
    .where(and(eq(lignesTable.id, id), isNull(lignesTable.deletedAt)))
    .returning();
  if (!row) return res.status(404).json({ error: 'Ligne introuvable.' });
  res.json({ ligne: row });
});

const transferSchema = z.object({
  nouvellePersonne: z.string().min(1),
  civilite: z.enum(CIVILITES).nullable().optional(),
  nouveauAffecte: z.string().nullable().optional(),
  nouvelleQualite: z.string().nullable().optional()
});

router.post('/lignes/:id/transfer', requirePermission('business.write'), async (req, res) => {
  const id = Number(req.params.id);
  const parsed = transferSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: 'Nouveau bénéficiaire requis.' });
  }
  const { nouvellePersonne, civilite, nouveauAffecte, nouvelleQualite } = parsed.data;
  const [row] = await db
    .update(lignesTable)
    .set({
      personne: nouvellePersonne,
      ...(civilite !== undefined ? { civilite } : {}),
      ...(nouveauAffecte !== undefined ? { affecte: nouveauAffecte } : {}),
      ...(nouvelleQualite !== undefined ? { qualite: nouvelleQualite } : {}),
      updatedAt: new Date()
    })
    .where(and(eq(lignesTable.id, id), isNull(lignesTable.deletedAt)))
    .returning();
  if (!row) return res.status(404).json({ error: 'Ligne introuvable.' });
  res.json({ ligne: row });
});

// Suppression douce : la ligne part dans la Corbeille (Administration) au
// lieu d'être effacée immédiatement, et reste restaurable.
router.delete('/lignes/:id', requirePermission('business.delete'), async (req, res) => {
  const id = Number(req.params.id);
  const [row] = await db
    .update(lignesTable)
    .set({ deletedAt: new Date(), deletedBy: req.user!.username })
    .where(and(eq(lignesTable.id, id), isNull(lignesTable.deletedAt)))
    .returning();
  if (!row) return res.status(404).json({ error: 'Ligne introuvable.' });
  res.json({ ok: true });
});

router.delete('/lignes', requirePermission('business.delete'), async (req, res) => {
  await db
    .update(lignesTable)
    .set({ deletedAt: new Date(), deletedBy: req.user!.username })
    .where(isNull(lignesTable.deletedAt));
  res.json({ ok: true });
});

export default router;
