/**
 * OrgContext — source de vérité unique pour l'organigramme.
 *
 * Fournit :
 *  - l'arbre hiérarchique complet (pour la page Organigramme)
 *  - la liste plate des unités (pour les <select> dans toute la plateforme)
 *  - la liste des "qualités" (remplace l'ancien LIGNE_QUALITES statique)
 *  - les fonctions CRUD (create / patch / delete)
 */
import React, { createContext, useCallback, useContext, useEffect, useMemo, useState } from 'react';
import { api, ApiError } from '../lib/api';
import { useAuth } from './AuthContext';

/* ── Types ─────────────────────────────────────────────────────────── */
export type OrgNodeType = 'direction' | 'sous-direction' | 'division' | 'service' | 'inspection' | 'entite';

export interface OrgNode {
  id: number;
  type: OrgNodeType;
  name: string;
  shortName: string | null;
  parentId: number | null;
  sortOrder: number;
  chefNom: string | null;
  telephone: string | null;
  notes: string | null;
  createdAt: string;
  updatedAt: string;
}

export interface OrgNodeTree extends OrgNode {
  children: OrgNodeTree[];
}

export interface OrgCreateInput {
  type: OrgNodeType;
  name: string;
  shortName?: string;
  parentId?: number;
  sortOrder?: number;
  chefNom?: string;
  telephone?: string;
  notes?: string;
}

export interface OrgPatchInput {
  name?: string;
  shortName?: string | null;
  parentId?: number | null;
  sortOrder?: number;
  chefNom?: string | null;
  telephone?: string | null;
  notes?: string | null;
}

interface OrgState {
  tree: OrgNodeTree[];
  nodes: OrgNode[];          // liste plate
  qualites: string[];        // pour les <select> qualite/affecte
  loading: boolean;
  error: string | null;
  reload: () => void;
  createNode: (input: OrgCreateInput) => Promise<OrgNode>;
  patchNode: (id: number, input: OrgPatchInput) => Promise<OrgNode>;
  deleteNode: (id: number) => Promise<void>;
  /** Déplace/réordonne plusieurs unités en une seule transaction serveur
   *  (utilisé pour monter/descendre/changer de niveau/changer de parent
   *  dans l'arbre interactif). */
  reorderNodes: (updates: { id: number; parentId: number | null; sortOrder: number }[]) => Promise<void>;
}

const OrgContext = createContext<OrgState | null>(null);

export function OrgProvider({ children }: { children: React.ReactNode }) {
  const { user } = useAuth();
  const [tree, setTree] = useState<OrgNodeTree[]>([]);
  const [nodes, setNodes] = useState<OrgNode[]>([]);
  const [qualites, setQualites] = useState<string[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [tick, setTick] = useState(0);

  const reload = useCallback(() => setTick((t) => t + 1), []);

  useEffect(() => {
    // Un compte CHAUFFEUR n'a pas la permission 'org.view' (voir
    // lib/permissions.ts côté serveur) et n'utilise que le portail dédié :
    // inutile de déclencher ces appels, qui échoueraient systématiquement
    // en 403 en arrière-plan.
    if (!user || user.role === 'CHAUFFEUR') {
      setTree([]);
      setNodes([]);
      setQualites([]);
      return;
    }
    setLoading(true);
    setError(null);
    Promise.all([
      api.get<{ tree: OrgNodeTree[] }>('/org/tree'),
      api.get<{ nodes: OrgNode[] }>('/org/flat'),
      api.get<{ qualites: string[] }>('/org/qualites'),
    ])
      .then(([treeRes, flatRes, qualRes]) => {
        setTree(treeRes.tree);
        setNodes(flatRes.nodes);
        setQualites(qualRes.qualites);
      })
      .catch(() => setError('Impossible de charger l\'organigramme.'))
      .finally(() => setLoading(false));
  }, [user, tick]);

  const createNode = useCallback(async (input: OrgCreateInput): Promise<OrgNode> => {
    const res = await api.post<{ node: OrgNode }>('/org/nodes', input);
    reload();
    return res.node;
  }, [reload]);

  const patchNode = useCallback(async (id: number, input: OrgPatchInput): Promise<OrgNode> => {
    const res = await api.patch<{ node: OrgNode }>(`/org/nodes/${id}`, input);
    // Mise à jour optimiste locale
    setNodes((prev) => prev.map((n) => n.id === id ? { ...n, ...input } as OrgNode : n));
    reload();
    return res.node;
  }, [reload]);

  const deleteNode = useCallback(async (id: number): Promise<void> => {
    await api.delete(`/org/nodes/${id}`);
    reload();
  }, [reload]);

  const reorderNodes = useCallback(
    async (updates: { id: number; parentId: number | null; sortOrder: number }[]): Promise<void> => {
      if (updates.length === 0) return;
      // Mise à jour optimiste locale pour un rendu instantané.
      setNodes((prev) => {
        const byId = new Map(updates.map((u) => [u.id, u]));
        return prev.map((n) => (byId.has(n.id) ? { ...n, ...byId.get(n.id)! } : n));
      });
      try {
        await api.patch('/org/reorder', { updates });
      } catch (err) {
        // En cas d'échec (droits insuffisants, session expirée, conflit…),
        // on resynchronise avec le serveur pour annuler la mise à jour
        // optimiste plutôt que de laisser l'affichage désynchronisé, et on
        // remonte l'erreur pour qu'elle soit visible côté UI.
        setError(err instanceof ApiError ? err.message : 'Le déplacement a échoué.');
        reload();
        throw err;
      }
      reload();
    },
    [reload]
  );

  const value = useMemo<OrgState>(() => ({
    tree, nodes, qualites, loading, error,
    reload, createNode, patchNode, deleteNode, reorderNodes
  }), [tree, nodes, qualites, loading, error, reload, createNode, patchNode, deleteNode, reorderNodes]);

  return <OrgContext.Provider value={value}>{children}</OrgContext.Provider>;
}

export function useOrg(): OrgState {
  const ctx = useContext(OrgContext);
  if (!ctx) throw new Error('useOrg doit être utilisé à l\'intérieur de <OrgProvider>');
  return ctx;
}

/** Helper : retourne la liste plate des noms de unités pour les selects qualite.
 *  Fallback statique si l'API n'a pas encore répondu. */
export function useQualites(): string[] {
  const { qualites } = useOrg();
  return qualites;
}
