import { serial, text, timestamp, integer, jsonb, boolean, pgSchema } from 'drizzle-orm/pg-core';

const iamSchema = pgSchema('iam');

/** Historique automatique de toutes les actions effectuées sur la
 *  plateforme (création, modification, suppression, import, export...).
 *  Alimenté automatiquement par le middleware d'audit — jamais à la main. */
export const auditLogsTable = iamSchema.table('audit_logs', {
  id: serial('id').primaryKey(),
  userId: integer('user_id'),
  username: text('username'),
  role: text('role'),
  /** Verbe métier : create, update, delete, login, logout, import, export... */
  action: text('action').notNull(),
  /** Ressource concernée : users, lignes, factures, sheet-rules... */
  entity: text('entity').notNull(),
  entityId: text('entity_id'),
  method: text('method').notNull(),
  path: text('path').notNull(),
  statusCode: integer('status_code').notNull(),
  /** Détails additionnels (payload résumé, avant/après...) */
  details: jsonb('details'),
  ipAddress: text('ip_address'),
  userAgent: text('user_agent'),
  createdAt: timestamp('created_at').defaultNow().notNull()
});

/** Journal des connexions : toute tentative de connexion, réussie ou non. */
export const connectionLogsTable = iamSchema.table('connection_logs', {
  id: serial('id').primaryKey(),
  userId: integer('user_id'),
  username: text('username').notNull(),
  success: boolean('success').notNull(),
  reason: text('reason'),
  ipAddress: text('ip_address'),
  userAgent: text('user_agent'),
  createdAt: timestamp('created_at').defaultNow().notNull()
});

export type AuditLogRow = typeof auditLogsTable.$inferSelect;
export type ConnectionLogRow = typeof connectionLogsTable.$inferSelect;
