import ExcelJS from 'exceljs';
import type { LigneInput } from '../types';
import { normalizeHeader, formatDateFr } from './excel';

/** Correspondance entre en-têtes reconnus (normalisés) et champs de Ligne. */
const FIELD_HINTS: Record<keyof LigneInput, string[]> = {
  categorie: ['CATEGORIE', 'CATÉGORIE'],
  typeForfait: ['TYPEFORFAIT', 'FORFAIT'],
  typeMobile: ['TYPEMOBILE', 'MOBILE', 'TELEPHONE', 'APPAREIL'],
  icc: ['ICC'],
  imei: ['IMEI'],
  affecte: ['AFFECTE', 'AFFECTATION'],
  civilite: ['CIVILITE', 'CIVILITÉ'],
  personne: ['PERSONNE', 'BENEFICIAIRE'],
  qualite: ['QUALITE', 'QUALITÉ'],
  date: ['DATE'],
  pin: ['PIN'],
  puk: ['PUK'],
  serviceId: ['SERVICEID', 'SERVICE'],
  consommationMensuelleDh: ['CONSOMMATION', 'CONSOMMATIONMENSUELLE']
};

function guessFieldForHeader(header: string): keyof LigneInput | null {
  const norm = normalizeHeader(header);
  for (const [field, hints] of Object.entries(FIELD_HINTS) as [keyof LigneInput, string[]][]) {
    if (hints.some((h) => norm.includes(h))) return field;
  }
  return null;
}

/** Lit un fichier Excel de lignes mobiles (colonnes CATEGORIE, TYPE FORFAIT,
 *  TYPE MOBILE, ICC, IMEI, AFFECTE, PERSONNE, QUALITE, DATE — l'ordre et la
 *  casse n'ont pas d'importance) et retourne les lignes prêtes à insérer. */
export async function parseLignesWorkbook(file: File): Promise<LigneInput[]> {
  const buffer = await file.arrayBuffer();
  const workbook = new ExcelJS.Workbook();
  await workbook.xlsx.load(buffer);
  const sheet = workbook.worksheets[0];
  if (!sheet) return [];

  const headerRow = sheet.getRow(1);
  const columnFields: (keyof LigneInput | null)[] = [];
  headerRow.eachCell({ includeEmpty: true }, (cell, colNumber) => {
    columnFields[colNumber] = guessFieldForHeader(String(cell.value ?? ''));
  });

  const rows: LigneInput[] = [];
  sheet.eachRow((row, rowNumber) => {
    if (rowNumber === 1) return;
    const entry: Partial<LigneInput> = {};
    row.eachCell({ includeEmpty: true }, (cell, colNumber) => {
      const field = columnFields[colNumber];
      if (!field) return;
      const raw = cell.value;
      if (raw === null || raw === undefined || raw === '') return;
      (entry as Record<string, string>)[field] =
        field === 'date' ? formatDateFr(raw as string | number | Date) : String(raw);
    });
    if (Object.keys(entry).length === 0) return;
    rows.push({
      categorie: entry.categorie || 'CAT 1',
      typeForfait: entry.typeForfait ?? null,
      typeMobile: entry.typeMobile ?? null,
      icc: entry.icc ?? null,
      imei: entry.imei ?? null,
      affecte: entry.affecte ?? null,
      civilite: (entry.civilite as 'Mme' | 'Mlle' | 'M.' | undefined) ?? null,
      personne: entry.personne ?? null,
      qualite: entry.qualite ?? null,
      date: entry.date ?? null,
      pin: entry.pin ?? null,
      puk: entry.puk ?? null,
      serviceId: entry.serviceId ? Number(entry.serviceId) : null,
      consommationMensuelleDh: entry.consommationMensuelleDh ? Number(entry.consommationMensuelleDh) : null
    });
  });

  return rows;
}
