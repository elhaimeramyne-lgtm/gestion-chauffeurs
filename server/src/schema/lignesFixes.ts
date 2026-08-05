import { serial, text, integer, timestamp, pgSchema } from 'drizzle-orm/pg-core';

const iamSchema = pgSchema('iam');

/** Répertoire des lignes fixes (par opposition à la flotte mobile gérée par
 *  iam.lignes). Champs alignés sur les colonnes des feuilles de règlement :
 *  Coordination Régionale, Délégation, Domiciliation, ND-SUP, CUSTCODE. */
export const lignesFixesTable = iamSchema.table('lignes_fixes', {
  id: serial('id').primaryKey(),
  nd: text('nd').notNull(), // ND-SUP : numéro de la ligne fixe
  custcode: text('custcode'),
  coordinationRegionale: text('coordination_regionale'),
  delegation: text('delegation'),
  domiciliation: text('domiciliation'),
  personne: text('personne'),
  qualite: text('qualite'),
  date: text('date'),
  /** Rattachement structuré à l'organigramme (direction/service). */
  serviceId: integer('service_id'),
  consommationMensuelleDh: integer('consommation_mensuelle_dh'),
  deletedAt: timestamp('deleted_at'),
  deletedBy: text('deleted_by'),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull()
});

export type LigneFixeRow = typeof lignesFixesTable.$inferSelect;
export type NewLigneFixeRow = typeof lignesFixesTable.$inferInsert;
