/**
 * Thème clair/sombre — le thème clair est la nouvelle identité par défaut ;
 * le thème sombre (ancienne identité "Aurora") reste disponible via le
 * sélecteur "Mode sombre" de la sidebar. Persisté en localStorage, appliqué
 * en posant data-theme="dark" sur <html> (voir index.css).
 */
const THEME_KEY = 'iam-facturation:theme:v1';
export type Theme = 'light' | 'dark';

export function getTheme(): Theme {
  try {
    const stored = localStorage.getItem(THEME_KEY);
    if (stored === 'dark' || stored === 'light') return stored;
  } catch { /* ignore */ }
  return 'light';
}

export function setTheme(theme: Theme): void {
  document.documentElement.dataset.theme = theme === 'dark' ? 'dark' : '';
  try { localStorage.setItem(THEME_KEY, theme); } catch { /* ignore */ }
}

/** À appeler une fois, avant le premier rendu, pour éviter le flash. */
export function initTheme(): void {
  setTheme(getTheme());
}
