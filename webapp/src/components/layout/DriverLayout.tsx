/**
 * DriverLayout — layout sidebar pour le portail chauffeur.
 *
 * Structure :
 *   ┌─────────┬─────────────────────────────────────────┐
 *   │ Sidebar │  Contenu principal (section active)      │
 *   │ (icônes │                                          │
 *   │ + label)│                                          │
 *   └─────────┴─────────────────────────────────────────┘
 *
 * Sur mobile (< 640px) la sidebar devient une barre du bas (tabs).
 */
import { useState, useEffect } from 'react';
import { Map, Car, User, Bell, Settings, LogOut, Sun, Moon } from 'lucide-react';
import { useAuth } from '../../context/AuthContext';
import { getTheme, setTheme, type Theme } from '../../lib/theme';
import { useNotifications } from '../../hooks/useNotifications';

export type DriverSection = 'missions' | 'vehicule' | 'profil' | 'notifications' | 'parametres';

interface DriverNavItem {
  id: DriverSection;
  icon: typeof Map;
  label: string;
  badge?: number;
}

const NAV: DriverNavItem[] = [
  { id: 'missions',      icon: Map,      label: 'Missions' },
  { id: 'vehicule',      icon: Car,       label: 'Véhicule' },
  { id: 'notifications', icon: Bell,      label: 'Alertes' },
  { id: 'profil',        icon: User,      label: 'Profil' },
  { id: 'parametres',    icon: Settings,  label: 'Paramètres' },
];

interface Props {
  children: (section: DriverSection) => React.ReactNode;
}

export default function DriverLayout({ children }: Props) {
  const { user, logout } = useAuth();
  const [active, setActive] = useState<DriverSection>('missions');
  const [theme, setThemeState] = useState<Theme>('light');
  const { unreadCount } = useNotifications();

  useEffect(() => { setThemeState(getTheme()); }, []);

  const toggleTheme = () => {
    const next: Theme = theme === 'dark' ? 'light' : 'dark';
    setTheme(next);
    setThemeState(next);
  };

  const navItems: DriverNavItem[] = NAV.map((n) => ({
    ...n,
    badge: n.id === 'notifications' ? unreadCount : undefined,
  }));

  return (
    <div
      className="min-h-screen flex"
      style={{ background: 'var(--bg)' }}
    >
      {/* ── Sidebar gauche (desktop) ── */}
      <aside
        className="hidden sm:flex flex-col shrink-0"
        style={{
          width: 72,
          background: 'var(--sidebar-bg)',
          borderRight: '1px solid var(--sidebar-border)',
          position: 'sticky',
          top: 0,
          height: '100vh',
          overflowY: 'auto',
        }}
      >
        {/* Logo / Nom */}
        <div
          className="flex flex-col items-center py-4 gap-0.5"
          style={{ borderBottom: '1px solid var(--sidebar-border)' }}
        >
          <div
            className="flex items-center justify-center rounded-full text-xs font-bold"
            style={{ width: 34, height: 34, background: 'var(--grad-brand)', color: '#fff', fontSize: 13 }}
          >
            {(user?.displayName ?? user?.username ?? 'C').slice(0, 1).toUpperCase()}
          </div>
          <span
            className="text-[9px] font-semibold text-center leading-tight mt-1"
            style={{ color: 'var(--sidebar-text-muted)', maxWidth: 62 }}
          >
            Portail<br />Chauffeur
          </span>
        </div>

        {/* Nav items */}
        <nav className="flex flex-col items-center gap-1 py-3 flex-1">
          {navItems.map((item) => {
            const Icon = item.icon;
            const isActive = active === item.id;
            return (
              <button
                key={item.id}
                onClick={() => setActive(item.id)}
                title={item.label}
                className="relative flex flex-col items-center gap-1 rounded-xl transition-colors w-14 py-2"
                style={{
                  background: isActive ? 'rgba(255,255,255,0.12)' : 'transparent',
                  color: isActive ? 'var(--sidebar-text)' : 'var(--sidebar-text-muted)',
                }}
              >
                <Icon size={18} />
                <span style={{ fontSize: 9, fontWeight: 600, lineHeight: 1 }}>{item.label}</span>
                {!!item.badge && item.badge > 0 && (
                  <span
                    style={{
                      position: 'absolute', top: 4, right: 6,
                      display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
                      background: '#e53e3e', color: '#fff', borderRadius: '9999px',
                      fontSize: 9, fontWeight: 700, minWidth: 14, height: 14, padding: '0 3px',
                    }}
                  >
                    {item.badge > 9 ? '9+' : item.badge}
                  </span>
                )}
              </button>
            );
          })}
        </nav>

        {/* Footer sidebar */}
        <div
          className="flex flex-col items-center gap-2 py-3"
          style={{ borderTop: '1px solid var(--sidebar-border)' }}
        >
          <button
            onClick={toggleTheme}
            title={theme === 'dark' ? 'Mode clair' : 'Mode sombre'}
            className="flex flex-col items-center gap-1 w-14 py-2 rounded-xl transition-colors"
            style={{ color: 'var(--sidebar-text-muted)' }}
          >
            {theme === 'dark' ? <Sun size={16} /> : <Moon size={16} />}
            <span style={{ fontSize: 9, fontWeight: 600 }}>{theme === 'dark' ? 'Clair' : 'Sombre'}</span>
          </button>
          <button
            onClick={() => logout()}
            title="Se déconnecter"
            className="flex flex-col items-center gap-1 w-14 py-2 rounded-xl transition-colors"
            style={{ color: 'var(--sidebar-text-muted)' }}
          >
            <LogOut size={16} />
            <span style={{ fontSize: 9, fontWeight: 600 }}>Quitter</span>
          </button>
        </div>
      </aside>

      {/* ── Contenu principal ── */}
      <div className="flex-1 min-w-0 flex flex-col pb-16 sm:pb-0">
        {children(active)}
      </div>

      {/* ── Bottom tabs (mobile) ── */}
      <nav
        className="sm:hidden fixed bottom-0 inset-x-0 flex items-center justify-around"
        style={{
          background: 'var(--sidebar-bg)',
          borderTop: '1px solid var(--sidebar-border)',
          zIndex: 50,
          height: 58,
        }}
      >
        {navItems.map((item) => {
          const Icon = item.icon;
          const isActive = active === item.id;
          return (
            <button
              key={item.id}
              onClick={() => setActive(item.id)}
              className="relative flex flex-col items-center gap-0.5 flex-1 py-2"
              style={{ color: isActive ? 'var(--sidebar-text)' : 'var(--sidebar-text-muted)' }}
            >
              <Icon size={18} />
              <span style={{ fontSize: 9, fontWeight: 600 }}>{item.label}</span>
              {!!item.badge && item.badge > 0 && (
                <span
                  style={{
                    position: 'absolute', top: 6, right: 'calc(50% - 18px)',
                    display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
                    background: '#e53e3e', color: '#fff', borderRadius: '9999px',
                    fontSize: 9, fontWeight: 700, minWidth: 14, height: 14, padding: '0 3px',
                  }}
                >
                  {item.badge > 9 ? '9+' : item.badge}
                </span>
              )}
            </button>
          );
        })}
      </nav>
    </div>
  );
}
