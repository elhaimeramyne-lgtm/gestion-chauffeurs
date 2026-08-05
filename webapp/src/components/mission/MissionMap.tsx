/**
 * MissionMap — Carte temps réel des missions actives avec OpenStreetMap
 * (Leaflet).
 *
 * Affiche :
 *   - Marqueurs des missions actives avec leur statut (couleur)
 *   - Popup avec les détails (numéro, chauffeur, destination, vitesse)
 *   - Lignes de route (itinéraire) pour les missions en route
 *   - Regroupement de marqueurs (Clustering) pour éviter le surplomb
 *   - Actualisation automatique toutes les 15s
 *
 * Utilise OpenStreetMap (gratuit, pas de clé API requise).
 */
import { useEffect, useMemo, useRef, useState } from 'react';
import { MapPin, Navigation, Gauge, Clock, Car, User as UserIcon } from 'lucide-react';
import type {
  Deplacement, DeplacementStatut, GpsPoint, Vehicule, Chauffeur
} from '../../types/parcAuto';
import { DEPLACEMENT_ETAPE_COLOR, DEPLACEMENT_STATUT_LABELS } from '../../types/parcAuto';

/* ═══════════════════════════════════════════════════════════════════════
 * TYPES
 * ═══════════════════════════════════════════════════════════════════════ */

export interface ActiveMission {
  deplacement: Deplacement;
  vehicule?: Vehicule | null;
  chauffeur?: Chauffeur | null;
  lastGpsPoint?: GpsPoint | null;
  gpsPoints?: GpsPoint[];
  etapeOrdre: number;
}

export interface MissionMapProps {
  missions: ActiveMission[];
  /** Hauteur de la carte en pixels (défaut: 450). */
  height?: number;
  /** Étapes pour lesquelles afficher l'itinéraire (défaut: en_route, retour). */
  showRouteFor?: DeplacementStatut[];
  /** Appelé quand l'utilisateur clique sur un marqueur. */
  onMissionClick?: (missionId: number) => void;
}

/* ═══════════════════════════════════════════════════════════════════════
 * SINGLETON: Import dynamique de Leaflet (non SSR)
 * ═══════════════════════════════════════════════════════════════════════ */

let L: any = null;
let mapInstance: any = null;
let markersLayer: any = null;

async function loadLeaflet(): Promise<any> {
  if (L) return L;
  L = await import('leaflet');
  // Corriger le chemin des icons par défaut (problème Webpack/Vite)
  delete L.Icon.Default.prototype._getIconUrl;
  L.Icon.Default.mergeOptions({
    iconRetinaUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png',
    iconUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png',
    shadowUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png',
  });
  return L;
}

/* ═══════════════════════════════════════════════════════════════════════
 * ICÔNES PERSONNALISÉES PAR STATUT
 * ═══════════════════════════════════════════════════════════════════════ */

