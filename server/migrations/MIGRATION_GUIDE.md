# Guide de migration — Super Admin + Historique

## Étape 1 — Appliquer la migration SQL

Connectez-vous à votre base PostgreSQL et exécutez :

```sql
ALTER TYPE iam.user_role ADD VALUE IF NOT EXISTS 'super_admin' BEFORE 'admin';

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
);
```

## Étape 2 — Créer le compte super_admin

Dans le dossier server :

```bash
npm run seed:superadmin
```

Répondez aux questions :
- Nom d'utilisateur : superadmin
- Mot de passe : (votre choix, min 6 caractères)

## Étape 3 — Redémarrer le serveur

```bash
npm run dev
```

Connectez-vous avec le compte superadmin → vous verrez "Historique" dans le menu.
