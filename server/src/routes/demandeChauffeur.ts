/**
 * Demandes de Chauffeur — Module Logistique
 *
 * Permet aux services de faire une demande de chauffeur.
 * Le responsable parc auto assigne un chauffeur ; le chauffeur accepte ou
 * refuse directement depuis son portail ; une fois accepté, le responsable
 * valide ce qui crée automatiquement un ordre de mission (déplacement).
 *
 * Workflow :
 *   en_attente → assignee → confirmee (chauffeur accepte) → validee → (création auto OM) → terminee
 *   en_attente → refusee (refus du responsable)
 *   assignee → en_attente (le chauffeur refuse : redevient à réassigner)
 */
import { Router } from 'express';
import { z } from 'zod';
import { and, desc, eq, ilike, inArray, isNull, or, sql } from 'drizzle-orm';
import {
  db, demandeChauffeurTable, orgNodesTable, chauffeursTable,
  deplacementsTable, vehiculesTable, deplacementPassagersTable
} from '../db.js';
import { requireAuth, requirePermission } from '../middleware/auth.js';
import { broadcastNotifications } from './notifications-sse.js';
import { applyTransition } from '../lib/missionEngine.js';
import type { DemandeChauffeurRow } from '../schema/demandeChauffeur.js';

const router = Router();
router.use(requireAuth);

type DemandeStatut = DemandeChauffeurRow['statut'];

const TRANSITIONS: Record<DemandeStatut, DemandeStatut[]> = {
  en_attente: ['assignee', 'refusee'],
  assignee: ['confirmee', 'en_attente', 'refusee'],
  confirmee: ['validee', 'refusee'],
  validee: ['terminee'],
  refusee: [],
  terminee: []
};

const STATUT_LABELS: Record<DemandeStatut, string> = {
  en_attente: 'En attente',
  assignee: 'Chauffeur assigné',
  confirmee: 'Accepté par le chauffeur',
  validee: 'Validée',
  refusee: 'Refusée',
  terminee: 'Terminée'
};

/* ── Numéro automatique : DC-2026-0001 ─────────────────────────────── */
async function generateNumero(): Promise<string> {
  const year = new Date().getFullYear();
  const prefix = `DC-${year}-`;
  const [{ count }] = await db
    .select({ count: sql<number>`count(*)::int` })
    .from(demandeChauffeurTable)
    .where(ilike(demandeChauffeurTable.numero, `${prefix}%`));
  const seq = (count ?? 0) + 1;
  return `${prefix}${String(seq).padStart(4, '0')}`;
}

/* ── Créer une demande de chauffeur ─────────────────────────────────── */
const createSchema = z.object({
  serviceDemandeurId: z.number().int().positive(),
  demandeurNom: z.string().min(2).max(150),
  demandeurTelephone: z.string().max(30).optional(),
  priorite: z.enum(['normale', 'urgente', 'critique']).default('normale'),
  observations: z.string().max(500).optional()
});

router.post('/demande-chauffeur', requirePermission('business.write'), async (req, res) => {
  const parsed = createSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.issues[0]?.message ?? 'Données invalides.' });

  const [service] = await db
    .select({ id: orgNodesTable.id })
    .from(orgNodesTable)
    .where(and(eq(orgNodesTable.id, parsed.data.serviceDemandeurId), isNull(orgNodesTable.deletedAt)));
  if (!service) return res.status(400).json({ error: 'Service demandeur introuvable dans l\'organigramme.' });

  const numero = await generateNumero();
  const [demande] = await db
    .insert(demandeChauffeurTable)
    .values({
      ...parsed.data,
      numero,
      statut: 'en_attente',
      createdBy: req.user!.username
    })
    .returning();

  broadcastNotifications().catch(() => {});

  res.status(201).json({ demande });
});

