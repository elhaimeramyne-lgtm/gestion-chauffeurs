/**
 * Photos attachées à un déplacement (ordre de mission).
 *
 * Les photos peuvent être de différents types :
 * - depart : photo du véhicule au départ
 * - arrivee : photo sur le lieu de mission
 * - bon_livraison : photo du bon de livraison / document
 * - retour : photo au retour
 * - autre : autre document utile
 *
 * Stockage : serveur local dans server/uploads/missions/{deplacementId}/
 */
import { serial, integer, text, timestamp, pgSchema } from 'drizzle-orm/pg-core';

const iamSchema = pgSchema('iam');

/** Type de photo attachée à une mission. */
export const photoTypeEnum = iamSchema.enum('photo_type', [
  'depart',
  'arrivee',
  'bon_livraison',
  'retour',
  'autre'
]);

export const deplacementPhotosTable = iamSchema.table('deplacement_photos', {
  id: serial('id').primaryKey(),
  /** Référence au déplacement. */
  deplacementId: integer('deplacement_id').notNull(),
  /** Type de photo (pour catégorisation dans l'interface). */
  type: photoTypeEnum('type').notNull().default('autre'),
  /** Chemin d'accès relatif au fichier stocké. */
  filename: text('filename').notNull(),
  /** Nom original du fichier côté client. */
  originalName: text('original_name'),
  /** Type MIME (image/jpeg, image/png…). */
  mimeType: text('mime_type'),
  /** Taille du fichier en octets. */
  sizeBytes: integer('size_bytes'),
  /** Nom de l'utilisateur ayant uploadé la photo. */
  uploadedBy: text('uploaded_by').notNull(),
  createdAt: timestamp('created_at').defaultNow().notNull()
});

export type DeplacementPhotoRow = typeof deplacementPhotosTable.$inferSelect;
export type NewDeplacementPhotoRow = typeof deplacementPhotosTable.$inferInsert;

