/**
 * Authentification — hachage des mots de passe (bcrypt), émission/vérification
 * des jetons JWT de session, et jetons temporaires "2FA en attente".
 *
 * Le jeton de session est stocké dans un cookie httpOnly (voir COOKIE_NAME) ;
 * son identifiant unique (`jti`) est aussi persisté dans `sessionsTable`
 * pour permettre la révocation d'une session précise (middleware/auth.ts).
 */
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import crypto from 'node:crypto';
import type { Role } from './permissions.js';

export const COOKIE_NAME = 'iam_session';
export const PENDING_2FA_COOKIE_NAME = 'iam_pending_2fa';

const JWT_SECRET = process.env.SESSION_SECRET ?? 'changez_cette_valeur_par_une_chaine_longue_et_aleatoire';
const JWT_EXPIRES_IN = '30d';
const PENDING_2FA_EXPIRES_IN = '5m';

export interface JwtPayload {
  userId: number;
  username: string;
  role: Role;
  jti: string;
}

interface PendingTwoFactorPayload {
  userId: number;
  pending2fa: true;
}

/* ── Mots de passe ─────────────────────────────────────────────────── */

export async function hashPassword(plain: string): Promise<string> {
  return bcrypt.hash(plain, 10);
}

export async function verifyPassword(plain: string, hash: string): Promise<boolean> {
  try {
    return await bcrypt.compare(plain, hash);
  } catch {
    return false;
  }
}

/* ── Jeton de session (JWT) ───────────────────────────────────────── */

export function signToken(payload: Omit<JwtPayload, 'jti'>): { token: string; jti: string } {
  const jti = crypto.randomUUID();
  const token = jwt.sign({ ...payload, jti }, JWT_SECRET, { expiresIn: JWT_EXPIRES_IN });
  return { token, jti };
}

export function verifyToken(token: string): JwtPayload | null {
  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    if (typeof decoded === 'string') return null;
    const { userId, username, role, jti } = decoded as Partial<JwtPayload>;
    if (!userId || !username || !role || !jti) return null;
    return { userId, username, role, jti };
  } catch {
    return null;
  }
}

/* ── Jeton temporaire "2FA en attente" ────────────────────────────── */

export function signPending2FA(userId: number): string {
  return jwt.sign({ userId, pending2fa: true }, JWT_SECRET, { expiresIn: PENDING_2FA_EXPIRES_IN });
}

export function verifyPending2FA(token: string): { userId: number } | null {
  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    if (typeof decoded === 'string') return null;
    const { userId, pending2fa } = decoded as Partial<PendingTwoFactorPayload>;
    if (!userId || !pending2fa) return null;
    return { userId };
  } catch {
    return null;
  }
}
