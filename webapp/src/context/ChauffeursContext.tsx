/**
 * ChauffeursContext — source de vérité pour le module Chauffeurs.
 *
 * Les chauffeurs sont créés/gérés manuellement ici (module indépendant des
 * comptes utilisateurs) et sont ensuite utilisés dans toutes les listes
 * déroulantes « Chauffeur » du module Déplacements.
 */
import React, { createContext, useCallback, useContext, useEffect, useMemo, useState } from 'react';
import { api } from '../lib/api';
import { useAuth } from './AuthContext';
import type { Chauffeur, ChauffeurCreateInput, ChauffeurStatut } from '../types/parcAuto';

interface ChauffeursState {
  chauffeurs: Chauffeur[];
  loading: boolean;
  error: string | null;
  reload: () => void;
  createChauffeur: (input: ChauffeurCreateInput) => Promise<Chauffeur>;
  updateChauffeur: (id: number, patch: Partial<ChauffeurCreateInput>) => Promise<Chauffeur>;
  setChauffeurStatut: (id: number, statut: ChauffeurStatut) => Promise<Chauffeur>;
  deleteChauffeur: (id: number) => Promise<void>;
}

const ChauffeursContext = createContext<ChauffeursState | null>(null);

export function ChauffeursProvider({ children }: { children: React.ReactNode }) {
  const { user } = useAuth();
  const [chauffeurs, setChauffeurs] = useState<Chauffeur[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [tick, setTick] = useState(0);

  const reload = useCallback(() => setTick((t) => t + 1), []);

  useEffect(() => {
    if (!user) {
      setChauffeurs([]);
      return;
    }
    setLoading(true);
    setError(null);
    api.get<{ chauffeurs: Chauffeur[] }>('/chauffeurs')
      .then((res) => setChauffeurs(res.chauffeurs))
      .catch(() => setError('Impossible de charger les chauffeurs.'))
      .finally(() => setLoading(false));
  }, [user, tick]);

  const createChauffeur = useCallback(async (input: ChauffeurCreateInput): Promise<Chauffeur> => {
    const res = await api.post<{ chauffeur: Chauffeur }>('/chauffeurs', input);
    reload();
    return res.chauffeur;
  }, [reload]);

  const updateChauffeur = useCallback(async (id: number, patch: Partial<ChauffeurCreateInput>): Promise<Chauffeur> => {
    const res = await api.patch<{ chauffeur: Chauffeur }>(`/chauffeurs/${id}`, patch);
    reload();
    return res.chauffeur;
  }, [reload]);

  const setChauffeurStatut = useCallback(async (id: number, statut: ChauffeurStatut): Promise<Chauffeur> => {
    const res = await api.patch<{ chauffeur: Chauffeur }>(`/chauffeurs/${id}/statut`, { statut });
    reload();
    return res.chauffeur;
  }, [reload]);

  const deleteChauffeur = useCallback(async (id: number): Promise<void> => {
    await api.delete(`/chauffeurs/${id}`);
    reload();
  }, [reload]);

  const value = useMemo<ChauffeursState>(() => ({
    chauffeurs, loading, error, reload,
    createChauffeur, updateChauffeur, setChauffeurStatut, deleteChauffeur
  }), [chauffeurs, loading, error, reload, createChauffeur, updateChauffeur, setChauffeurStatut, deleteChauffeur]);

  return <ChauffeursContext.Provider value={value}>{children}</ChauffeursContext.Provider>;
}

export function useChauffeurs(): ChauffeursState {
  const ctx = useContext(ChauffeursContext);
  if (!ctx) throw new Error('useChauffeurs doit être utilisé à l\'intérieur de <ChauffeursProvider>');
  return ctx;
}
