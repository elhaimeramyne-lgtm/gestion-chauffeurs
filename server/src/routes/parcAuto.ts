/**
 * Parc Automobile & Déplacements — Service de la Logistique et des Moyens
 * Généraux.
 *
 * Workflow complet à 9+ statuts (missionEngine) :
 *   creee → en_attente_acceptation → acceptee → en_route → arrive →
 *   mission_en_cours → terminee → retour → arrive_siege → cloturee
 *
 * Véhicules :
 *  GET   /parc-auto/vehicules            — liste (filtres : statut, recherche)
 *  GET   /parc-auto/vehicules/stats      — indicateurs
 *  GET   /parc-auto/vehicules/:id        — détail + historique + déplacements liés
 *  POST  /parc-auto/vehicules            — créer (ADMIN+ via business.write)
 *  PATCH /parc-auto/vehicules/:id        — modifier
 *  PATCH /parc-auto/vehicules/:id/statut — changer le statut manuellement
 *  DELETE /parc-auto/vehicules/:id       — suppression douce
 *
 * Déplacements (ordres de mission) :
 *  GET     /parc-auto/deplacements            — liste (filtres : statut, vehiculeId, serviceId, recherche)
 *  GET     /parc-auto/deplacements/:id        — détail + timeline + photos + GPS
 *  POST    /parc-auto/deplacements            — créer (statut 'creee')
 *  PATCH   /parc-auto/deplacements/:id        — modifier (statut creee/en_attente_acceptation uniquement)
 *  PATCH   /parc-auto/deplacements/:id/statut — transition via missionEngine
 *  DELETE  /parc-auto/deplacements/:id        — suppression douce
 *  GET     /parc-auto/deplacements/:id/events — timeline d'une mission
 *  GET     /parc-auto/deplacements/:id/photos — photos d'une mission
 *  POST    /parc-auto/deplacements/:id/assigner — assigner le chauffeur
 */
import { Router } from 'express';
import { z } from 'zod';
import { and, desc, eq, ilike, inArray, isNull, or, sql } from 'drizzle-orm';
import multer from 'multer';
import path from 'path';
import fs from 'fs';
import {
  db, vehiculesTable, vehiculeEventsTable, deplacementsTable,
  orgNodesTable, chauffeursTable, deplacementPassagersTable,
  deplacementEventsTable, deplacementPhotosTable, vehiculeAffectationsTable
} from '../db.js';
import { requireAuth, requirePermission } from '../middleware/auth.js';
import { applyTransition, getDeplacementDetail, STATUT_LABELS } from '../lib/missionEngine.js';
import { computeAlertesResume } from '../lib/alertsEngine.js';
import { assignVehicule, unassignVehicule } from '../lib/affectations.js';
import type { VehiculeRow } from '../schema/vehicules.js';

const router = Router();
router.use(requireAuth);

/* ── Upload photo véhicule ────────────────────────────────────────── */
const PHOTO_UPLOAD_BASE = path.join(process.cwd(), 'uploads', 'vehicules');
const photoStorage = multer.diskStorage({
  destination: (_req, _file, cb) => {
    fs.mkdirSync(PHOTO_UPLOAD_BASE, { recursive: true });
    cb(null, PHOTO_UPLOAD_BASE);
  },
  filename: (_req, file, cb) => {
    const ts = Date.now();
    const safe = file.originalname.replace(/[^a-zA-Z0-9._-]/g, '_');
    cb(null, `${ts}-${safe}`);
  },
});
const uploadPhoto = multer({ storage: photoStorage, limits: { fileSize: 10 * 1024 * 1024 } });

type VehiculeStatut = VehiculeRow['statut'];
type DeplacementStatut = 'creee' | 'en_attente_acceptation' | 'acceptee' | 'en_route' | 'arrive' | 'mission_en_cours' | 'terminee' | 'retour' | 'arrive_siege' | 'cloturee' | 'annule';

/* ═══════════════════════════════════════════════════════════════════════
 * HELPERS
 * ═══════════════════════════════════════════════════════════════════════ */

