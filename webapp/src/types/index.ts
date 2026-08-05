// Types métier pour la plateforme de rapprochement de facturation IAM

export type FileRole = 'impayes' | 'reglements';

export interface ParsedRow {
  [column: string]: string | number | Date | null;
}

export interface ParsedSheet {
  sheetName: string;
  headerRowIndex: number; // index (0-based) de la ligne d'en-tête détectée dans la feuille source
  headers: string[]; // en-têtes détectés, dans l'ordre des colonnes
  rows: ParsedRow[]; // lignes de données, clés = en-têtes
  rowCount: number;
}

export interface ParsedFile {
  id: string;
  fileName: string;
  role: FileRole;
  sheets: ParsedSheet[];
  importedAt: string;
}

// Rôle fonctionnel d'une colonne, indépendant de son intitulé réel dans le fichier source
export type FieldKey = 'refFacture' | 'montant' | 'echeance' | 'custcode' | 'nom' | 'produit';

export const FIELD_LABELS: Record<FieldKey, string> = {
  refFacture: 'Référence facture',
  montant: 'Montant',
  echeance: 'Échéance',
  custcode: 'Code client',
  nom: 'Nom / Client',
  produit: 'Produit'
};

export interface ColumnMapping {
  refFacture: string | null;
  montant: string | null;
  echeance: string | null;
  custcode: string | null;
  nom: string | null;
  produit: string | null;
  // Correspondances des champs personnalisés (clé = CustomFieldDef.id),
  // ajoutées librement par l'utilisateur en plus des champs fixes ci-dessus.
  custom: Record<string, string | null>;
}

export interface SheetRule {
  fileId: string;
  fileName: string;
  role: FileRole;
  sheetName: string;
  mapping: ColumnMapping;
}

/** Champ personnalisé défini par l'utilisateur (ex: "ND-SUP / ND1") : permet de
 *  faire correspondre deux colonnes qui désignent la même chose mais portent
 *  des intitulés différents d'un fichier à l'autre (ex: ND1 dans les impayés
 *  et ND-SUP dans les règlements). Si useAsMatchKey est actif, cette
 *  correspondance est aussi utilisée comme clé alternative de rapprochement
 *  des factures, en plus de la référence facture. */
export interface CustomFieldDef {
  id: string;
  label: string;
  useAsMatchKey: boolean;
}

export type MatchStatus = 'reglee' | 'impayee';

export interface ComparisonRow {
  refFacture: string;
  status: MatchStatus;
  montant: number | null;
  echeance: string | null;
  custcode: string | null;
  nom: string | null;
  produit: string | null;
  // Valeurs des champs personnalisés pour cette ligne (clé = CustomFieldDef.id)
  custom: Record<string, string | null>;
  // Si la ligne est réglée grâce à un champ personnalisé (et pas la référence
  // facture directement), indique quel champ a permis le rapprochement.
  matchedByFieldId?: string;
  sourceFile: string;
  sourceSheet: string;
  matchedFile?: string;
  matchedSheet?: string;
}

export interface ComparisonSummary {
  total: number;
  reglees: number;
  impayees: number;
  montantTotal: number;
  montantRegle: number;
  montantImpaye: number;
  runAt: string;
}

export interface ComparisonResult {
  rows: ComparisonRow[];
  summary: ComparisonSummary;
}

/** Règle de correction : associe une feuille "source de vérité" (impayés) à
 *  une feuille "à corriger" (règlements), identifiées par leur nom (stable
 *  d'un import à l'autre et partagé entre postes), pas par un identifiant de
 *  fichier (généré côté client à chaque import, donc éphémère). Les deux
 *  feuilles doivent avoir le code client (custcode) et la référence facture
 *  (refFacture) mappés. */
export interface CorrectionRule {
  id: string;
  sourceSheetName: string;
  targetSheetName: string;
}

export type CorrectionStatus = 'remplacee' | 'inchangee' | 'conflit' | 'non_trouvee';

/** Résultat du calcul de correction pour une ligne de la feuille cible
 *  (règlements) : la référence facture est-elle remplacée, déjà bonne, en
 *  conflit (plusieurs candidates différentes côté source pour ce code
 *  client) ou introuvable (code client absent de la source) ? */
