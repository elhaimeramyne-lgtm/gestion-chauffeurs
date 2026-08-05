import { useRef, useState } from 'react';
import { Plus, Upload, Pencil, Trash2, Printer, Newspaper } from 'lucide-react';
import { useApp } from '../context/AppContext';
import { useAuth } from '../context/AuthContext';
import type { JournalEntry, JournalEntryInput } from '../types';
import { PageHeader, Button, StatCard, EmptyState } from '../components/ui/Kit';
import JournalEntryFormModal from '../components/journaux/JournalEntryFormModal';
import ConfirmModal from '../components/lignes/ConfirmModal';
import { parseJournalWorkbook } from '../lib/journalImport';
import { useTranslation } from 'react-i18next';

export default function JournauxPage() {
  const { t } = useTranslation();
  const { journalEntries, addJournalEntry, addJournalEntries, updateJournalEntry, removeJournalEntry } = useApp();
  const { canEdit } = useAuth();

  const [formOpen, setFormOpen] = useState(false);
  const [editing, setEditing] = useState<JournalEntry | null>(null);
  const [deleteTarget, setDeleteTarget] = useState<JournalEntry | null>(null);
  const [isImporting, setIsImporting] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const withAtLeastOneJournal = journalEntries.filter((e) => e.journal1 || e.journal2 || e.journal3).length;

  const handleFileImport = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    setIsImporting(true);
    try {
      const rows = await parseJournalWorkbook(file);
      addJournalEntries(rows);
    } finally {
      setIsImporting(false);
      if (fileInputRef.current) fileInputRef.current.value = '';
    }
  };

  const handleFormSubmit = (data: JournalEntryInput) => {
    if (editing) {
      updateJournalEntry(editing.id, data);
    } else {
      addJournalEntry(data);
    }
    setFormOpen(false);
    setEditing(null);
  };

  return (
    <div>
      <div className="no-print">
        <PageHeader
          eyebrow={t('journauxPage.eyebrow')}
          title={t('journauxPage.title')}
          description={t('journauxPage.description')}
          action={
            <Button variant="secondary" onClick={() => window.print()}>
              <Printer size={14} /> Imprimer
            </Button>
          }
        />

        <div className="grid sm:grid-cols-2 gap-4 mb-6">
          <StatCard label="Services enregistrés" value={String(journalEntries.length)} icon={<Newspaper size={15} />} />
          <StatCard label="Avec au moins un journal" value={String(withAtLeastOneJournal)} />
        </div>

        {canEdit && (
          <div className="flex flex-wrap gap-2 mb-5">
            <Button onClick={() => { setEditing(null); setFormOpen(true); }}>
              <Plus size={14} /> Ajouter un service
            </Button>
            <Button variant="secondary" onClick={() => fileInputRef.current?.click()} disabled={isImporting}>
              <Upload size={14} /> {isImporting ? 'Import…' : 'Importer Excel'}
            </Button>
            <input ref={fileInputRef} type="file" accept=".xlsx,.xls" onChange={handleFileImport} className="hidden" />
          </div>
        )}
      </div>

      {journalEntries.length === 0 ? (
        <div className="no-print">
          <EmptyState
            title="Aucune entrée enregistrée"
            description="Ajoutez un service manuellement ou importez le fichier Excel de l'organigramme (colonnes Direction, Service, Journal 1, Journal 2, Journal 3)."
            action={
              canEdit ? (
                <Button onClick={() => { setEditing(null); setFormOpen(true); }}>
                  <Plus size={15} /> Ajouter un service
                </Button>
              ) : undefined
            }
          />
        </div>
      ) : (
        <div className="print-area rounded-2xl overflow-hidden" style={{ background: 'var(--card)', border: '1px solid var(--border)' }}>
          <div className="overflow-x-auto">
            <table className="dark-table">
              <thead>
                <tr>
                  <th>Direction</th>
                  <th>Service</th>
                  <th>Journal 1</th>
                  <th>Journal 2</th>
                  <th>Journal 3</th>
                  <th className="no-print">Actions</th>
                </tr>
              </thead>
              <tbody>
                {journalEntries.map((entry) => (
                  <tr key={entry.id}>
                    <td style={{ color: 'var(--text-sec)' }}>{entry.direction || '—'}</td>
                    <td style={{ color: 'var(--text-pri)', fontWeight: 500 }}>{entry.service}</td>
                    <td>{entry.journal1 || '—'}</td>
                    <td>{entry.journal2 || '—'}</td>
                    <td>{entry.journal3 || '—'}</td>
                    <td className="no-print">
                      {canEdit && (
                        <div className="flex items-center gap-1">
                          <button title="Modifier" className="tbl-btn focus-ring" onClick={() => { setEditing(entry); setFormOpen(true); }}>
                            <Pencil size={14} />
                          </button>
                          <button title="Supprimer" className="tbl-btn danger focus-ring" onClick={() => setDeleteTarget(entry)}>
                            <Trash2 size={14} />
                          </button>
                        </div>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      <div className="no-print">
        <JournalEntryFormModal
          open={formOpen}
          onClose={() => { setFormOpen(false); setEditing(null); }}
          initialData={editing}
          onSubmit={handleFormSubmit}
        />

        <ConfirmModal
          open={Boolean(deleteTarget)}
          onClose={() => setDeleteTarget(null)}
          onConfirm={() => { if (deleteTarget) removeJournalEntry(deleteTarget.id); }}
          title="Supprimer cette entrée ?"
          description="Cette action l'envoie dans la Corbeille (Administration), d'où elle reste restaurable."
          confirmLabel="Supprimer"
          danger
        />
      </div>
    </div>
  );
}