async function getMissionsActuelles(vehiculeIds: number[]): Promise<Map<number, {
  numero: string; destination: string | null; chauffeurNom: string | null;
  dateDepart: string; dateRetourPrevue: string | null;
}>> {
  const map = new Map();
  if (vehiculeIds.length === 0) return map;
  const statutsActifs: DeplacementStatut[] = ['acceptee', 'en_route', 'arrive', 'mission_en_cours', 'terminee', 'retour', 'arrive_siege'];
  const rows = await db
    .select()
    .from(deplacementsTable)
    .where(and(inArray(deplacementsTable.vehiculeId, vehiculeIds), inArray(deplacementsTable.statut, statutsActifs as any)));
  const chauffeurIds = rows.map((r) => r.chauffeurId).filter((id): id is number => id != null);
  const chauffeurs = chauffeurIds.length
    ? await db.select({ id: chauffeursTable.id, nom: chauffeursTable.nom }).from(chauffeursTable).where(inArray(chauffeursTable.id, chauffeurIds))
    : [];
  const chauffeurNameById = new Map(chauffeurs.map((c) => [c.id, c.nom]));
  for (const r of rows) {
    if (r.vehiculeId == null) continue;
    map.set(r.vehiculeId, {
      numero: r.numero,
      destination: r.destination,
      chauffeurNom: r.chauffeurId ? chauffeurNameById.get(r.chauffeurId) ?? null : null,
      dateDepart: r.dateDepart,
      dateRetourPrevue: r.dateRetourPrevue
    });
  }
  return map;
}

/* ═══════════════════════════════════════════════════════════════════════
 * VÉHICULES
 * ═══════════════════════════════════════════════════════════════════════ */

router.get('/parc-auto/vehicules', requirePermission('business.read'), async (req, res) => {
  const { statut, search } = req.query;
  const conditions = [isNull(vehiculesTable.deletedAt)];
  if (typeof statut === 'string' && statut) {
    conditions.push(eq(vehiculesTable.statut, statut as VehiculeStatut));
  }
  if (typeof search === 'string' && search.trim()) {
    const s = `%${search.trim()}%`;
    const cond = or(
      ilike(vehiculesTable.immatriculation, s),
      ilike(vehiculesTable.marque, s),
      ilike(vehiculesTable.modele, s)
    );
    if (cond) conditions.push(cond);
  }
  const vehicules = await db
    .select()
    .from(vehiculesTable)
    .where(and(...conditions))
    .orderBy(vehiculesTable.immatriculation);

  const missions = await getMissionsActuelles(vehicules.filter((v) => v.statut === 'en_mission').map((v) => v.id));
  const enriched = vehicules.map((v) => ({ ...v, missionActuelle: missions.get(v.id) ?? null }));

  res.json({ vehicules: enriched });
});

router.get('/parc-auto/vehicules/stats', requirePermission('business.read'), async (_req, res) => {
  const rows = await db.select().from(vehiculesTable).where(isNull(vehiculesTable.deletedAt));

  const parseDMY = (s: string | null): Date | null => {
    if (!s) return null;
    const m = /^(\d{2})\/(\d{2})\/(\d{4})$/.exec(s);
    if (!m) return null;
    return new Date(Number(m[3]), Number(m[2]) - 1, Number(m[1]));
  };
  const in30Days = new Date();
  in30Days.setDate(in30Days.getDate() + 30);
  const now = new Date();

  const echeancesProches = rows.filter((v) => {
    const assurance = parseDMY(v.assuranceExpiration);
    const visite = parseDMY(v.visiteTechniqueExpiration);
    const vidange = parseDMY(v.vidangeExpiration);
    return (
      (assurance && assurance <= in30Days && assurance >= now) ||
      (visite && visite <= in30Days && visite >= now) ||
      (vidange && vidange <= in30Days && vidange >= now)
    );
  }).length;

  res.json({
    total: rows.length,
    disponibles: rows.filter((v) => v.statut === 'disponible').length,
    enMission: rows.filter((v) => v.statut === 'en_mission').length,
    enMaintenance: rows.filter((v) => v.statut === 'maintenance').length,
    horsService: rows.filter((v) => v.statut === 'hors_service').length,
    echeancesProches
  });
});

