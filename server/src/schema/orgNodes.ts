/**
 * Organigramme — Structure organisationnelle dynamique.
 *
 * Hiérarchie : Direction → Sous-Directions → Divisions → Services
 *
 * Toute la plateforme utilise ces tables comme source unique de vérité.
 * Aucune liste de divisions/services ne doit être codée en dur.
 */
import { serial, text, integer, timestamp, pgSchema } from 'drizzle-orm/pg-core';

const iamSchema = pgSchema('iam');

/** Nœud générique de l'organigramme.
 *  type = 'direction' | 'sous-direction' | 'division' | 'service'
 *  parentId = null pour la racine (Direction)
 */
export const orgNodesTable = iamSchema.table('org_nodes', {
  id: serial('id').primaryKey(),
  /** Type du nœud : 'direction' | 'sous-direction' | 'division' | 'service' */
  type: text('type').notNull(),
  /** Nom complet du nœud */
  name: text('name').notNull(),
  /** Nom abrégé / acronyme (optionnel, pour affichage compact) */
  shortName: text('short_name'),
  /** Id du nœud parent (NULL pour Direction racine) */
  parentId: integer('parent_id'),
  /** Ordre d'affichage dans la liste des enfants du même parent */
  sortOrder: integer('sort_order').notNull().default(0),
  /** Nom du chef / responsable */
  chefNom: text('chef_nom'),
  /** Numéro de téléphone du service/division */
  telephone: text('telephone'),
  /** Champ libre pour notes internes */
  notes: text('notes'),
  /** Soft-delete (non utilisé pour l'instant, prévu pour archivage) */
  deletedAt: timestamp('deleted_at'),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull(),
});

export type OrgNodeRow = typeof orgNodesTable.$inferSelect;
export type NewOrgNodeRow = typeof orgNodesTable.$inferInsert;
