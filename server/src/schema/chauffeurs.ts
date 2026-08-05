/**
 * Chauffeurs — répertoire indépendant des comptes utilisateurs de la
 * plateforme. Créés et gérés manuellement par le Service Logistique
 * (ce ne sont pas forcément des utilisateurs de la plateforme).
 */
import { serial, integer, text, timestamp, doublePrecision, pgSchema } from 'drizzle-orm/pg-core';

const iamSchema = pgSchema('iam');

export const chauffeurStatutEnum = iamSchema.enum('chauffeur_statut', [
  'disponible',
  'en_mission',
  'indisponible',
  'en_conge',
  'absent'
]);

export const chauffeursTable = iamSchema.table('chauffeurs', {
  id: serial('id').primaryKey(),
  /** Informations générales */
  nom: text('nom').notNull(), // nom complet
  cin: text('cin'),
  telephone: text('telephone'),
  email: text('email'),
  adresse: text('adresse'),
  dateNaissance: text('date_naissance'), // JJ/MM/AAAA
  photoUrl: text('photo_url'),
  /** Permis de conduire */
  permis: text('permis'), // catégories, ex. "B" ou "B, C, EC"
  permisNumero: text('permis_numero'),
  permisDateObtention: text('permis_date_obtention'), // JJ/MM/AAAA
  permisDateExpiration: text('permis_date_expiration'), // JJ/MM/AAAA
  /** Affectation — le véhicule habituel reste porté par
   *  vehicules.chauffeur_attitre_id (source unique de vérité, synchronisé
   *  par la route PATCH /chauffeurs/:id). */
  serviceId: integer('service_id'), // orgNodes.id — service / direction de rattachement
  responsable: text('responsable'), // nom du responsable hiérarchique
  statut: chauffeurStatutEnum('statut').notNull().default('disponible'),
  notes: text('notes'), // Observations
  remarques: text('remarques'),
  /** Badge de télépéage Jawaz personnel du chauffeur (facultatif — un
   *  badge est aussi possible au niveau du véhicule, cf. vehicules). */
  jawazNumero: text('jawaz_numero'),
  jawazSolde: doublePrecision('jawaz_solde').notNull().default(0),
  /** Documents scannés */
  scanCinUrl: text('scan_cin_url'),
  scanPermisUrl: text('scan_permis_url'),
  certificatMedicalUrl: text('certificat_medical_url'),
  /** Compte de connexion (portail chauffeur) — facultatif : un chauffeur
   *  peut exister sans accès plateforme tant qu'aucun compte ne lui a été
   *  créé (voir POST /chauffeurs/:id/compte). */
  userId: integer('user_id'),
  deletedAt: timestamp('deleted_at'),
  deletedBy: text('deleted_by'),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull()
});

export type ChauffeurRow = typeof chauffeursTable.$inferSelect;
export type NewChauffeurRow = typeof chauffeursTable.$inferInsert;
