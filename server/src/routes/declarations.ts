/**
 * Déclarations chauffeur — consultation et traitement, côté responsable du
 * parc / logistique. La création (par le chauffeur) se fait depuis
 * routes/maMission.ts ; ce routeur couvre uniquement la suite du workflow.
 *
 * GET   /declarations             — liste (les plus récentes en premier)
 * GET   /declarations/resume      — compteurs pour le tableau de bord
 * GET   /declarations/:id         — détail + médias + historique des statuts
 * PATCH /declarations/:id/statut  — faire avancer / modifier le statut
 */
import { Router } from 'express';
import { z } from 'zod';
import { desc, eq, inArray } from 'drizzle-orm';
import {
  db,
  vehiculeDeclarationsTable,
  declarationMediaTable,
  declarationEventsTable,
  vehiculesTable,
  chauffeursTable
} from '../db.js';
import { requireAuth, requirePermission } from '../middleware/auth.js';
import { broadcastNotifications } from './notifications-sse.js';

const router = Router();
router.use(requireAuth);

const STATUTS = ['nouvelle', 'en_cours', 'validee', 'reparation_programmee', 'terminee', 'archivee'] as const;

async function hydrate(rows: (typeof vehiculeDeclarationsTable.$inferSelect)[]) {
  const vehiculeIds = [...new Set(rows.map((r) => r.vehiculeId))];
  const chauffeurIds = [...new Set(rows.map((r) => r.chauffeurId))];

  const vehicules = vehiculeIds.length ? await db.select().from(vehiculesTable).where(inArray(vehiculesTable.id, vehiculeIds)) : [];
  const chauffeurs = chauffeurIds.length ? await db.select().from(chauffeursTable).where(inArray(chauffeursTable.id, chauffeurIds)) : [];

  const vehiculeById = new Map(vehicules.map((v) => [v.id, v]));
  const chauffeurById = new Map(chauffeurs.map((c) => [c.id, c]));

  const declarationIds = rows.map((r) => r.id);
  const counts = new Map<number, number>();
  if (declarationIds.length) {
    const media = await db.select().from(declarationMediaTable).where(inArray(declarationMediaTable.declarationId, declarationIds));
    for (const m of media) counts.set(m.declarationId, (counts.get(m.declarationId) ?? 0) + 1);
  }

  return rows.map((r) => {
    const v = vehiculeById.get(r.vehiculeId);
    const c = chauffeurById.get(r.chauffeurId);
    return {
      ...r,
      vehicule: v ? { id: v.id, immatriculation: v.immatriculation, marque: v.marque, modele: v.modele } : null,
      chauffeur: c ? { id: c.id, nom: c.nom } : null,
      mediaCount: counts.get(r.id) ?? 0
    };
  });
}

router.get('/declarations', requirePermission('business.read'), async (_req, res) => {
  const rows = await db.select().from(vehiculeDeclarationsTable).orderBy(desc(vehiculeDeclarationsTable.createdAt)).limit(200);
  res.json({ declarations: await hydrate(rows) });
});

router.get('/declarations/resume', requirePermission('business.read'), async (_req, res) => {
  const rows = await db.select().from(vehiculeDeclarationsTable);
  const weekAgo = Date.now() - 7 * 24 * 60 * 60 * 1000;
  res.json({
    nouvelles: rows.filter((d) => d.statut === 'nouvelle').length,
    urgentes: rows.filter((d) => d.statut !== 'terminee' && d.statut !== 'archivee' && (d.urgence === 'urgent' || d.urgence === 'critique')).length,
    enCours: rows.filter((d) => ['en_cours', 'validee', 'reparation_programmee'].includes(d.statut)).length,
    termineesCetteSemaine: rows.filter((d) => d.statut === 'terminee' && new Date(d.updatedAt).getTime() >= weekAgo).length
  });
});

router.get('/declarations/:id', requirePermission('business.read'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });

  const [row] = await db.select().from(vehiculeDeclarationsTable).where(eq(vehiculeDeclarationsTable.id, id));
  if (!row) return res.status(404).json({ error: 'Déclaration introuvable.' });

  const [hydrated] = await hydrate([row]);
  const media = (await db.select().from(declarationMediaTable).where(eq(declarationMediaTable.declarationId, id)))
    .map((m) => ({ ...m, url: `/api/uploads/declarations/${m.filename}` }));
  const events = await db.select().from(declarationEventsTable).where(eq(declarationEventsTable.declarationId, id)).orderBy(desc(declarationEventsTable.createdAt));

  res.json({ declaration: { ...hydrated, media, events } });
});

const statutSchema = z.object({
  statut: z.enum(STATUTS),
  commentaire: z.string().max(2000).optional()
});

router.patch('/declarations/:id/statut', requirePermission('business.write'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });
  const parsed = statutSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.issues[0]?.message ?? 'Données invalides.' });

  const [existing] = await db.select().from(vehiculeDeclarationsTable).where(eq(vehiculeDeclarationsTable.id, id));
  if (!existing) return res.status(404).json({ error: 'Déclaration introuvable.' });

  const [updated] = await db
    .update(vehiculeDeclarationsTable)
    .set({
      statut: parsed.data.statut,
      commentaireTraitement: parsed.data.commentaire ?? existing.commentaireTraitement,
      traitePar: req.user!.username,
      updatedAt: new Date()
    })
    .where(eq(vehiculeDeclarationsTable.id, id))
    .returning();

  await db.insert(declarationEventsTable).values({
    declarationId: id,
    statut: parsed.data.statut,
    commentaire: parsed.data.commentaire,
    actionPar: req.user!.username
  });

  broadcastNotifications().catch(() => {});

  const [hydrated] = await hydrate([updated!]);
  res.json({ declaration: hydrated });
});

export default router;
