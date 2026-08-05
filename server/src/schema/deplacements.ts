/**
 * Déplacements — Ordres de mission liés au Parc Automobile.
 *
 * Workflow complet à 9 statuts (Phase 2) :
 *   creee → en_attente_acceptation → acceptee → en_route → arrive →
 *   mission_en_cours → terminee → retour → arrive_siege → cloturee
 *
 * Chaque transition est journalisée dans `deplacement_events` (timeline)
 * et peut être accompagnée de photos, signatures, points GPS.
 */
import { serial, integer, text, timestamp, jsonb, real, pgSchema } from 'drizzle-orm/pg-core';

const iamSchema = pgSchema('iam');

export const deplacementStatutEnum = iamSchema.enum('deplacement_statut', [
  'creee',
  'en_attente_acceptation',
  'acceptee',
  'en_route',
  'arrive',
  'mission_en_cours',
  'terminee',
  'retour',
  'arrive_siege',
  'cloturee',
  'annule'
]);

export const deplacementsTable = iamSchema.table('deplacements', {
  id: serial('id').primaryKey(),
  numero: text('numero').notNull().unique(),
  vehiculeId: integer('vehicule_id'),
  chauffeurId: integer('chauffeur_id'),
  /** Demande de service à l'origine de ce déplacement, le cas échéant. */
  demandeId: integer('demande_id'),
  serviceDemandeurId: integer('service_demandeur_id').notNull(),
  objet: text('objet').notNull(),
  destination: text('destination'),
  dateDepart: text('date_depart').notNull(), // JJ/MM/AAAA
  dateRetourPrevue: text('date_retour_prevue'),
  dateRetourEffective: text('date_retour_effective'),
  kilometrageDepart: integer('kilometrage_depart'),
  kilometrageRetour: integer('kilometrage_retour'),
  statut: deplacementStatutEnum('statut').notNull().default('creee'),
  rapportMission: text('rapport_mission'),
  createdBy: text('created_by').notNull(),

  // ── Phase 2 : Nouveaux champs temporels ──────────────────────────────
  /** Heure de départ prévue (HH:MM) — saisie lors de la création. */
  heureDepartPrevue: text('heure_depart_prevue'),
  /** Timestamp réel du départ. */
  heureDepartReelle: timestamp('heure_depart_reelle'),
  /** Timestamp réel de l'arrivée sur site. */
  heureArriveeReelle: timestamp('heure_arrivee_reelle'),
  /** Timestamp réel du retour au siège. */
  heureRetourReelle: timestamp('heure_retour_reelle'),
  /** Timestamp de clôture de la mission. */
  heureCloture: timestamp('heure_cloture'),
  /** Date réelle de départ (JJ/MM/AAAA). */
  dateDepartReelle: text('date_depart_reelle'),
  /** Date réelle d'arrivée (JJ/MM/AAAA). */
  dateArriveeReelle: text('date_arrivee_reelle'),
  /** Date réelle de retour (JJ/MM/AAAA). */
  dateRetourReelle: text('date_retour_reelle'),
  /** Timestamp de clôture effective. */
  dateCloture: timestamp('date_cloture'),
  /** Timestamp d'acceptation par le chauffeur. */
  acceptedAt: timestamp('accepted_at'),
  /** Nom du chauffeur ayant accepté. */
  acceptedBy: text('accepted_by'),

  // ── Signatures ─────────────────────────────────────────────────────
  /** Signature du chauffeur (base64 PNG). */
  signatureChauffeur: text('signature_chauffeur'),
  /** Signature du responsable (base64 PNG). */
  signatureResponsable: text('signature_responsable'),

  // ── Métriques ───────────────────────────────────────────────────────
  /** Durée totale de la mission en minutes (auto-calculée). */
  dureeMission: integer('duree_mission'),
  /** Distance totale parcourue en km (odomètre ou GPS). */
  distanceKm: integer('distance_km'),
  /** Consommation de carburant en litres. */
  consommationCarburant: real('consommation_carburant'),

  // ── Observations ────────────────────────────────────────────────────
  /** Observations saisies par le chauffeur pendant la mission. */
  observationsChauffeur: text('observations_chauffeur'),
  /** Notes de clôture saisies par le responsable. */
  notesCloture: text('notes_cloture'),

  // ── Itinéraire GPS (points clés) ────────────────────────────────────
  /** Points clés de l'itinéraire : [{lat, lng, speed, timestamp}]. */
  itineraire: jsonb('itineraire'),

  // ── Champs hérités ──────────────────────────────────────────────────
  /** Observations / consignes pour le chauffeur (Phase 1, migration 004). */
  observations: text('observations'),
  /** Heure de départ affichée sur l'OM (Phase 1, migration 004). */
  heureDepart: text('heure_depart'),

  deletedAt: timestamp('deleted_at'),
  deletedBy: text('deleted_by'),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull()
});

export type DeplacementRow = typeof deplacementsTable.$inferSelect;
export type NewDeplacementRow = typeof deplacementsTable.$inferInsert;

