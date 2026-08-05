/**
 * Parc Automobile — Service de la Logistique et des Moyens Généraux.
 *
 * Chaque véhicule a un statut (disponible / en mission / maintenance /
 * hors service). Les changements de statut sont journalisés dans
 * vehicule_events pour garder un historique complet (comme demandé dans
 * le cahier des charges : "Historique complet").
 */
import { serial, integer, text, timestamp, doublePrecision, pgSchema } from 'drizzle-orm/pg-core';

const iamSchema = pgSchema('iam');

export const vehiculeStatutEnum = iamSchema.enum('vehicule_statut', [
  'disponible',
  'en_mission',
  'maintenance',
  'hors_service'
]);

export const vehiculeCarburantEnum = iamSchema.enum('vehicule_carburant', [
  'essence',
  'diesel',
  'hybride',
  'electrique'
]);

/** États déclarés par le chauffeur depuis son portail (section « Mon véhicule »). */
export const etatPneusEnum = iamSchema.enum('vehicule_etat_pneus', [
  'bon_etat', 'usure_avant', 'usure_arriere', 'crevaison', 'pression_faible'
]);
export const etatBatterieEnum = iamSchema.enum('vehicule_etat_batterie', ['bonne', 'faible', 'a_remplacer']);
export const etatFreinsEnum = iamSchema.enum('vehicule_etat_freins', ['normaux', 'bruit', 'usure']);
export const etatEclairageEnum = iamSchema.enum('vehicule_etat_eclairage', ['fonctionnel', 'ampoule_grillee']);
export const etatClimatisationEnum = iamSchema.enum('vehicule_etat_climatisation', ['fonctionne', 'panne']);

export const vehiculesTable = iamSchema.table('vehicules', {
  id: serial('id').primaryKey(),
  immatriculation: text('immatriculation').notNull().unique(),
  marque: text('marque').notNull(),
  modele: text('modele').notNull(),
  annee: integer('annee'),
  carburant: vehiculeCarburantEnum('carburant').notNull().default('diesel'),
  kilometrage: integer('kilometrage').notNull().default(0),
  statut: vehiculeStatutEnum('statut').notNull().default('disponible'),
  assuranceExpiration: text('assurance_expiration'), // JJ/MM/AAAA
  visiteTechniqueExpiration: text('visite_technique_expiration'), // JJ/MM/AAAA
  /** Entretien — vidange */
  derniereVidange: text('derniere_vidange'), // JJ/MM/AAAA — date de la dernière vidange
  vidangeExpiration: text('vidange_expiration'), // JJ/MM/AAAA — date prévue de la prochaine vidange
  kilometrageDerniereVidange: integer('kilometrage_derniere_vidange'), // km au compteur lors de la dernière vidange
  kilometrageProchaineVidange: integer('kilometrage_prochaine_vidange'), // km auquel la prochaine vidange est due
  typeHuile: text('type_huile'), // ex. 5W30, 10W40...
  garageVidange: text('garage_vidange'), // garage ayant effectué la dernière vidange
  vidangeObservations: text('vidange_observations'),
  /** Jawaz (télépéage) — badge affecté au véhicule */
  jawazNumero: text('jawaz_numero'),
  jawazSolde: doublePrecision('jawaz_solde').notNull().default(0), // solde actuel en DH
  jawazDerniereRecharge: text('jawaz_derniere_recharge'), // JJ/MM/AAAA
  jawazSeuilAlerte: doublePrecision('jawaz_seuil_alerte').notNull().default(100), // seuil d'alerte configurable, en DH
  /** Chauffeur habituellement associé (facultatif — un déplacement peut
   *  désigner un chauffeur différent au cas par cas). Source unique de
   *  vérité pour la responsabilité du véhicule ; l'historique complet des
   *  affectations est dans vehicule_affectations. */
  chauffeurAttitreId: integer('chauffeur_attitre_id'),
  photoUrl: text('photo_url'),
  /** États déclarés par le chauffeur (portail) — mis à jour librement,
   *  sans passer par le workflow plus formel des déclarations. */
  etatPneus: etatPneusEnum('etat_pneus'),
  etatBatterie: etatBatterieEnum('etat_batterie'),
  etatFreins: etatFreinsEnum('etat_freins'),
  etatEclairage: etatEclairageEnum('etat_eclairage'),
  etatClimatisation: etatClimatisationEnum('etat_climatisation'),
  notes: text('notes'),
  deletedAt: timestamp('deleted_at'),
  deletedBy: text('deleted_by'),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull()
});

export const vehiculeEventsTable = iamSchema.table('vehicule_events', {
  id: serial('id').primaryKey(),
  vehiculeId: integer('vehicule_id').notNull(),
  statut: vehiculeStatutEnum('statut').notNull(),
  commentaire: text('commentaire'),
  actionPar: text('action_par').notNull(),
  createdAt: timestamp('created_at').defaultNow().notNull()
});

export type VehiculeRow = typeof vehiculesTable.$inferSelect;
export type NewVehiculeRow = typeof vehiculesTable.$inferInsert;
export type VehiculeEventRow = typeof vehiculeEventsTable.$inferSelect;