router.get('/parc-auto/vehicules/:id', requirePermission('business.read'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });

  const [vehicule] = await db.select().from(vehiculesTable).where(eq(vehiculesTable.id, id));
  if (!vehicule || vehicule.deletedAt) return res.status(404).json({ error: 'Véhicule introuvable.' });

  const events = await db
    .select()
    .from(vehiculeEventsTable)
    .where(eq(vehiculeEventsTable.vehiculeId, id))
    .orderBy(desc(vehiculeEventsTable.createdAt));

  const deplacements = await db
    .select()
    .from(deplacementsTable)
    .where(and(eq(deplacementsTable.vehiculeId, id), isNull(deplacementsTable.deletedAt)))
    .orderBy(desc(deplacementsTable.createdAt))
    .limit(20);

  const missions = await getMissionsActuelles(vehicule.statut === 'en_mission' ? [id] : []);

  res.json({ vehicule: { ...vehicule, missionActuelle: missions.get(id) ?? null }, events, deplacements });
});

const createVehiculeSchema = z.object({
  immatriculation: z.string().min(2).max(30),
  marque: z.string().min(1).max(80),
  modele: z.string().min(1).max(80),
  annee: z.number().int().min(1980).max(2100).optional(),
  carburant: z.enum(['essence', 'diesel', 'hybride', 'electrique']).default('diesel'),
  kilometrage: z.number().int().min(0).default(0),
  assuranceExpiration: z.string().regex(/^\d{2}\/\d{2}\/\d{4}$/).optional(),
  visiteTechniqueExpiration: z.string().regex(/^\d{2}\/\d{2}\/\d{4}$/).optional(),
  derniereVidange: z.string().regex(/^\d{2}\/\d{2}\/\d{4}$/).optional(),
  vidangeExpiration: z.string().regex(/^\d{2}\/\d{2}\/\d{4}$/).optional(),
  kilometrageDerniereVidange: z.number().int().min(0).optional(),
  kilometrageProchaineVidange: z.number().int().min(0).optional(),
  typeHuile: z.string().max(50).optional(),
  garageVidange: z.string().max(150).optional(),
  vidangeObservations: z.string().max(1000).optional(),
  jawazNumero: z.string().max(50).optional(),
  jawazSolde: z.number().min(0).optional(),
  jawazDerniereRecharge: z.string().regex(/^\d{2}\/\d{2}\/\d{4}$/).optional(),
  jawazSeuilAlerte: z.number().min(0).optional(),
  chauffeurAttitreId: z.number().int().positive().optional(),
  notes: z.string().max(1000).optional()
});

router.post('/parc-auto/vehicules', requirePermission('business.write'), async (req, res) => {
  const parsed = createVehiculeSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.issues[0]?.message ?? 'Données invalides.' });

  const [existing] = await db.select({ id: vehiculesTable.id }).from(vehiculesTable).where(eq(vehiculesTable.immatriculation, parsed.data.immatriculation));
  if (existing) return res.status(409).json({ error: 'Un véhicule avec cette immatriculation existe déjà.' });

  const [vehicule] = await db.insert(vehiculesTable).values({ ...parsed.data, statut: 'disponible' }).returning();
  await db.insert(vehiculeEventsTable).values({
    vehiculeId: vehicule!.id,
    statut: 'disponible',
    commentaire: 'Véhicule ajouté au parc.',
    actionPar: req.user!.username
  });
  res.status(201).json({ vehicule });
});

/** GET /parc-auto/alertes — résumé des alertes pour les administrateurs / responsables
 *  (assurances, visites techniques, vidanges, Jawaz, permis). Recalculé à la volée. */
router.get('/parc-auto/alertes', requirePermission('business.read'), async (_req, res) => {
  const resume = await computeAlertesResume();
  res.json(resume);
});

/* ── Responsabilité du véhicule (affectation à un chauffeur) ─────────── */
const affectationSchema = z.object({ chauffeurId: z.number().int().positive() });

router.post('/parc-auto/vehicules/:id/affectation', requirePermission('business.write'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });
  const parsed = affectationSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: 'Chauffeur invalide.' });

  const [vehicule] = await db.select({ id: vehiculesTable.id }).from(vehiculesTable).where(and(eq(vehiculesTable.id, id), isNull(vehiculesTable.deletedAt)));
  if (!vehicule) return res.status(404).json({ error: 'Véhicule introuvable.' });
  const [chauffeur] = await db.select({ id: chauffeursTable.id }).from(chauffeursTable).where(and(eq(chauffeursTable.id, parsed.data.chauffeurId), isNull(chauffeursTable.deletedAt)));
  if (!chauffeur) return res.status(404).json({ error: 'Chauffeur introuvable.' });

  await assignVehicule(id, parsed.data.chauffeurId, req.user!.username);
  const [updated] = await db.select().from(vehiculesTable).where(eq(vehiculesTable.id, id));
  res.json({ vehicule: updated });
});

