import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { Lock, User, ShieldCheck, Globe } from 'lucide-react';
import { useAuth } from '../context/AuthContext';
import { ENTRAIDE_LOGO_NEW_B64 } from '../lib/logoNewBase64';
import AnimatedBackground from '../components/layout/AnimatedBackground';
import { setLanguage } from '../i18n';

const inputStyle: React.CSSProperties = {
  width: '100%',
  background: 'var(--bg)',
  border: '1px solid var(--border)',
  borderRadius: 10,
  padding: '10px 12px 10px 38px',
  fontSize: 14,
  color: 'var(--text-pri)',
  outline: 'none',
  transition: 'border-color 200ms ease, box-shadow 200ms ease'
};

export default function LoginPage() {
  const { t, i18n } = useTranslation();
  const { login, verifyTwoFactor, loading } = useAuth();
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [code, setCode] = useState('');
  const [step, setStep] = useState<'credentials' | '2fa'>('credentials');
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    try {
      const res = await login(username, password);
      if (res.requires2FA) setStep('2fa');
    } catch (err) {
      setError(err instanceof Error ? err.message : t('login.genericError'));
    }
  };

  const handleVerify2FA = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    try {
      await verifyTwoFactor(code);
    } catch (err) {
      setError(err instanceof Error ? err.message : t('login.genericError'));
    }
  };

  const handleFocus = (e: React.FocusEvent<HTMLInputElement>) => {
    e.target.style.borderColor = 'var(--accent)';
    e.target.style.boxShadow = '0 0 0 3px rgba(99,102,241,0.16)';
  };
  const handleBlur = (e: React.FocusEvent<HTMLInputElement>) => {
    e.target.style.borderColor = 'var(--border)';
    e.target.style.boxShadow = 'none';
  };

  return (
    <div
      className="min-h-screen flex items-center justify-center px-4"
      style={{ background: 'transparent' }}
    >
      <AnimatedBackground />

      {/* Sélecteur de langue */}
      <div className="fixed top-4 z-20" style={{ insetInlineEnd: 16 }}>
        <div className="flex items-center gap-1 rounded-full p-1" style={{ background: 'var(--glass-bg)', border: '1px solid var(--border)' }}>
          <Globe size={13} style={{ color: 'var(--text-ter)', marginInlineStart: 8 }} />
          {(['fr', 'ar'] as const).map((lng) => (
            <button
              key={lng}
              onClick={() => setLanguage(lng)}
              className="focus-ring px-2.5 py-1 rounded-full text-xs font-medium transition-colors"
              style={{
                background: i18n.language === lng ? 'var(--grad-btn)' : 'transparent',
                color: i18n.language === lng ? 'var(--text-inv)' : 'var(--text-sec)'
              }}
            >
              {t(`language.${lng}`)}
            </button>
          ))}
        </div>
      </div>

      <div className="w-full max-w-sm animate-fade-up relative">
        {/* Logo — centré, grand, sans background */}
        <div className="text-center mb-8">
          <div className="flex items-center justify-center mb-5">
            <img
              src={ENTRAIDE_LOGO_NEW_B64}
              alt="Entraide Nationale"
              style={{
                width: 220,
                height: 'auto',
                objectFit: 'contain',
                filter: 'drop-shadow(0 4px 24px rgba(99,102,241,0.28)) brightness(1.02)',
                display: 'block',
                margin: '0 auto'
              }}
            />
          </div>
          <h1 className="text-2xl font-bold" style={{ color: 'var(--text-pri)' }}>{t('login.title')}</h1>
          <p className="text-sm mt-1" style={{ color: 'var(--text-sec)' }}>{t('login.subtitle')}</p>
        </div>

        {/* Form */}
        {step === 'credentials' ? (
          <form
            onSubmit={handleSubmit}
            className="glass p-6 space-y-4"
            style={{ background: 'var(--card)', borderColor: 'var(--border)' }}
          >
            {/* Username */}
            <label className="block">
              <p className="text-xs font-medium mb-1.5" style={{ color: 'var(--text-sec)' }}>{t('login.username')}</p>
              <div className="relative">
                <User size={15} className="absolute top-1/2 -translate-y-1/2 pointer-events-none" style={{ color: 'var(--text-ter)', insetInlineStart: 12 }} />
                <input
                  autoFocus
                  value={username}
                  onChange={(e) => setUsername(e.target.value)}
                  style={inputStyle}
                  onFocus={handleFocus}
                  onBlur={handleBlur}
                  required
                  autoComplete="username"
                />
              </div>
            </label>

            {/* Password */}
            <label className="block">
              <p className="text-xs font-medium mb-1.5" style={{ color: 'var(--text-sec)' }}>{t('login.password')}</p>
              <div className="relative">
                <Lock size={15} className="absolute top-1/2 -translate-y-1/2 pointer-events-none" style={{ color: 'var(--text-ter)', insetInlineStart: 12 }} />
                <input
                  type="password"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  style={inputStyle}
                  onFocus={handleFocus}
                  onBlur={handleBlur}
                  required
                  autoComplete="current-password"
                />
              </div>
            </label>

            {/* Error */}
            {error && (
              <div
                className="flex items-center gap-2 text-sm rounded-lg px-3 py-2.5"
                style={{ background: 'rgba(239,68,68,0.08)', border: '1px solid rgba(239,68,68,0.2)', color: 'var(--accent-err)' }}
              >
                <span className="shrink-0">⚠</span>
                {error}
              </div>
            )}

            {/* Submit */}
            <button
              type="submit"
              disabled={loading}
              className="focus-ring w-full py-2.5 text-sm font-bold rounded-full transition-all duration-150 disabled:opacity-50"
              style={{ background: 'var(--grad-btn)', color: 'var(--text-inv)', boxShadow: '0 4px 20px rgba(139,92,246,0.35)' }}
            >
              {loading ? t('login.connecting') : t('login.submit')}
            </button>
          </form>
        ) : (
          <form
            onSubmit={handleVerify2FA}
            className="glass p-6 space-y-4"
            style={{ background: 'var(--card)', borderColor: 'var(--border)' }}
          >
            <div className="flex items-center gap-2 mb-1" style={{ color: 'var(--text-pri)' }}>
              <ShieldCheck size={18} style={{ color: 'var(--accent)' }} />
              <p className="text-sm font-semibold">{t('login.twoFactorTitle')}</p>
            </div>
            <p className="text-xs" style={{ color: 'var(--text-sec)' }}>
              {t('login.twoFactorSubtitle')}
            </p>

            <label className="block">
              <div className="relative">
                <input
                  autoFocus
                  value={code}
                  onChange={(e) => setCode(e.target.value.replace(/\D/g, '').slice(0, 6))}
                  style={{ ...inputStyle, paddingInlineStart: 12, textAlign: 'center', letterSpacing: 6, fontSize: 20, fontWeight: 700 }}
                  onFocus={handleFocus}
                  onBlur={handleBlur}
                  placeholder="000000"
                  inputMode="numeric"
                  maxLength={6}
                  required
                />
              </div>
            </label>

            {error && (
              <div
                className="flex items-center gap-2 text-sm rounded-lg px-3 py-2.5"
                style={{ background: 'rgba(239,68,68,0.08)', border: '1px solid rgba(239,68,68,0.2)', color: 'var(--accent-err)' }}
              >
                <span className="shrink-0">⚠</span>
                {error}
              </div>
            )}

            <button
              type="submit"
              disabled={loading || code.length !== 6}
              className="focus-ring w-full py-2.5 text-sm font-bold rounded-full transition-all duration-150 disabled:opacity-50"
              style={{ background: 'var(--grad-btn)', color: 'var(--text-inv)', boxShadow: '0 4px 20px rgba(139,92,246,0.35)' }}
            >
              {loading ? t('login.verifying') : t('login.verify')}
            </button>

            <button
              type="button"
              onClick={() => { setStep('credentials'); setCode(''); setError(null); }}
              className="focus-ring w-full text-xs"
              style={{ color: 'var(--text-ter)' }}
            >
              {t('login.backToLogin')}
            </button>
          </form>
        )}

        {/* Mention organisationnelle en bas, centrée */}
        <p
          className="text-center mt-6 px-2"
          style={{ fontSize: 11, color: 'var(--text-ter)', lineHeight: 1.6 }}
        >
          Division du Patrimoine et de la Logistique (DPL)<br />
          Service de la Logistique et des Moyens Généraux
        </p>
      </div>
    </div>
  );
}
