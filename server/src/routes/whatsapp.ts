import { Router } from 'express';
import { z } from 'zod';
import { desc, eq } from 'drizzle-orm';
import { db, facturesTable, whatsappMessagesTable } from '../db.js';
import { requireAuth, requirePermission } from '../middleware/auth.js';
import { sendWhatsAppMessage } from '../lib/whatsapp.js';

const router = Router();
router.use(requireAuth);

const phoneSchema = z.string().min(8).max(20);

// ── Test de la configuration WhatsApp (Administration) ───────────────────
router.post('/whatsapp/test', requirePermission('settings.manage'), async (req, res) => {
  const parsed = z.object({ to: phoneSchema }).safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: 'Numéro de téléphone invalide.' });
  }
  const result = await sendWhatsAppMessage({
    to: parsed.data.to,
    message: 'Ceci est un message de test envoyé depuis la Plateforme IAM d’Entraide Nationale.',
    kind: 'test',
    sentBy: req.user!.username
  });
  if (!result.ok) {
    return res.status(502).json({ error: result.error ?? "Échec de l'envoi." });
  }
  res.json({ ok: true });
});

// ── Envoi d'une facture par WhatsApp ──────────────────────────────────────
const sendFactureSchema = z.object({ to: phoneSchema, message: z.string().max(1000).optional() });

router.post('/whatsapp/facture/:id', requirePermission('business.write'), async (req, res) => {
  const id = Number(req.params.id);
  const parsed = sendFactureSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: 'Numéro de téléphone invalide.' });
  }

  const [facture] = await db.select().from(facturesTable).where(eq(facturesTable.id, id)).limit(1);
  if (!facture) return res.status(404).json({ error: 'Facture introuvable.' });

  const message =
    parsed.data.message ||
    `Bonjour,\n\nVotre facture IAM ${facture.refFacture} est disponible.\n` +
      `Montant : ${facture.montant.toLocaleString('fr-FR')} DH\n` +
      `Échéance : ${facture.echeance ?? '—'}\n\n` +
      `Merci.\nEntraide Nationale`;

  const result = await sendWhatsAppMessage({
    to: parsed.data.to,
    message,
    kind: 'facture',
    relatedId: String(facture.id),
    sentBy: req.user!.username
  });

  if (!result.ok) {
    return res.status(502).json({ error: result.error ?? "Échec de l'envoi." });
  }
  res.json({ ok: true });
});

// ── Historique des messages WhatsApp ──────────────────────────────────────
router.get('/whatsapp/logs', requirePermission('audit.view'), async (req, res) => {
  const limit = Math.min(Number(req.query.limit) || 50, 200);
  const rows = await db.select().from(whatsappMessagesTable).orderBy(desc(whatsappMessagesTable.sentAt)).limit(limit);
  res.json({ logs: rows });
});

export default router;
