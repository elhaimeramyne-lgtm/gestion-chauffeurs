/**
 * Demandes de services — Service de la Logistique et des Moyens Généraux.
 *
 * GET  /logistique/demandes            — liste (filtres : statut, priorite, type, serviceId, recherche)
 * GET  /logistique/demandes/stats      — indicateurs pour le tableau de bord
 * GET  /logistique/demandes/:id        — détail + historique des transitions
 * POST /logistique/demandes            — créer une demande (tout utilisateur connecté)
 * PATCH /logistique/demandes/:id/statut — faire avancer le workflow
 * PATCH /logistique/demandes/:id        — modifier objet/description/priorité (avant traitement)
 * DELETE /logistique/demandes/:id      — suppression douce (ADMIN+)
 */
import { Router } from 'express';
import { z } from 'zod';
import { and, desc, eq, ilike, isNull, or, sql } from 'drizzle-orm';
import { db, serviceRequestsTable, serviceRequestEventsTable, orgNodesTable, usersTable } from '../db.js';
import { requireAuth, requirePermission } from '../middleware/auth.js';
import { isAtLeast, type Role } from '../lib/permissions.js';
import type { ServiceRequestRow } from '../schema/serviceRequests.js';

const router = Router();
router.use(requireAuth);

type Statut = ServiceRequestRow['statut'];

/* ── Machine à états du workflow ──────────────────────────────────────
 * Chaque transition déclare le rôle minimum requis pour l'effectuer.
 * GESTIONNAIRE ≈ chef de service, ADMIN ≈ responsable Logistique — à
 * affiner plus tard si un mapping plus fin par service est nécessaire. */
const TRANSITIONS: Record<Statut, { to: Statut; minRole: Role; requiresAgent?: boolean }[]> = {
  nouvelle: [
    { to: 'validee_chef', minRole: 'GESTIONNAIRE' },
    { to: 'annulee', minRole: 'USER' }
  ],
  validee_chef: [
    { to: 'validee_responsable', minRole: 'ADMIN' },
    { to: 'annulee', minRole: 'GESTIONNAIRE' }
  ],
  validee_responsable: [
    { to: 'affectee', minRole: 'ADMIN', requiresAgent: true },
    { to: 'annulee', minRole: 'ADMIN' }
  ],
  affectee: [
    { to: 'en_cours', minRole: 'USER' },
    { to: 'annulee', minRole: 'GESTIONNAIRE' }
  ],
  en_cours: [{ to: 'terminee', minRole: 'USER' }],
  terminee: [{ to: 'archivee', minRole: 'USER' }],
  annulee: [{ to: 'archivee', minRole: 'USER' }],
  archivee: []
};

const STATUT_LABELS: Record<Statut, string> = {
  nouvelle: 'Nouvelle',
  validee_chef: 'Validée (chef de service)',
  validee_responsable: 'Validée (responsable Logistique)',
  affectee: 'Affectée',
  en_cours: 'En cours',
  terminee: 'Terminée',
  annulee: 'Annulée',
  archivee: 'Archivée'
};

/* ── Numéro automatique : DEM-2026-0001 ─────────────────────────────── */
async function generateNumero(): Promise<string> {
  const year = new Date().getFullYear();
  const prefix = `DEM-${year}-`;
  const [{ count }] = await db
    .select({ count: sql<number>`count(*)::int` })
    .from(serviceRequestsTable)
    .where(ilike(serviceRequestsTable.numero, `${prefix}%`));
  const seq = (count ?? 0) + 1;
  return `${prefix}${String(seq).padStart(4, '0')}`;
}

/* ── Liste ──────────────────────────────────────────────────────────── */
router.get('/logistique/demandes', requirePermission('business.read'), async (req, res) => {
  const { statut, priorite, type, serviceId, search } = req.query;
  const conditions = [isNull(serviceRequestsTable.deletedAt)];

  if (typeof statut === 'string' && statut) {
    conditions.push(eq(serviceRequestsTable.statut, statut as Statut));
  }
  if (typeof priorite === 'string' && priorite) {
    conditions.push(eq(serviceRequestsTable.priorite, priorite as ServiceRequestRow['priorite']));
  }
  if (typeof type === 'string' && type) {
    conditions.push(eq(serviceRequestsTable.type, type as ServiceRequestRow['type']));
  }
  if (typeof serviceId === 'string' && serviceId) {
    const id = Number(serviceId);
    if (id) conditions.push(eq(serviceRequestsTable.serviceDemandeurId, id));
  }
  if (typeof search === 'string' && search.trim()) {
    const s = `%${search.trim()}%`;
    const cond = or(
      ilike(serviceRequestsTable.numero, s),
      ilike(serviceRequestsTable.objet, s),
      ilike(serviceRequestsTable.demandeurNom, s)
    );
    if (cond) conditions.push(cond);
  }

  const rows = await db
    .select()
    .from(serviceRequestsTable)
    .where(and(...conditions))
    .orderBy(desc(serviceRequestsTable.createdAt))
    .limit(500);

  res.json({ demandes: rows });
});

