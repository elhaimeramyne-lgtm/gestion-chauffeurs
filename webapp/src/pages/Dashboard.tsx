import { Link } from 'react-router-dom';
import {
  FolderInput, SlidersHorizontal, GitCompareArrows, FileBarChart2,
  ArrowRight, CheckCircle2, Circle, TrendingUp, FileCheck, AlertCircle, Smartphone
} from 'lucide-react';
import { useApp } from '../context/AppContext';
import { useAuth } from '../context/AuthContext';
import { StatCard } from '../components/ui/Kit';
import { useTranslation } from 'react-i18next';

export default function Dashboard() {
  const { t } = useTranslation();
  const { impayesFiles, reglementFiles, rules, comparisonResult, lignes } = useApp();
  const { user } = useAuth();

  const steps = [
    {
      to: '/import',
      icon: FolderInput,
      title: 'Import',
      done: impayesFiles.length > 0 && reglementFiles.length > 0,
      detail: `${impayesFiles.length + reglementFiles.length} fichier(s) importé(s)`,
      accent: 'var(--accent)'
    },
    {
      to: '/regles',
      icon: SlidersHorizontal,
      title: 'Règles de colonnes',
      done: rules.some((r) => r.mapping.refFacture),
      detail: `${rules.filter((r) => r.mapping.refFacture).length} feuille(s) configurée(s)`,
      accent: '#a78bfa'
    },
    {
      to: '/comparaison',
      icon: GitCompareArrows,
      title: 'Comparaison',
      done: Boolean(comparisonResult),
      detail: comparisonResult
        ? `${comparisonResult.summary.total} facture(s) analysée(s)`
        : 'Pas encore lancée',
      accent: '#f59e0b'
    },
    {
      to: '/rapports',
      icon: FileBarChart2,
      title: 'Rapports',
      done: Boolean(comparisonResult),
      detail: 'Export Excel coloré + synthèse',
      accent: 'var(--accent2)'
    }
  ];

  const now = new Date();
  const hour = now.getHours();
  const greeting = hour < 12 ? 'Bonjour' : hour < 18 ? 'Bon après-midi' : 'Bonsoir';

  return (
    <div>
      {/* Welcome banner */}
      <div
        className="rounded-2xl p-6 mb-7 animate-fade-up relative overflow-hidden"
        style={{
          background: 'linear-gradient(135deg, rgba(0,212,255,0.08) 0%, rgba(0,255,136,0.05) 100%)',
          border: '1px solid rgba(0,212,255,0.15)'
        }}
      >
        {/* Decorative blur orb */}
        <div
          className="absolute -top-10 -right-10 w-44 h-44 rounded-full pointer-events-none"
          style={{ background: 'radial-gradient(circle, rgba(0,212,255,0.12) 0%, transparent 70%)' }}
        />
        <p className="text-xs font-mono uppercase tracking-widest mb-1" style={{ color: 'var(--accent)' }}>
          Entraide Nationale · Facturation IAM
        </p>
        <h1 className="text-2xl font-bold" style={{ color: 'var(--text-pri)' }}>
          {greeting},{' '}
          <span style={{ background: 'linear-gradient(135deg,var(--accent),var(--accent2))', WebkitBackgroundClip: 'text', color: 'transparent' }}>
            {user?.displayName || user?.username}
          </span>{' '}👋
        </h1>
        <p className="text-sm mt-1" style={{ color: 'var(--text-sec)' }}>
          Suivez le rapprochement des factures et gérez la flotte mobile.
        </p>
      </div>

      {/* KPI stats */}
      {comparisonResult ? (
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 mb-7 stagger">
          <StatCard
            label={t('homeDashboard.totalAnalyse')}
            value={String(comparisonResult.summary.total)}
            icon={<TrendingUp size={15} />}
          />
          <StatCard
            label={t('homeDashboard.reglees')}
            value={String(comparisonResult.summary.reglees)}
            tone="good"
            icon={<FileCheck size={15} />}
          />
          <StatCard
            label={t('homeDashboard.impayees')}
            value={String(comparisonResult.summary.impayees)}
            tone="bad"
            icon={<AlertCircle size={15} />}
          />
          <StatCard
            label={t('homeDashboard.montantRestant')}
            value={`${comparisonResult.summary.montantImpaye.toLocaleString('fr-FR')} DH`}
            tone="bad"
          />
        </div>
      ) : (
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 mb-7 stagger">
          <StatCard label={t('homeDashboard.fichiersImpayes')} value={String(impayesFiles.length)} />
          <StatCard label={t('homeDashboard.fichiersReglements')} value={String(reglementFiles.length)} />
          <StatCard label={t('homeDashboard.reglesConfigurees')} value={String(rules.filter((r) => r.mapping.refFacture).length)} />
          <StatCard label={t('homeDashboard.lignesMobiles')} value={String(lignes.length)} icon={<Smartphone size={15} />} />
        </div>
      )}

      {/* Workflow steps */}
      <div className="mb-3 flex items-center justify-between">
        <p className="text-xs font-mono uppercase tracking-widest" style={{ color: 'var(--text-ter)' }}>
          Flux de travail
        </p>
        <p className="text-xs" style={{ color: 'var(--text-ter)' }}>
          {steps.filter((s) => s.done).length}/{steps.length} étapes complètes
        </p>
      </div>

      {/* Progress bar */}
      <div className="h-1 rounded-full mb-5 overflow-hidden" style={{ background: 'var(--border)' }}>
        <div
          className="h-full rounded-full transition-all duration-700"
          style={{
            width: `${(steps.filter((s) => s.done).length / steps.length) * 100}%`,
            background: 'linear-gradient(90deg,var(--accent),var(--accent2))'
          }}
        />
      </div>

      <div className="grid sm:grid-cols-2 gap-4 stagger">
        {steps.map(({ to, icon: Icon, title, done, detail, accent }, i) => (
          <Link key={to} to={to} className="group block">
            <div
              className="rounded-2xl p-5 h-full transition-all duration-200 animate-fade-up"
              style={{
                background: 'var(--card)',
                border: `1px solid ${done ? `${accent}30` : 'var(--border)'}`,
                animationDelay: `${i * 70}ms`
              }}
              onMouseEnter={(e) => {
                (e.currentTarget as HTMLElement).style.borderColor = `${accent}55`;
                (e.currentTarget as HTMLElement).style.boxShadow = `0 0 24px ${accent}12`;
              }}
              onMouseLeave={(e) => {
                (e.currentTarget as HTMLElement).style.borderColor = done ? `${accent}30` : 'var(--border)';
                (e.currentTarget as HTMLElement).style.boxShadow = 'none';
              }}
            >
              <div className="flex items-start justify-between mb-3">
                <div className="flex items-center gap-3">
                  <div
                    className="flex items-center justify-center rounded-xl"
                    style={{ width: 38, height: 38, background: `${accent}15`, flexShrink: 0 }}
                  >
                    <Icon size={17} style={{ color: accent }} />
                  </div>
                  <div>
                    <p className="text-[10px] uppercase tracking-widest font-mono" style={{ color: 'var(--text-ter)' }}>
                      Étape {i + 1}
                    </p>
                    <p className="text-base font-semibold" style={{ color: 'var(--text-pri)' }}>{title}</p>
                  </div>
                </div>
                {done
                  ? <CheckCircle2 size={18} style={{ color: accent, flexShrink: 0 }} />
                  : <Circle size={18} style={{ color: 'var(--text-ter)', flexShrink: 0 }} />
                }
              </div>

              <p className="text-sm" style={{ color: 'var(--text-sec)' }}>{detail}</p>

              <div
                className="flex items-center gap-1.5 mt-3 text-xs font-medium transition-all duration-200 opacity-0 group-hover:opacity-100"
                style={{ color: accent }}
              >
                Ouvrir <ArrowRight size={12} />
              </div>
            </div>
          </Link>
        ))}
      </div>

      {/* Quick access lignes */}
      <Link to="/lignes" className="group mt-4 block">
        <div
          className="rounded-2xl p-4 flex items-center justify-between transition-all duration-200"
          style={{ background: 'var(--card)', border: '1px solid var(--border)' }}
          onMouseEnter={(e) => {
            (e.currentTarget as HTMLElement).style.borderColor = 'rgba(0,212,255,0.35)';
          }}
          onMouseLeave={(e) => {
            (e.currentTarget as HTMLElement).style.borderColor = 'var(--border)';
          }}
        >
          <div className="flex items-center gap-3">
            <div
              className="flex items-center justify-center rounded-xl"
              style={{ width: 38, height: 38, background: 'rgba(0,212,255,0.08)', flexShrink: 0 }}
            >
              <Smartphone size={17} style={{ color: 'var(--accent)' }} />
            </div>
            <div>
              <p className="text-sm font-semibold" style={{ color: 'var(--text-pri)' }}>Gestion des lignes</p>
              <p className="text-xs" style={{ color: 'var(--text-sec)' }}>
                {lignes.length > 0 ? `${lignes.length} ligne(s) enregistrée(s)` : 'Gérez la flotte mobile'}
              </p>
            </div>
          </div>
          <ArrowRight size={16} style={{ color: 'var(--accent)' }} className="transition-transform group-hover:translate-x-1" />
        </div>
      </Link>
    </div>
  );
}
