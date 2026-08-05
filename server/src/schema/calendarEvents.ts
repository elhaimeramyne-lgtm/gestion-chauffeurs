import { serial, text, timestamp, pgSchema } from 'drizzle-orm/pg-core';

const iamSchema = pgSchema('iam');

/** Types génériques suffisants pour couvrir renouvellements, interventions,
 *  maintenance, congés... sans avoir besoin d'une table dédiée par type. */
export const calendarEventTypeEnum = iamSchema.enum('calendar_event_type', [
  'renouvellement',
  'intervention',
  'maintenance',
  'conge',
  'autre'
]);

/** Événements ajoutés manuellement au calendrier — vient compléter les
 *  échéances de factures et les paiements, qui eux sont dérivés
 *  automatiquement des tables factures existantes (voir routes/calendar.ts). */
export const calendarEventsTable = iamSchema.table('calendar_events', {
  id: serial('id').primaryKey(),
  title: text('title').notNull(),
  type: calendarEventTypeEnum('type').notNull().default('autre'),
  date: text('date').notNull(), // JJ/MM/AAAA, cohérent avec le reste de la plateforme
  description: text('description'),
  createdBy: text('created_by'),
  deletedAt: timestamp('deleted_at'),
  deletedBy: text('deleted_by'),
  createdAt: timestamp('created_at').defaultNow().notNull()
});

export type CalendarEventRow = typeof calendarEventsTable.$inferSelect;
