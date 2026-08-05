import ExcelJS from 'exceljs';
import type { ComparisonResult, CorrectionOutcome, CustomFieldDef, ParsedFile, SheetRule } from '../types';
import { applyCorrectionToRows } from './correction';
import { findSheetRule } from './rulesLookup';
import { addPremiumHeader, styleTableHeader, addTotalsRow, setPrintSetup } from './excelBranding';

const COLOR_REGLEE = 'FFDCEFDB'; // vert clair
const COLOR_IMPAYEE = 'FFFBDADD'; // rouge clair
const COLOR_HEADER = 'FF1B2327';
const COLOR_CORRECTED = 'FFFFE066'; // jaune franc : ligne remplacée par une correction
const COLOR_NOT_FOUND = 'FFFF6B6B'; // rouge franc : code client introuvable côté impayés
const COLOR_REVIEW = 'FFFFA94D'; // orange franc : remplacement automatique à vérifier (plusieurs factures)

export async function exportComparisonToExcel(
  result: ComparisonResult,
  customFields: CustomFieldDef[] = []
): Promise<Blob> {
  const workbook = new ExcelJS.Workbook();
  workbook.creator = 'Entraide Nationale — Facturation IAM';
  workbook.created = new Date();

  // ── Feuille Résumé (premium : logo, bandeau, KPI en cartes) ──────────────
  const summarySheet = workbook.addWorksheet('Résumé');
  summarySheet.columns = [{ width: 4 }, { width: 4 }, { width: 32 }, { width: 22 }, { width: 22 }, { width: 22 }];
  const summaryStart = addPremiumHeader(workbook, summarySheet, {
    title: 'Rapport de rapprochement facturation IAM',
    columnCount: 6
  });

  const kpis: [string, string | number, string][] = [
    ['Total factures analysées', result.summary.total, 'FFE0F2FE'],
    ['Factures réglées', result.summary.reglees, 'FFDCEFDB'],
    ['Factures toujours impayées', result.summary.impayees, 'FFFBDADD'],
    ['Montant total (DH)', Number(result.summary.montantTotal.toFixed(2)), 'FFE0F2FE'],
    ['Montant réglé (DH)', Number(result.summary.montantRegle.toFixed(2)), 'FFDCEFDB'],
    ['Montant restant impayé (DH)', Number(result.summary.montantImpaye.toFixed(2)), 'FFFBDADD']
  ];
  kpis.forEach(([label, value, color], i) => {
    const row = summarySheet.getRow(summaryStart + i);
    row.getCell(3).value = label;
    row.getCell(3).font = { size: 10, color: { argb: 'FF64748B' } };
    row.getCell(4).value = value;
    row.getCell(4).font = { bold: true, size: 13 };
    row.getCell(4).fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: color } };
  });
  const noteRow = summarySheet.getRow(summaryStart + kpis.length + 1);
  noteRow.getCell(3).value = `Généré le ${new Date(result.summary.runAt).toLocaleString('fr-FR')}`;
  noteRow.getCell(3).font = { italic: true, size: 9, color: { argb: 'FF94A3B8' } };
  setPrintSetup(summarySheet);

  // ── Feuille Résultats détaillés (premium : logo, bandeau, totaux) ────────
  const sheet = workbook.addWorksheet('Résultats');
  const headers = [
    'Référence facture',
    'Statut',
    'Montant',
    'Échéance',
    'Code client',
    'Nom / Client',
    'Produit',
    ...customFields.map((cf) => cf.label),
    'Fichier source',
    'Feuille source'
  ];
  const montantColIndex = 3; // 1-based

  const resultsStart = addPremiumHeader(workbook, sheet, {
    title: 'Détail des factures rapprochées',
    subtitle: `${result.summary.total} facture(s) · généré le ${new Date(result.summary.runAt).toLocaleString('fr-FR')}`,
    columnCount: headers.length
  });

  const headerRowIndex = resultsStart;
  sheet.getRow(headerRowIndex).values = headers;
  styleTableHeader(sheet.getRow(headerRowIndex));
  sheet.columns = [
    { width: 22 },
    { width: 16 },
    { width: 12 },
    { width: 14 },
    { width: 24 },
    { width: 30 },
    { width: 14 },
    ...customFields.map(() => ({ width: 20 })),
    { width: 28 },
    { width: 22 }
  ];

  result.rows.forEach((r) => {
    const row = sheet.addRow([
      r.refFacture,
      r.status === 'reglee' ? 'Réglée' : 'Toujours impayée',
      r.montant ?? '',
      r.echeance ?? '',
      r.custcode ?? '',
      r.nom ?? '',
      r.produit ?? '',
      ...customFields.map((cf) => r.custom?.[cf.id] ?? ''),
      r.sourceFile,
      r.sourceSheet
    ]);
    const fill: ExcelJS.Fill = {
      type: 'pattern',
      pattern: 'solid',
      fgColor: { argb: r.status === 'reglee' ? COLOR_REGLEE : COLOR_IMPAYEE }
    };
    row.eachCell((cell) => {
      cell.fill = fill;
    });
  });

  const dataStartRow = headerRowIndex + 1;
  const dataEndRow = headerRowIndex + result.rows.length;
  if (result.rows.length > 0) {
    addTotalsRow(sheet, 2, [montantColIndex], dataStartRow, dataEndRow, `TOTAL (${result.rows.length} lignes)`);
  }

  sheet.autoFilter = { from: { row: headerRowIndex, column: 1 }, to: { row: headerRowIndex, column: headers.length } };
  sheet.views = [{ state: 'frozen', ySplit: headerRowIndex }];
  setPrintSetup(sheet);

  const buffer = await workbook.xlsx.writeBuffer();
  return new Blob([buffer], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
}

