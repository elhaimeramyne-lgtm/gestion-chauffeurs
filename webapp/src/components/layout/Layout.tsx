import type { ReactNode } from 'react';
import { NavLink, Link, useLocation } from 'react-router-dom';
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
import { ROLE_LABEL_KEYS } from '../../lib/navItems';

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
  const location = useLocation();

  // Titre de la page courante (clé de traduction par route)
  const pageTitleKey: Record<string, string> = {
    '/': 'nav.dashboard',
    '/import': 'nav.import',
    '/regles': 'nav.rules',
    '/correction': 'nav.correction',
    '/comparaison': 'nav.comparison',
    '/rapports': 'nav.reports',
    '/lignes': 'nav.lignes',
    '/lignes-fixes': 'nav.lignesFixes',
    '/factures': 'nav.factures',
    '/comparaison-excel': 'nav.diff',
    '/journaux-presse': 'nav.journaux',
    '/utilisateurs': 'nav.users',
    '/journal': 'nav.journal',
    '/admin': 'nav.adminDashboard',
    '/administration': 'nav.administration',
    '/mon-compte': 'nav.monCompte',
    '/calendrier': 'nav.calendar'
  };
  const key = pageTitleKey[location.pathname];
  const title = key ? t(key) : '';

  return (
    <header
      className="hidden md:flex items-center justify-between shrink-0 px-6 relative"
      style={{
        height: 64,
        background: 'var(--surface)',
        backdropFilter: 'blur(18px) saturate(140%)',
        borderBottom: '1px solid var(--border)',
        zIndex: 30
      }}
    >
      <div className="flex items-center gap-2 min-w-0">
        <p className="text-base font-semibold truncate" style={{ color: 'var(--text-pri)' }}>{title}</p>
      </div>

      <div className="flex items-center gap-2.5">
        <div style={{ minWidth: 280 }}>
          <UniversalSearch />
        </div>

        <Link
          to="/calendrier"
          title={t('nav.calendar', 'Calendrier')}
          className="focus-ring flex items-center justify-center rounded-full transition-colors hover:bg-black/5"
          style={{ width: 34, height: 34, background: 'var(--glass-bg)', border: '1px solid var(--border)', color: 'var(--text-sec)' }}
        >
          <CalendarDays size={15} />
        </Link>

        <NotificationCenter />

        {/* User chip */}
        <Link
          to="/mon-compte"
          className="flex items-center gap-2 pl-1 pr-3 py-1 rounded-full text-xs transition-colors hover:bg-black/5"
          style={{ background: 'var(--glass-bg)', border: '1px solid var(--border)', color: 'var(--text-sec)' }}
        >
          <span
            className="flex items-center justify-center rounded-full text-[11px] font-bold shrink-0"
            style={{ width: 26, height: 26, background: 'var(--grad-brand)', color: '#fff' }}
          >
            {(user?.displayName || user?.username || '?').slice(0, 1).toUpperCase()}
          </span>
          <span className="font-medium" style={{ color: 'var(--text-pri)' }}>
            {user?.displayName || user?.username}
          </span>
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
