import { Router } from 'express';
import { z } from 'zod';
import { and, eq, ilike, or, gte, lte, isNull, count, sql } from 'drizzle-orm';
import { db, facturesTable } from '../db.js';
import { requireAuth, requirePermission } from '../middleware/auth.js';

const router = Router();
router.use(requireAuth);

const factureInput = z.object({
  custcode: z.string().min(1),
  nd: z.string().nullable().optional(),
  nom: z.string().nullable().optional(),
  refFacture: z.string().min(1),
  montant: z.number().min(0),
  mois: z.string().nullable().optional(),
  echeance: z.string().nullable().optional(),
  produit: z.string().nullable().optional(),
  statut: z.enum(['reglee', 'impayee']),
  sourceSheet: z.string().nullable().optional(),
  coordinationRegionale: z.string().nullable().optional(),
  delegation: z.string().nullable().optional(),
  domiciliation: z.string().nullable().optional()
});

// ── Recherche avancée + pagination ───────────────────────────────────────
// GET /factures?search=...&statut=impayee&produit=...&custcode=...&montantMin=&montantMax=&dateFrom=&dateTo=&page=&pageSize=
router.get('/factures', async (req, res) => {
  const search = typeof req.query.search === 'string' ? req.query.search.trim() : '';
  const statut = typeof req.query.statut === 'string' ? req.query.statut : '';
  const produit = typeof req.query.produit === 'string' ? req.query.produit : '';
  const custcode = typeof req.query.custcode === 'string' ? req.query.custcode.trim() : '';
  const montantMin = req.query.montantMin ? Number(req.query.montantMin) : undefined;
  const montantMax = req.query.montantMax ? Number(req.query.montantMax) : undefined;
  const dateFrom = typeof req.query.dateFrom === 'string' ? req.query.dateFrom : '';
  const dateTo = typeof req.query.dateTo === 'string' ? req.query.dateTo : '';
  const page = Math.max(1, Number(req.query.page) || 1);
  const pageSize = Math.min(100, Math.max(1, Number(req.query.pageSize) || 25));

  const conditions = [isNull(facturesTable.deletedAt)];
  if (search) {
    const cond = or(
      ilike(facturesTable.custcode, `%${search}%`),
      ilike(facturesTable.refFacture, `%${search}%`),
      ilike(facturesTable.nom, `%${search}%`),
      ilike(facturesTable.nd, `%${search}%`)
    );
    if (cond) conditions.push(cond);
  }
  if (custcode) conditions.push(ilike(facturesTable.custcode, `%${custcode}%`));
  if (statut === 'reglee' || statut === 'impayee') conditions.push(eq(facturesTable.statut, statut));
  if (produit) conditions.push(eq(facturesTable.produit, produit));
  if (typeof montantMin === 'number' && !Number.isNaN(montantMin)) conditions.push(gte(facturesTable.montant, montantMin));
  if (typeof montantMax === 'number' && !Number.isNaN(montantMax)) conditions.push(lte(facturesTable.montant, montantMax));
  if (dateFrom) conditions.push(gte(facturesTable.echeance, dateFrom));
  if (dateTo) conditions.push(lte(facturesTable.echeance, dateTo));

  const where = and(...conditions);

  const [{ value: total }] = await db.select({ value: count() }).from(facturesTable).where(where);
  const rows = await db
    .select()
    .from(facturesTable)
    .where(where)
    .orderBy(sql`${facturesTable.updatedAt} DESC`)
    .limit(pageSize)
    .offset((page - 1) * pageSize);

  res.json({ factures: rows, total: Number(total), page, pageSize });
});

router.get('/factures/produits', async (_req, res) => {
  const rows = await db
    .selectDistinct({ produit: facturesTable.produit })
    .from(facturesTable)
    .where(and(isNull(facturesTable.deletedAt)));
  res.json({ produits: rows.map((r) => r.produit).filter(Boolean) });
});

router.post('/factures', requirePermission('business.write'), async (req, res) => {
  const parsed = factureInput.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: parsed.error.issues[0]?.message ?? 'Données invalides.' });
  }
  const [row] = await db
    .insert(facturesTable)
    .values(parsed.data)
    .onConflictDoUpdate({
      target: [facturesTable.custcode, facturesTable.refFacture],
      set: { ...parsed.data, updatedAt: new Date() }
    })
    .returning();
  res.status(201).json({ facture: row });
});

// ── Import en masse depuis la page Comparaison ───────────────────────────
// Chaque ligne de résultat de comparaison est enregistrée en base ; une
// facture existante (même custcode + référence) est mise à jour (upsert),
// ce qui permet de relancer une comparaison sans dupliquer les données.
const bulkSchema = z.array(factureInput).max(20000);

router.post('/factures/bulk-import', requirePermission('business.write'), async (req, res) => {
  const parsed = bulkSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: 'Liste de factures invalide.' });
  }
  if (parsed.data.length === 0) return res.json({ imported: 0 });

  const CHUNK = 500;
  let imported = 0;
  for (let i = 0; i < parsed.data.length; i += CHUNK) {
    const chunk = parsed.data.slice(i, i + CHUNK);
    await db
      .insert(facturesTable)
      .values(chunk)
      .onConflictDoUpdate({
        target: [facturesTable.custcode, facturesTable.refFacture],
        set: {
          nd: sql`excluded.nd`,
          nom: sql`excluded.nom`,
          montant: sql`excluded.montant`,
          mois: sql`excluded.mois`,
          echeance: sql`excluded.echeance`,
          produit: sql`excluded.produit`,
          statut: sql`excluded.statut`,
          sourceSheet: sql`excluded.source_sheet`,
          coordinationRegionale: sql`excluded.coordination_regionale`,
          delegation: sql`excluded.delegation`,
          domiciliation: sql`excluded.domiciliation`,
          updatedAt: new Date()
        }
      });
    imported += chunk.length;
  }

  res.status(201).json({ imported });
});

router.patch('/factures/:id', requirePermission('business.write'), async (req, res) => {
  const id = Number(req.params.id);
  const parsed = factureInput.partial().safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: 'Données invalides.' });
  }
  const [row] = await db
    .update(facturesTable)
    .set({ ...parsed.data, updatedAt: new Date() })
    .where(and(eq(facturesTable.id, id), isNull(facturesTable.deletedAt)))
    .returning();
  if (!row) return res.status(404).json({ error: 'Facture introuvable.' });
  res.json({ facture: row });
});

// Suppression douce : la facture part dans la Corbeille (Administration).
router.delete('/factures/:id', requirePermission('business.delete'), async (req, res) => {
  const id = Number(req.params.id);
  const [row] = await db
    .update(facturesTable)
    .set({ deletedAt: new Date(), deletedBy: req.user!.username })
    .where(and(eq(facturesTable.id, id), isNull(facturesTable.deletedAt)))
    .returning();
  if (!row) return res.status(404).json({ error: 'Facture introuvable.' });
  res.json({ ok: true });
});

export default router;
