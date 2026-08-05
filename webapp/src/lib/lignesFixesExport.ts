import ExcelJS from 'exceljs';
import type { LigneFixe } from '../types';
import { downloadBlob } from './export';
import { addPremiumHeader, styleTableHeader, setPrintSetup } from './excelBranding';

const HEADERS = ['ND', 'CUSTCODE', 'COORDINATION RÉGIONALE', 'DÉLÉGATION', 'DOMICILIATION', 'PERSONNE', 'QUALITE', 'DATE'];

function ligneFixeToRow(l: LigneFixe): (string | number)[] {
  return [
    l.nd ?? '',
    l.custcode ?? '',
    l.coordinationRegionale ?? '',
    l.delegation ?? '',
    l.domiciliation ?? '',
    l.personne ?? '',
    l.qualite ?? '',
    l.date ?? ''
  ];
}

export async function exportLignesFixesToExcel(lignesFixes: LigneFixe[]): Promise<void> {
  const workbook = new ExcelJS.Workbook();
  workbook.creator = 'Entraide Nationale — Facturation IAM';
  workbook.created = new Date();

  const sheet = workbook.addWorksheet('Lignes fixes');
  const startRow = addPremiumHeader(workbook, sheet, {
    title: 'Lignes fixes',
    subtitle: `${lignesFixes.length} ligne(s)`,
    columnCount: HEADERS.length
  });

  sheet.getRow(startRow).values = HEADERS;
  styleTableHeader(sheet.getRow(startRow));
  sheet.columns = HEADERS.map(() => ({ width: 20 }));
  lignesFixes.forEach((l) => sheet.addRow(ligneFixeToRow(l)));
  sheet.autoFilter = { from: { row: startRow, column: 1 }, to: { row: startRow, column: HEADERS.length } };
  sheet.views = [{ state: 'frozen', ySplit: startRow }];
  setPrintSetup(sheet);

  const buffer = await workbook.xlsx.writeBuffer();
  const blob = new Blob([buffer], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
  downloadBlob(blob, `lignes-fixes-${Date.now()}.xlsx`);
}
