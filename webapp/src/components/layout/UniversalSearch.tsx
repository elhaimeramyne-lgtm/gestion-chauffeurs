import { useEffect, useRef, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Search, Receipt, Smartphone, Landmark, Users, MapPin, ScrollText, X, Car, UserRound, MapPinned } from 'lucide-react';
import { api } from '../../lib/api';

interface SearchResults {
  users: Array<{ id: number; username: string; displayName: string | null; role: string }>;
  factures: Array<{ id: number; custcode: string; refFacture: string; nom: string | null; montant: number; statut: string }>;
  lignes: Array<{ id: number; personne: string | null; icc: string | null; categorie: string }>;
  lignesFixes: Array<{ id: number; nd: string; personne: string | null; custcode: string | null }>;
  directions: string[];
  activity: Array<{ id: number; username: string | null; action: string; entity: string; createdAt: string }>;
  vehicules: Array<{ id: number; immatriculation: string; marque: string; modele: string; statut: string }>;
  chauffeurs: Array<{ id: number; nom: string; telephone: string | null; statut: string }>;
  deplacements: Array<{ id: number; numero: string; objet: string; destination: string | null; statut: string }>;
}

const EMPTY: SearchResults = {
  users: [], factures: [], lignes: [], lignesFixes: [], directions: [], activity: [],
  vehicules: [], chauffeurs: [], deplacements: []
};

/** Barre de recherche universelle façon omnibox : un champ, plusieurs types
 *  de résultats regroupés. Clique sur un résultat → navigue vers la page
 *  correspondante (avec la requête pré-remplie quand la page le supporte). */
