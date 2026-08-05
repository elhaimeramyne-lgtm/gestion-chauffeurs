# Gestion des Chauffeurs

Plateforme de gestion logistique : chauffeurs, véhicules, missions, parc auto.

## Stack
- **Frontend** : Vite + React + TypeScript + Tailwind CSS
- **Backend** : Express.js + Drizzle ORM + PostgreSQL

## Démarrage rapide
```bash
# 1. Backend
cd server
npm install
cp .env.example .env      # adapter DATABASE_URL et SESSION_SECRET
npm run dev               # démarre sur le port 5000

# 2. Frontend (autre terminal)
cd webapp
npm install
npm run dev               # démarre sur le port 5173
```

## Compte admin par défaut
- **Login** : admin
- **Mot de passe** : Admin123!
