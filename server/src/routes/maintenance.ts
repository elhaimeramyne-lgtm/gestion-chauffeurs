/**
 * Module Maintenance — historique complet d'entretien et de réparations par
 * véhicule (vidange, pneus, batterie, freins, embrayage, courroie,
 * réparations, accidents…), au-delà du simple suivi de vidange déjà présent
 * sur la fiche véhicule (Parc Automobile).
 *
 *  GET    /maintenance                    — liste (filtres : vehiculeId, type)
 *  GET    /maintenance/:id                — détail (+ documents)
 *  POST   /maintenance                    — créer une intervention
 *  PATCH  /maintenance/:id                — modifier
 *  DELETE /maintenance/:id                — suppression douce
 *  POST   /maintenance/:id/documents      — joindre une facture / un document PDF
 *  DELETE /maintenance/:id/documents/:docId — retirer une pièce jointe
 */
import { Router } from 'express';
import { z } from 'zod';
import { and, desc, eq, inArray, isNull } from 'drizzle-orm';
import multer from 'multer';
import path from 'path';
import fs from 'fs';
import { db, vehiculeMaintenanceTable, vehiculeMaintenanceDocumentsTable, vehiculesTable } from '../db.js';
import { requireAuth, requirePermission } from '../middleware/auth.js';

const router = Router();
router.use(requireAuth);

const MAINTENANCE_TYPES = [
  'vidange', 'pneus', 'batterie', 'freins', 'embrayage', 'courroie', 'reparation', 'accident', 'autre'
] as const;

/* ── Upload des pièces jointes (factures, documents PDF) ─────────────── */
const UPLOAD_BASE = path.join(process.cwd(), 'uploads', 'maintenance');
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
const upload = multer({ storage, limits: { fileSize: 15 * 1024 * 1024 } }); // 15 MB max (factures scannées)

type VehiculeResume = { id: number; immatriculation: string; marque: string; modele: string };

function withDocumentUrl<T extends { filename: string }>(doc: T) {
  return { ...doc, url: `/api/uploads/maintenance/${doc.filename}` };
}

/** GET /maintenance — liste, filtrable par véhicule et/ou par type. */
router.get('/maintenance', requirePermission('business.read'), async (req, res) => {
  const { vehiculeId, type } = req.query;
  const conditions = [isNull(vehiculeMaintenanceTable.deletedAt)];
  if (typeof vehiculeId === 'string' && vehiculeId.trim()) {
    conditions.push(eq(vehiculeMaintenanceTable.vehiculeId, Number(vehiculeId)));
  }
  if (typeof type === 'string' && (MAINTENANCE_TYPES as readonly string[]).includes(type)) {
    conditions.push(eq(vehiculeMaintenanceTable.type, type as (typeof MAINTENANCE_TYPES)[number]));
  }

  const records = await db
    .select()
    .from(vehiculeMaintenanceTable)
    .where(and(...conditions))
    .orderBy(desc(vehiculeMaintenanceTable.createdAt));

  const vehiculeIds = [...new Set(records.map((r) => r.vehiculeId))];
  const vehicules = vehiculeIds.length
    ? await db
        .select({ id: vehiculesTable.id, immatriculation: vehiculesTable.immatriculation, marque: vehiculesTable.marque, modele: vehiculesTable.modele })
        .from(vehiculesTable)
        .where(inArray(vehiculesTable.id, vehiculeIds))
    : [];
  const vehiculeMap = new Map<number, VehiculeResume>(vehicules.map((v) => [v.id, v]));

  const maintenanceIds = records.map((r) => r.id);
  const documents = maintenanceIds.length
    ? await db.select().from(vehiculeMaintenanceDocumentsTable).where(inArray(vehiculeMaintenanceDocumentsTable.maintenanceId, maintenanceIds))
    : [];
  const docsByMaintenance = new Map<number, typeof documents>();
  for (const d of documents) {
    const list = docsByMaintenance.get(d.maintenanceId) ?? [];
    list.push(d);
    docsByMaintenance.set(d.maintenanceId, list);
  }

  res.json({
    maintenances: records.map((r) => ({
      ...r,
      vehicule: vehiculeMap.get(r.vehiculeId) ?? null,
      documents: (docsByMaintenance.get(r.id) ?? []).map(withDocumentUrl)
    }))
  });
});

/** GET /maintenance/:id — détail d'une intervention. */
router.get('/maintenance/:id', requirePermission('business.read'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });
  const [record] = await db.select().from(vehiculeMaintenanceTable).where(and(eq(vehiculeMaintenanceTable.id, id), isNull(vehiculeMaintenanceTable.deletedAt)));
  if (!record) return res.status(404).json({ error: 'Intervention introuvable.' });
  const [vehicule] = await db
    .select({ id: vehiculesTable.id, immatriculation: vehiculesTable.immatriculation, marque: vehiculesTable.marque, modele: vehiculesTable.modele })
    .from(vehiculesTable)
    .where(eq(vehiculesTable.id, record.vehiculeId));
  const documents = await db.select().from(vehiculeMaintenanceDocumentsTable).where(eq(vehiculeMaintenanceDocumentsTable.maintenanceId, id));
  res.json({ maintenance: { ...record, vehicule: vehicule ?? null, documents: documents.map(withDocumentUrl) } });
});

