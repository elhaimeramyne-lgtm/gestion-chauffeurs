import { useEffect, useState } from 'react';
import { NavLink, Link, useLocation } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import {
  Receipt, ChevronDown, ChevronLeft, ChevronRight, LogOut,
  Layers, Zap, Boxes, Settings, Truck, Moon, Sun, Download,
  LayoutDashboard, ClipboardList, Users, Car, ParkingSquare,
  Wrench, Fuel, FileText, Bell, BookOpen, Cog, UserCog, Shield
} from 'lucide-react';
import { useApp } from '../../context/AppContext';
import { useAuth } from '../../context/AuthContext';
import { getTheme, setTheme, type Theme } from '../../lib/theme';
import OnlinePresence from './OnlinePresence';
import {
  FACTURATION_ITEMS, LIGNES_ITEM, LIGNES_FIXES_ITEM, FACTURES_ITEM, DIFF_ITEM,
  JOURNAUX_ITEM, CALENDAR_ITEM, ORGANIGRAMME_ITEM,
  LOGISTIQUE_DASHBOARD_ITEM, LOGISTIQUE_DEMANDES_ITEM, PARC_AUTO_ITEM,
  MAINTENANCE_ITEM, CARBURANT_ITEM, DECLARATIONS_ITEM, CHAUFFEURS_ITEM,
  DEMANDE_CHAUFFEUR_ITEM, GERER_DEMANDES_CHAUFFEUR_ITEM, DEPLACEMENTS_ITEM,
  USERS_ITEM, JOURNAL_ITEM, ADMIN_DASHBOARD_ITEM, ADMINISTRATION_ITEM,
  ROLE_LABEL_KEYS
} from '../../lib/navItems';
import { useBadgeCounts } from '../../hooks/useBadgeCounts';

const COLLAPSE_KEY = 'iam-facturation:sidebarCollapsed:v2';

/* ─── Icon color mapping for menu items ─── */
const ICON_COLORS: Record<string, string> = {
  '/logistique': '#4C8AFF',
  '/logistique/demandes': '#60A5FA',
  '/logistique/deplacements': '#A78BFA',
  '/logistique/chauffeurs': '#C084FC',
  '/logistique/parc-auto': '#34D399',
  '/logistique/maintenance': '#FCD34D',
  '/logistique/carburant': '#F97316',
  '/logistique/declarations': '#F87171',
  '/logistique/gerer-demandes-chauffeur': '#FB923C',
  '/logistique/notifications': '#22D3EE',
  '/logistique/demande-chauffeur': '#C084FC',
  '/admin': '#34D399',
  '/journal': '#FCD34D',
  '/utilisateurs': '#A78BFA',
  '/administration': '#F97316',
};

function NavItem({
  to, label, labelKey, icon: Icon, exact, collapsed, badge
}: {
  to: string; label: string; labelKey?: string; icon: typeof Receipt; exact?: boolean; collapsed: boolean; badge?: number;
}) {
  const { t } = useTranslation();
  const text = labelKey ? t(labelKey, label) : label;
  const iconColor = ICON_COLORS[to] ?? 'var(--sidebar-text-muted)';

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
          <span
            className="flex items-center justify-center rounded-lg shrink-0"
            style={{
              width: 28, height: 28,
              background: isActive ? 'rgba(76,138,255,0.18)' : 'rgba(255,255,255,0.06)',
              color: isActive ? '#fff' : iconColor,
              transition: 'all 0.2s',
            }}
          >
            <Icon size={14} />
          </span>
          {!collapsed && <span style={{ flex: 1, fontSize: 13 }}>{text}</span>}
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
                width: 3, height: '55%', background: '#4C8AFF',
                borderRadius: '0 4px 4px 0'
              }}
            />
          )}
        </>
      )}
    </NavLink>
  );
}

