/**
 * Miroir côté client de la machine à états définie dans
 * server/src/routes/logistique.ts. Sert uniquement à afficher/masquer les
 * bons boutons d'action — la validation faisant foi reste toujours
 * effectuée côté serveur.
 */
import type { ServiceRequestStatus } from '../types/logistique';

export type MinRole = 'USER' | 'GESTIONNAIRE' | 'ADMIN' | 'SUPER_ADMIN';

export interface Transition {
  to: ServiceRequestStatus;
  minRole: MinRole;
  requiresAgent?: boolean;
  label: string;
  tone: 'primary' | 'secondary' | 'danger';
}

export const TRANSITIONS: Record<ServiceRequestStatus, Transition[]> = {
  nouvelle: [
    { to: 'validee_chef', minRole: 'GESTIONNAIRE', label: 'Valider (chef de service)', tone: 'primary' },
    { to: 'annulee', minRole: 'USER', label: 'Annuler', tone: 'danger' }
  ],
  validee_chef: [
    { to: 'validee_responsable', minRole: 'ADMIN', label: 'Valider (responsable Logistique)', tone: 'primary' },
    { to: 'annulee', minRole: 'GESTIONNAIRE', label: 'Annuler', tone: 'danger' }
  ],
  validee_responsable: [
    { to: 'affectee', minRole: 'ADMIN', requiresAgent: true, label: 'Affecter un agent', tone: 'primary' },
    { to: 'annulee', minRole: 'ADMIN', label: 'Annuler', tone: 'danger' }
  ],
  affectee: [
    { to: 'en_cours', minRole: 'USER', label: 'Démarrer le traitement', tone: 'primary' },
    { to: 'annulee', minRole: 'GESTIONNAIRE', label: 'Annuler', tone: 'danger' }
  ],
  en_cours: [{ to: 'terminee', minRole: 'USER', label: 'Marquer comme terminée', tone: 'primary' }],
  terminee: [{ to: 'archivee', minRole: 'USER', label: 'Archiver', tone: 'secondary' }],
  annulee: [{ to: 'archivee', minRole: 'USER', label: 'Archiver', tone: 'secondary' }],
  archivee: []
};
