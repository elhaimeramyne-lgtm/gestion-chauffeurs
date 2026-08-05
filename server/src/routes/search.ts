import { Router } from 'express';
import { and, desc, ilike, isNull, or, sql } from 'drizzle-orm';
import {
  db, usersTable, facturesTable, lignesTable, lignesFixesTable, auditLogsTable,
  vehiculesTable, chauffeursTable, deplacementsTable, orgNodesTable
} from '../db.js';
import { requireAuth } from '../middleware/auth.js';
import { hasPermission } from '../lib/permissions.js';

const router = Router();
router.use(requireAuth);

/** Recherche universelle façon "omnibox" : un seul champ, plusieurs types de
 *  résultats. Chaque catégorie est limitée à 5 résultats pour rester rapide
 *  et lisible dans un menu déroulant. Les comptes utilisateurs ne sont
 *  retournés que si l'appelant a le droit de les consulter. */
router.get('/search', async (req, res) => {
  const q = typeof req.query.q === 'string' ? req.query.q.trim() : '';
  if (q.length < 2) {
    return res.json({ users: [], factures: [], lignes: [], lignesFixes: [], directions: [], activity: [], vehicules: [], chauffeurs: [], deplacements: [] });
  }
  const like = `%${q}%`;

  const [factures, lignes, lignesFixes] = await Promise.all([
    db
      .select({ id: facturesTable.id, custcode: facturesTable.custcode, refFacture: facturesTable.refFacture, nom: facturesTable.nom, montant: facturesTable.montant, statut: facturesTable.statut })
      .from(facturesTable)
      .where(
        and(
          isNull(facturesTable.deletedAt),
          or(
            ilike(facturesTable.custcode, like),
            ilike(facturesTable.refFacture, like),
            ilike(facturesTable.nom, like),
            ilike(facturesTable.nd, like)
          )
        )
      )
      .limit(5),
    db
      .select({ id: lignesTable.id, personne: lignesTable.personne, icc: lignesTable.icc, imei: lignesTable.imei, categorie: lignesTable.categorie })
      .from(lignesTable)
      .where(
        and(
          isNull(lignesTable.deletedAt),
          or(ilike(lignesTable.personne, like), ilike(lignesTable.icc, like), ilike(lignesTable.imei, like), ilike(lignesTable.affecte, like))
        )
      )
      .limit(5),
    db
      .select({ id: lignesFixesTable.id, nd: lignesFixesTable.nd, personne: lignesFixesTable.personne, custcode: lignesFixesTable.custcode, delegation: lignesFixesTable.delegation })
      .from(lignesFixesTable)
      .where(
        and(
          isNull(lignesFixesTable.deletedAt),
          or(ilike(lignesFixesTable.nd, like), ilike(lignesFixesTable.personne, like), ilike(lignesFixesTable.custcode, like))
        )
      )
      .limit(5)
  ]);

  let users: Array<{ id: number; username: string; displayName: string | null; role: string }> = [];
  if (hasPermission(req.user!.role, 'users.view')) {
    users = await db
      .select({ id: usersTable.id, username: usersTable.username, displayName: usersTable.displayName, role: usersTable.role })
      .from(usersTable)
      .where(
        and(
          isNull(usersTable.deletedAt),
          or(ilike(usersTable.username, like), ilike(usersTable.displayName, like))
        )
      )
      .limit(5);
  }

  const directionsResult = await db.execute<{ direction: string }>(sql`
    SELECT DISTINCT delegation AS direction FROM iam.factures
    WHERE deleted_at IS NULL AND delegation ILIKE ${like}
    LIMIT 5
  `);
  const directions = directionsResult.rows.map((r) => r.direction).filter(Boolean);

  let activity: Array<{ id: number; username: string | null; action: string; entity: string; createdAt: Date }> = [];
  if (hasPermission(req.user!.role, 'audit.view')) {
    activity = await db
      .select({ id: auditLogsTable.id, username: auditLogsTable.username, action: auditLogsTable.action, entity: auditLogsTable.entity, createdAt: auditLogsTable.createdAt })
      .from(auditLogsTable)
      .where(or(ilike(auditLogsTable.username, like), ilike(auditLogsTable.entity, like), ilike(auditLogsTable.entityId, like)))
      .orderBy(desc(auditLogsTable.createdAt))
      .limit(5);
  }

  let vehicules: Array<{ id: number; immatriculation: string; marque: string; modele: string; statut: string }> = [];
  let chauffeurs: Array<{ id: number; nom: string; telephone: string | null; statut: string }> = [];
  let deplacements: Array<{ id: number; numero: string; objet: string; destination: string | null; statut: string }> = [];

  // Parc Automobile / Chauffeurs / Déplacements — mêmes droits que le reste
  // des modules métier (invisible pour un compte CHAUFFEUR, qui n'a de
  // toute façon accès qu'à son portail dédié, voir routes/chauffeurPortal.ts).
  if (hasPermission(req.user!.role, 'business.read')) {
    [vehicules, chauffeurs, deplacements] = await Promise.all([
      db
        .select({ id: vehiculesTable.id, immatriculation: vehiculesTable.immatriculation, marque: vehiculesTable.marque, modele: vehiculesTable.modele, statut: vehiculesTable.statut })
        .from(vehiculesTable)
        .where(
          and(
            isNull(vehiculesTable.deletedAt),
            or(ilike(vehiculesTable.immatriculation, like), ilike(vehiculesTable.marque, like), ilike(vehiculesTable.modele, like))
          )
        )
        .limit(5),
      db
        .select({ id: chauffeursTable.id, nom: chauffeursTable.nom, telephone: chauffeursTable.telephone, statut: chauffeursTable.statut })
        .from(chauffeursTable)
        .where(and(isNull(chauffeursTable.deletedAt), or(ilike(chauffeursTable.nom, like), ilike(chauffeursTable.telephone, like))))
        .limit(5),
      db
        .select({ id: deplacementsTable.id, numero: deplacementsTable.numero, objet: deplacementsTable.objet, destination: deplacementsTable.destination, statut: deplacementsTable.statut })
        .from(deplacementsTable)
        .where(
          and(
            isNull(deplacementsTable.deletedAt),
            or(ilike(deplacementsTable.numero, like), ilike(deplacementsTable.objet, like), ilike(deplacementsTable.destination, like))
          )
        )
        .limit(5)
    ]);
  }

  res.json({ users, factures, lignes, lignesFixes, directions, activity, vehicules, chauffeurs, deplacements });
});

export default router;
