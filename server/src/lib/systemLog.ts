import { db, systemLogsTable } from '../db.js';

export async function logSystemEvent(
  level: 'info' | 'warn' | 'error',
  message: string,
  meta?: Record<string, unknown>
): Promise<void> {
  // eslint-disable-next-line no-console
  console[level === 'error' ? 'error' : level === 'warn' ? 'warn' : 'log'](`[system] ${message}`, meta ?? '');
  try {
    await db.insert(systemLogsTable).values({ level, message, meta: meta ?? null });
  } catch {
    // La table peut ne pas encore exister au tout premier démarrage (avant
    // runMigrations) : on ignore silencieusement, la console suffit alors.
  }
}
