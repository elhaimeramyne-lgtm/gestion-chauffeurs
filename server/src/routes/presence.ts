import { Router } from 'express';
import { and, eq, gte, isNull } from 'drizzle-orm';
import { db, usersTable } from '../db.js';
import { requireAuth } from '../middleware/auth.js';

const router = Router();
router.use(requireAuth);

/** Liste des comptes actifs vus au cours des 90 dernières secondes.
 *  Accessible à tout utilisateur connecté (pas seulement les admins) —
 *  c'est une simple présence, pas une donnée sensible. */
router.get('/presence/online', async (_req, res) => {
  const threshold = new Date(Date.now() - 90_000);
  const rows = await db
    .select({
      id: usersTable.id,
      username: usersTable.username,
      displayName: usersTable.displayName,
      role: usersTable.role,
      lastSeenAt: usersTable.lastSeenAt
    })
    .from(usersTable)
    .where(and(isNull(usersTable.deletedAt), eq(usersTable.isActive, true), gte(usersTable.lastSeenAt, threshold)))
    .orderBy(usersTable.username);

  res.json({ online: rows });
});

export default router;
