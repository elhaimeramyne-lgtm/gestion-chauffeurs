/**
 * Couche d'abstraction LLM pour l'assistant IA.
 *
 * Priorité de configuration :
 *  1. LLM_BASE_URL + LLM_API_KEY  — gateway interne (proxy OpenAI-compatible)
 *  2. OPENAI_API_KEY              — OpenAI direct (rétrocompatibilité)
 *
 * Cela permet d'utiliser la gateway centralisée de l'organisation sans
 * modifier le code métier de l'assistant.
 */
import OpenAI from 'openai';

let _client: OpenAI | null = null;

export function getLLMClient(): OpenAI {
  if (_client) return _client;

  const llmBase = process.env.LLM_BASE_URL?.trim();
  const llmKey = process.env.LLM_API_KEY?.trim();
  const openaiKey = process.env.OPENAI_API_KEY?.trim();

  if (llmBase && llmKey) {
    // Gateway interne compatible OpenAI (Litellm, Azure OpenAI, etc.)
    // eslint-disable-next-line no-console
    console.log(`[assistant] Gateway LLM interne : ${llmBase.slice(0, 40)}…`);
    _client = new OpenAI({ apiKey: llmKey, baseURL: llmBase });
    return _client;
  }

  if (openaiKey) {
    // eslint-disable-next-line no-console
    console.log(
      `[assistant] OpenAI direct : ${openaiKey.slice(0, 8)}…${openaiKey.slice(-4)} (longueur ${openaiKey.length})`
    );
    _client = new OpenAI({ apiKey: openaiKey });
    return _client;
  }

  throw new Error(
    "L'assistant IA n'est pas configuré. Ajoutez LLM_BASE_URL + LLM_API_KEY (gateway interne) " +
      'ou OPENAI_API_KEY (OpenAI direct) dans server/.env.'
  );
}

export function getLLMModel(): string {
  return process.env.LLM_MODEL ?? process.env.OPENAI_MODEL ?? 'gpt-4o';
}

/** Réinitialise le client (utile en test ou si la config change à chaud). */
export function resetLLMClient(): void {
  _client = null;
}
