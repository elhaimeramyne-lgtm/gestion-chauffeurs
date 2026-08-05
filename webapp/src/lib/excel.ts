import ExcelJS from 'exceljs';
import type { FieldKey, ParsedFile, ParsedRow, ParsedSheet, FileRole } from '../types';

/** Normalise un intitulé de colonne pour permettre un rapprochement flou
 *  (accents, espaces, tirets/underscores, casse). */
export function normalizeHeader(value: unknown): string {
  return String(value ?? '')
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .toUpperCase()
    .replace(/[-_ ]+/g, '')
    .trim();
}

/** Dictionnaire de mots-clés connus pour reconnaître automatiquement le rôle
 *  fonctionnel d'une colonne, quel que soit son intitulé exact dans le fichier. */
const FIELD_KEYWORDS: Record<FieldKey, string[]> = {
  refFacture: ['REFFACT', 'REFERENCEFACTURE', 'NFACTURE', 'FACTURE'],
  montant: ['MONTANT', 'MNTFACT', 'MNT'],
  echeance: ['ECHEANCE'],
  custcode: ['CUSTCODE', 'CUSTODE', 'CODECLIENT'],
  nom: ['NOM', 'INTCLI', 'CLIENT'],
  produit: ['PRODUIT']
};

/** Mots-clés utilisés uniquement pour repérer la ligne d'en-tête dans la feuille
 *  (liste large, tous les intitulés rencontrés dans les fichiers réels). */
const HEADER_HINTS = [
  'REFFACT',
  'MONTANT',
  'MNTFACT',
  'ECHEANCE',
  'CUSTCODE',
  'CUSTODE',
  'NOM',
  'PRODUIT',
  'NDSUP',
  'ND1',
  'LOGIN',
  'MOIS',
  'INTCLI'
];

export function guessFieldForHeader(header: string): FieldKey | null {
  const norm = normalizeHeader(header);
  for (const [field, keywords] of Object.entries(FIELD_KEYWORDS) as [FieldKey, string[]][]) {
    if (keywords.some((kw) => norm.includes(kw))) return field;
  }
  return null;
}

/** Suggère, parmi les en-têtes d'une feuille, celui qui correspond le mieux à
 *  un champ personnalisé défini par l'utilisateur (ex: "ND-SUP" pour un
 *  champ nommé "ND1 / ND-SUP"), par comparaison des intitulés normalisés. */
export function guessColumnForCustomLabel(headers: string[], label: string): string | null {
  const normLabel = normalizeHeader(label);
  if (!normLabel) return null;
  // Correspondance exacte d'abord, puis inclusion dans un sens ou l'autre.
  const exact = headers.find((h) => normalizeHeader(h) === normLabel);
  if (exact) return exact;
  const partial = headers.find((h) => {
    const normHeader = normalizeHeader(h);
    return normHeader.includes(normLabel) || normLabel.includes(normHeader);
  });
  return partial ?? null;
}

/** Repère, parmi les 20 premières lignes d'une feuille, celle qui ressemble le
 *  plus à une ligne d'en-tête (le plus grand nombre de MOTS-CLÉS DISTINCTS
 *  reconnus). Les rapports Excel de gestion ont souvent des titres/bandeaux
 *  au-dessus du vrai tableau (ex: une cellule fusionnée "PRODUITS FIXE"
 *  répétée visuellement sur toute la largeur) : on les écarte explicitement
 *  car sinon un mot-clé comme "PRODUIT" y matcherait sur chaque colonne et
 *  ferait perdre à cette ligne-bandeau contre la vraie ligne d'en-tête. */
function detectHeaderRow(matrix: unknown[][]): number {
  let bestRow = 0;
  let bestScore = -1;
  const searchDepth = Math.min(matrix.length, 20);
  for (let r = 0; r < searchDepth; r++) {
    const row = matrix[r] ?? [];
    const normValues = row.map((cell) => normalizeHeader(cell)).filter(Boolean);
    if (normValues.length === 0) continue;

    // Une bannière/titre fusionné répète presque toujours la même valeur sur
    // (quasi) toute la ligne. Une vraie ligne d'en-tête a des intitulés
    // distincts d'une colonne à l'autre.
    const distinctValues = new Set(normValues);
    const isBanner = normValues.length >= 3 && distinctValues.size <= 2;
    if (isBanner) continue;

    // On compte les mots-clés DISTINCTS reconnus sur la ligne (pas le nombre
    // de cellules qui matchent), pour ne pas sur-pondérer une valeur répétée.
    const matchedHints = new Set<string>();
    for (const norm of normValues) {
      for (const hint of HEADER_HINTS) {
        if (norm.includes(hint)) matchedHints.add(hint);
      }
    }

    if (matchedHints.size > bestScore) {
      bestScore = matchedHints.size;
      bestRow = r;
    }
  }
  return bestScore > 0 ? bestRow : 0;
}