/* ── Statistiques tableau de bord ──────────────────────────────────── */
router.get('/logistique/demandes/stats', requirePermission('business.read'), async (_req, res) => {
  const rows = await db
    .select()
    .from(serviceRequestsTable)
    .where(isNull(serviceRequestsTable.deletedAt));

  const nodes = await db
    .select({ id: orgNodesTable.id, name: orgNodesTable.name })
    .from(orgNodesTable)
    .where(isNull(orgNodesTable.deletedAt));
  const nodeName = new Map(nodes.map((n) => [n.id, n.name]));

  const startOfToday = new Date();
  startOfToday.setHours(0, 0, 0, 0);
  const startOfMonth = new Date();
  startOfMonth.setDate(1);
  startOfMonth.setHours(0, 0, 0, 0);

  const enAttenteStatuts: Statut[] = ['nouvelle', 'validee_chef', 'validee_responsable'];
  const clotureStatuts: Statut[] = ['terminee', 'archivee', 'annulee'];

  const todayCount = rows.filter((r) => r.createdAt >= startOfToday).length;
  const enAttente = rows.filter((r) => enAttenteStatuts.includes(r.statut)).length;
  const urgentes = rows.filter((r) => r.priorite !== 'normale' && !clotureStatuts.includes(r.statut)).length;
  const termineesMois = rows.filter((r) => r.statut === 'terminee' && r.updatedAt >= startOfMonth).length;

  const parDirection = new Map<string, number>();
  const parType = new Map<string, number>();
  const parStatut = new Map<string, number>();
  let delaiTotalHeures = 0;
  let delaiCount = 0;

  for (const r of rows) {
    const dirName = nodeName.get(r.serviceDemandeurId) ?? `Service #${r.serviceDemandeurId}`;
    parDirection.set(dirName, (parDirection.get(dirName) ?? 0) + 1);
    parType.set(r.type, (parType.get(r.type) ?? 0) + 1);
    parStatut.set(r.statut, (parStatut.get(r.statut) ?? 0) + 1);
    if (r.statut === 'terminee') {
      delaiTotalHeures += (r.updatedAt.getTime() - r.createdAt.getTime()) / 3_600_000;
      delaiCount += 1;
    }
  }

  res.json({
    todayCount,
    enAttente,
    urgentes,
    termineesMois,
    total: rows.length,
    delaiMoyenHeures: delaiCount > 0 ? Math.round(delaiTotalHeures / delaiCount) : null,
    parDirection: [...parDirection.entries()].map(([name, count]) => ({ name, count })).sort((a, b) => b.count - a.count),
    parType: [...parType.entries()].map(([type, count]) => ({ type, count })),
    parStatut: [...parStatut.entries()].map(([statut, count]) => ({ statut, label: STATUT_LABELS[statut as Statut], count }))
  });
});

/* ── Détail + historique ───────────────────────────────────────────── */
router.get('/logistique/demandes/:id', requirePermission('business.read'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });

  const [demande] = await db.select().from(serviceRequestsTable).where(eq(serviceRequestsTable.id, id));
  if (!demande || demande.deletedAt) return res.status(404).json({ error: 'Demande introuvable.' });

  const events = await db
    .select()
    .from(serviceRequestEventsTable)
    .where(eq(serviceRequestEventsTable.requestId, id))
    .orderBy(desc(serviceRequestEventsTable.createdAt));

  res.json({ demande, events });
});

/* ── Créer une demande ─────────────────────────────────────────────── */
const createSchema = z.object({
  serviceDemandeurId: z.number().int().positive(),
  demandeurNom: z.string().min(2).max(150),
  demandeurTelephone: z.string().max(30).optional(),
  type: z.enum(['vehicule', 'deplacement', 'telephone', 'fourniture', 'mobilier', 'maintenance', 'informatique', 'batiment', 'autre']),
  objet: z.string().min(3).max(200),
  description: z.string().max(2000).optional(),
  priorite: z.enum(['normale', 'urgente', 'critique']).default('normale'),
  dateSouhaitee: z.string().regex(/^\d{2}\/\d{2}\/\d{4}$/).optional()
});

