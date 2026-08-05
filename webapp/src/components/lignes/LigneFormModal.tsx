import { useEffect, useState } from 'react';
import type { Civilite, Ligne, LigneInput } from '../../types';
import { Modal, Button } from '../ui/Kit';
import { LIGNE_CATEGORIES, LIGNE_QUALITES } from '../../lib/lignesConstants';
import { useOrg } from '../../context/OrgContext';

const CIVILITES: Civilite[] = ['Mme', 'Mlle', 'M.'];

// Pour une NOUVELLE ligne, on pré-sélectionne Mme par défaut
const emptyForm: LigneInput = {
  categorie: LIGNE_CATEGORIES[0],
  typeForfait: '',
  typeMobile: '',
  icc: '',
  imei: '',
  affecte: '',
  civilite: 'Mme',   // défaut uniquement pour une création
  personne: '',
  qualite: '',
  date: new Date().toISOString().slice(0, 10),
  pin: '',
  puk: '',
  serviceId: null,
  consommationMensuelleDh: null
};

// Les styles d'input sont injectés globalement par Modal via .modal-body
// On laisse juste la classe de focus
function inputClass() {
  return 'focus-ring';
}

export default function LigneFormModal({
  open,
  onClose,
  initialData,
  onSubmit
}: {
  open: boolean;
  onClose: () => void;
  initialData?: Ligne | null;
  onSubmit: (data: LigneInput) => void;
}) {
  const [form, setForm] = useState<LigneInput>(emptyForm);
  const { nodes } = useOrg();
  const sortedNodes = [...nodes].sort((a, b) => a.name.localeCompare(b.name));

  useEffect(() => {
    if (open) {
      setForm(
        initialData
          ? {
              categorie: initialData.categorie,
              typeForfait: initialData.typeForfait ?? '',
              typeMobile: initialData.typeMobile ?? '',
              icc: initialData.icc ?? '',
              imei: initialData.imei ?? '',
              affecte: initialData.affecte ?? '',
              // On reprend exactement la valeur stockée — si null, on garde null
              // pour ne pas écraser une valeur absente en base par 'Mme' par défaut
              civilite: initialData.civilite ?? null,
              personne: initialData.personne ?? '',
              qualite: initialData.qualite ?? '',
              date: initialData.date ?? new Date().toISOString().slice(0, 10),
              pin: initialData.pin ?? '',
              puk: initialData.puk ?? '',
              serviceId: initialData.serviceId ?? null,
              consommationMensuelleDh: initialData.consommationMensuelleDh ?? null
            }
          : emptyForm
      );
    }
  }, [open, initialData]);

  const set = (field: keyof LigneInput) => (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) =>
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
    <Modal
      open={open}
      onClose={onClose}
      title={initialData ? 'Modifier la ligne' : 'Ajouter une ligne'}
      width="lg"
    >
      <form onSubmit={handleSubmit} className="grid sm:grid-cols-2 gap-4">
        <label>
          <span>Catégorie *</span>
          <select value={form.categorie} onChange={set('categorie')} required className={inputClass()}>
            {LIGNE_CATEGORIES.map((c) => <option key={c} value={c}>{c}</option>)}
          </select>
        </label>
        <label>
          <span>Forfait</span>
          <input value={form.typeForfait ?? ''} onChange={set('typeForfait')} className={inputClass()} />
        </label>
        <label>
          <span>Mobile</span>
          <input value={form.typeMobile ?? ''} onChange={set('typeMobile')} className={inputClass()} />
        </label>
        <label>
          <span>ICC</span>
          <input value={form.icc ?? ''} onChange={set('icc')} className={inputClass()} />
        </label>
        <label>
          <span>IMEI</span>
          <input value={form.imei ?? ''} onChange={set('imei')} className={inputClass()} />
        </label>
        <label>
          <span>Qualité</span>
          <input value={form.affecte ?? ''} onChange={set('affecte')} className={inputClass()} />
        </label>
        <label>
          <span>Civilité</span>
          <select value={form.civilite ?? ''} onChange={set('civilite')} className={inputClass()}>
            {/* Valeur vide = non définie, pour ne pas forcer Mme à tort */}
            <option value="">— Choisir —</option>
            {CIVILITES.map((c) => <option key={c} value={c}>{c}</option>)}
          </select>
        </label>
        <label>
          <span>Personne</span>
          <input value={form.personne ?? ''} onChange={set('personne')} className={inputClass()} />
        </label>
        <label>
          <span>Fonction / Grade</span>
          <select value={form.qualite ?? ''} onChange={set('qualite')} className={inputClass()}>
            <option value="">— Non définie —</option>
            {LIGNE_QUALITES.map((q) => <option key={q} value={q}>{q}</option>)}
          </select>
        </label>
        <label>
          <span>Date</span>
          <input type="date" value={form.date ?? ''} onChange={set('date')} className={inputClass()} />
        </label>
        <label>
          <span>PIN</span>
          <input value={form.pin ?? ''} onChange={set('pin')} className={inputClass()} placeholder="Code PIN de la SIM" />
        </label>
        <label>
          <span>PUK</span>
          <input value={form.puk ?? ''} onChange={set('puk')} className={inputClass()} placeholder="Code PUK de la SIM" />
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
          <Button type="button" variant="secondary" onClick={onClose}>Annuler</Button>
          <Button type="submit">{initialData ? 'Enregistrer' : 'Ajouter'}</Button>
        </div>
      </form>
    </Modal>
  );
}
