/**
 * Ma Mission — portail dédié aux comptes de rôle CHAUFFEUR.
 *
 * Workflow complet à 9+ statuts (missionEngine) :
 *   creee → en_attente_acceptation → acceptee → en_route → arrive →
 *   mission_en_cours → terminee → retour → arrive_siege → cloturee
 *
 * Sécurité : seule la route GET /ma-mission renvoie la mission en cours.
 * Chaque action vérifie que la mission manipulée appartient bien au
 * chauffeur connecté (deplacement.chauffeurId === son propre chauffeurId)
 * — un chauffeur ne peut jamais agir sur la mission d'un collègue, même
 * en devinant un ID dans l'URL.
 *
 *  GET    /ma-mission                   — la mission active du chauffeur connecté
 *  GET    /ma-mission/historique        — ses dernières missions terminées
 *  GET    /ma-mission/:id/detail        — détail complet + timeline + photos
 *  POST   /ma-mission/:id/accept        — en_attente_acceptation → acceptee
 *  POST   /ma-mission/:id/demarrer      — acceptee → en_route (départ effectif)
 *  POST   /ma-mission/:id/arrivee       — en_route → arrive
 *  POST   /ma-mission/:id/commencer     — arrive → mission_en_cours
 *  POST   /ma-mission/:id/terminer      — mission_en_cours → terminee
 *  POST   /ma-mission/:id/retour        — terminee → retour
 *  POST   /ma-mission/:id/arrive-siege  — retour → arrive_siege
 *  POST   /ma-mission/:id/gps           — enregistrer un point GPS
 *  POST   /ma-mission/:id/photo         — uploader une photo
 *  POST   /ma-mission/:id/signature     — sauvegarder une signature
 */
import { Router } from 'express';
import type { Request, Response } from 'express';
import { z } from 'zod';
import { and, desc, eq, inArray, isNull, sql } from 'drizzle-orm';
import {
  db, deplacementsTable, deplacementPassagersTable, vehiculesTable, orgNodesTable, chauffeursTable,
  deplacementEventsTable, deplacementPhotosTable, demandeChauffeurTable,
  vehiculeDeclarationsTable, declarationEventsTable, declarationMediaTable
} from '../db.js';
import { requireAuth } from '../middleware/auth.js';
import { applyTransition, getDeplacementDetail } from '../lib/missionEngine.js';
import { computeChauffeurPortalAlertes, fetchLastPneusKmByVehicule } from '../lib/alertsEngine.js';
import { broadcastNotifications } from './notifications-sse.js';
import multer from 'multer';
import path from 'path';
import fs from 'fs';

const router = Router();
router.use(requireAuth);

/* ── Configuration du stockage photo ──────────────────────────────── */
const UPLOAD_BASE = process.env.UPLOAD_DIR ?? path.join(process.cwd(), 'uploads', 'missions');
const storage = multer.diskStorage({
  destination: (_req, _file, cb) => {
    fs.mkdirSync(UPLOAD_BASE, { recursive: true });
    cb(null, UPLOAD_BASE);
  },
  filename: (_req, file, cb) => {
    const ts = Date.now();
    const safe = file.originalname.replace(/[^a-zA-Z0-9._-]/g, '_');
    cb(null, `${ts}-${safe}`);
  },
});
const upload = multer({ storage, limits: { fileSize: 10 * 1024 * 1024 } }); // 10 MB max

/* ── HELPER : Résoudre le chauffeurId lié au compte connecté ─────── */

async function resolveChauffeurId(req: Request, res: Response): Promise<number | null> {
  if (req.user!.role !== 'CHAUFFEUR') {
    res.status(403).json({ error: 'Ce portail est réservé aux comptes chauffeur.' });
    return null;
  }
  const [chauffeur] = await db
    .select({ id: chauffeursTable.id })
    .from(chauffeursTable)
    .where(eq(chauffeursTable.userId, req.user!.userId));
  if (!chauffeur) {
    res.status(404).json({ error: "Ce compte n'est relié à aucune fiche chauffeur. Contactez un administrateur." });
    return null;
  }
  return chauffeur.id;
}

