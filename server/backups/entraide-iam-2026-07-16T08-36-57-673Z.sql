--
-- PostgreSQL database dump
--

\restrict mZzEWNpmXlT97UjMzaGQ680vF8TjlzRPCoYONuKeC3MFck2BZowjePpMyVdSanZ

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
-- Name: lignes id; Type: DEFAULT; Schema: iam; Owner: -
--

ALTER TABLE ONLY iam.lignes ALTER COLUMN id SET DEFAULT nextval('iam.lignes_id_seq'::regclass);


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
-- Data for Name: lignes; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.lignes (id, categorie, type_forfait, type_mobile, icc, imei, affecte, personne, qualite, date, created_at, updated_at, civilite, deleted_at, deleted_by) FROM stdin;
4	CAT 1	40G	IPHONE 13	34567	23456789	DIRECTION	ELHAIMER AMINE	Division du Patrimoine et de la Logistique	2026-07-14	2026-07-14 11:34:53.526812	2026-07-14 11:32:58.867	\N	\N	\N
1	CAT 1	30G	IPHONE	34567890	3456789	direction	ELHAIMER	Division du Patrimoine et de la Logistique	2026-07-13	2026-07-13 12:53:06.689556	2026-07-14 11:50:48.03	M.	\N	\N
\.


--
-- Data for Name: sheet_rules; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.sheet_rules (id, role, sheet_name, mapping, updated_by, created_at, updated_at) FROM stdin;
1	impayes	Fix	{"nom": "NOM", "custom": {}, "montant": "MNT_FACT", "produit": null, "custcode": "CUSTCODE", "echeance": "ECHEANCE", "refFacture": "REF_FACT"}	ELHAIMER AMINE	2026-07-14 10:39:16.059235	2026-07-15 23:41:45.777
2	impayes	int	{"nom": "INT_CLI", "custom": {}, "montant": "MONTANT", "produit": null, "custcode": "CUSTCODE", "echeance": "ECHEANCE", "refFacture": "REF_FACT"}	ELHAIMER AMINE	2026-07-14 10:39:16.084163	2026-07-15 23:41:45.79
4	reglements	MINISTERE FIXE 	{"nom": null, "custom": {}, "montant": "MONTANT", "produit": "PRODUIT", "custcode": "CUSTCODE", "echeance": "ECHEANCE", "refFacture": "REF_FACT"}	ELHAIMER AMINE	2026-07-14 10:39:16.101478	2026-07-15 23:41:45.802
5	reglements	MINISTERE INTERNET	{"nom": null, "custom": {}, "montant": "MONTANT", "produit": "PRODUIT", "custcode": "CUSTODE", "echeance": "ECHEANCE", "refFacture": "REF-FACT"}	ELHAIMER AMINE	2026-07-14 10:39:16.108055	2026-07-15 23:41:45.848
3	reglements	ENTRAIDE NATIONALE FIXE 	{"nom": null, "custom": {}, "montant": "MONTANT", "produit": "PRODUIT", "custcode": "CUSTCODE", "echeance": "ECHEANCE", "refFacture": "REF_FACT"}	ELHAIMER AMINE	2026-07-14 10:39:16.092331	2026-07-15 23:41:45.857
6	reglements	ENTRAIDE NATIONALE INTERNET 	{"nom": null, "custom": {}, "montant": "MONTANT", "produit": "PRODUIT", "custcode": "CUSTODE", "echeance": "ECHEANCE", "refFacture": "REF-FACT"}	ELHAIMER AMINE	2026-07-14 10:39:16.11541	2026-07-15 23:41:45.869
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
\.


--
-- Data for Name: system_settings; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.system_settings (id, organization_name, support_email, session_duration_days, maintenance_mode, maintenance_message, updated_by, updated_at) FROM stdin;
1	Entraide Nationale	el.amyne@gmail.com	30	f	\N	ELHAIMER AMINE	2026-07-16 08:33:03.522
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: iam; Owner: -
--

COPY iam.users (id, username, password_hash, display_name, created_at, updated_at, role, is_active, last_login_at, deleted_at, deleted_by) FROM stdin;
4	TEST	$2a$10$oHQzS0lgcWBl0hJN6LYVBeidmqea/NeDeCAoFP2DEvQC7AjgztHR2	TEST 	2026-07-11 16:33:02.368198	2026-07-11 16:33:02.368198	USER	t	2026-07-15 23:02:47.239	\N	\N
7	superadmin	$2a$10$bcadPkD7ArUaN5J0EyIuzeDcbLX46pNGZheLxVb/6SUZznwARKXNa	superadmin	2026-07-14 14:49:13.1683	2026-07-15 22:59:43.542	SUPER_ADMIN	t	2026-07-15 23:40:55.699	\N	\N
2	ANAS JABRAN	$2a$10$AIfIf0kYSqp4FP70Z9CbleB2FdYArHkpKF2/FWC7BvWJEZksIOw0W	ANAS JABRAN 	2026-07-11 16:25:49.299453	2026-07-15 23:05:27.977	SUPER_ADMIN	t	2026-07-15 23:51:54.891	\N	\N
6	SARA EL HAMADI	$2a$10$isoVJcN85EJqgwoHQUHEJ.JMsIq39ky.rmlsJ5KLN13HSBmoqPm6G	SARA EL HAMADI	2026-07-13 12:57:11.745503	2026-07-13 12:57:11.745503	SUPER_ADMIN	t	2026-07-16 08:14:05.922	\N	\N
3	ELHAIMER AMINE	$2a$10$Ypnz.MvIYji7MqINHwloQOzTo4KgbSm5g/WuhZ45xFNAEQ0Jub.4K	ELHAIMER AMINE	2026-07-11 16:29:31.7373	2026-07-11 16:29:31.7373	SUPER_ADMIN	t	2026-07-16 08:32:58.418	\N	\N
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

SELECT pg_catalog.setval('iam.audit_logs_id_seq', 23, true);


--
-- Name: connection_logs_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.connection_logs_id_seq', 48, true);


--
-- Name: correction_rules_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.correction_rules_id_seq', 1, true);


--
-- Name: custom_fields_id_seq; Type: SEQUENCE SET; Schema: iam; Owner: -
--

SELECT pg_catalog.setval('iam.custom_fields_id_seq', 1, false);


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

SELECT pg_catalog.setval('iam.system_logs_id_seq', 14, true);


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

\unrestrict mZzEWNpmXlT97UjMzaGQ680vF8TjlzRPCoYONuKeC3MFck2BZowjePpMyVdSanZ

