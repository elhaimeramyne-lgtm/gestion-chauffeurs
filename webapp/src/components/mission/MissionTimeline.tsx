/**
 * MissionTimeline — Frise chronologique verticale pour le suivi des
 * missions en temps réel.
 *
 * Affiche la liste des événements (changements de statut) d'une mission
 * dans l'ordre chronologique inverse, avec :
 *   - Un cercle coloré correspondant au statut
 *   - Le libellé du statut
 *   - L'heure et l'auteur
 *   - Un commentaire optionnel
 */
import type { MissionEvent } from '../../types/parcAuto';
import { DEPLACEMENT_STATUT_LABELS, DEPLACEMENT_ETAPE_COLOR } from '../../types/parcAuto';
import type { DeplacementStatut } from '../../types/parcAuto';

export interface MissionTimelineProps {
  events: MissionEvent[];
  /** Si true, l'ordre est du plus récent au plus ancien (défaut). */
  reversed?: boolean;
  /** Nombre max d'événements à afficher (0 = tous). */
  max?: number;
}

export default function MissionTimeline({ events, reversed = true, max = 0 }: MissionTimelineProps) {
  const sorted = reversed
    ? [...events].sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime())
    : [...events].sort((a, b) => new Date(a.createdAt).getTime() - new Date(b.createdAt).getTime());

  const displayed = max > 0 ? sorted.slice(0, max) : sorted;

  if (displayed.length === 0) {
    return (
      <div className="text-center py-6">
        <p className="text-sm" style={{ color: 'var(--text-ter)' }}>Aucun événement enregistré.</p>
      </div>
    );
  }

  return (
    <div className="space-y-0">
      {displayed.map((event, idx) => {
        const isLast = idx === displayed.length - 1;
        const color = DEPLACEMENT_ETAPE_COLOR[event.statut as DeplacementStatut] ?? 'var(--text-ter)';
        const label = DEPLACEMENT_STATUT_LABELS[event.statut as DeplacementStatut] ?? event.statut;
        const time = new Date(event.createdAt).toLocaleTimeString('fr-FR', {
          hour: '2-digit',
          minute: '2-digit',
          day: '2-digit',
          month: '2-digit',
        });

        return (
          <div key={event.id} className="flex items-start gap-3 relative pb-4">
            {/* Ligne verticale de connexion */}
            {!isLast && (
              <div
                className="absolute left-[7px] top-3 w-px h-full"
                style={{ background: 'var(--border)' }}
              />
            )}

            {/* Cercle */}
            <div
              className="w-3.5 h-3.5 rounded-full mt-1 shrink-0"
              style={{
                background: color,
                boxShadow: `0 0 0 2px var(--card)`,
              }}
            />

            {/* Contenu */}
            <div className="flex-1 min-w-0">
              <div className="flex items-center justify-between gap-2">
                <p className="text-sm font-medium truncate" style={{ color: 'var(--text-pri)' }}>
                  {label}
                </p>
                <span className="text-[11px] shrink-0" style={{ color: 'var(--text-ter)' }}>
                  {time}
                </span>
              </div>
              <p className="text-xs" style={{ color: 'var(--text-ter)' }}>
                par {event.actionPar}
              </p>
              {event.commentaire && (
                <p className="text-xs mt-0.5 italic" style={{ color: 'var(--text-sec)' }}>
                  « {event.commentaire} »
                </p>
              )}
              {event.latitude && event.longitude && (
                <p className="text-[10px] mt-0.5" style={{ color: 'var(--text-ter)' }}>
                  📍 {event.latitude}, {event.longitude}
                  {event.vitesse != null && ` · ${event.vitesse} km/h`}
                </p>
              )}
            </div>
          </div>
        );
      })}
    </div>
  );
}

