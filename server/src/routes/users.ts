import { Router } from 'express';
import { z } from 'zod';
import { and, eq, ilike, or, count, isNull } from 'drizzle-orm';
import { db, usersTable, chauffeursTable } from '../db.js';
import { hashPassword } from '../lib/auth.js';
import { requireAuth, requirePermission } from '../middleware/auth.js';
import { canManageRole, assignableRoles, type Role } from '../lib/permissions.js';

const router = Router();

router.use(requireAuth);

const PUBLIC_COLUMNS = {
  id: usersTable.id,
  username: usersTable.username,
  displayName: usersTable.displayName,
  role: usersTable.role,
  isActive: usersTable.isActive,
  lastLoginAt: usersTable.lastLoginAt,
  lastSeenAt: usersTable.lastSeenAt,
  createdAt: usersTable.createdAt,
  updatedAt: usersTable.updatedAt
};

// ── Liste avec recherche et filtres ─────────────────────────────────────
// GET /users?search=jean&role=ADMIN&status=active
router.get('/users', requirePermission('users.view'), async (req, res) => {
  const search = typeof req.query.search === 'string' ? req.query.search.trim() : '';
  const roleFilter = typeof req.query.role === 'string' ? req.query.role : '';
  const statusFilter = typeof req.query.status === 'string' ? req.query.status : '';

  const conditions = [isNull(usersTable.deletedAt)];
  if (search) {
    const searchCond = or(ilike(usersTable.username, `%${search}%`), ilike(usersTable.displayName, `%${search}%`));
    if (searchCond) conditions.push(searchCond);
  }
  if (['SUPER_ADMIN', 'ADMIN', 'CHEF_DIVISION', 'GESTIONNAIRE', 'USER', 'CHAUFFEUR'].includes(roleFilter)) {
    conditions.push(eq(usersTable.role, roleFilter as Role));
  }
  if (statusFilter === 'active') conditions.push(eq(usersTable.isActive, true));
  if (statusFilter === 'inactive') conditions.push(eq(usersTable.isActive, false));

  const users = await db
    .select(PUBLIC_COLUMNS)
    .from(usersTable)
    .where(and(...conditions))
    .orderBy(usersTable.username);
  res.json({ users });
});

const createUserSchema = z.object({
  username: z.string().min(3).max(50),
  password: z.string().min(6),
  displayName: z.string().optional(),
  role: z.enum(['SUPER_ADMIN', 'ADMIN', 'CHEF_DIVISION', 'GESTIONNAIRE', 'USER', 'CHAUFFEUR'])
});

router.post('/users', requirePermission('users.manage_users', 'users.manage_admins'), async (req, res) => {
  const parsed = createUserSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: parsed.error.issues[0]?.message ?? 'Données invalides.' });
  }
  const { username, password, displayName, role } = parsed.data;

  if (!canManageRole(req.user!.role, role)) {
    return res.status(403).json({ error: "Vous n'êtes pas autorisé à attribuer ce rôle." });
  }

  const [existing] = await db.select().from(usersTable).where(eq(usersTable.username, username)).limit(1);
  if (existing) {
    return res.status(409).json({ error: 'Ce nom d’utilisateur existe déjà.' });
  }

  const passwordHash = await hashPassword(password);
  const [created] = await db
    .insert(usersTable)
    .values({ username, passwordHash, displayName, role })
    .returning(PUBLIC_COLUMNS);

  // Un compte CHAUFFEUR a besoin d'une fiche dans le répertoire Chauffeurs
  // (véhicules/missions y font référence) — on la crée automatiquement
  // ici pour que le portail fonctionne immédiatement, qu'on soit passé par
  // cette page générique ou par le bouton dédié de la page Chauffeurs.
  if (role === 'CHAUFFEUR' && created) {
    await db.insert(chauffeursTable).values({ nom: displayName || username, userId: created.id, statut: 'disponible' });
  }

  res.status(201).json({ user: created });
});

const updateUserSchema = z.object({
  displayName: z.string().optional(),
  role: z.enum(['SUPER_ADMIN', 'ADMIN', 'CHEF_DIVISION', 'GESTIONNAIRE', 'USER', 'CHAUFFEUR']).optional(),
  password: z.string().min(6).optional(),
  isActive: z.boolean().optional()
});

