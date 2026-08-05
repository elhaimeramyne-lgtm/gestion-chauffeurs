import { Router } from 'express';
import { z } from 'zod';
import type { ChatCompletionMessageParam } from 'openai/resources/chat/completions';
import { requireAuth } from '../middleware/auth.js';
import { ASSISTANT_TOOLS, executeAssistantTool } from '../lib/assistant.js';
import { getLLMClient, getLLMModel } from '../lib/assistant-llm.js';

const router = Router();
router.use(requireAuth);

const querySchema = z.object({
  question: z.string().min(1).max(500),
  // Historique court (facultatif) pour permettre des questions de suivi ("et le mois d'avant ?")
  history: z
    .array(z.object({ role: z.enum(['user', 'assistant']), content: z.string() }))
    .max(10)
    .optional()
});

const SYSTEM_PROMPT = `Tu es l'assistant intégré à la Plateforme IAM d'Entraide Nationale (gestion de facturation
télécom, lignes mobiles/fixes, utilisateurs). Réponds UNIQUEMENT à partir des données renvoyées par
les outils fournis — n'invente jamais de chiffre. Si une question ne correspond à aucun outil
disponible (ex: modifier des données, agir sur le système), explique poliment que tu ne peux
qu'effectuer des recherches, pas des actions. Réponds en français, de façon concise et directe,
avec les montants en dirhams (DH). Si les résultats sont nombreux, résume plutôt que de tout lister.`;

router.post('/assistant/query', async (req, res) => {
  const parsed = querySchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: 'Question invalide.' });
  }

  let client;
  try {
    client = getLLMClient();
  } catch (err) {
    return res.status(503).json({ error: err instanceof Error ? err.message : "Assistant indisponible." });
  }

  const model = getLLMModel();
  const messages: ChatCompletionMessageParam[] = [
    { role: 'system', content: SYSTEM_PROMPT },
    ...(parsed.data.history ?? []).map((h) => ({ role: h.role, content: h.content }) as ChatCompletionMessageParam),
    { role: 'user', content: parsed.data.question }
  ];

  const usedTools: Array<{ name: string; input: unknown }> = [];
  let structuredData: unknown = null;

  try {
    // Boucle d'appels d'outils bornée : évite une facture API ou une latence
    // incontrôlées si le modèle s'entête à enchaîner les recherches.
    for (let step = 0; step < 5; step++) {
      const response = await client.chat.completions.create({
        model,
        max_tokens: 1024,
        tools: ASSISTANT_TOOLS,
        messages
      });

      const choice = response.choices[0];
      const toolCalls = choice.message.tool_calls ?? [];

      if (toolCalls.length === 0) {
        const text = choice.message.content ?? '';
        return res.json({ answer: text, toolsUsed: usedTools.map((t) => t.name), data: structuredData });
      }

      messages.push(choice.message);

      for (const toolCall of toolCalls) {
        if (toolCall.type !== 'function') continue;
        let input: Record<string, unknown> = {};
        try {
          input = JSON.parse(toolCall.function.arguments || '{}');
        } catch {
          input = {};
        }
        usedTools.push({ name: toolCall.function.name, input });
        const result = await executeAssistantTool(toolCall.function.name, input);
        if (toolCall.function.name === 'search_factures' || toolCall.function.name === 'search_lignes') {
          structuredData = result;
        }
        messages.push({
          role: 'tool',
          tool_call_id: toolCall.id,
          content: JSON.stringify(result)
        });
      }
    }

    res.json({
      answer: "Je n'ai pas réussi à formuler une réponse claire à partir des données disponibles. Essayez de reformuler votre question.",
      toolsUsed: usedTools.map((t) => t.name),
      data: structuredData
    });
  } catch (err) {
    // eslint-disable-next-line no-console
    console.error('[assistant] erreur:', err);
    res.status(500).json({ error: "Erreur de l'assistant. Réessayez dans un instant." });
  }
});

export default router;
