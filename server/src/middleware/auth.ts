import type { Request, Response, NextFunction } from 'express';
import { and, eq, isNull } from 'drizzle-orm';
import { COOKIE_NAME, verifyToken, type JwtPayload } from '../lib/auth.js';
import { db, usersTable, sessionsTable } from '../db.js';
import { hasPermission, isAtLeast, type Permission, type Role } from '../lib/permissions.js';

declare global {
  // eslint-disable-next-line @typescript-eslint/no-namespace
  namespace Express {
    interface Request {
      user?: JwtPayload;
    }
  }
}

// Throttle en mémoire : évite d'écrire en base à chaque requête. Suffisant
// pour un déploiement mono-instance (cas de cette plateforme interne).
const lastSeenWrites = new Map<number, number>();
const sessionSeenWrites = new Map<string, number>();
const PRESENCE_THROTTLE_MS = 20_000;

/** Exige d'être connecté (cookie de session valide, session non révoquée)
 *  ET que le compte soit toujours actif et non supprimé. Un compte
 *  désactivé, une session révoquée depuis le Centre de sécurité, ou un
 *  compte envoyé à la corbeille sont tous bloqués dès la requête suivante. */
export async function requireAuth(req: Request, res: Response, next: NextFunction) {
  const token = req.cookies?.[COOKIE_NAME];
  const payload = token ? verifyToken(token) : null;
  if (!payload) {
    return res.status(401).json({ error: 'Non authentifié. Veuillez vous connecter.' });
  }

  // Jeton émis avant l'introduction du suivi de session (pas de jti) :
  // on force une reconnexion propre plutôt que de laisser une session
  // invisible du Centre de sécurité et impossible à révoquer.
  if (!payload.jti) {
    return res.status(401).json({ error: 'Session expirée, merci de vous reconnecter.' });
  }

  const [session] = await db
    .select({ revokedAt: sessionsTable.revokedAt })
    .from(sessionsTable)
    .where(eq(sessionsTable.jti, payload.jti))
    .limit(1);
  if (!session || session.revokedAt) {
    return res.status(401).json({ error: 'Cette session a été révoquée. Merci de vous reconnecter.' });
  }

  const [account] = await db
    .select({ isActive: usersTable.isActive })
    .from(usersTable)
    .where(and(eq(usersTable.id, payload.userId), isNull(usersTable.deletedAt)))
    .limit(1);

  if (!account) {
    return res.status(401).json({ error: 'Compte introuvable.' });
  }
  if (!account.isActive) {
    return res.status(403).json({ error: 'Ce compte a été désactivé. Contactez un administrateur.' });
  }

  req.user = payload;

  // Présence : ne met à jour "lastSeenAt" qu'une fois toutes les ~20s par
  // utilisateur/session, en tâche de fond (n'attend pas, ne bloque jamais).
  const now = Date.now();
  const last = lastSeenWrites.get(payload.userId) ?? 0;
  if (now - last > PRESENCE_THROTTLE_MS) {
    lastSeenWrites.set(payload.userId, now);
    db.update(usersTable)
      .set({ lastSeenAt: new Date() })
      .where(eq(usersTable.id, payload.userId))
      .catch(() => {});
  }
  const lastSession = sessionSeenWrites.get(payload.jti) ?? 0;
  if (now - lastSession > PRESENCE_THROTTLE_MS) {
    sessionSeenWrites.set(payload.jti, now);
    db.update(sessionsTable)
      .set({ lastSeenAt: new Date() })
      .where(eq(sessionsTable.jti, payload.jti))
      .catch(() => {});
  }

  next();
}

/** Exige un rôle minimum dans la hiérarchie SUPER_ADMIN > ADMIN > USER.
 *  À utiliser après requireAuth. */
export function requireMinRole(minimum: Role) {
  return (req: Request, res: Response, next: NextFunction) => {
    if (!req.user) {
      return res.status(401).json({ error: 'Non authentifié.' });
    }
    if (isAtLeast(req.user.role, minimum)) {
      return next();
    }
    return res.status(403).json({ error: "Vous n'avez pas les droits pour effectuer cette action." });
  };
}

/** Exige une des permissions listées, en plus d'être connecté. La matrice
 *  de permissions est centralisée dans lib/permissions.ts. */
export function requirePermission(...permissions: Permission[]) {
  return (req: Request, res: Response, next: NextFunction) => {
    if (!req.user) {
      return res.status(401).json({ error: 'Non authentifié.' });
    }
    if (permissions.some((p) => hasPermission(req.user!.role, p))) {
      return next();
    }
    return res.status(403).json({ error: "Vous n'avez pas les droits pour effectuer cette action." });
  };
}

/** Rétro-compatibilité : ancienne API basée sur des noms de rôles bruts.
 *  Les rôles historiques 'admin'/'editor'/'viewer' sont mappés vers le
 *  nouveau schéma SUPER_ADMIN/ADMIN/USER. Préférer requireMinRole ou
 *  requirePermission dans le nouveau code. */
export function requireRole(...roles: Array<'admin' | 'editor' | 'viewer'>) {
  const mapped = roles.map((r) => (r === 'admin' ? 'ADMIN' : 'USER') as Role);
  const minimum = mapped.includes('ADMIN') ? 'ADMIN' : 'USER';
  return requireMinRole(minimum as Role);
}
