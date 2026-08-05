/**
 * Portail Chauffeur — redirigé vers maMission.
 *
 * Ce routeur est conservé pour la rétrocompatibilité avec les anciens
 * clients qui appellent encore les routes /chauffeur-portal/*.
 * Les nouvelles routes /ma-mission/* (voir maMission.ts) sont le portail
 * moderne avec le workflow complet à 9 statuts.
 *
 * Routes maintenues :
 *   GET  /chauffeur-portal/me              → alias vers /ma-mission
 *   GET  /chauffeur-portal/missions        → missions du chauffeur
 *   GET  /chauffeur-portal/missions/:id    → détail mission
 *
 * Les routes PATCH /statut ne sont PAS redirigées : les chauffeurs
 * doivent utiliser le nouveau portail /ma-mission qui gère les 9 statuts.
 * Les anciennes transition "planifie→en_cours→termine" ne sont plus
 * valides dans le nouveau workflow (creee→en_attente_acceptation→...).
 */
import { Router } from 'express';
import { getDeplacementDetail } from '../lib/missionEngine.js';
import { requireAuth } from '../middleware/auth.js';
import type { Request, Response, NextFunction } from 'express';

const router = Router();
router.use(requireAuth);

/** N'autorise que les comptes de rôle CHAUFFEUR sur ce routeur. */
function requireChauffeurRole(req: Request, res: Response, next: NextFunction) {
  if (req.user!.role !== 'CHAUFFEUR') {
    return res.status(403).json({ error: 'Ce portail est réservé aux comptes chauffeur.' });
  }
  next();
}
router.use('/chauffeur-portal', requireChauffeurRole);

/**
 * GET /chauffeur-portal/me
 * Anciennement renvoyait la fiche chauffeur.
 * Désormais redirige vers l'endpoint ma-mission qui donne la mission active.
 */
router.get('/chauffeur-portal/me', async (req, res) => {
  // Redirection transparente vers le nouveau portail
  res.json({
    message: 'Le portail chauffeur a été modernisé. Utilisez /ma-mission pour le nouveau portail.',
    redirectTo: '/api/ma-mission',
  });
});

/**
 * GET /chauffeur-portal/missions
 * Retourne les missions du chauffeur connecté en filtrant par
 * le champ chauffeurId qui correspond à son userId.
 */
router.get('/chauffeur-portal/missions', async (req, res) => {
  // Redirection vers le nouveau portail
  res.json({
    message: 'Le portail chauffeur a été modernisé. Utilisez /ma-mission pour le nouveau portail.',
    redirectTo: '/api/ma-mission',
    missions: [],
  });
});

/**
 * GET /chauffeur-portal/missions/:id
 * Retourne le détail d'une mission.
 */
router.get('/chauffeur-portal/missions/:id', async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });

  const detail = await getDeplacementDetail(id);
  if (!detail) return res.status(404).json({ error: 'Mission introuvable.' });

  // Vérifier que la mission appartient bien au chauffeur connecté
  if (detail.deplacement.chauffeurId !== req.user!.userId) {
    return res.status(403).json({ error: "Cette mission n'est pas la vôtre." });
  }

  res.json(detail);
});

export default router;

