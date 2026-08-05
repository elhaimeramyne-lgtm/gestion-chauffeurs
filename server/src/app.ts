import express from 'express';
import cors from 'cors';
import cookieParser from 'cookie-parser';
import path from 'path';
import authRouter from './routes/auth.js';
import usersRouter from './routes/users.js';
import facturationConfigRouter from './routes/facturationConfig.js';
import correctionRulesRouter from './routes/correctionRules.js';
import lignesRouter from './routes/lignes.js';
import auditRouter from './routes/audit.js';
import dashboardRouter from './routes/dashboard.js';
import settingsRouter from './routes/settings.js';
import systemRouter from './routes/system.js';
import permissionsRouter from './routes/permissions.js';
import trashRouter from './routes/trash.js';
import facturesRouter from './routes/factures.js';
import lignesFixesRouter from './routes/lignesFixes.js';
import presenceRouter from './routes/presence.js';
import notificationsRouter from './routes/notifications.js';
import searchRouter from './routes/search.js';
import journauxRouter from './routes/journaux.js';
import securityRouter from './routes/security.js';
import assistantRouter from './routes/assistant.js';
import calendarRouter from './routes/calendar.js';
import emailRouter from './routes/email.js';
import whatsappRouter from './routes/whatsapp.js';
import notificationsSseRouter from './routes/notifications-sse.js';
import auditEnhancedRouter from './routes/audit-enhanced.js';
import orgRouter from './routes/org.js';
import logistiqueRouter from './routes/logistique.js';
import parcAutoRouter from './routes/parcAuto.js';
import chauffeursRouter from './routes/chauffeurs.js';
import chauffeurPortalRouter from './routes/chauffeurPortal.js';
import maMissionRouter from './routes/maMission.js';
import missionMapRouter from './routes/missionMap.js';
import demandeChauffeurRouter from './routes/demandeChauffeur.js';
import maintenanceRouter from './routes/maintenance.js';
import declarationsRouter from './routes/declarations.js';
import { logSystemEvent } from './lib/systemLog.js';
import { auditLogger } from './middleware/audit.js';
import { requireAuth } from './middleware/auth.js';

const app = express();

const allowedOrigins = (process.env.CORS_ORIGINS ?? '')
  .split(',')
  .map((s) => s.trim())
  .filter(Boolean);

app.use(
  cors({
    origin: allowedOrigins.length > 0 ? allowedOrigins : true,
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With'],
    optionsSuccessStatus: 204
  })
);
app.use(cookieParser());
app.use(express.json({ limit: '5mb' }));

// Historique automatique de toutes les actions de modification (POST/PUT/PATCH/DELETE).
// Placé avant les routeurs : le log est écrit à la fin de la requête (res.on('finish')),
// une fois que req.user a été renseigné par requireAuth en aval.
app.use(auditLogger);

app.get('/api/health', (_req, res) => res.json({ ok: true }));

app.use('/api', authRouter);
app.use('/api', usersRouter);
app.use('/api', facturationConfigRouter);
app.use('/api', correctionRulesRouter);
app.use('/api', lignesRouter);
app.use('/api', auditRouter);
app.use('/api', dashboardRouter);
app.use('/api', settingsRouter);
app.use('/api', systemRouter);
app.use('/api', permissionsRouter);
app.use('/api', trashRouter);
app.use('/api', facturesRouter);
app.use('/api', lignesFixesRouter);
app.use('/api', presenceRouter);
app.use('/api', notificationsRouter);
app.use('/api', searchRouter);
app.use('/api', journauxRouter);
app.use('/api', securityRouter);
app.use('/api', assistantRouter);
app.use('/api', calendarRouter);
app.use('/api', emailRouter);
app.use('/api', whatsappRouter);
app.use('/api', notificationsSseRouter);
app.use('/api', auditEnhancedRouter);
app.use('/api', orgRouter);
app.use('/api', logistiqueRouter);
app.use('/api', parcAutoRouter);
app.use('/api', chauffeursRouter);
app.use('/api', missionMapRouter);
app.use('/api', demandeChauffeurRouter);
app.use('/api', chauffeurPortalRouter);
app.use('/api', maMissionRouter);
app.use('/api', maintenanceRouter);
app.use('/api', declarationsRouter);

// Fichiers uploadés (photos chauffeur, documents, pièces jointes de maintenance).
// Servis derrière requireAuth : accessible à tout utilisateur connecté de la plateforme.
app.use('/api/uploads', requireAuth, express.static(path.join(process.cwd(), 'uploads')));

// Gestionnaire d'erreurs générique
// stack trace au frontend et journalise l'erreur côté serveur (console + journal système).
app.use((err: unknown, _req: express.Request, res: express.Response, _next: express.NextFunction) => {
  // eslint-disable-next-line no-console
  console.error(err);
  const message = err instanceof Error ? err.message : String(err);
  logSystemEvent('error', 'Erreur serveur non gérée', { message }).catch(() => {});
  res.status(500).json({ error: 'Erreur interne du serveur.' });
});

export default app;
