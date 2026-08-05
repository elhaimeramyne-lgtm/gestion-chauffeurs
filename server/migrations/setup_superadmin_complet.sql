-- ================================================================
-- SCRIPT COMPLET — À exécuter dans psql ou pgAdmin
-- Fait : migration enum + table + compte super_admin
-- ================================================================

-- 1. Ajouter le rôle super_admin
ALTER TYPE iam.user_role ADD VALUE IF NOT EXISTS 'super_admin' BEFORE 'admin';

-- 2. Créer la table historique
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

-- ================================================================
-- APRÈS ce script, dans le terminal du dossier server :
--   npm run seed:superadmin
-- ================================================================
