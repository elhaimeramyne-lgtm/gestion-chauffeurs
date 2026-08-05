import { and, eq, gte, sql } from 'drizzle-orm';
import { db, connectionLogsTable } from '../db.js';

const WINDOW_MINUTES = 15;
const MAX_ATTEMPTS = 5;

/** Compte les tentatives échouées récentes pour un nom d'utilisateur (déjà
 *  journalisées dans connection_logs — aucune table dédiée nécessaire).
 *  Retourne le nombre de minutes restantes avant déblocage, ou 0 si le
 *  compte n'est pas bloqué. */
export async function getBruteForceLockoutMinutes(username: string): Promise<number> {
  const since = new Date();
  since.setMinutes(since.getMinutes() - WINDOW_MINUTES);

  const [{ value: failedCount }] = await db
    .select({ value: sql<number>`count(*)` })
    .from(connectionLogsTable)
    .where(
      and(
        eq(connectionLogsTable.username, username),
        eq(connectionLogsTable.success, false),
        gte(connectionLogsTable.createdAt, since)
      )
    );

  if (Number(failedCount) < MAX_ATTEMPTS) return 0;

  const [mostRecentFailure] = await db
    .select({ createdAt: connectionLogsTable.createdAt })
    .from(connectionLogsTable)
    .where(and(eq(connectionLogsTable.username, username), eq(connectionLogsTable.success, false)))
    .orderBy(sql`${connectionLogsTable.createdAt} DESC`)
    .limit(1);

  if (!mostRecentFailure) return 0;
  const unlockAt = new Date(mostRecentFailure.createdAt.getTime() + WINDOW_MINUTES * 60_000);
  const remainingMs = unlockAt.getTime() - Date.now();
  return remainingMs > 0 ? Math.ceil(remainingMs / 60_000) : 0;
}