/* ── Lister les demandes ────────────────────────────────────────────── */
router.get('/demande-chauffeur', requirePermission('business.read'), async (req, res) => {
  const { statut, priorite, serviceId, search } = req.query;
  const conditions = [isNull(demandeChauffeurTable.deletedAt)];

  if (typeof statut === 'string' && statut) {
    conditions.push(eq(demandeChauffeurTable.statut, statut as DemandeStatut));
  }
  if (typeof priorite === 'string' && priorite) {
    conditions.push(eq(demandeChauffeurTable.priorite, priorite as DemandeChauffeurRow['priorite']));
  }
  if (typeof serviceId === 'string' && serviceId) {
    const id = Number(serviceId);
    if (id) conditions.push(eq(demandeChauffeurTable.serviceDemandeurId, id));
  }
  if (typeof search === 'string' && search.trim()) {
    const s = `%${search.trim()}%`;
    const cond = or(
      ilike(demandeChauffeurTable.numero, s),
      ilike(demandeChauffeurTable.demandeurNom, s)
    );
    if (cond) conditions.push(cond);
  }

  const demandes = await db
    .select()
    .from(demandeChauffeurTable)
    .where(and(...conditions))
    .orderBy(sql`CASE WHEN ${demandeChauffeurTable.priorite} = 'critique' THEN 1 WHEN ${demandeChauffeurTable.priorite} = 'urgente' THEN 2 ELSE 3 END`, desc(demandeChauffeurTable.createdAt))
    .limit(200);

  // Enrichir avec les données du chauffeur si assigné
  const chauffeurIds = demandes.map((d) => d.chauffeurId).filter((id): id is number => id != null);
  const chauffeurs = chauffeurIds.length
    ? await db.select().from(chauffeursTable).where(inArray(chauffeursTable.id, chauffeurIds))
    : [];

  const chauffeurMap = new Map(chauffeurs.map((c) => [c.id, c]));

  const enriched = demandes.map((d) => ({
    ...d,
    chauffeur: d.chauffeurId ? chauffeurMap.get(d.chauffeurId) ?? null : null
  }));

  res.json({ demandes: enriched });
});

/* ── Récupérer les chauffeurs disponibles pour assignation ──────────── */
router.get('/demande-chauffeur/chauffeurs-disponibles', requirePermission('business.read'), async (_req, res) => {
  const chauffeurs = await db
    .select()
    .from(chauffeursTable)
    .where(and(isNull(chauffeursTable.deletedAt), eq(chauffeursTable.statut, 'disponible')))
    .orderBy(chauffeursTable.nom);

  res.json({ chauffeurs });
});

/* ── Assigner un chauffeur à la demande ─────────────────────────────── */
const assignerSchema = z.object({
  chauffeurId: z.number().int().positive()
});

router.patch('/demande-chauffeur/:id/assigner', requirePermission('business.write'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });

  const parsed = assignerSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.issues[0]?.message ?? 'Données invalides.' });

  const [demande] = await db.select().from(demandeChauffeurTable).where(eq(demandeChauffeurTable.id, id));
  if (!demande || demande.deletedAt) return res.status(404).json({ error: 'Demande introuvable.' });

  if (demande.statut !== 'en_attente') {
    return res.status(400).json({ error: `Impossible d'assigner un chauffeur : la demande est « ${STATUT_LABELS[demande.statut]} ».` });
  }

  const [chauffeur] = await db.select().from(chauffeursTable).where(eq(chauffeursTable.id, parsed.data.chauffeurId));
  if (!chauffeur || chauffeur.deletedAt) return res.status(400).json({ error: 'Chauffeur introuvable.' });
  if (chauffeur.statut !== 'disponible') {
    return res.status(400).json({ error: `Ce chauffeur n'est pas disponible (statut : ${chauffeur.statut}).` });
  }

  const [updated] = await db
    .update(demandeChauffeurTable)
    .set({
      chauffeurId: parsed.data.chauffeurId,
      statut: 'assignee',
      assignePar: req.user!.username,
      updatedAt: new Date()
    })
    .where(eq(demandeChauffeurTable.id, id))
    .returning();

  broadcastNotifications().catch(() => {});

  res.json({ demande: updated });
});

