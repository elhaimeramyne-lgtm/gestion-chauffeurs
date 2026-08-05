/**
 * Migration 005 : Workflow mission complet à 9 statuts + nouvelles tables
 * (events, photos, GPS points) + nouvelles colonnes.
 *
 * Cette migration transforme le système de 4 statuts (planifie → en_cours
 * → termine / annule) en workflow professionnel à 9+ statuts :
 *   creee → en_attente_acceptation → acceptee → en_route → arrive →
 *   mission_en_cours → terminee → retour → arrive_siege → cloturee
 *
 * Exécuter depuis /server :
 *   npx tsx src/migrations/005_mission_workflow.ts
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

  // ── 1. Nouvel enum à 11 valeurs (10 statuts + annule) ────────────────
  // On ne peut pas ALTER TYPE ... RENAME VALUE, donc on crée un nouveau
  // type, on met à jour la table, on supprime l'ancien, on renomme.
  // Mais d'abord, on vérifie si on est déjà en 9-statuts.
  const currentEnum = await client.query(`
    SELECT unnest(enum_range(NULL::iam.deplacement_statut))::text AS value
  `);
  const currentValues = currentEnum.rows.map((r) => r.value);

  if (currentValues.includes('creee')) {
    console.log('✅ L\'enum est déjà en 9-statuts — aucune modification nécessaire.');
  } else {
    // On sauvegarde les anciennes valeurs pour la migration des données
    await client.query('BEGIN');
    try {
      // Créer le nouveau type
      await client.query(`
        CREATE TYPE iam.deplacement_statut_new AS ENUM (
          'creee', 'en_attente_acceptation', 'acceptee', 'en_route',
          'arrive', 'mission_en_cours', 'terminee', 'retour',
          'arrive_siege', 'cloturee', 'annule'
        )
      `);

      // Ajouter la colonne temporaire
      await client.query(`ALTER TABLE iam.deplacements ADD COLUMN statut_new iam.deplacement_statut_new`);

      // Migrer les données : planifie → creee, en_cours → acceptee, termine → cloturee, annule → annule
      await client.query(`
        UPDATE iam.deplacements SET statut_new = CASE statut::text
          WHEN 'planifie' THEN 'creee'::iam.deplacement_statut_new
          WHEN 'en_cours' THEN 'acceptee'::iam.deplacement_statut_new
          WHEN 'termine' THEN 'cloturee'::iam.deplacement_statut_new
          WHEN 'annule' THEN 'annule'::iam.deplacement_statut_new
          ELSE 'creee'::iam.deplacement_statut_new
        END
      `);

      // Rendre la colonne NOT NULL et supprimer l'ancienne
      await client.query(`ALTER TABLE iam.deplacements ALTER COLUMN statut_new SET NOT NULL`);
      await client.query(`ALTER TABLE iam.deplacements DROP COLUMN statut`);
      await client.query(`ALTER TABLE iam.deplacements RENAME COLUMN statut_new TO statut`);

      // Mettre à jour la valeur par défaut
      await client.query(`ALTER TABLE iam.deplacements ALTER COLUMN statut SET DEFAULT 'creee'`);

      // Supprimer l'ancien type et renommer le nouveau
      await client.query(`DROP TYPE iam.deplacement_statut`);
      await client.query(`ALTER TYPE iam.deplacement_statut_new RENAME TO deplacement_statut`);

      await client.query('COMMIT');
      console.log('✅ Enum migré vers 9-statuts, données préservées.');
    } catch (err) {
      await client.query('ROLLBACK');
      throw err;
    }
  }

  // ── 2. Nouvelles colonnes sur iam.deplacements ──────────────────────
  const newColumns = [
    'heure_depart_prevue TEXT',
    'heure_depart_reelle TIMESTAMP',
    'heure_arrivee_reelle TIMESTAMP',
    'heure_retour_reelle TIMESTAMP',
    'heure_cloture TIMESTAMP',
    'date_depart_reelle TEXT',
    'date_arrivee_reelle TEXT',
    'date_retour_reelle TEXT',
    'date_cloture TIMESTAMP',
    'accepted_at TIMESTAMP',
    'accepted_by TEXT',
    'signature_chauffeur TEXT',
    'signature_responsable TEXT',
    'duree_mission INTEGER',
    'distance_km INTEGER',
    'consommation_carburant REAL',
    'observations_chauffeur TEXT',
    'notes_cloture TEXT',
    'itineraire JSONB',
  ];

  for (const col of newColumns) {
    const colName = col.split(' ')[0];
    await client.query(`
      ALTER TABLE iam.deplacements ADD COLUMN IF NOT EXISTS ${col}
    `);
    console.log(`✅ Colonne ${colName} vérifiée / ajoutée.`);
  }

  // ── 3. Table deplacement_events (timeline) ──────────────────────────
  await client.query(`
    CREATE TABLE IF NOT EXISTS iam.deplacement_events (
      id SERIAL PRIMARY KEY,
      deplacement_id INTEGER NOT NULL,
      statut TEXT NOT NULL,
      commentaire TEXT,
      latitude TEXT,
      longitude TEXT,
      vitesse INTEGER,
      action_par TEXT NOT NULL,
      created_at TIMESTAMP NOT NULL DEFAULT now()
    )
  `);
  await client.query(`
    CREATE INDEX IF NOT EXISTS deplacement_events_dep_idx ON iam.deplacement_events (deplacement_id)
  `);
  console.log('✅ Table iam.deplacement_events vérifiée / créée.');

  // ── 4. Table deplacement_photos ─────────────────────────────────────
  // Vérifier si l'enum photo_type existe déjà
  const photoEnumCheck = await client.query(`
    SELECT 1 FROM pg_type WHERE typname = 'photo_type'
  `).catch(() => null);
  if (!photoEnumCheck || photoEnumCheck.rowCount === 0) {
    await client.query(`
      CREATE TYPE iam.photo_type AS ENUM ('depart', 'arrivee', 'bon_livraison', 'retour', 'autre')
    `);
  }
  await client.query(`
    CREATE TABLE IF NOT EXISTS iam.deplacement_photos (
      id SERIAL PRIMARY KEY,
      deplacement_id INTEGER NOT NULL,
      type iam.photo_type NOT NULL DEFAULT 'autre',
      filename TEXT NOT NULL,
      original_name TEXT,
      mime_type TEXT,
      size_bytes INTEGER,
      uploaded_by TEXT NOT NULL,
      created_at TIMESTAMP NOT NULL DEFAULT now()
    )
  `);
  await client.query(`
    CREATE INDEX IF NOT EXISTS deplacement_photos_dep_idx ON iam.deplacement_photos (deplacement_id)
  `);
  console.log('✅ Table iam.deplacement_photos vérifiée / créée.');

  // ── 5. Table deplacement_gps_points ─────────────────────────────────
  await client.query(`
    CREATE TABLE IF NOT EXISTS iam.deplacement_gps_points (
      id SERIAL PRIMARY KEY,
      deplacement_id INTEGER NOT NULL,
      latitude REAL NOT NULL,
      longitude REAL NOT NULL,
      vitesse REAL,
      precision REAL,
      cap INTEGER,
      created_at TIMESTAMP NOT NULL DEFAULT now()
    )
  `);
  await client.query(`
    CREATE INDEX IF NOT EXISTS deplacement_gps_dep_idx ON iam.deplacement_gps_points (deplacement_id)
  `);
  await client.query(`
    CREATE INDEX IF NOT EXISTS deplacement_gps_created_at_idx ON iam.deplacement_gps_points (created_at DESC)
  `);
  console.log('✅ Table iam.deplacement_gps_points vérifiée / créée.');

  // ── 6. Mise à jour du statut par défaut sur l'enum (déjà fait via DROP) ─
  // Vérification finale
  const statuts = await client.query(`
    SELECT unnest(enum_range(NULL::iam.deplacement_statut))::text AS statut
  `);
  console.log('\n📋 Statuts disponibles :', statuts.rows.map((r) => r.statut).join(', '));

  // Compter les déplacements migrés
  const depCount = await client.query(`SELECT COUNT(*)::text AS cnt FROM iam.deplacements`);
  console.log(`📋 Déplacements en base : ${depCount.rows[0]?.cnt ?? 0}`);

  // Vérifier la répartition par statut
  const byStatut = await client.query(`
    SELECT statut, COUNT(*)::text AS cnt FROM iam.deplacements GROUP BY statut ORDER BY statut
  `);
  for (const row of byStatut.rows) {
    console.log(`   ${row.statut}: ${row.cnt}`);
  }

  console.log('\n🎉 Migration 005 terminée sans perte de données.');
  await client.end();
}

main().catch(async (err) => {
  console.error('❌ Erreur :', err.message ?? err);
  await client.end().catch(() => {});
  process.exit(1);
});