/** Vérifie que la mission :id appartient bien au chauffeur connecté. */
async function ownMissionOrFail(req: Request, res: Response, id: number, chauffeurId: number) {
  const [deplacement] = await db.select().from(deplacementsTable).where(eq(deplacementsTable.id, id));
  if (!deplacement || deplacement.deletedAt) {
    res.status(404).json({ error: 'Mission introuvable.' });
    return null;
  }
  if (deplacement.chauffeurId !== chauffeurId) {
    res.status(403).json({ error: "Cette mission n'est pas la vôtre." });
    return null;
  }
  return deplacement;
}

/** Extrait les coordonnées GPS du corps de la requête si présentes. */
function extractCoords(req: Request): { lat?: number; lng?: number } {
  const lat = typeof req.body?.lat === 'number' ? req.body.lat : undefined;
  const lng = typeof req.body?.lng === 'number' ? req.body.lng : undefined;
  return lat != null && lng != null ? { lat, lng } : {};
}

/* ═══════════════════════════════════════════════════════════════════════
 * ENDPOINTS
 * ═══════════════════════════════════════════════════════════════════════ */

/** GET /ma-mission — Mission active du chauffeur connecté. */
router.get('/ma-mission', async (req, res) => {
  const chauffeurId = await resolveChauffeurId(req, res);
  if (chauffeurId == null) return;

  const statutsActifs: string[] = [
    'creee', 'en_attente_acceptation', 'acceptee', 'en_route',
    'arrive', 'mission_en_cours', 'terminee', 'retour', 'arrive_siege'
  ];

  const [deplacement] = await db
    .select()
    .from(deplacementsTable)
    .where(and(
      eq(deplacementsTable.chauffeurId, chauffeurId),
      isNull(deplacementsTable.deletedAt),
      inArray(deplacementsTable.statut, statutsActifs as any)
    ))
    .orderBy(deplacementsTable.dateDepart)
    .limit(1);

  if (!deplacement) {
    // Le chauffeur n'a pas encore d'ordre de mission actif. Vérifier s'il a
    // été assigné à une demande de chauffeur — dans ce cas il peut
    // l'accepter ou la refuser directement depuis son portail, avant même
    // que le responsable ne crée l'ordre de mission.
    const [pendingRow] = await db
      .select()
      .from(demandeChauffeurTable)
      .where(and(
        eq(demandeChauffeurTable.chauffeurId, chauffeurId),
        eq(demandeChauffeurTable.statut, 'assignee'),
        isNull(demandeChauffeurTable.deletedAt)
      ))
      .orderBy(desc(demandeChauffeurTable.createdAt))
      .limit(1);

    let pendingDemande = null;
    if (pendingRow) {
      const [service] = await db
        .select({ name: orgNodesTable.name })
        .from(orgNodesTable)
        .where(eq(orgNodesTable.id, pendingRow.serviceDemandeurId));
      pendingDemande = {
        id: pendingRow.id,
        numero: pendingRow.numero,
        priorite: pendingRow.priorite,
        demandeurNom: pendingRow.demandeurNom,
        demandeurTelephone: pendingRow.demandeurTelephone,
        observations: pendingRow.observations,
        serviceName: service?.name ?? null
      };
    }
    // Une demande déjà acceptée par ce chauffeur mais pas encore validée
    // (ordre de mission pas encore créé) : affichage "patientez", sans bouton.
    const [confirmedRow] = pendingDemande
      ? []
      : await db
          .select({ numero: demandeChauffeurTable.numero })
          .from(demandeChauffeurTable)
          .where(and(
            eq(demandeChauffeurTable.chauffeurId, chauffeurId),
            eq(demandeChauffeurTable.statut, 'confirmee'),
            isNull(demandeChauffeurTable.deletedAt)
          ))
          .orderBy(desc(demandeChauffeurTable.createdAt))
          .limit(1);

    return res.json({ deplacement: null, pendingDemande, confirmedDemandeNumero: confirmedRow?.numero ?? null });
  }

  const [vehicule] = deplacement.vehiculeId
    ? await db.select().from(vehiculesTable).where(eq(vehiculesTable.id, deplacement.vehiculeId))
    : [null];
  const [service] = await db
    .select({ id: orgNodesTable.id, name: orgNodesTable.name })
    .from(orgNodesTable)
    .where(eq(orgNodesTable.id, deplacement.serviceDemandeurId));
  const passagers = await db
    .select()
    .from(deplacementPassagersTable)
    .where(eq(deplacementPassagersTable.deplacementId, deplacement.id));

  const events = await db
    .select()
    .from(deplacementEventsTable)
    .where(eq(deplacementEventsTable.deplacementId, deplacement.id))
    .orderBy(desc(deplacementEventsTable.createdAt));

  res.json({
    deplacement,
    vehicule: vehicule ?? null,
    serviceName: service?.name ?? null,
    passagers,
    events,
  });
});

