import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import {
  Settings, DatabaseBackup, Terminal, ShieldCheck, Trash2, Download,
  RotateCcw, XCircle, Loader2, ShieldAlert, Monitor
} from 'lucide-react';
import { api, ApiError } from '../lib/api';
import { PageHeader, Card, Button, Badge, Modal } from '../components/ui/Kit';

type Tab = 'settings' | 'backups' | 'system-log' | 'permissions' | 'trash' | 'security';

const TABS: Array<{ id: Tab; label: string; icon: typeof Settings }> = [
  { id: 'settings', label: 'Paramètres', icon: Settings },
  { id: 'backups', label: 'Sauvegardes', icon: DatabaseBackup },
  { id: 'system-log', label: 'Journal système', icon: Terminal },
  { id: 'security', label: 'Sécurité', icon: ShieldAlert },
  { id: 'permissions', label: 'Permissions', icon: ShieldCheck },
  { id: 'trash', label: 'Corbeille', icon: Trash2 }
];

function Tabs({ tab, setTab }: { tab: Tab; setTab: (t: Tab) => void }) {
  return (
    <div className="flex flex-wrap gap-1.5 mb-5">
      {TABS.map((t) => (
        <button
          key={t.id}
          onClick={() => setTab(t.id)}
          className="focus-ring flex items-center gap-1.5 px-3 py-1.5 rounded-full text-xs font-medium transition-colors"
          style={{
            background: tab === t.id ? 'rgba(99,102,241,0.14)' : 'var(--glass-bg)',
            border: `1px solid ${tab === t.id ? 'rgba(99,102,241,0.35)' : 'var(--border)'}`,
            color: tab === t.id ? '#6366f1' : 'var(--text-sec)'
          }}
        >
          <t.icon size={13} />
          {t.label}
        </button>
      ))}
    </div>
  );
}

// ── Paramètres ─────────────────────────────────────────────────────────
interface SystemSettings {
  organizationName: string;
  supportEmail: string | null;
  sessionDurationDays: number;
  maintenanceMode: boolean;
  maintenanceMessage: string | null;
  backupScheduleEnabled: boolean;
  backupScheduleFrequency: 'daily' | 'weekly';
  backupScheduleHour: number;
}

