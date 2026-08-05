import { eq, desc, like } from 'drizzle-orm';
import { db, systemSettingsTable, systemLogsTable } from '../db.js';
import { runBackup } from './backup.js';

const CHECK_INTERVAL_MS = 15 * 60 * 1000; // vérifie toutes les 15 minutes

/** Planificateur de sauvegardes automatiques — en mémoire, pas de cron
 *  externe requis. Adapté à un déploiement mono-instance (cas de cette
 *  plateforme interne) : toutes les 15 minutes, vérifie si l'heure
 *  programmée (quotidienne ou hebdomadaire) vient de passer et si aucune
 *  sauvegarde automatique n'a déjà été faite depuis. */
export function startBackupScheduler(): void {
  const check = async () => {
    try {
      const [settings] = await db.select().from(systemSettingsTable).where(eq(systemSettingsTable.id, 1)).limit(1);
      if (!settings?.backupScheduleEnabled) return;

      const now = new Date();
      if (now.getHours() !== settings.backupScheduleHour) return;
      if (settings.backupScheduleFrequency === 'weekly' && now.getDay() !== 1) return; // lundi

      // Évite les doublons : ne relance pas si une sauvegarde planifiée a
      // déjà eu lieu dans les dernières 20 heures (couvre la fenêtre de
      // vérification de 15 min sans dépendre d'un état en mémoire qui
      // serait perdu au redémarrage du serveur).
      const [lastScheduled] = await db
        .select()
        .from(systemLogsTable)
        .where(like(systemLogsTable.message, 'Sauvegarde de la base créée'))
        .orderBy(desc(systemLogsTable.createdAt))
        .limit(1);
      if (lastScheduled) {
        const hoursSince = (now.getTime() - new Date(lastScheduled.createdAt).getTime()) / 3_600_000;
        if (hoursSince < 20) return;
      }

      await runBackup('scheduler', 'planifiee');
    } catch (err) {
      // eslint-disable-next-line no-console
      console.error('[backup-scheduler] erreur:', err);
    }
  };

  // Premier passage peu après le démarrage, puis toutes les 15 minutes.
  setTimeout(check, 60_000);
  setInterval(check, CHECK_INTERVAL_MS);
}
