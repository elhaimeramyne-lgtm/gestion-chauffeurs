/**
 * SignaturePad — Canvas interactif pour la capture de signature.
 *
 * Fonctionne aussi bien sur écran tactile (mobile) que souris (desktop).
 * Renvoie une image PNG en base64 via le callback onSave.
 *
 * Props :
 *  - onSave: (dataUrl: string) => void — appelé quand l'utilisateur valide
 *  - onCancel: () => void — appelé quand l'utilisateur annule
 *  - width?: number — largeur du canvas (défaut: 400)
 *  - height?: number — hauteur du canvas (défaut: 200)
 *  - label?: string — texte au-dessus du canvas
 */
import { useRef, useState, useCallback, useEffect } from 'react';

export interface SignaturePadProps {
  onSave: (dataUrl: string) => void;
  onCancel: () => void;
  width?: number;
  height?: number;
  label?: string;
}

export default function SignaturePad({
  onSave,
  onCancel,
  width = 400,
  height = 200,
  label = 'Signature',
}: SignaturePadProps) {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const [isDrawing, setIsDrawing] = useState(false);
  const [hasContent, setHasContent] = useState(false);

  const getPosition = useCallback(
    (e: MouseEvent | TouchEvent) => {
      const canvas = canvasRef.current;
      if (!canvas) return { x: 0, y: 0 };
      const rect = canvas.getBoundingClientRect();
      const clientX = 'touches' in e ? e.touches[0].clientX : e.clientX;
      const clientY = 'touches' in e ? e.touches[0].clientY : e.clientY;
      return {
        x: clientX - rect.left,
        y: clientY - rect.top,
      };
    },
    []
  );

  const startDrawing = useCallback(
    (e: MouseEvent | TouchEvent) => {
      e.preventDefault();
      const canvas = canvasRef.current;
      if (!canvas) return;
      const ctx = canvas.getContext('2d');
      if (!ctx) return;
      setIsDrawing(true);
      const { x, y } = getPosition(e);
      ctx.beginPath();
      ctx.moveTo(x, y);
    },
    [getPosition]
  );

  const draw = useCallback(
    (e: MouseEvent | TouchEvent) => {
      e.preventDefault();
      if (!isDrawing) return;
      const canvas = canvasRef.current;
      if (!canvas) return;
      const ctx = canvas.getContext('2d');
      if (!ctx) return;
      const { x, y } = getPosition(e);
      ctx.lineTo(x, y);
      ctx.strokeStyle = '#1e293b';
      ctx.lineWidth = 2.5;
      ctx.lineCap = 'round';
      ctx.lineJoin = 'round';
      ctx.stroke();
      setHasContent(true);
    },
    [isDrawing, getPosition]
  );

  const stopDrawing = useCallback(() => {
    setIsDrawing(false);
  }, []);

  const clearCanvas = useCallback(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    setHasContent(false);
  }, []);

  const handleSave = useCallback(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    onSave(canvas.toDataURL('image/png'));
  }, [onSave]);

  // Attacher les événements au canvas
  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;

    canvas.addEventListener('mousedown', startDrawing);
    canvas.addEventListener('mousemove', draw);
    canvas.addEventListener('mouseup', stopDrawing);
    canvas.addEventListener('mouseleave', stopDrawing);
    canvas.addEventListener('touchstart', startDrawing, { passive: false });
    canvas.addEventListener('touchmove', draw, { passive: false });
    canvas.addEventListener('touchend', stopDrawing);

    return () => {
      canvas.removeEventListener('mousedown', startDrawing);
      canvas.removeEventListener('mousemove', draw);
      canvas.removeEventListener('mouseup', stopDrawing);
      canvas.removeEventListener('mouseleave', stopDrawing);
      canvas.removeEventListener('touchstart', startDrawing);
      canvas.removeEventListener('touchmove', draw);
      canvas.removeEventListener('touchend', stopDrawing);
    };
  }, [startDrawing, draw, stopDrawing]);

  return (
    <div className="rounded-xl p-4" style={{ background: 'var(--card)', border: '1px solid var(--border)' }}>
      <p className="text-sm font-semibold mb-2" style={{ color: 'var(--text-pri)' }}>{label}</p>

      <canvas
        ref={canvasRef}
        width={width}
        height={height}
        className="w-full rounded-lg touch-none cursor-crosshair"
        style={{
          background: '#f8fafc',
          border: '1px solid #e2e8f0',
          maxWidth: '100%',
        }}
      />

      <div className="flex items-center justify-end gap-2 mt-3">
        <button
          onClick={clearCanvas}
          className="px-3 py-1.5 text-xs rounded-lg transition-colors hover:bg-[var(--card-hover)]"
          style={{ color: 'var(--text-ter)' }}
        >
          Effacer
        </button>
        <button
          onClick={onCancel}
          className="px-3 py-1.5 text-xs rounded-lg transition-colors hover:bg-[var(--card-hover)]"
          style={{ color: 'var(--text-ter)' }}
        >
          Annuler
        </button>
        <button
          onClick={handleSave}
          disabled={!hasContent}
          className="px-4 py-1.5 text-xs font-medium rounded-lg transition-all disabled:opacity-40"
          style={{
            background: hasContent ? '#2563eb' : 'var(--border)',
            color: hasContent ? '#fff' : 'var(--text-ter)',
          }}
        >
          Enregistrer
        </button>
      </div>
    </div>
  );
}