/* ── Valider la demande → crée l'ordre de mission automatiquement ──── */
const validerSchema = z.object({
  vehiculeId: z.number().int().positive(),
  objet: z.string().min(3).max(200).optional(),
  destination: z.string().max(200).optional(),
  dateDepart: z.string().regex(/^\d{2}\/\d{2}\/\d{4}$/),
  dateRetourPrevue: z.string().regex(/^\d{2}\/\d{2}\/\d{4}$/).optional(),
  heureDepartPrevue: z.string().regex(/^\d{2}:\d{2}$/).optional(),
  observations: z.string().max(500).optional()
});

router.post('/demande-chauffeur/:id/valider', requirePermission('business.write'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });

  const parsed = validerSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.issues[0]?.message ?? 'Données invalides.' });

  const [demande] = await db.select().from(demandeChauffeurTable).where(eq(demandeChauffeurTable.id, id));
  if (!demande || demande.deletedAt) return res.status(404).json({ error: 'Demande introuvable.' });

  if (demande.statut !== 'confirmee') {
    return res.status(400).json({ error: `Impossible de valider : la demande est « ${STATUT_LABELS[demande.statut]} ». Le chauffeur doit d'abord accepter la mission depuis son portail.` });
  }

  if (!demande.chauffeurId) {
    return res.status(400).json({ error: 'Aucun chauffeur assigné à cette demande.' });
  }

  // Vérifier le véhicule
  const [vehicule] = await db.select().from(vehiculesTable).where(eq(vehiculesTable.id, parsed.data.vehiculeId));
  if (!vehicule || vehicule.deletedAt) return res.status(400).json({ error: 'Véhicule introuvable.' });
  if (vehicule.statut !== 'disponible') {
    return res.status(400).json({ error: `Ce véhicule n'est pas disponible (statut : ${vehicule.statut}).` });
  }

  // Vérifier le chauffeur
  const [chauffeur] = await db.select().from(chauffeursTable).where(eq(chauffeursTable.id, demande.chauffeurId));
  if (!chauffeur || chauffeur.deletedAt) return res.status(400).json({ error: 'Chauffeur introuvable.' });

  // Générer un numéro d'ordre de mission
  const year = new Date().getFullYear();
  const prefix = `OM-${year}-`;
  const [{ count }] = await db
    .select({ count: sql<number>`count(*)::int` })
    .from(deplacementsTable)
    .where(ilike(deplacementsTable.numero, `${prefix}%`));
  const omNumero = `${prefix}${String((count ?? 0) + 1).padStart(4, '0')}`;

  // Créer l'ordre de mission
  const [deplacement] = await db
    .insert(deplacementsTable)
    .values({
      numero: omNumero,
      vehiculeId: parsed.data.vehiculeId,
      chauffeurId: demande.chauffeurId,
      demandeId: demande.id,
      serviceDemandeurId: demande.serviceDemandeurId,
      objet: parsed.data.objet ?? `Mission véhicule ${vehicule.immatriculation}`,
      destination: parsed.data.destination ?? null,
      dateDepart: parsed.data.dateDepart,
      dateRetourPrevue: parsed.data.dateRetourPrevue ?? null,
      heureDepartPrevue: parsed.data.heureDepartPrevue ?? null,
      observations: parsed.data.observations ?? null,
      statut: 'creee',
      createdBy: req.user!.username
    })
    .returning();

  // Marquer la demande comme validée
  const [updated] = await db
    .update(demandeChauffeurTable)
    .set({
      statut: 'validee',
      missionId: deplacement!.id,
      validePar: req.user!.username,
      updatedAt: new Date()
    })
    .where(eq(demandeChauffeurTable.id, id))
    .returning();

  // Mettre à jour le statut du chauffeur en "en_mission" — dès la validation,
  // avant même l'acceptation par le chauffeur, pour éviter qu'un autre
  // service ne le sélectionne pendant qu'il patiente.
  await db.update(chauffeursTable)
    .set({ statut: 'en_mission', updatedAt: new Date() })
    .where(eq(chauffeursTable.id, demande.chauffeurId));

  // Verrouiller le véhicule immédiatement pour la même raison (empêche le
  // double affectation d'un véhicule à deux demandes en attente d'acceptation).
  await db.update(vehiculesTable)
    .set({ statut: 'en_mission', updatedAt: new Date() })
    .where(eq(vehiculesTable.id, parsed.data.vehiculeId));

  // Faire passer l'ordre de mission de "Créée" à "En attente d'acceptation" :
  // c'est seulement à partir de ce moment que le chauffeur voit sa mission
  // complète (destination, horaires, etc.) avec le bouton "Accepter la
  // mission" dans son portail. Avant, il ne doit voir qu'un message
  // d'attente, sans aucun détail ni bouton.
  const transition = await applyTransition(
    deplacement!.id,
    'en_attente_acceptation',
    { commentaire: `Ordre de mission créé depuis la demande ${demande.numero}.` },
    req.user!.username
  );

  broadcastNotifications().catch(() => {});

  res.status(201).json({ demande: updated, deplacement: transition.ok ? transition.deplacement : deplacement });
});

