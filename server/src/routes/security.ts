import { Router } from 'express';
import { z } from 'zod';
import { desc, eq, isNull } from 'drizzle-orm';
import { db, sessionsTable, usersTable } from '../db.js';
import { requireAuth, requirePermission } from '../middleware/auth.js';
import { generateTwoFactorSecret, verifyTwoFactorCode } from '../lib/twoFactor.js';
import { logSystemEvent } from '../lib/systemLog.js';

const router = Router();
router.use(requireAuth);

// ── Sessions actives (Centre de sécurité — SUPER_ADMIN) ──────────────────
router.get('/security/sessions', requirePermission('settings.manage'), async (_req, res) => {
  const sessions = await db
    .select({
      id: sessionsTable.id,
      userId: sessionsTable.userId,
      username: usersTable.username,
      displayName: usersTable.displayName,
      ipAddress: sessionsTable.ipAddress,
      userAgent: sessionsTable.userAgent,
      createdAt: sessionsTable.createdAt,
      lastSeenAt: sessionsTable.lastSeenAt
    })
    .from(sessionsTable)
    .innerJoin(usersTable, eq(usersTable.id, sessionsTable.userId))
    .where(isNull(sessionsTable.revokedAt))
    .orderBy(desc(sessionsTable.lastSeenAt));

  res.json({ sessions });
});

router.post('/security/sessions/:id/revoke', requirePermission('settings.manage'), async (req, res) => {
  const id = Number(req.params.id);
  const [session] = await db
    .update(sessionsTable)
    .set({ revokedAt: new Date() })
    .where(eq(sessionsTable.id, id))
    .returning();
  if (!session) return res.status(404).json({ error: 'Session introuvable.' });

  await logSystemEvent('warn', 'Session révoquée depuis le Centre de sécurité', {
    sessionId: id,
    userId: session.userId,
    by: req.user!.username
  });
  res.json({ ok: true });
});

// ── Double authentification (personnelle — n'importe quel compte) ────────
router.post('/security/2fa/setup', async (req, res) => {
  const { secret, otpauthUrl } = generateTwoFactorSecret(req.user!.username);
  // Le secret n'est PAS encore enregistré : il ne le sera qu'après
  // confirmation via /security/2fa/enable avec un code valide, pour éviter
  // qu'un utilisateur active une 2FA avec un secret mal scanné.
  res.json({ secret, otpauthUrl });
});

const enable2FASchema = z.object({ secret: z.string().min(10), code: z.string().min(6).max(6) });

router.post('/security/2fa/enable', async (req, res) => {
  const parsed = enable2FASchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: 'Secret et code requis.' });
  }
  const { secret, code } = parsed.data;
  if (!verifyTwoFactorCode(secret, code)) {
    return res.status(400).json({ error: 'Code incorrect. Vérifiez votre application d’authentification.' });
  }

  await db
    .update(usersTable)
    .set({ twoFactorEnabled: true, twoFactorSecret: secret, updatedAt: new Date() })
    .where(eq(usersTable.id, req.user!.userId));

  await logSystemEvent('info', 'Double authentification activée', { userId: req.user!.userId, by: req.user!.username });
  res.json({ ok: true });
});

const disable2FASchema = z.object({ code: z.string().min(6).max(6) });

router.post('/security/2fa/disable', async (req, res) => {
  const parsed = disable2FASchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: 'Code requis.' });
  }

  const [user] = await db.select().from(usersTable).where(eq(usersTable.id, req.user!.userId)).limit(1);
  if (!user?.twoFactorEnabled || !user.twoFactorSecret) {
    return res.status(400).json({ error: '2FA non activée.' });
  }
  if (!verifyTwoFactorCode(user.twoFactorSecret, parsed.data.code)) {
    return res.status(400).json({ error: 'Code incorrect.' });
  }

  await db
    .update(usersTable)
    .set({ twoFactorEnabled: false, twoFactorSecret: null, updatedAt: new Date() })
    .where(eq(usersTable.id, req.user!.userId));

  await logSystemEvent('info', 'Double authentification désactivée', { userId: req.user!.userId, by: req.user!.username });
  res.json({ ok: true });
});

router.get('/security/2fa/status', async (req, res) => {
  const [user] = await db
    .select({ twoFactorEnabled: usersTable.twoFactorEnabled })
    .from(usersTable)
    .where(eq(usersTable.id, req.user!.userId))
    .limit(1);
  res.json({ enabled: user?.twoFactorEnabled ?? false });
});

export default router;
