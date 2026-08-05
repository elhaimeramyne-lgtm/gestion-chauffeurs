/**
 * MaintenanceContext — historique complet d'entretien et de réparations par
 * véhicule (module Maintenance, distinct du simple suivi de vidange déjà
 * présent sur la fiche véhicule). Voir server/src/routes/maintenance.ts.
 */
import React, { createContext, useCallback, useContext, useEffect, useMemo, useState } from 'react';
import { api } from '../lib/api';
import { useAuth } from './AuthContext';
import type { MaintenanceRecord, MaintenanceCreateInput, MaintenanceDocument } from '../types/parcAuto';

interface MaintenanceState {
  maintenances: MaintenanceRecord[];
  loading: boolean;
  error: string | null;
  reload: () => void;
  createMaintenance: (input: MaintenanceCreateInput) => Promise<MaintenanceRecord>;
  updateMaintenance: (id: number, patch: Partial<MaintenanceCreateInput>) => Promise<MaintenanceRecord>;
  deleteMaintenance: (id: number) => Promise<void>;
  uploadDocument: (id: number, type: 'facture' | 'document', file: File) => Promise<MaintenanceDocument>;
  deleteDocument: (maintenanceId: number, docId: number) => Promise<void>;
}

const MaintenanceContext = createContext<MaintenanceState | null>(null);

export function MaintenanceProvider({ children }: { children: React.ReactNode }) {
  const { user } = useAuth();
  const [maintenances, setMaintenances] = useState<MaintenanceRecord[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [tick, setTick] = useState(0);

  const reload = useCallback(() => setTick((t) => t + 1), []);

  useEffect(() => {
    if (!user || user.role === 'CHAUFFEUR') {
      setMaintenances([]);
      return;
    }
    setLoading(true);
    setError(null);
    api
      .get<{ maintenances: MaintenanceRecord[] }>('/maintenance')
      .then((res) => setMaintenances(res.maintenances))
      .catch(() => setError('Impossible de charger les interventions de maintenance.'))
      .finally(() => setLoading(false));
  }, [user, tick]);

  const createMaintenance = useCallback(async (input: MaintenanceCreateInput): Promise<MaintenanceRecord> => {
    const res = await api.post<{ maintenance: MaintenanceRecord }>('/maintenance', input);
    reload();
    return res.maintenance;
  }, [reload]);

  const updateMaintenance = useCallback(async (id: number, patch: Partial<MaintenanceCreateInput>): Promise<MaintenanceRecord> => {
    const res = await api.patch<{ maintenance: MaintenanceRecord }>(`/maintenance/${id}`, patch);
    reload();
    return res.maintenance;
  }, [reload]);

  const deleteMaintenance = useCallback(async (id: number): Promise<void> => {
    await api.delete(`/maintenance/${id}`);
    reload();
  }, [reload]);

  const uploadDocument = useCallback(async (id: number, type: 'facture' | 'document', file: File): Promise<MaintenanceDocument> => {
    const formData = new FormData();
    formData.append('document', file);
    formData.append('type', type);
    const res = await fetch(`/api/maintenance/${id}/documents`, { method: 'POST', credentials: 'include', body: formData });
    if (!res.ok) throw new Error("Échec de l'envoi du fichier.");
    const data = await res.json() as { document: MaintenanceDocument };
    reload();
    return data.document;
  }, [reload]);

  const deleteDocument = useCallback(async (maintenanceId: number, docId: number): Promise<void> => {
    await api.delete(`/maintenance/${maintenanceId}/documents/${docId}`);
    reload();
  }, [reload]);

  const value = useMemo<MaintenanceState>(() => ({
    maintenances, loading, error, reload,
    createMaintenance, updateMaintenance, deleteMaintenance, uploadDocument, deleteDocument
  }), [maintenances, loading, error, reload, createMaintenance, updateMaintenance, deleteMaintenance, uploadDocument, deleteDocument]);

  return <MaintenanceContext.Provider value={value}>{children}</MaintenanceContext.Provider>;
}

export function useMaintenance(): MaintenanceState {
  const ctx = useContext(MaintenanceContext);
  if (!ctx) throw new Error('useMaintenance doit être utilisé à l\'intérieur de <MaintenanceProvider>');
  return ctx;
}
