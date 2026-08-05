/**
 * Mission Map — Endpoints temps réel pour la carte des missions actives.
 *
 * Routes :
 *   GET  /mission-map/actives        — Missions actives avec dernier point GPS + itinéraire
 *   GET  /mission-map/:id/gps        — Tous les points GPS d'une mission
 *   GET  /mission-map/:id/itineraire — Points GPS ordonnés pour tracer la route
 */
import { Router } from 'express';
import { and, desc, eq, gte, inArray, isNull, sql } from 'drizzle-orm';
import {
  db,
  deplacementsTable,
  deplacementGpsPointsTable,
  vehiculesTable,
  chauffeursTable,
  orgNodesTable,
} from '../db.js';
import { requireAuth } from '../middleware/auth.js';
import { ETAPES_ORDRE } from '../lib/missionEngine.js';
import type { Request, Response } from 'express';

const router = Router();
router.use(requireAuth);

/* ── Statuts actifs (ceux qui peuvent avoir une position GPS) ─────── */
const STATUTS_ACTIFS = ['acceptee', 'en_route', 'arrive', 'mission_en_cours', 'terminee', 'retour', 'arrive_siege'];

/**
 * GET /mission-map/actives
 * Retourne la liste des missions actives avec leur dernier point GPS,
 * l'itinéraire complet (points GPS), le véhicule et le chauffeur.
 * Idéal pour alimenter la carte temps réel côté admin.
 */
router.get('/mission-map/actives', async (req: Request, res: Response) => {
  // Récupérer toutes les missions avec statut actif
  const missions = await db
    .select()
    .from(deplacementsTable)
    .where(
      and(
        inArray(deplacementsTable.statut, STATUTS_ACTIFS as any),
        isNull(deplacementsTable.deletedAt)
      )
    )
    .orderBy(desc(deplacementsTable.updatedAt))
    .limit(50);

  if (missions.length === 0) {
    return res.json({ missions: [] });
  }

  // Récupérer les IDs
  const missionIds = missions.map((m) => m.id);
  const vehiculeIds = missions.filter((m) => m.vehiculeId != null).map((m) => m.vehiculeId!);
  const chauffeurIds = missions.filter((m) => m.chauffeurId != null).map((m) => m.chauffeurId!);

  // Dernier point GPS pour chaque mission (sous-requête corrélée optimisée)
  const missionIdsSql = sql.join(missionIds.map((id) => sql`${id}`), sql`, `);
  const lastGpsRows = await db.execute<{
    deplacement_id: number;
    id: number;
    latitude: number;
    longitude: number;
    vitesse: number | null;
    precision: number | null;
    cap: number | null;
    created_at: string;
  }>(sql`
    SELECT DISTINCT ON (g.deplacement_id)
      g.deplacement_id,
      g.id,
      g.latitude,
      g.longitude,
      g.vitesse,
      g."precision",
      g.cap,
      g.created_at
    FROM iam.deplacement_gps_points g
    WHERE g.deplacement_id = ANY(ARRAY[${missionIdsSql}]::int[])
    ORDER BY g.deplacement_id, g.created_at DESC
  `);

  // Derniers 50 points GPS pour chaque mission (itinéraire récent)
  const recentGpsRows = await db.execute<{
    deplacement_id: number;
    id: number;
    latitude: number;
    longitude: number;
    vitesse: number | null;
    created_at: string;
  }>(sql`
    SELECT g.deplacement_id, g.id, g.latitude, g.longitude, g.vitesse, g.created_at
    FROM iam.deplacement_gps_points g
    WHERE g.deplacement_id = ANY(ARRAY[${missionIdsSql}]::int[])
      AND g.created_at >= now() - interval '2 hours'
    ORDER BY g.deplacement_id, g.created_at ASC
  `);

  // Véhicules
  const vehicules = vehiculeIds.length > 0
    ? await db.select().from(vehiculesTable).where(inArray(vehiculesTable.id, vehiculeIds))
    : [];

  // Chauffeurs
  const chauffeurs = chauffeurIds.length > 0
    ? await db.select().from(chauffeursTable).where(inArray(chauffeursTable.id, chauffeurIds))
    : [];

  // Construire les maps
  const lastGpsMap = new Map<number, any>();
  for (const row of lastGpsRows.rows) {
    lastGpsMap.set(row.deplacement_id, {
      id: row.id,
      latitude: row.latitude,
      longitude: row.longitude,
      vitesse: row.vitesse,
      precision: row.precision,
      cap: row.cap,
      createdAt: row.created_at,
    });
  }

  const gpsPointsMap = new Map<number, any[]>();
  for (const row of recentGpsRows.rows) {
    if (!gpsPointsMap.has(row.deplacement_id)) {
      gpsPointsMap.set(row.deplacement_id, []);
    }
    gpsPointsMap.get(row.deplacement_id)!.push({
      id: row.id,
      latitude: row.latitude,
      longitude: row.longitude,
      vitesse: row.vitesse,
      createdAt: row.created_at,
    });
  }

  const vehiculeMap = new Map(vehicules.map((v) => [v.id, v]));
  const chauffeurMap = new Map(chauffeurs.map((c) => [c.id, c]));

  // Assembler la réponse
  const enriched = missions.map((m) => ({
    deplacement: m,
    etapeOrdre: ETAPES_ORDRE.indexOf(m.statut as any),
    vehicule: m.vehiculeId ? vehiculeMap.get(m.vehiculeId) ?? null : null,
    chauffeur: m.chauffeurId ? chauffeurMap.get(m.chauffeurId) ?? null : null,
    lastGpsPoint: lastGpsMap.get(m.id) ?? null,
    gpsPoints: gpsPointsMap.get(m.id) ?? [],
  }));

  res.json({ missions: enriched });
});

