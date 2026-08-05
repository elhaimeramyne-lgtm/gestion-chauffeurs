import 'dotenv/config';
import pg from 'pg';
import bcrypt from 'bcryptjs';

const pool = new pg.Pool({ connectionString: process.env.DATABASE_URL });

console.log('\n=== Setup Super Admin ===\n');

try {
  await pool.query("ALTER TYPE iam.user_role ADD VALUE IF NOT EXISTS 'super_admin' BEFORE 'admin'");
  console.log('OK - role super_admin ajoute');
} catch(e) {
  console.log('OK - role deja present');
}

await pool.query(`CREATE TABLE IF NOT EXISTS iam.activity_logs (
  id SERIAL PRIMARY KEY, user_id INTEGER NOT NULL,
  username TEXT NOT NULL, user_role TEXT NOT NULL,
  action TEXT NOT NULL, category TEXT NOT NULL,
  description TEXT NOT NULL, target_id TEXT,
  target_name TEXT, metadata JSONB,
  ip_address TEXT, created_at TIMESTAMP DEFAULT NOW() NOT NULL
)`);
console.log('OK - table historique creee');

const hash = await bcrypt.hash('superadmin123', 10);
await pool.query(`
  INSERT INTO iam.users (username, password_hash, display_name, role)
  VALUES ('superadmin', $1, 'Super Administrateur', 'super_admin')
  ON CONFLICT (username) DO UPDATE 
  SET password_hash=$1, role='super_admin', display_name='Super Administrateur'
`, [hash]);

console.log('\n=== TERMINE ! ===');
console.log('Login    : superadmin');
console.log('Password : superadmin123');
console.log('\nRelancez : npm run dev\n');

await pool.end();
