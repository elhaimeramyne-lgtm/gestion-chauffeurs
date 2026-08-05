import type { ReactNode } from 'react';
import { NavLink, Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import {
  LayoutDashboard, FolderInput, SlidersHorizontal, Wand2,
  GitCompareArrows, FileBarChart2, Smartphone, CalendarDays
} from 'lucide-react';
import Sidebar from './Sidebar';
import MobileHeader from './MobileHeader';
import AnimatedBackground from './AnimatedBackground';
import NotificationCenter from './NotificationCenter';
import UniversalSearch from './UniversalSearch';
import AssistantWidget from '../assistant/AssistantWidget';
import { useAuth } from '../../context/AuthContext';

const MOBILE_NAV = [
  { to: '/', icon: LayoutDashboard, exact: true, label: 'Accueil', labelKey: 'nav.dashboard' },
  { to: '/import', icon: FolderInput, label: 'Import', labelKey: 'nav.import' },
  { to: '/regles', icon: SlidersHorizontal, label: 'Règles', labelKey: 'nav.rules' },
  { to: '/correction', icon: Wand2, label: 'Correction', labelKey: 'nav.correction' },
  { to: '/comparaison', icon: GitCompareArrows, label: 'Comparer', labelKey: 'nav.comparison' },
  { to: '/rapports', icon: FileBarChart2, label: 'Rapports', labelKey: 'nav.reports' },
  { to: '/lignes', icon: Smartphone, label: 'Lignes', labelKey: 'nav.lignes' }
];

function DesktopTopBar() {
  const { t } = useTranslation();
  const { user } = useAuth();

  const initials = (user?.displayName || user?.username || '?')
    .split(' ').map((n: string) => n[0]).join('').slice(0, 2).toUpperCase();

  return (
    <header
      className="hidden md:flex items-center justify-between shrink-0 px-6 relative"
      style={{
        height: 64,
        background: 'rgba(11,21,53,0.85)',
        backdropFilter: 'blur(20px) saturate(150%)',
        borderBottom: '1px solid rgba(255,255,255,0.08)',
        zIndex: 30
      }}
    >
      {/* Left — hamburger (decoratif) */}
      <div className="flex items-center gap-3">
        <button
          className="flex items-center justify-center rounded-lg transition-colors hover:bg-white/5"
          style={{ width: 36, height: 36, color: 'var(--text-sec)' }}
        >
          <svg width="16" height="12" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round">
            <line x1="0" y1="1" x2="16" y2="1"/>
            <line x1="0" y1="6" x2="12" y2="6"/>
            <line x1="0" y1="11" x2="16" y2="11"/>
          </svg>
        </button>

        {/* Search pill — exactement comme la maquette */}
        <div style={{ minWidth: 300 }}>
          <UniversalSearch />
        </div>
      </div>

      {/* Right */}
      <div className="flex items-center gap-2">
        {/* Cloche notifications */}
        <NotificationCenter />

        {/* Mail icon */}
        <button
          className="focus-ring flex items-center justify-center rounded-full transition-colors hover:bg-white/6"
          style={{ width: 36, height: 36, background: 'rgba(255,255,255,0.06)', border: '1px solid rgba(255,255,255,0.10)', color: 'var(--text-sec)' }}
          title="Messages"
        >
          <svg width="16" height="14" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" viewBox="0 0 16 14">
            <rect x="1" y="1" width="14" height="12" rx="2"/>
            <polyline points="1,3 8,8.5 15,3"/>
          </svg>
        </button>

        {/* Fullscreen icon */}
        <button
          className="focus-ring flex items-center justify-center rounded-full transition-colors hover:bg-white/6"
          style={{ width: 36, height: 36, background: 'rgba(255,255,255,0.06)', border: '1px solid rgba(255,255,255,0.10)', color: 'var(--text-sec)' }}
          title="Plein écran"
          onClick={() => { if (!document.fullscreenElement) document.documentElement.requestFullscreen(); else document.exitFullscreen(); }}
        >
          <CalendarDays size={14} />
        </button>

        {/* Divider */}
        <div style={{ width: 1, height: 24, background: 'rgba(255,255,255,0.10)', margin: '0 4px' }} />

        {/* Avatar + nom */}
        <Link
          to="/mon-compte"
          className="flex items-center gap-2.5 focus-ring rounded-xl px-2 py-1.5 transition-colors hover:bg-white/5"
        >
          <div
            className="flex items-center justify-center rounded-full font-bold shrink-0"
            style={{ width: 34, height: 34, background: 'var(--grad-brand)', color: '#fff', fontSize: 13 }}
          >
            {initials}
          </div>
          <div className="text-right">
            <p className="font-semibold leading-tight" style={{ fontSize: 13, color: 'var(--text-pri)' }}>
              {user?.displayName || user?.username}
            </p>
            <p style={{ fontSize: 11, color: 'var(--text-ter)' }}>Administrateur</p>
          </div>
          <svg width="14" height="14" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" style={{ color: 'var(--text-ter)' }}>
            <polyline points="3,5 7,9 11,5"/>
          </svg>
        </Link>
      </div>
    </header>
  );
}

export default function Layout({ children }: { children: ReactNode }) {
  const { t } = useTranslation();
  return (
    <div className="flex min-h-screen" style={{ background: 'transparent' }}>
      <AnimatedBackground />
      <AssistantWidget />
      <Sidebar />

      <div className="flex-1 flex flex-col min-w-0">
        <MobileHeader />
        <DesktopTopBar />

        <main
          className="flex-1 overflow-auto pb-24 md:pb-8"
          style={{ padding: '28px 24px' }}
        >
          <div className="max-w-6xl mx-auto w-full">
            {children}
          </div>
        </main>
      </div>

      {/* Mobile bottom nav */}
      <nav
        className="md:hidden fixed bottom-0 inset-x-0 flex justify-around"
        style={{
          background: 'var(--surface)',
          backdropFilter: 'blur(20px) saturate(140%)',
          borderTop: '1px solid var(--border)',
          paddingBottom: 'env(safe-area-inset-bottom)'
        }}
      >
        {MOBILE_NAV.map(({ to, icon: Icon, exact, label, labelKey }) => (
          <NavLink
            key={to}
            to={to}
            end={exact}
            aria-label={labelKey ? t(labelKey, label) : label}
            className="focus-ring flex flex-col items-center justify-center gap-0.5 min-w-[44px] min-h-[52px] px-1.5 transition-colors"
          >
            {({ isActive }) => (
              <Icon size={19} style={{ color: isActive ? 'var(--accent)' : 'var(--text-ter)' }} />
            )}
          </NavLink>
        ))}
      </nav>
    </div>
  );
}
