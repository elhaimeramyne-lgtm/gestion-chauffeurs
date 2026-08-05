/**
 * Demandes de services — Service de la Logistique et des Moyens Généraux.
 *
 * Toute direction/service de l'organigramme peut soumettre une demande
 * (véhicule, téléphone, fourniture, mobilier, maintenance, informatique…).
 * Le workflow suit : nouvelle → validée (chef de service) → validée
 * (responsable logistique) → affectée → en cours → terminée → archivée.
 * Chaque changement de statut est journalisé dans service_request_events.
 */
import { serial, integer, text, timestamp, pgSchema } from 'drizzle-orm/pg-core';

const iamSchema = pgSchema('iam');

export const serviceRequestTypeEnum = iamSchema.enum('service_request_type', [
  'vehicule',
  'deplacement',
  'telephone',
  'fourniture',
  'mobilier',
  'maintenance',
  'informatique',
  'batiment',
  'autre'
]);

export const serviceRequestPriorityEnum = iamSchema.enum('service_request_priority', [
  'normale',
  'urgente',
  'critique'
]);

export const serviceRequestStatusEnum = iamSchema.enum('service_request_status', [
  'nouvelle',
  'validee_chef',
  'validee_responsable',
  'affectee',
  'en_cours',
  'terminee',
  'annulee',
  'archivee'
]);

export const serviceRequestsTable = iamSchema.table('service_requests', {
  id: serial('id').primaryKey(),
  /** Référence lisible, ex. "DEM-2026-0001". Générée côté serveur. */
  numero: text('numero').notNull().unique(),
  /** Direction/service demandeur — référence l'organigramme (source unique
   *  de vérité, voir schema/orgNodes.ts). Pas de FK stricte pour éviter un
   *  couplage cassant si un service est réorganisé/déplacé plus tard. */
  serviceDemandeurId: integer('service_demandeur_id').notNull(),
  demandeurNom: text('demandeur_nom').notNull(),
  demandeurTelephone: text('demandeur_telephone'),
  type: serviceRequestTypeEnum('type').notNull().default('autre'),
  objet: text('objet').notNull(),
  description: text('description'),
  priorite: serviceRequestPriorityEnum('priorite').notNull().default('normale'),
  statut: serviceRequestStatusEnum('statut').notNull().default('nouvelle'),
  /** Utilisateur de la plateforme affecté au traitement (agent Logistique). */
  agentAffecteId: integer('agent_affecte_id'),
  dateSouhaitee: text('date_souhaitee'), // JJ/MM/AAAA, cohérent avec calendar_events
  /** Compte ayant créé la demande (peut différer du demandeur si saisie
   *  pour le compte d'un collègue). */
  createdBy: text('created_by').notNull(),
  deletedAt: timestamp('deleted_at'),
  deletedBy: text('deleted_by'),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull()
});

/** Historique horodaté de chaque transition de statut — alimente la
 *  chronologie affichée dans le panneau détail d'une demande. */
export const serviceRequestEventsTable = iamSchema.table('service_request_events', {
  id: serial('id').primaryKey(),
  requestId: integer('request_id').notNull(),
  statut: serviceRequestStatusEnum('statut').notNull(),
  commentaire: text('commentaire'),
  actionPar: text('action_par').notNull(),
  createdAt: timestamp('created_at').defaultNow().notNull()
});

export type ServiceRequestRow = typeof serviceRequestsTable.$inferSelect;
export type NewServiceRequestRow = typeof serviceRequestsTable.$inferInsert;
export type ServiceRequestEventRow = typeof serviceRequestEventsTable.$inferSelect;
