import { serial, text, timestamp, pgSchema } from 'drizzle-orm/pg-core';

const iamSchema = pgSchema('iam');

/** Registre des journaux (presse) par unité organisationnelle — reprend la
 *  structure des organigrammes internes (Direction, Sous-direction, Division,
 *  Service...) avec jusqu'à 3 titres de presse associés à chacune. */
export const journalEntriesTable = iamSchema.table('journal_entries', {
  id: serial('id').primaryKey(),
  /** Rattachement hiérarchique (ex: "Direction", "Division de l'ingénierie
   *  sociale") — libre, reflète la colonne "Direction" des organigrammes. */
  direction: text('direction'),
  /** Nom du service / unité (ex: "Service de la coopération"). */
  service: text('service').notNull(),
  journal1: text('journal_1'),
  journal2: text('journal_2'),
  journal3: text('journal_3'),
  deletedAt: timestamp('deleted_at'),
  deletedBy: text('deleted_by'),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull()
});

export type JournalEntryRow = typeof journalEntriesTable.$inferSelect;
export type NewJournalEntryRow = typeof journalEntriesTable.$inferInsert;
