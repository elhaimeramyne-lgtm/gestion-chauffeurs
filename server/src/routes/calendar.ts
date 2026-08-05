import { Router } from 'express';
import { z } from 'zod';
import { and, eq, gte, isNull, lte, ne, sql, inArray } from 'drizzle-orm';
import { db, facturesTable, calendarEventsTable, deplacementsTable, vehiculesTable, chauffeursTable } from '../db.js';
import { requireAuth, requirePermission } from '../middleware/auth.js';

const router = Router();
router.use(requireAuth);

export type CalendarEventKind = 'echeance' | 'paiement' | 'renouvellement' | 'intervention' | 'maintenance' | 'conge' | 'autre' | 'mission_depart' | 'mission_retour';

interface CalendarEvent {
  id: string;
  kind: CalendarEventKind;
  title: string;
  date: string; // JJ/MM/AAAA
  detail?: string;
}

// ── Vue du mois : fusionne échéances de factures, paiements et événements
// personnalisés. Le mois est demandé au format YYYY-MM (défaut : mois en cours).
router.get('/calendar/events', async (req, res) => {
  const monthParam = typeof req.query.month === 'string' ? req.query.month : '';
  const match = /^(\d{4})-(\d{2})$/.exec(monthParam);
  const now = new Date();
  const year = match ? Number(match[1]) : now.getFullYear();
  const month = match ? Number(match[2]) - 1 : now.getMonth();
  const start = new Date(year, month, 1);
  const end = new Date(year, month + 1, 1);

  const events: CalendarEvent[] = [];

  // 🔴 Échéances de factures impayées dont l'échéance tombe dans le mois demandé
  const impayees = await db
    .select({ id: facturesTable.id, custcode: facturesTable.custcode, refFacture: facturesTable.refFacture, echeance: facturesTable.echeance, montant: facturesTable.montant })
    .from(facturesTable)
    .where(
      sql`${facturesTable.deletedAt} IS NULL AND ${facturesTable.statut} = 'impayee'
          AND ${facturesTable.echeance} ~ '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
          AND to_date(${facturesTable.echeance}, 'DD/MM/YYYY') >= ${start.toISOString()}::date
          AND to_date(${facturesTable.echeance}, 'DD/MM/YYYY') < ${end.toISOString()}::date`
    )
    .limit(200);
  for (const f of impayees) {
    events.push({
      id: `echeance-${f.id}`,
      kind: 'echeance',
      title: `Échéance — ${f.refFacture}`,
      date: f.echeance!,
      detail: `${f.custcode} · ${f.montant.toLocaleString('fr-FR')} DH`
    });
  }

  // 🟢 Paiements : factures réglées, datées par leur dernière mise à jour
  const reglees = await db
    .select({ id: facturesTable.id, custcode: facturesTable.custcode, refFacture: facturesTable.refFacture, updatedAt: facturesTable.updatedAt, montant: facturesTable.montant })
    .from(facturesTable)
    .where(and(isNull(facturesTable.deletedAt), eq(facturesTable.statut, 'reglee'), gte(facturesTable.updatedAt, start), lte(facturesTable.updatedAt, end)))
    .limit(200);
  for (const f of reglees) {
    events.push({
      id: `paiement-${f.id}`,
      kind: 'paiement',
      title: `Paiement — ${f.refFacture}`,
      date: f.updatedAt.toLocaleDateString('fr-FR'),
      detail: `${f.custcode} · ${f.montant.toLocaleString('fr-FR')} DH`
    });
  }

  // 🔵 Missions (Parc Automobile) : dates de départ et de retour prévu qui
  // tombent dans le mois demandé. Dérivées automatiquement des ordres de
  // mission — comme les échéances/paiements, aucune saisie manuelle requise.
  const missions = await db
    .select()
    .from(deplacementsTable)
    .where(and(isNull(deplacementsTable.deletedAt), ne(deplacementsTable.statut, 'annule')))
    .limit(500);
  if (missions.length > 0) {
    const vehiculeIds = [...new Set(missions.map((m) => m.vehiculeId).filter((id): id is number => id != null))];
    const chauffeurIds = [...new Set(missions.map((m) => m.chauffeurId).filter((id): id is number => id != null))];
    const vehicules = vehiculeIds.length
      ? await db.select({ id: vehiculesTable.id, immatriculation: vehiculesTable.immatriculation }).from(vehiculesTable).where(inArray(vehiculesTable.id, vehiculeIds))
      : [];
    const chauffeurs = chauffeurIds.length
      ? await db.select({ id: chauffeursTable.id, nom: chauffeursTable.nom }).from(chauffeursTable).where(inArray(chauffeursTable.id, chauffeurIds))
      : [];
    const vehiculeById = new Map(vehicules.map((v) => [v.id, v.immatriculation]));
    const chauffeurById = new Map(chauffeurs.map((c) => [c.id, c.nom]));

    const inMonth = (dmy: string | null): boolean => {
      if (!dmy) return false;
      const [d, m, y] = dmy.split('/').map(Number);
      return !!d && y === year && m - 1 === month;
    };

    for (const m of missions) {
      const vehiculeLabel = m.vehiculeId ? vehiculeById.get(m.vehiculeId) : undefined;
      const chauffeurLabel = m.chauffeurId ? chauffeurById.get(m.chauffeurId) : undefined;
      const detailParts = [vehiculeLabel, m.destination, chauffeurLabel].filter(Boolean);
      if (inMonth(m.dateDepart)) {
        events.push({
          id: `mission-depart-${m.id}`,
          kind: 'mission_depart',
          title: `Départ mission — ${m.numero}`,
          date: m.dateDepart,
          detail: detailParts.join(' · ') || undefined
        });
      }
      if (inMonth(m.dateRetourPrevue)) {
        events.push({
          id: `mission-retour-${m.id}`,
          kind: 'mission_retour',
          title: `Retour prévu — ${m.numero}`,
          date: m.dateRetourPrevue!,
          detail: detailParts.join(' · ') || undefined
        });
      }
    }
  }

  // Événements personnalisés (renouvellements, interventions, maintenance, congés...)
  const custom = await db
    .select()
    .from(calendarEventsTable)
    .where(isNull(calendarEventsTable.deletedAt));
  for (const c of custom) {
    const [d, m, y] = c.date.split('/').map(Number);
    if (!d || !m || !y) continue;
    if (y === year && m - 1 === month) {
      events.push({
        id: `custom-${c.id}`,
        kind: c.type as CalendarEventKind,
        title: c.title,
        date: c.date,
        detail: c.description ?? undefined
      });
    }
  }

  res.json({ events, year, month: month + 1 });
});

const createEventSchema = z.object({
  title: z.string().min(1).max(200),
  type: z.enum(['renouvellement', 'intervention', 'maintenance', 'conge', 'autre']),
  date: z.string().regex(/^\d{2}\/\d{2}\/\d{4}$/, 'Format attendu : JJ/MM/AAAA'),
  description: z.string().max(1000).nullable().optional()
});

router.post('/calendar/events', requirePermission('business.write'), async (req, res) => {
  const parsed = createEventSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: parsed.error.issues[0]?.message ?? 'Données invalides.' });
  }
  const [row] = await db
    .insert(calendarEventsTable)
    .values({ ...parsed.data, createdBy: req.user!.username })
    .returning();
  res.status(201).json({ event: row });
});

router.delete('/calendar/events/:id', requirePermission('business.write'), async (req, res) => {
  const id = Number(req.params.id);
  const [row] = await db
    .update(calendarEventsTable)
    .set({ deletedAt: new Date(), deletedBy: req.user!.username })
    .where(and(eq(calendarEventsTable.id, id), isNull(calendarEventsTable.deletedAt)))
    .returning();
  if (!row) return res.status(404).json({ error: 'Événement introuvable.' });
  res.json({ ok: true });
});

export default router;
