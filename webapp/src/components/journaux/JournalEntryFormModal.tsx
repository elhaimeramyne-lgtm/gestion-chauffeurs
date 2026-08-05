import { useEffect, useState } from 'react';
import type { JournalEntry, JournalEntryInput } from '../../types';
import { Modal, Button } from '../ui/Kit';
import { LIGNE_QUALITES } from '../../lib/lignesConstants';

const emptyForm: JournalEntryInput = {
  direction: '',
  service: '',
  journal1: '',
  journal2: '',
  journal3: ''
};

export default function JournalEntryFormModal({
  open,
  onClose,
  initialData,
  onSubmit
}: {
  open: boolean;
  onClose: () => void;
  initialData?: JournalEntry | null;
  onSubmit: (data: JournalEntryInput) => void;
}) {
  const [form, setForm] = useState<JournalEntryInput>(emptyForm);

  useEffect(() => {
    if (open) {
      setForm(
        initialData
          ? {
              direction: initialData.direction ?? '',
              service: initialData.service,
              journal1: initialData.journal1 ?? '',
              journal2: initialData.journal2 ?? '',
              journal3: initialData.journal3 ?? ''
            }
          : emptyForm
      );
    }
  }, [open, initialData]);

  const setText = (field: keyof JournalEntryInput) => (e: React.ChangeEvent<HTMLInputElement>) =>
    setForm((prev) => ({ ...prev, [field]: e.target.value }));
  const setSelect = (field: keyof JournalEntryInput) => (e: React.ChangeEvent<HTMLSelectElement>) =>
    setForm((prev) => ({ ...prev, [field]: e.target.value }));

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onSubmit(form);
  };

  return (
    <Modal open={open} onClose={onClose} title={initialData ? 'Modifier l’entrée' : 'Ajouter une entrée'} width="lg">
      <form onSubmit={handleSubmit} className="grid sm:grid-cols-2 gap-4">
        <label className="sm:col-span-2">
          <span>Direction / rattachement</span>
          {/* Même liste que "Gestion des lignes" (Fonction / Grade) — une seule
              source de vérité pour les directions/services de l'organisation. */}
          <select value={form.direction ?? ''} onChange={setSelect('direction')} className="focus-ring">
            <option value="">— Non définie —</option>
            {LIGNE_QUALITES.map((q) => (
              <option key={q} value={q}>{q}</option>
            ))}
          </select>
        </label>
        <label className="sm:col-span-2">
          <span>Service *</span>
          <select value={form.service} onChange={setSelect('service')} required className="focus-ring">
            <option value="">— Choisir —</option>
            {LIGNE_QUALITES.map((q) => (
              <option key={q} value={q}>{q}</option>
            ))}
          </select>
        </label>
        <label>
          <span>Journal 1</span>
          <input value={form.journal1 ?? ''} onChange={setText('journal1')} placeholder="ex : L'Économiste" className="focus-ring" />
        </label>
        <label>
          <span>Journal 2</span>
          <input value={form.journal2 ?? ''} onChange={setText('journal2')} placeholder="ex : Al Massae" className="focus-ring" />
        </label>
        <label>
          <span>Journal 3</span>
          <input value={form.journal3 ?? ''} onChange={setText('journal3')} className="focus-ring" />
        </label>

        <div className="sm:col-span-2 flex justify-end gap-2 pt-2" style={{ borderTop: '1px solid var(--border)', marginTop: 4 }}>
          <Button type="button" variant="secondary" onClick={onClose}>Annuler</Button>
          <Button type="submit">{initialData ? 'Enregistrer' : 'Ajouter'}</Button>
        </div>
      </form>
    </Modal>
  );
}