/** POST /ma-mission/demande/:id/accepter — le chauffeur accepte la demande
 *  qui vient de lui être assignée (avant même la création de l'ordre de
 *  mission par le responsable). */
router.post('/ma-mission/demande/:id/accepter', async (req: Request, res: Response) => {
  const chauffeurId = await resolveChauffeurId(req, res);
  if (chauffeurId == null) return;
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });

  const [demande] = await db.select().from(demandeChauffeurTable).where(eq(demandeChauffeurTable.id, id));
  if (!demande || demande.deletedAt) return res.status(404).json({ error: 'Demande introuvable.' });
  if (demande.chauffeurId !== chauffeurId) {
    return res.status(403).json({ error: "Cette demande ne vous est pas assignée." });
  }
  if (demande.statut !== 'assignee') {
    return res.status(400).json({ error: 'Cette demande ne peut plus être acceptée.' });
  }

  const [updated] = await db
    .update(demandeChauffeurTable)
    .set({ statut: 'confirmee', updatedAt: new Date() })
    .where(eq(demandeChauffeurTable.id, id))
    .returning();

  broadcastNotifications().catch(() => {});
  res.json({ demande: updated });
});

/** POST /ma-mission/demande/:id/refuser — le chauffeur refuse la demande
 *  assignée : elle redevient "en attente" pour que le responsable choisisse
 *  un autre chauffeur. */
router.post('/ma-mission/demande/:id/refuser', async (req: Request, res: Response) => {
  const chauffeurId = await resolveChauffeurId(req, res);
  if (chauffeurId == null) return;
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });

  const [demande] = await db.select().from(demandeChauffeurTable).where(eq(demandeChauffeurTable.id, id));
  if (!demande || demande.deletedAt) return res.status(404).json({ error: 'Demande introuvable.' });
  if (demande.chauffeurId !== chauffeurId) {
    return res.status(403).json({ error: "Cette demande ne vous est pas assignée." });
  }
  if (demande.statut !== 'assignee') {
    return res.status(400).json({ error: 'Cette demande ne peut plus être refusée.' });
  }

  const motif = typeof req.body?.motif === 'string' ? req.body.motif.slice(0, 300) : null;
  const [updated] = await db
    .update(demandeChauffeurTable)
    .set({
      statut: 'en_attente',
      chauffeurId: null,
      assignePar: null,
      motifRefus: motif,
      updatedAt: new Date()
    })
    .where(eq(demandeChauffeurTable.id, id))
    .returning();

  // Le chauffeur redevient disponible immédiatement pour d'autres demandes.
  await db.update(chauffeursTable)
    .set({ statut: 'disponible', updatedAt: new Date() })
    .where(eq(chauffeursTable.id, chauffeurId));

  broadcastNotifications().catch(() => {});
  res.json({ demande: updated });
});

/** GET /ma-mission/dashboard — Tableau de bord du chauffeur : état de son
 *  véhicule habituel (assurance, visite technique, vidange), son solde
 *  Jawaz et ses statistiques cumulées (missions, kilomètres, temps de
 *  conduite, consommation moyenne). Actualisé uniquement à la demande
 *  (le portail ne l'interroge pas automatiquement). */
