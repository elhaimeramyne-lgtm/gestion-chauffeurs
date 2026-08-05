/**
 * Événements de la timeline d'un déplacement (ordre de mission).
 *
 * Chaque fois qu'une mission change de statut, un événement est créé
 * dans cette table pour constituer une timeline complète et horodatée
 * de tout ce qui s'est passé pendant la mission.
 *
 * Cela permet d'afficher côté chauffeur comme côté admin une frise
 * chronologique de type :
 *   ✔ Créée                         08:15
 *   ✔ Acceptée                      08:25   par Ahmed
 *   🚗 Départ                       08:30
 *   📍 Arrivée Fès                  09:42
 *   ...
 */
import { serial, integer, text, timestamp, pgSchema } from 'drizzle-orm/pg-core';

const iamSchema = pgSchema('iam');

export const deplacementEventsTable = iamSchema.table('deplacement_events', {
  id: serial('id').primaryKey(),
  /** Référence au déplacement concerné. */
  deplacementId: integer('deplacement_id').notNull(),
  /** Le nouveau statut après cette transition. */
  statut: text('statut').notNull(),
  /** Commentaire libre (optionnel) — ex: « Trajet fluide, arrivé 5 min en avance. » */
  commentaire: text('commentaire'),
  /** Latitude GPS au moment de l'événement (si disponible). */
  latitude: text('latitude'),
  /** Longitude GPS au moment de l'événement (si disponible). */
  longitude: text('longitude'),
  /** Vitesse instantanée en km/h (si disponible). */
  vitesse: integer('vitesse'),
  /** Utilisateur / chauffeur ayant déclenché la transition. */
  actionPar: text('action_par').notNull(),
  createdAt: timestamp('created_at').defaultNow().notNull()
});

export type DeplacementEventRow = typeof deplacementEventsTable.$inferSelect;
export type NewDeplacementEventRow = typeof deplacementEventsTable.$inferInsert;