router.delete('/parc-auto/vehicules/:id/affectation', requirePermission('business.write'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });
  const [vehicule] = await db.select({ id: vehiculesTable.id }).from(vehiculesTable).where(and(eq(vehiculesTable.id, id), isNull(vehiculesTable.deletedAt)));
  if (!vehicule) return res.status(404).json({ error: 'Véhicule introuvable.' });
  await unassignVehicule(id);
  const [updated] = await db.select().from(vehiculesTable).where(eq(vehiculesTable.id, id));
  res.json({ vehicule: updated });
});

router.get('/parc-auto/vehicules/:id/affectations', requirePermission('business.read'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });
  const rows = await db
    .select()
    .from(vehiculeAffectationsTable)
    .where(eq(vehiculeAffectationsTable.vehiculeId, id))
    .orderBy(desc(vehiculeAffectationsTable.createdAt));
  const chauffeurIds = [...new Set(rows.map((r) => r.chauffeurId))];
  const chauffeurs = chauffeurIds.length
    ? await db.select({ id: chauffeursTable.id, nom: chauffeursTable.nom }).from(chauffeursTable).where(inArray(chauffeursTable.id, chauffeurIds))
    : [];
  const nomById = new Map(chauffeurs.map((c) => [c.id, c.nom]));
  res.json({ affectations: rows.map((r) => ({ ...r, chauffeurNom: nomById.get(r.chauffeurId) ?? '—' })) });
});

/** POST /parc-auto/vehicules/:id/photo — photo du véhicule ("Mon véhicule" du portail chauffeur). */
router.post('/parc-auto/vehicules/:id/photo', requirePermission('business.write'), uploadPhoto.single('photo'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });
  if (!req.file) return res.status(400).json({ error: 'Fichier photo requis (champ "photo").' });
  const [vehicule] = await db.select({ id: vehiculesTable.id }).from(vehiculesTable).where(and(eq(vehiculesTable.id, id), isNull(vehiculesTable.deletedAt)));
  if (!vehicule) {
    fs.unlink(req.file.path, () => {});
    return res.status(404).json({ error: 'Véhicule introuvable.' });
  }
  const url = `/api/uploads/vehicules/${req.file.filename}`;
  const [updated] = await db.update(vehiculesTable).set({ photoUrl: url, updatedAt: new Date() }).where(eq(vehiculesTable.id, id)).returning();
  res.json({ vehicule: updated });
});

const patchVehiculeSchema = z.object({
  marque: z.string().min(1).max(80).optional(),
  modele: z.string().min(1).max(80).optional(),
  annee: z.number().int().min(1980).max(2100).nullable().optional(),
  carburant: z.enum(['essence', 'diesel', 'hybride', 'electrique']).optional(),
  kilometrage: z.number().int().min(0).optional(),
  assuranceExpiration: z.string().regex(/^\d{2}\/\d{2}\/\d{4}$/).nullable().optional(),
  visiteTechniqueExpiration: z.string().regex(/^\d{2}\/\d{2}\/\d{4}$/).nullable().optional(),
  derniereVidange: z.string().regex(/^\d{2}\/\d{2}\/\d{4}$/).nullable().optional(),
  vidangeExpiration: z.string().regex(/^\d{2}\/\d{2}\/\d{4}$/).nullable().optional(),
  kilometrageDerniereVidange: z.number().int().min(0).nullable().optional(),
  kilometrageProchaineVidange: z.number().int().min(0).nullable().optional(),
  typeHuile: z.string().max(50).nullable().optional(),
  garageVidange: z.string().max(150).nullable().optional(),
  vidangeObservations: z.string().max(1000).nullable().optional(),
  jawazNumero: z.string().max(50).nullable().optional(),
  jawazSolde: z.number().min(0).optional(),
  jawazDerniereRecharge: z.string().regex(/^\d{2}\/\d{2}\/\d{4}$/).nullable().optional(),
  jawazSeuilAlerte: z.number().min(0).optional(),
  chauffeurAttitreId: z.number().int().positive().nullable().optional(),
  etatPneus: z.enum(['bon_etat', 'usure_avant', 'usure_arriere', 'crevaison', 'pression_faible']).nullable().optional(),
  etatBatterie: z.enum(['bonne', 'faible', 'a_remplacer']).nullable().optional(),
  etatFreins: z.enum(['normaux', 'bruit', 'usure']).nullable().optional(),
  etatEclairage: z.enum(['fonctionnel', 'ampoule_grillee']).nullable().optional(),
  etatClimatisation: z.enum(['fonctionne', 'panne']).nullable().optional(),
  notes: z.string().max(1000).nullable().optional()
});

