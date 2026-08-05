/**
 * Envoi d'e-mails (SMTP) — factures, tests de configuration, futures
 * notifications par e-mail. Utilise nodemailer avec les variables SMTP_*
 * du .env. Sans configuration, l'envoi échoue avec un message clair mais
 * n'empêche jamais le reste de l'application de fonctionner.
 */
import nodemailer from 'nodemailer';
import { db, emailLogsTable } from '../db.js';

export interface SendEmailInput {
  to: string;
  subject: string;
  html: string;
  kind: string;
  relatedId?: string;
  sentBy?: string;
}

export interface SendEmailResult {
  ok: boolean;
  error?: string;
}

function isSmtpConfigured(): boolean {
  return Boolean(process.env.SMTP_HOST && process.env.SMTP_USER && process.env.SMTP_PASS);
}

let cachedTransporter: ReturnType<typeof nodemailer.createTransport> | null = null;

function getTransporter() {
  if (cachedTransporter) return cachedTransporter;
  cachedTransporter = nodemailer.createTransport({
    host: process.env.SMTP_HOST,
    port: Number(process.env.SMTP_PORT ?? 587),
    secure: process.env.SMTP_SECURE === 'true',
    auth: { user: process.env.SMTP_USER, pass: process.env.SMTP_PASS }
  });
  return cachedTransporter;
}

/** Envoie un e-mail et journalise le résultat (succès ou échec) dans
 *  `email_logs`, pour garder un historique consultable depuis l'Administration. */
export async function sendEmail(input: SendEmailInput): Promise<SendEmailResult> {
  if (!isSmtpConfigured()) {
    const error = "Configuration SMTP manquante (voir SMTP_HOST/SMTP_USER/SMTP_PASS dans .env).";
    await logEmail(input, false, error);
    return { ok: false, error };
  }

  try {
    const transporter = getTransporter();
    await transporter.sendMail({
      from: process.env.SMTP_FROM || process.env.SMTP_USER,
      to: input.to,
      subject: input.subject,
      html: input.html
    });
    await logEmail(input, true);
    return { ok: true };
  } catch (err) {
    const error = err instanceof Error ? err.message : "Échec de l'envoi de l'e-mail.";
    await logEmail(input, false, error);
    return { ok: false, error };
  }
}

async function logEmail(input: SendEmailInput, success: boolean, error?: string): Promise<void> {
  try {
    await db.insert(emailLogsTable).values({
      toAddress: input.to,
      subject: input.subject,
      kind: input.kind,
      relatedId: input.relatedId ?? null,
      success,
      error: error ?? null,
      sentBy: input.sentBy ?? null
    });
  } catch {
    // ne bloque jamais l'envoi si la journalisation échoue
  }
}
