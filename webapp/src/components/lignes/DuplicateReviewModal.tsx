import { AlertTriangle } from 'lucide-react';
import { Button, Modal, Badge } from '../ui/Kit';

/** Affiche le résultat de detectDuplicates() après un import Excel et laisse
 *  l'utilisateur choisir : importer seulement les lignes propres, ou tout
 *  importer malgré les doublons détectés (interne au fichier ou vs. existant). */
export default function DuplicateReviewModal<T>({
  open, onClose, cleanCount, duplicatesOfExisting, duplicatesWithinFile, labelOf, onImportCleanOnly, onImportAll
}: {
  open: boolean;
  onClose: () => void;
  cleanCount: number;
  duplicatesOfExisting: Array<{ row: T; matchKey: string }>;
  duplicatesWithinFile: Array<{ row: T; matchKey: string }>;
  labelOf: (row: T) => string;
  onImportCleanOnly: () => void;
  onImportAll: () => void;
}) {
  const totalDupes = duplicatesOfExisting.length + duplicatesWithinFile.length;

  return (
    <Modal
      open={open}
      onClose={onClose}
      title="Doublons détectés"
      description={`${totalDupes} ligne(s) en double sur un total de ${cleanCount + totalDupes} lignes importées.`}
      width="lg"
    >
      <div className="space-y-4">
        <div className="flex items-start gap-2 rounded-lg px-3 py-2.5" style={{ background: 'rgba(245,158,11,0.08)', border: '1px solid rgba(245,158,11,0.25)' }}>
          <AlertTriangle size={15} style={{ color: 'var(--accent-warn)', flexShrink: 0, marginTop: 2 }} />
          <p className="text-xs" style={{ color: 'var(--text-sec)' }}>
            {cleanCount} ligne(s) peuvent être importées sans risque. Vous pouvez choisir d'ignorer les doublons ou de tout importer quand même.
          </p>
        </div>

        {duplicatesOfExisting.length > 0 && (
          <div>
            <p className="text-xs font-semibold mb-2 flex items-center gap-2" style={{ color: 'var(--text-ter)' }}>
              Doublons avec des lignes existantes <Badge tone="bad">{duplicatesOfExisting.length}</Badge>
            </p>
            <div className="space-y-1 max-h-40 overflow-y-auto">
              {duplicatesOfExisting.map((d, i) => (
                <div key={i} className="text-xs flex items-center justify-between rounded-lg px-3 py-1.5" style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}>
                  <span style={{ color: 'var(--text-sec)' }}>{labelOf(d.row)}</span>
                  <span className="font-mono" style={{ color: 'var(--text-ter)' }}>{d.matchKey}</span>
                </div>
              ))}
            </div>
          </div>
        )}

        {duplicatesWithinFile.length > 0 && (
          <div>
            <p className="text-xs font-semibold mb-2 flex items-center gap-2" style={{ color: 'var(--text-ter)' }}>
              Doublons à l'intérieur du fichier <Badge tone="warn">{duplicatesWithinFile.length}</Badge>
            </p>
            <div className="space-y-1 max-h-40 overflow-y-auto">
              {duplicatesWithinFile.map((d, i) => (
                <div key={i} className="text-xs flex items-center justify-between rounded-lg px-3 py-1.5" style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}>
                  <span style={{ color: 'var(--text-sec)' }}>{labelOf(d.row)}</span>
                  <span className="font-mono" style={{ color: 'var(--text-ter)' }}>{d.matchKey}</span>
                </div>
              ))}
            </div>
          </div>
        )}

        <div className="flex justify-end gap-2 pt-2" style={{ borderTop: '1px solid var(--border)' }}>
          <Button variant="secondary" onClick={onClose}>Annuler</Button>
          <Button variant="secondary" onClick={onImportCleanOnly}>Importer sans les doublons ({cleanCount})</Button>
          <Button variant="primary" onClick={onImportAll}>Tout importer quand même</Button>
        </div>
      </div>
    </Modal>
  );
}
