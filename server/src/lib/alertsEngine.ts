/**
 * Moteur d'alertes — Parc Automobile & Chauffeurs.
 *
 * Comme pour /api/notifications, rien n'est persisté : les alertes sont
 * recalculées à chaque appel à partir de l'état actuel des véhicules et
 * des chauffeurs, pour rester toujours exactes.
 */
import { and, eq, isNull } from 'drizzle-orm';
import { db, vehiculesTable, chauffeursTable, vehiculeMaintenanceTable } from '../db.js';
import type { VehiculeRow } from '../schema/vehicules.js';
import type { ChauffeurRow } from '../schema/chauffeurs.js';

export type AlerteNiveau = 'orange' | 'rouge';
export type AlerteType =
  | 'assurance' | 'visite_technique' | 'vidange' | 'jawaz' | 'vehicule_indisponible' | 'permis'
  | 'pneus' | 'etat_vehicule';

export interface Alerte {
  type: AlerteType;
  niveau: AlerteNiveau;
  message: string;
  vehiculeId?: number;
  chauffeurId?: number;
}

/** Parse une date JJ/MM/AAAA. Retourne null si absente ou invalide. */
function parseDMY(value: string | null | undefined): Date | null {
  if (!value) return null;
  const m = /^(\d{1,2})\/(\d{1,2})\/(\d{4})$/.exec(value.trim());
  if (!m) return null;
  const d = new Date(Number(m[3]), Number(m[2]) - 1, Number(m[1]));
  return Number.isNaN(d.getTime()) ? null : d;
}

/** Nombre de jours restants avant une date JJ/MM/AAAA (négatif si dépassée). */
function joursRestants(value: string | null | undefined): number | null {
  const date = parseDMY(value);
  if (!date) return null;
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  return Math.round((date.getTime() - today.getTime()) / 86_400_000);
}

/** Kilométrage au moment du dernier changement de pneus (module Maintenance),
 *  par véhicule — sert à l'alerte "pneus : plus de 50 000 km". */
export async function fetchLastPneusKmByVehicule(): Promise<Map<number, number>> {
  const rows = await db
    .select({ vehiculeId: vehiculeMaintenanceTable.vehiculeId, kilometrage: vehiculeMaintenanceTable.kilometrage })
    .from(vehiculeMaintenanceTable)
    .where(and(eq(vehiculeMaintenanceTable.type, 'pneus'), isNull(vehiculeMaintenanceTable.deletedAt)));
  const map = new Map<number, number>();
  for (const r of rows) {
    if (r.kilometrage == null) continue;
    const current = map.get(r.vehiculeId);
    if (current == null || r.kilometrage > current) map.set(r.vehiculeId, r.kilometrage);
  }
  return map;
}

/** Alertes liées à un véhicule : assurance, visite technique, vidange, Jawaz,
 *  disponibilité, pneus (kilométrage depuis le dernier changement, tiré du
 *  module Maintenance — voir lastPneusKm) et états déclarés par le chauffeur. */
export function computeVehiculeAlertes(v: VehiculeRow, lastPneusKm: number | null = null): Alerte[] {
  const alertes: Alerte[] = [];

  const joursAssurance = joursRestants(v.assuranceExpiration);
  if (joursAssurance != null && joursAssurance <= 30) {
    alertes.push({
      type: 'assurance',
      niveau: joursAssurance < 0 ? 'rouge' : 'orange',
      message: joursAssurance < 0
        ? `Assurance de ${v.immatriculation} expirée depuis ${Math.abs(joursAssurance)} j.`
        : `Assurance de ${v.immatriculation} expire dans ${joursAssurance} j.`,
      vehiculeId: v.id
    });
  }

  const joursVisite = joursRestants(v.visiteTechniqueExpiration);
  if (joursVisite != null && joursVisite <= 15) {
    alertes.push({
      type: 'visite_technique',
      niveau: joursVisite < 0 ? 'rouge' : 'orange',
      message: joursVisite < 0
        ? `Visite technique de ${v.immatriculation} expirée depuis ${Math.abs(joursVisite)} j.`
        : `Visite technique de ${v.immatriculation} expire dans ${joursVisite} j.`,
      vehiculeId: v.id
    });
  }

  if (v.kilometrageProchaineVidange != null) {
    const reste = v.kilometrageProchaineVidange - v.kilometrage;
    if (reste <= 500) {
      alertes.push({
        type: 'vidange',
        niveau: reste <= 0 ? 'rouge' : 'orange',
        message: reste <= 0
          ? `Vidange de ${v.immatriculation} dépassée de ${Math.abs(reste).toLocaleString('fr-FR')} km.`
          : `Vidange de ${v.immatriculation} à effectuer dans ${reste.toLocaleString('fr-FR')} km.`,
        vehiculeId: v.id
      });
    }
  }

  if (v.jawazNumero && v.jawazSolde < v.jawazSeuilAlerte) {
    alertes.push({
      type: 'jawaz',
      niveau: 'rouge',
      message: `Jawaz de ${v.immatriculation} presque vide (${v.jawazSolde.toLocaleString('fr-FR')} DH).`,
      vehiculeId: v.id
    });
  }

  if (v.statut === 'maintenance' || v.statut === 'hors_service') {
    alertes.push({
      type: 'vehicule_indisponible',
      niveau: 'rouge',
      message: `Véhicule ${v.immatriculation} indisponible (${v.statut === 'maintenance' ? 'en maintenance' : 'hors service'}).`,
      vehiculeId: v.id
    });
  }

  // Pneus — kilométrage depuis le dernier changement (module Maintenance).
  if (lastPneusKm != null && v.kilometrage - lastPneusKm >= 50_000) {
    alertes.push({
      type: 'pneus',
      niveau: 'orange',
      message: `Pneus de ${v.immatriculation} à vérifier — plus de ${(v.kilometrage - lastPneusKm).toLocaleString('fr-FR')} km parcourus depuis le dernier changement.`,
      vehiculeId: v.id
    });
  }
  // Pneus — état déclaré par le chauffeur.
  if (v.etatPneus === 'crevaison') {
    alertes.push({ type: 'pneus', niveau: 'rouge', message: `Pneu crevé signalé sur ${v.immatriculation}.`, vehiculeId: v.id });
  } else if (v.etatPneus === 'pression_faible') {
    alertes.push({ type: 'pneus', niveau: 'orange', message: `Pression des pneus faible signalée sur ${v.immatriculation}.`, vehiculeId: v.id });
  } else if (v.etatPneus === 'usure_avant' || v.etatPneus === 'usure_arriere') {
    alertes.push({ type: 'pneus', niveau: 'orange', message: `Usure des pneus (${v.etatPneus === 'usure_avant' ? 'avant' : 'arrière'}) signalée sur ${v.immatriculation}.`, vehiculeId: v.id });
  }

  // Autres états déclarés par le chauffeur (batterie, freins, éclairage, climatisation).
  if (v.etatBatterie === 'a_remplacer') {
    alertes.push({ type: 'etat_vehicule', niveau: 'rouge', message: `Batterie à remplacer sur ${v.immatriculation}.`, vehiculeId: v.id });
  } else if (v.etatBatterie === 'faible') {
    alertes.push({ type: 'etat_vehicule', niveau: 'orange', message: `Batterie faible signalée sur ${v.immatriculation}.`, vehiculeId: v.id });
  }
  if (v.etatFreins === 'usure') {
    alertes.push({ type: 'etat_vehicule', niveau: 'rouge', message: `Usure des freins signalée sur ${v.immatriculation}.`, vehiculeId: v.id });
  } else if (v.etatFreins === 'bruit') {
    alertes.push({ type: 'etat_vehicule', niveau: 'orange', message: `Bruit de freinage signalé sur ${v.immatriculation}.`, vehiculeId: v.id });
  }
  if (v.etatEclairage === 'ampoule_grillee') {
    alertes.push({ type: 'etat_vehicule', niveau: 'orange', message: `Ampoule grillée signalée sur ${v.immatriculation}.`, vehiculeId: v.id });
  }
  if (v.etatClimatisation === 'panne') {
    alertes.push({ type: 'etat_vehicule', niveau: 'orange', message: `Climatisation en panne sur ${v.immatriculation}.`, vehiculeId: v.id });
  }

  return alertes;
}

