import { Router } from 'express';
import { requireAuth, requirePermission } from '../middleware/auth.js';

const router = Router();
router.use(requireAuth);

/** Matrice de permissions statique (le modèle de rôles est fixe :
 *  SUPER_ADMIN > ADMIN > CHEF_DIVISION > GESTIONNAIRE > USER > CHAUFFEUR,
 *  ce dernier hors hiérarchie métier — voir routes/chauffeurPortal.ts).
 *  Exposée en lecture pour que les administrateurs puissent voir
 *  précisément qui peut faire quoi, sans avoir à lire le code serveur. */
const MATRIX = [
  {
    key: 'business.read',
    label: 'Consulter les modules métier (import, lignes, rapports...)',
    roles: ['USER', 'GESTIONNAIRE', 'CHEF_DIVISION', 'ADMIN', 'SUPER_ADMIN']
  },
  {
    key: 'business.write',
    label: 'Créer / modifier dans les modules métier',
    roles: ['USER', 'GESTIONNAIRE', 'CHEF_DIVISION', 'ADMIN', 'SUPER_ADMIN']
  },
  { key: 'business.delete', label: 'Supprimer dans les modules métier', roles: ['GESTIONNAIRE', 'CHEF_DIVISION', 'ADMIN', 'SUPER_ADMIN'] },
  { key: 'dashboard.view', label: 'Voir le tableau de bord Executive', roles: ['GESTIONNAIRE', 'CHEF_DIVISION', 'ADMIN', 'SUPER_ADMIN'] },
  { key: 'users.view', label: 'Voir la liste des utilisateurs', roles: ['ADMIN', 'SUPER_ADMIN'] },
  { key: 'users.manage_users', label: 'Gérer les comptes CHEF_DIVISION / GESTIONNAIRE / USER / CHAUFFEUR', roles: ['ADMIN', 'SUPER_ADMIN'] },
  { key: 'users.manage_admins', label: 'Gérer les comptes ADMIN / SUPER_ADMIN', roles: ['SUPER_ADMIN'] },
  { key: 'audit.view', label: "Voir l'historique des actions et le journal des connexions", roles: ['ADMIN', 'SUPER_ADMIN'] },
  { key: 'settings.manage', label: 'Paramètres système, sauvegardes, journal système', roles: ['SUPER_ADMIN'] },
  { key: 'trash.manage', label: 'Corbeille et restauration', roles: ['SUPER_ADMIN'] },
  {
    key: 'chauffeur.portal',
    label: 'Portail chauffeur (uniquement ses propres missions)',
    roles: ['CHAUFFEUR']
  }
];

router.get('/permissions/matrix', requirePermission('users.view'), (_req, res) => {
  res.json({ roles: ['CHAUFFEUR', 'USER', 'GESTIONNAIRE', 'CHEF_DIVISION', 'ADMIN', 'SUPER_ADMIN'], permissions: MATRIX });
});

export default router;
