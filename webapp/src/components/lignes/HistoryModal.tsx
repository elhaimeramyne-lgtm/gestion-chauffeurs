import { useEffect, useState } from 'react';
import { Clock } from 'lucide-react';
import { Modal } from '../ui/Kit';
import { api } from '../../lib/api';

interface AuditLogEntry {
  id: number;
  action: string;
  username: string | null;
  details: unknown;
  createdAt: string;
}

const ACTION_LABELS: Record<string, string> = {
  create: 'Création',
  update: 'Modification',
  delete: 'Suppression',
  import: 'Import',
  export: 'Export'
};

function formatDateTime(iso: string): string {
  return new Date(iso).toLocaleString('fr-FR', { day: '2-digit', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit' });
}

/** Historique horodaté d'un enregistrement précis, alimenté par le journal
 *  d'audit global de la plateforme (aucune table dédiée nécessaire). */
export default function HistoryModal({
  open, onClose, entity, entityId, title
}: {
  open: boolean;
  onClose: () => void;
  entity: string;
  entityId: string | number | null;
  title?: string;
}) {
  const [logs, setLogs] = useState<AuditLogEntry[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!open || entityId == null) return;
    setLoading(true);
    setError(null);
    api.get<{ logs: AuditLogEntry[] }>(`/audit-logs?entity=${entity}&entityId=${entityId}&limit=50`)
      .then((res) => setLogs(res.logs))
      .catch(() => setError("Impossible de charger l'historique (droits insuffisants ?)."))
      .finally(() => setLoading(false));
  }, [open, entity, entityId]);

  return (
    <Modal open={open} onClose={onClose} title={title ?? 'Historique'} width="md">
      {loading ? (
        <p className="text-sm py-6 text-center" style={{ color: 'var(--text-ter)' }}>Chargement…</p>
      ) : error ? (
        <p className="text-xs rounded-lg px-3 py-2" style={{ color: 'var(--accent-err)', background: 'rgba(239,68,68,0.08)', border: '1px solid rgba(239,68,68,0.2)' }}>{error}</p>
      ) : logs.length === 0 ? (
        <p className="text-sm py-6 text-center" style={{ color: 'var(--text-ter)' }}>Aucun historique disponible pour cet enregistrement.</p>
      ) : (
        <div className="space-y-2 max-h-80 overflow-y-auto pr-1">
          {logs.map((log) => (
            <div key={log.id} className="flex items-start gap-2 text-xs rounded-lg px-3 py-2" style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}>
              <Clock size={12} className="mt-0.5 shrink-0" style={{ color: 'var(--text-ter)' }} />
              <div className="min-w-0 flex-1">
                <p style={{ color: 'var(--text-pri)', fontWeight: 600 }}>{ACTION_LABELS[log.action] ?? log.action}</p>
                <p style={{ color: 'var(--text-ter)' }}>{log.username ?? 'Système'} · {formatDateTime(log.createdAt)}</p>
              </div>
            </div>
          ))}
        </div>
      )}
    </Modal>
  );
}
