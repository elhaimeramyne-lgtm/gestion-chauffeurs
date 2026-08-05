import {
  LayoutDashboard,
  FolderInput,
  SlidersHorizontal,
  Wand2,
  GitCompareArrows,
  FileBarChart2,
  Smartphone,
  Landmark,
  FileText,
  FileDiff,
  Newspaper,
  Users,
  ScrollText,
  Gauge,
  ShieldAlert,
  UserCog,
  CalendarDays,
  Network,
  Truck,
  ClipboardList,
  Car,
  MapPinned,
  UserRound,
  MapIcon,
  Wrench,
  Fuel,
  AlertOctagon
} from 'lucide-react';

// Chaque item porte un `labelKey` (clé de traduction i18n) en plus de
// `label` (texte français, conservé comme repli si la clé est absente).
export const FACTURATION_ITEMS = [
  { to: '/', label: 'Tableau de bord', labelKey: 'nav.dashboard', icon: LayoutDashboard, exact: true },
  { to: '/import', label: 'Import', labelKey: 'nav.import', icon: FolderInput },
  { to: '/regles', label: 'Règles de colonnes', labelKey: 'nav.rules', icon: SlidersHorizontal },
  { to: '/correction', label: 'Correction', labelKey: 'nav.correction', icon: Wand2 },
  { to: '/comparaison', label: 'Comparaison', labelKey: 'nav.comparison', icon: GitCompareArrows },
  { to: '/rapports', label: 'Rapports', labelKey: 'nav.reports', icon: FileBarChart2 }
];

export const LIGNES_ITEM = { to: '/lignes', label: 'Gestion des lignes', labelKey: 'nav.lignes', icon: Smartphone, exact: false };
export const LIGNES_FIXES_ITEM = { to: '/lignes-fixes', label: 'Lignes fixes', labelKey: 'nav.lignesFixes', icon: Landmark, exact: false };
export const FACTURES_ITEM = { to: '/factures', label: 'Factures IAM', labelKey: 'nav.factures', icon: FileText, exact: false };
export const DIFF_ITEM = { to: '/comparaison-excel', label: 'Comparaison Excel', labelKey: 'nav.diff', icon: FileDiff, exact: false };
export const JOURNAUX_ITEM = { to: '/journaux-presse', label: 'Journal (Presse)', labelKey: 'nav.journaux', icon: Newspaper, exact: false };
export const USERS_ITEM = { to: '/utilisateurs', label: 'Utilisateurs', labelKey: 'nav.users', icon: Users, exact: false };
export const JOURNAL_ITEM = { to: '/journal', label: 'Journal & Historique', labelKey: 'nav.journal', icon: ScrollText, exact: false };
export const ADMIN_DASHBOARD_ITEM = { to: '/admin', label: 'Tableau de bord Super Admin', labelKey: 'nav.adminDashboard', icon: Gauge, exact: false };
export const ADMINISTRATION_ITEM = { to: '/administration', label: 'Administration système', labelKey: 'nav.administration', icon: ShieldAlert, exact: false };
export const MON_COMPTE_ITEM = { to: '/mon-compte', label: 'Mon compte', labelKey: 'nav.monCompte', icon: UserCog, exact: false };
export const CALENDAR_ITEM = { to: '/calendrier', label: 'Calendrier', labelKey: 'nav.calendar', icon: CalendarDays, exact: false };
export const ORGANIGRAMME_ITEM = { to: '/organigramme', label: 'Organigramme', labelKey: 'nav.organigramme', icon: Network, exact: false };
export const LOGISTIQUE_DASHBOARD_ITEM = { to: '/logistique', label: 'Tableau de bord Logistique', labelKey: 'nav.logistiqueDashboard', icon: LayoutDashboard, exact: true };
export const LOGISTIQUE_DEMANDES_ITEM = { to: '/logistique/demandes', label: 'Demandes de services', labelKey: 'nav.logistiqueDemandes', icon: ClipboardList, exact: false };
export const PARC_AUTO_ITEM = { to: '/logistique/parc-auto', label: 'Parc Automobile', labelKey: 'nav.parcAuto', icon: Car, exact: false };
export const MAINTENANCE_ITEM = { to: '/logistique/maintenance', label: 'Maintenance', labelKey: 'nav.maintenance', icon: Wrench, exact: false };
export const CARBURANT_ITEM = { to: '/logistique/carburant', label: 'Carburant', labelKey: 'nav.carburant', icon: Fuel, exact: false };
export const DECLARATIONS_ITEM = { to: '/logistique/declarations', label: 'Déclarations', labelKey: 'nav.declarations', icon: AlertOctagon, exact: false };
export const CHAUFFEURS_ITEM = { to: '/logistique/chauffeurs', label: 'Chauffeurs', labelKey: 'nav.chauffeurs', icon: UserRound, exact: false };
export const DEMANDE_CHAUFFEUR_ITEM = { to: '/logistique/demande-chauffeur', label: 'Demande Chauffeur', labelKey: 'nav.demandeChauffeur', icon: UserRound, exact: false };
export const GERER_DEMANDES_CHAUFFEUR_ITEM = { to: '/logistique/gerer-demandes-chauffeur', label: 'Gérer demandes chauffeur', labelKey: 'nav.gererDemandesChauffeur', icon: ClipboardList, exact: false };
export const DEPLACEMENTS_ITEM = { to: '/logistique/deplacements', label: 'Déplacements', labelKey: 'nav.deplacements', icon: MapPinned, exact: false };

export const ROLE_LABELS: Record<string, string> = {
  SUPER_ADMIN: 'Super administrateur',
  ADMIN: 'Administrateur',
  CHEF_DIVISION: 'Chef de Division',
  GESTIONNAIRE: 'Gestionnaire',
  USER: 'Utilisateur',
  CHAUFFEUR: 'Chauffeur'
};

export const ROLE_LABEL_KEYS: Record<string, string> = {
  SUPER_ADMIN: 'roles.superAdmin',
  ADMIN: 'roles.admin',
  CHEF_DIVISION: 'roles.chefDivision',
  GESTIONNAIRE: 'roles.gestionnaire',
  USER: 'roles.user',
  CHAUFFEUR: 'roles.chauffeur'
};

export const ROLE_TONE: Record<string, 'bad' | 'good' | 'default'> = {
  SUPER_ADMIN: 'bad',
  ADMIN: 'good',
  CHEF_DIVISION: 'good',
  GESTIONNAIRE: 'default',
  USER: 'default',
  CHAUFFEUR: 'default'
};
