import { useEffect, useState } from 'react';
import { CheckCircle2 } from 'lucide-react';
import type { ColumnMapping, CustomFieldDef, FieldKey, ParsedFile, ParsedSheet, SheetRule } from '../../types';
import { FIELD_LABELS } from '../../types';
import { guessColumnForCustomLabel, guessFieldForHeader } from '../../lib/excel';
import { Card, Badge } from '../ui/Kit';
import { useAuth } from '../../context/AuthContext';

const FIELD_ORDER: FieldKey[] = ['refFacture', 'montant', 'echeance', 'custcode', 'nom', 'produit'];
const REQUIRED_FIELDS: FieldKey[] = ['refFacture'];

function autoSuggestMapping(headers: string[], customFields: CustomFieldDef[]): ColumnMapping {
  const mapping: ColumnMapping = {
    refFacture: null,
    montant: null,
    echeance: null,
    custcode: null,
    nom: null,
    produit: null,
    custom: {}
  };
  for (const header of headers) {
    const field = guessFieldForHeader(header);
    if (field && !mapping[field]) mapping[field] = header;
  }
  for (const cf of customFields) {
    mapping.custom[cf.id] = guessColumnForCustomLabel(headers, cf.label);
  }
  return mapping;
}

export default function ColumnMapper({
  file,
  sheet,
  customFields,
  existingRule,
  onSave
}: {
  file: ParsedFile;
  sheet: ParsedSheet;
  customFields: CustomFieldDef[];
  existingRule?: SheetRule;
  onSave: (rule: SheetRule) => void;
}) {
  const { canEdit } = useAuth();

  const [mapping, setMapping] = useState<ColumnMapping>(
    existingRule?.mapping
      ? { ...existingRule.mapping, custom: existingRule.mapping.custom ?? {} }
      : autoSuggestMapping(sheet.headers, customFields)
  );

  // Si de nouveaux champs personnalisés sont créés après coup (ou renommés),
  // on complète la correspondance avec une suggestion automatique sans
  // écraser les choix déjà faits par l'utilisateur.
  useEffect(() => {
    setMapping((prev) => {
      let changed = false;
      const nextCustom = { ...prev.custom };
      for (const cf of customFields) {
        if (!(cf.id in nextCustom)) {
          nextCustom[cf.id] = guessColumnForCustomLabel(sheet.headers, cf.label);
          changed = true;
        }
      }
      return changed ? { ...prev, custom: nextCustom } : prev;
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [customFields]);

  useEffect(() => {
    onSave({ fileId: file.id, fileName: file.fileName, role: file.role, sheetName: sheet.sheetName, mapping });
    // On sauvegarde automatiquement dès qu'une correspondance change, y compris la
    // suggestion initiale, pour que la comparaison dispose toujours d'une règle.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [mapping]);

  const isConfigured = REQUIRED_FIELDS.every((f) => Boolean(mapping[f]));

  return (
    <Card className="p-5">
      <div className="flex items-center justify-between gap-3 mb-4">
        <div>
          <p className="text-sm font-semibold" style={{ color: 'var(--text-pri)' }}>{sheet.sheetName}</p>
          <p className="text-xs" style={{ color: 'var(--text-ter)' }}>{file.fileName}</p>
        </div>
        {isConfigured ? (
          <Badge tone="good">
            <CheckCircle2 size={12} className="mr-1 inline" /> Prête
          </Badge>
        ) : (
          <Badge tone="bad">Référence facture manquante</Badge>
        )}
      </div>

      <div className="grid sm:grid-cols-2 gap-3">
        {FIELD_ORDER.map((field) => (
          <label key={field} className="text-xs" style={{ color: 'var(--text-sec)' }}>
            <span className="flex items-center gap-1">
              {FIELD_LABELS[field]}
              {REQUIRED_FIELDS.includes(field) && <span className="text-signal-rose">*</span>}
            </span>
            <select
              value={mapping[field] ?? ''}
              disabled={!canEdit}
              onChange={(e) =>
                setMapping((prev) => ({ ...prev, [field]: e.target.value || null }))
              }
              className="dark-input focus-ring mt-1 disabled:opacity-50"
            >
              <option value="">— Non utilisée —</option>
              {sheet.headers.map((h) => (
                <option key={h} value={h}>
                  {h}
                </option>
              ))}
            </select>
          </label>
        ))}
      </div>

      {customFields.length > 0 && (
        <div className="mt-4 pt-4" style={{ borderTop: '1px solid var(--border)' }}>
          <p className="text-[11px] font-medium uppercase tracking-wide mb-2.5" style={{ color: 'var(--text-ter)' }}>
            Champs personnalisés
          </p>
          <div className="grid sm:grid-cols-2 gap-3">
            {customFields.map((cf) => (
              <label key={cf.id} className="text-xs" style={{ color: 'var(--text-sec)' }}>
                <span className="flex items-center gap-1">
                  {cf.label}
                  {cf.useAsMatchKey && (
                    <span
                      className="text-signal-teal text-[10px] font-medium"
                      title="Utilisé comme clé de rapprochement"
                    >
                      (clé)
                    </span>
                  )}
                </span>
                <select
                  value={mapping.custom[cf.id] ?? ''}
                  disabled={!canEdit}
                  onChange={(e) =>
                    setMapping((prev) => ({
                      ...prev,
                      custom: { ...prev.custom, [cf.id]: e.target.value || null }
                    }))
                  }
                  className="dark-input focus-ring mt-1 disabled:opacity-50"
                >
                  <option value="">— Non utilisée —</option>
                  {sheet.headers.map((h) => (
                    <option key={h} value={h}>
                      {h}
                    </option>
                  ))}
                </select>
              </label>
            ))}
          </div>
        </div>
      )}
    </Card>
  );
}
