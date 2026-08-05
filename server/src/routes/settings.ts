import { Router } from 'express';
import { z } from 'zod';
import { eq } from 'drizzle-orm';
import { db, systemSettingsTable } from '../db.js';
import { requireAuth, requirePermission } from '../middleware/auth.js';
import { logSystemEvent } from '../lib/systemLog.js';

const router = Router();
router.use(requireAuth);

router.get('/settings', requirePermission('settings.manage'), async (_req, res) => {
  let [row] = await db.select().from(systemSettingsTable).where(eq(systemSettingsTable.id, 1)).limit(1);
  if (!row) {
    [row] = await db.insert(systemSettingsTable).values({ id: 1 }).returning();
  }
  res.json({ settings: row });
});

const updateSchema = z.object({
  organizationName: z.string().min(1).optional(),
  supportEmail: z.string().email().nullable().optional(),
  sessionDurationDays: z.number().int().min(1).max(365).optional(),
  maintenanceMode: z.boolean().optional(),
  maintenanceMessage: z.string().nullable().optional(),
  backupScheduleEnabled: z.boolean().optional(),
  backupScheduleFrequency: z.enum(['daily', 'weekly']).optional(),
  backupScheduleHour: z.number().int().min(0).max(23).optional()
});

router.patch('/settings', requirePermission('settings.manage'), async (req, res) => {
  const parsed = updateSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: parsed.error.issues[0]?.message ?? 'Données invalides.' });
  }

  await db
    .insert(systemSettingsTable)
    .values({ id: 1, ...parsed.data, updatedBy: req.user!.username, updatedAt: new Date() })
    .onConflictDoUpdate({
      target: systemSettingsTable.id,
      set: { ...parsed.data, updatedBy: req.user!.username, updatedAt: new Date() }
    });

  await logSystemEvent('info', 'Paramètres système modifiés', { by: req.user!.username, changes: parsed.data });

  const [row] = await db.select().from(systemSettingsTable).where(eq(systemSettingsTable.id, 1)).limit(1);
  res.json({ settings: row });
});

export default router;
