--
-- PostgreSQL database dump
--

\restrict 7wvgBl9IedGOWdSHXadLerY45abuNA6bhPwpf7JGh0fUWDJKatNS42Ee5bywImd

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY iam.org_nodes DROP CONSTRAINT IF EXISTS org_nodes_parent_id_fkey;
DROP INDEX IF EXISTS iam.vehicules_statut_idx;
DROP INDEX IF EXISTS iam.vehicule_events_vehicule_idx;
DROP INDEX IF EXISTS iam.system_logs_created_at_idx;
DROP INDEX IF EXISTS iam.sessions_user_id_idx;
DROP INDEX IF EXISTS iam.sessions_jti_idx;
DROP INDEX IF EXISTS iam.service_requests_statut_idx;
DROP INDEX IF EXISTS iam.service_requests_service_idx;
DROP INDEX IF EXISTS iam.service_requests_created_at_idx;
DROP INDEX IF EXISTS iam.service_request_events_request_idx;
DROP INDEX IF EXISTS iam.idx_activity_logs_created_at;
DROP INDEX IF EXISTS iam.factures_statut_idx;
DROP INDEX IF EXISTS iam.factures_custcode_idx;
DROP INDEX IF EXISTS iam.deplacements_vehicule_idx;
DROP INDEX IF EXISTS iam.deplacements_statut_idx;
DROP INDEX IF EXISTS iam.deplacement_photos_dep_idx;
DROP INDEX IF EXISTS iam.deplacement_passagers_deplacement_idx;
DROP INDEX IF EXISTS iam.deplacement_gps_dep_idx;
DROP INDEX IF EXISTS iam.deplacement_gps_created_at_idx;
DROP INDEX IF EXISTS iam.deplacement_events_dep_idx;
DROP INDEX IF EXISTS iam.connection_logs_created_at_idx;
DROP INDEX IF EXISTS iam.chauffeurs_statut_idx;
DROP INDEX IF EXISTS iam.chauffeur_events_chauffeur_idx;
DROP INDEX IF EXISTS iam.audit_logs_entity_idx;
DROP INDEX IF EXISTS iam.audit_logs_created_at_idx;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_username_unique;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.sheet_rules DROP CONSTRAINT IF EXISTS sheet_rules_role_sheet_unique;
ALTER TABLE IF EXISTS ONLY public.sheet_rules DROP CONSTRAINT IF EXISTS sheet_rules_pkey;
ALTER TABLE IF EXISTS ONLY public.lignes DROP CONSTRAINT IF EXISTS lignes_pkey;
ALTER TABLE IF EXISTS ONLY public.custom_fields DROP CONSTRAINT IF EXISTS custom_fields_pkey;
ALTER TABLE IF EXISTS ONLY public.correction_rules DROP CONSTRAINT IF EXISTS correction_rules_source_target_unique;
ALTER TABLE IF EXISTS ONLY public.correction_rules DROP CONSTRAINT IF EXISTS correction_rules_pkey;
ALTER TABLE IF EXISTS ONLY iam.whatsapp_messages DROP CONSTRAINT IF EXISTS whatsapp_messages_pkey;
ALTER TABLE IF EXISTS ONLY iam.vehicules DROP CONSTRAINT IF EXISTS vehicules_pkey;
ALTER TABLE IF EXISTS ONLY iam.vehicules DROP CONSTRAINT IF EXISTS vehicules_immatriculation_key;
ALTER TABLE IF EXISTS ONLY iam.vehicule_events DROP CONSTRAINT IF EXISTS vehicule_events_pkey;
ALTER TABLE IF EXISTS ONLY iam.users DROP CONSTRAINT IF EXISTS users_username_unique;
ALTER TABLE IF EXISTS ONLY iam.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY iam.system_settings DROP CONSTRAINT IF EXISTS system_settings_pkey;
ALTER TABLE IF EXISTS ONLY iam.system_logs DROP CONSTRAINT IF EXISTS system_logs_pkey;
ALTER TABLE IF EXISTS ONLY iam.sheet_rules DROP CONSTRAINT IF EXISTS sheet_rules_role_sheet_unique;
ALTER TABLE IF EXISTS ONLY iam.sheet_rules DROP CONSTRAINT IF EXISTS sheet_rules_pkey;
ALTER TABLE IF EXISTS ONLY iam.sessions DROP CONSTRAINT IF EXISTS sessions_pkey;
ALTER TABLE IF EXISTS ONLY iam.sessions DROP CONSTRAINT IF EXISTS sessions_jti_key;
ALTER TABLE IF EXISTS ONLY iam.service_requests DROP CONSTRAINT IF EXISTS service_requests_pkey;
ALTER TABLE IF EXISTS ONLY iam.service_requests DROP CONSTRAINT IF EXISTS service_requests_numero_key;
ALTER TABLE IF EXISTS ONLY iam.service_request_events DROP CONSTRAINT IF EXISTS service_request_events_pkey;
ALTER TABLE IF EXISTS ONLY iam.org_nodes DROP CONSTRAINT IF EXISTS org_nodes_pkey;
ALTER TABLE IF EXISTS ONLY iam.notification_reads DROP CONSTRAINT IF EXISTS notification_reads_pkey;
ALTER TABLE IF EXISTS ONLY iam.lignes DROP CONSTRAINT IF EXISTS lignes_pkey;
ALTER TABLE IF EXISTS ONLY iam.lignes_fixes DROP CONSTRAINT IF EXISTS lignes_fixes_pkey;
ALTER TABLE IF EXISTS ONLY iam.journal_entries DROP CONSTRAINT IF EXISTS journal_entries_pkey;
ALTER TABLE IF EXISTS ONLY iam.factures DROP CONSTRAINT IF EXISTS factures_pkey;
ALTER TABLE IF EXISTS ONLY iam.factures DROP CONSTRAINT IF EXISTS factures_custcode_ref_unique;
ALTER TABLE IF EXISTS ONLY iam.email_logs DROP CONSTRAINT IF EXISTS email_logs_pkey;
ALTER TABLE IF EXISTS ONLY iam.deplacements DROP CONSTRAINT IF EXISTS deplacements_pkey;
ALTER TABLE IF EXISTS ONLY iam.deplacements DROP CONSTRAINT IF EXISTS deplacements_numero_key;
ALTER TABLE IF EXISTS ONLY iam.deplacement_photos DROP CONSTRAINT IF EXISTS deplacement_photos_pkey;
ALTER TABLE IF EXISTS ONLY iam.deplacement_passagers DROP CONSTRAINT IF EXISTS deplacement_passagers_pkey;
ALTER TABLE IF EXISTS ONLY iam.deplacement_gps_points DROP CONSTRAINT IF EXISTS deplacement_gps_points_pkey;
ALTER TABLE IF EXISTS ONLY iam.deplacement_events DROP CONSTRAINT IF EXISTS deplacement_events_pkey;
ALTER TABLE IF EXISTS ONLY iam.dashboard_snapshot DROP CONSTRAINT IF EXISTS dashboard_snapshot_pkey;
ALTER TABLE IF EXISTS ONLY iam.custom_fields DROP CONSTRAINT IF EXISTS custom_fields_pkey;
ALTER TABLE IF EXISTS ONLY iam.correction_rules DROP CONSTRAINT IF EXISTS correction_rules_source_target_unique;
ALTER TABLE IF EXISTS ONLY iam.correction_rules DROP CONSTRAINT IF EXISTS correction_rules_pkey;
ALTER TABLE IF EXISTS ONLY iam.connection_logs DROP CONSTRAINT IF EXISTS connection_logs_pkey;
ALTER TABLE IF EXISTS ONLY iam.chauffeurs DROP CONSTRAINT IF EXISTS chauffeurs_pkey;
ALTER TABLE IF EXISTS ONLY iam.chauffeur_events DROP CONSTRAINT IF EXISTS chauffeur_events_pkey;
ALTER TABLE IF EXISTS ONLY iam.calendar_events DROP CONSTRAINT IF EXISTS calendar_events_pkey;
ALTER TABLE IF EXISTS ONLY iam.audit_logs DROP CONSTRAINT IF EXISTS audit_logs_pkey;
ALTER TABLE IF EXISTS ONLY iam.activity_logs DROP CONSTRAINT IF EXISTS activity_logs_pkey;
ALTER TABLE IF EXISTS public.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.sheet_rules ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.lignes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.custom_fields ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.correction_rules ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS iam.whatsapp_messages ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS iam.vehicules ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS iam.vehicule_events ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS iam.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS iam.system_logs ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS iam.sheet_rules ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS iam.sessions ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS iam.service_requests ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS iam.service_request_events ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS iam.org_nodes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS iam.lignes_fixes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS iam.lignes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS iam.journal_entries ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS iam.factures ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS iam.email_logs ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS iam.deplacements ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS iam.deplacement_photos ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS iam.deplacement_passagers ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS iam.deplacement_gps_points ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS iam.deplacement_events ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS iam.custom_fields ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS iam.correction_rules ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS iam.connection_logs ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS iam.chauffeurs ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS iam.chauffeur_events ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS iam.calendar_events ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS iam.audit_logs ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS iam.activity_logs ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.users_id_seq;
DROP TABLE IF EXISTS public.users;
DROP SEQUENCE IF EXISTS public.sheet_rules_id_seq;
DROP TABLE IF EXISTS public.sheet_rules;
DROP SEQUENCE IF EXISTS public.lignes_id_seq;
DROP TABLE IF EXISTS public.lignes;
DROP SEQUENCE IF EXISTS public.custom_fields_id_seq;
DROP TABLE IF EXISTS public.custom_fields;
DROP SEQUENCE IF EXISTS public.correction_rules_id_seq;
DROP TABLE IF EXISTS public.correction_rules;
DROP SEQUENCE IF EXISTS iam.whatsapp_messages_id_seq;
DROP TABLE IF EXISTS iam.whatsapp_messages;
DROP SEQUENCE IF EXISTS iam.vehicules_id_seq;
DROP TABLE IF EXISTS iam.vehicules;
DROP SEQUENCE IF EXISTS iam.vehicule_events_id_seq;
DROP TABLE IF EXISTS iam.vehicule_events;
DROP SEQUENCE IF EXISTS iam.users_id_seq;
DROP TABLE IF EXISTS iam.users;
DROP TABLE IF EXISTS iam.system_settings;
DROP SEQUENCE IF EXISTS iam.system_logs_id_seq;
DROP TABLE IF EXISTS iam.system_logs;
DROP SEQUENCE IF EXISTS iam.sheet_rules_id_seq;
DROP TABLE IF EXISTS iam.sheet_rules;
DROP SEQUENCE IF EXISTS iam.sessions_id_seq;
DROP TABLE IF EXISTS iam.sessions;
DROP SEQUENCE IF EXISTS iam.service_requests_id_seq;
DROP TABLE IF EXISTS iam.service_requests;
DROP SEQUENCE IF EXISTS iam.service_request_events_id_seq;
DROP TABLE IF EXISTS iam.service_request_events;
DROP SEQUENCE IF EXISTS iam.org_nodes_id_seq;
DROP TABLE IF EXISTS iam.org_nodes;
DROP TABLE IF EXISTS iam.notification_reads;
DROP SEQUENCE IF EXISTS iam.lignes_id_seq;
DROP SEQUENCE IF EXISTS iam.lignes_fixes_id_seq;
DROP TABLE IF EXISTS iam.lignes_fixes;
DROP TABLE IF EXISTS iam.lignes;
DROP SEQUENCE IF EXISTS iam.journal_entries_id_seq;
DROP TABLE IF EXISTS iam.journal_entries;
DROP SEQUENCE IF EXISTS iam.factures_id_seq;
DROP TABLE IF EXISTS iam.factures;
DROP SEQUENCE IF EXISTS iam.email_logs_id_seq;
DROP TABLE IF EXISTS iam.email_logs;
DROP SEQUENCE IF EXISTS iam.deplacements_id_seq;
DROP TABLE IF EXISTS iam.deplacements;
DROP SEQUENCE IF EXISTS iam.deplacement_photos_id_seq;
DROP TABLE IF EXISTS iam.deplacement_photos;
DROP SEQUENCE IF EXISTS iam.deplacement_passagers_id_seq;
DROP TABLE IF EXISTS iam.deplacement_passagers;
DROP SEQUENCE IF EXISTS iam.deplacement_gps_points_id_seq;
DROP TABLE IF EXISTS iam.deplacement_gps_points;
DROP SEQUENCE IF EXISTS iam.deplacement_events_id_seq;
DROP TABLE IF EXISTS iam.deplacement_events;
DROP TABLE IF EXISTS iam.dashboard_snapshot;
DROP SEQUENCE IF EXISTS iam.custom_fields_id_seq;
DROP TABLE IF EXISTS iam.custom_fields;
DROP SEQUENCE IF EXISTS iam.correction_rules_id_seq;
DROP TABLE IF EXISTS iam.correction_rules;
DROP SEQUENCE IF EXISTS iam.connection_logs_id_seq;
DROP TABLE IF EXISTS iam.connection_logs;
DROP SEQUENCE IF EXISTS iam.chauffeurs_id_seq;
DROP TABLE IF EXISTS iam.chauffeurs;
DROP SEQUENCE IF EXISTS iam.chauffeur_events_id_seq;
DROP TABLE IF EXISTS iam.chauffeur_events;
DROP SEQUENCE IF EXISTS iam.calendar_events_id_seq;
DROP TABLE IF EXISTS iam.calendar_events;
DROP SEQUENCE IF EXISTS iam.audit_logs_id_seq;
DROP TABLE IF EXISTS iam.audit_logs;
DROP SEQUENCE IF EXISTS iam.activity_logs_id_seq;
DROP TABLE IF EXISTS iam.activity_logs;
DROP TYPE IF EXISTS public.user_role;
DROP TYPE IF EXISTS iam.vehicule_statut;
DROP TYPE IF EXISTS iam.vehicule_carburant;
DROP TYPE IF EXISTS iam.user_role;
DROP TYPE IF EXISTS iam.system_log_level;
DROP TYPE IF EXISTS iam.service_request_type;
DROP TYPE IF EXISTS iam.service_request_status;
DROP TYPE IF EXISTS iam.service_request_priority;
DROP TYPE IF EXISTS iam.photo_type;
DROP TYPE IF EXISTS iam.facture_statut;
DROP TYPE IF EXISTS iam.deplacement_statut;
DROP TYPE IF EXISTS iam.chauffeur_statut;
DROP TYPE IF EXISTS iam.calendar_event_type;
DROP SCHEMA IF EXISTS iam;
--
-- Name: iam; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA iam;


--
-- Name: calendar_event_type; Type: TYPE; Schema: iam; Owner: -
--

CREATE TYPE iam.calendar_event_type AS ENUM (
    'renouvellement',
    'intervention',
    'maintenance',
    'conge',
    'autre'
);


--
-- Name: chauffeur_statut; Type: TYPE; Schema: iam; Owner: -
--

CREATE TYPE iam.chauffeur_statut AS ENUM (
    'disponible',
    'en_mission',
    'indisponible'
);


--
-- Name: deplacement_statut; Type: TYPE; Schema: iam; Owner: -
--

CREATE TYPE iam.deplacement_statut AS ENUM (
    'creee',
    'en_attente_acceptation',
    'acceptee',
    'en_route',
    'arrive',
    'mission_en_cours',
    'terminee',
    'retour',
    'arrive_siege',
    'cloturee',
    'annule'
);


--
-- Name: facture_statut; Type: TYPE; Schema: iam; Owner: -
--

CREATE TYPE iam.facture_statut AS ENUM (
    'reglee',
    'impayee'
);


--
-- Name: photo_type; Type: TYPE; Schema: iam; Owner: -
--

CREATE TYPE iam.photo_type AS ENUM (
    'depart',
    'arrivee',
    'bon_livraison',
    'retour',
    'autre'
);


--
-- Name: service_request_priority; Type: TYPE; Schema: iam; Owner: -
--

CREATE TYPE iam.service_request_priority AS ENUM (
    'normale',
    'urgente',
    'critique'
);


--
-- Name: service_request_status; Type: TYPE; Schema: iam; Owner: -
--

CREATE TYPE iam.service_request_status AS ENUM (
    'nouvelle',
    'validee_chef',
    'validee_responsable',
    'affectee',
    'en_cours',
    'terminee',
    'annulee',
    'archivee'
);


--
-- Name: service_request_type; Type: TYPE; Schema: iam; Owner: -
--

CREATE TYPE iam.service_request_type AS ENUM (
    'vehicule',
    'deplacement',
    'telephone',
    'fourniture',
    'mobilier',
    'maintenance',
    'informatique',
    'batiment',
    'autre'
);


--
-- Name: system_log_level; Type: TYPE; Schema: iam; Owner: -
--

CREATE TYPE iam.system_log_level AS ENUM (
    'info',
    'warn',
    'error'
);


--
-- Name: user_role; Type: TYPE; Schema: iam; Owner: -
--

CREATE TYPE iam.user_role AS ENUM (
    'SUPER_ADMIN',
    'ADMIN',
    'USER',
    'GESTIONNAIRE',
    'CHAUFFEUR',
    'CHEF_DIVISION'
);


--
-- Name: vehicule_carburant; Type: TYPE; Schema: iam; Owner: -
--

CREATE TYPE iam.vehicule_carburant AS ENUM (
    'essence',
    'diesel',
    'hybride',
    'electrique'
);


--
-- Name: vehicule_statut; Type: TYPE; Schema: iam; Owner: -
--

CREATE TYPE iam.vehicule_statut AS ENUM (
    'disponible',
    'en_mission',
    'maintenance',
    'hors_service'
);


--
-- Name: user_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.user_role AS ENUM (
    'admin',
    'editor',
    'viewer'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: activity_logs; Type: TABLE; Schema: iam; Owner: -
--

CREATE TABLE iam.activity_logs (
    id integer NOT NULL,
    user_id integer NOT NULL,
    username text NOT NULL,
    user_role text NOT NULL,
    action text NOT NULL,
    category text NOT NULL,
    description text NOT NULL,
    target_id text,
    target_name text,
    metadata jsonb,
    ip_address text,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: activity_logs_id_seq; Type: SEQUENCE; Schema: iam; Owner: -
--

CREATE SEQUENCE iam.activity_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activity_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: iam; Owner: -
--

ALTER SEQUENCE iam.activity_logs_id_seq OWNED BY iam.activity_logs.id;


--
-- Name: audit_logs; Type: TABLE; Schema: iam; Owner: -
--

CREATE TABLE iam.audit_logs (
    id integer NOT NULL,
    user_id integer,
    username text,
    role text,
    action text NOT NULL,
    entity text NOT NULL,
    entity_id text,
    method text NOT NULL,
    path text NOT NULL,
    status_code integer NOT NULL,
    details jsonb,
    ip_address text,
    user_agent text,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: iam; Owner: -
--

CREATE SEQUENCE iam.audit_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: iam; Owner: -
--

ALTER SEQUENCE iam.audit_logs_id_seq OWNED BY iam.audit_logs.id;


--
-- Name: calendar_events; Type: TABLE; Schema: iam; Owner: -
--

CREATE TABLE iam.calendar_events (
    id integer NOT NULL,
    title text NOT NULL,
    type iam.calendar_event_type DEFAULT 'autre'::iam.calendar_event_type NOT NULL,
    date text NOT NULL,
    description text,
    created_by text,
    deleted_at timestamp without time zone,
    deleted_by text,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: calendar_events_id_seq; Type: SEQUENCE; Schema: iam; Owner: -
--

CREATE SEQUENCE iam.calendar_events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: calendar_events_id_seq; Type: SEQUENCE OWNED BY; Schema: iam; Owner: -
--

ALTER SEQUENCE iam.calendar_events_id_seq OWNED BY iam.calendar_events.id;


--
-- Name: chauffeur_events; Type: TABLE; Schema: iam; Owner: -
--

CREATE TABLE iam.chauffeur_events (
    id integer NOT NULL,
    chauffeur_id integer NOT NULL,
    statut iam.chauffeur_statut NOT NULL,
    commentaire text,
    action_par text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: chauffeur_events_id_seq; Type: SEQUENCE; Schema: iam; Owner: -
--

CREATE SEQUENCE iam.chauffeur_events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chauffeur_events_id_seq; Type: SEQUENCE OWNED BY; Schema: iam; Owner: -
--

ALTER SEQUENCE iam.chauffeur_events_id_seq OWNED BY iam.chauffeur_events.id;


--
-- Name: chauffeurs; Type: TABLE; Schema: iam; Owner: -
--

CREATE TABLE iam.chauffeurs (
    id integer NOT NULL,
    nom text NOT NULL,
    telephone text,
    permis text,
    statut iam.chauffeur_statut DEFAULT 'disponible'::iam.chauffeur_statut NOT NULL,
    notes text,
    deleted_at timestamp without time zone,
    deleted_by text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    cin text,
    matricule text,
    user_id integer
);


--
-- Name: chauffeurs_id_seq; Type: SEQUENCE; Schema: iam; Owner: -
--

CREATE SEQUENCE iam.chauffeurs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chauffeurs_id_seq; Type: SEQUENCE OWNED BY; Schema: iam; Owner: -
--

ALTER SEQUENCE iam.chauffeurs_id_seq OWNED BY iam.chauffeurs.id;


--
-- Name: connection_logs; Type: TABLE; Schema: iam; Owner: -
--

CREATE TABLE iam.connection_logs (
    id integer NOT NULL,
    user_id integer,
    username text NOT NULL,
    success boolean NOT NULL,
    reason text,
    ip_address text,
    user_agent text,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: connection_logs_id_seq; Type: SEQUENCE; Schema: iam; Owner: -
--

CREATE SEQUENCE iam.connection_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: connection_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: iam; Owner: -
--

ALTER SEQUENCE iam.connection_logs_id_seq OWNED BY iam.connection_logs.id;


--
-- Name: correction_rules; Type: TABLE; Schema: iam; Owner: -
--

CREATE TABLE iam.correction_rules (
    id integer NOT NULL,
    source_sheet_name text NOT NULL,
    target_sheet_name text NOT NULL,
    created_by text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    deleted_by text
);


--
-- Name: correction_rules_id_seq; Type: SEQUENCE; Schema: iam; Owner: -
--

CREATE SEQUENCE iam.correction_rules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: correction_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: iam; Owner: -
--

ALTER SEQUENCE iam.correction_rules_id_seq OWNED BY iam.correction_rules.id;


--
-- Name: custom_fields; Type: TABLE; Schema: iam; Owner: -
--

CREATE TABLE iam.custom_fields (
    id integer NOT NULL,
    label text NOT NULL,
    use_as_match_key boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    deleted_by text
);


--
-- Name: custom_fields_id_seq; Type: SEQUENCE; Schema: iam; Owner: -
--

CREATE SEQUENCE iam.custom_fields_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: custom_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: iam; Owner: -
--

ALTER SEQUENCE iam.custom_fields_id_seq OWNED BY iam.custom_fields.id;


--
-- Name: dashboard_snapshot; Type: TABLE; Schema: iam; Owner: -
--

CREATE TABLE iam.dashboard_snapshot (
    id integer DEFAULT 1 NOT NULL,
    total_factures integer DEFAULT 0 NOT NULL,
    factures_reglees integer DEFAULT 0 NOT NULL,
    factures_impayees integer DEFAULT 0 NOT NULL,
    montant_impaye double precision DEFAULT 0 NOT NULL,
    lignes_fixes integer DEFAULT 0 NOT NULL,
    updated_by text,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: deplacement_events; Type: TABLE; Schema: iam; Owner: -
--

CREATE TABLE iam.deplacement_events (
    id integer NOT NULL,
    deplacement_id integer NOT NULL,
    statut text NOT NULL,
    commentaire text,
    latitude text,
    longitude text,
    vitesse integer,
    action_par text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: deplacement_events_id_seq; Type: SEQUENCE; Schema: iam; Owner: -
--

CREATE SEQUENCE iam.deplacement_events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: deplacement_events_id_seq; Type: SEQUENCE OWNED BY; Schema: iam; Owner: -
--

ALTER SEQUENCE iam.deplacement_events_id_seq OWNED BY iam.deplacement_events.id;


--
-- Name: deplacement_gps_points; Type: TABLE; Schema: iam; Owner: -
--

CREATE TABLE iam.deplacement_gps_points (
    id integer NOT NULL,
    deplacement_id integer NOT NULL,
    latitude real NOT NULL,
    longitude real NOT NULL,
    vitesse real,
    "precision" real,
    cap integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: deplacement_gps_points_id_seq; Type: SEQUENCE; Schema: iam; Owner: -
--

CREATE SEQUENCE iam.deplacement_gps_points_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: deplacement_gps_points_id_seq; Type: SEQUENCE OWNED BY; Schema: iam; Owner: -
--

ALTER SEQUENCE iam.deplacement_gps_points_id_seq OWNED BY iam.deplacement_gps_points.id;


--
-- Name: deplacement_passagers; Type: TABLE; Schema: iam; Owner: -
--

CREATE TABLE iam.deplacement_passagers (
    id integer NOT NULL,
    deplacement_id integer NOT NULL,
    nom text NOT NULL,
    service text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    service_id integer
);


--
-- Name: deplacement_passagers_id_seq; Type: SEQUENCE; Schema: iam; Owner: -
--

CREATE SEQUENCE iam.deplacement_passagers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: deplacement_passagers_id_seq; Type: SEQUENCE OWNED BY; Schema: iam; Owner: -
--

ALTER SEQUENCE iam.deplacement_passagers_id_seq OWNED BY iam.deplacement_passagers.id;


--
-- Name: deplacement_photos; Type: TABLE; Schema: iam; Owner: -
--

CREATE TABLE iam.deplacement_photos (
    id integer NOT NULL,
    deplacement_id integer NOT NULL,
    type iam.photo_type DEFAULT 'autre'::iam.photo_type NOT NULL,
    filename text NOT NULL,
    original_name text,
    mime_type text,
    size_bytes integer,
    uploaded_by text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: deplacement_photos_id_seq; Type: SEQUENCE; Schema: iam; Owner: -
--

CREATE SEQUENCE iam.deplacement_photos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: deplacement_photos_id_seq; Type: SEQUENCE OWNED BY; Schema: iam; Owner: -
--

ALTER SEQUENCE iam.deplacement_photos_id_seq OWNED BY iam.deplacement_photos.id;


--
-- Name: deplacements; Type: TABLE; Schema: iam; Owner: -
--

CREATE TABLE iam.deplacements (
    id integer NOT NULL,
    numero text NOT NULL,
    vehicule_id integer,
    chauffeur_id integer,
    demande_id integer,
    service_demandeur_id integer NOT NULL,
    objet text NOT NULL,
    destination text,
    date_depart text NOT NULL,
    date_retour_prevue text,
    date_retour_effective text,
    kilometrage_depart integer,
    kilometrage_retour integer,
    rapport_mission text,
    created_by text NOT NULL,
    deleted_at timestamp without time zone,
    deleted_by text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    depart_reel_at timestamp without time zone,
    arrivee_at timestamp without time zone,
    depart_retour_at timestamp without time zone,
    retour_reel_at timestamp without time zone,
    depart_lat double precision,
    depart_lng double precision,
    arrivee_lat double precision,
    arrivee_lng double precision,
    depart_retour_lat double precision,
    depart_retour_lng double precision,
    retour_lat double precision,
    retour_lng double precision,
    heure_depart text,
    observations text,
    statut iam.deplacement_statut DEFAULT 'creee'::iam.deplacement_statut CONSTRAINT deplacements_statut_new_not_null NOT NULL,
    heure_depart_prevue text,
    heure_depart_reelle timestamp without time zone,
    heure_arrivee_reelle timestamp without time zone,
    heure_retour_reelle timestamp without time zone,
    heure_cloture timestamp without time zone,
    date_depart_reelle text,
    date_arrivee_reelle text,
    date_retour_reelle text,
    date_cloture timestamp without time zone,
    accepted_at timestamp without time zone,
    accepted_by text,
    signature_chauffeur text,
    signature_responsable text,
    duree_mission integer,
    distance_km integer,
    consommation_carburant real,
    observations_chauffeur text,
    notes_cloture text,
    itineraire jsonb
);


--
-- Name: deplacements_id_seq; Type: SEQUENCE; Schema: iam; Owner: -
--

CREATE SEQUENCE iam.deplacements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: deplacements_id_seq; Type: SEQUENCE OWNED BY; Schema: iam; Owner: -
--

ALTER SEQUENCE iam.deplacements_id_seq OWNED BY iam.deplacements.id;


--
-- Name: email_logs; Type: TABLE; Schema: iam; Owner: -
--

CREATE TABLE iam.email_logs (
    id integer NOT NULL,
    to_address text NOT NULL,
    subject text NOT NULL,
    kind text DEFAULT 'autre'::text NOT NULL,
    related_id text,
    success boolean NOT NULL,
    error text,
    sent_by text,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: email_logs_id_seq; Type: SEQUENCE; Schema: iam; Owner: -
--

CREATE SEQUENCE iam.email_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: email_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: iam; Owner: -
--

ALTER SEQUENCE iam.email_logs_id_seq OWNED BY iam.email_logs.id;


--
-- Name: factures; Type: TABLE; Schema: iam; Owner: -
--

CREATE TABLE iam.factures (
    id integer NOT NULL,
    custcode text NOT NULL,
    nd text,
    nom text,
    ref_facture text NOT NULL,
    montant double precision DEFAULT 0 NOT NULL,
    mois text,
    echeance text,
    produit text,
    statut iam.facture_statut DEFAULT 'impayee'::iam.facture_statut NOT NULL,
    source_sheet text,
    coordination_regionale text,
    delegation text,
    domiciliation text,
    deleted_at timestamp without time zone,
    deleted_by text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: factures_id_seq; Type: SEQUENCE; Schema: iam; Owner: -
--

CREATE SEQUENCE iam.factures_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: factures_id_seq; Type: SEQUENCE OWNED BY; Schema: iam; Owner: -
--

ALTER SEQUENCE iam.factures_id_seq OWNED BY iam.factures.id;


--
-- Name: journal_entries; Type: TABLE; Schema: iam; Owner: -
--

CREATE TABLE iam.journal_entries (
    id integer NOT NULL,
    direction text,
    service text NOT NULL,
    journal_1 text,
    journal_2 text,
    journal_3 text,
    deleted_at timestamp without time zone,
    deleted_by text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: journal_entries_id_seq; Type: SEQUENCE; Schema: iam; Owner: -
--

CREATE SEQUENCE iam.journal_entries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: journal_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: iam; Owner: -
--

ALTER SEQUENCE iam.journal_entries_id_seq OWNED BY iam.journal_entries.id;


--
-- Name: lignes; Type: TABLE; Schema: iam; Owner: -
--

CREATE TABLE iam.lignes (
    id integer NOT NULL,
    categorie text NOT NULL,
    type_forfait text,
    type_mobile text,
    icc text,
    imei text,
    affecte text,
    personne text,
    qualite text,
    date text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    civilite text,
    deleted_at timestamp without time zone,
    deleted_by text,
    pin text,
    puk text,
    service_id integer,
    consommation_mensuelle_dh integer,
    CONSTRAINT lignes_civilite_check CHECK ((civilite = ANY (ARRAY['Mme'::text, 'Mlle'::text, 'M.'::text])))
);


--
-- Name: lignes_fixes; Type: TABLE; Schema: iam; Owner: -
--

CREATE TABLE iam.lignes_fixes (
    id integer NOT NULL,
    nd text NOT NULL,
    custcode text,
    coordination_regionale text,
    delegation text,
    domiciliation text,
    personne text,
    qualite text,
    date text,
    deleted_at timestamp without time zone,
    deleted_by text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    service_id integer,
    consommation_mensuelle_dh integer
);


--
-- Name: lignes_fixes_id_seq; Type: SEQUENCE; Schema: iam; Owner: -
--

CREATE SEQUENCE iam.lignes_fixes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lignes_fixes_id_seq; Type: SEQUENCE OWNED BY; Schema: iam; Owner: -
--

ALTER SEQUENCE iam.lignes_fixes_id_seq OWNED BY iam.lignes_fixes.id;


--
-- Name: lignes_id_seq; Type: SEQUENCE; Schema: iam; Owner: -
--

CREATE SEQUENCE iam.lignes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lignes_id_seq; Type: SEQUENCE OWNED BY; Schema: iam; Owner: -
--

ALTER SEQUENCE iam.lignes_id_seq OWNED BY iam.lignes.id;


--
-- Name: notification_reads; Type: TABLE; Schema: iam; Owner: -
--

CREATE TABLE iam.notification_reads (
    user_id integer NOT NULL,
    last_seen_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: org_nodes; Type: TABLE; Schema: iam; Owner: -
--

CREATE TABLE iam.org_nodes (
    id integer NOT NULL,
    type text NOT NULL,
    name text NOT NULL,
    short_name text,
    parent_id integer,
    sort_order integer DEFAULT 0 NOT NULL,
    chef_nom text,
    telephone text,
    notes text,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: org_nodes_id_seq; Type: SEQUENCE; Schema: iam; Owner: -
--

CREATE SEQUENCE iam.org_nodes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: org_nodes_id_seq; Type: SEQUENCE OWNED BY; Schema: iam; Owner: -
--

ALTER SEQUENCE iam.org_nodes_id_seq OWNED BY iam.org_nodes.id;


--
-- Name: service_request_events; Type: TABLE; Schema: iam; Owner: -
--

CREATE TABLE iam.service_request_events (
    id integer NOT NULL,
    request_id integer NOT NULL,
    statut iam.service_request_status NOT NULL,
    commentaire text,
    action_par text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: service_request_events_id_seq; Type: SEQUENCE; Schema: iam; Owner: -
--

CREATE SEQUENCE iam.service_request_events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: service_request_events_id_seq; Type: SEQUENCE OWNED BY; Schema: iam; Owner: -
--

ALTER SEQUENCE iam.service_request_events_id_seq OWNED BY iam.service_request_events.id;


--
-- Name: service_requests; Type: TABLE; Schema: iam; Owner: -
--

CREATE TABLE iam.service_requests (
    id integer NOT NULL,
    numero text NOT NULL,
    service_demandeur_id integer NOT NULL,
    demandeur_nom text NOT NULL,
    demandeur_telephone text,
    type iam.service_request_type DEFAULT 'autre'::iam.service_request_type NOT NULL,
    objet text NOT NULL,
    description text,
    priorite iam.service_request_priority DEFAULT 'normale'::iam.service_request_priority NOT NULL,
    statut iam.service_request_status DEFAULT 'nouvelle'::iam.service_request_status NOT NULL,
    agent_affecte_id integer,
    date_souhaitee text,
    created_by text NOT NULL,
    deleted_at timestamp without time zone,
    deleted_by text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: service_requests_id_seq; Type: SEQUENCE; Schema: iam; Owner: -
--

CREATE SEQUENCE iam.service_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: service_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: iam; Owner: -
--

ALTER SEQUENCE iam.service_requests_id_seq OWNED BY iam.service_requests.id;


--
-- Name: sessions; Type: TABLE; Schema: iam; Owner: -
--

CREATE TABLE iam.sessions (
    id integer NOT NULL,
    jti text NOT NULL,
    user_id integer NOT NULL,
    ip_address text,
    user_agent text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    last_seen_at timestamp without time zone DEFAULT now() NOT NULL,
    revoked_at timestamp without time zone
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: iam; Owner: -
--

CREATE SEQUENCE iam.sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: iam; Owner: -
--

ALTER SEQUENCE iam.sessions_id_seq OWNED BY iam.sessions.id;


--
-- Name: sheet_rules; Type: TABLE; Schema: iam; Owner: -
--

CREATE TABLE iam.sheet_rules (
    id integer NOT NULL,
    role text NOT NULL,
    sheet_name text NOT NULL,
    mapping jsonb NOT NULL,
    updated_by text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: sheet_rules_id_seq; Type: SEQUENCE; Schema: iam; Owner: -
--

CREATE SEQUENCE iam.sheet_rules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sheet_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: iam; Owner: -
--

ALTER SEQUENCE iam.sheet_rules_id_seq OWNED BY iam.sheet_rules.id;


--
-- Name: system_logs; Type: TABLE; Schema: iam; Owner: -
--

CREATE TABLE iam.system_logs (
    id integer NOT NULL,
    level iam.system_log_level DEFAULT 'info'::iam.system_log_level NOT NULL,
    message text NOT NULL,
    meta jsonb,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: system_logs_id_seq; Type: SEQUENCE; Schema: iam; Owner: -
--

CREATE SEQUENCE iam.system_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: iam; Owner: -
--

ALTER SEQUENCE iam.system_logs_id_seq OWNED BY iam.system_logs.id;


--
-- Name: system_settings; Type: TABLE; Schema: iam; Owner: -
--

CREATE TABLE iam.system_settings (
    id integer DEFAULT 1 NOT NULL,
    organization_name text DEFAULT 'Entraide Nationale'::text NOT NULL,
    support_email text,
    session_duration_days integer DEFAULT 30 NOT NULL,
    maintenance_mode boolean DEFAULT false NOT NULL,
    maintenance_message text,
    updated_by text,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    backup_schedule_enabled boolean DEFAULT false NOT NULL,
    backup_schedule_frequency text DEFAULT 'daily'::text NOT NULL,
    backup_schedule_hour integer DEFAULT 2 NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: iam; Owner: -
--

CREATE TABLE iam.users (
    id integer NOT NULL,
    username text NOT NULL,
    password_hash text NOT NULL,
    display_name text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    role iam.user_role DEFAULT 'USER'::iam.user_role CONSTRAINT users_role_new_not_null NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    last_login_at timestamp without time zone,
    deleted_at timestamp without time zone,
    deleted_by text,
    last_seen_at timestamp without time zone,
    two_factor_enabled boolean DEFAULT false NOT NULL,
    two_factor_secret text,
    chauffeur_id integer
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: iam; Owner: -
--

CREATE SEQUENCE iam.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: iam; Owner: -
--

ALTER SEQUENCE iam.users_id_seq OWNED BY iam.users.id;


--
-- Name: vehicule_events; Type: TABLE; Schema: iam; Owner: -
--

CREATE TABLE iam.vehicule_events (
    id integer NOT NULL,
    vehicule_id integer NOT NULL,
    statut iam.vehicule_statut NOT NULL,
    commentaire text,
    action_par text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: vehicule_events_id_seq; Type: SEQUENCE; Schema: iam; Owner: -
--

CREATE SEQUENCE iam.vehicule_events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vehicule_events_id_seq; Type: SEQUENCE OWNED BY; Schema: iam; Owner: -
--

ALTER SEQUENCE iam.vehicule_events_id_seq OWNED BY iam.vehicule_events.id;


--
-- Name: vehicules; Type: TABLE; Schema: iam; Owner: -
--

CREATE TABLE iam.vehicules (
    id integer NOT NULL,
    immatriculation text NOT NULL,
    marque text NOT NULL,
    modele text NOT NULL,
    annee integer,
    carburant iam.vehicule_carburant DEFAULT 'diesel'::iam.vehicule_carburant NOT NULL,
    kilometrage integer DEFAULT 0 NOT NULL,
    statut iam.vehicule_statut DEFAULT 'disponible'::iam.vehicule_statut NOT NULL,
    assurance_expiration text,
    visite_technique_expiration text,
    chauffeur_attitre_id integer,
    notes text,
    deleted_at timestamp without time zone,
    deleted_by text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: vehicules_id_seq; Type: SEQUENCE; Schema: iam; Owner: -
--

CREATE SEQUENCE iam.vehicules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vehicules_id_seq; Type: SEQUENCE OWNED BY; Schema: iam; Owner: -
--

ALTER SEQUENCE iam.vehicules_id_seq OWNED BY iam.vehicules.id;


--
-- Name: whatsapp_messages; Type: TABLE; Schema: iam; Owner: -
--

CREATE TABLE iam.whatsapp_messages (
    id integer NOT NULL,
    to_phone text NOT NULL,
    message text NOT NULL,
    kind text DEFAULT 'autre'::text NOT NULL,
    related_id text,
    status text DEFAULT 'queued'::text NOT NULL,
    wa_message_id text,
    error text,
    sent_by text,
    sent_at timestamp without time zone DEFAULT now() NOT NULL,
    read_at timestamp without time zone
);


--
-- Name: whatsapp_messages_id_seq; Type: SEQUENCE; Schema: iam; Owner: -
--

CREATE SEQUENCE iam.whatsapp_messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: whatsapp_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: iam; Owner: -
--

ALTER SEQUENCE iam.whatsapp_messages_id_seq OWNED BY iam.whatsapp_messages.id;


--
-- Name: correction_rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.correction_rules (
    id integer NOT NULL,
    source_sheet_name text NOT NULL,
    target_sheet_name text NOT NULL,
    created_by text,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: correction_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.correction_rules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: correction_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.correction_rules_id_seq OWNED BY public.correction_rules.id;


--
-- Name: custom_fields; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.custom_fields (
    id integer NOT NULL,
    label text NOT NULL,
    use_as_match_key boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: custom_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.custom_fields_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: custom_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.custom_fields_id_seq OWNED BY public.custom_fields.id;


--
-- Name: lignes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lignes (
    id integer NOT NULL,
    categorie text NOT NULL,
    type_forfait text,
    type_mobile text,
    icc text,
    imei text,
    affecte text,
    personne text,
    qualite text,
    date text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: lignes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.lignes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lignes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.lignes_id_seq OWNED BY public.lignes.id;


--
-- Name: sheet_rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sheet_rules (
    id integer NOT NULL,
    role text NOT NULL,
    sheet_name text NOT NULL,
    mapping jsonb NOT NULL,
    updated_by text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: sheet_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sheet_rules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sheet_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sheet_rules_id_seq OWNED BY public.sheet_rules.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username text NOT NULL,
    password_hash text NOT NULL,
    display_name text,
    role public.user_role DEFAULT 'viewer'::public.user_role NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: activity_logs id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.activity_logs ALTER COLUMN id SET DEFAULT nextval('iam.activity_logs_id_seq'::regclass);


--
-- Name: audit_logs id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.audit_logs ALTER COLUMN id SET DEFAULT nextval('iam.audit_logs_id_seq'::regclass);


--
-- Name: calendar_events id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.calendar_events ALTER COLUMN id SET DEFAULT nextval('iam.calendar_events_id_seq'::regclass);


--
-- Name: chauffeur_events id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.chauffeur_events ALTER COLUMN id SET DEFAULT nextval('iam.chauffeur_events_id_seq'::regclass);


--
-- Name: chauffeurs id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.chauffeurs ALTER COLUMN id SET DEFAULT nextval('iam.chauffeurs_id_seq'::regclass);


--
-- Name: connection_logs id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.connection_logs ALTER COLUMN id SET DEFAULT nextval('iam.connection_logs_id_seq'::regclass);


--
-- Name: correction_rules id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.correction_rules ALTER COLUMN id SET DEFAULT nextval('iam.correction_rules_id_seq'::regclass);


--
-- Name: custom_fields id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.custom_fields ALTER COLUMN id SET DEFAULT nextval('iam.custom_fields_id_seq'::regclass);


--
-- Name: deplacement_events id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.deplacement_events ALTER COLUMN id SET DEFAULT nextval('iam.deplacement_events_id_seq'::regclass);


--
-- Name: deplacement_gps_points id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.deplacement_gps_points ALTER COLUMN id SET DEFAULT nextval('iam.deplacement_gps_points_id_seq'::regclass);


--
-- Name: deplacement_passagers id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.deplacement_passagers ALTER COLUMN id SET DEFAULT nextval('iam.deplacement_passagers_id_seq'::regclass);


--
-- Name: deplacement_photos id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.deplacement_photos ALTER COLUMN id SET DEFAULT nextval('iam.deplacement_photos_id_seq'::regclass);


--
-- Name: deplacements id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.deplacements ALTER COLUMN id SET DEFAULT nextval('iam.deplacements_id_seq'::regclass);


--
-- Name: email_logs id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.email_logs ALTER COLUMN id SET DEFAULT nextval('iam.email_logs_id_seq'::regclass);


--
-- Name: factures id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.factures ALTER COLUMN id SET DEFAULT nextval('iam.factures_id_seq'::regclass);


--
-- Name: journal_entries id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.journal_entries ALTER COLUMN id SET DEFAULT nextval('iam.journal_entries_id_seq'::regclass);


--
-- Name: lignes id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.lignes ALTER COLUMN id SET DEFAULT nextval('iam.lignes_id_seq'::regclass);


--
-- Name: lignes_fixes id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.lignes_fixes ALTER COLUMN id SET DEFAULT nextval('iam.lignes_fixes_id_seq'::regclass);


--
-- Name: org_nodes id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.org_nodes ALTER COLUMN id SET DEFAULT nextval('iam.org_nodes_id_seq'::regclass);


--
-- Name: service_request_events id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.service_request_events ALTER COLUMN id SET DEFAULT nextval('iam.service_request_events_id_seq'::regclass);


--
-- Name: service_requests id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.service_requests ALTER COLUMN id SET DEFAULT nextval('iam.service_requests_id_seq'::regclass);


--
-- Name: sessions id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.sessions ALTER COLUMN id SET DEFAULT nextval('iam.sessions_id_seq'::regclass);


--
-- Name: sheet_rules id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.sheet_rules ALTER COLUMN id SET DEFAULT nextval('iam.sheet_rules_id_seq'::regclass);


--
-- Name: system_logs id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.system_logs ALTER COLUMN id SET DEFAULT nextval('iam.system_logs_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.users ALTER COLUMN id SET DEFAULT nextval('iam.users_id_seq'::regclass);


--
-- Name: vehicule_events id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.vehicule_events ALTER COLUMN id SET DEFAULT nextval('iam.vehicule_events_id_seq'::regclass);


--
-- Name: vehicules id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.vehicules ALTER COLUMN id SET DEFAULT nextval('iam.vehicules_id_seq'::regclass);


--
-- Name: whatsapp_messages id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.whatsapp_messages ALTER COLUMN id SET DEFAULT nextval('iam.whatsapp_messages_id_seq'::regclass);


--
-- Name: correction_rules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.correction_rules ALTER COLUMN id SET DEFAULT nextval('public.correction_rules_id_seq'::regclass);


--
-- Name: custom_fields id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_fields ALTER COLUMN id SET DEFAULT nextval('public.custom_fields_id_seq'::regclass);


--
-- Name: lignes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lignes ALTER COLUMN id SET DEFAULT nextval('public.lignes_id_seq'::regclass);


--
-- Name: sheet_rules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sheet_rules ALTER COLUMN id SET DEFAULT nextval('public.sheet_rules_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: activity_logs; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.activity_logs (id, user_id, username, user_role, action, category, description, target_id, target_name, metadata, ip_address, created_at) FROM stdin;
1	7	superadmin	super_admin	auth.login	auth	Connexion réussie	\N	\N	\N	192.168.77.24	2026-07-14 14:49:41.617549
2	3	ELHAIMER AMINE	admin	auth.login	auth	Connexion réussie	\N	\N	\N	192.168.77.156	2026-07-14 15:02:03.816532
3	3	ELHAIMER AMINE	admin	lignes.create	lignes	Ajout ligne "CAT 1" — S	7	\N	\N	192.168.77.156	2026-07-14 15:02:30.872996
4	3	ELHAIMER AMINE	admin	lignes.delete	lignes	Suppression ligne #7	7	\N	\N	192.168.77.156	2026-07-14 15:04:13.562107
5	7	superadmin	super_admin	lignes.create	lignes	Ajout ligne "CAT 1" — t	8	t	\N	192.168.77.24	2026-07-14 15:17:20.2925
6	7	superadmin	super_admin	auth.logout	auth	Déconnexion	\N	\N	\N	192.168.77.24	2026-07-14 15:26:57.849939
7	3	ELHAIMER AMINE	admin	auth.login	auth	Connexion réussie	\N	\N	\N	192.168.77.24	2026-07-14 15:27:02.000879
8	3	ELHAIMER AMINE	admin	lignes.delete	lignes	Suppression ligne #8 — t (CAT 1)	8	t	\N	192.168.77.24	2026-07-14 15:27:15.791854
9	3	ELHAIMER AMINE	admin	lignes.delete	lignes	Suppression ligne #6 — T (CAT 1)	6	T	\N	192.168.77.24	2026-07-14 15:27:17.896753
10	3	ELHAIMER AMINE	admin	lignes.delete	lignes	Suppression ligne #5 —  (CAT 1)	5		\N	192.168.77.24	2026-07-14 15:27:20.191427
11	3	ELHAIMER AMINE	admin	auth.logout	auth	Déconnexion	\N	\N	\N	192.168.77.24	2026-07-14 15:27:22.126558
12	7	superadmin	super_admin	auth.login	auth	Connexion réussie	\N	\N	\N	192.168.77.24	2026-07-14 15:27:25.436692
13	7	superadmin	super_admin	auth.logout	auth	Déconnexion	\N	\N	\N	192.168.77.24	2026-07-15 08:48:28.263325
14	7	superadmin	super_admin	auth.login	auth	Connexion réussie	\N	\N	\N	192.168.77.24	2026-07-15 08:48:31.708403
15	7	superadmin	super_admin	auth.logout	auth	Déconnexion	\N	\N	\N	192.168.77.24	2026-07-15 08:51:29.337385
16	7	superadmin	super_admin	auth.login	auth	Connexion réussie	\N	\N	\N	192.168.77.24	2026-07-15 08:51:53.293404
\.


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.audit_logs (id, user_id, username, role, action, entity, entity_id, method, path, status_code, details, ip_address, user_agent, created_at) FROM stdin;
1	3	ELHAIMER AMINE	SUPER_ADMIN	update	users	7	PATCH	/users/7	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-15 23:59:43.557517
2	3	ELHAIMER AMINE	SUPER_ADMIN	update	users	2	PATCH	/users/2	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 00:04:59.125665
3	3	ELHAIMER AMINE	SUPER_ADMIN	update	users	2	PATCH	/users/2	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 00:05:13.342978
4	3	ELHAIMER AMINE	SUPER_ADMIN	update	users	2	PATCH	/users/2	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 00:05:16.152025
5	3	ELHAIMER AMINE	SUPER_ADMIN	update	users	2	PATCH	/users/2	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 00:05:27.989158
6	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 00:41:45.653358
7	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 00:41:45.756649
8	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 00:41:45.769715
9	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 00:41:45.783046
10	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 00:41:45.797464
11	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 00:41:45.806973
12	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 00:41:45.818039
13	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 00:41:45.830628
14	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 00:41:45.840891
15	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 00:41:45.852284
16	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 00:41:45.865027
17	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 00:41:45.874024
18	6	SARA EL HAMADI	SUPER_ADMIN	update	settings	\N	PATCH	/settings	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 09:23:05.677251
19	6	SARA EL HAMADI	SUPER_ADMIN	create	system	\N	POST	/system/backup	500	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 09:23:23.911097
20	6	SARA EL HAMADI	SUPER_ADMIN	update	settings	\N	PATCH	/settings	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 09:27:22.676909
21	6	SARA EL HAMADI	SUPER_ADMIN	create	system	\N	POST	/system/backup	500	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 09:27:25.768915
22	3	ELHAIMER AMINE	SUPER_ADMIN	update	settings	\N	PATCH	/settings	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 09:33:03.542472
23	3	ELHAIMER AMINE	SUPER_ADMIN	create	system	\N	POST	/system/backup	500	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 09:33:05.876893
24	3	ELHAIMER AMINE	SUPER_ADMIN	create	system	\N	POST	/system/backup	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 09:36:58.523055
25	3	ELHAIMER AMINE	SUPER_ADMIN	update	settings	\N	PATCH	/settings	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 09:39:25.670459
26	3	ELHAIMER AMINE	SUPER_ADMIN	create	lignes-fixes	\N	POST	/lignes-fixes/bulk	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 12:34:16.229486
27	3	ELHAIMER AMINE	SUPER_ADMIN	delete	lignes-fixes	\N	DELETE	/lignes-fixes	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 12:34:24.236444
28	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 12:34:48.833755
29	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 12:34:48.931807
30	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 12:34:48.944256
31	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 12:34:48.95446
32	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 12:34:48.965147
33	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 12:34:48.974543
34	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 12:34:48.989192
36	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 12:34:49.018525
37	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 12:34:49.031259
38	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 12:34:49.040505
35	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 12:34:49.003273
39	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 12:34:49.051177
40	3	ELHAIMER AMINE	SUPER_ADMIN	create	correction-rules	\N	POST	/correction-rules	409	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 12:35:00.394374
41	6	SARA EL HAMADI	SUPER_ADMIN	create	system	\N	POST	/system/backup	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 12:40:46.042016
42	3	ELHAIMER AMINE	SUPER_ADMIN	update	settings	\N	PATCH	/settings	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 12:42:42.890218
43	3	ELHAIMER AMINE	SUPER_ADMIN	create	system	\N	POST	/system/backup	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 12:42:46.750965
44	3	ELHAIMER AMINE	SUPER_ADMIN	create	users	\N	POST	/users	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 13:05:15.298528
45	3	ELHAIMER AMINE	SUPER_ADMIN	update	users	8	PATCH	/users/8	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 13:06:01.848614
46	3	ELHAIMER AMINE	SUPER_ADMIN	update	users	8	PATCH	/users/8	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 13:06:08.883299
47	3	ELHAIMER AMINE	SUPER_ADMIN	delete	users	8	DELETE	/users/8	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 13:06:12.300944
48	2	ANAS JABRAN	SUPER_ADMIN	create	system	\N	POST	/system/backup	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 01:43:22.989708
49	3	ELHAIMER AMINE	SUPER_ADMIN	create	system	\N	POST	/system/backup	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 02:05:05.002096
50	3	ELHAIMER AMINE	SUPER_ADMIN	create	users	\N	POST	/users	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 09:41:49.930581
51	3	ELHAIMER AMINE	SUPER_ADMIN	delete	users	9	DELETE	/users/9	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 09:42:38.110724
52	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 15:23:07.202893
53	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 15:23:07.221123
54	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 15:23:07.237653
55	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 15:23:07.250742
56	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 15:23:07.265736
57	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 15:23:07.281788
58	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 15:23:07.297668
59	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 15:23:07.315488
60	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 15:23:07.32967
61	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 15:23:07.344483
62	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 15:23:07.357516
63	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 15:23:07.372973
64	3	ELHAIMER AMINE	SUPER_ADMIN	create	correction-rules	\N	POST	/correction-rules	409	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 15:23:22.729872
65	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 15:24:58.834895
66	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 15:24:58.860051
67	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 15:24:58.885773
68	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 15:24:58.893138
70	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 15:24:58.958842
69	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 15:24:58.956665
71	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 15:24:58.963731
72	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 15:24:59.00189
73	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 15:24:59.022621
74	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 15:24:59.061702
75	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 15:24:59.066473
76	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 15:24:59.168078
77	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-18 00:36:08.225569
78	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-18 00:37:24.250448
79	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-18 00:38:10.534135
80	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-18 00:38:26.423397
81	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-18 00:39:42.351776
82	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-18 00:39:49.416529
83	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-18 00:40:18.621553
84	2	ANAS JABRAN	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.132	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-18 00:40:38.422522
85	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-18 00:41:17.324357
86	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-18 00:42:31.728007
87	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-18 00:46:36.367712
88	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-18 00:53:49.602249
89	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-18 00:53:54.344721
90	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-18 01:05:10.369563
91	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-18 01:08:28.213763
92	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-18 01:10:07.129923
93	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-18 11:02:13.83049
94	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-19 00:57:28.972753
95	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-19 00:57:59.200915
96	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-19 00:58:16.922857
97	3	ELHAIMER AMINE	SUPER_ADMIN	create	security	\N	POST	/security/2fa/setup	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-19 00:58:41.143172
98	3	ELHAIMER AMINE	SUPER_ADMIN	create	journal-entries	\N	POST	/journal-entries	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-19 01:01:56.393168
99	3	ELHAIMER AMINE	SUPER_ADMIN	delete	journal-entries	1	DELETE	/journal-entries/1	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-19 01:02:09.235733
100	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-19 01:02:26.364512
101	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-19 01:08:06.643596
102	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-19 01:08:46.656477
103	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-19 01:08:56.629091
104	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-19 01:15:52.642934
105	3	ELHAIMER AMINE	SUPER_ADMIN	create	assistant	\N	POST	/assistant/query	500	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-19 01:16:06.684389
106	3	ELHAIMER AMINE	SUPER_ADMIN	create	assistant	\N	POST	/assistant/query	500	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-19 01:16:27.101746
107	3	ELHAIMER AMINE	SUPER_ADMIN	create	assistant	\N	POST	/assistant/query	500	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-19 01:19:59.842807
108	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-19 17:44:10.415656
109	3	ELHAIMER AMINE	SUPER_ADMIN	create	assistant	\N	POST	/assistant/query	503	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-19 17:44:19.187898
110	3	ELHAIMER AMINE	SUPER_ADMIN	create	system	\N	POST	/system/backup	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-19 17:47:40.488745
111	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-19 17:48:35.819492
112	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-19 17:51:59.850454
113	3	ELHAIMER AMINE	SUPER_ADMIN	create	assistant	\N	POST	/assistant/query	503	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-19 17:55:14.648085
114	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-19 17:58:53.023301
115	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-19 17:58:59.626614
116	3	ELHAIMER AMINE	SUPER_ADMIN	create	assistant	\N	POST	/assistant/query	500	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-20 00:56:28.149814
117	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-20 00:58:02.808895
118	3	ELHAIMER AMINE	SUPER_ADMIN	create	assistant	\N	POST	/assistant/query	500	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-20 00:59:54.91194
119	3	ELHAIMER AMINE	SUPER_ADMIN	create	email	\N	POST	/email/test	502	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-20 11:14:01.598902
120	3	ELHAIMER AMINE	SUPER_ADMIN	create	email	\N	POST	/email/test	502	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-20 11:14:23.716937
121	3	ELHAIMER AMINE	SUPER_ADMIN	create	email	\N	POST	/email/test	502	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-21 01:18:08.247152
122	3	ELHAIMER AMINE	SUPER_ADMIN	delete	trash	\N	DELETE	/trash/journal-entries/1	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-21 01:21:03.549775
123	3	ELHAIMER AMINE	SUPER_ADMIN	delete	trash	\N	DELETE	/trash/users/9	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-21 01:21:08.569718
124	3	ELHAIMER AMINE	SUPER_ADMIN	create	security	\N	POST	/security/2fa/setup	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-21 01:30:15.799204
125	3	ELHAIMER AMINE	SUPER_ADMIN	create	email	\N	POST	/email/facture/515	502	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-21 01:44:07.807014
126	3	ELHAIMER AMINE	SUPER_ADMIN	create	security	\N	POST	/security/2fa/setup	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-21 01:44:46.439763
127	3	ELHAIMER AMINE	SUPER_ADMIN	create	security	\N	POST	/security/2fa/enable	400	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-21 01:45:19.133666
128	3	ELHAIMER AMINE	SUPER_ADMIN	create	security	\N	POST	/security/2fa/enable	400	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-21 01:45:21.901815
129	3	ELHAIMER AMINE	SUPER_ADMIN	create	security	\N	POST	/security/2fa/enable	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-21 01:45:41.852318
130	3	ELHAIMER AMINE	SUPER_ADMIN	create	email	\N	POST	/email/test	502	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-21 11:51:21.677409
131	3	ELHAIMER AMINE	SUPER_ADMIN	create	assistant	\N	POST	/assistant/query	500	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-21 11:51:48.3029
163	3	ELHAIMER AMINE	SUPER_ADMIN	create	whatsapp	\N	POST	/whatsapp/test	502	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-22 01:27:50.506794
164	3	ELHAIMER AMINE	SUPER_ADMIN	delete	users	4	DELETE	/users/4	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-22 01:31:06.043093
165	3	ELHAIMER AMINE	SUPER_ADMIN	create	email	\N	POST	/email/test	502	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-22 15:45:53.354141
166	3	ELHAIMER AMINE	SUPER_ADMIN	create	journal-entries	\N	POST	/journal-entries	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-22 15:46:52.889285
167	3	ELHAIMER AMINE	SUPER_ADMIN	create	email	\N	POST	/email/test	502	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 11:12:52.995935
168	3	ELHAIMER AMINE	SUPER_ADMIN	create	email	\N	POST	/email/test	502	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 11:31:41.271317
169	3	ELHAIMER AMINE	SUPER_ADMIN	create	email	\N	POST	/email/test	502	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 11:34:07.451023
170	3	ELHAIMER AMINE	SUPER_ADMIN	create	email	\N	POST	/email/test	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 11:34:56.14572
171	3	ELHAIMER AMINE	SUPER_ADMIN	update	settings	\N	PATCH	/settings	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 11:38:05.110033
172	3	ELHAIMER AMINE	SUPER_ADMIN	create	system	\N	POST	/system/backup	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 11:38:46.671904
173	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 11:39:08.191571
174	3	ELHAIMER AMINE	SUPER_ADMIN	create	email	\N	POST	/email/test	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 11:41:25.099212
175	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 12:24:27.901603
176	3	ELHAIMER AMINE	SUPER_ADMIN	create	email	\N	POST	/email/test	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 12:24:41.983365
177	3	ELHAIMER AMINE	SUPER_ADMIN	create	assistant	\N	POST	/api/assistant/chat	404	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 12:25:00.033739
178	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 12:27:21.196256
179	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 12:27:27.696511
180	3	ELHAIMER AMINE	SUPER_ADMIN	create	email	\N	POST	/email/facture/515	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 12:28:20.758178
181	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 12:29:11.683587
182	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 12:31:14.07262
183	3	ELHAIMER AMINE	SUPER_ADMIN	create	whatsapp	\N	POST	/whatsapp/test	502	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 12:32:47.020777
184	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 13:06:30.093266
185	3	ELHAIMER AMINE	SUPER_ADMIN	create	org	\N	POST	/org/nodes	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 13:52:47.65646
186	3	ELHAIMER AMINE	SUPER_ADMIN	create	org	\N	POST	/org/nodes	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 13:53:57.05295
187	3	ELHAIMER AMINE	SUPER_ADMIN	delete	org	\N	DELETE	/org/nodes/4	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 13:55:04.684583
188	3	ELHAIMER AMINE	SUPER_ADMIN	delete	org	\N	DELETE	/org/nodes/7	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 13:55:09.901962
189	3	ELHAIMER AMINE	SUPER_ADMIN	create	org	\N	POST	/org/nodes	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 13:55:41.329589
190	3	ELHAIMER AMINE	SUPER_ADMIN	create	org	\N	POST	/org/nodes	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 13:55:49.46774
191	3	ELHAIMER AMINE	SUPER_ADMIN	create	org	\N	POST	/org/nodes	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 13:55:54.965318
192	3	ELHAIMER AMINE	SUPER_ADMIN	create	org	\N	POST	/org/nodes	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 13:56:24.488675
193	3	ELHAIMER AMINE	SUPER_ADMIN	create	org	\N	POST	/org/nodes	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 13:56:29.596996
194	3	ELHAIMER AMINE	SUPER_ADMIN	delete	org	\N	DELETE	/org/nodes/62	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 13:56:40.451383
195	3	ELHAIMER AMINE	SUPER_ADMIN	delete	org	\N	DELETE	/org/nodes/61	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 13:56:44.932832
196	3	ELHAIMER AMINE	SUPER_ADMIN	create	org	\N	POST	/org/nodes	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 13:56:54.455015
197	3	ELHAIMER AMINE	SUPER_ADMIN	create	org	\N	POST	/org/nodes	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 13:57:01.69084
198	3	ELHAIMER AMINE	SUPER_ADMIN	create	org	\N	POST	/org/nodes	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 13:57:10.006153
199	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/nodes/11	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 13:58:58.244218
200	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/nodes/14	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 14:05:36.679958
201	3	ELHAIMER AMINE	SUPER_ADMIN	delete	org	\N	DELETE	/org/nodes/50	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 14:06:00.012917
202	3	ELHAIMER AMINE	SUPER_ADMIN	create	org	\N	POST	/org/nodes	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 14:06:54.239264
203	3	ELHAIMER AMINE	SUPER_ADMIN	create	org	\N	POST	/org/nodes	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 14:07:47.509602
204	3	ELHAIMER AMINE	SUPER_ADMIN	delete	org	\N	DELETE	/org/nodes/15	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 14:09:39.72929
205	3	ELHAIMER AMINE	SUPER_ADMIN	delete	org	\N	DELETE	/org/nodes/16	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 14:10:23.721431
206	3	ELHAIMER AMINE	SUPER_ADMIN	create	org	\N	POST	/org/nodes	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 14:10:55.741884
207	3	ELHAIMER AMINE	SUPER_ADMIN	create	org	\N	POST	/org/nodes	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 14:11:40.491904
208	3	ELHAIMER AMINE	SUPER_ADMIN	create	org	\N	POST	/org/nodes	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 14:11:56.470892
209	3	ELHAIMER AMINE	SUPER_ADMIN	create	org	\N	POST	/org/nodes	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 14:12:13.916972
210	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/nodes/35	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 14:14:58.245042
211	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/nodes/36	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 14:15:39.796926
212	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/nodes/35	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 14:16:05.289154
213	3	ELHAIMER AMINE	SUPER_ADMIN	create	assistant	\N	POST	/api/assistant/chat	404	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 14:16:14.460336
214	3	ELHAIMER AMINE	SUPER_ADMIN	create	assistant	\N	POST	/api/assistant/chat	404	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 14:16:33.35873
215	3	ELHAIMER AMINE	SUPER_ADMIN	create	email	\N	POST	/email/facture/524	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-23 15:02:19.141298
216	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:47:17.757471
217	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:47:38.682655
218	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:47:45.050492
219	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:47:49.244343
220	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:47:51.011336
221	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:47:52.96245
222	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:48:12.260132
223	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:48:37.044547
224	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:48:48.000044
225	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:48:51.542204
226	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:48:56.498321
227	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:51:10.665764
228	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:51:24.992434
229	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:51:56.439738
230	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:56:21.430069
231	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:56:26.074945
232	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:56:28.386188
233	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:56:31.268183
234	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:56:32.441694
235	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:56:33.040174
236	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:56:33.205331
237	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:56:34.178339
238	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:56:34.229801
239	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:56:36.639718
240	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:56:41.578697
241	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:56:48.315281
242	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:56:51.801304
243	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:56:53.040539
244	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:56:58.215106
245	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:56:59.106085
246	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:57:06.337572
247	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:57:11.24482
248	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:57:13.87021
249	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:57:15.509576
250	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:57:16.704593
251	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:57:18.237042
252	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:57:19.580197
253	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:58:05.980775
254	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:58:42.340078
255	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:58:45.708739
256	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:58:54.658616
257	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 00:59:00.391684
258	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 01:03:41.661903
259	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 01:03:46.242185
260	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 01:04:19.875374
261	3	ELHAIMER AMINE	SUPER_ADMIN	create	org	\N	POST	/org/nodes	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 01:08:29.539306
262	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 01:08:50.192618
263	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 01:09:04.126138
264	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 01:09:31.323823
265	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 01:09:44.453503
266	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 01:10:10.730618
267	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 01:10:12.350571
268	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 01:10:13.499386
269	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 01:10:18.8131
270	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 01:10:19.440646
271	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 01:10:22.066455
272	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 01:10:24.106996
273	3	ELHAIMER AMINE	SUPER_ADMIN	update	org	\N	PATCH	/org/reorder	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 01:10:29.960441
274	3	ELHAIMER AMINE	SUPER_ADMIN	create	email	\N	POST	/email/test	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 01:26:22.431457
275	3	ELHAIMER AMINE	SUPER_ADMIN	create	logistique	\N	POST	/logistique/demandes	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 02:02:19.141923
276	3	ELHAIMER AMINE	SUPER_ADMIN	update	logistique	\N	PATCH	/logistique/demandes/1/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 02:02:45.291673
277	3	ELHAIMER AMINE	SUPER_ADMIN	update	logistique	\N	PATCH	/logistique/demandes/1/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 02:02:50.010393
278	3	ELHAIMER AMINE	SUPER_ADMIN	update	logistique	\N	PATCH	/logistique/demandes/1/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 02:03:07.770053
279	3	ELHAIMER AMINE	SUPER_ADMIN	update	logistique	\N	PATCH	/logistique/demandes/1/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 02:03:12.311925
280	3	ELHAIMER AMINE	SUPER_ADMIN	update	logistique	\N	PATCH	/logistique/demandes/1/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 02:03:19.474811
281	3	ELHAIMER AMINE	SUPER_ADMIN	update	logistique	\N	PATCH	/logistique/demandes/1/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 02:03:22.502439
282	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:02:18.041136
283	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:02:18.079394
284	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:02:18.105881
285	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:02:18.128152
286	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:02:18.147213
287	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:02:18.167769
288	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:02:18.188863
289	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:02:18.20645
290	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:02:18.229334
291	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:02:18.248111
292	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:02:18.265848
293	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:02:18.283819
294	3	ELHAIMER AMINE	SUPER_ADMIN	create	correction-rules	\N	POST	/correction-rules	409	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:02:38.791243
295	3	ELHAIMER AMINE	SUPER_ADMIN	create	logistique	\N	POST	/logistique/demandes	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:05:22.786133
296	3	ELHAIMER AMINE	SUPER_ADMIN	update	logistique	\N	PATCH	/logistique/demandes/2/statut	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:05:46.71328
297	3	ELHAIMER AMINE	SUPER_ADMIN	update	logistique	\N	PATCH	/logistique/demandes/2/statut	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:06:00.015009
298	3	ELHAIMER AMINE	SUPER_ADMIN	update	logistique	\N	PATCH	/logistique/demandes/2/statut	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:06:34.143183
299	3	ELHAIMER AMINE	SUPER_ADMIN	update	logistique	\N	PATCH	/logistique/demandes/2/statut	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:06:36.796675
300	3	ELHAIMER AMINE	SUPER_ADMIN	update	logistique	\N	PATCH	/logistique/demandes/2/statut	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:07:35.854887
301	3	ELHAIMER AMINE	SUPER_ADMIN	update	logistique	\N	PATCH	/logistique/demandes/2/statut	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:07:57.744511
302	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:10:24.207149
303	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:10:33.730562
304	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:10:33.732548
305	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:10:33.739609
306	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:10:33.77475
307	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:10:33.781224
308	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:10:33.802758
309	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:10:33.821857
310	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:10:33.826943
311	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:10:33.849404
312	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:10:33.856744
313	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:10:33.966441
314	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:10:34.006192
315	3	ELHAIMER AMINE	SUPER_ADMIN	create	email	\N	POST	/email/test	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:11:30.022943
316	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/vehicules	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:16:32.870922
317	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/vehicules/1/statut	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:16:44.07314
318	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/vehicules/1/statut	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:16:50.002268
319	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:18:27.655216
320	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/1/statut	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:18:36.073707
321	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:20:39.792042
322	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/1/statut	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:20:48.800294
323	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/2/statut	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:20:52.580527
324	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:24:09.229512
325	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:24:09.240939
326	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:24:09.244054
327	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:24:09.264463
328	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:24:09.271754
329	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:24:09.290069
330	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:24:09.296536
331	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:24:09.318979
332	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:24:09.321008
333	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:24:09.336846
334	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:24:09.482093
335	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 09:24:09.578465
336	3	ELHAIMER AMINE	SUPER_ADMIN	create	logistique	\N	POST	/logistique/demandes	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 11:45:35.991646
337	3	ELHAIMER AMINE	SUPER_ADMIN	update	logistique	\N	PATCH	/logistique/demandes/3/statut	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 11:45:56.188637
338	3	ELHAIMER AMINE	SUPER_ADMIN	update	logistique	\N	PATCH	/logistique/demandes/3/statut	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 11:46:24.415508
339	3	ELHAIMER AMINE	SUPER_ADMIN	update	logistique	\N	PATCH	/logistique/demandes/3/statut	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 11:47:07.787971
340	3	ELHAIMER AMINE	SUPER_ADMIN	update	logistique	\N	PATCH	/logistique/demandes/3/statut	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 11:47:10.755702
341	3	ELHAIMER AMINE	SUPER_ADMIN	update	logistique	\N	PATCH	/logistique/demandes/3/statut	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 11:47:29.64844
342	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 11:49:16.061728
343	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/3/statut	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 11:49:26.339191
344	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/3/statut	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 11:49:38.893576
345	3	ELHAIMER AMINE	SUPER_ADMIN	create	assistant	\N	POST	/api/assistant/chat	404	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 11:50:09.276932
346	3	ELHAIMER AMINE	SUPER_ADMIN	create	email	\N	POST	/email/test	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 11:50:52.214064
347	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/vehicules/1/statut	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 11:51:46.538677
348	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/vehicules/1/statut	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 11:51:49.134785
349	3	ELHAIMER AMINE	SUPER_ADMIN	create	chauffeurs	\N	POST	/chauffeurs	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:01:07.472831
350	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/3	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:01:48.455629
351	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/2	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:01:50.73118
352	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/1	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:01:53.666233
353	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:03:26.409195
354	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/4/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:03:45.352831
355	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/4/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:04:07.525196
356	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/vehicules/1	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:05:05.54101
357	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:06:31.750313
358	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/5/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:06:51.033328
359	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:08:31.259845
360	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:08:31.272999
361	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:08:31.285469
362	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:08:31.299751
363	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:08:31.314979
364	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:08:31.344783
365	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:08:31.366955
366	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:08:31.389059
367	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:08:31.408127
368	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:08:31.430682
369	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:08:31.454057
370	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:08:31.469316
371	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:08:59.936335
372	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:08:59.94004
373	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:08:59.957819
374	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:08:59.975523
375	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:08:59.99046
376	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:09:00.08531
377	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:09:00.103501
378	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:09:00.126289
379	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:09:00.140136
380	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:09:00.289771
381	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:09:00.311898
382	3	ELHAIMER AMINE	SUPER_ADMIN	update	sheet-rules	\N	PUT	/sheet-rules	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:09:00.365167
383	3	ELHAIMER AMINE	SUPER_ADMIN	create	correction-rules	\N	POST	/correction-rules	409	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:09:11.567963
384	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:12:09.11707
385	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/vehicules/1/statut	400	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:18:39.109621
386	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/vehicules/1/statut	400	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:18:46.243542
387	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/vehicules/1/statut	400	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:18:47.512205
388	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/vehicules/1/statut	400	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:18:49.474372
389	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/vehicules/1/statut	400	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:18:51.242554
390	3	ELHAIMER AMINE	SUPER_ADMIN	create	assistant	\N	POST	/api/assistant/chat	404	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:35:15.692603
391	3	ELHAIMER AMINE	SUPER_ADMIN	create	chauffeurs	\N	POST	/chauffeurs	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:35:58.558698
392	3	ELHAIMER AMINE	SUPER_ADMIN	create	chauffeurs	\N	POST	/chauffeurs	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:36:24.069328
393	3	ELHAIMER AMINE	SUPER_ADMIN	create	chauffeurs	\N	POST	/chauffeurs	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:36:50.04401
394	3	ELHAIMER AMINE	SUPER_ADMIN	create	chauffeurs	\N	POST	/chauffeurs	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:37:06.736892
395	3	ELHAIMER AMINE	SUPER_ADMIN	create	chauffeurs	\N	POST	/chauffeurs	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-25 01:37:44.252167
396	3	ELHAIMER AMINE	SUPER_ADMIN	create	users	\N	POST	/users	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 00:37:12.713733
397	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 00:38:38.900525
398	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/5/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 00:38:48.243293
399	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	2	PATCH	/chauffeurs/2/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 00:39:32.431325
400	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	2	PATCH	/chauffeurs/2/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 00:39:33.652291
401	3	ELHAIMER AMINE	SUPER_ADMIN	delete	chauffeurs	2	DELETE	/chauffeurs/2	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 00:39:37.031876
402	3	ELHAIMER AMINE	SUPER_ADMIN	delete	chauffeurs	6	DELETE	/chauffeurs/6	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 00:39:39.121523
403	3	ELHAIMER AMINE	SUPER_ADMIN	delete	chauffeurs	5	DELETE	/chauffeurs/5	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 00:39:41.021475
404	3	ELHAIMER AMINE	SUPER_ADMIN	delete	chauffeurs	1	DELETE	/chauffeurs/1	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 00:39:43.203563
405	3	ELHAIMER AMINE	SUPER_ADMIN	delete	chauffeurs	3	DELETE	/chauffeurs/3	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 00:39:45.239982
406	3	ELHAIMER AMINE	SUPER_ADMIN	delete	chauffeurs	4	DELETE	/chauffeurs/4	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 00:39:47.296542
407	3	ELHAIMER AMINE	SUPER_ADMIN	create	chauffeurs	\N	POST	/chauffeurs	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 00:40:40.219499
408	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 00:43:34.545647
409	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/6/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 00:44:06.189295
410	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 00:44:49.30196
411	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	7	PATCH	/chauffeurs/7/statut	400	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 00:45:37.207596
412	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	7	PATCH	/chauffeurs/7/statut	400	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 00:45:37.935128
413	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	7	PATCH	/chauffeurs/7/statut	400	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 00:45:38.945901
414	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	7	PATCH	/chauffeurs/7/statut	400	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 00:45:40.141272
415	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	7	PATCH	/chauffeurs/7/statut	400	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 00:45:43.097055
416	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/6/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 00:49:08.140609
417	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/6/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 00:49:20.889192
418	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/6/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 00:49:26.718507
419	3	ELHAIMER AMINE	SUPER_ADMIN	delete	chauffeurs	7	DELETE	/chauffeurs/7	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 00:49:45.809799
420	3	ELHAIMER AMINE	SUPER_ADMIN	create	chauffeurs	\N	POST	/chauffeurs	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 00:53:21.695926
421	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	8	PATCH	/chauffeurs/8/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:08:19.491026
422	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	8	PATCH	/chauffeurs/8/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:08:20.579743
423	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	8	PATCH	/chauffeurs/8/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:08:23.801576
424	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	8	PATCH	/chauffeurs/8/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:08:25.466656
425	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:09:18.981641
426	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/7/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:09:50.530654
427	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	8	PATCH	/chauffeurs/8	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:13:34.158037
428	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:13:40.036497
429	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:13:57.526442
430	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/vehicules/1/statut	400	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:17:55.70753
431	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/7	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:19:45.492252
432	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/6	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:19:47.290008
433	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/5	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:19:49.104872
434	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/4	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:19:51.143415
435	3	ELHAIMER AMINE	SUPER_ADMIN	delete	chauffeurs	8	DELETE	/chauffeurs/8	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:20:01.235266
436	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:20:14.112748
437	3	ELHAIMER AMINE	SUPER_ADMIN	create	chauffeurs	\N	POST	/chauffeurs	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:25:08.025838
438	3	ELHAIMER AMINE	SUPER_ADMIN	delete	users	10	DELETE	/users/10	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:25:26.545514
439	3	ELHAIMER AMINE	SUPER_ADMIN	create	users	\N	POST	/users	409	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:25:49.033824
440	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	9	PATCH	/chauffeurs/9/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:26:08.540386
441	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	9	PATCH	/chauffeurs/9/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:26:09.86477
442	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/vehicules/1	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:26:39.899492
443	3	ELHAIMER AMINE	SUPER_ADMIN	delete	chauffeurs	9	DELETE	/chauffeurs/9	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:26:44.448779
444	3	ELHAIMER AMINE	SUPER_ADMIN	create	chauffeurs	\N	POST	/chauffeurs	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:28:33.224389
445	3	ELHAIMER AMINE	SUPER_ADMIN	create	users	\N	POST	/users	409	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:28:56.016747
446	3	ELHAIMER AMINE	SUPER_ADMIN	create	users	\N	POST	/users	409	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:30:53.245282
447	3	ELHAIMER AMINE	SUPER_ADMIN	delete	trash	\N	DELETE	/trash/users/10	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:31:53.602362
448	3	ELHAIMER AMINE	SUPER_ADMIN	delete	chauffeurs	10	DELETE	/chauffeurs/10	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:32:10.486259
449	3	ELHAIMER AMINE	SUPER_ADMIN	create	chauffeurs	\N	POST	/chauffeurs	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:32:43.444213
450	3	ELHAIMER AMINE	SUPER_ADMIN	create	users	\N	POST	/users	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:33:01.551192
451	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/vehicules	409	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:34:15.615307
452	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/vehicules	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:39:48.98751
453	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:42:59.731633
454	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/vehicules/2/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:44:09.47156
455	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/vehicules/2/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:44:11.31134
456	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/8/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:44:31.625804
457	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:45:21.250083
458	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:45:31.076502
459	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:54:17.975798
460	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/8	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:54:59.232623
461	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/vehicules/2/statut	400	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:55:49.89941
462	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/vehicules/2/statut	400	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:55:56.079695
463	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/vehicules/2	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:56:01.703365
464	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/vehicules	409	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:56:41.509783
465	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/vehicules	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:56:51.053568
466	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	11	PATCH	/chauffeurs/11	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:57:02.946542
467	3	ELHAIMER AMINE	SUPER_ADMIN	delete	chauffeurs	11	DELETE	/chauffeurs/11	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:57:07.433343
468	3	ELHAIMER AMINE	SUPER_ADMIN	create	chauffeurs	\N	POST	/chauffeurs	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:57:39.832076
469	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:58:16.683416
470	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/9/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:58:47.36843
471	3	ELHAIMER AMINE	SUPER_ADMIN	update	users	11	PATCH	/users/11	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:08:30.343825
472	3	ELHAIMER AMINE	SUPER_ADMIN	delete	chauffeurs	12	DELETE	/chauffeurs/12	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:10:13.978135
473	3	ELHAIMER AMINE	SUPER_ADMIN	create	chauffeurs	\N	POST	/chauffeurs	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:11:09.266382
474	3	ELHAIMER AMINE	SUPER_ADMIN	update	users	11	PATCH	/users/11	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:11:18.605086
475	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/9	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:11:27.49879
476	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/vehicules/3/statut	400	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:11:38.237909
477	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/vehicules/3	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:11:44.549954
478	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/vehicules	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:12:23.075159
479	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:14:17.365883
480	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/10/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:15:01.789348
481	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	13	PATCH	/chauffeurs/13	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:16:23.26937
482	3	ELHAIMER AMINE	SUPER_ADMIN	delete	users	11	DELETE	/users/11	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:17:25.722636
483	3	ELHAIMER AMINE	SUPER_ADMIN	create	trash	\N	POST	/trash/users/11/restore	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:17:40.478781
484	3	ELHAIMER AMINE	SUPER_ADMIN	update	users	11	PATCH	/users/11	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:17:59.897737
485	3	ELHAIMER AMINE	SUPER_ADMIN	update	users	11	PATCH	/users/11	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:18:03.106926
486	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	13	PATCH	/chauffeurs/13	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:18:27.865402
487	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	13	PATCH	/chauffeurs/13	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:18:40.853594
488	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:20:39.213302
489	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/10/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:25:11.712661
490	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/10/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:25:14.571482
491	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/10/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:25:17.613852
492	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:28:02.044531
493	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/11/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:28:31.391994
494	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/11/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:32:59.695487
495	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/11/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:33:01.973046
496	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/11/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:33:04.814464
497	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:33:57.50809
498	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/12/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:34:42.795099
499	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/12/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:34:53.984403
500	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/12/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:34:57.231134
501	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/12/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:35:00.017064
502	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	13	PATCH	/chauffeurs/13/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:35:08.302901
503	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	13	PATCH	/chauffeurs/13/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 02:35:09.497303
504	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 11:28:40.1309
505	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/13/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 11:29:14.771229
506	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/13/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 11:50:40.861243
507	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/13/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 11:50:44.583401
508	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/13/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 11:50:48.499023
509	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 11:50:58.397797
510	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 11:51:24.057489
511	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 11:58:13.486642
512	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/14/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 11:58:30.35626
513	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/14/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 11:58:34.272052
514	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/14/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 11:58:45.396904
515	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/14/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 11:59:31.994882
516	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/14/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 11:59:37.718006
517	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/14/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 11:59:47.564724
518	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 13:01:24.158531
519	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	13	PATCH	/chauffeurs/13/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 13:01:46.908608
520	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	13	PATCH	/chauffeurs/13/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 13:01:49.763035
521	3	ELHAIMER AMINE	SUPER_ADMIN	delete	users	11	DELETE	/users/11	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 15:30:12.113765
522	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 15:33:02.085987
523	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	13	PATCH	/chauffeurs/13/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 15:33:45.94799
524	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	13	PATCH	/chauffeurs/13/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 15:33:46.935079
525	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	13	PATCH	/chauffeurs/13	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 15:34:00.609607
526	3	ELHAIMER AMINE	SUPER_ADMIN	create	users	\N	POST	/users	409	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 15:34:37.494578
527	3	ELHAIMER AMINE	SUPER_ADMIN	create	trash	\N	POST	/trash/users/11/restore	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 15:34:57.57739
528	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 15:36:42.695894
529	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/15/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 15:36:53.604425
530	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/15/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 15:36:58.133091
531	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/15/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 15:37:24.920008
532	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 15:37:40.276867
533	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/15/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 15:37:48.239283
534	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/15/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 15:37:52.029901
535	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/15/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 15:37:59.125989
536	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 15:38:11.516187
537	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:14:15.720071
538	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/16/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:14:31.010391
539	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/16/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:14:39.949333
540	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/16/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:15:03.672052
541	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/16/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:36:34.454145
542	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/16/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:36:36.792203
543	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/15/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:36:39.66041
544	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/15/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:36:41.943091
545	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/15/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:36:45.110724
546	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/16/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:36:48.3877
547	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/16	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:39:10.069235
548	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/15	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:39:11.977504
549	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/14	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:39:14.023334
550	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/13	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:39:15.741616
551	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/12	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:39:17.408511
552	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/11	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:39:19.221299
553	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/10	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:39:21.126994
554	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:40:22.715363
555	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/17/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:40:26.823573
556	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/17/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:40:27.268277
557	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/17/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:42:56.130509
558	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/17/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:45:07.56397
559	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/17/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:45:09.466843
560	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/17/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:45:12.283962
561	3	ELHAIMER AMINE	SUPER_ADMIN	create	chauffeurs	\N	POST	/chauffeurs	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:46:16.324218
562	3	ELHAIMER AMINE	SUPER_ADMIN	create	users	\N	POST	/users	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:46:47.184828
563	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:47:47.306037
564	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/18/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:47:50.267268
565	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/18/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:47:50.537506
566	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/18/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:49:17.174406
567	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/18/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 17:06:41.934083
568	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/18/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 17:06:44.100946
569	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/18/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 17:06:46.622425
570	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 17:08:05.871492
571	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/19/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 17:08:25.594799
572	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/19/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 17:08:25.846785
573	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 18:02:04.355114
574	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 18:02:12.016308
575	3	ELHAIMER AMINE	SUPER_ADMIN	create	assistant	\N	POST	/api/assistant/chat	404	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 18:43:45.120312
576	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 18:46:30.96739
577	3	ELHAIMER AMINE	SUPER_ADMIN	delete	users	12	DELETE	/users/12	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 00:01:48.290841
578	3	ELHAIMER AMINE	SUPER_ADMIN	delete	users	11	DELETE	/users/11	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 00:01:54.173292
579	3	ELHAIMER AMINE	SUPER_ADMIN	delete	trash	\N	DELETE	/trash/users/11	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 00:02:25.366413
580	3	ELHAIMER AMINE	SUPER_ADMIN	delete	trash	\N	DELETE	/trash/users/12	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 00:02:28.376664
581	3	ELHAIMER AMINE	SUPER_ADMIN	delete	trash	\N	DELETE	/trash/users/8	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 00:02:34.607719
582	3	ELHAIMER AMINE	SUPER_ADMIN	create	users	\N	POST	/users	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 00:21:28.104971
583	3	ELHAIMER AMINE	SUPER_ADMIN	update	users	2	PATCH	/users/2	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 00:35:11.146071
584	3	ELHAIMER AMINE	SUPER_ADMIN	update	users	2	PATCH	/users/2	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 00:35:13.185792
585	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	13	PATCH	/chauffeurs/13/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 00:56:39.677856
586	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	13	PATCH	/chauffeurs/13/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 00:56:40.771396
587	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 00:57:21.083793
588	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/20/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 00:57:52.244739
589	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/20/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 00:57:52.518774
590	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/19/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 00:59:05.579037
591	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/20/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 00:59:09.665794
592	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 01:00:40.917758
593	3	ELHAIMER AMINE	SUPER_ADMIN	create	email	\N	POST	/email/test	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 01:05:52.669976
594	3	ELHAIMER AMINE	SUPER_ADMIN	update	logistique	\N	PATCH	/logistique/demandes/3/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 01:06:26.610356
595	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 01:06:35.968114
596	3	ELHAIMER AMINE	SUPER_ADMIN	create	chauffeurs	\N	POST	/chauffeurs	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 01:19:42.913838
597	3	ELHAIMER AMINE	SUPER_ADMIN	delete	users	13	DELETE	/users/13	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 01:20:13.508036
598	3	ELHAIMER AMINE	SUPER_ADMIN	delete	chauffeurs	14	DELETE	/chauffeurs/14	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 01:20:22.309112
599	3	ELHAIMER AMINE	SUPER_ADMIN	delete	chauffeurs	13	DELETE	/chauffeurs/13	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 01:20:24.324607
600	3	ELHAIMER AMINE	SUPER_ADMIN	delete	chauffeurs	15	DELETE	/chauffeurs/15	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 01:20:26.639246
601	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 01:20:56.073286
602	3	ELHAIMER AMINE	SUPER_ADMIN	create	chauffeurs	\N	POST	/chauffeurs	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 01:22:47.025303
603	3	ELHAIMER AMINE	SUPER_ADMIN	create	users	\N	POST	/users	409	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 01:23:11.729407
604	3	ELHAIMER AMINE	SUPER_ADMIN	delete	trash	\N	DELETE	/trash/users/13	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 01:23:35.168845
605	3	ELHAIMER AMINE	SUPER_ADMIN	create	users	\N	POST	/users	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 01:23:59.827156
606	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 01:24:42.969529
607	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/21/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 01:25:24.519268
608	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/21/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 01:25:24.896997
609	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 01:27:45.661487
610	3	ELHAIMER AMINE	SUPER_ADMIN	delete	users	14	DELETE	/users/14	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 01:49:21.936056
611	3	ELHAIMER AMINE	SUPER_ADMIN	delete	trash	\N	DELETE	/trash/users/14	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 01:49:45.620668
612	3	ELHAIMER AMINE	SUPER_ADMIN	create	chauffeurs	16	POST	/chauffeurs/16/compte	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 01:55:15.397081
613	3	ELHAIMER AMINE	SUPER_ADMIN	create	chauffeurs	\N	POST	/chauffeurs	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 01:55:34.58206
614	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 01:55:51.836721
615	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 01:56:33.099659
616	3	ELHAIMER AMINE	SUPER_ADMIN	create	chauffeurs	17	POST	/chauffeurs/17/compte	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 02:00:51.768279
617	3	ELHAIMER AMINE	SUPER_ADMIN	create	users	15	POST	/users/15/reset-password	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 02:02:28.964955
618	3	ELHAIMER AMINE	SUPER_ADMIN	delete	users	15	DELETE	/users/15	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 02:03:03.80241
619	3	ELHAIMER AMINE	SUPER_ADMIN	delete	users	16	DELETE	/users/16	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 02:03:09.698373
620	3	ELHAIMER AMINE	SUPER_ADMIN	delete	trash	\N	DELETE	/trash/users/16	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 02:03:21.623307
621	3	ELHAIMER AMINE	SUPER_ADMIN	delete	trash	\N	DELETE	/trash/users/15	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 02:03:24.991178
622	3	ELHAIMER AMINE	SUPER_ADMIN	update	settings	\N	PATCH	/settings	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 02:05:05.17952
623	3	ELHAIMER AMINE	SUPER_ADMIN	create	system	\N	POST	/system/backup	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 02:05:13.636486
624	3	ELHAIMER AMINE	SUPER_ADMIN	create	logistique	\N	POST	/logistique/demandes	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 02:08:07.627299
625	3	ELHAIMER AMINE	SUPER_ADMIN	update	logistique	\N	PATCH	/logistique/demandes/4/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 02:08:41.910397
626	3	ELHAIMER AMINE	SUPER_ADMIN	update	logistique	\N	PATCH	/logistique/demandes/4/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 02:09:06.292314
627	3	ELHAIMER AMINE	SUPER_ADMIN	update	logistique	\N	PATCH	/logistique/demandes/4/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 02:09:19.472617
628	3	ELHAIMER AMINE	SUPER_ADMIN	update	logistique	\N	PATCH	/logistique/demandes/4/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 02:09:28.177874
629	3	ELHAIMER AMINE	SUPER_ADMIN	update	logistique	\N	PATCH	/logistique/demandes/4/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 02:09:41.039889
630	3	ELHAIMER AMINE	SUPER_ADMIN	update	logistique	\N	PATCH	/logistique/demandes/4/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 02:10:10.407982
631	3	ELHAIMER AMINE	SUPER_ADMIN	create	users	\N	POST	/users	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 02:45:40.356292
632	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 02:52:41.410622
633	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 02:53:21.673827
634	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/23/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 02:53:29.808258
635	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/23/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 02:54:26.238707
636	3	ELHAIMER AMINE	SUPER_ADMIN	delete	chauffeurs	18	DELETE	/chauffeurs/18	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 02:55:00.087775
637	3	ELHAIMER AMINE	SUPER_ADMIN	create	chauffeurs	16	POST	/chauffeurs/16/compte	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 02:55:14.199176
638	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 02:59:46.49958
639	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	16	PATCH	/chauffeurs/16/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 02:59:57.283369
640	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	16	PATCH	/chauffeurs/16/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 02:59:59.490746
641	3	ELHAIMER AMINE	SUPER_ADMIN	delete	users	17	DELETE	/users/17	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 10:18:48.751246
642	3	ELHAIMER AMINE	SUPER_ADMIN	delete	trash	\N	DELETE	/trash/users/17	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 10:18:58.414258
643	3	ELHAIMER AMINE	SUPER_ADMIN	create	users	\N	POST	/users	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 10:19:27.137359
644	3	ELHAIMER AMINE	SUPER_ADMIN	delete	users	18	DELETE	/users/18	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 10:19:38.604512
645	3	ELHAIMER AMINE	SUPER_ADMIN	delete	trash	\N	DELETE	/trash/users/18	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 10:19:47.074598
646	3	ELHAIMER AMINE	SUPER_ADMIN	create	users	\N	POST	/users	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 10:20:06.051577
647	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 10:20:58.523954
648	3	ELHAIMER AMINE	SUPER_ADMIN	delete	chauffeurs	20	DELETE	/chauffeurs/20	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 12:03:41.601894
649	3	ELHAIMER AMINE	SUPER_ADMIN	delete	chauffeurs	17	DELETE	/chauffeurs/17	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 12:03:44.136281
650	3	ELHAIMER AMINE	SUPER_ADMIN	delete	chauffeurs	16	DELETE	/chauffeurs/16	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 12:03:46.661634
651	3	ELHAIMER AMINE	SUPER_ADMIN	delete	chauffeurs	19	DELETE	/chauffeurs/19	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 12:03:48.909152
652	3	ELHAIMER AMINE	SUPER_ADMIN	delete	users	19	DELETE	/users/19	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 12:04:12.079769
653	3	ELHAIMER AMINE	SUPER_ADMIN	delete	trash	\N	DELETE	/trash/users/19	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 12:04:35.0356
654	3	ELHAIMER AMINE	SUPER_ADMIN	create	chauffeurs	\N	POST	/chauffeurs	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 12:04:54.11699
655	3	ELHAIMER AMINE	SUPER_ADMIN	create	users	\N	POST	/users	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 12:05:26.145267
656	3	ELHAIMER AMINE	SUPER_ADMIN	create	chauffeurs	21	POST	/chauffeurs/21/compte	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 12:22:41.349109
657	3	ELHAIMER AMINE	SUPER_ADMIN	create	chauffeurs	22	POST	/chauffeurs/22/compte	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 12:22:56.762729
658	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 13:27:16.393914
659	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 13:30:28.04651
660	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/25/statut	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 13:31:44.932551
661	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/25/statut	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 13:32:01.284649
662	3	ELHAIMER AMINE	SUPER_ADMIN	delete	chauffeurs	22	DELETE	/chauffeurs/22	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 13:32:12.709855
663	3	ELHAIMER AMINE	SUPER_ADMIN	delete	chauffeurs	21	DELETE	/chauffeurs/21	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 13:32:15.160263
664	3	ELHAIMER AMINE	SUPER_ADMIN	delete	users	20	DELETE	/users/20	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 13:32:24.716819
665	3	ELHAIMER AMINE	SUPER_ADMIN	delete	users	21	DELETE	/users/21	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 13:32:27.219873
666	3	ELHAIMER AMINE	SUPER_ADMIN	delete	trash	\N	DELETE	/trash/users/21	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 13:32:34.614327
667	3	ELHAIMER AMINE	SUPER_ADMIN	delete	trash	\N	DELETE	/trash/users/20	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 13:32:38.391685
668	3	ELHAIMER AMINE	SUPER_ADMIN	create	chauffeurs	\N	POST	/chauffeurs	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 13:32:53.748323
669	3	ELHAIMER AMINE	SUPER_ADMIN	create	users	\N	POST	/users	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 13:33:21.773379
670	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 13:39:09.895328
671	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 13:55:32.859815
672	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/26/statut	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 13:55:42.611849
673	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 13:59:18.271216
674	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/27/statut	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 14:00:47.994686
675	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/27/statut	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 14:00:53.741213
676	3	ELHAIMER AMINE	SUPER_ADMIN	create	chauffeurs	\N	POST	/chauffeurs	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 14:06:34.012567
677	3	ELHAIMER AMINE	SUPER_ADMIN	create	chauffeurs	25	POST	/chauffeurs/25/compte	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 14:06:57.579723
678	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 14:36:58.992031
679	22	SMAIL YASSINE	CHAUFFEUR	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 14:37:07.319412
680	22	SMAIL YASSINE	CHAUFFEUR	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 14:37:07.438178
681	22	SMAIL YASSINE	CHAUFFEUR	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 14:37:11.133753
682	22	SMAIL YASSINE	CHAUFFEUR	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 14:37:11.189052
683	22	SMAIL YASSINE	CHAUFFEUR	update	chauffeur-portal	\N	PATCH	/chauffeur-portal/missions/28/statut	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 14:37:43.963842
684	22	SMAIL YASSINE	CHAUFFEUR	update	chauffeur-portal	\N	PATCH	/chauffeur-portal/missions/28/statut	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 14:38:09.930099
685	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 14:43:06.579399
686	22	SMAIL YASSINE	CHAUFFEUR	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.77.248	Mozilla/5.0 (iPhone; CPU iPhone OS 26_5_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/430.3.945886556 Mobile/15E148 Safari/604.1	2026-07-27 14:43:12.623428
687	22	SMAIL YASSINE	CHAUFFEUR	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.77.248	Mozilla/5.0 (iPhone; CPU iPhone OS 26_5_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/430.3.945886556 Mobile/15E148 Safari/604.1	2026-07-27 14:43:12.629101
688	22	SMAIL YASSINE	CHAUFFEUR	update	chauffeur-portal	\N	PATCH	/chauffeur-portal/missions/29/statut	200	\N	192.168.77.248	Mozilla/5.0 (iPhone; CPU iPhone OS 26_5_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/430.3.945886556 Mobile/15E148 Safari/604.1	2026-07-27 14:43:17.860891
689	22	SMAIL YASSINE	CHAUFFEUR	update	chauffeur-portal	\N	PATCH	/chauffeur-portal/missions/29/statut	200	\N	192.168.77.248	Mozilla/5.0 (iPhone; CPU iPhone OS 26_5_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/430.3.945886556 Mobile/15E148 Safari/604.1	2026-07-27 14:43:57.489355
690	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 14:45:34.3995
691	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 14:46:29.226557
692	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/vehicules/4/statut	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 14:48:00.997177
693	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/vehicules/4/statut	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 14:48:08.627657
694	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/vehicules/4/statut	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 14:48:12.508334
695	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/vehicules/4/statut	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 14:48:17.418141
696	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 15:14:28.830296
697	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 15:15:28.121944
698	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 00:09:44.442238
699	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 00:10:17.108637
700	3	ELHAIMER AMINE	SUPER_ADMIN	create	chauffeurs	23	POST	/chauffeurs/23/compte	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 00:11:07.840667
701	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 00:44:54.60494
702	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 00:45:35.441291
703	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 00:46:02.835851
704	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/30/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 00:46:30.606815
705	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/30/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:02:50.773226
706	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:03:29.562468
707	22	SMAIL YASSINE	CHAUFFEUR	create	ma-mission	31	POST	/ma-mission/31/accept	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:04:38.914662
708	22	SMAIL YASSINE	CHAUFFEUR	create	ma-mission	31	POST	/ma-mission/31/demarrer	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:04:53.504939
709	22	SMAIL YASSINE	CHAUFFEUR	create	ma-mission	31	POST	/ma-mission/31/arrivee	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:04:59.193157
710	22	SMAIL YASSINE	CHAUFFEUR	create	ma-mission	31	POST	/ma-mission/31/commencer	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:05:20.140002
711	22	SMAIL YASSINE	CHAUFFEUR	create	ma-mission	31	POST	/ma-mission/31/terminer	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:05:39.390746
712	22	SMAIL YASSINE	CHAUFFEUR	create	ma-mission	31	POST	/ma-mission/31/retour	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:05:44.814512
713	22	SMAIL YASSINE	CHAUFFEUR	create	ma-mission	31	POST	/ma-mission/31/arrive-siege	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:06:06.20142
714	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/31/statut	400	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:06:18.431098
715	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/31/statut	400	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:06:28.892206
716	22	SMAIL YASSINE	CHAUFFEUR	create	ma-mission	31	POST	/ma-mission/31/signature	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:07:02.245477
717	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/31/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:07:35.261267
718	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:08:23.696232
719	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:12:29.221549
720	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:12:33.815341
721	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:32:08.589089
722	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:32:14.499417
723	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:43:59.515558
724	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/32/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:45:08.520411
725	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	23	PATCH	/chauffeurs/23/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:45:23.628618
726	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	24	PATCH	/chauffeurs/24/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:45:26.520767
727	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	23	PATCH	/chauffeurs/23/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:45:28.350242
728	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	24	PATCH	/chauffeurs/24/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:45:31.067216
729	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	24	PATCH	/chauffeurs/24/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:45:33.012386
730	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	24	PATCH	/chauffeurs/24/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:45:34.482779
731	3	ELHAIMER AMINE	SUPER_ADMIN	delete	chauffeurs	23	DELETE	/chauffeurs/23	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:45:42.456312
732	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:45:49.898007
733	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:46:31.766481
734	22	SMAIL YASSINE	CHAUFFEUR	create	ma-mission	33	POST	/ma-mission/33/accept	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:47:17.087572
735	22	SMAIL YASSINE	CHAUFFEUR	create	ma-mission	33	POST	/ma-mission/33/demarrer	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:47:51.60589
736	22	SMAIL YASSINE	CHAUFFEUR	create	ma-mission	33	POST	/ma-mission/33/arrivee	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:48:05.444564
737	22	SMAIL YASSINE	CHAUFFEUR	create	ma-mission	33	POST	/ma-mission/33/commencer	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:48:22.833476
738	22	SMAIL YASSINE	CHAUFFEUR	create	ma-mission	33	POST	/ma-mission/33/terminer	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:48:32.262097
739	22	SMAIL YASSINE	CHAUFFEUR	create	ma-mission	33	POST	/ma-mission/33/retour	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:48:34.861625
740	22	SMAIL YASSINE	CHAUFFEUR	create	ma-mission	33	POST	/ma-mission/33/arrive-siege	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:48:44.48267
741	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/33/statut	400	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:48:53.263655
742	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/33/statut	400	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:48:55.293865
743	3	ELHAIMER AMINE	SUPER_ADMIN	update	parc-auto	\N	PATCH	/parc-auto/deplacements/33/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:49:20.134288
744	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/32	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:49:49.291046
745	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/33	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:49:49.335295
746	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/31	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:49:49.343312
747	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/26	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:50:29.367138
748	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/24	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:50:29.53132
749	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/29	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:50:29.798558
750	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/25	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:50:29.847135
751	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/23	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:50:29.883068
752	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/27	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:50:29.982736
753	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/30	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:50:30.12518
754	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/28	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:50:30.147779
759	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/19	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:50:30.643497
755	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/22	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:50:30.16766
760	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/17	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:50:30.707239
756	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/21	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:50:30.31835
757	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/20	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:50:30.618216
758	3	ELHAIMER AMINE	SUPER_ADMIN	delete	parc-auto	\N	DELETE	/parc-auto/deplacements/18	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:50:30.630696
761	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:55:44.758279
762	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	24	PATCH	/chauffeurs/24/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 02:01:50.735079
763	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	24	PATCH	/chauffeurs/24/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 02:01:52.276899
764	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	25	PATCH	/chauffeurs/25/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 02:01:53.599972
765	3	ELHAIMER AMINE	SUPER_ADMIN	update	chauffeurs	25	PATCH	/chauffeurs/25/statut	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 02:01:54.375588
766	3	ELHAIMER AMINE	SUPER_ADMIN	create	notifications	\N	POST	/notifications/mark-read	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 02:01:56.399279
767	3	ELHAIMER AMINE	SUPER_ADMIN	create	parc-auto	\N	POST	/parc-auto/deplacements	201	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 02:12:36.623338
768	22	SMAIL YASSINE	CHAUFFEUR	create	ma-mission	34	POST	/ma-mission/34/accept	200	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 02:12:51.091638
\.


--
-- Data for Name: calendar_events; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.calendar_events (id, title, type, date, description, created_by, deleted_at, deleted_by, created_at) FROM stdin;
\.


--
-- Data for Name: chauffeur_events; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.chauffeur_events (id, chauffeur_id, statut, commentaire, action_par, created_at) FROM stdin;
1	1	disponible	Retour de mission — OM-2026-0005.	ELHAIMER AMINE	2026-07-26 00:38:48.221548
2	2	indisponible	Changement de statut manuel.	ELHAIMER AMINE	2026-07-26 00:39:32.42628
3	2	disponible	Changement de statut manuel.	ELHAIMER AMINE	2026-07-26 00:39:33.646692
4	7	en_mission	Départ en mission — OM-2026-0006.	ELHAIMER AMINE	2026-07-26 00:44:06.177949
5	7	disponible	Retour de mission — OM-2026-0006.	ELHAIMER AMINE	2026-07-26 00:49:26.698024
6	8	indisponible	Changement de statut manuel.	ELHAIMER AMINE	2026-07-26 01:08:19.487399
7	8	disponible	Changement de statut manuel.	ELHAIMER AMINE	2026-07-26 01:08:20.576597
8	8	indisponible	Changement de statut manuel.	ELHAIMER AMINE	2026-07-26 01:08:23.798669
9	8	disponible	Changement de statut manuel.	ELHAIMER AMINE	2026-07-26 01:08:25.464525
10	8	en_mission	Départ en mission — OM-2026-0007.	ELHAIMER AMINE	2026-07-26 01:09:50.516886
11	9	indisponible	Changement de statut manuel.	ELHAIMER AMINE	2026-07-26 01:26:08.537901
12	9	disponible	Changement de statut manuel.	ELHAIMER AMINE	2026-07-26 01:26:09.86259
13	11	en_mission	Départ en mission — OM-2026-0008.	ELHAIMER AMINE	2026-07-26 01:44:31.61973
14	12	en_mission	Départ en mission — OM-2026-0009.	ELHAIMER AMINE	2026-07-26 01:58:47.360844
15	13	en_mission	Départ en mission — OM-2026-0010.	ELHAIMER AMINE	2026-07-26 02:15:01.781321
16	13	disponible	Retour de mission — OM-2026-0010.	ELHAIMER AMINE	2026-07-26 02:25:17.595893
17	13	en_mission	Départ en mission — OM-2026-0011.	ELHAIMER AMINE	2026-07-26 02:28:31.379311
18	13	disponible	Retour de mission — OM-2026-0011.	ELHAIMER AMINE	2026-07-26 02:33:04.802305
19	13	en_mission	Départ en mission — OM-2026-0012.	ELHAIMER AMINE	2026-07-26 02:34:42.784167
20	13	disponible	Retour de mission — OM-2026-0012.	ELHAIMER AMINE	2026-07-26 02:34:59.999278
21	13	indisponible	Changement de statut manuel.	ELHAIMER AMINE	2026-07-26 02:35:08.299809
22	13	disponible	Changement de statut manuel.	ELHAIMER AMINE	2026-07-26 02:35:09.495424
23	13	en_mission	Départ en mission — OM-2026-0013.	ELHAIMER AMINE	2026-07-26 11:29:14.76292
24	13	disponible	Retour de mission — OM-2026-0013.	ELHAIMER AMINE	2026-07-26 11:50:48.480609
25	13	en_mission	Départ en mission — OM-2026-0014.	ELHAIMER AMINE	2026-07-26 11:58:45.385168
26	13	disponible	Retour de mission — OM-2026-0014.	ELHAIMER AMINE	2026-07-26 11:59:47.548133
27	13	indisponible	Changement de statut manuel.	ELHAIMER AMINE	2026-07-26 13:01:46.903421
28	13	disponible	Changement de statut manuel.	ELHAIMER AMINE	2026-07-26 13:01:49.760763
29	13	indisponible	Changement de statut manuel.	ELHAIMER AMINE	2026-07-26 15:33:45.944978
30	13	disponible	Changement de statut manuel.	ELHAIMER AMINE	2026-07-26 15:33:46.929727
31	13	en_mission	Départ en mission — OM-2026-0015.	ELHAIMER AMINE	2026-07-26 15:37:24.90442
32	13	disponible	Retour de mission — OM-2026-0015.	ELHAIMER AMINE	2026-07-26 15:37:59.096262
33	13	en_mission	Départ en mission — OM-2026-0016.	ELHAIMER AMINE	2026-07-26 16:15:03.655339
34	13	disponible	Retour de mission — OM-2026-0015.	ELHAIMER AMINE	2026-07-26 16:36:45.101938
35	13	en_mission	Départ en mission — OM-2026-0017.	ELHAIMER AMINE	2026-07-26 16:42:56.122658
36	13	disponible	Retour de mission — OM-2026-0017.	ELHAIMER AMINE	2026-07-26 16:45:12.267993
37	14	en_mission	Départ en mission — OM-2026-0018.	ELHAIMER AMINE	2026-07-26 16:49:17.15956
38	14	disponible	Retour de mission — OM-2026-0018.	ELHAIMER AMINE	2026-07-26 17:06:46.600304
39	13	indisponible	Changement de statut manuel.	ELHAIMER AMINE	2026-07-27 00:56:39.670824
40	13	disponible	Changement de statut manuel.	ELHAIMER AMINE	2026-07-27 00:56:40.763492
\.


--
-- Data for Name: chauffeurs; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.chauffeurs (id, nom, telephone, permis, statut, notes, deleted_at, deleted_by, created_at, updated_at, cin, matricule, user_id) FROM stdin;
2	ANAS	\N	B	disponible	\N	2026-07-25 23:39:37.019	ELHAIMER AMINE	2026-07-25 01:35:58.544589	2026-07-25 23:39:33.642	\N	\N	\N
6	CHAKIB	\N	B	disponible	\N	2026-07-25 23:39:39.108	ELHAIMER AMINE	2026-07-25 01:37:44.234944	2026-07-25 01:37:44.234944	\N	\N	\N
5	ELKHOMSI AHMED	\N	B	disponible	\N	2026-07-25 23:39:41.008	ELHAIMER AMINE	2026-07-25 01:37:06.722126	2026-07-25 01:37:06.722126	\N	\N	\N
1	SMAIL YASSINE	0698550981	B , C	disponible	\N	2026-07-25 23:39:43.192	ELHAIMER AMINE	2026-07-25 01:01:07.449801	2026-07-25 23:38:48.204	\N	\N	\N
3	YOUSSEF	\N	B , C	disponible	\N	2026-07-25 23:39:45.228	ELHAIMER AMINE	2026-07-25 01:36:24.048454	2026-07-25 01:36:24.048454	\N	\N	\N
4	ZIYANI	\N	B	disponible	\N	2026-07-25 23:39:47.288	ELHAIMER AMINE	2026-07-25 01:36:50.026897	2026-07-25 01:36:50.026897	\N	\N	\N
7	SMAIL YASSINE	0698550981	B , C	disponible	\N	2026-07-25 23:49:45.795	ELHAIMER AMINE	2026-07-26 00:40:40.204454	2026-07-25 23:49:26.686	\N	\N	\N
14	ANAS A	\N	B	disponible	\N	2026-07-27 00:20:22.295	ELHAIMER AMINE	2026-07-26 16:46:16.288479	2026-07-26 16:06:46.586	AD3333	P2222	\N
13	SMAIL YASSINE	0698550981	B , C	disponible	\N	2026-07-27 00:20:24.306	ELHAIMER AMINE	2026-07-26 02:11:09.251487	2026-07-26 23:56:40.747	AD1234	P1111	\N
15	YOUSSEF	\N	B	disponible	\N	2026-07-27 00:20:26.627	ELHAIMER AMINE	2026-07-27 01:19:42.841724	2026-07-27 01:19:42.841724	AA222	P789	\N
8	SMAIL YASSINE	0698550981	B , C	en_mission	\N	2026-07-26 00:20:01.231	ELHAIMER AMINE	2026-07-26 00:53:21.680308	2026-07-26 00:13:34.132	\N	\N	\N
9	SMAIL YASSINE	0698550981	B , C	disponible	\N	2026-07-26 00:26:44.437	ELHAIMER AMINE	2026-07-26 01:25:08.020325	2026-07-26 00:26:09.853	\N	\N	\N
10	SMAIL YASSINE	0698550981	B , C	disponible	\N	2026-07-26 00:32:10.481	ELHAIMER AMINE	2026-07-26 01:28:33.210876	2026-07-26 01:28:33.210876	\N	\N	\N
11	SMAIL YASSINE	0698550981	B , C	en_mission	\N	2026-07-26 00:57:07.421	ELHAIMER AMINE	2026-07-26 01:32:43.434038	2026-07-26 00:57:02.933	\N	\N	\N
12	SMAIL YASSINE	\N	B , C	en_mission	\N	2026-07-26 01:10:13.968	ELHAIMER AMINE	2026-07-26 01:57:39.816742	2026-07-26 00:58:47.341	\N	\N	\N
18	SMAIL YASSINE	\N	\N	disponible	\N	2026-07-27 01:55:00.07	ELHAIMER AMINE	2026-07-27 02:45:40.3451	2026-07-27 01:54:26.23	\N	\N	17
20	SMAIL YASSINE	\N	\N	disponible	\N	2026-07-27 11:03:41.581	ELHAIMER AMINE	2026-07-27 10:20:06.045564	2026-07-27 10:20:06.045564	\N	\N	19
17	YOUSSEF	\N	B	disponible	\N	2026-07-27 11:03:44.124	ELHAIMER AMINE	2026-07-27 01:55:34.565674	2026-07-27 01:00:51.758	\N	\N	16
16	SMAIL YASSINE	\N	B	disponible	\N	2026-07-27 11:03:46.649	ELHAIMER AMINE	2026-07-27 01:22:47.003455	2026-07-27 01:59:59.478	AD345	P6666	15
19	123456	\N	\N	disponible	\N	2026-07-27 11:03:48.896	ELHAIMER AMINE	2026-07-27 10:19:27.128805	2026-07-27 10:19:27.128805	\N	\N	18
22	SMAIL YASSINE	\N	\N	disponible	\N	2026-07-27 12:32:12.702	ELHAIMER AMINE	2026-07-27 12:05:26.140063	2026-07-27 12:05:26.140063	\N	\N	20
21	SMAIL YASSINE	\N	B	disponible	\N	2026-07-27 12:32:15.151	ELHAIMER AMINE	2026-07-27 12:04:54.068642	2026-07-27 12:32:01.269	\N	\N	21
23	SMAIL YASSINE	\N	B	disponible	\N	2026-07-28 00:45:42.441	ELHAIMER AMINE	2026-07-27 13:32:53.733412	2026-07-28 00:45:28.339	\N	\N	25
25	youssef	\N	B	disponible	\N	\N	\N	2026-07-27 14:06:33.965644	2026-07-28 01:01:54.365	\N	\N	24
24	SMAIL YASSINE	\N	\N	en_mission	\N	\N	\N	2026-07-27 13:33:21.761171	2026-07-28 01:12:51.088	\N	\N	22
\.


--
-- Data for Name: connection_logs; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.connection_logs (id, user_id, username, success, reason, ip_address, user_agent, created_at) FROM stdin;
1	7	superadmin	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-15 23:58:56.791849
2	3	ELHAIMER AMINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-15 23:59:11.093215
3	2	ANAS JABRAN	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 00:02:40.275883
4	4	TEST	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 00:02:47.243605
5	3	ELHAIMER AMINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 00:03:03.63798
6	2	ANAS JABRAN	t	\N	192.168.0.132	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-16 00:04:09.951156
7	2	ANAS JABRAN	f	account_disabled	192.168.0.132	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-16 00:05:08.034903
8	2	ANAS JABRAN	t	\N	192.168.0.132	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-16 00:05:30.889116
9	3	ELHAIMER AMINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 00:33:30.548308
10	2	ANAS JABRAN	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 00:40:45.722512
11	7	superadmin	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 00:40:55.70496
12	3	ELHAIMER AMINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 00:41:22.648977
13	2	ANAS JABRAN	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 00:51:54.915928
46	3	ELHAIMER AMINE	t	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 09:12:31.573715
47	6	SARA EL HAMADI	t	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 09:14:05.933604
48	3	ELHAIMER AMINE	t	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 09:32:58.42501
49	3	ELHAIMER AMINE	t	\N	192.168.77.21	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-16 09:42:19.782218
50	3	ELHAIMER AMINE	t	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 12:33:22.525179
51	\N	DAMIR ABDELMONIEM	f	unknown_username	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 12:40:00.775088
52	6	SARA EL HAMADI	t	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 12:40:04.306142
53	3	ELHAIMER AMINE	t	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-16 12:41:34.936822
54	8	MOHAMED HAMEDOUN	t	\N	192.168.77.87	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-16 13:05:42.169817
55	3	ELHAIMER AMINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 01:44:09.726543
56	3	ELHAIMER AMINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 01:45:33.511707
57	3	ELHAIMER AMINE	t	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 09:34:33.941732
58	9	SOUKAINA	t	\N	192.168.80.43	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 09:42:02.708201
59	2	ANAS JABRAN	t	\N	192.168.77.21	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-17 09:45:17.600632
60	3	ELHAIMER AMINE	t	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-17 15:17:03.24277
61	2	ANAS JABRAN	t	\N	192.168.0.132	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-18 00:37:06.578766
62	3	ELHAIMER AMINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-19 00:57:24.908397
63	3	ELHAIMER AMINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-19 01:07:00.64287
64	2	ANAS JABRAN	t	\N	192.168.0.132	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-19 01:07:52.050442
65	3	ELHAIMER AMINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-19 17:44:06.374707
66	3	ELHAIMER AMINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-21 01:46:16.773653
67	3	ELHAIMER AMINE	t	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-22 14:20:14.056595
68	3	ELHAIMER AMINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 01:03:19.190594
69	3	ELHAIMER AMINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 01:17:37.352109
70	3	ELHAIMER AMINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 02:00:39.676759
71	10	SMAIL YASSINE	t	\N	192.168.0.132	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-26 00:38:10.304897
72	10	SMAIL YASSINE	t	\N	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-26 01:09:42.602373
73	10	SMAIL YASSINE	t	\N	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-26 01:13:17.754463
74	\N	SMAIL YASSINE	f	unknown_username	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:26:51.073628
75	3	ELHAIMER AMINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:27:10.688917
76	11	SMAIL YASSINE	t	\N	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-26 01:40:12.51588
77	11	SMAIL YASSINE	t	\N	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-26 01:54:44.063617
78	11	SMAIL YASSINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:59:27.454866
79	11	SMAIL YASSINE	t	\N	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-26 02:20:17.399076
80	11	SMAIL YASSINE	t	\N	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-26 02:25:03.782537
81	11	SMAIL YASSINE	t	\N	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-26 02:29:12.763268
82	11	SMAIL YASSINE	t	\N	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-26 02:34:49.600855
83	3	ELHAIMER AMINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 11:27:49.484001
84	11	SMAIL YASSINE	t	\N	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-26 11:31:06.006514
85	11	SMAIL YASSINE	t	\N	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-26 11:50:35.651926
86	3	ELHAIMER AMINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 15:32:50.281038
87	11	SMAIL YASSINE	t	\N	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-26 15:35:44.980876
88	11	SMAIL YASSINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 15:57:38.969233
89	11	SMAIL YASSINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:13:11.809633
90	3	ELHAIMER AMINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:13:32.958221
91	11	SMAIL YASSINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:15:57.126281
92	11	SMAIL YASSINE	t	\N	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-26 16:39:58.88695
93	3	ELHAIMER AMINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:44:57.402668
94	12	ANAS A	t	\N	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-26 16:47:05.434017
95	12	ANAS A	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:58:40.062636
96	3	ELHAIMER AMINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 17:06:27.464135
97	12	ANAS A	t	\N	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-26 17:08:21.233169
98	3	ELHAIMER AMINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 00:01:17.452065
99	\N	ANAS A	f	unknown_username	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 00:20:48.054605
100	13	SMAIL YASSINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 00:21:42.939409
101	3	ELHAIMER AMINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 00:32:19.665147
102	3	ELHAIMER AMINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 00:36:05.072588
103	13	SMAIL YASSINE	t	\N	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-27 00:57:46.644485
104	3	ELHAIMER AMINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 01:05:06.554141
105	14	SMAIL YASSINE	t	\N	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-27 01:25:19.536891
106	3	ELHAIMER AMINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 01:54:45.529985
107	\N	SMAIL YASSINE	f	unknown_username	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-27 02:01:49.250475
108	\N	SMAIL YASSINE	f	unknown_username	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-27 02:01:50.909139
109	\N	SMAIL YASSINE	f	unknown_username	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-27 02:02:34.734528
110	\N	SMAIL YASSINE	f	unknown_username	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-27 02:02:57.804833
111	17	SMAIL YASSINE	t	\N	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-27 02:46:04.01202
112	17	SMAIL YASSINE	t	\N	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-27 02:52:27.993025
113	17	SMAIL YASSINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 02:53:44.758009
114	\N	smail.yassine	f	unknown_username	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-27 02:55:35.048941
115	\N	smail.yassine	f	unknown_username	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-27 02:55:57.21434
116	17	SMAIL YASSINE	f	bad_password	192.168.77.21	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-27 10:18:34.741503
117	19	SMAIL YASSINE	f	bad_password	192.168.77.21	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-27 10:20:14.63505
118	19	SMAIL YASSINE	t	\N	192.168.77.21	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-27 10:20:19.867907
119	19	SMAIL YASSINE	t	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 10:23:26.36445
120	19	SMAIL YASSINE	t	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 12:01:49.521986
121	19	SMAIL YASSINE	t	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 12:02:31.454908
122	3	ELHAIMER AMINE	t	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 12:03:17.26274
123	20	SMAIL YASSINE	t	\N	192.168.77.21	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-27 12:05:44.986902
124	20	SMAIL YASSINE	t	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 12:09:16.656218
125	20	SMAIL YASSINE	t	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 12:10:22.584755
126	20	SMAIL YASSINE	t	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 12:14:57.306768
127	20	SMAIL YASSINE	t	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 12:21:04.917362
128	20	SMAIL YASSINE	t	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 12:23:06.192914
129	20	SMAIL YASSINE	t	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 12:23:57.153024
130	20	SMAIL YASSINE	t	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 12:25:10.087102
131	20	SMAIL YASSINE	t	\N	192.168.77.21	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-27 13:27:59.205275
132	20	SMAIL YASSINE	t	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 13:30:44.010658
133	3	ELHAIMER AMINE	t	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 13:38:22.382508
134	22	SMAIL YASSINE	t	\N	192.168.77.21	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-27 13:39:24.856907
135	22	SMAIL YASSINE	t	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 13:40:48.719531
136	22	SMAIL YASSINE	t	\N	192.168.77.21	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-27 13:49:08.094297
137	22	SMAIL YASSINE	t	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 13:58:14.28067
138	22	SMAIL YASSINE	t	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 13:59:37.784859
139	22	SMAIL YASSINE	t	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 14:14:54.789045
140	22	SMAIL YASSINE	t	\N	192.168.77.21	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-27 14:24:14.060836
141	22	SMAIL YASSINE	t	\N	192.168.77.248	Mozilla/5.0 (iPhone; CPU iPhone OS 26_5_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/430.3.945886556 Mobile/15E148 Safari/604.1	2026-07-27 14:41:51.01797
142	22	SMAIL YASSINE	t	\N	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 15:23:19.712603
143	22	SMAIL YASSINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 00:08:07.440241
144	22	SMAIL YASSINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 00:10:35.214022
145	22	SMAIL YASSINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 00:11:14.663954
146	22	SMAIL YASSINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 00:15:59.249733
147	3	ELHAIMER AMINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 00:17:47.658896
148	22	SMAIL YASSINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:43:06.639475
149	22	SMAIL YASSINE	t	\N	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:44:15.838636
\.


--
-- Data for Name: correction_rules; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.correction_rules (id, source_sheet_name, target_sheet_name, created_by, created_at, deleted_at, deleted_by) FROM stdin;
1	Fix	ENTRAIDE NATIONALE FIXE 	ELHAIMER AMINE	2026-07-14 10:40:17.305082	\N	\N
\.


--
-- Data for Name: custom_fields; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.custom_fields (id, label, use_as_match_key, created_at, updated_at, deleted_at, deleted_by) FROM stdin;
\.


--
-- Data for Name: dashboard_snapshot; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.dashboard_snapshot (id, total_factures, factures_reglees, factures_impayees, montant_impaye, lignes_fixes, updated_by, updated_at) FROM stdin;
\.


--
-- Data for Name: deplacement_events; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.deplacement_events (id, deplacement_id, statut, commentaire, latitude, longitude, vitesse, action_par, created_at) FROM stdin;
1	30	en_attente_acceptation	\N	\N	\N	\N	ELHAIMER AMINE	2026-07-28 00:46:30.56802
2	30	annule	\N	\N	\N	\N	ELHAIMER AMINE	2026-07-28 01:02:50.726529
3	31	en_attente_acceptation	Assigné automatiquement lors de la création.	\N	\N	\N	ELHAIMER AMINE	2026-07-28 01:03:28.45764
4	31	acceptee	SMAIL YASSINE	\N	\N	\N	SMAIL YASSINE	2026-07-28 01:04:38.880695
5	31	en_route	SMAIL YASSINE	\N	\N	\N	SMAIL YASSINE	2026-07-28 01:04:53.500058
6	31	arrive	SMAIL YASSINE	\N	\N	\N	SMAIL YASSINE	2026-07-28 01:04:59.188886
7	31	mission_en_cours	SMAIL YASSINE	\N	\N	\N	SMAIL YASSINE	2026-07-28 01:05:20.12949
8	31	terminee	SMAIL YASSINE	\N	\N	\N	SMAIL YASSINE	2026-07-28 01:05:39.379496
9	31	retour	SMAIL YASSINE	\N	\N	\N	SMAIL YASSINE	2026-07-28 01:05:44.808758
10	31	arrive_siege	SMAIL YASSINE	\N	\N	\N	SMAIL YASSINE	2026-07-28 01:06:06.188488
11	31	cloturee	\N	\N	\N	\N	ELHAIMER AMINE	2026-07-28 01:07:35.211876
12	32	en_attente_acceptation	Assigné automatiquement lors de la création.	\N	\N	\N	ELHAIMER AMINE	2026-07-28 01:43:58.659835
13	32	annule	\N	\N	\N	\N	ELHAIMER AMINE	2026-07-28 01:45:08.49992
14	33	en_attente_acceptation	Assigné automatiquement lors de la création.	\N	\N	\N	ELHAIMER AMINE	2026-07-28 01:46:31.753012
15	33	acceptee	SMAIL YASSINE	\N	\N	\N	SMAIL YASSINE	2026-07-28 01:47:17.077214
16	33	en_route	SMAIL YASSINE	\N	\N	\N	SMAIL YASSINE	2026-07-28 01:47:51.600222
17	33	arrive	SMAIL YASSINE	\N	\N	\N	SMAIL YASSINE	2026-07-28 01:48:05.437904
18	33	mission_en_cours	SMAIL YASSINE	\N	\N	\N	SMAIL YASSINE	2026-07-28 01:48:22.827286
19	33	terminee	SMAIL YASSINE	\N	\N	\N	SMAIL YASSINE	2026-07-28 01:48:32.259001
20	33	retour	SMAIL YASSINE	\N	\N	\N	SMAIL YASSINE	2026-07-28 01:48:34.857824
21	33	arrive_siege	SMAIL YASSINE	\N	\N	\N	SMAIL YASSINE	2026-07-28 01:48:44.477975
22	33	cloturee	\N	\N	\N	\N	ELHAIMER AMINE	2026-07-28 01:49:20.102127
23	34	en_attente_acceptation	Assigné automatiquement lors de la création.	\N	\N	\N	ELHAIMER AMINE	2026-07-28 02:12:36.606039
24	34	acceptee	SMAIL YASSINE	\N	\N	\N	SMAIL YASSINE	2026-07-28 02:12:51.081508
\.


--
-- Data for Name: deplacement_gps_points; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.deplacement_gps_points (id, deplacement_id, latitude, longitude, vitesse, "precision", cap, created_at) FROM stdin;
\.


--
-- Data for Name: deplacement_passagers; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.deplacement_passagers (id, deplacement_id, nom, service, created_at, service_id) FROM stdin;
1	4	ELHAIMER	LOGISTIQUE	2026-07-25 01:03:26.398735	\N
2	5	AYMANE	ACHAT	2026-07-25 01:06:31.741375	\N
3	6	AYMANE	ACHAT	2026-07-26 00:43:34.534708	\N
4	7	aymane	achat	2026-07-26 01:09:18.975287	\N
5	8	AYMANE ELKHOMSI	ACHAT	2026-07-26 01:42:59.71709	\N
6	9	AYMANE ELKHOMSI	ARCHEVE	2026-07-26 01:58:16.671942	\N
7	10	AYMANE	ARCHEVE	2026-07-26 02:14:17.361574	\N
8	11	ELHAIMER	LOGISTIQUE	2026-07-26 02:28:02.036109	\N
9	12	AMINE	ACHAT	2026-07-26 02:33:57.502001	\N
10	13	AMINE	ACHAT	2026-07-26 11:28:40.120769	\N
11	14	AMINE	ACHAT	2026-07-26 11:58:13.47647	\N
12	15	AMINE	LOGISTIQUE	2026-07-26 15:36:42.688993	\N
13	16	AMINE	ACHAT	2026-07-26 16:14:15.71043	\N
14	17	AYMANE	ARCHEVE	2026-07-26 16:40:22.704811	\N
15	18	AMINE	ACHAT	2026-07-26 16:47:47.29819	\N
16	19	AYMANE	ARCHEVE	2026-07-26 17:08:05.864217	\N
17	20	amine	achat	2026-07-27 00:57:21.074862	\N
18	21	AMINE	ACHAT	2026-07-27 01:24:42.962503	\N
19	23	amine	\N	2026-07-27 02:53:21.663279	28
20	24	AMINE	\N	2026-07-27 10:20:58.518374	28
21	25	amine	\N	2026-07-27 13:30:28.030699	3
22	26	AMINE	\N	2026-07-27 13:39:09.882566	32
23	27	amine	\N	2026-07-27 13:59:18.251774	14
24	28	AMINE	\N	2026-07-27 14:36:58.97423	60
25	29	AYMANE 	\N	2026-07-27 14:43:06.569019	36
26	30	AMINE	\N	2026-07-28 00:09:44.418944	22
27	31	AMINE	\N	2026-07-28 01:03:28.436506	28
28	32	amine	\N	2026-07-28 01:43:58.633294	3
29	33	amine	\N	2026-07-28 01:46:31.743754	37
30	34	AMINE	\N	2026-07-28 02:12:36.589833	23
\.


--
-- Data for Name: deplacement_photos; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.deplacement_photos (id, deplacement_id, type, filename, original_name, mime_type, size_bytes, uploaded_by, created_at) FROM stdin;
\.


--
-- Data for Name: deplacements; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.deplacements (id, numero, vehicule_id, chauffeur_id, demande_id, service_demandeur_id, objet, destination, date_depart, date_retour_prevue, date_retour_effective, kilometrage_depart, kilometrage_retour, rapport_mission, created_by, deleted_at, deleted_by, created_at, updated_at, depart_reel_at, arrivee_at, depart_retour_at, retour_reel_at, depart_lat, depart_lng, arrivee_lat, arrivee_lng, depart_retour_lat, depart_retour_lng, retour_lat, retour_lng, heure_depart, observations, statut, heure_depart_prevue, heure_depart_reelle, heure_arrivee_reelle, heure_retour_reelle, heure_cloture, date_depart_reelle, date_arrivee_reelle, date_retour_reelle, date_cloture, accepted_at, accepted_by, signature_chauffeur, signature_responsable, duree_mission, distance_km, consommation_carburant, observations_chauffeur, notes_cloture, itineraire) FROM stdin;
17	OM-2026-0017	4	13	\N	17	VISITE	AGADIR	26/07/2026	29/07/2026	\N	\N	\N	\N	ELHAIMER AMINE	2026-07-28 00:50:30.697	ELHAIMER AMINE	2026-07-26 16:40:22.634094	2026-07-26 15:45:12.261	2026-07-26 15:42:56.111	2026-07-26 15:45:07.542	2026-07-26 15:45:09.45	2026-07-26 15:45:12.261	\N	\N	\N	\N	\N	\N	\N	\N	16:40	\N	cloturee	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
34	OM-2026-0034	4	24	\N	2	CONTROLE	AGADIR	28/07/2026	31/07/2026	\N	\N	\N	\N	ELHAIMER AMINE	\N	\N	2026-07-28 02:12:36.533029	2026-07-28 01:12:51.077	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	acceptee	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-28 01:12:51.077	SMAIL YASSINE	\N	\N	\N	\N	\N	\N	\N	\N
16	OM-2026-0016	4	13	\N	56	VISITE	AGADIR	26/07/2026	31/07/2026	\N	\N	\N	\N	ELHAIMER AMINE	2026-07-26 15:39:10.05	ELHAIMER AMINE	2026-07-26 16:14:15.698817	2026-07-26 15:36:48.363	2026-07-26 15:15:03.585	2026-07-26 15:36:34.436	2026-07-26 15:36:36.77	2026-07-26 15:36:48.363	\N	\N	\N	\N	\N	\N	\N	\N	16:14	\N	cloturee	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
15	OM-2026-0015	4	13	\N	17	VISITE	FES	26/07/2026	30/07/2026	\N	\N	\N	\N	ELHAIMER AMINE	2026-07-26 15:39:11.956	ELHAIMER AMINE	2026-07-26 15:36:42.67679	2026-07-26 15:36:45.087	2026-07-26 14:37:24.869	2026-07-26 15:36:39.649	2026-07-26 15:36:41.925	2026-07-26 15:36:45.087	\N	\N	\N	\N	\N	\N	\N	\N	15:36	\N	cloturee	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
14	OM-2026-0014	4	13	\N	2	listen	agadir	26/07/2026	26/07/2026	\N	\N	\N	\N	ELHAIMER AMINE	2026-07-26 15:39:14.011	ELHAIMER AMINE	2026-07-26 11:58:13.473286	2026-07-26 10:59:47.539	2026-07-26 10:58:45.363	2026-07-26 10:59:31.976	2026-07-26 10:59:37.7	2026-07-26 10:59:47.539	\N	\N	\N	\N	\N	\N	\N	\N	13:59	\N	cloturee	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
13	OM-2026-0013	4	13	\N	57	VOIRE	FES	26/07/2026	31/07/2026	\N	\N	\N	\N	ELHAIMER AMINE	2026-07-26 15:39:15.728	ELHAIMER AMINE	2026-07-26 11:28:40.116233	2026-07-26 10:50:48.473	2026-07-26 10:29:14.738	2026-07-26 10:50:40.838	2026-07-26 10:50:44.567	2026-07-26 10:50:48.473	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	cloturee	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
12	OM-2026-0012	4	13	\N	2	TEST	AGADIR	26/07/2026	05/08/2026	\N	\N	\N	\N	ELHAIMER AMINE	2026-07-26 15:39:17.394	ELHAIMER AMINE	2026-07-26 02:33:57.489498	2026-07-26 01:34:59.983	2026-07-26 01:34:42.775	2026-07-26 01:34:53.962	2026-07-26 01:34:57.216	2026-07-26 01:34:59.983	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	cloturee	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
3	OM-2026-0003	1	3	\N	24	VISITE	AGDAL RABAT	24/07/2026	28/07/2026	\N	20000	\N	\N	ELHAIMER AMINE	2026-07-25 00:01:48.435	ELHAIMER AMINE	2026-07-24 11:49:16.049908	2026-07-24 10:49:38.888	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	cloturee	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
2	OM-2026-0002	1	7	\N	1	VISITE	AGADIR	24/07/2026	\N	\N	\N	\N	\N	ELHAIMER AMINE	2026-07-25 00:01:50.719	ELHAIMER AMINE	2026-07-24 09:20:39.781323	2026-07-24 08:20:52.564	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	annule	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
1	OM-2026-0001	1	3	\N	33	VISITE ET CONTROLE	FES	24/07/2026	25/07/2026	\N	20000	\N	\N	ELHAIMER AMINE	2026-07-25 00:01:53.651	ELHAIMER AMINE	2026-07-24 09:18:27.64103	2026-07-24 08:20:48.795	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	cloturee	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
11	OM-2026-0011	4	13	\N	57	controle	FES	26/07/2026	31/07/2026	\N	\N	\N	\N	ELHAIMER AMINE	2026-07-26 15:39:19.205	ELHAIMER AMINE	2026-07-26 02:28:02.022929	2026-07-26 01:33:04.787	2026-07-26 01:28:31.347	2026-07-26 01:32:59.681	2026-07-26 01:33:01.96	2026-07-26 01:33:04.787	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	cloturee	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
10	OM-2026-0010	4	13	\N	24	CONTROLE	AGADIR	26/07/2026	31/07/2026	\N	\N	\N	\N	ELHAIMER AMINE	2026-07-26 15:39:21.107	ELHAIMER AMINE	2026-07-26 02:14:17.349826	2026-07-26 01:25:17.573	2026-07-26 01:15:01.763	2026-07-26 01:25:11.692	2026-07-26 01:25:14.549	2026-07-26 01:25:17.573	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	cloturee	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
7	OM-2026-0007	1	8	\N	23	controle	agadir	26/07/2026	30/07/2026	\N	\N	\N	\N	ELHAIMER AMINE	2026-07-26 00:19:45.467	ELHAIMER AMINE	2026-07-26 01:09:18.971064	2026-07-26 00:09:50.482	2026-07-26 00:09:50.482	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	creee	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
6	OM-2026-0006	1	7	\N	36	visite local	AGADIR	26/07/2026	28/07/2026	\N	\N	\N	\N	ELHAIMER AMINE	2026-07-26 00:19:47.27	ELHAIMER AMINE	2026-07-26 00:43:34.529543	2026-07-25 23:49:26.686	2026-07-25 23:44:06.157	2026-07-25 23:49:08.119	2026-07-25 23:49:20.871	2026-07-25 23:49:26.686	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	cloturee	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
5	OM-2026-0005	1	1	\N	17	visite	FES	25/07/2026	27/07/2026	\N	21000	\N	\N	ELHAIMER AMINE	2026-07-26 00:19:49.091	ELHAIMER AMINE	2026-07-25 01:06:31.731224	2026-07-25 23:38:48.204	\N	\N	\N	2026-07-25 23:38:48.204	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	cloturee	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
4	OM-2026-0004	1	1	\N	1	VISITE LOCAL	AGADIR	25/07/2026	27/07/2026	\N	20000	21000	FAIT	ELHAIMER AMINE	2026-07-26 00:19:51.128	ELHAIMER AMINE	2026-07-25 01:03:26.392961	2026-07-25 00:04:07.521	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	cloturee	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
8	OM-2026-0008	2	11	\N	36	visite	AGADIR	26/07/2026	29/07/2026	\N	\N	\N	\N	ELHAIMER AMINE	2026-07-26 00:54:59.22	ELHAIMER AMINE	2026-07-26 01:42:59.701174	2026-07-26 00:44:31.601	2026-07-26 00:44:31.601	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	creee	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
9	OM-2026-0009	3	12	\N	2	VISITE	AGADIR	26/07/2026	29/07/2026	\N	\N	\N	\N	ELHAIMER AMINE	2026-07-26 01:11:27.486	ELHAIMER AMINE	2026-07-26 01:58:16.660028	2026-07-26 00:58:47.341	2026-07-26 00:58:47.341	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	creee	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
26	OM-2026-0026	4	23	\N	2	VISITE	RABAT	27/07/2026	28/07/2026	\N	\N	\N	\N	ELHAIMER AMINE	2026-07-28 00:50:29.346	ELHAIMER AMINE	2026-07-27 13:39:09.872061	2026-07-27 12:55:42.594	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	annule	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
24	OM-2026-0024	4	16	\N	41	VISTE	AGADIR	27/07/2026	30/07/2026	\N	\N	\N	\N	ELHAIMER AMINE	2026-07-28 00:50:29.515	ELHAIMER AMINE	2026-07-27 10:20:58.510494	2026-07-27 10:20:58.510494	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	creee	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
29	OM-2026-0029	4	24	\N	36	VISTE	LAAYOUNE	27/07/2026	31/07/2026	\N	\N	20000	Fait	ELHAIMER AMINE	2026-07-28 00:50:29.781	ELHAIMER AMINE	2026-07-27 14:43:06.553649	2026-07-27 13:43:57.484	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	cloturee	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
25	OM-2026-0025	4	21	\N	56	visite	rabat	27/07/2026	28/07/2026	\N	20000	\N	\N	ELHAIMER AMINE	2026-07-28 00:50:29.832	ELHAIMER AMINE	2026-07-27 13:30:27.978539	2026-07-27 12:32:01.274	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	cloturee	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
23	OM-2026-0023	4	18	\N	2	controle	rabat	27/07/2026	31/07/2026	\N	20000	\N	\N	ELHAIMER AMINE	2026-07-28 00:50:29.874	ELHAIMER AMINE	2026-07-27 02:53:21.651612	2026-07-27 01:54:26.233	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	cloturee	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
27	OM-2026-0027	4	23	\N	1	visite	rabat	27/07/2026	28/07/2026	\N	20000	\N	\N	ELHAIMER AMINE	2026-07-28 00:50:29.963	ELHAIMER AMINE	2026-07-27 13:59:18.234381	2026-07-27 13:00:53.728	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	cloturee	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
30	OM-2026-0030	4	23	\N	2	CONTROLE TOTAL	KHOURIBGA	28/07/2026	30/07/2026	\N	\N	\N	\N	ELHAIMER AMINE	2026-07-28 00:50:30.107	ELHAIMER AMINE	2026-07-28 00:09:44.351953	2026-07-28 00:02:50.706	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	annule	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
28	OM-2026-0028	4	24	\N	2	test	test	27/07/2026	30/07/2026	\N	\N	21000	TEST	ELHAIMER AMINE	2026-07-28 00:50:30.134	ELHAIMER AMINE	2026-07-27 14:36:58.961326	2026-07-27 13:38:09.925	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	cloturee	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
22	OM-2026-0022	4	16	\N	41	VISITE	AGADIR	27/07/2026	29/07/2026	\N	\N	\N	\N	ELHAIMER AMINE	2026-07-28 00:50:30.158	ELHAIMER AMINE	2026-07-27 02:47:18.137512	2026-07-27 02:47:18.137512	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	creee	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
21	OM-2026-0021	4	16	\N	2	VISITE	RABAT	27/07/2026	30/07/2026	\N	\N	\N	\N	ELHAIMER AMINE	2026-07-28 00:50:30.299	ELHAIMER AMINE	2026-07-27 01:24:42.950522	2026-07-27 00:25:24.87	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	01:24	\N	creee	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
20	OM-2026-0020	4	13	\N	1	controle	rabat	27/07/2026	30/07/2026	\N	\N	\N	\N	ELHAIMER AMINE	2026-07-28 00:50:30.582	ELHAIMER AMINE	2026-07-27 00:57:21.013599	2026-07-26 23:59:09.647	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	00:57	\N	annule	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
18	OM-2026-0018	4	14	\N	37	CONTROLE	RABAT	26/07/2026	30/07/2026	\N	\N	\N	\N	ELHAIMER AMINE	2026-07-28 00:50:30.609	ELHAIMER AMINE	2026-07-26 16:47:47.284935	2026-07-26 16:06:46.586	2026-07-26 15:49:17.139	2026-07-26 16:06:41.91	2026-07-26 16:06:44.085	2026-07-26 16:06:46.586	\N	\N	\N	\N	\N	\N	\N	\N	16:47	\N	cloturee	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
19	OM-2026-0019	4	14	\N	2	VISITE	AGADIR	26/07/2026	31/07/2026	\N	\N	\N	\N	ELHAIMER AMINE	2026-07-28 00:50:30.632	ELHAIMER AMINE	2026-07-26 17:08:05.85807	2026-07-26 23:59:05.554	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17:07	\N	annule	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
32	OM-2026-0032	4	23	\N	2	test	test	28/07/2026	30/07/2026	\N	\N	\N	\N	ELHAIMER AMINE	2026-07-28 00:49:49.265	ELHAIMER AMINE	2026-07-28 01:43:58.615981	2026-07-28 00:45:08.482	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	annule	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
33	OM-2026-0033	4	24	\N	2	test	test	28/07/2026	30/07/2026	\N	30000	40000	\N	ELHAIMER AMINE	2026-07-28 00:49:49.322	ELHAIMER AMINE	2026-07-28 01:46:31.731042	2026-07-28 00:49:20.086	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	cloturee	\N	2026-07-28 00:47:51.589	2026-07-28 00:48:05.434	2026-07-28 00:48:32.256	2026-07-28 00:49:20.086	28/07/2026	28/07/2026	28/07/2026	2026-07-28 00:49:20.086	2026-07-28 00:47:17.066	SMAIL YASSINE	\N	\N	1	\N	\N	35000	\N	\N
31	OM-2026-0031	4	24	\N	2	TEST	TEST	28/07/2026	30/07/2026	\N	20000	22000	\N	ELHAIMER AMINE	2026-07-28 00:49:49.336	ELHAIMER AMINE	2026-07-28 01:03:28.377541	2026-07-28 00:07:35.196	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	cloturee	\N	2026-07-28 00:04:53.495	2026-07-28 00:04:59.178	2026-07-28 00:05:39.368	2026-07-28 00:07:35.196	28/07/2026	28/07/2026	28/07/2026	2026-07-28 00:07:35.196	2026-07-28 00:04:38.876	SMAIL YASSINE	data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUAAAACgCAYAAAB9o7WcAAAOLUlEQVR4Aeydeaw21xzHH0pLaTW0aEVVLU0tpWqtPUGKovFfU42oEIml9gQVhMbWpGqJiDWNP/oPtb0EkSgaS6ggpEFTRdo37fuilNq6fL9z5/Q973Pvfe4zzzNnzpk5n5vfb86ZeWbO+Z3PmfvNLGdmbj/jDwIQgEClBBDASjueZkMAArMZAsheAAEIVEugagGsttdpOAQg0BBAABsMTCAAgRoJIIA19jpthgAEGgIIYIOhwglNhgAEuAnCPgABCNRLgCPAevuelkOgegIIYPW7QI0AaDMENggggBscmEIAAhUSQAAr7HSaDAEIbBBAADc4MIVALQRoZ0QAAYxgkIUABOoigADW1d+0FgIQiAgggBEMshCAwLQJzLcOAZwnwjwEIFANAQSwmq6moRCAwDwBBHCeCPMQgEA1BKoSwGp6lYZCAAJLEUAAl8LEShCAwBQJIIBT7FXaBAEILEUAAVwK0wRWogkQgMAmAgjgJiQsgAAEaiGAANbS07QTAhDYRAAB3ISEBdMjQIsgsDUBBHBrLiyFAAQqIIAAVtDJhTXxFsUTXFkMAvkIIID52FPzbHYzEJIToIIFBBDABXD4KTmB26mGK+UYBLIQQACzYKfSiMAxyrMfCgI2PAF2vOGZU+MGAR/9beRms5uUOUiOQaBXAjsVhgDuRIjfUxK4Jir838rfRY5BYDACCOBgqKloCwJHadleebAblDlMjkFgEAII4CCYqWQBgcP1W3wk+FfNHyHHIJCcwKQFMDk9KuiLgI8Efx8Vdq3yR8oxCCQlgAAmxUvhHQg8SOteJg92tTJHyzEIJCOAACZDS8ErEDhJ23xTHuwqZY6VYxBIQgABTIK1gELHG8IpCv2z8mBXKHOcHINA7wQQwN6RUmAPBM5SGW+VB7tcmRfIMQj0SgAB7BUnhfVI4L0q61R5sC8pc7Ecg0BvBBDA3lBSUAICu1Rm/MTIaZqP7xZrditjGQSWI4AALseJtfISiEXwAQrlejkGgbUJIIBrI6SAgQjEInio6vyPHIPAWgQQwLXwsfHABGIRPFB1+yUKSrCIANkOBBDADrBYtQgCFkG/UdrBeP/lpaomga9EwDvQShuyEQQyEvB+G4QvFsSMIVH1GAl4Rxpj3MQMgQOE4P/yYOGoMMyTVkiga5MRwK7EWL8kAndUMP+SB7MI+u0yYZ4UAgsJIIAL8fDjCAj4Jap7ojivU/48OQaBHQkggDsiYoUREPD7A/24XAj1Dcr8VI5BYCGBSQngwpby49QJHK8Gfk0ezG+WYaxgoEG6JQEEcEssLBwpgecp7jfLg3msoK8LxsvCb6QQmCGA7ARTI/BBNWh+aMz7tcwfXVKCQWAfAQRwH4tx54h+noD37d3RwoOU99HgG5ViEGgIeCdpMkwgMEEC/q7I/NGgjxA5GpxgZ6/SJARwFWpsMzYC3s/9tbkQdzga9N3isIy0QgLeMSpsNk2eFoGlWnN3rXWwPDaPF+RoMCZSWR4BrKzDK2/ujWq/T4lvUBosHA2+NiwgrYcAAlhPX9PSfQQOUdYfX1Jym52v3LfkWEUEEMCKOpum7kfAn9/00WB8CvxMrTG2jy8pZGxVAgjgquTYbioE7qyGXCkP5o8vhTzpxAkggBPvYJq3FIFjtdY/5cE8XjDkSSdMAAGccOfStE4E7qq1eb+gIIzJ1o0VAVyXINtPiYDfLxgf/cX5KbWTtrQEEMAWBAkEWgLz/xPh1fvtzyRTIjDf2VNqG22BwKoEfHc4bOt8fKc4LCedAIFRC+AE+NOEcglY+EJ0Hiwd3ykOy0lHTgABHHkHEn5SArEIHqOaPiDHJkQAAZxQZ9KUJAT8zZFQ8JuUebEcmwgBBHCsHUncQxHwV+eOjir7nPKXyrEJEEAAJ9CJNCE5gT+phvh0+GTN75UPYY9SJe+UYwkIIIAJoFLkZAnEIujXa/03YUtfqLJ/LP+Z/B1yRFAQ+jYEsG+ilDcAgaxVxCI4P3C6j8A+rEKukX9B/li57euafEyO9UwAAewZKMVVQcAiGA+QXueJkTNF7EdyP4vscl6t/L3ltqs1eYv8ufLr5FjPBBDAnoFSXDUEDlBLfYNESWMWrw81ucUTX9P7ilbxNUSL6IXKP04e3lbtbxlfovmny+8jf58cS0QAAUwElmKrIOAhMr+NWnq28i+Vx2YRu0ALrpD7mqGv6fn7xb6G6CNJLZ7dpMkf5O+R30n+NPl35VsZy3okgAD2CJOiqiRwnFpt4VLS2Kea6Wx22mw2u1buO8ivUepXbvmaobIzHy3+XZnvyB8tv4P8/vK3y7EBCSCAA8KmqskSsHB9MWqdBe5izR8hD0d5PrW9XPPnyv1/dzelz5D7iFAJloOAOyJHvdQJgakRuH6bBu3Rcg9p8ant8cqfI8dWJND3Zghg30QprzYC/rbI/9Tol8jn7cFa4KNAHw0qi5VGAAEsrUeIZywELlOgvnnxLKW+hqekubb3Z2da/0WbkhRKAAEstGMIq0gC91VUfi2Wh6+cqHz4//H8D9t5r7NbeZs/uPR5Z/AyCYQOLDO6uaiYhUAmAi9XvR6I/Eelfi1WuLHhb4h8Vcs8JtDPByvb2JGa+kaIktkZnuBlEkAAy+wXoiqDwC6F4et7n1B6uDyY3xDtZR7W8vywcC6N/7d8B3juZ2ZLIBB3UgnxEAMEchM4UAFcJfdp7XOUhut7ys7+oYkfTfOp7SuU38l+3a7gMr/d5kkKIoAAFtQZC0Phx9QE3q0K/Dyuj9b8/r9wmqvFMw9xOV2ZQ+VdHk17mNb3abKSmcf8OcULIoAAFtQZhJKFgG9e+G6ux+eF53EdiK/h/UYZC+FhSi+Sr2I+TQ7b3RgypGUQQADL6AeiGJbAY1SdH1OzyD1e+fj/wM/r+nE2L3uofuvDvtEW4sHQId8uIslJwJ2cs37qhsASBHpb5dMqyTcwfqLUA5SV3Ga+y/sIzfkLcC9T2qf5WqLrdZmneIKXQQABLKMfiCItAd+M8E2Ns1SNBU5JY17md/H5NPeeWvJLeSrzjZNQNqfCgUTmFAHM3AFUn4zAq1Ty3+Q+zX2IUoucksYsQH7FvMfvPaFZMswknP76VNhveR6mVmrZlgACuC0afhgpgUcqbt/J/YhSv3FFSWMWQg9kthD6Zse7mqXDTuJT4WcvWTWrJSSAACaES9GDE/A79n6uWj3uTkljHobioy3v6/drluSdcCqcl/9+tXun2G8BMxAYIQF/O8NHeIdEsXtoi09zPQzF39SIfsqejU+F/Shd9oBqDQABrLXnp9Fu37Sw8PnZ29Aiz1tU/ARHjtPcEMeiND4VPnXRirX/lrr9CGBqwpSfgsCXVajv4D5caWy/0oz36e2ez9XPxRinwgV0hXeWAsIgBAgsRcDf3vA1PQucb2aEjfwdXc+fEBaMJPXLVB2q7wr7qNV5fEACCOCAsKlqZQK/05Y+4nubUg9dUdKYX05g4TuqmRvfxIOiwwBpToUz9F/RApiBB1WWR8DX9B6osCx0Shrz42onKeeXEygZtflU2G10Izx8xyk+EAEEcCDQVNMLAQ9zOVMl+WkOv5Je2UnY69pWePiOn1FuZ0lSE0AAUxOm/HUJ+MgvuAc2T/EV8xcI0g/kNj+jfIkzeHoCCGB6xqvVwFa1EXiyGrxHbnuKJmfLscQEEMDEgCkeAh0I+OjPr+D3Jud7gqclgACm5UvpEOhKwNcBfVPEp/3cFOlKr+P6CGBHYKw+BIHq63hlS8BiyE2RFkaKBAFMQZUyIbAegY9r8+/JbT4t/r4zeP8EEMD+mVIiBPog8FQV4rdUK5k9SZPXy7GeCSCAPQOlOAisSSDe3G+p9qBvLzvPE7xfAghgvzwpDQJ9E/Cgbz8G6Jsiu/suvPbyEMDa9wDaPwYCH22DvJfSC+VYTwQQwJ5AUgwEEhLwoOhw9Pci1RO/EEKz07GhW4IADk2c+nwqZ4dENwJ+6Ws4Fd7bbVPW3o4AArgdGZZDoDwCn2lD8jPRu9o8yRoEEMA14LEpBAYm4A+2h4HRfq2+v4A3cAjTqq4oAZwWWloDgSQEfCPEp8Iu/FJP8NUJIICrs2NLCOQicFFb8cFKEUFBWNUQwFXJsR0E8hE4Q1X/RW47WZMT5dgKBBDAFaAl2YRCIdCNwD2i1c+N8mQ7EEAAO8BiVQgURiDcEHliYXGNJhwEcDRdRaAQ2ETgk+0Sfxzq9DZP0oEAAtgBFqumIkC5KxI4R9uFJ0T8XRHNYl0IIIBdaLEuBMojcEIbkt8b2GZJliWAAC5LivUgUCYBvzPQjxbay4yw4KgQwII7h9CqIEAjMxJAADPCp2oIQCAvAQQwL39qhwAEMhJAADPCp2oI1E4gd/sRwNw9QP0QgEA2AghgNvRUDAEI5CaAAObuAeqHAASyEcgqgNlaTcUQgAAERAABFAQMAhCokwACWGe/02oIQEAEEEBByGJUCgEIZCeAAGbvAgKAAARyEUAAc5GnXghAIDsBBDB7F9QYAG2GQBkEEMAy+oEoIACBDAQQwAzQqRICECiDAAJYRj8QRT0EaGlBBBDAgjqDUCAAgWEJIIDD8qY2CECgIAIIYEGdQSgQmDqB0tqHAJbWI8QDAQgMRgABHAw1FUEAAqURQABL6xHigQAEBiMwqAAO1ioqggAEILAEAQRwCUisAgEITJMAAjjNfqVVEIDAEgQQwCUg9bIKhUAAAsURQACL6xICggAEhiKAAA5FmnogAIHiCCCAxXXJFAOiTRAokwACWGa/EBUEIDAAAQRwAMhUAQEIlEkAASyzX4hqOgRoScEEEMCCO4fQIACBtAQQwLR8KR0CECiYAAJYcOcQGgTGTqD0+G8FAAD//7rx+VAAAAAGSURBVAMAcB0WUL5QH/IAAAAASUVORK5CYII=	\N	1	\N	\N	21000	\N	\N
\.


--
-- Data for Name: email_logs; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.email_logs (id, to_address, subject, kind, related_id, success, error, sent_by, created_at) FROM stdin;
1	el.amyne@gmail.com	Test — Plateforme IAM	test	\N	f	Invalid login: 535-5.7.8 Username and Password not accepted. For more information, go to\n535 5.7.8  https://support.google.com/mail/?p=BadCredentials 5b1f17b1804b1-4955a9e5f26sm82020065e9.0 - gsmtp	ELHAIMER AMINE	2026-07-20 11:14:01.581901
2	el.amyne@gmail.com	Test — Plateforme IAM	test	\N	f	Invalid login: 535-5.7.8 Username and Password not accepted. For more information, go to\n535 5.7.8  https://support.google.com/mail/?p=BadCredentials ffacd0b85a97d-47f63e496ffsm28148662f8f.3 - gsmtp	ELHAIMER AMINE	2026-07-20 11:14:23.701636
3	el.amyne@gmail.com	Test — Plateforme IAM	test	\N	f	Invalid login: 535-5.7.8 Username and Password not accepted. For more information, go to\n535 5.7.8  https://support.google.com/mail/?p=BadCredentials 5b1f17b1804b1-49565dbc288sm13078935e9.4 - gsmtp	ELHAIMER AMINE	2026-07-21 01:18:08.233126
4	el.amyne@gmail.com	Facture IAM 0000863579102024	facture	515	f	Invalid login: 535-5.7.8 Username and Password not accepted. For more information, go to\n535 5.7.8  https://support.google.com/mail/?p=BadCredentials ffacd0b85a97d-47f6b85970esm27741050f8f.15 - gsmtp	ELHAIMER AMINE	2026-07-21 01:44:07.790279
5	el.amyne@gmail.com	Test — Plateforme IAM	test	\N	f	Invalid login: 535-5.7.8 Username and Password not accepted. For more information, go to\n535 5.7.8  https://support.google.com/mail/?p=BadCredentials ffacd0b85a97d-47f67466e09sm41299046f8f.21 - gsmtp	ELHAIMER AMINE	2026-07-21 11:51:21.667294
38	el.amyne@gmail.com	Test — Plateforme IAM	test	\N	f	Invalid login: 535-5.7.8 Username and Password not accepted. For more information, go to\n535 5.7.8  https://support.google.com/mail/?p=BadCredentials ffacd0b85a97d-47f85c52fc0sm6384097f8f.23 - gsmtp	ELHAIMER AMINE	2026-07-22 15:45:53.326133
39	el.amyne@gmail.com	Test — Plateforme IAM	test	\N	f	Invalid login: 535-5.7.8 Username and Password not accepted. For more information, go to\n535 5.7.8  https://support.google.com/mail/?p=BadCredentials ffacd0b85a97d-47f85b9a659sm14904685f8f.6 - gsmtp	ELHAIMER AMINE	2026-07-23 11:12:52.978201
40	el.amyne@gmail.com	Test — Plateforme IAM	test	\N	f	Invalid login: 535-5.7.8 Username and Password not accepted. For more information, go to\n535 5.7.8  https://support.google.com/mail/?p=BadCredentials 5b1f17b1804b1-4956ab22e74sm122283405e9.1 - gsmtp	ELHAIMER AMINE	2026-07-23 11:31:41.255584
41	el.amyne@gmail.com	Test — Plateforme IAM	test	\N	f	Invalid login: 535-5.7.8 Username and Password not accepted. For more information, go to\n535 5.7.8  https://support.google.com/mail/?p=BadCredentials 5b1f17b1804b1-495653c9d99sm214353835e9.12 - gsmtp	ELHAIMER AMINE	2026-07-23 11:34:07.436021
42	el.amyne@gmail.com	Test — Plateforme IAM	test	\N	t	\N	ELHAIMER AMINE	2026-07-23 11:34:56.129897
43	el.amyne@gmail.com	Test — Plateforme IAM	test	\N	t	\N	ELHAIMER AMINE	2026-07-23 11:41:25.089444
44	el.amyne@gmail.com	Test — Plateforme IAM	test	\N	t	\N	ELHAIMER AMINE	2026-07-23 12:24:41.968051
45	el.amyne@gmail.com	Facture IAM 0000863579102024	facture	515	t	\N	ELHAIMER AMINE	2026-07-23 12:28:20.743971
46	el.amyne@gmail.com	Facture IAM 0001674762082024	facture	524	t	\N	ELHAIMER AMINE	2026-07-23 15:02:19.117728
47	el.amyne@gmail.com	Test — Plateforme IAM	test	\N	t	\N	ELHAIMER AMINE	2026-07-24 01:26:22.411333
48	el.amyne@gmail.com	Test — Plateforme IAM	test	\N	t	\N	ELHAIMER AMINE	2026-07-24 09:11:30.012985
49	damilo1991@gmail.com	Test — Plateforme IAM	test	\N	t	\N	ELHAIMER AMINE	2026-07-24 11:50:52.20181
50	el.amyne@gmail.com	Test — Plateforme IAM	test	\N	t	\N	ELHAIMER AMINE	2026-07-27 01:05:52.654462
\.


--
-- Data for Name: factures; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.factures (id, custcode, nd, nom, ref_facture, montant, mois, echeance, produit, statut, source_sheet, coordination_regionale, delegation, domiciliation, deleted_at, deleted_by, created_at, updated_at) FROM stdin;
1	5.53231.00.00.100165	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076389022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
2	5.53231.00.00.100165	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007104032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
3	5.53231.00.00.100165	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836754042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
4	5.53231.00.00.100165	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824323052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
5	5.53231.00.00.100165	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560988062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
6	5.53231.00.00.100165	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916596072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
7	5.53231.00.00.100165	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674798082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
8	5.53231.00.00.100165	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543956092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
9	5.53231.00.00.100165	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863611102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
10	5.53231.00.00.100165	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626465112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
11	5.53231.00.00.100165	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694301122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
12	5.53231.00.00.100164	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076388022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
13	5.53231.00.00.100164	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007103032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
14	5.53231.00.00.100164	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836753042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
15	5.53231.00.00.100164	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824322052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
16	5.53231.00.00.100164	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560987062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
17	5.53231.00.00.100164	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916595072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
18	5.53231.00.00.100164	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674797082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
19	5.53231.00.00.100164	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543955092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
20	5.53231.00.00.100164	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863610102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
21	5.53231.00.00.100164	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626464112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
22	5.53231.00.00.100164	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694300122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
23	5.53231.00.00.100174	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076393022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
24	5.53231.00.00.100174	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007108032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
25	5.53231.00.00.100174	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836758042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
26	5.53231.00.00.100174	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824327052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
27	5.53231.00.00.100174	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560992062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
28	5.53231.00.00.100174	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916600072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
29	5.53231.00.00.100174	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674802082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
30	5.53231.00.00.100174	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543960092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
31	5.53231.00.00.100174	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863615102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
32	5.53231.00.00.100174	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626469112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
33	5.53231.00.00.100174	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694305122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
34	5.53231.00.00.100161	\N	ENTRAIDE  NATIONALE	0001076385022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
35	5.53231.00.00.100161	\N	ENTRAIDE  NATIONALE	0001007100032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
36	5.53231.00.00.100161	\N	ENTRAIDE  NATIONALE	0001836750042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
37	5.53231.00.00.100161	\N	ENTRAIDE  NATIONALE	0001824319052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
38	5.53231.00.00.100161	\N	ENTRAIDE  NATIONALE	0000560984062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
39	5.53231.00.00.100161	\N	ENTRAIDE  NATIONALE	0001916592072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
40	5.53231.00.00.100161	\N	ENTRAIDE  NATIONALE	0001674794082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
41	5.53231.00.00.100161	\N	ENTRAIDE  NATIONALE	0000543952092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
42	5.53231.00.00.100161	\N	ENTRAIDE  NATIONALE	0000863607102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
43	5.53231.00.00.100161	\N	ENTRAIDE  NATIONALE	0000626461112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
44	5.53231.00.00.100161	\N	ENTRAIDE  NATIONALE	0001694297122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
45	5.53231.00.00.100155	\N	ENTRAIDE  NATIONALE	0001076382022024	144	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
46	5.53231.00.00.100155	\N	ENTRAIDE  NATIONALE	0001007097032024	144	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
47	5.53231.00.00.100155	\N	ENTRAIDE  NATIONALE	0001836747042024	144	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
48	5.53231.00.00.100155	\N	ENTRAIDE  NATIONALE	0001824316052024	144	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
49	5.53231.00.00.100155	\N	ENTRAIDE  NATIONALE	0000560981062024	144	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
50	5.53231.00.00.100155	\N	ENTRAIDE  NATIONALE	0001916589072024	144	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
51	5.53231.00.00.100155	\N	ENTRAIDE  NATIONALE	0001674791082024	144	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
52	5.53231.00.00.100155	\N	ENTRAIDE  NATIONALE	0000543949092024	144	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
53	5.53231.00.00.100155	\N	ENTRAIDE  NATIONALE	0000863604102024	144	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
54	5.53231.00.00.100155	\N	ENTRAIDE  NATIONALE	0000626458112024	144	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
55	5.53231.00.00.100155	\N	ENTRAIDE  NATIONALE	0001694294122024	144	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
56	5.53231.00.00.100153	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076380022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
57	5.53231.00.00.100153	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007095032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
58	5.53231.00.00.100153	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836745042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
59	5.53231.00.00.100153	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824314052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
60	5.53231.00.00.100153	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560979062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
61	5.53231.00.00.100153	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916587072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
62	5.53231.00.00.100153	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674789082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
63	5.53231.00.00.100153	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543947092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
64	5.53231.00.00.100153	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863602102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
65	5.53231.00.00.100153	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626456112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
66	5.53231.00.00.100153	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694292122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
67	5.53231.00.00.100123	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076365022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
68	5.53231.00.00.100123	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007080032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
69	5.53231.00.00.100123	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836730042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
70	5.53231.00.00.100123	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824299052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
71	5.53231.00.00.100123	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560964062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
72	5.53231.00.00.100123	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916572072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
73	5.53231.00.00.100123	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674774082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
74	5.53231.00.00.100123	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543933092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
75	5.53231.00.00.100123	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863587102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
76	5.53231.00.00.100123	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626441112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
77	5.53231.00.00.100123	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694277122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
78	5.53231.00.00.100114	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076359022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
79	5.53231.00.00.100114	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007074032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
80	5.53231.00.00.100114	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836724042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
81	5.53231.00.00.100114	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824293052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
82	5.53231.00.00.100114	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560958062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
83	5.53231.00.00.100114	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916566072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
84	5.53231.00.00.100114	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674768082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
85	5.53231.00.00.100114	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543927092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
86	5.53231.00.00.100114	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863581102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
87	5.53231.00.00.100114	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626434112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
88	5.53231.00.00.100114	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694271122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
89	5.53231.00.00.100108	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076355022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
90	5.53231.00.00.100108	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007070032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
91	5.53231.00.00.100108	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836720042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
92	5.53231.00.00.100108	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824289052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
93	5.53231.00.00.100108	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560954062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
94	5.53231.00.00.100108	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916562072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
95	5.53231.00.00.100108	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674764082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
96	5.53231.00.00.100108	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543923092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
97	5.53231.00.00.100108	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863577102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
98	5.53231.00.00.100108	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626430112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
99	5.53231.00.00.100108	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694267122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
100	5.53231.00.00.100105	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076354022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
101	5.53231.00.00.100105	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007069032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
102	5.53231.00.00.100105	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836719042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
103	5.53231.00.00.100105	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824288052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
104	5.53231.00.00.100105	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560953062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
105	5.53231.00.00.100105	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916561072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
106	5.53231.00.00.100105	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674763082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
107	5.53231.00.00.100105	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543922092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
108	5.53231.00.00.100105	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863576102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
109	5.53231.00.00.100105	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626429112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
110	5.53231.00.00.100105	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694266122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
111	5.53231.00.00.100094	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076347022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
112	5.53231.00.00.100094	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007062032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
113	5.53231.00.00.100094	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836711042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
114	5.53231.00.00.100094	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824280052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
115	5.53231.00.00.100094	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560945062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
116	5.53231.00.00.100094	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916553072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
117	5.53231.00.00.100094	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674755082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
118	5.53231.00.00.100094	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543915092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
119	5.53231.00.00.100094	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863569102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
120	5.53231.00.00.100094	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626422112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
121	5.53231.00.00.100094	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694259122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
122	5.53231.00.00.100092	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076345022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
123	5.53231.00.00.100092	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007060032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
124	5.53231.00.00.100092	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836709042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
125	5.53231.00.00.100092	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824278052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
126	5.53231.00.00.100092	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560943062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
127	5.53231.00.00.100092	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916551072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
128	5.53231.00.00.100092	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674753082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
129	5.53231.00.00.100092	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543913092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
130	5.53231.00.00.100092	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863567102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
131	5.53231.00.00.100092	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626420112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
132	5.53231.00.00.100092	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694257122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
133	5.53231.00.00.100079	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076339022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
134	5.53231.00.00.100079	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007054032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
135	5.53231.00.00.100079	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836703042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
136	5.53231.00.00.100079	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824272052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
137	5.53231.00.00.100079	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560936062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
138	5.53231.00.00.100079	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916545072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
139	5.53231.00.00.100079	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674747082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
140	5.53231.00.00.100079	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543907092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
141	5.53231.00.00.100079	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863561102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
142	5.53231.00.00.100079	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626413112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
143	5.53231.00.00.100079	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694250122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
144	5.53231.00.00.100053	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076335022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
145	5.53231.00.00.100053	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007050032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
146	5.53231.00.00.100053	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836699042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
147	5.53231.00.00.100053	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824268052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
148	5.53231.00.00.100053	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560932062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
149	5.53231.00.00.100053	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916541072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
150	5.53231.00.00.100053	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674743082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
151	5.53231.00.00.100053	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543903092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
152	5.53231.00.00.100053	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863557102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
153	5.53231.00.00.100053	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626409112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
154	5.53231.00.00.100053	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694246122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
155	5.53231.00.00.100014	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076329022024	430.4	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
156	5.53231.00.00.100014	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007044032024	367.02	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
157	5.53231.00.00.100014	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836694042024	524.54	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
158	5.53231.00.00.100014	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824263052024	400.81	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
159	5.53231.00.00.100014	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560927062024	558.86	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
160	5.53231.00.00.100014	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916535072024	326.6	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
161	5.53231.00.00.100014	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674738082024	354.95	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
162	5.53231.00.00.100014	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543897092024	171.6	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
163	5.53231.00.00.100014	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863552102024	453.55	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
164	5.53231.00.00.100014	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626404112024	793.68	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
165	5.53231.00.00.100014	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694240122024	440.39	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
166	5.53231.00.00.100001	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076326022024	226.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
167	5.53231.00.00.100001	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007041032024	226.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
168	5.53231.00.00.100001	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836691042024	226.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
169	5.53231.00.00.100001	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824260052024	226.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
170	5.53231.00.00.100001	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560924062024	226.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
171	5.53231.00.00.100001	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916532072024	226.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
172	5.53231.00.00.100001	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674735082024	226.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
173	5.53231.00.00.100001	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543894092024	226.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
174	5.53231.00.00.100001	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863549102024	226.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
175	5.53231.00.00.100001	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626401112024	226.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
176	5.53231.00.00.100001	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694237122024	226.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
177	5.53231.00.00.100323	\N	ENTRAIDE NATIONALE	0001076476022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
178	5.53231.00.00.100323	\N	ENTRAIDE NATIONALE	0001007191032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
179	5.53231.00.00.100323	\N	ENTRAIDE NATIONALE	0001836841042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
180	5.53231.00.00.100323	\N	ENTRAIDE NATIONALE	0001824410052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
181	5.53231.00.00.100323	\N	ENTRAIDE NATIONALE	0000561075062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
182	5.53231.00.00.100323	\N	ENTRAIDE NATIONALE	0001916683072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
183	5.53231.00.00.100323	\N	ENTRAIDE NATIONALE	0001674885082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
184	5.53231.00.00.100323	\N	ENTRAIDE NATIONALE	0000544043092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
185	5.53231.00.00.100323	\N	ENTRAIDE NATIONALE	0000863698102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
186	5.53231.00.00.100323	\N	ENTRAIDE NATIONALE	0000626552112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
187	5.53231.00.00.100323	\N	ENTRAIDE NATIONALE	0001694388122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
188	5.53231.00.00.100207	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076405022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
189	5.53231.00.00.100207	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007120032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
190	5.53231.00.00.100207	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836770042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
191	5.53231.00.00.100207	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824339052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
192	5.53231.00.00.100207	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000561004062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
193	5.53231.00.00.100207	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916612072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
194	5.53231.00.00.100207	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674814082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
195	5.53231.00.00.100207	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543972092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
196	5.53231.00.00.100207	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863627102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
197	5.53231.00.00.100207	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626481112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
198	5.53231.00.00.100207	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694317122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
199	5.53231.00.00.100341	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001076484022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
200	5.53231.00.00.100341	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001007199032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
201	5.53231.00.00.100341	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001836849042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
202	5.53231.00.00.100341	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001824418052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
203	5.53231.00.00.100341	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0000561083062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
204	5.53231.00.00.100341	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001916691072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
205	5.53231.00.00.100341	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001674893082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
206	5.53231.00.00.100341	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0000544051092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
207	5.53231.00.00.100341	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0000863706102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
208	5.53231.00.00.100341	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0000626560112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
209	5.53231.00.00.100341	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001694396122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
210	5.53231.00.00.100367	\N	ENTRAIDE NATIONALE 4014	0001076507022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
211	5.53231.00.00.100367	\N	ENTRAIDE NATIONALE 4014	0001007222032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
212	5.53231.00.00.100367	\N	ENTRAIDE NATIONALE 4014	0001836872042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
213	5.53231.00.00.100367	\N	ENTRAIDE NATIONALE 4014	0001824441052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
214	5.53231.00.00.100367	\N	ENTRAIDE NATIONALE 4014	0000561106062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
215	5.53231.00.00.100367	\N	ENTRAIDE NATIONALE 4014	0001916714072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
216	5.53231.00.00.100367	\N	ENTRAIDE NATIONALE 4014	0001674916082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
217	5.53231.00.00.100367	\N	ENTRAIDE NATIONALE 4014	0000544074092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
218	5.53231.00.00.100367	\N	ENTRAIDE NATIONALE 4014	0000863729102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
219	5.53231.00.00.100367	\N	ENTRAIDE NATIONALE 4014	0000626583112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
220	5.53231.00.00.100367	\N	ENTRAIDE NATIONALE 4014	0001694419122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
221	5.53231.00.00.100382	\N	ENTRAIDE NATIONAL	0001076512022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
222	5.53231.00.00.100382	\N	ENTRAIDE NATIONAL	0001007227032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
223	5.53231.00.00.100382	\N	ENTRAIDE NATIONAL	0001836877042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
224	5.53231.00.00.100382	\N	ENTRAIDE NATIONAL	0001824446052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
225	5.53231.00.00.100382	\N	ENTRAIDE NATIONAL	0000561111062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
226	5.53231.00.00.100382	\N	ENTRAIDE NATIONAL	0001916719072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
227	5.53231.00.00.100382	\N	ENTRAIDE NATIONAL	0001674921082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
228	5.53231.00.00.100382	\N	ENTRAIDE NATIONAL	0000544079092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
229	5.53231.00.00.100382	\N	ENTRAIDE NATIONAL	0000863734102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
230	5.53231.00.00.100382	\N	ENTRAIDE NATIONAL	0000626588112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
231	5.53231.00.00.100382	\N	ENTRAIDE NATIONAL	0001694424122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
232	5.53231.00.00.100162	\N	ENTRAIDE NATIONALE 4922	0001076386022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
233	5.53231.00.00.100162	\N	ENTRAIDE NATIONALE 4922	0001007101032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
234	5.53231.00.00.100162	\N	ENTRAIDE NATIONALE 4922	0001836751042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
235	5.53231.00.00.100162	\N	ENTRAIDE NATIONALE 4922	0001824320052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
236	5.53231.00.00.100162	\N	ENTRAIDE NATIONALE 4922	0000560985062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
237	5.53231.00.00.100162	\N	ENTRAIDE NATIONALE 4922	0001916593072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
238	5.53231.00.00.100162	\N	ENTRAIDE NATIONALE 4922	0001674795082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
239	5.53231.00.00.100162	\N	ENTRAIDE NATIONALE 4922	0000543953092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
240	5.53231.00.00.100162	\N	ENTRAIDE NATIONALE 4922	0000863608102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
241	5.53231.00.00.100162	\N	ENTRAIDE NATIONALE 4922	0000626462112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
242	5.53231.00.00.100162	\N	ENTRAIDE NATIONALE 4922	0001694298122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
243	5.53231.00.00.100166	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076390022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
244	5.53231.00.00.100166	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007105032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
245	5.53231.00.00.100166	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836755042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
246	5.53231.00.00.100166	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824324052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
247	5.53231.00.00.100166	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560989062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
248	5.53231.00.00.100166	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916597072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
249	5.53231.00.00.100166	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674799082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
250	5.53231.00.00.100166	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543957092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
251	5.53231.00.00.100166	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863612102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
252	5.53231.00.00.100166	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626466112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
253	5.53231.00.00.100166	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694302122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
254	5.53231.00.00.100177	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076395022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
255	5.53231.00.00.100177	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007110032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
256	5.53231.00.00.100177	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836760042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
257	5.53231.00.00.100177	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824329052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
258	5.53231.00.00.100177	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560994062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
259	5.53231.00.00.100177	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916602072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
260	5.53231.00.00.100177	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674804082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
261	5.53231.00.00.100177	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543962092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
262	5.53231.00.00.100177	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863617102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
263	5.53231.00.00.100177	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626471112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
264	5.53231.00.00.100177	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694307122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
265	5.53231.00.00.100178	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076396022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
266	5.53231.00.00.100178	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007111032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
267	5.53231.00.00.100178	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836761042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
268	5.53231.00.00.100178	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824330052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
269	5.53231.00.00.100178	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560995062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
270	5.53231.00.00.100178	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916603072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
271	5.53231.00.00.100178	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674805082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
272	5.53231.00.00.100178	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543963092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
273	5.53231.00.00.100178	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863618102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
274	5.53231.00.00.100178	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626472112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
275	5.53231.00.00.100178	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694308122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
276	7.1830754.00.00.100012	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000121526022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
277	7.1830754.00.00.100012	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000076748032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
278	7.1830754.00.00.100012	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000095612042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
279	7.1830754.00.00.100012	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000522527052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
280	7.1830754.00.00.100012	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000612089062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
281	7.1830754.00.00.100012	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543483072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
282	7.1830754.00.00.100012	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001679006082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
283	7.1830754.00.00.100012	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000535562092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
284	7.1830754.00.00.100012	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000874598102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
285	7.1830754.00.00.100012	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000609638112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
286	7.1830754.00.00.100012	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001685969122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
287	7.1830754.00.00.100009	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000121525022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
288	7.1830754.00.00.100009	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000076747032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
289	7.1830754.00.00.100009	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000095611042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
290	7.1830754.00.00.100009	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000522526052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
291	7.1830754.00.00.100009	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000612088062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
292	7.1830754.00.00.100009	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543482072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
293	7.1830754.00.00.100009	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001679005082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
294	7.1830754.00.00.100009	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000535561092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
295	7.1830754.00.00.100009	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000874597102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
296	7.1830754.00.00.100009	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000609637112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
297	7.1830754.00.00.100009	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001685968122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
298	5.53231.00.00.100096	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076348022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
299	5.53231.00.00.100096	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007063032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
300	5.53231.00.00.100096	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836712042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
301	5.53231.00.00.100096	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824281052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
302	5.53231.00.00.100096	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560946062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
303	5.53231.00.00.100096	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916554072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
304	5.53231.00.00.100096	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674756082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
305	5.53231.00.00.100096	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543916092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
306	5.53231.00.00.100096	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863570102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
307	5.53231.00.00.100096	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626423112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
308	5.53231.00.00.100096	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694260122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
309	5.53231.00.00.100093	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076346022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
310	5.53231.00.00.100093	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007061032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
311	5.53231.00.00.100093	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836710042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
312	5.53231.00.00.100093	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824279052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
313	5.53231.00.00.100093	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560944062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
314	5.53231.00.00.100093	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916552072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
315	5.53231.00.00.100093	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674754082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
316	5.53231.00.00.100093	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543914092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
317	5.53231.00.00.100093	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863568102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
318	5.53231.00.00.100093	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626421112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
319	5.53231.00.00.100093	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694258122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
320	5.53231.00.00.100091	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076344022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
321	5.53231.00.00.100091	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007059032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
322	5.53231.00.00.100091	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836708042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
323	5.53231.00.00.100091	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824277052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
324	5.53231.00.00.100091	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560942062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
325	5.53231.00.00.100091	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916550072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
326	5.53231.00.00.100091	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674752082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
327	5.53231.00.00.100091	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543912092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
328	5.53231.00.00.100091	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863566102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
329	5.53231.00.00.100091	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626419112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
330	5.53231.00.00.100091	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694256122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
331	5.53231.00.00.100084	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076342022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
332	5.53231.00.00.100084	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007057032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
333	5.53231.00.00.100084	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836706042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
334	5.53231.00.00.100084	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824275052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
335	5.53231.00.00.100084	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560939062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
336	5.53231.00.00.100084	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916548072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
337	5.53231.00.00.100084	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674750082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
338	5.53231.00.00.100084	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543910092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
339	5.53231.00.00.100084	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863564102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
340	5.53231.00.00.100084	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626416112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
341	5.53231.00.00.100084	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694253122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
342	5.53231.00.00.100082	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076340022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
343	5.53231.00.00.100082	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007055032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
344	5.53231.00.00.100082	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836704042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
345	5.53231.00.00.100082	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824273052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
346	5.53231.00.00.100082	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560937062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
347	5.53231.00.00.100082	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916546072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
348	5.53231.00.00.100082	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674748082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
349	5.53231.00.00.100082	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543908092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
350	5.53231.00.00.100082	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863562102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
351	5.53231.00.00.100082	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626414112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
352	5.53231.00.00.100082	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694251122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
353	5.53231.00.00.100068	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076337022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
354	5.53231.00.00.100068	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007052032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
355	5.53231.00.00.100068	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836701042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
356	5.53231.00.00.100068	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824270052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
357	5.53231.00.00.100068	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560934062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
358	5.53231.00.00.100068	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916543072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
359	5.53231.00.00.100068	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674745082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
360	5.53231.00.00.100068	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543905092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
361	5.53231.00.00.100068	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863559102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
362	5.53231.00.00.100068	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626411112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
363	5.53231.00.00.100068	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694248122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
364	5.53231.00.00.100052	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076334022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
365	5.53231.00.00.100052	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007049032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
366	5.53231.00.00.100052	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836698042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
367	5.53231.00.00.100052	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824267052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
368	5.53231.00.00.100052	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560931062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
369	5.53231.00.00.100052	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916540072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
370	5.53231.00.00.100052	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674742082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
371	5.53231.00.00.100052	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543902092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
372	5.53231.00.00.100052	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863556102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
373	5.53231.00.00.100052	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626408112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
374	5.53231.00.00.100052	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694245122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
375	5.53231.00.00.100019	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076331022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
376	5.53231.00.00.100019	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007046032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
377	5.53231.00.00.100019	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836696042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
378	5.53231.00.00.100019	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824265052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
379	5.53231.00.00.100019	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560929062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
380	5.53231.00.00.100019	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916537072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
381	5.53231.00.00.100019	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674740082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
382	5.53231.00.00.100019	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543899092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
383	5.53231.00.00.100019	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863554102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
384	5.53231.00.00.100019	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626406112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
385	5.53231.00.00.100019	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694242122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
386	5.53231.00.00.100013	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076328022024	226.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
387	5.53231.00.00.100013	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007043032024	226.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
388	5.53231.00.00.100013	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836693042024	226.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
389	5.53231.00.00.100013	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824262052024	226.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
390	5.53231.00.00.100013	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560926062024	226.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
391	5.53231.00.00.100013	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916534072024	226.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
392	5.53231.00.00.100013	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674737082024	226.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
393	5.53231.00.00.100013	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543896092024	226.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
394	5.53231.00.00.100013	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863551102024	226.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
395	5.53231.00.00.100013	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626403112024	226.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
396	5.53231.00.00.100013	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694239122024	226.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
397	5.53231.00.00.100007	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076327022024	204	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
398	5.53231.00.00.100007	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007042032024	204	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
399	5.53231.00.00.100007	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836692042024	204	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
400	5.53231.00.00.100007	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824261052024	204	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
401	5.53231.00.00.100007	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560925062024	204	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
402	5.53231.00.00.100007	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916533072024	204	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
403	5.53231.00.00.100007	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674736082024	204	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
404	5.53231.00.00.100007	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543895092024	204	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
405	5.53231.00.00.100007	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863550102024	204	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
406	5.53231.00.00.100007	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626402112024	204	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
407	5.53231.00.00.100007	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694238122024	204	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
408	5.53231.00.00.100154	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076381022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
409	5.53231.00.00.100154	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007096032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
410	5.53231.00.00.100154	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836746042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
411	5.53231.00.00.100154	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824315052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
412	5.53231.00.00.100154	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560980062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
413	5.53231.00.00.100154	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916588072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
414	5.53231.00.00.100154	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674790082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
415	5.53231.00.00.100154	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543948092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
416	5.53231.00.00.100154	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863603102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
417	5.53231.00.00.100154	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626457112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
418	5.53231.00.00.100154	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694293122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
419	5.53231.00.00.100151	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076379022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
420	5.53231.00.00.100151	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007094032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
421	5.53231.00.00.100151	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836744042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
422	5.53231.00.00.100151	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824313052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
423	5.53231.00.00.100151	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560978062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
424	5.53231.00.00.100151	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916586072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
425	5.53231.00.00.100151	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674788082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
426	5.53231.00.00.100151	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543946092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
427	5.53231.00.00.100151	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863601102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
428	5.53231.00.00.100151	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626455112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
429	5.53231.00.00.100151	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694291122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
430	5.53231.00.00.100150	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076378022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
431	5.53231.00.00.100150	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007093032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
432	5.53231.00.00.100150	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836743042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
433	5.53231.00.00.100150	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824312052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
434	5.53231.00.00.100150	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560977062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
435	5.53231.00.00.100150	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916585072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
436	5.53231.00.00.100150	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674787082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
437	5.53231.00.00.100150	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543945092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
438	5.53231.00.00.100150	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863600102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
439	5.53231.00.00.100150	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626454112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
440	5.53231.00.00.100150	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694290122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
441	5.53231.00.00.100145	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076375022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
442	5.53231.00.00.100145	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007090032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
443	5.53231.00.00.100145	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836740042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
444	5.53231.00.00.100145	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824309052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
445	5.53231.00.00.100145	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560974062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
446	5.53231.00.00.100145	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916582072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
447	5.53231.00.00.100145	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674784082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
448	5.53231.00.00.100145	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543942092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
449	5.53231.00.00.100145	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863597102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
450	5.53231.00.00.100145	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626451112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
451	5.53231.00.00.100145	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694287122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
452	5.53231.00.00.100141	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076372022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
453	5.53231.00.00.100141	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007087032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
454	5.53231.00.00.100141	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836737042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
455	5.53231.00.00.100141	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824306052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
456	5.53231.00.00.100141	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560971062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
457	5.53231.00.00.100141	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916579072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
458	5.53231.00.00.100141	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674781082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
459	5.53231.00.00.100141	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543939092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
460	5.53231.00.00.100141	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863594102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
461	5.53231.00.00.100141	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626448112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
462	5.53231.00.00.100141	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694284122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
463	5.53231.00.00.100139	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076371022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
464	5.53231.00.00.100139	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007086032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
465	5.53231.00.00.100139	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836736042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
466	5.53231.00.00.100139	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824305052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
467	5.53231.00.00.100139	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560970062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
468	5.53231.00.00.100139	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916578072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
469	5.53231.00.00.100139	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674780082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
470	5.53231.00.00.100139	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543938092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
471	5.53231.00.00.100139	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863593102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
472	5.53231.00.00.100139	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626447112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
473	5.53231.00.00.100139	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694283122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
474	5.53231.00.00.100126	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076367022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
475	5.53231.00.00.100126	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007082032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
476	5.53231.00.00.100126	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836732042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
477	5.53231.00.00.100126	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824301052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
478	5.53231.00.00.100126	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560966062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
479	5.53231.00.00.100126	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916574072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
480	5.53231.00.00.100126	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674776082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
481	5.53231.00.00.100126	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543935092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
482	5.53231.00.00.100126	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863589102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
483	5.53231.00.00.100126	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626443112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
484	5.53231.00.00.100126	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694279122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
485	5.53231.00.00.100119	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076363022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
486	5.53231.00.00.100119	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007078032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
487	5.53231.00.00.100119	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836728042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
488	5.53231.00.00.100119	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824297052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
489	5.53231.00.00.100119	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560962062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
490	5.53231.00.00.100119	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916570072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
491	5.53231.00.00.100119	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674772082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
492	5.53231.00.00.100119	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543931092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
493	5.53231.00.00.100119	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863585102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
494	5.53231.00.00.100119	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626438112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
495	5.53231.00.00.100119	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694275122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
496	5.53231.00.00.100115	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076360022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
497	5.53231.00.00.100115	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007075032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
498	5.53231.00.00.100115	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836725042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
499	5.53231.00.00.100115	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824294052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
500	5.53231.00.00.100115	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560959062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:41.953129	2026-07-16 12:35:41.953129
501	5.53231.00.00.100115	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916567072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
502	5.53231.00.00.100115	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674769082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
503	5.53231.00.00.100115	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543928092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
504	5.53231.00.00.100115	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863582102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
505	5.53231.00.00.100115	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626435112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
506	5.53231.00.00.100115	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694272122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
507	5.53231.00.00.100111	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076357022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
508	5.53231.00.00.100111	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007072032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
509	5.53231.00.00.100111	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836722042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
510	5.53231.00.00.100111	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824291052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
511	5.53231.00.00.100111	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560956062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
512	5.53231.00.00.100111	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916564072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
513	5.53231.00.00.100111	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674766082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
514	5.53231.00.00.100111	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543925092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
515	5.53231.00.00.100111	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863579102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
516	5.53231.00.00.100111	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626432112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
517	5.53231.00.00.100111	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694269122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
518	5.53231.00.00.100104	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076353022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
519	5.53231.00.00.100104	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007068032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
520	5.53231.00.00.100104	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836718042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
521	5.53231.00.00.100104	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824287052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
522	5.53231.00.00.100104	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560952062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
523	5.53231.00.00.100104	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916560072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
524	5.53231.00.00.100104	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674762082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
525	5.53231.00.00.100104	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543921092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
526	5.53231.00.00.100104	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863575102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
527	5.53231.00.00.100104	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626428112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
528	5.53231.00.00.100104	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694265122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
529	5.53231.00.00.100097	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076349022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
530	5.53231.00.00.100097	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007064032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
531	5.53231.00.00.100097	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836713042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
532	5.53231.00.00.100097	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824282052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
533	5.53231.00.00.100097	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560947062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
534	5.53231.00.00.100097	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916555072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
535	5.53231.00.00.100097	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674757082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
536	5.53231.00.00.100097	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543917092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
537	5.53231.00.00.100097	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863571102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
538	5.53231.00.00.100097	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626424112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
539	5.53231.00.00.100097	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694261122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
540	5.53231.00.00.100163	\N	ENTRAIDE NATIONALE	0001076387022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
541	5.53231.00.00.100163	\N	ENTRAIDE NATIONALE	0001007102032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
542	5.53231.00.00.100163	\N	ENTRAIDE NATIONALE	0001836752042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
543	5.53231.00.00.100163	\N	ENTRAIDE NATIONALE	0001824321052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
544	5.53231.00.00.100163	\N	ENTRAIDE NATIONALE	0000560986062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
545	5.53231.00.00.100163	\N	ENTRAIDE NATIONALE	0001916594072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
546	5.53231.00.00.100163	\N	ENTRAIDE NATIONALE	0001674796082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
547	5.53231.00.00.100163	\N	ENTRAIDE NATIONALE	0000543954092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
548	5.53231.00.00.100163	\N	ENTRAIDE NATIONALE	0000863609102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
549	5.53231.00.00.100163	\N	ENTRAIDE NATIONALE	0000626463112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
550	5.53231.00.00.100163	\N	ENTRAIDE NATIONALE	0001694299122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
551	5.53231.13.00.100141	\N	ENTRAIDE NATIONALE FAHS ANJRA LETTRE 170	0001076640022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
552	5.53231.13.00.100141	\N	ENTRAIDE NATIONALE FAHS ANJRA LETTRE 170	0001007358032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
553	5.53231.13.00.100141	\N	ENTRAIDE NATIONALE FAHS ANJRA LETTRE 170	0001837008042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
554	5.53231.13.00.100141	\N	ENTRAIDE NATIONALE FAHS ANJRA LETTRE 170	0001824577052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
555	5.53231.13.00.100141	\N	ENTRAIDE NATIONALE FAHS ANJRA LETTRE 170	0000561241062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
556	5.53231.13.00.100141	\N	ENTRAIDE NATIONALE FAHS ANJRA LETTRE 170	0001916849072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
557	5.53231.13.00.100141	\N	ENTRAIDE NATIONALE FAHS ANJRA LETTRE 170	0001675054082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
558	5.53231.13.00.100141	\N	ENTRAIDE NATIONALE FAHS ANJRA LETTRE 170	0000544206092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
559	5.53231.13.00.100141	\N	ENTRAIDE NATIONALE FAHS ANJRA LETTRE 170	0000863857102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
560	5.53231.13.00.100141	\N	ENTRAIDE NATIONALE FAHS ANJRA LETTRE 170	0000626711112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
561	5.53231.13.00.100141	\N	ENTRAIDE NATIONALE FAHS ANJRA LETTRE 170	0001694548122024	202.8	\N	30/11/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
562	5.53231.00.00.100190	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076399022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
563	5.53231.00.00.100190	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007114032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
564	5.53231.00.00.100190	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836764042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
565	5.53231.00.00.100190	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824333052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
566	5.53231.00.00.100190	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560998062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
567	5.53231.00.00.100190	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916606072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
568	5.53231.00.00.100190	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674808082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
569	5.53231.00.00.100190	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543966092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
570	5.53231.00.00.100190	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863621102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
571	5.53231.00.00.100190	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626475112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
572	5.53231.00.00.100190	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694311122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
573	5.53231.00.00.100194	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE 1	0001076401022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
574	5.53231.00.00.100194	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE 1	0001007116032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
575	5.53231.00.00.100194	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE 1	0001836766042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
576	5.53231.00.00.100194	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE 1	0001824335052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
577	5.53231.00.00.100194	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE 1	0000561000062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
578	5.53231.00.00.100194	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE 1	0001916608072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
579	5.53231.00.00.100194	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE 1	0001674810082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
580	5.53231.00.00.100194	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE 1	0000543968092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
581	5.53231.00.00.100194	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE 1	0000863623102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
582	5.53231.00.00.100194	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE 1	0000626477112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
583	5.53231.00.00.100194	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE 1	0001694313122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
584	5.53231.00.00.100202	\N	ENTRAIDE NATIONALE	0001076402022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
585	5.53231.00.00.100202	\N	ENTRAIDE NATIONALE	0001007117032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
586	5.53231.00.00.100202	\N	ENTRAIDE NATIONALE	0001836767042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
587	5.53231.00.00.100202	\N	ENTRAIDE NATIONALE	0001824336052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
588	5.53231.00.00.100202	\N	ENTRAIDE NATIONALE	0000561001062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
589	5.53231.00.00.100202	\N	ENTRAIDE NATIONALE	0001916609072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
590	5.53231.00.00.100202	\N	ENTRAIDE NATIONALE	0001674811082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
591	5.53231.00.00.100202	\N	ENTRAIDE NATIONALE	0000543969092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
592	5.53231.00.00.100202	\N	ENTRAIDE NATIONALE	0000863624102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
593	5.53231.00.00.100202	\N	ENTRAIDE NATIONALE	0000626478112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
594	5.53231.00.00.100202	\N	ENTRAIDE NATIONALE	0001694314122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
595	5.53231.13.00.100083	\N	ENTRAIDE NATIONALE TEMARA	0001076609022024	500	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
596	5.53231.13.00.100083	\N	ENTRAIDE NATIONALE TEMARA	0001007325032024	500	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
597	5.53231.13.00.100083	\N	ENTRAIDE NATIONALE TEMARA	0001836976042024	500	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
598	5.53231.13.00.100083	\N	ENTRAIDE NATIONALE TEMARA	0001824543052024	500	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
599	5.53231.13.00.100083	\N	ENTRAIDE NATIONALE TEMARA	0000561207062024	500	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
600	5.53231.13.00.100083	\N	ENTRAIDE NATIONALE TEMARA	0001916816072024	500	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
601	5.53231.13.00.100083	\N	ENTRAIDE NATIONALE TEMARA	0001675019082024	500	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
602	5.53231.13.00.100083	\N	ENTRAIDE NATIONALE TEMARA	0000544177092024	500	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
603	5.53231.13.00.100083	\N	ENTRAIDE NATIONALE TEMARA	0000863830102024	500	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
604	5.53231.13.00.100083	\N	ENTRAIDE NATIONALE TEMARA	0000626684112024	500	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
605	5.53231.13.00.100083	\N	ENTRAIDE NATIONALE TEMARA	0001694521122024	500	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
606	5.53231.12.00.100030	\N	ENTRAIDE NATIONALE DELEGATION BOULEMANE	0001076530022024	180	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
607	5.53231.12.00.100030	\N	ENTRAIDE NATIONALE DELEGATION BOULEMANE	0001007245032024	180	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
608	5.53231.12.00.100030	\N	ENTRAIDE NATIONALE DELEGATION BOULEMANE	0001836894042024	180	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
609	5.53231.12.00.100030	\N	ENTRAIDE NATIONALE DELEGATION BOULEMANE	0001824463052024	180	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
610	5.53231.12.00.100030	\N	ENTRAIDE NATIONALE DELEGATION BOULEMANE	0000561128062024	180	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
611	5.53231.12.00.100030	\N	ENTRAIDE NATIONALE DELEGATION BOULEMANE	0001916736072024	180	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
612	5.53231.12.00.100030	\N	ENTRAIDE NATIONALE DELEGATION BOULEMANE	0001674938082024	180	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
613	5.53231.12.00.100030	\N	ENTRAIDE NATIONALE DELEGATION BOULEMANE	0000544096092024	180	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
614	5.53231.12.00.100030	\N	ENTRAIDE NATIONALE DELEGATION BOULEMANE	0000863751102024	180	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
615	5.53231.12.00.100030	\N	ENTRAIDE NATIONALE DELEGATION BOULEMANE	0000626605112024	180	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
616	5.53231.12.00.100030	\N	ENTRAIDE NATIONALE DELEGATION BOULEMANE	0001694441122024	180	\N	30/11/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
617	5.53231.00.00.100320	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076474022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
618	5.53231.00.00.100320	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007189032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
619	5.53231.00.00.100320	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836839042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
620	5.53231.00.00.100320	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824408052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
621	5.53231.00.00.100320	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000561073062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
622	5.53231.00.00.100320	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916681072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
623	5.53231.00.00.100320	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674883082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
624	5.53231.00.00.100320	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000544041092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
625	5.53231.00.00.100320	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863696102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
626	5.53231.00.00.100320	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626550112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
627	5.53231.00.00.100320	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694386122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
628	5.53231.00.00.100370	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076508022024	156	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
629	5.53231.00.00.100370	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007223032024	156	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
630	5.53231.00.00.100370	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836873042024	156	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
631	5.53231.00.00.100370	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824442052024	156	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
632	5.53231.00.00.100370	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000561107062024	156	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
633	5.53231.00.00.100370	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916715072024	156	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
634	5.53231.00.00.100370	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674917082024	156	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
635	5.53231.00.00.100370	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000544075092024	156	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
636	5.53231.00.00.100370	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863730102024	156	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
637	5.53231.00.00.100370	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626584112024	156	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
638	5.53231.00.00.100370	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694420122024	156	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
639	5.53231.00.00.100388	\N	ADSMINSTRATION DE L'ENTRAIDE NATIONLE 37	0001076516022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
640	5.53231.00.00.100388	\N	ADSMINSTRATION DE L'ENTRAIDE NATIONLE 37	0001007231032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
641	5.53231.00.00.100388	\N	ADSMINSTRATION DE L'ENTRAIDE NATIONLE 37	0001836881042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
642	5.53231.00.00.100388	\N	ADSMINSTRATION DE L'ENTRAIDE NATIONLE 37	0001824450052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
643	5.53231.00.00.100388	\N	ADSMINSTRATION DE L'ENTRAIDE NATIONLE 37	0000561115062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
644	5.53231.00.00.100388	\N	ADSMINSTRATION DE L'ENTRAIDE NATIONLE 37	0001916723072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
645	5.53231.00.00.100388	\N	ADSMINSTRATION DE L'ENTRAIDE NATIONLE 37	0001674925082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
646	5.53231.00.00.100388	\N	ADSMINSTRATION DE L'ENTRAIDE NATIONLE 37	0000544083092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
647	5.53231.00.00.100388	\N	ADSMINSTRATION DE L'ENTRAIDE NATIONLE 37	0000863738102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
648	5.53231.00.00.100388	\N	ADSMINSTRATION DE L'ENTRAIDE NATIONLE 37	0000626592112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
649	5.53231.00.00.100388	\N	ADSMINSTRATION DE L'ENTRAIDE NATIONLE 37	0001694428122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
650	5.53231.00.00.100345	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001076488022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
651	5.53231.00.00.100345	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001007203032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
652	5.53231.00.00.100345	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001836853042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
653	5.53231.00.00.100345	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001824422052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
654	5.53231.00.00.100345	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0000561087062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
655	5.53231.00.00.100345	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001916695072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
656	5.53231.00.00.100345	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001674897082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
657	5.53231.00.00.100345	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0000544055092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
658	5.53231.00.00.100345	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0000863710102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
659	5.53231.00.00.100345	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0000626564112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
660	5.53231.00.00.100345	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001694400122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
661	5.53231.00.00.100354	\N	DIRECTION ENTRAIDE NATIONALE	0001076496022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
662	5.53231.00.00.100354	\N	DIRECTION ENTRAIDE NATIONALE	0001007211032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
663	5.53231.00.00.100354	\N	DIRECTION ENTRAIDE NATIONALE	0001836861042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
664	5.53231.00.00.100354	\N	DIRECTION ENTRAIDE NATIONALE	0001824430052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
665	5.53231.00.00.100354	\N	DIRECTION ENTRAIDE NATIONALE	0000561095062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
666	5.53231.00.00.100354	\N	DIRECTION ENTRAIDE NATIONALE	0001916703072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
667	5.53231.00.00.100354	\N	DIRECTION ENTRAIDE NATIONALE	0001674905082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
668	5.53231.00.00.100354	\N	DIRECTION ENTRAIDE NATIONALE	0000544063092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
669	5.53231.00.00.100354	\N	DIRECTION ENTRAIDE NATIONALE	0000863718102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
670	5.53231.00.00.100354	\N	DIRECTION ENTRAIDE NATIONALE	0000626572112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
671	5.53231.00.00.100354	\N	DIRECTION ENTRAIDE NATIONALE	0001694408122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
672	5.53231.00.00.100348	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001076490022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
673	5.53231.00.00.100348	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001007205032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
674	5.53231.00.00.100348	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001836855042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
675	5.53231.00.00.100348	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001824424052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
676	5.53231.00.00.100348	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0000561089062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
677	5.53231.00.00.100348	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001916697072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
678	5.53231.00.00.100348	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001674899082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
679	5.53231.00.00.100348	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0000544057092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
680	5.53231.00.00.100348	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0000863712102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
681	5.53231.00.00.100348	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0000626566112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
682	5.53231.00.00.100348	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001694402122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
683	5.53231.00.00.100350	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001076492022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
684	5.53231.00.00.100350	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001007207032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
685	5.53231.00.00.100350	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001836857042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
686	5.53231.00.00.100350	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001824426052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
687	5.53231.00.00.100350	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0000561091062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
688	5.53231.00.00.100350	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001916699072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
689	5.53231.00.00.100350	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001674901082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
690	5.53231.00.00.100350	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0000544059092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
691	5.53231.00.00.100350	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0000863714102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
692	5.53231.00.00.100350	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0000626568112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
693	5.53231.00.00.100350	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001694404122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
694	5.53231.00.00.100352	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001076494022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
695	5.53231.00.00.100352	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001007209032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
696	5.53231.00.00.100352	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001836859042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
697	5.53231.00.00.100352	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001824428052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
698	5.53231.00.00.100352	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0000561093062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
699	5.53231.00.00.100352	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001916701072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
700	5.53231.00.00.100352	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001674903082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
701	5.53231.00.00.100352	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0000544061092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
702	5.53231.00.00.100352	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0000863716102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
703	5.53231.00.00.100352	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0000626570112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
704	5.53231.00.00.100352	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001694406122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
705	5.53231.00.00.100342	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001076485022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
706	5.53231.00.00.100342	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001007200032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
707	5.53231.00.00.100342	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001836850042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
708	5.53231.00.00.100342	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001824419052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
709	5.53231.00.00.100342	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0000561084062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
710	5.53231.00.00.100342	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001916692072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
711	5.53231.00.00.100342	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001674894082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
712	5.53231.00.00.100342	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0000544052092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
713	5.53231.00.00.100342	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0000863707102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
714	5.53231.00.00.100342	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0000626561112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
715	5.53231.00.00.100342	\N	DIRECTION DE L'ENTRAIDE NATIONALE	0001694397122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
716	5.53231.00.00.100362	\N	ENTRAIDE NATIONALE341	0001076504022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
717	5.53231.00.00.100362	\N	ENTRAIDE NATIONALE341	0001007219032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
718	5.53231.00.00.100362	\N	ENTRAIDE NATIONALE341	0001836869042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
719	5.53231.00.00.100362	\N	ENTRAIDE NATIONALE341	0001824438052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
720	5.53231.00.00.100362	\N	ENTRAIDE NATIONALE341	0000561103062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
721	5.53231.00.00.100362	\N	ENTRAIDE NATIONALE341	0001916711072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
722	5.53231.00.00.100362	\N	ENTRAIDE NATIONALE341	0001674913082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
723	5.53231.00.00.100362	\N	ENTRAIDE NATIONALE341	0000544071092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
724	5.53231.00.00.100362	\N	ENTRAIDE NATIONALE341	0000863726102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
725	5.53231.00.00.100362	\N	ENTRAIDE NATIONALE341	0000626580112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
726	5.53231.00.00.100362	\N	ENTRAIDE NATIONALE341	0001694416122024	202.8	\N	30/11/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
727	5.53231.00.00.100395	\N	ENTRAIDE NATIONALE LETTRE 1662	0001076522022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
728	5.53231.00.00.100395	\N	ENTRAIDE NATIONALE LETTRE 1662	0001007237032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
729	5.53231.00.00.100395	\N	ENTRAIDE NATIONALE LETTRE 1662	0001836887042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
730	5.53231.00.00.100395	\N	ENTRAIDE NATIONALE LETTRE 1662	0001824456052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
731	5.53231.00.00.100395	\N	ENTRAIDE NATIONALE LETTRE 1662	0000561121062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
732	5.53231.00.00.100395	\N	ENTRAIDE NATIONALE LETTRE 1662	0001916729072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
733	5.53231.00.00.100395	\N	ENTRAIDE NATIONALE LETTRE 1662	0001674931082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
734	5.53231.00.00.100395	\N	ENTRAIDE NATIONALE LETTRE 1662	0000544089092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
735	5.53231.00.00.100395	\N	ENTRAIDE NATIONALE LETTRE 1662	0000863744102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
736	5.53231.00.00.100395	\N	ENTRAIDE NATIONALE LETTRE 1662	0000626598112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
737	5.53231.00.00.100395	\N	ENTRAIDE NATIONALE LETTRE 1662	0001694434122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
738	5.53231.00.00.100517	\N	ENTRAIDE NATIONALE CENTRE AL MAJD LETTRE	0001076648022024	500	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
739	5.53231.00.00.100517	\N	ENTRAIDE NATIONALE CENTRE AL MAJD LETTRE	0001007365032024	500	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
740	5.53231.00.00.100517	\N	ENTRAIDE NATIONALE CENTRE AL MAJD LETTRE	0001837016042024	500	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
741	5.53231.00.00.100517	\N	ENTRAIDE NATIONALE CENTRE AL MAJD LETTRE	0001824586052024	500	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
742	5.53231.00.00.100517	\N	ENTRAIDE NATIONALE CENTRE AL MAJD LETTRE	0000561249062024	500	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
743	5.53231.00.00.100517	\N	ENTRAIDE NATIONALE CENTRE AL MAJD LETTRE	0001916856072024	500	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
744	5.53231.00.00.100517	\N	ENTRAIDE NATIONALE CENTRE AL MAJD LETTRE	0001675060082024	500	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
745	5.53231.00.00.100517	\N	ENTRAIDE NATIONALE CENTRE AL MAJD LETTRE	0000544213092024	500	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
746	5.53231.00.00.100517	\N	ENTRAIDE NATIONALE CENTRE AL MAJD LETTRE	0000863864102024	500	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
747	5.53231.00.00.100517	\N	ENTRAIDE NATIONALE CENTRE AL MAJD LETTRE	0000626719112024	500	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
748	5.53231.00.00.100517	\N	ENTRAIDE NATIONALE CENTRE AL MAJD LETTRE	0001694554122024	500	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
749	5.53231.00.00.100356	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076498022024	226.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
750	5.53231.00.00.100356	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007213032024	226.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
751	5.53231.00.00.100356	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836863042024	226.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
752	5.53231.00.00.100356	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824432052024	226.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
753	5.53231.00.00.100356	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000561097062024	226.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
754	5.53231.00.00.100356	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916705072024	226.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
755	5.53231.00.00.100356	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674907082024	226.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
756	5.53231.00.00.100356	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000544065092024	226.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
757	5.53231.00.00.100356	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863720102024	226.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
758	5.53231.00.00.100356	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626574112024	226.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
759	5.53231.00.00.100356	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694410122024	226.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
760	5.53231.00.00.100376	\N	ADMINISTRATION ENTRAIDE NATIONALE CASA	0001076510022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
761	5.53231.00.00.100376	\N	ADMINISTRATION ENTRAIDE NATIONALE CASA	0001007225032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
762	5.53231.00.00.100376	\N	ADMINISTRATION ENTRAIDE NATIONALE CASA	0001836875042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
763	5.53231.00.00.100376	\N	ADMINISTRATION ENTRAIDE NATIONALE CASA	0001824444052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
764	5.53231.00.00.100376	\N	ADMINISTRATION ENTRAIDE NATIONALE CASA	0000561109062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
765	5.53231.00.00.100376	\N	ADMINISTRATION ENTRAIDE NATIONALE CASA	0001916717072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
766	5.53231.00.00.100376	\N	ADMINISTRATION ENTRAIDE NATIONALE CASA	0001674919082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
767	5.53231.00.00.100376	\N	ADMINISTRATION ENTRAIDE NATIONALE CASA	0000544077092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
768	5.53231.00.00.100376	\N	ADMINISTRATION ENTRAIDE NATIONALE CASA	0000863732102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
769	5.53231.00.00.100376	\N	ADMINISTRATION ENTRAIDE NATIONALE CASA	0000626586112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
770	5.53231.00.00.100376	\N	ADMINISTRATION ENTRAIDE NATIONALE CASA	0001694422122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
771	5.53231.00.00.100386	\N	ENTRAIDE NATIONALE OUJDA 6352	0001076514022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
772	5.53231.00.00.100386	\N	ENTRAIDE NATIONALE OUJDA 6352	0001007229032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
773	5.53231.00.00.100386	\N	ENTRAIDE NATIONALE OUJDA 6352	0001836879042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
774	5.53231.00.00.100386	\N	ENTRAIDE NATIONALE OUJDA 6352	0001824448052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
775	5.53231.00.00.100386	\N	ENTRAIDE NATIONALE OUJDA 6352	0000561113062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
776	5.53231.00.00.100386	\N	ENTRAIDE NATIONALE OUJDA 6352	0001916721072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
777	5.53231.00.00.100386	\N	ENTRAIDE NATIONALE OUJDA 6352	0001674923082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
778	5.53231.00.00.100386	\N	ENTRAIDE NATIONALE OUJDA 6352	0000544081092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
779	5.53231.00.00.100386	\N	ENTRAIDE NATIONALE OUJDA 6352	0000863736102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
780	5.53231.00.00.100386	\N	ENTRAIDE NATIONALE OUJDA 6352	0000626590112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
781	5.53231.00.00.100386	\N	ENTRAIDE NATIONALE OUJDA 6352	0001694426122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
782	5.53231.00.00.100131	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076369022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
783	5.53231.00.00.100131	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007084032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
784	5.53231.00.00.100131	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836734042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
785	5.53231.00.00.100131	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824303052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
786	5.53231.00.00.100131	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560968062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
787	5.53231.00.00.100131	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916576072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
788	5.53231.00.00.100131	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674778082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
789	5.53231.00.00.100131	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543936092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
790	5.53231.00.00.100131	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863591102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
791	5.53231.00.00.100131	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626445112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
792	5.53231.00.00.100131	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694281122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
793	5.53231.12.00.100016	\N	ENTRAIDE NATIONALE DELEGATION TAOUNATE	0001076529022024	180	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
794	5.53231.12.00.100016	\N	ENTRAIDE NATIONALE DELEGATION TAOUNATE	0001007244032024	180	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
795	5.53231.12.00.100016	\N	ENTRAIDE NATIONALE DELEGATION TAOUNATE	0001836893042024	180	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
796	5.53231.12.00.100016	\N	ENTRAIDE NATIONALE DELEGATION TAOUNATE	0001824462052024	180	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
797	5.53231.12.00.100016	\N	ENTRAIDE NATIONALE DELEGATION TAOUNATE	0000561127062024	180	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
798	5.53231.12.00.100016	\N	ENTRAIDE NATIONALE DELEGATION TAOUNATE	0001916735072024	180	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
799	5.53231.12.00.100016	\N	ENTRAIDE NATIONALE DELEGATION TAOUNATE	0001674937082024	180	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
800	5.53231.12.00.100016	\N	ENTRAIDE NATIONALE DELEGATION TAOUNATE	0000544095092024	180	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
801	5.53231.12.00.100016	\N	ENTRAIDE NATIONALE DELEGATION TAOUNATE	0000863750102024	180	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
802	5.53231.12.00.100016	\N	ENTRAIDE NATIONALE DELEGATION TAOUNATE	0000626604112024	180	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
803	5.53231.12.00.100016	\N	ENTRAIDE NATIONALE DELEGATION TAOUNATE	0001694440122024	180	\N	30/11/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
804	5.53231.00.00.100116	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076361022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
805	5.53231.00.00.100116	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007076032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
806	5.53231.00.00.100116	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836726042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
807	5.53231.00.00.100116	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824295052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
808	5.53231.00.00.100116	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560960062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
809	5.53231.00.00.100116	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916568072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
810	5.53231.00.00.100116	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674770082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
811	5.53231.00.00.100116	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543929092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
812	5.53231.00.00.100116	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863583102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
813	5.53231.00.00.100116	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626436112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
928	5.53231.00.00.100325	\N	ENTRAIDE NATIONALE	0001824412052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
814	5.53231.00.00.100116	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694273122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
815	5.53231.00.00.100099	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076351022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
816	5.53231.00.00.100099	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007066032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
817	5.53231.00.00.100099	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836715042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
818	5.53231.00.00.100099	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824284052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
819	5.53231.00.00.100099	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560949062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
820	5.53231.00.00.100099	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916557072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
821	5.53231.00.00.100099	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674759082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
822	5.53231.00.00.100099	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543919092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
823	5.53231.00.00.100099	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863573102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
824	5.53231.00.00.100099	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626426112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
825	5.53231.00.00.100099	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694263122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
826	5.53231.00.00.100187	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076398022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
827	5.53231.00.00.100187	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007113032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
828	5.53231.00.00.100187	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836763042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
829	5.53231.00.00.100187	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824332052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
830	5.53231.00.00.100187	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560997062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
831	5.53231.00.00.100187	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916605072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
832	5.53231.00.00.100187	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674807082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
833	5.53231.00.00.100187	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543965092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
834	5.53231.00.00.100187	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863620102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
835	5.53231.00.00.100187	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626474112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
836	5.53231.00.00.100187	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694310122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
837	5.53231.00.00.100390	\N	ENTRAIDE NATIONALE 387 FEV 2017	0001076518022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
838	5.53231.00.00.100390	\N	ENTRAIDE NATIONALE 387 FEV 2017	0001007233032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
839	5.53231.00.00.100390	\N	ENTRAIDE NATIONALE 387 FEV 2017	0001836883042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
840	5.53231.00.00.100390	\N	ENTRAIDE NATIONALE 387 FEV 2017	0001824452052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
841	5.53231.00.00.100390	\N	ENTRAIDE NATIONALE 387 FEV 2017	0000561117062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
842	5.53231.00.00.100390	\N	ENTRAIDE NATIONALE 387 FEV 2017	0001916725072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
843	5.53231.00.00.100390	\N	ENTRAIDE NATIONALE 387 FEV 2017	0001674927082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
844	5.53231.00.00.100390	\N	ENTRAIDE NATIONALE 387 FEV 2017	0000544085092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
845	5.53231.00.00.100390	\N	ENTRAIDE NATIONALE 387 FEV 2017	0000863740102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
846	5.53231.00.00.100390	\N	ENTRAIDE NATIONALE 387 FEV 2017	0000626594112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
847	5.53231.00.00.100390	\N	ENTRAIDE NATIONALE 387 FEV 2017	0001694430122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
848	5.53231.00.00.100016	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076330022024	226.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
849	5.53231.00.00.100016	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007045032024	226.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
850	5.53231.00.00.100016	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836695042024	226.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
851	5.53231.00.00.100016	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824264052024	226.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
929	5.53231.00.00.100325	\N	ENTRAIDE NATIONALE	0000561077062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
852	5.53231.00.00.100016	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560928062024	226.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
853	5.53231.00.00.100016	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916536072024	226.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
854	5.53231.00.00.100016	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674739082024	226.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
855	5.53231.00.00.100016	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543898092024	226.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
856	5.53231.00.00.100016	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863553102024	226.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
857	5.53231.00.00.100016	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626405112024	226.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
858	5.53231.00.00.100016	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694241122024	226.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
859	5.53231.00.00.100397	\N	ENTRAIDE NATIONALE LETTRE 5703	0001076524022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
860	5.53231.00.00.100397	\N	ENTRAIDE NATIONALE LETTRE 5703	0001007239032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
861	5.53231.00.00.100397	\N	ENTRAIDE NATIONALE LETTRE 5703	0001836889042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
862	5.53231.00.00.100397	\N	ENTRAIDE NATIONALE LETTRE 5703	0001824458052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
863	5.53231.00.00.100397	\N	ENTRAIDE NATIONALE LETTRE 5703	0000561123062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
864	5.53231.00.00.100397	\N	ENTRAIDE NATIONALE LETTRE 5703	0001916731072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
865	5.53231.00.00.100397	\N	ENTRAIDE NATIONALE LETTRE 5703	0001674933082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
866	5.53231.00.00.100397	\N	ENTRAIDE NATIONALE LETTRE 5703	0000544091092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
867	5.53231.00.00.100397	\N	ENTRAIDE NATIONALE LETTRE 5703	0000863746102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
868	5.53231.00.00.100397	\N	ENTRAIDE NATIONALE LETTRE 5703	0000626600112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
869	5.53231.00.00.100397	\N	ENTRAIDE NATIONALE LETTRE 5703	0001694436122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
870	5.53231.00.00.100098	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076350022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
871	5.53231.00.00.100098	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007065032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
872	5.53231.00.00.100098	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836714042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
873	5.53231.00.00.100098	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824283052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
874	5.53231.00.00.100098	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560948062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
875	5.53231.00.00.100098	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916556072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
876	5.53231.00.00.100098	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674758082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
877	5.53231.00.00.100098	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543918092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
878	5.53231.00.00.100098	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863572102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
879	5.53231.00.00.100098	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626425112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
880	5.53231.00.00.100098	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694262122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
881	5.53231.00.00.100159	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076383022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
882	5.53231.00.00.100159	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007098032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
883	5.53231.00.00.100159	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836748042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
884	5.53231.00.00.100159	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824317052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
885	5.53231.00.00.100159	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560982062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
886	5.53231.00.00.100159	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916590072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
887	5.53231.00.00.100159	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674792082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
888	5.53231.00.00.100159	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543950092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
889	5.53231.00.00.100159	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863605102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
930	5.53231.00.00.100325	\N	ENTRAIDE NATIONALE	0001916685072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
890	5.53231.00.00.100159	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626459112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
891	5.53231.00.00.100159	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694295122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
892	5.53231.00.00.100110	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076356022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
893	5.53231.00.00.100110	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007071032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
894	5.53231.00.00.100110	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836721042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
895	5.53231.00.00.100110	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824290052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
896	5.53231.00.00.100110	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560955062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
897	5.53231.00.00.100110	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916563072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
898	5.53231.00.00.100110	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674765082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
899	5.53231.00.00.100110	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543924092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
900	5.53231.00.00.100110	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863578102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
901	5.53231.00.00.100110	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626431112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
902	5.53231.00.00.100110	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694268122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
903	5.53231.00.00.100205	\N	ADMINISTRATION GENERALE DE L'ENTRAIDE NA	0001076403022024	192	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
904	5.53231.00.00.100205	\N	ADMINISTRATION GENERALE DE L'ENTRAIDE NA	0001007118032024	192	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
905	5.53231.00.00.100205	\N	ADMINISTRATION GENERALE DE L'ENTRAIDE NA	0001836768042024	192	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
906	5.53231.00.00.100205	\N	ADMINISTRATION GENERALE DE L'ENTRAIDE NA	0001824337052024	192	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
907	5.53231.00.00.100205	\N	ADMINISTRATION GENERALE DE L'ENTRAIDE NA	0000561002062024	192	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
908	5.53231.00.00.100205	\N	ADMINISTRATION GENERALE DE L'ENTRAIDE NA	0001916610072024	192	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
909	5.53231.00.00.100205	\N	ADMINISTRATION GENERALE DE L'ENTRAIDE NA	0001674812082024	192	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
910	5.53231.00.00.100205	\N	ADMINISTRATION GENERALE DE L'ENTRAIDE NA	0000543970092024	192	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
911	5.53231.00.00.100205	\N	ADMINISTRATION GENERALE DE L'ENTRAIDE NA	0000863625102024	192	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
912	5.53231.00.00.100205	\N	ADMINISTRATION GENERALE DE L'ENTRAIDE NA	0000626479112024	192	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
913	5.53231.00.00.100205	\N	ADMINISTRATION GENERALE DE L'ENTRAIDE NA	0001694315122024	192	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
914	5.53231.00.00.100160	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076384022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
915	5.53231.00.00.100160	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007099032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
916	5.53231.00.00.100160	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836749042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
917	5.53231.00.00.100160	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824318052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
918	5.53231.00.00.100160	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560983062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
919	5.53231.00.00.100160	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916591072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
920	5.53231.00.00.100160	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674793082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
921	5.53231.00.00.100160	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543951092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
922	5.53231.00.00.100160	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863606102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
923	5.53231.00.00.100160	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626460112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
924	5.53231.00.00.100160	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694296122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
925	5.53231.00.00.100325	\N	ENTRAIDE NATIONALE	0001076478022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
926	5.53231.00.00.100325	\N	ENTRAIDE NATIONALE	0001007193032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
927	5.53231.00.00.100325	\N	ENTRAIDE NATIONALE	0001836843042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
931	5.53231.00.00.100325	\N	ENTRAIDE NATIONALE	0001674887082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
932	5.53231.00.00.100325	\N	ENTRAIDE NATIONALE	0000544045092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
933	5.53231.00.00.100325	\N	ENTRAIDE NATIONALE	0000863700102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
934	5.53231.00.00.100325	\N	ENTRAIDE NATIONALE	0000626554112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
935	5.53231.00.00.100325	\N	ENTRAIDE NATIONALE	0001694390122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
936	5.53231.00.00.100117	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076362022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
937	5.53231.00.00.100117	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007077032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
938	5.53231.00.00.100117	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836727042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
939	5.53231.00.00.100117	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824296052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
940	5.53231.00.00.100117	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560961062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
941	5.53231.00.00.100117	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916569072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
942	5.53231.00.00.100117	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674771082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
943	5.53231.00.00.100117	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543930092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
944	5.53231.00.00.100117	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863584102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
945	5.53231.00.00.100117	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626437112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
946	5.53231.00.00.100117	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694274122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
947	5.53231.00.00.100054	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076336022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
948	5.53231.00.00.100054	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007051032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
949	5.53231.00.00.100054	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836700042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
950	5.53231.00.00.100054	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824269052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
951	5.53231.00.00.100054	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560933062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
952	5.53231.00.00.100054	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916542072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
953	5.53231.00.00.100054	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674744082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
954	5.53231.00.00.100054	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543904092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
955	5.53231.00.00.100054	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863558102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
956	5.53231.00.00.100054	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626410112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
957	5.53231.00.00.100054	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694247122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
958	5.53231.00.00.100206	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076404022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
959	5.53231.00.00.100206	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007119032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
960	5.53231.00.00.100206	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836769042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
961	5.53231.00.00.100206	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824338052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
962	5.53231.00.00.100206	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000561003062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
963	5.53231.00.00.100206	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916611072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
964	5.53231.00.00.100206	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674813082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
965	5.53231.00.00.100206	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543971092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
966	5.53231.00.00.100206	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863626102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
967	5.53231.00.00.100206	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626480112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
968	5.53231.00.00.100206	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694316122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
969	5.53231.00.00.100070	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076338022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
970	5.53231.00.00.100070	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007053032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
971	5.53231.00.00.100070	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836702042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
972	5.53231.00.00.100070	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824271052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
973	5.53231.00.00.100070	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560935062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
974	5.53231.00.00.100070	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916544072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
975	5.53231.00.00.100070	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674746082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
976	5.53231.00.00.100070	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543906092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
977	5.53231.00.00.100070	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863560102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
978	5.53231.00.00.100070	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626412112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
979	5.53231.00.00.100070	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694249122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
980	5.53231.00.00.100087	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076343022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
981	5.53231.00.00.100087	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007058032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
982	5.53231.00.00.100087	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836707042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
983	5.53231.00.00.100087	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824276052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
984	5.53231.00.00.100087	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560940062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
985	5.53231.00.00.100087	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916549072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
986	5.53231.00.00.100087	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674751082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
987	5.53231.00.00.100087	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543911092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
988	5.53231.00.00.100087	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863565102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
989	5.53231.00.00.100087	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626417112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
990	5.53231.00.00.100087	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001694254122024	202.8	\N	30/11/2024	\N	reglee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
991	5.53231.00.00.100083	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001076341022024	202.8	\N	31/01/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
992	5.53231.00.00.100083	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001007056032024	202.8	\N	28/02/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
993	5.53231.00.00.100083	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001836705042024	202.8	\N	31/03/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
994	5.53231.00.00.100083	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001824274052024	202.8	\N	30/04/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
995	5.53231.00.00.100083	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000560938062024	202.8	\N	31/05/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
996	5.53231.00.00.100083	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001916547072024	202.8	\N	30/06/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
997	5.53231.00.00.100083	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0001674749082024	202.8	\N	31/07/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
998	5.53231.00.00.100083	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000543909092024	202.8	\N	31/08/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
999	5.53231.00.00.100083	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000863563102024	202.8	\N	30/09/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
1000	5.53231.00.00.100083	\N	ADMINISTRATION DE L'ENTRAIDE NATIONALE	0000626415112024	202.8	\N	31/10/2024	\N	impayee	Impayés entraide Nle 2024 (5).xlsx · Fix	\N	\N	\N	\N	\N	2026-07-16 12:35:42.097435	2026-07-16 12:35:42.097435
\.


--
-- Data for Name: journal_entries; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.journal_entries (id, direction, service, journal_1, journal_2, journal_3, deleted_at, deleted_by, created_at, updated_at) FROM stdin;
2	Direction	Direction	ASSABAH	AL AKHBAR		\N	\N	2026-07-22 15:46:52.860489	2026-07-22 15:46:52.860489
\.


--
-- Data for Name: lignes; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.lignes (id, categorie, type_forfait, type_mobile, icc, imei, affecte, personne, qualite, date, created_at, updated_at, civilite, deleted_at, deleted_by, pin, puk, service_id, consommation_mensuelle_dh) FROM stdin;
4	CAT 1	40G	IPHONE 13	34567	23456789	DIRECTION	ELHAIMER AMINE	Division du Patrimoine et de la Logistique	2026-07-14	2026-07-14 11:34:53.526812	2026-07-14 11:32:58.867	\N	\N	\N	\N	\N	\N	\N
1	CAT 1	30G	IPHONE	34567890	3456789	direction	ELHAIMER	Division du Patrimoine et de la Logistique	2026-07-13	2026-07-13 12:53:06.689556	2026-07-14 11:50:48.03	M.	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: lignes_fixes; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.lignes_fixes (id, nd, custcode, coordination_regionale, delegation, domiciliation, personne, qualite, date, deleted_at, deleted_by, created_at, updated_at, service_id, consommation_mensuelle_dh) FROM stdin;
1	0535660487	5.53231.00.00.100165	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
2	0535660487	5.53231.00.00.100165	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
3	0535660487	5.53231.00.00.100165	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
4	0535660487	5.53231.00.00.100165	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
5	0535660487	5.53231.00.00.100165	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
6	0535660487	5.53231.00.00.100165	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
7	0535660487	5.53231.00.00.100165	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
8	0535660487	5.53231.00.00.100165	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
9	0535660487	5.53231.00.00.100165	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
10	0535660487	5.53231.00.00.100165	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
11	0535660487	5.53231.00.00.100165	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
12	0539975355	5.53231.00.00.100164	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
13	0539975355	5.53231.00.00.100164	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
14	0539975355	5.53231.00.00.100164	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
15	0539975355	5.53231.00.00.100164	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
16	0539975355	5.53231.00.00.100164	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
17	0539975355	5.53231.00.00.100164	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
18	0539975355	5.53231.00.00.100164	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
19	0539975355	5.53231.00.00.100164	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
20	0539975355	5.53231.00.00.100164	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
21	0539975355	5.53231.00.00.100164	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
22	0539975355	5.53231.00.00.100164	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
23	0523284212	5.53231.00.00.100174	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
24	0523284212	5.53231.00.00.100174	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
25	0523284212	5.53231.00.00.100174	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
26	0523284212	5.53231.00.00.100174	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
27	0523284212	5.53231.00.00.100174	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
28	0523284212	5.53231.00.00.100174	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
29	0523284212	5.53231.00.00.100174	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
30	0523284212	5.53231.00.00.100174	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
31	0523284212	5.53231.00.00.100174	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
32	0523284212	5.53231.00.00.100174	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
33	0523284212	5.53231.00.00.100174	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
34	0524846152	5.53231.00.00.100161	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
35	0524846152	5.53231.00.00.100161	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
36	0524846152	5.53231.00.00.100161	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
37	0524846152	5.53231.00.00.100161	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
38	0524846152	5.53231.00.00.100161	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
39	0524846152	5.53231.00.00.100161	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
40	0524846152	5.53231.00.00.100161	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
41	0524846152	5.53231.00.00.100161	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
42	0524846152	5.53231.00.00.100161	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
43	0524846152	5.53231.00.00.100161	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
44	0524846152	5.53231.00.00.100161	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
45	0537708054	5.53231.00.00.100155	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
46	0537708054	5.53231.00.00.100155	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
47	0537708054	5.53231.00.00.100155	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
48	0537708054	5.53231.00.00.100155	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
49	0537708054	5.53231.00.00.100155	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
50	0537708054	5.53231.00.00.100155	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
51	0537708054	5.53231.00.00.100155	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
52	0537708054	5.53231.00.00.100155	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
53	0537708054	5.53231.00.00.100155	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
54	0537708054	5.53231.00.00.100155	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
55	0537708054	5.53231.00.00.100155	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
56	0528819068	5.53231.00.00.100153	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
57	0528819068	5.53231.00.00.100153	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
58	0528819068	5.53231.00.00.100153	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
59	0528819068	5.53231.00.00.100153	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
60	0528819068	5.53231.00.00.100153	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
61	0528819068	5.53231.00.00.100153	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
62	0528819068	5.53231.00.00.100153	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
63	0528819068	5.53231.00.00.100153	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
64	0528819068	5.53231.00.00.100153	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
65	0528819068	5.53231.00.00.100153	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
66	0528819068	5.53231.00.00.100153	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
67	0523458298	5.53231.00.00.100123	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
68	0523458298	5.53231.00.00.100123	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
69	0523458298	5.53231.00.00.100123	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
70	0523458298	5.53231.00.00.100123	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
71	0523458298	5.53231.00.00.100123	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
72	0523458298	5.53231.00.00.100123	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
73	0523458298	5.53231.00.00.100123	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
74	0523458298	5.53231.00.00.100123	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
75	0523458298	5.53231.00.00.100123	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
76	0523458298	5.53231.00.00.100123	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
77	0523458298	5.53231.00.00.100123	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
78	0535585379	5.53231.00.00.100114	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
79	0535585379	5.53231.00.00.100114	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
80	0535585379	5.53231.00.00.100114	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
81	0535585379	5.53231.00.00.100114	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
82	0535585379	5.53231.00.00.100114	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
83	0535585379	5.53231.00.00.100114	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
84	0535585379	5.53231.00.00.100114	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
85	0535585379	5.53231.00.00.100114	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
86	0535585379	5.53231.00.00.100114	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
87	0535585379	5.53231.00.00.100114	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
88	0535585379	5.53231.00.00.100114	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
89	0535282381	5.53231.00.00.100108	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
90	0535282381	5.53231.00.00.100108	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
91	0535282381	5.53231.00.00.100108	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
92	0535282381	5.53231.00.00.100108	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
93	0535282381	5.53231.00.00.100108	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
94	0535282381	5.53231.00.00.100108	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
95	0535282381	5.53231.00.00.100108	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
96	0535282381	5.53231.00.00.100108	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
97	0535282381	5.53231.00.00.100108	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
98	0535282381	5.53231.00.00.100108	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
99	0535282381	5.53231.00.00.100108	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
100	0528897094	5.53231.00.00.100105	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
101	0528897094	5.53231.00.00.100105	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
102	0528897094	5.53231.00.00.100105	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
103	0528897094	5.53231.00.00.100105	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
104	0528897094	5.53231.00.00.100105	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
105	0528897094	5.53231.00.00.100105	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
106	0528897094	5.53231.00.00.100105	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
107	0528897094	5.53231.00.00.100105	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
108	0528897094	5.53231.00.00.100105	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
109	0528897094	5.53231.00.00.100105	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
110	0528897094	5.53231.00.00.100105	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
111	0524882474	5.53231.00.00.100094	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
112	0524882474	5.53231.00.00.100094	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
113	0524882474	5.53231.00.00.100094	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
114	0524882474	5.53231.00.00.100094	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
115	0524882474	5.53231.00.00.100094	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
116	0524882474	5.53231.00.00.100094	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
117	0524882474	5.53231.00.00.100094	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
118	0524882474	5.53231.00.00.100094	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
119	0524882474	5.53231.00.00.100094	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
120	0524882474	5.53231.00.00.100094	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
121	0524882474	5.53231.00.00.100094	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
122	0524621242	5.53231.00.00.100092	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
123	0524621242	5.53231.00.00.100092	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
124	0524621242	5.53231.00.00.100092	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
125	0524621242	5.53231.00.00.100092	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
126	0524621242	5.53231.00.00.100092	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
127	0524621242	5.53231.00.00.100092	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
128	0524621242	5.53231.00.00.100092	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
129	0524621242	5.53231.00.00.100092	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
130	0524621242	5.53231.00.00.100092	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
131	0524621242	5.53231.00.00.100092	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
132	0524621242	5.53231.00.00.100092	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
133	0539318634	5.53231.00.00.100079	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
134	0539318634	5.53231.00.00.100079	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
135	0539318634	5.53231.00.00.100079	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
136	0539318634	5.53231.00.00.100079	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
137	0539318634	5.53231.00.00.100079	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
138	0539318634	5.53231.00.00.100079	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
139	0539318634	5.53231.00.00.100079	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
140	0539318634	5.53231.00.00.100079	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
141	0539318634	5.53231.00.00.100079	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
142	0539318634	5.53231.00.00.100079	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
143	0539318634	5.53231.00.00.100079	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
144	0537552785	5.53231.00.00.100053	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
145	0537552785	5.53231.00.00.100053	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
146	0537552785	5.53231.00.00.100053	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
147	0537552785	5.53231.00.00.100053	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
148	0537552785	5.53231.00.00.100053	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
149	0537552785	5.53231.00.00.100053	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
150	0537552785	5.53231.00.00.100053	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
151	0537552785	5.53231.00.00.100053	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
152	0537552785	5.53231.00.00.100053	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
153	0537552785	5.53231.00.00.100053	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
154	0537552785	5.53231.00.00.100053	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
155	0537704329	5.53231.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
156	0537704329	5.53231.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
157	0537704329	5.53231.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
158	0537704329	5.53231.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
159	0537704329	5.53231.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
160	0537704329	5.53231.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
161	0537704329	5.53231.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
162	0537704329	5.53231.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
163	0537704329	5.53231.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
164	0537704329	5.53231.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
165	0537704329	5.53231.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
166	0537734433	5.53231.00.00.100001	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
167	0537734433	5.53231.00.00.100001	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
168	0537734433	5.53231.00.00.100001	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
169	0537734433	5.53231.00.00.100001	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
170	0537734433	5.53231.00.00.100001	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
171	0537734433	5.53231.00.00.100001	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
172	0537734433	5.53231.00.00.100001	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
173	0537734433	5.53231.00.00.100001	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
174	0537734433	5.53231.00.00.100001	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
175	0537734433	5.53231.00.00.100001	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
176	0537734433	5.53231.00.00.100001	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
177	0536693832	5.53231.00.00.100323	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
178	0536693832	5.53231.00.00.100323	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
179	0536693832	5.53231.00.00.100323	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
180	0536693832	5.53231.00.00.100323	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
181	0536693832	5.53231.00.00.100323	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
182	0536693832	5.53231.00.00.100323	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
183	0536693832	5.53231.00.00.100323	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
184	0536693832	5.53231.00.00.100323	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
185	0536693832	5.53231.00.00.100323	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
186	0536693832	5.53231.00.00.100323	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
187	0536693832	5.53231.00.00.100323	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
188	0522590615	5.53231.00.00.100207	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
189	0522590615	5.53231.00.00.100207	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
190	0522590615	5.53231.00.00.100207	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
191	0522590615	5.53231.00.00.100207	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
192	0522590615	5.53231.00.00.100207	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
193	0522590615	5.53231.00.00.100207	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
194	0522590615	5.53231.00.00.100207	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
195	0522590615	5.53231.00.00.100207	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
196	0522590615	5.53231.00.00.100207	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
197	0522590615	5.53231.00.00.100207	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
198	0522590615	5.53231.00.00.100207	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
199	0522534560	5.53231.00.00.100341	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
200	0522534560	5.53231.00.00.100341	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
201	0522534560	5.53231.00.00.100341	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
202	0522534560	5.53231.00.00.100341	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
203	0522534560	5.53231.00.00.100341	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
204	0522534560	5.53231.00.00.100341	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
205	0522534560	5.53231.00.00.100341	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
206	0522534560	5.53231.00.00.100341	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
207	0522534560	5.53231.00.00.100341	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
208	0522534560	5.53231.00.00.100341	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
209	0522534560	5.53231.00.00.100341	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
210	0524649763	5.53231.00.00.100367	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
211	0524649763	5.53231.00.00.100367	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
212	0524649763	5.53231.00.00.100367	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
213	0524649763	5.53231.00.00.100367	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
214	0524649763	5.53231.00.00.100367	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
215	0524649763	5.53231.00.00.100367	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
216	0524649763	5.53231.00.00.100367	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
217	0524649763	5.53231.00.00.100367	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
218	0524649763	5.53231.00.00.100367	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
219	0524649763	5.53231.00.00.100367	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
220	0524649763	5.53231.00.00.100367	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
221	0522635141	5.53231.00.00.100382	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
222	0522635141	5.53231.00.00.100382	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
223	0522635141	5.53231.00.00.100382	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
224	0522635141	5.53231.00.00.100382	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
225	0522635141	5.53231.00.00.100382	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
226	0522635141	5.53231.00.00.100382	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
227	0522635141	5.53231.00.00.100382	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
228	0522635141	5.53231.00.00.100382	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
229	0522635141	5.53231.00.00.100382	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
230	0522635141	5.53231.00.00.100382	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
231	0522635141	5.53231.00.00.100382	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
232	0535962266	5.53231.00.00.100162	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
233	0535962266	5.53231.00.00.100162	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
234	0535962266	5.53231.00.00.100162	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
235	0535962266	5.53231.00.00.100162	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
236	0535962266	5.53231.00.00.100162	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
237	0535962266	5.53231.00.00.100162	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
238	0535962266	5.53231.00.00.100162	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
239	0535962266	5.53231.00.00.100162	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
240	0535962266	5.53231.00.00.100162	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
241	0535962266	5.53231.00.00.100162	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
242	0535962266	5.53231.00.00.100162	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
243	0536611831	5.53231.00.00.100166	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
244	0536611831	5.53231.00.00.100166	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
245	0536611831	5.53231.00.00.100166	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
246	0536611831	5.53231.00.00.100166	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
247	0536611831	5.53231.00.00.100166	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
248	0536611831	5.53231.00.00.100166	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
249	0536611831	5.53231.00.00.100166	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
250	0536611831	5.53231.00.00.100166	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
251	0536611831	5.53231.00.00.100166	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
252	0536611831	5.53231.00.00.100166	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
253	0536611831	5.53231.00.00.100166	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
254	0528887261	5.53231.00.00.100177	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
255	0528887261	5.53231.00.00.100177	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
256	0528887261	5.53231.00.00.100177	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
257	0528887261	5.53231.00.00.100177	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
258	0528887261	5.53231.00.00.100177	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
259	0528887261	5.53231.00.00.100177	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
260	0528887261	5.53231.00.00.100177	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
261	0528887261	5.53231.00.00.100177	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
262	0528887261	5.53231.00.00.100177	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
263	0528887261	5.53231.00.00.100177	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
264	0528887261	5.53231.00.00.100177	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
265	0528998336	5.53231.00.00.100178	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
266	0528998336	5.53231.00.00.100178	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
267	0528998336	5.53231.00.00.100178	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
268	0528998336	5.53231.00.00.100178	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
269	0528998336	5.53231.00.00.100178	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
270	0528998336	5.53231.00.00.100178	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
271	0528998336	5.53231.00.00.100178	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
272	0528998336	5.53231.00.00.100178	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
273	0528998336	5.53231.00.00.100178	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
274	0528998336	5.53231.00.00.100178	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
275	0528998336	5.53231.00.00.100178	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
276	0522271923	7.1830754.00.00.100012	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
277	0522271923	7.1830754.00.00.100012	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
278	0522271923	7.1830754.00.00.100012	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
279	0522271923	7.1830754.00.00.100012	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
280	0522271923	7.1830754.00.00.100012	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
281	0522271923	7.1830754.00.00.100012	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
282	0522271923	7.1830754.00.00.100012	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
283	0522271923	7.1830754.00.00.100012	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
284	0522271923	7.1830754.00.00.100012	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
285	0522271923	7.1830754.00.00.100012	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
286	0522271923	7.1830754.00.00.100012	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
287	0522902005	7.1830754.00.00.100009	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
288	0522902005	7.1830754.00.00.100009	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
289	0522902005	7.1830754.00.00.100009	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
290	0522902005	7.1830754.00.00.100009	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
291	0522902005	7.1830754.00.00.100009	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
292	0522902005	7.1830754.00.00.100009	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
293	0522902005	7.1830754.00.00.100009	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
294	0522902005	7.1830754.00.00.100009	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
295	0522902005	7.1830754.00.00.100009	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
296	0522902005	7.1830754.00.00.100009	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
297	0522902005	7.1830754.00.00.100009	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
298	0528700023	5.53231.00.00.100096	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
299	0528700023	5.53231.00.00.100096	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
300	0528700023	5.53231.00.00.100096	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
301	0528700023	5.53231.00.00.100096	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
302	0528700023	5.53231.00.00.100096	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
303	0528700023	5.53231.00.00.100096	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
304	0528700023	5.53231.00.00.100096	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
305	0528700023	5.53231.00.00.100096	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
306	0528700023	5.53231.00.00.100096	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
307	0528700023	5.53231.00.00.100096	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
308	0528700023	5.53231.00.00.100096	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
309	0524784712	5.53231.00.00.100093	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
310	0524784712	5.53231.00.00.100093	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
311	0524784712	5.53231.00.00.100093	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
312	0524784712	5.53231.00.00.100093	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
313	0524784712	5.53231.00.00.100093	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
314	0524784712	5.53231.00.00.100093	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
315	0524784712	5.53231.00.00.100093	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
316	0524784712	5.53231.00.00.100093	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
317	0524784712	5.53231.00.00.100093	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
318	0524784712	5.53231.00.00.100093	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
319	0524784712	5.53231.00.00.100093	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
320	0524484013	5.53231.00.00.100091	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
321	0524484013	5.53231.00.00.100091	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
322	0524484013	5.53231.00.00.100091	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
323	0524484013	5.53231.00.00.100091	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
324	0524484013	5.53231.00.00.100091	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
325	0524484013	5.53231.00.00.100091	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
326	0524484013	5.53231.00.00.100091	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
327	0524484013	5.53231.00.00.100091	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
328	0524484013	5.53231.00.00.100091	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
329	0524484013	5.53231.00.00.100091	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
330	0524484013	5.53231.00.00.100091	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
331	0524304915	5.53231.00.00.100084	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
332	0524304915	5.53231.00.00.100084	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
333	0524304915	5.53231.00.00.100084	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
334	0524304915	5.53231.00.00.100084	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
335	0524304915	5.53231.00.00.100084	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
336	0524304915	5.53231.00.00.100084	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
337	0524304915	5.53231.00.00.100084	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
338	0524304915	5.53231.00.00.100084	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
339	0524304915	5.53231.00.00.100084	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
340	0524304915	5.53231.00.00.100084	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
341	0524304915	5.53231.00.00.100084	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
342	0523482813	5.53231.00.00.100082	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
343	0523482813	5.53231.00.00.100082	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
344	0523482813	5.53231.00.00.100082	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
345	0523482813	5.53231.00.00.100082	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
346	0523482813	5.53231.00.00.100082	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
347	0523482813	5.53231.00.00.100082	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
348	0523482813	5.53231.00.00.100082	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
349	0523482813	5.53231.00.00.100082	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
350	0523482813	5.53231.00.00.100082	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
351	0523482813	5.53231.00.00.100082	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
352	0523482813	5.53231.00.00.100082	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
353	0539986781	5.53231.00.00.100068	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
354	0539986781	5.53231.00.00.100068	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
355	0539986781	5.53231.00.00.100068	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
356	0539986781	5.53231.00.00.100068	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
357	0539986781	5.53231.00.00.100068	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
358	0539986781	5.53231.00.00.100068	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
359	0539986781	5.53231.00.00.100068	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
360	0539986781	5.53231.00.00.100068	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
361	0539986781	5.53231.00.00.100068	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
362	0539986781	5.53231.00.00.100068	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
363	0539986781	5.53231.00.00.100068	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
364	0537372816	5.53231.00.00.100052	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
365	0537372816	5.53231.00.00.100052	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
366	0537372816	5.53231.00.00.100052	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
367	0537372816	5.53231.00.00.100052	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
368	0537372816	5.53231.00.00.100052	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
369	0537372816	5.53231.00.00.100052	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
370	0537372816	5.53231.00.00.100052	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
371	0537372816	5.53231.00.00.100052	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
372	0537372816	5.53231.00.00.100052	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
373	0537372816	5.53231.00.00.100052	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
374	0537372816	5.53231.00.00.100052	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
375	0537690947	5.53231.00.00.100019	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
376	0537690947	5.53231.00.00.100019	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
377	0537690947	5.53231.00.00.100019	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
378	0537690947	5.53231.00.00.100019	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
379	0537690947	5.53231.00.00.100019	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
380	0537690947	5.53231.00.00.100019	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
381	0537690947	5.53231.00.00.100019	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
382	0537690947	5.53231.00.00.100019	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
383	0537690947	5.53231.00.00.100019	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
384	0537690947	5.53231.00.00.100019	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
385	0537690947	5.53231.00.00.100019	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
386	0537701998	5.53231.00.00.100013	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
387	0537701998	5.53231.00.00.100013	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
388	0537701998	5.53231.00.00.100013	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
389	0537701998	5.53231.00.00.100013	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
390	0537701998	5.53231.00.00.100013	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
391	0537701998	5.53231.00.00.100013	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
392	0537701998	5.53231.00.00.100013	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
393	0537701998	5.53231.00.00.100013	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
394	0537701998	5.53231.00.00.100013	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
395	0537701998	5.53231.00.00.100013	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
396	0537701998	5.53231.00.00.100013	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
397	0537770607	5.53231.00.00.100007	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
398	0537770607	5.53231.00.00.100007	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
399	0537770607	5.53231.00.00.100007	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
400	0537770607	5.53231.00.00.100007	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
401	0537770607	5.53231.00.00.100007	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
402	0537770607	5.53231.00.00.100007	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
403	0537770607	5.53231.00.00.100007	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
404	0537770607	5.53231.00.00.100007	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
405	0537770607	5.53231.00.00.100007	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
406	0537770607	5.53231.00.00.100007	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
407	0537770607	5.53231.00.00.100007	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
408	0528893728	5.53231.00.00.100154	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
409	0528893728	5.53231.00.00.100154	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
410	0528893728	5.53231.00.00.100154	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
411	0528893728	5.53231.00.00.100154	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
412	0528893728	5.53231.00.00.100154	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
413	0528893728	5.53231.00.00.100154	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
414	0528893728	5.53231.00.00.100154	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
415	0528893728	5.53231.00.00.100154	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
416	0528893728	5.53231.00.00.100154	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
417	0528893728	5.53231.00.00.100154	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
418	0528893728	5.53231.00.00.100154	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
419	0528899052	5.53231.00.00.100151	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
420	0528899052	5.53231.00.00.100151	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
421	0528899052	5.53231.00.00.100151	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
422	0528899052	5.53231.00.00.100151	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
423	0528899052	5.53231.00.00.100151	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
424	0528899052	5.53231.00.00.100151	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
425	0528899052	5.53231.00.00.100151	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
426	0528899052	5.53231.00.00.100151	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
427	0528899052	5.53231.00.00.100151	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
428	0528899052	5.53231.00.00.100151	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
429	0528899052	5.53231.00.00.100151	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
430	0522555974	5.53231.00.00.100150	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
431	0522555974	5.53231.00.00.100150	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
432	0522555974	5.53231.00.00.100150	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
433	0522555974	5.53231.00.00.100150	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
434	0522555974	5.53231.00.00.100150	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
435	0522555974	5.53231.00.00.100150	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
436	0522555974	5.53231.00.00.100150	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
437	0522555974	5.53231.00.00.100150	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
438	0522555974	5.53231.00.00.100150	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
439	0522555974	5.53231.00.00.100150	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
440	0522555974	5.53231.00.00.100150	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
441	0535541632	5.53231.00.00.100145	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
442	0535541632	5.53231.00.00.100145	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
443	0535541632	5.53231.00.00.100145	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
444	0535541632	5.53231.00.00.100145	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
445	0535541632	5.53231.00.00.100145	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
446	0535541632	5.53231.00.00.100145	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
447	0535541632	5.53231.00.00.100145	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
448	0535541632	5.53231.00.00.100145	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
449	0535541632	5.53231.00.00.100145	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
450	0535541632	5.53231.00.00.100145	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
451	0535541632	5.53231.00.00.100145	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
452	0523342465	5.53231.00.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
453	0523342465	5.53231.00.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
454	0523342465	5.53231.00.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
455	0523342465	5.53231.00.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
456	0523342465	5.53231.00.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
457	0523342465	5.53231.00.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
458	0523342465	5.53231.00.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
459	0523342465	5.53231.00.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
460	0523342465	5.53231.00.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
461	0523342465	5.53231.00.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
462	0523342465	5.53231.00.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
463	0537592915	5.53231.00.00.100139	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
464	0537592915	5.53231.00.00.100139	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
465	0537592915	5.53231.00.00.100139	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
466	0537592915	5.53231.00.00.100139	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
467	0537592915	5.53231.00.00.100139	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
468	0537592915	5.53231.00.00.100139	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
469	0537592915	5.53231.00.00.100139	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
470	0537592915	5.53231.00.00.100139	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
471	0537592915	5.53231.00.00.100139	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
472	0537592915	5.53231.00.00.100139	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
473	0537592915	5.53231.00.00.100139	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
474	0539914911	5.53231.00.00.100126	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
475	0539914911	5.53231.00.00.100126	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
476	0539914911	5.53231.00.00.100126	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
477	0539914911	5.53231.00.00.100126	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
478	0539914911	5.53231.00.00.100126	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
479	0539914911	5.53231.00.00.100126	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
480	0539914911	5.53231.00.00.100126	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
481	0539914911	5.53231.00.00.100126	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
482	0539914911	5.53231.00.00.100126	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
483	0539914911	5.53231.00.00.100126	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
484	0539914911	5.53231.00.00.100126	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
485	0536606082	5.53231.00.00.100119	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
486	0536606082	5.53231.00.00.100119	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
487	0536606082	5.53231.00.00.100119	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
488	0536606082	5.53231.00.00.100119	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
489	0536606082	5.53231.00.00.100119	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
490	0536606082	5.53231.00.00.100119	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
491	0536606082	5.53231.00.00.100119	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
492	0536606082	5.53231.00.00.100119	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
493	0536606082	5.53231.00.00.100119	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
494	0536606082	5.53231.00.00.100119	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
495	0536606082	5.53231.00.00.100119	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
496	0535586953	5.53231.00.00.100115	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
497	0535586953	5.53231.00.00.100115	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
498	0535586953	5.53231.00.00.100115	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
499	0535586953	5.53231.00.00.100115	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
500	0535586953	5.53231.00.00.100115	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
501	0535586953	5.53231.00.00.100115	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
502	0535586953	5.53231.00.00.100115	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
503	0535586953	5.53231.00.00.100115	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
504	0535586953	5.53231.00.00.100115	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
505	0535586953	5.53231.00.00.100115	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
506	0535586953	5.53231.00.00.100115	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
507	0535566154	5.53231.00.00.100111	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
508	0535566154	5.53231.00.00.100111	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
509	0535566154	5.53231.00.00.100111	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
510	0535566154	5.53231.00.00.100111	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
511	0535566154	5.53231.00.00.100111	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
512	0535566154	5.53231.00.00.100111	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
513	0535566154	5.53231.00.00.100111	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
514	0535566154	5.53231.00.00.100111	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
515	0535566154	5.53231.00.00.100111	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
516	0535566154	5.53231.00.00.100111	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
517	0535566154	5.53231.00.00.100111	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
518	0528896789	5.53231.00.00.100104	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
519	0528896789	5.53231.00.00.100104	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
520	0528896789	5.53231.00.00.100104	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
521	0528896789	5.53231.00.00.100104	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
522	0528896789	5.53231.00.00.100104	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
523	0528896789	5.53231.00.00.100104	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
524	0528896789	5.53231.00.00.100104	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
525	0528896789	5.53231.00.00.100104	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
526	0528896789	5.53231.00.00.100104	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
527	0528896789	5.53231.00.00.100104	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
528	0528896789	5.53231.00.00.100104	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
529	0528802049	5.53231.00.00.100097	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
530	0528802049	5.53231.00.00.100097	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
531	0528802049	5.53231.00.00.100097	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
532	0528802049	5.53231.00.00.100097	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
533	0528802049	5.53231.00.00.100097	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
534	0528802049	5.53231.00.00.100097	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
535	0528802049	5.53231.00.00.100097	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
536	0528802049	5.53231.00.00.100097	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
537	0528802049	5.53231.00.00.100097	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
538	0528802049	5.53231.00.00.100097	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
539	0528802049	5.53231.00.00.100097	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
540	0522734549	5.53231.00.00.100163	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
541	0522734549	5.53231.00.00.100163	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
542	0522734549	5.53231.00.00.100163	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
543	0522734549	5.53231.00.00.100163	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
544	0522734549	5.53231.00.00.100163	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
545	0522734549	5.53231.00.00.100163	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
546	0522734549	5.53231.00.00.100163	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
547	0522734549	5.53231.00.00.100163	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
548	0522734549	5.53231.00.00.100163	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
549	0522734549	5.53231.00.00.100163	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
550	0522734549	5.53231.00.00.100163	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
551	0539333413	5.53231.13.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
552	0539333413	5.53231.13.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
553	0539333413	5.53231.13.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
554	0539333413	5.53231.13.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
555	0539333413	5.53231.13.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
556	0539333413	5.53231.13.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
557	0539333413	5.53231.13.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
558	0539333413	5.53231.13.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
559	0539333413	5.53231.13.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
560	0539333413	5.53231.13.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
561	0539333413	5.53231.13.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
562	0528877974	5.53231.00.00.100190	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
563	0528877974	5.53231.00.00.100190	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
564	0528877974	5.53231.00.00.100190	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
565	0528877974	5.53231.00.00.100190	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
566	0528877974	5.53231.00.00.100190	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
567	0528877974	5.53231.00.00.100190	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
568	0528877974	5.53231.00.00.100190	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
569	0528877974	5.53231.00.00.100190	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
570	0528877974	5.53231.00.00.100190	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
571	0528877974	5.53231.00.00.100190	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
572	0528877974	5.53231.00.00.100190	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
573	0528980059	5.53231.00.00.100194	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
574	0528980059	5.53231.00.00.100194	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
575	0528980059	5.53231.00.00.100194	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
576	0528980059	5.53231.00.00.100194	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
577	0528980059	5.53231.00.00.100194	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
578	0528980059	5.53231.00.00.100194	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
579	0528980059	5.53231.00.00.100194	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
580	0528980059	5.53231.00.00.100194	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
581	0528980059	5.53231.00.00.100194	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
582	0528980059	5.53231.00.00.100194	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
583	0528980059	5.53231.00.00.100194	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
584	0522714623	5.53231.00.00.100202	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
585	0522714623	5.53231.00.00.100202	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
586	0522714623	5.53231.00.00.100202	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
587	0522714623	5.53231.00.00.100202	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
588	0522714623	5.53231.00.00.100202	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
589	0522714623	5.53231.00.00.100202	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
590	0522714623	5.53231.00.00.100202	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
591	0522714623	5.53231.00.00.100202	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
592	0522714623	5.53231.00.00.100202	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
593	0522714623	5.53231.00.00.100202	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
594	0522714623	5.53231.00.00.100202	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
595	0808546340	5.53231.13.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
596	0808546340	5.53231.13.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
597	0808546340	5.53231.13.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
598	0808546340	5.53231.13.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
599	0808546340	5.53231.13.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
600	0808546340	5.53231.13.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
601	0808546340	5.53231.13.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
602	0808546340	5.53231.13.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
603	0808546340	5.53231.13.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
604	0808546340	5.53231.13.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
605	0808546340	5.53231.13.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
606	0535595234	5.53231.12.00.100030	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
607	0535595234	5.53231.12.00.100030	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
608	0535595234	5.53231.12.00.100030	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
609	0535595234	5.53231.12.00.100030	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
610	0535595234	5.53231.12.00.100030	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
611	0535595234	5.53231.12.00.100030	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
612	0535595234	5.53231.12.00.100030	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
613	0535595234	5.53231.12.00.100030	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
614	0535595234	5.53231.12.00.100030	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
615	0535595234	5.53231.12.00.100030	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
616	0535595234	5.53231.12.00.100030	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
617	0522856947	5.53231.00.00.100320	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
618	0522856947	5.53231.00.00.100320	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
619	0522856947	5.53231.00.00.100320	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
620	0522856947	5.53231.00.00.100320	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
621	0522856947	5.53231.00.00.100320	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
622	0522856947	5.53231.00.00.100320	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
623	0522856947	5.53231.00.00.100320	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
624	0522856947	5.53231.00.00.100320	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
625	0522856947	5.53231.00.00.100320	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
626	0522856947	5.53231.00.00.100320	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
627	0522856947	5.53231.00.00.100320	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
628	0528930240	5.53231.00.00.100370	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
629	0528930240	5.53231.00.00.100370	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
630	0528930240	5.53231.00.00.100370	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
631	0528930240	5.53231.00.00.100370	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
632	0528930240	5.53231.00.00.100370	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
633	0528930240	5.53231.00.00.100370	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
634	0528930240	5.53231.00.00.100370	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
635	0528930240	5.53231.00.00.100370	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
636	0528930240	5.53231.00.00.100370	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
637	0528930240	5.53231.00.00.100370	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
638	0528930240	5.53231.00.00.100370	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
639	0536362352	5.53231.00.00.100388	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
640	0536362352	5.53231.00.00.100388	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
641	0536362352	5.53231.00.00.100388	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
642	0536362352	5.53231.00.00.100388	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
643	0536362352	5.53231.00.00.100388	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
644	0536362352	5.53231.00.00.100388	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
645	0536362352	5.53231.00.00.100388	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
646	0536362352	5.53231.00.00.100388	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
647	0536362352	5.53231.00.00.100388	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
648	0536362352	5.53231.00.00.100388	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
649	0536362352	5.53231.00.00.100388	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
650	0537909739	5.53231.00.00.100345	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
651	0537909739	5.53231.00.00.100345	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
652	0537909739	5.53231.00.00.100345	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
653	0537909739	5.53231.00.00.100345	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
654	0537909739	5.53231.00.00.100345	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
655	0537909739	5.53231.00.00.100345	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
656	0537909739	5.53231.00.00.100345	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
657	0537909739	5.53231.00.00.100345	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
658	0537909739	5.53231.00.00.100345	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
659	0537909739	5.53231.00.00.100345	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
660	0537909739	5.53231.00.00.100345	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
661	0523369398	5.53231.00.00.100354	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
662	0523369398	5.53231.00.00.100354	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
663	0523369398	5.53231.00.00.100354	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
664	0523369398	5.53231.00.00.100354	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
665	0523369398	5.53231.00.00.100354	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
666	0523369398	5.53231.00.00.100354	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
667	0523369398	5.53231.00.00.100354	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
668	0523369398	5.53231.00.00.100354	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
669	0523369398	5.53231.00.00.100354	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
670	0523369398	5.53231.00.00.100354	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
671	0523369398	5.53231.00.00.100354	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
672	0524318074	5.53231.00.00.100348	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
673	0524318074	5.53231.00.00.100348	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
674	0524318074	5.53231.00.00.100348	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
675	0524318074	5.53231.00.00.100348	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
676	0524318074	5.53231.00.00.100348	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
677	0524318074	5.53231.00.00.100348	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
678	0524318074	5.53231.00.00.100348	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
679	0524318074	5.53231.00.00.100348	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
680	0524318074	5.53231.00.00.100348	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
681	0524318074	5.53231.00.00.100348	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
682	0524318074	5.53231.00.00.100348	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
683	0523438926	5.53231.00.00.100350	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
684	0523438926	5.53231.00.00.100350	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
685	0523438926	5.53231.00.00.100350	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
686	0523438926	5.53231.00.00.100350	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
687	0523438926	5.53231.00.00.100350	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
688	0523438926	5.53231.00.00.100350	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
689	0523438926	5.53231.00.00.100350	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
690	0523438926	5.53231.00.00.100350	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
691	0523438926	5.53231.00.00.100350	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
692	0523438926	5.53231.00.00.100350	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
693	0523438926	5.53231.00.00.100350	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
694	0535360798	5.53231.00.00.100352	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
695	0535360798	5.53231.00.00.100352	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
696	0535360798	5.53231.00.00.100352	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
697	0535360798	5.53231.00.00.100352	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
698	0535360798	5.53231.00.00.100352	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
699	0535360798	5.53231.00.00.100352	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
700	0535360798	5.53231.00.00.100352	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
701	0535360798	5.53231.00.00.100352	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
702	0535360798	5.53231.00.00.100352	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
703	0535360798	5.53231.00.00.100352	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
704	0535360798	5.53231.00.00.100352	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
705	0536367854	5.53231.00.00.100342	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
706	0536367854	5.53231.00.00.100342	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
707	0536367854	5.53231.00.00.100342	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
708	0536367854	5.53231.00.00.100342	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
709	0536367854	5.53231.00.00.100342	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
710	0536367854	5.53231.00.00.100342	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
711	0536367854	5.53231.00.00.100342	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
712	0536367854	5.53231.00.00.100342	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
713	0536367854	5.53231.00.00.100342	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
714	0536367854	5.53231.00.00.100342	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
715	0536367854	5.53231.00.00.100342	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
716	0528895581	5.53231.00.00.100362	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
717	0528895581	5.53231.00.00.100362	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
718	0528895581	5.53231.00.00.100362	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
719	0528895581	5.53231.00.00.100362	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
720	0528895581	5.53231.00.00.100362	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
721	0528895581	5.53231.00.00.100362	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
722	0528895581	5.53231.00.00.100362	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
723	0528895581	5.53231.00.00.100362	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
724	0528895581	5.53231.00.00.100362	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
725	0528895581	5.53231.00.00.100362	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
726	0528895581	5.53231.00.00.100362	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
727	0537512154	5.53231.00.00.100395	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
728	0537512154	5.53231.00.00.100395	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
729	0537512154	5.53231.00.00.100395	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
730	0537512154	5.53231.00.00.100395	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
731	0537512154	5.53231.00.00.100395	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
732	0537512154	5.53231.00.00.100395	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
733	0537512154	5.53231.00.00.100395	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
734	0537512154	5.53231.00.00.100395	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
735	0537512154	5.53231.00.00.100395	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
736	0537512154	5.53231.00.00.100395	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
737	0537512154	5.53231.00.00.100395	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
738	0808681004	5.53231.00.00.100517	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
739	0808681004	5.53231.00.00.100517	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
740	0808681004	5.53231.00.00.100517	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
741	0808681004	5.53231.00.00.100517	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
742	0808681004	5.53231.00.00.100517	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
743	0808681004	5.53231.00.00.100517	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
744	0808681004	5.53231.00.00.100517	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
745	0808681004	5.53231.00.00.100517	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
746	0808681004	5.53231.00.00.100517	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
747	0808681004	5.53231.00.00.100517	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
748	0808681004	5.53231.00.00.100517	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
749	0537500305	5.53231.00.00.100356	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
750	0537500305	5.53231.00.00.100356	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
751	0537500305	5.53231.00.00.100356	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
752	0537500305	5.53231.00.00.100356	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
753	0537500305	5.53231.00.00.100356	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
754	0537500305	5.53231.00.00.100356	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
755	0537500305	5.53231.00.00.100356	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
756	0537500305	5.53231.00.00.100356	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
757	0537500305	5.53231.00.00.100356	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
758	0537500305	5.53231.00.00.100356	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
759	0537500305	5.53231.00.00.100356	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
760	0522474894	5.53231.00.00.100376	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
761	0522474894	5.53231.00.00.100376	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
762	0522474894	5.53231.00.00.100376	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
763	0522474894	5.53231.00.00.100376	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
764	0522474894	5.53231.00.00.100376	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
765	0522474894	5.53231.00.00.100376	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
766	0522474894	5.53231.00.00.100376	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
767	0522474894	5.53231.00.00.100376	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
768	0522474894	5.53231.00.00.100376	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
769	0522474894	5.53231.00.00.100376	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
770	0522474894	5.53231.00.00.100376	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
771	0536683998	5.53231.00.00.100386	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
772	0536683998	5.53231.00.00.100386	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
773	0536683998	5.53231.00.00.100386	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
774	0536683998	5.53231.00.00.100386	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
775	0536683998	5.53231.00.00.100386	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
776	0536683998	5.53231.00.00.100386	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
777	0536683998	5.53231.00.00.100386	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
778	0536683998	5.53231.00.00.100386	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
779	0536683998	5.53231.00.00.100386	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
780	0536683998	5.53231.00.00.100386	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
781	0536683998	5.53231.00.00.100386	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
782	0536679113	5.53231.00.00.100131	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
783	0536679113	5.53231.00.00.100131	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
784	0536679113	5.53231.00.00.100131	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
785	0536679113	5.53231.00.00.100131	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
786	0536679113	5.53231.00.00.100131	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
787	0536679113	5.53231.00.00.100131	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
788	0536679113	5.53231.00.00.100131	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
789	0536679113	5.53231.00.00.100131	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
790	0536679113	5.53231.00.00.100131	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
791	0536679113	5.53231.00.00.100131	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
792	0536679113	5.53231.00.00.100131	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
793	0535688891	5.53231.12.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
794	0535688891	5.53231.12.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
795	0535688891	5.53231.12.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
796	0535688891	5.53231.12.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
797	0535688891	5.53231.12.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
798	0535688891	5.53231.12.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
799	0535688891	5.53231.12.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
800	0535688891	5.53231.12.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
801	0535688891	5.53231.12.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
802	0535688891	5.53231.12.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
803	0535688891	5.53231.12.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
804	0535627074	5.53231.00.00.100116	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
805	0535627074	5.53231.00.00.100116	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
806	0535627074	5.53231.00.00.100116	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
807	0535627074	5.53231.00.00.100116	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
808	0535627074	5.53231.00.00.100116	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
809	0535627074	5.53231.00.00.100116	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
810	0535627074	5.53231.00.00.100116	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
811	0535627074	5.53231.00.00.100116	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
812	0535627074	5.53231.00.00.100116	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
813	0535627074	5.53231.00.00.100116	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
814	0535627074	5.53231.00.00.100116	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
815	0528862331	5.53231.00.00.100099	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
816	0528862331	5.53231.00.00.100099	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
817	0528862331	5.53231.00.00.100099	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
818	0528862331	5.53231.00.00.100099	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
819	0528862331	5.53231.00.00.100099	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
820	0528862331	5.53231.00.00.100099	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
821	0528862331	5.53231.00.00.100099	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
822	0528862331	5.53231.00.00.100099	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
823	0528862331	5.53231.00.00.100099	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
824	0528862331	5.53231.00.00.100099	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
825	0528862331	5.53231.00.00.100099	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
826	0524410459	5.53231.00.00.100187	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
827	0524410459	5.53231.00.00.100187	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
828	0524410459	5.53231.00.00.100187	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
829	0524410459	5.53231.00.00.100187	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
830	0524410459	5.53231.00.00.100187	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
831	0524410459	5.53231.00.00.100187	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
832	0524410459	5.53231.00.00.100187	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
833	0524410459	5.53231.00.00.100187	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
834	0524410459	5.53231.00.00.100187	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
835	0524410459	5.53231.00.00.100187	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
836	0524410459	5.53231.00.00.100187	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
837	0523432051	5.53231.00.00.100390	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
838	0523432051	5.53231.00.00.100390	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
839	0523432051	5.53231.00.00.100390	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
840	0523432051	5.53231.00.00.100390	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
841	0523432051	5.53231.00.00.100390	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
842	0523432051	5.53231.00.00.100390	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
843	0523432051	5.53231.00.00.100390	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
844	0523432051	5.53231.00.00.100390	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
845	0523432051	5.53231.00.00.100390	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
846	0523432051	5.53231.00.00.100390	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
847	0523432051	5.53231.00.00.100390	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
848	0537704373	5.53231.00.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
849	0537704373	5.53231.00.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
850	0537704373	5.53231.00.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
851	0537704373	5.53231.00.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
852	0537704373	5.53231.00.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
853	0537704373	5.53231.00.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
854	0537704373	5.53231.00.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
855	0537704373	5.53231.00.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
856	0537704373	5.53231.00.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
857	0537704373	5.53231.00.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
858	0537704373	5.53231.00.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
859	0537630415	5.53231.00.00.100397	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
860	0537630415	5.53231.00.00.100397	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
861	0537630415	5.53231.00.00.100397	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
862	0537630415	5.53231.00.00.100397	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
863	0537630415	5.53231.00.00.100397	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
864	0537630415	5.53231.00.00.100397	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
865	0537630415	5.53231.00.00.100397	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
866	0537630415	5.53231.00.00.100397	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
867	0537630415	5.53231.00.00.100397	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
868	0537630415	5.53231.00.00.100397	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
869	0537630415	5.53231.00.00.100397	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
870	0528852749	5.53231.00.00.100098	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
871	0528852749	5.53231.00.00.100098	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
872	0528852749	5.53231.00.00.100098	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
873	0528852749	5.53231.00.00.100098	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
874	0528852749	5.53231.00.00.100098	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
875	0528852749	5.53231.00.00.100098	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
876	0528852749	5.53231.00.00.100098	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
877	0528852749	5.53231.00.00.100098	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
878	0528852749	5.53231.00.00.100098	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
879	0528852749	5.53231.00.00.100098	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
880	0528852749	5.53231.00.00.100098	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
881	0522710435	5.53231.00.00.100159	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
882	0522710435	5.53231.00.00.100159	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
883	0522710435	5.53231.00.00.100159	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
884	0522710435	5.53231.00.00.100159	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
885	0522710435	5.53231.00.00.100159	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
886	0522710435	5.53231.00.00.100159	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
887	0522710435	5.53231.00.00.100159	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
888	0522710435	5.53231.00.00.100159	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
889	0522710435	5.53231.00.00.100159	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
890	0522710435	5.53231.00.00.100159	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
891	0522710435	5.53231.00.00.100159	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
892	0535525800	5.53231.00.00.100110	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
893	0535525800	5.53231.00.00.100110	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
894	0535525800	5.53231.00.00.100110	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
895	0535525800	5.53231.00.00.100110	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
896	0535525800	5.53231.00.00.100110	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
897	0535525800	5.53231.00.00.100110	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
898	0535525800	5.53231.00.00.100110	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
899	0535525800	5.53231.00.00.100110	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
900	0535525800	5.53231.00.00.100110	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
901	0535525800	5.53231.00.00.100110	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
902	0535525800	5.53231.00.00.100110	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
903	0537686175	5.53231.00.00.100205	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
904	0537686175	5.53231.00.00.100205	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
905	0537686175	5.53231.00.00.100205	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
906	0537686175	5.53231.00.00.100205	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
907	0537686175	5.53231.00.00.100205	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
908	0537686175	5.53231.00.00.100205	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
909	0537686175	5.53231.00.00.100205	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
910	0537686175	5.53231.00.00.100205	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
911	0537686175	5.53231.00.00.100205	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
912	0537686175	5.53231.00.00.100205	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
913	0537686175	5.53231.00.00.100205	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
914	0537704553	5.53231.00.00.100160	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
915	0537704553	5.53231.00.00.100160	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
916	0537704553	5.53231.00.00.100160	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
917	0537704553	5.53231.00.00.100160	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
918	0537704553	5.53231.00.00.100160	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
919	0537704553	5.53231.00.00.100160	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
920	0537704553	5.53231.00.00.100160	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
921	0537704553	5.53231.00.00.100160	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
922	0537704553	5.53231.00.00.100160	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
923	0537704553	5.53231.00.00.100160	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
924	0537704553	5.53231.00.00.100160	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
925	0522875376	5.53231.00.00.100325	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
926	0522875376	5.53231.00.00.100325	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
927	0522875376	5.53231.00.00.100325	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
928	0522875376	5.53231.00.00.100325	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
929	0522875376	5.53231.00.00.100325	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
930	0522875376	5.53231.00.00.100325	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
931	0522875376	5.53231.00.00.100325	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
932	0522875376	5.53231.00.00.100325	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
933	0522875376	5.53231.00.00.100325	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
934	0522875376	5.53231.00.00.100325	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
935	0522875376	5.53231.00.00.100325	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
936	0535649261	5.53231.00.00.100117	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
937	0535649261	5.53231.00.00.100117	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
938	0535649261	5.53231.00.00.100117	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
939	0535649261	5.53231.00.00.100117	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
940	0535649261	5.53231.00.00.100117	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
941	0535649261	5.53231.00.00.100117	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
942	0535649261	5.53231.00.00.100117	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
943	0535649261	5.53231.00.00.100117	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
944	0535649261	5.53231.00.00.100117	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
945	0535649261	5.53231.00.00.100117	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
946	0535649261	5.53231.00.00.100117	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
947	0537704689	5.53231.00.00.100054	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
948	0537704689	5.53231.00.00.100054	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
949	0537704689	5.53231.00.00.100054	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
950	0537704689	5.53231.00.00.100054	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
951	0537704689	5.53231.00.00.100054	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
952	0537704689	5.53231.00.00.100054	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
953	0537704689	5.53231.00.00.100054	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
954	0537704689	5.53231.00.00.100054	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
955	0537704689	5.53231.00.00.100054	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
956	0537704689	5.53231.00.00.100054	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
957	0537704689	5.53231.00.00.100054	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
958	0522219050	5.53231.00.00.100206	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
959	0522219050	5.53231.00.00.100206	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
960	0522219050	5.53231.00.00.100206	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
961	0522219050	5.53231.00.00.100206	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
962	0522219050	5.53231.00.00.100206	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
963	0522219050	5.53231.00.00.100206	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
964	0522219050	5.53231.00.00.100206	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
965	0522219050	5.53231.00.00.100206	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
966	0522219050	5.53231.00.00.100206	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
967	0522219050	5.53231.00.00.100206	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
968	0522219050	5.53231.00.00.100206	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
969	0539993038	5.53231.00.00.100070	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
970	0539993038	5.53231.00.00.100070	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
971	0539993038	5.53231.00.00.100070	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
972	0539993038	5.53231.00.00.100070	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
973	0539993038	5.53231.00.00.100070	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
974	0539993038	5.53231.00.00.100070	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
975	0539993038	5.53231.00.00.100070	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
976	0539993038	5.53231.00.00.100070	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
977	0539993038	5.53231.00.00.100070	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
978	0539993038	5.53231.00.00.100070	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
979	0539993038	5.53231.00.00.100070	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
980	0524412219	5.53231.00.00.100087	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
981	0524412219	5.53231.00.00.100087	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
982	0524412219	5.53231.00.00.100087	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
983	0524412219	5.53231.00.00.100087	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
984	0524412219	5.53231.00.00.100087	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
985	0524412219	5.53231.00.00.100087	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
986	0524412219	5.53231.00.00.100087	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
987	0524412219	5.53231.00.00.100087	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
988	0524412219	5.53231.00.00.100087	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
989	0524412219	5.53231.00.00.100087	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
990	0524412219	5.53231.00.00.100087	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
991	0523560304	5.53231.00.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
992	0523560304	5.53231.00.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
993	0523560304	5.53231.00.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
994	0523560304	5.53231.00.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
995	0523560304	5.53231.00.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
996	0523560304	5.53231.00.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
997	0523560304	5.53231.00.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
998	0523560304	5.53231.00.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
999	0523560304	5.53231.00.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1000	0523560304	5.53231.00.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1001	0523560304	5.53231.00.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1002	0523313248	7.1830754.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1003	0523313248	7.1830754.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1004	0523313248	7.1830754.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1005	0523313248	7.1830754.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1006	0523313248	7.1830754.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1007	0523313248	7.1830754.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1008	0523313248	7.1830754.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1009	0523313248	7.1830754.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1010	0523313248	7.1830754.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1011	0523313248	7.1830754.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1012	0523313248	7.1830754.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1013	0524474024	5.53231.00.00.100185	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1014	0524474024	5.53231.00.00.100185	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1015	0524474024	5.53231.00.00.100185	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1016	0524474024	5.53231.00.00.100185	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1017	0524474024	5.53231.00.00.100185	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1018	0524474024	5.53231.00.00.100185	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1019	0524474024	5.53231.00.00.100185	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1020	0524474024	5.53231.00.00.100185	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1021	0524474024	5.53231.00.00.100185	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1022	0524474024	5.53231.00.00.100185	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1023	0524474024	5.53231.00.00.100185	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1024	0523291619	8.11414778.00.00.100000	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1025	0523291619	8.11414778.00.00.100000	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1026	0523291619	8.11414778.00.00.100000	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1027	0523291619	8.11414778.00.00.100000	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1028	0523291619	8.11414778.00.00.100000	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1029	0523291619	8.11414778.00.00.100000	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1030	0523291619	8.11414778.00.00.100000	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1031	0523291619	8.11414778.00.00.100000	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1032	0523291619	8.11414778.00.00.100000	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1033	0523291619	8.11414778.00.00.100000	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1034	0523291619	8.11414778.00.00.100000	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1035	0537612904	5.53231.00.00.100137	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1036	0537612904	5.53231.00.00.100137	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1037	0537612904	5.53231.00.00.100137	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1038	0537612904	5.53231.00.00.100137	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1039	0537612904	5.53231.00.00.100137	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1040	0537612904	5.53231.00.00.100137	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1041	0537612904	5.53231.00.00.100137	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1042	0537612904	5.53231.00.00.100137	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1043	0537612904	5.53231.00.00.100137	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1044	0537612904	5.53231.00.00.100137	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1045	0537612904	5.53231.00.00.100137	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1046	0536798141	5.53231.00.00.100122	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1047	0536798141	5.53231.00.00.100122	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1048	0536798141	5.53231.00.00.100122	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1049	0536798141	5.53231.00.00.100122	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1050	0536798141	5.53231.00.00.100122	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1051	0536798141	5.53231.00.00.100122	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1052	0536798141	5.53231.00.00.100122	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1053	0536798141	5.53231.00.00.100122	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1054	0536798141	5.53231.00.00.100122	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1055	0536798141	5.53231.00.00.100122	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1056	0536798141	5.53231.00.00.100122	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1057	0528877449	5.53231.00.00.100101	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1058	0528877449	5.53231.00.00.100101	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1059	0528877449	5.53231.00.00.100101	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1060	0528877449	5.53231.00.00.100101	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1061	0528877449	5.53231.00.00.100101	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1062	0528877449	5.53231.00.00.100101	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1063	0528877449	5.53231.00.00.100101	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1064	0528877449	5.53231.00.00.100101	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1065	0528877449	5.53231.00.00.100101	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1066	0528877449	5.53231.00.00.100101	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1067	0528877449	5.53231.00.00.100101	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1068	0528828383	5.53231.00.00.100327	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1069	0528828383	5.53231.00.00.100327	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1070	0528828383	5.53231.00.00.100327	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1071	0528828383	5.53231.00.00.100327	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1072	0528828383	5.53231.00.00.100327	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1073	0528828383	5.53231.00.00.100327	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1074	0528828383	5.53231.00.00.100327	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1075	0528828383	5.53231.00.00.100327	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1076	0528828383	5.53231.00.00.100327	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1077	0528828383	5.53231.00.00.100327	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1078	0528828383	5.53231.00.00.100327	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1079	0537809686	5.53231.00.00.100042	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1080	0537809686	5.53231.00.00.100042	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1081	0537809686	5.53231.00.00.100042	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1082	0537809686	5.53231.00.00.100042	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1083	0537809686	5.53231.00.00.100042	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1084	0537809686	5.53231.00.00.100042	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1085	0537809686	5.53231.00.00.100042	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1086	0537809686	5.53231.00.00.100042	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1087	0537809686	5.53231.00.00.100042	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1088	0537809686	5.53231.00.00.100042	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1089	0537809686	5.53231.00.00.100042	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1090	0524642692	5.53231.00.00.100175	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1091	0524642692	5.53231.00.00.100175	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1092	0524642692	5.53231.00.00.100175	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1093	0524642692	5.53231.00.00.100175	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1094	0524642692	5.53231.00.00.100175	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1095	0524642692	5.53231.00.00.100175	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1096	0524642692	5.53231.00.00.100175	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1097	0524642692	5.53231.00.00.100175	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1098	0524642692	5.53231.00.00.100175	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1099	0524642692	5.53231.00.00.100175	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1100	0524642692	5.53231.00.00.100175	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1101	0528875032	5.53231.00.00.100339	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1102	0528875032	5.53231.00.00.100339	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1103	0528875032	5.53231.00.00.100339	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1104	0528875032	5.53231.00.00.100339	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1105	0528875032	5.53231.00.00.100339	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1106	0528875032	5.53231.00.00.100339	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1107	0528875032	5.53231.00.00.100339	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1108	0528875032	5.53231.00.00.100339	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1109	0528875032	5.53231.00.00.100339	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1110	0528875032	5.53231.00.00.100339	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1111	0528875032	5.53231.00.00.100339	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1112	0539982952	5.53231.00.00.100148	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1113	0539982952	5.53231.00.00.100148	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1114	0539982952	5.53231.00.00.100148	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1115	0539982952	5.53231.00.00.100148	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1116	0539982952	5.53231.00.00.100148	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1117	0539982952	5.53231.00.00.100148	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1118	0539982952	5.53231.00.00.100148	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1119	0539982952	5.53231.00.00.100148	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1120	0539982952	5.53231.00.00.100148	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1121	0539982952	5.53231.00.00.100148	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1122	0539982952	5.53231.00.00.100148	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1123	0523403766	5.53231.00.00.100143	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1124	0523403766	5.53231.00.00.100143	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1125	0523403766	5.53231.00.00.100143	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1126	0523403766	5.53231.00.00.100143	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1127	0523403766	5.53231.00.00.100143	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1128	0523403766	5.53231.00.00.100143	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1129	0523403766	5.53231.00.00.100143	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1130	0523403766	5.53231.00.00.100143	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1131	0523403766	5.53231.00.00.100143	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1132	0523403766	5.53231.00.00.100143	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1133	0523403766	5.53231.00.00.100143	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1134	0524835882	5.53231.00.00.100358	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1135	0524835882	5.53231.00.00.100358	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1136	0524835882	5.53231.00.00.100358	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1137	0524835882	5.53231.00.00.100358	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1138	0524835882	5.53231.00.00.100358	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1139	0524835882	5.53231.00.00.100358	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1140	0524835882	5.53231.00.00.100358	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1141	0524835882	5.53231.00.00.100358	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1142	0524835882	5.53231.00.00.100358	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1143	0524835882	5.53231.00.00.100358	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1144	0524835882	5.53231.00.00.100358	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1145	0522600690	5.53231.00.00.100142	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1146	0522600690	5.53231.00.00.100142	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1147	0522600690	5.53231.00.00.100142	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1148	0522600690	5.53231.00.00.100142	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1149	0522600690	5.53231.00.00.100142	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1150	0522600690	5.53231.00.00.100142	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1151	0522600690	5.53231.00.00.100142	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1152	0522600690	5.53231.00.00.100142	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1153	0522600690	5.53231.00.00.100142	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1154	0522600690	5.53231.00.00.100142	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1155	0522600690	5.53231.00.00.100142	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1156	0528873840	5.53231.00.00.100192	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1157	0528873840	5.53231.00.00.100192	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1158	0528873840	5.53231.00.00.100192	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1159	0528873840	5.53231.00.00.100192	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1160	0528873840	5.53231.00.00.100192	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1161	0528873840	5.53231.00.00.100192	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1162	0528873840	5.53231.00.00.100192	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1163	0528873840	5.53231.00.00.100192	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1164	0528873840	5.53231.00.00.100192	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1165	0528873840	5.53231.00.00.100192	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1166	0528873840	5.53231.00.00.100192	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1167	0528834140	5.53231.00.00.100149	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1168	0528834140	5.53231.00.00.100149	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1169	0528834140	5.53231.00.00.100149	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1170	0528834140	5.53231.00.00.100149	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1171	0528834140	5.53231.00.00.100149	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1172	0528834140	5.53231.00.00.100149	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1173	0528834140	5.53231.00.00.100149	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1174	0528834140	5.53231.00.00.100149	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1175	0528834140	5.53231.00.00.100149	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1176	0528834140	5.53231.00.00.100149	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1177	0528834140	5.53231.00.00.100149	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1178	0535676045	5.53231.00.00.100360	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1179	0535676045	5.53231.00.00.100360	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1180	0535676045	5.53231.00.00.100360	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1181	0535676045	5.53231.00.00.100360	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1182	0535676045	5.53231.00.00.100360	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1183	0535676045	5.53231.00.00.100360	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1184	0535676045	5.53231.00.00.100360	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1185	0535676045	5.53231.00.00.100360	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1186	0535676045	5.53231.00.00.100360	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1187	0535676045	5.53231.00.00.100360	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1188	0535676045	5.53231.00.00.100360	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1189	0535567637	5.53231.00.00.100172	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1190	0535567637	5.53231.00.00.100172	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1191	0535567637	5.53231.00.00.100172	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1192	0535567637	5.53231.00.00.100172	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1193	0535567637	5.53231.00.00.100172	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1194	0535567637	5.53231.00.00.100172	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1195	0535567637	5.53231.00.00.100172	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1196	0535567637	5.53231.00.00.100172	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1197	0535567637	5.53231.00.00.100172	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1198	0535567637	5.53231.00.00.100172	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1199	0535567637	5.53231.00.00.100172	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1200	0522510432	5.53231.00.00.100167	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1201	0522510432	5.53231.00.00.100167	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1202	0522510432	5.53231.00.00.100167	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1203	0522510432	5.53231.00.00.100167	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1204	0522510432	5.53231.00.00.100167	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1205	0522510432	5.53231.00.00.100167	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1206	0522510432	5.53231.00.00.100167	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1207	0522510432	5.53231.00.00.100167	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1208	0522510432	5.53231.00.00.100167	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1209	0522510432	5.53231.00.00.100167	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1210	0522510432	5.53231.00.00.100167	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1211	0536820633	5.53231.00.00.100124	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1212	0536820633	5.53231.00.00.100124	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1213	0536820633	5.53231.00.00.100124	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1214	0536820633	5.53231.00.00.100124	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1215	0536820633	5.53231.00.00.100124	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1216	0536820633	5.53231.00.00.100124	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1217	0536820633	5.53231.00.00.100124	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1218	0536820633	5.53231.00.00.100124	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1219	0536820633	5.53231.00.00.100124	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1220	0536820633	5.53231.00.00.100124	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
1221	0536820633	5.53231.00.00.100124	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176	\N	\N
\.


--
-- Data for Name: notification_reads; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.notification_reads (user_id, last_seen_at) FROM stdin;
2	2026-07-17 23:40:38.41
22	2026-07-27 13:43:12.618
3	2026-07-28 01:01:56.395
\.


--
-- Data for Name: org_nodes; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.org_nodes (id, type, name, short_name, parent_id, sort_order, chef_nom, telephone, notes, deleted_at, created_at, updated_at) FROM stdin;
1	direction	Direction	Direction	\N	0	\N	\N	\N	\N	2026-07-23 13:04:17.721305	2026-07-23 13:04:17.721305
17	division	Division de l'Ingénierie Sociale	Ing. Sociale	11	0	\N	\N	\N	\N	2026-07-23 13:04:17.753814	2026-07-23 13:04:17.753814
18	service	Service de l'Ingénierie de la Veille Sociale et des Études	\N	17	0	\N	\N	\N	\N	2026-07-23 13:04:17.75474	2026-07-23 13:04:17.75474
19	service	Service des Statistiques et des Indicateurs	\N	17	1	\N	\N	\N	\N	2026-07-23 13:04:17.755562	2026-07-23 13:04:17.755562
20	division	Division de la Planification Stratégique et de la Programmation	Planification	11	1	\N	\N	\N	\N	2026-07-23 13:04:17.756651	2026-07-23 13:04:17.756651
21	service	Service de la Planification du Suivi et d'Évaluation des Programmes	\N	20	0	\N	\N	\N	\N	2026-07-23 13:04:17.757493	2026-07-23 13:04:17.757493
22	service	Service du Partenariat	\N	20	1	\N	\N	\N	\N	2026-07-23 13:04:17.758968	2026-07-23 13:04:17.758968
23	division	Division des Ressources Financières	Res. Fin.	12	0	\N	\N	\N	\N	2026-07-23 13:04:17.76003	2026-07-23 13:04:17.76003
24	service	Service de la Comptabilité	\N	23	0	\N	\N	\N	\N	2026-07-23 13:04:17.761006	2026-07-23 13:04:17.761006
25	service	Service du Budget et de la Programmation	\N	23	1	\N	\N	\N	\N	2026-07-23 13:04:17.762117	2026-07-23 13:04:17.762117
26	service	Service du Recouvrement	\N	23	2	\N	\N	\N	\N	2026-07-23 13:04:17.763096	2026-07-23 13:04:17.763096
27	service	Service de l'Ordonnancement et du Paiement	\N	23	3	\N	\N	\N	\N	2026-07-23 13:04:17.765857	2026-07-23 13:04:17.765857
28	division	Division des Ressources Humaines	RH	12	1	\N	\N	\N	\N	2026-07-23 13:04:17.767218	2026-07-23 13:04:17.767218
29	service	Service de la Gestion du Personnel	\N	28	0	\N	\N	\N	\N	2026-07-23 13:04:17.768475	2026-07-23 13:04:17.768475
30	service	Service de la Couverture Sociale	\N	28	1	\N	\N	\N	\N	2026-07-23 13:04:17.769684	2026-07-23 13:04:17.769684
31	service	Service Développement des RH	\N	28	2	\N	\N	\N	\N	2026-07-23 13:04:17.77072	2026-07-23 13:04:17.77072
32	division	Division du Patrimoine et de la Logistique	Patrimoine	12	2	\N	\N	\N	\N	2026-07-23 13:04:17.772011	2026-07-23 13:04:17.772011
33	service	Service du Patrimoine et des Bâtiments	\N	32	0	\N	\N	\N	\N	2026-07-23 13:04:17.773029	2026-07-23 13:04:17.773029
34	service	Service des Achats	\N	32	1	\N	\N	\N	\N	2026-07-23 13:04:17.773974	2026-07-23 13:04:17.773974
37	division	Division de la Solidarité et de l'Assistance Sociale	Solidarité	13	0	\N	\N	\N	\N	2026-07-23 13:04:17.777013	2026-07-23 13:04:17.777013
38	service	Service de la Solidarité et de l'Action Humanitaire	\N	37	0	\N	\N	\N	\N	2026-07-23 13:04:17.778208	2026-07-23 13:04:17.778208
39	service	Service d'Assistance et d'Accompagnement des PSH	\N	37	1	\N	\N	\N	\N	2026-07-23 13:04:17.779218	2026-07-23 13:04:17.779218
40	service	Service des Personnes Sans Abri	\N	37	2	\N	\N	\N	\N	2026-07-23 13:04:17.780246	2026-07-23 13:04:17.780246
41	division	Division de la Protection et de la Promotion Familiale	Protection Fam.	13	1	\N	\N	\N	\N	2026-07-23 13:04:17.782764	2026-07-23 13:04:17.782764
42	service	Service d'Accompagnement et de Protection de l'Enfance	\N	41	0	\N	\N	\N	\N	2026-07-23 13:04:17.784047	2026-07-23 13:04:17.784047
43	service	Service des Établissements d'Accueil et de Protection des Enfants	\N	41	1	\N	\N	\N	\N	2026-07-23 13:04:17.785243	2026-07-23 13:04:17.785243
44	service	Service des Structures d'Accueil et d'Aide des PSH	\N	41	2	\N	\N	\N	\N	2026-07-23 13:04:17.786198	2026-07-23 13:04:17.786198
45	service	Service de Protection des Personnes Âgées et de la Promotion Familiale	\N	41	3	\N	\N	\N	\N	2026-07-23 13:04:17.787098	2026-07-23 13:04:17.787098
46	division	Division de l'Intégration et de l'Autonomisation	Intégration	13	2	\N	\N	\N	\N	2026-07-23 13:04:17.788236	2026-07-23 13:04:17.788236
47	service	Service d'Assistance Sociale à la Femme	\N	46	0	\N	\N	\N	\N	2026-07-23 13:04:17.78913	2026-07-23 13:04:17.78913
48	service	Service des Centres d'Accueil et de Protection de la Femme	\N	46	1	\N	\N	\N	\N	2026-07-23 13:04:17.790006	2026-07-23 13:04:17.790006
49	service	Service de l'Autonomisation et de l'Insertion Sociale de la Femme	\N	46	2	\N	\N	\N	\N	2026-07-23 13:04:17.79102	2026-07-23 13:04:17.79102
4	division	Division de la Programmation et du Suivi	\N	3	0	\N	\N	\N	2026-07-23 13:55:04.663845	2026-07-23 13:04:17.73409	2026-07-23 13:55:04.663845
5	service	Service de la Programmation	\N	4	0	\N	\N	\N	2026-07-23 13:55:04.663845	2026-07-23 13:04:17.735844	2026-07-23 13:55:04.663845
6	service	Service du Suivi et de l'Évaluation	\N	4	1	\N	\N	\N	2026-07-23 13:55:04.663845	2026-07-23 13:04:17.737228	2026-07-23 13:55:04.663845
7	division	Division du Contrôle et de la Vérification	\N	3	1	\N	\N	\N	2026-07-23 13:55:09.896566	2026-07-23 13:04:17.739055	2026-07-23 13:55:09.896566
8	service	Service du Contrôle Interne	\N	7	0	\N	\N	\N	2026-07-23 13:55:09.896566	2026-07-23 13:04:17.741572	2026-07-23 13:55:09.896566
9	service	Service de la Vérification	\N	7	1	\N	\N	\N	2026-07-23 13:55:09.896566	2026-07-23 13:04:17.743224	2026-07-23 13:55:09.896566
10	service	Service des Enquêtes	\N	7	2	\N	\N	\N	2026-07-23 13:55:09.896566	2026-07-23 13:04:17.744614	2026-07-23 13:55:09.896566
62	division	Service 2	\N	3	0	\N	\N	\N	2026-07-23 13:56:40.439185	2026-07-23 13:56:29.583875	2026-07-23 13:56:40.439185
61	service	Service 1	\N	3	0	\N	\N	\N	2026-07-23 13:56:44.921218	2026-07-23 13:56:24.467254	2026-07-23 13:56:44.921218
2	sous-direction	Direction Adjointe	Dir. Adjointe	1	0	\N	\N	\N	\N	2026-07-23 13:04:17.725115	2026-07-23 23:51:24.978
11	sous-direction	Sous-Direction de l'ingénierie Sociales et de la Planification	SDASP	2	0	\N	\N	\N	\N	2026-07-23 13:04:17.745688	2026-07-24 00:09:44.416
50	division	Division des Systèmes d'Information et de la Transformation Digitale	Div. SI	14	0	\N	\N	\N	2026-07-23 14:05:59.996013	2026-07-23 13:04:17.792397	2026-07-23 14:05:59.996013
51	service	Service Études et Développement des SI	\N	50	0	\N	\N	\N	2026-07-23 14:05:59.996013	2026-07-23 13:04:17.793357	2026-07-23 14:05:59.996013
52	service	Service Gestion, Maintenance et Support des SI	\N	50	1	\N	\N	\N	2026-07-23 14:05:59.996013	2026-07-23 13:04:17.794184	2026-07-23 14:05:59.996013
66	service	Service d'Etudes et développement des SI	\N	14	0	\N	\N	\N	\N	2026-07-23 14:06:54.223414	2026-07-23 14:06:54.223414
67	service	Service de Gestion, de Maintenance et de Support SI	\N	14	0	\N	\N	\N	\N	2026-07-23 14:07:47.493881	2026-07-23 14:07:47.493881
15	sous-direction	Communication et Coopération	Comm.	2	4	\N	\N	\N	2026-07-23 14:09:39.709125	2026-07-23 13:04:17.751265	2026-07-23 14:09:39.709125
16	service	Service du Contentieux et des Affaires Juridiques	Contentieux	2	5	\N	\N	\N	2026-07-23 14:10:23.702201	2026-07-23 13:04:17.752517	2026-07-23 14:10:23.702201
36	service	Service de la Gestion des Archives	\N	32	3	HILMI MAROUANE	\N	\N	\N	2026-07-23 13:04:17.775953	2026-07-23 13:15:39.778
35	service	Service de la Logistique et des Moyens Généraux	\N	32	2	JABRAN ANAS	0672989360	\N	\N	2026-07-23 13:04:17.774953	2026-07-23 13:16:05.271
57	division	Directions Provinciales/Préfectorales	\N	56	0	\N	\N	\N	\N	2026-07-23 13:53:57.038254	2026-07-23 23:51:56.421
12	sous-direction	Sous-Direction des Affaires Administratives et Financières	SDAAF	2	1	\N	\N	\N	\N	2026-07-23 13:04:17.74664	2026-07-24 00:09:44.424
58	division	Division 1	\N	3	0	\N	\N	\N	\N	2026-07-23 13:55:41.314164	2026-07-24 00:03:46.214
59	division	Division 2	\N	3	1	\N	\N	\N	\N	2026-07-23 13:55:49.4636	2026-07-24 00:03:46.219
60	division	Division 3	\N	3	2	\N	\N	\N	\N	2026-07-23 13:55:54.954304	2026-07-24 00:03:46.222
63	service	Service 1	\N	3	3	\N	\N	\N	\N	2026-07-23 13:56:54.444494	2026-07-24 00:03:46.225
64	service	Service 2	\N	3	4	\N	\N	\N	\N	2026-07-23 13:57:01.684362	2026-07-24 00:03:46.227
56	entite	Directions Régionales	\N	1	1	\N	\N	\N	\N	2026-07-23 13:52:47.639967	2026-07-23 23:51:24.979
65	service	Service 3	\N	3	5	\N	\N	\N	\N	2026-07-23 13:57:10.002239	2026-07-24 00:03:46.236
53	service	Service Presse, Édition et Contribution de Gestion	\N	15	0	\N	\N	\N	2026-07-23 14:09:39.709125	2026-07-23 13:04:17.794945	2026-07-23 14:09:39.709125
54	service	Service de la Communication	\N	15	1	\N	\N	\N	2026-07-23 14:09:39.709125	2026-07-23 13:04:17.79571	2026-07-23 14:09:39.709125
55	service	Service de la Coopération	\N	15	2	\N	\N	\N	2026-07-23 14:09:39.709125	2026-07-23 13:04:17.796523	2026-07-23 14:09:39.709125
3	inspection	Inspection	Inspection	1	2	\N	\N	\N	\N	2026-07-23 13:04:17.73204	2026-07-23 23:58:05.975
68	service	Service de l’Audit, de la Qualité et du Contrôle de Gestion	\N	72	0	\N	\N	\N	\N	2026-07-23 14:10:55.702654	2026-07-24 00:10:29.946
69	service	Service de la Communication	\N	72	1	\N	\N	\N	\N	2026-07-23 14:11:40.476705	2026-07-24 00:10:29.949
70	service	Service de la Coopération	\N	72	2	\N	\N	\N	\N	2026-07-23 14:11:56.460448	2026-07-24 00:10:29.95
71	service	Service du Contentieux et des Affaires Juridiques	\N	72	3	\N	\N	\N	\N	2026-07-23 14:12:13.914663	2026-07-24 00:10:29.951
72	entite	Ratachée	\N	1	0	\N	\N	\N	\N	2026-07-24 01:08:29.476639	2026-07-24 01:08:29.476639
13	sous-direction	Sous-Direction de l'Assistance Sociale	SDAS	2	2	\N	\N	\N	\N	2026-07-23 13:04:17.748686	2026-07-24 00:09:44.427
14	sous-direction	Division des systèmes d'information et de la Digitalisation	SI	2	3	\N	\N	\N	\N	2026-07-23 13:04:17.750022	2026-07-24 00:09:44.429
\.


--
-- Data for Name: service_request_events; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.service_request_events (id, request_id, statut, commentaire, action_par, created_at) FROM stdin;
1	1	nouvelle	Demande créée.	ELHAIMER AMINE	2026-07-24 02:02:19.131415
2	1	validee_chef	\N	ELHAIMER AMINE	2026-07-24 02:02:45.285096
3	1	validee_responsable	\N	ELHAIMER AMINE	2026-07-24 02:02:50.003876
4	1	affectee	\N	ELHAIMER AMINE	2026-07-24 02:03:07.764395
5	1	en_cours	\N	ELHAIMER AMINE	2026-07-24 02:03:12.304028
6	1	terminee	\N	ELHAIMER AMINE	2026-07-24 02:03:19.471403
7	1	archivee	\N	ELHAIMER AMINE	2026-07-24 02:03:22.498392
8	2	nouvelle	Demande créée.	ELHAIMER AMINE	2026-07-24 09:05:22.781951
9	2	validee_chef	\N	ELHAIMER AMINE	2026-07-24 09:05:46.702654
10	2	validee_responsable	\N	ELHAIMER AMINE	2026-07-24 09:06:00.009004
11	2	affectee	\N	ELHAIMER AMINE	2026-07-24 09:06:34.13601
12	2	en_cours	\N	ELHAIMER AMINE	2026-07-24 09:06:36.792133
13	2	terminee	FAIT	ELHAIMER AMINE	2026-07-24 09:07:35.849227
14	2	archivee	\N	ELHAIMER AMINE	2026-07-24 09:07:57.740861
15	3	nouvelle	Demande créée.	ELHAIMER AMINE	2026-07-24 11:45:35.986668
16	3	validee_chef	\N	ELHAIMER AMINE	2026-07-24 11:45:56.183499
17	3	validee_responsable	\N	ELHAIMER AMINE	2026-07-24 11:46:24.410284
18	3	affectee	\N	ELHAIMER AMINE	2026-07-24 11:47:07.782352
19	3	en_cours	\N	ELHAIMER AMINE	2026-07-24 11:47:10.750199
20	3	terminee	VALIDER	ELHAIMER AMINE	2026-07-24 11:47:29.642042
21	3	archivee	\N	ELHAIMER AMINE	2026-07-27 01:06:26.601987
22	4	nouvelle	Demande créée.	ELHAIMER AMINE	2026-07-27 02:08:07.620731
23	4	validee_chef	ok	ELHAIMER AMINE	2026-07-27 02:08:41.90321
24	4	validee_responsable	\N	ELHAIMER AMINE	2026-07-27 02:09:06.284496
25	4	affectee	\N	ELHAIMER AMINE	2026-07-27 02:09:19.463706
26	4	en_cours	\N	ELHAIMER AMINE	2026-07-27 02:09:28.168616
27	4	terminee	\N	ELHAIMER AMINE	2026-07-27 02:09:41.034872
28	4	archivee	fait	ELHAIMER AMINE	2026-07-27 02:10:10.3999
\.


--
-- Data for Name: service_requests; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.service_requests (id, numero, service_demandeur_id, demandeur_nom, demandeur_telephone, type, objet, description, priorite, statut, agent_affecte_id, date_souhaitee, created_by, deleted_at, deleted_by, created_at, updated_at) FROM stdin;
1	DEM-2026-0001	2	ELHAIMER AMINE	0602799998	telephone	mobile avec carte sim	\N	urgente	archivee	3	25/07/2026	ELHAIMER AMINE	\N	\N	2026-07-24 02:02:19.122993	2026-07-24 01:03:22.487
2	DEM-2026-0002	24	hamza	\N	mobilier	BUREAU PC SCANNER IMPRIMANTE	\N	urgente	archivee	3	24/07/2026	ELHAIMER AMINE	\N	\N	2026-07-24 09:05:22.774199	2026-07-24 08:07:57.727
3	DEM-2026-0003	36	moniem damir	0658788912	mobilier	BUREAU SCANNER	\N	urgente	archivee	3	30/07/2026	ELHAIMER AMINE	\N	\N	2026-07-24 11:45:35.974083	2026-07-27 00:06:26.592
4	DEM-2026-0004	35	AMINE	06027999988	mobilier	bureau ordinateur	\N	normale	archivee	3	30/07/2026	ELHAIMER AMINE	\N	\N	2026-07-27 02:08:07.614223	2026-07-27 01:10:10.386
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.sessions (id, jti, user_id, ip_address, user_agent, created_at, last_seen_at, revoked_at) FROM stdin;
20	ea399bb6-88ae-43c5-9763-055ee35cb7e5	11	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-26 02:34:49.597558	2026-07-26 10:31:00.85	2026-07-26 10:31:02.267
5	0e0f7b86-0f99-4863-8031-01b3a4b967ff	3	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-21 01:46:16.75926	2026-07-24 00:02:27.403	\N
10	9cf57910-a4dd-4317-b37e-793f18183f86	10	192.168.0.132	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-26 00:38:10.293474	2026-07-26 00:09:33.648	2026-07-26 00:09:39.762
7	01150de1-979f-401d-a1f3-91d8f4a31019	3	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 01:03:19.162813	2026-07-24 00:16:19.399	\N
15	0dc97b1d-5b57-4004-8509-b03698b3cddb	11	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-26 01:54:44.050581	2026-07-26 01:20:01.26	2026-07-26 01:20:14.849
2	8b05f91e-ee79-436d-b7d8-60fe59eb767f	3	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-19 01:07:00.636583	2026-07-19 00:46:48.582	\N
14	bbeb0fd3-3c94-4b65-af75-b74095d0980e	11	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-26 01:40:12.508822	2026-07-26 00:54:37.634	2026-07-26 00:54:41.139
30	dfe66d96-2809-4870-98c3-7370cc488c8d	11	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-26 16:39:58.872981	2026-07-26 15:46:57.118	2026-07-26 15:47:00.605
9	9e7c76a6-7410-4ac2-b512-9cdd0b16c407	3	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 02:00:39.659773	2026-07-26 00:26:39.709	2026-07-26 00:26:48.849
1	d00fdc0c-ac00-460a-9b76-714c3513dfae	3	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-19 00:57:24.871612	2026-07-19 00:06:31.288	2026-07-19 00:06:57.055
8	73999748-a6ae-4d90-a1ec-5097cbaafa7f	3	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-24 01:17:37.335229	2026-07-24 00:59:53.357	\N
26	e66999c0-6a2d-432d-a1db-5d59ced66c8d	11	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 15:57:38.950388	2026-07-26 15:12:57.614	2026-07-26 15:13:08.708
6	dd3d3a7f-a6bc-4e01-b58c-696490c1faba	3	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-22 14:20:14.004932	2026-07-27 11:02:39.926	2026-07-27 11:02:55.448
3	d4c0d84c-ab4b-4fc5-b3b8-8ddf923ee050	2	192.168.0.132	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-19 01:07:52.037933	2026-07-19 00:08:19.042	2026-07-19 00:08:26.959
22	7f8d527a-e360-4176-8a90-d9eea2750548	11	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-26 11:31:05.995732	2026-07-26 10:50:29.082	2026-07-26 10:50:33.045
4	4946eabd-1bfb-4780-b002-f65354134111	3	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-19 17:44:06.356932	2026-07-21 00:45:41.218	2026-07-21 00:46:01.036
18	6cba9ce8-a2f8-4a0e-b154-572fed626a0a	11	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-26 02:25:03.770328	2026-07-26 01:29:07.338	2026-07-26 01:29:10.399
11	dc8dd003-9269-4ca8-956e-da9e8eb040db	10	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-26 01:09:42.593985	2026-07-26 00:13:10.159	2026-07-26 00:13:11.724
12	c6a68a44-8246-4973-bef2-e95f0d17021d	10	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-26 01:13:17.744756	2026-07-26 00:21:20.254	\N
32	4c7fdea4-3ae5-4950-9423-8283662b97e2	12	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-26 16:47:05.42849	2026-07-26 16:08:13.893	2026-07-26 16:08:18.74
27	562d6599-469f-424b-84be-a657ae3f521f	11	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:13:11.795327	2026-07-26 15:13:11.87	2026-07-26 15:13:13.846
17	19cfb27a-3413-456d-bc25-2da487f75e93	11	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-26 02:20:17.389345	2026-07-26 01:24:58.728	2026-07-26 01:25:00.349
19	e8fde848-5b4a-4ab9-b128-8be27ff56e84	11	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-26 02:29:12.758635	2026-07-26 01:34:34.158	2026-07-26 01:34:47.256
16	0bbc58db-fb5d-42a1-8108-8cbc40f65f0b	11	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:59:27.444942	2026-07-26 01:46:49.699	\N
13	ad907f43-0327-4411-809c-3417aad83afe	3	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 01:27:10.676013	2026-07-26 01:46:56.695	\N
21	e0c48f0f-798e-49de-b8df-389cb28d87c3	3	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 11:27:49.46983	2026-07-26 15:44:35.447	2026-07-26 15:44:42.794
23	7dddb43f-dcd5-49da-8e0c-02b262eab759	11	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-26 11:50:35.637592	2026-07-26 14:35:38.802	2026-07-26 14:35:41.294
28	76c6f6a2-5295-4db3-bbef-a2737c0134a5	3	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:13:32.943725	2026-07-26 15:15:34.032	2026-07-26 15:15:54.961
24	bb564337-1b31-4d0f-ba0a-658184fd4de0	3	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 15:32:50.269168	2026-07-26 14:57:20.817	2026-07-26 14:57:27.516
25	09ec1566-fc99-4993-8bb7-0c7daf5ea438	11	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-26 15:35:44.97629	2026-07-26 15:39:49.671	2026-07-26 15:39:50.79
34	1bf66739-5653-4622-ae1f-2b2ebcc2d792	3	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 17:06:27.452423	2026-07-27 23:16:42.167	2026-07-27 23:17:05.181
29	810e64b2-0a78-48e0-9072-a97d19a040aa	11	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:15:57.116021	2026-07-26 15:58:29.208	2026-07-26 15:58:31.112
31	d452da57-eda5-4c44-ae8d-1f0d97089a77	3	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:44:57.389085	2026-07-26 16:04:37.977	\N
55	050939fd-4eb9-433f-bf6e-6334ad19a568	20	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 12:14:57.29475	2026-07-27 11:21:00.786	2026-07-27 11:21:02.722
54	b67f5dd4-f8cc-4c3e-af2c-967a64b5aaa5	20	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 12:10:22.572231	2026-07-27 11:14:44.4	2026-07-27 11:14:55.288
44	5993da01-8d70-4502-8e15-c7ab53c4936f	17	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-27 02:46:04.004281	2026-07-27 01:52:18.723	2026-07-27 01:52:24.573
48	99825727-e166-4799-9780-8ac11b128a37	19	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 10:23:26.353244	2026-07-27 10:53:34.317	\N
35	5541323d-f6be-4e7b-81e1-cf5a30236efc	12	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-26 17:08:21.226117	2026-07-26 16:12:16.361	\N
37	119d97ce-b97d-4250-a059-9c461ace6727	13	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 00:21:42.925879	2026-07-27 00:04:30.374	2026-07-27 00:04:33.542
36	99ecca6d-5941-489a-b4a0-c0ab05a178c5	3	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 00:01:17.418838	2026-07-26 23:31:08.717	\N
39	4c39b1e0-db60-4e71-bde1-7ef4d591c87f	3	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 00:36:05.059526	2026-07-27 00:04:24.746	2026-07-27 00:04:40.166
49	86cc30e1-6725-4124-a47e-6a9ccad12003	19	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 12:01:49.486126	2026-07-27 11:02:19.313	2026-07-27 11:02:29.223
46	8148bb8b-bcdc-4e67-be38-ba4dff963703	17	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 02:53:44.745924	2026-07-27 01:53:44.81	\N
40	0527c782-1747-4fe5-aa30-33ca14fdfe74	13	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-27 00:57:46.626607	2026-07-26 23:58:56.677	2026-07-26 23:58:57.06
33	f20c2ae8-6e0d-423b-a615-67f41ed19184	12	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-26 16:58:40.057029	2026-07-26 23:01:46.769	\N
50	02f06be2-8f8d-4258-ad74-3ba434ecdfce	19	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 12:02:31.442753	2026-07-27 11:02:31.472	\N
41	da98d772-aabf-4653-bcc3-beacb6c31f71	3	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 01:05:06.547716	2026-07-27 00:54:16.268	2026-07-27 00:54:24.428
38	cda8b00a-832c-4875-ad2f-6adabb4554cd	3	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 00:32:19.652022	2026-07-26 23:35:28.909	2026-07-26 23:35:49.032
45	b2e61518-174f-4124-aad7-d1622e20c7f8	17	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-27 02:52:27.980122	2026-07-27 01:53:37.297	2026-07-27 01:55:18.892
57	b2139442-1118-4408-b842-ff5f400266cf	20	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 12:23:06.179508	2026-07-27 11:23:06.223	2026-07-27 11:23:54.927
63	39b472b4-69f2-4fb8-99ba-ccf6732989ee	22	192.168.77.21	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-27 13:39:24.838242	2026-07-27 12:48:57.42	2026-07-27 12:49:04.229
43	3472c7ed-51cd-4da1-8a51-2e9f9b9d01ee	3	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 01:54:45.52155	2026-07-27 02:03:55.76	\N
42	7a1d57a6-2025-4b3d-9a0b-b6ad41fe7800	14	192.168.0.111	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-27 01:25:19.520005	2026-07-27 00:25:51.418	\N
56	b30db1d2-2181-46fb-9311-dc8c0dc623c6	20	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 12:21:04.905399	2026-07-27 11:21:04.942	2026-07-27 11:21:57.574
47	8b932266-2f03-4d3c-be32-a0cd1cb7ca79	19	192.168.77.21	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-27 10:20:19.855485	2026-07-27 09:21:08.504	\N
52	d33479c5-b066-44fe-a98e-85ff68e43e18	20	192.168.77.21	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-27 12:05:44.974308	2026-07-27 12:27:52.038	2026-07-27 12:27:56.457
51	28af6caa-ed5d-4b3c-bf9f-daa8b840a01a	3	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 12:03:17.250069	2026-07-27 12:33:16.884	\N
59	7f824311-a91d-4749-b44a-69556e12f697	20	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 12:25:10.081225	2026-07-27 12:30:36.478	2026-07-27 12:30:42.014
53	69068611-0f73-48d4-a2f6-3a5351769f8c	20	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 12:09:16.64415	2026-07-27 11:09:16.685	2026-07-27 11:10:19.839
58	d8574d4c-628f-41ae-b59b-78d12209deb5	20	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 12:23:57.142659	2026-07-27 11:23:57.203	2026-07-27 11:25:07.862
60	4b49e806-0f83-4260-af12-d2542fdbaa85	20	192.168.77.21	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-27 13:27:59.199276	2026-07-27 12:27:59.273	\N
61	34b39c46-8521-490f-8241-54cab4564c03	20	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 13:30:44.007003	2026-07-27 12:31:38.264	\N
65	bc16bc9c-64bb-49c1-9aec-cdf7064935b5	22	192.168.77.21	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-27 13:49:08.069796	2026-07-27 13:24:03.423	2026-07-27 13:24:10.497
64	d591e0e5-0a32-40f1-b69d-44ca88493aa9	22	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 13:40:48.707923	2026-07-27 12:55:05.202	\N
66	ad32cfe1-7d5c-4c45-966d-2d5f2addcda4	22	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 13:58:14.268484	2026-07-27 12:59:28.986	2026-07-27 12:59:35.788
67	560ad0da-6604-4300-b61d-f05eedb123d9	22	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 13:59:37.773439	2026-07-27 13:12:30.663	\N
62	19053bb5-451a-4fd9-9d66-67eec73952e8	3	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 13:38:22.365366	2026-07-27 14:20:39.937	\N
72	7470c4bf-9b28-4d17-b5c6-8186f90280d4	22	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 00:08:07.393824	2026-07-27 23:10:30.038	2026-07-27 23:10:33.216
69	6a99e347-1ccd-49ec-9405-2a85977200d2	22	192.168.77.21	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36	2026-07-27 14:24:14.009164	2026-07-27 13:33:21.49	\N
75	412695ff-7778-4b98-b17f-2c1df5663321	22	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 00:15:59.24095	2026-07-28 00:41:38.478	2026-07-28 00:41:41.969
73	0a66d621-2fea-4bb8-9220-869df99297b1	22	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 00:10:35.201359	2026-07-27 23:11:06.54	2026-07-27 23:11:12.264
74	c883d42b-266b-407f-a8be-a721dd24d1c0	22	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 00:11:14.65295	2026-07-27 23:15:52.1	2026-07-27 23:15:56.541
70	c5bf6fcb-af68-44b4-90c3-81601a6031e2	22	192.168.77.248	Mozilla/5.0 (iPhone; CPU iPhone OS 26_5_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) GSA/430.3.945886556 Mobile/15E148 Safari/604.1	2026-07-27 14:41:51.002494	2026-07-27 13:44:49.572	\N
76	372d0439-0b56-478f-9d23-7d18607c0017	3	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 00:17:47.626087	2026-07-28 01:12:36.223	\N
78	7913d4c4-137c-4bf6-8dae-c7caa8ebdd48	22	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:44:15.8344	2026-07-28 01:12:46.79	\N
77	a5718229-ce28-44a0-845a-e6b320fd5f50	22	192.168.0.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-28 01:43:06.631674	2026-07-28 00:44:06.681	2026-07-28 00:44:13.049
68	4d839b45-5bd8-4b6c-b3d1-1b703684d845	22	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 14:14:54.771802	2026-07-27 14:20:46.226	\N
71	0f3ff4e6-d356-444a-b748-5e58d1f75563	22	192.168.77.24	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	2026-07-27 15:23:19.693819	2026-07-27 14:23:19.792	\N
\.


--
-- Data for Name: sheet_rules; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.sheet_rules (id, role, sheet_name, mapping, updated_by, created_at, updated_at) FROM stdin;
1	impayes	Fix	{"nom": "NOM", "custom": {}, "montant": "MNT_FACT", "produit": null, "custcode": "CUSTCODE", "echeance": "ECHEANCE", "refFacture": "REF_FACT"}	ELHAIMER AMINE	2026-07-14 10:39:16.059235	2026-07-25 00:08:59.971
2	impayes	int	{"nom": "INT_CLI", "custom": {}, "montant": "MONTANT", "produit": null, "custcode": "CUSTCODE", "echeance": "ECHEANCE", "refFacture": "REF_FACT"}	ELHAIMER AMINE	2026-07-14 10:39:16.084163	2026-07-25 00:08:59.986
6	reglements	ENTRAIDE NATIONALE INTERNET 	{"nom": null, "custom": {}, "montant": "MONTANT", "produit": "PRODUIT", "custcode": "CUSTODE", "echeance": "ECHEANCE", "refFacture": "REF-FACT"}	ELHAIMER AMINE	2026-07-14 10:39:16.11541	2026-07-25 00:09:00.136
5	reglements	MINISTERE INTERNET	{"nom": null, "custom": {}, "montant": "MONTANT", "produit": "PRODUIT", "custcode": "CUSTODE", "echeance": "ECHEANCE", "refFacture": "REF-FACT"}	ELHAIMER AMINE	2026-07-14 10:39:16.108055	2026-07-25 00:09:00.276
4	reglements	MINISTERE FIXE 	{"nom": null, "custom": {}, "montant": "MONTANT", "produit": "PRODUIT", "custcode": "CUSTCODE", "echeance": "ECHEANCE", "refFacture": "REF_FACT"}	ELHAIMER AMINE	2026-07-14 10:39:16.101478	2026-07-25 00:09:00.305
3	reglements	ENTRAIDE NATIONALE FIXE 	{"nom": null, "custom": {}, "montant": "MONTANT", "produit": "PRODUIT", "custcode": "CUSTCODE", "echeance": "ECHEANCE", "refFacture": "REF_FACT"}	ELHAIMER AMINE	2026-07-14 10:39:16.092331	2026-07-25 00:09:00.36
\.


--
-- Data for Name: system_logs; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.system_logs (id, level, message, meta, created_at) FROM stdin;
1	info	Démarrage du serveur	{"port": 5000}	2026-07-16 09:06:39.387811
2	info	Démarrage du serveur	{"port": 5000}	2026-07-16 09:08:45.023584
3	info	Paramètres système modifiés	{"by": "SARA EL HAMADI", "changes": {"supportEmail": "el.amyne@gmail.com", "maintenanceMode": false, "organizationName": "Entraide Nationale", "maintenanceMessage": null, "sessionDurationDays": 30}}	2026-07-16 09:23:05.669402
4	error	Échec du lancement de pg_dump	{"error": "spawn pg_dump ENOENT"}	2026-07-16 09:23:23.906384
5	error	Échec de la sauvegarde de la base	{"code": -4058, "stderr": ""}	2026-07-16 09:23:23.968497
6	info	Démarrage du serveur	{"port": 5000}	2026-07-16 09:27:10.019646
7	info	Paramètres système modifiés	{"by": "SARA EL HAMADI", "changes": {"supportEmail": "el.amyne@gmail.com", "maintenanceMode": false, "organizationName": "Entraide Nationale", "maintenanceMessage": null, "sessionDurationDays": 30}}	2026-07-16 09:27:22.668026
8	error	Échec du lancement de pg_dump	{"error": "spawn pg_dump ENOENT"}	2026-07-16 09:27:25.759267
9	error	Échec de la sauvegarde de la base	{"code": -4058, "stderr": ""}	2026-07-16 09:27:25.7648
10	info	Démarrage du serveur	{"port": 5000}	2026-07-16 09:32:06.891591
11	info	Paramètres système modifiés	{"by": "ELHAIMER AMINE", "changes": {"supportEmail": "el.amyne@gmail.com", "maintenanceMode": false, "organizationName": "Entraide Nationale", "maintenanceMessage": null, "sessionDurationDays": 30}}	2026-07-16 09:33:03.535885
12	error	Échec du lancement de pg_dump	{"error": "spawn pg_dump ENOENT"}	2026-07-16 09:33:05.872312
13	error	Échec de la sauvegarde de la base	{"code": -4058, "stderr": ""}	2026-07-16 09:33:05.873884
14	info	Démarrage du serveur	{"port": 5000}	2026-07-16 09:36:31.960634
15	info	Sauvegarde de la base créée	{"by": "ELHAIMER AMINE", "filename": "entraide-iam-2026-07-16T08-36-57-673Z.sql"}	2026-07-16 09:36:58.511881
16	info	Paramètres système modifiés	{"by": "ELHAIMER AMINE", "changes": {"supportEmail": "el.amyne@gmail.com", "maintenanceMode": false, "organizationName": "Entraide Nationale", "maintenanceMessage": null, "sessionDurationDays": 30}}	2026-07-16 09:39:25.664268
17	info	Démarrage du serveur	{"port": 5000}	2026-07-16 12:32:55.192774
18	info	Démarrage du serveur	{"port": 5000}	2026-07-16 12:39:52.905354
19	info	Sauvegarde de la base créée	{"by": "SARA EL HAMADI", "filename": "entraide-iam-2026-07-16T11-40-45-662Z.sql"}	2026-07-16 12:40:46.034265
20	info	Paramètres système modifiés	{"by": "ELHAIMER AMINE", "changes": {"supportEmail": "el.amyne@gmail.com", "maintenanceMode": false, "organizationName": "Entraide Nationale", "maintenanceMessage": null, "sessionDurationDays": 30}}	2026-07-16 12:42:42.884729
21	info	Sauvegarde de la base créée	{"by": "ELHAIMER AMINE", "filename": "entraide-iam-2026-07-16T11-42-46-242Z.sql"}	2026-07-16 12:42:46.748275
22	info	Démarrage du serveur	{"port": 5000}	2026-07-17 01:30:05.274882
23	info	Démarrage du serveur	{"port": 5000}	2026-07-17 01:30:46.096876
24	info	Démarrage du serveur	{"port": 5000}	2026-07-17 01:33:15.399027
25	info	Démarrage du serveur	{"port": 5000}	2026-07-17 01:38:20.175641
26	info	Sauvegarde de la base créée	{"by": "ANAS JABRAN", "filename": "entraide-iam-2026-07-17T00-43-21-758Z.sql"}	2026-07-17 01:43:22.982758
27	info	Démarrage du serveur	{"port": 5000}	2026-07-17 02:03:14.473917
28	info	Sauvegarde de la base créée	{"by": "ELHAIMER AMINE", "filename": "entraide-iam-2026-07-17T01-05-04-381Z.sql"}	2026-07-17 02:05:04.988464
29	info	Démarrage du serveur	{"port": 5000}	2026-07-17 08:53:43.505546
30	info	Démarrage du serveur	{"port": 5000}	2026-07-17 08:54:48.347099
31	info	Démarrage du serveur	{"port": 5000}	2026-07-17 08:55:42.940252
32	info	Démarrage du serveur	{"port": 5000}	2026-07-17 08:56:42.363427
33	info	Démarrage du serveur	{"port": 5000}	2026-07-17 09:03:52.835167
34	info	Démarrage du serveur	{"port": 5000}	2026-07-17 09:04:16.52082
35	info	Démarrage du serveur	{"port": 5000}	2026-07-17 09:32:27.928837
36	info	Démarrage du serveur	{"port": 5000}	2026-07-17 09:38:18.400609
37	info	Démarrage du serveur	{"port": 5000}	2026-07-17 15:17:02.755437
38	info	Démarrage du serveur	{"port": 5000}	2026-07-17 15:26:14.426385
39	info	Démarrage du serveur	{"port": 5000}	2026-07-18 00:34:28.811394
40	info	Démarrage du serveur	{"port": 5000}	2026-07-18 00:35:03.572189
41	info	Démarrage du serveur	{"port": 5000}	2026-07-18 00:45:33.571313
42	info	Démarrage du serveur	{"port": 5000}	2026-07-18 11:04:15.508766
43	info	Démarrage du serveur	{"port": 5000}	2026-07-18 17:40:55.571799
44	info	Démarrage du serveur	{"port": 5000}	2026-07-18 17:42:02.740075
45	info	Démarrage du serveur	{"port": 5000}	2026-07-19 00:52:37.248385
46	info	Démarrage du serveur	{"port": 5000}	2026-07-19 00:56:35.761703
47	info	Démarrage du serveur	{"port": 5000}	2026-07-19 01:06:26.835588
48	info	Démarrage du serveur	{"port": 5000}	2026-07-19 01:14:39.909418
49	info	Démarrage du serveur	{"port": 5000}	2026-07-19 01:15:31.538593
50	info	Démarrage du serveur	{"port": 5000}	2026-07-19 01:19:46.436419
51	info	Démarrage du serveur	{"port": 5000}	2026-07-19 17:43:58.421549
52	info	Sauvegarde de la base créée	{"by": "ELHAIMER AMINE", "filename": "entraide-iam-2026-07-19T16-47-38-851Z.sql"}	2026-07-19 17:47:40.477623
53	info	Démarrage du serveur	{"port": 5000}	2026-07-19 17:48:11.339668
54	info	Démarrage du serveur	{"port": 5000}	2026-07-19 17:50:46.777861
55	info	Démarrage du serveur	{"port": 5000}	2026-07-20 00:49:09.252147
56	info	Démarrage du serveur	{"port": 5000}	2026-07-20 00:55:30.722532
57	info	Démarrage du serveur	{"port": 5000}	2026-07-20 00:59:26.167989
58	info	Démarrage du serveur	{"port": 5000}	2026-07-20 11:10:32.368999
59	info	Démarrage du serveur	{"port": 5000}	2026-07-21 01:10:53.344071
60	info	Démarrage du serveur	{"port": 5000}	2026-07-21 01:11:52.613159
61	warn	Élément supprimé définitivement depuis la corbeille	{"by": "ELHAIMER AMINE", "id": 1, "entity": "journal-entries"}	2026-07-21 01:21:03.541589
62	warn	Élément supprimé définitivement depuis la corbeille	{"by": "ELHAIMER AMINE", "id": 9, "entity": "users"}	2026-07-21 01:21:08.564527
63	info	Double authentification activée	{"by": "ELHAIMER AMINE", "userId": 3}	2026-07-21 01:45:41.848451
64	info	Démarrage du serveur	{"port": 5000}	2026-07-21 11:47:47.658051
65	info	Démarrage du serveur	{"port": 5000}	2026-07-21 11:48:32.807865
66	info	Démarrage du serveur	{"port": 5000}	2026-07-22 01:27:13.546139
67	info	Démarrage du serveur	{"port": 5000}	2026-07-22 14:07:10.992592
68	info	Démarrage du serveur	{"port": 5000}	2026-07-23 11:08:02.332873
69	info	Démarrage du serveur	{"port": 5000}	2026-07-23 11:34:35.797754
70	info	Paramètres système modifiés	{"by": "ELHAIMER AMINE", "changes": {"supportEmail": "el.amyne@gmail.com", "maintenanceMode": false, "organizationName": "Entraide Nationale", "backupScheduleHour": 2, "maintenanceMessage": null, "sessionDurationDays": 30, "backupScheduleEnabled": false, "backupScheduleFrequency": "daily"}}	2026-07-23 11:38:05.099346
71	info	Sauvegarde de la base créée	{"by": "ELHAIMER AMINE", "label": "manuelle", "filename": "entraide-iam-2026-07-23T10-38-44-603Z.sql"}	2026-07-23 11:38:46.625431
72	info	Démarrage du serveur	{"port": 5000}	2026-07-23 12:23:47.253694
73	info	Démarrage du serveur	{"port": 5000}	2026-07-23 13:04:29.777348
74	info	Démarrage du serveur	{"port": 5000}	2026-07-23 13:27:58.292306
75	info	Démarrage du serveur	{"port": 5000}	2026-07-23 13:28:33.943116
76	info	Démarrage du serveur	{"port": 5000}	2026-07-23 13:44:37.348784
77	info	Démarrage du serveur	{"port": 5000}	2026-07-23 15:04:52.765803
78	info	Démarrage du serveur	{"port": 5000}	2026-07-24 00:46:33.594128
79	info	Démarrage du serveur	{"port": 5000}	2026-07-24 00:53:31.737787
80	info	Démarrage du serveur	{"port": 5000}	2026-07-24 01:01:20.76109
81	info	Démarrage du serveur	{"port": 5000}	2026-07-24 01:02:54.941715
82	info	Démarrage du serveur	{"port": 5000}	2026-07-24 01:17:10.746769
83	info	Démarrage du serveur	{"port": 5000}	2026-07-24 02:00:16.135969
84	info	Démarrage du serveur	{"port": 5000}	2026-07-24 08:52:48.847846
85	info	Démarrage du serveur	{"port": 5000}	2026-07-24 08:54:58.327714
86	info	Démarrage du serveur	{"port": 5000}	2026-07-24 08:55:30.886506
87	info	Démarrage du serveur	{"port": 5000}	2026-07-24 12:25:35.388825
88	info	Démarrage du serveur	{"port": 5000}	2026-07-24 12:29:10.959661
89	info	Démarrage du serveur	{"port": 5000}	2026-07-25 00:55:31.512283
90	info	Démarrage du serveur	{"port": 5000}	2026-07-25 00:57:10.98308
91	info	Démarrage du serveur	{"port": 5000}	2026-07-25 01:14:50.268543
92	info	Démarrage du serveur	{"port": 5000}	2026-07-25 01:20:28.123557
93	info	Démarrage du serveur	{"port": 5000}	2026-07-25 13:03:21.860635
94	info	Démarrage du serveur	{"port": 5000}	2026-07-26 00:35:31.407169
95	info	Démarrage du serveur	{"port": 5000}	2026-07-26 00:47:48.075528
96	info	Démarrage du serveur	{"port": 5000}	2026-07-26 01:30:24.764299
97	warn	Élément supprimé définitivement depuis la corbeille	{"by": "ELHAIMER AMINE", "id": 10, "entity": "users"}	2026-07-26 01:31:53.595455
98	info	Démarrage du serveur	{"port": 5000}	2026-07-26 01:38:01.102879
99	info	Démarrage du serveur	{"port": 5000}	2026-07-26 01:38:40.135743
100	info	Démarrage du serveur	{"port": 5000}	2026-07-26 01:52:16.015065
101	info	Élément restauré depuis la corbeille	{"by": "ELHAIMER AMINE", "id": 11, "entity": "users"}	2026-07-26 02:17:40.473475
102	info	Démarrage du serveur	{"port": 5000}	2026-07-26 02:23:54.601709
103	info	Démarrage du serveur	{"port": 5000}	2026-07-26 02:24:23.343749
104	info	Démarrage du serveur	{"port": 5000}	2026-07-26 11:27:14.473396
105	info	Démarrage du serveur	{"port": 5000}	2026-07-26 11:36:34.900515
106	info	Démarrage du serveur	{"port": 5000}	2026-07-26 11:37:40.092017
107	info	Démarrage du serveur	{"port": 5000}	2026-07-26 11:42:41.686071
108	info	Démarrage du serveur	{"port": 5000}	2026-07-26 11:49:37.315408
109	info	Démarrage du serveur	{"port": 5000}	2026-07-26 11:56:48.79362
110	info	Démarrage du serveur	{"port": 5000}	2026-07-26 15:16:27.678083
111	info	Démarrage du serveur	{"port": 5000}	2026-07-26 15:18:40.123671
112	info	Démarrage du serveur	{"port": 5000}	2026-07-26 15:20:31.156544
113	info	Démarrage du serveur	{"port": 5000}	2026-07-26 15:29:41.098809
114	info	Démarrage du serveur	{"port": 5000}	2026-07-26 15:32:01.260907
115	info	Élément restauré depuis la corbeille	{"by": "ELHAIMER AMINE", "id": 11, "entity": "users"}	2026-07-26 15:34:57.572414
116	info	Démarrage du serveur	{"port": 5000}	2026-07-26 16:12:48.917098
117	info	Démarrage du serveur	{"port": 5000}	2026-07-26 16:35:16.668432
118	info	Démarrage du serveur	{"port": 5000}	2026-07-26 16:35:58.489506
119	info	Démarrage du serveur	{"port": 5000}	2026-07-26 16:38:37.238925
120	info	Démarrage du serveur	{"port": 5000}	2026-07-26 16:38:51.040115
121	info	Démarrage du serveur	{"port": 5000}	2026-07-26 16:44:34.945695
122	info	Démarrage du serveur	{"port": 5000}	2026-07-26 16:58:23.443241
123	info	Démarrage du serveur	{"port": 5000}	2026-07-26 17:06:14.201118
124	info	Démarrage du serveur	{"port": 5000}	2026-07-26 23:53:40.936416
125	info	Démarrage du serveur	{"port": 5000}	2026-07-26 23:54:10.177407
126	info	Démarrage du serveur	{"port": 5000}	2026-07-27 00:00:53.380604
127	warn	Élément supprimé définitivement depuis la corbeille	{"by": "ELHAIMER AMINE", "id": 11, "entity": "users"}	2026-07-27 00:02:25.362513
128	warn	Élément supprimé définitivement depuis la corbeille	{"by": "ELHAIMER AMINE", "id": 12, "entity": "users"}	2026-07-27 00:02:28.373983
129	warn	Élément supprimé définitivement depuis la corbeille	{"by": "ELHAIMER AMINE", "id": 8, "entity": "users"}	2026-07-27 00:02:34.60306
130	info	Démarrage du serveur	{"port": 5000}	2026-07-27 00:18:45.618337
131	info	Démarrage du serveur	{"port": 5000}	2026-07-27 00:27:41.788327
132	info	Démarrage du serveur	{"port": 5000}	2026-07-27 00:30:48.320475
133	info	Démarrage du serveur	{"port": 5000}	2026-07-27 00:32:03.081823
134	info	Démarrage du serveur	{"port": 5000}	2026-07-27 00:33:33.893034
135	info	Démarrage du serveur	{"port": 5000}	2026-07-27 00:44:11.922063
136	info	Démarrage du serveur	{"port": 5000}	2026-07-27 00:45:33.723941
137	info	Démarrage du serveur	{"port": 5000}	2026-07-27 00:46:01.083893
138	info	Démarrage du serveur	{"port": 5000}	2026-07-27 00:46:57.711499
139	info	Démarrage du serveur	{"port": 5000}	2026-07-27 00:55:31.76069
140	warn	Élément supprimé définitivement depuis la corbeille	{"by": "ELHAIMER AMINE", "id": 13, "entity": "users"}	2026-07-27 01:23:35.150953
141	info	Démarrage du serveur	{"port": 5000}	2026-07-27 01:31:58.573714
142	info	Démarrage du serveur	{"port": 5000}	2026-07-27 01:35:34.815422
143	info	Démarrage du serveur	{"port": 5000}	2026-07-27 01:41:20.635713
144	info	Démarrage du serveur	{"port": 5000}	2026-07-27 01:44:47.992075
145	warn	Élément supprimé définitivement depuis la corbeille	{"by": "ELHAIMER AMINE", "id": 14, "entity": "users"}	2026-07-27 01:49:45.614423
146	info	Démarrage du serveur	{"port": 5000}	2026-07-27 01:50:42.866157
147	info	Démarrage du serveur	{"port": 5000}	2026-07-27 01:59:37.704898
148	warn	Élément supprimé définitivement depuis la corbeille	{"by": "ELHAIMER AMINE", "id": 16, "entity": "users"}	2026-07-27 02:03:21.585997
149	warn	Élément supprimé définitivement depuis la corbeille	{"by": "ELHAIMER AMINE", "id": 15, "entity": "users"}	2026-07-27 02:03:24.986304
150	info	Paramètres système modifiés	{"by": "ELHAIMER AMINE", "changes": {"supportEmail": "el.amyne@gmail.com", "maintenanceMode": false, "organizationName": "Entraide Nationale", "backupScheduleHour": 2, "maintenanceMessage": null, "sessionDurationDays": 30, "backupScheduleEnabled": true, "backupScheduleFrequency": "daily"}}	2026-07-27 02:05:05.165634
151	info	Sauvegarde de la base créée	{"by": "ELHAIMER AMINE", "label": "manuelle", "filename": "entraide-iam-2026-07-27T01-05-11-643Z.sql"}	2026-07-27 02:05:13.629662
152	info	Démarrage du serveur	{"port": 5000}	2026-07-27 02:39:59.609721
153	info	Démarrage du serveur	{"port": 5000}	2026-07-27 02:40:45.540412
154	info	Démarrage du serveur	{"port": 5000}	2026-07-27 02:42:42.637523
155	info	Démarrage du serveur	{"port": 5000}	2026-07-27 02:44:51.92227
156	info	Démarrage du serveur	{"port": 5000}	2026-07-27 02:49:52.826207
157	info	Démarrage du serveur	{"port": 5000}	2026-07-27 02:51:57.869441
158	info	Démarrage du serveur	{"port": 5000}	2026-07-27 09:46:01.05112
159	info	Démarrage du serveur	{"port": 5000}	2026-07-27 09:46:30.421925
160	warn	Élément supprimé définitivement depuis la corbeille	{"by": "ELHAIMER AMINE", "id": 17, "entity": "users"}	2026-07-27 10:18:58.406562
161	warn	Élément supprimé définitivement depuis la corbeille	{"by": "ELHAIMER AMINE", "id": 18, "entity": "users"}	2026-07-27 10:19:47.069168
162	info	Démarrage du serveur	{"port": 5000}	2026-07-27 12:01:49.113673
163	info	Démarrage du serveur	{"port": 5000}	2026-07-27 12:02:18.985532
164	warn	Élément supprimé définitivement depuis la corbeille	{"by": "ELHAIMER AMINE", "id": 19, "entity": "users"}	2026-07-27 12:04:35.030875
165	info	Démarrage du serveur	{"port": 5000}	2026-07-27 12:09:03.297619
166	info	Démarrage du serveur	{"port": 5000}	2026-07-27 12:20:42.920505
167	info	Démarrage du serveur	{"port": 5000}	2026-07-27 13:11:48.297313
168	info	Démarrage du serveur	{"port": 5000}	2026-07-27 13:21:38.412343
169	info	Démarrage du serveur	{"port": 5000}	2026-07-27 13:22:33.374103
170	info	Démarrage du serveur	{"port": 5000}	2026-07-27 13:23:34.813251
171	info	Démarrage du serveur	{"port": 5000}	2026-07-27 13:24:03.38854
172	info	Démarrage du serveur	{"port": 5000}	2026-07-27 13:24:37.421484
173	warn	Élément supprimé définitivement depuis la corbeille	{"by": "ELHAIMER AMINE", "id": 21, "entity": "users"}	2026-07-27 13:32:34.60271
174	warn	Élément supprimé définitivement depuis la corbeille	{"by": "ELHAIMER AMINE", "id": 20, "entity": "users"}	2026-07-27 13:32:38.385928
175	info	Démarrage du serveur	{"port": 5000}	2026-07-27 13:33:54.910783
176	info	Démarrage du serveur	{"port": 5000}	2026-07-27 13:38:00.95107
177	info	Démarrage du serveur	{"port": 5000}	2026-07-27 13:52:08.218403
178	info	Démarrage du serveur	{"port": 5000}	2026-07-27 13:52:48.151762
179	info	Démarrage du serveur	{"port": 5000}	2026-07-27 13:57:56.204396
180	info	Démarrage du serveur	{"port": 5000}	2026-07-27 14:08:42.619602
181	info	Démarrage du serveur	{"port": 5000}	2026-07-27 14:11:20.21751
182	info	Démarrage du serveur	{"port": 5000}	2026-07-27 14:14:52.567414
183	info	Démarrage du serveur	{"port": 5000}	2026-07-27 14:36:04.706292
184	info	Démarrage du serveur	{"port": 5000}	2026-07-27 15:09:25.906014
185	info	Démarrage du serveur	{"port": 5000}	2026-07-27 15:18:19.629077
186	info	Démarrage du serveur	{"port": 5000}	2026-07-27 15:19:32.954502
187	info	Démarrage du serveur	{"port": 5000}	2026-07-27 15:23:14.371861
188	info	Démarrage du serveur	{"port": 5000}	2026-07-27 21:29:19.097647
189	info	Démarrage du serveur	{"port": 5000}	2026-07-27 21:31:45.236151
190	info	Démarrage du serveur	{"port": 5000}	2026-07-27 21:36:48.694133
191	info	Démarrage du serveur	{"port": 5000}	2026-07-27 21:53:31.585352
192	info	Démarrage du serveur	{"port": 5000}	2026-07-28 00:01:01.558499
193	info	Démarrage du serveur	{"port": 5000}	2026-07-28 00:12:35.349037
194	info	Démarrage du serveur	{"port": 5000}	2026-07-28 00:15:11.416048
195	info	Démarrage du serveur	{"port": 5000}	2026-07-28 00:55:05.809562
196	info	Démarrage du serveur	{"port": 5000}	2026-07-28 01:16:40.179374
197	info	Démarrage du serveur	{"port": 5000}	2026-07-28 01:17:27.613419
198	info	Démarrage du serveur	{"port": 5000}	2026-07-28 01:42:56.154485
\.


--
-- Data for Name: system_settings; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.system_settings (id, organization_name, support_email, session_duration_days, maintenance_mode, maintenance_message, updated_by, updated_at, backup_schedule_enabled, backup_schedule_frequency, backup_schedule_hour) FROM stdin;
1	Entraide Nationale	el.amyne@gmail.com	30	f	\N	ELHAIMER AMINE	2026-07-27 01:05:05.156	t	daily	2
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.users (id, username, password_hash, display_name, created_at, updated_at, role, is_active, last_login_at, deleted_at, deleted_by, last_seen_at, two_factor_enabled, two_factor_secret, chauffeur_id) FROM stdin;
4	TEST	$2a$10$oHQzS0lgcWBl0hJN6LYVBeidmqea/NeDeCAoFP2DEvQC7AjgztHR2	TEST 	2026-07-11 16:33:02.368198	2026-07-11 16:33:02.368198	USER	t	2026-07-15 23:02:47.239	2026-07-22 00:31:06.033	ELHAIMER AMINE	\N	f	\N	\N
2	ANAS JABRAN	$2a$10$AIfIf0kYSqp4FP70Z9CbleB2FdYArHkpKF2/FWC7BvWJEZksIOw0W	ANAS JABRAN 	2026-07-11 16:25:49.299453	2026-07-26 23:35:13.172	SUPER_ADMIN	t	2026-07-19 00:07:52.047	\N	\N	2026-07-19 00:08:19.041	f	\N	\N
24	youssef	$2a$10$l2KZzlk89UhxpzvSjk5nNO/QAALvt6jHNidSiFaRjIRMeAa/x8WIG	youssef	2026-07-27 14:06:57.547558	2026-07-27 14:06:57.547558	CHAUFFEUR	t	\N	\N	\N	\N	f	\N	\N
3	ELHAIMER AMINE	$2a$10$Ypnz.MvIYji7MqINHwloQOzTo4KgbSm5g/WuhZ45xFNAEQ0Jub.4K	ELHAIMER AMINE	2026-07-11 16:29:31.7373	2026-07-21 00:45:41.835	SUPER_ADMIN	t	2026-07-27 23:17:47.654	\N	\N	2026-07-28 01:12:36.222	t	Z3R2AFJBBKLHGJYST6G4PIPCPFEX2HAU	\N
22	SMAIL YASSINE	$2a$10$6wYG/lrBuAkUTXaxTEdPJeTgy4vjDk.AvhDUG1HIDMY32.WS4uOse	SMAIL YASSINE	2026-07-27 13:33:21.748621	2026-07-27 13:33:21.748621	CHAUFFEUR	t	2026-07-28 00:44:15.834	\N	\N	2026-07-28 01:12:46.789	f	\N	\N
7	superadmin	$2a$10$bcadPkD7ArUaN5J0EyIuzeDcbLX46pNGZheLxVb/6SUZznwARKXNa	superadmin	2026-07-14 14:49:13.1683	2026-07-15 22:59:43.542	SUPER_ADMIN	t	2026-07-15 23:40:55.699	\N	\N	\N	f	\N	\N
25	smail.yassine	$2a$10$H8QU9t4vwDmeELAEH3g.KeaHe.LFcqMMFL8jJpG0TaJyBoSyCzc..	SMAIL YASSINE	2026-07-28 00:11:07.7636	2026-07-28 00:11:07.7636	CHAUFFEUR	t	\N	\N	\N	\N	f	\N	\N
6	SARA EL HAMADI	$2a$10$isoVJcN85EJqgwoHQUHEJ.JMsIq39ky.rmlsJ5KLN13HSBmoqPm6G	SARA EL HAMADI	2026-07-13 12:57:11.745503	2026-07-13 12:57:11.745503	SUPER_ADMIN	t	2026-07-16 11:40:04.295	\N	\N	\N	f	\N	\N
\.


--
-- Data for Name: vehicule_events; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.vehicule_events (id, vehicule_id, statut, commentaire, action_par, created_at) FROM stdin;
1	1	disponible	Véhicule ajouté au parc.	ELHAIMER AMINE	2026-07-24 09:16:32.860029
2	1	hors_service	\N	ELHAIMER AMINE	2026-07-24 09:16:44.068419
3	1	disponible	\N	ELHAIMER AMINE	2026-07-24 09:16:49.998292
4	1	en_mission	Départ en mission — OM-2026-0001.	ELHAIMER AMINE	2026-07-24 09:18:36.063434
5	1	disponible	Retour de mission — OM-2026-0001.	ELHAIMER AMINE	2026-07-24 09:20:48.793363
6	1	en_mission	Départ en mission — OM-2026-0003.	ELHAIMER AMINE	2026-07-24 11:49:26.328587
7	1	disponible	Retour de mission — OM-2026-0003.	ELHAIMER AMINE	2026-07-24 11:49:38.885919
8	1	hors_service	\N	ELHAIMER AMINE	2026-07-24 11:51:46.5332
9	1	disponible	\N	ELHAIMER AMINE	2026-07-24 11:51:49.130865
10	1	en_mission	Départ en mission — OM-2026-0004.	ELHAIMER AMINE	2026-07-25 01:03:45.33662
11	1	disponible	Retour de mission — OM-2026-0004.	ELHAIMER AMINE	2026-07-25 01:04:07.518962
12	1	en_mission	Départ en mission — OM-2026-0005.	ELHAIMER AMINE	2026-07-25 01:06:51.02253
13	1	disponible	Retour de mission — OM-2026-0005.	ELHAIMER AMINE	2026-07-26 00:38:48.231211
14	1	en_mission	Départ en mission — OM-2026-0006.	ELHAIMER AMINE	2026-07-26 00:44:06.170821
15	1	disponible	Retour de mission — OM-2026-0006.	ELHAIMER AMINE	2026-07-26 00:49:26.703791
16	1	en_mission	Départ en mission — OM-2026-0007.	ELHAIMER AMINE	2026-07-26 01:09:50.51011
17	2	disponible	Véhicule ajouté au parc.	ELHAIMER AMINE	2026-07-26 01:39:48.980303
18	2	maintenance	\N	ELHAIMER AMINE	2026-07-26 01:44:09.465628
19	2	disponible	\N	ELHAIMER AMINE	2026-07-26 01:44:11.30448
20	2	en_mission	Départ en mission — OM-2026-0008.	ELHAIMER AMINE	2026-07-26 01:44:31.615521
21	3	disponible	Véhicule ajouté au parc.	ELHAIMER AMINE	2026-07-26 01:56:51.04444
22	3	en_mission	Départ en mission — OM-2026-0009.	ELHAIMER AMINE	2026-07-26 01:58:47.353514
23	4	disponible	Véhicule ajouté au parc.	ELHAIMER AMINE	2026-07-26 02:12:23.068288
24	4	en_mission	Départ en mission — OM-2026-0010.	ELHAIMER AMINE	2026-07-26 02:15:01.776232
25	4	disponible	Retour de mission — OM-2026-0010.	ELHAIMER AMINE	2026-07-26 02:25:17.603596
26	4	en_mission	Départ en mission — OM-2026-0011.	ELHAIMER AMINE	2026-07-26 02:28:31.370592
27	4	disponible	Retour de mission — OM-2026-0011.	ELHAIMER AMINE	2026-07-26 02:33:04.807504
28	4	en_mission	Départ en mission — OM-2026-0012.	ELHAIMER AMINE	2026-07-26 02:34:42.779931
29	4	disponible	Retour de mission — OM-2026-0012.	ELHAIMER AMINE	2026-07-26 02:35:00.008129
30	4	en_mission	Départ en mission — OM-2026-0013.	ELHAIMER AMINE	2026-07-26 11:29:14.754942
31	4	disponible	Retour de mission — OM-2026-0013.	ELHAIMER AMINE	2026-07-26 11:50:48.490462
32	4	en_mission	Départ en mission — OM-2026-0014.	ELHAIMER AMINE	2026-07-26 11:58:45.378213
33	4	disponible	Retour de mission — OM-2026-0014.	ELHAIMER AMINE	2026-07-26 11:59:47.553209
34	4	en_mission	Départ en mission — OM-2026-0015.	ELHAIMER AMINE	2026-07-26 15:37:24.8926
35	4	disponible	Retour de mission — OM-2026-0015.	ELHAIMER AMINE	2026-07-26 15:37:59.107422
36	4	en_mission	Départ en mission — OM-2026-0016.	ELHAIMER AMINE	2026-07-26 16:15:03.594752
37	4	disponible	Retour de mission — OM-2026-0015.	ELHAIMER AMINE	2026-07-26 16:36:45.106237
38	4	disponible	Retour de mission — OM-2026-0016.	ELHAIMER AMINE	2026-07-26 16:36:48.378222
39	4	en_mission	Départ en mission — OM-2026-0017.	ELHAIMER AMINE	2026-07-26 16:42:56.115037
40	4	disponible	Retour de mission — OM-2026-0017.	ELHAIMER AMINE	2026-07-26 16:45:12.275956
41	4	en_mission	Départ en mission — OM-2026-0018.	ELHAIMER AMINE	2026-07-26 16:49:17.152152
42	4	disponible	Retour de mission — OM-2026-0018.	ELHAIMER AMINE	2026-07-26 17:06:46.611243
43	4	en_mission	Départ en mission — OM-2026-0023.	ELHAIMER AMINE	2026-07-27 02:53:29.79784
44	4	disponible	Retour de mission — OM-2026-0023.	ELHAIMER AMINE	2026-07-27 02:54:26.22645
45	4	en_mission	Départ en mission — OM-2026-0025.	ELHAIMER AMINE	2026-07-27 13:31:44.915027
46	4	disponible	Retour de mission — OM-2026-0025.	ELHAIMER AMINE	2026-07-27 13:32:01.265055
47	4	en_mission	Départ en mission — OM-2026-0027.	ELHAIMER AMINE	2026-07-27 14:00:47.965239
48	4	disponible	Retour de mission — OM-2026-0027.	ELHAIMER AMINE	2026-07-27 14:00:53.722704
49	4	en_mission	Départ en mission — OM-2026-0028 (accepté par SMAIL YASSINE).	SMAIL YASSINE	2026-07-27 14:37:43.955493
50	4	disponible	Retour de mission — OM-2026-0028.	SMAIL YASSINE	2026-07-27 14:38:09.921808
51	4	en_mission	Départ en mission — OM-2026-0029 (accepté par SMAIL YASSINE).	SMAIL YASSINE	2026-07-27 14:43:17.848548
52	4	disponible	Retour de mission — OM-2026-0029.	SMAIL YASSINE	2026-07-27 14:43:57.478703
53	4	maintenance	\N	ELHAIMER AMINE	2026-07-27 14:48:00.990718
54	4	disponible	\N	ELHAIMER AMINE	2026-07-27 14:48:08.620888
55	4	hors_service	\N	ELHAIMER AMINE	2026-07-27 14:48:12.502095
56	4	disponible	\N	ELHAIMER AMINE	2026-07-27 14:48:17.412308
57	4	en_mission	Accepté par le chauffeur — OM-2026-0031.	SMAIL YASSINE	2026-07-28 01:04:38.904518
58	4	disponible	Mission clôturée — OM-2026-0031.	ELHAIMER AMINE	2026-07-28 01:07:35.234358
59	4	en_mission	Accepté par le chauffeur — OM-2026-0033.	SMAIL YASSINE	2026-07-28 01:47:17.081806
60	4	disponible	Mission clôturée — OM-2026-0033.	ELHAIMER AMINE	2026-07-28 01:49:20.117695
61	4	en_mission	Accepté par le chauffeur — OM-2026-0034.	SMAIL YASSINE	2026-07-28 02:12:51.086475
\.


--
-- Data for Name: vehicules; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.vehicules (id, immatriculation, marque, modele, annee, carburant, kilometrage, statut, assurance_expiration, visite_technique_expiration, chauffeur_attitre_id, notes, deleted_at, deleted_by, created_at, updated_at) FROM stdin;
4	12344-A-1	DACIA	LOGAN	2026	diesel	20000	en_mission	26/02/2027	26/06/2027	\N	\N	\N	\N	2026-07-26 02:12:23.056762	2026-07-28 01:12:51.084
1	12345-A-1	DACIA	LOGAN	2026	diesel	21000	en_mission	24/02/2027	\N	\N	\N	2026-07-26 00:26:39.879	ELHAIMER AMINE	2026-07-24 09:16:32.84251	2026-07-26 00:09:50.482
2	123467-A-1	DACIA	LOGAN	2026	diesel	20000	en_mission	26/07/2026	26/08/2026	\N	\N	2026-07-26 00:56:01.684	ELHAIMER AMINE	2026-07-26 01:39:48.964498	2026-07-26 00:44:31.601
3	123456-A-1	DACIA	LOGAN	2026	diesel	20000	en_mission	26/03/2027	26/07/2027	\N	\N	2026-07-26 01:11:44.533	ELHAIMER AMINE	2026-07-26 01:56:51.03269	2026-07-26 00:58:47.341
\.


--
-- Data for Name: whatsapp_messages; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.whatsapp_messages (id, to_phone, message, kind, related_id, status, wa_message_id, error, sent_by, sent_at, read_at) FROM stdin;
1	0602799998	Ceci est un message de test envoyé depuis la Plateforme IAM d’Entraide Nationale.	test	\N	failed	\N	Unsupported post request. Object with ID '...' does not exist, cannot be loaded due to missing permissions, or does not support this operation. Please read the Graph API documentation at https://developers.facebook.com/docs/graph-api	ELHAIMER AMINE	2026-07-22 01:27:50.496554	\N
2	212602799998	Ceci est un message de test envoyé depuis la Plateforme IAM d’Entraide Nationale.	test	\N	failed	\N	Unsupported post request. Object with ID '...' does not exist, cannot be loaded due to missing permissions, or does not support this operation. Please read the Graph API documentation at https://developers.facebook.com/docs/graph-api	ELHAIMER AMINE	2026-07-23 12:32:47.011978	\N
\.


--
-- Data for Name: correction_rules; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.correction_rules (id, source_sheet_name, target_sheet_name, created_by, created_at) FROM stdin;
\.


--
-- Data for Name: custom_fields; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.custom_fields (id, label, use_as_match_key, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: lignes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.lignes (id, categorie, type_forfait, type_mobile, icc, imei, affecte, personne, qualite, date, created_at, updated_at) FROM stdin;
2	CAT 2	30G	IPHONE 17	34567IO	34567890	DIRECTION	ELHAIMER	Communication et Coopération	25/06/2026	2026-06-25 13:23:22.510173	2026-06-25 13:23:22.510173
1	CAT 1	Test	Samsung	123456	987654	DIRECTION	AMINE	Division de l'Ingénierie Sociale	25/06/2026	2026-06-25 02:35:00.938101	2026-06-28 00:43:15.843
26	CAT 2	50 G	IPHONE	3456789	4567890	DIRECTION	ISSAM	Service des Statistiques et des Indicateurs	2026-07-01	2026-07-01 12:05:33.128833	2026-07-01 11:06:04.579
\.


--
-- Data for Name: sheet_rules; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sheet_rules (id, role, sheet_name, mapping, updated_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, username, password_hash, display_name, role, created_at, updated_at) FROM stdin;
\.


--
-- Name: activity_logs_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.activity_logs_id_seq', 16, true);


--
-- Name: audit_logs_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.audit_logs_id_seq', 768, true);


--
-- Name: calendar_events_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.calendar_events_id_seq', 1, false);


--
-- Name: chauffeur_events_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.chauffeur_events_id_seq', 40, true);


--
-- Name: chauffeurs_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.chauffeurs_id_seq', 25, true);


--
-- Name: connection_logs_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.connection_logs_id_seq', 149, true);


--
-- Name: correction_rules_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.correction_rules_id_seq', 5, true);


--
-- Name: custom_fields_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.custom_fields_id_seq', 1, false);


--
-- Name: deplacement_events_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.deplacement_events_id_seq', 24, true);


--
-- Name: deplacement_gps_points_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.deplacement_gps_points_id_seq', 1, false);


--
-- Name: deplacement_passagers_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.deplacement_passagers_id_seq', 30, true);


--
-- Name: deplacement_photos_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.deplacement_photos_id_seq', 1, false);


--
-- Name: deplacements_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.deplacements_id_seq', 34, true);


--
-- Name: email_logs_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.email_logs_id_seq', 50, true);


--
-- Name: factures_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.factures_id_seq', 1222, true);


--
-- Name: journal_entries_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.journal_entries_id_seq', 2, true);


--
-- Name: lignes_fixes_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.lignes_fixes_id_seq', 1221, true);


--
-- Name: lignes_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.lignes_id_seq', 8, true);


--
-- Name: org_nodes_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.org_nodes_id_seq', 72, true);


--
-- Name: service_request_events_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.service_request_events_id_seq', 28, true);


--
-- Name: service_requests_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.service_requests_id_seq', 4, true);


--
-- Name: sessions_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.sessions_id_seq', 78, true);


--
-- Name: sheet_rules_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.sheet_rules_id_seq', 6, true);


--
-- Name: system_logs_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.system_logs_id_seq', 198, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.users_id_seq', 25, true);


--
-- Name: vehicule_events_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.vehicule_events_id_seq', 61, true);


--
-- Name: vehicules_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.vehicules_id_seq', 4, true);


--
-- Name: whatsapp_messages_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.whatsapp_messages_id_seq', 2, true);


--
-- Name: correction_rules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.correction_rules_id_seq', 1, false);


--
-- Name: custom_fields_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.custom_fields_id_seq', 1, false);


--
-- Name: lignes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.lignes_id_seq', 26, true);


--
-- Name: sheet_rules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sheet_rules_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- Name: activity_logs activity_logs_pkey; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.activity_logs
    ADD CONSTRAINT activity_logs_pkey PRIMARY KEY (id);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: calendar_events calendar_events_pkey; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.calendar_events
    ADD CONSTRAINT calendar_events_pkey PRIMARY KEY (id);


--
-- Name: chauffeur_events chauffeur_events_pkey; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.chauffeur_events
    ADD CONSTRAINT chauffeur_events_pkey PRIMARY KEY (id);


--
-- Name: chauffeurs chauffeurs_pkey; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.chauffeurs
    ADD CONSTRAINT chauffeurs_pkey PRIMARY KEY (id);


--
-- Name: connection_logs connection_logs_pkey; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.connection_logs
    ADD CONSTRAINT connection_logs_pkey PRIMARY KEY (id);


--
-- Name: correction_rules correction_rules_pkey; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.correction_rules
    ADD CONSTRAINT correction_rules_pkey PRIMARY KEY (id);


--
-- Name: correction_rules correction_rules_source_target_unique; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.correction_rules
    ADD CONSTRAINT correction_rules_source_target_unique UNIQUE (source_sheet_name, target_sheet_name);


--
-- Name: custom_fields custom_fields_pkey; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.custom_fields
    ADD CONSTRAINT custom_fields_pkey PRIMARY KEY (id);


--
-- Name: dashboard_snapshot dashboard_snapshot_pkey; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.dashboard_snapshot
    ADD CONSTRAINT dashboard_snapshot_pkey PRIMARY KEY (id);


--
-- Name: deplacement_events deplacement_events_pkey; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.deplacement_events
    ADD CONSTRAINT deplacement_events_pkey PRIMARY KEY (id);


--
-- Name: deplacement_gps_points deplacement_gps_points_pkey; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.deplacement_gps_points
    ADD CONSTRAINT deplacement_gps_points_pkey PRIMARY KEY (id);


--
-- Name: deplacement_passagers deplacement_passagers_pkey; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.deplacement_passagers
    ADD CONSTRAINT deplacement_passagers_pkey PRIMARY KEY (id);


--
-- Name: deplacement_photos deplacement_photos_pkey; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.deplacement_photos
    ADD CONSTRAINT deplacement_photos_pkey PRIMARY KEY (id);


--
-- Name: deplacements deplacements_numero_key; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.deplacements
    ADD CONSTRAINT deplacements_numero_key UNIQUE (numero);


--
-- Name: deplacements deplacements_pkey; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.deplacements
    ADD CONSTRAINT deplacements_pkey PRIMARY KEY (id);


--
-- Name: email_logs email_logs_pkey; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.email_logs
    ADD CONSTRAINT email_logs_pkey PRIMARY KEY (id);


--
-- Name: factures factures_custcode_ref_unique; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.factures
    ADD CONSTRAINT factures_custcode_ref_unique UNIQUE (custcode, ref_facture);


--
-- Name: factures factures_pkey; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.factures
    ADD CONSTRAINT factures_pkey PRIMARY KEY (id);


--
-- Name: journal_entries journal_entries_pkey; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.journal_entries
    ADD CONSTRAINT journal_entries_pkey PRIMARY KEY (id);


--
-- Name: lignes_fixes lignes_fixes_pkey; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.lignes_fixes
    ADD CONSTRAINT lignes_fixes_pkey PRIMARY KEY (id);


--
-- Name: lignes lignes_pkey; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.lignes
    ADD CONSTRAINT lignes_pkey PRIMARY KEY (id);


--
-- Name: notification_reads notification_reads_pkey; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.notification_reads
    ADD CONSTRAINT notification_reads_pkey PRIMARY KEY (user_id);


--
-- Name: org_nodes org_nodes_pkey; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.org_nodes
    ADD CONSTRAINT org_nodes_pkey PRIMARY KEY (id);


--
-- Name: service_request_events service_request_events_pkey; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.service_request_events
    ADD CONSTRAINT service_request_events_pkey PRIMARY KEY (id);


--
-- Name: service_requests service_requests_numero_key; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.service_requests
    ADD CONSTRAINT service_requests_numero_key UNIQUE (numero);


--
-- Name: service_requests service_requests_pkey; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.service_requests
    ADD CONSTRAINT service_requests_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_jti_key; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.sessions
    ADD CONSTRAINT sessions_jti_key UNIQUE (jti);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sheet_rules sheet_rules_pkey; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.sheet_rules
    ADD CONSTRAINT sheet_rules_pkey PRIMARY KEY (id);


--
-- Name: sheet_rules sheet_rules_role_sheet_unique; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.sheet_rules
    ADD CONSTRAINT sheet_rules_role_sheet_unique UNIQUE (role, sheet_name);


--
-- Name: system_logs system_logs_pkey; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.system_logs
    ADD CONSTRAINT system_logs_pkey PRIMARY KEY (id);


--
-- Name: system_settings system_settings_pkey; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.system_settings
    ADD CONSTRAINT system_settings_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_unique; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);


--
-- Name: vehicule_events vehicule_events_pkey; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.vehicule_events
    ADD CONSTRAINT vehicule_events_pkey PRIMARY KEY (id);


--
-- Name: vehicules vehicules_immatriculation_key; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.vehicules
    ADD CONSTRAINT vehicules_immatriculation_key UNIQUE (immatriculation);


--
-- Name: vehicules vehicules_pkey; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.vehicules
    ADD CONSTRAINT vehicules_pkey PRIMARY KEY (id);


--
-- Name: whatsapp_messages whatsapp_messages_pkey; Type: CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.whatsapp_messages
    ADD CONSTRAINT whatsapp_messages_pkey PRIMARY KEY (id);


--
-- Name: correction_rules correction_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.correction_rules
    ADD CONSTRAINT correction_rules_pkey PRIMARY KEY (id);


--
-- Name: correction_rules correction_rules_source_target_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.correction_rules
    ADD CONSTRAINT correction_rules_source_target_unique UNIQUE (source_sheet_name, target_sheet_name);


--
-- Name: custom_fields custom_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_fields
    ADD CONSTRAINT custom_fields_pkey PRIMARY KEY (id);


--
-- Name: lignes lignes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lignes
    ADD CONSTRAINT lignes_pkey PRIMARY KEY (id);


--
-- Name: sheet_rules sheet_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sheet_rules
    ADD CONSTRAINT sheet_rules_pkey PRIMARY KEY (id);


--
-- Name: sheet_rules sheet_rules_role_sheet_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sheet_rules
    ADD CONSTRAINT sheet_rules_role_sheet_unique UNIQUE (role, sheet_name);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);


--
-- Name: audit_logs_created_at_idx; Type: INDEX; Schema: iam; Owner: -
--

CREATE INDEX audit_logs_created_at_idx ON iam.audit_logs USING btree (created_at DESC);


--
-- Name: audit_logs_entity_idx; Type: INDEX; Schema: iam; Owner: -
--

CREATE INDEX audit_logs_entity_idx ON iam.audit_logs USING btree (entity);


--
-- Name: chauffeur_events_chauffeur_idx; Type: INDEX; Schema: iam; Owner: -
--

CREATE INDEX chauffeur_events_chauffeur_idx ON iam.chauffeur_events USING btree (chauffeur_id);


--
-- Name: chauffeurs_statut_idx; Type: INDEX; Schema: iam; Owner: -
--

CREATE INDEX chauffeurs_statut_idx ON iam.chauffeurs USING btree (statut);


--
-- Name: connection_logs_created_at_idx; Type: INDEX; Schema: iam; Owner: -
--

CREATE INDEX connection_logs_created_at_idx ON iam.connection_logs USING btree (created_at DESC);


--
-- Name: deplacement_events_dep_idx; Type: INDEX; Schema: iam; Owner: -
--

CREATE INDEX deplacement_events_dep_idx ON iam.deplacement_events USING btree (deplacement_id);


--
-- Name: deplacement_gps_created_at_idx; Type: INDEX; Schema: iam; Owner: -
--

CREATE INDEX deplacement_gps_created_at_idx ON iam.deplacement_gps_points USING btree (created_at DESC);


--
-- Name: deplacement_gps_dep_idx; Type: INDEX; Schema: iam; Owner: -
--

CREATE INDEX deplacement_gps_dep_idx ON iam.deplacement_gps_points USING btree (deplacement_id);


--
-- Name: deplacement_passagers_deplacement_idx; Type: INDEX; Schema: iam; Owner: -
--

CREATE INDEX deplacement_passagers_deplacement_idx ON iam.deplacement_passagers USING btree (deplacement_id);


--
-- Name: deplacement_photos_dep_idx; Type: INDEX; Schema: iam; Owner: -
--

CREATE INDEX deplacement_photos_dep_idx ON iam.deplacement_photos USING btree (deplacement_id);


--
-- Name: deplacements_statut_idx; Type: INDEX; Schema: iam; Owner: -
--

CREATE INDEX deplacements_statut_idx ON iam.deplacements USING btree (statut);


--
-- Name: deplacements_vehicule_idx; Type: INDEX; Schema: iam; Owner: -
--

CREATE INDEX deplacements_vehicule_idx ON iam.deplacements USING btree (vehicule_id);


--
-- Name: factures_custcode_idx; Type: INDEX; Schema: iam; Owner: -
--

CREATE INDEX factures_custcode_idx ON iam.factures USING btree (custcode);


--
-- Name: factures_statut_idx; Type: INDEX; Schema: iam; Owner: -
--

CREATE INDEX factures_statut_idx ON iam.factures USING btree (statut);


--
-- Name: idx_activity_logs_created_at; Type: INDEX; Schema: iam; Owner: -
--

CREATE INDEX idx_activity_logs_created_at ON iam.activity_logs USING btree (created_at DESC);


--
-- Name: service_request_events_request_idx; Type: INDEX; Schema: iam; Owner: -
--

CREATE INDEX service_request_events_request_idx ON iam.service_request_events USING btree (request_id);


--
-- Name: service_requests_created_at_idx; Type: INDEX; Schema: iam; Owner: -
--

CREATE INDEX service_requests_created_at_idx ON iam.service_requests USING btree (created_at DESC);


--
-- Name: service_requests_service_idx; Type: INDEX; Schema: iam; Owner: -
--

CREATE INDEX service_requests_service_idx ON iam.service_requests USING btree (service_demandeur_id);


--
-- Name: service_requests_statut_idx; Type: INDEX; Schema: iam; Owner: -
--

CREATE INDEX service_requests_statut_idx ON iam.service_requests USING btree (statut);


--
-- Name: sessions_jti_idx; Type: INDEX; Schema: iam; Owner: -
--

CREATE INDEX sessions_jti_idx ON iam.sessions USING btree (jti);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: iam; Owner: -
--

CREATE INDEX sessions_user_id_idx ON iam.sessions USING btree (user_id);


--
-- Name: system_logs_created_at_idx; Type: INDEX; Schema: iam; Owner: -
--

CREATE INDEX system_logs_created_at_idx ON iam.system_logs USING btree (created_at DESC);


--
-- Name: vehicule_events_vehicule_idx; Type: INDEX; Schema: iam; Owner: -
--

CREATE INDEX vehicule_events_vehicule_idx ON iam.vehicule_events USING btree (vehicule_id);


--
-- Name: vehicules_statut_idx; Type: INDEX; Schema: iam; Owner: -
--

CREATE INDEX vehicules_statut_idx ON iam.vehicules USING btree (statut);


--
-- Name: org_nodes org_nodes_parent_id_fkey; Type: FK CONSTRAINT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.org_nodes
    ADD CONSTRAINT org_nodes_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES iam.org_nodes(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict 7wvgBl9IedGOWdSHXadLerY45abuNA6bhPwpf7JGh0fUWDJKatNS42Ee5bywImd

