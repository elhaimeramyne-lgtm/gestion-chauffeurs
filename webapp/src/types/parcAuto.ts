export type VehiculeStatut = 'disponible' | 'en_mission' | 'maintenance' | 'hors_service';
export type VehiculeCarburant = 'essence' | 'diesel' | 'hybride' | 'electrique';

export interface MissionActuelle {
  numero: string;
  destination: string | null;
  chauffeurNom: string | null;
  dateDepart: string;
  dateRetourPrevue: string | null;
}

export type EtatPneus = 'bon_etat' | 'usure_avant' | 'usure_arriere' | 'crevaison' | 'pression_faible';
export type EtatBatterie = 'bonne' | 'faible' | 'a_remplacer';
export type EtatFreins = 'normaux' | 'bruit' | 'usure';
export type EtatEclairage = 'fonctionnel' | 'ampoule_grillee';
export type EtatClimatisation = 'fonctionne' | 'panne';

export interface Vehicule {
  id: number;
  immatriculation: string;
  marque: string;
  modele: string;
  annee: number | null;
  carburant: VehiculeCarburant;
  kilometrage: number;
  statut: VehiculeStatut;
  assuranceExpiration: string | null;
  visiteTechniqueExpiration: string | null;
  derniereVidange: string | null;
  vidangeExpiration: string | null;
  kilometrageDerniereVidange: number | null;
  kilometrageProchaineVidange: number | null;
  typeHuile: string | null;
  garageVidange: string | null;
  vidangeObservations: string | null;
  jawazNumero: string | null;
  jawazSolde: number;
  jawazDerniereRecharge: string | null;
  jawazSeuilAlerte: number;
  chauffeurAttitreId: number | null;
  photoUrl: string | null;
  etatPneus: EtatPneus | null;
  etatBatterie: EtatBatterie | null;
  etatFreins: EtatFreins | null;
  etatEclairage: EtatEclairage | null;
  etatClimatisation: EtatClimatisation | null;
  notes: string | null;
  missionActuelle: MissionActuelle | null;
  createdAt: string;
  updatedAt: string;
}

export interface VehiculeEvent {
  id: number;
  vehiculeId: number;
  statut: VehiculeStatut;
  commentaire: string | null;
  actionPar: string;
  createdAt: string;
}

/** Historique des affectations (responsabilité) d'un véhicule. */
export interface VehiculeAffectation {
  id: number;
  vehiculeId: number;
  chauffeurId: number;
  chauffeurNom: string;
  dateAffectation: string;
  dateFin: string | null;
  responsable: string;
  createdAt: string;
}

export interface VehiculeCreateInput {
  immatriculation: string;
  marque: string;
  modele: string;
  annee?: number;
  carburant: VehiculeCarburant;
  kilometrage: number;
  assuranceExpiration?: string;
  visiteTechniqueExpiration?: string;
  derniereVidange?: string;
  vidangeExpiration?: string;
  kilometrageDerniereVidange?: number;
  kilometrageProchaineVidange?: number;
  typeHuile?: string;
  garageVidange?: string;
  vidangeObservations?: string;
  jawazNumero?: string;
  jawazSolde?: number;
  jawazDerniereRecharge?: string;
  jawazSeuilAlerte?: number;
  chauffeurAttitreId?: number | null;
  etatPneus?: EtatPneus | null;
  etatBatterie?: EtatBatterie | null;
  etatFreins?: EtatFreins | null;
  etatEclairage?: EtatEclairage | null;
  etatClimatisation?: EtatClimatisation | null;
  notes?: string;
}

export interface ParcAutoStats {
  total: number;
  disponibles: number;
  enMission: number;
  enMaintenance: number;
  horsService: number;
  echeancesProches: number;
}

/* ═══════════════════════════════════════════════════════════════════════
 * WORKFLOW MISSION — 9+ statuts
 * ═══════════════════════════════════════════════════════════════════════ */

