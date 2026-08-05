import { useEffect, useState } from 'react';

export default function SplashScreen({ onDone }: { onDone: () => void }) {
  const [exiting, setExiting] = useState(false);
  const [reducedMotion, setReducedMotion] = useState(false);

  useEffect(() => {
    const mq = window.matchMedia('(prefers-reduced-motion: reduce)');
    setReducedMotion(mq.matches);
  }, []);

  const handleExitAnimationEnd = () => {
    if (exiting) onDone();
  };

  const enter = () => {
    if (reducedMotion) onDone();
    else setExiting(true);
  };

  return (
    <div
      onAnimationEnd={handleExitAnimationEnd}
      className={`splash-root ${exiting ? 'splash-root-exit' : ''}`}
    >
      <style>{`
        .splash-root {
          position: fixed;
          inset: 0;
          z-index: 100;
          display: flex;
          align-items: center;
          justify-content: center;
          flex-direction: column;
          background: radial-gradient(circle at 50% 32%, #1c2b27 0%, #0c1214 55%, #050708 100%);
          perspective: 1400px;
          overflow: hidden;
        }
        .splash-root-exit { animation: splashOut 0.6s ease-in forwards; }
        @keyframes splashOut {
          to { opacity: 0; transform: scale(1.06); }
        }

        .splash-ring {
          position: absolute;
          width: 820px;
          height: 820px;
          border-radius: 9999px;
          background: conic-gradient(from 0deg, rgba(56,189,155,0.22), rgba(56,189,155,0) 30%, rgba(56,189,155,0.16) 60%, rgba(56,189,155,0) 100%);
          animation: ${reducedMotion ? 'none' : 'splashSpin 14s linear infinite'};
          filter: blur(2px);
        }
        @keyframes splashSpin {
          to { transform: rotate(360deg); }
        }

        .splash-glow {
          position: absolute;
          width: 420px;
          height: 420px;
          border-radius: 9999px;
          background: radial-gradient(circle, rgba(72,207,173,0.35) 0%, rgba(72,207,173,0.08) 45%, rgba(72,207,173,0) 72%);
          filter: blur(4px);
        }

        .splash-stage {
          position: relative;
          transform-style: preserve-3d;
        }

        .splash-logo-wrap {
          transform-style: preserve-3d;
          animation: ${reducedMotion ? 'none' : 'splashIn 1.3s cubic-bezier(0.16, 1, 0.3, 1) forwards'};
          opacity: ${reducedMotion ? 1 : 0};
        }
        @keyframes splashIn {
          0%   { opacity: 0; transform: rotateY(-130deg) rotateX(12deg) scale(0.5) translateY(50px); }
          55%  { opacity: 1; transform: rotateY(12deg) rotateX(-6deg) scale(1.06) translateY(-8px); }
          75%  { transform: rotateY(-5deg) rotateX(2deg) scale(0.99) translateY(2px); }
          100% { opacity: 1; transform: rotateY(0deg) rotateX(0deg) scale(1) translateY(0px); }
        }

        .splash-logo-float {
          animation: ${reducedMotion ? 'none' : 'splashFloat 3.4s ease-in-out 1.3s infinite'};
        }
        @keyframes splashFloat {
          0%, 100% { transform: translateY(0px) rotateY(0deg); }
          50% { transform: translateY(-10px) rotateY(6deg); }
        }

        .splash-logo-img {
          position: relative;
          width: 340px;
          height: 340px;
          object-fit: contain;
          filter:
            drop-shadow(0 30px 40px rgba(0,0,0,0.6))
            drop-shadow(0 2px 6px rgba(0,0,0,0.35))
            contrast(1.22) saturate(1.35) brightness(1.06);
        }

        .splash-shadow {
          width: 190px;
          height: 26px;
          margin: 4px auto 0;
          border-radius: 9999px;
          background: radial-gradient(ellipse at center, rgba(0,0,0,0.5) 0%, rgba(0,0,0,0) 72%);
          animation: ${reducedMotion ? 'none' : 'splashShadow 3.4s ease-in-out 1.3s infinite'};
        }
        @keyframes splashShadow {
          0%, 100% { transform: scale(1); opacity: 0.6; }
          50% { transform: scale(0.8); opacity: 0.38; }
        }

        .splash-text {
          text-align: center;
          margin-top: 22px;
          opacity: 0;
          animation: ${reducedMotion ? 'splashTextIn 0.01s forwards' : 'splashTextIn 0.8s ease-out 1.05s forwards'};
        }
        @keyframes splashTextIn {
          from { opacity: 0; transform: translateY(10px); }
          to { opacity: 1; transform: translateY(0); }
        }

        .splash-eyebrow {
          font-family: ui-monospace, monospace;
          font-size: 12px;
          letter-spacing: 0.3em;
          color: #57cba8;
          margin-bottom: 8px;
        }
        .splash-title {
          font-size: 26px;
          font-weight: 800;
          color: #fbfbfa;
          letter-spacing: 0.01em;
        }

        .splash-btn {
          position: relative;
          margin-top: 34px;
          padding: 15px 52px;
          font-size: 14px;
          font-weight: 800;
          letter-spacing: 0.16em;
          text-transform: uppercase;
          color: #f4fffb;
          background: linear-gradient(180deg, #35c39c 0%, #219677 55%, #157a61 100%);
          border: none;
          border-radius: 999px;
          cursor: pointer;
          box-shadow:
            0 7px 0 #0d5c49,
            0 14px 22px rgba(0,0,0,0.5),
            inset 0 1px 0 rgba(255,255,255,0.35);
          transform: translateY(0);
          transition: transform 0.12s ease, box-shadow 0.12s ease;
          opacity: 0;
          animation: ${reducedMotion ? 'splashTextIn 0.01s forwards' : 'splashTextIn 0.8s ease-out 1.35s forwards'};
        }
        .splash-btn:hover {
          transform: translateY(-2px);
          box-shadow:
            0 9px 0 #0d5c49,
            0 18px 26px rgba(0,0,0,0.55),
            inset 0 1px 0 rgba(255,255,255,0.4);
        }
        .splash-btn:active {
          transform: translateY(6px);
          box-shadow:
            0 1px 0 #0d5c49,
            0 4px 10px rgba(0,0,0,0.4),
            inset 0 1px 0 rgba(255,255,255,0.25);
        }
        .splash-btn:focus-visible {
          outline: 2px solid #a8f0da;
          outline-offset: 3px;
        }
      `}</style>

      <div className="splash-ring" />
      <div className="splash-glow" />

      <div className="splash-stage">
        <div className="splash-logo-wrap">
          <div className="splash-logo-float">
            <img src="/assets/entraide-logo.png" alt="Entraide Nationale" className="splash-logo-img" />
            <div className="splash-shadow" />
          </div>
        </div>
      </div>

      <div className="splash-text">
        <p className="splash-eyebrow">ENTRAIDE NATIONALE</p>
        <p className="splash-title">Facturation IAM</p>
      </div>

      <button type="button" className="splash-btn" onClick={enter}>
        Entrer
      </button>
    </div>
  );
}
