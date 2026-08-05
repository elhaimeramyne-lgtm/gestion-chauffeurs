import { integer, text, boolean, timestamp, pgSchema } from 'drizzle-orm/pg-core';

const iamSchema = pgSchema('iam');

/** Ligne unique (singleton, id=1) contenant les paramètres système. */
export const systemSettingsTable = iamSchema.table('system_settings', {
  id: integer('id').primaryKey().default(1),
  organizationName: text('organization_name').notNull().default('Entraide Nationale'),
  supportEmail: text('support_email'),
  /** Durée de validité de la session (jours) avant déconnexion forcée. */
  sessionDurationDays: integer('session_duration_days').notNull().default(30),
  /** Mode maintenance : bloque l'accès aux comptes non SUPER_ADMIN. */
  maintenanceMode: boolean('maintenance_mode').notNull().default(false),
  maintenanceMessage: text('maintenance_message'),
  /** Planification des sauvegardes automatiques (voir lib/backupScheduler.ts). */
  backupScheduleEnabled: boolean('backup_schedule_enabled').notNull().default(false),
  backupScheduleFrequency: text('backup_schedule_frequency').notNull().default('daily'), // 'daily' | 'weekly'
  backupScheduleHour: integer('backup_schedule_hour').notNull().default(2), // heure locale du serveur, 0-23
  updatedBy: text('updated_by'),
  updatedAt: timestamp('updated_at').defaultNow().notNull()
});

export type SystemSettingsRow = typeof systemSettingsTable.$inferSelect;
