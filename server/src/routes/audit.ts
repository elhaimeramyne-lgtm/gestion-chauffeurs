import { Router } from 'express';
import { desc, and, eq, gte, lte } from 'drizzle-orm';
import { db, auditLogsTable, connectionLogsTable } from '../db.js';
import { requireAuth, requirePermission } from '../middleware/auth.js';

const router = Router();

router.use(requireAuth);

/** Historique automatique de toutes les actions. Filtrable par entité,
 *  utilisateur et plage de dates. Paginé (limit/offset). */
router.get('/audit-logs', requirePermission('audit.view'), async (req, res) => {
  const limit = Math.min(Number(req.query.limit) || 50, 200);
  const offset = Number(req.query.offset) || 0;
  const entity = typeof req.query.entity === 'string' ? req.query.entity : '';
  const entityId = typeof req.query.entityId === 'string' ? req.query.entityId : '';
  const userId = req.query.userId ? Number(req.query.userId) : undefined;
  const from = typeof req.query.from === 'string' ? new Date(req.query.from) : undefined;
  const to = typeof req.query.to === 'string' ? new Date(req.query.to) : undefined;

  const conditions = [];
  if (entity) conditions.push(eq(auditLogsTable.entity, entity));
  if (entityId) conditions.push(eq(auditLogsTable.entityId, entityId));
  if (userId) conditions.push(eq(auditLogsTable.userId, userId));
  if (from && !Number.isNaN(from.getTime())) conditions.push(gte(auditLogsTable.createdAt, from));
  if (to && !Number.isNaN(to.getTime())) conditions.push(lte(auditLogsTable.createdAt, to));

  const rows = await db
    .select()
    .from(auditLogsTable)
    .where(conditions.length > 0 ? and(...conditions) : undefined)
    .orderBy(desc(auditLogsTable.createdAt))
    .limit(limit)
    .offset(offset);

  res.json({ logs: rows });
});

/** Journal des connexions : tentatives réussies et échouées. */
router.get('/connection-logs', requirePermission('audit.view'), async (req, res) => {
  const limit = Math.min(Number(req.query.limit) || 50, 200);
  const offset = Number(req.query.offset) || 0;

  const rows = await db
    .select()
    .from(connectionLogsTable)
    .orderBy(desc(connectionLogsTable.createdAt))
    .limit(limit)
    .offset(offset);

  res.json({ logs: rows });
});

export default router;