export type DeplacementStatut =
  | 'creee'
  | 'en_attente_acceptation'
  | 'acceptee'
  | 'en_route'
  | 'arrive'
  | 'mission_en_cours'
  | 'terminee'
  | 'retour'
  | 'arrive_siege'
  | 'cloturee'
  | 'annule';

export interface Deplacement {
  id: number;
  numero: string;
  vehiculeId: number | null;
  chauffeurId: number | null;
  demandeId: number | null;
  serviceDemandeurId: number;
  objet: string;
  destination: string | null;
  dateDepart: string;
  dateRetourPrevue: string | null;
  dateRetourEffective: string | null;
  kilometrageDepart: number | null;
  kilometrageRetour: number | null;
  statut: DeplacementStatut;
  rapportMission: string | null;
  createdBy: string;

  // Nouveaux champs temporels
  heureDepartPrevue: string | null;
  heureDepartReelle: string | null;
  heureArriveeReelle: string | null;
  heureRetourReelle: string | null;
  heureCloture: string | null;
  dateDepartReelle: string | null;
  dateArriveeReelle: string | null;
  dateRetourReelle: string | null;
  dateCloture: string | null;
  acceptedAt: string | null;
  acceptedBy: string | null;

  // Signatures
  signatureChauffeur: string | null;
  signatureResponsable: string | null;

  // Métriques
  dureeMission: number | null;
  distanceKm: number | null;
  consommationCarburant: number | null;

  // Observations
  observationsChauffeur: string | null;
  notesCloture: string | null;

  // Champs hérités
  observations: string | null;
  heureDepart: string | null;

  deletedAt: string | null;
  deletedBy: string | null;
  createdAt: string;
  updatedAt: string;
}

export interface DeplacementPassager {
  id: number;
  deplacementId: number;
  nom: string;
  serviceId: number | null;
}

export interface PassagerInput {
  nom: string;
  serviceId?: number | null;
}

export interface DeplacementCreateInput {
  vehiculeId: number;
  chauffeurId?: number;
  demandeId?: number;
  serviceDemandeurId: number;
  objet: string;
  destination?: string;
  dateDepart: string;
  dateRetourPrevue?: string;
  heureDepartPrevue?: string;
  observations?: string;
  passagers?: PassagerInput[];
}

/* ═══════════════════════════════════════════════════════════════════════
 * TYPES DE LA TIMELINE / PHOTOS / GPS
 * ═══════════════════════════════════════════════════════════════════════ */

export interface MissionEvent {
  id: number;
  deplacementId: number;
  statut: string;
  commentaire: string | null;
  latitude: string | null;
  longitude: string | null;
  vitesse: number | null;
  actionPar: string;
  createdAt: string;
}

export interface MissionPhoto {
  id: number;
  deplacementId: number;
  type: 'depart' | 'arrivee' | 'bon_livraison' | 'retour' | 'autre';
  filename: string;
  originalName: string | null;
  mimeType: string | null;
  sizeBytes: number | null;
  uploadedBy: string;
  createdAt: string;
}

export interface GpsPoint {
  id: number;
  deplacementId: number;
  latitude: number;
  longitude: number;
  vitesse: number | null;
  precision: number | null;
  cap: number | null;
  createdAt: string;
}

export interface DeplacementDetail {
  deplacement: Deplacement;
  events: MissionEvent[];
  photos: MissionPhoto[];
  gpsPoints: GpsPoint[];
  passagers?: DeplacementPassager[];
}

/* ═══════════════════════════════════════════════════════════════════════
 * TYPE POUR LA CARTE TEMPS RÉEL
 * ═══════════════════════════════════════════════════════════════════════ */

export interface ActiveMission {
  deplacement: Deplacement;
  vehicule: Vehicule | null;
  chauffeur: Chauffeur | null;
  lastGpsPoint: GpsPoint | null;
  gpsPoints: GpsPoint[];
  etapeOrdre: number;
}

