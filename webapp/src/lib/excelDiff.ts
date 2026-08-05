import ExcelJS from 'exceljs';

export interface GenericSheet {
  headers: string[];
  rows: Record<string, string>[];
}

function cellToString(value: ExcelJS.CellValue): string {
  if (value === null || value === undefined) return '';
  if (value instanceof Date) return value.toLocaleDateString('fr-FR');
  if (typeof value === 'object' && 'result' in (value as object)) {
    return String((value as { result: unknown }).result ?? '');
  }
  return String(value).trim();
}

/** Lit un fichier Excel générique : première feuille, première ligne = en-têtes,
 *  tout le reste en texte. Ne fait aucune hypothèse métier — utilisé par
 *  l'outil de comparaison automatique (diff) entre deux exports. */
export async function parseGenericExcel(file: File): Promise<GenericSheet> {
  const buffer = await file.arrayBuffer();
  const workbook = new ExcelJS.Workbook();
  await workbook.xlsx.load(buffer);
  const sheet = workbook.worksheets[0];
  if (!sheet) return { headers: [], rows: [] };

  const headerRow = sheet.getRow(1);
  const headers: string[] = [];
  headerRow.eachCell({ includeEmpty: true }, (cell, colNumber) => {
    headers[colNumber] = cellToString(cell.value) || `Colonne ${colNumber}`;
  });

  const rows: Record<string, string>[] = [];
  sheet.eachRow((row, rowNumber) => {
    if (rowNumber === 1) return;
    const entry: Record<string, string> = {};
    let hasValue = false;
    row.eachCell({ includeEmpty: true }, (cell, colNumber) => {
      const header = headers[colNumber];
      if (!header) return;
      const v = cellToString(cell.value);
      if (v) hasValue = true;
      entry[header] = v;
    });
    if (hasValue) rows.push(entry);
  });

  return { headers: headers.filter(Boolean), rows };
}

export interface DiffChangedRow {
  key: string;
  before: Record<string, string>;
  after: Record<string, string>;
  changedFields: string[];
  montantChanged: boolean;
}

export interface DiffErrorRow {
  source: 'A' | 'B';
  row: Record<string, string>;
  reason: string;
}

export interface DiffResult {
  keyColumn: string;
  added: Record<string, string>[];
  removed: Record<string, string>[];
  changed: DiffChangedRow[];
  errors: DiffErrorRow[];
  unchangedCount: number;
}

const MONTANT_HINTS = ['MONTANT', 'MNT', 'AMOUNT', 'PRIX', 'COUT', 'COÛT'];

function isMontantColumn(header: string): boolean {
  const norm = header.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toUpperCase();
  return MONTANT_HINTS.some((h) => norm.includes(h));
}

/** Compare deux exports Excel (ex: deux instantanés du même fichier à un mois
 *  d'intervalle) en les rapprochant sur une colonne-clé (ex: CUSTCODE, ND,
 *  ICC...). Retourne les lignes ajoutées, supprimées, modifiées (avec le
 *  détail des champs qui diffèrent) et les erreurs (clé manquante). */
export function computeDiff(a: GenericSheet, b: GenericSheet, keyColumn: string): DiffResult {
  const errors: DiffErrorRow[] = [];

  const mapOf = (sheet: GenericSheet, source: 'A' | 'B') => {
    const map = new Map<string, Record<string, string>>();
    for (const row of sheet.rows) {
      const key = row[keyColumn]?.trim();
      if (!key) {
        errors.push({ source, row, reason: 'Valeur de la colonne-clé manquante' });
        continue;
      }
      map.set(key, row);
    }
    return map;
  };

  const mapA = mapOf(a, 'A');
  const mapB = mapOf(b, 'B');

  const added: Record<string, string>[] = [];
  const removed: Record<string, string>[] = [];
  const changed: DiffChangedRow[] = [];
  let unchangedCount = 0;

  const allFields = Array.from(new Set([...a.headers, ...b.headers])).filter((h) => h !== keyColumn);

  for (const [key, rowB] of mapB) {
    const rowA = mapA.get(key);
    if (!rowA) {
      added.push(rowB);
      continue;
    }
    const changedFields = allFields.filter((f) => (rowA[f] ?? '') !== (rowB[f] ?? ''));
    if (changedFields.length > 0) {
      changed.push({
        key,
        before: rowA,
        after: rowB,
        changedFields,
        montantChanged: changedFields.some(isMontantColumn)
      });
    } else {
      unchangedCount += 1;
    }
  }

  for (const [key, rowA] of mapA) {
    if (!mapB.has(key)) removed.push(rowA);
  }

  return { keyColumn, added, removed, changed, errors, unchangedCount };
}

/** Devine la meilleure colonne-clé commune aux deux fichiers (CUSTCODE, ND,
 *  ICC, REF...) pour pré-remplir le sélecteur — l'utilisateur peut toujours
 *  changer le choix. */
export function guessKeyColumn(headersA: string[], headersB: string[]): string | null {
  const common = headersA.filter((h) => headersB.includes(h));
  const hints = ['CUSTCODE', 'ND', 'ICC', 'REF_FACT', 'REFERENCE', 'CODE'];
  for (const hint of hints) {
    const match = common.find((h) => h.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toUpperCase().includes(hint));
    if (match) return match;
  }
  return common[0] ?? null;
}
