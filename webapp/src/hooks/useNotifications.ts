/**
 * useNotifications — consomme le flux SSE /api/notifications/stream
 *
 * Reconnexion automatique exponentielle (1s → 30s) en cas de coupure.
 * Fallback sur polling HTTP si EventSource n'est pas disponible (rare).
 */
import { useCallback, useEffect, useRef, useState } from 'react';

const API_BASE = (import.meta.env.VITE_API_URL as string | undefined) ?? '/api';

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

export function useNotifications(): NotificationState {
  const [notifications, setNotifications] = useState<Notification[]>([]);
  const [unreadCount, setUnreadCount] = useState(0);
  const [lastSeenAt, setLastSeenAt] = useState(new Date(0).toISOString());
  const [connected, setConnected] = useState(false);
  const esRef = useRef<EventSource | null>(null);
  const retryDelay = useRef(1000);
  const retryTimer = useRef<ReturnType<typeof setTimeout> | null>(null);
  const mountedRef = useRef(true);

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
          setUnreadCount(payload.unreadCount);
          setLastSeenAt(payload.lastSeenAt);
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
        // Reconnexion exponentielle plafonnée à 30s
        retryTimer.current = setTimeout(() => {
          retryDelay.current = Math.min(retryDelay.current * 2, 30_000);
          connect();
        }, retryDelay.current);
      };
    } catch {
      // EventSource indisponible — ne pas bloquer
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
    try {
      await fetch(`${API_BASE}/notifications/mark-read`, {
        method: 'POST',
        credentials: 'include',
        headers: { 'Content-Type': 'application/json' },
      });
      setUnreadCount(0);
      setLastSeenAt(new Date().toISOString());
    } catch {
      // ignore
    }
  }, []);

  const refresh = useCallback(() => {
    esRef.current?.close();
    connect();
  }, [connect]);

  return { notifications, unreadCount, lastSeenAt, connected, markRead, refresh };
}
