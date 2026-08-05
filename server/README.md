# Serveur API — Entraide Nationale IAM

Backend Express + PostgreSQL (via Drizzle ORM) pour la plateforme Facturation IAM
et Gestion des lignes. Gère l'authentification (comptes + rôles) et stocke les
données partagées entre tous les postes : règles de colonnes, champs
personnalisés, règles de correction, et lignes mobiles.

Les fichiers Excel importés (impayés / règlements) et le résultat de la
dernière comparaison restent volontairement **locaux à chaque poste** (non
partagés) : seule la configuration et les lignes sont centralisées.

## Prérequis

- Node.js 20 ou plus récent
- PostgreSQL 14 ou plus récent, accessible depuis ce serveur

## Installation

```bash
cd server
npm install
cp .env.example .env
```

Éditez `.env` :
- `DATABASE_URL` : chaîne de connexion vers votre base PostgreSQL
- `SESSION_SECRET` : une chaîne longue et aléatoire (ex: générée avec `openssl rand -hex 32`)
- `PORT` : port d'écoute du serveur (5000 par défaut)
- `CORS_ORIGINS` : l'adresse depuis laquelle le frontend sera servi, par
  exemple `http://192.168.77.204:5173`. Plusieurs adresses possibles,
  séparées par des virgules.

## Créer les tables

```bash
npm run db:push
```

Cette commande crée (ou met à jour) les tables dans la base indiquée par
`DATABASE_URL`. À relancer à chaque fois que le schéma évolue.

## Créer le premier compte administrateur

```bash
npm run seed:admin
```

Le script demande un nom d'utilisateur et un mot de passe dans le terminal.
Une fois ce compte créé, connectez-vous avec sur la plateforme et créez les
autres comptes depuis la page "Utilisateurs" (aucun besoin de relancer ce
script, sauf pour créer un deuxième admin en cas de mot de passe perdu).

Pour un déploiement automatisé sans interaction, vous pouvez à la place définir :
```bash
ADMIN_USERNAME=admin ADMIN_PASSWORD=motdepasse npm run seed:admin
```

## Lancer le serveur

En développement (redémarre automatiquement au moindre changement) :
```bash
npm run dev
```

En production :
```bash
npm run build
npm start
```

Le serveur écoute par défaut sur `http://0.0.0.0:5000` (ou le port choisi),
donc accessible depuis les autres postes du réseau via l'adresse IP de cette
machine (ex: `http://192.168.77.204:5000`).

## Garder le serveur actif en permanence

Pour un usage réel, utilisez un gestionnaire de process comme `pm2` afin que
le serveur redémarre automatiquement en cas de plantage ou de redémarrage de
la machine :

```bash
npm install -g pm2
pm2 start dist/index.js --name entraide-iam-server
pm2 save
pm2 startup
```

## Rôles des comptes

- **admin** : accès complet, y compris la gestion des comptes utilisateurs
- **editor** : peut consulter et modifier toutes les données (règles, lignes, corrections)
- **viewer** : lecture seule, ne peut ni ajouter ni modifier ni supprimer

## Structure

```
server/
  src/
    schema/          Définition des tables (Drizzle)
    routes/           Points d'entrée de l'API
    middleware/       Authentification et contrôle des rôles
    lib/               Utilitaires (mots de passe, jetons de session)
    scripts/          Script de création du compte admin
    app.ts             Assemblage de l'application Express
    index.ts          Point d'entrée
```
