/**
 * Chauffeurs — répertoire indépendant, géré manuellement par le Service
 * Logistique (voir server/src/schema/chauffeurs.ts).
 *
 * Le « véhicule habituel » d'un chauffeur reste porté par la colonne
 * vehicules.chauffeur_attitre_id (source unique de vérité) : cette route
 * orchestre son (dés)affectation via syncVehiculeHabituel() pour que la
 * fiche chauffeur puisse malgré tout exposer/éditer ce champ directement.
 */
import { Router } from 'express';
import { z } from 'zod';
import { and, eq, ilike, isNull, isNotNull, ne, or } from 'drizzle-orm';
import multer from 'multer';
import path from 'path';
import fs from 'fs';
import { db, chauffeursTable, usersTable, vehiculesTable } from '../db.js';
import { requireAuth, requirePermission } from '../middleware/auth.js';
import { hashPassword } from '../lib/auth.js';
import { assignVehicule, unassignVehicule } from '../lib/affectations.js';
import type { ChauffeurRow } from '../schema/chauffeurs.js';

const router = Router();
router.use(requireAuth);

type ChauffeurStatut = ChauffeurRow['statut'];
type VehiculeResume = { id: number; immatriculation: string; marque: string; modele: string };

/* ── Upload photo / documents (CIN, permis, certificat médical) ─────── */
const UPLOAD_BASE = path.join(process.cwd(), 'uploads', 'chauffeurs');
const storage = multer.diskStorage({
  destination: (_req, _file, cb) => {
    fs.mkdirSync(UPLOAD_BASE, { recursive: true });
    cb(null, UPLOAD_BASE);
  },
  filename: (_req, file, cb) => {
    const ts = Date.now();
    const safe = file.originalname.replace(/[^a-zA-Z0-9._-]/g, '_');
    cb(null, `${ts}-${safe}`);
  },
});
const upload = multer({ storage, limits: { fileSize: 10 * 1024 * 1024 } }); // 10 MB max

/* ── HELPER : véhicule habituel (source de vérité = vehicules.chauffeur_attitre_id) */
async function loadVehiculesHabituels(): Promise<Map<number, VehiculeResume>> {
  const rows = await db
    .select({
      id: vehiculesTable.id,
      immatriculation: vehiculesTable.immatriculation,
      marque: vehiculesTable.marque,
      modele: vehiculesTable.modele,
      chauffeurAttitreId: vehiculesTable.chauffeurAttitreId
    })
    .from(vehiculesTable)
    .where(and(isNull(vehiculesTable.deletedAt), isNotNull(vehiculesTable.chauffeurAttitreId)));
  const map = new Map<number, VehiculeResume>();
  for (const r of rows) {
    if (r.chauffeurAttitreId != null) {
      map.set(r.chauffeurAttitreId, { id: r.id, immatriculation: r.immatriculation, marque: r.marque, modele: r.modele });
    }
  }
  return map;
}

async function findVehiculeHabituel(chauffeurId: number): Promise<VehiculeResume | null> {
  const [row] = await db
    .select({ id: vehiculesTable.id, immatriculation: vehiculesTable.immatriculation, marque: vehiculesTable.marque, modele: vehiculesTable.modele })
    .from(vehiculesTable)
    .where(and(eq(vehiculesTable.chauffeurAttitreId, chauffeurId), isNull(vehiculesTable.deletedAt)));
  return row ?? null;
}

/** Détache l'ancien véhicule habituel (s'il diffère) puis affecte le nouveau,
 *  en journalisant le changement dans l'historique des affectations. */
async function syncVehiculeHabituel(chauffeurId: number, vehiculeId: number | null | undefined, responsable: string): Promise<void> {
  if (vehiculeId === undefined) return;
  if (vehiculeId != null) {
    await assignVehicule(vehiculeId, chauffeurId, responsable);
    return;
  }
  const [current] = await db.select({ id: vehiculesTable.id }).from(vehiculesTable).where(eq(vehiculesTable.chauffeurAttitreId, chauffeurId));
  if (current) await unassignVehicule(current.id);
}

