import { Router } from 'express';
import { desc, eq, and, gte, lte, sql } from 'drizzle-orm';
import { db, auditLogsTable } from '../db.js';
import { requireAuth, requireMinRole } from '../middleware/auth.js';

const router = Router();
router.use(requireAuth, requireMinRole('SUPER_ADMIN'));

router.get('/history', async (req, res) => {
  const page     = Math.max(1, Number(req.query.page  ?? 1));
  const limit    = Math.min(100, Math.max(10, Number(req.query.limit ?? 50)));
  const entity   = req.query.entity as string | undefined;
  const userId   = req.query.userId ? Number(req.query.userId) : undefined;
  const from     = req.query.from ? new Date(req.query.from as string) : undefined;
  const to       = req.query.to   ? new Date(req.query.to   as string) : undefined;

  const conditions = [];
  if (entity)  conditions.push(eq(auditLogsTable.entity, entity));
  if (userId)  conditions.push(eq(auditLogsTable.userId, userId));
  if (from)    conditions.push(gte(auditLogsTable.createdAt, from));
  if (to)      conditions.push(lte(auditLogsTable.createdAt, to));
  const where = conditions.length > 0 ? and(...conditions) : undefined;

  const [{ count }] = await db.select({ count: sql<number>`count(*)::int` })
    .from(auditLogsTable).where(where);

  const logs = await db.select().from(auditLogsTable)
    .where(where).orderBy(desc(auditLogsTable.createdAt))
    .limit(limit).offset((page - 1) * limit);

  res.json({ logs, pagination: { page, limit, total: count, pages: Math.ceil(count / limit) } });
});

export default router;
