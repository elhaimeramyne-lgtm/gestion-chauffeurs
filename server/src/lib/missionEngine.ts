/**
 * Mission Engine — Moteur de workflow à 9+ statuts pour les ordres de
 * mission (déplacements).
 *
 * Workflow complet :
 *   creee → en_attente_acceptation → acceptee → en_route → arrive →
 *   mission_en_cours → terminee → retour → arrive_siege → cloturee
 *
 * Chaque transition :
 *   1. Valide que la transition est autorisée depuis le statut courant.
 *   2. Déclenche les effets de bord (synchronisation véhicule/chauffeur,
 *      mise à jour des horodatages, création d'événement de timeline).
 *   3. Met à jour le statut du déplacement et retourne l’objet modifié.
 *
 * Toute transition illégale renvoie une erreur structurée { ok: false,
 * status, error } — l'appelant n'a qu'à la transmettre tel quelle dans
 * la réponse HTTP.
 */
import { and, desc, eq, inArray, isNull } from 'drizzle-orm';
import { db, deplacementsTable, deplacementEventsTable, deplacementPhotosTable, deplacementGpsPointsTable, vehiculesTable, vehiculeEventsTable, chauffeursTable } from '../db.js';
import { broadcastNotifications } from '../routes/notifications-sse.js';
import type { DeplacementRow } from '../schema/deplacements.js';

/* ═══════════════════════════════════════════════════════════════════════
 * TYPES
 * ═══════════════════════════════════════════════════════════════════════ */

/** Les 11 valeurs possibles du statut. */
export type DeplacementStatut = DeplacementRow['statut'];

/** Résultat d'une transition. */
export type TransitionResult =
  | { ok: true; deplacement: DeplacementRow }
  | { ok: false; status: number; error: string };

/** Données optionnelles qui peuvent accompagner une transition. */
export interface TransitionExtra {
  /** Kilométrage au départ (en_route, acceptee). */
  kilometrageDepart?: number;
  /** Kilométrage au retour (arrive_siege, cloturee). */
  kilometrageRetour?: number;
  /** Rapport / observations du chauffeur. */
  rapportMission?: string;
  /** Date effective de retour (JJ/MM/AAAA). */
  dateRetourEffective?: string;
  /** Latitude GPS au moment de la transition. */
  lat?: number;
  /** Longitude GPS au moment de la transition. */
  lng?: number;
  /** Commentaire libre pour l'événement de timeline. */
  commentaire?: string;
  /** Observations saisies par le chauffeur pendant la mission. */
  observationsChauffeur?: string;
  /** Notes de clôture saisies par le responsable. */
  notesCloture?: string;
  /** Consommation de carburant en litres. */
  consommationCarburant?: number;
  /** Distance parcourue en km. */
  distanceKm?: number;
}

/* ═══════════════════════════════════════════════════════════════════════
 * TRANSITIONS AUTORISÉES
 * ═══════════════════════════════════════════════════════════════════════
 * Chaque statut ne peut transitionner que vers les statuts listés
 * ci-dessous. Toute tentative en dehors de ces chemins est rejetée. */

const TRANSITIONS: Record<DeplacementStatut, DeplacementStatut[]> = {
  creee:                   ['en_attente_acceptation', 'annule'],
  en_attente_acceptation:  ['acceptee', 'creee', 'annule'],
  acceptee:                ['en_route', 'annule'],
  en_route:                ['arrive', 'annule'],
  arrive:                  ['mission_en_cours', 'annule'],
  mission_en_cours:        ['terminee', 'annule'],
  terminee:                ['retour', 'annule'],
  retour:                  ['arrive_siege', 'annule'],
  arrive_siege:            ['cloturee', 'annule'],
  cloturee:                [],
  annule:                  [],
};

/* ═══════════════════════════════════════════════════════════════════════
 * EFFETS DE BORD PAR TRANSITION
 * ═══════════════════════════════════════════════════════════════════════
 * Chaque fonction retourne un objet de mise à jour partiel qui sera
 * fusionné dans le UPDATE final du déplacement. */

