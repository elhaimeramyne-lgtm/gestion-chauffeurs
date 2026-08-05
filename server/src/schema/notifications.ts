import { integer, timestamp, pgSchema } from 'drizzle-orm/pg-core';

const iamSchema = pgSchema('iam');

/** Une ligne par utilisateur : mémorise jusqu'où il a "lu" le centre de
 *  notifications. Les notifications elles-mêmes ne sont pas stockées — elles
 *  sont recalculées à la volée depuis les tables existantes (audit_logs,
 *  connection_logs, system_logs, factures) pour éviter toute duplication. */
export const notificationReadsTable = iamSchema.table('notification_reads', {
  userId: integer('user_id').primaryKey(),
  lastSeenAt: timestamp('last_seen_at').defaultNow().notNull()
});

export type NotificationReadRow = typeof notificationReadsTable.$inferSelect;
