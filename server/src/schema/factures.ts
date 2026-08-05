import { serial, text, doublePrecision, timestamp, pgSchema, unique } from 'drizzle-orm/pg-core';

const iamSchema = pgSchema('iam');

export const factureStatutEnum = iamSchema.enum('facture_statut', ['reglee', 'impayee']);

/** Facture IAM persistée — alimentée par « Enregistrer en base » depuis la
 *  page Comparaison, ou créée/modifiée manuellement ici. Une même facture
 *  (custcode + référence) est mise à jour plutôt que dupliquée à chaque
 *  nouvelle comparaison (upsert). */
export const facturesTable = iamSchema.table(
  'factures',
  {
    id: serial('id').primaryKey(),
    custcode: text('custcode').notNull(),
    nd: text('nd'), // ND1 / ND-SUP : numéro de ligne fixe concerné
    nom: text('nom'),
    refFacture: text('ref_facture').notNull(),
    montant: doublePrecision('montant').notNull().default(0),
    mois: text('mois'),
    echeance: text('echeance'),
    produit: text('produit'),
    statut: factureStatutEnum('statut').notNull().default('impayee'),
    sourceSheet: text('source_sheet'),
    coordinationRegionale: text('coordination_regionale'),
    delegation: text('delegation'),
    domiciliation: text('domiciliation'),
    deletedAt: timestamp('deleted_at'),
    deletedBy: text('deleted_by'),
    createdAt: timestamp('created_at').defaultNow().notNull(),
    updatedAt: timestamp('updated_at').defaultNow().notNull()
  },
  (t) => [unique('factures_custcode_ref_unique').on(t.custcode, t.refFacture)]
);

export type FactureRow = typeof facturesTable.$inferSelect;
export type NewFactureRow = typeof facturesTable.$inferInsert;
