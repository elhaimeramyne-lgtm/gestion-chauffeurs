import { useEffect, useState } from 'react';
import { NavLink, Link, useLocation } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import {
  Receipt, ChevronDown, ChevronLeft, ChevronRight, LogOut,
  Layers, Zap, Boxes, Settings, Truck, Moon, Sun, Download
} from 'lucide-react';
import { useApp } from '../../context/AppContext';
import { useAuth } from '../../context/AuthContext';
import { getTheme, setTheme, type Theme } from '../../lib/theme';
import OnlinePresence from './OnlinePresence';
import { FACTURATION_ITEMS, LIGNES_ITEM, LIGNES_FIXES_ITEM, FACTURES_ITEM, DIFF_ITEM, JOURNAUX_ITEM, CALENDAR_ITEM, ORGANIGRAMME_ITEM, LOGISTIQUE_DASHBOARD_ITEM, LOGISTIQUE_DEMANDES_ITEM, PARC_AUTO_ITEM, MAINTENANCE_ITEM, CARBURANT_ITEM, DECLARATIONS_ITEM, CHAUFFEURS_ITEM, DEMANDE_CHAUFFEUR_ITEM, GERER_DEMANDES_CHAUFFEUR_ITEM, DEPLACEMENTS_ITEM, USERS_ITEM, JOURNAL_ITEM, ADMIN_DASHBOARD_ITEM, ADMINISTRATION_ITEM, ROLE_LABEL_KEYS } from '../../lib/navItems';
import { useBadgeCounts } from '../../hooks/useBadgeCounts';

const COLLAPSE_KEY = 'iam-facturation:sidebarCollapsed:v2';

function NavItem({
  to, label, labelKey, icon: Icon, exact, collapsed, badge
}: {
  to: string; label: string; labelKey?: string; icon: typeof Receipt; exact?: boolean; collapsed: boolean; badge?: number;
}) {
  const { t } = useTranslation();
  const text = labelKey ? t(labelKey, label) : label;
  return (
    <NavLink
      to={to}
      end={exact}
      title={collapsed ? text : undefined}
      className={({ isActive }) =>
        `relative nav-item focus-ring ${collapsed ? 'justify-center px-0 py-2.5' : ''} ${isActive ? 'active' : ''}`
      }
    >
      {({ isActive }) => (
        <>
          <Icon size={16} style={{ flexShrink: 0, color: isActive ? 'var(--sidebar-active-text)' : 'var(--sidebar-text-muted)' }} />
          {!collapsed && <span style={{ flex: 1 }}>{text}</span>}
          {!!badge && badge > 0 && (
            <span
              style={{
                display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
                background: '#e53e3e', color: '#fff', borderRadius: '9999px',
                fontSize: 10, fontWeight: 700, lineHeight: 1,
                minWidth: 17, height: 17, padding: '0 4px',
                position: collapsed ? 'absolute' : 'relative',
                top: collapsed ? 4 : undefined, right: collapsed ? 4 : undefined,
                flexShrink: 0
              }}
            >
              {badge > 99 ? '99+' : badge}
            </span>
          )}
          {isActive && collapsed && (
            <span
              style={{
                position: 'absolute', left: 0, top: '50%', transform: 'translateY(-50%)',
                width: 3, height: '55%', background: '#fff',
                borderRadius: '0 4px 4px 0', opacity: 0.85
              }}
            />
          )}
        </>
      )}
    </NavLink>
  );
}