function getUpdatePayload(
  current: DeplacementRow,
  newStatut: DeplacementStatut,
  extra: TransitionExtra
): Record<string, unknown> {
  const now = new Date();
  const payload: Record<string, unknown> = {
    statut: newStatut,
    updatedAt: now,
  };

  switch (newStatut) {
    case 'acceptee':
      payload.acceptedAt = now;
      payload.acceptedBy = extra.commentaire ?? null;
      payload.kilometrageDepart = extra.kilometrageDepart ?? current.kilometrageDepart;
      break;

    case 'en_route':
      payload.heureDepartReelle = now;
      payload.dateDepartReelle = formatDateDMY(now);
      payload.kilometrageDepart = extra.kilometrageDepart ?? current.kilometrageDepart;
      break;

    case 'arrive':
      payload.heureArriveeReelle = now;
      payload.dateArriveeReelle = formatDateDMY(now);
      break;

    case 'mission_en_cours':
      // Aucun champ temporel spécifique — le chauffeur commence sa
      // prestation sur site.
      break;

    case 'terminee':
      payload.heureRetourReelle = now;
      payload.dateRetourReelle = formatDateDMY(now);
      payload.dateRetourEffective = extra.dateRetourEffective ?? current.dateRetourEffective;
      payload.rapportMission = extra.rapportMission ?? current.rapportMission;
      payload.observationsChauffeur = extra.observationsChauffeur ?? current.observationsChauffeur;
      break;

    case 'retour':
      // Le chauffeur a quitté le site pour revenir au siège.
      break;

    case 'arrive_siege':
      payload.kilometrageRetour = extra.kilometrageRetour ?? current.kilometrageRetour;
      break;

    case 'cloturee':
      payload.heureCloture = now;
      payload.dateCloture = now;
      payload.notesCloture = extra.notesCloture ?? current.notesCloture;
      payload.consommationCarburant = extra.consommationCarburant ?? current.consommationCarburant;
      payload.distanceKm = extra.distanceKm ?? current.distanceKm;
      break;

    case 'annule':
      payload.notesCloture = extra.notesCloture ?? current.notesCloture;
      break;
  }

  return payload;
}

/** Crée un événement de timeline correspondant à la transition. */
async function createEvent(
  deplacementId: number,
  newStatut: DeplacementStatut,
  extra: TransitionExtra,
  username: string
): Promise<void> {
  await db.insert(deplacementEventsTable).values({
    deplacementId,
    statut: newStatut,
    commentaire: extra.commentaire ?? null,
    latitude: extra.lat != null ? String(extra.lat) : null,
    longitude: extra.lng != null ? String(extra.lng) : null,
    actionPar: username,
  });
}

/** Synchronise le statut du véhicule et du chauffeur. */
async function syncResources(
  current: DeplacementRow,
  newStatut: DeplacementStatut,
  username: string
): Promise<void> {
  const vehicule = current.vehiculeId
    ? (await db.select().from(vehiculesTable).where(eq(vehiculesTable.id, current.vehiculeId)))[0]
    : null;
  const chauffeur = current.chauffeurId
    ? (await db.select().from(chauffeursTable).where(eq(chauffeursTable.id, current.chauffeurId)))[0]
    : null;

  // Passage en mission : dès que le chauffeur accepte
  if (newStatut === 'acceptee') {
    if (vehicule && vehicule.statut !== 'en_mission') {
      await db.update(vehiculesTable).set({ statut: 'en_mission', updatedAt: new Date() }).where(eq(vehiculesTable.id, vehicule.id));
      await db.insert(vehiculeEventsTable).values({
        vehiculeId: vehicule.id,
        statut: 'en_mission',
        commentaire: `Accepté par le chauffeur — ${current.numero}.`,
        actionPar: username,
      });
    }
    if (chauffeur && chauffeur.statut !== 'en_mission') {
      await db.update(chauffeursTable).set({ statut: 'en_mission', updatedAt: new Date() }).where(eq(chauffeursTable.id, chauffeur.id));
    }
  }

  // Retour à la normale : clôture de la mission
  if (newStatut === 'cloturee') {
    if (vehicule) {
      await db.update(vehiculesTable).set({ statut: 'disponible', updatedAt: new Date() }).where(eq(vehiculesTable.id, vehicule.id));
      await db.insert(vehiculeEventsTable).values({
        vehiculeId: vehicule.id,
        statut: 'disponible',
        commentaire: `Mission clôturée — ${current.numero}.`,
        actionPar: username,
      });
    }
    if (chauffeur) {
      await db.update(chauffeursTable).set({ statut: 'disponible', updatedAt: new Date() }).where(eq(chauffeursTable.id, chauffeur.id));
    }
  }

  // Annulation : libérer les ressources (véhicule et/ou chauffeur peuvent
  // avoir été verrouillés dès la validation d'une demande de chauffeur,
  // avant même l'acceptation — donc on les libère dans tous les cas où ils
  // sont effectivement encore marqués "en_mission").
  if (newStatut === 'annule') {
    if (vehicule && vehicule.statut === 'en_mission') {
      await db.update(vehiculesTable).set({ statut: 'disponible', updatedAt: new Date() }).where(eq(vehiculesTable.id, vehicule.id));
      await db.insert(vehiculeEventsTable).values({
        vehiculeId: vehicule.id,
        statut: 'disponible',
        commentaire: `Mission annulée — ${current.numero}.`,
        actionPar: username,
      });
    }
    if (chauffeur && chauffeur.statut === 'en_mission') {
      await db.update(chauffeursTable).set({ statut: 'disponible', updatedAt: new Date() }).where(eq(chauffeursTable.id, chauffeur.id));
    }
  }
}

