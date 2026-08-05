/**
 * Widget assistant IA flottant.
 *
 * - Branché sur /api/assistant (streaming SSE via fetch + ReadableStream)
 * - Historique de conversation dans la session (perdu à la fermeture du widget)
 * - Suggestions rapides contextuelles
 * - Gestion propre de l'état : idle | loading | streaming | error
 */
import { KeyboardEvent, useEffect, useRef, useState } from 'react';
import { Bot, X, Send, Loader2, Sparkles, ChevronDown } from 'lucide-react';

interface Message {
  role: 'user' | 'assistant';
  content: string;
}

const API_BASE = (import.meta.env.VITE_API_URL as string | undefined) ?? 'http://localhost:5000/api';

const SUGGESTIONS = [
  'Combien y a-t-il de factures impayées ce mois ?',
  'Quelles lignes mobiles n\'ont pas de titulaire ?',
  'Montre-moi les 5 dernières actions dans l\'audit.',
  'Quel est le total des dépenses du mois en cours ?',
];

function UserBubble({ text }: { text: string }) {
  return (
    <div className="flex justify-end mb-3">
      <div
        className="max-w-[85%] rounded-2xl rounded-br-sm px-3.5 py-2.5 text-sm leading-relaxed"
        style={{ background: 'var(--grad-btn)', color: '#fff' }}
      >
        {text}
      </div>
    </div>
  );
}

function AssistantBubble({ text, streaming }: { text: string; streaming?: boolean }) {
  return (
    <div className="flex justify-start mb-3 gap-2">
      <div
        className="shrink-0 flex items-center justify-center rounded-full"
        style={{ width: 26, height: 26, background: 'rgba(168,85,247,0.15)', border: '1px solid rgba(168,85,247,0.3)' }}
      >
        <Bot size={13} style={{ color: '#a855f7' }} />
      </div>
      <div
        className="max-w-[85%] rounded-2xl rounded-bl-sm px-3.5 py-2.5 text-sm leading-relaxed whitespace-pre-wrap"
        style={{ background: 'var(--bg)', border: '1px solid var(--border)', color: 'var(--text-pri)' }}
      >
        {text}
        {streaming && (
          <span
            className="inline-block ml-1 rounded-full align-middle"
            style={{ width: 6, height: 6, background: 'var(--accent)', animation: 'pulse 1s ease-in-out infinite' }}
          />
        )}
      </div>
    </div>
  );
}

