import { useState } from 'react';
import { Plus, Trash2, KeyRound } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import { useApp } from '../context/AppContext';
import { useAuth } from '../context/AuthContext';
import { PageHeader, Card, Button, EmptyState, Badge } from '../components/ui/Kit';
import ColumnMapper from '../components/rules/ColumnMapper';

export default function RulesPage() {
  const { t } = useTranslation();
  const {
    impayesFiles, reglementFiles, rules, upsertRule,
    customFields, addCustomField, removeCustomField, toggleCustomFieldMatchKey
  } = useApp();
  const { canEdit } = useAuth();
  const [newFieldLabel, setNewFieldLabel] = useState('');

  const allFiles = [...impayesFiles, ...reglementFiles];

  const handleAddField = () => {
    const trimmed = newFieldLabel.trim();
    if (!trimmed) return;
    addCustomField(trimmed);
    setNewFieldLabel('');
  };

  return (
    <div>
      <PageHeader
        eyebrow={t('rulesPage.eyebrow', 'Configuration')}
        title={t('rulesPage.title', 'Règles de colonnes')}
        description={t(
          'rulesPage.description',
          "Indiquez, pour chaque feuille importée, quelle colonne correspond à quel champ (référence facture, montant, échéance…). Ces correspondances sont réutilisées par la comparaison et la correction."
        )}
      />

      {canEdit && (
        <Card className="p-5 mb-6">
          <p className="text-sm font-semibold mb-1" style={{ color: 'var(--text-pri)' }}>Champs personnalisés</p>
          <p className="text-xs mb-3" style={{ color: 'var(--text-ter)' }}>
            Ajoutez un champ (ex. « ND-SUP / ND1 ») pour faire correspondre deux colonnes qui désignent la même chose
            mais portent des intitulés différents d'un fichier à l'autre. Marquez-le « clé » pour l'utiliser aussi
            comme critère de rapprochement, en plus de la référence facture.
          </p>
          <div className="flex flex-wrap gap-2 mb-3">
            {customFields.map((cf) => (
              <span
                key={cf.id}
                className="inline-flex items-center gap-2 text-xs px-3 py-1.5 rounded-full"
                style={{ background: 'var(--glass-bg)', border: '1px solid var(--border)', color: 'var(--text-sec)' }}
              >
                {cf.label}
                <button
                  title={cf.useAsMatchKey ? 'Utilisé comme clé de rapprochement' : "Utiliser comme clé de rapprochement"}
                  onClick={() => toggleCustomFieldMatchKey(cf.id)}
                  style={{ color: cf.useAsMatchKey ? '#16a34a' : 'var(--text-ter)' }}
                >
                  <KeyRound size={12} />
                </button>
                <button title="Supprimer" onClick={() => removeCustomField(cf.id)} style={{ color: 'var(--accent-err)' }}>
                  <Trash2 size={12} />
                </button>
              </span>
            ))}
            {customFields.length === 0 && (
              <p className="text-xs" style={{ color: 'var(--text-ter)' }}>Aucun champ personnalisé pour le moment.</p>
            )}
          </div>
          <div className="flex gap-2">
            <input
              value={newFieldLabel}
              onChange={(e) => setNewFieldLabel(e.target.value)}
              onKeyDown={(e) => e.key === 'Enter' && handleAddField()}
              placeholder="Ex. ND-SUP / ND1"
              className="flex-1 max-w-xs"
            />
            <Button variant="secondary" onClick={handleAddField} disabled={!newFieldLabel.trim()}>
              <Plus size={13} /> Ajouter
            </Button>
          </div>
        </Card>
      )}

      {allFiles.length === 0 ? (
        <EmptyState
          title="Aucun fichier importé"
          description="Importez d'abord un fichier d'impayés ou de règlements pour configurer ses colonnes."
        />
      ) : (
        <div className="space-y-6">
          {allFiles.map((file) => (
            <div key={file.id}>
              <div className="flex items-center gap-2 mb-3">
                <p className="text-sm font-semibold" style={{ color: 'var(--text-pri)' }}>{file.fileName}</p>
                <Badge tone={file.role === 'impayes' ? 'info' : 'default'}>
                  {file.role === 'impayes' ? 'Impayés' : 'Règlements'}
                </Badge>
              </div>
              <div className="grid sm:grid-cols-2 gap-4">
                {file.sheets.map((sheet) => (
                  <ColumnMapper
                    key={`${file.id}::${sheet.sheetName}`}
                    file={file}
                    sheet={sheet}
                    customFields={customFields}
                    existingRule={rules.find((r) => r.fileId === file.id && r.sheetName === sheet.sheetName)}
                    onSave={upsertRule}
                  />
                ))}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
