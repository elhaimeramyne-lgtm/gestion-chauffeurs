import { useEffect, useState } from 'react';
import type { LigneFixe, LigneFixeInput } from '../../types';
import { Modal, Button } from '../ui/Kit';
import { LIGNE_QUALITES } from '../../lib/lignesConstants';
import { useOrg } from '../../context/OrgContext';

const emptyForm: LigneFixeInput = {
  nd: '',
  custcode: '',
  coordinationRegionale: '',
  delegation: '',
  domiciliation: '',
  personne: '',
  qualite: '',
  date: new Date().toISOString().slice(0, 10),
  serviceId: null,
  consommationMensuelleDh: null
};

function inputClass() {
  return 'focus-ring';
}

export default function LigneFixeFormModal({
  open,
  onClose,
  initialData,
  onSubmit
}: {
  open: boolean;
  onClose: () => void;
  initialData?: LigneFixe | null;
  onSubmit: (data: LigneFixeInput) => void;
}) {
  const [form, setForm] = useState<LigneFixeInput>(emptyForm);
  const { nodes } = useOrg();
  const sortedNodes = [...nodes].sort((a, b) => a.name.localeCompare(b.name));

  useEffect(() => {
    if (open) {
      setForm(
        initialData
          ? {
              nd: initialData.nd,
              custcode: initialData.custcode ?? '',
              coordinationRegionale: initialData.coordinationRegionale ?? '',
              delegation: initialData.delegation ?? '',
              domiciliation: initialData.domiciliation ?? '',
              personne: initialData.personne ?? '',
              qualite: initialData.qualite ?? '',
              date: initialData.date ?? new Date().toISOString().slice(0, 10),
              serviceId: initialData.serviceId ?? null,
              consommationMensuelleDh: initialData.consommationMensuelleDh ?? null
            }
          : emptyForm
      );
    }
  }, [open, initialData]);

  const set = (field: keyof LigneFixeInput) => (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) =>
    setForm((prev) => ({ ...prev, [field]: e.target.value }));

  const setServiceId = (e: React.ChangeEvent<HTMLSelectElement>) =>
    setForm((prev) => ({ ...prev, serviceId: e.target.value ? Number(e.target.value) : null }));

  const setConsommation = (e: React.ChangeEvent<HTMLInputElement>) =>
    setForm((prev) => ({ ...prev, consommationMensuelleDh: e.target.value ? Number(e.target.value) : null }));

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onSubmit(form);
  };

  return (
    <Modal open={open} onClose={onClose} title={initialData ? 'Modifier la ligne fixe' : 'Ajouter une ligne fixe'} width="lg">
      <form onSubmit={handleSubmit} className="grid sm:grid-cols-2 gap-4">
        <label>
          <span>ND (numéro de ligne) *</span>
          <input value={form.nd} onChange={set('nd')} required className={inputClass()} />
        </label>
        <label>
          <span>CUSTCODE</span>
          <input value={form.custcode ?? ''} onChange={set('custcode')} className={inputClass()} />
        </label>
        <label>
          <span>Coordination régionale</span>
          <input value={form.coordinationRegionale ?? ''} onChange={set('coordinationRegionale')} className={inputClass()} />
        </label>
        <label>
          <span>Délégation</span>
          <input value={form.delegation ?? ''} onChange={set('delegation')} className={inputClass()} />
        </label>
        <label>
          <span>Domiciliation</span>
          <input value={form.domiciliation ?? ''} onChange={set('domiciliation')} className={inputClass()} />
        </label>
        <label>
          <span>Personne</span>
          <input value={form.personne ?? ''} onChange={set('personne')} className={inputClass()} />
        </label>
        <label>
          <span>Fonction / Grade</span>
          <select value={form.qualite ?? ''} onChange={set('qualite')} className={inputClass()}>
            <option value="">— Non définie —</option>
            {LIGNE_QUALITES.map((q) => (
              <option key={q} value={q}>
                {q}
              </option>
            ))}
          </select>
        </label>
        <label>
          <span>Date</span>
          <input type="date" value={form.date ?? ''} onChange={set('date')} className={inputClass()} />
        </label>
        <label>
          <span>Direction / Service (organigramme)</span>
          <select value={form.serviceId ?? ''} onChange={setServiceId} className={inputClass()}>
            <option value="">— Non rattachée —</option>
            {sortedNodes.map((n) => (
              <option key={n.id} value={n.id}>{n.name}</option>
            ))}
          </select>
        </label>
        <label>
          <span>Consommation mensuelle (DH)</span>
          <input type="number" min={0} value={form.consommationMensuelleDh ?? ''} onChange={setConsommation} className={inputClass()} />
        </label>

        <div className="sm:col-span-2 flex justify-end gap-2 pt-2" style={{ borderTop: '1px solid var(--border)', marginTop: 4 }}>
          <Button type="button" variant="secondary" onClick={onClose}>
            Annuler
          </Button>
          <Button type="submit">{initialData ? 'Enregistrer' : 'Ajouter'}</Button>
        </div>
      </form>
    </Modal>
  );
}
