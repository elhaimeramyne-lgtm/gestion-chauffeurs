import React from 'react';
import { useCountUp } from '../../lib/useCountUp';

/* ── Card ── */
export function Card({ className = '', children, onClick, style }: { className?: string; children: React.ReactNode; onClick?: () => void; style?: React.CSSProperties }) {
  return (
    <div
      className={`glass transition-all duration-200 ${className}`}
      style={{ background: 'var(--card)', borderColor: 'var(--border)', cursor: onClick ? 'pointer' : undefined, ...style }}
      onClick={onClick}
    >
      {children}
    </div>
  );
}

/* ── PageHeader ── */
export function PageHeader({
  eyebrow, title, description, action
}: {
  eyebrow?: string;
  title: string;
  description?: string;
  action?: React.ReactNode;
}) {
  return (
    <div className="flex flex-wrap items-start justify-between gap-4 mb-7 animate-fade-up">
      <div>
        {eyebrow && (
          <p style={{ fontFamily:'Inter,sans-serif', fontSize: 11, fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.14em', color: 'var(--accent)', marginBottom: 6 }}>
            {eyebrow}
          </p>
        )}
        {/* Titre page : 30px/700 spec IAM */}
        <h2 style={{ fontFamily:'Inter,sans-serif', fontSize: 'var(--fs-page)', fontWeight: 700, letterSpacing: '-0.018em', lineHeight: 1.22, color: 'var(--text-pri)' }}>
          {title}
        </h2>
        {description && (
          <p style={{ fontFamily:'Inter,sans-serif', fontSize: 'var(--fs-body)', lineHeight: 'var(--lh-normal)', color: 'var(--text-sec)', marginTop: 6, maxWidth: 520 }}>
            {description}
          </p>
        )}
      </div>
      {action && <div className="flex items-center gap-2">{action}</div>}
    </div>
  );
}

/* ── StatCard ──
   Palette "signature" par couleur nommée — icône en dégradé plein,
   halo assorti, et liseré de tendance. `value` numérique s'anime
   automatiquement (useCountUp) ; passer une string pour désactiver
   l'animation (ex. "24 580 DH"). */
export const STAT_COLORS = {
  indigo: { from: '#6366F1', to: '#8B5CF6', text: '#6366F1' },
  blue:   { from: '#3B82F6', to: '#2563EB', text: '#2563EB' },
  violet: { from: '#A855F7', to: '#7C3AED', text: '#8B5CF6' },
  green:  { from: '#22C55E', to: '#16A34A', text: '#16A34A' },
  orange: { from: '#FB923C', to: '#F59E0B', text: '#F59E0B' },
  red:    { from: '#F87171', to: '#EF4444', text: '#EF4444' },
} as const;
export type StatColor = keyof typeof STAT_COLORS;

export function StatCard({
  label, value, tone = 'default', hint, icon, color, trend
}: {
  label: string;
  value: React.ReactNode;
  tone?: 'default' | 'good' | 'bad';
  hint?: string;
  icon?: React.ReactNode;
  /** Teinte de l'icône et de la lueur de la carte — reprend la maquette (une couleur par KPI). */
  color?: StatColor;
  /** Variation affichée sous la valeur, ex. "+12 ce mois" / "-8.5% ce mois". Le signe pilote la couleur. */
  trend?: string;
}) {
  const palette = color ? STAT_COLORS[color] : null;
  const valueColor =
    tone === 'good' ? 'var(--badge-good-text)' :
    tone === 'bad'  ? 'var(--badge-bad-text)' :
    'var(--text-pri)';
  const trendUp = trend?.trim().startsWith('+');
  const trendDown = trend?.trim().startsWith('-');
  const isNumeric = typeof value === 'number';
  const animated = useCountUp(isNumeric ? (value as number) : 0);

  return (
    <Card
      className="px-5 py-4 animate-fade-up relative overflow-hidden group"
      style={palette ? { boxShadow: `0 1px 2px rgba(17,20,45,0.04), 0 10px 24px -14px ${palette.from}55` } : undefined}
    >
      {/* Halo décoratif assorti à la couleur du KPI, discret, révélé au survol */}
      {palette && (
        <div
          className="absolute -top-8 -right-8 w-24 h-24 rounded-full pointer-events-none opacity-60 transition-opacity duration-200 group-hover:opacity-90"
          style={{ background: `radial-gradient(circle, ${palette.from}22 0%, transparent 72%)` }}
        />
      )}
      <div className="flex items-start justify-between relative">
        <p style={{ fontFamily:'Inter,sans-serif', fontSize: 11, textTransform: 'uppercase', letterSpacing: '0.09em', fontWeight: 600, marginBottom: 10, color: 'var(--text-ter)' }}>
          {label}
        </p>
        {icon && (
          <span
            className="flex items-center justify-center rounded-xl shrink-0"
            style={
              palette
                ? {
                    width: 34, height: 34,
                    background: `linear-gradient(135deg, ${palette.from} 0%, ${palette.to} 100%)`,
                    boxShadow: `0 4px 12px -2px ${palette.from}77`,
                    color: '#fff'
                  }
                : {
                    width: 30, height: 30,
                    background: 'linear-gradient(135deg, rgba(99,102,241,0.14) 0%, rgba(139,92,246,0.18) 100%)',
                    border: '1px solid rgba(99,102,241,0.20)',
                    color: 'var(--accent)'
                  }
            }
          >
            {icon}
          </span>
        )}
      </div>
      {/* Valeur carte Dashboard : agrandie pour les KPI en tête de tableau de bord */}
      <p
        className="relative"
        style={{ fontFamily:'Inter,sans-serif', fontSize: 24, fontWeight: 700, color: valueColor, fontVariantNumeric: 'tabular-nums', letterSpacing: '-0.02em', lineHeight: 1.25 }}
      >
        {isNumeric ? animated.toLocaleString('fr-FR') : value}
      </p>
      {(trend || hint) && (
        <p className="relative flex items-center gap-1" style={{ fontFamily:'Inter,sans-serif', fontSize: 'var(--fs-table)', marginTop: 4, color: 'var(--text-sec)' }}>
          {trend && (
            <span className="font-semibold" style={{ color: trendUp ? 'var(--badge-good-text)' : trendDown ? 'var(--badge-bad-text)' : 'var(--text-sec)' }}>
              {trend}
            </span>
          )}
          {trend && hint && <span style={{ color: 'var(--text-ter)' }}>·</span>}
          {hint}
        </p>
      )}
    </Card>
  );
}

/* ── Badge ── */
export function Badge({
  tone = 'default', children, className = ''
}: {
  tone?: 'default' | 'good' | 'bad' | 'warn' | 'info';
  children: React.ReactNode;
  className?: string;
}) {
  const styles =
    tone === 'good' ? { background: 'var(--badge-good-bg)', color: 'var(--badge-good-text)', border: '1px solid var(--badge-good-bg)' } :
    tone === 'bad'  ? { background: 'var(--badge-bad-bg)', color: 'var(--badge-bad-text)', border: '1px solid var(--badge-bad-bg)' } :
    tone === 'warn' ? { background: 'var(--badge-warn-bg)', color: 'var(--badge-warn-text)', border: '1px solid var(--badge-warn-bg)' } :
    tone === 'info' ? { background: 'var(--badge-info-bg)', color: 'var(--badge-info-text)', border: '1px solid var(--badge-info-bg)' } :
    { background: 'var(--badge-default-bg)', color: 'var(--badge-default-text)', border: '1px solid var(--border-md)' };
  return (
    <span
      className={`inline-flex items-center px-2.5 py-0.5 rounded-full font-semibold ${className}`}
      style={{ fontSize: 12, ...styles }}
    >
      {children}
    </span>
  );
}

/* ── Button ── */
export function Button({
  children, onClick, variant = 'primary', disabled, type = 'button', className = ''
}: {
  children: React.ReactNode;
  onClick?: () => void;
  variant?: 'primary' | 'secondary' | 'ghost' | 'danger';
  disabled?: boolean;
  type?: 'button' | 'submit';
  className?: string;
}) {
  /* Boutons : 14px / 600 / interligne 1.5 — spec IAM */
  const base =
    'focus-ring inline-flex items-center gap-2 px-4 py-2 transition-all duration-150 disabled:opacity-40 disabled:cursor-not-allowed';

  /* Taille unique 14px/600 pour tous les variants */
  const baseTypo: React.CSSProperties = {
    fontFamily: 'Inter, sans-serif',
    fontSize: 'var(--fs-body)',   /* 14px */
    fontWeight: 600,
    lineHeight: 'var(--lh-normal)',
  };
  const variantStyles: Record<string, React.CSSProperties> = {
    primary:   { ...baseTypo, background: 'var(--grad-btn)', color: 'var(--text-inv)', borderRadius: 'var(--radius-btn)', boxShadow: 'var(--glow-btn)' },
    secondary: { ...baseTypo, background: 'var(--card)', color: 'var(--text-pri)', border: '1px solid var(--border-md)', borderRadius: 10 },
    ghost:     { ...baseTypo, background: 'transparent', color: 'var(--text-sec)', borderRadius: 10 },
    danger:    { ...baseTypo, background: 'rgba(239,68,68,0.10)', color: 'var(--accent-err)', border: '1px solid rgba(239,68,68,0.25)', borderRadius: 'var(--radius-btn)' },
  };

  const hoverClass =
    variant === 'primary' ? 'hover:opacity-92 hover:-translate-y-px hover:shadow-lg' :
    variant === 'danger'  ? 'hover:bg-red-500/15' :
    variant === 'secondary' ? 'hover:bg-black/[0.02]' :
    'hover:brightness-125';

  return (
    <button
      type={type}
      onClick={onClick}
      disabled={disabled}
      className={`${base} ${hoverClass} ${className}`}
      style={variantStyles[variant]}
    >
      {children}
    </button>
  );
}

/* ── Modal ── */
export function Modal({
  open, onClose, title, description, children, width = 'md'
}: {
  open: boolean;
  onClose: () => void;
  title: string;
  description?: string;
  children: React.ReactNode;
  width?: 'sm' | 'md' | 'lg';
}) {
  if (!open) return null;
  const widthClass = width === 'sm' ? 'max-w-sm' : width === 'lg' ? 'max-w-2xl' : 'max-w-lg';
  return (
    <div className="fixed inset-0 z-50 flex items-start sm:items-center justify-center p-4 overflow-y-auto">
      <div className="fixed inset-0 animate-fade-in" style={{ background: 'rgba(8,12,18,0.82)', backdropFilter: 'blur(6px)' }} onClick={onClose} />
      <div
        className={`relative w-full ${widthClass} my-8 rounded-2xl shadow-2xl animate-fade-up`}
        style={{ background: 'var(--card)', border: '1px solid var(--border-md)' }}
      >
        <div className="px-6 pt-5 pb-4" style={{ borderBottom: '1px solid var(--border)' }}>
          <h3 className="font-bold" style={{ fontSize: 'var(--fs-lg)', color: 'var(--text-pri)' }}>{title}</h3>
          {description && <p className="mt-1" style={{ fontSize: 'var(--fs-sm)', color: 'var(--text-sec)' }}>{description}</p>}
        </div>
        {/* Champs de formulaire à l'intérieur des modales — suit le thème courant. */}
        <style>{`
          .modal-body input:not([type=checkbox]):not([type=radio]),
          .modal-body select,
          .modal-body textarea {
            width:100%;
            background:var(--card);
            border:1px solid var(--border-md);
            border-radius:9px;
            padding:9px 12px;
            font-size:14px;
            color:var(--text-pri);
            outline:none;
            transition:border-color .18s, box-shadow .18s;
            appearance:none;
            -webkit-appearance:none;
          }
          .modal-body input::placeholder,
          .modal-body textarea::placeholder { color:var(--text-ter); }
          .modal-body input:focus,
          .modal-body select:focus,
          .modal-body textarea:focus {
            border-color:var(--accent);
            box-shadow:0 0 0 3px rgba(99,102,241,0.16);
          }
          [data-theme="dark"] .modal-body input[type="date"]::-webkit-calendar-picker-indicator {
            filter: invert(1) opacity(0.5);
          }
          /* Options du select dans le dropdown navigateur */
          .modal-body select option,
          .modal-body select optgroup {
            background: var(--select-bg) !important;
            color: var(--text-pri) !important;
          }
          .modal-body select {
            background: var(--select-bg);
            color: var(--text-pri);
          }
          .modal-body label > span,
          .modal-body label > p {
            display:block;
            font-size:11px;
            font-weight:700;
            text-transform:uppercase;
            letter-spacing:0.08em;
            color:var(--text-ter);
            margin-bottom:7px;
          }
        `}</style>
        <div className="px-6 py-5 modal-body">{children}</div>
      </div>
    </div>
  );
}

/* ── EmptyState ── */
export function EmptyState({ title, description, action }: { title: string; description: string; action?: React.ReactNode }) {
  return (
    <Card className="px-8 py-16 text-center animate-fade-up">
      <div className="w-12 h-12 rounded-2xl mx-auto mb-4 flex items-center justify-center"
           style={{ background: 'rgba(99,102,241,0.10)', border: '1px solid rgba(99,102,241,0.20)' }}>
        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="var(--accent)" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
        </svg>
      </div>
      <h3 className="text-base font-semibold" style={{ color: 'var(--text-pri)' }}>{title}</h3>
      <p className="text-sm mt-2 max-w-md mx-auto leading-relaxed" style={{ color: 'var(--text-sec)' }}>{description}</p>
      {action && <div className="mt-5 flex justify-center">{action}</div>}
    </Card>
  );
}
