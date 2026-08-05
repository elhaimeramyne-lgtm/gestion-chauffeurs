import { db, auditLogsTable } from '../db.js';

export interface LogActionParams {
  userId: number;
  username: string;
  userRole: string;
  action: string;
  category: 'auth' | 'users' | 'lignes' | 'facturation' | 'system';
  description: string;
  targetId?: string;
  targetName?: string;
  ipAddress?: string;
}

export async function logAction(params: LogActionParams): Promise<void> {
  try {
    // Logué dans audit_logs (table d'audit unifiée) avec les champs dont
    // nous disposons — l'auditLogger middleware s'occupe des logs HTTP.
    await db.insert(auditLogsTable).values({
      userId: params.userId,
      username: params.username,
      role: params.userRole,
      action: params.action,
      entity: params.category,
      entityId: params.targetId ?? null,
      method: 'INTERNAL',
      path: `activity/${params.category}`,
      statusCode: 200,
      details: { description: params.description, targetName: params.targetName },
      ipAddress: params.ipAddress ?? null,
    });
  } catch (err) {
    console.error('[activityLog]', err);
  }
}