function SettingsTab() {
  const [settings, setSettings] = useState<SystemSettings | null>(null);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [saved, setSaved] = useState(false);

  useEffect(() => {
    api
      .get<{ settings: SystemSettings }>('/settings')
      .then((res) => setSettings(res.settings))
      .catch((err) => setError(err instanceof ApiError ? err.message : 'Erreur de chargement.'));
  }, []);

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!settings) return;
    setSaving(true);
    setError(null);
    setSaved(false);
    try {
      const res = await api.patch<{ settings: SystemSettings }>('/settings', settings);
      setSettings(res.settings);
      setSaved(true);
      setTimeout(() => setSaved(false), 2500);
    } catch (err) {
      setError(err instanceof ApiError ? err.message : "Erreur lors de l'enregistrement.");
    } finally {
      setSaving(false);
    }
  };

  if (!settings) return <p className="text-sm text-ink-400">Chargement…</p>;

  return (
    <Card className="p-5 max-w-xl">
      <form onSubmit={handleSave} className="space-y-4">
        {error && <p className="text-sm text-signal-roseDark bg-signal-rose/10 rounded-lg px-3 py-2">{error}</p>}
        <label className="block text-xs text-ink-500">
          <span>Nom de l'organisation</span>
          <input
            value={settings.organizationName}
            onChange={(e) => setSettings({ ...settings, organizationName: e.target.value })}
            className="focus-ring mt-1 w-full rounded-lg border border-ink-200 px-3 py-2 text-sm"
          />
        </label>
        <label className="block text-xs text-ink-500">
          <span>E-mail support</span>
          <input
            type="email"
            value={settings.supportEmail ?? ''}
            onChange={(e) => setSettings({ ...settings, supportEmail: e.target.value || null })}
            className="focus-ring mt-1 w-full rounded-lg border border-ink-200 px-3 py-2 text-sm"
          />
        </label>
        <label className="block text-xs text-ink-500">
          <span>Durée de session (jours)</span>
          <input
            type="number"
            min={1}
            max={365}
            value={settings.sessionDurationDays}
            onChange={(e) => setSettings({ ...settings, sessionDurationDays: Number(e.target.value) })}
            className="focus-ring mt-1 w-full rounded-lg border border-ink-200 px-3 py-2 text-sm"
          />
        </label>
        <label className="flex items-center gap-2 text-sm text-ink-700">
          <input
            type="checkbox"
            checked={settings.maintenanceMode}
            onChange={(e) => setSettings({ ...settings, maintenanceMode: e.target.checked })}
          />
          Mode maintenance (bloque l'accès aux comptes non SUPER_ADMIN)
        </label>
        {settings.maintenanceMode && (
          <label className="block text-xs text-ink-500">
            <span>Message affiché aux utilisateurs</span>
            <textarea
              value={settings.maintenanceMessage ?? ''}
              onChange={(e) => setSettings({ ...settings, maintenanceMessage: e.target.value || null })}
              className="focus-ring mt-1 w-full rounded-lg border border-ink-200 px-3 py-2 text-sm"
              rows={2}
            />
          </label>
        )}

        <div className="pt-3" style={{ borderTop: '1px solid var(--border)' }}>
          <label className="flex items-center gap-2 text-sm text-ink-700">
            <input
              type="checkbox"
              checked={settings.backupScheduleEnabled}
              onChange={(e) => setSettings({ ...settings, backupScheduleEnabled: e.target.checked })}
            />
            Sauvegarde automatique planifiée
          </label>
          {settings.backupScheduleEnabled && (
            <div className="grid grid-cols-2 gap-3 mt-3">
              <label className="block text-xs text-ink-500">
                <span>Fréquence</span>
                <select
                  value={settings.backupScheduleFrequency}
                  onChange={(e) => setSettings({ ...settings, backupScheduleFrequency: e.target.value as 'daily' | 'weekly' })}
                  className="focus-ring mt-1 w-full rounded-lg border border-ink-200 px-3 py-2 text-sm"
                >
                  <option value="daily">Quotidienne</option>
                  <option value="weekly">Hebdomadaire (le lundi)</option>
                </select>
              </label>
              <label className="block text-xs text-ink-500">
                <span>Heure (serveur, 0-23h)</span>
                <input
                  type="number"
                  min={0}
                  max={23}
                  value={settings.backupScheduleHour}
                  onChange={(e) => setSettings({ ...settings, backupScheduleHour: Number(e.target.value) })}
                  className="focus-ring mt-1 w-full rounded-lg border border-ink-200 px-3 py-2 text-sm"
                />
              </label>
            </div>
          )}
        </div>

        <div className="flex items-center gap-3 pt-2">
          <Button type="submit" disabled={saving}>
            {saving ? <Loader2 size={14} className="animate-spin" /> : null}
            Enregistrer
          </Button>
          {saved && <span className="text-xs text-signal-emeraldDark">Enregistré ✓</span>}
        </div>
      </form>
    </Card>
  );
}

// ── Test SMTP ──────────────────────────────────────────────────────────
function SmtpTestCard() {
  const [to, setTo] = useState('');
  const [sending, setSending] = useState(false);
  const [result, setResult] = useState<{ ok: boolean; message: string } | null>(null);

  const handleTest = async (e: React.FormEvent) => {
    e.preventDefault();
    setSending(true);
    setResult(null);
    try {
      await api.post('/email/test', { to });
      setResult({ ok: true, message: 'E-mail de test envoyé avec succès.' });
    } catch (err) {
      setResult({ ok: false, message: err instanceof ApiError ? err.message : "Échec de l'envoi." });
    } finally {
      setSending(false);
    }
  };

  return (
    <Card className="p-5 max-w-xl mt-4">
      <p className="text-sm font-semibold mb-1" style={{ color: 'var(--text-pri)' }}>Configuration SMTP (e-mails)</p>
      <p className="text-xs mb-3" style={{ color: 'var(--text-ter)' }}>
        La connexion SMTP se configure dans <code>server/.env</code> (SMTP_HOST, SMTP_USER, SMTP_PASS...).
        Testez-la ici après configuration.
      </p>
      <form onSubmit={handleTest} className="flex flex-wrap gap-2 items-end">
        <label className="block text-xs text-ink-500 flex-1 min-w-[220px]">
          <span>Adresse de test</span>
          <input
            type="email"
            required
            value={to}
            onChange={(e) => setTo(e.target.value)}
            placeholder="vous@entraide.ma"
            className="focus-ring mt-1 w-full rounded-lg border border-ink-200 px-3 py-2 text-sm"
          />
        </label>
        <Button type="submit" disabled={sending}>
          {sending ? <Loader2 size={14} className="animate-spin" /> : null} Envoyer un test
        </Button>
      </form>
      {result && (
        <p className={`text-sm mt-3 rounded-lg px-3 py-2 ${result.ok ? 'bg-signal-emerald/10 text-signal-emeraldDark' : 'bg-signal-rose/10 text-signal-roseDark'}`}>
          {result.message}
        </p>
      )}
    </Card>
  );
}