router.patch('/users/:id', async (req, res) => {
  const id = Number(req.params.id);
  const parsed = updateUserSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: parsed.error.issues[0]?.message ?? 'Données invalides.' });
  }

  const [target] = await db
    .select()
    .from(usersTable)
    .where(and(eq(usersTable.id, id), isNull(usersTable.deletedAt)))
    .limit(1);
  if (!target) return res.status(404).json({ error: 'Utilisateur introuvable.' });

  // Un ADMIN ne peut gérer que des comptes USER (pas d'autres ADMIN, pas de SUPER_ADMIN).
  if (!canManageRole(req.user!.role, target.role)) {
    return res.status(403).json({ error: "Vous n'avez pas les droits sur ce compte." });
  }

  const { password, role, isActive, ...rest } = parsed.data;

  if (role && !canManageRole(req.user!.role, role)) {
    return res.status(403).json({ error: "Vous n'êtes pas autorisé à attribuer ce rôle." });
  }

  // Empêche de se retirer soi-même le rôle SUPER_ADMIN ou de se désactiver soi-même,
  // ce qui pourrait verrouiller l'accès au système.
  if (id === req.user!.userId) {
    if (role && role !== req.user!.role) {
      return res.status(400).json({ error: 'Vous ne pouvez pas modifier votre propre rôle.' });
    }
    if (isActive === false) {
      return res.status(400).json({ error: 'Vous ne pouvez pas désactiver votre propre compte.' });
    }
  }

  // Empêche de désactiver ou rétrograder le dernier SUPER_ADMIN actif.
  if (target.role === 'SUPER_ADMIN' && (isActive === false || (role && role !== 'SUPER_ADMIN'))) {
    const [{ value: activeSuperAdmins }] = await db
      .select({ value: count() })
      .from(usersTable)
      .where(and(eq(usersTable.role, 'SUPER_ADMIN'), eq(usersTable.isActive, true)));
    if (Number(activeSuperAdmins) <= 1) {
      return res.status(400).json({ error: 'Impossible : il doit rester au moins un compte SUPER_ADMIN actif.' });
    }
  }

  const values: Record<string, unknown> = { ...rest, updatedAt: new Date() };
  if (role) values.role = role;
  if (typeof isActive === 'boolean') values.isActive = isActive;
  if (password) values.passwordHash = await hashPassword(password);

  const [updated] = await db.update(usersTable).set(values).where(eq(usersTable.id, id)).returning(PUBLIC_COLUMNS);

  if (role === 'CHAUFFEUR' && updated) {
    const [linked] = await db.select({ id: chauffeursTable.id }).from(chauffeursTable).where(eq(chauffeursTable.userId, id));
    if (!linked) {
      await db.insert(chauffeursTable).values({ nom: updated.displayName || updated.username, userId: id, statut: 'disponible' });
    }
  }

  res.json({ user: updated });
});

// Réinitialisation rapide du mot de passe (raccourci dédié, en plus du PATCH générique).
const resetPasswordSchema = z.object({ password: z.string().min(6) });

router.post('/users/:id/reset-password', async (req, res) => {
  const id = Number(req.params.id);
  const parsed = resetPasswordSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: parsed.error.issues[0]?.message ?? 'Mot de passe invalide.' });
  }

  const [target] = await db
    .select()
    .from(usersTable)
    .where(and(eq(usersTable.id, id), isNull(usersTable.deletedAt)))
    .limit(1);
  if (!target) return res.status(404).json({ error: 'Utilisateur introuvable.' });
  if (!canManageRole(req.user!.role, target.role)) {
    return res.status(403).json({ error: "Vous n'avez pas les droits sur ce compte." });
  }

  const passwordHash = await hashPassword(parsed.data.password);
  await db.update(usersTable).set({ passwordHash, updatedAt: new Date() }).where(eq(usersTable.id, id));
  res.json({ ok: true });
});

router.delete('/users/:id', async (req, res) => {
  const id = Number(req.params.id);
  if (id === req.user!.userId) {
    return res.status(400).json({ error: 'Vous ne pouvez pas supprimer votre propre compte.' });
  }

  const [target] = await db
    .select()
    .from(usersTable)
    .where(and(eq(usersTable.id, id), isNull(usersTable.deletedAt)))
    .limit(1);
  if (!target) return res.status(404).json({ error: 'Utilisateur introuvable.' });
  if (!canManageRole(req.user!.role, target.role)) {
    return res.status(403).json({ error: "Vous n'avez pas les droits sur ce compte." });
  }

  if (target.role === 'SUPER_ADMIN') {
    const [{ value: activeSuperAdmins }] = await db
      .select({ value: count() })
      .from(usersTable)
      .where(and(eq(usersTable.role, 'SUPER_ADMIN'), eq(usersTable.isActive, true)));
    if (Number(activeSuperAdmins) <= 1) {
      return res.status(400).json({ error: 'Impossible : il doit rester au moins un compte SUPER_ADMIN.' });
    }
  }

  // Suppression douce : le compte part dans la Corbeille (Administration)
  // et reste restaurable par un SUPER_ADMIN.
  await db
    .update(usersTable)
    .set({ deletedAt: new Date(), deletedBy: req.user!.username })
    .where(eq(usersTable.id, id));
  res.json({ ok: true });
});

// Rôles que l'utilisateur connecté est autorisé à attribuer (pour peupler le formulaire côté client).
router.get('/users/assignable-roles', requirePermission('users.view'), (req, res) => {
  res.json({ roles: assignableRoles(req.user!.role) });
});

export default router;
