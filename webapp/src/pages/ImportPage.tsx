import { useApp } from '../context/AppContext';
import { parseWorkbookFile } from '../lib/excel';
import { PageHeader, EmptyState } from '../components/ui/Kit';
import FileDropzone from '../components/import/FileDropzone';
import FileSheetCard from '../components/import/FileSheetCard';
import { useTranslation } from 'react-i18next';

export default function ImportPage() {
  const { t } = useTranslation();
  const { impayesFiles, reglementFiles, addFile, removeFile } = useApp();

  return (
    <div>
      <PageHeader
        eyebrow={t('importPage.eyebrow', 'Étape 1')}
        title={t('importPage.title')}
        description={t('importPage.description')}
      />

      <div className="grid sm:grid-cols-2 gap-6">
        <section>
          <h3 className="font-semibold mb-3" style={{ fontSize: 14, color: 'var(--text-pri)' }}>Factures impayées</h3>
          <FileDropzone
            role="impayes"
            label="Déposer le fichier des impayés"
            description="Ex. Impayés entraide Nle 2024.xlsx"
            onFile={async (file) => {
              const parsed = await parseWorkbookFile(file, 'impayes');
              addFile(parsed);
            }}
          />
          <div className="mt-4 space-y-3">
            {impayesFiles.length === 0 ? (
              <EmptyState
                title="Aucun fichier importé"
                description="Le fichier des impayés contient une ligne par facture non réglée, avec sa référence, son montant et son échéance."
              />
            ) : (
              impayesFiles.map((f) => <FileSheetCard key={f.id} file={f} onRemove={removeFile} />)
            )}
          </div>
        </section>

        <section>
          <h3 className="font-semibold mb-3" style={{ fontSize: 14, color: 'var(--text-pri)' }}>Règlements reçus</h3>
          <FileDropzone
            role="reglements"
            label="Déposer un fichier de règlements"
            description="Ex. Règlement des factures IAM.xlsx"
            onFile={async (file) => {
              const parsed = await parseWorkbookFile(file, 'reglements');
              addFile(parsed);
            }}
          />
          <div className="mt-4 space-y-3">
            {reglementFiles.length === 0 ? (
              <EmptyState
                title="Aucun fichier importé"
                description="Le fichier des règlements liste les paiements reçus. Vous pouvez déposer plusieurs fichiers, ils seront combinés à la comparaison."
              />
            ) : (
              reglementFiles.map((f) => <FileSheetCard key={f.id} file={f} onRemove={removeFile} />)
            )}
          </div>
        </section>
      </div>
    </div>
  );
}
