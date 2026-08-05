import { useEffect, useRef, useState } from 'react';
import { Bell, Check, Wifi, WifiOff, RefreshCw, FileText, Smartphone, Save, UserCircle2, AlertTriangle, Car } from 'lucide-react';
import { useNotifications, COLOR_HEX } from '../../hooks/useNotifications';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
const KIND_ICON: Record<string, React.ComponentType<any>> = {
  facture_echeance: FileText,
  ligne_creee: Smartphone,
  sauvegarde: Save,
  connexion: UserCircle2,
  system_error: AlertTriangle,
  mission_assignee: Car,
};

function timeAgo(iso: string): string {
  const diffMs = Date.now() - new Date(iso).getTime();
  const min = Math.floor(diffMs / 60000);
  if (min < 1) return "à l'instant";
  if (min < 60) return `il y a ${min} min`;
  const h = Math.floor(min / 60);
  if (h < 24) return `il y a ${h} h`;
  return `il y a ${Math.floor(h / 24)} j`;
}

/** Centre de notifications temps réel via SSE.
 *  Reconnexion automatique, badge animé, indicateur de connexion. */
export default function NotificationCenter() {
  const [open, setOpen] = useState(false);
  const ref = useRef<HTMLDivElement>(null);
  const { notifications, unreadCount, connected, markRead, refresh } = useNotifications();

  // Fermer en cliquant à l'extérieur
  useEffect(() => {
    const onClickOutside = (e: MouseEvent) => {
      if (ref.current && !ref.current.contains(e.target as Node)) setOpen(false);
    };
    document.addEventListener('mousedown', onClickOutside);
    return () => document.removeEventListener('mousedown', onClickOutside);
  }, []);

  const handleOpen = () => {
    const next = !open;
    setOpen(next);
    if (next && unreadCount > 0) {
      markRead();
    }
  };

  return (
    <div className="relative" ref={ref}>
      {/* Bouton cloche */}
      <button
        onClick={handleOpen}
        title="Notifications"
        className="focus-ring relative flex items-center justify-center rounded-full transition-colors"
        style={{
          width: 34, height: 34,
          background: open ? 'rgba(99,102,241,0.10)' : 'var(--glass-bg)',
          border: `1px solid ${open ? 'rgba(99,102,241,0.35)' : 'var(--border)'}`,
          color: open ? 'var(--accent)' : 'var(--text-sec)'
        }}
      >
        <Bell size={15} />
        {unreadCount > 0 && (
          <span
            className="absolute flex items-center justify-center rounded-full text-[10px] font-bold"
            style={{
              top: -3, right: -3, minWidth: 16, height: 16, padding: '0 3px',
              background: 'var(--grad-btn)', color: 'var(--text-inv)',
              boxShadow: '0 0 8px rgba(99,102,241,0.55)',
              animation: 'pulse 2s ease-in-out infinite'
            }}
          >
            {unreadCount > 9 ? '9+' : unreadCount}
          </span>
        )}
        {/* Point vert = SSE connecté, rouge = déconnecté */}
        <span
          className="absolute rounded-full"
          style={{
            bottom: 1, right: 1, width: 6, height: 6,
            background: connected ? 'var(--accent2)' : 'var(--accent-err)',
            boxShadow: connected ? '0 0 5px #34d399' : '0 0 5px #f87171'
          }}
        />
      </button>

      {open && (
        <div
          className="absolute right-0 mt-2 z-50 animate-fade-in"
          style={{
            width: 'min(360px, calc(100vw - 24px))',
            maxHeight: 460,
            borderRadius: 16,
            boxShadow: '0 8px 40px rgba(0,0,0,0.45)',
            overflow: 'hidden',
            display: 'flex',
            flexDirection: 'column',
          }}
        >
          <div className="glass" style={{ background: 'var(--surface)', display: 'flex', flexDirection: 'column', maxHeight: 460 }}>
            {/* En-tête */}
            <div
              className="flex items-center justify-between px-4 py-3 shrink-0"
              style={{ borderBottom: '1px solid var(--border)' }}
            >
              <div className="flex items-center gap-2">
                <Bell size={14} style={{ color: 'var(--accent)' }} />
                <p className="text-sm font-semibold" style={{ color: 'var(--text-pri)' }}>Notifications</p>
                {connected
                  ? <span className="flex items-center gap-1 text-[11px]" style={{ color: 'var(--accent2)' }}><Wifi size={10} /> Temps réel</span>
                  : <span className="flex items-center gap-1 text-[11px]" style={{ color: 'var(--accent-err)' }}><WifiOff size={10} /> Hors ligne</span>
                }
              </div>
              <div className="flex items-center gap-1.5">
                {unreadCount === 0 && notifications.length > 0 && (
                  <span className="flex items-center gap-1 text-[11px]" style={{ color: 'var(--text-ter)' }}>
                    <Check size={11} /> à jour
                  </span>
                )}
                <button
                  onClick={(e) => { e.stopPropagation(); refresh(); }}
                  title="Rafraîchir"
                  className="focus-ring rounded-md p-1 transition-colors hover:bg-[var(--card-hover)]"
                  style={{ color: 'var(--text-ter)' }}
                >
                  <RefreshCw size={12} />
                </button>
              </div>
            </div>

            {/* Liste */}
            <div className="overflow-y-auto" style={{ flex: 1 }}>
              {notifications.length === 0 && (
                <p className="px-4 py-10 text-center text-sm" style={{ color: 'var(--text-ter)' }}>
                  Aucune notification récente.
                </p>
              )}
              {notifications.map((n) => {
                const Icon = KIND_ICON[n.kind] ?? Bell;
                return (
                <div
                  key={n.id}
                  className="flex items-start gap-3 px-4 py-3 transition-colors hover:bg-[var(--card-hover)]"
                  style={{ borderBottom: '1px solid var(--border)' }}
                >
                  {/* Icône type */}
                  <span
                    className="shrink-0 flex items-center justify-center rounded-lg"
                    style={{
                      width: 30, height: 30, marginTop: 1,
                      background: `linear-gradient(135deg, ${COLOR_HEX[n.color]} 0%, ${COLOR_HEX[n.color]}CC 100%)`,
                      boxShadow: `0 3px 10px -2px ${COLOR_HEX[n.color]}88`,
                      color: '#fff'
                    }}
                  >
                    <Icon size={14} />
                  </span>

                  <div className="min-w-0 flex-1">
                    <p className="text-xs leading-snug" style={{ color: 'var(--text-pri)' }}>{n.message}</p>
                    <p className="text-[11px] mt-0.5" style={{ color: 'var(--text-ter)' }}>{timeAgo(n.createdAt)}</p>
                  </div>

                  {/* Point couleur */}
                  <span
                    className="rounded-full shrink-0 mt-2"
                    style={{ width: 6, height: 6, background: COLOR_HEX[n.color], boxShadow: `0 0 6px ${COLOR_HEX[n.color]}` }}
                  />
                </div>
                );
              })}
            </div>

            {/* Pied */}
            {notifications.length > 0 && (
              <div
                className="px-4 py-2.5 text-center shrink-0"
                style={{ borderTop: '1px solid var(--border)' }}
              >
                <button
                  onClick={() => { markRead(); setOpen(false); }}
                  className="text-xs transition-colors"
                  style={{ color: 'var(--text-ter)' }}
                >
                  Tout marquer comme lu
                </button>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
}
