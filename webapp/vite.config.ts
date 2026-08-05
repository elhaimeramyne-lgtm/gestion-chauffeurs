import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// Adresse du serveur API backend (Express) — utilisée uniquement par le
// proxy de développement. En production, VITE_API_URL (ou le chemin relatif
// /api) est utilisé directement par le frontend, voir src/lib/api.ts.
const API_PROXY_TARGET = process.env.VITE_DEV_API_PROXY ?? 'http://localhost:5000';

export default defineConfig({
  plugins: [react()],
  server: {
    host: true,
    port: 5173,
    proxy: {
      '/api': {
        target: API_PROXY_TARGET,
        changeOrigin: true
      }
    }
  },
  preview: {
    host: true,
    port: 5173
  }
});
