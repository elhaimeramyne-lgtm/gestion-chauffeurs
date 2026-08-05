import ExcelJS from 'exceljs';
import type { JournalEntryInput } from '../types';
import { normalizeHeader } from './excel';

const FIELD_HINTS: Record<keyof JournalEntryInput, string[]> = {
  direction: ['DIRECTION'],
  service: ['SERVICE'],
  journal1: ['JOURNAL1', 'JOURNAL 1'],
  journal2: ['JOURNAL2', 'JOURNAL 2'],
  journal3: ['JOURNAL3', 'JOURNAL 3']
};

function guessFieldForHeader(header: string): keyof JournalEntryInput | null {
  const norm = normalizeHeader(header);
  // "JOURNAL 1" doit être testé avant "JOURNAL" seul seul pour éviter toute
  // ambiguïté ; ici les hints sont déjà assez spécifiques.
  for (const [field, hints] of Object.entries(FIELD_HINTS) as [keyof JournalEntryInput, string[]][]) {
    if (hints.some((h) => norm.includes(h))) return field;
  }
  // "LES JOURNAUX" seul (sans numéro) → première colonne journal libre
  if (norm.includes('JOURNAUX') || norm.includes('JOURNAL')) return 'journal1';
  return null;
}

/** Lit un fichier Excel du registre "Journal" (organigramme + jusqu'à 3
 *  titres de presse par service). Colonnes attendues : Direction, Service,
 *  Journal 1, Journal 2, Journal 3 — ordre et casse libres. */
export async function parseJournalWorkbook(file: File): Promise<JournalEntryInput[]> {
  const buffer = await file.arrayBuffer();
  const workbook = new ExcelJS.Workbook();
  await workbook.xlsx.load(buffer);
  const sheet = workbook.worksheets[0];
  if (!sheet) return [];

  const headerRow = sheet.getRow(1);
  const columnFields: (keyof JournalEntryInput | null)[] = [];
  const usedJournalCols = new Set<number>();
  headerRow.eachCell({ includeEmpty: true }, (cell, colNumber) => {
    let field = guessFieldForHeader(String(cell.value ?? ''));
    // Si plusieurs colonnes vides tombent sur "journal1" par défaut, décale
    // vers journal2 puis journal3 pour ne pas les écraser.
    if (field === 'journal1' || field === 'journal2' || field === 'journal3') {
      let candidate = field;
      while (usedJournalCols.has(['journal1', 'journal2', 'journal3'].indexOf(candidate))) {
        const next = { journal1: 'journal2', journal2: 'journal3', journal3: null }[candidate];
        if (!next) break;
        candidate = next as typeof field;
      }
      usedJournalCols.add(['journal1', 'journal2', 'journal3'].indexOf(candidate));
      field = candidate;
    }
    columnFields[colNumber] = field;
  });

  const rows: JournalEntryInput[] = [];
  sheet.eachRow((row, rowNumber) => {
    if (rowNumber === 1) return;
    const entry: Partial<JournalEntryInput> = {};
    row.eachCell({ includeEmpty: true }, (cell, colNumber) => {
      const field = columnFields[colNumber];
      if (!field) return;
      const raw = cell.value;
      if (raw === null || raw === undefined || raw === '') return;
      (entry as Record<string, string>)[field] = String(raw).trim();
    });
    if (!entry.service) return; // Service obligatoire : sans lui la ligne n'a pas de sens
    rows.push({
      direction: entry.direction ?? null,
      service: entry.service,
      journal1: entry.journal1 ?? null,
      journal2: entry.journal2 ?? null,
      journal3: entry.journal3 ?? null
    });
  });

  return rows;
}
