/**
 * Personnel transporté (« passagers ») lors d'un déplacement — en plus du
 * chauffeur. Terme volontairement administratif : on évite « accompagné »
 * qui n'est pas un vocabulaire professionnel.
 */
import { serial, integer, text, timestamp, pgSchema } from 'drizzle-orm/pg-core';

const iamSchema = pgSchema('iam');

export const deplacementPassagersTable = iamSchema.table('deplacement_passagers', {
  id: serial('id').primaryKey(),
  deplacementId: integer('deplacement_id').notNull(),
  nom: text('nom').notNull(),
  /** Service/direction de rattachement (organigramme), le cas échéant. */
  serviceId: integer('service_id'),
  createdAt: timestamp('created_at').defaultNow().notNull()
});

export type DeplacementPassagerRow = typeof deplacementPassagersTable.$inferSelect;
export type NewDeplacementPassagerRow = typeof deplacementPassagersTable.$inferInsert;