router.post('/logistique/demandes', requirePermission('business.write'), async (req, res) => {
  const parsed = createSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.issues[0]?.message ?? 'Données invalides.' });

  const [service] = await db
    .select({ id: orgNodesTable.id })
    .from(orgNodesTable)
    .where(and(eq(orgNodesTable.id, parsed.data.serviceDemandeurId), isNull(orgNodesTable.deletedAt)));
  if (!service) return res.status(400).json({ error: 'Service demandeur introuvable dans l\'organigramme.' });

  const numero = await generateNumero();
  const [demande] = await db
    .insert(serviceRequestsTable)
    .values({ ...parsed.data, numero, statut: 'nouvelle', createdBy: req.user!.username })
    .returning();

  await db.insert(serviceRequestEventsTable).values({
    requestId: demande!.id,
    statut: 'nouvelle',
    commentaire: 'Demande créée.',
    actionPar: req.user!.username
  });

  res.status(201).json({ demande });
});

/* ── Modifier les champs descriptifs (avant clôture) ───────────────── */
const patchSchema = z.object({
  objet: z.string().min(3).max(200).optional(),
  description: z.string().max(2000).nullable().optional(),
  priorite: z.enum(['normale', 'urgente', 'critique']).optional(),
  dateSouhaitee: z.string().regex(/^\d{2}\/\d{2}\/\d{4}$/).nullable().optional()
});

router.patch('/logistique/demandes/:id', requirePermission('business.write'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });

  const parsed = patchSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.issues[0]?.message ?? 'Données invalides.' });

  const [updated] = await db
    .update(serviceRequestsTable)
    .set({ ...parsed.data, updatedAt: new Date() })
    .where(and(eq(serviceRequestsTable.id, id), isNull(serviceRequestsTable.deletedAt)))
    .returning();
  if (!updated) return res.status(404).json({ error: 'Demande introuvable.' });
  res.json({ demande: updated });
});

/* ── Faire avancer le workflow ─────────────────────────────────────── */
const transitionSchema = z.object({
  statut: z.enum(['nouvelle', 'validee_chef', 'validee_responsable', 'affectee', 'en_cours', 'terminee', 'annulee', 'archivee']),
  commentaire: z.string().max(1000).optional(),
  agentAffecteId: z.number().int().positive().optional()
});

router.patch('/logistique/demandes/:id/statut', requirePermission('business.write'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });

  const parsed = transitionSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.issues[0]?.message ?? 'Données invalides.' });

  const [demande] = await db.select().from(serviceRequestsTable).where(eq(serviceRequestsTable.id, id));
  if (!demande || demande.deletedAt) return res.status(404).json({ error: 'Demande introuvable.' });

  const allowed = TRANSITIONS[demande.statut].find((t) => t.to === parsed.data.statut);
  if (!allowed) {
    return res.status(400).json({
      error: `Transition invalide : « ${STATUT_LABELS[demande.statut]} » → « ${STATUT_LABELS[parsed.data.statut]} ».`
    });
  }
  if (!isAtLeast(req.user!.role, allowed.minRole)) {
    return res.status(403).json({ error: "Vous n'avez pas les droits pour effectuer cette validation." });
  }
  if (allowed.requiresAgent && !parsed.data.agentAffecteId && !demande.agentAffecteId) {
    return res.status(400).json({ error: 'Un agent doit être affecté pour passer au statut « Affectée ».' });
  }

  const [updated] = await db
    .update(serviceRequestsTable)
    .set({
      statut: parsed.data.statut,
      agentAffecteId: parsed.data.agentAffecteId ?? demande.agentAffecteId,
      updatedAt: new Date()
    })
    .where(eq(serviceRequestsTable.id, id))
    .returning();

  await db.insert(serviceRequestEventsTable).values({
    requestId: id,
    statut: parsed.data.statut,
    commentaire: parsed.data.commentaire,
    actionPar: req.user!.username
  });

  res.json({ demande: updated });
});

/* ── Supprimer (suppression douce, ADMIN+) ─────────────────────────── */
router.delete('/logistique/demandes/:id', requirePermission('business.delete'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });

  const [row] = await db
    .update(serviceRequestsTable)
    .set({ deletedAt: new Date(), deletedBy: req.user!.username })
    .where(and(eq(serviceRequestsTable.id, id), isNull(serviceRequestsTable.deletedAt)))
    .returning();
  if (!row) return res.status(404).json({ error: 'Demande introuvable.' });
  res.json({ ok: true });
});

/* ── Agents disponibles pour affectation ───────────────────────────── */
router.get('/logistique/agents', requirePermission('business.read'), async (_req, res) => {
  const agents = await db
    .select({ id: usersTable.id, displayName: usersTable.displayName, username: usersTable.username, role: usersTable.role })
    .from(usersTable)
    .where(and(isNull(usersTable.deletedAt), eq(usersTable.isActive, true)));
  res.json({ agents });
});

export default router;