// ── Test WhatsApp ──────────────────────────────────────────────────────
function WhatsAppTestCard() {
  const [to, setTo] = useState('');
  const [sending, setSending] = useState(false);
  const [result, setResult] = useState<{ ok: boolean; message: string } | null>(null);

  const handleTest = async (e: React.FormEvent) => {
    e.preventDefault();
    setSending(true);
    setResult(null);
    try {
      await api.post('/whatsapp/test', { to });
      setResult({ ok: true, message: 'Message WhatsApp de test envoyé avec succès.' });
    } catch (err) {
      setResult({ ok: false, message: err instanceof ApiError ? err.message : "Échec de l'envoi." });
    } finally {
      setSending(false);
    }
  };

  return (
    <Card className="p-5 max-w-xl mt-4">
      <p className="text-sm font-semibold mb-1" style={{ color: 'var(--text-pri)' }}>Configuration WhatsApp Business</p>
      <p className="text-xs mb-3" style={{ color: 'var(--text-ter)' }}>
        Se configure dans <code>server/.env</code> (WHATSAPP_ACCESS_TOKEN, WHATSAPP_PHONE_NUMBER_ID) —
        nécessite un compte WhatsApp Business API (Meta). Testez-la ici après configuration.
      </p>
      <form onSubmit={handleTest} className="flex flex-wrap gap-2 items-end">
        <label className="block text-xs text-ink-500 flex-1 min-w-[220px]">
          <span>Numéro de test (format international, ex: 212612345678)</span>
          <input
            required
            value={to}
            onChange={(e) => setTo(e.target.value)}
            placeholder="212612345678"
            className="focus-ring mt-1 w-full rounded-lg border border-ink-200 px-3 py-2 text-sm"
          />
        </label>
        <Button type="submit" disabled={sending}>
          {sending ? <Loader2 size={14} className="animate-spin" /> : null} Envoyer un test
        </Button>
      </form>
      {result && (
        <p className={`text-sm mt-3 rounded-lg px-3 py-2 ${result.ok ? 'bg-signal-emerald/10 text-signal-emeraldDark' : 'bg-signal-rose/10 text-signal-roseDark'}`}>
          {result.message}
        </p>
      )}
    </Card>
  );
}

// ── Sauvegardes ────────────────────────────────────────────────────────
interface Backup {
  filename: string;
  sizeBytes: number;
  createdAt: string;
}

