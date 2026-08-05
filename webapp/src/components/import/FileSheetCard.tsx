import { useState } from 'react';
import { ChevronDown, ChevronUp, Trash2, FileSpreadsheet } from 'lucide-react';
import type { ParsedFile } from '../../types';
import { Card, Badge, Button } from '../ui/Kit';

export default function FileSheetCard({ file, onRemove }: { file: ParsedFile; onRemove: (id: string) => void }) {
  const [expandedSheet, setExpandedSheet] = useState<string | null>(file.sheets[0]?.sheetName ?? null);

  return (
    <div
      className="rounded-2xl p-4"
      style={{ background: 'var(--card)', border: '1px solid var(--border)' }}
    >
      {/* File header */}
      <div className="flex items-start justify-between gap-3 mb-3">
        <div className="flex items-start gap-3 min-w-0">
          <div
            className="flex items-center justify-center rounded-xl shrink-0 mt-0.5"
            style={{ width: 34, height: 34, background: 'rgba(99,102,241,0.1)' }}
          >
            <FileSpreadsheet size={16} style={{ color: 'var(--accent)' }} />
          </div>
          <div className="min-w-0">
            <p className="font-semibold truncate" style={{ fontSize: 14, color: 'var(--text-pri)' }}>
              {file.fileName}
            </p>
            <p style={{ fontSize: 12, color: 'var(--text-ter)', marginTop: 2 }}>
              {file.sheets.length} feuille(s) · importé le {new Date(file.importedAt).toLocaleTimeString('fr-FR')}
            </p>
          </div>
        </div>
        <button
          onClick={() => onRemove(file.id)}
          aria-label="Retirer ce fichier"
          className="tbl-btn danger focus-ring shrink-0"
        >
          <Trash2 size={15} />
        </button>
      </div>

      {/* Sheets */}
      <div className="space-y-1.5">
        {file.sheets.map((sheet) => {
          const isOpen = expandedSheet === sheet.sheetName;
          return (
            <div
              key={sheet.sheetName}
              className="rounded-xl overflow-hidden"
              style={{ border: '1px solid var(--border)' }}
            >
              <button
                onClick={() => setExpandedSheet(isOpen ? null : sheet.sheetName)}
                className="focus-ring w-full flex items-center justify-between px-3.5 py-2.5 text-left transition-colors"
                style={{ background: isOpen ? 'rgba(99,102,241,0.05)' : 'rgba(255,255,255,0.03)' }}
              >
                <span style={{ fontSize: 13, fontWeight: 600, color: 'var(--text-pri)' }}>
                  {sheet.sheetName}
                </span>
                <span className="flex items-center gap-2">
                  <Badge>{sheet.rowCount} lignes</Badge>
                  <Badge>{sheet.headers.length} colonnes</Badge>
                  {isOpen
                    ? <ChevronUp size={14} style={{ color: 'var(--text-ter)' }} />
                    : <ChevronDown size={14} style={{ color: 'var(--text-ter)' }} />
                  }
                </span>
              </button>

              {isOpen && (
                <div className="overflow-x-auto" style={{ borderTop: '1px solid var(--border)' }}>
                  <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: 12 }}>
                    <thead>
                      <tr style={{ background: 'var(--bg)', borderBottom: '1px solid var(--border)' }}>
                        {sheet.headers.map((h) => (
                          <th key={h} style={{
                            padding: '7px 12px', textAlign: 'left', whiteSpace: 'nowrap',
                            fontFamily: 'monospace', fontWeight: 600, color: 'var(--text-ter)',
                            fontSize: 11, textTransform: 'uppercase', letterSpacing: '0.06em'
                          }}>
                            {h}
                          </th>
                        ))}
                      </tr>
                    </thead>
                    <tbody>
                      {sheet.rows.slice(0, 5).map((row, i) => (
                        <tr key={i} style={{ borderBottom: '1px solid var(--border)' }}>
                          {sheet.headers.map((h) => (
                            <td key={h} style={{
                              padding: '6px 12px', whiteSpace: 'nowrap',
                              color: 'var(--text-sec)'
                            }}>
                              {formatCell(row[h])}
                            </td>
                          ))}
                        </tr>
                      ))}
                    </tbody>
                  </table>
                  {sheet.rowCount > 5 && (
                    <p style={{ fontSize: 12, color: 'var(--text-ter)', padding: '6px 12px' }}>
                      … et {sheet.rowCount - 5} autres lignes
                    </p>
                  )}
                </div>
              )}
            </div>
          );
        })}
      </div>
    </div>
  );
}

function formatCell(value: unknown): string {
  if (value === null || value === undefined) return '—';
  if (value instanceof Date) return value.toLocaleDateString('fr-FR');
  return String(value);
}
