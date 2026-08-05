import { Router } from 'express';
import { count, desc, eq, gte, isNull, sql, sum } from 'drizzle-orm';
import { db, usersTable, lignesTable, lignesFixesTable, facturesTable, auditLogsTable, systemLogsTable } from '../db.js';
import { requireAuth, requirePermission } from '../middleware/auth.js';

const router = Router();

// ── Statistiques globales : réservé aux ADMIN / SUPER_ADMIN ─────────────
// Toutes les valeurs proviennent directement des tables persistées
// (utilisateurs, lignes, lignes fixes, factures) — aucune valeur calculée
// côté client n'est nécessaire ici.
router.get('/dashboard/stats', requireAuth, requirePermission('dashboard.view'), async (_req, res) => {
  const [{ value: usersCount }] = await db.select({ value: count() }).from(usersTable);
  const [{ value: adminsCount }] = await db
    .select({ value: count() })
    .from(usersTable)
    .where(sql`${usersTable.role} IN ('ADMIN', 'SUPER_ADMIN')`);
  const [{ value: activeUsersCount }] = await db
    .select({ value: count() })
    .from(usersTable)
    .where(eq(usersTable.isActive, true));
  const [{ value: lignesMobilesCount }] = await db
    .select({ value: count() })
    .from(lignesTable)
    .where(isNull(lignesTable.deletedAt));
  const [{ value: lignesFixesCount }] = await db
    .select({ value: count() })
    .from(lignesFixesTable)
    .where(isNull(lignesFixesTable.deletedAt));

  const [{ value: facturesTotal }] = await db
    .select({ value: count() })
    .from(facturesTable)
    .where(isNull(facturesTable.deletedAt));
  const [{ value: facturesImpayees, montant: montantImpaye }] = await db
    .select({ value: count(), montant: sum(facturesTable.montant) })
    .from(facturesTable)
    .where(sql`${facturesTable.deletedAt} IS NULL AND ${facturesTable.statut} = 'impayee'`);
  const facturesReglees = Number(facturesTotal) - Number(facturesImpayees);

  // Répartition des comptes par rôle (pour le graphique)
  const byRole = await db
    .select({ role: usersTable.role, value: count() })
    .from(usersTable)
    .groupBy(usersTable.role);

  // Répartition des lignes mobiles par catégorie (pour le graphique)
  const byCategorie = await db
    .select({ categorie: lignesTable.categorie, value: count() })
    .from(lignesTable)
    .where(isNull(lignesTable.deletedAt))
    .groupBy(lignesTable.categorie);

  // Activité des 7 derniers jours (nombre d'actions par jour)
  const sevenDaysAgo = new Date();
  sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 6);
  sevenDaysAgo.setHours(0, 0, 0, 0);
  const activityByDay = await db
    .select({
      day: sql<string>`to_char(${auditLogsTable.createdAt}, 'YYYY-MM-DD')`,
      value: count()
    })
    .from(auditLogsTable)
    .where(gte(auditLogsTable.createdAt, sevenDaysAgo))
    .groupBy(sql`to_char(${auditLogsTable.createdAt}, 'YYYY-MM-DD')`)
    .orderBy(sql`to_char(${auditLogsTable.createdAt}, 'YYYY-MM-DD')`);

  const recentActivity = await db
    .select()
    .from(auditLogsTable)
    .orderBy(desc(auditLogsTable.createdAt))
    .limit(10);

  // ── Dépenses du mois + comparaison au mois précédent ────────────────────
  // Basé sur la date d'enregistrement de la facture (updatedAt), la seule
  // date fiable en base (l'échéance est un texte libre importé d'Excel).
  const monthResult = await db.execute<{
    current_total: string | null;
    current_count: string | null;
    previous_total: string | null;
    previous_count: string | null;
  }>(sql`
    SELECT
      SUM(CASE WHEN date_trunc('month', updated_at) = date_trunc('month', now()) THEN montant ELSE 0 END) AS current_total,
      COUNT(*) FILTER (WHERE date_trunc('month', updated_at) = date_trunc('month', now())) AS current_count,
      SUM(CASE WHEN date_trunc('month', updated_at) = date_trunc('month', now() - interval '1 month') THEN montant ELSE 0 END) AS previous_total,
      COUNT(*) FILTER (WHERE date_trunc('month', updated_at) = date_trunc('month', now() - interval '1 month')) AS previous_count
    FROM iam.factures
    WHERE deleted_at IS NULL
  `);
  const monthRow = monthResult.rows[0];
  const currentMonthTotal = Number(monthRow?.current_total ?? 0);
  const previousMonthTotal = Number(monthRow?.previous_total ?? 0);
  const monthDeltaPct =
    previousMonthTotal > 0 ? ((currentMonthTotal - previousMonthTotal) / previousMonthTotal) * 100 : null;

  // ── Évolution des dépenses (6 derniers mois) ─────────────────────────────
  const monthlyTrendResult = await db.execute<{ month: string; montant: string; count: string }>(sql`
    SELECT to_char(date_trunc('month', updated_at), 'YYYY-MM') AS month,
           SUM(montant) AS montant,
           COUNT(*) AS count
    FROM iam.factures
    WHERE deleted_at IS NULL AND updated_at >= now() - interval '6 months'
    GROUP BY 1
    ORDER BY 1
  `);
  const monthlyTrend = monthlyTrendResult.rows.map((r) => ({
    month: r.month,
    montant: Number(r.montant),
    count: Number(r.count)
  }));

  // ── Top 10 directions les plus coûteuses + répartition ──────────────────
  const topDirectionsResult = await db.execute<{ direction: string; montant: string; count: string }>(sql`
    SELECT COALESCE(delegation, 'Non renseignée') AS direction,
           SUM(montant) AS montant,
           COUNT(*) AS count
    FROM iam.factures
    WHERE deleted_at IS NULL
    GROUP BY 1
    ORDER BY SUM(montant) DESC
    LIMIT 10
  `);
  const topDirections = topDirectionsResult.rows.map((r) => ({
    direction: r.direction,
    montant: Number(r.montant),
    count: Number(r.count)
  }));

  // ── Alertes importantes ──────────────────────────────────────────────────
  const alerts: Array<{ level: 'critical' | 'warning' | 'info'; message: string }> = [];

  const [{ value: overdueCount }] = await db
    .select({ value: count() })
    .from(facturesTable)
    .where(sql`
      ${facturesTable.deletedAt} IS NULL AND ${facturesTable.statut} = 'impayee'
      AND ${facturesTable.echeance} ~ '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
      AND to_date(${facturesTable.echeance}, 'DD/MM/YYYY') < now()
    `);
  if (Number(overdueCount) > 0) {
    alerts.push({ level: 'critical', message: `${overdueCount} facture(s) impayée(s) en retard d'échéance.` });
  }

  const [{ value: dueSoonCount }] = await db
    .select({ value: count() })
    .from(facturesTable)
    .where(sql`
      ${facturesTable.deletedAt} IS NULL AND ${facturesTable.statut} = 'impayee'
      AND ${facturesTable.echeance} ~ '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
      AND to_date(${facturesTable.echeance}, 'DD/MM/YYYY') BETWEEN now() AND now() + interval '7 days'
    `);
  if (Number(dueSoonCount) > 0) {
    alerts.push({ level: 'warning', message: `${dueSoonCount} facture(s) IAM arrivent à échéance sous 7 jours.` });
  }

  const [lastBackupLog] = await db
    .select()
    .from(systemLogsTable)
    .where(sql`${systemLogsTable.message} = 'Sauvegarde de la base créée'`)
    .orderBy(desc(systemLogsTable.createdAt))
    .limit(1);
  const thirtyDaysAgo = new Date();
  thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
  if (!lastBackupLog || new Date(lastBackupLog.createdAt) < thirtyDaysAgo) {
    alerts.push({ level: 'warning', message: 'Aucune sauvegarde de la base effectuée depuis plus de 30 jours.' });
  }

  res.json({
    users: {
      total: Number(usersCount),
      admins: Number(adminsCount),
      active: Number(activeUsersCount),
      byRole: byRole.map((r) => ({ role: r.role, value: Number(r.value) }))
    },
    lignes: {
      mobiles: Number(lignesMobilesCount),
      fixes: Number(lignesFixesCount),
      actives: Number(lignesMobilesCount) + Number(lignesFixesCount),
      byCategorie: byCategorie.map((c) => ({ categorie: c.categorie, value: Number(c.value) }))
    },
    factures: {
      total: Number(facturesTotal),
      reglees: facturesReglees,
      impayees: Number(facturesImpayees),
      montantImpaye: Number(montantImpaye ?? 0)
    },
    monthComparison: {
      currentMonthTotal,
      previousMonthTotal,
      deltaPct: monthDeltaPct
    },
    monthlyTrend,
    topDirections,
    alerts,
    activityByDay: activityByDay.map((a) => ({ day: a.day, value: Number(a.value) })),
    recentActivity
  });
});

export default router;
