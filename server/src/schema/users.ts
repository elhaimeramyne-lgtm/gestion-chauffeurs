import { serial, text, timestamp, boolean, pgSchema } from 'drizzle-orm/pg-core';

const iamSchema = pgSchema('iam');

/** Rôles (du plus bas au plus haut, hors CHAUFFEUR qui est hors hiérarchie
 *  "métier" — voir routes/chauffeurPortal.ts) :
 *  - USER : accès aux modules métier en lecture/écriture (pas de
 *    suppression), pas de gestion des comptes ni des paramètres système.
 *  - GESTIONNAIRE : accès complet aux modules métier (y compris suppression
 *    et tableau de bord), mais aucune gestion des comptes ni accès à
 *    l'audit ou aux paramètres système — un rôle "opérationnel", pas
 *    "administratif".
 *  - CHEF_DIVISION : mêmes droits que GESTIONNAIRE sur les modules métier,
 *    mais un cran au-dessus dans la hiérarchie — lui donne l'autorité de
 *    validation "chef de service/division" dans les workflows (ex : étape
 *    de validation des demandes de service).
 *  - ADMIN : gère les comptes GESTIONNAIRE/CHEF_DIVISION/USER et l'ensemble
 *    des modules métier, consulte l'audit et le tableau de bord.
 *  - SUPER_ADMIN : accès total, seul rôle habilité à gérer les comptes
 *    SUPER_ADMIN/ADMIN, les paramètres système et la corbeille. */
export const userRoleEnum = iamSchema.enum('user_role', ['SUPER_ADMIN', 'ADMIN', 'CHEF_DIVISION', 'GESTIONNAIRE', 'USER', 'CHAUFFEUR']);

export const usersTable = iamSchema.table('users', {
  id: serial('id').primaryKey(),
  username: text('username').notNull().unique(),
  passwordHash: text('password_hash').notNull(),
  displayName: text('display_name'),
  role: userRoleEnum('role').notNull().default('USER'),
  /** Compte désactivé = connexion refusée, sans supprimer les données liées. */
  isActive: boolean('is_active').notNull().default(true),
  lastLoginAt: timestamp('last_login_at'),
  /** Mis à jour à chaque requête authentifiée (voir middleware/auth.ts) —
   *  sert à déterminer qui est "en ligne" en ce moment (présence). */
  lastSeenAt: timestamp('last_seen_at'),
  /** Double authentification (TOTP). Le secret ne doit jamais être exposé
   *  au client une fois enregistré — voir routes/security.ts. */
  twoFactorEnabled: boolean('two_factor_enabled').notNull().default(false),
  twoFactorSecret: text('two_factor_secret'),
  /** Suppression douce : voir Corbeille. Un compte supprimé n'apparaît plus
   *  dans /users mais reste restaurable par un SUPER_ADMIN. */
  deletedAt: timestamp('deleted_at'),
  deletedBy: text('deleted_by'),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull()
});

export type UserRow = typeof usersTable.$inferSelect;
export type NewUserRow = typeof usersTable.$inferInsert;
export type PublicUser = Omit<UserRow, 'passwordHash' | 'twoFactorSecret'>;
