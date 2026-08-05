import { Router } from 'express';
import { z } from 'zod';
import { desc, eq } from 'drizzle-orm';
import { db, facturesTable, emailLogsTable } from '../db.js';
import { requireAuth, requirePermission } from '../middleware/auth.js';
import { sendEmail } from '../lib/email.js';

const router = Router();
router.use(requireAuth);

// ── Test de la configuration SMTP (Administration) ───────────────────────
const testSchema = z.object({ to: z.string().email() });

router.post('/email/test', requirePermission('settings.manage'), async (req, res) => {
  const parsed = testSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: 'Adresse e-mail invalide.' });
  }
  const result = await sendEmail({
    to: parsed.data.to,
    subject: 'Test — Plateforme IAM',
    html: `<p>Ceci est un e-mail de test envoyé depuis la Plateforme IAM d'Entraide Nationale.</p>
           <p>Si vous recevez ce message, la configuration SMTP fonctionne correctement.</p>`,
    kind: 'test',
    sentBy: req.user!.username
  });
  if (!result.ok) {
    return res.status(502).json({ error: result.error ?? "Échec de l'envoi." });
  }
  res.json({ ok: true });
});

// ── Envoi d'une facture par e-mail ────────────────────────────────────────
const sendFactureSchema = z.object({ to: z.string().email(), message: z.string().max(1000).optional() });

router.post('/email/facture/:id', requirePermission('business.write'), async (req, res) => {
  const id = Number(req.params.id);
  const parsed = sendFactureSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: 'Adresse e-mail invalide.' });
  }

  const [facture] = await db.select().from(facturesTable).where(eq(facturesTable.id, id)).limit(1);
  if (!facture) return res.status(404).json({ error: 'Facture introuvable.' });

  const html = `
    <div style="font-family: sans-serif; max-width: 480px; margin: 0 auto;">
      <h2 style="color:#0B1023;">Facture IAM</h2>
      ${parsed.data.message ? `<p>${parsed.data.message}</p>` : '<p>Bonjour,</p><p>Voici le détail de votre facture IAM :</p>'}
      <table style="width:100%; border-collapse: collapse; margin-top: 16px;">
        <tr><td style="padding:6px 0; color:#64748b;">Référence</td><td style="padding:6px 0; font-weight:600;">${facture.refFacture}</td></tr>
        <tr><td style="padding:6px 0; color:#64748b;">Code client</td><td style="padding:6px 0;">${facture.custcode}</td></tr>
        <tr><td style="padding:6px 0; color:#64748b;">Montant</td><td style="padding:6px 0; font-weight:600;">${facture.montant.toLocaleString('fr-FR')} DH</td></tr>
        <tr><td style="padding:6px 0; color:#64748b;">Échéance</td><td style="padding:6px 0;">${facture.echeance ?? '—'}</td></tr>
        <tr><td style="padding:6px 0; color:#64748b;">Statut</td><td style="padding:6px 0;">${facture.statut === 'reglee' ? 'Réglée' : 'Impayée'}</td></tr>
      </table>
      <p style="margin-top:24px; color:#94a3b8; font-size:12px;">Entraide Nationale — Plateforme IAM</p>
    </div>`;

  const result = await sendEmail({
    to: parsed.data.to,
    subject: `Facture IAM ${facture.refFacture}`,
    html,
    kind: 'facture',
    relatedId: String(facture.id),
    sentBy: req.user!.username
  });

  if (!result.ok) {
    return res.status(502).json({ error: result.error ?? "Échec de l'envoi." });
  }
  res.json({ ok: true });
});

// ── Historique des e-mails envoyés ────────────────────────────────────────
router.get('/email/logs', requirePermission('audit.view'), async (req, res) => {
  const limit = Math.min(Number(req.query.limit) || 50, 200);
  const rows = await db.select().from(emailLogsTable).orderBy(desc(emailLogsTable.createdAt)).limit(limit);
  res.json({ logs: rows });
});

export default router;