router.get('/chauffeurs/stats', requirePermission('business.read'), async (_req, res) => {
  const rows = await db.select().from(chauffeursTable).where(isNull(chauffeursTable.deletedAt));
  res.json({
    total: rows.length,
    disponibles: rows.filter((c) => c.statut === 'disponible').length,
    enMission: rows.filter((c) => c.statut === 'en_mission').length,
    indisponibles: rows.filter((c) => c.statut === 'indisponible').length,
    enConge: rows.filter((c) => c.statut === 'en_conge').length,
    absents: rows.filter((c) => c.statut === 'absent').length,
  });
});

router.get('/chauffeurs', requirePermission('business.read'), async (req, res) => {
  const { statut, search } = req.query;
  const conditions = [isNull(chauffeursTable.deletedAt)];
  if (typeof statut === 'string' && statut) {
    conditions.push(eq(chauffeursTable.statut, statut as ChauffeurStatut));
  }
  if (typeof search === 'string' && search.trim()) {
    const s = `%${search.trim()}%`;
    const cond = or(ilike(chauffeursTable.nom, s), ilike(chauffeursTable.telephone, s), ilike(chauffeursTable.cin, s));
    if (cond) conditions.push(cond);
  }
  const chauffeurs = await db
    .select()
    .from(chauffeursTable)
    .where(and(...conditions))
    .orderBy(chauffeursTable.nom);
  const vehiculeMap = await loadVehiculesHabituels();
  res.json({
    chauffeurs: chauffeurs.map((c) => ({ ...c, vehiculeHabituel: vehiculeMap.get(c.id) ?? null }))
  });
});

router.get('/chauffeurs/:id', requirePermission('business.read'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });
  const [chauffeur] = await db.select().from(chauffeursTable).where(and(eq(chauffeursTable.id, id), isNull(chauffeursTable.deletedAt)));
  if (!chauffeur) return res.status(404).json({ error: 'Chauffeur introuvable.' });
  const vehiculeHabituel = await findVehiculeHabituel(id);
  res.json({ chauffeur: { ...chauffeur, vehiculeHabituel } });
});

const createSchema = z.object({
  nom: z.string().min(2).max(150),
  cin: z.string().max(20).optional(),
  telephone: z.string().max(30).optional(),
  email: z.string().max(150).optional(),
  adresse: z.string().max(300).optional(),
  dateNaissance: z.string().max(10).optional(),
  permis: z.string().max(50).optional(),
  permisNumero: z.string().max(50).optional(),
  permisDateObtention: z.string().max(10).optional(),
  permisDateExpiration: z.string().max(10).optional(),
  serviceId: z.number().int().positive().nullable().optional(),
  responsable: z.string().max(150).optional(),
  vehiculeHabituelId: z.number().int().positive().nullable().optional(),
  notes: z.string().max(1000).optional(),
  remarques: z.string().max(1000).optional(),
  jawazNumero: z.string().max(50).optional(),
  jawazSolde: z.number().min(0).optional()
});

router.post('/chauffeurs', requirePermission('business.write'), async (req, res) => {
  const parsed = createSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.issues[0]?.message ?? 'Données invalides.' });
  const { vehiculeHabituelId, ...data } = parsed.data;
  const [chauffeur] = await db.insert(chauffeursTable).values({ ...data, statut: 'disponible' }).returning();
  if (vehiculeHabituelId != null) {
    await syncVehiculeHabituel(chauffeur!.id, vehiculeHabituelId, req.user!.username);
  }
  const vehiculeHabituel = await findVehiculeHabituel(chauffeur!.id);
  res.status(201).json({ chauffeur: { ...chauffeur, vehiculeHabituel } });
});