router.get('/ma-mission/dashboard', async (req, res) => {
  const chauffeurId = await resolveChauffeurId(req, res);
  if (chauffeurId == null) return;

  const [chauffeur] = await db.select().from(chauffeursTable).where(eq(chauffeursTable.id, chauffeurId));

  // Véhicule habituellement attitré à ce chauffeur (le cas échéant).
  const [vehiculeHabituel] = await db
    .select()
    .from(vehiculesTable)
    .where(eq(vehiculesTable.chauffeurAttitreId, chauffeurId));

  // Historique complet des missions clôturées de ce chauffeur, pour les stats.
  const clotureesRows = await db
    .select({
      id: deplacementsTable.id,
      distanceKm: deplacementsTable.distanceKm,
      dureeMission: deplacementsTable.dureeMission,
      consommationCarburant: deplacementsTable.consommationCarburant,
    })
    .from(deplacementsTable)
    .where(and(
      eq(deplacementsTable.chauffeurId, chauffeurId),
      isNull(deplacementsTable.deletedAt),
      eq(deplacementsTable.statut, 'cloturee')
    ));

  const missionsTerminees = clotureesRows.length;
  const kmParcourus = clotureesRows.reduce((sum, r) => sum + (r.distanceKm ?? 0), 0);
  const dureeTotaleMin = clotureesRows.reduce((sum, r) => sum + (r.dureeMission ?? 0), 0);
  const consosValides = clotureesRows
    .map((r) => r.consommationCarburant)
    .filter((v): v is number => v != null);
  const consommationMoyenne = consosValides.length
    ? Math.round((consosValides.reduce((a, b) => a + b, 0) / consosValides.length) * 10) / 10
    : null;

  // Photos envoyées (toutes missions confondues, pas seulement clôturées).
  const [{ count: photosEnvoyees }] = await db
    .select({ count: sql<number>`count(*)::int` })
    .from(deplacementPhotosTable)
    .innerJoin(deplacementsTable, eq(deplacementPhotosTable.deplacementId, deplacementsTable.id))
    .where(eq(deplacementsTable.chauffeurId, chauffeurId));

  // Missions en retard : date de retour prévue dépassée, mission pas encore clôturée/annulée.
  const enRetardRows = await db
    .select({ id: deplacementsTable.id })
    .from(deplacementsTable)
    .where(and(
      eq(deplacementsTable.chauffeurId, chauffeurId),
      isNull(deplacementsTable.deletedAt),
      sql`${deplacementsTable.statut} NOT IN ('cloturee', 'annule')`,
      sql`${deplacementsTable.dateRetourPrevue} ~ '^[0-9]{2}/[0-9]{2}/[0-9]{4}$' AND to_date(${deplacementsTable.dateRetourPrevue}, 'DD/MM/YYYY') < now()`
    ));

  const lastPneusKm = vehiculeHabituel ? (await fetchLastPneusKmByVehicule()).get(vehiculeHabituel.id) ?? null : null;

  res.json({
    chauffeur: chauffeur ? { jawazNumero: chauffeur.jawazNumero, jawazSolde: chauffeur.jawazSolde } : null,
    vehicule: vehiculeHabituel ?? null,
    alertes: chauffeur ? computeChauffeurPortalAlertes(chauffeur, vehiculeHabituel ?? null, lastPneusKm) : [],
    stats: {
      missionsTerminees,
      kmParcourus,
      dureeTotaleMin,
      consommationMoyenne,
      photosEnvoyees: photosEnvoyees ?? 0,
      missionsEnRetard: enRetardRows.length
    }
  });
});

/** GET /ma-mission/historique — Missions déjà closes. */
router.get('/ma-mission/historique', async (req, res) => {
  const chauffeurId = await resolveChauffeurId(req, res);
  if (chauffeurId == null) return;

  const historique = await db
    .select({
      id: deplacementsTable.id,
      numero: deplacementsTable.numero,
      destination: deplacementsTable.destination,
      dateDepart: deplacementsTable.dateDepart,
      statut: deplacementsTable.statut,
      objet: deplacementsTable.objet,
      createdAt: deplacementsTable.createdAt,
      updatedAt: deplacementsTable.updatedAt,
    })
    .from(deplacementsTable)
    .where(and(
      eq(deplacementsTable.chauffeurId, chauffeurId),
      isNull(deplacementsTable.deletedAt),
      inArray(deplacementsTable.statut, ['terminee', 'cloturee', 'annule'] as any)
    ))
    .orderBy(desc(deplacementsTable.updatedAt))
    .limit(50);

  res.json({ historique });
});

/** GET /ma-mission/:id/detail — Détail complet d'une mission (timeline, photos, GPS). */
router.get('/ma-mission/:id/detail', async (req, res) => {
  const chauffeurId = await resolveChauffeurId(req, res);
  if (chauffeurId == null) return;
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });
  const deplacement = await ownMissionOrFail(req, res, id, chauffeurId);
  if (!deplacement) return;

  const detail = await getDeplacementDetail(id);
  if (!detail) return res.status(404).json({ error: 'Détail introuvable.' });
  res.json(detail);
});