function NavGroup({
  icon: Icon, label, labelKey, items, collapsed, open, onToggle, badges
}: {
  icon: typeof Receipt;
  label: string;
  labelKey?: string;
  items: Array<{ to: string; label: string; labelKey?: string; icon: typeof Receipt; exact?: boolean }>;
  collapsed: boolean;
  open: boolean;
  onToggle: () => void;
  badges?: Record<string, number>;
}) {
  const { t } = useTranslation();
  const text = labelKey ? t(labelKey, label) : label;
  const location = useLocation();
  const isActive = items.some((item) =>
    item.exact ? location.pathname === item.to : location.pathname.startsWith(item.to)
  );
  const isOpen = collapsed || open;
  // Badge total du groupe (pour afficher quand collapsed)
  const totalBadge = badges ? Object.values(badges).reduce((a, b) => a + b, 0) : 0;

  return (
    <div className="mb-1">
      <button
        onClick={onToggle}
        className="focus-ring nav-item w-full transition-colors"
        style={{
          justifyContent: collapsed ? 'center' : 'space-between',
          paddingLeft: collapsed ? 0 : undefined,
          paddingRight: collapsed ? 0 : undefined,
          position: 'relative'
        }}
        title={collapsed ? text : undefined}
      >
        <span className="flex items-center gap-2.5">
          <Icon size={16} style={{ flexShrink: 0, color: isActive ? 'var(--sidebar-text)' : 'var(--sidebar-text-muted)' }} />
          {!collapsed && <span style={{ color: isActive ? 'var(--sidebar-text)' : undefined }}>{text}</span>}
        </span>
        {!collapsed && totalBadge > 0 && (
          <span style={{
            display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
            background: '#e53e3e', color: '#fff', borderRadius: '9999px',
            fontSize: 10, fontWeight: 700, minWidth: 17, height: 17, padding: '0 4px', marginRight: 4
          }}>
            {totalBadge > 99 ? '99+' : totalBadge}
          </span>
        )}
        {collapsed && totalBadge > 0 && (
          <span style={{
            position: 'absolute', top: 4, right: 4,
            display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
            background: '#e53e3e', color: '#fff', borderRadius: '9999px',
            fontSize: 9, fontWeight: 700, minWidth: 14, height: 14, padding: '0 3px'
          }}>
            {totalBadge > 9 ? '9+' : totalBadge}
          </span>
        )}
        {!collapsed && (
          <ChevronDown
            size={13}
            style={{
              color: 'var(--sidebar-text-muted)',
              transform: isOpen ? 'rotate(180deg)' : 'none',
              transition: 'transform 200ms ease'
            }}
          />
        )}
      </button>

      {isOpen && (
        <div
          className="mt-0.5 space-y-0.5 animate-fade-in"
          style={collapsed ? {} : { marginLeft: 10, paddingLeft: 10, borderLeft: '1px solid var(--sidebar-border)' }}
        >
          {items.map((item) => (
            <NavItem key={item.to} {...item} collapsed={collapsed} badge={badges?.[item.to]} />
          ))}
        </div>
      )}
    </div>
  );
}

function UserAvatar({ name }: { name: string }) {
  const initials = name.split(' ').map((n) => n[0]).join('').slice(0, 2).toUpperCase();
  return (
    <div
      className="flex items-center justify-center rounded-full text-xs font-bold shrink-0"
      style={{ width: 32, height: 32, background: 'var(--grad-brand)', color: '#fff' }}
    >
      {initials}
    </div>
  );
}

/** Bascule thème clair (défaut) / sombre — visuel calqué sur le sélecteur
 *  "Mode sombre" de la référence, toujours logé dans la sidebar sombre. */
