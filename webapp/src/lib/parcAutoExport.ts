import ExcelJS from 'exceljs';
import QRCode from 'qrcode';
import type { Vehicule, Deplacement, DeplacementPassager, Chauffeur } from '../types/parcAuto';
import { VEHICULE_STATUT_LABELS, CARBURANT_LABELS, DEPLACEMENT_STATUT_LABELS } from '../types/parcAuto';
import { downloadBlob } from './export';
import { ENTRAIDE_LOGO_B64 } from './logoBase64';

/* ══════════════════════════ EXPORT EXCEL ══════════════════════════════ */

const VEHICULE_HEADERS = ['IMMATRICULATION', 'MARQUE', 'MODÈLE', 'ANNÉE', 'CARBURANT', 'KILOMÉTRAGE', 'STATUT', 'ASSURANCE', 'VISITE TECHNIQUE'];

function vehiculeToRow(v: Vehicule): (string | number)[] {
  return [
    v.immatriculation, v.marque, v.modele, v.annee ?? '', CARBURANT_LABELS[v.carburant],
    v.kilometrage, VEHICULE_STATUT_LABELS[v.statut], v.assuranceExpiration ?? '', v.visiteTechniqueExpiration ?? ''
  ];
}

export async function exportVehiculesToExcel(vehicules: Vehicule[]): Promise<void> {
  const workbook = new ExcelJS.Workbook();
  const sheet = workbook.addWorksheet('Parc Automobile');
  sheet.addRow(VEHICULE_HEADERS);
  sheet.getRow(1).font = { bold: true, color: { argb: 'FFFFFFFF' } };
  sheet.getRow(1).eachCell((cell) => {
    cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF1B2327' } };
  });
  sheet.columns = VEHICULE_HEADERS.map(() => ({ width: 18 }));
  vehicules.forEach((v) => sheet.addRow(vehiculeToRow(v)));
  sheet.autoFilter = { from: { row: 1, column: 1 }, to: { row: 1, column: VEHICULE_HEADERS.length } };

  const buffer = await workbook.xlsx.writeBuffer();
  const blob = new Blob([buffer], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
  downloadBlob(blob, `parc-automobile-${Date.now()}.xlsx`);
}

const DEPLACEMENT_HEADERS = ['N° ORDRE', 'OBJET', 'DESTINATION', 'STATUT', 'DATE DÉPART', 'RETOUR PRÉVU', 'KM DÉPART', 'KM RETOUR'];

function deplacementToRow(d: Deplacement): (string | number)[] {
  return [
    d.numero, d.objet, d.destination ?? '', DEPLACEMENT_STATUT_LABELS[d.statut],
    d.dateDepart, d.dateRetourPrevue ?? '', d.kilometrageDepart ?? '', d.kilometrageRetour ?? ''
  ];
}

export async function exportDeplacementsToExcel(deplacements: Deplacement[]): Promise<void> {
  const workbook = new ExcelJS.Workbook();
  const sheet = workbook.addWorksheet('Déplacements');
  sheet.addRow(DEPLACEMENT_HEADERS);
  sheet.getRow(1).font = { bold: true, color: { argb: 'FFFFFFFF' } };
  sheet.getRow(1).eachCell((cell) => {
    cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF1B2327' } };
  });
  sheet.columns = DEPLACEMENT_HEADERS.map(() => ({ width: 18 }));
  deplacements.forEach((d) => sheet.addRow(deplacementToRow(d)));
  sheet.autoFilter = { from: { row: 1, column: 1 }, to: { row: 1, column: DEPLACEMENT_HEADERS.length } };

  const buffer = await workbook.xlsx.writeBuffer();
  const blob = new Blob([buffer], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
  downloadBlob(blob, `deplacements-${Date.now()}.xlsx`);
}

/* ══════════════════════════ IMPRESSION ORDRE DE MISSION ═══════════════ */

function esc(s: string): string {
  return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
}

export interface OrdreMissionData {
  deplacement: Deplacement;
  vehicule: Vehicule | null;
  chauffeur: Chauffeur | null;
  serviceNom: string;
  passagers: DeplacementPassager[];
  passagerServiceNom: (serviceId: number | null) => string;
}

export function buildOrdreMissionHtml(data: OrdreMissionData, qrDataUrl?: string): string {
  const { deplacement, vehicule, chauffeur, serviceNom, passagers, passagerServiceNom } = data;
  const today = new Date().toLocaleDateString('fr-FR');

  const passagersRows = passagers.length
    ? passagers.map((p) => `<tr><td>${esc(p.nom)}</td><td>${esc(passagerServiceNom(p.serviceId))}</td></tr>`).join('')
    : `<tr><td colspan="2" style="text-align:center;color:#666;">Aucune personne transportée</td></tr>`;

  return `<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="utf-8" />
<title>Ordre de mission ${esc(deplacement.numero)}</title>
<style>
  @page { size: A4 portrait; margin: 1.5cm 2cm 2cm 2cm; }
  * { box-sizing: border-box; }
  body { font-family: 'Times New Roman', Times, serif; font-size: 11.5pt; color: #000; margin: 0; padding: 0; }
  .page-header { text-align: center; margin-bottom: 16pt; padding-bottom: 10pt; border-bottom: 1.5px solid #000; position: relative; }
  .page-header img.logo { max-height: 80pt; max-width: 260pt; object-fit: contain; }
  .page-header .qr { position: absolute; top: 0; right: 0; text-align: center; }
  .page-header .qr img { width: 64pt; height: 64pt; }
  .page-header .qr p { margin: 2pt 0 0; font-size: 7.5pt; color: #555; }
  .title { text-align: center; font-weight: bold; font-size: 15pt; text-decoration: underline; margin: 0 0 4pt; }
  .subtitle { text-align: center; font-size: 11pt; margin: 0 0 16pt; color: #333; }
  p { margin: 0 0 8pt; line-height: 1.5; }
  table { border-collapse: collapse; width: 100%; margin: 8pt 0 16pt; }
  th { border: 1px solid #000; padding: 5pt 7pt; text-align: left; font-weight: bold; background: #efefef; font-size: 10.5pt; }
  td { border: 1px solid #000; padding: 5pt 7pt; vertical-align: top; font-size: 10.5pt; }
  .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 4pt 24pt; margin: 10pt 0 16pt; }
  .info-grid .label { font-weight: bold; }
  .signatures { display: grid; grid-template-columns: 1fr 1fr; gap: 24pt; margin-top: 40pt; }
  .signatures .box { text-align: center; }
  .signatures .line { margin-top: 40pt; border-top: 1px solid #000; padding-top: 4pt; font-size: 10pt; }
  .page-footer { margin-top: 30pt; text-align: right; font-size: 10pt; color: #555; }
</style>
</head>
<body>
  <div class="page-header">
    <img class="logo" src="${ENTRAIDE_LOGO_B64}" alt="Logo" />
    ${qrDataUrl ? `<div class="qr"><img src="${qrDataUrl}" alt="QR" /><p>N° ${esc(deplacement.numero)}</p></div>` : ''}
  </div>
  <p class="title">Ordre de Mission</p>
  <p class="subtitle">N° ${esc(deplacement.numero)} — Service de la Logistique et des Moyens Généraux</p>

  <div class="info-grid">
    <p><span class="label">Service demandeur :</span> ${esc(serviceNom)}</p>
    <p><span class="label">Objet :</span> ${esc(deplacement.objet)}</p>
    <p><span class="label">Véhicule :</span> ${vehicule ? esc(`${vehicule.immatriculation} — ${vehicule.marque} ${vehicule.modele}`) : 'Non désigné'}</p>
    <p><span class="label">Chauffeur :</span> ${chauffeur ? esc(chauffeur.nom) : 'Non désigné'}</p>
    <p><span class="label">Destination :</span> ${esc(deplacement.destination || '—')}</p>
    <p><span class="label">Date de départ :</span> ${esc(deplacement.dateDepart)}</p>
    <p><span class="label">Retour prévu :</span> ${esc(deplacement.dateRetourPrevue || '—')}</p>
    <p><span class="label">Date d'établissement :</span> ${today}</p>
  </div>

  <table>
    <thead><tr><th>Personnel transporté</th><th>Service</th></tr></thead>
    <tbody>${passagersRows}</tbody>
  </table>

  <div class="signatures">
    <div class="box">Le Chauffeur<div class="line">Signature</div></div>
    <div class="box">Le Responsable Logistique<div class="line">Signature et cachet</div></div>
  </div>

  <p class="page-footer">Entraide Nationale — Service de la Logistique et des Moyens Généraux</p>
</body>
</html>`;
}

export async function printOrdreMission(data: OrdreMissionData): Promise<void> {
  let qrDataUrl: string | undefined;
  try {
    qrDataUrl = await QRCode.toDataURL(
      `ORDRE-MISSION:${data.deplacement.numero}:${data.deplacement.statut}`,
      { width: 180, margin: 1, color: { dark: '#000000', light: '#ffffff' } }
    );
  } catch {
    // QR facultatif — l'ordre de mission reste imprimable sans lui
  }
  const html = buildOrdreMissionHtml(data, qrDataUrl);
  const win = window.open('', '_blank', 'width=850,height=1100');
  if (!win) {
    const blob = new Blob([html], { type: 'text/html;charset=utf-8' });
    downloadBlob(blob, `ordre-mission-${data.deplacement.numero}.html`);
    return;
  }
  win.document.open();
  win.document.write(html);
  win.document.close();
  win.addEventListener('load', () => { win.focus(); win.print(); });
  setTimeout(() => { try { win.focus(); win.print(); } catch { /* déjà imprimé */ } }, 800);
}
