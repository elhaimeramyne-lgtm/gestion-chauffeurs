import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';
import type { Facture } from '../types';
import { ENTRAIDE_LOGO_NEW_B64 } from './logoNewBase64';

export function exportFacturesToPdf(factures: Facture[], filterSummary?: string): void {
  const doc = new jsPDF({ orientation: 'landscape', unit: 'mm', format: 'a4' });
  const pageWidth = doc.internal.pageSize.getWidth();

  // ── En-tête ──
  try {
    doc.addImage(ENTRAIDE_LOGO_NEW_B64, 'PNG', 12, 10, 32, 10);
  } catch {
    // Si le logo ne peut pas être décodé dans cet environnement, on continue sans.
  }
  doc.setFontSize(16);
  doc.setTextColor(11, 16, 35);
  doc.text('Factures IAM', pageWidth - 12, 16, { align: 'right' });
  doc.setFontSize(9);
  doc.setTextColor(100, 116, 139);
  doc.text(`Généré le ${new Date().toLocaleString('fr-FR')}`, pageWidth - 12, 22, { align: 'right' });
  if (filterSummary) {
    doc.text(filterSummary, pageWidth - 12, 27, { align: 'right' });
  }

  const impayees = factures.filter((f) => f.statut === 'impayee').length;
  const montantTotal = factures.reduce((sum, f) => sum + f.montant, 0);
  const montantImpaye = factures.filter((f) => f.statut === 'impayee').reduce((sum, f) => sum + f.montant, 0);

  doc.setFontSize(10);
  doc.setTextColor(11, 16, 35);
  doc.text(
    `${factures.length} facture(s) · ${impayees} impayée(s) · ${montantTotal.toLocaleString('fr-FR')} DH au total · ${montantImpaye.toLocaleString('fr-FR')} DH restant impayé`,
    12,
    32
  );

  // ── Tableau ──
  autoTable(doc, {
    startY: 37,
    head: [['CUSTCODE', 'Nom', 'Réf. facture', 'Montant (DH)', 'Échéance', 'Produit', 'Statut']],
    body: factures.map((f) => [
      f.custcode,
      f.nom || '—',
      f.refFacture,
      f.montant.toLocaleString('fr-FR'),
      f.echeance || '—',
      f.produit || '—',
      f.statut === 'reglee' ? 'Réglée' : 'Impayée'
    ]),
    styles: { fontSize: 8, cellPadding: 2 },
    headStyles: { fillColor: [11, 16, 35], textColor: 255, fontStyle: 'bold' },
    alternateRowStyles: { fillColor: [246, 248, 252] },
    didParseCell: (data) => {
      if (data.section === 'body' && data.column.index === 6 && data.cell.raw === 'Impayée') {
        data.cell.styles.textColor = [220, 38, 38];
        data.cell.styles.fontStyle = 'bold';
      }
    },
    margin: { left: 12, right: 12 },
    didDrawPage: () => {
      const pageCount = doc.getNumberOfPages();
      doc.setFontSize(8);
      doc.setTextColor(148, 163, 184);
      doc.text(
        `Entraide Nationale — Plateforme IAM · Page ${doc.getCurrentPageInfo().pageNumber} / ${pageCount}`,
        pageWidth / 2,
        doc.internal.pageSize.getHeight() - 8,
        { align: 'center' }
      );
    }
  });

  doc.save(`factures-IAM-${Date.now()}.pdf`);
}
