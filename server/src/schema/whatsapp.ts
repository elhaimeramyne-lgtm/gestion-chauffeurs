import { serial, text, timestamp, pgSchema } from 'drizzle-orm/pg-core';

const iamSchema = pgSchema('iam');

/** Historique des messages WhatsApp envoyés (API officielle WhatsApp
 *  Business / Meta Cloud API). `status` suit le cycle de vie renvoyé par
 *  Meta : queued → sent → delivered → read (ou failed). */
export const whatsappMessagesTable = iamSchema.table('whatsapp_messages', {
  id: serial('id').primaryKey(),
  toPhone: text('to_phone').notNull(),
  message: text('message').notNull(),
  kind: text('kind').notNull().default('autre'), // 'facture' | 'rappel' | 'test' | 'autre'
  relatedId: text('related_id'),
  status: text('status').notNull().default('queued'), // queued | sent | delivered | read | failed
  waMessageId: text('wa_message_id'), // identifiant renvoyé par Meta, pour suivre le statut
  error: text('error'),
  sentBy: text('sent_by'),
  sentAt: timestamp('sent_at').defaultNow().notNull(),
  readAt: timestamp('read_at')
});

export type WhatsappMessageRow = typeof whatsappMessagesTable.$inferSelect;
