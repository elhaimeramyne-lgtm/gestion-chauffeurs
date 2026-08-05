import { useEffect, useState } from 'react';
import type { Civilite, Ligne } from '../../types';
import { Modal, Button } from '../ui/Kit';
import { LIGNE_QUALITES } from '../../lib/lignesConstants';

const CIVILITES: Civilite[] = ['Mme', 'Mlle', 'M.'];

export interface TransferSubmitData {
  nouvellePersonne: string;
  civilite: Civilite;
  nouveauAffecte: string | null;
  nouvelleQualite: string | null;
  generateBon: boolean;
}

export default function TransferIccModal({
  open,
  onClose,
  ligne,
  onSubmit
}: {
  open: boolean;
  onClose: () => void;
  ligne: Ligne | null;
  onSubmit: (data: TransferSubmitData) => void;
}) {
  const [nouvellePersonne, setNouvellePersonne] = useState('');
  const [civilite, setCivilite] = useState<Civilite>('Mme');
  const [nouveauAffecte, setNouveauAffecte] = useState('');
  const [nouvelleQualite, setNouvelleQualite] = useState('');
  const [generateBon, setGenerateBon] = useState(true);

  useEffect(() => {
    if (open) {
      setNouvellePersonne('');
      setCivilite(ligne?.civilite ?? 'Mme');
      setNouveauAffecte(ligne?.affecte ?? '');
      setNouvelleQualite(ligne?.qualite ?? '');
      setGenerateBon(true);
    }
  }, [open, ligne]);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!nouvellePersonne.trim()) return;
    onSubmit({
      nouvellePersonne: nouvellePersonne.trim(),
      civilite,
      nouveauAffecte: nouveauAffecte || null,
      nouvelleQualite: nouvelleQualite || null,
      generateBon
    });
  };

  return (
    <Modal open={open} onClose={onClose} title="Transférer / réaffecter la ligne">
      <div className="text-sm text-ink-500 border border-ink-100 rounded-lg p-3 bg-ink-50 space-y-1 mb-4">
        <div className="flex items-center justify-between">
          <span className="text-xs font-semibold uppercase tracking-wide text-ink-400">ICC</span>
          <span className="font-mono font-medium text-ink-800">{ligne?.icc || '—'}</span>
        </div>
        {ligne?.imei && (
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold uppercase tracking-wide text-ink-400">IMEI</span>
            <span className="font-mono font-medium text-ink-800">{ligne.imei}</span>
          </div>
        )}
        {ligne?.typeMobile && (
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold uppercase tracking-wide text-ink-400">Appareil</span>
            <span className="font-medium text-ink-800">{ligne.typeMobile}</span>
          </div>
        )}
        <div className="flex items-center justify-between pt-1 border-t border-ink-100 mt-1">
          <span className="text-xs font-semibold uppercase tracking-wide text-ink-400">Bénéficiaire actuel</span>
          <span className="font-medium text-ink-800">{ligne?.personne || '—'}</span>
        </div>
      </div>

      <form onSubmit={handleSubmit} className="space-y-4">
        <div className="grid grid-cols-[140px_1fr] gap-2">
          <label className="text-xs text-ink-500 block">
            <span>Civilité</span>
            <select
              value={civilite}
              onChange={(e) => setCivilite(e.target.value as Civilite)}
              className="focus-ring mt-1 w-full rounded-lg border border-ink-200 px-3 py-2 text-sm text-ink-800"
            >
              {CIVILITES.map((c) => <option key={c} value={c}>{c}</option>)}
            </select>
          </label>
          <label className="text-xs text-ink-500 block">
            <span>Nouveau bénéficiaire *</span>
            <input
              required
              value={nouvellePersonne}
              onChange={(e) => setNouvellePersonne(e.target.value)}
              placeholder="Nom et prénom"
              className="focus-ring mt-1 w-full rounded-lg border border-ink-200 px-3 py-2 text-sm text-ink-800"
            />
          </label>
        </div>
        <label className="text-xs text-ink-500 block">
          <span>Nouvelle affectation</span>
          <input
            value={nouveauAffecte}
            onChange={(e) => setNouveauAffecte(e.target.value)}
            placeholder="Direction / Service..."
            className="focus-ring mt-1 w-full rounded-lg border border-ink-200 px-3 py-2 text-sm text-ink-800"
          />
        </label>
        <label className="text-xs text-ink-500 block">
          <span>Nouvelle qualité</span>
          <select
            value={nouvelleQualite}
            onChange={(e) => setNouvelleQualite(e.target.value)}
            className="focus-ring mt-1 w-full rounded-lg border border-ink-200 px-3 py-2 text-sm text-ink-800"
          >
            <option value="">— Non définie —</option>
            {LIGNE_QUALITES.map((q) => (
              <option key={q} value={q}>
                {q}
              </option>
            ))}
          </select>
        </label>

        <label className="flex items-start gap-3 rounded-lg border border-ink-100 bg-ink-50 p-3 text-sm">
          <input
            type="checkbox"
            checked={generateBon}
            onChange={(e) => setGenerateBon(e.target.checked)}
            className="mt-0.5 focus-ring rounded border-ink-300"
          />
          <span>
            <span className="font-medium text-ink-800">Générer le bon de réaffectation</span>
            <span className="block text-xs text-ink-400 mt-0.5">
              Un document imprimable pré-rempli s'ouvrira après le transfert.
            </span>
          </span>
        </label>

        <div className="flex justify-end gap-2 pt-2">
          <Button type="button" variant="secondary" onClick={onClose}>
            Annuler
          </Button>
          <Button type="submit">Transférer</Button>
        </div>
      </form>
    </Modal>
  );
}
