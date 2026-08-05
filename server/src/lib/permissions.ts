import type { PublicUser } from '../schema/users.js';

export type Role = PublicUser['role'];

/** Hiérarchie des rôles : plus le nombre est élevé, plus le rôle a de droits.
 *  Un SUPER_ADMIN passe toujours toutes les vérifications de rôle/permission. */
export const ROLE_RANK: Record<Role, number> = {
  CHAUFFEUR: 0,
  USER: 1,
  GESTIONNAIRE: 2,
  CHEF_DIVISION: 3,
  ADMIN: 4,
  SUPER_ADMIN: 5
};

export function isAtLeast(role: Role, minimum: Role): boolean {
  return ROLE_RANK[role] >= ROLE_RANK[minimum];
}

/** Permissions applicatives fines, indépendantes des routes. Chaque route
 *  protégée déclare la permission qu'elle nécessite plutôt qu'un rôle brut,
 *  ce qui centralise la matrice des droits à un seul endroit. */
export type Permission =
  | 'users.view'
  | 'users.manage_users' // créer/modifier/désactiver des comptes GESTIONNAIRE/USER
  | 'users.manage_admins' // créer/modifier/désactiver des comptes ADMIN/SUPER_ADMIN
  | 'audit.view'
  | 'dashboard.view' // tableau de bord Executive (statistiques globales)
  | 'settings.manage' // paramètres système, sauvegarde
  | 'org.view'        // consulter l'organigramme
  | 'org.manage'      // modifier l'organigramme (ADMIN+)
  | 'trash.manage' // corbeille / restauration
  | 'business.read'
  | 'business.write'
  | 'business.delete';

const PERMISSIONS: Record<Role, Permission[]> = {
  /** Aucune permission "métier" générique — le compte chauffeur n'accède
   *  qu'aux routes dédiées du portail chauffeur (routes/chauffeurPortal.ts),
   *  qui vérifient elles-mêmes que la mission demandée lui appartient. */
  CHAUFFEUR: [],
  USER: ['business.read', 'business.write', 'org.view'],
  GESTIONNAIRE: [
    'business.read',
    'business.write',
    'business.delete',
    'dashboard.view',
    'org.view'
  ],
  /** Mêmes droits "métier" que GESTIONNAIRE — la distinction est purement
   *  hiérarchique (voir ROLE_RANK) : un Chef de Division peut valider les
   *  étapes de workflow qui exigent au moins le rang GESTIONNAIRE (ex :
   *  validation "chef de service" des demandes de service). */
  CHEF_DIVISION: [
    'business.read',
    'business.write',
    'business.delete',
    'dashboard.view',
    'org.view'
  ],
  ADMIN: [
    'users.view',
    'users.manage_users',
    'audit.view',
    'dashboard.view',
    'business.read',
    'business.write',
    'business.delete',
    'org.view',
    'org.manage'
  ],
  SUPER_ADMIN: [
    'users.view',
    'users.manage_users',
    'users.manage_admins',
    'audit.view',
    'dashboard.view',
    'settings.manage',
    'trash.manage',
    'business.read',
    'business.write',
    'business.delete',
    'org.view',
    'org.manage'
  ]
};

export function hasPermission(role: Role, permission: Permission): boolean {
  return PERMISSIONS[role]?.includes(permission) ?? false;
}

/** Un compte ne peut créer/modifier un compte cible que si son rôle est
 *  strictement supérieur (ou égal pour un SUPER_ADMIN) au rôle cible. Évite
 *  qu'un ADMIN promeuve quelqu'un SUPER_ADMIN, et qu'un GESTIONNAIRE (qui
 *  n'a de toute façon aucun droit de gestion de comptes) modifie qui que
 *  ce soit. */
export function canManageRole(actorRole: Role, targetRole: Role): boolean {
  if (actorRole === 'SUPER_ADMIN') return true;
  if (actorRole === 'ADMIN') {
    return targetRole === 'CHEF_DIVISION' || targetRole === 'GESTIONNAIRE' || targetRole === 'USER' || targetRole === 'CHAUFFEUR';
  }
  return false;
}

/** Rôles qu'un acteur donné est autorisé à attribuer à un compte. */
export function assignableRoles(actorRole: Role): Role[] {
  if (actorRole === 'SUPER_ADMIN') return ['SUPER_ADMIN', 'ADMIN', 'CHEF_DIVISION', 'GESTIONNAIRE', 'USER', 'CHAUFFEUR'];
  if (actorRole === 'ADMIN') return ['CHEF_DIVISION', 'GESTIONNAIRE', 'USER', 'CHAUFFEUR'];
  return [];
}
