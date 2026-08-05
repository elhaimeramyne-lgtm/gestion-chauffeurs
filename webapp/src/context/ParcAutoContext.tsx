/**
 * ParcAutoContext — source de vérité pour le Parc Automobile et les
 * Déplacements (ordres de mission). Les deux sont volontairement dans le
 * même contexte car un déplacement modifie directement le statut et le
 * kilométrage d'un véhicule (voir server/src/routes/parcAuto.ts).
 */
import React, { createContext, useCallback, useContext, useEffect, useMemo, useState } from 'react';
import { api } from '../lib/api';
import { useAuth } from './AuthContext';
import type {
  Vehicule, VehiculeEvent, VehiculeCreateInput, VehiculeStatut, ParcAutoStats,
  Deplacement, DeplacementCreateInput, DeplacementStatut, DeplacementPassager,
  DeplacementDetail, ActiveMission, VehiculeAffectation,
  Chauffeur, ChauffeurCreateInput, ChauffeurStatut, AlertesResume
} from '../types/parcAuto';

interface ParcAutoState {
  vehicules: Vehicule[];
  deplacements: Deplacement[];
  chauffeurs: Chauffeur[];
  stats: ParcAutoStats | null;
  alertesResume: AlertesResume | null;
  loading: boolean;
  error: string | null;
  reload: () => void;
  createVehicule: (input: VehiculeCreateInput) => Promise<Vehicule>;
  updateVehicule: (id: number, patch: Partial<VehiculeCreateInput>) => Promise<Vehicule>;
  setVehiculeStatut: (id: number, statut: VehiculeStatut, commentaire?: string) => Promise<Vehicule>;
  deleteVehicule: (id: number) => Promise<void>;
  fetchVehiculeDetail: (id: number) => Promise<{ vehicule: Vehicule; events: VehiculeEvent[]; deplacements: Deplacement[] }>;
  assignVehicule: (vehiculeId: number, chauffeurId: number) => Promise<Vehicule>;
  unassignVehicule: (vehiculeId: number) => Promise<Vehicule>;
  fetchAffectations: (vehiculeId: number) => Promise<VehiculeAffectation[]>;
  uploadVehiculePhoto: (vehiculeId: number, file: File) => Promise<Vehicule>;
  createDeplacement: (input: DeplacementCreateInput) => Promise<Deplacement>;
  updateDeplacement: (id: number, patch: Partial<DeplacementCreateInput>) => Promise<Deplacement>;
  transitionDeplacement: (id: number, statut: DeplacementStatut, extra?: {
    kilometrageDepart?: number; kilometrageRetour?: number; rapportMission?: string; dateRetourEffective?: string;
  }) => Promise<Deplacement>;
  deleteDeplacement: (id: number) => Promise<void>;
  bulkDeleteDeplacements: (ids: number[]) => Promise<void>;
  fetchDeplacementDetail: (id: number) => Promise<DeplacementDetail>;
  fetchActiveMissions: () => Promise<ActiveMission[]>;
  createChauffeur: (input: ChauffeurCreateInput) => Promise<Chauffeur>;
  updateChauffeur: (id: number, patch: Partial<ChauffeurCreateInput>) => Promise<Chauffeur>;
  fetchChauffeurDetail: (id: number) => Promise<Chauffeur>;
  setChauffeurStatut: (id: number, statut: ChauffeurStatut) => Promise<Chauffeur>;
  deleteChauffeur: (id: number) => Promise<void>;
  uploadChauffeurPhoto: (id: number, file: File) => Promise<Chauffeur>;
  uploadChauffeurDocument: (id: number, type: 'cin' | 'permis' | 'medical', file: File) => Promise<Chauffeur>;
}

const ParcAutoContext = createContext<ParcAutoState | null>(null);