/* ── Actions du workflow ──────────────────────────────────────────── */

/**
 * Helper pour exécuter une transition et retourner la réponse appropriée.
 * Vérifie l'appartenance de la mission avant chaque action.
 */
async function executeTransition(
  req: Request,
  res: Response,
  targetStatut: string,
  extraFields: Record<string, unknown> = {}
) {
  const chauffeurId = await resolveChauffeurId(req, res);
  if (chauffeurId == null) return;
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });
  const deplacement = await ownMissionOrFail(req, res, id, chauffeurId);
  if (!deplacement) return;

  const coords = extractCoords(req);
  const result = await applyTransition(
    id,
    targetStatut as any,
    { ...coords, ...extraFields, commentaire: req.user!.username },
    req.user!.username
  );

  if (!result.ok) return res.status(result.status).json({ error: result.error });
  res.json({ deplacement: result.deplacement });
}

/** POST /ma-mission/:id/accept — Accepter la mission (en_attente_acceptation → acceptee). */
router.post('/ma-mission/:id/accept', async (req, res) => {
  await executeTransition(req, res, 'acceptee');
});

/** POST /ma-mission/:id/demarrer — Démarrer la mission (acceptee → en_route). */
router.post('/ma-mission/:id/demarrer', async (req, res) => {
  await executeTransition(req, res, 'en_route', {
    kilometrageDepart: typeof req.body?.kilometrageDepart === 'number' ? req.body.kilometrageDepart : undefined,
  });
});

/** POST /ma-mission/:id/arrivee — Arrivée sur site (en_route → arrive). */
router.post('/ma-mission/:id/arrivee', async (req, res) => {
  await executeTransition(req, res, 'arrive');
});

/** POST /ma-mission/:id/commencer — Commencer la mission sur place (arrive → mission_en_cours). */
router.post('/ma-mission/:id/commencer', async (req, res) => {
  await executeTransition(req, res, 'mission_en_cours');
});

/** POST /ma-mission/:id/terminer — Mission terminée sur site (mission_en_cours → terminee). */
router.post('/ma-mission/:id/terminer', async (req, res) => {
  await executeTransition(req, res, 'terminee', {
    rapportMission: typeof req.body?.rapportMission === 'string' ? req.body.rapportMission : undefined,
    observationsChauffeur: typeof req.body?.observations === 'string' ? req.body.observations : undefined,
  });
});

/** POST /ma-mission/:id/retour — Retour vers le siège (terminee → retour). */
router.post('/ma-mission/:id/retour', async (req, res) => {
  await executeTransition(req, res, 'retour');
});

/** POST /ma-mission/:id/arrive-siege — Arrivée au siège (retour → arrive_siege). */
router.post('/ma-mission/:id/arrive-siege', async (req, res) => {
  await executeTransition(req, res, 'arrive_siege', {
    kilometrageRetour: typeof req.body?.kilometrageRetour === 'number' ? req.body.kilometrageRetour : undefined,
  });
});

/* ── GPS, Photos, Signatures ──────────────────────────────────────── */

/** POST /ma-mission/:id/gps — Enregistrer un point GPS. */
router.post('/ma-mission/:id/gps', async (req, res) => {
  const chauffeurId = await resolveChauffeurId(req, res);
  if (chauffeurId == null) return;
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });
  const deplacement = await ownMissionOrFail(req, res, id, chauffeurId);
  if (!deplacement) return;

  const { lat, lng, vitesse, precision, cap } = req.body ?? {};
  if (typeof lat !== 'number' || typeof lng !== 'number') {
    return res.status(400).json({ error: 'lat et lng (nombres) sont requis.' });
  }

  const { recordGpsPoint } = await import('../lib/missionEngine.js');
  const point = await recordGpsPoint(id, lat, lng, { vitesse, precision, cap });
  res.status(201).json({ point });
});