function ThemeToggle({ collapsed }: { collapsed: boolean }) {
  const [theme, setThemeState] = useState<Theme>('light');
  useEffect(() => { setThemeState(getTheme()); }, []);

  const toggle = () => {
    const next: Theme = theme === 'dark' ? 'light' : 'dark';
    setTheme(next);
    setThemeState(next);
  };

  if (collapsed) {
    return (
      <button
        onClick={toggle}
        title={theme === 'dark' ? 'Passer en mode clair' : 'Passer en mode sombre'}
        className="focus-ring nav-item w-full justify-center"
      >
        {theme === 'dark' ? <Sun size={15} style={{ color: 'var(--sidebar-text-muted)' }} /> : <Moon size={15} style={{ color: 'var(--sidebar-text-muted)' }} />}
      </button>
    );
  }

  return (
    <button onClick={toggle} className="focus-ring w-full flex items-center justify-between px-2 py-1.5 rounded-lg transition-colors hover:bg-white/5">
      <span className="flex items-center gap-2 text-xs font-medium" style={{ color: 'var(--sidebar-text-muted)' }}>
        <Moon size={13} /> Mode sombre
      </span>
      <span
        className="relative shrink-0 rounded-full transition-colors"
        style={{ width: 34, height: 19, background: theme === 'dark' ? 'var(--grad-brand)' : 'rgba(255,255,255,0.14)' }}
      >
        <span
          className="absolute rounded-full transition-transform"
          style={{
            width: 15, height: 15, top: 2, left: 2, background: '#fff',
            transform: theme === 'dark' ? 'translateX(15px)' : 'translateX(0)'
          }}
        />
      </span>
    </button>
  );
}

