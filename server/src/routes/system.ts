import { Router } from 'express';
import { mkdir, readdir, stat, unlink } from 'node:fs/promises';
import path from 'node:path';
import { desc } from 'drizzle-orm';
import { db, systemLogsTable } from '../db.js';
import { requireAuth, requirePermission } from '../middleware/auth.js';
import { logSystemEvent } from '../lib/systemLog.js';
import { runBackup, runRestore, BACKUP_DIR } from '../lib/backup.js';

const router = Router();
router.use(requireAuth);

// ── Journal système ────────────────────────────────────────────────────
router.get('/system/logs', requirePermission('settings.manage'), async (req, res) => {
  const limit = Math.min(Number(req.query.limit) || 100, 300);
  const rows = await db.select().from(systemLogsTable).orderBy(desc(systemLogsTable.createdAt)).limit(limit);
  res.json({ logs: rows });
});

async function ensureBackupDir() {
  await mkdir(BACKUP_DIR, { recursive: true });
}

router.get('/system/backups', requirePermission('settings.manage'), async (_req, res) => {
  await ensureBackupDir();
  const files = await readdir(BACKUP_DIR);
  const backups = await Promise.all(
    files
      .filter((f) => f.endsWith('.sql'))
      .map(async (f) => {
        const s = await stat(path.join(BACKUP_DIR, f));
        return { filename: f, sizeBytes: s.size, createdAt: s.birthtime };
      })
  );
  backups.sort((a, b) => b.createdAt.getTime() - a.createdAt.getTime());
  res.json({ backups });
});

router.post('/system/backup', requirePermission('settings.manage'), async (req, res) => {
  const result = await runBackup(req.user!.username);
  if (!result.ok) {
    return res.status(500).json({ error: result.error });
  }
  res.status(201).json({ filename: result.filename });
});

router.get('/system/backups/:filename/download', requirePermission('settings.manage'), async (req, res) => {
  const { filename } = req.params;
  if (!/^[\w.-]+\.sql$/.test(filename)) {
    return res.status(400).json({ error: 'Nom de fichier invalide.' });
  }
  const filepath = path.join(BACKUP_DIR, filename);
  res.download(filepath, filename, (err) => {
    if (err && !res.headersSent) {
      res.status(404).json({ error: 'Sauvegarde introuvable.' });
    }
  });
});

// ── Restauration en un clic ──────────────────────────────────────────────
// Opération destructive : une sauvegarde de sécurité de l'état actuel est
// systématiquement créée juste avant, pour permettre de revenir en arrière
// en cas de restauration malencontreuse.
router.post('/system/backups/:filename/restore', requirePermission('settings.manage'), async (req, res) => {
  const { filename } = req.params;
  if (!/^[\w.-]+\.sql$/.test(filename)) {
    return res.status(400).json({ error: 'Nom de fichier invalide.' });
  }

  await logSystemEvent('warn', 'Restauration de sauvegarde lancée', { filename, by: req.user!.username });

  const safety = await runBackup(req.user!.username, 'avant-restauration');
  if (!safety.ok) {
    return res.status(500).json({
      error: `Restauration annulée : impossible de créer la sauvegarde de sécurité préalable (${safety.error}).`
    });
  }

  const result = await runRestore(filename, req.user!.username);
  if (!result.ok) {
    return res.status(500).json({
      error: `${result.error} Une sauvegarde de sécurité ("${safety.filename}") a été créée avant la tentative — vos données d'avant restauration sont préservées.`
    });
  }

  res.json({ ok: true, safetyBackup: safety.filename });
});

router.delete('/system/backups/:filename', requirePermission('settings.manage'), async (req, res) => {
  const { filename } = req.params;
  if (!/^[\w.-]+\.sql$/.test(filename)) {
    return res.status(400).json({ error: 'Nom de fichier invalide.' });
  }
  try {
    await unlink(path.join(BACKUP_DIR, filename));
    await logSystemEvent('info', 'Sauvegarde supprimée', { filename, by: req.user!.username });
    res.json({ ok: true });
  } catch {
    res.status(404).json({ error: 'Sauvegarde introuvable.' });
  }
});

export default router;
