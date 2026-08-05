import { Router } from 'express';
import { z } from 'zod';
import { and, eq, isNull } from 'drizzle-orm';
import { db, usersTable, sessionsTable } from '../db.js';
import {
  verifyPassword, signToken, COOKIE_NAME,
  signPending2FA, verifyPending2FA, PENDING_2FA_COOKIE_NAME
} from '../lib/auth.js';
import { verifyTwoFactorCode } from '../lib/twoFactor.js';
import { getBruteForceLockoutMinutes } from '../lib/bruteForce.js';
import { requireAuth } from '../middleware/auth.js';
import { logConnection } from '../middleware/audit.js';

const router = Router();

const loginSchema = z.object({
  username: z.string().min(1),
  password: z.string().min(1)
});

// Le cookie "Secure" n'est envoyé par le navigateur que sur une connexion
// HTTPS. Cette plateforme tourne en HTTP simple sur le réseau interne, donc
// ce flag doit rester désactivé par défaut — sinon le navigateur refuse
// silencieusement de conserver le cookie de session, et toutes les requêtes
// suivantes échouent avec "Non authentifié" malgré une connexion réussie.
// Si un jour le serveur est servi en HTTPS, définissez COOKIE_SECURE=true
// dans le .env.
const cookieSecure = process.env.COOKIE_SECURE === 'true';

function clientIp(req: import('express').Request): string | undefined {
  const forwarded = req.headers['x-forwarded-for'];
  if (typeof forwarded === 'string' && forwarded.length > 0) return forwarded.split(',')[0].trim();
  return req.socket?.remoteAddress ?? undefined;
}

async function issueSession(req: import('express').Request, res: import('express').Response, user: typeof usersTable.$inferSelect) {
  const { token, jti } = signToken({ userId: user.id, username: user.username, role: user.role });
  await db.insert(sessionsTable).values({
    jti,
    userId: user.id,
    ipAddress: clientIp(req) ?? null,
    userAgent: req.headers['user-agent'] ?? null
  });

  res.cookie(COOKIE_NAME, token, {
    httpOnly: true,
    sameSite: 'lax',
    secure: cookieSecure,
    maxAge: 30 * 24 * 60 * 60 * 1000
  });

  await db.update(usersTable).set({ lastLoginAt: new Date() }).where(eq(usersTable.id, user.id));
}

router.post('/auth/login', async (req, res) => {
  const parsed = loginSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: "Nom d'utilisateur et mot de passe requis." });
  }
  const { username, password } = parsed.data;

  // ── Anti-brute-force : réutilise le journal des connexions déjà tenu ────
  const lockoutMinutes = await getBruteForceLockoutMinutes(username);
  if (lockoutMinutes > 0) {
    return res.status(429).json({
      error: `Trop de tentatives échouées. Réessayez dans ${lockoutMinutes} minute(s).`
    });
  }

  const [user] = await db
    .select()
    .from(usersTable)
    .where(and(eq(usersTable.username, username), isNull(usersTable.deletedAt)))
    .limit(1);
  if (!user) {
    await logConnection(req, { userId: null, username, success: false, reason: 'unknown_username' });
    return res.status(401).json({ error: 'Identifiants incorrects.' });
  }

  const ok = await verifyPassword(password, user.passwordHash);
  if (!ok) {
    await logConnection(req, { userId: user.id, username, success: false, reason: 'bad_password' });
    return res.status(401).json({ error: 'Identifiants incorrects.' });
  }

  if (!user.isActive) {
    await logConnection(req, { userId: user.id, username, success: false, reason: 'account_disabled' });
    return res.status(403).json({ error: 'Ce compte a été désactivé. Contactez un administrateur.' });
  }

  // ── Double authentification activée : étape intermédiaire ───────────────
  if (user.twoFactorEnabled) {
    const pendingToken = signPending2FA(user.id);
    res.cookie(PENDING_2FA_COOKIE_NAME, pendingToken, {
      httpOnly: true,
      sameSite: 'lax',
      secure: cookieSecure,
      maxAge: 5 * 60 * 1000
    });
    return res.json({ requires2FA: true });
  }

  await issueSession(req, res, user);
  await logConnection(req, { userId: user.id, username, success: true });

  const { passwordHash: _passwordHash, twoFactorSecret: _tfs, ...publicUser } = user;
  res.json({ user: publicUser });
});

const verify2FASchema = z.object({ code: z.string().min(6).max(6) });

router.post('/auth/login-2fa', async (req, res) => {
  const pendingToken = req.cookies?.[PENDING_2FA_COOKIE_NAME];
  const pending = pendingToken ? verifyPending2FA(pendingToken) : null;
  if (!pending) {
    return res.status(401).json({ error: 'Session de connexion expirée. Reconnectez-vous.' });
  }

  const parsed = verify2FASchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: 'Code à 6 chiffres requis.' });
  }

  const [user] = await db.select().from(usersTable).where(eq(usersTable.id, pending.userId)).limit(1);
  if (!user || !user.twoFactorEnabled || !user.twoFactorSecret) {
    return res.status(400).json({ error: '2FA non configurée pour ce compte.' });
  }

  const ok = verifyTwoFactorCode(user.twoFactorSecret, parsed.data.code);
  if (!ok) {
    await logConnection(req, { userId: user.id, username: user.username, success: false, reason: 'bad_2fa_code' });
    return res.status(401).json({ error: 'Code incorrect.' });
  }

  res.clearCookie(PENDING_2FA_COOKIE_NAME);
  await issueSession(req, res, user);
  await logConnection(req, { userId: user.id, username: user.username, success: true });

  const { passwordHash: _passwordHash, twoFactorSecret: _tfs, ...publicUser } = user;
  res.json({ user: publicUser });
});

router.post('/auth/logout', async (req, res) => {
  const token = req.cookies?.[COOKIE_NAME];
  if (token) {
    const { verifyToken } = await import('../lib/auth.js');
    const payload = verifyToken(token);
    if (payload) {
      await db.update(sessionsTable).set({ revokedAt: new Date() }).where(eq(sessionsTable.jti, payload.jti));
    }
  }
  res.clearCookie(COOKIE_NAME);
  res.json({ ok: true });
});

router.get('/auth/me', requireAuth, async (req, res) => {
  const [user] = await db.select().from(usersTable).where(eq(usersTable.id, req.user!.userId)).limit(1);
  if (!user) return res.status(401).json({ error: 'Utilisateur introuvable.' });
  const { passwordHash: _passwordHash, twoFactorSecret: _tfs, ...publicUser } = user;
  res.json({ user: publicUser });
});

export default router;