/** Calcule et met à jour la durée de mission en minutes lors de la clôture. */
async function updateDureeMission(deplacementId: number, current: DeplacementRow): Promise<void> {
  const start = current.heureDepartReelle;
  const end = current.heureRetourReelle ?? current.heureCloture;
  if (start && end) {
    const duree = Math.round((end.getTime() - start.getTime()) / 60_000);
    await db.update(deplacementsTable).set({ dureeMission: duree }).where(eq(deplacementsTable.id, deplacementId));
  }
}

/* ═══════════════════════════════════════════════════════════════════════
 * FONCTION PRINCIPALE
 * ═══════════════════════════════════════════════════════════════════════ */

/**
 * Applique une transition de statut sur un déplacement.
 *
 * @param id          ID du déplacement.
 * @param newStatut   Statut cible.
 * @param extra       Données optionnelles accompagnant la transition.
 * @param username    Nom de l'utilisateur effectuant l'action.
 * @returns           { ok: true, deplacement } ou { ok: false, status, error }.
 */
export async function applyTransition(
  id: number,
  newStatut: DeplacementStatut,
  extra: TransitionExtra,
  username: string
): Promise<TransitionResult> {
  const [deplacement] = await db
    .select()
    .from(deplacementsTable)
    .where(and(eq(deplacementsTable.id, id), isNull(deplacementsTable.deletedAt)));

  if (!deplacement) {
    return { ok: false, status: 404, error: 'Déplacement introuvable.' };
  }

  // Vérifier que la transition est autorisée
  const allowed = TRANSITIONS[deplacement.statut];
  if (!allowed || !allowed.includes(newStatut)) {
    return {
      ok: false,
      status: 400,
      error: `Transition non autorisée : « ${deplacement.statut} » → « ${newStatut} ».`,
    };
  }

  // Vérifications spécifiques
  if (newStatut === 'acceptee') {
    if (!deplacement.chauffeurId) {
      return { ok: false, status: 400, error: 'Aucun chauffeur assigné à cette mission.' };
    }
  }

  if (newStatut === 'en_route') {
    if (deplacement.vehiculeId) {
      const [vehicule] = await db.select().from(vehiculesTable).where(eq(vehiculesTable.id, deplacement.vehiculeId));
      if (!vehicule || vehicule.deletedAt) {
        return { ok: false, status: 400, error: 'Véhicule introuvable.' };
      }
    }
  }

  // 1. Calculer les champs à mettre à jour
  const updatePayload = getUpdatePayload(deplacement, newStatut, extra);

  // 2. Mettre à jour le déplacement
  const [updated] = await db
    .update(deplacementsTable)
    .set(updatePayload)
    .where(eq(deplacementsTable.id, id))
    .returning();

  if (!updated) {
    return { ok: false, status: 500, error: 'Échec de la mise à jour du déplacement.' };
  }

  // 3. Créer l'événement de timeline
  await createEvent(id, newStatut, extra, username);

  // 4. Synchroniser les ressources (véhicule, chauffeur)
  await syncResources(deplacement, newStatut, username);

  // 5. Calculer la durée si clôture
  if (newStatut === 'cloturee') {
    await updateDureeMission(id, deplacement);
  }

  // 6. Notifier les clients connectés
  broadcastNotifications().catch(() => {});

  return { ok: true, deplacement: updated };
}

/* ═══════════════════════════════════════════════════════════════════════
 * FONCTIONS UTILITAIRES
 * ═══════════════════════════════════════════════════════════════════════ */

/** Formate une date en JJ/MM/AAAA. */
function formatDateDMY(date: Date): string {
  const d = String(date.getDate()).padStart(2, '0');
  const m = String(date.getMonth() + 1).padStart(2, '0');
  const y = date.getFullYear();
  return `${d}/${m}/${y}`;
}

