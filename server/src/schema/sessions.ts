import { serial, text, integer, timestamp, pgSchema } from 'drizzle-orm/pg-core';

const iamSchema = pgSchema('iam');

/** Une ligne par connexion active. Le cookie de session porte un identifiant
 *  unique (jti) qui pointe vers cette table — cela permet de révoquer une
 *  session précise (ex: "déconnecter cet appareil") sans invalider les
 *  autres, ce qu'un JWT purement sans état ne permettrait pas. */
export const sessionsTable = iamSchema.table('sessions', {
  id: serial('id').primaryKey(),
  jti: text('jti').notNull().unique(),
  userId: integer('user_id').notNull(),
  ipAddress: text('ip_address'),
  userAgent: text('user_agent'),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  lastSeenAt: timestamp('last_seen_at').defaultNow().notNull(),
  revokedAt: timestamp('revoked_at')
});

export type SessionRow = typeof sessionsTable.$inferSelect;