router.patch('/parc-auto/vehicules/:id', requirePermission('business.write'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });
  const parsed = patchVehiculeSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.issues[0]?.message ?? 'Données invalides.' });

  // chauffeurAttitreId passe par assignVehicule/unassignVehicule (historique
  // des affectations) plutôt que par un simple UPDATE, pour rester cohérent
  // avec les endpoints dédiés /vehicules/:id/affectation.
  const { chauffeurAttitreId, ...rest } = parsed.data;
  if (chauffeurAttitreId !== undefined) {
    if (chauffeurAttitreId != null) await assignVehicule(id, chauffeurAttitreId, req.user!.username);
    else await unassignVehicule(id);
  }

  const [updated] = await db
    .update(vehiculesTable)
    .set({ ...rest, updatedAt: new Date() })
    .where(and(eq(vehiculesTable.id, id), isNull(vehiculesTable.deletedAt)))
    .returning();
  if (!updated) return res.status(404).json({ error: 'Véhicule introuvable.' });
  res.json({ vehicule: updated });
});

const vehiculeStatutSchema = z.object({
  statut: z.enum(['disponible', 'en_mission', 'maintenance', 'hors_service']),
  commentaire: z.string().max(500).optional()
});

router.patch('/parc-auto/vehicules/:id/statut', requirePermission('business.write'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });
  const parsed = vehiculeStatutSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.issues[0]?.message ?? 'Données invalides.' });

  const [vehicule] = await db.select().from(vehiculesTable).where(eq(vehiculesTable.id, id));
  if (!vehicule || vehicule.deletedAt) return res.status(404).json({ error: 'Véhicule introuvable.' });

  if (vehicule.statut === 'en_mission' && parsed.data.statut !== 'en_mission') {
    const [activeMission] = await db
      .select({ id: deplacementsTable.id })
      .from(deplacementsTable)
      .where(and(eq(deplacementsTable.vehiculeId, id), inArray(deplacementsTable.statut, ['acceptee', 'en_route', 'arrive', 'mission_en_cours', 'terminee', 'retour', 'arrive_siege'] as any)));
    if (activeMission) {
      return res.status(400).json({ error: 'Ce véhicule est actuellement en mission — clôturez le déplacement en cours avant de changer son statut.' });
    }
  }

  const [updated] = await db
    .update(vehiculesTable)
    .set({ statut: parsed.data.statut, updatedAt: new Date() })
    .where(eq(vehiculesTable.id, id))
    .returning();

  await db.insert(vehiculeEventsTable).values({
    vehiculeId: id,
    statut: parsed.data.statut,
    commentaire: parsed.data.commentaire,
    actionPar: req.user!.username
  });

  res.json({ vehicule: updated });
});

router.delete('/parc-auto/vehicules/:id', requirePermission('business.delete'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });
  const [row] = await db
    .update(vehiculesTable)
    .set({ deletedAt: new Date(), deletedBy: req.user!.username })
    .where(and(eq(vehiculesTable.id, id), isNull(vehiculesTable.deletedAt)))
    .returning();
  if (!row) return res.status(404).json({ error: 'Véhicule introuvable.' });
  res.json({ ok: true });
});

/* ═══════════════════════════════════════════════════════════════════════
 * DÉPLACEMENTS
 * ═══════════════════════════════════════════════════════════════════════ */

async function generateOmNumero(): Promise<string> {
  const year = new Date().getFullYear();
  const prefix = `OM-${year}-`;
  const [{ count }] = await db
    .select({ count: sql<number>`count(*)::int` })
    .from(deplacementsTable)
    .where(ilike(deplacementsTable.numero, `${prefix}%`));
  return `${prefix}${String((count ?? 0) + 1).padStart(4, '0')}`;
}

/** Statuts dans lesquels un déplacement peut encore être modifié. */
const MODIFIABLE_STATUTS: DeplacementStatut[] = ['creee', 'en_attente_acceptation'];

