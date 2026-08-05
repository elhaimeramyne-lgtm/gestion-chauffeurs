import { serial, text, boolean, timestamp, jsonb, unique, pgSchema } from 'drizzle-orm/pg-core';

const iamSchema = pgSchema('iam');

/** Correspondance de colonnes pour une feuille donnée. Clé par (role, nom de
 *  feuille) plutôt que par fichier : le fichier réimporté change d'identifiant
 *  à chaque import, mais le nom de la feuille (ex: "Fix") reste stable — la
 *  correspondance configurée une fois s'applique donc automatiquement aux
 *  imports suivants. */
export const sheetRulesTable = iamSchema.table(
  'sheet_rules',
  {
    id: serial('id').primaryKey(),
    role: text('role').notNull(), // 'impayes' | 'reglements'
    sheetName: text('sheet_name').notNull(),
    mapping: jsonb('mapping').notNull(),
    updatedBy: text('updated_by'),
    createdAt: timestamp('created_at').defaultNow().notNull(),
    updatedAt: timestamp('updated_at').defaultNow().notNull()
  },
  (t) => [unique('sheet_rules_role_sheet_unique').on(t.role, t.sheetName)]
);

export const customFieldsTable = iamSchema.table('custom_fields', {
  id: serial('id').primaryKey(),
  label: text('label').notNull(),
  useAsMatchKey: boolean('use_as_match_key').notNull().default(true),
  deletedAt: timestamp('deleted_at'),
  deletedBy: text('deleted_by'),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull()
});

/** Règle de correction, elle aussi ancrée sur les noms de feuilles plutôt que
 *  sur des identifiants de fichiers éphémères. */
export const correctionRulesTable = iamSchema.table(
  'correction_rules',
  {
    id: serial('id').primaryKey(),
    sourceSheetName: text('source_sheet_name').notNull(),
    targetSheetName: text('target_sheet_name').notNull(),
    createdBy: text('created_by'),
    deletedAt: timestamp('deleted_at'),
    deletedBy: text('deleted_by'),
    createdAt: timestamp('created_at').defaultNow().notNull()
  },
  (t) => [unique('correction_rules_source_target_unique').on(t.sourceSheetName, t.targetSheetName)]
);

export type SheetRuleRow = typeof sheetRulesTable.$inferSelect;
export type CustomFieldRow = typeof customFieldsTable.$inferSelect;
export type CorrectionRuleRow = typeof correctionRulesTable.$inferSelect;
