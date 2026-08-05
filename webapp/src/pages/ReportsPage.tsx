import { useMemo, useState } from 'react';
import { Link } from 'react-router-dom';
import { Download } from 'lucide-react';
import { useApp } from '../context/AppContext';
import { exportComparisonToExcel, downloadBlob } from '../lib/export';
import { PageHeader, EmptyState, Button, Card, StatCard } from '../components/ui/Kit';
import { useTranslation } from 'react-i18next';

export default function ReportsPage() {
  const { t } = useTranslation();
  const { comparisonResult, customFields } = useApp();
  const [isExporting, setIsExporting] = useState(false);

  const bySheet = useMemo(() => {
    if (!comparisonResult) return [];
    const map = new Map<string, { total: number; reglees: number; impayees: number; montantImpaye: number }>();
    for (const row of comparisonResult.rows) {
      const key = `${row.sourceFile} · ${row.sourceSheet}`;
      const entry = map.get(key) ?? { total: 0, reglees: 0, impayees: 0, montantImpaye: 0 };
      entry.total += 1;
      if (row.status === 'reglee') entry.reglees += 1;
      else {
        entry.impayees += 1;
        entry.montantImpaye += row.montant ?? 0;
      }
      map.set(key, entry);
    }
    return Array.from(map.entries()).map(([key, stats]) => ({ key, ...stats }));
  }, [comparisonResult]);

  if (!comparisonResult) {
    return (
      <div>
        <PageHeader eyebrow={t('reportsPage.eyebrow', 'Étape 4')} title={t('reportsPage.title')} />
        <EmptyState
          title="Aucune comparaison disponible"
          description="Lancez une comparaison pour générer un rapport exportable."
          action={
            <Link to="/comparaison">
              <Button>Aller à la comparaison</Button>
            </Link>
          }
        />
      </div>
    );
  }

  const handleExport = async () => {
    setIsExporting(true);
    try {
      const blob = await exportComparisonToExcel(comparisonResult, customFields);
      downloadBlob(blob, `rapport-facturation-IAM-${Date.now()}.xlsx`);
    } finally {
      setIsExporting(false);
    }
  };

  const { summary } = comparisonResult;
  const tauxReglement = summary.total > 0 ? Math.round((summary.reglees / summary.total) * 100) : 0;

  return (
    <div>
      <PageHeader
        eyebrow="Étape 4"
        title="Rapports"
        description={`Généré le ${new Date(summary.runAt).toLocaleString('fr-FR')}`}
        action={
          <Button onClick={handleExport} disabled={isExporting}>
            <Download size={15} />
            {isExporting ? 'Export…' : 'Exporter le rapport complet'}
          </Button>
        }
      />

      <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 mb-8">
        <StatCard label="Taux de règlement" value={`${tauxReglement}%`} tone={tauxReglement >= 50 ? 'good' : 'bad'} />
        <StatCard label="Montant total" value={`${summary.montantTotal.toLocaleString('fr-FR')} DH`} />
        <StatCard label="Montant réglé" value={`${summary.montantRegle.toLocaleString('fr-FR')} DH`} tone="good" />
        <StatCard label="Montant restant" value={`${summary.montantImpaye.toLocaleString('fr-FR')} DH`} tone="bad" />
      </div>

      <Card className="p-5">
        <h3 className="text-sm font-semibold text-ink-800 mb-4">Répartition par fichier / feuille source</h3>
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="text-left text-xs text-ink-500 uppercase tracking-wide border-b border-ink-100">
                <th className="py-2 pr-4">Source</th>
                <th className="py-2 pr-4">Total</th>
                <th className="py-2 pr-4">Réglées</th>
                <th className="py-2 pr-4">Impayées</th>
                <th className="py-2 pr-4">Montant restant</th>
              </tr>
            </thead>
            <tbody>
              {bySheet.map((s) => (
                <tr key={s.key} className="border-b border-ink-50 last:border-0">
                  <td className="py-2 pr-4 text-ink-800">{s.key}</td>
                  <td className="py-2 pr-4 text-ink-600">{s.total}</td>
                  <td className="py-2 pr-4 text-signal-moss font-medium">{s.reglees}</td>
                  <td className="py-2 pr-4 text-signal-roseDark font-medium">{s.impayees}</td>
                  <td className="py-2 pr-4 text-ink-600">{s.montantImpaye.toLocaleString('fr-FR')} DH</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </Card>
    </div>
  );
}
