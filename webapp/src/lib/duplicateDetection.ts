/** Détection de doublons à l'import : compare les lignes importées entre
 *  elles (doublons internes au fichier) ET avec les données déjà en base
 *  (doublons contre l'existant), sur une clé donnée (ICC, IMEI ou ND selon
 *  le module). Ne bloque rien — fournit juste l'information pour que
 *  l'utilisateur décide en connaissance de cause. */
export interface DuplicateCheckResult<T> {
  /** Lignes sans doublon détecté — prêtes à importer directement. */
  clean: T[];
  /** Lignes en double avec une ligne déjà existante en base. */
  duplicatesOfExisting: Array<{ row: T; matchKey: string }>;
  /** Lignes en double entre elles, à l'intérieur du fichier importé
   *  (seule la première occurrence de chaque groupe est gardée dans `clean`). */
  duplicatesWithinFile: Array<{ row: T; matchKey: string }>;
}

/** @param rows Lignes tout juste parsées depuis le fichier Excel
 *  @param existing Lignes déjà présentes (mobiles, fixes...) pour comparaison
 *  @param keyOf Extrait la clé de comparaison d'une ligne (retourne null si non comparable) */
export function detectDuplicates<T>(
  rows: T[],
  existing: T[],
  keyOf: (row: T) => string | null
): DuplicateCheckResult<T> {
  const existingKeys = new Set(
    existing.map(keyOf).filter((k): k is string => Boolean(k))
  );

  const seenInFile = new Set<string>();
  const clean: T[] = [];
  const duplicatesOfExisting: Array<{ row: T; matchKey: string }> = [];
  const duplicatesWithinFile: Array<{ row: T; matchKey: string }> = [];

  for (const row of rows) {
    const key = keyOf(row);
    if (!key) {
      clean.push(row); // pas de clé exploitable : impossible de vérifier, on laisse passer
      continue;
    }
    if (existingKeys.has(key)) {
      duplicatesOfExisting.push({ row, matchKey: key });
      continue;
    }
    if (seenInFile.has(key)) {
      duplicatesWithinFile.push({ row, matchKey: key });
      continue;
    }
    seenInFile.add(key);
    clean.push(row);
  }

  return { clean, duplicatesOfExisting, duplicatesWithinFile };
}
