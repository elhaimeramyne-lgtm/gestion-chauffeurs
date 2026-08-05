import 'dotenv/config';
import readline from 'node:readline/promises';
import { eq } from 'drizzle-orm';
import { db, usersTable } from '../db.js';
import { hashPassword } from '../lib/auth.js';

/** Crée (ou met à jour) un compte administrateur. À exécuter une seule fois
 *  après le premier déploiement : npm run seed:admin
 *
 *  Deux modes :
 *  - Interactif (par défaut) : le script pose les questions dans le terminal.
 *  - Non-interactif : définissez ADMIN_USERNAME et ADMIN_PASSWORD (et
 *    éventuellement ADMIN_DISPLAY_NAME) comme variables d'environnement,
 *    utile pour un script de déploiement automatisé. */
async function main() {
  let username = process.env.ADMIN_USERNAME?.trim();
  let password = process.env.ADMIN_PASSWORD?.trim();
  let displayName = process.env.ADMIN_DISPLAY_NAME?.trim() ?? '';

  if (!username || !password) {
    const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
    username = (await rl.question("Nom d'utilisateur admin : ")).trim();
    password = (await rl.question('Mot de passe (min. 6 caractères) : ')).trim();
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
    await db
      .update(usersTable)
      .set({
        passwordHash,
        role: 'SUPER_ADMIN',
        isActive: true,
        displayName: displayName || existing.displayName,
        updatedAt: new Date()
      })
      .where(eq(usersTable.id, existing.id));
    console.log(`Compte "${username}" mis à jour en tant que SUPER_ADMIN.`);
  } else {
    await db.insert(usersTable).values({
      username,
      passwordHash,
      role: 'SUPER_ADMIN',
      displayName: displayName || null
    });
    console.log(`Compte SUPER_ADMIN "${username}" créé.`);
  }

  process.exit(0);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
