-- Migration : ajout des colonnes cin et matricule dans iam.chauffeurs
-- Permet l'anti-doublon (un chauffeur = une seule fiche) côté Phase 1.
-- À exécuter UNE SEULE FOIS sur la base de données de production.
--
-- Commande :
--   psql $DATABASE_URL -f migrations/add_chauffeur_cin_matricule.sql
--
-- (Alternative en développement : npm run db:push depuis /server,
--  qui synchronise le schéma Drizzle directement.)

ALTER TABLE iam.chauffeurs
  ADD COLUMN IF NOT EXISTS cin TEXT,
  ADD COLUMN IF NOT EXISTS matricule TEXT;

-- Vérification
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'iam'
  AND table_name   = 'chauffeurs'
  AND column_name IN ('cin', 'matricule');
