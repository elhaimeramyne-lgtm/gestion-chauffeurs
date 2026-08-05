import type { Request, Response, NextFunction } from 'express';
import { db, auditLogsTable, connectionLogsTable } from '../db.js';

function clientIp(req: Request): string | undefined {
  const forwarded = req.headers['x-forwarded-for'];
  if (typeof forwarded === 'string' && forwarded.length > 0) return forwarded.split(',')[0].trim();
  return req.socket?.remoteAddress ?? undefined;
}

function actionFromMethod(method: string): string {
  switch (method) {
    case 'POST':
      return 'create';
    case 'PATCH':
    case 'PUT':
      return 'update';
    case 'DELETE':
      return 'delete';
    default:
      return method.toLowerCase();
  }
}

/** Déduit le nom de l'entité depuis le chemin de la route, ex.
 *  /api/lignes/12 -> "lignes", /api/sheet-rules -> "sheet-rules". */
function entityFromPath(path: string): { entity: string; entityId?: string } {
  const parts = path.replace(/^\/api\/?/, '').split('/').filter(Boolean);
  const entity = parts[0] ?? 'unknown';
  const maybeId = parts[1];
  const entityId = maybeId && /^[0-9]+$/.test(maybeId) ? maybeId : undefined;
  return { entity, entityId };
}

/** Middleware global : journalise automatiquement toute requête de
 *  modification (POST/PUT/PATCH/DELETE) réussie ou non, une fois la
 *  réponse envoyée. Ne bloque jamais la requête : les erreurs d'écriture
 *  du journal sont avalées et journalisées côté console uniquement. */
export function auditLogger(req: Request, res: Response, next: NextFunction) {
  const shouldLog = ['POST', 'PUT', 'PATCH', 'DELETE'].includes(req.method);
  if (!shouldLog) return next();

  // Ignore les routes d'authentification : gérées séparément par le
  // journal des connexions (logConnection), plus adapté.
  if (req.path.startsWith('/api/auth/')) return next();

  res.on('finish', () => {
    const { entity, entityId } = entityFromPath(req.path);
    db.insert(auditLogsTable)
      .values({
        userId: req.user?.userId ?? null,
        username: req.user?.username ?? null,
        role: req.user?.role ?? null,
        action: actionFromMethod(req.method),
        entity,
        entityId: entityId ?? null,
        method: req.method,
        path: req.path,
        statusCode: res.statusCode,
        details: null,
        ipAddress: clientIp(req) ?? null,
        userAgent: req.headers['user-agent'] ?? null
      })
      .catch((err: unknown) => {
        // eslint-disable-next-line no-console
        console.error('[audit] échec de journalisation :', err);
      });
  });

  next();
}

/** À appeler explicitement depuis la route de connexion pour journaliser
 *  chaque tentative, réussie ou non (identifiants invalides, compte
 *  désactivé...). */
export async function logConnection(
  req: Request,
  params: { userId: number | null; username: string; success: boolean; reason?: string }
): Promise<void> {
  try {
    await db.insert(connectionLogsTable).values({
      userId: params.userId,
      username: params.username,
      success: params.success,
      reason: params.reason ?? null,
      ipAddress: clientIp(req) ?? null,
      userAgent: req.headers['user-agent'] ?? null
    });
  } catch (err) {
    // eslint-disable-next-line no-console
    console.error('[audit] échec de journalisation de connexion :', err);
  }
}