function SectionLabel({ label, collapsed }: { label: string; collapsed: boolean }) {
  if (collapsed) return null;
  return (
    <p
      className="px-3 mb-1 mt-3"
      style={{ fontSize: 10, fontWeight: 700, textTransform: 'uppercase', letterSpacing: '0.1em', color: 'var(--sidebar-text-muted)' }}
    >
      {label}
    </p>
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
  const totalBadge = badges ? Object.values(badges).reduce((a, b) => a + b, 0) : 0;
  const iconColor = ICON_COLORS[items[0]?.to] ?? 'var(--sidebar-text-muted)';

  return (
    <div className="mb-0.5">
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
        <span className="flex items-center gap-2">
          <span
            className="flex items-center justify-center rounded-lg shrink-0"
            style={{
              width: 28, height: 28,
              background: isActive ? 'rgba(76,138,255,0.18)' : 'rgba(255,255,255,0.06)',
              color: isActive ? '#4C8AFF' : iconColor,
            }}
          >
            <Icon size={14} />
          </span>
          {!collapsed && <span style={{ color: isActive ? 'var(--sidebar-text)' : undefined, fontSize: 13 }}>{text}</span>}
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
            size={12}
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
          style={collapsed ? {} : { marginLeft: 10, paddingLeft: 10, borderLeft: '1px solid rgba(255,255,255,0.08)' }}
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
      style={{ width: 32, height: 32, background: 'var(--grad-brand)', color: '#fff', fontSize: 11 }}
    >
      {initials}
    </div>
  );
}

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
        {theme === 'dark'
          ? <Sun size={14} style={{ color: 'var(--sidebar-text-muted)' }} />
          : <Moon size={14} style={{ color: 'var(--sidebar-text-muted)' }} />
        }
      </button>
    );
  }

  return (
    <button onClick={toggle} className="focus-ring w-full flex items-center justify-between px-2 py-1.5 rounded-lg transition-colors hover:bg-white/5">
      <span className="flex items-center gap-2 text-xs font-medium" style={{ color: 'var(--sidebar-text-muted)' }}>
        <Moon size={12} /> Mode sombre
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
  const [openGroups, setOpenGroups] = useState<Record<string, boolean>>({
    facturation: false,
    gestion: false,
    logistique: true,
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
        {collapsed ? <ChevronRight size={11} /> : <ChevronLeft size={11} />}
      </button>

      {/* Logo — bouclier style maquette */}
      <div
        className="shrink-0 flex flex-col"
        style={{
          padding: collapsed ? '18px 12px 16px' : '18px 16px 16px',
          borderBottom: '1px solid var(--sidebar-border)'
        }}
      >
        {collapsed ? (
          <div className="flex items-center justify-center">
            <div
              className="flex items-center justify-center rounded-xl"
              style={{ width: 36, height: 36, background: 'var(--grad-brand)', boxShadow: '0 4px 16px rgba(76,138,255,0.45)' }}
            >
              <Shield size={17} color="#fff" strokeWidth={2.5} />
            </div>
          </div>
        ) : (
          <div className="flex items-center gap-3">
            <div
              className="flex items-center justify-center rounded-xl shrink-0"
              style={{ width: 38, height: 38, background: 'var(--grad-brand)', boxShadow: '0 4px 16px rgba(76,138,255,0.45)' }}
            >
              <Shield size={18} color="#fff" strokeWidth={2.5} />
            </div>
            <div className="min-w-0">
              <p className="font-bold leading-tight" style={{ fontSize: 11, color: '#fff', letterSpacing: '-0.01em' }}>
                GESTION D'INTERVENTION
              </p>
              <p className="text-[10px] leading-tight" style={{ color: 'var(--sidebar-text-muted)' }}>
                Service Logistique & Moyens Généraux
              </p>
            </div>
          </div>
        )}
      </div>

      {/* Nav */}
      <nav className="flex-1 overflow-y-auto" style={{ padding: collapsed ? '12px 8px' : '12px 10px' }}>

        {/* Menu principal logistique */}
        <SectionLabel label="Menu Principal" collapsed={collapsed} />

        <NavItem
          to="/logistique"
          label="Tableau de bord"
          icon={LayoutDashboard}
          exact
          collapsed={collapsed}
        />
        <NavItem
          to="/logistique/demandes"
          label="Demandes chauffeur"
          icon={ClipboardList}
          collapsed={collapsed}
          badge={badgeCounts.demandesChauffeur}
        />
        <NavItem
          to="/logistique/deplacements"
          label="Ordres de mission"
          icon={Truck}
          collapsed={collapsed}
          badge={badgeCounts.missionsAttente}
        />
        <NavItem
          to="/logistique/chauffeurs"
          label="Chauffeurs"
          icon={Users}
          collapsed={collapsed}
        />
        <NavItem
          to="/logistique/parc-auto"
          label="Parc automobile"
          icon={Car}
          collapsed={collapsed}
        />
        <NavItem
          to="/logistique/maintenance"
          label="Maintenance"
          icon={Wrench}
          collapsed={collapsed}
        />
        <NavItem
          to="/logistique/carburant"
          label="Carburant & Entretien"
          icon={Fuel}
          collapsed={collapsed}
        />
        <NavItem
          to="/logistique/declarations"
          label="Déclarations"
          icon={Receipt}
          collapsed={collapsed}
          badge={badgeCounts.declarationsNouv}
        />
        <NavItem
          to="/logistique/gerer-demandes-chauffeur"
          label="Gérer les demandes"
          icon={FileText}
          collapsed={collapsed}
        />
        <NavItem
          to="/logistique/notifications"
          label="Notifications"
          icon={Bell}
          collapsed={collapsed}
        />

        {/* Séparateur */}
        <div style={{ height: 1, background: 'var(--sidebar-border)', margin: '10px 4px' }} />

        {/* Groupes Facturation & Gestion */}
        <SectionLabel label="Autres modules" collapsed={collapsed} />
        <NavGroup
          icon={Layers}
          label="Facturation IAM"
          labelKey="nav.facturationGroup"
          items={FACTURATION_ITEMS}
          collapsed={collapsed}
          open={openGroups.facturation}
          onToggle={() => toggleGroup('facturation')}
        />
        <NavGroup
          icon={Boxes}
          label="Gestion"
          labelKey="nav.gestionGroup"
          items={[LIGNES_ITEM, LIGNES_FIXES_ITEM, FACTURES_ITEM, DIFF_ITEM, JOURNAUX_ITEM, CALENDAR_ITEM, ORGANIGRAMME_ITEM]}
          collapsed={collapsed}
          open={openGroups.gestion}
          onToggle={() => toggleGroup('gestion')}
        />

        {/* Administration — GESTIONNAIRE */}
        {!isAdmin && hasMinRole('GESTIONNAIRE') && (
          <>
            <div style={{ height: 1, background: 'var(--sidebar-border)', margin: '8px 4px' }} />
            <SectionLabel label="Administration" collapsed={collapsed} />
            <NavItem to="/admin" label="Tableau admin" icon={BookOpen} collapsed={collapsed} />
            <NavItem to="/utilisateurs" label="Utilisateurs & Rôles" icon={UserCog} collapsed={collapsed} />
          </>
        )}

        {/* Administration — ADMIN */}
        {isAdmin && (
          <>
            <div style={{ height: 1, background: 'var(--sidebar-border)', margin: '8px 4px' }} />
            <SectionLabel label="Administration" collapsed={collapsed} />
            <NavItem to="/admin" label="Tableau admin" icon={BookOpen} collapsed={collapsed} />
            <NavItem to="/journal" label="Journal d'activité" icon={Cog} collapsed={collapsed} />
            <NavItem to="/utilisateurs" label="Utilisateurs & Rôles" icon={UserCog} collapsed={collapsed} />
            {isSuperAdmin && (
              <NavItem to="/administration" label="Super Admin" icon={Settings} collapsed={collapsed} />
            )}
          </>
        )}
      </nav>

      {/* Copyright footer */}
      {!collapsed && (
        <div className="px-4 py-2 text-center" style={{ color: 'var(--sidebar-text-muted)', fontSize: 10, borderTop: '1px solid var(--sidebar-border)' }}>
          © 2025 — Tous droits réservés
        </div>
      )}

      <div className="mx-3 mb-1">
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
              <Download size={14} style={{ color: 'var(--sidebar-text-muted)' }} />
            </Link>
            <button
              onClick={logout}
              title={`${user?.displayName ?? user?.username} — Déconnexion`}
              className="focus-ring nav-item w-full justify-center"
            >
              <LogOut size={14} style={{ color: 'var(--sidebar-text-muted)' }} />
            </button>
          </div>
        ) : (
          <div className="space-y-1">
            <div className="flex items-center gap-2.5">
              <Link to="/mon-compte" className="flex items-center gap-2.5 flex-1 min-w-0 focus-ring rounded-lg -m-1 p-1 transition-colors hover:bg-white/5" title="Mon compte">
                <UserAvatar name={user?.displayName || user?.username || '?'} />
                <div className="flex-1 min-w-0">
                  <p className="font-semibold truncate" style={{ fontSize: 13, color: 'var(--sidebar-text)' }}>
                    {user?.displayName || user?.username}
                  </p>
                  <p style={{ fontSize: 11, color: 'var(--sidebar-text-muted)' }}>
                    {user ? t(ROLE_LABEL_KEYS[user.role], user.role) : ''}
                  </p>
                </div>
              </Link>
              <button
                onClick={logout}
                title="Se déconnecter"
                className="focus-ring shrink-0 flex items-center justify-center rounded-lg transition-colors hover:bg-white/5"
                style={{ width: 30, height: 30, color: 'var(--sidebar-text-muted)' }}
              >
                <LogOut size={14} />
              </button>
            </div>
          </div>
        )}
      </div>
    </aside>
  );
}