/** Certains rapports "fusionnent" visuellement des colonnes (CUSTCODE, ND-SUP...)
 *  en ne répétant la valeur que sur la première ligne d'un groupe. On complète
 *  les cellules vides avec la dernière valeur non vide de la colonne. */
function fillDown(rows: unknown[][], columnCount: number): unknown[][] {
  const lastSeen: unknown[] = new Array(columnCount).fill(null);
  return rows.map((row) => {
    const filled = [...row];
    for (let c = 0; c < columnCount; c++) {
      const isEmpty = filled[c] === null || filled[c] === undefined || filled[c] === '';
      if (isEmpty) {
        // On complète avec la dernière valeur non vide rencontrée dans cette
        // colonne (cas des cellules "fusionnées" visuellement : le code
        // client ou le ND-SUP n'est répété que sur la première ligne du groupe).
        filled[c] = lastSeen[c];
      } else {
        lastSeen[c] = filled[c];
      }
    }
    return filled;
  });
}

/** Convertit une feuille ExcelJS en matrice de valeurs brutes.
 *  N'inclut que les lignes qui contiennent réellement au moins une valeur :
 *  certains classeurs déclarent une plage utilisée bien plus grande que les
 *  données réelles (ex. mise en forme appliquée à des colonnes/lignes
 *  entières), ce qui ferait sinon itérer sur des centaines de milliers de
 *  lignes vides et bloquerait le navigateur. */
function sheetToMatrix(worksheet: ExcelJS.Worksheet): unknown[][] {
  const MAX_ROWS = 20000; // garde-fou de sécurité, largement suffisant pour ces rapports
  const matrix: unknown[][] = [];

  worksheet.eachRow({ includeEmpty: false }, (row) => {
    if (matrix.length >= MAX_ROWS) return;

    const colCount = row.cellCount; // uniquement les cellules réellement définies sur cette ligne
    const values: unknown[] = [];
    let hasValue = false;

    for (let c = 1; c <= colCount; c++) {
      const cell = row.getCell(c);
      let val: unknown = cell.value;
      if (val && typeof val === 'object' && 'result' in (val as any)) {
        val = (val as any).result;
      }
      if (val && typeof val === 'object' && 'richText' in (val as any)) {
        val = (val as any).richText.map((t: any) => t.text).join('');
      }
      if (val !== null && val !== undefined && String(val).trim() !== '') hasValue = true;
      values.push(val ?? null);
    }

    // On ignore les lignes qui n'ont qu'une mise en forme mais aucune valeur réelle
    if (hasValue) matrix.push(values);
  });

  return matrix;
}

function isRowEmpty(row: unknown[]): boolean {
  return row.every((v) => v === null || v === undefined || String(v).trim() === '');
}

/** Analyse une feuille brute et produit une structure {headers, rows} exploitable,
 *  en gérant la détection de l'en-tête et le remplissage des cellules fusionnées. */
export function parseSheet(worksheet: ExcelJS.Worksheet): ParsedSheet | null {
  const matrix = sheetToMatrix(worksheet);
  if (matrix.length === 0) return null;

  const headerRowIndex = detectHeaderRow(matrix);
  const headerRow = matrix[headerRowIndex] ?? [];
  const columnCount = headerRow.length;

  const headers = headerRow.map((h, i) => {
    const label = String(h ?? '').trim();
    return label || `Colonne ${i + 1}`;
  });

  // On ignore les colonnes totalement vides sans intitulé ET sans nom généré utile
  const dataRowsRaw = matrix.slice(headerRowIndex + 1).filter((r) => !isRowEmpty(r));
  const dataRowsFilled = fillDown(dataRowsRaw, columnCount);

  const rows: ParsedRow[] = dataRowsFilled.map((r) => {
    const obj: ParsedRow = {};
    headers.forEach((h, i) => {
      const raw = r[i];
      if (raw instanceof Date) {
        obj[h] = raw;
      } else if (typeof raw === 'number') {
        obj[h] = raw;
      } else if (raw === null || raw === undefined) {
        obj[h] = null;
      } else {
        obj[h] = String(raw).trim();
      }
    });
    return obj;
  });

  return {
    sheetName: worksheet.name,
    headerRowIndex,
    headers,
    rows,
    rowCount: rows.length
  };
}

