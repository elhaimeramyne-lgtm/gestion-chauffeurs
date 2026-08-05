import { useCallback, useRef, useState } from 'react';
import { UploadCloud, Loader2, FileWarning } from 'lucide-react';
import type { FileRole } from '../../types';

const ACCEPTED_EXTENSIONS = ['.xlsx', '.xls'];

interface Props {
  role: FileRole;
  label: string;
  description: string;
  onFile: (file: File) => Promise<void>;
}

export default function FileDropzone({ label, description, onFile }: Props) {
  const [isDragging, setIsDragging] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const inputRef = useRef<HTMLInputElement>(null);

  const validateAndLoad = useCallback(
    async (file: File | undefined) => {
      if (!file) return;
      const isValid = ACCEPTED_EXTENSIONS.some((ext) => file.name.toLowerCase().endsWith(ext));
      if (!isValid) {
        setError('Format non pris en charge. Merci de déposer un fichier .xlsx ou .xls.');
        return;
      }
      setError(null);
      setIsLoading(true);
      try {
        await onFile(file);
      } catch (e) {
        setError("Impossible de lire ce fichier. Vérifiez qu'il s'agit bien d'un classeur Excel valide.");
      } finally {
        setIsLoading(false);
      }
    },
    [onFile]
  );

  const baseStyle: React.CSSProperties = {
    background: isDragging ? 'rgba(99,102,241,0.06)' : 'rgba(255,255,255,0.03)',
    border: `2px dashed ${isDragging ? 'rgba(99,102,241,0.6)' : 'rgba(255,255,255,0.12)'}`,
    borderRadius: 14,
    padding: '36px 24px',
    textAlign: 'center',
    cursor: 'pointer',
    transition: 'all 180ms ease',
  };

  return (
    <div
      onDragOver={(e) => { e.preventDefault(); setIsDragging(true); }}
      onDragLeave={() => setIsDragging(false)}
      onDrop={(e) => { e.preventDefault(); setIsDragging(false); void validateAndLoad(e.dataTransfer.files?.[0]); }}
      onClick={() => inputRef.current?.click()}
      onMouseEnter={(e) => { if (!isDragging) (e.currentTarget as HTMLElement).style.borderColor = 'rgba(99,102,241,0.35)'; }}
      onMouseLeave={(e) => { if (!isDragging) (e.currentTarget as HTMLElement).style.borderColor = 'rgba(255,255,255,0.12)'; }}
      className="focus-ring"
      style={baseStyle}
    >
      <input
        ref={inputRef}
        type="file"
        accept=".xlsx,.xls"
        className="hidden"
        onChange={(e) => void validateAndLoad(e.target.files?.[0])}
      />

      <div
        className="mx-auto mb-3 flex items-center justify-center rounded-2xl"
        style={{ width: 48, height: 48, background: isDragging ? 'rgba(99,102,241,0.15)' : 'rgba(255,255,255,0.05)' }}
      >
        {isLoading
          ? <Loader2 size={22} style={{ color: 'var(--accent)' }} className="animate-spin" />
          : <UploadCloud size={22} style={{ color: isDragging ? 'var(--accent)' : 'var(--text-ter)' }} />
        }
      </div>

      <p style={{ fontWeight: 600, fontSize: 14, color: 'var(--text-pri)', marginBottom: 4 }}>{label}</p>
      <p style={{ fontSize: 13, color: 'var(--text-sec)', marginBottom: 8 }}>{description}</p>
      <p style={{ fontSize: 12, color: 'var(--text-ter)' }}>Glissez-déposez ou cliquez pour choisir un fichier .xlsx</p>

      {error && (
        <p style={{ fontSize: 12, color: 'var(--accent-err)', marginTop: 10, display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 6 }}>
          <FileWarning size={13} /> {error}
        </p>
      )}
    </div>
  );
}