function formatSize(bytes: number): string {
  if (bytes < 1024) return `${bytes} o`;
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} Ko`;
  return `${(bytes / (1024 * 1024)).toFixed(1)} Mo`;
}

function BackupsTab() {
  const [backups, setBackups] = useState<Backup[]>([]);
  const [loading, setLoading] = useState(true);
  const [creating, setCreating] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const [restoreTarget, setRestoreTarget] = useState<Backup | null>(null);
  const [restoreConfirmText, setRestoreConfirmText] = useState('');
  const [restoring, setRestoring] = useState(false);
  const [restoreDone, setRestoreDone] = useState<string | null>(null);

  const load = () => {
    setLoading(true);
    api
      .get<{ backups: Backup[] }>('/system/backups')
      .then((res) => setBackups(res.backups))
      .catch((err) => setError(err instanceof ApiError ? err.message : 'Erreur de chargement.'))
      .finally(() => setLoading(false));
  };

  useEffect(load, []);

  const handleCreate = async () => {
    setCreating(true);
    setError(null);
    try {
      await api.post('/system/backup');
      load();
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'Erreur lors de la sauvegarde.');
    } finally {
      setCreating(false);
    }
  };

  const handleDelete = async (filename: string) => {
    if (!confirm(`Supprimer la sauvegarde "${filename}" ?`)) return;
    try {
      await api.delete(`/system/backups/${filename}`);
      load();
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'Erreur lors de la suppression.');
    }
  };

  const handleRestore = async () => {
    if (!restoreTarget) return;
    setRestoring(true);
    setError(null);
    setRestoreDone(null);
    try {
      const res = await api.post<{ ok: boolean; safetyBackup: string }>(
        `/system/backups/${restoreTarget.filename}/restore`
      );
      setRestoreDone(`Restauration réussie. Une sauvegarde de sécurité de l'état précédent a été créée : "${res.safetyBackup}".`);
      setRestoreTarget(null);
      setRestoreConfirmText('');
      load();
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'Erreur lors de la restauration.');
    } finally {
      setRestoring(false);
    }
  };

  const downloadUrl = (filename: string) =>
    `${(import.meta.env.VITE_API_URL as string | undefined) ?? 'http://localhost:5000/api'}/system/backups/${filename}/download`;

  return (
    <div>
      <div className="flex items-center justify-between mb-4">
        <p className="text-sm text-ink-500">
          Génère une sauvegarde complète de la base de données (pg_dump), téléchargeable depuis ce poste.
        </p>
        <Button onClick={handleCreate} disabled={creating}>
          {creating ? <Loader2 size={14} className="animate-spin" /> : <DatabaseBackup size={15} />}
          Lancer une sauvegarde
        </Button>
      </div>

      {error && <p className="text-sm text-signal-roseDark bg-signal-rose/10 rounded-lg px-3 py-2 mb-4">{error}</p>}
      {restoreDone && <p className="text-sm bg-signal-emerald/10 text-signal-emeraldDark rounded-lg px-3 py-2 mb-4">{restoreDone}</p>}

      <Card className="overflow-hidden">
        <table className="w-full text-sm">
          <thead>
            <tr className="bg-ink-50 text-left text-xs text-ink-500 uppercase tracking-wide">
              <th className="px-4 py-3">Fichier</th>
              <th className="px-4 py-3">Taille</th>
              <th className="px-4 py-3">Créée le</th>
              <th className="px-4 py-3">Actions</th>
            </tr>
          </thead>
          <tbody>
            {backups.map((b) => (
              <tr key={b.filename} className="border-t border-ink-50">
                <td className="px-4 py-3 font-mono text-xs text-ink-800">{b.filename}</td>
                <td className="px-4 py-3 text-ink-600">{formatSize(b.sizeBytes)}</td>
                <td className="px-4 py-3 text-ink-500 text-xs">{new Date(b.createdAt).toLocaleString('fr-FR')}</td>
                <td className="px-4 py-3">
                  <div className="flex items-center gap-1.5">
                    <a
                      href={downloadUrl(b.filename)}
                      title="Télécharger"
                      className="focus-ring p-2 rounded-md text-ink-500 hover:bg-ink-100 hover:text-ink-800"
                    >
                      <Download size={15} />
                    </a>
                    <button
                      title="Restaurer cette sauvegarde"
                      onClick={() => { setRestoreTarget(b); setRestoreConfirmText(''); }}
                      className="focus-ring p-2 rounded-md text-ink-500 hover:bg-signal-amber/10 hover:text-signal-amberDark"
                    >
                      <RotateCcw size={15} />
                    </button>
                    <button
                      title="Supprimer"
                      onClick={() => handleDelete(b.filename)}
                      className="focus-ring p-2 rounded-md text-ink-500 hover:bg-signal-rose/10 hover:text-signal-rose"
                    >
                      <Trash2 size={15} />
                    </button>
                  </div>
                </td>
              </tr>
            ))}
            {!loading && backups.length === 0 && (
              <tr>
                <td colSpan={4} className="px-4 py-8 text-center text-ink-400">
                  Aucune sauvegarde pour le moment.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </Card>

      <Modal open={Boolean(restoreTarget)} onClose={() => setRestoreTarget(null)} title="⚠️ Restaurer une sauvegarde" width="sm">
        <div className="space-y-4">
          <p className="text-sm text-signal-roseDark bg-signal-rose/10 rounded-lg px-3 py-2">
            Cette action <b>remplace toutes les données actuelles</b> par celles de la sauvegarde
            <span className="font-mono"> {restoreTarget?.filename}</span>. Une sauvegarde de sécurité de l'état
            actuel sera créée automatiquement avant, mais toute donnée saisie après cette sauvegarde sera perdue.
          </p>
          <label className="block text-xs text-ink-500">
            <span>Tapez <b>RESTAURER</b> pour confirmer</span>
            <input
              value={restoreConfirmText}
              onChange={(e) => setRestoreConfirmText(e.target.value)}
              className="focus-ring mt-1 w-full rounded-lg border border-ink-200 px-3 py-2 text-sm"
              autoFocus
            />
          </label>
          <div className="flex justify-end gap-2">
            <Button variant="secondary" onClick={() => setRestoreTarget(null)}>Annuler</Button>
            <Button
              variant="danger"
              onClick={handleRestore}
              disabled={restoreConfirmText !== 'RESTAURER' || restoring}
            >
              {restoring ? <Loader2 size={14} className="animate-spin" /> : <RotateCcw size={14} />}
              Restaurer maintenant
            </Button>
          </div>
        </div>
      </Modal>
    </div>
  );
}

// ── Journal système ────────────────────────────────────────────────────
interface SystemLogEntry {
  id: number;
  level: 'info' | 'warn' | 'error';
  message: string;
  createdAt: string;
}

function SystemLogTab() {
  const [logs, setLogs] = useState<SystemLogEntry[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    api
      .get<{ logs: SystemLogEntry[] }>('/system/logs?limit=150')
      .then((res) => setLogs(res.logs))
      .finally(() => setLoading(false));
  }, []);

  const tone = (level: string) => (level === 'error' ? 'bad' : level === 'warn' ? 'default' : 'good');

  return (
    <Card className="overflow-hidden">
      <table className="w-full text-sm">
        <thead>
          <tr className="bg-ink-50 text-left text-xs text-ink-500 uppercase tracking-wide">
            <th className="px-4 py-3">Date</th>
            <th className="px-4 py-3">Niveau</th>
            <th className="px-4 py-3">Message</th>
          </tr>
        </thead>
        <tbody>
          {logs.map((l) => (
            <tr key={l.id} className="border-t border-ink-50">
              <td className="px-4 py-3 text-ink-500 text-xs whitespace-nowrap">
                {new Date(l.createdAt).toLocaleString('fr-FR')}
              </td>
              <td className="px-4 py-3">
                <Badge tone={tone(l.level) as 'good' | 'bad' | 'default'}>{l.level}</Badge>
              </td>
              <td className="px-4 py-3 text-ink-700">{l.message}</td>
            </tr>
          ))}
          {!loading && logs.length === 0 && (
            <tr>
              <td colSpan={3} className="px-4 py-8 text-center text-ink-400">
                Aucun événement système enregistré.
              </td>
            </tr>
          )}
        </tbody>
      </table>
    </Card>
  );
}

