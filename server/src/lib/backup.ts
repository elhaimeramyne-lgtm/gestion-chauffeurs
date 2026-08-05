import { spawn } from 'node:child_process';
import { mkdir } from 'node:fs/promises';
import path from 'node:path';
import { logSystemEvent } from './systemLog.js';

// Utilise pg_dump / psql (livrés avec PostgreSQL). Les chemins sont
// configurables via PG_DUMP_PATH / PSQL_PATH si absents du PATH système
// (fréquent sur Windows — voir server/.env.example).
export const BACKUP_DIR = process.env.BACKUP_DIR ?? path.join(process.cwd(), 'backups');
const PG_DUMP_PATH = process.env.PG_DUMP_PATH ?? 'pg_dump';
const PSQL_PATH = process.env.PSQL_PATH ?? 'psql';

async function ensureBackupDir() {
  await mkdir(BACKUP_DIR, { recursive: true });
}

function runProcess(command: string, args: string[]): Promise<{ code: number | null; stderr: string }> {
  return new Promise((resolve) => {
    const child = spawn(command, args);
    let stderr = '';
    child.stderr.on('data', (chunk) => {
      stderr += chunk.toString();
    });
    child.on('error', (err) => resolve({ code: -1, stderr: err.message }));
    child.on('close', (code) => resolve({ code, stderr }));
  });
}

export interface BackupResult {
  ok: boolean;
  filename?: string;
  error?: string;
}

/** Lance une sauvegarde complète (pg_dump). `--clean --if-exists` garantit
 *  que le fichier généré est directement restaurable (il recrée proprement
 *  les objets plutôt que d'échouer sur "already exists"). `label` permet de
 *  distinguer une sauvegarde manuelle, planifiée, ou de sécurité. */
export async function runBackup(username: string, label = ''): Promise<BackupResult> {
  await ensureBackupDir();

  if (!process.env.DATABASE_URL) {
    return { ok: false, error: 'DATABASE_URL non configuré.' };
  }

  const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
  const filename = `entraide-iam-${label ? `${label}-` : ''}${timestamp}.sql`;
  const filepath = path.join(BACKUP_DIR, filename);

  const { code, stderr } = await runProcess(PG_DUMP_PATH, [
    '--no-owner',
    '--no-privileges',
    '--clean',
    '--if-exists',
    '-f',
    filepath,
    process.env.DATABASE_URL
  ]);

  if (code === 0) {
    await logSystemEvent('info', 'Sauvegarde de la base créée', { filename, by: username, label: label || 'manuelle' });
    return { ok: true, filename };
  }

  await logSystemEvent('error', 'Échec de la sauvegarde de la base', { code, stderr: stderr.slice(0, 2000) });
  return {
    ok: false,
    error:
      code === -1
        ? "Impossible de lancer pg_dump. Vérifiez qu'il est installé et accessible (variable PG_DUMP_PATH si besoin)."
        : 'La sauvegarde a échoué. Voir le journal système pour le détail.'
  };
}

/** Restaure la base à partir d'un fichier de sauvegarde (psql -f). Le
 *  fichier ayant été généré avec --clean --if-exists, la restauration
 *  recrée proprement les objets sans erreur "already exists". */
export async function runRestore(filename: string, username: string): Promise<{ ok: boolean; error?: string }> {
  if (!process.env.DATABASE_URL) {
    return { ok: false, error: 'DATABASE_URL non configuré.' };
  }
  const filepath = path.join(BACKUP_DIR, filename);

  const { code, stderr } = await runProcess(PSQL_PATH, ['-v', 'ON_ERROR_STOP=1', '-f', filepath, process.env.DATABASE_URL]);

  if (code === 0) {
    await logSystemEvent('warn', 'Restauration de sauvegarde terminée avec succès', { filename, by: username });
    return { ok: true };
  }

  await logSystemEvent('error', 'Échec de la restauration', { filename, code, stderr: stderr.slice(0, 2000) });
  return {
    ok: false,
    error:
      code === -1
        ? "Impossible de lancer psql. Vérifiez qu'il est installé et accessible (variable PSQL_PATH si besoin)."
        : 'La restauration a échoué. Voir le journal système pour le détail.'
  };
}
