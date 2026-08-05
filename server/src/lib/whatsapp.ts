import { db, whatsappMessagesTable } from '../db.js';

/** Numéro de téléphone au format international sans "+" ni espaces
 *  (exigé par l'API Meta), ex: 212612345678. Tolère les formats courants
 *  saisis à la main et les normalise. */
function normalizePhone(raw: string): string {
  return raw.replace(/[^\d]/g, '');
}

interface WhatsAppConfig {
  accessToken: string;
  phoneNumberId: string;
  apiVersion: string;
}

function getConfig(): WhatsAppConfig {
  const accessToken = process.env.WHATSAPP_ACCESS_TOKEN?.trim();
  const phoneNumberId = process.env.WHATSAPP_PHONE_NUMBER_ID?.trim();
  const apiVersion = process.env.WHATSAPP_API_VERSION?.trim() || 'v21.0';

  if (!accessToken || !phoneNumberId) {
    throw new Error(
      "WhatsApp n'est pas configuré : ajoutez WHATSAPP_ACCESS_TOKEN et WHATSAPP_PHONE_NUMBER_ID dans server/.env " +
        '(voir .env.example — nécessite un compte WhatsApp Business API créé sur business.facebook.com).'
    );
  }
  return { accessToken, phoneNumberId, apiVersion };
}

export interface SendWhatsAppInput {
  to: string;
  message: string;
  kind?: 'facture' | 'rappel' | 'test' | 'autre';
  relatedId?: string;
  sentBy?: string;
}

/** Envoie un message texte WhatsApp via l'API Cloud officielle de Meta, et
 *  journalise systématiquement le résultat. Important : en dehors d'une
 *  fenêtre de 24h suivant un message du destinataire, Meta exige un
 *  "message modèle" pré-approuvé plutôt qu'un texte libre — voir
 *  sendWhatsAppTemplate ci-dessous pour ce cas. */
export async function sendWhatsAppMessage(input: SendWhatsAppInput): Promise<{ ok: boolean; error?: string }> {
  const to = normalizePhone(input.to);

  try {
    const { accessToken, phoneNumberId, apiVersion } = getConfig();

    const response = await fetch(`https://graph.facebook.com/${apiVersion}/${phoneNumberId}/messages`, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${accessToken}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        messaging_product: 'whatsapp',
        to,
        type: 'text',
        text: { body: input.message }
      })
    });

    const data = (await response.json()) as {
      messages?: Array<{ id: string }>;
      error?: { message: string };
    };

    if (!response.ok || data.error) {
      const errorMessage = data.error?.message ?? `Erreur HTTP ${response.status}`;
      await db.insert(whatsappMessagesTable).values({
        toPhone: to,
        message: input.message,
        kind: input.kind ?? 'autre',
        relatedId: input.relatedId ?? null,
        status: 'failed',
        error: errorMessage,
        sentBy: input.sentBy ?? null
      });
      return { ok: false, error: errorMessage };
    }

    await db.insert(whatsappMessagesTable).values({
      toPhone: to,
      message: input.message,
      kind: input.kind ?? 'autre',
      relatedId: input.relatedId ?? null,
      status: 'sent',
      waMessageId: data.messages?.[0]?.id ?? null,
      sentBy: input.sentBy ?? null
    });
    return { ok: true };
  } catch (err) {
    const message = err instanceof Error ? err.message : String(err);
    await db
      .insert(whatsappMessagesTable)
      .values({
        toPhone: to,
        message: input.message,
        kind: input.kind ?? 'autre',
        relatedId: input.relatedId ?? null,
        status: 'failed',
        error: message,
        sentBy: input.sentBy ?? null
      })
      .catch(() => {});
    return { ok: false, error: message };
  }
}
