-- Migration : ajout de la colonne civilite dans iam.lignes
-- À exécuter UNE SEULE FOIS sur la base de données de production.
--
-- Commande :
--   psql $DATABASE_URL -f migrations/add_civilite_column.sql

ALTER TABLE iam.lignes
  ADD COLUMN IF NOT EXISTS civilite TEXT
    CHECK (civilite IN ('Mme', 'Mlle', 'M.'));

-- Vérification
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'iam'
  AND table_name   = 'lignes'
  AND column_name  = 'civilite';