/* ── Refuser une demande ────────────────────────────────────────────── */
const refuserSchema = z.object({
  motifRefus: z.string().max(500).optional()
});

router.patch('/demande-chauffeur/:id/refuser', requirePermission('business.write'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });

  const parsed = refuserSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.issues[0]?.message ?? 'Données invalides.' });

  const [demande] = await db.select().from(demandeChauffeurTable).where(eq(demandeChauffeurTable.id, id));
  if (!demande || demande.deletedAt) return res.status(404).json({ error: 'Demande introuvable.' });

  if (demande.statut !== 'en_attente' && demande.statut !== 'assignee' && demande.statut !== 'confirmee') {
    return res.status(400).json({ error: `Impossible de refuser : la demande est « ${STATUT_LABELS[demande.statut]} ».` });
  }

  const [updated] = await db
    .update(demandeChauffeurTable)
    .set({
      statut: 'refusee',
      motifRefus: parsed.data.motifRefus ?? null,
      updatedAt: new Date()
    })
    .where(eq(demandeChauffeurTable.id, id))
    .returning();

  res.json({ demande: updated });
});

/* ── Détail d'une demande ───────────────────────────────────────────── */
router.get('/demande-chauffeur/:id', requirePermission('business.read'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });

  const [demande] = await db.select().from(demandeChauffeurTable).where(eq(demandeChauffeurTable.id, id));
  if (!demande || demande.deletedAt) return res.status(404).json({ error: 'Demande introuvable.' });

  let chauffeur = null;
  let deplacement = null;

  if (demande.chauffeurId) {
    [chauffeur] = await db.select().from(chauffeursTable).where(eq(chauffeursTable.id, demande.chauffeurId));
  }
  if (demande.missionId) {
    [deplacement] = await db.select().from(deplacementsTable).where(eq(deplacementsTable.id, demande.missionId));
  }

  const serviceName = await db
    .select({ name: orgNodesTable.name })
    .from(orgNodesTable)
    .where(eq(orgNodesTable.id, demande.serviceDemandeurId))
    .then((rows) => rows[0]?.name ?? null);

  res.json({ demande, chauffeur, deplacement, serviceName });
});

/* ── Stats pour le tableau de bord ──────────────────────────────────── */
router.get('/demande-chauffeur/stats', requirePermission('business.read'), async (_req, res) => {
  const rows = await db
    .select()
    .from(demandeChauffeurTable)
    .where(isNull(demandeChauffeurTable.deletedAt));

  const enAttente = rows.filter((r) => r.statut === 'en_attente').length;
  const assignees = rows.filter((r) => r.statut === 'assignee').length;
  const validees = rows.filter((r) => r.statut === 'validee').length;
  const urgentes = rows.filter((r) => r.priorite !== 'normale' && r.statut === 'en_attente').length;
  const total = rows.length;

  res.json({ enAttente, assignees, validees, urgentes, total });
});

export default router;
