import React from 'react';
import ReactDOM from 'react-dom/client';

// Enregistrement du Service Worker (PWA)
if ('serviceWorker' in navigator && import.meta.env.PROD) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/sw.js').catch(() => {
      // SW non critique — ignorer l'erreur silencieusement
    });
  });
}
import { HashRouter } from 'react-router-dom';
import App from './App';
import { AppProvider } from './context/AppContext';
import { AuthProvider } from './context/AuthContext';
import { OrgProvider } from './context/OrgContext';
import { LogistiqueProvider } from './context/LogistiqueContext';
import { ParcAutoProvider } from './context/ParcAutoContext';
import { MaintenanceProvider } from './context/MaintenanceContext';
import { DeclarationProvider } from './context/DeclarationContext';
import { initTheme } from './lib/theme';
import './i18n';
import './index.css';

initTheme();

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <HashRouter future={{ v7_startTransition: true, v7_relativeSplatPath: true }}>
      <AuthProvider>
        <OrgProvider>
          <LogistiqueProvider>
            <ParcAutoProvider>
              <MaintenanceProvider>
                <DeclarationProvider>
                  <AppProvider>
                    <App />
                  </AppProvider>
                </DeclarationProvider>
              </MaintenanceProvider>
            </ParcAutoProvider>
          </LogistiqueProvider>
        </OrgProvider>
      </AuthProvider>
    </HashRouter>
  </React.StrictMode>
);
