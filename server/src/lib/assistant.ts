import OpenAI from 'openai';
import type { ChatCompletionTool } from 'openai/resources/chat/completions';
import { and, count, eq, gte, ilike, isNull, lte, or, sql, sum } from 'drizzle-orm';
import { db, facturesTable, lignesTable, lignesFixesTable, usersTable } from '../db.js';

export const ASSISTANT_TOOLS: ChatCompletionTool[] = [
  {
    type: 'function',
    function: {
      name: 'search_factures',
      description:
        "Recherche des factures IAM selon des critères. Utilise ceci pour toute question sur des factures précises, un client, une direction/délégation, ou un statut (payées/impayées).",
      parameters: {
        type: 'object',
        properties: {
          direction: { type: 'string', description: 'Nom de la direction/délégation (recherche partielle, ex: "Casablanca")' },
          statut: { type: 'string', enum: ['reglee', 'impayee'], description: 'Filtrer par statut de paiement' },
          custcode: { type: 'string', description: 'Code client exact ou partiel' },
          montantMin: { type: 'number' },
          montantMax: { type: 'number' },
          limit: { type: 'number', description: 'Nombre max de résultats à retourner (défaut 15, max 30)' }
        }
      }
    }
  },
  {
    type: 'function',
    function: {
      name: 'get_monthly_spending',
      description:
        "Donne le montant total des factures enregistrées pour un mois donné (dépenses). Utilise 'current' pour le mois en cours, 'previous' pour le mois dernier, ou un mois au format YYYY-MM.",
      parameters: {
        type: 'object',
        properties: {
          month: { type: 'string', description: "'current', 'previous', ou 'YYYY-MM'" }
        },
        required: ['month']
      }
    }
  },
  {
    type: 'function',
    function: {
      name: 'get_directions_breakdown',
      description: 'Retourne le classement des directions/délégations par montant total facturé, du plus coûteux au moins coûteux.',
      parameters: { type: 'object', properties: { limit: { type: 'number' } } }
    }
  },
  {
    type: 'function',
    function: {
      name: 'get_platform_summary',
      description:
        "Donne une vue d'ensemble globale de la plateforme : nombre d'utilisateurs, de lignes mobiles, de lignes fixes, de factures, de factures impayées. Utilise ceci pour les questions générales.",
      parameters: { type: 'object', properties: {} }
    }
  },
  {
    type: 'function',
    function: {
      name: 'search_lignes',
      description: 'Recherche des lignes mobiles ou fixes par bénéficiaire, catégorie ou numéro.',
      parameters: {
        type: 'object',
        properties: {
          query: { type: 'string', description: 'Nom de la personne, ICC, IMEI ou ND recherché' },
          type: { type: 'string', enum: ['mobile', 'fixe', 'les_deux'] },
          limit: { type: 'number' }
        }
      }
    }
  }
];

function monthRange(month: string): { start: Date; end: Date; label: string } {
  const now = new Date();
  let year = now.getFullYear();
  let m = now.getMonth(); // 0-based
  if (month === 'previous') {
    m -= 1;
    if (m < 0) {
      m = 11;
      year -= 1;
    }
  } else if (month !== 'current') {
    const match = /^(\d{4})-(\d{2})$/.exec(month);
    if (match) {
      year = Number(match[1]);
      m = Number(match[2]) - 1;
    }
  }
  const start = new Date(year, m, 1);
  const end = new Date(year, m + 1, 1);
  const label = start.toLocaleDateString('fr-FR', { month: 'long', year: 'numeric' });
  return { start, end, label };
}

