/**
 * Migration : nouveaux statuts de mission (brouillon/valide/archive) +
 * colonnes cin/matricule sur les chauffeurs.
 *
 * Ne nécessite PAS psql — utilise la connexion pg déjà configurée dans
 * .env (DATABASE_URL), comme les autres scripts de src/migrations.
 *
 * IMPORTANT : contrairement à `npm run db:push`, ce script n'exécute
 * que des ALTER TYPE / ALTER TABLE ADD COLUMN IF NOT EXISTS — aucune
 * colonne n'est jamais supprimée ou recréée, donc aucune perte de
 * données possible.
 *
 * Lancer depuis /server :
 *   npx tsx src/migrations/004_workflow_missions_et_chauffeurs.ts
 */
import pg from 'pg';
import * as dotenv from 'dotenv';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __dirname = dirname(fileURLToPath(import.meta.url));
dotenv.config({ path: join(__dirname, '../../.env') });

const { Client } = pg;
const client = new Client({ connectionString: process.env.DATABASE_URL });

async function main() {
  await client.connect();
  console.log('✅ Connecté à PostgreSQL');

  // ── Nouveaux statuts du workflow des ordres de mission ──────────────────
  // ALTER TYPE ... ADD VALUE ne peut pas s'exécuter dans un bloc BEGIN/COMMIT
  // explicite avec certaines versions de PG — chaque requête est donc
  // envoyée séparément (pas de transaction manuelle ici).
  const nouveauxStatuts = ['brouillon', 'valide', 'archive'];
  for (const statut of nouveauxStatuts) {
    await client.query(
      `ALTER TYPE iam.deplacement_statut ADD VALUE IF NOT EXISTS '${statut}'`
    );
    console.log(`✅ Statut « ${statut} » ajouté (ou déjà présent).`);
  }

  await client.query(
    `ALTER TABLE iam.deplacements ALTER COLUMN statut SET DEFAULT 'brouillon'`
  );
  console.log('✅ Statut par défaut des nouvelles missions : brouillon.');

  // ── CIN / matricule sur la fiche chauffeur ───────────────────────────────
  await client.query(`
    ALTER TABLE iam.chauffeurs
      ADD COLUMN IF NOT EXISTS cin TEXT,
      ADD COLUMN IF NOT EXISTS matricule TEXT
  `);
  console.log('✅ Colonnes cin / matricule vérifiées sur iam.chauffeurs.');

  // ── Heure de départ / observations sur les ordres de mission ────────────
  // (Phase 2 — portail chauffeur : affichage de l'heure et des consignes)
  await client.query(`
    ALTER TABLE iam.deplacements
      ADD COLUMN IF NOT EXISTS heure_depart TEXT,
      ADD COLUMN IF NOT EXISTS observations TEXT
  `);
  console.log('✅ Colonnes heure_depart / observations vérifiées sur iam.deplacements.');

  // ── Vérification finale ───────────────────────────────────────────────
  const statuts = await client.query(
    `SELECT unnest(enum_range(NULL::iam.deplacement_statut))::text AS statut`
  );
  console.log('\n📋 Statuts de mission disponibles :', statuts.rows.map((r) => r.statut).join(', '));

  const cols = await client.query(`
    SELECT column_name FROM information_schema.columns
    WHERE table_schema = 'iam' AND table_name = 'chauffeurs' AND column_name IN ('cin', 'matricule')
  `);
  console.log('📋 Colonnes chauffeurs présentes :', cols.rows.map((r) => r.column_name).join(', '));

  const colsDeplacements = await client.query(`
    SELECT column_name FROM information_schema.columns
    WHERE table_schema = 'iam' AND table_name = 'deplacements' AND column_name IN ('heure_depart', 'observations')
  `);
  console.log('📋 Colonnes déplacements présentes :', colsDeplacements.rows.map((r) => r.column_name).join(', '));

  console.log('\n🎉 Migration terminée sans perte de données.');
  await client.end();
}

main().catch(async (err) => {
  console.error('❌ Erreur :', err.message ?? err);
  await client.end().catch(() => {});
  process.exit(1);
});
