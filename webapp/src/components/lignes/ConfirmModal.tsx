import { Button, Modal } from '../ui/Kit';

/** Boîte de dialogue de confirmation générique — utilisée avant toute
 *  action destructrice (suppression d'une ligne, purge complète, etc.). */
export default function ConfirmModal({
  open, onClose, onConfirm, title, description, confirmLabel = 'Confirmer', danger
}: {
  open: boolean;
  onClose: () => void;
  onConfirm: () => void;
  title: string;
  description?: string;
  confirmLabel?: string;
  danger?: boolean;
}) {
  return (
    <Modal open={open} onClose={onClose} title={title} description={description} width="sm">
      <div className="flex justify-end gap-2 pt-1">
        <Button variant="secondary" onClick={onClose}>Annuler</Button>
        <Button
          variant={danger ? 'danger' : 'primary'}
          onClick={() => {
            onConfirm();
            onClose();
          }}
        >
          {confirmLabel}
        </Button>
      </div>
    </Modal>
  );
}
