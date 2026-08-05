/**
 * Demandes de Chauffeur — Module Logistique
 *
 * Workflow :
 *   en_attente → assignee → confirmee (chauffeur accepte) → validee → terminee
 *   en_attente → refusee (refus du responsable)
 *   assignee → en_attente (le chauffeur refuse : redevient à réassigner)
 */
import { serial, integer, text, timestamp, pgSchema } from 'drizzle-orm/pg-core';

const iamSchema = pgSchema('iam');

export const demandeChauffeurStatutEnum = iamSchema.enum('demande_chauffeur_statut', [
  'en_attente',
  'assignee',
  'confirmee',
  'validee',
  'refusee',
  'terminee'
]);

export const demandeChauffeurPrioriteEnum = iamSchema.enum('demande_chauffeur_priorite', [
  'normale',
  'urgente',
  'critique'
]);

export const demandeChauffeurTable = iamSchema.table('demande_chauffeur', {
  id: serial('id').primaryKey(),
  numero: text('numero').notNull().unique(),
  serviceDemandeurId: integer('service_demandeur_id').notNull(),
  demandeurNom: text('demandeur_nom').notNull(),
  demandeurTelephone: text('demandeur_telephone'),
  priorite: demandeChauffeurPrioriteEnum('priorite').notNull().default('normale'),
  observations: text('observations'),
  statut: demandeChauffeurStatutEnum('statut').notNull().default('en_attente'),

  /** Chauffeur assigné par le responsable du parc. */
  chauffeurId: integer('chauffeur_id'),
  assignePar: text('assigne_par'),

  /** Ordre de mission (déplacement) créé lors de la validation. */
  missionId: integer('mission_id'),
  validePar: text('valide_par'),

  /** Motif de refus (responsable ou chauffeur). */
  motifRefus: text('motif_refus'),

  createdBy: text('created_by').notNull(),
  deletedAt: timestamp('deleted_at'),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull()
});

export type DemandeChauffeurRow = typeof demandeChauffeurTable.$inferSelect;
export type NewDemandeChauffeurRow = typeof demandeChauffeurTable.$inferInsert;
