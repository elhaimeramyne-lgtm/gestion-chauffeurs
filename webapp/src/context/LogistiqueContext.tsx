/**
 * LogistiqueContext — source de vérité pour le module Logistique & Moyens
 * Généraux (demandes de services). Fournit la liste des demandes, les
 * statistiques du tableau de bord, les agents affectables, et les
 * fonctions de création / transition de workflow.
 */
import React, { createContext, useCallback, useContext, useEffect, useMemo, useState } from 'react';
import { api } from '../lib/api';
import { useAuth } from './AuthContext';
import type {
  ServiceRequest, ServiceRequestEvent, ServiceRequestCreateInput,
  ServiceRequestStatus, LogistiqueStats, LogistiqueAgent
} from '../types/logistique';

interface LogistiqueFilters {
  statut?: string;
  priorite?: string;
  type?: string;
  serviceId?: number;
  search?: string;
}

interface LogistiqueState {
  demandes: ServiceRequest[];
  stats: LogistiqueStats | null;
  agents: LogistiqueAgent[];
  loading: boolean;
  error: string | null;
  filters: LogistiqueFilters;
  setFilters: (f: LogistiqueFilters) => void;
  reload: () => void;
  createDemande: (input: ServiceRequestCreateInput) => Promise<ServiceRequest>;
  updateDemande: (id: number, patch: Partial<Pick<ServiceRequest, 'objet' | 'description' | 'priorite' | 'dateSouhaitee'>>) => Promise<ServiceRequest>;
  transitionStatut: (id: number, statut: ServiceRequestStatus, opts?: { commentaire?: string; agentAffecteId?: number }) => Promise<ServiceRequest>;
  fetchDetail: (id: number) => Promise<{ demande: ServiceRequest; events: ServiceRequestEvent[] }>;
  deleteDemande: (id: number) => Promise<void>;
}

const LogistiqueContext = createContext<LogistiqueState | null>(null);

export function LogistiqueProvider({ children }: { children: React.ReactNode }) {
  const { user } = useAuth();
  const [demandes, setDemandes] = useState<ServiceRequest[]>([]);
  const [stats, setStats] = useState<LogistiqueStats | null>(null);
  const [agents, setAgents] = useState<LogistiqueAgent[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [filters, setFilters] = useState<LogistiqueFilters>({});
  const [tick, setTick] = useState(0);

  const reload = useCallback(() => setTick((t) => t + 1), []);

  useEffect(() => {
    // Un compte CHAUFFEUR n'a pas la permission 'business.read' (voir
    // lib/permissions.ts côté serveur) et n'utilise que le portail dédié :
    // inutile de déclencher ces appels, qui échoueraient systématiquement
    // en 403 en arrière-plan.
    if (!user || user.role === 'CHAUFFEUR') {
      setDemandes([]);
      setStats(null);
      setAgents([]);
      return;
    }
    // Seul le premier chargement affiche "loading" ; les rafraîchissements
    // automatiques suivants restent silencieux (pas de clignotement d'écran).
    if (tick === 0) setLoading(true);
    setError(null);

    const params = new URLSearchParams();
    if (filters.statut) params.set('statut', filters.statut);
    if (filters.priorite) params.set('priorite', filters.priorite);
    if (filters.type) params.set('type', filters.type);
    if (filters.serviceId) params.set('serviceId', String(filters.serviceId));
    if (filters.search) params.set('search', filters.search);
    const qs = params.toString();

    Promise.all([
      api.get<{ demandes: ServiceRequest[] }>(`/logistique/demandes${qs ? `?${qs}` : ''}`),
      api.get<LogistiqueStats>('/logistique/demandes/stats'),
      api.get<{ agents: LogistiqueAgent[] }>('/logistique/agents')
    ])
      .then(([demandesRes, statsRes, agentsRes]) => {
        setDemandes(demandesRes.demandes);
        setStats(statsRes);
        setAgents(agentsRes.agents);
      })
      .catch(() => setError('Impossible de charger les demandes de services.'))
      .finally(() => setLoading(false));
  }, [user, tick, filters.statut, filters.priorite, filters.type, filters.serviceId, filters.search]);

  // Actualisation automatique toutes les 15s (nouvelle demande, changement de statut, etc.)
  useEffect(() => {
    if (!user || user.role === 'CHAUFFEUR') return;
    const interval = setInterval(() => setTick((t) => t + 1), 15_000);
    return () => clearInterval(interval);
  }, [user]);

  const createDemande = useCallback(async (input: ServiceRequestCreateInput): Promise<ServiceRequest> => {
    const res = await api.post<{ demande: ServiceRequest }>('/logistique/demandes', input);
    reload();
    return res.demande;
  }, [reload]);

  const updateDemande = useCallback(async (
    id: number,
    patch: Partial<Pick<ServiceRequest, 'objet' | 'description' | 'priorite' | 'dateSouhaitee'>>
  ): Promise<ServiceRequest> => {
    const res = await api.patch<{ demande: ServiceRequest }>(`/logistique/demandes/${id}`, patch);
    reload();
    return res.demande;
  }, [reload]);

  const transitionStatut = useCallback(async (
    id: number,
    statut: ServiceRequestStatus,
    opts?: { commentaire?: string; agentAffecteId?: number }
  ): Promise<ServiceRequest> => {
    const res = await api.patch<{ demande: ServiceRequest }>(`/logistique/demandes/${id}/statut`, {
      statut,
      commentaire: opts?.commentaire,
      agentAffecteId: opts?.agentAffecteId
    });
    reload();
    return res.demande;
  }, [reload]);

  const fetchDetail = useCallback(async (id: number) => {
    return api.get<{ demande: ServiceRequest; events: ServiceRequestEvent[] }>(`/logistique/demandes/${id}`);
  }, []);

  const deleteDemande = useCallback(async (id: number): Promise<void> => {
    await api.delete(`/logistique/demandes/${id}`);
    reload();
  }, [reload]);

  const value = useMemo<LogistiqueState>(() => ({
    demandes, stats, agents, loading, error, filters, setFilters,
    reload, createDemande, updateDemande, transitionStatut, fetchDetail, deleteDemande
  }), [demandes, stats, agents, loading, error, filters, reload, createDemande, updateDemande, transitionStatut, fetchDetail, deleteDemande]);

  return <LogistiqueContext.Provider value={value}>{children}</LogistiqueContext.Provider>;
}

export function useLogistique(): LogistiqueState {
  const ctx = useContext(LogistiqueContext);
  if (!ctx) throw new Error('useLogistique doit être utilisé à l\'intérieur de <LogistiqueProvider>');
  return ctx;
}