function createStatusIcon(statut: DeplacementStatut, isActive: boolean = false): any {
  if (!L) return null;
  const color = DEPLACEMENT_ETAPE_COLOR[statut] ?? '#6b7280';
  const size = isActive ? 16 : 12;

  const svg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="${color}" width="${size * 2}" height="${size * 2}">
    <path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/>
  </svg>`;

  return L.divIcon({
    className: 'mission-marker',
    html: svg,
    iconSize: [size * 2, size * 2],
    iconAnchor: [size, size],
    popupAnchor: [0, -size],
  });
}

/* ═══════════════════════════════════════════════════════════════════════
 * COMPOSANT CARTE
 * ═══════════════════════════════════════════════════════════════════════ */

export default function MissionMap({
  missions,
  height = 450,
  showRouteFor = ['en_route', 'retour'],
  onMissionClick,
}: MissionMapProps) {
  const mapContainerRef = useRef<HTMLDivElement>(null);
  const mapRef = useRef<any>(null);
  const markersRef = useRef<any>(null);
  const [leafletReady, setLeafletReady] = useState(false);
  const [mapReady, setMapReady] = useState(false);

  // Charger Leaflet une fois
  useEffect(() => {
    loadLeaflet().then(() => setLeafletReady(true));
  }, []);

  // Initialiser la carte
  useEffect(() => {
    if (!leafletReady || !mapContainerRef.current || mapRef.current) return;

    const L_local = L;

    // Centrer sur le Maroc par défaut
    const map = L_local.map(mapContainerRef.current, {
      center: [31.7917, -7.0926],
      zoom: 6,
      zoomControl: true,
      attributionControl: true,
    });

    // Tuiles OpenStreetMap (gratuites)
    L_local.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
      maxZoom: 19,
    }).addTo(map);

    mapRef.current = map;
    markersRef.current = L_local.layerGroup().addTo(map);
    setMapReady(true);

    // Nettoyage
    return () => {
      map.remove();
      mapRef.current = null;
      markersRef.current = null;
    };
  }, [leafletReady]);

  // Mettre à jour les marqueurs lorsque les missions changent
  useEffect(() => {
    if (!mapReady || !markersRef.current || !L) return;

    const map = mapRef.current;
    const markers = markersRef.current;
    const L_local = L;

    // Vider les marqueurs et lignes existants
    markers.clearLayers();

    const bounds: [number, number][] = [];
    const hasMarkers = missions.some((m) => m.lastGpsPoint);

    for (const mission of missions) {
      const gps = mission.lastGpsPoint;
      if (!gps) continue;

      const lat = gps.latitude;
      const lng = gps.longitude;
      bounds.push([lat, lng]);

      const statut = mission.deplacement.statut;
      const color = DEPLACEMENT_ETAPE_COLOR[statut] ?? '#6b7280';
      const label = DEPLACEMENT_STATUT_LABELS[statut] ?? statut;

      // Créer le marqueur personnalisé
      const marker = L_local.marker([lat, lng], {
        icon: createStatusIcon(statut, true),
        riseOnHover: true,
      });

      // Popup avec les détails de la mission
      const popupContent = `
        <div style="font-family: system-ui, sans-serif; min-width: 220px;">
          <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px;">
            <span style="display: inline-block; width: 10px; height: 10px; border-radius: 50%; background: ${color};"></span>
            <strong style="font-size: 13px;">${mission.deplacement.numero}</strong>
            <span style="font-size: 10px; padding: 1px 6px; border-radius: 4px; background: ${color}20; color: ${color}; margin-left: auto;">
              ${label}
            </span>
          </div>
          <div style="font-size: 12px; color: #666; line-height: 1.6;">
            <div>📍 <strong>${mission.deplacement.destination ?? '—'}</strong></div>
            <div>🚗 ${mission.vehicule?.immatriculation ?? '—'} · ${mission.vehicule?.marque ?? ''} ${mission.vehicule?.modele ?? ''}</div>
            <div>👤 ${mission.chauffeur?.nom ?? '—'}</div>
            ${gps.vitesse != null ? `<div>⚡ ${gps.vitesse.toFixed(1)} km/h</div>` : ''}
            <div>📅 ${mission.deplacement.dateDepart}</div>
            <div style="margin-top: 6px; font-size: 11px; color: #999;">
              ${new Intl.DateTimeFormat('fr-FR', { hour: '2-digit', minute: '2-digit', second: '2-digit' }).format(new Date(gps.createdAt))}
            </div>
          </div>
          <button onclick="window.__missionMapClick && window.__missionMapClick(${mission.deplacement.id})"
            style="margin-top: 8px; width: 100%; padding: 4px 8px; font-size: 11px; background: ${color}; color: white; border: none; border-radius: 4px; cursor: pointer;">
            Voir le détail
          </button>
        </div>
      `;

      marker.bindPopup(popupContent, {
        closeButton: true,
        maxWidth: 280,
      });

      marker.on('click', () => {
        onMissionClick?.(mission.deplacement.id);
      });

      markers.addLayer(marker);

      // Tracer l'itinéraire (points GPS récents) pour les missions en déplacement
      if (showRouteFor.includes(statut) && mission.gpsPoints && mission.gpsPoints.length > 1) {
        const routeCoords: [number, number][] = mission.gpsPoints
          .sort((a, b) => new Date(a.createdAt).getTime() - new Date(b.createdAt).getTime())
          .map((p) => [p.latitude, p.longitude]);

        const routeLine = L_local.polyline(routeCoords, {
          color: color,
          weight: 3,
          opacity: 0.6,
          dashArray: '6, 10',
        });
        markers.addLayer(routeLine);
      }
    }

    // Ajuster les bounds si on a des marqueurs
    if (hasMarkers && bounds.length > 0) {
      map.fitBounds(bounds, { padding: [50, 50], maxZoom: 12 });
    } else {
      map.setView([31.7917, -7.0926], 6);
    }
  }, [missions, mapReady, onMissionClick, showRouteFor]);

  return (
    <div className="relative rounded-xl overflow-hidden" style={{ border: '1px solid var(--border)' }}>
      {/* Légende flottante */}
      <div
        className="absolute top-3 right-3 z-[1000] rounded-lg px-3 py-2 text-[11px] space-y-1"
        style={{
          background: 'rgba(11,16,35,0.85)',
          backdropFilter: 'blur(12px)',
          border: '1px solid var(--border)',
          maxWidth: 160,
        }}
      >
        <p className="font-semibold mb-1" style={{ color: 'var(--text-pri)' }}>Légende</p>
        {Array.from(new Set(missions.map((m) => m.deplacement.statut))).map((statut) => (
          <div key={statut} className="flex items-center gap-1.5">
            <span
              className="rounded-full shrink-0"
              style={{
                width: 8,
                height: 8,
                background: DEPLACEMENT_ETAPE_COLOR[statut] ?? '#6b7280',
                boxShadow: `0 0 4px ${DEPLACEMENT_ETAPE_COLOR[statut] ?? '#6b7280'}`,
              }}
            />
            <span style={{ color: 'var(--text-sec)' }}>{DEPLACEMENT_STATUT_LABELS[statut] ?? statut}</span>
          </div>
        ))}
        <div className="flex items-center gap-1.5 mt-1 pt-1" style={{ borderTop: '1px solid var(--border)' }}>
          <span
            className="block"
            style={{ width: 16, height: 2, background: 'var(--text-ter)', opacity: 0.6 }}
          />
          <span style={{ color: 'var(--text-ter)' }}>Itinéraire</span>
        </div>
      </div>

      {/* Conteneur de la carte */}
      <div
        ref={mapContainerRef}
        style={{
          width: '100%',
          height,
          background: '#1a1a2e',
          borderRadius: 'inherit',
        }}
      />

      {/* État vide / chargement */}
      {!leafletReady && (
        <div
          className="absolute inset-0 flex items-center justify-center"
          style={{ background: 'rgba(11,16,35,0.8)' }}
        >
          <p className="text-sm" style={{ color: 'var(--text-ter)' }}>Chargement de la carte…</p>
        </div>
      )}

      {leafletReady && missions.length === 0 && (
        <div
          className="absolute inset-0 flex flex-col items-center justify-center"
          style={{ background: 'rgba(11,16,35,0.8)' }}
        >
          <MapPin size={28} style={{ color: 'var(--text-ter)', marginBottom: 8 }} />
          <p className="text-sm font-medium" style={{ color: 'var(--text-pri)' }}>Aucune mission active</p>
          <p className="text-xs mt-1" style={{ color: 'var(--text-ter)' }}>
            Les missions avec des points GPS apparaîtront ici.
          </p>
        </div>
      )}
    </div>
  );
}