router.get('/parc-auto/deplacements', requirePermission('business.read'), async (req, res) => {
  const { statut, vehiculeId, serviceId, search } = req.query;
  const conditions = [isNull(deplacementsTable.deletedAt)];
  if (typeof statut === 'string' && statut) {
    conditions.push(eq(deplacementsTable.statut, statut as DeplacementStatut));
  }
  if (typeof vehiculeId === 'string' && vehiculeId) {
    const id = Number(vehiculeId);
    if (id) conditions.push(eq(deplacementsTable.vehiculeId, id));
  }
  if (typeof serviceId === 'string' && serviceId) {
    const id = Number(serviceId);
    if (id) conditions.push(eq(deplacementsTable.serviceDemandeurId, id));
  }
  if (typeof search === 'string' && search.trim()) {
    const s = `%${search.trim()}%`;
    const cond = or(ilike(deplacementsTable.numero, s), ilike(deplacementsTable.objet, s), ilike(deplacementsTable.destination, s));
    if (cond) conditions.push(cond);
  }
  const deplacements = await db
    .select()
    .from(deplacementsTable)
    .where(and(...conditions))
    .orderBy(desc(deplacementsTable.createdAt))
    .limit(500);
  res.json({ deplacements });
});

router.get('/parc-auto/deplacements/:id', requirePermission('business.read'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });

  const detail = await getDeplacementDetail(id);
  if (!detail) return res.status(404).json({ error: 'Déplacement introuvable.' });

  // Enrichir avec les passagers
  const passagers = await db
    .select()
    .from(deplacementPassagersTable)
    .where(eq(deplacementPassagersTable.deplacementId, id));

  res.json({ ...detail, passagers });
});

/** GET /parc-auto/deplacements/:id/events — Timeline d'une mission. */
router.get('/parc-auto/deplacements/:id/events', requirePermission('business.read'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });
  const events = await db
    .select()
    .from(deplacementEventsTable)
    .where(eq(deplacementEventsTable.deplacementId, id))
    .orderBy(desc(deplacementEventsTable.createdAt));
  res.json({ events });
});

/** GET /parc-auto/deplacements/:id/photos — Photos d'une mission. */
router.get('/parc-auto/deplacements/:id/photos', requirePermission('business.read'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });
  const photos = await db
    .select()
    .from(deplacementPhotosTable)
    .where(eq(deplacementPhotosTable.deplacementId, id))
    .orderBy(desc(deplacementPhotosTable.createdAt));
  res.json({ photos });
});

const createDeplacementSchema = z.object({
  vehiculeId: z.number().int().positive(),
  chauffeurId: z.number().int().positive().optional(),
  demandeId: z.number().int().positive().optional(),
  serviceDemandeurId: z.number().int().positive(),
  objet: z.string().min(3).max(200),
  destination: z.string().max(200).optional(),
  dateDepart: z.string().regex(/^\d{2}\/\d{2}\/\d{4}$/),
  dateRetourPrevue: z.string().regex(/^\d{2}\/\d{2}\/\d{4}$/).optional(),
  heureDepartPrevue: z.string().regex(/^\d{2}:\d{2}$/).optional(),
  observations: z.string().max(500).optional(),
  passagers: z.array(z.object({
    nom: z.string().min(1).max(150),
    serviceId: z.number().int().positive().nullable().optional()
  })).max(30).optional()
});

