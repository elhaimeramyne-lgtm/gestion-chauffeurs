/**
 * Migration + Seed : table iam.org_nodes
 * Structure EXACTE selon l'organigramme officiel d'Entraide Nationale
 * Source : image organigramme couleur (jaune = SD, violet = Division)
 *
 * Lancer avec :  npx tsx src/migrations/003_org_nodes.ts
 */
import pg from 'pg';
import * as dotenv from 'dotenv';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __dirname = dirname(fileURLToPath(import.meta.url));
dotenv.config({ path: join(__dirname, '../../.env') });

const { Client } = pg;
const client = new Client({ connectionString: process.env.DATABASE_URL });

async function ins(
  type: string,
  name: string,
  parentId: number | null,
  sortOrder: number,
  shortName?: string
): Promise<number> {
  const res = await client.query<{ id: number }>(
    `INSERT INTO iam.org_nodes (type, name, short_name, parent_id, sort_order)
     VALUES ($1, $2, $3, $4, $5) RETURNING id`,
    [type, name, shortName ?? null, parentId, sortOrder]
  );
  return res.rows[0]!.id;
}

async function main() {
  await client.connect();
  console.log('✅ Connecté à PostgreSQL');

  // ── Créer la table si elle n'existe pas ─────────────────────────────────
  await client.query(`
    CREATE TABLE IF NOT EXISTS iam.org_nodes (
      id          SERIAL PRIMARY KEY,
      type        TEXT NOT NULL,
      name        TEXT NOT NULL,
      short_name  TEXT,
      parent_id   INTEGER REFERENCES iam.org_nodes(id) ON DELETE CASCADE,
      sort_order  INTEGER NOT NULL DEFAULT 0,
      chef_nom    TEXT,
      telephone   TEXT,
      notes       TEXT,
      deleted_at  TIMESTAMP,
      created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
      updated_at  TIMESTAMP NOT NULL DEFAULT NOW()
    )
  `);
  console.log('✅ Table iam.org_nodes vérifiée.');

  // ── Vider et re-seeder ───────────────────────────────────────────────────
  const check = await client.query<{ cnt: string }>('SELECT COUNT(*)::text AS cnt FROM iam.org_nodes');
  if (Number(check.rows[0]?.cnt) > 0) {
    await client.query('DELETE FROM iam.org_nodes');
    await client.query('ALTER SEQUENCE iam.org_nodes_id_seq RESTART WITH 1');
    console.log('🗑️  Données précédentes supprimées.');
  }

  console.log("⏳ Insertion de l'organigramme...");

  // ══════════════════════════════════════════════════════════════════════════
  // RACINE : Direction
  // ══════════════════════════════════════════════════════════════════════════
  const dirId = await ins('direction', 'Direction', null, 0);

  // ══════════════════════════════════════════════════════════════════════════
  // Inspection  (gauche de la Direction — 3 Divisions + 3 Services plats)
  // ══════════════════════════════════════════════════════════════════════════
  const inspId = await ins('inspection', 'Inspection', dirId, 1, 'Inspection');
  await ins('division', 'Division 1', inspId, 0);
  await ins('division', 'Division 2', inspId, 1);
  await ins('division', 'Division 3', inspId, 2);
  await ins('service',  'Service 1',  inspId, 3);
  await ins('service',  'Service 2',  inspId, 4);
  await ins('service',  'Service 3',  inspId, 5);

  // ══════════════════════════════════════════════════════════════════════════
  // Directions Régionales / Provinciales  (droite de la Direction)
  // ══════════════════════════════════════════════════════════════════════════
  await ins('entite', 'Directions Régionales',                       dirId, 2, 'Dir. Rég.');
  await ins('entite', 'Directions Provinciales/Préfectorales',       dirId, 3, 'Dir. Prov.');

  // ══════════════════════════════════════════════════════════════════════════
  // Direction Adjointe  (centre de la Direction)
  // ══════════════════════════════════════════════════════════════════════════
  const adjId = await ins('sous-direction', 'Direction Adjointe', dirId, 4, 'Dir. Adjointe');

  // ─────────────────────────────────────────────────────────────────────────
  // SOUS-DIRECTION 1
  // Sous-Direction de l'Ingénierie Sociale et de la Planification
  // ─────────────────────────────────────────────────────────────────────────
  const sdIngId = await ins(
    'sous-direction',
    "Sous-Direction de l'Ingénierie Sociale et de la Planification",
    adjId, 0, 'SD Ing. Sociale'
  );

  // Division de l'Ingénierie Sociale
  const dIngId = await ins('division', "Division de l'Ingénierie Sociale", sdIngId, 0, 'Ing. Sociale');
  await ins('service', "Service de l'Ingénierie de la Veille Sociale et des Études", dIngId, 0);
  await ins('service', 'Service des Statistiques et des Indicateurs',                dIngId, 1);

  // Division de la Planification Stratégique et de la Programmation
  const dPlanId = await ins('division', 'Division de la Planification Stratégique et de la Programmation', sdIngId, 1, 'Planification');
  await ins('service', "Service de la Planification, du Suivi et d'Évaluation des Programmes", dPlanId, 0);
  await ins('service', 'Service du Partenariat',                                               dPlanId, 1);

  // ─────────────────────────────────────────────────────────────────────────
  // SOUS-DIRECTION 2
  // Sous-Direction des Affaires Administratives et Financières
  // ─────────────────────────────────────────────────────────────────────────
  const sdAafId = await ins(
    'sous-direction',
    'Sous-Direction des Affaires Administratives et Financières',
    adjId, 1, 'SDAAF'
  );

  // Division des Ressources Financières
  const dFinId = await ins('division', 'Division des Ressources Financières', sdAafId, 0, 'Res. Fin.');
  await ins('service', 'Service de la Comptabilité',                  dFinId, 0);
  await ins('service', 'Service du Budget et de la Programmation',    dFinId, 1);
  await ins('service', 'Service du Recouvrement',                     dFinId, 2);
  await ins('service', "Service de l'Ordonnancement et du Paiement",  dFinId, 3);

  // Division des Ressources Humaines
  const dRhId = await ins('division', 'Division des Ressources Humaines', sdAafId, 1, 'RH');
  await ins('service', 'Service de la Gestion du Personnel',  dRhId, 0);
  await ins('service', 'Service de la Couverture Sociale',    dRhId, 1);
  await ins('service', 'Service de Développement des RH',     dRhId, 2);

  // Division du Patrimoine et de la Logistique
  const dPatrId = await ins('division', 'Division du Patrimoine et de la Logistique', sdAafId, 2, 'Patrimoine');
  await ins('service', 'Service du Patrimoine et des Bâtiments',         dPatrId, 0);
  await ins('service', 'Service des Achats',                             dPatrId, 1);
  await ins('service', 'Service de la Logistique et des Moyens Généraux',dPatrId, 2);
  await ins('service', 'Service de la Gestion des Archives',             dPatrId, 3);

  // ─────────────────────────────────────────────────────────────────────────
  // SOUS-DIRECTION 3
  // Sous-Direction de l'Assistance Sociale
  // ─────────────────────────────────────────────────────────────────────────
  const sdAsId = await ins(
    'sous-direction',
    "Sous-Direction de l'Assistance Sociale",
    adjId, 2, 'SDAS'
  );

  // Division de la Solidarité et de l'Assistance Sociale
  const dSolId = await ins('division', "Division de la Solidarité et de l'Assistance Sociale", sdAsId, 0, 'Solidarité');
  await ins('service', "Service de la Solidarité et de l'Action Humanitaire",  dSolId, 0);
  await ins('service', "Service de l'Assistance et d'Accompagnement des PSH",  dSolId, 1);
  await ins('service', 'Service des Personnes Sans Abris',                     dSolId, 2);

  // Division de la Protection et de la Promotion Familiale
  const dProtId = await ins('division', 'Division de la Protection et de la Promotion Familiale', sdAsId, 1, 'Protection Fam.');
  await ins('service', "Service d'Accompagnement et de Protection de l'Enfance",               dProtId, 0);
  await ins('service', "Service des Établissements d'Accueil et de Protection des Enfants",    dProtId, 1);
  await ins('service', "Service des Structures d'Accueil et d'Aide des PSH",                   dProtId, 2);
  await ins('service', 'Service de Protection des Personnes Âgées et de la Promotion Familiale', dProtId, 3);

  // Division de l'Intégration et de l'Autonomisation
  const dIntegId = await ins('division', "Division de l'Intégration et de l'Autonomisation", sdAsId, 2, 'Intégration');
  await ins('service', "Service d'Assistance Sociale à la Femme",                        dIntegId, 0);
  await ins('service', "Service des Centres d'Accueil et de Protection de la Femme",     dIntegId, 1);
  await ins('service', "Service de l'Autonomisation et de l'Insertion Sociale de la Femme", dIntegId, 2);

  // ─────────────────────────────────────────────────────────────────────────
  // Division des Systèmes d'Information et de la Digitalisation
  // (rattachée directement à Direction Adjointe — 4ème colonne de l'image)
  // ─────────────────────────────────────────────────────────────────────────
  const dSiId = await ins(
    'division',
    "Division des Systèmes d'Information et de la Digitalisation",
    adjId, 3, 'Div. SI'
  );
  await ins('service', "Service d'Études et de Développement des SI",               dSiId, 0);
  await ins('service', 'Service de Gestion, de Maintenance et de Support des SI',   dSiId, 1);
  await ins('service', "Service de l'Accueil, de la Qualité et du Contrôle de Gestion", dSiId, 2);

  // ─────────────────────────────────────────────────────────────────────────
  // Services rattachés directement à la Direction Adjointe
  // (colonne tout à droite de l'image)
  // ─────────────────────────────────────────────────────────────────────────
  await ins('service', 'Service de la Communication',                       adjId, 4, 'Communication');
  await ins('service', 'Service de la Coopération',                         adjId, 5, 'Coopération');
  await ins('service', 'Service du Contentieux et des Affaires Juridiques', adjId, 6, 'Contentieux');

  // ── Résumé ───────────────────────────────────────────────────────────────
  const total = await client.query<{ cnt: string }>('SELECT COUNT(*)::text AS cnt FROM iam.org_nodes');
  console.log(`\n✅ Organigramme seedé — ${total.rows[0]?.cnt} nœuds insérés.\n`);
  console.log('Direction');
  console.log('├── Inspection');
  console.log('│   ├── Division 1 / Division 2 / Division 3');
  console.log('│   └── Service 1 / Service 2 / Service 3');
  console.log('├── Directions Régionales');
  console.log('├── Directions Provinciales/Préfectorales');
  console.log('└── Direction Adjointe');
  console.log('    ├── SD Ingénierie Sociale et de la Planification');
  console.log('    │   ├── Division de l\'Ingénierie Sociale (2 services)');
  console.log('    │   └── Division de la Planification Stratégique (2 services)');
  console.log('    ├── SD Affaires Administratives et Financières');
  console.log('    │   ├── Division des Ressources Financières (4 services)');
  console.log('    │   ├── Division des Ressources Humaines (3 services)');
  console.log('    │   └── Division du Patrimoine et de la Logistique (4 services)');
  console.log("    ├── SD Assistance Sociale");
  console.log("    │   ├── Division de la Solidarité et de l'Assistance Sociale (3 services)");
  console.log('    │   ├── Division de la Protection et de la Promotion Familiale (4 services)');
  console.log("    │   └── Division de l'Intégration et de l'Autonomisation (3 services)");
  console.log("    ├── Division des Systèmes d'Information et de la Digitalisation (3 services)");
  console.log('    ├── Service de la Communication');
  console.log('    ├── Service de la Coopération');
  console.log('    └── Service du Contentieux et des Affaires Juridiques');

  await client.end();
}

main().catch(async (err) => {
  console.error('❌ Erreur :', err.message ?? err);
  await client.end().catch(() => {});
  process.exit(1);
});
