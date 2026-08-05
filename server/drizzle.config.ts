import { defineConfig } from 'drizzle-kit';

export default defineConfig({
  schema: [
    './src/schema/activityLogs.ts', './src/schema/affectations.ts', './src/schema/audit.ts',
    './src/schema/calendarEvents.ts', './src/schema/chauffeurs.ts', './src/schema/dashboard.ts',
    './src/schema/declarations.ts', './src/schema/demandeChauffeur.ts', './src/schema/deplacementEvents.ts',
    './src/schema/deplacementGps.ts', './src/schema/deplacementPassagers.ts', './src/schema/deplacementPhotos.ts',
    './src/schema/deplacements.ts', './src/schema/emailLogs.ts', './src/schema/facturation.ts',
    './src/schema/factures.ts', './src/schema/journaux.ts', './src/schema/lignes.ts',
    './src/schema/lignesFixes.ts', './src/schema/maintenance.ts', './src/schema/notifications.ts',
    './src/schema/orgNodes.ts', './src/schema/serviceRequests.ts', './src/schema/sessions.ts',
    './src/schema/settings.ts', './src/schema/systemLog.ts', './src/schema/users.ts',
    './src/schema/vehicules.ts', './src/schema/whatsapp.ts'
  ],
  out: './drizzle',
  dialect: 'postgresql',
  dbCredentials: {
    url: process.env.DATABASE_URL!
  },
  // Ne gère que le schéma PostgreSQL "iam" (le nôtre) : sur une base
  // partagée avec d'autres applications (tables dans "public", ex: l'ancienne
  // app "Gestion des lignes"), il ne doit jamais les modifier ou supprimer.
  schemaFilter: ['iam']
});