export default function UniversalSearch() {
  const [query, setQuery] = useState('');
  const [results, setResults] = useState<SearchResults>(EMPTY);
  const [open, setOpen] = useState(false);
  const ref = useRef<HTMLDivElement>(null);
  const navigate = useNavigate();

  useEffect(() => {
    if (query.trim().length < 2) {
      setResults(EMPTY);
      return;
    }
    const t = setTimeout(() => {
      api
        .get<SearchResults>(`/search?q=${encodeURIComponent(query.trim())}`)
        .then((res) => {
          setResults(res);
          setOpen(true);
        })
        .catch(() => {});
    }, 250);
    return () => clearTimeout(t);
  }, [query]);

  useEffect(() => {
    const onClickOutside = (e: MouseEvent) => {
      if (ref.current && !ref.current.contains(e.target as Node)) setOpen(false);
    };
    document.addEventListener('mousedown', onClickOutside);
    return () => document.removeEventListener('mousedown', onClickOutside);
  }, []);

  const totalResults =
    results.users.length + results.factures.length + results.lignes.length +
    results.lignesFixes.length + results.directions.length + results.activity.length +
    results.vehicules.length + results.chauffeurs.length + results.deplacements.length;

  const goTo = (path: string) => {
    navigate(path);
    setOpen(false);
    setQuery('');
  };

  return (
    <div className="relative" ref={ref}>
      <div
        className="flex items-center gap-2 rounded-full px-3.5 transition-colors"
        style={{ width: '100%', maxWidth: 260, height: 34, background: 'var(--glass-bg)', border: '1px solid var(--border)' }}
      >
        <Search size={14} style={{ color: 'var(--text-ter)', flexShrink: 0 }} />
        <input
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          onFocus={() => query.length >= 2 && setOpen(true)}
          placeholder="Rechercher (facture, ligne, véhicule, mission…)"
          className="bg-transparent border-none outline-none text-xs w-full"
          style={{ color: 'var(--text-pri)' }}
        />
        {query && (
          <button onClick={() => { setQuery(''); setResults(EMPTY); }} style={{ color: 'var(--text-ter)' }}>
            <X size={13} />
          </button>
        )}
      </div>

      {open && (
        <div
          className="absolute left-0 mt-2 z-50 animate-fade-in glass"
          style={{ width: 'min(380px, calc(100vw - 32px))', maxHeight: 460, overflowY: 'auto', borderRadius: 16, background: 'var(--surface)' }}
        >
          {totalResults === 0 ? (
            <p className="px-4 py-8 text-center text-sm" style={{ color: 'var(--text-ter)' }}>
              Aucun résultat pour « {query} ».
            </p>
          ) : (
            <div className="py-2">
              {results.factures.length > 0 && (
                <SearchSection title="Factures" icon={Receipt}>
                  {results.factures.map((f) => (
                    <SearchRow key={f.id} onClick={() => goTo('/factures')}>
                      <span style={{ color: 'var(--text-pri)' }}>{f.refFacture}</span>
                      <span className="text-xs ml-2" style={{ color: 'var(--text-ter)' }}>
                        {f.custcode} · {f.montant.toLocaleString('fr-FR')} DH · {f.statut === 'reglee' ? 'Réglée' : 'Impayée'}
                      </span>
                    </SearchRow>
                  ))}
                </SearchSection>
              )}

              {results.lignes.length > 0 && (
                <SearchSection title="Lignes mobiles" icon={Smartphone}>
                  {results.lignes.map((l) => (
                    <SearchRow key={l.id} onClick={() => goTo('/lignes')}>
                      <span style={{ color: 'var(--text-pri)' }}>{l.personne || l.icc || `Ligne #${l.id}`}</span>
                      <span className="text-xs ml-2" style={{ color: 'var(--text-ter)' }}>{l.categorie}</span>
                    </SearchRow>
                  ))}
                </SearchSection>
              )}

              {results.lignesFixes.length > 0 && (
                <SearchSection title="Lignes fixes" icon={Landmark}>
                  {results.lignesFixes.map((l) => (
                    <SearchRow key={l.id} onClick={() => goTo('/lignes-fixes')}>
                      <span style={{ color: 'var(--text-pri)' }}>{l.nd}</span>
                      <span className="text-xs ml-2" style={{ color: 'var(--text-ter)' }}>{l.personne || l.custcode || ''}</span>
                    </SearchRow>
                  ))}
                </SearchSection>
              )}

              {results.vehicules.length > 0 && (
                <SearchSection title="Parc Automobile" icon={Car}>
                  {results.vehicules.map((v) => (
                    <SearchRow key={v.id} onClick={() => goTo('/logistique/parc-auto')}>
                      <span style={{ color: 'var(--text-pri)' }}>{v.immatriculation}</span>
                      <span className="text-xs ml-2" style={{ color: 'var(--text-ter)' }}>{v.marque} {v.modele}</span>
                    </SearchRow>
                  ))}
                </SearchSection>
              )}

              {results.chauffeurs.length > 0 && (
                <SearchSection title="Chauffeurs" icon={UserRound}>
                  {results.chauffeurs.map((c) => (
                    <SearchRow key={c.id} onClick={() => goTo('/logistique/chauffeurs')}>
                      <span style={{ color: 'var(--text-pri)' }}>{c.nom}</span>
                      {c.telephone && <span className="text-xs ml-2" style={{ color: 'var(--text-ter)' }}>{c.telephone}</span>}
                    </SearchRow>
                  ))}
                </SearchSection>
              )}

              {results.deplacements.length > 0 && (
                <SearchSection title="Déplacements" icon={MapPinned}>
                  {results.deplacements.map((d) => (
                    <SearchRow key={d.id} onClick={() => goTo('/logistique/deplacements')}>
                      <span style={{ color: 'var(--text-pri)' }}>{d.numero}</span>
                      <span className="text-xs ml-2" style={{ color: 'var(--text-ter)' }}>{d.objet}</span>
                    </SearchRow>
                  ))}
                </SearchSection>
              )}

              {results.directions.length > 0 && (
                <SearchSection title="Directions" icon={MapPin}>
                  {results.directions.map((d) => (
                    <SearchRow key={d} onClick={() => goTo('/admin')}>
                      <span style={{ color: 'var(--text-pri)' }}>{d}</span>
                    </SearchRow>
                  ))}
                </SearchSection>
              )}

              {results.users.length > 0 && (
                <SearchSection title="Utilisateurs" icon={Users}>
                  {results.users.map((u) => (
                    <SearchRow key={u.id} onClick={() => goTo('/utilisateurs')}>
                      <span style={{ color: 'var(--text-pri)' }}>{u.displayName || u.username}</span>
                      <span className="text-xs ml-2" style={{ color: 'var(--text-ter)' }}>{u.role}</span>
                    </SearchRow>
                  ))}
                </SearchSection>
              )}

              {results.activity.length > 0 && (
                <SearchSection title="Historique" icon={ScrollText}>
                  {results.activity.map((a) => (
                    <SearchRow key={a.id} onClick={() => goTo('/journal')}>
                      <span style={{ color: 'var(--text-pri)' }}>{a.username ?? 'Système'}</span>
                      <span className="text-xs ml-2" style={{ color: 'var(--text-ter)' }}>{a.entity}</span>
                    </SearchRow>
                  ))}
                </SearchSection>
              )}
            </div>
          )}
        </div>
      )}
    </div>
  );
}

function SearchSection({ title, icon: Icon, children }: { title: string; icon: typeof Receipt; children: React.ReactNode }) {
  return (
    <div className="mb-1">
      <div className="flex items-center gap-1.5 px-4 py-1.5">
        <Icon size={11} style={{ color: 'var(--accent)' }} />
        <span className="text-[10px] font-mono uppercase tracking-widest" style={{ color: 'var(--text-ter)' }}>{title}</span>
      </div>
      {children}
    </div>
  );
}

function SearchRow({ children, onClick }: { children: React.ReactNode; onClick: () => void }) {
  return (
    <button
      onClick={onClick}
      className="focus-ring flex items-center w-full px-4 py-2 text-left text-sm transition-colors hover:bg-[var(--card-hover)]"
    >
      {children}
    </button>
  );
}
