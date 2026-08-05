/**
 * PhotoCapture — Widget de capture photo pour les missions.
 *
 * Supporte :
 *   - Appareil photo (via `capture="environment"`)
 *   - Galerie / sélection de fichier
 *   - Webcam en direct (fallback si l'appareil photo natif n'est pas dispo)
 *
 * Props :
 *   - onPhoto: (file: File, type: PhotoType) => void
 *   - types?: PhotoType[] — types de photo disponibles (défaut: tous)
 *   - multiple?: boolean — autoriser plusieurs fichiers
 */
import { useRef, useState, useCallback } from 'react';
import { Camera, Image as ImageIcon, X } from 'lucide-react';

export type PhotoType = 'depart' | 'arrivee' | 'bon_livraison' | 'retour' | 'autre';

const PHOTO_TYPE_LABELS: Record<PhotoType, string> = {
  depart: 'Départ',
  arrivee: 'Arrivée',
  bon_livraison: 'Bon de livraison',
  retour: 'Retour',
  autre: 'Autre',
};

const PHOTO_TYPE_COLORS: Record<PhotoType, string> = {
  depart: '#3b82f6',
  arrivee: '#8b5cf6',
  bon_livraison: '#f59e0b',
  retour: '#f97316',
  autre: '#6b7280',
};

export interface PhotoCaptureProps {
  onPhoto: (file: File, type: PhotoType) => void;
  types?: PhotoType[];
  multiple?: boolean;
}

export default function PhotoCapture({
  onPhoto,
  types = ['depart', 'arrivee', 'bon_livraison', 'retour', 'autre'],
  multiple = false,
}: PhotoCaptureProps) {
  const fileInputRef = useRef<HTMLInputElement>(null);
  const cameraInputRef = useRef<HTMLInputElement>(null);
  const [selectedType, setSelectedType] = useState<PhotoType | null>(null);
  const [preview, setPreview] = useState<string | null>(null);

  const handleFile = useCallback(
    (e: React.ChangeEvent<HTMLInputElement>) => {
      const files = e.target.files;
      if (!files?.length) return;
      const file = files[0];
      const type = selectedType ?? 'autre';

      // Créer un aperçu
      const reader = new FileReader();
      reader.onload = () => setPreview(reader.result as string);
      reader.readAsDataURL(file);

      onPhoto(file, type);
      e.target.value = '';
    },
    [selectedType, onPhoto]
  );

  const openFilePicker = () => {
    fileInputRef.current?.click();
  };

  const openCamera = () => {
    cameraInputRef.current?.click();
  };

  const clearPreview = () => {
    setPreview(null);
    setSelectedType(null);
  };

  return (
    <div className="space-y-3">
      {/* Sélecteur de type de photo */}
      <div className="flex flex-wrap gap-1.5">
        {types.map((type) => (
          <button
            key={type}
            onClick={() => setSelectedType(type)}
            className="px-2.5 py-1 rounded-full text-[11px] font-medium transition-all"
            style={{
              background: selectedType === type ? PHOTO_TYPE_COLORS[type] : 'var(--bg)',
              color: selectedType === type ? '#fff' : 'var(--text-sec)',
              border: `1px solid ${selectedType === type ? PHOTO_TYPE_COLORS[type] : 'var(--border)'}`,
            }}
          >
            {PHOTO_TYPE_LABELS[type]}
          </button>
        ))}
      </div>

      {/* Aperçu */}
      {preview && (
        <div className="relative rounded-lg overflow-hidden" style={{ border: '1px solid var(--border)' }}>
          <img src={preview} alt="Aperçu" className="w-full h-40 object-cover" />
          <button
            onClick={clearPreview}
            className="absolute top-2 right-2 p-1 rounded-full bg-black/40 text-white hover:bg-black/60 transition-colors"
          >
            <X size={14} />
          </button>
        </div>
      )}

      {/* Boutons de capture */}
      <div className="flex gap-2">
        <input
          ref={cameraInputRef}
          type="file"
          accept="image/*"
          capture="environment"
          className="hidden"
          onChange={handleFile}
        />
        <input
          ref={fileInputRef}
          type="file"
          accept="image/*"
          multiple={multiple}
          className="hidden"
          onChange={handleFile}
        />

        <button
          onClick={openCamera}
          className="flex-1 flex items-center justify-center gap-1.5 px-3 py-2.5 rounded-lg text-xs font-medium transition-colors"
          style={{ background: 'var(--bg)', color: 'var(--text-sec)', border: '1px solid var(--border)' }}
        >
          <Camera size={15} /> Appareil photo
        </button>
        <button
          onClick={openFilePicker}
          className="flex-1 flex items-center justify-center gap-1.5 px-3 py-2.5 rounded-lg text-xs font-medium transition-colors"
          style={{ background: 'var(--bg)', color: 'var(--text-sec)', border: '1px solid var(--border)' }}
        >
          <ImageIcon size={15} /> Galerie
        </button>
      </div>
    </div>
  );
}

