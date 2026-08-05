import { useMemo, useState } from 'react';
import { Search, Fuel, AlertTriangle, CreditCard, Wallet, Info } from 'lucide-react';
import { PageHeader, Card, StatCard, Badge, EmptyState } from '../components/ui/Kit';
import { useParcAuto } from '../context/ParcAutoContext';
import { CARBURANT_LABELS } from '../types/parcAuto';

/** État du solde Jawaz par rapport au seuil d'alerte configuré (même logique que Parc Automobile). */
function jawazEtat(solde: number, seuil: number): { label: string; tone: 'good' | 'warn' | 'bad' } {
  if (solde <= 0) return { label: 'Vide', tone: 'bad' };
  if (solde < seuil) return { label: 'Solde bas', tone: 'bad' };
  if (solde < seuil * 2) return { label: 'À surveiller', tone: 'warn' };
  return { label: 'OK', tone: 'good' };
}

export default function CarburantPage() {
  const { vehicules, loading } = useParcAuto();
  const [search, setSearch] = useState('');

  const avecJawaz = useMemo(
    () => vehicules.filter((v) => v.jawazNumero).filter((v) => {
      if (!search.trim()) return true;
      const s = search.toLowerCase();
      return v.immatriculation.toLowerCase().includes(s) || v.marque.toLowerCase().includes(s) || v.modele.toLowerCase().includes(s);
    }),
    [vehicules, search]
  );

  const soldeTotal = useMemo(() => vehicules.reduce((sum, v) => sum + (v.jawazNumero ? v.jawazSolde : 0), 0), [vehicules]);
  const alertesBasses = useMemo(() => vehicules.filter((v) => v.jawazNumero && v.jawazSolde < v.jawazSeuilAlerte), [vehicules]);
  const sansCarte = useMemo(() => vehicules.filter((v) => !v.jawazNumero), [vehicules]);

  return (
    <div>
      <PageHeader
        eyebrow="Service de la Logistique et des Moyens Généraux"
        title="Carburant"
        description="Suivi des cartes carburant (Jawaz) et des soldes de l'ensemble du parc."
      />

      <div className="grid grid-cols-2 md:grid-cols-4 gap-3 mb-6">
        <StatCard label="Véhicules avec carte" value={vehicules.filter((v) => v.jawazNumero).length} icon={<CreditCard size={16} />} color="blue" />
        <StatCard label="Solde cumulé" value={`${soldeTotal.toLocaleString('fr-FR')} DH`} icon={<Wallet size={16} />} color="green" />
        <StatCard label="Soldes bas" value={alertesBasses.length} icon={<AlertTriangle size={16} />} color={alertesBasses.length > 0 ? 'red' : 'violet'} />
        <StatCard label="Sans carte Jawaz" value={sansCarte.length} icon={<Fuel size={16} />} color="orange" />
      </div>

      <div className="flex items-start gap-2 text-xs rounded-lg px-3 py-2.5 mb-5" style={{ color: 'var(--text-sec)', background: 'var(--glass-bg)', border: '1px solid var(--border)' }}>
        <Info size={14} className="shrink-0 mt-0.5" style={{ color: 'var(--accent)' }} />
        <span>
          Cette page reprend les soldes Jawaz enregistrés sur chaque véhicule. Le suivi de la consommation détaillée et du coût mensuel par trajet
          nécessite d'enregistrer chaque plein (nouvelle fonctionnalité à ajouter séparément si vous le souhaitez).
        </span>
      </div>

      <div className="flex flex-wrap items-center gap-2 mb-4">
        <div className="relative flex-1 min-w-48 max-w-72">
          <Search size={13} className="absolute left-3 top-1/2 -translate-y-1/2" style={{ color: 'var(--text-ter)' }} />
          <input
            value={search} onChange={(e) => setSearch(e.target.value)}
            placeholder="Immatriculation, marque, modèle…"
            className="w-full text-sm pl-9 pr-3 py-2 rounded-xl outline-none"
            style={{ background: 'var(--glass-bg)', border: '1px solid var(--border)', color: 'var(--text-pri)' }}
          />
        </div>
      </div>

      {!loading && avecJawaz.length === 0 ? (
        <EmptyState
          title="Aucune carte carburant"
          description="Aucun véhicule avec carte Jawaz ne correspond à la recherche."
        />
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-4">
          {avecJawaz.map((v) => {
            const etat = jawazEtat(v.jawazSolde, v.jawazSeuilAlerte);
            const pct = v.jawazSeuilAlerte > 0 ? Math.min(100, Math.round((v.jawazSolde / (v.jawazSeuilAlerte * 3)) * 100)) : 100;
            const barColor = etat.tone === 'good' ? '#22C55E' : etat.tone === 'warn' ? '#F59E0B' : '#EF4444';
            return (
              <Card key={v.id} className="p-4">
                <div className="flex items-start justify-between mb-2">
                  <div>
                    <p className="text-sm font-bold font-mono" style={{ color: 'var(--text-pri)' }}>{v.immatriculation}</p>
                    <p className="text-xs" style={{ color: 'var(--text-sec)' }}>{v.marque} {v.modele} · {CARBURANT_LABELS[v.carburant]}</p>
                  </div>
                  <Badge tone={etat.tone}>{etat.label}</Badge>
                </div>

                <div className="flex items-baseline justify-between mt-3">
                  <span className="text-lg font-bold" style={{ color: 'var(--text-pri)' }}>{v.jawazSolde.toLocaleString('fr-FR')} DH</span>
                  <span className="text-xs" style={{ color: 'var(--text-ter)' }}>seuil {v.jawazSeuilAlerte.toLocaleString('fr-FR')} DH</span>
                </div>
                <div className="w-full h-1.5 rounded-full mt-2 overflow-hidden" style={{ background: 'var(--bg)' }}>
                  <div className="h-full rounded-full transition-all" style={{ width: `${pct}%`, background: barColor }} />
                </div>

                <div className="flex items-center justify-between mt-3 pt-3 text-xs" style={{ borderTop: '1px solid var(--border)', color: 'var(--text-ter)' }}>
                  <span>Carte {v.jawazNumero}</span>
                  {v.jawazDerniereRecharge && <span>Recharge {v.jawazDerniereRecharge}</span>}
                </div>
              </Card>
            );
          })}
        </div>
      )}

      {sansCarte.length > 0 && (
        <Card className="p-4 mt-6">
          <p className="text-xs font-semibold mb-2" style={{ color: 'var(--text-sec)' }}>Véhicules sans carte Jawaz enregistrée</p>
          <div className="flex flex-wrap gap-1.5">
            {sansCarte.map((v) => (
              <Badge key={v.id} tone="default">{v.immatriculation}</Badge>
            ))}
          </div>
        </Card>
      )}
    </div>
  );
}
