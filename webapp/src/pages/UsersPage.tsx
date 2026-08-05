import { useEffect, useMemo, useState } from 'react';
import { Plus, Trash2, KeyRound, Search, Power, PowerOff } from 'lucide-react';
import { api, ApiError } from '../lib/api';
import type { CurrentUser, UserRole } from '../context/AuthContext';
import { useAuth } from '../context/AuthContext';
import { PageHeader, Card, Button, Badge, Modal } from '../components/ui/Kit';
import { ROLE_LABELS, ROLE_TONE } from '../lib/navItems';
import { useTranslation } from 'react-i18next';

const ALL_ROLES: UserRole[] = ['SUPER_ADMIN', 'ADMIN', 'CHEF_DIVISION', 'GESTIONNAIRE', 'USER', 'CHAUFFEUR'];

export default function UsersPage() {
  const { t } = useTranslation();
  const { user: me, isSuperAdmin } = useAuth();
  const [users, setUsers] = useState<CurrentUser[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Rôles que le compte connecté est autorisé à attribuer/gérer.
  const [assignableRoles, setAssignableRoles] = useState<UserRole[]>(['USER']);

  const [search, setSearch] = useState('');
  const [roleFilter, setRoleFilter] = useState<'' | UserRole>('');
  const [statusFilter, setStatusFilter] = useState<'' | 'active' | 'inactive'>('');

  const [createOpen, setCreateOpen] = useState(false);
  const [form, setForm] = useState({ username: '', password: '', displayName: '', role: 'USER' as UserRole });

  const [resetTarget, setResetTarget] = useState<CurrentUser | null>(null);
  const [resetPassword, setResetPassword] = useState('');

  const load = async (silent = false) => {
    if (!silent) setLoading(true);
    try {
      const params = new URLSearchParams();
      if (search) params.set('search', search);
      if (roleFilter) params.set('role', roleFilter);
      if (statusFilter) params.set('status', statusFilter);
      const qs = params.toString();
      const res = await api.get<{ users: CurrentUser[] }>(`/users${qs ? `?${qs}` : ''}`);
      setUsers(res.users);
    } catch (err) {
      if (!silent) setError(err instanceof ApiError ? err.message : 'Erreur de chargement.');
    } finally {
      if (!silent) setLoading(false);
    }
  };

  useEffect(() => {
    api
      .get<{ roles: UserRole[] }>('/users/assignable-roles')
      .then((res) => setAssignableRoles(res.roles))
      .catch(() => setAssignableRoles([]));
  }, []);

  useEffect(() => {
    const t = setTimeout(load, 250); // debounce recherche
    return () => clearTimeout(t);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [search, roleFilter, statusFilter]);

  // Rafraîchit silencieusement la présence ("en ligne") toutes les 20s,
  // sans redéclencher le spinner de chargement ni perturber la saisie.
  useEffect(() => {
    const interval = setInterval(() => load(true), 20_000);
    return () => clearInterval(interval);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [search, roleFilter, statusFilter]);

  // Un compte est considéré "en ligne" si une requête authentifiée a été
  // vue il y a moins de 90s (le serveur met à jour lastSeenAt toutes les
  // ~20s au fil de la navigation ; 90s laisse une marge confortable).
  const isOnline = (u: CurrentUser) => {
    if (!u.lastSeenAt) return false;
    return Date.now() - new Date(u.lastSeenAt).getTime() < 90_000;
  };

  const canManage = (target: CurrentUser) => {
    if (isSuperAdmin) return true;
    return target.role === 'USER';
  };

  const handleCreate = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    try {
      await api.post('/users', form);
      setCreateOpen(false);
      setForm({ username: '', password: '', displayName: '', role: assignableRoles[assignableRoles.length - 1] ?? 'USER' });
      load();
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'Erreur lors de la création.');
    }
  };

  const handleRoleChange = async (id: number, role: UserRole) => {
    try {
      await api.patch(`/users/${id}`, { role });
      load();
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'Erreur lors du changement de rôle.');
    }
  };

  const handleToggleActive = async (u: CurrentUser) => {
    try {
      await api.patch(`/users/${u.id}`, { isActive: !u.isActive });
      load();
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'Erreur lors du changement de statut.');
    }
  };

  const handleDelete = async (id: number) => {
    if (!confirm('Supprimer ce compte ?')) return;
    try {
      await api.delete(`/users/${id}`);
      load();
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'Erreur lors de la suppression.');
    }
  };

  const handleResetPassword = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!resetTarget) return;
    try {
      await api.post(`/users/${resetTarget.id}/reset-password`, { password: resetPassword });
      setResetTarget(null);
      setResetPassword('');
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'Erreur lors de la réinitialisation.');
    }
  };

  const formRoleOptions = useMemo(
    () => (assignableRoles.length > 0 ? assignableRoles : ['USER' as UserRole]),
    [assignableRoles]
  );

  return (
    <div>
      <PageHeader
        eyebrow={t('users.eyebrow')}
        title={t('users.title')}
        description={t('users.description')}
        action={
          <div className="flex items-center gap-3">
            <span
              className="flex items-center gap-1.5 text-xs font-medium px-3 py-1.5 rounded-full"
              style={{ background: 'rgba(34,197,94,0.10)', border: '1px solid rgba(34,197,94,0.22)', color: 'var(--accent2)' }}
            >
              <span className="w-1.5 h-1.5 rounded-full animate-pulse" style={{ background: 'var(--accent2)' }} />
              {users.filter(isOnline).length} en ligne
            </span>
            <Button onClick={() => setCreateOpen(true)}>
              <Plus size={15} />
              Ajouter un utilisateur
            </Button>
          </div>
        }
      />

      {error && <p className="text-sm text-signal-roseDark bg-signal-rose/10 rounded-lg px-3 py-2 mb-4">{error}</p>}

      {/* Recherche et filtres */}
      <div className="flex flex-wrap items-center gap-2 mb-4">
        <div className="relative flex-1 min-w-[220px]">
          <Search size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-ink-400" />
          <input
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Rechercher un utilisateur..."
            className="focus-ring w-full rounded-lg border border-ink-200 pl-8 pr-3 py-2 text-sm"
          />
        </div>
        <select
          value={roleFilter}
          onChange={(e) => setRoleFilter(e.target.value as '' | UserRole)}
          className="focus-ring rounded-lg border border-ink-200 px-2 py-2 text-xs text-ink-800"
        >
          <option value="">Tous les rôles</option>
          {ALL_ROLES.map((r) => (
            <option key={r} value={r}>
              {ROLE_LABELS[r]}
            </option>
          ))}
        </select>
        <select
          value={statusFilter}
          onChange={(e) => setStatusFilter(e.target.value as '' | 'active' | 'inactive')}
          className="focus-ring rounded-lg border border-ink-200 px-2 py-2 text-xs text-ink-800"
        >
          <option value="">Tous les statuts</option>
          <option value="active">Actifs</option>
          <option value="inactive">Désactivés</option>
        </select>
      </div>

      <Card className="overflow-hidden">
        <table className="w-full text-sm">
          <thead>
            <tr className="bg-ink-50 text-left text-xs text-ink-500 uppercase tracking-wide">
              <th className="px-4 py-3">Utilisateur</th>
              <th className="px-4 py-3">Nom affiché</th>
              <th className="px-4 py-3">Rôle</th>
              <th className="px-4 py-3">Statut</th>
              <th className="px-4 py-3">Dernière connexion</th>
              <th className="px-4 py-3">Actions</th>
            </tr>
          </thead>
          <tbody>
            {users.map((u) => {
              const manageable = canManage(u) && u.id !== me?.id;
              return (
                <tr key={u.id} className="border-t border-ink-50">
                  <td className="px-4 py-3 font-medium text-ink-800">
                    <span className="flex items-center gap-2">
                      <span
                        title={isOnline(u) ? 'En ligne actuellement' : 'Hors ligne'}
                        className="w-2 h-2 rounded-full shrink-0"
                        style={{
                          background: isOnline(u) ? 'var(--accent2)' : 'var(--text-ter)',
                          boxShadow: isOnline(u) ? '0 0 6px rgba(34,197,94,0.7)' : 'none'
                        }}
                      />
                      {u.username}
                    </span>
                  </td>
                  <td className="px-4 py-3 text-ink-600">{u.displayName || '—'}</td>
                  <td className="px-4 py-3">
                    {manageable ? (
                      <select
                        value={u.role}
                        onChange={(e) => handleRoleChange(u.id, e.target.value as UserRole)}
                        className="focus-ring rounded-lg border border-ink-200 px-2 py-1 text-xs text-ink-800"
                      >
                        {formRoleOptions.map((r) => (
                          <option key={r} value={r}>
                            {ROLE_LABELS[r]}
                          </option>
                        ))}
                      </select>
                    ) : (
                      <Badge tone={ROLE_TONE[u.role]}>{ROLE_LABELS[u.role]}</Badge>
                    )}
                  </td>
                  <td className="px-4 py-3">
                    <Badge tone={u.isActive ? 'good' : 'bad'}>{u.isActive ? 'Actif' : 'Désactivé'}</Badge>
                  </td>
                  <td className="px-4 py-3 text-ink-500 text-xs">
                    {u.lastLoginAt ? new Date(u.lastLoginAt).toLocaleString('fr-FR') : 'Jamais'}
                  </td>
                  <td className="px-4 py-3">
                    <div className="flex items-center gap-1.5">
                      <button
                        title="Réinitialiser le mot de passe"
                        disabled={!manageable}
                        onClick={() => setResetTarget(u)}
                        className="focus-ring p-2 rounded-md text-ink-500 hover:bg-ink-100 hover:text-ink-800 disabled:opacity-30"
                      >
                        <KeyRound size={15} />
                      </button>
                      <button
                        title={u.isActive ? 'Désactiver le compte' : 'Activer le compte'}
                        disabled={!manageable}
                        onClick={() => handleToggleActive(u)}
                        className="focus-ring p-2 rounded-md text-ink-500 hover:bg-ink-100 hover:text-ink-800 disabled:opacity-30"
                      >
                        {u.isActive ? <PowerOff size={15} /> : <Power size={15} />}
                      </button>
                      <button
                        title="Supprimer"
                        disabled={!manageable}
                        onClick={() => handleDelete(u.id)}
                        className="focus-ring p-2 rounded-md text-ink-500 hover:bg-signal-rose/10 hover:text-signal-rose disabled:opacity-30"
                      >
                        <Trash2 size={15} />
                      </button>
                    </div>
                  </td>
                </tr>
              );
            })}
            {!loading && users.length === 0 && (
              <tr>
                <td colSpan={6} className="px-4 py-8 text-center text-ink-400">
                  Aucun utilisateur.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </Card>

      <Modal open={createOpen} onClose={() => setCreateOpen(false)} title="Ajouter un utilisateur">
        <form onSubmit={handleCreate} className="space-y-4">
          <label className="block text-xs text-ink-500">
            <span>Nom d'utilisateur *</span>
            <input
              required
              minLength={3}
              value={form.username}
              onChange={(e) => setForm((f) => ({ ...f, username: e.target.value }))}
              className="focus-ring mt-1 w-full rounded-lg border border-ink-200 px-3 py-2 text-sm"
            />
          </label>
          <label className="block text-xs text-ink-500">
            <span>Mot de passe * (min. 6 caractères)</span>
            <input
              required
              minLength={6}
              type="password"
              value={form.password}
              onChange={(e) => setForm((f) => ({ ...f, password: e.target.value }))}
              className="focus-ring mt-1 w-full rounded-lg border border-ink-200 px-3 py-2 text-sm"
            />
          </label>
          <label className="block text-xs text-ink-500">
            <span>Nom affiché</span>
            <input
              value={form.displayName}
              onChange={(e) => setForm((f) => ({ ...f, displayName: e.target.value }))}
              className="focus-ring mt-1 w-full rounded-lg border border-ink-200 px-3 py-2 text-sm"
            />
          </label>
          <label className="block text-xs text-ink-500">
            <span>Rôle</span>
            <select
              value={form.role}
              onChange={(e) => setForm((f) => ({ ...f, role: e.target.value as UserRole }))}
              className="focus-ring mt-1 w-full rounded-lg border border-ink-200 px-3 py-2 text-sm"
            >
              {formRoleOptions.map((r) => (
                <option key={r} value={r}>
                  {ROLE_LABELS[r]}
                </option>
              ))}
            </select>
          </label>
          <div className="flex justify-end gap-2 pt-2">
            <Button type="button" variant="secondary" onClick={() => setCreateOpen(false)}>
              Annuler
            </Button>
            <Button type="submit">Créer</Button>
          </div>
        </form>
      </Modal>

      <Modal open={Boolean(resetTarget)} onClose={() => setResetTarget(null)} title="Réinitialiser le mot de passe" width="sm">
        <form onSubmit={handleResetPassword} className="space-y-4">
          <p className="text-sm text-ink-500">
            Nouveau mot de passe pour <b>{resetTarget?.username}</b>
          </p>
          <input
            required
            minLength={6}
            type="password"
            value={resetPassword}
            onChange={(e) => setResetPassword(e.target.value)}
            placeholder="Min. 6 caractères"
            className="focus-ring w-full rounded-lg border border-ink-200 px-3 py-2 text-sm"
          />
          <div className="flex justify-end gap-2">
            <Button type="button" variant="secondary" onClick={() => setResetTarget(null)}>
              Annuler
            </Button>
            <Button type="submit">Enregistrer</Button>
          </div>
        </form>
      </Modal>
    </div>
  );
}
