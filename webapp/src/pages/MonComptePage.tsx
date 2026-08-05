import { useEffect, useState } from 'react';
import QRCode from 'qrcode';
import { useTranslation } from 'react-i18next';
import { ShieldCheck, ShieldOff, Loader2, Copy, Check, Globe } from 'lucide-react';
import { api, ApiError } from '../lib/api';
import { useAuth } from '../context/AuthContext';
import { PageHeader, Card, Button } from '../components/ui/Kit';
import { setLanguage } from '../i18n';

export default function MonComptePage() {
  const { t, i18n } = useTranslation();
  const { user, refresh } = useAuth();
  const [enabled, setEnabled] = useState<boolean | null>(null);
  const [error, setError] = useState<string | null>(null);

  // Étape d'activation
  const [setupData, setSetupData] = useState<{ secret: string; otpauthUrl: string; qrDataUrl: string } | null>(null);
  const [enableCode, setEnableCode] = useState('');
  const [copied, setCopied] = useState(false);

  // Désactivation
  const [disableOpen, setDisableOpen] = useState(false);
  const [disableCode, setDisableCode] = useState('');

  const [busy, setBusy] = useState(false);

  useEffect(() => {
    api
      .get<{ enabled: boolean }>('/security/2fa/status')
      .then((res) => setEnabled(res.enabled))
      .catch(() => setEnabled(false));
  }, []);

  const startSetup = async () => {
    setError(null);
    setBusy(true);
    try {
      const res = await api.post<{ secret: string; otpauthUrl: string }>('/security/2fa/setup');
      const qrDataUrl = await QRCode.toDataURL(res.otpauthUrl, { margin: 1, width: 220 });
      setSetupData({ ...res, qrDataUrl });
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'Erreur lors de la génération du secret.');
    } finally {
      setBusy(false);
    }
  };

  const confirmEnable = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!setupData) return;
    setError(null);
    setBusy(true);
    try {
      await api.post('/security/2fa/enable', { secret: setupData.secret, code: enableCode });
      setEnabled(true);
      setSetupData(null);
      setEnableCode('');
      await refresh();
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'Code incorrect.');
    } finally {
      setBusy(false);
    }
  };

  const confirmDisable = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setBusy(true);
    try {
      await api.post('/security/2fa/disable', { code: disableCode });
      setEnabled(false);
      setDisableOpen(false);
      setDisableCode('');
      await refresh();
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'Code incorrect.');
    } finally {
      setBusy(false);
    }
  };

  const copySecret = () => {
    if (!setupData) return;
    navigator.clipboard.writeText(setupData.secret).then(() => {
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    });
  };

  return (
    <div>
      <PageHeader
        eyebrow="Mon compte"
        title="Sécurité de mon compte"
        description={`Connecté en tant que ${user?.displayName || user?.username}.`}
      />

      {error && <p className="text-sm text-signal-roseDark bg-signal-rose/10 rounded-lg px-3 py-2 mb-4">{error}</p>}

      <Card className="p-6 max-w-lg mb-4">
        <div className="flex items-center gap-3 mb-3">
          <span
            className="flex items-center justify-center rounded-xl shrink-0"
            style={{ width: 40, height: 40, background: 'rgba(168,85,247,0.12)', border: '1px solid rgba(168,85,247,0.25)', color: 'var(--accent)' }}
          >
            <Globe size={18} />
          </span>
          <div>
            <p className="text-sm font-semibold" style={{ color: 'var(--text-pri)' }}>{t('language.label')}</p>
            <p className="text-xs mt-0.5" style={{ color: 'var(--text-sec)' }}>Français / العربية</p>
          </div>
        </div>
        <div className="flex gap-2">
          {(['fr', 'ar'] as const).map((lng) => (
            <button
              key={lng}
              onClick={() => setLanguage(lng)}
              className="focus-ring px-4 py-2 rounded-lg text-sm font-medium transition-colors"
              style={{
                background: i18n.language === lng ? 'var(--grad-btn)' : 'var(--glass-bg)',
                border: '1px solid var(--border)',
                color: i18n.language === lng ? 'var(--text-inv)' : 'var(--text-pri)'
              }}
            >
              {t(`language.${lng}`)}
            </button>
          ))}
        </div>
      </Card>

      <Card className="p-6 max-w-lg">
        <div className="flex items-start gap-3 mb-4">
          <span
            className="flex items-center justify-center rounded-xl shrink-0"
            style={{
              width: 40, height: 40,
              background: enabled ? 'rgba(34,197,94,0.12)' : 'rgba(255,255,255,0.05)',
              border: `1px solid ${enabled ? 'rgba(34,197,94,0.3)' : 'var(--border)'}`,
              color: enabled ? 'var(--accent2)' : 'var(--text-ter)'
            }}
          >
            {enabled ? <ShieldCheck size={18} /> : <ShieldOff size={18} />}
          </span>
          <div>
            <p className="text-sm font-semibold" style={{ color: 'var(--text-pri)' }}>Double authentification (2FA)</p>
            <p className="text-xs mt-0.5" style={{ color: 'var(--text-sec)' }}>
              {enabled === null ? 'Chargement…' : enabled ? 'Activée — un code est demandé à chaque connexion.' : 'Désactivée — ajoutez une couche de sécurité supplémentaire.'}
            </p>
          </div>
        </div>

        {enabled === false && !setupData && (
          <Button onClick={startSetup} disabled={busy}>
            {busy ? <Loader2 size={14} className="animate-spin" /> : <ShieldCheck size={14} />}
            Activer la 2FA
          </Button>
        )}

        {setupData && (
          <div className="space-y-4 pt-2" style={{ borderTop: '1px solid var(--border)' }}>
            <p className="text-sm pt-4" style={{ color: 'var(--text-sec)' }}>
              1. Scannez ce QR code avec Google Authenticator, Microsoft Authenticator ou une application équivalente.
            </p>
            <div className="flex justify-center">
              <img src={setupData.qrDataUrl} alt="QR code 2FA" style={{ borderRadius: 12, border: '1px solid var(--border)' }} />
            </div>
            <div>
              <p className="text-xs mb-1" style={{ color: 'var(--text-ter)' }}>Ou saisissez ce code manuellement :</p>
              <div className="flex items-center gap-2">
                <code className="text-xs px-2 py-1 rounded" style={{ background: 'var(--glass-bg)', border: '1px solid var(--border)', color: 'var(--text-pri)' }}>
                  {setupData.secret}
                </code>
                <button onClick={copySecret} className="focus-ring p-1.5 rounded-md" style={{ color: 'var(--text-ter)' }}>
                  {copied ? <Check size={13} /> : <Copy size={13} />}
                </button>
              </div>
            </div>
            <form onSubmit={confirmEnable} className="space-y-3">
              <p className="text-sm" style={{ color: 'var(--text-sec)' }}>2. Entrez le code affiché par l'application pour confirmer :</p>
              <input
                value={enableCode}
                onChange={(e) => setEnableCode(e.target.value.replace(/\D/g, '').slice(0, 6))}
                placeholder="000000"
                inputMode="numeric"
                maxLength={6}
                required
                className="focus-ring rounded-lg border px-3 py-2 text-center text-lg font-bold tracking-widest"
                style={{ borderColor: 'var(--border)', background: 'var(--card)', color: 'var(--text-pri)', width: 160 }}
              />
              <div className="flex gap-2">
                <Button type="submit" disabled={busy || enableCode.length !== 6}>
                  {busy ? <Loader2 size={14} className="animate-spin" /> : null} Confirmer
                </Button>
                <Button type="button" variant="secondary" onClick={() => setSetupData(null)}>Annuler</Button>
              </div>
            </form>
          </div>
        )}

        {enabled === true && !disableOpen && (
          <Button variant="danger" onClick={() => setDisableOpen(true)}>
            <ShieldOff size={14} /> Désactiver la 2FA
          </Button>
        )}

        {disableOpen && (
          <form onSubmit={confirmDisable} className="space-y-3 pt-4" style={{ borderTop: '1px solid var(--border)' }}>
            <p className="text-sm" style={{ color: 'var(--text-sec)' }}>
              Confirmez avec un code actuel de votre application d'authentification :
            </p>
            <input
              value={disableCode}
              onChange={(e) => setDisableCode(e.target.value.replace(/\D/g, '').slice(0, 6))}
              placeholder="000000"
              inputMode="numeric"
              maxLength={6}
              required
              className="focus-ring rounded-lg border px-3 py-2 text-center text-lg font-bold tracking-widest"
              style={{ borderColor: 'var(--border)', background: 'var(--card)', color: 'var(--text-pri)', width: 160 }}
            />
            <div className="flex gap-2">
              <Button type="submit" variant="danger" disabled={busy || disableCode.length !== 6}>
                {busy ? <Loader2 size={14} className="animate-spin" /> : null} Désactiver
              </Button>
              <Button type="button" variant="secondary" onClick={() => setDisableOpen(false)}>Annuler</Button>
            </div>
          </form>
        )}
      </Card>
    </div>
  );
}
