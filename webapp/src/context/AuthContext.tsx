import React, { createContext, useCallback, useContext, useEffect, useState } from 'react';
import { api, ApiError } from '../lib/api';

export type UserRole = 'SUPER_ADMIN' | 'ADMIN' | 'CHEF_DIVISION' | 'GESTIONNAIRE' | 'USER' | 'CHAUFFEUR';

const ROLE_RANK: Record<UserRole, number> = { CHAUFFEUR: 0, USER: 1, GESTIONNAIRE: 2, CHEF_DIVISION: 3, ADMIN: 4, SUPER_ADMIN: 5 };

export interface CurrentUser {
  id: number;
  username: string;
  displayName: string | null;
  role: UserRole;
  isActive: boolean;
  twoFactorEnabled: boolean;
  lastLoginAt: string | null;
  lastSeenAt: string | null;
  createdAt: string;
  updatedAt: string;
}

interface AuthState {
  user: CurrentUser | null;
  loading: boolean;
  /** true une fois la première vérification de session terminée (permet
   *  d'afficher un écran de chargement plutôt que de flasher l'écran de
   *  connexion pendant la vérification initiale). */
  checked: boolean;
  /** Tout compte connecté peut lire/écrire les modules métier. */
  canEdit: boolean;
  /** ADMIN ou SUPER_ADMIN : gestion des utilisateurs, accès à l'historique. */
  isAdmin: boolean;
  isChauffeur: boolean;
  /** SUPER_ADMIN uniquement : paramètres système, gestion des comptes ADMIN. */
  isSuperAdmin: boolean;
  hasMinRole: (role: UserRole) => boolean;
  /** Retourne { requires2FA: true } si un code à 6 chiffres est attendu
   *  avant que la session ne soit réellement ouverte (voir verifyTwoFactor). */
  login: (username: string, password: string) => Promise<{ requires2FA: boolean }>;
  verifyTwoFactor: (code: string) => Promise<void>;
  logout: () => Promise<void>;
  refresh: () => Promise<void>;
}

const AuthContext = createContext<AuthState | null>(null);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<CurrentUser | null>(null);
  const [loading, setLoading] = useState(false);
  const [checked, setChecked] = useState(false);

  const refresh = useCallback(async () => {
    try {
      const res = await api.get<{ user: CurrentUser }>('/auth/me');
      setUser(res.user);
    } catch {
      setUser(null);
    }
  }, []);

  useEffect(() => {
    refresh().finally(() => setChecked(true));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const login = useCallback(async (username: string, password: string) => {
    setLoading(true);
    try {
      const res = await api.post<{ user?: CurrentUser; requires2FA?: boolean }>('/auth/login', { username, password });
      if (res.requires2FA) {
        return { requires2FA: true };
      }
      if (res.user) setUser(res.user);
      return { requires2FA: false };
    } catch (err) {
      if (err instanceof ApiError) throw new Error(err.message);
      throw err;
    } finally {
      setLoading(false);
    }
  }, []);

  const verifyTwoFactor = useCallback(async (code: string) => {
    setLoading(true);
    try {
      const res = await api.post<{ user: CurrentUser }>('/auth/login-2fa', { code });
      setUser(res.user);
    } catch (err) {
      if (err instanceof ApiError) throw new Error(err.message);
      throw err;
    } finally {
      setLoading(false);
    }
  }, []);

  const logout = useCallback(async () => {
    await api.post('/auth/logout');
    setUser(null);
  }, []);

  const hasMinRole = useCallback(
    (role: UserRole) => (user ? ROLE_RANK[user.role] >= ROLE_RANK[role] : false),
    [user]
  );

  const value: AuthState = {
    user,
    loading,
    checked,
    canEdit: !!user,
    isAdmin: user?.role === 'ADMIN' || user?.role === 'SUPER_ADMIN',
    isChauffeur: user?.role === 'CHAUFFEUR',
    isSuperAdmin: user?.role === 'SUPER_ADMIN',
    hasMinRole,
    login,
    verifyTwoFactor,
    logout,
    refresh
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth(): AuthState {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error('useAuth doit être utilisé à l’intérieur de AuthProvider');
  return ctx;
}
