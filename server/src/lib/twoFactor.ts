import * as OTPAuth from 'otpauth';

const ISSUER = 'Entraide Nationale — Plateforme IAM';

/** Génère un nouveau secret TOTP (non enregistré tant que l'utilisateur n'a
 *  pas confirmé avec un code valide — voir routes/security.ts). */
export function generateTwoFactorSecret(username: string): { secret: string; otpauthUrl: string } {
  const totp = new OTPAuth.TOTP({
    issuer: ISSUER,
    label: username,
    algorithm: 'SHA1',
    digits: 6,
    period: 30,
    secret: new OTPAuth.Secret({ size: 20 })
  });
  return { secret: totp.secret.base32, otpauthUrl: totp.toString() };
}

/** Vérifie un code à 6 chiffres saisi par l'utilisateur contre son secret.
 *  Tolère un léger décalage d'horloge (une période avant/après). */
export function verifyTwoFactorCode(secret: string, code: string): boolean {
  const totp = new OTPAuth.TOTP({
    issuer: ISSUER,
    algorithm: 'SHA1',
    digits: 6,
    period: 30,
    secret: OTPAuth.Secret.fromBase32(secret)
  });
  const delta = totp.validate({ token: code.trim(), window: 1 });
  return delta !== null;
}
