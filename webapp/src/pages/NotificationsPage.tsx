import { Bell, CheckCircle2, AlertTriangle, Info, Clock, Wifi, WifiOff } from 'lucide-react';
import { useNotifications } from '../hooks/useNotifications';

const COLOR_MAP: Record<string, { icon: typeof Info; color: string }> = {
  red:    { icon: AlertTriangle, color: '#F87171' },
  green:  { icon: CheckCircle2,  color: '#4ADE80' },
  orange: { icon: AlertTriangle, color: '#FCD34D' },
  blue:   { icon: Info,          color: '#60A5FA' },
};

export default function NotificationsPage() {
  const { notifications, unreadCount, connected, markRead, refresh } = useNotifications();

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 style={{ fontSize: 24, fontWeight: 700, color: 'var(--text-pri)' }}>Notifications</h1>
          <p style={{ fontSize: 13, color: 'var(--text-ter)', marginTop: 4 }}>
            {unreadCount > 0
              ? `${unreadCount} notification${unreadCount > 1 ? 's' : ''} non lue${unreadCount > 1 ? 's' : ''}`
              : 'Toutes les notifications sont lues'
            }
          </p>
        </div>
        <div className="flex items-center gap-3">
          {/* Indicateur connexion SSE */}
          <span
            className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg"
            style={{
              background: connected ? 'rgba(74,222,128,0.12)' : 'rgba(248,113,113,0.12)',
              border: `1px solid ${connected ? 'rgba(74,222,128,0.25)' : 'rgba(248,113,113,0.25)'}`,
              fontSize: 12,
              color: connected ? '#4ADE80' : '#F87171',
            }}
          >
            {connected ? <Wifi size={13} /> : <WifiOff size={13} />}
            {connected ? 'Connecté en temps réel' : 'Déconnecté'}
          </span>

          <button
            onClick={refresh}
            className="flex items-center gap-2 px-3 py-2 rounded-xl font-medium transition-colors hover:bg-white/5"
            style={{ background: 'rgba(255,255,255,0.06)', border: '1px solid rgba(255,255,255,0.10)', color: 'var(--text-sec)', fontSize: 13 }}
          >
            Actualiser
          </button>

          {unreadCount > 0 && (
            <button
              onClick={markRead}
              className="flex items-center gap-2 px-4 py-2 rounded-xl font-medium transition-colors hover:opacity-90"
              style={{ background: 'var(--grad-brand)', color: '#fff', fontSize: 13 }}
            >
              <CheckCircle2 size={14} />
              Tout marquer lu
            </button>
          )}
        </div>
      </div>

      <div
        className="rounded-2xl overflow-hidden"
        style={{
          background: 'rgba(255,255,255,0.05)',
          border: '1px solid rgba(255,255,255,0.09)',
          backdropFilter: 'blur(20px)',
        }}
      >
        {notifications.length === 0 ? (
          <div className="flex flex-col items-center justify-center py-16 gap-4">
            <div
              className="flex items-center justify-center rounded-2xl"
              style={{ width: 64, height: 64, background: 'rgba(76,138,255,0.12)' }}
            >
              <Bell size={28} style={{ color: 'var(--accent)' }} />
            </div>
            <p style={{ color: 'var(--text-ter)', fontSize: 14 }}>Aucune notification pour l'instant</p>
            <p style={{ color: 'var(--text-ter)', fontSize: 12 }}>
              {connected ? 'En attente d\'événements...' : 'Vérifiez la connexion au serveur'}
            </p>
          </div>
        ) : (
          <ul>
            {notifications.map((n, idx) => {
              const entry = COLOR_MAP[n.color] ?? { icon: Info, color: '#60A5FA' };
              const Icon = entry.icon;

              return (
                <li
                  key={n.id}
                  className="flex items-start gap-4 px-5 py-4 transition-colors hover:bg-white/5"
                  style={{
                    borderBottom: idx < notifications.length - 1 ? '1px solid rgba(255,255,255,0.06)' : 'none',
                  }}
                >
                  <div
                    className="flex items-center justify-center rounded-xl shrink-0 mt-0.5"
                    style={{ width: 36, height: 36, background: `${entry.color}18` }}
                  >
                    <Icon size={16} style={{ color: entry.color }} />
                  </div>
                  <div className="flex-1 min-w-0">
                    <p style={{ fontSize: 14, color: 'var(--text-pri)' }}>{n.message}</p>
                    <p style={{ fontSize: 11, color: 'var(--text-ter)', marginTop: 3 }}>
                      <span
                        className="inline-flex items-center gap-1 px-1.5 py-0.5 rounded"
                        style={{ background: 'rgba(255,255,255,0.06)', color: 'var(--text-ter)' }}
                      >
                        {n.kind.replace(/_/g, ' ')}
                      </span>
                    </p>
                  </div>
                  <div className="flex items-center gap-1.5 shrink-0">
                    <Clock size={11} style={{ color: 'var(--text-ter)' }} />
                    <span style={{ fontSize: 11, color: 'var(--text-ter)', whiteSpace: 'nowrap' }}>
                      {new Date(n.createdAt).toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' })}
                    </span>
                  </div>
                </li>
              );
            })}
          </ul>
        )}
      </div>
    </div>
  );
}
