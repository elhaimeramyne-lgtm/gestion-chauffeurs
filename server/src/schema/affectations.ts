/**
 * Historique des affectations (responsabilité d'un véhicule à un chauffeur).
 *
 * La responsabilité "en cours" reste portée par vehicules.chauffeur_attitre_id
 * (source unique de vérité, cf. server/src/lib/affectations.ts) ; cette table
 * ne fait que journaliser chaque affectation / fin d'affectation pour garder
 * un historique complet, consultable depuis la fiche véhicule.
 */
import { serial, integer, text, timestamp, pgSchema } from 'drizzle-orm/pg-core';

const iamSchema = pgSchema('iam');

export const vehiculeAffectationsTable = iamSchema.table('vehicule_affectations', {
  id: serial('id').primaryKey(),
  vehiculeId: integer('vehicule_id').notNull(),
  chauffeurId: integer('chauffeur_id').notNull(),
  dateAffectation: text('date_affectation').notNull(), // JJ/MM/AAAA
  dateFin: text('date_fin'), // JJ/MM/AAAA — NULL tant que l'affectation est active
  /** Responsable du parc ayant validé l'affectation (nom affiché). */
  responsable: text('responsable').notNull(),
  createdAt: timestamp('created_at').defaultNow().notNull()
});

export type VehiculeAffectationRow = typeof vehiculeAffectationsTable.$inferSelect;
export type NewVehiculeAffectationRow = typeof vehiculeAffectationsTable.$inferInsert;