/* ═══════════════════════════════════════════════════════════════════════
 * CONSTANTES UI
 * ═══════════════════════════════════════════════════════════════════════ */

export const VEHICULE_STATUT_LABELS: Record<VehiculeStatut, string> = {
  disponible: 'Disponible',
  en_mission: 'En mission',
  maintenance: 'En maintenance',
  hors_service: 'Hors service'
};

export const VEHICULE_STATUT_TONE: Record<VehiculeStatut, 'default' | 'good' | 'bad' | 'warn' | 'info'> = {
  disponible: 'good',
  en_mission: 'warn',
  maintenance: 'info',
  hors_service: 'bad'
};

export const CARBURANT_LABELS: Record<VehiculeCarburant, string> = {
  essence: 'Essence',
  diesel: 'Diesel',
  hybride: 'Hybride',
  electrique: 'Électrique'
};

/** Ordre des étapes dans le workflow. */
export const DEPLACEMENT_ETAPES: DeplacementStatut[] = [
  'creee',
  'en_attente_acceptation',
  'acceptee',
  'en_route',
  'arrive',
  'mission_en_cours',
  'terminee',
  'retour',
  'arrive_siege',
  'cloturee',
];

export const DEPLACEMENT_STATUT_LABELS: Record<DeplacementStatut, string> = {
  creee: 'Créée',
  en_attente_acceptation: 'En attente',
  acceptee: 'Acceptée',
  en_route: 'En route',
  arrive: 'Arrivé',
  mission_en_cours: 'Mission en cours',
  terminee: 'Terminée',
  retour: 'Retour',
  arrive_siege: 'Arrivé au siège',
  cloturee: 'Clôturée',
  annule: 'Annulée',
};

export const DEPLACEMENT_STATUT_TONE: Record<DeplacementStatut, 'default' | 'good' | 'bad' | 'warn' | 'info'> = {
  creee: 'default',
  en_attente_acceptation: 'warn',
  acceptee: 'good',
  en_route: 'info',
  arrive: 'info',
  mission_en_cours: 'good',
  terminee: 'good',
  retour: 'warn',
  arrive_siege: 'info',
  cloturee: 'good',
  annule: 'bad',
};

export const DEPLACEMENT_ETAPE_COLOR: Record<DeplacementStatut, string> = {
  creee: '#6b7280',
  en_attente_acceptation: '#f59e0b',
  acceptee: '#22c55e',
  en_route: '#3b82f6',
  arrive: '#8b5cf6',
  mission_en_cours: '#22c55e',
  terminee: '#14b8a6',
  retour: '#f97316',
  arrive_siege: '#06b6d4',
  cloturee: '#10b981',
  annule: '#ef4444',
};

/** Actions disponibles pour le chauffeur en fonction du statut actuel. */
export const NEXT_ACTION: Partial<Record<DeplacementStatut, { endpoint: string; label: string; icon: string }>> = {
  en_attente_acceptation: { endpoint: 'accept', label: 'Accepter la mission', icon: 'CheckCircle2' },
  acceptee: { endpoint: 'demarrer', label: 'Démarrer la mission', icon: 'Gauge' },
  en_route: { endpoint: 'arrivee', label: 'Je suis arrivé', icon: 'MapPin' },
  arrive: { endpoint: 'commencer', label: 'Commencer la mission', icon: 'Play' },
  mission_en_cours: { endpoint: 'terminer', label: 'Terminer la mission', icon: 'Flag' },
  terminee: { endpoint: 'retour', label: 'Retour au siège', icon: 'Navigation' },
  retour: { endpoint: 'arrive-siege', label: 'Arrivé au siège', icon: 'Home' },
};

/* ── Chauffeurs ──────────────────────────────────────────────────── */
export type ChauffeurStatut = 'disponible' | 'en_mission' | 'indisponible' | 'en_conge' | 'absent';

