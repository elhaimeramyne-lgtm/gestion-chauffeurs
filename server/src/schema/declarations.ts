/**
 * Déclarations chauffeur — "Signaler un problème".
 *
 * Le chauffeur, responsable de son véhicule, peut à tout moment signaler un
 * problème (catégorie, description, photos/vidéo, niveau d'urgence). Le
 * responsable du parc est notifié (cf. notifications-sse.ts) et fait
 * progresser la déclaration à travers un workflow à 6 statuts, journalisé
 * dans vehicule_declaration_events (même principe que vehicule_events).
 */
import { serial, integer, text, timestamp, pgSchema } from 'drizzle-orm/pg-core';

const iamSchema = pgSchema('iam');

export const declarationCategorieEnum = iamSchema.enum('declaration_categorie', [
  'vidange', 'pneus', 'batterie', 'freins', 'embrayage', 'moteur',
  'climatisation', 'carrosserie', 'jawaz', 'assurance', 'autre'
]);

export const declarationUrgenceEnum = iamSchema.enum('declaration_urgence', ['normal', 'urgent', 'critique']);

export const declarationStatutEnum = iamSchema.enum('declaration_statut', [
  'nouvelle', 'en_cours', 'validee', 'reparation_programmee', 'terminee', 'archivee'
]);

export const declarationMediaTypeEnum = iamSchema.enum('declaration_media_type', ['photo', 'video']);

export const vehiculeDeclarationsTable = iamSchema.table('vehicule_declarations', {
  id: serial('id').primaryKey(),
  vehiculeId: integer('vehicule_id').notNull(),
  chauffeurId: integer('chauffeur_id').notNull(),
  categorie: declarationCategorieEnum('categorie').notNull(),
  description: text('description'),
  urgence: declarationUrgenceEnum('urgence').notNull().default('normal'),
  statut: declarationStatutEnum('statut').notNull().default('nouvelle'),
  commentaireTraitement: text('commentaire_traitement'),
  traitePar: text('traite_par'),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull()
});

export const declarationMediaTable = iamSchema.table('vehicule_declaration_media', {
  id: serial('id').primaryKey(),
  declarationId: integer('declaration_id').notNull(),
  type: declarationMediaTypeEnum('type').notNull(),
  filename: text('filename').notNull(),
  originalName: text('original_name'),
  mimeType: text('mime_type'),
  sizeBytes: integer('size_bytes'),
  uploadedBy: text('uploaded_by').notNull(),
  createdAt: timestamp('created_at').defaultNow().notNull()
});

export const declarationEventsTable = iamSchema.table('vehicule_declaration_events', {
  id: serial('id').primaryKey(),
  declarationId: integer('declaration_id').notNull(),
  statut: declarationStatutEnum('statut').notNull(),
  commentaire: text('commentaire'),
  actionPar: text('action_par').notNull(),
  createdAt: timestamp('created_at').defaultNow().notNull()
});

export type VehiculeDeclarationRow = typeof vehiculeDeclarationsTable.$inferSelect;
export type NewVehiculeDeclarationRow = typeof vehiculeDeclarationsTable.$inferInsert;
export type DeclarationMediaRow = typeof declarationMediaTable.$inferSelect;
export type DeclarationEventRow = typeof declarationEventsTable.$inferSelect;
