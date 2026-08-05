/**
 * Routes d'audit enrichies :
 *  GET /audit-logs/summary  — statistiques rapides pour le dashboard
 *  GET /audit-logs/export   — export CSV complet (sans limite)
 *  GET /audit-logs/users    — liste des utilisateurs distincts dans les logs (filtre UI)
 *  GET /connection-logs/stats — statistiques des connexions
 */
import { Router } from 'express';
import { desc, and, eq, gte, lte, count, sql } from 'drizzle-orm';
import { db, auditLogsTable, connectionLogsTable } from '../db.js';
import { requireAuth, requirePermission } from '../middleware/auth.js';

const router = Router();
router.use(requireAuth);

/* ── Résumé audit (graphiques dashboard journal) ─────────────────── */
router.get('/audit-logs/summary', requirePermission('audit.view'), async (_req, res) => {
  // Actions par type sur les 30 derniers jours
  const thirtyDaysAgo = new Date();
  thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

  const byAction = await db
    .select({ action: auditLogsTable.action, value: count() })
    .from(auditLogsTable)
    .where(gte(auditLogsTable.createdAt, thirtyDaysAgo))
    .groupBy(auditLogsTable.action)
    .orderBy(count());

  // Top entités modifiées
  const topEntities = await db
    .select({ entity: auditLogsTable.entity, value: count() })
    .from(auditLogsTable)
    .where(gte(auditLogsTable.createdAt, thirtyDaysAgo))
    .groupBy(auditLogsTable.entity)
    .orderBy(desc(count()))
    .limit(8);

  // Activité horaire (heatmap 0-23h)
  const byHour = await db.execute<{ hour: string; value: string }>(sql`
    SELECT EXTRACT(HOUR FROM created_at)::int AS hour, COUNT(*) AS value
    FROM iam.audit_logs
    WHERE created_at >= NOW() - interval '30 days'
    GROUP BY 1 ORDER BY 1
  `);

  // Top utilisateurs actifs
  const topUsers = await db
    .select({ username: auditLogsTable.username, value: count() })
    .from(auditLogsTable)
    .where(and(gte(auditLogsTable.createdAt, thirtyDaysAgo), sql`${auditLogsTable.username} IS NOT NULL`))
    .groupBy(auditLogsTable.username)
    .orderBy(desc(count()))
    .limit(10);

  // Taux d'erreurs (status >= 400)
  const [{ value: totalActions }] = await db
    .select({ value: count() })
    .from(auditLogsTable)
    .where(gte(auditLogsTable.createdAt, thirtyDaysAgo));

  const [{ value: errorActions }] = await db
    .select({ value: count() })
    .from(auditLogsTable)
    .where(and(gte(auditLogsTable.createdAt, thirtyDaysAgo), sql`${auditLogsTable.statusCode} >= 400`));

  res.json({
    byAction: byAction.map((r) => ({ action: r.action, value: Number(r.value) })),
    topEntities: topEntities.map((r) => ({ entity: r.entity, value: Number(r.value) })),
    byHour: byHour.rows.map((r) => ({ hour: Number(r.hour), value: Number(r.value) })),
    topUsers: topUsers.map((r) => ({ username: r.username ?? 'Système', value: Number(r.value) })),
    errorRate: Number(totalActions) > 0 ? (Number(errorActions) / Number(totalActions)) * 100 : 0,
    totalActions: Number(totalActions),
  });
});

/* ── Liste des utilisateurs distincts présents dans les logs ──────── */
router.get('/audit-logs/users', requirePermission('audit.view'), async (_req, res) => {
  const users = await db
    .selectDistinct({ username: auditLogsTable.username, userId: auditLogsTable.userId })
    .from(auditLogsTable)
    .where(sql`${auditLogsTable.username} IS NOT NULL`)
    .orderBy(auditLogsTable.username)
    .limit(100);

  res.json({ users: users.map((u) => ({ username: u.username!, userId: u.userId })) });
});

