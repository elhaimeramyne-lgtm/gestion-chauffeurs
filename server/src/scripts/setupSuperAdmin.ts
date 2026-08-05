/**
 * Script tout-en-un : migration + création super_admin
 * Lancer UNE SEULE FOIS : npm run setup:superadmin
 */
import 'dotenv/config';
import readline from 'node:readline/promises';
import { sql } from 'drizzle-orm';
import { db, usersTable } from '../db.js';
import { hashPassword } from '../lib/auth.js';
import { eq } from 'drizzle-orm';

async function main() {
  console.log('\n🚀 Setup Super Admin — Plateforme IAM\n');

  // ── Étape 1 : Migration base de données ─────────────────────────
  console.log('📦 Étape 1/2 — Migration base de données...');
  try {
    await db.execute(sql`
      DO $$ BEGIN
        IF NOT EXISTS (
          SELECT 1 FROM pg_enum e
          JOIN pg_type t ON t.oid = e.enumtypid
          WHERE t.typname = 'user_role' AND e.enumlabel = 'super_admin'
        ) THEN
          ALTER TYPE iam.user_role ADD VALUE 'super_admin' BEFORE 'admin';
        END IF;
      END $$;
    `);
    console.log('   ✅ Rôle super_admin ajouté à l\'enum');
  } catch (e) {
    console.log('   ℹ️  Rôle super_admin déjà présent');
  }

  await db.execute(sql`
    CREATE TABLE IF NOT EXISTS iam.activity_logs (
      id          SERIAL PRIMARY KEY,
      user_id     INTEGER NOT NULL,
      username    TEXT NOT NULL,
      user_role   TEXT NOT NULL,
      action      TEXT NOT NULL,
      category    TEXT NOT NULL,
      description TEXT NOT NULL,
      target_id   TEXT,
      target_name TEXT,
      metadata    JSONB,
      ip_address  TEXT,
      created_at  TIMESTAMP DEFAULT NOW() NOT NULL
    )
  `);
  console.log('   ✅ Table activity_logs créée');

  await db.execute(sql`
    CREATE INDEX IF NOT EXISTS idx_activity_logs_created_at 
    ON iam.activity_logs (created_at DESC)
  `);
  console.log('   ✅ Index créés');

  // ── Étape 2 : Création compte super_admin ────────────────────────
  console.log('\n👤 Étape 2/2 — Création du compte super_admin...');

  let username = process.env.SUPER_ADMIN_USERNAME?.trim();
  let password = process.env.SUPER_ADMIN_PASSWORD?.trim();
  let displayName = process.env.SUPER_ADMIN_DISPLAY_NAME?.trim() ?? '';

  if (!username || !password) {
    const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
    username    = (await rl.question("   Nom d'utilisateur : ")).trim();
    password    = (await rl.question('   Mot de passe (min. 6 car.) : ')).trim();
    displayName = (await rl.question('   Nom affiché (ex: Super Admin) : ')).trim();
    rl.close();
  }

  if (!username || !password || password.length < 6) {
    console.error('\n❌ Identifiants invalides.');
    process.exit(1);
  }

  const passwordHash = await hashPassword(password);
  const [existing] = await db.select().from(usersTable)
    .where(eq(usersTable.username, username)).limit(1);

  if (existing) {
    await db.update(usersTable).set({
      passwordHash,
      role: 'super_admin' as never,
      displayName: displayName || existing.displayName,
      updatedAt: new Date()
    }).where(eq(usersTable.id, existing.id));
    console.log(`\n   ✅ Compte "${username}" mis à jour → super_admin`);
  } else {
    await db.insert(usersTable).values({
      username, passwordHash,
      role: 'super_admin' as never,
      displayName: displayName || null
    });
    console.log(`\n   ✅ Compte super_admin "${username}" créé`);
  }

  console.log('\n✨ Terminé ! Redémarrez le serveur puis connectez-vous avec :');
  console.log(`   Utilisateur : ${username}`);
  console.log('   Mot de passe : (celui que vous venez de saisir)\n');
  process.exit(0);
}

main().catch((err) => {
  console.error('\n❌ Erreur :', err.message);
  process.exit(1);
});
