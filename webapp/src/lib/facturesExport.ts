import ExcelJS from 'exceljs';
import type { Facture } from '../types';
import { downloadBlob } from './export';
import { addPremiumHeader, styleTableHeader, addTotalsRow, setPrintSetup } from './excelBranding';

const HEADERS = ['CUSTCODE', 'ND', 'NOM', 'RÉF. FACTURE', 'MONTANT', 'MOIS', 'ÉCHÉANCE', 'PRODUIT', 'STATUT'];
const MONTANT_COL = 5; // 1-based

function factureToRow(f: Facture): (string | number)[] {
  return [
    f.custcode,
    f.nd ?? '',
    f.nom ?? '',
    f.refFacture,
    f.montant,
    f.mois ?? '',
    f.echeance ?? '',
    f.produit ?? '',
    f.statut === 'reglee' ? 'Réglée' : 'Impayée'
  ];
}

export async function exportFacturesToExcel(factures: Facture[]): Promise<void> {
  const workbook = new ExcelJS.Workbook();
  workbook.creator = 'Entraide Nationale — Facturation IAM';
  workbook.created = new Date();

  const sheet = workbook.addWorksheet('Factures');
  const impayees = factures.filter((f) => f.statut === 'impayee').length;
  const startRow = addPremiumHeader(workbook, sheet, {
    title: 'Factures IAM',
    subtitle: `${factures.length} facture(s) · ${impayees} impayée(s)`,
    columnCount: HEADERS.length
  });

  sheet.getRow(startRow).values = HEADERS;
  styleTableHeader(sheet.getRow(startRow));
  sheet.columns = HEADERS.map(() => ({ width: 18 }));

  factures.forEach((f) => {
    const row = sheet.addRow(factureToRow(f));
    if (f.statut === 'impayee') {
      row.eachCell((cell) => {
        cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFFFE3E3' } };
      });
    }
  });

  const dataStartRow = startRow + 1;
  const dataEndRow = startRow + factures.length;
  if (factures.length > 0) {
    addTotalsRow(sheet, 2, [MONTANT_COL], dataStartRow, dataEndRow, `TOTAL (${factures.length} factures)`);
  }

  sheet.autoFilter = { from: { row: startRow, column: 1 }, to: { row: startRow, column: HEADERS.length } };
  sheet.views = [{ state: 'frozen', ySplit: startRow }];
  setPrintSetup(sheet);

  const buffer = await workbook.xlsx.writeBuffer();
  const blob = new Blob([buffer], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
  downloadBlob(blob, `factures-IAM-${Date.now()}.xlsx`);
}
