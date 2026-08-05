import { serial, text, integer, timestamp, pgSchema } from 'drizzle-orm/pg-core';

const iamSchema = pgSchema('iam');

// Cette table vit dans le schéma PostgreSQL "iam" (voir iamSchema ci-dessus),
// donc "iam.lignes" en toutes lettres — jamais en conflit avec une éventuelle
// table "lignes" dans le schéma "public" d'une autre application partageant
// la même base de données (ex: l'ancienne app "Gestion des lignes").
export const lignesTable = iamSchema.table('lignes', {
  id: serial('id').primaryKey(),
  categorie: text('categorie').notNull(),
  typeForfait: text('type_forfait'),
  typeMobile: text('type_mobile'),
  icc: text('icc'),
  imei: text('imei'),
  affecte: text('affecte'),
  /** Civilité du bénéficiaire : 'Mme', 'Mlle' ou 'M.' */
  civilite: text('civilite'),
  personne: text('personne'),
  qualite: text('qualite'),
  date: text('date'),
  /** Code PIN / PUK de la carte SIM. */
  pin: text('pin'),
  puk: text('puk'),
  /** Rattachement structuré à l'organigramme (direction/service), en plus
   *  du champ texte libre "affecte" conservé pour compatibilité. */
  serviceId: integer('service_id'),
  consommationMensuelleDh: integer('consommation_mensuelle_dh'),
  /** Suppression douce : la ligne reste en base (visible dans la Corbeille)
   *  jusqu'à suppression définitive ou restauration. */
  deletedAt: timestamp('deleted_at'),
  deletedBy: text('deleted_by'),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull()
});

export type LigneRow = typeof lignesTable.$inferSelect;
export type NewLigneRow = typeof lignesTable.$inferInsert;