export function downloadBlob(blob: Blob, filename: string) {
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = filename;
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(url);
}

/** Reconstruit le classeur d'un fichier de règlements en appliquant les
 *  corrections calculées (remplacement du REF_FACT via CUSTCODE) sur les
 *  feuilles concernées ; les autres feuilles du fichier sont recopiées telles
 *  quelles. Les cellules modifiées sont surlignées pour une relecture rapide. */
export async function exportCorrectedFile(
  file: ParsedFile,
  outcomes: CorrectionOutcome[],
  rules: SheetRule[]
): Promise<Blob> {
  const workbook = new ExcelJS.Workbook();
  workbook.creator = 'Entraide Nationale — Facturation IAM';
  workbook.created = new Date();

  for (const sheet of file.sheets) {
    const outcome = outcomes.find((o) => o.rule.targetSheetName === sheet.sheetName);
    const mapping = findSheetRule(rules, file.role, sheet.sheetName)?.mapping;
    const rows = outcome && mapping ? applyCorrectionToRows(sheet, mapping, outcome) : sheet.rows;
    const refColIndex = mapping?.refFacture ? sheet.headers.indexOf(mapping.refFacture) : -1;
    const echeanceColIndex = mapping?.echeance ? sheet.headers.indexOf(mapping.echeance) : -1;

    const ws = workbook.addWorksheet(sheet.sheetName.slice(0, 31));
    ws.addRow(sheet.headers);
    const headerRow = ws.getRow(1);
    headerRow.eachCell((cell) => {
      cell.font = { bold: true, color: { argb: 'FFFFFFFF' } };
      cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: COLOR_HEADER } };
    });
    ws.columns = sheet.headers.map(() => ({ width: 20 }));

    rows.forEach((row, i) => {
      const values = sheet.headers.map((h) => {
        const v = row[h];
        return v instanceof Date ? v : (v ?? '');
      });
      const addedRow = ws.addRow(values);

      if (outcome) {
        const result = outcome.results[i];
        if (result) {
          // Couleur de fond appliquée à toute la ligne selon son statut, pour
          // repérer d'un coup d'œil les lignes modifiées, à vérifier, ou dont
          // le code client est introuvable côté impayés.
          const rowColor = result.ambiguous
            ? COLOR_REVIEW
            : result.status === 'remplacee'
              ? COLOR_CORRECTED
              : result.status === 'non_trouvee'
                ? COLOR_NOT_FOUND
                : null;

          if (rowColor) {
            addedRow.eachCell({ includeEmpty: true }, (cell) => {
              cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: rowColor } };
            });
          }

          if (result.status === 'remplacee') {
            if (refColIndex >= 0) {
              addedRow.getCell(refColIndex + 1).note = `Ancienne valeur : ${result.originalRef}`;
            }
            if (echeanceColIndex >= 0 && result.newEcheance && result.newEcheance !== result.originalEcheance) {
              addedRow.getCell(echeanceColIndex + 1).note = `Ancienne valeur : ${result.originalEcheance ?? ''}`;
            }
          }
        }
      }
    });

    // Légende des couleurs, ajoutée en bas de la feuille pour que la
    // correspondance couleur → statut soit toujours à portée de main.
    if (outcome) {
      ws.addRow([]);
      const legendEntries: [string, string][] = [
        [COLOR_CORRECTED, 'Remplacée'],
        [COLOR_REVIEW, 'À vérifier (plusieurs factures, choix automatique)'],
        [COLOR_NOT_FOUND, 'Code client introuvable côté impayés']
      ];
      for (const [color, label] of legendEntries) {
        const legendRow = ws.addRow([label]);
        legendRow.getCell(1).fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: color } };
        legendRow.getCell(1).font = { size: 10, italic: true };
      }
    }

    ws.autoFilter = { from: { row: 1, column: 1 }, to: { row: 1, column: sheet.headers.length } };
  }

  const buffer = await workbook.xlsx.writeBuffer();
  return new Blob([buffer], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
}
