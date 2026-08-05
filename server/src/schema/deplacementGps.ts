/**
 * Points GPS d'un déplacement — suivi en temps réel de la position
 * du véhicule pendant la mission.
 *
 * Envoyés par le chauffeur toutes les 30s environ depuis son téléphone
 * (via le portail ma-mission). Permet d'afficher l'itinéraire complet
 * sur une carte et de rejouer le trajet a posteriori.
 *
 * Stockage allégé : seul l'essentiel (lat, lng, vitesse, timestamp)
 * est conservé. Les données volumineuses sont purgées au bout de 90
 * jours via un job de nettoyage (voir backupScheduler ou un cron).
 */
import { serial, integer, real, text, timestamp, pgSchema } from 'drizzle-orm/pg-core';

const iamSchema = pgSchema('iam');

export const deplacementGpsPointsTable = iamSchema.table('deplacement_gps_points', {
  id: serial('id').primaryKey(),
  /** Référence au déplacement. */
  deplacementId: integer('deplacement_id').notNull(),
  /** Latitude (degrés décimaux). */
  latitude: real('latitude').notNull(),
  /** Longitude (degrés décimaux). */
  longitude: real('longitude').notNull(),
  /** Vitesse instantanée en km/h. */
  vitesse: real('vitesse'),
  /** Précision en mètres (optionnel). */
  precision: real('precision'),
  /** Cap en degrés (optionnel). */
  cap: integer('cap'),
  createdAt: timestamp('created_at').defaultNow().notNull()
});

export type DeplacementGpsPointRow = typeof deplacementGpsPointsTable.$inferSelect;
export type NewDeplacementGpsPointRow = typeof deplacementGpsPointsTable.$inferInsert;

