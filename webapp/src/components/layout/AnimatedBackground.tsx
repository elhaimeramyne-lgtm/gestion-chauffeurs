/** Arrière-plan : fond uni en thème clair (par défaut) ; halos "aurora"
 *  dégradés violet/cyan/rose qui dérivent lentement + grille de particules
 *  très subtile en thème sombre (voir lib/theme.ts et les règles CSS
 *  [data-theme="dark"] .aurora-blob / .aurora-decoration dans index.css). */
export default function AnimatedBackground() {
  return (
    <div className="fixed inset-0 -z-10 overflow-hidden pointer-events-none" aria-hidden="true" style={{ background: 'var(--bg)' }}>
      <div
        className="aurora-blob animate-float-slow"
        style={{ width: 520, height: 520, top: '-12%', left: '-8%', background: 'radial-gradient(circle, rgba(168,85,247,0.35) 0%, transparent 70%)' }}
      />
      <div
        className="aurora-blob animate-float-slower"
        style={{ width: 460, height: 460, top: '48%', right: '-10%', background: 'radial-gradient(circle, rgba(34,211,238,0.28) 0%, transparent 70%)' }}
      />
      <div
        className="aurora-blob animate-float-slow"
        style={{ width: 440, height: 440, bottom: '-16%', left: '22%', background: 'radial-gradient(circle, rgba(236,72,153,0.22) 0%, transparent 70%)' }}
      />
      {/* Grille de particules très légère */}
      <div
        className="aurora-decoration absolute inset-0 opacity-40"
        style={{
          backgroundImage: 'radial-gradient(rgba(255,255,255,0.05) 1px, transparent 1px)',
          backgroundSize: '46px 46px'
        }}
      />
      {/* Vignette pour garder le contenu lisible sur les bords */}
      <div className="aurora-decoration absolute inset-0" style={{ background: 'radial-gradient(ellipse at center, transparent 40%, rgba(11,16,35,0.55) 100%)' }} />
    </div>
  );
}
