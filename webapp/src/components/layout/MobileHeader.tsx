import { useLocation } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import NotificationCenter from './NotificationCenter';
import { useAuth } from '../../context/AuthContext';

/** Barre supérieure visible uniquement sur mobile (le Sidebar desktop est
 *  masqué en dessous de md, la navigation se fait via le bottom nav de
 *  Layout.tsx). Reprend le même mapping titre de page que DesktopTopBar. */
const PAGE_TITLE_KEY: Record<string, string> = {
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

export default function MobileHeader() {
  const { t } = useTranslation();
  const { user } = useAuth();
  const location = useLocation();

  const key = PAGE_TITLE_KEY[location.pathname];
  const title = key ? t(key) : 'IAM';

  return (
    <header
      className="md:hidden flex items-center justify-between shrink-0 px-4 sticky top-0"
      style={{
        height: 56,
        background: 'var(--surface)',
        backdropFilter: 'blur(18px) saturate(140%)',
        borderBottom: '1px solid var(--border)',
        zIndex: 30
      }}
    >
      <p className="text-sm font-semibold truncate" style={{ color: 'var(--text-pri)' }}>{title}</p>

      <div className="flex items-center gap-2">
        <NotificationCenter />
        <span
          className="flex items-center justify-center rounded-full text-[11px] font-bold shrink-0"
          style={{ width: 28, height: 28, background: 'var(--grad-brand)', color: '#fff' }}
        >
          {(user?.displayName || user?.username || '?').slice(0, 1).toUpperCase()}
        </span>
      </div>
    </header>
  );
}