router.post('/parc-auto/deplacements', requirePermission('business.write'), async (req, res) => {
  const parsed = createDeplacementSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.issues[0]?.message ?? 'Données invalides.' });

  const [vehicule] = await db.select().from(vehiculesTable).where(eq(vehiculesTable.id, parsed.data.vehiculeId));
  if (!vehicule || vehicule.deletedAt) return res.status(400).json({ error: 'Véhicule introuvable.' });
  if (vehicule.statut !== 'disponible') {
    const missions = await getMissionsActuelles(vehicule.statut === 'en_mission' ? [vehicule.id] : []);
    const mission = missions.get(vehicule.id);
    const messages: Record<string, string> = {
      disponible: '',
      en_mission: mission
        ? `Ce véhicule est actuellement en mission à ${mission.destination || 'destination inconnue'} (retour prévu le ${mission.dateRetourPrevue || 'non précisé'}).`
        : 'Ce véhicule est actuellement en mission.',
      maintenance: 'Ce véhicule est actuellement en maintenance et ne peut pas être réservé.',
      hors_service: 'Ce véhicule est actuellement hors service et ne peut pas être réservé.'
    };
    return res.status(400).json({ error: messages[vehicule.statut] || 'Véhicule non disponible.' });
  }

  if (parsed.data.chauffeurId) {
    const [chauffeur] = await db.select().from(chauffeursTable).where(eq(chauffeursTable.id, parsed.data.chauffeurId));
    if (!chauffeur || chauffeur.deletedAt) return res.status(400).json({ error: 'Chauffeur introuvable.' });
    if (chauffeur.statut !== 'disponible') {
      return res.status(400).json({ error: `Ce chauffeur n'est pas disponible actuellement (statut : ${chauffeur.statut}).` });
    }
  }

  const [service] = await db
    .select({ id: orgNodesTable.id })
    .from(orgNodesTable)
    .where(and(eq(orgNodesTable.id, parsed.data.serviceDemandeurId), isNull(orgNodesTable.deletedAt)));
  if (!service) return res.status(400).json({ error: 'Service demandeur introuvable dans l\'organigramme.' });

  const { passagers, ...deplacementData } = parsed.data;
  const numero = await generateOmNumero();

  const [deplacement] = await db
    .insert(deplacementsTable)
    .values({
      ...deplacementData,
      numero,
      statut: 'creee',
      createdBy: req.user!.username,
    })
    .returning();

  if (passagers && passagers.length > 0) {
    await db.insert(deplacementPassagersTable).values(
      passagers.map((p) => ({ deplacementId: deplacement!.id, nom: p.nom, serviceId: p.serviceId ?? null }))
    );
  }

  // Si un chauffeur est assigné, auto-soumettre en attente d'acceptation
  if (deplacement!.chauffeurId) {
    const autoResult = await applyTransition(
      deplacement!.id,
      'en_attente_acceptation',
      { commentaire: 'Assigné automatiquement lors de la création.' },
      req.user!.username
    );
    if (autoResult.ok) {
      return res.status(201).json({ deplacement: autoResult.deplacement });
    }
  }

  res.status(201).json({ deplacement });
});

const patchDeplacementSchema = z.object({
  vehiculeId: z.number().int().positive().optional(),
  chauffeurId: z.number().int().positive().nullable().optional(),
  objet: z.string().min(3).max(200).optional(),
  destination: z.string().max(200).nullable().optional(),
  dateDepart: z.string().regex(/^\d{2}\/\d{2}\/\d{4}$/).optional(),
  dateRetourPrevue: z.string().regex(/^\d{2}\/\d{2}\/\d{4}$/).nullable().optional(),
  heureDepartPrevue: z.string().regex(/^\d{2}:\d{2}$/).nullable().optional(),
  observations: z.string().max(500).nullable().optional(),
  passagers: z.array(z.object({
    nom: z.string().min(1).max(150),
    serviceId: z.number().int().positive().nullable().optional()
  })).max(30).optional()
});

router.patch('/parc-auto/deplacements/:id', requirePermission('business.write'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });
  const parsed = patchDeplacementSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.issues[0]?.message ?? 'Données invalides.' });

  const [existing] = await db.select().from(deplacementsTable).where(eq(deplacementsTable.id, id));
  if (!existing || existing.deletedAt) return res.status(404).json({ error: 'Déplacement introuvable.' });
  if (!(MODIFIABLE_STATUTS as string[]).includes(existing.statut)) {
    return res.status(400).json({ error: 'Seul un déplacement encore « Créé » ou « En attente d\'acceptation » peut être modifié.' });
  }

  if (parsed.data.vehiculeId && parsed.data.vehiculeId !== existing.vehiculeId) {
    const [vehicule] = await db.select().from(vehiculesTable).where(eq(vehiculesTable.id, parsed.data.vehiculeId));
    if (!vehicule || vehicule.deletedAt) return res.status(400).json({ error: 'Véhicule introuvable.' });
    if (vehicule.statut !== 'disponible') {
      return res.status(400).json({ error: `Ce véhicule n'est pas disponible actuellement (statut : ${vehicule.statut}).` });
    }
  }
  if (parsed.data.chauffeurId) {
    const [chauffeur] = await db.select().from(chauffeursTable).where(eq(chauffeursTable.id, parsed.data.chauffeurId));
    if (!chauffeur || chauffeur.deletedAt) return res.status(400).json({ error: 'Chauffeur introuvable.' });
  }

  const { passagers, ...deplacementData } = parsed.data;

  const [updated] = await db
    .update(deplacementsTable)
    .set({ ...deplacementData, updatedAt: new Date() })
    .where(eq(deplacementsTable.id, id))
    .returning();

  if (passagers !== undefined) {
    await db.delete(deplacementPassagersTable).where(eq(deplacementPassagersTable.deplacementId, id));
    if (passagers.length > 0) {
      await db.insert(deplacementPassagersTable).values(
        passagers.map((p) => ({ deplacementId: id, nom: p.nom, serviceId: p.serviceId ?? null }))
      );
    }
  }

  res.json({ deplacement: updated });
});

