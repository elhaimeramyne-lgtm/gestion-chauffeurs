import 'dotenv/config';
import app from './app.js';
import { runMigrations } from './migrate.js';
import { logSystemEvent } from './lib/systemLog.js';
import { startBackupScheduler } from './lib/backupScheduler.js';

const port = Number(process.env.PORT ?? 5000);

// Lance les migrations automatiques puis démarre le serveur
runMigrations().finally(() => {
  app.listen(port, '0.0.0.0', () => {
    // eslint-disable-next-line no-console
    console.log(`[entraide-iam-server] écoute sur le port ${port}`);
    logSystemEvent('info', 'Démarrage du serveur', { port }).catch(() => {});
    startBackupScheduler();
  });
});
