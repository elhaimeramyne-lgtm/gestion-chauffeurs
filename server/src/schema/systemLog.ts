import { serial, text, jsonb, timestamp, pgSchema } from 'drizzle-orm/pg-core';

const iamSchema = pgSchema('iam');

/** Journal système : événements côté serveur (démarrage, migrations,
 *  sauvegardes, erreurs non gérées) — distinct de l'historique des actions
 *  utilisateur (audit_logs) et du journal des connexions (connection_logs). */
export const systemLogEnum = iamSchema.enum('system_log_level', ['info', 'warn', 'error']);

export const systemLogsTable = iamSchema.table('system_logs', {
  id: serial('id').primaryKey(),
  level: systemLogEnum('level').notNull().default('info'),
  message: text('message').notNull(),
  meta: jsonb('meta'),
  createdAt: timestamp('created_at').defaultNow().notNull()
});

export type SystemLogRow = typeof systemLogsTable.$inferSelect;