// ── Permissions ────────────────────────────────────────────────────────
interface PermissionRow {
  key: string;
  label: string;
  roles: string[];
}

function PermissionsTab() {
  const [roles, setRoles] = useState<string[]>([]);
  const [permissions, setPermissions] = useState<PermissionRow[]>([]);

  useEffect(() => {
    api
      .get<{ roles: string[]; permissions: PermissionRow[] }>('/permissions/matrix')
      .then((res) => {
        setRoles(res.roles);
        setPermissions(res.permissions);
      })
      .catch(() => {});
  }, []);

  return (
    <Card className="overflow-hidden">
      <table className="w-full text-sm">
        <thead>
          <tr className="bg-ink-50 text-left text-xs text-ink-500 uppercase tracking-wide">
            <th className="px-4 py-3">Permission</th>
            {roles.map((r) => (
              <th key={r} className="px-4 py-3 text-center">
                {r}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {permissions.map((p) => (
            <tr key={p.key} className="border-t border-ink-50">
              <td className="px-4 py-3 text-ink-700">{p.label}</td>
              {roles.map((r) => (
                <td key={r} className="px-4 py-3 text-center">
                  {p.roles.includes(r) ? (
                    <span className="text-signal-emeraldDark">●</span>
                  ) : (
                    <span className="text-ink-200">—</span>
                  )}
                </td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
      <p className="text-xs text-ink-400 px-4 py-3">
        Le modèle de rôles est fixe (SUPER_ADMIN &gt; ADMIN &gt; USER) ; cette page est en lecture seule.
      </p>
    </Card>
  );
}

// ── Corbeille ──────────────────────────────────────────────────────────
interface TrashItem {
  entity: string;
  id: number;
  label: string;
  deletedAt: string;
  deletedBy: string | null;
}

const ENTITY_LABELS: Record<string, string> = {
  lignes: 'Ligne mobile',
  'custom-fields': 'Champ personnalisé',
  'correction-rules': 'Règle de correction',
  users: 'Utilisateur'
};

function TrashTab() {
  const [items, setItems] = useState<TrashItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const load = () => {
    setLoading(true);
    api
      .get<{ items: TrashItem[] }>('/trash')
      .then((res) => setItems(res.items))
      .catch((err) => setError(err instanceof ApiError ? err.message : 'Erreur de chargement.'))
      .finally(() => setLoading(false));
  };

  useEffect(load, []);

  const handleRestore = async (item: TrashItem) => {
    try {
      await api.post(`/trash/${item.entity}/${item.id}/restore`);
      load();
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'Erreur lors de la restauration.');
    }
  };

  const handlePurge = async (item: TrashItem) => {
    if (!confirm(`Supprimer définitivement "${item.label}" ? Cette action est irréversible.`)) return;
    try {
      await api.delete(`/trash/${item.entity}/${item.id}`);
      load();
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'Erreur lors de la suppression définitive.');
    }
  };

  return (
    <div>
      {error && <p className="text-sm text-signal-roseDark bg-signal-rose/10 rounded-lg px-3 py-2 mb-4">{error}</p>}
      <Card className="overflow-hidden">
        <table className="w-full text-sm">
          <thead>
            <tr className="bg-ink-50 text-left text-xs text-ink-500 uppercase tracking-wide">
              <th className="px-4 py-3">Type</th>
              <th className="px-4 py-3">Élément</th>
              <th className="px-4 py-3">Supprimé le</th>
              <th className="px-4 py-3">Par</th>
              <th className="px-4 py-3">Actions</th>
            </tr>
          </thead>
          <tbody>
            {items.map((item) => (
              <tr key={`${item.entity}-${item.id}`} className="border-t border-ink-50">
                <td className="px-4 py-3">
                  <Badge>{ENTITY_LABELS[item.entity] ?? item.entity}</Badge>
                </td>
                <td className="px-4 py-3 text-ink-800 font-medium">{item.label}</td>
                <td className="px-4 py-3 text-ink-500 text-xs">{new Date(item.deletedAt).toLocaleString('fr-FR')}</td>
                <td className="px-4 py-3 text-ink-600 text-xs">{item.deletedBy ?? '—'}</td>
                <td className="px-4 py-3">
                  <div className="flex items-center gap-1.5">
                    <button
                      title="Restaurer"
                      onClick={() => handleRestore(item)}
                      className="focus-ring p-2 rounded-md text-ink-500 hover:bg-ink-100 hover:text-ink-800"
                    >
                      <RotateCcw size={15} />
                    </button>
                    <button
                      title="Supprimer définitivement"
                      onClick={() => handlePurge(item)}
                      className="focus-ring p-2 rounded-md text-ink-500 hover:bg-signal-rose/10 hover:text-signal-rose"
                    >
                      <XCircle size={15} />
                    </button>
                  </div>
                </td>
              </tr>
            ))}
            {!loading && items.length === 0 && (
              <tr>
                <td colSpan={5} className="px-4 py-8 text-center text-ink-400">
                  La corbeille est vide.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </Card>
    </div>
  );
}

// ── Sécurité (sessions actives) ───────────────────────────────────────────
interface ActiveSession {
  id: number;
  userId: number;
  username: string;
  displayName: string | null;
  ipAddress: string | null;
  userAgent: string | null;
  createdAt: string;
  lastSeenAt: string;
}

function browserFromUA(ua: string | null): string {
  if (!ua) return 'Inconnu';
  if (ua.includes('Edg/')) return 'Edge';
  if (ua.includes('Chrome/')) return 'Chrome';
  if (ua.includes('Firefox/')) return 'Firefox';
  if (ua.includes('Safari/')) return 'Safari';
  return 'Autre';
}

function SecurityTab() {
  const [sessions, setSessions] = useState<ActiveSession[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const load = () => {
    setLoading(true);
    api
      .get<{ sessions: ActiveSession[] }>('/security/sessions')
      .then((res) => setSessions(res.sessions))
      .catch((err) => setError(err instanceof ApiError ? err.message : 'Erreur de chargement.'))
      .finally(() => setLoading(false));
  };

  useEffect(load, []);

  const handleRevoke = async (s: ActiveSession) => {
    if (!confirm(`Déconnecter la session de ${s.displayName || s.username} (${browserFromUA(s.userAgent)}) ?`)) return;
    try {
      await api.post(`/security/sessions/${s.id}/revoke`);
      load();
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'Erreur lors de la révocation.');
    }
  };

  return (
    <div>
      <p className="text-sm text-ink-500 mb-4">
        Sessions actuellement ouvertes sur la plateforme. Révoquer une session déconnecte immédiatement l'appareil
        concerné — l'utilisateur devra se reconnecter (et re-saisir son code 2FA si activée).
      </p>
      {error && <p className="text-sm text-signal-roseDark bg-signal-rose/10 rounded-lg px-3 py-2 mb-4">{error}</p>}
      <Card className="overflow-hidden">
        <table className="w-full text-sm">
          <thead>
            <tr className="bg-ink-50 text-left text-xs text-ink-500 uppercase tracking-wide">
              <th className="px-4 py-3">Utilisateur</th>
              <th className="px-4 py-3">Navigateur</th>
              <th className="px-4 py-3">Adresse IP</th>
              <th className="px-4 py-3">Ouverte le</th>
              <th className="px-4 py-3">Dernière activité</th>
              <th className="px-4 py-3">Actions</th>
            </tr>
          </thead>
          <tbody>
            {sessions.map((s) => (
              <tr key={s.id} className="border-t border-ink-50">
                <td className="px-4 py-2.5 font-medium text-ink-800">{s.displayName || s.username}</td>
                <td className="px-4 py-2.5"><Badge>{browserFromUA(s.userAgent)}</Badge></td>
                <td className="px-4 py-2.5 font-mono text-xs text-ink-600">{s.ipAddress || '—'}</td>
                <td className="px-4 py-2.5 text-ink-500 text-xs">{new Date(s.createdAt).toLocaleString('fr-FR')}</td>
                <td className="px-4 py-2.5 text-ink-500 text-xs">{new Date(s.lastSeenAt).toLocaleString('fr-FR')}</td>
                <td className="px-4 py-2.5">
                  <button
                    title="Révoquer cette session"
                    onClick={() => handleRevoke(s)}
                    className="focus-ring p-1.5 rounded-md text-ink-500 hover:bg-signal-rose/10 hover:text-signal-rose"
                  >
                    <Monitor size={14} />
                  </button>
                </td>
              </tr>
            ))}
            {!loading && sessions.length === 0 && (
              <tr>
                <td colSpan={6} className="px-4 py-8 text-center text-ink-400">
                  Aucune session active.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </Card>
    </div>
  );
}

export default function AdministrationPage() {
  const { t } = useTranslation();
  const [tab, setTab] = useState<Tab>('settings');

  return (
    <div>
      <PageHeader
        eyebrow="Administration"
        title={t('administration.title')}
        description={t('administration.description')}
      />
      <Tabs tab={tab} setTab={setTab} />
      {tab === 'settings' && (<><SettingsTab /><SmtpTestCard /><WhatsAppTestCard /></>)}
      {tab === 'backups' && <BackupsTab />}
      {tab === 'system-log' && <SystemLogTab />}
      {tab === 'security' && <SecurityTab />}
      {tab === 'permissions' && <PermissionsTab />}
      {tab === 'trash' && <TrashTab />}
    </div>
  );
}
