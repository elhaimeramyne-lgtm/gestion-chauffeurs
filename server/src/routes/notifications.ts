import { Router } from 'express';
import { desc, eq, gte, sql } from 'drizzle-orm';
import { db, auditLogsTable, connectionLogsTable, systemLogsTable, facturesTable, notificationReadsTable, chauffeursTable, deplacementsTable } from '../db.js';
import { requireAuth } from '../middleware/auth.js';

const router = Router();
router.use(requireAuth);

type NotifKind = 'facture_echeance' | 'ligne_creee' | 'sauvegarde' | 'connexion' | 'system_error' | 'mission_assignee';

interface Notification {
  id: string;
  kind: NotifKind;
  color: 'red' | 'green' | 'orange' | 'blue';
  message: string;
  createdAt: string;
}

/** Centre de notifications — pas de table dédiée : le flux est recalculé à
 *  chaque appel à partir des événements déjà journalisés ailleurs
 *  (audit_logs, connection_logs, system_logs, factures). Limité aux 3
 *  derniers jours pour rester pertinent, 30 éléments max. */
router.get('/notifications', async (req, res) => {
  const since = new Date();
  since.setDate(since.getDate() - 3);

  const items: Notification[] = [];

  // 🔵 Missions assignées en attente (uniquement pour les comptes chauffeur)
  // — sert de "notification" au sens demandé : le chauffeur voit apparaître
  // sa nouvelle mission dès sa connexion, sans table dédiée supplémentaire.
  if (req.user!.role === 'CHAUFFEUR') {
    const [chauffeur] = await db.select().from(chauffeursTable).where(eq(chauffeursTable.userId, req.user!.userId));
    if (chauffeur) {
      const pending = await db
        .select()
        .from(deplacementsTable)
        .where(
          sql`${deplacementsTable.chauffeurId} = ${chauffeur.id} AND ${deplacementsTable.statut} = 'en_attente_acceptation' AND ${deplacementsTable.deletedAt} IS NULL`
        )
        .orderBy(desc(deplacementsTable.createdAt))
        .limit(20);
      for (const m of pending) {
        items.push({
          id: `mission-${m.id}`,
          kind: 'mission_assignee',
          color: 'blue',
          message: `Nouvelle mission assignée : ${m.numero} — ${m.objet}${m.destination ? ` (${m.destination})` : ''}.`,
          createdAt: m.createdAt.toISOString()
        });
      }
    }
    // Un compte chauffeur n'a accès à rien d'autre côté serveur (voir
    // lib/permissions.ts) : on s'arrête ici, inutile d'interroger les
    // tables factures/lignes/audit ci-dessous.
    items.sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime());
    const [readState] = await db.select().from(notificationReadsTable).where(eq(notificationReadsTable.userId, req.user!.userId)).limit(1);
    const lastSeenAt = readState?.lastSeenAt ?? new Date(0);
    const unreadCount = items.filter((n) => new Date(n.createdAt) > lastSeenAt).length;
    return res.json({ notifications: items, unreadCount, lastSeenAt: lastSeenAt.toISOString() });
  }

  // 🔴 Factures IAM arrivant à échéance sous 7 jours
  const dueSoon = await db
    .select({
      id: facturesTable.id,
      custcode: facturesTable.custcode,
      refFacture: facturesTable.refFacture,
      echeance: facturesTable.echeance,
      updatedAt: facturesTable.updatedAt
    })
    .from(facturesTable)
    .where(sql`
      ${facturesTable.deletedAt} IS NULL AND ${facturesTable.statut} = 'impayee'
      AND ${facturesTable.echeance} ~ '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
      AND to_date(${facturesTable.echeance}, 'DD/MM/YYYY') BETWEEN now() AND now() + interval '7 days'
    `)
    .limit(10);
  for (const f of dueSoon) {
    items.push({
      id: `facture-${f.id}`,
      kind: 'facture_echeance',
      color: 'red',
      message: `Facture ${f.refFacture} (${f.custcode}) arrive à échéance le ${f.echeance}.`,
      // Date stable (dernière modification de la facture) — et non "maintenant" à
      // chaque appel, sinon la notification redevient "non lue" en boucle.
      createdAt: f.updatedAt.toISOString()
    });
  }

  // 🟢 Nouvelles lignes créées (mobiles + fixes) — pas les vôtres : se
  // notifier soi-même de ses propres actions n'a pas de sens et faisait
  // réapparaître une notification "non lue" à chaque connexion.
  const newLignes = await db
    .select()
    .from(auditLogsTable)
    .where(
      sql`${auditLogsTable.createdAt} >= ${since} AND ${auditLogsTable.action} = 'create' AND ${auditLogsTable.entity} IN ('lignes', 'lignes-fixes') AND (${auditLogsTable.userId} IS NULL OR ${auditLogsTable.userId} != ${req.user!.userId})`
    )
    .orderBy(desc(auditLogsTable.createdAt))
    .limit(10);
  for (const l of newLignes) {
    items.push({
      id: `ligne-${l.id}`,
      kind: 'ligne_creee',
      color: 'green',
      message: `${l.username ?? 'Un utilisateur'} a créé une nouvelle ${l.entity === 'lignes-fixes' ? 'ligne fixe' : 'ligne mobile'}.`,
      createdAt: l.createdAt.toISOString()
    });
  }

  // 🟠 Sauvegardes terminées
  const backups = await db
    .select()
    .from(systemLogsTable)
    .where(gte(systemLogsTable.createdAt, since))
    .orderBy(desc(systemLogsTable.createdAt))
    .limit(20);
  for (const s of backups) {
    if (s.message === 'Sauvegarde de la base créée') {
      items.push({
        id: `backup-${s.id}`,
        kind: 'sauvegarde',
        color: 'orange',
        message: 'Sauvegarde de la base de données terminée.',
        createdAt: s.createdAt.toISOString()
      });
    }
    if (s.level === 'error') {
      items.push({
        id: `syserr-${s.id}`,
        kind: 'system_error',
        color: 'red',
        message: s.message,
        createdAt: s.createdAt.toISOString()
      });
    }
  }

  // 🔵 Connexions réussies récentes — pas les vôtres, pour la même raison
  // (sinon chaque connexion génère une notification "non lue" sur soi-même).
  const connections = await db
    .select()
    .from(connectionLogsTable)
    .where(
      sql`${connectionLogsTable.createdAt} >= ${since} AND ${connectionLogsTable.success} = true AND (${connectionLogsTable.userId} IS NULL OR ${connectionLogsTable.userId} != ${req.user!.userId})`
    )
    .orderBy(desc(connectionLogsTable.createdAt))
    .limit(10);
  for (const c of connections) {
    items.push({
      id: `conn-${c.id}`,
      kind: 'connexion',
      color: 'blue',
      message: `${c.username} s'est connecté.`,
      createdAt: c.createdAt.toISOString()
    });
  }

  items.sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime());
  const trimmed = items.slice(0, 30);

  const [readState] = await db
    .select()
    .from(notificationReadsTable)
    .where(eq(notificationReadsTable.userId, req.user!.userId))
    .limit(1);
  const lastSeenAt = readState?.lastSeenAt ?? new Date(0);
  const unreadCount = trimmed.filter((n) => new Date(n.createdAt) > lastSeenAt).length;

  res.json({ notifications: trimmed, unreadCount, lastSeenAt: lastSeenAt.toISOString() });
});

router.post('/notifications/mark-read', async (req, res) => {
  await db
    .insert(notificationReadsTable)
    .values({ userId: req.user!.userId, lastSeenAt: new Date() })
    .onConflictDoUpdate({
      target: notificationReadsTable.userId,
      set: { lastSeenAt: new Date() }
    });
  res.json({ ok: true });
});

export default router;