/** Alertes liées à un chauffeur : expiration du permis. */
export function computeChauffeurAlertes(c: ChauffeurRow): Alerte[] {
  const alertes: Alerte[] = [];
  const joursPermis = joursRestants(c.permisDateExpiration);
  if (joursPermis != null && joursPermis <= 30) {
    alertes.push({
      type: 'permis',
      niveau: joursPermis < 0 ? 'rouge' : 'orange',
      message: joursPermis < 0
        ? `Permis de ${c.nom} expiré depuis ${Math.abs(joursPermis)} j.`
        : `Permis de ${c.nom} expire dans ${joursPermis} j.`,
      chauffeurId: c.id
    });
  }
  return alertes;
}

/** Alertes pour le portail chauffeur : son véhicule habituel + sa propre fiche. */
export function computeChauffeurPortalAlertes(chauffeur: ChauffeurRow, vehiculeHabituel: VehiculeRow | null, lastPneusKm: number | null = null): Alerte[] {
  const alertes: Alerte[] = [];
  if (vehiculeHabituel) alertes.push(...computeVehiculeAlertes(vehiculeHabituel, lastPneusKm));
  alertes.push(...computeChauffeurAlertes(chauffeur));
  return alertes;
}

export interface AlertesResume {
  vehiculesAAssurer: number;
  visitesExpirees: number;
  vidangesAFaire: number;
  jawazARecharger: number;
  permisExpires: number;
  pneusAlerte: number;
  etatVehiculeAlerte: number;
  total: number;
  alertes: Alerte[];
}

/** Résumé agrégé pour les administrateurs / responsables (tout le parc). */
export async function computeAlertesResume(): Promise<AlertesResume> {
  const vehicules = await db.select().from(vehiculesTable).where(isNull(vehiculesTable.deletedAt));
  const chauffeurs = await db.select().from(chauffeursTable).where(isNull(chauffeursTable.deletedAt));
  const lastPneusKmByVehicule = await fetchLastPneusKmByVehicule();

  const alertes: Alerte[] = [];
  for (const v of vehicules) alertes.push(...computeVehiculeAlertes(v, lastPneusKmByVehicule.get(v.id) ?? null));
  for (const c of chauffeurs) alertes.push(...computeChauffeurAlertes(c));

  const countUnique = (type: AlerteType, key: 'vehiculeId' | 'chauffeurId') =>
    new Set(alertes.filter((a) => a.type === type).map((a) => a[key])).size;

  return {
    vehiculesAAssurer: countUnique('assurance', 'vehiculeId'),
    visitesExpirees: countUnique('visite_technique', 'vehiculeId'),
    vidangesAFaire: countUnique('vidange', 'vehiculeId'),
    jawazARecharger: countUnique('jawaz', 'vehiculeId'),
    permisExpires: countUnique('permis', 'chauffeurId'),
    pneusAlerte: countUnique('pneus', 'vehiculeId'),
    etatVehiculeAlerte: countUnique('etat_vehicule', 'vehiculeId'),
    total: alertes.length,
    alertes
  };
}
