import ExcelJS from 'exceljs';
import { ENTRAIDE_LOGO_NEW_B64 } from './logoNewBase64';

const NAVY = 'FF0B1023';
const VIOLET = 'FFA855F7';
const TEXT_MUTED = 'FFCBD5E1';

/** Ajoute un bandeau d'en-tête pro (logo + titre + sous-titre) en haut d'une
 *  feuille, sur fond marine assorti à l'identité "Aurora" de la plateforme.
 *  Retourne le numéro de la première ligne libre pour la suite du contenu. */
export function addPremiumHeader(
  workbook: ExcelJS.Workbook,
  sheet: ExcelJS.Worksheet,
  opts: { title: string; subtitle?: string; columnCount: number }
): number {
  const columnCount = Math.max(opts.columnCount, 4);

  try {
    const imageId = workbook.addImage({ base64: ENTRAIDE_LOGO_NEW_B64, extension: 'png' });
    sheet.addImage(imageId, { tl: { col: 0.15, row: 0.15 }, ext: { width: 130, height: 34 } });
  } catch {
    // Si l'image ne peut pas être intégrée (environnement restreint), le
    // reste de l'export continue sans logo plutôt que d'échouer.
  }

  sheet.mergeCells(1, 3, 1, columnCount);
  const titleCell = sheet.getCell(1, 3);
  titleCell.value = opts.title;
  titleCell.font = { bold: true, size: 15, color: { argb: 'FFFFFFFF' } };
  titleCell.alignment = { vertical: 'middle' };

  sheet.mergeCells(2, 3, 2, columnCount);
  const subCell = sheet.getCell(2, 3);
  subCell.value = opts.subtitle ?? `Généré le ${new Date().toLocaleString('fr-FR')}`;
  subCell.font = { italic: true, size: 10, color: { argb: TEXT_MUTED } };
  subCell.alignment = { vertical: 'middle' };

  for (let r = 1; r <= 3; r++) {
    const row = sheet.getRow(r);
    row.height = r === 1 ? 30 : r === 2 ? 18 : 6;
    for (let c = 1; c <= columnCount; c++) {
      row.getCell(c).fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: NAVY } };
    }
  }
  // Liseré violet sous le bandeau
  const accentRow = sheet.getRow(4);
  accentRow.height = 3;
  for (let c = 1; c <= columnCount; c++) {
    accentRow.getCell(c).fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: VIOLET } };
  }

  return 6; // première ligne libre pour le contenu
}

/** Style d'en-tête de tableau (fond marine, texte blanc, gras). */
export function styleTableHeader(row: ExcelJS.Row) {
  row.eachCell((cell) => {
    cell.font = { bold: true, color: { argb: 'FFFFFFFF' } };
    cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: NAVY } };
  });
}

/** Ajoute une ligne de totaux (SUM) sous le tableau, mise en évidence. */
export function addTotalsRow(
  sheet: ExcelJS.Worksheet,
  labelColumn: number,
  sumColumns: number[],
  dataStartRow: number,
  dataEndRow: number,
  label = 'TOTAL'
) {
  const row = sheet.addRow([]);
  row.getCell(labelColumn).value = label;
  row.getCell(labelColumn).font = { bold: true };
  sumColumns.forEach((col) => {
    const colLetter = sheet.getColumn(col).letter;
    const cell = row.getCell(col);
    cell.value = { formula: `SUM(${colLetter}${dataStartRow}:${colLetter}${dataEndRow})`, date1904: false } as ExcelJS.CellFormulaValue;
    cell.numFmt = '#,##0.00';
    cell.font = { bold: true };
  });
  row.eachCell({ includeEmpty: true }, (cell) => {
    cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFE9D8FD' } };
    cell.border = { top: { style: 'double' } };
  });
  return row;
}

/** Mise en page impression pro : orientation paysage, ajustée à la largeur. */
export function setPrintSetup(sheet: ExcelJS.Worksheet) {
  sheet.pageSetup = {
    orientation: 'landscape',
    fitToPage: true,
    fitToWidth: 1,
    fitToHeight: 0,
    margins: { left: 0.4, right: 0.4, top: 0.6, bottom: 0.5, header: 0.2, footer: 0.2 }
  };
  sheet.headerFooter = {
    oddFooter: '&C&8Entraide Nationale — Plateforme IAM · Page &P / &N'
  };
}
