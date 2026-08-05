import { useState } from 'react';
import { Link } from 'react-router-dom';
import { Plus } from 'lucide-react';
import { useApp } from '../context/AppContext';
import { useAuth } from '../context/AuthContext';
import { PageHeader, EmptyState, Button, Card } from '../components/ui/Kit';
import CorrectionRuleCard from '../components/correction/CorrectionRuleCard';
import { useTranslation } from 'react-i18next';

interface SheetOption {
  fileId: string;
  sheetName: string;
  label: string;
}

function buildOptions(files: { id: string; fileName: string; sheets: { sheetName: string }[] }[]): SheetOption[] {
  return files.flatMap((f) =>
    f.sheets.map((s) => ({ fileId: f.id, sheetName: s.sheetName, label: `${f.fileName} · ${s.sheetName}` }))
  );
}

export default function CorrectionPage() {
  const { t } = useTranslation();
  const {
    impayesFiles,
    reglementFiles,
    rules,
    correctionRules,
    addCorrectionRule,
    removeCorrectionRule,
    updateSheetRows
  } = useApp();
  const { canEdit } = useAuth();

  const sourceOptions = buildOptions(impayesFiles);
  const targetOptions = buildOptions(reglementFiles);

  const [sourceKey, setSourceKey] = useState('');
  const [targetKey, setTargetKey] = useState('');

  if (impayesFiles.length === 0 || reglementFiles.length === 0) {
    return (
      <div>
        <PageHeader eyebrow={t('correctionPage.eyebrow')} title={t('correctionPage.title')} />
        <EmptyState
          title="Il manque au moins un fichier"
          description="La correction a besoin d'au moins un fichier d'impayés (source) et un fichier de règlements (à corriger)."
          action={
            <Link to="/import">
              <Button>Aller à l'import</Button>
            </Link>
          }
        />
      </div>
    );
  }

  const handleAdd = () => {
    if (!sourceKey || !targetKey) return;
    const [, sourceSheetName] = sourceKey.split('::');
    const [, targetSheetName] = targetKey.split('::');
    addCorrectionRule({ sourceSheetName, targetSheetName });
    setSourceKey('');
    setTargetKey('');
  };

  return (
    <div>
      <PageHeader
        eyebrow="Correction"
        title="Correction des références"
        description="Retrouve, pour chaque ligne d'un fichier de règlements, le code client (CUSTCODE) dans un fichier d'impayés, et remplace la référence facture (REF_FACT) du règlement par celle de l'impayé correspondant."
      />

      {canEdit && (
        <Card className="p-5 mb-6">
          <p className="text-sm font-semibold text-ink-800 mb-3">Nouvelle règle de correction</p>
          <div className="grid sm:grid-cols-2 gap-3 mb-3">
            <label className="text-xs text-ink-500">
              <span>Source (impayés) — donne la bonne référence</span>
              <select
                value={sourceKey}
                onChange={(e) => setSourceKey(e.target.value)}
                className="focus-ring mt-1 w-full rounded-lg border border-ink-200 bg-white px-2.5 py-1.5 text-sm text-ink-800"
              >
                <option value="">— Choisir une feuille —</option>
                {sourceOptions.map((o) => (
                  <option key={`${o.fileId}::${o.sheetName}`} value={`${o.fileId}::${o.sheetName}`}>
                    {o.label}
                  </option>
                ))}
              </select>
            </label>
            <label className="text-xs text-ink-500">
              <span>Cible (règlements) — sera corrigée</span>
              <select
                value={targetKey}
                onChange={(e) => setTargetKey(e.target.value)}
                className="focus-ring mt-1 w-full rounded-lg border border-ink-200 bg-white px-2.5 py-1.5 text-sm text-ink-800"
              >
                <option value="">— Choisir une feuille —</option>
                {targetOptions.map((o) => (
                  <option key={`${o.fileId}::${o.sheetName}`} value={`${o.fileId}::${o.sheetName}`}>
                    {o.label}
                  </option>
                ))}
              </select>
            </label>
          </div>
          <Button onClick={handleAdd} disabled={!sourceKey || !targetKey}>
            <Plus size={15} />
            Ajouter cette règle
          </Button>
          <p className="text-xs text-ink-400 mt-2">
            Les deux feuilles doivent avoir le code client et la référence facture configurés dans{' '}
            <Link to="/regles" className="underline font-medium">
              Règles de colonnes
            </Link>
            .
          </p>
        </Card>
      )}

      {correctionRules.length === 0 ? (
        <EmptyState
          title="Aucune règle de correction"
          description="Ajoutez une règle ci-dessus pour comparer une feuille d'impayés à une feuille de règlements."
        />
      ) : (
        <div className="space-y-5">
          {correctionRules.map((rule) => (
            <CorrectionRuleCard
              key={rule.id}
              rule={rule}
              impayesFiles={impayesFiles}
              reglementFiles={reglementFiles}
              rules={rules}
              onRemove={removeCorrectionRule}
              onApplyRows={updateSheetRows}
              canEdit={canEdit}
            />
          ))}
        </div>
      )}
    </div>
  );
}
