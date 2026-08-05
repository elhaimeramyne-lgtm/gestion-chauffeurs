import { useEffect, useMemo, useState } from 'react';
import { ChevronLeft, ChevronRight, Plus, Trash2 } from 'lucide-react';
import { api, ApiError } from '../lib/api';
import { useAuth } from '../context/AuthContext';
import { PageHeader, Card, Button, Badge, Modal } from '../components/ui/Kit';
import { useTranslation } from 'react-i18next';

type EventKind = 'echeance' | 'paiement' | 'renouvellement' | 'intervention' | 'maintenance' | 'conge' | 'autre' | 'mission_depart' | 'mission_retour';

interface CalendarEvent {
  id: string;
  kind: EventKind;
  title: string;
  date: string; // JJ/MM/AAAA
  detail?: string;
}

const KIND_STYLE: Record<EventKind, { label: string; color: string }> = {
  echeance: { label: 'Échéance', color: 'var(--accent-err)' },
  paiement: { label: 'Paiement', color: 'var(--accent2)' },
  renouvellement: { label: 'Renouvellement', color: '#a855f7' },
  intervention: { label: 'Intervention', color: 'var(--accent-warn)' },
  maintenance: { label: 'Maintenance', color: '#22d3ee' },
  conge: { label: 'Congé', color: '#f472b6' },
  autre: { label: 'Autre', color: '#94a3b8' },
  mission_depart: { label: 'Départ mission', color: '#6366f1' },
  mission_retour: { label: 'Retour mission', color: '#818cf8' }
};

const WEEKDAYS = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];

function toKey(d: number, m: number, y: number): string {
  return `${String(d).padStart(2, '0')}/${String(m).padStart(2, '0')}/${y}`;
}