export async function executeAssistantTool(name: string, input: Record<string, unknown>): Promise<unknown> {
  switch (name) {
    case 'search_factures': {
      const limit = Math.min(Number(input.limit) || 15, 30);
      const conditions = [isNull(facturesTable.deletedAt)];
      if (typeof input.direction === 'string' && input.direction) {
        conditions.push(ilike(facturesTable.delegation, `%${input.direction}%`));
      }
      if (input.statut === 'reglee' || input.statut === 'impayee') {
        conditions.push(eq(facturesTable.statut, input.statut));
      }
      if (typeof input.custcode === 'string' && input.custcode) {
        conditions.push(ilike(facturesTable.custcode, `%${input.custcode}%`));
      }
      if (typeof input.montantMin === 'number') conditions.push(gte(facturesTable.montant, input.montantMin));
      if (typeof input.montantMax === 'number') conditions.push(lte(facturesTable.montant, input.montantMax));

      const where = and(...conditions);
      const [{ value: total }] = await db.select({ value: count() }).from(facturesTable).where(where);
      const [{ value: montantTotal }] = await db.select({ value: sum(facturesTable.montant) }).from(facturesTable).where(where);
      const rows = await db
        .select({
          custcode: facturesTable.custcode,
          refFacture: facturesTable.refFacture,
          nom: facturesTable.nom,
          montant: facturesTable.montant,
          echeance: facturesTable.echeance,
          statut: facturesTable.statut,
          delegation: facturesTable.delegation
        })
        .from(facturesTable)
        .where(where)
        .limit(limit);

      return { totalMatches: Number(total), montantTotal: Number(montantTotal ?? 0), factures: rows };
    }

    case 'get_monthly_spending': {
      const { start, end, label } = monthRange(String(input.month ?? 'current'));
      const [{ value: total, montant }] = await db
        .select({ value: count(), montant: sum(facturesTable.montant) })
        .from(facturesTable)
        .where(and(isNull(facturesTable.deletedAt), gte(facturesTable.updatedAt, start), lte(facturesTable.updatedAt, end)));
      return { mois: label, nombreFactures: Number(total), montantTotal: Number(montant ?? 0) };
    }

    case 'get_directions_breakdown': {
      const limit = Math.min(Number(input.limit) || 10, 20);
      const result = await db.execute<{ direction: string; montant: string; count: string }>(sql`
        SELECT COALESCE(delegation, 'Non renseignée') AS direction, SUM(montant) AS montant, COUNT(*) AS count
        FROM iam.factures WHERE deleted_at IS NULL
        GROUP BY 1 ORDER BY SUM(montant) DESC LIMIT ${limit}
      `);
      return { directions: result.rows.map((r) => ({ direction: r.direction, montant: Number(r.montant), factures: Number(r.count) })) };
    }

    case 'get_platform_summary': {
      const [{ value: usersCount }] = await db.select({ value: count() }).from(usersTable);
      const [{ value: lignesMobiles }] = await db.select({ value: count() }).from(lignesTable).where(isNull(lignesTable.deletedAt));
      const [{ value: lignesFixes }] = await db.select({ value: count() }).from(lignesFixesTable).where(isNull(lignesFixesTable.deletedAt));
      const [{ value: facturesTotal }] = await db.select({ value: count() }).from(facturesTable).where(isNull(facturesTable.deletedAt));
      const [{ value: facturesImpayees }] = await db
        .select({ value: count() })
        .from(facturesTable)
        .where(and(isNull(facturesTable.deletedAt), eq(facturesTable.statut, 'impayee')));
      return {
        utilisateurs: Number(usersCount),
        lignesMobiles: Number(lignesMobiles),
        lignesFixes: Number(lignesFixes),
        facturesTotal: Number(facturesTotal),
        facturesImpayees: Number(facturesImpayees)
      };
    }

    case 'search_lignes': {
      const limit = Math.min(Number(input.limit) || 15, 30);
      const q = typeof input.query === 'string' ? input.query : '';
      const type = (input.type as string) ?? 'les_deux';
      const results: Record<string, unknown> = {};

      if (type !== 'fixe') {
        const cond = q
          ? or(ilike(lignesTable.personne, `%${q}%`), ilike(lignesTable.icc, `%${q}%`), ilike(lignesTable.imei, `%${q}%`))
          : undefined;
        results.lignesMobiles = await db
          .select({ personne: lignesTable.personne, categorie: lignesTable.categorie, icc: lignesTable.icc, affecte: lignesTable.affecte })
          .from(lignesTable)
          .where(cond ? and(isNull(lignesTable.deletedAt), cond) : isNull(lignesTable.deletedAt))
          .limit(limit);
      }
      if (type !== 'mobile') {
        const cond = q
          ? or(ilike(lignesFixesTable.personne, `%${q}%`), ilike(lignesFixesTable.nd, `%${q}%`), ilike(lignesFixesTable.custcode, `%${q}%`))
          : undefined;
        results.lignesFixes = await db
          .select({ nd: lignesFixesTable.nd, personne: lignesFixesTable.personne, delegation: lignesFixesTable.delegation })
          .from(lignesFixesTable)
          .where(cond ? and(isNull(lignesFixesTable.deletedAt), cond) : isNull(lignesFixesTable.deletedAt))
          .limit(limit);
      }
      return results;
    }

    default:
      return { error: `Outil inconnu : ${name}` };
  }
}

let openaiClient: OpenAI | null = null;
export function getOpenAIClient(): OpenAI {
  const rawKey = process.env.OPENAI_API_KEY;
  const key = rawKey?.trim();
  if (!key) {
    throw new Error(
      "L'assistant IA n'est pas configuré : ajoutez OPENAI_API_KEY dans server/.env (voir .env.example)."
    );
  }
  if (!openaiClient) {
    // Diagnostic ponctuel (sans jamais exposer la clé complète) — utile si
    // l'API renvoie une erreur d'authentification malgré une clé qui semble
    // correcte : permet de repérer un espace/retour à la ligne collé par
    // erreur, une clé tronquée, ou un .env non rechargé après modification.
    // eslint-disable-next-line no-console
    console.log(
      `[assistant] Clé API OpenAI chargée : ${key.slice(0, 8)}…${key.slice(-4)} (longueur ${key.length}, ` +
        `${rawKey !== key ? 'espaces détectés et retirés' : 'aucun espace parasite détecté'})`
    );
    openaiClient = new OpenAI({ apiKey: key });
  }
  return openaiClient;
}
