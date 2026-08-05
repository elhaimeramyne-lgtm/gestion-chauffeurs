-- Migration : ajout des statuts brouillon / valide / archive au workflow
-- des ordres de mission (iam.deplacements).
--
-- Nouveau workflow complet :
--   brouillon → valide → planifie → en_route → arrive → retour → termine → archive
--   (annule possible tant que le statut est brouillon, valide ou planifie)
--
-- À exécuter UNE SEULE FOIS sur la base de données de production.
--
-- Commande :
--   psql $DATABASE_URL -f migrations/add_deplacement_statuts_workflow.sql
--
-- (Alternative en développement : npm run db:push depuis /server,
--  qui synchronise le schéma Drizzle directement.)

ALTER TYPE iam.deplacement_statut ADD VALUE IF NOT EXISTS 'brouillon';
ALTER TYPE iam.deplacement_statut ADD VALUE IF NOT EXISTS 'valide';
ALTER TYPE iam.deplacement_statut ADD VALUE IF NOT EXISTS 'archive';

-- Le statut par défaut à la création passe de 'planifie' à 'brouillon'.
-- NOTE : les valeurs ajoutées à un enum PostgreSQL ne sont utilisables
-- dans la même transaction qui les crée — exécuter ce script en une
-- seule fois avec psql (pas de BEGIN/COMMIT manuel autour) résout ce
-- point, psql exécute chaque commande séparément par défaut.
ALTER TABLE iam.deplacements ALTER COLUMN statut SET DEFAULT 'brouillon';

-- Vérification
SELECT unnest(enum_range(NULL::iam.deplacement_statut)) AS statuts_disponibles;
