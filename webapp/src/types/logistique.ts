export type ServiceRequestType =
  | 'vehicule' | 'deplacement' | 'telephone' | 'fourniture'
  | 'mobilier' | 'maintenance' | 'informatique' | 'batiment' | 'autre';

export type ServiceRequestPriority = 'normale' | 'urgente' | 'critique';

export type ServiceRequestStatus =
  | 'nouvelle' | 'validee_chef' | 'validee_responsable' | 'affectee'
  | 'en_cours' | 'terminee' | 'annulee' | 'archivee';

export interface ServiceRequest {
  id: number;
  numero: string;
  serviceDemandeurId: number;
  demandeurNom: string;
  demandeurTelephone: string | null;
  type: ServiceRequestType;
  objet: string;
  description: string | null;
  priorite: ServiceRequestPriority;
  statut: ServiceRequestStatus;
  agentAffecteId: number | null;
  dateSouhaitee: string | null;
  createdBy: string;
  createdAt: string;
  updatedAt: string;
}

export interface ServiceRequestEvent {
  id: number;
  requestId: number;
  statut: ServiceRequestStatus;
  commentaire: string | null;
  actionPar: string;
  createdAt: string;
}

export interface ServiceRequestCreateInput {
  serviceDemandeurId: number;
  demandeurNom: string;
  demandeurTelephone?: string;
  type: ServiceRequestType;
  objet: string;
  description?: string;
  priorite: ServiceRequestPriority;
  dateSouhaitee?: string;
}

export interface LogistiqueStats {
  todayCount: number;
  enAttente: number;
  urgentes: number;
  termineesMois: number;
  total: number;
  delaiMoyenHeures: number | null;
  parDirection: { name: string; count: number }[];
  parType: { type: ServiceRequestType; count: number }[];
  parStatut: { statut: ServiceRequestStatus; label: string; count: number }[];
}

export interface LogistiqueAgent {
  id: number;
  displayName: string | null;
  username: string;
  role: string;
}

export const TYPE_LABELS: Record<ServiceRequestType, string> = {
  vehicule: 'Véhicule',
  deplacement: 'Déplacement',
  telephone: 'Téléphonie',
  fourniture: 'Fournitures',
  mobilier: 'Mobilier',
  maintenance: 'Maintenance',
  informatique: 'Informatique',
  batiment: 'Bâtiment',
  autre: 'Autre'
};

export const PRIORITY_LABELS: Record<ServiceRequestPriority, string> = {
  normale: 'Normale',
  urgente: 'Urgente',
  critique: 'Critique'
};

export const STATUS_LABELS: Record<ServiceRequestStatus, string> = {
  nouvelle: 'Nouvelle',
  validee_chef: 'Validée (chef de service)',
  validee_responsable: 'Validée (responsable Logistique)',
  affectee: 'Affectée',
  en_cours: 'En cours',
  terminee: 'Terminée',
  annulee: 'Annulée',
  archivee: 'Archivée'
};

/** Ordre d'affichage logique du workflow (hors annulée/archivée, affichées
 *  séparément dans les filtres). */
export const STATUS_FLOW_ORDER: ServiceRequestStatus[] = [
  'nouvelle', 'validee_chef', 'validee_responsable', 'affectee', 'en_cours', 'terminee'
];

export const STATUS_TONE: Record<ServiceRequestStatus, 'default' | 'good' | 'bad'> = {
  nouvelle: 'default',
  validee_chef: 'default',
  validee_responsable: 'default',
  affectee: 'default',
  en_cours: 'default',
  terminee: 'good',
  annulee: 'bad',
  archivee: 'default'
};

export const PRIORITY_TONE: Record<ServiceRequestPriority, 'default' | 'good' | 'bad'> = {
  normale: 'default',
  urgente: 'bad',
  critique: 'bad'
};
