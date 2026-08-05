/**
 * useBadgeCounts — poll /api/notifications/badges toutes les 30s
 * Retourne les compteurs de rubrique pour les badges Gmail dans la sidebar admin.
 */
import { useEffect, useState } from 'react';
import { api } from '../lib/api';

export interface BadgeCounts {
  demandesChauffeur: number;
  missionsAttente: number;
  declarationsNouv: number;
}

const EMPTY: BadgeCounts = { demandesChauffeur: 0, missionsAttente: 0, declarationsNouv: 0 };
const POLL_MS = 30_000;

export function useBadgeCounts(): BadgeCounts {
  const [counts, setCounts] = useState<BadgeCounts>(EMPTY);

  useEffect(() => {
    let cancelled = false;

    const fetch = async () => {
      try {
        const data = await api.get<BadgeCounts>('/notifications/badges');
        if (!cancelled) setCounts(data);
      } catch {
        // silencieux — ne pas casser le layout si l'endpoint échoue
      }
    };

    fetch();
    const id = setInterval(fetch, POLL_MS);
    return () => {
      cancelled = true;
      clearInterval(id);
    };
  }, []);

  return counts;
}
