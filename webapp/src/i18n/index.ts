import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import fr from './locales/fr.json';
import ar from './locales/ar.json';

export const RTL_LANGUAGES = ['ar'];

const savedLang = typeof window !== 'undefined' ? localStorage.getItem('iam-lang') : null;
const initialLang = savedLang && ['fr', 'ar'].includes(savedLang) ? savedLang : 'fr';

i18n.use(initReactI18next).init({
  resources: {
    fr: { translation: fr },
    ar: { translation: ar }
  },
  lng: initialLang,
  fallbackLng: 'fr',
  interpolation: { escapeValue: false }
});

/** Change la langue active, persiste le choix, et bascule le sens de
 *  lecture du document (RTL pour l'arabe) — nécessaire pour que toute la
 *  mise en page (sidebar, marges, alignements) s'inverse correctement. */
export function setLanguage(lang: 'fr' | 'ar'): void {
  i18n.changeLanguage(lang);
  localStorage.setItem('iam-lang', lang);
  document.documentElement.dir = RTL_LANGUAGES.includes(lang) ? 'rtl' : 'ltr';
  document.documentElement.lang = lang;
}

// Applique le sens de lecture dès le chargement initial (avant même le premier rendu React)
if (typeof document !== 'undefined') {
  document.documentElement.dir = RTL_LANGUAGES.includes(initialLang) ? 'rtl' : 'ltr';
  document.documentElement.lang = initialLang;
}

export default i18n;
