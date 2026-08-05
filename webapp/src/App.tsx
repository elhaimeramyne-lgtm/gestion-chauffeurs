import { useState } from 'react';
import { Route, Routes } from 'react-router-dom';
import Layout from './components/layout/Layout';
import SplashScreen from './components/layout/SplashScreen';
import LoginPage from './pages/LoginPage';
import UsersPage from './pages/UsersPage';
import JournalPage from './pages/JournalPage';
import SuperAdminDashboard from './pages/SuperAdminDashboard';
import AdministrationPage from './pages/AdministrationPage';
import MonComptePage from './pages/MonComptePage';
import Dashboard from './pages/Dashboard';
import ImportPage from './pages/ImportPage';
import RulesPage from './pages/RulesPage';
import CorrectionPage from './pages/CorrectionPage';
import ComparisonPage from './pages/ComparisonPage';
import ReportsPage from './pages/ReportsPage';
import LignesPage from './pages/LignesPage';
import LignesFixesPage from './pages/LignesFixesPage';
import FacturesPage from './pages/FacturesPage';
import DiffPage from './pages/DiffPage';
import CalendarPage from './pages/CalendarPage';
import JournauxPage from './pages/JournauxPage';
import OrganigrammePage from './pages/OrganigrammePage';
import LogistiqueDashboardPage from './pages/LogistiqueDashboardPage';
import LogistiqueDemandesPage from './pages/LogistiqueDemandesPage';
import ParcAutoPage from './pages/ParcAutoPage';
import MaintenancePage from './pages/MaintenancePage';
import CarburantPage from './pages/CarburantPage';
import DeclarationsPage from './pages/DeclarationsPage';
import ChauffeursPage from './pages/ChauffeursPage';
import DemandeChauffeurPage from './pages/DemandeChauffeurPage';
import GererDemandesChauffeurPage from './pages/GererDemandesChauffeurPage';
import DeplacementsPage from './pages/DeplacementsPage';
import ChauffeurPortalPage from './pages/ChauffeurPortalPage';
import MaMissionPage from './pages/MaMissionPage';
import DriverLayout from './components/layout/DriverLayout';
import DownloadPage from './pages/DownloadPage';
import { useAuth } from './context/AuthContext';

// Clé sessionStorage pour ne montrer le splash qu'une seule fois par session
// (pas à chaque actualisation de page).
const SPLASH_DONE_KEY = 'iam_splash_done';

export default function App() {
  const [showSplash, setShowSplash] = useState(() => {
    try {
      return sessionStorage.getItem(SPLASH_DONE_KEY) !== '1';
    } catch {
      return true;
    }
  });
  const { user, checked, isAdmin, isSuperAdmin, isChauffeur, hasMinRole } = useAuth();

  const handleSplashDone = () => {
    try {
      sessionStorage.setItem(SPLASH_DONE_KEY, '1');
    } catch {
      // sessionStorage non disponible (mode privé très restrictif) : ok
    }
    setShowSplash(false);
  };

  if (showSplash) {
    return <SplashScreen onDone={handleSplashDone} />;
  }

  // Vérification de session en cours : écran neutre plutôt qu'un flash de
  // l'écran de connexion.
  if (!checked) {
    return <div className="min-h-screen bg-ink-50" />;
  }

  if (!user) {
    return <LoginPage />;
  }

  // Portail chauffeur : interface dédiée avec le nouveau portail MaMission
  // complet (workflow à 9 statuts, timeline, photos, signature).
  // L'ancien portail (ChauffeurPortalPage) est conservé pour les comptes
  // qui n'ont pas encore été migrés, mais les nouveaux comptes CHAUFFEUR
  // sont redirigés vers MaMissionPage.
  if (isChauffeur) {
    return (
      <Routes>
        <Route path="*" element={
          <DriverLayout>
            {(section) => <MaMissionPage section={section} standaloneHeader={false} />}
          </DriverLayout>
        } />
      </Routes>
    );
  }

  return (
    <Layout>
      <Routes>
        <Route path="/" element={<Dashboard />} />
        <Route path="/import" element={<ImportPage />} />
        <Route path="/regles" element={<RulesPage />} />
        <Route path="/correction" element={<CorrectionPage />} />
        <Route path="/comparaison" element={<ComparisonPage />} />
        <Route path="/rapports" element={<ReportsPage />} />
        <Route path="/lignes" element={<LignesPage />} />
        <Route path="/lignes-fixes" element={<LignesFixesPage />} />
        <Route path="/factures" element={<FacturesPage />} />
        <Route path="/comparaison-excel" element={<DiffPage />} />
        <Route path="/calendrier" element={<CalendarPage />} />
        <Route path="/journaux-presse" element={<JournauxPage />} />
        <Route path="/organigramme" element={<OrganigrammePage />} />
        <Route path="/logistique" element={<LogistiqueDashboardPage />} />
        <Route path="/logistique/demandes" element={<LogistiqueDemandesPage />} />
        <Route path="/logistique/parc-auto" element={<ParcAutoPage />} />
        <Route path="/logistique/maintenance" element={<MaintenancePage />} />
        <Route path="/logistique/carburant" element={<CarburantPage />} />
        <Route path="/logistique/declarations" element={<DeclarationsPage />} />
        <Route path="/logistique/chauffeurs" element={<ChauffeursPage />} />
        <Route path="/logistique/demande-chauffeur" element={<DemandeChauffeurPage />} />
        <Route path="/logistique/gerer-demandes-chauffeur" element={<GererDemandesChauffeurPage />} />
        <Route path="/logistique/deplacements" element={<DeplacementsPage />} />
        {isAdmin && <Route path="/utilisateurs" element={<UsersPage />} />}
        {isAdmin && <Route path="/journal" element={<JournalPage />} />}
        {hasMinRole('GESTIONNAIRE') && <Route path="/admin" element={<SuperAdminDashboard />} />}
        {isSuperAdmin && <Route path="/administration" element={<AdministrationPage />} />}
        <Route path="/mon-compte" element={<MonComptePage />} />
        <Route path="/telecharger" element={<DownloadPage />} />
      </Routes>
    </Layout>
  );
}
