/**
 * /api/notifications/stream — Server-Sent Events (SSE)
 *
 * Chaque client authentifié ouvre une connexion persistante.
 * Le serveur envoie un événement "ping" toutes les 20s pour maintenir
 * la connexion active (proxy / load balancer) et un événement "update"
 * chaque fois qu'un nouveau contenu de notification est détecté.
 *
 * Stratégie "diff" légère : on conserve le hash du dernier paquet
 * envoyé par connexion et on n'émet que si le contenu a changé.
 * Pas de Redis / WebSocket requis — 100 % SSE natif.
 */
import { Router } from 'express';
import { and, desc, eq, gte, inArray, isNull, sql } from 'drizzle-orm';
import {
  db,
  auditLogsTable,
  connectionLogsTable,
  systemLogsTable,
  facturesTable,
  notificationReadsTable,
  deplacementsTable,
  usersTable,
  vehiculeDeclarationsTable,
  vehiculesTable,
  chauffeursTable,
  demandeChauffeurTable,
} from '../db.js';
import { requireAuth } from '../middleware/auth.js';
import type { Request, Response } from 'express';

const router = Router();

/* ── Clients SSE actifs ─────────────────────────────────────────── */
interface SseClient {
  userId: number;
  res: Response;
  lastHash: string;
}
const clients = new Set<SseClient>();

/** Diffuse un événement SSE à tous les clients connectés dont les données
 *  ont changé depuis le dernier envoi. */
export async function broadcastNotifications(): Promise<void> {
  for (const client of clients) {
    try {
      const payload = await buildNotificationPayload(client.userId);
      const hash = simpleHash(JSON.stringify(payload));
      if (hash !== client.lastHash) {
        client.lastHash = hash;
        client.res.write(`event: update\ndata: ${JSON.stringify(payload)}\n\n`);
      }
    } catch {
      // client mort — sera nettoyé à la déconnexion
    }
  }
}