const patchSchema = z.object({
  nom: z.string().min(2).max(150).optional(),
  cin: z.string().max(20).nullable().optional(),
  telephone: z.string().max(30).nullable().optional(),
  email: z.string().max(150).nullable().optional(),
  adresse: z.string().max(300).nullable().optional(),
  dateNaissance: z.string().max(10).nullable().optional(),
  permis: z.string().max(50).nullable().optional(),
  permisNumero: z.string().max(50).nullable().optional(),
  permisDateObtention: z.string().max(10).nullable().optional(),
  permisDateExpiration: z.string().max(10).nullable().optional(),
  serviceId: z.number().int().positive().nullable().optional(),
  responsable: z.string().max(150).nullable().optional(),
  vehiculeHabituelId: z.number().int().positive().nullable().optional(),
  notes: z.string().max(1000).nullable().optional(),
  remarques: z.string().max(1000).nullable().optional(),
  jawazNumero: z.string().max(50).nullable().optional(),
  jawazSolde: z.number().min(0).optional()
});

router.patch('/chauffeurs/:id', requirePermission('business.write'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });
  const parsed = patchSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.issues[0]?.message ?? 'Données invalides.' });
  const { vehiculeHabituelId, ...data } = parsed.data;
  const [updated] = await db
    .update(chauffeursTable)
    .set({ ...data, updatedAt: new Date() })
    .where(and(eq(chauffeursTable.id, id), isNull(chauffeursTable.deletedAt)))
    .returning();
  if (!updated) return res.status(404).json({ error: 'Chauffeur introuvable.' });
  if (vehiculeHabituelId !== undefined) {
    await syncVehiculeHabituel(id, vehiculeHabituelId, req.user!.username);
  }
  const vehiculeHabituel = await findVehiculeHabituel(id);
  res.json({ chauffeur: { ...updated, vehiculeHabituel } });
});

const statutSchema = z.object({ statut: z.enum(['disponible', 'en_mission', 'indisponible', 'en_conge', 'absent']) });

router.patch('/chauffeurs/:id/statut', requirePermission('business.write'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });
  const parsed = statutSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: 'Statut invalide.' });
  const [updated] = await db
    .update(chauffeursTable)
    .set({ statut: parsed.data.statut, updatedAt: new Date() })
    .where(and(eq(chauffeursTable.id, id), isNull(chauffeursTable.deletedAt)))
    .returning();
  if (!updated) return res.status(404).json({ error: 'Chauffeur introuvable.' });
  res.json({ chauffeur: updated });
});

router.delete('/chauffeurs/:id', requirePermission('business.delete'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });
  const [row] = await db
    .update(chauffeursTable)
    .set({ deletedAt: new Date(), deletedBy: req.user!.username })
    .where(and(eq(chauffeursTable.id, id), isNull(chauffeursTable.deletedAt)))
    .returning();
  if (!row) return res.status(404).json({ error: 'Chauffeur introuvable.' });
  res.json({ ok: true });
});

/* ── Photo de profil ──────────────────────────────────────────────── */
router.post('/chauffeurs/:id/photo', requirePermission('business.write'), upload.single('photo'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });
  if (!req.file) return res.status(400).json({ error: 'Fichier photo requis (champ "photo").' });
  const [chauffeur] = await db.select().from(chauffeursTable).where(and(eq(chauffeursTable.id, id), isNull(chauffeursTable.deletedAt)));
  if (!chauffeur) {
    fs.unlink(req.file.path, () => {});
    return res.status(404).json({ error: 'Chauffeur introuvable.' });
  }
  const url = `/api/uploads/chauffeurs/${req.file.filename}`;
  const [updated] = await db.update(chauffeursTable).set({ photoUrl: url, updatedAt: new Date() }).where(eq(chauffeursTable.id, id)).returning();
  const vehiculeHabituel = await findVehiculeHabituel(id);
  res.json({ chauffeur: { ...updated, vehiculeHabituel } });
});

