/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        /* Échelle "ink" repensée pour un fond sombre glassmorphism :
           les numéros hauts restent les plus contrastés/prononcés (comme
           avant), mais désormais en clair sur fond marine plutôt qu'en
           sombre sur fond blanc — aucun composant n'a besoin d'être réécrit. */
        ink: {
          950: 'rgba(5,8,20,0.72)',
          900: '#ffffff',
          800: '#f1f5f9',
          700: '#cbd5e1',
          600: '#a8b3c9',
          500: '#8891a8',
          400: '#69738c',
          300: 'rgba(255,255,255,0.16)',
          200: 'rgba(255,255,255,0.12)',
          100: 'rgba(255,255,255,0.07)',
          50: 'rgba(255,255,255,0.04)'
        },
        signal: {
          teal: '#2dd4bf',
          tealDark: '#5eead4',
          amber: '#fbbf24',
          amberDark: '#fcd34d',
          rose: '#f87171',
          roseDark: '#fca5a5',
          moss: '#4ade80',
          emerald: '#34d399',
          emeraldDark: '#6ee7b7'
        },
        /* Palette "aurora" — violet / cyan / rose, cœur de l'identité visuelle */
        aurora: {
          violet: '#a855f7',
          violetSoft: '#c084fc',
          cyan: '#22d3ee',
          cyanSoft: '#67e8f9',
          pink: '#ec4899',
          pinkSoft: '#f472b6'
        }
      },
      fontFamily: {
        /* Inter pour absolument tout — cohérence maximale */
        display: ['"Inter"', 'system-ui', 'sans-serif'],
        body:    ['"Inter"', 'system-ui', 'sans-serif'],
        sans:    ['"Inter"', 'system-ui', 'sans-serif'],
        mono:    ['"JetBrains Mono"', 'ui-monospace', 'monospace']
      },
      fontSize: {
        /* Système typographique IAM */
        'table':  ['13px', { lineHeight: '1.5', fontWeight: '400' }],
        'body':   ['14px', { lineHeight: '1.5', fontWeight: '400' }],
        'nav':    ['15px', { lineHeight: '1.5', fontWeight: '500' }],
        'card':   ['18px', { lineHeight: '1.4', fontWeight: '600' }],
        'page':   ['30px', { lineHeight: '1.2', fontWeight: '700', letterSpacing: '-0.02em' }],
        'page-lg':['32px', { lineHeight: '1.2', fontWeight: '700', letterSpacing: '-0.02em' }]
      },
      boxShadow: {
        panel: '0 1px 2px rgba(18,24,27,0.06), 0 8px 24px -12px rgba(18,24,27,0.15)'
      }
    }
  },
  plugins: []
};