/** Catégories de permis de conduire marocaines couramment utilisées. */
export const PERMIS_CATEGORIES = ['A', 'B', 'C', 'D', 'EB', 'EC'] as const;
export type PermisCategorie = typeof PERMIS_CATEGORIES[number];

export interface VehiculeResume {
  id: number;
  immatriculation: string;
  marque: string;
  modele: string;
}

export interface Chauffeur {
  id: number;
  // Informations générales
  nom: string;
  cin: string | null;
  telephone: string | null;
  email: string | null;
  adresse: string | null;
  dateNaissance: string | null;
  photoUrl: string | null;
  // Permis
  permis: string | null; // catégories, ex. "B, EC"
  permisNumero: string | null;
  permisDateObtention: string | null;
  permisDateExpiration: string | null;
  // Affectation
  serviceId: number | null;
  responsable: string | null;
  vehiculeHabituel: VehiculeResume | null;
  // Statut & Jawaz personnel
  statut: ChauffeurStatut;
  jawazNumero: string | null;
  jawazSolde: number;
  // Documents
  scanCinUrl: string | null;
  scanPermisUrl: string | null;
  certificatMedicalUrl: string | null;
  // Notes
  notes: string | null; // Observations
  remarques: string | null;
  userId: number | null;
  createdAt: string;
  updatedAt: string;
}

export interface ChauffeurCreateInput {
  nom: string;
  cin?: string;
  telephone?: string;
  email?: string;
  adresse?: string;
  dateNaissance?: string;
  permis?: string;
  permisNumero?: string;
  permisDateObtention?: string;
  permisDateExpiration?: string;
  serviceId?: number | null;
  responsable?: string;
  vehiculeHabituelId?: number | null;
  notes?: string;
  remarques?: string;
  jawazNumero?: string;
  jawazSolde?: number;
}

export const CHAUFFEUR_STATUT_LABELS: Record<ChauffeurStatut, string> = {
  disponible: 'Disponible',
  en_mission: 'En mission',
  indisponible: 'Indisponible',
  en_conge: 'En congé',
  absent: 'Absent'
};

export const CHAUFFEUR_STATUT_TONE: Record<ChauffeurStatut, 'default' | 'good' | 'bad' | 'warn' | 'info'> = {
  disponible: 'good',
  en_mission: 'warn',
  indisponible: 'bad',
  en_conge: 'info',
  absent: 'bad'
};

/* ═══════════════════════════════════════════════════════════════════════
 * MODULE MAINTENANCE
 * ═══════════════════════════════════════════════════════════════════════ */

export type MaintenanceType =
  | 'vidange' | 'pneus' | 'batterie' | 'freins' | 'embrayage'
  | 'courroie' | 'reparation' | 'accident' | 'autre';

export const MAINTENANCE_TYPE_LABELS: Record<MaintenanceType, string> = {
  vidange: 'Vidange',
  pneus: 'Pneus',
  batterie: 'Batterie',
  freins: 'Freins',
  embrayage: 'Embrayage',
  courroie: 'Courroie',
  reparation: 'Réparation',
  accident: 'Accident',
  autre: 'Autre'
};

export const MAINTENANCE_TYPE_COLOR: Record<MaintenanceType, string> = {
  vidange: '#38bdf8',
  pneus: '#a78bfa',
  batterie: '#fbbf24',
  freins: '#f87171',
  embrayage: '#fb923c',
  courroie: '#34d399',
  reparation: '#60a5fa',
  accident: '#ef4444',
  autre: '#94a3b8'
};

export interface MaintenanceDocument {
  id: number;
  maintenanceId: number;
  type: 'facture' | 'document';
  filename: string;
  url: string;
  originalName: string | null;
  mimeType: string | null;
  sizeBytes: number | null;
  uploadedBy: string;
  createdAt: string;
}