const createSchema = z.object({
  vehiculeId: z.number().int().positive(),
  type: z.enum(MAINTENANCE_TYPES),
  date: z.string().regex(/^\d{2}\/\d{2}\/\d{4}$/),
  kilometrage: z.number().int().min(0).optional(),
  garage: z.string().max(150).optional(),
  description: z.string().max(2000).optional(),
  piecesRemplacees: z.string().max(1000).optional(),
  cout: z.number().min(0).optional()
});

router.post('/maintenance', requirePermission('business.write'), async (req, res) => {
  const parsed = createSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.issues[0]?.message ?? 'Données invalides.' });

  const [vehicule] = await db.select({ id: vehiculesTable.id }).from(vehiculesTable).where(and(eq(vehiculesTable.id, parsed.data.vehiculeId), isNull(vehiculesTable.deletedAt)));
  if (!vehicule) return res.status(404).json({ error: 'Véhicule introuvable.' });

  const [record] = await db.insert(vehiculeMaintenanceTable).values({ ...parsed.data, createdBy: req.user!.username }).returning();
  res.status(201).json({ maintenance: { ...record, documents: [] } });
});

const patchSchema = z.object({
  type: z.enum(MAINTENANCE_TYPES).optional(),
  date: z.string().regex(/^\d{2}\/\d{2}\/\d{4}$/).optional(),
  kilometrage: z.number().int().min(0).nullable().optional(),
  garage: z.string().max(150).nullable().optional(),
  description: z.string().max(2000).nullable().optional(),
  piecesRemplacees: z.string().max(1000).nullable().optional(),
  cout: z.number().min(0).optional()
});

router.patch('/maintenance/:id', requirePermission('business.write'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });
  const parsed = patchSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.issues[0]?.message ?? 'Données invalides.' });

  const [updated] = await db
    .update(vehiculeMaintenanceTable)
    .set({ ...parsed.data, updatedAt: new Date() })
    .where(and(eq(vehiculeMaintenanceTable.id, id), isNull(vehiculeMaintenanceTable.deletedAt)))
    .returning();
  if (!updated) return res.status(404).json({ error: 'Intervention introuvable.' });

  const documents = await db.select().from(vehiculeMaintenanceDocumentsTable).where(eq(vehiculeMaintenanceDocumentsTable.maintenanceId, id));
  res.json({ maintenance: { ...updated, documents: documents.map(withDocumentUrl) } });
});

router.delete('/maintenance/:id', requirePermission('business.delete'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });
  const [row] = await db
    .update(vehiculeMaintenanceTable)
    .set({ deletedAt: new Date(), deletedBy: req.user!.username })
    .where(and(eq(vehiculeMaintenanceTable.id, id), isNull(vehiculeMaintenanceTable.deletedAt)))
    .returning();
  if (!row) return res.status(404).json({ error: 'Intervention introuvable.' });
  res.json({ ok: true });
});

/** POST /maintenance/:id/documents — joindre une facture ou un document PDF.
 *  Champ "type" du formulaire multipart (facultatif) : facture | document. */
router.post('/maintenance/:id/documents', requirePermission('business.write'), upload.single('document'), async (req, res) => {
  const id = Number(req.params.id);
  if (!id) return res.status(400).json({ error: 'ID invalide.' });
  if (!req.file) return res.status(400).json({ error: 'Fichier requis (champ "document").' });

  const [record] = await db.select({ id: vehiculeMaintenanceTable.id }).from(vehiculeMaintenanceTable).where(and(eq(vehiculeMaintenanceTable.id, id), isNull(vehiculeMaintenanceTable.deletedAt)));
  if (!record) {
    fs.unlink(req.file.path, () => {});
    return res.status(404).json({ error: 'Intervention introuvable.' });
  }

  const type = req.body?.type === 'facture' ? 'facture' : 'document';
  const [doc] = await db
    .insert(vehiculeMaintenanceDocumentsTable)
    .values({
      maintenanceId: id,
      type,
      filename: req.file.filename,
      originalName: req.file.originalname,
      mimeType: req.file.mimetype,
      sizeBytes: req.file.size,
      uploadedBy: req.user!.username
    })
    .returning();
  res.status(201).json({ document: withDocumentUrl(doc!) });
});

router.delete('/maintenance/:id/documents/:docId', requirePermission('business.write'), async (req, res) => {
  const id = Number(req.params.id);
  const docId = Number(req.params.docId);
  if (!id || !docId) return res.status(400).json({ error: 'ID invalide.' });
  const [doc] = await db
    .select()
    .from(vehiculeMaintenanceDocumentsTable)
    .where(and(eq(vehiculeMaintenanceDocumentsTable.id, docId), eq(vehiculeMaintenanceDocumentsTable.maintenanceId, id)));
  if (!doc) return res.status(404).json({ error: 'Document introuvable.' });
  await db.delete(vehiculeMaintenanceDocumentsTable).where(eq(vehiculeMaintenanceDocumentsTable.id, docId));
  fs.unlink(path.join(UPLOAD_BASE, doc.filename), () => {});
  res.json({ ok: true });
});

export default router;