const transitionDeplacementSchema = z.object({
  statut: z.enum([
    'en_attente_acceptation', 'acceptee', 'en_route', 'arrive',
    'mission_en_cours', 'terminee', 'retour', 'arrive_siege', 'cloturee', 'annule'
  ] as const),
  kilometrageDepart: z.number().int().min(0).optional(),
  kilometrageRetour: z.number().int().min(0).optional(),
  rapportMission: z.string().max(2000).optional(),
  dateRetourEffective: z.string().regex(/^\d{2}\/\d{2}\/\d{4}$/).optional(),
  commentaire: z.string().max(500).optional(),
  notesCloture: z.string().max(2000).optional(),
  consommationCarburant: z.number().min(0).optional(),
  distanceKm: z.number().int().min(0).optional(),
  observationsChauffeur: z.string().max(2000).optional(),
  lat: z.number().optional(),
  lng: z.number().optional(),
});

router.patch('/parc-auto/deplacements/:id/statut', requirePermission('business.write'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });
  const parsed = transitionDeplacementSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.issues[0]?.message ?? 'Données invalides.' });

  const result = await applyTransition(id, parsed.data.statut as DeplacementStatut, parsed.data, req.user!.username);
  if (!result.ok) return res.status(result.status).json({ error: result.error });
  res.json({ deplacement: result.deplacement });
});

router.delete('/parc-auto/deplacements/:id', requirePermission('business.delete'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });
  const [existing] = await db.select().from(deplacementsTable).where(eq(deplacementsTable.id, id));
  if (!existing || existing.deletedAt) return res.status(404).json({ error: 'Déplacement introuvable.' });
  const statutsBloques: DeplacementStatut[] = ['en_route', 'arrive', 'mission_en_cours', 'terminee', 'retour', 'arrive_siege'];
  if ((statutsBloques as string[]).includes(existing.statut)) {
    return res.status(400).json({ error: 'Impossible de supprimer une mission en cours — terminez-la ou annulez-la d\'abord.' });
  }
  const [row] = await db
    .update(deplacementsTable)
    .set({ deletedAt: new Date(), deletedBy: req.user!.username })
    .where(eq(deplacementsTable.id, id))
    .returning();
  if (!row) return res.status(404).json({ error: 'Déplacement introuvable.' });
  res.json({ ok: true });
});

/** POST /parc-auto/deplacements/:id/assigner — Assigner un chauffeur à une mission. */
const assignChauffeurSchema = z.object({
  chauffeurId: z.number().int().positive(),
});

router.post('/parc-auto/deplacements/:id/assigner', requirePermission('business.write'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });
  const parsed = assignChauffeurSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.issues[0]?.message ?? 'Données invalides.' });

  const [deplacement] = await db.select().from(deplacementsTable).where(and(eq(deplacementsTable.id, id), isNull(deplacementsTable.deletedAt)));
  if (!deplacement) return res.status(404).json({ error: 'Déplacement introuvable.' });
  if (!(MODIFIABLE_STATUTS as string[]).includes(deplacement.statut)) {
    return res.status(400).json({ error: 'Impossible de changer le chauffeur sur une mission déjà en cours.' });
  }

  const [chauffeur] = await db.select().from(chauffeursTable).where(eq(chauffeursTable.id, parsed.data.chauffeurId));
  if (!chauffeur || chauffeur.deletedAt) return res.status(400).json({ error: 'Chauffeur introuvable.' });

  const [updated] = await db
    .update(deplacementsTable)
    .set({ chauffeurId: parsed.data.chauffeurId, updatedAt: new Date() })
    .where(eq(deplacementsTable.id, id))
    .returning();

  res.json({ deplacement: updated });
});

export default router;

