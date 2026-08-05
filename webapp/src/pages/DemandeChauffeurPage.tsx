import { useState, useEffect } from 'react';
import { api } from '../lib/api';
import { Loader2, Send, AlertCircle, CheckCircle2, UserRound } from 'lucide-react';
import { PageHeader, Card, Button } from '../components/ui/Kit';

interface OrgNode {
  id: number;
  name: string;
}

const PRIORITES = [
  { value: 'normale' as const, label: 'Normale', color: '#6366F1' },
  { value: 'urgente' as const, label: 'Urgente', color: '#F59E0B' },
  { value: 'critique' as const, label: 'Critique', color: '#EF4444' }
];

export default function DemandeChauffeurPage() {
  const [services, setServices] = useState<OrgNode[]>([]);
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [success, setSuccess] = useState(false);
  const [error, setError] = useState('');

  const [form, setForm] = useState({
    serviceDemandeurId: '' as string,
    demandeurNom: '',
    demandeurTelephone: '',
    priorite: 'normale' as 'normale' | 'urgente' | 'critique',
    observations: ''
  });

  useEffect(() => {
    api.get<{ nodes: OrgNode[] }>('/org/flat')
      .then((res) => setServices(res.nodes ?? []))
      .catch(() => setError('Erreur chargement services'))
      .finally(() => setLoading(false));
  }, []);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setSuccess(false);
    setSubmitting(true);

    try {
      await api.post('/demande-chauffeur', {
        ...form,
        serviceDemandeurId: parseInt(form.serviceDemandeurId, 10)
      });
      setSuccess(true);
      setForm({
        serviceDemandeurId: '',
        demandeurNom: '',
        demandeurTelephone: '',
        priorite: 'normale',
        observations: ''
      });
    } catch (err: any) {
      setError(err?.message ?? 'Erreur lors de la soumission');
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div>
      <PageHeader
        eyebrow="Service de la Logistique et des Moyens Généraux"
        title="Demander un chauffeur"
        description="Soumettez une demande de chauffeur pour un déplacement — un responsable du parc la traitera dans les meilleurs délais."
      />

      <div className="max-w-xl">
        <Card className="p-6">
          {loading ? (
            <div className="flex items-center justify-center py-10">
              <Loader2 size={22} className="animate-spin" style={{ color: 'var(--accent)' }} />
            </div>
          ) : (
            <>
              {success && (
                <div
                  className="mb-4 p-3.5 rounded-lg flex items-center gap-2.5 text-sm"
                  style={{ background: 'var(--badge-good-bg)', color: 'var(--badge-good-text)', border: '1px solid var(--badge-good-bg)' }}
                >
                  <CheckCircle2 size={18} className="shrink-0" />
                  Votre demande a été envoyée avec succès. Un responsable va la traiter.
                </div>
              )}

              {error && (
                <div
                  className="mb-4 p-3.5 rounded-lg flex items-center gap-2.5 text-sm"
                  style={{ background: 'var(--badge-bad-bg)', color: 'var(--badge-bad-text)', border: '1px solid var(--badge-bad-bg)' }}
                >
                  <AlertCircle size={18} className="shrink-0" />
                  {error}
                </div>
              )}

              <form onSubmit={handleSubmit} className="space-y-4">
                <label>
                  <span>Service demandeur *</span>
                  <select
                    required
                    value={form.serviceDemandeurId}
                    onChange={(e) => setForm({ ...form, serviceDemandeurId: e.target.value })}
                  >
                    <option value="">Sélectionner un service…</option>
                    {services.map((s) => (
                      <option key={s.id} value={s.id}>{s.name}</option>
                    ))}
                  </select>
                </label>

                <div className="grid grid-cols-2 gap-3">
                  <label>
                    <span>Votre nom *</span>
                    <input
                      required
                      type="text"
                      value={form.demandeurNom}
                      onChange={(e) => setForm({ ...form, demandeurNom: e.target.value })}
                      placeholder="Nom et prénom"
                    />
                  </label>
                  <label>
                    <span>Téléphone</span>
                    <input
                      type="tel"
                      value={form.demandeurTelephone}
                      onChange={(e) => setForm({ ...form, demandeurTelephone: e.target.value })}
                      placeholder="06XX XX XX XX"
                    />
                  </label>
                </div>

                <div>
                  <span className="block text-[11px] font-bold uppercase tracking-wide mb-1.5" style={{ color: 'var(--text-ter)' }}>
                    Priorité *
                  </span>
                  <div className="grid grid-cols-3 gap-2">
                    {PRIORITES.map(({ value, label, color }) => {
                      const active = form.priorite === value;
                      return (
                        <button
                          key={value}
                          type="button"
                          onClick={() => setForm({ ...form, priorite: value })}
                          className="text-sm font-medium py-2 rounded-lg transition-colors focus-ring"
                          style={{
                            background: active ? `${color}1F` : 'var(--card)',
                            border: `1px solid ${active ? color : 'var(--border-md)'}`,
                            color: active ? color : 'var(--text-sec)'
                          }}
                        >
                          {label}
                        </button>
                      );
                    })}
                  </div>
                </div>

                <label>
                  <span>Observations</span>
                  <textarea
                    value={form.observations}
                    onChange={(e) => setForm({ ...form, observations: e.target.value })}
                    rows={3}
                    placeholder="Motif du déplacement, destination, date souhaitée, informations complémentaires…"
                  />
                </label>

                <Button type="submit" variant="primary" disabled={submitting} className="w-full justify-center">
                  {submitting ? <Loader2 size={15} className="animate-spin" /> : <UserRound size={15} />}
                  {submitting ? 'Envoi en cours…' : 'Demander un chauffeur'}
                </Button>
              </form>
            </>
          )}
        </Card>
      </div>
    </div>
  );
}