export default function CalendarPage() {
  const { t } = useTranslation();
  const { canEdit } = useAuth();
  const today = new Date();
  const [year, setYear] = useState(today.getFullYear());
  const [month, setMonth] = useState(today.getMonth()); // 0-based
  const [events, setEvents] = useState<CalendarEvent[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [selectedDay, setSelectedDay] = useState<string | null>(null);

  const [formOpen, setFormOpen] = useState(false);
  const [form, setForm] = useState({ title: '', type: 'autre' as EventKind, date: '', description: '' });

  const load = () => {
    setLoading(true);
    api
      .get<{ events: CalendarEvent[] }>(`/calendar/events?month=${year}-${String(month + 1).padStart(2, '0')}`)
      .then((res) => setEvents(res.events))
      .catch((err) => setError(err instanceof ApiError ? err.message : 'Erreur de chargement.'))
      .finally(() => setLoading(false));
  };

  useEffect(load, [year, month]);

  const eventsByDay = useMemo(() => {
    const map = new Map<string, CalendarEvent[]>();
    for (const e of events) {
      const list = map.get(e.date) ?? [];
      list.push(e);
      map.set(e.date, list);
    }
    return map;
  }, [events]);

  const grid = useMemo(() => {
    const firstOfMonth = new Date(year, month, 1);
    const startWeekday = (firstOfMonth.getDay() + 6) % 7; // lundi = 0
    const daysInMonth = new Date(year, month + 1, 0).getDate();
    const cells: Array<{ day: number | null; key: string | null }> = [];
    for (let i = 0; i < startWeekday; i++) cells.push({ day: null, key: null });
    for (let d = 1; d <= daysInMonth; d++) cells.push({ day: d, key: toKey(d, month + 1, year) });
    return cells;
  }, [year, month]);

  const changeMonth = (delta: number) => {
    let m = month + delta;
    let y = year;
    if (m < 0) { m = 11; y -= 1; }
    if (m > 11) { m = 0; y += 1; }
    setMonth(m);
    setYear(y);
  };

  const monthLabel = new Date(year, month, 1).toLocaleDateString('fr-FR', { month: 'long', year: 'numeric' });
  const todayKey = toKey(today.getDate(), today.getMonth() + 1, today.getFullYear());

  const handleCreate = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      await api.post('/calendar/events', form);
      setFormOpen(false);
      setForm({ title: '', type: 'autre', date: selectedDay ?? '', description: '' });
      load();
    } catch (err) {
      setError(err instanceof ApiError ? err.message : "Erreur lors de la création.");
    }
  };

  const handleDelete = async (id: string) => {
    if (!id.startsWith('custom-')) return; // seuls les événements personnalisés sont supprimables ici
    const realId = id.replace('custom-', '');
    try {
      await api.delete(`/calendar/events/${realId}`);
      load();
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'Erreur lors de la suppression.');
    }
  };

  return (
    <div>
      <PageHeader
        eyebrow={t('calendar.eyebrow')}
        title={t('calendar.title')}
        description={t('calendar.description')}
        action={
          canEdit ? (
            <Button onClick={() => { setForm({ title: '', type: 'autre', date: todayKey, description: '' }); setFormOpen(true); }}>
              <Plus size={14} /> Ajouter un événement
            </Button>
          ) : undefined
        }
      />

      {error && <p className="text-sm text-signal-roseDark bg-signal-rose/10 rounded-lg px-3 py-2 mb-4">{error}</p>}

      <div className="flex flex-wrap items-center gap-3 mb-4">
        <div className="flex items-center gap-2">
          <button onClick={() => changeMonth(-1)} className="focus-ring p-2 rounded-lg" style={{ border: '1px solid var(--border)', color: 'var(--text-sec)' }}>
            <ChevronLeft size={15} />
          </button>
          <p className="text-sm font-semibold capitalize" style={{ color: 'var(--text-pri)', minWidth: 140, textAlign: 'center' }}>
            {monthLabel}
          </p>
          <button onClick={() => changeMonth(1)} className="focus-ring p-2 rounded-lg" style={{ border: '1px solid var(--border)', color: 'var(--text-sec)' }}>
            <ChevronRight size={15} />
          </button>
        </div>
        <div className="flex flex-wrap gap-2 text-xs ml-auto">
          {(Object.entries(KIND_STYLE) as [EventKind, typeof KIND_STYLE[EventKind]][]).map(([k, s]) => (
            <span key={k} className="flex items-center gap-1.5" style={{ color: 'var(--text-sec)' }}>
              <span className="w-2 h-2 rounded-full" style={{ background: s.color }} /> {s.label}
            </span>
          ))}
        </div>
      </div>

      <Card className="p-4">
        <div className="grid grid-cols-7 gap-1 mb-1">
          {WEEKDAYS.map((w) => (
            <div key={w} className="text-center text-xs font-semibold uppercase tracking-wide py-2" style={{ color: 'var(--text-ter)' }}>
              {w}
            </div>
          ))}
        </div>
        <div className="grid grid-cols-7 gap-1">
          {grid.map((cell, i) => {
            if (!cell.day) return <div key={i} />;
            const dayEvents = eventsByDay.get(cell.key!) ?? [];
            const isToday = cell.key === todayKey;
            return (
              <button
                key={i}
                onClick={() => setSelectedDay(cell.key)}
                className="focus-ring flex flex-col items-start p-1.5 rounded-lg text-left transition-colors hover:bg-[var(--card-hover)]"
                style={{
                  minHeight: 74,
                  border: isToday ? '1px solid var(--accent)' : '1px solid var(--border)',
                  background: isToday ? 'rgba(34,211,238,0.06)' : 'transparent'
                }}
              >
                <span className="text-xs font-semibold" style={{ color: isToday ? 'var(--accent)' : 'var(--text-sec)' }}>
                  {cell.day}
                </span>
                <div className="flex flex-wrap gap-1 mt-1">
                  {dayEvents.slice(0, 4).map((e) => (
                    <span key={e.id} className="w-1.5 h-1.5 rounded-full" style={{ background: KIND_STYLE[e.kind].color }} title={e.title} />
                  ))}
                  {dayEvents.length > 4 && <span className="text-[9px]" style={{ color: 'var(--text-ter)' }}>+{dayEvents.length - 4}</span>}
                </div>
              </button>
            );
          })}
        </div>
        {loading && <p className="text-xs mt-3 text-center" style={{ color: 'var(--text-ter)' }}>Chargement…</p>}
      </Card>

      {/* Détail du jour sélectionné */}
      <Modal open={Boolean(selectedDay)} onClose={() => setSelectedDay(null)} title={selectedDay ? `Le ${selectedDay}` : ''} width="sm">
        <div className="space-y-2">
          {(eventsByDay.get(selectedDay ?? '') ?? []).length === 0 && (
            <p className="text-sm" style={{ color: 'var(--text-ter)' }}>Aucun événement ce jour-là.</p>
          )}
          {(eventsByDay.get(selectedDay ?? '') ?? []).map((e) => (
            <div key={e.id} className="flex items-start gap-2.5 px-3 py-2 rounded-lg" style={{ border: '1px solid var(--border)' }}>
              <span className="w-2 h-2 rounded-full shrink-0 mt-1.5" style={{ background: KIND_STYLE[e.kind].color }} />
              <div className="flex-1 min-w-0">
                <p className="text-sm font-medium" style={{ color: 'var(--text-pri)' }}>{e.title}</p>
                {e.detail && <p className="text-xs" style={{ color: 'var(--text-ter)' }}>{e.detail}</p>}
                <Badge>{KIND_STYLE[e.kind].label}</Badge>
              </div>
              {canEdit && e.id.startsWith('custom-') && (
                <button onClick={() => handleDelete(e.id)} className="focus-ring p-1 rounded text-signal-rose" title="Supprimer">
                  <Trash2 size={13} />
                </button>
              )}
            </div>
          ))}
          {canEdit && (
            <Button
              variant="secondary"
              onClick={() => { setForm({ title: '', type: 'autre', date: selectedDay ?? '', description: '' }); setSelectedDay(null); setFormOpen(true); }}
            >
              <Plus size={13} /> Ajouter un événement ce jour
            </Button>
          )}
        </div>
      </Modal>

      {/* Formulaire de création */}
      <Modal open={formOpen} onClose={() => setFormOpen(false)} title="Ajouter un événement" width="sm">
        <form onSubmit={handleCreate} className="space-y-4">
          <label className="block text-xs" style={{ color: 'var(--text-ter)' }}>
            <span>Titre *</span>
            <input
              required
              value={form.title}
              onChange={(e) => setForm((f) => ({ ...f, title: e.target.value }))}
              className="focus-ring mt-1 w-full rounded-lg border px-3 py-2 text-sm"
              style={{ borderColor: 'var(--border)', background: 'var(--card)', color: 'var(--text-pri)' }}
            />
          </label>
          <label className="block text-xs" style={{ color: 'var(--text-ter)' }}>
            <span>Type</span>
            <select
              value={form.type}
              onChange={(e) => setForm((f) => ({ ...f, type: e.target.value as EventKind }))}
              className="focus-ring mt-1 w-full rounded-lg border px-3 py-2 text-sm"
              style={{ borderColor: 'var(--border)', background: 'var(--card)', color: 'var(--text-pri)' }}
            >
              {(['renouvellement', 'intervention', 'maintenance', 'conge', 'autre'] as EventKind[]).map((k) => (
                <option key={k} value={k}>{KIND_STYLE[k].label}</option>
              ))}
            </select>
          </label>
          <label className="block text-xs" style={{ color: 'var(--text-ter)' }}>
            <span>Date (JJ/MM/AAAA) *</span>
            <input
              required
              pattern="\d{2}/\d{2}/\d{4}"
              placeholder="19/07/2026"
              value={form.date}
              onChange={(e) => setForm((f) => ({ ...f, date: e.target.value }))}
              className="focus-ring mt-1 w-full rounded-lg border px-3 py-2 text-sm"
              style={{ borderColor: 'var(--border)', background: 'var(--card)', color: 'var(--text-pri)' }}
            />
          </label>
          <label className="block text-xs" style={{ color: 'var(--text-ter)' }}>
            <span>Description</span>
            <textarea
              value={form.description}
              onChange={(e) => setForm((f) => ({ ...f, description: e.target.value }))}
              rows={2}
              className="focus-ring mt-1 w-full rounded-lg border px-3 py-2 text-sm"
              style={{ borderColor: 'var(--border)', background: 'var(--card)', color: 'var(--text-pri)' }}
            />
          </label>
          <div className="flex justify-end gap-2">
            <Button type="button" variant="secondary" onClick={() => setFormOpen(false)}>Annuler</Button>
            <Button type="submit">Ajouter</Button>
          </div>
        </form>
      </Modal>
    </div>
  );
}