export interface CorrectionRowResult {
  targetRowIndex: number;
  custcode: string;
  originalRef: string;
  newRef: string | null;
  /** Échéance avant/après remplacement (seulement si le champ Échéance est
   *  mappé des deux côtés) : mise à jour en même temps que REF_FACT, comme le
   *  fait l'opérateur à chaque période. */
  originalEcheance?: string | null;
  newEcheance?: string | null;
  status: CorrectionStatus;
  /** Les factures candidates côté impayés quand plusieurs existaient pour ce
   *  client (référence + échéance de chacune), pour permettre un choix
   *  manuel dans l'interface. */
  candidates?: { ref: string; echeance: string | null }[];
  /** Comment le remplacement a été déterminé : uniquement par CUSTCODE, par
   *  CUSTCODE + MONTANT (désambiguïsation automatique), automatiquement sans
   *  critère fiable (plusieurs factures, choix du dernier candidat trouvé),
   *  ou par un choix manuel de l'utilisateur. */
  matchedBy?: 'custcode' | 'custcode+montant' | 'automatique' | 'manuel';
  /** Vrai si plusieurs factures candidates existaient côté impayés pour ce
   *  client : le remplacement a été fait mais mérite une relecture. */
  ambiguous?: boolean;
}

export interface CorrectionOutcome {
  rule: CorrectionRule;
  results: CorrectionRowResult[];
  summary: {
    total: number;
    remplacees: number;
    inchangees: number;
    conflits: number;
    nonTrouvees: number;
  };
}

export type Civilite = 'Mme' | 'Mlle' | 'M.';

/** Une ligne mobile/téléphonique gérée dans la page "Gestion des lignes"
 *  (indépendante des données de facturation : aucun lien avec CUSTCODE). */
export interface Ligne {
  id: string;
  categorie: string;
  typeForfait: string | null;
  typeMobile: string | null;
  icc: string | null;
  imei: string | null;
  affecte: string | null;
  /** Civilité de la personne bénéficiaire : Mme, Mlle ou M. */
  civilite: Civilite | null;
  personne: string | null;
  qualite: string | null;
  date: string | null;
  /** Code PIN / PUK de la carte SIM. */
  pin: string | null;
  puk: string | null;
  /** Rattachement structuré à l'organigramme (direction/service). */
  serviceId: number | null;
  consommationMensuelleDh: number | null;
  createdAt: string;
  updatedAt: string;
}

export type LigneInput = Omit<Ligne, 'id' | 'createdAt' | 'updatedAt'>;

/** Une ligne fixe (répertoire des lignes fixes de l'organisation, distinct
 *  de la flotte mobile). */
export interface LigneFixe {
  id: string;
  nd: string;
  custcode: string | null;
  coordinationRegionale: string | null;
  delegation: string | null;
  domiciliation: string | null;
  personne: string | null;
  qualite: string | null;
  date: string | null;
  serviceId: number | null;
  consommationMensuelleDh: number | null;
  createdAt: string;
  updatedAt: string;
}

export type LigneFixeInput = Omit<LigneFixe, 'id' | 'createdAt' | 'updatedAt'>;

export type FactureStatut = 'reglee' | 'impayee';

/** Une facture IAM persistée (enregistrée depuis une comparaison ou saisie
 *  manuellement) — voir page "Gestion des factures IAM". */
export interface Facture {
  id: string;
  custcode: string;
  nd: string | null;
  nom: string | null;
  refFacture: string;
  montant: number;
  mois: string | null;
  echeance: string | null;
  produit: string | null;
  statut: FactureStatut;
  sourceSheet: string | null;
  coordinationRegionale: string | null;
  delegation: string | null;
  domiciliation: string | null;
  createdAt: string;
  updatedAt: string;
}

export type FactureInput = Omit<Facture, 'id' | 'createdAt' | 'updatedAt'>;

/** Une entrée du registre "Journal" (abonnements presse par service) —
 *  reprend l'organigramme interne : Direction / Service + jusqu'à 3 titres
 *  de journaux (ex: L'Économiste, Al Massae...). */
export interface JournalEntry {
  id: string;
  direction: string | null;
  service: string;
  journal1: string | null;
  journal2: string | null;
  journal3: string | null;
  createdAt: string;
  updatedAt: string;
}

export type JournalEntryInput = Omit<JournalEntry, 'id' | 'createdAt' | 'updatedAt'>;
