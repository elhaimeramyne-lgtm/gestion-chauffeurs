import type { FileRole, SheetRule } from '../types';

/** Retrouve la règle de colonnes d'une feuille par rôle + nom de feuille.
 *  On n'utilise plus fileId : il change à chaque réimport, alors que le nom
 *  de la feuille (ex: "Fix") reste stable — la correspondance configurée une
 *  fois s'applique donc automatiquement aux imports suivants, et reste
 *  partagée entre postes une fois stockée côté serveur. */
export function findSheetRule(rules: SheetRule[], role: FileRole, sheetName: string): SheetRule | undefined {
  return rules.find((r) => r.role === role && r.sheetName === sheetName);
}