export function ParcAutoProvider({ children }: { children: React.ReactNode }) {
  const { user } = useAuth();
  const [vehicules, setVehicules] = useState<Vehicule[]>([]);
  const [deplacements, setDeplacements] = useState<Deplacement[]>([]);
  const [chauffeurs, setChauffeurs] = useState<Chauffeur[]>([]);
  const [stats, setStats] = useState<ParcAutoStats | null>(null);
  const [alertesResume, setAlertesResume] = useState<AlertesResume | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [tick, setTick] = useState(0);

  const reload = useCallback(() => setTick((t) => t + 1), []);

  useEffect(() => {
    if (!user || user.role === 'CHAUFFEUR') {
      setVehicules([]);
      setDeplacements([]);
      setChauffeurs([]);
      setStats(null);
      setAlertesResume(null);
      return;
    }
    // Seul le premier chargement (tick === 0) affiche l'état "loading" ;
    // les rafraîchissements automatiques suivants restent silencieux pour éviter tout clignotement.
    if (tick === 0) setLoading(true);
    setError(null);
    Promise.all([
      api.get<{ vehicules: Vehicule[] }>('/parc-auto/vehicules'),
      api.get<{ deplacements: Deplacement[] }>('/parc-auto/deplacements'),
      api.get<ParcAutoStats>('/parc-auto/vehicules/stats'),
      api.get<{ chauffeurs: Chauffeur[] }>('/chauffeurs'),
      api.get<AlertesResume>('/parc-auto/alertes')
    ])
      .then(([v, d, s, c, a]) => { setVehicules(v.vehicules); setDeplacements(d.deplacements); setStats(s); setChauffeurs(c.chauffeurs); setAlertesResume(a); })
      .catch(() => setError('Impossible de charger les données du Parc Automobile.'))
      .finally(() => setLoading(false));
  }, [user, tick]);

  useEffect(() => {
    if (!user || user.role === 'CHAUFFEUR') return;
    const interval = setInterval(() => {
      setTick((t) => t + 1);
    }, 15_000);
    return () => clearInterval(interval);
  }, [user]);

  const createVehicule = useCallback(async (input: VehiculeCreateInput): Promise<Vehicule> => {
    const res = await api.post<{ vehicule: Vehicule }>('/parc-auto/vehicules', input);
    reload();
    return res.vehicule;
  }, [reload]);

  const updateVehicule = useCallback(async (id: number, patch: Partial<VehiculeCreateInput>): Promise<Vehicule> => {
    const res = await api.patch<{ vehicule: Vehicule }>(`/parc-auto/vehicules/${id}`, patch);
    reload();
    return res.vehicule;
  }, [reload]);

  const setVehiculeStatut = useCallback(async (id: number, statut: VehiculeStatut, commentaire?: string): Promise<Vehicule> => {
    const res = await api.patch<{ vehicule: Vehicule }>(`/parc-auto/vehicules/${id}/statut`, { statut, commentaire });
    reload();
    return res.vehicule;
  }, [reload]);

  const deleteVehicule = useCallback(async (id: number): Promise<void> => {
    await api.delete(`/parc-auto/vehicules/${id}`);
    reload();
  }, [reload]);

  const fetchVehiculeDetail = useCallback(async (id: number) => {
    return api.get<{ vehicule: Vehicule; events: VehiculeEvent[]; deplacements: Deplacement[] }>(`/parc-auto/vehicules/${id}`);
  }, []);

  const assignVehicule = useCallback(async (vehiculeId: number, chauffeurId: number): Promise<Vehicule> => {
    const res = await api.post<{ vehicule: Vehicule }>(`/parc-auto/vehicules/${vehiculeId}/affectation`, { chauffeurId });
    reload();
    return res.vehicule;
  }, [reload]);

  const unassignVehicule = useCallback(async (vehiculeId: number): Promise<Vehicule> => {
    const res = await api.delete<{ vehicule: Vehicule }>(`/parc-auto/vehicules/${vehiculeId}/affectation`);
    reload();
    return res.vehicule;
  }, [reload]);

  const fetchAffectations = useCallback(async (vehiculeId: number): Promise<VehiculeAffectation[]> => {
    const res = await api.get<{ affectations: VehiculeAffectation[] }>(`/parc-auto/vehicules/${vehiculeId}/affectations`);
    return res.affectations;
  }, []);

  const uploadVehiculePhoto = useCallback(async (vehiculeId: number, file: File): Promise<Vehicule> => {
    const formData = new FormData();
    formData.append('photo', file);
    const res = await fetch(`/api/parc-auto/vehicules/${vehiculeId}/photo`, { method: 'POST', credentials: 'include', body: formData });
    if (!res.ok) throw new Error('Upload échoué');
    const data = await res.json() as { vehicule: Vehicule };
    reload();
    return data.vehicule;
  }, [reload]);

  const createDeplacement = useCallback(async (input: DeplacementCreateInput): Promise<Deplacement> => {
    const res = await api.post<{ deplacement: Deplacement }>('/parc-auto/deplacements', input);
    reload();
    return res.deplacement;
  }, [reload]);

  const updateDeplacement = useCallback(async (id: number, patch: Partial<DeplacementCreateInput>): Promise<Deplacement> => {
    const res = await api.patch<{ deplacement: Deplacement }>(`/parc-auto/deplacements/${id}`, patch);
    reload();
    return res.deplacement;
  }, [reload]);

  const transitionDeplacement = useCallback(async (
    id: number,
    statut: DeplacementStatut,
    extra?: { kilometrageDepart?: number; kilometrageRetour?: number; rapportMission?: string; dateRetourEffective?: string }
  ): Promise<Deplacement> => {
    const res = await api.patch<{ deplacement: Deplacement }>(`/parc-auto/deplacements/${id}/statut`, { statut, ...extra });
    reload();
    return res.deplacement;
  }, [reload]);

const deleteDeplacement = useCallback(async (id: number): Promise<void> => {
    await api.delete(`/parc-auto/deplacements/${id}`);
    reload();
  }, [reload]);

  const bulkDeleteDeplacements = useCallback(async (ids: number[]): Promise<void> => {
    if (ids.length === 0) return;
    await Promise.all(ids.map((id) => api.delete(`/parc-auto/deplacements/${id}`)));
    reload();
  }, [reload]);

  const fetchDeplacementDetail = useCallback(async (id: number) => {
    return api.get<DeplacementDetail>(`/parc-auto/deplacements/${id}`);
  }, []);

  const fetchActiveMissions = useCallback(async (): Promise<ActiveMission[]> => {
    const res = await api.get<{ missions: ActiveMission[] }>('/mission-map/actives');
    return res.missions;
  }, []);

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

  const fetchChauffeurDetail = useCallback(async (id: number): Promise<Chauffeur> => {
    const res = await api.get<{ chauffeur: Chauffeur }>(`/chauffeurs/${id}`);
    return res.chauffeur;
  }, []);

  const setChauffeurStatut = useCallback(async (id: number, statut: ChauffeurStatut): Promise<Chauffeur> => {
    const res = await api.patch<{ chauffeur: Chauffeur }>(`/chauffeurs/${id}/statut`, { statut });
    reload();
    return res.chauffeur;
  }, [reload]);

  const deleteChauffeur = useCallback(async (id: number): Promise<void> => {
    await api.delete(`/chauffeurs/${id}`);
    reload();
  }, [reload]);

  const uploadChauffeurPhoto = useCallback(async (id: number, file: File): Promise<Chauffeur> => {
    const formData = new FormData();
    formData.append('photo', file);
    const res = await fetch(`/api/chauffeurs/${id}/photo`, { method: 'POST', credentials: 'include', body: formData });
    if (!res.ok) throw new Error('Upload échoué');
    const data = await res.json() as { chauffeur: Chauffeur };
    reload();
    return data.chauffeur;
  }, [reload]);

  const uploadChauffeurDocument = useCallback(async (id: number, type: 'cin' | 'permis' | 'medical', file: File): Promise<Chauffeur> => {
    const formData = new FormData();
    formData.append('document', file);
    formData.append('type', type);
    const res = await fetch(`/api/chauffeurs/${id}/documents`, { method: 'POST', credentials: 'include', body: formData });
    if (!res.ok) throw new Error('Upload échoué');
    const data = await res.json() as { chauffeur: Chauffeur };
    reload();
    return data.chauffeur;
  }, [reload]);

const value = useMemo<ParcAutoState>(() => ({
    vehicules, deplacements, chauffeurs, stats, alertesResume, loading, error, reload,
    createVehicule, updateVehicule, setVehiculeStatut, deleteVehicule, fetchVehiculeDetail,
    assignVehicule, unassignVehicule, fetchAffectations, uploadVehiculePhoto,
    createDeplacement, updateDeplacement, transitionDeplacement, deleteDeplacement, bulkDeleteDeplacements, fetchDeplacementDetail, fetchActiveMissions,
    createChauffeur, updateChauffeur, fetchChauffeurDetail, setChauffeurStatut, deleteChauffeur, uploadChauffeurPhoto, uploadChauffeurDocument
  }), [vehicules, deplacements, chauffeurs, stats, alertesResume, loading, error, reload, createVehicule, updateVehicule, setVehiculeStatut, deleteVehicule, fetchVehiculeDetail, assignVehicule, unassignVehicule, fetchAffectations, uploadVehiculePhoto, createDeplacement, updateDeplacement, transitionDeplacement, deleteDeplacement, bulkDeleteDeplacements, fetchDeplacementDetail, fetchActiveMissions, createChauffeur, updateChauffeur, fetchChauffeurDetail, setChauffeurStatut, deleteChauffeur, uploadChauffeurPhoto, uploadChauffeurDocument]);

  return <ParcAutoContext.Provider value={value}>{children}</ParcAutoContext.Provider>;
}

export function useParcAuto(): ParcAutoState {
  const ctx = useContext(ParcAutoContext);
  if (!ctx) throw new Error('useParcAuto doit être utilisé à l\'intérieur de <ParcAutoProvider>');
  return ctx;
}
