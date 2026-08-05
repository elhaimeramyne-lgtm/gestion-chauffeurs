/**
 * Affectation d'un véhicule à un chauffeur — responsabilité du véhicule.
 *
 * vehicules.chauffeur_attitre_id reste la source unique de vérité pour
 * l'affectation "en cours" ; assignVehicule()/unassignVehicule() maintiennent
 * en plus un historique complet dans vehicule_affectations, consultable
 * depuis la fiche véhicule. Utilisé à la fois depuis les routes véhicule
 * (affectation initiée côté Parc Automobile) et chauffeur (affectation
 * initiée côté fiche chauffeur), pour que l'invariant "un véhicule → un
 * chauffeur responsable à la fois" reste garanti quel que soit le sens.
 */
import { and, eq, isNull, ne } from 'drizzle-orm';
import { db, vehiculesTable, vehiculeAffectationsTable } from '../db.js';

export function todayDMY(): string {
  const d = new Date();
  const pad = (n: number) => String(n).padStart(2, '0');
  return `${pad(d.getDate())}/${pad(d.getMonth() + 1)}/${d.getFullYear()}`;
}

/** Affecte (ou réaffecte) un véhicule à un chauffeur, en journalisant le
 *  changement. Libère automatiquement toute affectation précédente — celle
 *  de ce véhicule, et celle de ce chauffeur sur un autre véhicule le cas
 *  échéant, pour garder une relation 1↔1 cohérente. */
export async function assignVehicule(vehiculeId: number, chauffeurId: number, responsable: string): Promise<void> {
  const today = todayDMY();

  // Ferme l'affectation active de ce véhicule, quel qu'en soit le titulaire.
  await db.update(vehiculeAffectationsTable)
    .set({ dateFin: today })
    .where(and(eq(vehiculeAffectationsTable.vehiculeId, vehiculeId), isNull(vehiculeAffectationsTable.dateFin)));

  // Si ce chauffeur avait déjà un AUTRE véhicule habituel, on l'en détache.
  const [autreVehicule] = await db
    .select({ id: vehiculesTable.id })
    .from(vehiculesTable)
    .where(and(eq(vehiculesTable.chauffeurAttitreId, chauffeurId), ne(vehiculesTable.id, vehiculeId)));
  if (autreVehicule) {
    await db.update(vehiculesTable).set({ chauffeurAttitreId: null, updatedAt: new Date() }).where(eq(vehiculesTable.id, autreVehicule.id));
    await db.update(vehiculeAffectationsTable)
      .set({ dateFin: today })
      .where(and(eq(vehiculeAffectationsTable.vehiculeId, autreVehicule.id), isNull(vehiculeAffectationsTable.dateFin)));
  }

  await db.insert(vehiculeAffectationsTable).values({ vehiculeId, chauffeurId, dateAffectation: today, responsable });
  await db.update(vehiculesTable).set({ chauffeurAttitreId: chauffeurId, updatedAt: new Date() }).where(eq(vehiculesTable.id, vehiculeId));
}

/** Retire la responsabilité en cours d'un véhicule (sans en affecter un nouveau). */
export async function unassignVehicule(vehiculeId: number): Promise<void> {
  const today = todayDMY();
  await db.update(vehiculeAffectationsTable)
    .set({ dateFin: today })
    .where(and(eq(vehiculeAffectationsTable.vehiculeId, vehiculeId), isNull(vehiculeAffectationsTable.dateFin)));
  await db.update(vehiculesTable).set({ chauffeurAttitreId: null, updatedAt: new Date() }).where(eq(vehiculesTable.id, vehiculeId));
}