export async function parseWorkbookFile(file: File, role: FileRole): Promise<ParsedFile> {
  const buffer = await file.arrayBuffer();
  const workbook = new ExcelJS.Workbook();
  await workbook.xlsx.load(buffer);

  const sheets: ParsedSheet[] = [];
  workbook.eachSheet((worksheet) => {
    const parsed = parseSheet(worksheet);
    if (parsed && parsed.rowCount > 0) sheets.push(parsed);
  });

  return {
    id: `${role}-${Date.now()}-${Math.round(Math.random() * 1000)}`,
    fileName: file.name,
    role,
    sheets,
    importedAt: new Date().toISOString()
  };
}

/** Normalise une référence de facture pour la comparaison (espaces, casse). */
export function normalizeRef(value: string | number | Date | null): string {
  if (value === null || value === undefined) return '';
  return String(value).trim().toUpperCase();
}

export function toNumber(value: string | number | Date | null): number | null {
  if (value === null || value === undefined || value === '') return null;
  if (typeof value === 'number') return value;
  const n = Number(String(value).replace(',', '.').replace(/\s/g, ''));
  return Number.isFinite(n) ? n : null;
}

const EXCEL_EPOCH_MS = Date.UTC(1899, 11, 30);

function excelSerialToDate(serial: number): Date {
  return new Date(EXCEL_EPOCH_MS + serial * 86400000);
}

/** Formate n'importe quelle date (objet Date, numéro de série Excel, ou texte
 *  dans des formats hétérogènes comme "1/31/23", "31/01/24" ou "31/01/2023")
 *  en un format unique et sans ambiguïté : jj/mm/année (jour et mois sur 2
 *  chiffres, année sur 4 chiffres). Si la valeur ne ressemble à aucune date
 *  reconnue, elle est renvoyée telle quelle. */
export function formatDateFr(value: string | number | Date | null | undefined): string {
  if (value === null || value === undefined || value === '') return '';

  let date: Date | null = null;

  if (value instanceof Date) {
    date = value;
  } else if (typeof value === 'number' && Number.isFinite(value)) {
    date = excelSerialToDate(value);
  } else {
    const str = String(value).trim();
    const match = str.match(/^(\d{1,4})[/\-.](\d{1,2})[/\-.](\d{1,4})$/);
    if (match) {
      const [, a, b, c] = match;
      let day: number;
      let month: number;
      let year: number;
      if (a.length === 4) {
        // Format ISO AAAA-MM-JJ
        year = Number(a);
        month = Number(b);
        day = Number(c);
      } else {
        const first = Number(a);
        const second = Number(b);
        // Un nombre > 12 ne peut être qu'un jour : ça lève l'ambiguïté entre
        // les formats JJ/MM (marocain/français) et MM/JJ (anglo-saxon).
        if (first > 12) {
          day = first;
          month = second;
        } else if (second > 12) {
          month = first;
          day = second;
        } else {
          // Vraiment ambigu (ex: "5/6/23") : on suppose JJ/MM par défaut.
          day = first;
          month = second;
        }
        year = Number(c);
        if (year < 100) year += 2000;
      }
      const candidate = new Date(year, month - 1, day);
      if (!Number.isNaN(candidate.getTime())) date = candidate;
    }
  }

  if (!date || Number.isNaN(date.getTime())) {
    return typeof value === 'string' ? value : String(value);
  }

  const dd = String(date.getDate()).padStart(2, '0');
  const mm = String(date.getMonth() + 1).padStart(2, '0');
  const yyyy = date.getFullYear();
  return `${dd}/${mm}/${yyyy}`;
}

export function toDateLabel(value: string | number | Date | null): string | null {
  if (!value) return null;
  return formatDateFr(value) || null;
}
