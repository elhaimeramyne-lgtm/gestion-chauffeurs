import ExcelJS from 'exceljs';
import type { Ligne } from '../types';
import { downloadBlob } from './export';
import { ENTRAIDE_LOGO_B64 } from './logoBase64';

const HEADERS = ['CATEGORIE', 'TYPE FORFAIT', 'TYPE MOBILE', 'ICC', 'IMEI', 'AFFECTE', 'PERSONNE', 'QUALITE', 'DATE'];

function ligneToRow(l: Ligne): (string | number)[] {
  return [
    l.categorie ?? '',
    l.typeForfait ?? '',
    l.typeMobile ?? '',
    l.icc ?? '',
    l.imei ?? '',
    l.affecte ?? '',
    l.personne ?? '',
    l.qualite ?? '',
    l.date ?? ''
  ];
}

export async function exportLignesToExcel(lignes: Ligne[]): Promise<void> {
  const workbook = new ExcelJS.Workbook();
  const sheet = workbook.addWorksheet('Lignes');
  sheet.addRow(HEADERS);
  sheet.getRow(1).font = { bold: true, color: { argb: 'FFFFFFFF' } };
  sheet.getRow(1).eachCell((cell) => {
    cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF1B2327' } };
  });
  sheet.columns = HEADERS.map(() => ({ width: 20 }));
  lignes.forEach((l) => sheet.addRow(ligneToRow(l)));
  sheet.autoFilter = { from: { row: 1, column: 1 }, to: { row: 1, column: HEADERS.length } };

  const buffer = await workbook.xlsx.writeBuffer();
  const blob = new Blob([buffer], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
  downloadBlob(blob, `lignes-mobiles-${Date.now()}.xlsx`);
}

function csvEscape(value: string): string {
  if (value.includes(',') || value.includes('"') || value.includes('\n')) {
    return `"${value.replace(/"/g, '""')}"`;
  }
  return value;
}

export function exportLignesToCSV(lignes: Ligne[]): void {
  const lines = [HEADERS.join(',')];
  for (const l of lignes) {
    lines.push(ligneToRow(l).map((v) => csvEscape(String(v))).join(','));
  }
  const blob = new Blob([lines.join('\n')], { type: 'text/csv;charset=utf-8;' });
  downloadBlob(blob, `lignes-mobiles-${Date.now()}.csv`);
}

export type Civilite = 'Mme' | 'Mlle' | 'M.';

export interface BonReaffectationData {
  ligne: Ligne;
  nouvellePersonne: string;
  civilite: Civilite;
  nouveauAffecte: string | null;
  nouvelleQualite: string | null;
}

function esc(s: string): string {
  return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
}

/** Construit le HTML imprimable du bon de réaffectation, reproduisant
 *  fidèlement le modèle Word officiel : logo en haut, titre "Bon de réception",
 *  tableau Désignation/Qté/Origine, section "Accusé de réception", pied de page
 *  avec le service. Les champs sont pré-remplis automatiquement. */
export function buildBonReaffectationHtml(data: BonReaffectationData): string {
  const { ligne, nouvellePersonne, civilite, nouveauAffecte, nouvelleQualite } = data;
  const today = new Date().toLocaleDateString('fr-FR');

  const designation = [
    ligne.typeMobile ? `Téléphone : ${esc(ligne.typeMobile)}` : null,
    ligne.icc ? `ICC (SIM) : ${esc(ligne.icc)}` : null,
    ligne.imei ? `IMEI : ${esc(ligne.imei)}` : null,
    ligne.typeForfait ? `Forfait : ${esc(ligne.typeForfait)}` : null
  ]
    .filter(Boolean)
    .join('<br/>');

  const origine = ligne.affecte ? esc(ligne.affecte) : '';
  const nom = esc(nouvellePersonne || '');
  const qualite = esc(nouvelleQualite || '');
  const dir = nouveauAffecte ? esc(nouveauAffecte) : origine;
  const civ = esc(civilite || 'Mme');

  return `<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="utf-8" />
<title>Bon de réception</title>
<style>
  @page { size: A4 portrait; margin: 1.5cm 2cm 2cm 2cm; }
  * { box-sizing: border-box; }
  body {
    font-family: 'Times New Roman', Times, serif;
    font-size: 11.5pt;
    color: #000;
    margin: 0;
    padding: 0;
  }
  /* ── En-tête : logo centré, sans texte organisationnel ── */
  .page-header {
    text-align: center;
    margin-bottom: 16pt;
    padding-bottom: 10pt;
    border-bottom: 1.5px solid #000;
  }
  .page-header img {
    max-height: 80pt;
    max-width: 260pt;
    object-fit: contain;
  }
  /* ── Titre ── */
  .title {
    text-align: center;
    font-weight: bold;
    font-size: 15pt;
    text-decoration: underline;
    margin: 0 0 16pt;
  }
  /* ── Corps ── */
  p { margin: 0 0 10pt; line-height: 1.55; }
  .right { text-align: right; }
  /* ── Tableau ── */
  table { border-collapse: collapse; width: 100%; margin: 8pt 0 14pt; }
  th {
    border: 1px solid #000;
    padding: 5pt 7pt;
    text-align: center;
    vertical-align: middle;
    font-weight: bold;
    background: #efefef;
    font-size: 10.5pt;
  }
  td {
    border: 1px solid #000;
    padding: 5pt 7pt;
    vertical-align: top;
    font-size: 10.5pt;
  }
  td.qty  { text-align: center; width: 50pt; }
  td.orig { width: 110pt; }
  td.desig { min-height: 55pt; }
  /* ── Séparateur ── */
  .divider { border: none; border-top: 1.5px solid #000; margin: 16pt 0; }
  /* ── Ligne pointillée ── */
  .dots {
    display: inline-block;
    min-width: 180pt;
    border-bottom: 1px dotted #555;
    vertical-align: bottom;
  }
  /* ── Pied de page ── */
  .page-footer {
    margin-top: 20pt;
    padding-top: 8pt;
    border-top: 1px solid #000;
    font-size: 9.5pt;
    text-align: center;
    color: #333;
  }
  @media print {
    body { -webkit-print-color-adjust: exact; print-color-adjust: exact; }
  }
</style>
</head>
<body>

  <!-- Logo uniquement en en-tête, pas de texte organisationnel -->
  <div class="page-header">
    <img src="${ENTRAIDE_LOGO_B64}" alt="Entraide Nationale" />
  </div>

  <p class="title">Bon de réception</p>

  <p>Il est attribué à ${civ} <strong>${nom}</strong>${qualite ? `, <em>${qualite}</em>` : ''}${dir ? ` &mdash; ${dir}` : ''}, le matériel désigné ci-après&nbsp;:</p>

  <table>
    <thead>
      <tr>
        <th>Désignation de l'article</th>
        <th style="width:50pt">Qté</th>
        <th style="width:110pt">Origine</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td class="desig">${designation || '&nbsp;'}</td>
        <td class="qty">1</td>
        <td class="orig">${origine || '&nbsp;'}</td>
      </tr>
    </tbody>
  </table>

  <p class="right">Rabat le : ${today}</p>

  <hr class="divider" />

  <p class="title">Accusé de réception</p>

  <p>
    Je soussigné (e) ${civ} <span class="dots">${nom}</span><br/>
    En qualité de <span class="dots">${qualite}</span> reconnais
  </p>
  <p>avoir reçu le matériel sus indiqué.</p>

  <p class="right">Rabat le : &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;&nbsp;</p>

  <!-- Texte organisationnel uniquement en pied de page -->
  <div class="page-footer">
    Division du Patrimoine et de la Logistique (DPL) &mdash; Service de la Logistique et des Moyens Généraux
  </div>

</body>
</html>`;
}

export function printBonReaffectation(data: BonReaffectationData): void {
  const html = buildBonReaffectationHtml(data);
  const win = window.open('', '_blank', 'width=850,height=1100');
  if (!win) {
    // Si le popup est bloqué, on propose le téléchargement en fallback
    const blob = new Blob([html], { type: 'text/html;charset=utf-8' });
    downloadBlob(blob, `bon-reception-${Date.now()}.html`);
    return;
  }
  win.document.open();
  win.document.write(html);
  win.document.close();
  // Déclenche l'impression dès que le document est chargé
  win.addEventListener('load', () => {
    win.focus();
    win.print();
  });
  // Fallback si l'événement load ne se déclenche pas (navigateurs stricts)
  setTimeout(() => {
    try { win.focus(); win.print(); } catch { /* déjà imprimé */ }
  }, 800);
}
