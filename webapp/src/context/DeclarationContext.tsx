/**
 * DeclarationContext — déclarations chauffeur ("Signaler un problème") côté
 * responsable du parc : consultation, filtres, traitement du workflow.
 * La création se fait depuis le portail chauffeur (voir MaMissionPage.tsx).
 */
import React, { createContext, useCallback, useContext, useEffect, useMemo, useState } from 'react';
import { api } from '../lib/api';
import { useAuth } from './AuthContext';
import type { Declaration, DeclarationsResume, DeclarationStatut } from '../types/parcAuto';

interface DeclarationState {
  declarations: Declaration[];
  resume: DeclarationsResume | null;
  loading: boolean;
  error: string | null;
  reload: () => void;
  fetchDeclarationDetail: (id: number) => Promise<Declaration>;
  updateStatut: (id: number, statut: DeclarationStatut, commentaire?: string) => Promise<Declaration>;
}

const DeclarationContext = createContext<DeclarationState | null>(null);

export function DeclarationProvider({ children }: { children: React.ReactNode }) {
  const { user } = useAuth();
  const [declarations, setDeclarations] = useState<Declaration[]>([]);
  const [resume, setResume] = useState<DeclarationsResume | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [tick, setTick] = useState(0);

  const reload = useCallback(() => setTick((t) => t + 1), []);

  useEffect(() => {
    if (!user || user.role === 'CHAUFFEUR') {
      setDeclarations([]);
      setResume(null);
      return;
    }
    setLoading(true);
    setError(null);
    Promise.all([
      api.get<{ declarations: Declaration[] }>('/declarations'),
      api.get<DeclarationsResume>('/declarations/resume')
    ])
      .then(([d, r]) => { setDeclarations(d.declarations); setResume(r); })
      .catch(() => setError('Impossible de charger les déclarations.'))
      .finally(() => setLoading(false));
  }, [user, tick]);

  const fetchDeclarationDetail = useCallback(async (id: number): Promise<Declaration> => {
    const res = await api.get<{ declaration: Declaration }>(`/declarations/${id}`);
    return res.declaration;
  }, []);

  const updateStatut = useCallback(async (id: number, statut: DeclarationStatut, commentaire?: string): Promise<Declaration> => {
    const res = await api.patch<{ declaration: Declaration }>(`/declarations/${id}/statut`, { statut, commentaire });
    reload();
    return res.declaration;
  }, [reload]);

  const value = useMemo<DeclarationState>(() => ({
    declarations, resume, loading, error, reload, fetchDeclarationDetail, updateStatut
  }), [declarations, resume, loading, error, reload, fetchDeclarationDetail, updateStatut]);

  return <DeclarationContext.Provider value={value}>{children}</DeclarationContext.Provider>;
}

export function useDeclarations(): DeclarationState {
  const ctx = useContext(DeclarationContext);
  if (!ctx) throw new Error('useDeclarations doit être utilisé à l\'intérieur de <DeclarationProvider>');
  return ctx;
}