/* ═══════════════════════════════════════════════════════════════════════
 * FONCTIONS D'ENRICHISSEMENT (détail d'un déplacement avec timeline,
 * photos, GPS)
 * ═══════════════════════════════════════════════════════════════════════ */

export async function getDeplacementDetail(id: number) {
  const [deplacement] = await db
    .select()
    .from(deplacementsTable)
    .where(and(eq(deplacementsTable.id, id), isNull(deplacementsTable.deletedAt)));

  if (!deplacement) return null;

  const events = await db
    .select()
    .from(deplacementEventsTable)
    .where(eq(deplacementEventsTable.deplacementId, id))
    .orderBy(desc(deplacementEventsTable.createdAt));

  const photos = await db
    .select()
    .from(deplacementPhotosTable)
    .where(eq(deplacementPhotosTable.deplacementId, id))
    .orderBy(desc(deplacementPhotosTable.createdAt));

  const gpsPoints = await db
    .select()
    .from(deplacementGpsPointsTable)
    .where(eq(deplacementGpsPointsTable.deplacementId, id))
    .orderBy(desc(deplacementGpsPointsTable.createdAt))
    .limit(500);

  return { deplacement, events, photos, gpsPoints };
}

export async function getDeplacementTimeline(id: number) {
  const events = await db
    .select()
    .from(deplacementEventsTable)
    .where(eq(deplacementEventsTable.deplacementId, id))
    .orderBy(desc(deplacementEventsTable.createdAt));

  return events;
}

export async function recordGpsPoint(
  deplacementId: number,
  lat: number,
  lng: number,
  extra?: { vitesse?: number; precision?: number; cap?: number }
) {
  const [point] = await db
    .insert(deplacementGpsPointsTable)
    .values({
      deplacementId,
      latitude: lat,
      longitude: lng,
      vitesse: extra?.vitesse ?? null,
      precision: extra?.precision ?? null,
      cap: extra?.cap ?? null,
    })
    .returning();

  return point;
}

export async function attachPhoto(
  deplacementId: number,
  type: 'depart' | 'arrivee' | 'bon_livraison' | 'retour' | 'autre',
  filename: string,
  uploadedBy: string,
  extra?: { originalName?: string; mimeType?: string; sizeBytes?: number }
) {
  const [photo] = await db
    .insert(deplacementPhotosTable)
    .values({
      deplacementId,
      type,
      filename,
      originalName: extra?.originalName ?? null,
      mimeType: extra?.mimeType ?? null,
      sizeBytes: extra?.sizeBytes ?? null,
      uploadedBy,
    })
    .returning();

  return photo;
}

/* ═══════════════════════════════════════════════════════════════════════
 * MAPPE DE STATUTS POUR LE FRONTEND
 * ═══════════════════════════════════════════════════════════════════════ */

/** Étapes ordonnées pour l'affichage de la barre de progression. */
export const ETAPES_ORDRE: DeplacementStatut[] = [
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
];

/** Libellés lisibles pour chaque statut. */
export const STATUT_LABELS: Record<DeplacementStatut, string> = {
  creee: 'Créée',
  en_attente_acceptation: 'En attente d\'acceptation',
  acceptee: 'Acceptée',
  en_route: 'En route',
  arrive: 'Arrivé',
  mission_en_cours: 'Mission en cours',
  terminee: 'Terminée',
  retour: 'Retour',
  arrive_siege: 'Arrivé au siège',
  cloturee: 'Clôturée',
  annule: 'Annulée',
};

/** Couleurs associées à chaque statut pour l'UI. */
export const STATUT_COLORS: Record<DeplacementStatut, string> = {
  creee: '#6b7280',
  en_attente_acceptation: '#f59e0b',
  acceptee: '#22c55e',
  en_route: '#3b82f6',
  arrive: '#8b5cf6',
  mission_en_cours: '#22c55e',
  terminee: '#14b8a6',
  retour: '#f97316',
  arrive_siege: '#06b6d4',
  cloturee: '#10b981',
  annule: '#ef4444',
};

/** Vérifie si un statut est antérieur ou égal à un autre dans le workflow. */
export function isEtapeAtteinte(current: DeplacementStatut, etape: DeplacementStatut): boolean {
  const curIdx = ETAPES_ORDRE.indexOf(current);
  const etaIdx = ETAPES_ORDRE.indexOf(etape);
  if (curIdx === -1 || etaIdx === -1) return false;
  return etaIdx <= curIdx;
}