export interface MaintenanceRecord {
  id: number;
  vehiculeId: number;
  vehicule?: VehiculeResume;
  type: MaintenanceType;
  date: string;
  kilometrage: number | null;
  garage: string | null;
  description: string | null;
  piecesRemplacees: string | null;
  cout: number;
  createdBy: string;
  documents: MaintenanceDocument[];
  createdAt: string;
  updatedAt: string;
}

export interface MaintenanceCreateInput {
  vehiculeId: number;
  type: MaintenanceType;
  date: string;
  kilometrage?: number;
  garage?: string;
  description?: string;
  piecesRemplacees?: string;
  cout?: number;
}

/* ═══════════════════════════════════════════════════════════════════════
 * ÉTATS DÉCLARÉS PAR LE CHAUFFEUR (portail — "Mon véhicule")
 * ═══════════════════════════════════════════════════════════════════════ */

export const ETAT_PNEUS_LABELS: Record<EtatPneus, string> = {
  bon_etat: 'Bon état', usure_avant: 'Usure avant', usure_arriere: 'Usure arrière',
  crevaison: 'Crevaison', pression_faible: 'Pression faible'
};
export const ETAT_PNEUS_TONE: Record<EtatPneus, 'default' | 'good' | 'bad' | 'warn' | 'info'> = {
  bon_etat: 'good', usure_avant: 'warn', usure_arriere: 'warn', crevaison: 'bad', pression_faible: 'warn'
};
export const ETAT_BATTERIE_LABELS: Record<EtatBatterie, string> = { bonne: 'Bonne', faible: 'Faible', a_remplacer: 'À remplacer' };
export const ETAT_BATTERIE_TONE: Record<EtatBatterie, 'default' | 'good' | 'bad' | 'warn' | 'info'> = { bonne: 'good', faible: 'warn', a_remplacer: 'bad' };
export const ETAT_FREINS_LABELS: Record<EtatFreins, string> = { normaux: 'Normaux', bruit: 'Bruit', usure: 'Usure' };
export const ETAT_FREINS_TONE: Record<EtatFreins, 'default' | 'good' | 'bad' | 'warn' | 'info'> = { normaux: 'good', bruit: 'warn', usure: 'bad' };
export const ETAT_ECLAIRAGE_LABELS: Record<EtatEclairage, string> = { fonctionnel: 'Fonctionnel', ampoule_grillee: 'Ampoule grillée' };
export const ETAT_ECLAIRAGE_TONE: Record<EtatEclairage, 'default' | 'good' | 'bad' | 'warn' | 'info'> = { fonctionnel: 'good', ampoule_grillee: 'warn' };
export const ETAT_CLIMATISATION_LABELS: Record<EtatClimatisation, string> = { fonctionne: 'Fonctionne', panne: 'Panne' };
export const ETAT_CLIMATISATION_TONE: Record<EtatClimatisation, 'default' | 'good' | 'bad' | 'warn' | 'info'> = { fonctionne: 'good', panne: 'bad' };

/* ═══════════════════════════════════════════════════════════════════════
 * DÉCLARATIONS CHAUFFEUR — "Signaler un problème"
 * ═══════════════════════════════════════════════════════════════════════ */

export type DeclarationCategorie =
  | 'vidange' | 'pneus' | 'batterie' | 'freins' | 'embrayage' | 'moteur'
  | 'climatisation' | 'carrosserie' | 'jawaz' | 'assurance' | 'autre';
export type DeclarationUrgence = 'normal' | 'urgent' | 'critique';
export type DeclarationStatut = 'nouvelle' | 'en_cours' | 'validee' | 'reparation_programmee' | 'terminee' | 'archivee';

