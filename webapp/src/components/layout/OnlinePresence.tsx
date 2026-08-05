import { useEffect, useState } from 'react';
import { api } from '../../lib/api';
import { useAuth } from '../../context/AuthContext';
import { ROLE_LABELS } from '../../lib/navItems';

interface OnlineUser {
  id: number;
  username: string;
  displayName: string | null;
  role: string;
}

/** Widget de présence : affiche le nom de chaque utilisateur actuellement
 *  connecté (vu au cours des 90 dernières secondes). Se rafraîchit tout
 *  seul toutes les 20s. Visible par tout le monde, pas seulement les admins. */
export default function OnlinePresence({ collapsed }: { collapsed: boolean }) {
  const { user } = useAuth();
  const [online, setOnline] = useState<OnlineUser[]>([]);

  useEffect(() => {
    let cancelled = false;
    const load = () => {
      api
        .get<{ online: OnlineUser[] }>('/presence/online')
        .then((res) => {
          if (!cancelled) setOnline(res.online);
        })
        .catch(() => {});
    };
    load();
    const interval = setInterval(load, 20_000);
    return () => {
      cancelled = true;
      clearInterval(interval);
    };
  }, []);

  const nameOf = (u: OnlineUser) => u.displayName || u.username;

  if (collapsed) {
    return (
      <div
        className="flex flex-col items-center gap-1 mx-2 mb-3 py-2 rounded-xl"
        title={online.map((o) => `${nameOf(o)}${o.id === user?.id ? ' (vous)' : ''}`).join('\n') || 'Personne en ligne'}
        style={{ background: 'rgba(34,197,94,0.06)', border: '1px solid rgba(34,197,94,0.16)' }}
      >
        <span className="relative flex h-2 w-2">
          <span
            className="absolute inline-flex h-full w-full rounded-full animate-ping"
            style={{ background: 'var(--accent2)', opacity: 0.5 }}
          />
          <span className="relative inline-flex rounded-full h-2 w-2" style={{ background: 'var(--accent2)' }} />
        </span>
        <span className="text-[10px] font-mono font-semibold" style={{ color: 'var(--sidebar-text-muted)' }}>
          {online.length}
        </span>
      </div>
    );
  }

  return (
    <div
      className="mx-3 mb-3 rounded-xl p-3 text-xs"
      style={{ background: 'rgba(34,197,94,0.06)', border: '1px solid rgba(34,197,94,0.16)' }}
    >
      <div className="flex items-center gap-1.5 mb-2">
        <span className="relative flex h-1.5 w-1.5">
          <span
            className="absolute inline-flex h-full w-full rounded-full animate-ping"
            style={{ background: 'var(--accent2)', opacity: 0.5 }}
          />
          <span className="relative inline-flex rounded-full h-1.5 w-1.5" style={{ background: 'var(--accent2)' }} />
        </span>
        <span className="font-semibold" style={{ color: 'var(--sidebar-text)' }}>
          {online.length} en ligne
        </span>
      </div>

      <div className="space-y-1.5 max-h-32 overflow-y-auto">
        {online.length === 0 && <p style={{ color: 'var(--sidebar-text-muted)' }}>Personne d'autre pour l'instant</p>}
        {online.map((o) => (
          <div key={o.id} className="flex items-center gap-1.5" title={ROLE_LABELS[o.role] ?? o.role}>
            <span className="w-1.5 h-1.5 rounded-full shrink-0" style={{ background: 'var(--accent2)' }} />
            <span className="truncate" style={{ color: 'var(--sidebar-text-muted)' }}>
              {nameOf(o)}
              {o.id === user?.id && <span style={{ color: 'var(--sidebar-text-muted)' }}> (vous)</span>}
            </span>
          </div>
        ))}
      </div>
    </div>
  );
}
