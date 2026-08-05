import 'dotenv/config';
import readline from 'node:readline/promises';
import { eq } from 'drizzle-orm';
import { db, usersTable } from '../db.js';
import { hashPassword } from '../lib/auth.js';

/**
 * Crée (ou met à jour) le compte super_admin.
 * À exécuter UNE SEULE FOIS après la migration :
 *   npm run seed:superadmin
 *
 * Ou en non-interactif :
 *   SUPER_ADMIN_USERNAME=superadmin SUPER_ADMIN_PASSWORD=monmdp npm run seed:superadmin
 */
async function main() {
  let username    = process.env.SUPER_ADMIN_USERNAME?.trim();
  let password    = process.env.SUPER_ADMIN_PASSWORD?.trim();
  let displayName = process.env.SUPER_ADMIN_DISPLAY_NAME?.trim() ?? '';

  if (!username || !password) {
    const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
    username    = (await rl.question("Nom d'utilisateur super admin : ")).trim();
    password    = (await rl.question('Mot de passe (min. 6 caractères) : ')).trim();
    displayName = (await rl.question('Nom affiché (optionnel) : ')).trim();
    rl.close();
  }

  if (!username || !password || password.length < 6) {
    console.error("Nom d'utilisateur requis et mot de passe d'au moins 6 caractères.");
    process.exit(1);
  }

  const passwordHash = await hashPassword(password);
  const [existing] = await db.select().from(usersTable).where(eq(usersTable.username, username)).limit(1);

  if (existing) {
    await db.update(usersTable).set({
      passwordHash, role: 'SUPER_ADMIN',
      displayName: displayName || existing.displayName,
      updatedAt: new Date()
    }).where(eq(usersTable.id, existing.id));
    console.log(`✓ Compte "${username}" mis à jour → SUPER_ADMIN`);
  } else {
    await db.insert(usersTable).values({ username, passwordHash, role: 'SUPER_ADMIN', displayName: displayName || null });
    console.log(`✓ Compte SUPER_ADMIN "${username}" créé avec succès`);
  }

  process.exit(0);
}

main().catch((err) => { console.error(err); process.exit(1); });