/* ── Documents scannés : CIN, permis, certificat médical ─────────────
 * Champ "type" du formulaire multipart : cin | permis | medical. */
router.post('/chauffeurs/:id/documents', requirePermission('business.write'), upload.single('document'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });
  if (!req.file) return res.status(400).json({ error: 'Fichier requis (champ "document").' });
  const type = req.body?.type as string;
  if (!['cin', 'permis', 'medical'].includes(type)) {
    fs.unlink(req.file.path, () => {});
    return res.status(400).json({ error: 'Type de document invalide. Valeurs acceptées : cin, permis, medical.' });
  }
  const [chauffeur] = await db.select().from(chauffeursTable).where(and(eq(chauffeursTable.id, id), isNull(chauffeursTable.deletedAt)));
  if (!chauffeur) {
    fs.unlink(req.file.path, () => {});
    return res.status(404).json({ error: 'Chauffeur introuvable.' });
  }
  const url = `/api/uploads/chauffeurs/${req.file.filename}`;
  let updated: ChauffeurRow | undefined;
  if (type === 'cin') {
    [updated] = await db.update(chauffeursTable).set({ scanCinUrl: url, updatedAt: new Date() }).where(eq(chauffeursTable.id, id)).returning();
  } else if (type === 'permis') {
    [updated] = await db.update(chauffeursTable).set({ scanPermisUrl: url, updatedAt: new Date() }).where(eq(chauffeursTable.id, id)).returning();
  } else {
    [updated] = await db.update(chauffeursTable).set({ certificatMedicalUrl: url, updatedAt: new Date() }).where(eq(chauffeursTable.id, id)).returning();
  }
  const vehiculeHabituel = await findVehiculeHabituel(id);
  res.json({ chauffeur: { ...updated, vehiculeHabituel } });
});

/* ── Compte du portail chauffeur ─────────────────────────────────────
 * Crée (ou, si déjà existant, réinitialise le mot de passe d'un) compte de
 * connexion de rôle CHAUFFEUR, lié à ce chauffeur. Réservé aux comptes
 * pouvant gérer des utilisateurs (ADMIN+). */
const compteSchema = z.object({
  username: z.string().min(3).max(50).regex(/^[a-z0-9._-]+$/i, 'Lettres, chiffres, points, tirets uniquement.'),
  password: z.string().min(6).max(100)
});

router.post('/chauffeurs/:id/compte', requirePermission('users.manage_users'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });
  const parsed = compteSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.issues[0]?.message ?? 'Données invalides.' });

  const [chauffeur] = await db.select().from(chauffeursTable).where(and(eq(chauffeursTable.id, id), isNull(chauffeursTable.deletedAt)));
  if (!chauffeur) return res.status(404).json({ error: 'Chauffeur introuvable.' });

  const passwordHash = await hashPassword(parsed.data.password);

  if (chauffeur.userId) {
    // Compte déjà existant : on se contente de réinitialiser le mot de passe.
    await db.update(usersTable).set({ passwordHash }).where(eq(usersTable.id, chauffeur.userId));
    return res.json({ ok: true, created: false });
  }

  const [existingUsername] = await db.select({ id: usersTable.id }).from(usersTable).where(eq(usersTable.username, parsed.data.username));
  if (existingUsername) return res.status(409).json({ error: 'Ce nom d\'utilisateur existe déjà.' });

  const [user] = await db
    .insert(usersTable)
    .values({ username: parsed.data.username, passwordHash, displayName: chauffeur.nom, role: 'CHAUFFEUR' })
    .returning({ id: usersTable.id });

  await db.update(chauffeursTable).set({ userId: user!.id, updatedAt: new Date() }).where(eq(chauffeursTable.id, id));

  res.status(201).json({ ok: true, created: true, username: parsed.data.username });
});

export default router;