/** POST /ma-mission/:id/photo — Uploader une photo. */
router.post('/ma-mission/:id/photo', upload.single('photo'), async (req, res) => {
  const chauffeurId = await resolveChauffeurId(req, res);
  if (chauffeurId == null) return;
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });
  const deplacement = await ownMissionOrFail(req, res, id, chauffeurId);
  if (!deplacement) return;

  if (!req.file) return res.status(400).json({ error: 'Fichier photo requis (champ "photo").' });

  const type = (req.body?.type as string) ?? 'autre';
  const validTypes = ['depart', 'arrivee', 'bon_livraison', 'retour', 'autre'];
  if (!validTypes.includes(type)) {
    // Nettoyer le fichier uploadé
    fs.unlink(req.file.path, () => {});
    return res.status(400).json({ error: `Type de photo invalide. Valeurs acceptées : ${validTypes.join(', ')}.` });
  }

  const { attachPhoto } = await import('../lib/missionEngine.js');
  const photo = await attachPhoto(
    id,
    type as any,
    req.file.filename,
    req.user!.username,
    {
      originalName: req.file.originalname,
      mimeType: req.file.mimetype,
      sizeBytes: req.file.size,
    }
  );

  res.status(201).json({ photo });
});

/** POST /ma-mission/:id/signature — Sauvegarder la signature du chauffeur (base64). */
router.post('/ma-mission/:id/signature', async (req, res) => {
  const chauffeurId = await resolveChauffeurId(req, res);
  if (chauffeurId == null) return;
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });
  const deplacement = await ownMissionOrFail(req, res, id, chauffeurId);
  if (!deplacement) return;

  const { signature } = req.body ?? {};
  if (typeof signature !== 'string' || !signature.startsWith('data:image/')) {
    return res.status(400).json({ error: 'Signature attendue en base64 (data:image/...).' });
  }

  await db.update(deplacementsTable)
    .set({ signatureChauffeur: signature, updatedAt: new Date() })
    .where(eq(deplacementsTable.id, id));

  res.json({ ok: true });
});

/* ── État déclaratif du véhicule (pneus, batterie, freins, éclairage, clim) ──
 * Mise à jour libre depuis "Mon véhicule", sans passer par le workflow plus
 * formel des déclarations ci-dessous. */
const etatVehiculeSchema = z.object({
  etatPneus: z.enum(['bon_etat', 'usure_avant', 'usure_arriere', 'crevaison', 'pression_faible']).optional(),
  etatBatterie: z.enum(['bonne', 'faible', 'a_remplacer']).optional(),
  etatFreins: z.enum(['normaux', 'bruit', 'usure']).optional(),
  etatEclairage: z.enum(['fonctionnel', 'ampoule_grillee']).optional(),
  etatClimatisation: z.enum(['fonctionne', 'panne']).optional()
});

router.patch('/ma-mission/vehicule/etat', async (req, res) => {
  const chauffeurId = await resolveChauffeurId(req, res);
  if (chauffeurId == null) return;
  const parsed = etatVehiculeSchema.safeParse(req.body);
  if (!parsed.success || Object.keys(parsed.data).length === 0) {
    return res.status(400).json({ error: 'Aucun champ valide à mettre à jour.' });
  }

  const [vehicule] = await db.select({ id: vehiculesTable.id }).from(vehiculesTable).where(and(eq(vehiculesTable.chauffeurAttitreId, chauffeurId), isNull(vehiculesTable.deletedAt)));
  if (!vehicule) return res.status(404).json({ error: 'Aucun véhicule habituel associé à ce compte.' });

  await db.update(vehiculesTable).set({ ...parsed.data, updatedAt: new Date() }).where(eq(vehiculesTable.id, vehicule.id));
  res.json({ ok: true });
});

/* ── Déclarations : "Signaler un problème" ────────────────────────────── */
const DECLARATION_UPLOAD_BASE = path.join(process.cwd(), 'uploads', 'declarations');
const declarationStorage = multer.diskStorage({
  destination: (_req, _file, cb) => {
    fs.mkdirSync(DECLARATION_UPLOAD_BASE, { recursive: true });
    cb(null, DECLARATION_UPLOAD_BASE);
  },
  filename: (_req, file, cb) => {
    const ts = Date.now();
    const safe = file.originalname.replace(/[^a-zA-Z0-9._-]/g, '_');
    cb(null, `${ts}-${safe}`);
  },
});
const uploadDeclarationMedia = multer({ storage: declarationStorage, limits: { fileSize: 25 * 1024 * 1024 } }); // 25 Mo (vidéo)

