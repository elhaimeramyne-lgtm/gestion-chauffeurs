/**
 * Point d'entrée unique du schéma Drizzle — ré-exporte toutes les tables,
 * enums et types de chaque fichier de `src/schema/`. `db.ts` importe
 * `* as schema` depuis ce fichier pour construire l'instance Drizzle, et
 * les routes importent les tables via `../db.js` qui ré-exporte ce module.
 */
export * from './users.js';
export * from './facturation.js';
export * from './lignes.js';
export * from './lignesFixes.js';
export * from './factures.js';
export * from './journaux.js';
export * from './audit.js';
export * from './systemLog.js';
export * from './settings.js';
export * from './sessions.js';
export * from './notifications.js';
export * from './emailLogs.js';
export * from './whatsapp.js';
export * from './orgNodes.js';
export * from './calendarEvents.js';
export * from './serviceRequests.js';
export * from './demandeChauffeur.js';
export * from './chauffeurs.js';
export * from './vehicules.js';
export * from './affectations.js';
export * from './maintenance.js';
export * from './declarations.js';
export * from './deplacements.js';
export * from './deplacementEvents.js';
export * from './deplacementPhotos.js';
export * from './deplacementGps.js';
export * from './deplacementPassagers.js';
export * from './activityLogs.js';
export * from './dashboard.js';