export const DECLARATION_CATEGORIES: DeclarationCategorie[] = [
  'vidange', 'pneus', 'batterie', 'freins', 'embrayage', 'moteur', 'climatisation', 'carrosserie', 'jawaz', 'assurance', 'autre'
];
export const DECLARATION_CATEGORIE_LABELS: Record<DeclarationCategorie, string> = {
  vidange: 'Vidange', pneus: 'Pneus', batterie: 'Batterie', freins: 'Freins', embrayage: 'Embrayage',
  moteur: 'Moteur', climatisation: 'Climatisation', carrosserie: 'Carrosserie', jawaz: 'Jawaz', assurance: 'Assurance', autre: 'Autre'
};
export const DECLARATION_URGENCE_LABELS: Record<DeclarationUrgence, string> = { normal: 'Normal', urgent: 'Urgent', critique: 'Critique' };
export const DECLARATION_URGENCE_TONE: Record<DeclarationUrgence, 'default' | 'good' | 'bad' | 'warn' | 'info'> = { normal: 'info', urgent: 'warn', critique: 'bad' };
export const DECLARATION_STATUTS: DeclarationStatut[] = ['nouvelle', 'en_cours', 'validee', 'reparation_programmee', 'terminee', 'archivee'];
export const DECLARATION_STATUT_LABELS: Record<DeclarationStatut, string> = {
  nouvelle: 'Nouvelle', en_cours: 'En cours', validee: 'Validée',
  reparation_programmee: 'Réparation programmée', terminee: 'Terminée', archivee: 'Archivée'
};
export const DECLARATION_STATUT_TONE: Record<DeclarationStatut, 'default' | 'good' | 'bad' | 'warn' | 'info'> = {
  nouvelle: 'bad', en_cours: 'warn', validee: 'info', reparation_programmee: 'info', terminee: 'good', archivee: 'default'
};

export interface DeclarationMedia {
  id: number;
  declarationId: number;
  type: 'photo' | 'video';
  filename: string;
  url: string;
  originalName: string | null;
  mimeType: string | null;
  sizeBytes: number | null;
  uploadedBy: string;
  createdAt: string;
}

export interface DeclarationEvent {
  id: number;
  declarationId: number;
  statut: DeclarationStatut;
  commentaire: string | null;
  actionPar: string;
  createdAt: string;
}

export interface Declaration {
  id: number;
  vehiculeId: number;
  chauffeurId: number;
  vehicule: VehiculeResume | null;
  chauffeur: { id: number; nom: string } | null;
  categorie: DeclarationCategorie;
  description: string | null;
  urgence: DeclarationUrgence;
  statut: DeclarationStatut;
  commentaireTraitement: string | null;
  traitePar: string | null;
  mediaCount?: number;
  media?: DeclarationMedia[];
  events?: DeclarationEvent[];
  createdAt: string;
  updatedAt: string;
}

export interface DeclarationCreateInput {
  categorie: DeclarationCategorie;
  description?: string;
  urgence: DeclarationUrgence;
}

export interface DeclarationsResume {
  nouvelles: number;
  urgentes: number;
  enCours: number;
  termineesCetteSemaine: number;
}

/* ═══════════════════════════════════════════════════════════════════════
 * ALERTES (Parc Automobile / Chauffeurs)
 * ═══════════════════════════════════════════════════════════════════════ */

export type AlerteNiveau = 'orange' | 'rouge';
export type AlerteType =
  | 'assurance' | 'visite_technique' | 'vidange' | 'jawaz' | 'vehicule_indisponible' | 'permis'
  | 'pneus' | 'etat_vehicule';

export interface Alerte {
  type: AlerteType;
  niveau: AlerteNiveau;
  message: string;
  vehiculeId?: number;
  chauffeurId?: number;
}

export interface AlertesResume {
  vehiculesAAssurer: number;
  visitesExpirees: number;
  vidangesAFaire: number;
  jawazARecharger: number;
  permisExpires: number;
  pneusAlerte: number;
  etatVehiculeAlerte: number;
  total: number;
  alertes: Alerte[];
}