/* ── Export CSV ───────────────────────────────────────────────────── */
router.get('/audit-logs/export', requirePermission('audit.view'), async (req, res) => {
  const entity = typeof req.query.entity === 'string' ? req.query.entity : '';
  const userId = req.query.userId ? Number(req.query.userId) : undefined;
  const from = typeof req.query.from === 'string' ? new Date(req.query.from) : undefined;
  const to = typeof req.query.to === 'string' ? new Date(req.query.to) : undefined;
  const action = typeof req.query.action === 'string' ? req.query.action : '';

  const conditions = [];
  if (entity) conditions.push(eq(auditLogsTable.entity, entity));
  if (userId) conditions.push(eq(auditLogsTable.userId, userId));
  if (action) conditions.push(eq(auditLogsTable.action, action));
  if (from && !Number.isNaN(from.getTime())) conditions.push(gte(auditLogsTable.createdAt, from));
  if (to && !Number.isNaN(to.getTime())) conditions.push(lte(auditLogsTable.createdAt, to));

  const rows = await db
    .select()
    .from(auditLogsTable)
    .where(conditions.length > 0 ? and(...conditions) : undefined)
    .orderBy(desc(auditLogsTable.createdAt))
    .limit(5000);

  const ACTION_LABELS: Record<string, string> = {
    create: 'Création',
    update: 'Modification',
    delete: 'Suppression',
  };

  const csvHeader = 'Date;Utilisateur;Rôle;Action;Ressource;ID Ressource;Méthode HTTP;Chemin;Code HTTP;Adresse IP\n';
  const csvRows = rows
    .map((r) =>
      [
        new Date(r.createdAt).toLocaleString('fr-FR'),
        r.username ?? 'Système',
        r.role ?? '',
        ACTION_LABELS[r.action] ?? r.action,
        r.entity,
        r.entityId ?? '',
        r.method,
        r.path,
        r.statusCode,
        r.ipAddress ?? '',
      ]
        .map((v) => `"${String(v).replace(/"/g, '""')}"`)
        .join(';')
    )
    .join('\n');

  const csv = '\uFEFF' + csvHeader + csvRows; // BOM UTF-8 pour Excel

  res.setHeader('Content-Type', 'text/csv; charset=utf-8');
  res.setHeader(
    'Content-Disposition',
    `attachment; filename="journal-audit-${new Date().toISOString().slice(0, 10)}.csv"`
  );
  res.send(csv);
});

/* ── Statistiques connexions ─────────────────────────────────────── */
router.get('/connection-logs/stats', requirePermission('audit.view'), async (_req, res) => {
  const thirtyDaysAgo = new Date();
  thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

  const [{ successCount, failCount }] = await db.execute<{
    successCount: string;
    failCount: string;
  }>(sql`
    SELECT
      COUNT(*) FILTER (WHERE success = true) AS "successCount",
      COUNT(*) FILTER (WHERE success = false) AS "failCount"
    FROM iam.connection_logs
    WHERE created_at >= NOW() - interval '30 days'
  `).then((r) => r.rows);

  const byDay = await db.execute<{ day: string; success: string; fail: string }>(sql`
    SELECT
      to_char(date_trunc('day', created_at), 'YYYY-MM-DD') AS day,
      COUNT(*) FILTER (WHERE success = true) AS success,
      COUNT(*) FILTER (WHERE success = false) AS fail
    FROM iam.connection_logs
    WHERE created_at >= NOW() - interval '14 days'
    GROUP BY 1 ORDER BY 1
  `);

  const topFailReasons = await db
    .select({ reason: connectionLogsTable.reason, value: count() })
    .from(connectionLogsTable)
    .where(and(gte(connectionLogsTable.createdAt, thirtyDaysAgo), eq(connectionLogsTable.success, false)))
    .groupBy(connectionLogsTable.reason)
    .orderBy(desc(count()))
    .limit(5);

  res.json({
    successCount: Number(successCount ?? 0),
    failCount: Number(failCount ?? 0),
    byDay: byDay.rows.map((r) => ({ day: r.day, success: Number(r.success), fail: Number(r.fail) })),
    topFailReasons: topFailReasons.map((r) => ({ reason: r.reason ?? 'unknown', value: Number(r.value) })),
  });
});

export default router;
