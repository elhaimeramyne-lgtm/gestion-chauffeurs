import { Router } from 'express';
import { and, eq, isNotNull } from 'drizzle-orm';
import { db, lignesTable, customFieldsTable, correctionRulesTable, usersTable, facturesTable, lignesFixesTable, journalEntriesTable } from '../db.js';
import { requireAuth, requirePermission } from '../middleware/auth.js';
import { logSystemEvent } from '../lib/systemLog.js';

const router = Router();
router.use(requireAuth);

type EntityKey = 'lignes' | 'lignes-fixes' | 'custom-fields' | 'correction-rules' | 'users' | 'factures' | 'journal-entries';

const ENTITIES: Record<
  EntityKey,
  { table: any; label: (row: any) => string }
> = {
  lignes: { table: lignesTable, label: (r) => r.personne || r.icc || `Ligne #${r.id}` },
  'lignes-fixes': { table: lignesFixesTable, label: (r) => r.nd || `Ligne fixe #${r.id}` },
  'custom-fields': { table: customFieldsTable, label: (r) => r.label },
  'correction-rules': { table: correctionRulesTable, label: (r) => `${r.sourceSheetName} → ${r.targetSheetName}` },
  users: { table: usersTable, label: (r) => r.displayName || r.username },
  factures: { table: facturesTable, label: (r) => `${r.custcode} · ${r.refFacture}` },
  'journal-entries': { table: journalEntriesTable, label: (r) => r.service }
};

router.get('/trash', requirePermission('trash.manage'), async (_req, res) => {
  const items: Array<{ entity: EntityKey; id: number; label: string; deletedAt: string; deletedBy: string | null }> = [];

  for (const [entity, config] of Object.entries(ENTITIES) as [EntityKey, (typeof ENTITIES)[EntityKey]][]) {
    const rows = await db
      .select()
      .from(config.table as any)
      .where(isNotNull((config.table as any).deletedAt));
    for (const row of rows as any[]) {
      // Ne jamais exposer le hash de mot de passe dans la corbeille.
      const { passwordHash: _ph, twoFactorSecret: _tfs, ...safe } = row;
      items.push({
        entity,
        id: safe.id,
        label: config.label(safe),
        deletedAt: safe.deletedAt,
        deletedBy: safe.deletedBy ?? null
      });
    }
  }

  items.sort((a, b) => new Date(b.deletedAt).getTime() - new Date(a.deletedAt).getTime());
  res.json({ items });
});

router.post('/trash/:entity/:id/restore', requirePermission('trash.manage'), async (req, res) => {
  const entity = req.params.entity as EntityKey;
  const id = Number(req.params.id);
  const config = ENTITIES[entity];
  if (!config) return res.status(404).json({ error: 'Type de ressource inconnu.' });

  const [row] = await db
    .update(config.table as any)
    .set({ deletedAt: null, deletedBy: null })
    .where(eq((config.table as any).id, id))
    .returning();
  if (!row) return res.status(404).json({ error: 'Élément introuvable dans la corbeille.' });

  await logSystemEvent('info', 'Élément restauré depuis la corbeille', { entity, id, by: req.user!.username });
  res.json({ ok: true });
});

router.delete('/trash/:entity/:id', requirePermission('trash.manage'), async (req, res) => {
  const entity = req.params.entity as EntityKey;
  const id = Number(req.params.id);
  const config = ENTITIES[entity];
  if (!config) return res.status(404).json({ error: 'Type de ressource inconnu.' });

  await db
    .delete(config.table as any)
    .where(and(eq((config.table as any).id, id), isNotNull((config.table as any).deletedAt)));

  await logSystemEvent('warn', 'Élément supprimé définitivement depuis la corbeille', {
    entity,
    id,
    by: req.user!.username
  });
  res.json({ ok: true });
});

export default router;