/**
 * GET /mission-map/:id/gps
 * Retourne tous les points GPS d'une mission spécifique,
 * limité aux 500 derniers points (30s d'intervalle = ~4h de trajet).
 */
router.get('/mission-map/:id/gps', async (req: Request, res: Response) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });

  const points = await db
    .select()
    .from(deplacementGpsPointsTable)
    .where(eq(deplacementGpsPointsTable.deplacementId, id))
    .orderBy(desc(deplacementGpsPointsTable.createdAt))
    .limit(500);

  res.json({ points });
});

/**
 * GET /mission-map/:id/itineraire
 * Points GPS ordonnés par date croissante pour tracer la route complète.
 */
router.get('/mission-map/:id/itineraire', async (req: Request, res: Response) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });

  const points = await db
    .select({
      id: deplacementGpsPointsTable.id,
      latitude: deplacementGpsPointsTable.latitude,
      longitude: deplacementGpsPointsTable.longitude,
      vitesse: deplacementGpsPointsTable.vitesse,
      createdAt: deplacementGpsPointsTable.createdAt,
    })
    .from(deplacementGpsPointsTable)
    .where(eq(deplacementGpsPointsTable.deplacementId, id))
    .orderBy(deplacementGpsPointsTable.createdAt)
    .limit(1000);

  // Calculer la distance totale
  let distanceKm = 0;
  const R = 6371; // Rayon terrestre en km
  for (let i = 1; i < points.length; i++) {
    const prev = points[i - 1];
    const curr = points[i];
    const dLat = ((curr.latitude - prev.latitude) * Math.PI) / 180;
    const dLon = ((curr.longitude - prev.longitude) * Math.PI) / 180;
    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos((prev.latitude * Math.PI) / 180) *
        Math.cos((curr.latitude * Math.PI) / 180) *
        Math.sin(dLon / 2) *
        Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    distanceKm += R * c;
  }

  res.json({
    points,
    distanceKm: Math.round(distanceKm * 10) / 10,
    nbPoints: points.length,
  });
});

export default router;