/* ── Calcul du payload de notifications (réutilisé par GET aussi) ─ */
export async function buildNotificationPayload(userId: number) {
  const since = new Date();
  since.setDate(since.getDate() - 3);

  type NotifColor = 'red' | 'green' | 'orange' | 'blue';
  type NotifKind = 'facture_echeance' | 'ligne_creee' | 'sauvegarde' | 'connexion' | 'system_error' | 'mission_assignee' | 'mission_statut' | 'declaration_vehicule';

  interface Notification {
    id: string;
    kind: NotifKind;
    color: NotifColor;
    message: string;
    createdAt: string;
  }

  const items: Notification[] = [];

  // Factures IAM arrivant à échéance sous 7 jours
  const dueSoon = await db
    .select({
      id: facturesTable.id,
      custcode: facturesTable.custcode,
      refFacture: facturesTable.refFacture,
      echeance: facturesTable.echeance,
      updatedAt: facturesTable.updatedAt,
    })
    .from(facturesTable)
    .where(
      sql`${facturesTable.deletedAt} IS NULL AND ${facturesTable.statut} = 'impayee'
          AND ${facturesTable.echeance} ~ '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
          AND to_date(${facturesTable.echeance}, 'DD/MM/YYYY') BETWEEN now() AND now() + interval '7 days'`
    )
    .limit(10);
  for (const f of dueSoon) {
    items.push({
      id: `facture-${f.id}`,
      kind: 'facture_echeance',
      color: 'red',
      message: `Facture ${f.refFacture} (${f.custcode}) arrive à échéance le ${f.echeance}.`,
      createdAt: f.updatedAt.toISOString(),
    });
  }

  // Nouvelles lignes créées par d'autres utilisateurs
  const newLignes = await db
    .select()
    .from(auditLogsTable)
    .where(
      sql`${auditLogsTable.createdAt} >= ${since}
          AND ${auditLogsTable.action} = 'create'
          AND ${auditLogsTable.entity} IN ('lignes', 'lignes-fixes')
          AND (${auditLogsTable.userId} IS NULL OR ${auditLogsTable.userId} != ${userId})`
    )
    .orderBy(desc(auditLogsTable.createdAt))
    .limit(10);
  for (const l of newLignes) {
    items.push({
      id: `ligne-${l.id}`,
      kind: 'ligne_creee',
      color: 'green',
      message: `${l.username ?? 'Un utilisateur'} a créé une nouvelle ${l.entity === 'lignes-fixes' ? 'ligne fixe' : 'ligne mobile'}.`,
      createdAt: l.createdAt.toISOString(),
    });
  }

  // Sauvegardes et erreurs système récentes
  const systemEvents = await db
    .select()
    .from(systemLogsTable)
    .where(gte(systemLogsTable.createdAt, since))
    .orderBy(desc(systemLogsTable.createdAt))
    .limit(20);
  for (const s of systemEvents) {
    if (s.message === 'Sauvegarde de la base créée') {
      items.push({
        id: `backup-${s.id}`,
        kind: 'sauvegarde',
        color: 'orange',
        message: 'Sauvegarde de la base de données terminée.',
        createdAt: s.createdAt.toISOString(),
      });
    }
    if (s.level === 'error') {
      items.push({
        id: `syserr-${s.id}`,
        kind: 'system_error',
        color: 'red',
        message: s.message,
        createdAt: s.createdAt.toISOString(),
      });
    }
  }

  // Connexions récentes d'autres utilisateurs
  const connections = await db
    .select()
    .from(connectionLogsTable)
    .where(
      sql`${connectionLogsTable.createdAt} >= ${since}
          AND ${connectionLogsTable.success} = true
          AND (${connectionLogsTable.userId} IS NULL OR ${connectionLogsTable.userId} != ${userId})`
    )
    .orderBy(desc(connectionLogsTable.createdAt))
    .limit(10);
  for (const c of connections) {
    items.push({
      id: `conn-${c.id}`,
      kind: 'connexion',
      color: 'blue',
      message: `${c.username} s'est connecté.`,
      createdAt: c.createdAt.toISOString(),
    });
  }

  // Missions récentes impliquant l'utilisateur (si c'est un chauffeur)
  const [userChauffeur] = await db
    .select()
    .from(deplacementsTable)
    .where(and(
      eq(deplacementsTable.chauffeurId, userId),
      gte(deplacementsTable.createdAt, since),
      isNull(deplacementsTable.deletedAt)
    ))
    .catch(() => [])
    .then(rows => rows.length > 0 ? [rows[0]] : [null]);

  // Missions assignées récemment (pour les chauffeurs)
  const missionsRecentes = await db
    .select({
      id: deplacementsTable.id,
      numero: deplacementsTable.numero,
      destination: deplacementsTable.destination,
      objet: deplacementsTable.objet,
      statut: deplacementsTable.statut,
      createdAt: deplacementsTable.createdAt,
    })
    .from(deplacementsTable)
    .where(
      and(
        gte(deplacementsTable.createdAt, since),
        isNull(deplacementsTable.deletedAt),
        inArray(deplacementsTable.statut, ['creee', 'en_attente_acceptation', 'acceptee', 'en_route', 'arrive', 'mission_en_cours'] as any)
      )
    )
    .orderBy(desc(deplacementsTable.createdAt))
    .limit(5);
  for (const m of missionsRecentes) {
    items.push({
      id: `mission-${m.id}`,
      kind: 'mission_statut',
      color: 'green',
      message: `Mission ${m.numero} : ${m.objet} (${m.destination || '—'}) — ${m.statut}`,
      createdAt: m.createdAt.toISOString(),
    });
  }

  // Déclarations chauffeur récentes (état du véhicule) — pour les rôles
  // responsables du parc, pas pour les chauffeurs eux-mêmes.
  const [requestingUser] = await db.select({ role: usersTable.role }).from(usersTable).where(eq(usersTable.id, userId));
  if (requestingUser && requestingUser.role !== 'CHAUFFEUR') {
    const declarationsRecentes = await db
      .select()
      .from(vehiculeDeclarationsTable)
      .where(and(gte(vehiculeDeclarationsTable.createdAt, since), sql`${vehiculeDeclarationsTable.statut} NOT IN ('terminee', 'archivee')`))
      .orderBy(desc(vehiculeDeclarationsTable.createdAt))
      .limit(10);
    if (declarationsRecentes.length > 0) {
      const vehiculeIds = [...new Set(declarationsRecentes.map((d) => d.vehiculeId))];
      const chauffeurIds = [...new Set(declarationsRecentes.map((d) => d.chauffeurId))];
      const vehicules = await db.select({ id: vehiculesTable.id, immatriculation: vehiculesTable.immatriculation }).from(vehiculesTable).where(inArray(vehiculesTable.id, vehiculeIds));
      const chauffeurs = await db.select({ id: chauffeursTable.id, nom: chauffeursTable.nom }).from(chauffeursTable).where(inArray(chauffeursTable.id, chauffeurIds));
      const immatById = new Map(vehicules.map((v) => [v.id, v.immatriculation]));
      const nomById = new Map(chauffeurs.map((c) => [c.id, c.nom]));
      const categorieLabels: Record<string, string> = {
        vidange: 'vidange', pneus: 'pneus', batterie: 'batterie', freins: 'freins', embrayage: 'embrayage',
        moteur: 'moteur', climatisation: 'climatisation', carrosserie: 'carrosserie', jawaz: 'Jawaz', assurance: 'assurance', autre: 'autre'
      };
      for (const d of declarationsRecentes) {
        items.push({
          id: `declaration-${d.id}`,
          kind: 'declaration_vehicule',
          color: d.urgence === 'critique' ? 'red' : d.urgence === 'urgent' ? 'orange' : 'blue',
          message: `${nomById.get(d.chauffeurId) ?? 'Un chauffeur'} signale un problème (${categorieLabels[d.categorie] ?? d.categorie}) sur ${immatById.get(d.vehiculeId) ?? 'un véhicule'}.`,
          createdAt: d.createdAt.toISOString(),
        });
      }
    }
  }

  items.sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime());
  const trimmed = items.slice(0, 30);

  const [readState] = await db
    .select()
    .from(notificationReadsTable)
    .where(eq(notificationReadsTable.userId, userId))
    .limit(1);
  const lastSeenAt = readState?.lastSeenAt ?? new Date(0);
  const unreadCount = trimmed.filter((n) => new Date(n.createdAt) > lastSeenAt).length;

  return { notifications: trimmed, unreadCount, lastSeenAt: lastSeenAt.toISOString() };
}

