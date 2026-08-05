import { useState } from 'react';
import { Link } from 'react-router-dom';
import { GitCompareArrows, Download, DatabaseZap } from 'lucide-react';
import { useApp } from '../context/AppContext';
import { runComparison } from '../lib/matching';
import { exportComparisonToExcel, downloadBlob } from '../lib/export';
import { findSheetRule } from '../lib/rulesLookup';
import { PageHeader, EmptyState, Button, StatCard } from '../components/ui/Kit';
import ResultsTable from '../components/comparison/ResultsTable';
import { api, ApiError } from '../lib/api';
import type { FileRole, ComparisonRow } from '../types';
import { useTranslation } from 'react-i18next';

export default function ComparisonPage() {
  const { t } = useTranslation();
  const { impayesFiles, reglementFiles, rules, customFields, comparisonResult, setComparisonResult } = useApp();
  const [isRunning, setIsRunning] = useState(false);
  const [isExporting, setIsExporting] = useState(false);
  const [isSaving, setIsSaving] = useState(false);
  const [saveMessage, setSaveMessage] = useState<string | null>(null);

  const hasRefRule = (role: FileRole, sheetName: string) =>
    Boolean(findSheetRule(rules, role, sheetName)?.mapping.refFacture);

  const impayesReady = impayesFiles.some((f) => f.sheets.some((s) => hasRefRule(f.role, s.sheetName)));
  const reglementsReady = reglementFiles.some((f) => f.sheets.some((s) => hasRefRule(f.role, s.sheetName)));
  const canRun = impayesReady && reglementsReady;

  if (impayesFiles.length === 0 || reglementFiles.length === 0) {
    return (
      <div>
        <PageHeader eyebrow={t('comparisonPage.eyebrow', 'Étape 3')} title={t('comparisonPage.title')} />
        <EmptyState
          title="Il manque au moins un fichier"
          description="La comparaison a besoin d'au moins un fichier d'impayés et un fichier de règlements."
          action={
            <Link to="/import">
              <Button>Aller à l'import</Button>
            </Link>
          }
        />
      </div>
    );
  }

  const handleRun = () => {
    setIsRunning(true);
    setSaveMessage(null);
    // setTimeout pour laisser l'UI afficher l'état de chargement avant le calcul synchrone
    setTimeout(() => {
      const result = runComparison(impayesFiles, reglementFiles, rules, customFields);
      setComparisonResult(result);
      setIsRunning(false);
    }, 150);
  };

  const handleExport = async () => {
    if (!comparisonResult) return;
    setIsExporting(true);
    try {
      const blob = await exportComparisonToExcel(comparisonResult, customFields);
      downloadBlob(blob, `rapprochement-factures-IAM-${Date.now()}.xlsx`);
    } finally {
      setIsExporting(false);
    }
  };

  // Retrouve la valeur d'un champ personnalisé par correspondance approximative
  // sur son intitulé (ex: le champ créé par l'utilisateur peut s'appeler
  // "Délégation" ou "DELEGATION" selon la feuille) — alimente les colonnes
  // dédiées de la table Factures (utilisées pour la répartition par direction).
  const findCustomValue = (row: ComparisonRow, hints: string[]): string | null => {
    for (const field of customFields) {
      const norm = field.label.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toUpperCase();
      if (hints.some((h) => norm.includes(h))) {
        const value = row.custom[field.id];
        if (value) return value;
      }
    }
    return null;
  };

  // Enregistre les résultats en base (table Factures persistée) — visible par
  // tous les utilisateurs et alimente le tableau de bord Super Admin et la
  // page "Gestion des factures IAM". Une facture existante (même client +
  // référence) est mise à jour plutôt que dupliquée.
  const handleSaveToDatabase = async () => {
    if (!comparisonResult) return;
    setIsSaving(true);
    setSaveMessage(null);
    try {
      const payload = comparisonResult.rows
        .filter((r) => r.custcode)
        .map((r) => ({
          custcode: r.custcode as string,
          nd: findCustomValue(r, ['ND-SUP', 'ND1', 'NDSUP', 'ND ']),
          nom: r.nom,
          refFacture: r.refFacture,
          montant: r.montant ?? 0,
          mois: null,
          echeance: r.echeance,
          produit: r.produit,
          statut: r.status,
          sourceSheet: `${r.sourceFile} · ${r.sourceSheet}`,
          coordinationRegionale: findCustomValue(r, ['COORDINATION']),
          delegation: findCustomValue(r, ['DELEGATION', 'DÉLÉGATION']),
          domiciliation: findCustomValue(r, ['DOMICILIATION'])
        }));
      const res = await api.post<{ imported: number }>('/factures/bulk-import', payload);
      setSaveMessage(`${res.imported} facture(s) enregistrée(s) en base.`);
    } catch (err) {
      setSaveMessage(err instanceof ApiError ? err.message : "Erreur lors de l'enregistrement.");
    } finally {
      setIsSaving(false);
    }
  };

  return (
    <div>
      <PageHeader
        eyebrow="Étape 3"
        title="Comparaison"
        description="Rapproche chaque facture impayée avec l'ensemble des règlements importés, à partir de la référence de facture."
        action={
          <div className="flex gap-2">
            <Button onClick={handleRun} disabled={!canRun || isRunning}>
              <GitCompareArrows size={15} />
              {isRunning ? 'Comparaison en cours…' : 'Lancer la comparaison'}
            </Button>
            {comparisonResult && (
              <>
                <Button variant="secondary" onClick={handleSaveToDatabase} disabled={isSaving}>
                  <DatabaseZap size={15} />
                  {isSaving ? 'Enregistrement…' : 'Enregistrer en base'}
                </Button>
                <Button variant="secondary" onClick={handleExport} disabled={isExporting}>
                  <Download size={15} />
                  {isExporting ? 'Export…' : 'Exporter en Excel'}
                </Button>
              </>
            )}
          </div>
        }
      />

      {!canRun && (
        <p className="text-sm text-signal-roseDark bg-signal-rose/10 rounded-lg px-4 py-3 mb-6">
          Configurez d'abord, dans <Link to="/regles" className="underline font-medium">Règles de colonnes</Link>,
          la référence de facture pour au moins une feuille d'impayés et une feuille de règlements.
        </p>
      )}

      {saveMessage && (
        <p className="text-sm bg-signal-emerald/10 text-signal-emeraldDark rounded-lg px-4 py-3 mb-6">{saveMessage}</p>
      )}

      {comparisonResult && (
        <>
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 mb-6">
            <StatCard label="Total analysé" value={String(comparisonResult.summary.total)} />
            <StatCard label="Réglées" value={String(comparisonResult.summary.reglees)} tone="good" />
            <StatCard label="Toujours impayées" value={String(comparisonResult.summary.impayees)} tone="bad" />
            <StatCard
              label="Montant impayé"
              value={`${comparisonResult.summary.montantImpaye.toLocaleString('fr-FR')} DH`}
              tone="bad"
            />
          </div>
          <ResultsTable rows={comparisonResult.rows} customFields={customFields} />
        </>
      )}
    </div>
  );
}
