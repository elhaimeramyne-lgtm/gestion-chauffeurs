/**
 * useNotifications — consomme le flux SSE /api/notifications/stream
 *
 * Reconnexion automatique exponentielle (1s → 30s) en cas de coupure.
 * lastSeenAt est persisté en localStorage — "Tout marquer lu" est immédiat
 * et survit aux reconnexions SSE.
 */
import { useCallback, useEffect, useRef, useState } from 'react';

const API_BASE = (import.meta.env.VITE_API_URL as string | undefined) ?? '/api';
const LS_KEY = 'iam_notif_lastSeenAt';

export type NotifColor = 'red' | 'green' | 'orange' | 'blue';
export type NotifKind = 'facture_echeance' | 'ligne_creee' | 'sauvegarde' | 'connexion' | 'system_error' | 'mission_assignee' | 'mission_statut';

export interface Notification {
  id: string;
  kind: NotifKind;
  color: NotifColor;
  message: string;
  createdAt: string;
}

export interface NotificationState {
  notifications: Notification[];
  unreadCount: number;
  lastSeenAt: string;
  connected: boolean;
  markRead: () => Promise<void>;
  refresh: () => void;
}

const COLOR_HEX: Record<NotifColor, string> = {
  red: '#f87171',
  green: '#34d399',
  orange: '#fbbf24',
  blue: '#22d3ee',
};
export { COLOR_HEX };

function getStoredLastSeen(): string {
  try { return localStorage.getItem(LS_KEY) ?? new Date(0).toISOString(); } catch { return new Date(0).toISOString(); }
}
function storeLastSeen(ts: string) {
  try { localStorage.setItem(LS_KEY, ts); } catch { /* ignore */ }
}

export function useNotifications(): NotificationState {
  const [notifications, setNotifications] = useState<Notification[]>([]);
  const [lastSeenAt, setLastSeenAt] = useState<string>(getStoredLastSeen);
  const [connected, setConnected] = useState(false);
  const esRef = useRef<EventSource | null>(null);
  const retryDelay = useRef(1000);
  const retryTimer = useRef<ReturnType<typeof setTimeout> | null>(null);
  const mountedRef = useRef(true);
  // lastSeenAt ref pour l'utiliser dans les callbacks sans re-créer connect
  const lastSeenRef = useRef<string>(getStoredLastSeen());

  // unreadCount calculé localement à partir des notifications et de lastSeenAt
  const unreadCount = notifications.filter(
    (n) => new Date(n.createdAt) > new Date(lastSeenAt)
  ).length;

  const connect = useCallback(() => {
    if (!mountedRef.current) return;
    try {
      const es = new EventSource(`${API_BASE}/notifications/stream`, { withCredentials: true });
      esRef.current = es;

      es.addEventListener('update', (e: MessageEvent) => {
        if (!mountedRef.current) return;
        try {
          const payload = JSON.parse(e.data) as {
            notifications: Notification[];
            unreadCount: number;
            lastSeenAt: string;
          };
          setNotifications(payload.notifications);
          // On N'écrase PAS lastSeenAt depuis le serveur — on garde celui du localStorage
          // sauf si le serveur renvoie une date plus récente
          const serverSeen = payload.lastSeenAt;
          if (new Date(serverSeen) > new Date(lastSeenRef.current)) {
            lastSeenRef.current = serverSeen;
            setLastSeenAt(serverSeen);
            storeLastSeen(serverSeen);
          }
          retryDelay.current = 1000;
          setConnected(true);
        } catch {
          // ignore malformed
        }
      });

      es.onerror = () => {
        if (!mountedRef.current) return;
        setConnected(false);
        es.close();
        retryTimer.current = setTimeout(() => {
          retryDelay.current = Math.min(retryDelay.current * 2, 30_000);
          connect();
        }, retryDelay.current);
      };
    } catch {
      setConnected(false);
    }
  }, []);

  useEffect(() => {
    mountedRef.current = true;
    connect();
    return () => {
      mountedRef.current = false;
      esRef.current?.close();
      if (retryTimer.current) clearTimeout(retryTimer.current);
    };
  }, [connect]);

  const markRead = useCallback(async () => {
    // Mise à jour locale immédiate — plus de badge même si SSE tarde
    const now = new Date().toISOString();
    lastSeenRef.current = now;
    setLastSeenAt(now);
    storeLastSeen(now);
    try {
      await fetch(`${API_BASE}/notifications/mark-read`, {
        method: 'POST',
        credentials: 'include',
        headers: { 'Content-Type': 'application/json' },
      });
    } catch {
      // ignore — l'état local est déjà correct
    }
  }, []);

  const refresh = useCallback(() => {
    esRef.current?.close();
    connect();
  }, [connect]);

  return { notifications, unreadCount, lastSeenAt, connected, markRead, refresh };
}
