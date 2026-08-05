import { Download, FileArchive, CheckCircle2, Package } from 'lucide-react';

const FILES = [
  {
    name: 'gestion-chauffeurs.zip',
    label: 'Archive ZIP',
    size: '2,9 Mo',
    desc: 'Format ZIP — compatible Windows, macOS, Linux',
    icon: FileArchive,
    color: '#6366f1',
  },
  {
    name: 'gestion-chauffeurs-v2.tar.gz',
    label: 'Archive TAR.GZ',
    size: '2,7 Mo',
    desc: 'Format TAR.GZ — recommandé Linux / macOS',
    icon: Package,
    color: '#0ea5e9',
  },
];

const STEPS = [
  'Décompresser l\'archive dans un dossier de votre choix',
  'cd server && npm install && cp .env.example .env  (adapter DATABASE_URL)',
  'cd server && npm run dev    (backend Express sur le port 5000)',
  'cd webapp && npm install && npm run dev   (frontend Vite sur le port 5173)',
];

export default function DownloadPage() {
  return (
    <div className="max-w-2xl mx-auto py-10 px-4 space-y-8">
      {/* En-tête */}
      <div>
        <h1 className="text-2xl font-bold mb-1" style={{ color: 'var(--text-pri)' }}>
          Télécharger le projet
        </h1>
        <p className="text-sm" style={{ color: 'var(--text-sec)' }}>
          Code source complet — webapp (Vite + React + TS) &amp; serveur (Express + Drizzle + PostgreSQL).
          Les dossiers <code className="px-1 rounded text-xs" style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}>node_modules</code> et{' '}
          <code className="px-1 rounded text-xs" style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}>dist</code> sont exclus.
        </p>
      </div>

      {/* Cartes de téléchargement */}
      <div className="grid gap-4">
        {FILES.map(({ name, label, size, desc, icon: Icon, color }) => (
          <a
            key={name}
            href={`/${name}`}
            download={name}
            className="flex items-center gap-4 rounded-2xl p-5 transition-all hover:-translate-y-0.5"
            style={{
              background: 'var(--card)',
              border: '1px solid var(--border)',
              boxShadow: 'var(--shadow-card)',
              textDecoration: 'none',
            }}
          >
            <span
              className="flex items-center justify-center rounded-xl shrink-0"
              style={{ width: 48, height: 48, background: `${color}22` }}
            >
              <Icon size={22} style={{ color }} />
            </span>
            <div className="flex-1 min-w-0">
              <p className="font-semibold text-sm" style={{ color: 'var(--text-pri)' }}>{label}</p>
              <p className="text-xs mt-0.5" style={{ color: 'var(--text-ter)' }}>{desc}</p>
              <p className="text-xs font-mono mt-1" style={{ color: 'var(--text-ter)' }}>{name} — {size}</p>
            </div>
            <span
              className="flex items-center gap-1.5 px-4 py-2 rounded-xl text-sm font-semibold shrink-0"
              style={{ background: color, color: '#fff' }}
            >
              <Download size={15} /> Télécharger
            </span>
          </a>
        ))}
      </div>

      {/* Instructions de démarrage */}
      <div className="rounded-2xl p-5 space-y-3" style={{ background: 'var(--card)', border: '1px solid var(--border)' }}>
        <p className="text-xs font-bold uppercase tracking-wide" style={{ color: 'var(--text-ter)' }}>
          Instructions de démarrage
        </p>
        <ol className="space-y-2">
          {STEPS.map((step, i) => (
            <li key={i} className="flex items-start gap-3">
              <span
                className="flex items-center justify-center rounded-full text-xs font-bold shrink-0 mt-0.5"
                style={{ width: 20, height: 20, background: 'var(--grad-brand)', color: '#fff' }}
              >
                {i + 1}
              </span>
              <code className="text-xs leading-relaxed" style={{ color: 'var(--text-sec)' }}>{step}</code>
            </li>
          ))}
        </ol>
      </div>

      {/* Note .env */}
      <div
        className="flex items-start gap-3 rounded-xl p-4"
        style={{ background: 'rgba(239,68,68,0.08)', border: '1px solid rgba(239,68,68,0.2)' }}
      >
        <CheckCircle2 size={16} style={{ color: '#ef4444', marginTop: 2, flexShrink: 0 }} />
        <p className="text-xs leading-relaxed" style={{ color: 'var(--text-sec)' }}>
          <strong style={{ color: 'var(--text-pri)' }}>Important :</strong> le fichier{' '}
          <code className="px-1 rounded" style={{ background: 'var(--bg)', border: '1px solid var(--border)' }}>server/.env</code>{' '}
          contient les credentials de la base de données sandbox.{' '}
          <strong>Remplacez <code>DATABASE_URL</code>, <code>SESSION_SECRET</code> et <code>CORS_ORIGINS</code></strong>{' '}
          avant tout déploiement en production.
        </p>
      </div>
    </div>
  );
}
