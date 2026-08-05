import { pool } from './db.js';

/**
 * Migration automatique au démarrage.
 * Ajoute les colonnes/tables manquantes sans toucher aux données existantes.
 * Toutes les étapes sont idempotentes (IF NOT EXISTS / vérifications) —
 * sans danger si déjà appliquées.
 */
export async function runMigrations(): Promise<void> {
  const client = await pool.connect();
  try {
    // S'assure que le schéma iam existe
    await client.query(`CREATE SCHEMA IF NOT EXISTS iam`);

    // Ajoute la colonne civilite si absente
    await client.query(`
      ALTER TABLE iam.lignes
        ADD COLUMN IF NOT EXISTS civilite TEXT
          CHECK (civilite IN ('Mme', 'Mlle', 'M.'))
    `);
    console.log('[migrate] ✅ Colonne civilite vérifiée / ajoutée.');

    // ── Système de rôles SUPER_ADMIN / ADMIN / USER ──────────────────────
    // L'ancien enum user_role ('admin' | 'editor' | 'viewer') est remplacé
    // par un nouvel enum ('SUPER_ADMIN' | 'ADMIN' | 'USER'). Postgres ne
    // permet pas de renommer les valeurs d'un enum utilisé par une colonne
    // en une seule opération sûre, donc on procède par un type intermédiaire.
    const enumCheck = await client.query(`
      SELECT unnest(enum_range(NULL::iam.user_role))::text AS value
    `).catch(() => null);

    const currentValues = enumCheck?.rows.map((r) => r.value) ?? [];
    const alreadyMigrated = currentValues.includes('SUPER_ADMIN');

    if (!alreadyMigrated && currentValues.length > 0) {
      await client.query('BEGIN');
      try {
        await client.query(`CREATE TYPE iam.user_role_new AS ENUM ('SUPER_ADMIN', 'ADMIN', 'USER')`);
        await client.query(`ALTER TABLE iam.users ADD COLUMN role_new iam.user_role_new`);
        // admin -> SUPER_ADMIN (garde le contrôle total pour les comptes historiques),
        // editor -> ADMIN, viewer -> USER.
        await client.query(`
          UPDATE iam.users SET role_new = CASE role::text
            WHEN 'admin' THEN 'SUPER_ADMIN'
            WHEN 'editor' THEN 'ADMIN'
            ELSE 'USER'
          END::iam.user_role_new
        `);
        await client.query(`ALTER TABLE iam.users ALTER COLUMN role_new SET NOT NULL`);
        await client.query(`ALTER TABLE iam.users DROP COLUMN role`);
        await client.query(`ALTER TABLE iam.users RENAME COLUMN role_new TO role`);
        await client.query(`ALTER TABLE iam.users ALTER COLUMN role SET DEFAULT 'USER'`);
        await client.query(`DROP TYPE iam.user_role`);
        await client.query(`ALTER TYPE iam.user_role_new RENAME TO user_role`);
        await client.query('COMMIT');
        console.log('[migrate] ✅ Rôles migrés vers SUPER_ADMIN / ADMIN / USER.');
      } catch (err) {
        await client.query('ROLLBACK');
        throw err;
      }
    }

    // ── Ajout du rôle GESTIONNAIRE (RBAC à 4 niveaux) ────────────────────
    // Contrairement à la migration ci-dessus (qui renommait toutes les
    // valeurs), ici on se contente d'ajouter une valeur à l'enum existant —
    // opération native Postgres 12+, pas besoin de type intermédiaire.
    const gestionnaireCheck = await client
      .query(`SELECT unnest(enum_range(NULL::iam.user_role))::text AS value`)
      .catch(() => null);
    const rolesNow = gestionnaireCheck?.rows.map((r) => r.value) ?? [];
    if (!rolesNow.includes('GESTIONNAIRE')) {
      await client.query(`ALTER TYPE iam.user_role ADD VALUE IF NOT EXISTS 'GESTIONNAIRE'`);
      console.log('[migrate] ✅ Rôle GESTIONNAIRE ajouté.');
    }

    // Colonnes ajoutées au modèle utilisateur (compte actif, dernière connexion)
    await client.query(`ALTER TABLE iam.users ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT true`);
    await client.query(`ALTER TABLE iam.users ADD COLUMN IF NOT EXISTS last_login_at TIMESTAMP`);
    await client.query(`ALTER TABLE iam.users ADD COLUMN IF NOT EXISTS last_seen_at TIMESTAMP`);
    console.log('[migrate] ✅ Colonnes is_active / last_login_at / last_seen_at vérifiées / ajoutées.');

    // ── Historique des actions ───────────────────────────────────────────
    await client.query(`
      CREATE TABLE IF NOT EXISTS iam.audit_logs (
        id SERIAL PRIMARY KEY,
        user_id INTEGER,
        username TEXT,
        role TEXT,
        action TEXT NOT NULL,
        entity TEXT NOT NULL,
        entity_id TEXT,
        method TEXT NOT NULL,
        path TEXT NOT NULL,
        status_code INTEGER NOT NULL,
        details JSONB,
        ip_address TEXT,
        user_agent TEXT,
        created_at TIMESTAMP NOT NULL DEFAULT now()
      )
    `);
    await client.query(`CREATE INDEX IF NOT EXISTS audit_logs_created_at_idx ON iam.audit_logs (created_at DESC)`);
    await client.query(`CREATE INDEX IF NOT EXISTS audit_logs_entity_idx ON iam.audit_logs (entity)`);

    // ── Journal des connexions ───────────────────────────────────────────
    await client.query(`
      CREATE TABLE IF NOT EXISTS iam.connection_logs (
        id SERIAL PRIMARY KEY,
        user_id INTEGER,
        username TEXT NOT NULL,
        success BOOLEAN NOT NULL,
        reason TEXT,
        ip_address TEXT,
        user_agent TEXT,
        created_at TIMESTAMP NOT NULL DEFAULT now()
      )
    `);
    await client.query(
      `CREATE INDEX IF NOT EXISTS connection_logs_created_at_idx ON iam.connection_logs (created_at DESC)`
    );
    console.log('[migrate] ✅ Tables audit_logs / connection_logs vérifiées / créées.');

    // ── Snapshot du tableau de bord ───────────────────────────────────────
    await client.query(`
      CREATE TABLE IF NOT EXISTS iam.dashboard_snapshot (
        id INTEGER PRIMARY KEY DEFAULT 1,
        total_factures INTEGER NOT NULL DEFAULT 0,
        factures_reglees INTEGER NOT NULL DEFAULT 0,
        factures_impayees INTEGER NOT NULL DEFAULT 0,
        montant_impaye DOUBLE PRECISION NOT NULL DEFAULT 0,
        lignes_fixes INTEGER NOT NULL DEFAULT 0,
        updated_by TEXT,
        updated_at TIMESTAMP NOT NULL DEFAULT now()
      )
    `);
    console.log('[migrate] ✅ Table dashboard_snapshot vérifiée / créée.');

    // ── Suppression douce (Corbeille) ───────────────────────────────────
    await client.query(`ALTER TABLE iam.users ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMP`);
    await client.query(`ALTER TABLE iam.users ADD COLUMN IF NOT EXISTS deleted_by TEXT`);
    await client.query(`ALTER TABLE iam.lignes ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMP`);
    await client.query(`ALTER TABLE iam.lignes ADD COLUMN IF NOT EXISTS deleted_by TEXT`);
    await client.query(`ALTER TABLE iam.custom_fields ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMP`);
    await client.query(`ALTER TABLE iam.custom_fields ADD COLUMN IF NOT EXISTS deleted_by TEXT`);
    await client.query(`ALTER TABLE iam.correction_rules ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMP`);
    await client.query(`ALTER TABLE iam.correction_rules ADD COLUMN IF NOT EXISTS deleted_by TEXT`);
    console.log('[migrate] ✅ Colonnes deleted_at / deleted_by (Corbeille) vérifiées / ajoutées.');

    // ── Paramètres système ────────────────────────────────────────────────
    await client.query(`
      CREATE TABLE IF NOT EXISTS iam.system_settings (
        id INTEGER PRIMARY KEY DEFAULT 1,
        organization_name TEXT NOT NULL DEFAULT 'Entraide Nationale',
        support_email TEXT,
        session_duration_days INTEGER NOT NULL DEFAULT 30,
        maintenance_mode BOOLEAN NOT NULL DEFAULT false,
        maintenance_message TEXT,
        updated_by TEXT,
        updated_at TIMESTAMP NOT NULL DEFAULT now()
      )
    `);
    await client.query(`INSERT INTO iam.system_settings (id) VALUES (1) ON CONFLICT (id) DO NOTHING`);
    await client.query(`ALTER TABLE iam.system_settings ADD COLUMN IF NOT EXISTS backup_schedule_enabled BOOLEAN NOT NULL DEFAULT false`);
    await client.query(`ALTER TABLE iam.system_settings ADD COLUMN IF NOT EXISTS backup_schedule_frequency TEXT NOT NULL DEFAULT 'daily'`);
    await client.query(`ALTER TABLE iam.system_settings ADD COLUMN IF NOT EXISTS backup_schedule_hour INTEGER NOT NULL DEFAULT 2`);
    console.log('[migrate] ✅ Table system_settings vérifiée / créée.');

    // ── Journal système ──────────────────────────────────────────────────
    const logLevelEnumCheck = await client
      .query(`SELECT 1 FROM pg_type WHERE typname = 'system_log_level'`)
      .catch(() => null);
    if (!logLevelEnumCheck || logLevelEnumCheck.rowCount === 0) {
      await client.query(`CREATE TYPE iam.system_log_level AS ENUM ('info', 'warn', 'error')`);
    }
    await client.query(`
      CREATE TABLE IF NOT EXISTS iam.system_logs (
        id SERIAL PRIMARY KEY,
        level iam.system_log_level NOT NULL DEFAULT 'info',
        message TEXT NOT NULL,
        meta JSONB,
        created_at TIMESTAMP NOT NULL DEFAULT now()
      )
    `);
    await client.query(`CREATE INDEX IF NOT EXISTS system_logs_created_at_idx ON iam.system_logs (created_at DESC)`);
    console.log('[migrate] ✅ Table system_logs vérifiée / créée.');

    // ── Lignes fixes ─────────────────────────────────────────────────────
    await client.query(`
      CREATE TABLE IF NOT EXISTS iam.lignes_fixes (
        id SERIAL PRIMARY KEY,
        nd TEXT NOT NULL,
        custcode TEXT,
        coordination_regionale TEXT,
        delegation TEXT,
        domiciliation TEXT,
        personne TEXT,
        qualite TEXT,
        date TEXT,
        deleted_at TIMESTAMP,
        deleted_by TEXT,
        created_at TIMESTAMP NOT NULL DEFAULT now(),
        updated_at TIMESTAMP NOT NULL DEFAULT now()
      )
    `);
    console.log('[migrate] ✅ Table lignes_fixes vérifiée / créée.');

    // ── Factures IAM ─────────────────────────────────────────────────────
    const factureStatutCheck = await client
      .query(`SELECT 1 FROM pg_type WHERE typname = 'facture_statut'`)
      .catch(() => null);
    if (!factureStatutCheck || factureStatutCheck.rowCount === 0) {
      await client.query(`CREATE TYPE iam.facture_statut AS ENUM ('reglee', 'impayee')`);
    }
    await client.query(`
      CREATE TABLE IF NOT EXISTS iam.factures (
        id SERIAL PRIMARY KEY,
        custcode TEXT NOT NULL,
        nd TEXT,
        nom TEXT,
        ref_facture TEXT NOT NULL,
        montant DOUBLE PRECISION NOT NULL DEFAULT 0,
        mois TEXT,
        echeance TEXT,
        produit TEXT,
        statut iam.facture_statut NOT NULL DEFAULT 'impayee',
        source_sheet TEXT,
        coordination_regionale TEXT,
        delegation TEXT,
        domiciliation TEXT,
        deleted_at TIMESTAMP,
        deleted_by TEXT,
        created_at TIMESTAMP NOT NULL DEFAULT now(),
        updated_at TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT factures_custcode_ref_unique UNIQUE (custcode, ref_facture)
      )
    `);
    await client.query(`CREATE INDEX IF NOT EXISTS factures_statut_idx ON iam.factures (statut)`);
    await client.query(`CREATE INDEX IF NOT EXISTS factures_custcode_idx ON iam.factures (custcode)`);
    console.log('[migrate] ✅ Table factures vérifiée / créée.');

    // ── Centre de notifications (état de lecture par utilisateur) ──────────
    await client.query(`
      CREATE TABLE IF NOT EXISTS iam.notification_reads (
        user_id INTEGER PRIMARY KEY,
        last_seen_at TIMESTAMP NOT NULL DEFAULT now()
      )
    `);
    console.log('[migrate] ✅ Table notification_reads vérifiée / créée.');

    // ── Registre des journaux (presse) par service ──────────────────────────
    await client.query(`
      CREATE TABLE IF NOT EXISTS iam.journal_entries (
        id SERIAL PRIMARY KEY,
        direction TEXT,
        service TEXT NOT NULL,
        journal_1 TEXT,
        journal_2 TEXT,
        journal_3 TEXT,
        deleted_at TIMESTAMP,
        deleted_by TEXT,
        created_at TIMESTAMP NOT NULL DEFAULT now(),
        updated_at TIMESTAMP NOT NULL DEFAULT now()
      )
    `);
    console.log('[migrate] ✅ Table journal_entries vérifiée / créée.');

    // ── Double authentification (colonnes sur users) ────────────────────────
    await client.query(`ALTER TABLE iam.users ADD COLUMN IF NOT EXISTS two_factor_enabled BOOLEAN NOT NULL DEFAULT false`);
    await client.query(`ALTER TABLE iam.users ADD COLUMN IF NOT EXISTS two_factor_secret TEXT`);
    console.log('[migrate] ✅ Colonnes two_factor_enabled / two_factor_secret vérifiées / ajoutées.');

    // ── Sessions actives (Centre de sécurité) ────────────────────────────────
    await client.query(`
      CREATE TABLE IF NOT EXISTS iam.sessions (
        id SERIAL PRIMARY KEY,
        jti TEXT NOT NULL UNIQUE,
        user_id INTEGER NOT NULL,
        ip_address TEXT,
        user_agent TEXT,
        created_at TIMESTAMP NOT NULL DEFAULT now(),
        last_seen_at TIMESTAMP NOT NULL DEFAULT now(),
        revoked_at TIMESTAMP
      )
    `);
    await client.query(`CREATE INDEX IF NOT EXISTS sessions_user_id_idx ON iam.sessions (user_id)`);
    await client.query(`CREATE INDEX IF NOT EXISTS sessions_jti_idx ON iam.sessions (jti)`);
    console.log('[migrate] ✅ Table sessions vérifiée / créée.');

    // ── Calendrier (événements personnalisés) ───────────────────────────────
    const calEventTypeCheck = await client
      .query(`SELECT 1 FROM pg_type WHERE typname = 'calendar_event_type'`)
      .catch(() => null);
    if (!calEventTypeCheck || calEventTypeCheck.rowCount === 0) {
      await client.query(`CREATE TYPE iam.calendar_event_type AS ENUM ('renouvellement', 'intervention', 'maintenance', 'conge', 'autre')`);
    }
    await client.query(`
      CREATE TABLE IF NOT EXISTS iam.calendar_events (
        id SERIAL PRIMARY KEY,
        title TEXT NOT NULL,
        type iam.calendar_event_type NOT NULL DEFAULT 'autre',
        date TEXT NOT NULL,
        description TEXT,
        created_by TEXT,
        deleted_at TIMESTAMP,
        deleted_by TEXT,
        created_at TIMESTAMP NOT NULL DEFAULT now()
      )
    `);
    console.log('[migrate] ✅ Table calendar_events vérifiée / créée.');

    // ── Historique des e-mails envoyés ───────────────────────────────────────
    await client.query(`
      CREATE TABLE IF NOT EXISTS iam.email_logs (
        id SERIAL PRIMARY KEY,
        to_address TEXT NOT NULL,
        subject TEXT NOT NULL,
        kind TEXT NOT NULL DEFAULT 'autre',
        related_id TEXT,
        success BOOLEAN NOT NULL,
        error TEXT,
        sent_by TEXT,
        created_at TIMESTAMP NOT NULL DEFAULT now()
      )
    `);
    console.log('[migrate] ✅ Table email_logs vérifiée / créée.');

    // ── Historique des messages WhatsApp ─────────────────────────────────────
    await client.query(`
      CREATE TABLE IF NOT EXISTS iam.whatsapp_messages (
        id SERIAL PRIMARY KEY,
        to_phone TEXT NOT NULL,
        message TEXT NOT NULL,
        kind TEXT NOT NULL DEFAULT 'autre',
        related_id TEXT,
        status TEXT NOT NULL DEFAULT 'queued',
        wa_message_id TEXT,
        error TEXT,
        sent_by TEXT,
        sent_at TIMESTAMP NOT NULL DEFAULT now(),
        read_at TIMESTAMP
      )
    `);
    console.log('[migrate] ✅ Table whatsapp_messages vérifiée / créée.');

    // ── Demandes de services (Logistique & Moyens Généraux) ───────────────
    const enumExists = async (name: string) => {
      const check = await client.query(`SELECT 1 FROM pg_type WHERE typname = $1`, [name]).catch(() => null);
      return !!check && (check.rowCount ?? 0) > 0;
    };
    if (!(await enumExists('service_request_type'))) {
      await client.query(`
        CREATE TYPE iam.service_request_type AS ENUM (
          'vehicule', 'deplacement', 'telephone', 'fourniture',
          'mobilier', 'maintenance', 'informatique', 'batiment', 'autre'
        )
      `);
    }
    if (!(await enumExists('service_request_priority'))) {
      await client.query(`CREATE TYPE iam.service_request_priority AS ENUM ('normale', 'urgente', 'critique')`);
    }
    if (!(await enumExists('service_request_status'))) {
      await client.query(`
        CREATE TYPE iam.service_request_status AS ENUM (
          'nouvelle', 'validee_chef', 'validee_responsable', 'affectee',
          'en_cours', 'terminee', 'annulee', 'archivee'
        )
      `);
    }
    await client.query(`
      CREATE TABLE IF NOT EXISTS iam.service_requests (
        id SERIAL PRIMARY KEY,
        numero TEXT NOT NULL UNIQUE,
        service_demandeur_id INTEGER NOT NULL,
        demandeur_nom TEXT NOT NULL,
        demandeur_telephone TEXT,
        type iam.service_request_type NOT NULL DEFAULT 'autre',
        objet TEXT NOT NULL,
        description TEXT,
        priorite iam.service_request_priority NOT NULL DEFAULT 'normale',
        statut iam.service_request_status NOT NULL DEFAULT 'nouvelle',
        agent_affecte_id INTEGER,
        date_souhaitee TEXT,
        created_by TEXT NOT NULL,
        deleted_at TIMESTAMP,
        deleted_by TEXT,
        created_at TIMESTAMP NOT NULL DEFAULT now(),
        updated_at TIMESTAMP NOT NULL DEFAULT now()
      )
    `);
    await client.query(`CREATE INDEX IF NOT EXISTS service_requests_statut_idx ON iam.service_requests (statut)`);
    await client.query(`CREATE INDEX IF NOT EXISTS service_requests_service_idx ON iam.service_requests (service_demandeur_id)`);
    await client.query(`CREATE INDEX IF NOT EXISTS service_requests_created_at_idx ON iam.service_requests (created_at DESC)`);
    await client.query(`
      CREATE TABLE IF NOT EXISTS iam.service_request_events (
        id SERIAL PRIMARY KEY,
        request_id INTEGER NOT NULL,
        statut iam.service_request_status NOT NULL,
        commentaire TEXT,
        action_par TEXT NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT now()
      )
    `);
    await client.query(`CREATE INDEX IF NOT EXISTS service_request_events_request_idx ON iam.service_request_events (request_id)`);
    console.log('[migrate] ✅ Tables service_requests / service_request_events vérifiées / créées.');

    // ── Parc Automobile ────────────────────────────────────────────────
    if (!(await enumExists('vehicule_statut'))) {
      await client.query(`CREATE TYPE iam.vehicule_statut AS ENUM ('disponible', 'en_mission', 'maintenance', 'hors_service')`);
    }
    if (!(await enumExists('vehicule_carburant'))) {
      await client.query(`CREATE TYPE iam.vehicule_carburant AS ENUM ('essence', 'diesel', 'hybride', 'electrique')`);
    }
    await client.query(`
      CREATE TABLE IF NOT EXISTS iam.vehicules (
        id SERIAL PRIMARY KEY,
        immatriculation TEXT NOT NULL UNIQUE,
        marque TEXT NOT NULL,
        modele TEXT NOT NULL,
        annee INTEGER,
        carburant iam.vehicule_carburant NOT NULL DEFAULT 'diesel',
        kilometrage INTEGER NOT NULL DEFAULT 0,
        statut iam.vehicule_statut NOT NULL DEFAULT 'disponible',
        assurance_expiration TEXT,
        visite_technique_expiration TEXT,
        chauffeur_attitre_id INTEGER,
        notes TEXT,
        deleted_at TIMESTAMP,
        deleted_by TEXT,
        created_at TIMESTAMP NOT NULL DEFAULT now(),
        updated_at TIMESTAMP NOT NULL DEFAULT now()
      )
    `);
    await client.query(`CREATE INDEX IF NOT EXISTS vehicules_statut_idx ON iam.vehicules (statut)`);
    // Entretien — vidange (date de la dernière vidange / prochaine échéance)
    await client.query(`ALTER TABLE iam.vehicules ADD COLUMN IF NOT EXISTS derniere_vidange TEXT`);
    await client.query(`ALTER TABLE iam.vehicules ADD COLUMN IF NOT EXISTS vidange_expiration TEXT`);
    console.log('[migrate] ✅ Colonnes vidange (derniere_vidange / vidange_expiration) vérifiées / ajoutées.');
    await client.query(`
      CREATE TABLE IF NOT EXISTS iam.vehicule_events (
        id SERIAL PRIMARY KEY,
        vehicule_id INTEGER NOT NULL,
        statut iam.vehicule_statut NOT NULL,
        commentaire TEXT,
        action_par TEXT NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT now()
      )
    `);
    await client.query(`CREATE INDEX IF NOT EXISTS vehicule_events_vehicule_idx ON iam.vehicule_events (vehicule_id)`);
    console.log('[migrate] ✅ Tables vehicules / vehicule_events vérifiées / créées.');

    // ── Déplacements (ordres de mission) ──────────────────────────────
    if (!(await enumExists('deplacement_statut'))) {
      await client.query(`CREATE TYPE iam.deplacement_statut AS ENUM ('planifie', 'en_cours', 'termine', 'annule')`);
    }
    await client.query(`
      CREATE TABLE IF NOT EXISTS iam.deplacements (
        id SERIAL PRIMARY KEY,
        numero TEXT NOT NULL UNIQUE,
        vehicule_id INTEGER,
        chauffeur_id INTEGER,
        demande_id INTEGER,
        service_demandeur_id INTEGER NOT NULL,
        objet TEXT NOT NULL,
        destination TEXT,
        date_depart TEXT NOT NULL,
        date_retour_prevue TEXT,
        date_retour_effective TEXT,
        kilometrage_depart INTEGER,
        kilometrage_retour INTEGER,
        statut iam.deplacement_statut NOT NULL DEFAULT 'planifie',
        rapport_mission TEXT,
        created_by TEXT NOT NULL,
        deleted_at TIMESTAMP,
        deleted_by TEXT,
        created_at TIMESTAMP NOT NULL DEFAULT now(),
        updated_at TIMESTAMP NOT NULL DEFAULT now()
      )
    `);
    await client.query(`CREATE INDEX IF NOT EXISTS deplacements_statut_idx ON iam.deplacements (statut)`);
    await client.query(`CREATE INDEX IF NOT EXISTS deplacements_vehicule_idx ON iam.deplacements (vehicule_id)`);
    console.log('[migrate] ✅ Table deplacements vérifiée / créée.');

    // ── Portail chauffeur : nouveau rôle + rattachement compte ─────────
    await client.query(`ALTER TYPE iam.user_role ADD VALUE IF NOT EXISTS 'CHAUFFEUR'`);
    await client.query(`ALTER TABLE iam.chauffeurs ADD COLUMN IF NOT EXISTS user_id INTEGER`);
    console.log('[migrate] ✅ Rôle CHAUFFEUR et rattachement de compte vérifiés / créés.');

    // ── Rôle Chef de Division (hiérarchie intermédiaire) ───────────────
    await client.query(`ALTER TYPE iam.user_role ADD VALUE IF NOT EXISTS 'CHEF_DIVISION'`);
    console.log('[migrate] ✅ Rôle CHEF_DIVISION vérifié / créé.');

    // ── Téléphonie : enrichissement des lignes existantes ──────────────
    // (PIN/PUK, rattachement à l'organigramme, consommation mensuelle,
    //  historique via la table audit_logs déjà en place — pas de doublon)
    await client.query(`ALTER TABLE iam.lignes ADD COLUMN IF NOT EXISTS pin TEXT`);
    await client.query(`ALTER TABLE iam.lignes ADD COLUMN IF NOT EXISTS puk TEXT`);
    await client.query(`ALTER TABLE iam.lignes ADD COLUMN IF NOT EXISTS service_id INTEGER`);
    await client.query(`ALTER TABLE iam.lignes ADD COLUMN IF NOT EXISTS consommation_mensuelle_dh INTEGER`);
    await client.query(`ALTER TABLE iam.lignes_fixes ADD COLUMN IF NOT EXISTS service_id INTEGER`);
    await client.query(`ALTER TABLE iam.lignes_fixes ADD COLUMN IF NOT EXISTS consommation_mensuelle_dh INTEGER`);
    console.log('[migrate] ✅ Colonnes Téléphonie (PIN/PUK, service, consommation) vérifiées / créées.');

    // ── Chauffeurs (indépendants des comptes utilisateurs) ─────────────
    if (!(await enumExists('chauffeur_statut'))) {
      await client.query(`CREATE TYPE iam.chauffeur_statut AS ENUM ('disponible', 'en_mission', 'indisponible')`);
    }
    await client.query(`
      CREATE TABLE IF NOT EXISTS iam.chauffeurs (
        id SERIAL PRIMARY KEY,
        nom TEXT NOT NULL,
        telephone TEXT,
        permis TEXT,
        statut iam.chauffeur_statut NOT NULL DEFAULT 'disponible',
        notes TEXT,
        deleted_at TIMESTAMP,
        deleted_by TEXT,
        created_at TIMESTAMP NOT NULL DEFAULT now(),
        updated_at TIMESTAMP NOT NULL DEFAULT now()
      )
    `);
    await client.query(`CREATE INDEX IF NOT EXISTS chauffeurs_statut_idx ON iam.chauffeurs (statut)`);
    console.log('[migrate] ✅ Table chauffeurs vérifiée / créée.');
    // Badge de télépéage Jawaz personnel du chauffeur
    await client.query(`ALTER TABLE iam.chauffeurs ADD COLUMN IF NOT EXISTS jawaz_numero TEXT`);
    await client.query(`ALTER TABLE iam.chauffeurs ADD COLUMN IF NOT EXISTS jawaz_solde DOUBLE PRECISION NOT NULL DEFAULT 0`);
    console.log('[migrate] ✅ Colonnes Jawaz (jawaz_numero / jawaz_solde) vérifiées / ajoutées.');

    // ── Personnel transporté (passagers d'un déplacement) ──────────────
    await client.query(`
      CREATE TABLE IF NOT EXISTS iam.deplacement_passagers (
        id SERIAL PRIMARY KEY,
        deplacement_id INTEGER NOT NULL,
        nom TEXT NOT NULL,
        service_id INTEGER,
        created_at TIMESTAMP NOT NULL DEFAULT now()
      )
    `);
    await client.query(`CREATE INDEX IF NOT EXISTS deplacement_passagers_deplacement_idx ON iam.deplacement_passagers (deplacement_id)`);
    // Auto-réparation : si la table existait déjà (créée par une exécution
    // antérieure de la plateforme), le CREATE TABLE IF NOT EXISTS ci-dessus
    // ne fait rien et la colonne service_id pourrait manquer.
    await client.query(`ALTER TABLE iam.deplacement_passagers ADD COLUMN IF NOT EXISTS service_id INTEGER`);
    console.log('[migrate] ✅ Table deplacement_passagers vérifiée / créée.');

    // ── Demandes de chauffeur (module Logistique) ───────────────────────
    // Table absente de toute migration jusqu'ici — ajoutée pour que le
    // module fonctionne dès le démarrage, sans script manuel séparé.
    if (!(await enumExists('demande_chauffeur_statut'))) {
      await client.query(`
        CREATE TYPE iam.demande_chauffeur_statut AS ENUM (
          'en_attente', 'assignee', 'confirmee', 'validee', 'refusee', 'terminee'
        )
      `);
    } else {
      // Le chauffeur doit pouvoir accepter/refuser dès l'assignation, avant
      // même la création de l'ordre de mission : nouveau statut intermédiaire.
      await client.query(`ALTER TYPE iam.demande_chauffeur_statut ADD VALUE IF NOT EXISTS 'confirmee'`);
    }
    if (!(await enumExists('demande_chauffeur_priorite'))) {
      await client.query(`CREATE TYPE iam.demande_chauffeur_priorite AS ENUM ('normale', 'urgente', 'critique')`);
    }
    await client.query(`
      CREATE TABLE IF NOT EXISTS iam.demande_chauffeur (
        id SERIAL PRIMARY KEY,
        numero TEXT NOT NULL UNIQUE,
        service_demandeur_id INTEGER NOT NULL,
        demandeur_nom TEXT NOT NULL,
        demandeur_telephone TEXT,
        priorite iam.demande_chauffeur_priorite NOT NULL DEFAULT 'normale',
        chauffeur_id INTEGER,
        statut iam.demande_chauffeur_statut NOT NULL DEFAULT 'en_attente',
        mission_id INTEGER,
        observations TEXT,
        motif_refus TEXT,
        created_by TEXT NOT NULL,
        assigne_par TEXT,
        valide_par TEXT,
        deleted_at TIMESTAMP,
        deleted_by TEXT,
        created_at TIMESTAMP NOT NULL DEFAULT now(),
        updated_at TIMESTAMP NOT NULL DEFAULT now()
      )
    `);
    await client.query(`CREATE INDEX IF NOT EXISTS demande_chauffeur_statut_idx ON iam.demande_chauffeur (statut)`);
    await client.query(`CREATE INDEX IF NOT EXISTS demande_chauffeur_service_idx ON iam.demande_chauffeur (service_demandeur_id)`);
    console.log('[migrate] ✅ Table demande_chauffeur vérifiée / créée.');

    // ── Parc Automobile : entretien (vidange kilométrique) + Jawaz véhicule ──
    await client.query(`
      ALTER TABLE iam.vehicules
        ADD COLUMN IF NOT EXISTS kilometrage_derniere_vidange INTEGER,
        ADD COLUMN IF NOT EXISTS kilometrage_prochaine_vidange INTEGER,
        ADD COLUMN IF NOT EXISTS type_huile TEXT,
        ADD COLUMN IF NOT EXISTS garage_vidange TEXT,
        ADD COLUMN IF NOT EXISTS vidange_observations TEXT,
        ADD COLUMN IF NOT EXISTS jawaz_numero TEXT,
        ADD COLUMN IF NOT EXISTS jawaz_solde DOUBLE PRECISION NOT NULL DEFAULT 0,
        ADD COLUMN IF NOT EXISTS jawaz_derniere_recharge TEXT,
        ADD COLUMN IF NOT EXISTS jawaz_seuil_alerte DOUBLE PRECISION NOT NULL DEFAULT 100
    `);
    console.log('[migrate] ✅ Colonnes entretien (vidange km) et Jawaz vérifiées sur iam.vehicules.');

    // ── Fiche chauffeur enrichie : identité, permis, affectation, documents ──
    await client.query(`
      ALTER TABLE iam.chauffeurs
        ADD COLUMN IF NOT EXISTS cin TEXT,
        ADD COLUMN IF NOT EXISTS email TEXT,
        ADD COLUMN IF NOT EXISTS adresse TEXT,
        ADD COLUMN IF NOT EXISTS date_naissance TEXT,
        ADD COLUMN IF NOT EXISTS photo_url TEXT,
        ADD COLUMN IF NOT EXISTS permis_numero TEXT,
        ADD COLUMN IF NOT EXISTS permis_date_obtention TEXT,
        ADD COLUMN IF NOT EXISTS permis_date_expiration TEXT,
        ADD COLUMN IF NOT EXISTS service_id INTEGER,
        ADD COLUMN IF NOT EXISTS responsable TEXT,
        ADD COLUMN IF NOT EXISTS remarques TEXT,
        ADD COLUMN IF NOT EXISTS scan_cin_url TEXT,
        ADD COLUMN IF NOT EXISTS scan_permis_url TEXT,
        ADD COLUMN IF NOT EXISTS certificat_medical_url TEXT
    `);
    console.log('[migrate] ✅ Colonnes fiche chauffeur enrichie vérifiées sur iam.chauffeurs.');

    // ── Module Maintenance : historique complet par véhicule ────────────────
    if (!(await enumExists('vehicule_maintenance_type'))) {
      await client.query(`
        CREATE TYPE iam.vehicule_maintenance_type AS ENUM (
          'vidange', 'pneus', 'batterie', 'freins', 'embrayage', 'courroie',
          'reparation', 'accident', 'autre'
        )
      `);
    }
    if (!(await enumExists('vehicule_maintenance_document_type'))) {
      await client.query(`
        CREATE TYPE iam.vehicule_maintenance_document_type AS ENUM ('facture', 'document')
      `);
    }
    await client.query(`
      CREATE TABLE IF NOT EXISTS iam.vehicule_maintenance (
        id SERIAL PRIMARY KEY,
        vehicule_id INTEGER NOT NULL,
        type iam.vehicule_maintenance_type NOT NULL,
        date TEXT NOT NULL,
        kilometrage INTEGER,
        garage TEXT,
        description TEXT,
        pieces_remplacees TEXT,
        cout DOUBLE PRECISION NOT NULL DEFAULT 0,
        created_by TEXT NOT NULL,
        deleted_at TIMESTAMP,
        deleted_by TEXT,
        created_at TIMESTAMP NOT NULL DEFAULT now(),
        updated_at TIMESTAMP NOT NULL DEFAULT now()
      )
    `);
    await client.query(`CREATE INDEX IF NOT EXISTS vehicule_maintenance_vehicule_idx ON iam.vehicule_maintenance (vehicule_id)`);
    await client.query(`CREATE INDEX IF NOT EXISTS vehicule_maintenance_type_idx ON iam.vehicule_maintenance (type)`);
    await client.query(`
      CREATE TABLE IF NOT EXISTS iam.vehicule_maintenance_documents (
        id SERIAL PRIMARY KEY,
        maintenance_id INTEGER NOT NULL,
        type iam.vehicule_maintenance_document_type NOT NULL DEFAULT 'document',
        filename TEXT NOT NULL,
        original_name TEXT,
        mime_type TEXT,
        size_bytes INTEGER,
        uploaded_by TEXT NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT now()
      )
    `);
    await client.query(`CREATE INDEX IF NOT EXISTS vehicule_maintenance_documents_maintenance_idx ON iam.vehicule_maintenance_documents (maintenance_id)`);
    console.log('[migrate] ✅ Table vehicule_maintenance (+ documents) vérifiée / créée.');

    // ── Responsabilité du véhicule : photo + états déclarés par le chauffeur ──
    if (!(await enumExists('vehicule_etat_pneus'))) {
      await client.query(`CREATE TYPE iam.vehicule_etat_pneus AS ENUM ('bon_etat', 'usure_avant', 'usure_arriere', 'crevaison', 'pression_faible')`);
    }
    if (!(await enumExists('vehicule_etat_batterie'))) {
      await client.query(`CREATE TYPE iam.vehicule_etat_batterie AS ENUM ('bonne', 'faible', 'a_remplacer')`);
    }
    if (!(await enumExists('vehicule_etat_freins'))) {
      await client.query(`CREATE TYPE iam.vehicule_etat_freins AS ENUM ('normaux', 'bruit', 'usure')`);
    }
    if (!(await enumExists('vehicule_etat_eclairage'))) {
      await client.query(`CREATE TYPE iam.vehicule_etat_eclairage AS ENUM ('fonctionnel', 'ampoule_grillee')`);
    }
    if (!(await enumExists('vehicule_etat_climatisation'))) {
      await client.query(`CREATE TYPE iam.vehicule_etat_climatisation AS ENUM ('fonctionne', 'panne')`);
    }
    await client.query(`
      ALTER TABLE iam.vehicules
        ADD COLUMN IF NOT EXISTS photo_url TEXT,
        ADD COLUMN IF NOT EXISTS etat_pneus iam.vehicule_etat_pneus,
        ADD COLUMN IF NOT EXISTS etat_batterie iam.vehicule_etat_batterie,
        ADD COLUMN IF NOT EXISTS etat_freins iam.vehicule_etat_freins,
        ADD COLUMN IF NOT EXISTS etat_eclairage iam.vehicule_etat_eclairage,
        ADD COLUMN IF NOT EXISTS etat_climatisation iam.vehicule_etat_climatisation
    `);
    console.log('[migrate] ✅ Colonnes photo + états déclarés vérifiées sur iam.vehicules.');

    // Statuts chauffeur étendus (congé / absent), en plus de disponible / en_mission / indisponible.
    await client.query(`ALTER TYPE iam.chauffeur_statut ADD VALUE IF NOT EXISTS 'en_conge'`);
    await client.query(`ALTER TYPE iam.chauffeur_statut ADD VALUE IF NOT EXISTS 'absent'`);
    console.log('[migrate] ✅ Statuts chauffeur étendus (en_conge, absent) vérifiés.');

    // ── Historique des affectations véhicule ↔ chauffeur (responsabilité) ────
    await client.query(`
      CREATE TABLE IF NOT EXISTS iam.vehicule_affectations (
        id SERIAL PRIMARY KEY,
        vehicule_id INTEGER NOT NULL,
        chauffeur_id INTEGER NOT NULL,
        date_affectation TEXT NOT NULL,
        date_fin TEXT,
        responsable TEXT NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT now()
      )
    `);
    await client.query(`CREATE INDEX IF NOT EXISTS vehicule_affectations_vehicule_idx ON iam.vehicule_affectations (vehicule_id)`);
    await client.query(`CREATE INDEX IF NOT EXISTS vehicule_affectations_chauffeur_idx ON iam.vehicule_affectations (chauffeur_id)`);
    console.log('[migrate] ✅ Table vehicule_affectations vérifiée / créée.');

    // ── Déclarations chauffeur ("Signaler un problème") ──────────────────────
    if (!(await enumExists('declaration_categorie'))) {
      await client.query(`
        CREATE TYPE iam.declaration_categorie AS ENUM (
          'vidange', 'pneus', 'batterie', 'freins', 'embrayage', 'moteur',
          'climatisation', 'carrosserie', 'jawaz', 'assurance', 'autre'
        )
      `);
    }
    if (!(await enumExists('declaration_urgence'))) {
      await client.query(`CREATE TYPE iam.declaration_urgence AS ENUM ('normal', 'urgent', 'critique')`);
    }
    if (!(await enumExists('declaration_statut'))) {
      await client.query(`
        CREATE TYPE iam.declaration_statut AS ENUM (
          'nouvelle', 'en_cours', 'validee', 'reparation_programmee', 'terminee', 'archivee'
        )
      `);
    }
    if (!(await enumExists('declaration_media_type'))) {
      await client.query(`CREATE TYPE iam.declaration_media_type AS ENUM ('photo', 'video')`);
    }
    await client.query(`
      CREATE TABLE IF NOT EXISTS iam.vehicule_declarations (
        id SERIAL PRIMARY KEY,
        vehicule_id INTEGER NOT NULL,
        chauffeur_id INTEGER NOT NULL,
        categorie iam.declaration_categorie NOT NULL,
        description TEXT,
        urgence iam.declaration_urgence NOT NULL DEFAULT 'normal',
        statut iam.declaration_statut NOT NULL DEFAULT 'nouvelle',
        commentaire_traitement TEXT,
        traite_par TEXT,
        created_at TIMESTAMP NOT NULL DEFAULT now(),
        updated_at TIMESTAMP NOT NULL DEFAULT now()
      )
    `);
    await client.query(`CREATE INDEX IF NOT EXISTS vehicule_declarations_vehicule_idx ON iam.vehicule_declarations (vehicule_id)`);
    await client.query(`CREATE INDEX IF NOT EXISTS vehicule_declarations_chauffeur_idx ON iam.vehicule_declarations (chauffeur_id)`);
    await client.query(`CREATE INDEX IF NOT EXISTS vehicule_declarations_statut_idx ON iam.vehicule_declarations (statut)`);
    await client.query(`
      CREATE TABLE IF NOT EXISTS iam.vehicule_declaration_media (
        id SERIAL PRIMARY KEY,
        declaration_id INTEGER NOT NULL,
        type iam.declaration_media_type NOT NULL,
        filename TEXT NOT NULL,
        original_name TEXT,
        mime_type TEXT,
        size_bytes INTEGER,
        uploaded_by TEXT NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT now()
      )
    `);
    await client.query(`CREATE INDEX IF NOT EXISTS vehicule_declaration_media_declaration_idx ON iam.vehicule_declaration_media (declaration_id)`);
    await client.query(`
      CREATE TABLE IF NOT EXISTS iam.vehicule_declaration_events (
        id SERIAL PRIMARY KEY,
        declaration_id INTEGER NOT NULL,
        statut iam.declaration_statut NOT NULL,
        commentaire TEXT,
        action_par TEXT NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT now()
      )
    `);
    await client.query(`CREATE INDEX IF NOT EXISTS vehicule_declaration_events_declaration_idx ON iam.vehicule_declaration_events (declaration_id)`);
    console.log('[migrate] ✅ Tables vehicule_declarations (+ media, events) vérifiées / créées.');
  } catch (err: unknown) {
    // Si une table de base n'existe pas encore, elle sera créée par
    // drizzle-kit push plus tard : on ignore silencieusement ce cas précis.
    const msg = err instanceof Error ? err.message : String(err);
    if (!msg.includes("n'existe pas") && !msg.includes('does not exist')) {
      console.error('[migrate] ⚠️ Migration:', msg);
    }
  } finally {
    client.release();
  }
}
