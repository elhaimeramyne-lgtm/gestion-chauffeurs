import { serial, text, timestamp, jsonb, pgSchema } from 'drizzle-orm/pg-core';

const iamSchema = pgSchema('iam');

export const activityLogsTable = iamSchema.table('activity_logs', {
  id: serial('id').primaryKey(),
  userId: serial('user_id').notNull(),
  username: text('username').notNull(),
  userRole: text('user_role').notNull(),
  action: text('action').notNull(),
  category: text('category').notNull(),
  description: text('description').notNull(),
  targetId: text('target_id'),
  targetName: text('target_name'),
  metadata: jsonb('metadata'),
  ipAddress: text('ip_address'),
  createdAt: timestamp('created_at').defaultNow().notNull(),
});

export type ActivityLogRow = typeof activityLogsTable.$inferSelect;
export type NewActivityLogRow = typeof activityLogsTable.$inferInsert;
