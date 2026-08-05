import { serial, text, timestamp, boolean, pgSchema } from 'drizzle-orm/pg-core';

const iamSchema = pgSchema('iam');

/** Historique des e-mails envoyés depuis la plateforme (factures, tests SMTP,
 *  notifications...). Permet de savoir ce qui a été envoyé, à qui, et si
 *  l'envoi a réussi, sans dépendre des logs bruts du serveur SMTP. */
export const emailLogsTable = iamSchema.table('email_logs', {
  id: serial('id').primaryKey(),
  toAddress: text('to_address').notNull(),
  subject: text('subject').notNull(),
  kind: text('kind').notNull().default('autre'), // 'facture' | 'test' | 'autre'
  relatedId: text('related_id'), // ex: id de la facture envoyée
  success: boolean('success').notNull(),
  error: text('error'),
  sentBy: text('sent_by'),
  createdAt: timestamp('created_at').defaultNow().notNull()
});

export type EmailLogRow = typeof emailLogsTable.$inferSelect;
