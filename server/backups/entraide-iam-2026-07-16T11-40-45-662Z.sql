--
-- PostgreSQL database dump
--

\restrict IedwGwIQ2upRzOpDuMJcYlWhk8qDKs6TcQa3qwqjj0zfhvW6QiT62e0snZtm3g3

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

--
-- Name: iam; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA iam;


--
-- Name: facture_statut; Type: TYPE; Schema: iam; Owner: -
--

CREATE TYPE iam.facture_statut AS ENUM (
    'reglee',
    'impayee'
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
    'USER'
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
    updated_at timestamp without time zone DEFAULT now() NOT NULL
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
    updated_at timestamp without time zone DEFAULT now() NOT NULL
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
    deleted_by text
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
-- Name: factures id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.factures ALTER COLUMN id SET DEFAULT nextval('iam.factures_id_seq'::regclass);


--
-- Name: lignes id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.lignes ALTER COLUMN id SET DEFAULT nextval('iam.lignes_id_seq'::regclass);


--
-- Name: lignes_fixes id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.lignes_fixes ALTER COLUMN id SET DEFAULT nextval('iam.lignes_fixes_id_seq'::regclass);


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
-- Data for Name: lignes; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.lignes (id, categorie, type_forfait, type_mobile, icc, imei, affecte, personne, qualite, date, created_at, updated_at, civilite, deleted_at, deleted_by) FROM stdin;
4	CAT 1	40G	IPHONE 13	34567	23456789	DIRECTION	ELHAIMER AMINE	Division du Patrimoine et de la Logistique	2026-07-14	2026-07-14 11:34:53.526812	2026-07-14 11:32:58.867	\N	\N	\N
1	CAT 1	30G	IPHONE	34567890	3456789	direction	ELHAIMER	Division du Patrimoine et de la Logistique	2026-07-13	2026-07-13 12:53:06.689556	2026-07-14 11:50:48.03	M.	\N	\N
\.


--
-- Data for Name: lignes_fixes; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.lignes_fixes (id, nd, custcode, coordination_regionale, delegation, domiciliation, personne, qualite, date, deleted_at, deleted_by, created_at, updated_at) FROM stdin;
1	0535660487	5.53231.00.00.100165	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
2	0535660487	5.53231.00.00.100165	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
3	0535660487	5.53231.00.00.100165	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
4	0535660487	5.53231.00.00.100165	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
5	0535660487	5.53231.00.00.100165	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
6	0535660487	5.53231.00.00.100165	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
7	0535660487	5.53231.00.00.100165	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
8	0535660487	5.53231.00.00.100165	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
9	0535660487	5.53231.00.00.100165	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
10	0535660487	5.53231.00.00.100165	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
11	0535660487	5.53231.00.00.100165	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
12	0539975355	5.53231.00.00.100164	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
13	0539975355	5.53231.00.00.100164	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
14	0539975355	5.53231.00.00.100164	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
15	0539975355	5.53231.00.00.100164	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
16	0539975355	5.53231.00.00.100164	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
17	0539975355	5.53231.00.00.100164	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
18	0539975355	5.53231.00.00.100164	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
19	0539975355	5.53231.00.00.100164	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
20	0539975355	5.53231.00.00.100164	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
21	0539975355	5.53231.00.00.100164	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
22	0539975355	5.53231.00.00.100164	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
23	0523284212	5.53231.00.00.100174	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
24	0523284212	5.53231.00.00.100174	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
25	0523284212	5.53231.00.00.100174	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
26	0523284212	5.53231.00.00.100174	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
27	0523284212	5.53231.00.00.100174	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
28	0523284212	5.53231.00.00.100174	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
29	0523284212	5.53231.00.00.100174	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
30	0523284212	5.53231.00.00.100174	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
31	0523284212	5.53231.00.00.100174	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
32	0523284212	5.53231.00.00.100174	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
33	0523284212	5.53231.00.00.100174	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
34	0524846152	5.53231.00.00.100161	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
35	0524846152	5.53231.00.00.100161	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
36	0524846152	5.53231.00.00.100161	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
37	0524846152	5.53231.00.00.100161	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
38	0524846152	5.53231.00.00.100161	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
39	0524846152	5.53231.00.00.100161	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
40	0524846152	5.53231.00.00.100161	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
41	0524846152	5.53231.00.00.100161	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
42	0524846152	5.53231.00.00.100161	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
43	0524846152	5.53231.00.00.100161	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
44	0524846152	5.53231.00.00.100161	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
45	0537708054	5.53231.00.00.100155	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
46	0537708054	5.53231.00.00.100155	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
47	0537708054	5.53231.00.00.100155	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
48	0537708054	5.53231.00.00.100155	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
49	0537708054	5.53231.00.00.100155	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
50	0537708054	5.53231.00.00.100155	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
51	0537708054	5.53231.00.00.100155	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
52	0537708054	5.53231.00.00.100155	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
53	0537708054	5.53231.00.00.100155	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
54	0537708054	5.53231.00.00.100155	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
55	0537708054	5.53231.00.00.100155	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
56	0528819068	5.53231.00.00.100153	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
57	0528819068	5.53231.00.00.100153	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
58	0528819068	5.53231.00.00.100153	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
59	0528819068	5.53231.00.00.100153	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
60	0528819068	5.53231.00.00.100153	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
61	0528819068	5.53231.00.00.100153	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
62	0528819068	5.53231.00.00.100153	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
63	0528819068	5.53231.00.00.100153	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
64	0528819068	5.53231.00.00.100153	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
65	0528819068	5.53231.00.00.100153	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
66	0528819068	5.53231.00.00.100153	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
67	0523458298	5.53231.00.00.100123	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
68	0523458298	5.53231.00.00.100123	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
69	0523458298	5.53231.00.00.100123	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
70	0523458298	5.53231.00.00.100123	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
71	0523458298	5.53231.00.00.100123	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
72	0523458298	5.53231.00.00.100123	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
73	0523458298	5.53231.00.00.100123	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
74	0523458298	5.53231.00.00.100123	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
75	0523458298	5.53231.00.00.100123	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
76	0523458298	5.53231.00.00.100123	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
77	0523458298	5.53231.00.00.100123	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
78	0535585379	5.53231.00.00.100114	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
79	0535585379	5.53231.00.00.100114	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
80	0535585379	5.53231.00.00.100114	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
81	0535585379	5.53231.00.00.100114	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
82	0535585379	5.53231.00.00.100114	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
83	0535585379	5.53231.00.00.100114	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
84	0535585379	5.53231.00.00.100114	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
85	0535585379	5.53231.00.00.100114	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
86	0535585379	5.53231.00.00.100114	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
87	0535585379	5.53231.00.00.100114	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
88	0535585379	5.53231.00.00.100114	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
89	0535282381	5.53231.00.00.100108	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
90	0535282381	5.53231.00.00.100108	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
91	0535282381	5.53231.00.00.100108	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
92	0535282381	5.53231.00.00.100108	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
93	0535282381	5.53231.00.00.100108	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
94	0535282381	5.53231.00.00.100108	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
95	0535282381	5.53231.00.00.100108	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
96	0535282381	5.53231.00.00.100108	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
97	0535282381	5.53231.00.00.100108	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
98	0535282381	5.53231.00.00.100108	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
99	0535282381	5.53231.00.00.100108	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
100	0528897094	5.53231.00.00.100105	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
101	0528897094	5.53231.00.00.100105	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
102	0528897094	5.53231.00.00.100105	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
103	0528897094	5.53231.00.00.100105	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
104	0528897094	5.53231.00.00.100105	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
105	0528897094	5.53231.00.00.100105	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
106	0528897094	5.53231.00.00.100105	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
107	0528897094	5.53231.00.00.100105	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
108	0528897094	5.53231.00.00.100105	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
109	0528897094	5.53231.00.00.100105	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
110	0528897094	5.53231.00.00.100105	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
111	0524882474	5.53231.00.00.100094	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
112	0524882474	5.53231.00.00.100094	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
113	0524882474	5.53231.00.00.100094	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
114	0524882474	5.53231.00.00.100094	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
115	0524882474	5.53231.00.00.100094	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
116	0524882474	5.53231.00.00.100094	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
117	0524882474	5.53231.00.00.100094	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
118	0524882474	5.53231.00.00.100094	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
119	0524882474	5.53231.00.00.100094	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
120	0524882474	5.53231.00.00.100094	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
121	0524882474	5.53231.00.00.100094	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
122	0524621242	5.53231.00.00.100092	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
123	0524621242	5.53231.00.00.100092	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
124	0524621242	5.53231.00.00.100092	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
125	0524621242	5.53231.00.00.100092	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
126	0524621242	5.53231.00.00.100092	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
127	0524621242	5.53231.00.00.100092	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
128	0524621242	5.53231.00.00.100092	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
129	0524621242	5.53231.00.00.100092	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
130	0524621242	5.53231.00.00.100092	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
131	0524621242	5.53231.00.00.100092	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
132	0524621242	5.53231.00.00.100092	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
133	0539318634	5.53231.00.00.100079	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
134	0539318634	5.53231.00.00.100079	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
135	0539318634	5.53231.00.00.100079	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
136	0539318634	5.53231.00.00.100079	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
137	0539318634	5.53231.00.00.100079	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
138	0539318634	5.53231.00.00.100079	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
139	0539318634	5.53231.00.00.100079	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
140	0539318634	5.53231.00.00.100079	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
141	0539318634	5.53231.00.00.100079	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
142	0539318634	5.53231.00.00.100079	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
143	0539318634	5.53231.00.00.100079	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
144	0537552785	5.53231.00.00.100053	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
145	0537552785	5.53231.00.00.100053	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
146	0537552785	5.53231.00.00.100053	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
147	0537552785	5.53231.00.00.100053	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
148	0537552785	5.53231.00.00.100053	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
149	0537552785	5.53231.00.00.100053	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
150	0537552785	5.53231.00.00.100053	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
151	0537552785	5.53231.00.00.100053	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
152	0537552785	5.53231.00.00.100053	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
153	0537552785	5.53231.00.00.100053	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
154	0537552785	5.53231.00.00.100053	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
155	0537704329	5.53231.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
156	0537704329	5.53231.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
157	0537704329	5.53231.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
158	0537704329	5.53231.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
159	0537704329	5.53231.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
160	0537704329	5.53231.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
161	0537704329	5.53231.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
162	0537704329	5.53231.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
163	0537704329	5.53231.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
164	0537704329	5.53231.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
165	0537704329	5.53231.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
166	0537734433	5.53231.00.00.100001	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
167	0537734433	5.53231.00.00.100001	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
168	0537734433	5.53231.00.00.100001	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
169	0537734433	5.53231.00.00.100001	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
170	0537734433	5.53231.00.00.100001	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
171	0537734433	5.53231.00.00.100001	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
172	0537734433	5.53231.00.00.100001	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
173	0537734433	5.53231.00.00.100001	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
174	0537734433	5.53231.00.00.100001	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
175	0537734433	5.53231.00.00.100001	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
176	0537734433	5.53231.00.00.100001	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
177	0536693832	5.53231.00.00.100323	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
178	0536693832	5.53231.00.00.100323	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
179	0536693832	5.53231.00.00.100323	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
180	0536693832	5.53231.00.00.100323	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
181	0536693832	5.53231.00.00.100323	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
182	0536693832	5.53231.00.00.100323	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
183	0536693832	5.53231.00.00.100323	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
184	0536693832	5.53231.00.00.100323	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
185	0536693832	5.53231.00.00.100323	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
186	0536693832	5.53231.00.00.100323	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
187	0536693832	5.53231.00.00.100323	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
188	0522590615	5.53231.00.00.100207	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
189	0522590615	5.53231.00.00.100207	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
190	0522590615	5.53231.00.00.100207	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
191	0522590615	5.53231.00.00.100207	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
192	0522590615	5.53231.00.00.100207	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
193	0522590615	5.53231.00.00.100207	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
194	0522590615	5.53231.00.00.100207	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
195	0522590615	5.53231.00.00.100207	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
196	0522590615	5.53231.00.00.100207	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
197	0522590615	5.53231.00.00.100207	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
198	0522590615	5.53231.00.00.100207	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
199	0522534560	5.53231.00.00.100341	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
200	0522534560	5.53231.00.00.100341	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
201	0522534560	5.53231.00.00.100341	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
202	0522534560	5.53231.00.00.100341	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
203	0522534560	5.53231.00.00.100341	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
204	0522534560	5.53231.00.00.100341	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
205	0522534560	5.53231.00.00.100341	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
206	0522534560	5.53231.00.00.100341	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
207	0522534560	5.53231.00.00.100341	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
208	0522534560	5.53231.00.00.100341	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
209	0522534560	5.53231.00.00.100341	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
210	0524649763	5.53231.00.00.100367	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
211	0524649763	5.53231.00.00.100367	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
212	0524649763	5.53231.00.00.100367	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
213	0524649763	5.53231.00.00.100367	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
214	0524649763	5.53231.00.00.100367	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
215	0524649763	5.53231.00.00.100367	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
216	0524649763	5.53231.00.00.100367	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
217	0524649763	5.53231.00.00.100367	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
218	0524649763	5.53231.00.00.100367	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
219	0524649763	5.53231.00.00.100367	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
220	0524649763	5.53231.00.00.100367	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
221	0522635141	5.53231.00.00.100382	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
222	0522635141	5.53231.00.00.100382	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
223	0522635141	5.53231.00.00.100382	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
224	0522635141	5.53231.00.00.100382	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
225	0522635141	5.53231.00.00.100382	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
226	0522635141	5.53231.00.00.100382	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
227	0522635141	5.53231.00.00.100382	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
228	0522635141	5.53231.00.00.100382	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
229	0522635141	5.53231.00.00.100382	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
230	0522635141	5.53231.00.00.100382	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
231	0522635141	5.53231.00.00.100382	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
232	0535962266	5.53231.00.00.100162	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
233	0535962266	5.53231.00.00.100162	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
234	0535962266	5.53231.00.00.100162	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
235	0535962266	5.53231.00.00.100162	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
236	0535962266	5.53231.00.00.100162	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
237	0535962266	5.53231.00.00.100162	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
238	0535962266	5.53231.00.00.100162	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
239	0535962266	5.53231.00.00.100162	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
240	0535962266	5.53231.00.00.100162	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
241	0535962266	5.53231.00.00.100162	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
242	0535962266	5.53231.00.00.100162	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
243	0536611831	5.53231.00.00.100166	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
244	0536611831	5.53231.00.00.100166	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
245	0536611831	5.53231.00.00.100166	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
246	0536611831	5.53231.00.00.100166	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
247	0536611831	5.53231.00.00.100166	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
248	0536611831	5.53231.00.00.100166	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
249	0536611831	5.53231.00.00.100166	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
250	0536611831	5.53231.00.00.100166	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
251	0536611831	5.53231.00.00.100166	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
252	0536611831	5.53231.00.00.100166	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
253	0536611831	5.53231.00.00.100166	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
254	0528887261	5.53231.00.00.100177	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
255	0528887261	5.53231.00.00.100177	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
256	0528887261	5.53231.00.00.100177	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
257	0528887261	5.53231.00.00.100177	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
258	0528887261	5.53231.00.00.100177	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
259	0528887261	5.53231.00.00.100177	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
260	0528887261	5.53231.00.00.100177	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
261	0528887261	5.53231.00.00.100177	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
262	0528887261	5.53231.00.00.100177	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
263	0528887261	5.53231.00.00.100177	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
264	0528887261	5.53231.00.00.100177	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
265	0528998336	5.53231.00.00.100178	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
266	0528998336	5.53231.00.00.100178	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
267	0528998336	5.53231.00.00.100178	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
268	0528998336	5.53231.00.00.100178	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
269	0528998336	5.53231.00.00.100178	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
270	0528998336	5.53231.00.00.100178	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
271	0528998336	5.53231.00.00.100178	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
272	0528998336	5.53231.00.00.100178	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
273	0528998336	5.53231.00.00.100178	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
274	0528998336	5.53231.00.00.100178	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
275	0528998336	5.53231.00.00.100178	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
276	0522271923	7.1830754.00.00.100012	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
277	0522271923	7.1830754.00.00.100012	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
278	0522271923	7.1830754.00.00.100012	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
279	0522271923	7.1830754.00.00.100012	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
280	0522271923	7.1830754.00.00.100012	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
281	0522271923	7.1830754.00.00.100012	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
282	0522271923	7.1830754.00.00.100012	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
283	0522271923	7.1830754.00.00.100012	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
284	0522271923	7.1830754.00.00.100012	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
285	0522271923	7.1830754.00.00.100012	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
286	0522271923	7.1830754.00.00.100012	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
287	0522902005	7.1830754.00.00.100009	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
288	0522902005	7.1830754.00.00.100009	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
289	0522902005	7.1830754.00.00.100009	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
290	0522902005	7.1830754.00.00.100009	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
291	0522902005	7.1830754.00.00.100009	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
292	0522902005	7.1830754.00.00.100009	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
293	0522902005	7.1830754.00.00.100009	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
294	0522902005	7.1830754.00.00.100009	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
295	0522902005	7.1830754.00.00.100009	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
296	0522902005	7.1830754.00.00.100009	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
297	0522902005	7.1830754.00.00.100009	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
298	0528700023	5.53231.00.00.100096	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
299	0528700023	5.53231.00.00.100096	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
300	0528700023	5.53231.00.00.100096	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
301	0528700023	5.53231.00.00.100096	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
302	0528700023	5.53231.00.00.100096	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
303	0528700023	5.53231.00.00.100096	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
304	0528700023	5.53231.00.00.100096	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
305	0528700023	5.53231.00.00.100096	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
306	0528700023	5.53231.00.00.100096	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
307	0528700023	5.53231.00.00.100096	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
308	0528700023	5.53231.00.00.100096	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
309	0524784712	5.53231.00.00.100093	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
310	0524784712	5.53231.00.00.100093	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
311	0524784712	5.53231.00.00.100093	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
312	0524784712	5.53231.00.00.100093	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
313	0524784712	5.53231.00.00.100093	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
314	0524784712	5.53231.00.00.100093	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
315	0524784712	5.53231.00.00.100093	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
316	0524784712	5.53231.00.00.100093	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
317	0524784712	5.53231.00.00.100093	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
318	0524784712	5.53231.00.00.100093	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
319	0524784712	5.53231.00.00.100093	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
320	0524484013	5.53231.00.00.100091	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
321	0524484013	5.53231.00.00.100091	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
322	0524484013	5.53231.00.00.100091	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
323	0524484013	5.53231.00.00.100091	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
324	0524484013	5.53231.00.00.100091	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
325	0524484013	5.53231.00.00.100091	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
326	0524484013	5.53231.00.00.100091	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
327	0524484013	5.53231.00.00.100091	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
328	0524484013	5.53231.00.00.100091	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
329	0524484013	5.53231.00.00.100091	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
330	0524484013	5.53231.00.00.100091	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
331	0524304915	5.53231.00.00.100084	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
332	0524304915	5.53231.00.00.100084	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
333	0524304915	5.53231.00.00.100084	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
334	0524304915	5.53231.00.00.100084	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
335	0524304915	5.53231.00.00.100084	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
336	0524304915	5.53231.00.00.100084	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
337	0524304915	5.53231.00.00.100084	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
338	0524304915	5.53231.00.00.100084	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
339	0524304915	5.53231.00.00.100084	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
340	0524304915	5.53231.00.00.100084	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
341	0524304915	5.53231.00.00.100084	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
342	0523482813	5.53231.00.00.100082	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
343	0523482813	5.53231.00.00.100082	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
344	0523482813	5.53231.00.00.100082	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
345	0523482813	5.53231.00.00.100082	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
346	0523482813	5.53231.00.00.100082	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
347	0523482813	5.53231.00.00.100082	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
348	0523482813	5.53231.00.00.100082	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
349	0523482813	5.53231.00.00.100082	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
350	0523482813	5.53231.00.00.100082	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
351	0523482813	5.53231.00.00.100082	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
352	0523482813	5.53231.00.00.100082	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
353	0539986781	5.53231.00.00.100068	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
354	0539986781	5.53231.00.00.100068	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
355	0539986781	5.53231.00.00.100068	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
356	0539986781	5.53231.00.00.100068	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
357	0539986781	5.53231.00.00.100068	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
358	0539986781	5.53231.00.00.100068	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
359	0539986781	5.53231.00.00.100068	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
360	0539986781	5.53231.00.00.100068	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
361	0539986781	5.53231.00.00.100068	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
362	0539986781	5.53231.00.00.100068	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
363	0539986781	5.53231.00.00.100068	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
364	0537372816	5.53231.00.00.100052	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
365	0537372816	5.53231.00.00.100052	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
366	0537372816	5.53231.00.00.100052	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
367	0537372816	5.53231.00.00.100052	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
368	0537372816	5.53231.00.00.100052	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
369	0537372816	5.53231.00.00.100052	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
370	0537372816	5.53231.00.00.100052	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
371	0537372816	5.53231.00.00.100052	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
372	0537372816	5.53231.00.00.100052	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
373	0537372816	5.53231.00.00.100052	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
374	0537372816	5.53231.00.00.100052	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
375	0537690947	5.53231.00.00.100019	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
376	0537690947	5.53231.00.00.100019	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
377	0537690947	5.53231.00.00.100019	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
378	0537690947	5.53231.00.00.100019	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
379	0537690947	5.53231.00.00.100019	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
380	0537690947	5.53231.00.00.100019	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
381	0537690947	5.53231.00.00.100019	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
382	0537690947	5.53231.00.00.100019	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
383	0537690947	5.53231.00.00.100019	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
384	0537690947	5.53231.00.00.100019	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
385	0537690947	5.53231.00.00.100019	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
386	0537701998	5.53231.00.00.100013	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
387	0537701998	5.53231.00.00.100013	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
388	0537701998	5.53231.00.00.100013	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
389	0537701998	5.53231.00.00.100013	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
390	0537701998	5.53231.00.00.100013	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
391	0537701998	5.53231.00.00.100013	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
392	0537701998	5.53231.00.00.100013	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
393	0537701998	5.53231.00.00.100013	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
394	0537701998	5.53231.00.00.100013	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
395	0537701998	5.53231.00.00.100013	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
396	0537701998	5.53231.00.00.100013	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
397	0537770607	5.53231.00.00.100007	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
398	0537770607	5.53231.00.00.100007	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
399	0537770607	5.53231.00.00.100007	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
400	0537770607	5.53231.00.00.100007	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
401	0537770607	5.53231.00.00.100007	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
402	0537770607	5.53231.00.00.100007	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
403	0537770607	5.53231.00.00.100007	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
404	0537770607	5.53231.00.00.100007	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
405	0537770607	5.53231.00.00.100007	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
406	0537770607	5.53231.00.00.100007	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
407	0537770607	5.53231.00.00.100007	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
408	0528893728	5.53231.00.00.100154	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
409	0528893728	5.53231.00.00.100154	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
410	0528893728	5.53231.00.00.100154	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
411	0528893728	5.53231.00.00.100154	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
412	0528893728	5.53231.00.00.100154	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
413	0528893728	5.53231.00.00.100154	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
414	0528893728	5.53231.00.00.100154	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
415	0528893728	5.53231.00.00.100154	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
416	0528893728	5.53231.00.00.100154	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
417	0528893728	5.53231.00.00.100154	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
418	0528893728	5.53231.00.00.100154	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
419	0528899052	5.53231.00.00.100151	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
420	0528899052	5.53231.00.00.100151	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
421	0528899052	5.53231.00.00.100151	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
422	0528899052	5.53231.00.00.100151	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
423	0528899052	5.53231.00.00.100151	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
424	0528899052	5.53231.00.00.100151	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
425	0528899052	5.53231.00.00.100151	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
426	0528899052	5.53231.00.00.100151	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
427	0528899052	5.53231.00.00.100151	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
428	0528899052	5.53231.00.00.100151	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
429	0528899052	5.53231.00.00.100151	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
430	0522555974	5.53231.00.00.100150	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
431	0522555974	5.53231.00.00.100150	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
432	0522555974	5.53231.00.00.100150	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
433	0522555974	5.53231.00.00.100150	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
434	0522555974	5.53231.00.00.100150	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
435	0522555974	5.53231.00.00.100150	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
436	0522555974	5.53231.00.00.100150	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
437	0522555974	5.53231.00.00.100150	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
438	0522555974	5.53231.00.00.100150	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
439	0522555974	5.53231.00.00.100150	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
440	0522555974	5.53231.00.00.100150	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
441	0535541632	5.53231.00.00.100145	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
442	0535541632	5.53231.00.00.100145	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
443	0535541632	5.53231.00.00.100145	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
444	0535541632	5.53231.00.00.100145	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
445	0535541632	5.53231.00.00.100145	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
446	0535541632	5.53231.00.00.100145	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
447	0535541632	5.53231.00.00.100145	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
448	0535541632	5.53231.00.00.100145	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
449	0535541632	5.53231.00.00.100145	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
450	0535541632	5.53231.00.00.100145	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
451	0535541632	5.53231.00.00.100145	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
452	0523342465	5.53231.00.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
453	0523342465	5.53231.00.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
454	0523342465	5.53231.00.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
455	0523342465	5.53231.00.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
456	0523342465	5.53231.00.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
457	0523342465	5.53231.00.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
458	0523342465	5.53231.00.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
459	0523342465	5.53231.00.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
460	0523342465	5.53231.00.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
461	0523342465	5.53231.00.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
462	0523342465	5.53231.00.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
463	0537592915	5.53231.00.00.100139	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
464	0537592915	5.53231.00.00.100139	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
465	0537592915	5.53231.00.00.100139	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
466	0537592915	5.53231.00.00.100139	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
467	0537592915	5.53231.00.00.100139	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
468	0537592915	5.53231.00.00.100139	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
469	0537592915	5.53231.00.00.100139	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
470	0537592915	5.53231.00.00.100139	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
471	0537592915	5.53231.00.00.100139	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
472	0537592915	5.53231.00.00.100139	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
473	0537592915	5.53231.00.00.100139	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
474	0539914911	5.53231.00.00.100126	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
475	0539914911	5.53231.00.00.100126	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
476	0539914911	5.53231.00.00.100126	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
477	0539914911	5.53231.00.00.100126	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
478	0539914911	5.53231.00.00.100126	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
479	0539914911	5.53231.00.00.100126	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
480	0539914911	5.53231.00.00.100126	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
481	0539914911	5.53231.00.00.100126	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
482	0539914911	5.53231.00.00.100126	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
483	0539914911	5.53231.00.00.100126	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
484	0539914911	5.53231.00.00.100126	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
485	0536606082	5.53231.00.00.100119	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
486	0536606082	5.53231.00.00.100119	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
487	0536606082	5.53231.00.00.100119	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
488	0536606082	5.53231.00.00.100119	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
489	0536606082	5.53231.00.00.100119	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
490	0536606082	5.53231.00.00.100119	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
491	0536606082	5.53231.00.00.100119	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
492	0536606082	5.53231.00.00.100119	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
493	0536606082	5.53231.00.00.100119	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
494	0536606082	5.53231.00.00.100119	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
495	0536606082	5.53231.00.00.100119	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
496	0535586953	5.53231.00.00.100115	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
497	0535586953	5.53231.00.00.100115	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
498	0535586953	5.53231.00.00.100115	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
499	0535586953	5.53231.00.00.100115	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
500	0535586953	5.53231.00.00.100115	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
501	0535586953	5.53231.00.00.100115	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
502	0535586953	5.53231.00.00.100115	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
503	0535586953	5.53231.00.00.100115	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
504	0535586953	5.53231.00.00.100115	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
505	0535586953	5.53231.00.00.100115	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
506	0535586953	5.53231.00.00.100115	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
507	0535566154	5.53231.00.00.100111	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
508	0535566154	5.53231.00.00.100111	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
509	0535566154	5.53231.00.00.100111	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
510	0535566154	5.53231.00.00.100111	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
511	0535566154	5.53231.00.00.100111	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
512	0535566154	5.53231.00.00.100111	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
513	0535566154	5.53231.00.00.100111	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
514	0535566154	5.53231.00.00.100111	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
515	0535566154	5.53231.00.00.100111	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
516	0535566154	5.53231.00.00.100111	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
517	0535566154	5.53231.00.00.100111	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
518	0528896789	5.53231.00.00.100104	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
519	0528896789	5.53231.00.00.100104	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
520	0528896789	5.53231.00.00.100104	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
521	0528896789	5.53231.00.00.100104	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
522	0528896789	5.53231.00.00.100104	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
523	0528896789	5.53231.00.00.100104	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
524	0528896789	5.53231.00.00.100104	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
525	0528896789	5.53231.00.00.100104	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
526	0528896789	5.53231.00.00.100104	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
527	0528896789	5.53231.00.00.100104	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
528	0528896789	5.53231.00.00.100104	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
529	0528802049	5.53231.00.00.100097	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
530	0528802049	5.53231.00.00.100097	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
531	0528802049	5.53231.00.00.100097	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
532	0528802049	5.53231.00.00.100097	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
533	0528802049	5.53231.00.00.100097	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
534	0528802049	5.53231.00.00.100097	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
535	0528802049	5.53231.00.00.100097	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
536	0528802049	5.53231.00.00.100097	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
537	0528802049	5.53231.00.00.100097	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
538	0528802049	5.53231.00.00.100097	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
539	0528802049	5.53231.00.00.100097	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
540	0522734549	5.53231.00.00.100163	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
541	0522734549	5.53231.00.00.100163	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
542	0522734549	5.53231.00.00.100163	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
543	0522734549	5.53231.00.00.100163	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
544	0522734549	5.53231.00.00.100163	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
545	0522734549	5.53231.00.00.100163	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
546	0522734549	5.53231.00.00.100163	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
547	0522734549	5.53231.00.00.100163	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
548	0522734549	5.53231.00.00.100163	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
549	0522734549	5.53231.00.00.100163	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
550	0522734549	5.53231.00.00.100163	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
551	0539333413	5.53231.13.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
552	0539333413	5.53231.13.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
553	0539333413	5.53231.13.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
554	0539333413	5.53231.13.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
555	0539333413	5.53231.13.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
556	0539333413	5.53231.13.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
557	0539333413	5.53231.13.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
558	0539333413	5.53231.13.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
559	0539333413	5.53231.13.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
560	0539333413	5.53231.13.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
561	0539333413	5.53231.13.00.100141	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
562	0528877974	5.53231.00.00.100190	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
563	0528877974	5.53231.00.00.100190	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
564	0528877974	5.53231.00.00.100190	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
565	0528877974	5.53231.00.00.100190	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
566	0528877974	5.53231.00.00.100190	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
567	0528877974	5.53231.00.00.100190	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
568	0528877974	5.53231.00.00.100190	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
569	0528877974	5.53231.00.00.100190	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
570	0528877974	5.53231.00.00.100190	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
571	0528877974	5.53231.00.00.100190	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
572	0528877974	5.53231.00.00.100190	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
573	0528980059	5.53231.00.00.100194	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
574	0528980059	5.53231.00.00.100194	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
575	0528980059	5.53231.00.00.100194	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
576	0528980059	5.53231.00.00.100194	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
577	0528980059	5.53231.00.00.100194	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
578	0528980059	5.53231.00.00.100194	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
579	0528980059	5.53231.00.00.100194	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
580	0528980059	5.53231.00.00.100194	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
581	0528980059	5.53231.00.00.100194	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
582	0528980059	5.53231.00.00.100194	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
583	0528980059	5.53231.00.00.100194	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
584	0522714623	5.53231.00.00.100202	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
585	0522714623	5.53231.00.00.100202	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
586	0522714623	5.53231.00.00.100202	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
587	0522714623	5.53231.00.00.100202	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
588	0522714623	5.53231.00.00.100202	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
589	0522714623	5.53231.00.00.100202	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
590	0522714623	5.53231.00.00.100202	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
591	0522714623	5.53231.00.00.100202	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
592	0522714623	5.53231.00.00.100202	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
593	0522714623	5.53231.00.00.100202	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
594	0522714623	5.53231.00.00.100202	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
595	0808546340	5.53231.13.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
596	0808546340	5.53231.13.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
597	0808546340	5.53231.13.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
598	0808546340	5.53231.13.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
599	0808546340	5.53231.13.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
600	0808546340	5.53231.13.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
601	0808546340	5.53231.13.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
602	0808546340	5.53231.13.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
603	0808546340	5.53231.13.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
604	0808546340	5.53231.13.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
605	0808546340	5.53231.13.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
606	0535595234	5.53231.12.00.100030	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
607	0535595234	5.53231.12.00.100030	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
608	0535595234	5.53231.12.00.100030	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
609	0535595234	5.53231.12.00.100030	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
610	0535595234	5.53231.12.00.100030	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
611	0535595234	5.53231.12.00.100030	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
612	0535595234	5.53231.12.00.100030	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
613	0535595234	5.53231.12.00.100030	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
614	0535595234	5.53231.12.00.100030	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
615	0535595234	5.53231.12.00.100030	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
616	0535595234	5.53231.12.00.100030	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
617	0522856947	5.53231.00.00.100320	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
618	0522856947	5.53231.00.00.100320	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
619	0522856947	5.53231.00.00.100320	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
620	0522856947	5.53231.00.00.100320	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
621	0522856947	5.53231.00.00.100320	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
622	0522856947	5.53231.00.00.100320	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
623	0522856947	5.53231.00.00.100320	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
624	0522856947	5.53231.00.00.100320	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
625	0522856947	5.53231.00.00.100320	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
626	0522856947	5.53231.00.00.100320	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
627	0522856947	5.53231.00.00.100320	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
628	0528930240	5.53231.00.00.100370	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
629	0528930240	5.53231.00.00.100370	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
630	0528930240	5.53231.00.00.100370	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
631	0528930240	5.53231.00.00.100370	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
632	0528930240	5.53231.00.00.100370	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
633	0528930240	5.53231.00.00.100370	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
634	0528930240	5.53231.00.00.100370	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
635	0528930240	5.53231.00.00.100370	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
636	0528930240	5.53231.00.00.100370	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
637	0528930240	5.53231.00.00.100370	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
638	0528930240	5.53231.00.00.100370	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
639	0536362352	5.53231.00.00.100388	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
640	0536362352	5.53231.00.00.100388	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
641	0536362352	5.53231.00.00.100388	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
642	0536362352	5.53231.00.00.100388	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
643	0536362352	5.53231.00.00.100388	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
644	0536362352	5.53231.00.00.100388	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
645	0536362352	5.53231.00.00.100388	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
646	0536362352	5.53231.00.00.100388	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
647	0536362352	5.53231.00.00.100388	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
648	0536362352	5.53231.00.00.100388	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
649	0536362352	5.53231.00.00.100388	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
650	0537909739	5.53231.00.00.100345	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
651	0537909739	5.53231.00.00.100345	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
652	0537909739	5.53231.00.00.100345	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
653	0537909739	5.53231.00.00.100345	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
654	0537909739	5.53231.00.00.100345	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
655	0537909739	5.53231.00.00.100345	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
656	0537909739	5.53231.00.00.100345	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
657	0537909739	5.53231.00.00.100345	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
658	0537909739	5.53231.00.00.100345	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
659	0537909739	5.53231.00.00.100345	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
660	0537909739	5.53231.00.00.100345	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
661	0523369398	5.53231.00.00.100354	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
662	0523369398	5.53231.00.00.100354	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
663	0523369398	5.53231.00.00.100354	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
664	0523369398	5.53231.00.00.100354	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
665	0523369398	5.53231.00.00.100354	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
666	0523369398	5.53231.00.00.100354	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
667	0523369398	5.53231.00.00.100354	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
668	0523369398	5.53231.00.00.100354	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
669	0523369398	5.53231.00.00.100354	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
670	0523369398	5.53231.00.00.100354	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
671	0523369398	5.53231.00.00.100354	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
672	0524318074	5.53231.00.00.100348	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
673	0524318074	5.53231.00.00.100348	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
674	0524318074	5.53231.00.00.100348	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
675	0524318074	5.53231.00.00.100348	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
676	0524318074	5.53231.00.00.100348	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
677	0524318074	5.53231.00.00.100348	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
678	0524318074	5.53231.00.00.100348	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
679	0524318074	5.53231.00.00.100348	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
680	0524318074	5.53231.00.00.100348	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
681	0524318074	5.53231.00.00.100348	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
682	0524318074	5.53231.00.00.100348	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
683	0523438926	5.53231.00.00.100350	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
684	0523438926	5.53231.00.00.100350	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
685	0523438926	5.53231.00.00.100350	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
686	0523438926	5.53231.00.00.100350	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
687	0523438926	5.53231.00.00.100350	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
688	0523438926	5.53231.00.00.100350	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
689	0523438926	5.53231.00.00.100350	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
690	0523438926	5.53231.00.00.100350	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
691	0523438926	5.53231.00.00.100350	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
692	0523438926	5.53231.00.00.100350	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
693	0523438926	5.53231.00.00.100350	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
694	0535360798	5.53231.00.00.100352	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
695	0535360798	5.53231.00.00.100352	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
696	0535360798	5.53231.00.00.100352	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
697	0535360798	5.53231.00.00.100352	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
698	0535360798	5.53231.00.00.100352	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
699	0535360798	5.53231.00.00.100352	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
700	0535360798	5.53231.00.00.100352	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
701	0535360798	5.53231.00.00.100352	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
702	0535360798	5.53231.00.00.100352	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
703	0535360798	5.53231.00.00.100352	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
704	0535360798	5.53231.00.00.100352	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
705	0536367854	5.53231.00.00.100342	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
706	0536367854	5.53231.00.00.100342	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
707	0536367854	5.53231.00.00.100342	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
708	0536367854	5.53231.00.00.100342	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
709	0536367854	5.53231.00.00.100342	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
710	0536367854	5.53231.00.00.100342	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
711	0536367854	5.53231.00.00.100342	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
712	0536367854	5.53231.00.00.100342	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
713	0536367854	5.53231.00.00.100342	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
714	0536367854	5.53231.00.00.100342	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
715	0536367854	5.53231.00.00.100342	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
716	0528895581	5.53231.00.00.100362	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
717	0528895581	5.53231.00.00.100362	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
718	0528895581	5.53231.00.00.100362	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
719	0528895581	5.53231.00.00.100362	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
720	0528895581	5.53231.00.00.100362	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
721	0528895581	5.53231.00.00.100362	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
722	0528895581	5.53231.00.00.100362	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
723	0528895581	5.53231.00.00.100362	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
724	0528895581	5.53231.00.00.100362	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
725	0528895581	5.53231.00.00.100362	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
726	0528895581	5.53231.00.00.100362	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
727	0537512154	5.53231.00.00.100395	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
728	0537512154	5.53231.00.00.100395	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
729	0537512154	5.53231.00.00.100395	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
730	0537512154	5.53231.00.00.100395	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
731	0537512154	5.53231.00.00.100395	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
732	0537512154	5.53231.00.00.100395	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
733	0537512154	5.53231.00.00.100395	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
734	0537512154	5.53231.00.00.100395	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
735	0537512154	5.53231.00.00.100395	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
736	0537512154	5.53231.00.00.100395	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
737	0537512154	5.53231.00.00.100395	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
738	0808681004	5.53231.00.00.100517	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
739	0808681004	5.53231.00.00.100517	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
740	0808681004	5.53231.00.00.100517	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
741	0808681004	5.53231.00.00.100517	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
742	0808681004	5.53231.00.00.100517	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
743	0808681004	5.53231.00.00.100517	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
744	0808681004	5.53231.00.00.100517	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
745	0808681004	5.53231.00.00.100517	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
746	0808681004	5.53231.00.00.100517	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
747	0808681004	5.53231.00.00.100517	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
748	0808681004	5.53231.00.00.100517	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
749	0537500305	5.53231.00.00.100356	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
750	0537500305	5.53231.00.00.100356	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
751	0537500305	5.53231.00.00.100356	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
752	0537500305	5.53231.00.00.100356	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
753	0537500305	5.53231.00.00.100356	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
754	0537500305	5.53231.00.00.100356	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
755	0537500305	5.53231.00.00.100356	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
756	0537500305	5.53231.00.00.100356	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
757	0537500305	5.53231.00.00.100356	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
758	0537500305	5.53231.00.00.100356	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
759	0537500305	5.53231.00.00.100356	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
760	0522474894	5.53231.00.00.100376	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
761	0522474894	5.53231.00.00.100376	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
762	0522474894	5.53231.00.00.100376	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
763	0522474894	5.53231.00.00.100376	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
764	0522474894	5.53231.00.00.100376	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
765	0522474894	5.53231.00.00.100376	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
766	0522474894	5.53231.00.00.100376	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
767	0522474894	5.53231.00.00.100376	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
768	0522474894	5.53231.00.00.100376	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
769	0522474894	5.53231.00.00.100376	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
770	0522474894	5.53231.00.00.100376	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
771	0536683998	5.53231.00.00.100386	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
772	0536683998	5.53231.00.00.100386	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
773	0536683998	5.53231.00.00.100386	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
774	0536683998	5.53231.00.00.100386	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
775	0536683998	5.53231.00.00.100386	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
776	0536683998	5.53231.00.00.100386	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
777	0536683998	5.53231.00.00.100386	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
778	0536683998	5.53231.00.00.100386	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
779	0536683998	5.53231.00.00.100386	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
780	0536683998	5.53231.00.00.100386	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
781	0536683998	5.53231.00.00.100386	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
782	0536679113	5.53231.00.00.100131	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
783	0536679113	5.53231.00.00.100131	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
784	0536679113	5.53231.00.00.100131	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
785	0536679113	5.53231.00.00.100131	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
786	0536679113	5.53231.00.00.100131	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
787	0536679113	5.53231.00.00.100131	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
788	0536679113	5.53231.00.00.100131	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
789	0536679113	5.53231.00.00.100131	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
790	0536679113	5.53231.00.00.100131	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
791	0536679113	5.53231.00.00.100131	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
792	0536679113	5.53231.00.00.100131	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
793	0535688891	5.53231.12.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
794	0535688891	5.53231.12.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
795	0535688891	5.53231.12.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
796	0535688891	5.53231.12.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
797	0535688891	5.53231.12.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
798	0535688891	5.53231.12.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
799	0535688891	5.53231.12.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
800	0535688891	5.53231.12.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
801	0535688891	5.53231.12.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
802	0535688891	5.53231.12.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
803	0535688891	5.53231.12.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
804	0535627074	5.53231.00.00.100116	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
805	0535627074	5.53231.00.00.100116	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
806	0535627074	5.53231.00.00.100116	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
807	0535627074	5.53231.00.00.100116	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
808	0535627074	5.53231.00.00.100116	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
809	0535627074	5.53231.00.00.100116	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
810	0535627074	5.53231.00.00.100116	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
811	0535627074	5.53231.00.00.100116	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
812	0535627074	5.53231.00.00.100116	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
813	0535627074	5.53231.00.00.100116	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
814	0535627074	5.53231.00.00.100116	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
815	0528862331	5.53231.00.00.100099	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
816	0528862331	5.53231.00.00.100099	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
817	0528862331	5.53231.00.00.100099	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
818	0528862331	5.53231.00.00.100099	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
819	0528862331	5.53231.00.00.100099	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
820	0528862331	5.53231.00.00.100099	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
821	0528862331	5.53231.00.00.100099	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
822	0528862331	5.53231.00.00.100099	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
823	0528862331	5.53231.00.00.100099	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
824	0528862331	5.53231.00.00.100099	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
825	0528862331	5.53231.00.00.100099	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
826	0524410459	5.53231.00.00.100187	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
827	0524410459	5.53231.00.00.100187	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
828	0524410459	5.53231.00.00.100187	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
829	0524410459	5.53231.00.00.100187	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
830	0524410459	5.53231.00.00.100187	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
831	0524410459	5.53231.00.00.100187	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
832	0524410459	5.53231.00.00.100187	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
833	0524410459	5.53231.00.00.100187	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
834	0524410459	5.53231.00.00.100187	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
835	0524410459	5.53231.00.00.100187	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
836	0524410459	5.53231.00.00.100187	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
837	0523432051	5.53231.00.00.100390	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
838	0523432051	5.53231.00.00.100390	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
839	0523432051	5.53231.00.00.100390	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
840	0523432051	5.53231.00.00.100390	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
841	0523432051	5.53231.00.00.100390	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
842	0523432051	5.53231.00.00.100390	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
843	0523432051	5.53231.00.00.100390	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
844	0523432051	5.53231.00.00.100390	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
845	0523432051	5.53231.00.00.100390	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
846	0523432051	5.53231.00.00.100390	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
847	0523432051	5.53231.00.00.100390	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
848	0537704373	5.53231.00.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
849	0537704373	5.53231.00.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
850	0537704373	5.53231.00.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
851	0537704373	5.53231.00.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
852	0537704373	5.53231.00.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
853	0537704373	5.53231.00.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
854	0537704373	5.53231.00.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
855	0537704373	5.53231.00.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
856	0537704373	5.53231.00.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
857	0537704373	5.53231.00.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
858	0537704373	5.53231.00.00.100016	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
859	0537630415	5.53231.00.00.100397	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
860	0537630415	5.53231.00.00.100397	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
861	0537630415	5.53231.00.00.100397	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
862	0537630415	5.53231.00.00.100397	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
863	0537630415	5.53231.00.00.100397	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
864	0537630415	5.53231.00.00.100397	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
865	0537630415	5.53231.00.00.100397	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
866	0537630415	5.53231.00.00.100397	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
867	0537630415	5.53231.00.00.100397	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
868	0537630415	5.53231.00.00.100397	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
869	0537630415	5.53231.00.00.100397	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
870	0528852749	5.53231.00.00.100098	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
871	0528852749	5.53231.00.00.100098	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
872	0528852749	5.53231.00.00.100098	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
873	0528852749	5.53231.00.00.100098	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
874	0528852749	5.53231.00.00.100098	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
875	0528852749	5.53231.00.00.100098	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
876	0528852749	5.53231.00.00.100098	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
877	0528852749	5.53231.00.00.100098	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
878	0528852749	5.53231.00.00.100098	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
879	0528852749	5.53231.00.00.100098	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
880	0528852749	5.53231.00.00.100098	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
881	0522710435	5.53231.00.00.100159	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
882	0522710435	5.53231.00.00.100159	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
883	0522710435	5.53231.00.00.100159	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
884	0522710435	5.53231.00.00.100159	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
885	0522710435	5.53231.00.00.100159	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
886	0522710435	5.53231.00.00.100159	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
887	0522710435	5.53231.00.00.100159	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
888	0522710435	5.53231.00.00.100159	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
889	0522710435	5.53231.00.00.100159	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
890	0522710435	5.53231.00.00.100159	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
891	0522710435	5.53231.00.00.100159	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
892	0535525800	5.53231.00.00.100110	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
893	0535525800	5.53231.00.00.100110	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
894	0535525800	5.53231.00.00.100110	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
895	0535525800	5.53231.00.00.100110	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
896	0535525800	5.53231.00.00.100110	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
897	0535525800	5.53231.00.00.100110	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
898	0535525800	5.53231.00.00.100110	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
899	0535525800	5.53231.00.00.100110	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
900	0535525800	5.53231.00.00.100110	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
901	0535525800	5.53231.00.00.100110	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
902	0535525800	5.53231.00.00.100110	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
903	0537686175	5.53231.00.00.100205	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
904	0537686175	5.53231.00.00.100205	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
905	0537686175	5.53231.00.00.100205	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
906	0537686175	5.53231.00.00.100205	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
907	0537686175	5.53231.00.00.100205	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
908	0537686175	5.53231.00.00.100205	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
909	0537686175	5.53231.00.00.100205	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
910	0537686175	5.53231.00.00.100205	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
911	0537686175	5.53231.00.00.100205	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
912	0537686175	5.53231.00.00.100205	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
913	0537686175	5.53231.00.00.100205	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
914	0537704553	5.53231.00.00.100160	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
915	0537704553	5.53231.00.00.100160	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
916	0537704553	5.53231.00.00.100160	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
917	0537704553	5.53231.00.00.100160	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
918	0537704553	5.53231.00.00.100160	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
919	0537704553	5.53231.00.00.100160	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
920	0537704553	5.53231.00.00.100160	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
921	0537704553	5.53231.00.00.100160	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
922	0537704553	5.53231.00.00.100160	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
923	0537704553	5.53231.00.00.100160	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
924	0537704553	5.53231.00.00.100160	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
925	0522875376	5.53231.00.00.100325	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
926	0522875376	5.53231.00.00.100325	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
927	0522875376	5.53231.00.00.100325	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
928	0522875376	5.53231.00.00.100325	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
929	0522875376	5.53231.00.00.100325	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
930	0522875376	5.53231.00.00.100325	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
931	0522875376	5.53231.00.00.100325	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
932	0522875376	5.53231.00.00.100325	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
933	0522875376	5.53231.00.00.100325	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
934	0522875376	5.53231.00.00.100325	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
935	0522875376	5.53231.00.00.100325	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
936	0535649261	5.53231.00.00.100117	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
937	0535649261	5.53231.00.00.100117	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
938	0535649261	5.53231.00.00.100117	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
939	0535649261	5.53231.00.00.100117	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
940	0535649261	5.53231.00.00.100117	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
941	0535649261	5.53231.00.00.100117	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
942	0535649261	5.53231.00.00.100117	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
943	0535649261	5.53231.00.00.100117	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
944	0535649261	5.53231.00.00.100117	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
945	0535649261	5.53231.00.00.100117	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
946	0535649261	5.53231.00.00.100117	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
947	0537704689	5.53231.00.00.100054	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
948	0537704689	5.53231.00.00.100054	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
949	0537704689	5.53231.00.00.100054	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
950	0537704689	5.53231.00.00.100054	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
951	0537704689	5.53231.00.00.100054	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
952	0537704689	5.53231.00.00.100054	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
953	0537704689	5.53231.00.00.100054	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
954	0537704689	5.53231.00.00.100054	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
955	0537704689	5.53231.00.00.100054	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
956	0537704689	5.53231.00.00.100054	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
957	0537704689	5.53231.00.00.100054	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
958	0522219050	5.53231.00.00.100206	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
959	0522219050	5.53231.00.00.100206	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
960	0522219050	5.53231.00.00.100206	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
961	0522219050	5.53231.00.00.100206	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
962	0522219050	5.53231.00.00.100206	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
963	0522219050	5.53231.00.00.100206	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
964	0522219050	5.53231.00.00.100206	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
965	0522219050	5.53231.00.00.100206	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
966	0522219050	5.53231.00.00.100206	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
967	0522219050	5.53231.00.00.100206	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
968	0522219050	5.53231.00.00.100206	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
969	0539993038	5.53231.00.00.100070	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
970	0539993038	5.53231.00.00.100070	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
971	0539993038	5.53231.00.00.100070	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
972	0539993038	5.53231.00.00.100070	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
973	0539993038	5.53231.00.00.100070	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
974	0539993038	5.53231.00.00.100070	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
975	0539993038	5.53231.00.00.100070	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
976	0539993038	5.53231.00.00.100070	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
977	0539993038	5.53231.00.00.100070	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
978	0539993038	5.53231.00.00.100070	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
979	0539993038	5.53231.00.00.100070	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
980	0524412219	5.53231.00.00.100087	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
981	0524412219	5.53231.00.00.100087	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
982	0524412219	5.53231.00.00.100087	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
983	0524412219	5.53231.00.00.100087	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
984	0524412219	5.53231.00.00.100087	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
985	0524412219	5.53231.00.00.100087	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
986	0524412219	5.53231.00.00.100087	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
987	0524412219	5.53231.00.00.100087	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
988	0524412219	5.53231.00.00.100087	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
989	0524412219	5.53231.00.00.100087	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
990	0524412219	5.53231.00.00.100087	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
991	0523560304	5.53231.00.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
992	0523560304	5.53231.00.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
993	0523560304	5.53231.00.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
994	0523560304	5.53231.00.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
995	0523560304	5.53231.00.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
996	0523560304	5.53231.00.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
997	0523560304	5.53231.00.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
998	0523560304	5.53231.00.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
999	0523560304	5.53231.00.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1000	0523560304	5.53231.00.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1001	0523560304	5.53231.00.00.100083	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1002	0523313248	7.1830754.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1003	0523313248	7.1830754.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1004	0523313248	7.1830754.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1005	0523313248	7.1830754.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1006	0523313248	7.1830754.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1007	0523313248	7.1830754.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1008	0523313248	7.1830754.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1009	0523313248	7.1830754.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1010	0523313248	7.1830754.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1011	0523313248	7.1830754.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1012	0523313248	7.1830754.00.00.100014	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1013	0524474024	5.53231.00.00.100185	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1014	0524474024	5.53231.00.00.100185	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1015	0524474024	5.53231.00.00.100185	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1016	0524474024	5.53231.00.00.100185	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1017	0524474024	5.53231.00.00.100185	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1018	0524474024	5.53231.00.00.100185	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1019	0524474024	5.53231.00.00.100185	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1020	0524474024	5.53231.00.00.100185	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1021	0524474024	5.53231.00.00.100185	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1022	0524474024	5.53231.00.00.100185	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1023	0524474024	5.53231.00.00.100185	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1024	0523291619	8.11414778.00.00.100000	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1025	0523291619	8.11414778.00.00.100000	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1026	0523291619	8.11414778.00.00.100000	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1027	0523291619	8.11414778.00.00.100000	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1028	0523291619	8.11414778.00.00.100000	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1029	0523291619	8.11414778.00.00.100000	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1030	0523291619	8.11414778.00.00.100000	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1031	0523291619	8.11414778.00.00.100000	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1032	0523291619	8.11414778.00.00.100000	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1033	0523291619	8.11414778.00.00.100000	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1034	0523291619	8.11414778.00.00.100000	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1035	0537612904	5.53231.00.00.100137	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1036	0537612904	5.53231.00.00.100137	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1037	0537612904	5.53231.00.00.100137	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1038	0537612904	5.53231.00.00.100137	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1039	0537612904	5.53231.00.00.100137	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1040	0537612904	5.53231.00.00.100137	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1041	0537612904	5.53231.00.00.100137	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1042	0537612904	5.53231.00.00.100137	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1043	0537612904	5.53231.00.00.100137	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1044	0537612904	5.53231.00.00.100137	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1045	0537612904	5.53231.00.00.100137	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1046	0536798141	5.53231.00.00.100122	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1047	0536798141	5.53231.00.00.100122	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1048	0536798141	5.53231.00.00.100122	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1049	0536798141	5.53231.00.00.100122	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1050	0536798141	5.53231.00.00.100122	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1051	0536798141	5.53231.00.00.100122	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1052	0536798141	5.53231.00.00.100122	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1053	0536798141	5.53231.00.00.100122	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1054	0536798141	5.53231.00.00.100122	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1055	0536798141	5.53231.00.00.100122	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1056	0536798141	5.53231.00.00.100122	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1057	0528877449	5.53231.00.00.100101	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1058	0528877449	5.53231.00.00.100101	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1059	0528877449	5.53231.00.00.100101	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1060	0528877449	5.53231.00.00.100101	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1061	0528877449	5.53231.00.00.100101	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1062	0528877449	5.53231.00.00.100101	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1063	0528877449	5.53231.00.00.100101	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1064	0528877449	5.53231.00.00.100101	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1065	0528877449	5.53231.00.00.100101	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1066	0528877449	5.53231.00.00.100101	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1067	0528877449	5.53231.00.00.100101	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1068	0528828383	5.53231.00.00.100327	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1069	0528828383	5.53231.00.00.100327	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1070	0528828383	5.53231.00.00.100327	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1071	0528828383	5.53231.00.00.100327	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1072	0528828383	5.53231.00.00.100327	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1073	0528828383	5.53231.00.00.100327	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1074	0528828383	5.53231.00.00.100327	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1075	0528828383	5.53231.00.00.100327	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1076	0528828383	5.53231.00.00.100327	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1077	0528828383	5.53231.00.00.100327	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1078	0528828383	5.53231.00.00.100327	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1079	0537809686	5.53231.00.00.100042	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1080	0537809686	5.53231.00.00.100042	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1081	0537809686	5.53231.00.00.100042	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1082	0537809686	5.53231.00.00.100042	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1083	0537809686	5.53231.00.00.100042	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1084	0537809686	5.53231.00.00.100042	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1085	0537809686	5.53231.00.00.100042	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1086	0537809686	5.53231.00.00.100042	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1087	0537809686	5.53231.00.00.100042	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1088	0537809686	5.53231.00.00.100042	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1089	0537809686	5.53231.00.00.100042	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1090	0524642692	5.53231.00.00.100175	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1091	0524642692	5.53231.00.00.100175	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1092	0524642692	5.53231.00.00.100175	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1093	0524642692	5.53231.00.00.100175	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1094	0524642692	5.53231.00.00.100175	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1095	0524642692	5.53231.00.00.100175	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1096	0524642692	5.53231.00.00.100175	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1097	0524642692	5.53231.00.00.100175	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1098	0524642692	5.53231.00.00.100175	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1099	0524642692	5.53231.00.00.100175	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1100	0524642692	5.53231.00.00.100175	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1101	0528875032	5.53231.00.00.100339	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1102	0528875032	5.53231.00.00.100339	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1103	0528875032	5.53231.00.00.100339	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1104	0528875032	5.53231.00.00.100339	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1105	0528875032	5.53231.00.00.100339	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1106	0528875032	5.53231.00.00.100339	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1107	0528875032	5.53231.00.00.100339	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1108	0528875032	5.53231.00.00.100339	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1109	0528875032	5.53231.00.00.100339	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1110	0528875032	5.53231.00.00.100339	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1111	0528875032	5.53231.00.00.100339	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1112	0539982952	5.53231.00.00.100148	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1113	0539982952	5.53231.00.00.100148	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1114	0539982952	5.53231.00.00.100148	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1115	0539982952	5.53231.00.00.100148	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1116	0539982952	5.53231.00.00.100148	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1117	0539982952	5.53231.00.00.100148	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1118	0539982952	5.53231.00.00.100148	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1119	0539982952	5.53231.00.00.100148	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1120	0539982952	5.53231.00.00.100148	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1121	0539982952	5.53231.00.00.100148	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1122	0539982952	5.53231.00.00.100148	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1123	0523403766	5.53231.00.00.100143	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1124	0523403766	5.53231.00.00.100143	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1125	0523403766	5.53231.00.00.100143	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1126	0523403766	5.53231.00.00.100143	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1127	0523403766	5.53231.00.00.100143	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1128	0523403766	5.53231.00.00.100143	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1129	0523403766	5.53231.00.00.100143	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1130	0523403766	5.53231.00.00.100143	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1131	0523403766	5.53231.00.00.100143	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1132	0523403766	5.53231.00.00.100143	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1133	0523403766	5.53231.00.00.100143	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1134	0524835882	5.53231.00.00.100358	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1135	0524835882	5.53231.00.00.100358	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1136	0524835882	5.53231.00.00.100358	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1137	0524835882	5.53231.00.00.100358	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1138	0524835882	5.53231.00.00.100358	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1139	0524835882	5.53231.00.00.100358	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1140	0524835882	5.53231.00.00.100358	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1141	0524835882	5.53231.00.00.100358	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1142	0524835882	5.53231.00.00.100358	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1143	0524835882	5.53231.00.00.100358	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1144	0524835882	5.53231.00.00.100358	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1145	0522600690	5.53231.00.00.100142	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1146	0522600690	5.53231.00.00.100142	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1147	0522600690	5.53231.00.00.100142	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1148	0522600690	5.53231.00.00.100142	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1149	0522600690	5.53231.00.00.100142	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1150	0522600690	5.53231.00.00.100142	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1151	0522600690	5.53231.00.00.100142	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1152	0522600690	5.53231.00.00.100142	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1153	0522600690	5.53231.00.00.100142	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1154	0522600690	5.53231.00.00.100142	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1155	0522600690	5.53231.00.00.100142	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1156	0528873840	5.53231.00.00.100192	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1157	0528873840	5.53231.00.00.100192	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1158	0528873840	5.53231.00.00.100192	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1159	0528873840	5.53231.00.00.100192	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1160	0528873840	5.53231.00.00.100192	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1161	0528873840	5.53231.00.00.100192	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1162	0528873840	5.53231.00.00.100192	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1163	0528873840	5.53231.00.00.100192	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1164	0528873840	5.53231.00.00.100192	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1165	0528873840	5.53231.00.00.100192	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1166	0528873840	5.53231.00.00.100192	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1167	0528834140	5.53231.00.00.100149	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1168	0528834140	5.53231.00.00.100149	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1169	0528834140	5.53231.00.00.100149	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1170	0528834140	5.53231.00.00.100149	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1171	0528834140	5.53231.00.00.100149	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1172	0528834140	5.53231.00.00.100149	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1173	0528834140	5.53231.00.00.100149	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1174	0528834140	5.53231.00.00.100149	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1175	0528834140	5.53231.00.00.100149	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1176	0528834140	5.53231.00.00.100149	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1177	0528834140	5.53231.00.00.100149	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1178	0535676045	5.53231.00.00.100360	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1179	0535676045	5.53231.00.00.100360	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1180	0535676045	5.53231.00.00.100360	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1181	0535676045	5.53231.00.00.100360	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1182	0535676045	5.53231.00.00.100360	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1183	0535676045	5.53231.00.00.100360	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1184	0535676045	5.53231.00.00.100360	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1185	0535676045	5.53231.00.00.100360	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1186	0535676045	5.53231.00.00.100360	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1187	0535676045	5.53231.00.00.100360	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1188	0535676045	5.53231.00.00.100360	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1189	0535567637	5.53231.00.00.100172	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1190	0535567637	5.53231.00.00.100172	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1191	0535567637	5.53231.00.00.100172	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1192	0535567637	5.53231.00.00.100172	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1193	0535567637	5.53231.00.00.100172	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1194	0535567637	5.53231.00.00.100172	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1195	0535567637	5.53231.00.00.100172	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1196	0535567637	5.53231.00.00.100172	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1197	0535567637	5.53231.00.00.100172	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1198	0535567637	5.53231.00.00.100172	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1199	0535567637	5.53231.00.00.100172	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1200	0522510432	5.53231.00.00.100167	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1201	0522510432	5.53231.00.00.100167	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1202	0522510432	5.53231.00.00.100167	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1203	0522510432	5.53231.00.00.100167	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1204	0522510432	5.53231.00.00.100167	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1205	0522510432	5.53231.00.00.100167	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1206	0522510432	5.53231.00.00.100167	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1207	0522510432	5.53231.00.00.100167	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1208	0522510432	5.53231.00.00.100167	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1209	0522510432	5.53231.00.00.100167	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1210	0522510432	5.53231.00.00.100167	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1211	0536820633	5.53231.00.00.100124	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1212	0536820633	5.53231.00.00.100124	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1213	0536820633	5.53231.00.00.100124	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1214	0536820633	5.53231.00.00.100124	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1215	0536820633	5.53231.00.00.100124	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1216	0536820633	5.53231.00.00.100124	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1217	0536820633	5.53231.00.00.100124	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1218	0536820633	5.53231.00.00.100124	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1219	0536820633	5.53231.00.00.100124	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1220	0536820633	5.53231.00.00.100124	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
1221	0536820633	5.53231.00.00.100124	\N	\N	\N	\N	\N	\N	2026-07-16 11:34:24.211	ELHAIMER AMINE	2026-07-16 12:34:16.101176	2026-07-16 12:34:16.101176
\.


--
-- Data for Name: sheet_rules; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.sheet_rules (id, role, sheet_name, mapping, updated_by, created_at, updated_at) FROM stdin;
4	reglements	MINISTERE FIXE 	{"nom": null, "custom": {}, "montant": "MONTANT", "produit": "PRODUIT", "custcode": "CUSTCODE", "echeance": "ECHEANCE", "refFacture": "REF_FACT"}	ELHAIMER AMINE	2026-07-14 10:39:16.101478	2026-07-16 11:34:49.014
5	reglements	MINISTERE INTERNET	{"nom": null, "custom": {}, "montant": "MONTANT", "produit": "PRODUIT", "custcode": "CUSTODE", "echeance": "ECHEANCE", "refFacture": "REF-FACT"}	ELHAIMER AMINE	2026-07-14 10:39:16.108055	2026-07-16 11:34:49.026
3	reglements	ENTRAIDE NATIONALE FIXE 	{"nom": null, "custom": {}, "montant": "MONTANT", "produit": "PRODUIT", "custcode": "CUSTCODE", "echeance": "ECHEANCE", "refFacture": "REF_FACT"}	ELHAIMER AMINE	2026-07-14 10:39:16.092331	2026-07-16 11:34:49.037
6	reglements	ENTRAIDE NATIONALE INTERNET 	{"nom": null, "custom": {}, "montant": "MONTANT", "produit": "PRODUIT", "custcode": "CUSTODE", "echeance": "ECHEANCE", "refFacture": "REF-FACT"}	ELHAIMER AMINE	2026-07-14 10:39:16.11541	2026-07-16 11:34:49.048
1	impayes	Fix	{"nom": "NOM", "custom": {}, "montant": "MNT_FACT", "produit": null, "custcode": "CUSTCODE", "echeance": "ECHEANCE", "refFacture": "REF_FACT"}	ELHAIMER AMINE	2026-07-14 10:39:16.059235	2026-07-16 11:34:48.951
2	impayes	int	{"nom": "INT_CLI", "custom": {}, "montant": "MONTANT", "produit": null, "custcode": "CUSTCODE", "echeance": "ECHEANCE", "refFacture": "REF_FACT"}	ELHAIMER AMINE	2026-07-14 10:39:16.084163	2026-07-16 11:34:48.97
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
\.


--
-- Data for Name: system_settings; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.system_settings (id, organization_name, support_email, session_duration_days, maintenance_mode, maintenance_message, updated_by, updated_at) FROM stdin;
1	Entraide Nationale	el.amyne@gmail.com	30	f	\N	ELHAIMER AMINE	2026-07-16 08:39:25.652
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.users (id, username, password_hash, display_name, created_at, updated_at, role, is_active, last_login_at, deleted_at, deleted_by) FROM stdin;
4	TEST	$2a$10$oHQzS0lgcWBl0hJN6LYVBeidmqea/NeDeCAoFP2DEvQC7AjgztHR2	TEST 	2026-07-11 16:33:02.368198	2026-07-11 16:33:02.368198	USER	t	2026-07-15 23:02:47.239	\N	\N
7	superadmin	$2a$10$bcadPkD7ArUaN5J0EyIuzeDcbLX46pNGZheLxVb/6SUZznwARKXNa	superadmin	2026-07-14 14:49:13.1683	2026-07-15 22:59:43.542	SUPER_ADMIN	t	2026-07-15 23:40:55.699	\N	\N
2	ANAS JABRAN	$2a$10$AIfIf0kYSqp4FP70Z9CbleB2FdYArHkpKF2/FWC7BvWJEZksIOw0W	ANAS JABRAN 	2026-07-11 16:25:49.299453	2026-07-15 23:05:27.977	SUPER_ADMIN	t	2026-07-15 23:51:54.891	\N	\N
3	ELHAIMER AMINE	$2a$10$Ypnz.MvIYji7MqINHwloQOzTo4KgbSm5g/WuhZ45xFNAEQ0Jub.4K	ELHAIMER AMINE	2026-07-11 16:29:31.7373	2026-07-11 16:29:31.7373	SUPER_ADMIN	t	2026-07-16 11:33:22.513	\N	\N
6	SARA EL HAMADI	$2a$10$isoVJcN85EJqgwoHQUHEJ.JMsIq39ky.rmlsJ5KLN13HSBmoqPm6G	SARA EL HAMADI	2026-07-13 12:57:11.745503	2026-07-13 12:57:11.745503	SUPER_ADMIN	t	2026-07-16 11:40:04.295	\N	\N
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

SELECT pg_catalog.setval('iam.audit_logs_id_seq', 40, true);


--
-- Name: connection_logs_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.connection_logs_id_seq', 52, true);


--
-- Name: correction_rules_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.correction_rules_id_seq', 2, true);


--
-- Name: custom_fields_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.custom_fields_id_seq', 1, false);


--
-- Name: factures_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.factures_id_seq', 1222, true);


--
-- Name: lignes_fixes_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.lignes_fixes_id_seq', 1221, true);


--
-- Name: lignes_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.lignes_id_seq', 8, true);


--
-- Name: sheet_rules_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.sheet_rules_id_seq', 6, true);


--
-- Name: system_logs_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.system_logs_id_seq', 18, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.users_id_seq', 7, true);


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
-- Name: connection_logs_created_at_idx; Type: INDEX; Schema: iam; Owner: -
--

CREATE INDEX connection_logs_created_at_idx ON iam.connection_logs USING btree (created_at DESC);


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
-- Name: system_logs_created_at_idx; Type: INDEX; Schema: iam; Owner: -
--

CREATE INDEX system_logs_created_at_idx ON iam.system_logs USING btree (created_at DESC);


--
-- PostgreSQL database dump complete
--

\unrestrict IedwGwIQ2upRzOpDuMJcYlWhk8qDKs6TcQa3qwqjj0zfhvW6QiT62e0snZtm3g3

