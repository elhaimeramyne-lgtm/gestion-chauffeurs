-- ============================================================
-- Migration : super_admin + historique
-- Exécuter dans cet ordre sur votre base PostgreSQL
-- ============================================================

-- 1. Ajouter le rôle super_admin à l'enum
ALTER TYPE iam.user_role ADD VALUE IF NOT EXISTS 'super_admin' BEFORE 'admin';

-- 2. Table des journaux d'activité
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

CREATE INDEX IF NOT EXISTS idx_activity_logs_created_at ON iam.activity_logs (created_at DESC);
CREATE INDEX IF NOT EXISTS idx_activity_logs_user_id    ON iam.activity_logs (user_id);
CREATE INDEX IF NOT EXISTS idx_activity_logs_category   ON iam.activity_logs (category);

-- ============================================================
-- Après la migration, créez le compte super_admin :
--   cd server && npm run seed:superadmin
-- ============================================================