/** Hash djb2 ultra-léger pour détecter les changements de payload. */
function simpleHash(str: string): string {
  let h = 5381;
  for (let i = 0; i < str.length; i++) {
    h = ((h << 5) + h) ^ str.charCodeAt(i);
  }
  return (h >>> 0).toString(36);
}

/* ── Endpoint SSE ─────────────────────────────────────────────────── */
router.get('/notifications/stream', requireAuth, async (req: Request, res: Response) => {
  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');
  res.setHeader('X-Accel-Buffering', 'no'); // désactive le buffering nginx
  res.flushHeaders();

  const userId = req.user!.userId;

  // Envoi immédiat du premier payload
  let lastHash = '';
  try {
    const payload = await buildNotificationPayload(userId);
    lastHash = simpleHash(JSON.stringify(payload));
    res.write(`event: update\ndata: ${JSON.stringify(payload)}\n\n`);
  } catch {
    res.write(`event: error\ndata: {}\n\n`);
  }

  const client: SseClient = { userId, res, lastHash };
  clients.add(client);

  // Ping toutes les 20s pour maintenir la connexion
  const pingInterval = setInterval(() => {
    res.write(`: ping\n\n`);
  }, 20_000);

  // Poll toutes les 15s pour les clients qui ne reçoivent pas de broadcast
  const pollInterval = setInterval(async () => {
    try {
      const payload = await buildNotificationPayload(userId);
      const hash = simpleHash(JSON.stringify(payload));
      if (hash !== client.lastHash) {
        client.lastHash = hash;
        res.write(`event: update\ndata: ${JSON.stringify(payload)}\n\n`);
      }
    } catch {
      // ignore
    }
  }, 15_000);

  req.on('close', () => {
    clearInterval(pingInterval);
    clearInterval(pollInterval);
    clients.delete(client);
  });
});

/* ── Badges Gmail (comptes par rubrique) ─────────────────────────── */
router.get('/notifications/badges', requireAuth, async (req, res) => {
  try {
    const [demandesChauffeur, missionsAttente, declarationsNouv] = await Promise.all([
      db.select().from(demandeChauffeurTable).then((rows) =>
        rows.filter((r) => r.statut === 'en_attente' && !r.deletedAt).length
      ),
      db.select().from(deplacementsTable).then((rows) =>
        rows.filter((r) => r.statut === 'en_attente_acceptation' && !r.deletedAt).length
      ),
      db.select().from(vehiculeDeclarationsTable).then((rows) =>
        rows.filter((r) => r.statut === 'nouvelle').length
      )
    ]);
    res.json({ demandesChauffeur, missionsAttente, declarationsNouv });
  } catch {
    res.json({ demandesChauffeur: 0, missionsAttente: 0, declarationsNouv: 0 });
  }
});

/* ── Mark-read via SSE (POST) ─────────────────────────────────────── */
router.post('/notifications/mark-read', requireAuth, async (req, res) => {
  await db
    .insert(notificationReadsTable)
    .values({ userId: req.user!.userId, lastSeenAt: new Date() })
    .onConflictDoUpdate({
      target: notificationReadsTable.userId,
      set: { lastSeenAt: new Date() },
    });
  res.json({ ok: true });
});

export default router;