const createDeclarationSchema = z.object({
  categorie: z.enum(['vidange', 'pneus', 'batterie', 'freins', 'embrayage', 'moteur', 'climatisation', 'carrosserie', 'jawaz', 'assurance', 'autre']),
  description: z.string().max(2000).optional(),
  urgence: z.enum(['normal', 'urgent', 'critique']).default('normal')
});

router.get('/ma-mission/declarations', async (req, res) => {
  const chauffeurId = await resolveChauffeurId(req, res);
  if (chauffeurId == null) return;
  const rows = await db
    .select()
    .from(vehiculeDeclarationsTable)
    .where(eq(vehiculeDeclarationsTable.chauffeurId, chauffeurId))
    .orderBy(desc(vehiculeDeclarationsTable.createdAt))
    .limit(30);
  res.json({ declarations: rows });
});

router.post('/ma-mission/declarations', async (req, res) => {
  const chauffeurId = await resolveChauffeurId(req, res);
  if (chauffeurId == null) return;
  const parsed = createDeclarationSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.issues[0]?.message ?? 'Données invalides.' });

  // Résout le véhicule concerné : en priorité le véhicule habituel, sinon
  // celui de la mission active en cours (un chauffeur sans véhicule attitré
  // peut malgré tout conduire ponctuellement un véhicule en mission).
  let vehiculeId: number | null = null;
  const [habituel] = await db.select({ id: vehiculesTable.id }).from(vehiculesTable).where(and(eq(vehiculesTable.chauffeurAttitreId, chauffeurId), isNull(vehiculesTable.deletedAt)));
  if (habituel) {
    vehiculeId = habituel.id;
  } else {
    const statutsActifs = ['creee', 'en_attente_acceptation', 'acceptee', 'en_route', 'arrive', 'mission_en_cours', 'retour', 'arrive_siege'];
    const [missionActive] = await db
      .select({ vehiculeId: deplacementsTable.vehiculeId })
      .from(deplacementsTable)
      .where(and(eq(deplacementsTable.chauffeurId, chauffeurId), isNull(deplacementsTable.deletedAt), inArray(deplacementsTable.statut, statutsActifs as any)))
      .orderBy(deplacementsTable.dateDepart)
      .limit(1);
    if (missionActive?.vehiculeId) vehiculeId = missionActive.vehiculeId;
  }
  if (!vehiculeId) {
    return res.status(404).json({ error: 'Aucun véhicule ne vous est actuellement affecté. Contactez le responsable du parc.' });
  }

  const [declaration] = await db.insert(vehiculeDeclarationsTable).values({ vehiculeId, chauffeurId, ...parsed.data }).returning();
  await db.insert(declarationEventsTable).values({ declarationId: declaration!.id, statut: 'nouvelle', actionPar: req.user!.username });
  broadcastNotifications().catch(() => {}); // pousse immédiatement aux responsables connectés (SSE)
  res.status(201).json({ declaration: { ...declaration, media: [] } });
});

router.post('/ma-mission/declarations/:id/media', uploadDeclarationMedia.single('media'), async (req, res) => {
  const chauffeurId = await resolveChauffeurId(req, res);
  if (chauffeurId == null) return;
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });
  if (!req.file) return res.status(400).json({ error: 'Fichier requis (champ "media").' });

  const [declaration] = await db.select({ id: vehiculeDeclarationsTable.id, chauffeurId: vehiculeDeclarationsTable.chauffeurId }).from(vehiculeDeclarationsTable).where(eq(vehiculeDeclarationsTable.id, id));
  if (!declaration || declaration.chauffeurId !== chauffeurId) {
    fs.unlink(req.file.path, () => {});
    return res.status(404).json({ error: 'Déclaration introuvable.' });
  }
  const type: 'photo' | 'video' = req.file.mimetype.startsWith('video/') ? 'video' : 'photo';
  const [media] = await db.insert(declarationMediaTable).values({
    declarationId: id,
    type,
    filename: req.file.filename,
    originalName: req.file.originalname,
    mimeType: req.file.mimetype,
    sizeBytes: req.file.size,
    uploadedBy: req.user!.username
  }).returning();
  res.status(201).json({ media: { ...media, url: `/api/uploads/declarations/${media!.filename}` } });
});

export default router;

