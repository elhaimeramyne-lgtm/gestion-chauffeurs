import ExcelJS from 'exceljs';
import type { LigneFixeInput } from '../types';
import { normalizeHeader, formatDateFr } from './excel';

/** Correspondance entre en-têtes reconnus (normalisés) et champs de LigneFixe. */
const FIELD_HINTS: Record<keyof LigneFixeInput, string[]> = {
  nd: ['ND', 'NUMERO', 'NUMÉRO'],
  custcode: ['CUSTCODE', 'CODECLIENT', 'CODE CLIENT'],
  coordinationRegionale: ['COORDINATIONREGIONALE', 'COORDINATION REGIONALE', 'COORDINATION RÉGIONALE'],
  delegation: ['DELEGATION', 'DÉLÉGATION'],
  domiciliation: ['DOMICILIATION'],
  personne: ['PERSONNE', 'BENEFICIAIRE'],
  qualite: ['QUALITE', 'QUALITÉ'],
  date: ['DATE'],
  serviceId: ['SERVICEID', 'SERVICE'],
  consommationMensuelleDh: ['CONSOMMATION', 'CONSOMMATIONMENSUELLE', 'MONTANT']
};

function guessFieldForHeader(header: string): keyof LigneFixeInput | null {
  const norm = normalizeHeader(header);
  for (const [field, hints] of Object.entries(FIELD_HINTS) as [keyof LigneFixeInput, string[]][]) {
    if (hints.some((h) => norm.includes(h))) return field;
  }
  return null;
}

/** Lit un fichier Excel de lignes fixes (colonnes ND, CUSTCODE, COORDINATION
 *  REGIONALE, DELEGATION, DOMICILIATION, PERSONNE, QUALITE, DATE,
 *  CONSOMMATION — l'ordre et la casse n'ont pas d'importance) et retourne
 *  les lignes prêtes à insérer. */
export async function parseLignesFixesWorkbook(file: File): Promise<LigneFixeInput[]> {
  const buffer = await file.arrayBuffer();
  const workbook = new ExcelJS.Workbook();
  await workbook.xlsx.load(buffer);
  const sheet = workbook.worksheets[0];
  if (!sheet) return [];

  const headerRow = sheet.getRow(1);
  const columnFields: (keyof LigneFixeInput | null)[] = [];
  headerRow.eachCell({ includeEmpty: true }, (cell, colNumber) => {
    columnFields[colNumber] = guessFieldForHeader(String(cell.value ?? ''));
  });

  const rows: LigneFixeInput[] = [];
  sheet.eachRow((row, rowNumber) => {
    if (rowNumber === 1) return;
    const entry: Partial<Record<keyof LigneFixeInput, string>> = {};
    row.eachCell({ includeEmpty: true }, (cell, colNumber) => {
      const field = columnFields[colNumber];
      if (!field) return;
      const raw = cell.value;
      if (raw === null || raw === undefined || raw === '') return;
      entry[field] = field === 'date' ? formatDateFr(raw as string | number | Date) : String(raw);
    });
    if (Object.keys(entry).length === 0 || !entry.nd) return;
    rows.push({
      nd: entry.nd,
      custcode: entry.custcode ?? null,
      coordinationRegionale: entry.coordinationRegionale ?? null,
      delegation: entry.delegation ?? null,
      domiciliation: entry.domiciliation ?? null,
      personne: entry.personne ?? null,
      qualite: entry.qualite ?? null,
      date: entry.date ?? null,
      serviceId: entry.serviceId ? Number(entry.serviceId) : null,
      consommationMensuelleDh: entry.consommationMensuelleDh ? Number(entry.consommationMensuelleDh) : null
    });
  });

  return rows;
}