export default function Sidebar() {
  const { t } = useTranslation();
  const { impayesFiles, reglementFiles, comparisonResult } = useApp();
  const { user, isAdmin, isSuperAdmin, hasMinRole, logout } = useAuth();
  const totalFiles = impayesFiles.length + reglementFiles.length;
  const badgeCounts = useBadgeCounts();

  const [collapsed, setCollapsed] = useState(false);
  // Tous les groupes du menu sont repliés par défaut — seul un clic sur la
  // flèche les ouvre (comportement demandé, pas d'ouverture automatique).
  const [openGroups, setOpenGroups] = useState<Record<string, boolean>>({
    facturation: false,
    gestion: false,
    logistique: false,
    administration: false
  });
  const toggleGroup = (key: string) =>
    setOpenGroups((prev) => ({ ...prev, [key]: !prev[key] }));

  useEffect(() => {
    try {
      const raw = localStorage.getItem(COLLAPSE_KEY);
      if (raw) setCollapsed(raw === '1');
    } catch { /* ignore */ }
  }, []);

  const toggleCollapsed = () => {
    setCollapsed((prev) => {
      const next = !prev;
      try { localStorage.setItem(COLLAPSE_KEY, next ? '1' : '0'); } catch { /* ignore */ }
      return next;
    });
  };

  return (
    <aside
      className="hidden md:flex flex-col shrink-0 relative"
      style={{
        width: collapsed ? 72 : 252,
        background: 'var(--sidebar-bg)',
        borderRight: '1px solid var(--sidebar-border)',
        boxShadow: 'var(--shadow-sidebar)',
        transition: 'width 220ms cubic-bezier(0.4,0,0.2,1)'
      }}
    >
      {/* Toggle button */}
      <button
        onClick={toggleCollapsed}
        title={collapsed ? 'Afficher le menu' : 'Réduire'}
        className="focus-ring absolute -right-3 top-7 z-10 flex h-6 w-6 items-center justify-center rounded-full transition-colors"
        style={{ background: 'var(--sidebar-bg-soft)', border: '1px solid var(--sidebar-border)', color: 'var(--sidebar-text-muted)' }}
      >
        {collapsed ? <ChevronRight size={12} /> : <ChevronLeft size={12} />}
      </button>

      {/* Logo */}
      <div
        className="shrink-0 flex flex-col"
        style={{
          padding: collapsed ? '20px 12px 18px' : '20px 18px 18px',
          borderBottom: '1px solid var(--sidebar-border)'
        }}
      >
        {collapsed ? (
          <div className="flex items-center justify-center">
            <div
              className="flex items-center justify-center rounded-xl"
              style={{ width: 36, height: 36, background: 'var(--grad-brand)', boxShadow: 'var(--glow-violet)' }}
            >
              <Zap size={17} color="#fff" strokeWidth={2.5} />
            </div>
          </div>
        ) : (
          <div className="flex items-center gap-2.5">
            <div
              className="flex items-center justify-center rounded-xl shrink-0"
              style={{ width: 36, height: 36, background: 'var(--grad-brand)', boxShadow: 'var(--glow-violet)' }}
            >
              <Zap size={17} color="#fff" strokeWidth={2.5} />
            </div>
            <div className="min-w-0">
              <p className="text-[10px] font-mono uppercase tracking-widest" style={{ color: 'var(--accent)' }}>
                Entraide Nationale
              </p>
              <p className="text-sm font-bold leading-tight" style={{ color: 'var(--sidebar-text)' }}>
                Plateforme IAM
              </p>
            </div>
          </div>
        )}
      </div>

      {/* Nav */}
      <nav className="flex-1 overflow-y-auto py-4" style={{ padding: collapsed ? '16px 8px' : '16px 10px' }}>
        <NavGroup
          icon={Layers}
          label="Facturation IAM"
          labelKey="nav.facturationGroup"
          items={FACTURATION_ITEMS}
          collapsed={collapsed}
          open={openGroups.facturation}
          onToggle={() => toggleGroup('facturation')}
        />

        {/* Separator */}
        <div style={{ height: 1, background: 'var(--sidebar-border)', margin: '8px 4px' }} />

        <NavGroup
          icon={Boxes}
          label="Gestion"
          labelKey="nav.gestionGroup"
          items={[LIGNES_ITEM, LIGNES_FIXES_ITEM, FACTURES_ITEM, DIFF_ITEM, JOURNAUX_ITEM, CALENDAR_ITEM, ORGANIGRAMME_ITEM]}
          collapsed={collapsed}
          open={openGroups.gestion}
          onToggle={() => toggleGroup('gestion')}
        />

        {/* Separator */}
        <div style={{ height: 1, background: 'var(--sidebar-border)', margin: '8px 4px' }} />

        <NavGroup
          icon={Truck}
          label="Logistique"
          labelKey="nav.logistiqueGroup"
          items={[LOGISTIQUE_DASHBOARD_ITEM, LOGISTIQUE_DEMANDES_ITEM, DEMANDE_CHAUFFEUR_ITEM, GERER_DEMANDES_CHAUFFEUR_ITEM, PARC_AUTO_ITEM, MAINTENANCE_ITEM, CARBURANT_ITEM, DECLARATIONS_ITEM, CHAUFFEURS_ITEM, DEPLACEMENTS_ITEM]}
          collapsed={collapsed}
          open={openGroups.logistique}
          onToggle={() => toggleGroup('logistique')}
          badges={{
            [DEMANDE_CHAUFFEUR_ITEM.to]: badgeCounts.demandesChauffeur,
            [GERER_DEMANDES_CHAUFFEUR_ITEM.to]: badgeCounts.demandesChauffeur,
            [DEPLACEMENTS_ITEM.to]: badgeCounts.missionsAttente,
            [DECLARATIONS_ITEM.to]: badgeCounts.declarationsNouv,
          }}
        />

        {/* Tableau de bord Executive : Gestionnaire et au-dessus (mais l'Administration reste réservée aux Admins) */}
        {!isAdmin && hasMinRole('GESTIONNAIRE') && (
          <>
            <div style={{ height: 1, background: 'var(--sidebar-border)', margin: '8px 4px' }} />
            <NavGroup
              icon={Settings}
              label="Administration"
              labelKey="nav.administrationGroup"
              items={[ADMIN_DASHBOARD_ITEM]}
              collapsed={collapsed}
              open={openGroups.administration}
              onToggle={() => toggleGroup('administration')}
            />
          </>
        )}

        {/* Admin */}
        {isAdmin && (
          <>
            <div style={{ height: 1, background: 'var(--sidebar-border)', margin: '8px 4px' }} />
            <NavGroup
              icon={Settings}
              label="Administration"
              labelKey="nav.administrationGroup"
              items={[
                ADMIN_DASHBOARD_ITEM,
                USERS_ITEM,
                JOURNAL_ITEM,
                ...(isSuperAdmin ? [ADMINISTRATION_ITEM] : [])
              ]}
              collapsed={collapsed}
              open={openGroups.administration}
              onToggle={() => toggleGroup('administration')}
            />
          </>
        )}
      </nav>

      {/* Stats */}
      {!collapsed && (
        <div
          className="text-xs space-y-2 mx-3 mb-3 rounded-xl p-3"
          style={{ background: 'var(--sidebar-card)', border: '1px solid var(--sidebar-border)' }}
        >
          <div className="flex justify-between items-center">
            <span style={{ color: 'var(--sidebar-text-muted)' }}>Fichiers importés</span>
            <span className="font-mono font-semibold" style={{ color: totalFiles > 0 ? 'var(--accent)' : 'var(--sidebar-text-muted)' }}>
              {totalFiles}
            </span>
          </div>
          <div className="flex justify-between items-center">
            <span style={{ color: 'var(--sidebar-text-muted)' }}>Dernière comparaison</span>
            <span className="font-mono" style={{ color: 'var(--sidebar-text)' }}>
              {comparisonResult
                ? new Date(comparisonResult.summary.runAt).toLocaleDateString('fr-FR')
                : '—'}
            </span>
          </div>
        </div>
      )}

      <div className="mx-3 mb-2">
        <ThemeToggle collapsed={collapsed} />
      </div>

      <OnlinePresence collapsed={collapsed} />

      {/* User */}
      <div
        className="shrink-0"
        style={{
          borderTop: '1px solid var(--sidebar-border)',
          padding: collapsed ? '10px 8px' : '10px 12px'
        }}
      >
        {collapsed ? (
          <div className="flex flex-col gap-1 items-center">
            <Link
              to="/telecharger"
              title="Télécharger le projet"
              className="focus-ring nav-item w-full justify-center"
            >
              <Download size={15} style={{ color: 'var(--sidebar-text-muted)' }} />
            </Link>
            <Link to="/mon-compte" title="Mon compte" className="focus-ring nav-item w-full justify-center">
              <Settings size={15} style={{ color: 'var(--sidebar-text-muted)' }} />
            </Link>
            <button
              onClick={logout}
              title={`${user?.displayName ?? user?.username} — Déconnexion`}
              className="focus-ring nav-item w-full justify-center"
            >
              <LogOut size={16} style={{ color: 'var(--sidebar-text-muted)' }} />
            </button>
          </div>
        ) : (
          <div className="space-y-1">
            <Link
              to="/telecharger"
              className="flex items-center gap-2 px-2 py-1.5 rounded-lg text-xs font-medium transition-colors hover:bg-white/5"
              style={{ color: 'var(--sidebar-text-muted)' }}
            >
              <Download size={13} />
              <span>Télécharger le projet</span>
            </Link>
            <div className="flex items-center gap-2.5">
              <Link to="/mon-compte" className="flex items-center gap-2.5 flex-1 min-w-0 focus-ring rounded-lg -m-1 p-1 transition-colors hover:bg-white/5" title="Mon compte">
                <UserAvatar name={user?.displayName || user?.username || '?'} />
                <div className="flex-1 min-w-0">
                  <p className="text-sm font-medium truncate" style={{ color: 'var(--sidebar-text)' }}>
                    {user?.displayName || user?.username}
                  </p>
                  <p className="text-[11px]" style={{ color: 'var(--sidebar-text-muted)' }}>
                    {user ? t(ROLE_LABEL_KEYS[user.role], user.role) : ''}
                  </p>
                </div>
              </Link>
              <button
                onClick={logout}
                title="Se déconnecter"
                className="focus-ring shrink-0 flex items-center justify-center rounded-lg transition-colors hover:bg-white/5"
                style={{ width: 32, height: 32, color: 'var(--sidebar-text-muted)' }}
              >
                <LogOut size={15} />
              </button>
            </div>
          </div>
        )}
      </div>
    </aside>
  );
}
