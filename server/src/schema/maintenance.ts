/**
 * Module Maintenance — historique complet d'entretien et de réparations par
 * véhicule, au-delà de la simple vidange déjà suivie sur la fiche véhicule
 * (Parc Automobile) : pneus, batterie, freins, embrayage, courroie,
 * réparations, accidents...
 *
 * Chaque intervention peut avoir une ou plusieurs pièces jointes (factures,
 * documents PDF) — voir vehicule_maintenance_documents.
 *
 * Stockage des fichiers : serveur local dans
 * server/uploads/maintenance/{maintenanceId}/
 */
import { serial, integer, text, timestamp, doublePrecision, pgSchema } from 'drizzle-orm/pg-core';

const iamSchema = pgSchema('iam');

/** Nature de l'intervention. */
export const maintenanceTypeEnum = iamSchema.enum('vehicule_maintenance_type', [
  'vidange',
  'pneus',
  'batterie',
  'freins',
  'embrayage',
  'courroie',
  'reparation',
  'accident',
  'autre'
]);

/** Nature de la pièce jointe. */
export const maintenanceDocumentTypeEnum = iamSchema.enum('vehicule_maintenance_document_type', [
  'facture',
  'document'
]);

export const vehiculeMaintenanceTable = iamSchema.table('vehicule_maintenance', {
  id: serial('id').primaryKey(),
  vehiculeId: integer('vehicule_id').notNull(),
  type: maintenanceTypeEnum('type').notNull(),
  date: text('date').notNull(), // JJ/MM/AAAA
  /** Kilométrage au compteur lors de l'intervention. */
  kilometrage: integer('kilometrage'),
  /** Garage / prestataire ayant réalisé l'intervention. */
  garage: text('garage'),
  description: text('description'),
  /** Liste libre des pièces remplacées. */
  piecesRemplacees: text('pieces_remplacees'),
  /** Dépense associée, en DH. */
  cout: doublePrecision('cout').notNull().default(0),
  createdBy: text('created_by').notNull(),
  deletedAt: timestamp('deleted_at'),
  deletedBy: text('deleted_by'),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull()
});

export const vehiculeMaintenanceDocumentsTable = iamSchema.table('vehicule_maintenance_documents', {
  id: serial('id').primaryKey(),
  maintenanceId: integer('maintenance_id').notNull(),
  /** facture = pièce comptable ; document = tout autre justificatif PDF. */
  type: maintenanceDocumentTypeEnum('type').notNull().default('document'),
  filename: text('filename').notNull(),
  originalName: text('original_name'),
  mimeType: text('mime_type'),
  sizeBytes: integer('size_bytes'),
  uploadedBy: text('uploaded_by').notNull(),
  createdAt: timestamp('created_at').defaultNow().notNull()
});

export type VehiculeMaintenanceRow = typeof vehiculeMaintenanceTable.$inferSelect;
export type NewVehiculeMaintenanceRow = typeof vehiculeMaintenanceTable.$inferInsert;
export type VehiculeMaintenanceDocumentRow = typeof vehiculeMaintenanceDocumentsTable.$inferSelect;
export type NewVehiculeMaintenanceDocumentRow = typeof vehiculeMaintenanceDocumentsTable.$inferInsert;
