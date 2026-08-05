import { integer, text, doublePrecision, timestamp, pgSchema } from 'drizzle-orm/pg-core';

const iamSchema = pgSchema('iam');

/** Ligne unique (singleton, id=1) mise à jour à chaque comparaison lancée
 *  depuis la page "Comparaison". Les factures elles-mêmes restent calculées
 *  à la volée depuis les fichiers Excel importés (aucune table de factures
 *  pour l'instant — prévu à l'étape "Gestion des factures IAM") ; ce
 *  snapshot ne fait que persister le dernier résumé pour que le tableau de
 *  bord Super Admin affiche des chiffres réels sans dépendre d'une session
 *  navigateur particulière. */
export const dashboardSnapshotTable = iamSchema.table('dashboard_snapshot', {
  id: integer('id').primaryKey().default(1),
  totalFactures: integer('total_factures').notNull().default(0),
  facturesReglees: integer('factures_reglees').notNull().default(0),
  facturesImpayees: integer('factures_impayees').notNull().default(0),
  montantImpaye: doublePrecision('montant_impaye').notNull().default(0),
  lignesFixes: integer('lignes_fixes').notNull().default(0),
  updatedBy: text('updated_by'),
  updatedAt: timestamp('updated_at').defaultNow().notNull()
});

export type DashboardSnapshotRow = typeof dashboardSnapshotTable.$inferSelect;