export default function AssistantWidget() {
  const [open, setOpen] = useState(false);
  const [minimized, setMinimized] = useState(false);
  const [messages, setMessages] = useState<Message[]>([]);
  const [input, setInput] = useState('');
  const [status, setStatus] = useState<'idle' | 'loading' | 'streaming' | 'error'>('idle');
  const [streamingText, setStreamingText] = useState('');
  const bottomRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLTextAreaElement>(null);
  const abortRef = useRef<AbortController | null>(null);

  // Scroll vers le bas à chaque nouveau message
  useEffect(() => {
    bottomRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages, streamingText]);

  const sendMessage = async (text: string) => {
    if (!text.trim() || status === 'loading' || status === 'streaming') return;

    const userMsg: Message = { role: 'user', content: text.trim() };
    setMessages((prev) => [...prev, userMsg]);
    setInput('');
    setStatus('loading');
    setStreamingText('');

    const history = [...messages, userMsg].slice(-10).map((m) => ({ role: m.role, content: m.content }));

    abortRef.current = new AbortController();
    try {
      const resp = await fetch(`${API_BASE}/assistant/chat`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'include',
        body: JSON.stringify({ message: text.trim(), history }),
        signal: abortRef.current.signal,
      });

      if (!resp.ok) {
        const err = await resp.json().catch(() => ({ error: `Erreur ${resp.status}` }));
        throw new Error((err as { error?: string }).error ?? `Erreur ${resp.status}`);
      }

      const contentType = resp.headers.get('content-type') ?? '';

      // Réponse streaming (text/event-stream ou text/plain)
      if (resp.body && (contentType.includes('event-stream') || contentType.includes('text/'))) {
        setStatus('streaming');
        const reader = resp.body.getReader();
        const decoder = new TextDecoder();
        let accumulated = '';

        while (true) {
          const { value, done } = await reader.read();
          if (done) break;
          const chunk = decoder.decode(value, { stream: true });
          // Gère SSE "data: ..." et plain text
          const lines = chunk.split('\n');
          for (const line of lines) {
            if (line.startsWith('data: ')) {
              const data = line.slice(6);
              if (data === '[DONE]') continue;
              try {
                const parsed = JSON.parse(data) as { delta?: string; content?: string; error?: string };
                if (parsed.error) throw new Error(parsed.error);
                accumulated += parsed.delta ?? parsed.content ?? '';
              } catch {
                accumulated += data;
              }
            } else if (!line.startsWith(':') && line.trim()) {
              accumulated += line;
            }
          }
          setStreamingText(accumulated);
        }

        setMessages((prev) => [...prev, { role: 'assistant', content: accumulated || '…' }]);
        setStreamingText('');
        setStatus('idle');
      } else {
        // Réponse JSON classique
        const data = await resp.json() as { reply?: string; message?: string; error?: string };
        const reply = data.reply ?? data.message ?? JSON.stringify(data);
        setMessages((prev) => [...prev, { role: 'assistant', content: reply }]);
        setStatus('idle');
      }
    } catch (err) {
      if ((err as Error).name === 'AbortError') {
        setStatus('idle');
        return;
      }
      const msg = err instanceof Error ? err.message : 'Erreur de connexion à l\'assistant.';
      setMessages((prev) => [...prev, { role: 'assistant', content: `⚠️ ${msg}` }]);
      setStatus('error');
      setTimeout(() => setStatus('idle'), 3000);
    }
  };

  const handleKey = (e: KeyboardEvent<HTMLTextAreaElement>) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      sendMessage(input);
    }
  };

  const handleStop = () => {
    abortRef.current?.abort();
    setStreamingText('');
    setStatus('idle');
  };

  const isEmpty = messages.length === 0 && status === 'idle';

  if (!open) {
    return (
      <button
        onClick={() => setOpen(true)}
        className="fixed bottom-6 right-6 z-50 flex items-center gap-2 px-4 py-3 rounded-full font-semibold text-sm shadow-lg transition-transform hover:scale-105 focus-ring"
        style={{
          background: 'var(--grad-btn)',
          color: '#fff',
          boxShadow: '0 4px 24px rgba(139,92,246,0.45), 0 0 0 1px rgba(255,255,255,0.06) inset'
        }}
      >
        <Sparkles size={15} />
        Assistant IA
      </button>
    );
  }

  return (
    <div
      className="fixed bottom-6 right-6 z-50 flex flex-col rounded-2xl overflow-hidden shadow-2xl"
      style={{
        width: 'min(380px, calc(100vw - 32px))',
        height: minimized ? 'auto' : 'min(560px, calc(100vh - 48px))',
        background: 'var(--surface)',
        border: '1px solid var(--border)',
        backdropFilter: 'blur(20px)',
        boxShadow: '0 8px 48px rgba(0,0,0,0.6), 0 0 0 1px rgba(255,255,255,0.05) inset'
      }}
    >
      {/* Header */}
      <div
        className="flex items-center gap-2.5 px-4 py-3 shrink-0"
        style={{ borderBottom: minimized ? 'none' : '1px solid var(--border)', background: 'rgba(168,85,247,0.06)' }}
      >
        <div
          className="flex items-center justify-center rounded-full shrink-0"
          style={{ width: 30, height: 30, background: 'var(--grad-btn)', boxShadow: '0 0 12px rgba(139,92,246,0.4)' }}
        >
          <Bot size={14} color="#fff" />
        </div>
        <div className="flex-1 min-w-0">
          <p className="text-sm font-semibold" style={{ color: 'var(--text-pri)' }}>Assistant IAM</p>
          <p className="text-[11px]" style={{ color: status === 'streaming' ? 'var(--accent2)' : 'var(--text-ter)' }}>
            {status === 'loading' ? 'Réflexion…' : status === 'streaming' ? '● Répond…' : 'Posez vos questions sur vos données'}
          </p>
        </div>
        <button
          onClick={() => setMinimized((m) => !m)}
          className="focus-ring p-1.5 rounded-lg transition-colors hover:bg-[var(--card-hover)]"
          style={{ color: 'var(--text-ter)' }}
          title={minimized ? 'Agrandir' : 'Réduire'}
        >
          <ChevronDown size={14} style={{ transform: minimized ? 'rotate(180deg)' : undefined }} />
        </button>
        <button
          onClick={() => setOpen(false)}
          className="focus-ring p-1.5 rounded-lg transition-colors hover:bg-[var(--card-hover)]"
          style={{ color: 'var(--text-ter)' }}
          title="Fermer"
        >
          <X size={14} />
        </button>
      </div>

      {!minimized && (
        <>
          {/* Messages */}
          <div className="flex-1 overflow-y-auto px-4 py-4" style={{ minHeight: 0 }}>
            {isEmpty && (
              <div className="text-center py-6">
                <div
                  className="inline-flex items-center justify-center rounded-full mb-3"
                  style={{ width: 48, height: 48, background: 'rgba(168,85,247,0.12)', border: '1px solid rgba(168,85,247,0.25)' }}
                >
                  <Sparkles size={20} style={{ color: '#a855f7' }} />
                </div>
                <p className="text-sm font-medium mb-1" style={{ color: 'var(--text-pri)' }}>
                  Bonjour, comment puis-je vous aider ?
                </p>
                <p className="text-xs mb-4" style={{ color: 'var(--text-ter)' }}>
                  Posez des questions sur vos lignes, factures, utilisateurs…
                </p>
                <div className="flex flex-col gap-1.5">
                  {SUGGESTIONS.map((s) => (
                    <button
                      key={s}
                      onClick={() => sendMessage(s)}
                      className="text-left text-xs px-3 py-2 rounded-xl transition-colors focus-ring"
                      style={{
                        background: 'var(--bg)',
                        border: '1px solid var(--border)',
                        color: 'var(--text-sec)'
                      }}
                    >
                      {s}
                    </button>
                  ))}
                </div>
              </div>
            )}

            {messages.map((m, i) =>
              m.role === 'user'
                ? <UserBubble key={i} text={m.content} />
                : <AssistantBubble key={i} text={m.content} />
            )}

            {(status === 'loading' || status === 'streaming') && streamingText && (
              <AssistantBubble text={streamingText} streaming />
            )}
            {status === 'loading' && !streamingText && (
              <div className="flex items-center gap-2 mb-3">
                <div
                  className="shrink-0 flex items-center justify-center rounded-full"
                  style={{ width: 26, height: 26, background: 'rgba(168,85,247,0.15)', border: '1px solid rgba(168,85,247,0.3)' }}
                >
                  <Loader2 size={13} className="animate-spin" style={{ color: '#a855f7' }} />
                </div>
                <div className="flex gap-1 items-center">
                  {[0, 1, 2].map((i) => (
                    <span
                      key={i}
                      className="rounded-full"
                      style={{
                        width: 6, height: 6, background: 'var(--text-ter)',
                        animation: `bounce 1.2s ease-in-out infinite`,
                        animationDelay: `${i * 0.2}s`
                      }}
                    />
                  ))}
                </div>
              </div>
            )}

            <div ref={bottomRef} />
          </div>

          {/* Zone de saisie */}
          <div className="px-3 py-3 shrink-0" style={{ borderTop: '1px solid var(--border)' }}>
            <div
              className="flex items-end gap-2 rounded-xl px-3 py-2"
              style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}
            >
              <textarea
                ref={inputRef}
                value={input}
                onChange={(e) => setInput(e.target.value)}
                onKeyDown={handleKey}
                placeholder="Posez votre question… (Entrée pour envoyer)"
                rows={1}
                disabled={status === 'loading' || status === 'streaming'}
                className="flex-1 bg-transparent resize-none text-sm outline-none leading-relaxed"
                style={{
                  color: 'var(--text-pri)',
                  maxHeight: 100,
                  overflow: 'auto',
                  border: 'none',
                }}
              />
              {(status === 'loading' || status === 'streaming') ? (
                <button
                  onClick={handleStop}
                  className="focus-ring shrink-0 rounded-lg p-1.5 transition-colors"
                  style={{ background: 'rgba(239,68,68,0.1)', border: '1px solid rgba(239,68,68,0.2)', color: 'var(--accent-err)' }}
                  title="Arrêter"
                >
                  <X size={14} />
                </button>
              ) : (
                <button
                  onClick={() => sendMessage(input)}
                  disabled={!input.trim()}
                  className="focus-ring shrink-0 rounded-lg p-1.5 transition-all disabled:opacity-30"
                  style={{ background: 'var(--grad-btn)', color: '#fff', boxShadow: '0 2px 8px rgba(139,92,246,0.3)' }}
                  title="Envoyer"
                >
                  <Send size={14} />
                </button>
              )}
            </div>
            <p className="text-center text-[10px] mt-1" style={{ color: 'var(--text-ter)' }}>
              Shift+Entrée pour nouvelle ligne
            </p>
          </div>
        </>
      )}
    </div>
  );
}
