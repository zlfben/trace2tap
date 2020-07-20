--
-- PostgreSQL database dump
--

-- Dumped from database version 10.4
-- Dumped by pg_dump version 10.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(80) NOT NULL
);


--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auth_user_groups_id_seq OWNED BY public.auth_user_groups.id;


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auth_user_id_seq OWNED BY public.auth_user.id;


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auth_user_user_permissions_id_seq OWNED BY public.auth_user_user_permissions.id;


--
-- Name: authtoken_token; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.authtoken_token (
    key character varying(40) NOT NULL,
    created timestamp with time zone NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


--
-- Name: smartthings_argument; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.smartthings_argument (
    id integer NOT NULL,
    name character varying(128) NOT NULL,
    command_id integer NOT NULL,
    data_type character varying(64),
    required boolean NOT NULL
);


--
-- Name: smartthings_argument_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.smartthings_argument_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: smartthings_argument_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.smartthings_argument_id_seq OWNED BY public.smartthings_argument.id;


--
-- Name: smartthings_attribute; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.smartthings_attribute (
    id integer NOT NULL,
    name character varying(128) NOT NULL,
    value text,
    capability_id integer NOT NULL,
    data_type character varying(64),
    required boolean NOT NULL
);


--
-- Name: smartthings_attribute_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.smartthings_attribute_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: smartthings_attribute_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.smartthings_attribute_id_seq OWNED BY public.smartthings_attribute.id;


--
-- Name: smartthings_capability; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.smartthings_capability (
    id integer NOT NULL,
    name character varying(128) NOT NULL,
    st_id character varying(128) NOT NULL
);


--
-- Name: smartthings_capability_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.smartthings_capability_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: smartthings_capability_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.smartthings_capability_id_seq OWNED BY public.smartthings_capability.id;


--
-- Name: smartthings_command; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.smartthings_command (
    id integer NOT NULL,
    name character varying(128) NOT NULL,
    capability_id integer NOT NULL
);


--
-- Name: smartthings_command_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.smartthings_command_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: smartthings_command_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.smartthings_command_id_seq OWNED BY public.smartthings_command.id;


--
-- Name: smartthings_device; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.smartthings_device (
    id integer NOT NULL,
    st_device_id character varying(36) NOT NULL,
    proj_device_id integer NOT NULL,
    component_id character varying(36) NOT NULL
);


--
-- Name: smartthings_device_capabilities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.smartthings_device_capabilities (
    id integer NOT NULL,
    device_id integer NOT NULL,
    capability_id integer NOT NULL
);


--
-- Name: smartthings_device_capabilities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.smartthings_device_capabilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: smartthings_device_capabilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.smartthings_device_capabilities_id_seq OWNED BY public.smartthings_device_capabilities.id;


--
-- Name: smartthings_device_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.smartthings_device_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: smartthings_device_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.smartthings_device_id_seq OWNED BY public.smartthings_device.id;


--
-- Name: smartthings_stapp; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.smartthings_stapp (
    id integer NOT NULL,
    app_id character varying(128) NOT NULL,
    description text NOT NULL,
    name character varying(128) NOT NULL,
    client_id character varying(36),
    client_secret character varying(36),
    proj_endpoint character varying(200)
);


--
-- Name: smartthings_stapp_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.smartthings_stapp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: smartthings_stapp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.smartthings_stapp_id_seq OWNED BY public.smartthings_stapp.id;


--
-- Name: smartthings_stapp_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.smartthings_stapp_permissions (
    id integer NOT NULL,
    stapp_id integer NOT NULL,
    stapppermission_id integer NOT NULL
);


--
-- Name: smartthings_stapp_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.smartthings_stapp_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: smartthings_stapp_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.smartthings_stapp_permissions_id_seq OWNED BY public.smartthings_stapp_permissions.id;


--
-- Name: smartthings_stappconfpage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.smartthings_stappconfpage (
    id integer NOT NULL,
    "pageId" character varying(64) NOT NULL,
    name character varying(128) NOT NULL,
    "nextPageId" character varying(64),
    "previousPageId" character varying(64),
    complete boolean NOT NULL,
    st_app_id integer NOT NULL
);


--
-- Name: smartthings_stappconfpage_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.smartthings_stappconfpage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: smartthings_stappconfpage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.smartthings_stappconfpage_id_seq OWNED BY public.smartthings_stappconfpage.id;


--
-- Name: smartthings_stappconfsection; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.smartthings_stappconfsection (
    id integer NOT NULL,
    name text NOT NULL,
    page_id integer NOT NULL,
    st_app_id character varying(128)
);


--
-- Name: smartthings_stappconfsection_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.smartthings_stappconfsection_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: smartthings_stappconfsection_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.smartthings_stappconfsection_id_seq OWNED BY public.smartthings_stappconfsection.id;


--
-- Name: smartthings_stappconfsectionsetting; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.smartthings_stappconfsectionsetting (
    id integer NOT NULL,
    setting_id character varying(36) NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    setting_type character varying(36) NOT NULL,
    required boolean NOT NULL,
    multiple boolean NOT NULL,
    section_id integer NOT NULL,
    st_app_id character varying(128)
);


--
-- Name: smartthings_stappconfsectionsetting_capabilities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.smartthings_stappconfsectionsetting_capabilities (
    id integer NOT NULL,
    stappconfsectionsetting_id integer NOT NULL,
    capability_id integer NOT NULL
);


--
-- Name: smartthings_stappconfsectionsetting_capabilities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.smartthings_stappconfsectionsetting_capabilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: smartthings_stappconfsectionsetting_capabilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.smartthings_stappconfsectionsetting_capabilities_id_seq OWNED BY public.smartthings_stappconfsectionsetting_capabilities.id;


--
-- Name: smartthings_stappconfsectionsetting_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.smartthings_stappconfsectionsetting_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: smartthings_stappconfsectionsetting_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.smartthings_stappconfsectionsetting_id_seq OWNED BY public.smartthings_stappconfsectionsetting.id;


--
-- Name: smartthings_stappconfsectionsetting_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.smartthings_stappconfsectionsetting_permissions (
    id integer NOT NULL,
    stappconfsectionsetting_id integer NOT NULL,
    stapppermission_id integer NOT NULL
);


--
-- Name: smartthings_stappconfsectionsetting_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.smartthings_stappconfsectionsetting_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: smartthings_stappconfsectionsetting_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.smartthings_stappconfsectionsetting_permissions_id_seq OWNED BY public.smartthings_stappconfsectionsetting_permissions.id;


--
-- Name: smartthings_stappinstance; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.smartthings_stappinstance (
    id integer NOT NULL,
    st_installed_app_id character varying(36) NOT NULL,
    refresh_token character varying(40) NOT NULL,
    st_app_id integer NOT NULL,
    location_id character varying(36)
);


--
-- Name: smartthings_stappinstance_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.smartthings_stappinstance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: smartthings_stappinstance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.smartthings_stappinstance_id_seq OWNED BY public.smartthings_stappinstance.id;


--
-- Name: smartthings_stappinstancesetting; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.smartthings_stappinstancesetting (
    id integer NOT NULL,
    device_id integer,
    setting_id integer NOT NULL,
    st_app_instance_id integer NOT NULL
);


--
-- Name: smartthings_stappinstancesettingdevice_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.smartthings_stappinstancesettingdevice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: smartthings_stappinstancesettingdevice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.smartthings_stappinstancesettingdevice_id_seq OWNED BY public.smartthings_stappinstancesetting.id;


--
-- Name: smartthings_stapppermission; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.smartthings_stapppermission (
    id integer NOT NULL,
    scope character varying(36) NOT NULL
);


--
-- Name: smartthings_stapppermission_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.smartthings_stapppermission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: smartthings_stapppermission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.smartthings_stapppermission_id_seq OWNED BY public.smartthings_stapppermission.id;


--
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- Name: auth_user id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user ALTER COLUMN id SET DEFAULT nextval('public.auth_user_id_seq'::regclass);


--
-- Name: auth_user_groups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_groups ALTER COLUMN id SET DEFAULT nextval('public.auth_user_groups_id_seq'::regclass);


--
-- Name: auth_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_user_user_permissions_id_seq'::regclass);


--
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- Name: smartthings_argument id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_argument ALTER COLUMN id SET DEFAULT nextval('public.smartthings_argument_id_seq'::regclass);


--
-- Name: smartthings_attribute id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_attribute ALTER COLUMN id SET DEFAULT nextval('public.smartthings_attribute_id_seq'::regclass);


--
-- Name: smartthings_capability id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_capability ALTER COLUMN id SET DEFAULT nextval('public.smartthings_capability_id_seq'::regclass);


--
-- Name: smartthings_command id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_command ALTER COLUMN id SET DEFAULT nextval('public.smartthings_command_id_seq'::regclass);


--
-- Name: smartthings_device id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_device ALTER COLUMN id SET DEFAULT nextval('public.smartthings_device_id_seq'::regclass);


--
-- Name: smartthings_device_capabilities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_device_capabilities ALTER COLUMN id SET DEFAULT nextval('public.smartthings_device_capabilities_id_seq'::regclass);


--
-- Name: smartthings_stapp id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stapp ALTER COLUMN id SET DEFAULT nextval('public.smartthings_stapp_id_seq'::regclass);


--
-- Name: smartthings_stapp_permissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stapp_permissions ALTER COLUMN id SET DEFAULT nextval('public.smartthings_stapp_permissions_id_seq'::regclass);


--
-- Name: smartthings_stappconfpage id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stappconfpage ALTER COLUMN id SET DEFAULT nextval('public.smartthings_stappconfpage_id_seq'::regclass);


--
-- Name: smartthings_stappconfsection id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stappconfsection ALTER COLUMN id SET DEFAULT nextval('public.smartthings_stappconfsection_id_seq'::regclass);


--
-- Name: smartthings_stappconfsectionsetting id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stappconfsectionsetting ALTER COLUMN id SET DEFAULT nextval('public.smartthings_stappconfsectionsetting_id_seq'::regclass);


--
-- Name: smartthings_stappconfsectionsetting_capabilities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stappconfsectionsetting_capabilities ALTER COLUMN id SET DEFAULT nextval('public.smartthings_stappconfsectionsetting_capabilities_id_seq'::regclass);


--
-- Name: smartthings_stappconfsectionsetting_permissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stappconfsectionsetting_permissions ALTER COLUMN id SET DEFAULT nextval('public.smartthings_stappconfsectionsetting_permissions_id_seq'::regclass);


--
-- Name: smartthings_stappinstance id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stappinstance ALTER COLUMN id SET DEFAULT nextval('public.smartthings_stappinstance_id_seq'::regclass);


--
-- Name: smartthings_stappinstancesetting id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stappinstancesetting ALTER COLUMN id SET DEFAULT nextval('public.smartthings_stappinstancesettingdevice_id_seq'::regclass);


--
-- Name: smartthings_stapppermission id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stapppermission ALTER COLUMN id SET DEFAULT nextval('public.smartthings_stapppermission_id_seq'::regclass);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can add permission	2	add_permission
5	Can change permission	2	change_permission
6	Can delete permission	2	delete_permission
7	Can add group	3	add_group
8	Can change group	3	change_group
9	Can delete group	3	delete_group
10	Can add user	4	add_user
11	Can change user	4	change_user
12	Can delete user	4	delete_user
13	Can add content type	5	add_contenttype
14	Can change content type	5	change_contenttype
15	Can delete content type	5	delete_contenttype
16	Can add session	6	add_session
17	Can change session	6	change_session
18	Can delete session	6	delete_session
19	Can add Token	7	add_token
20	Can change Token	7	change_token
21	Can delete Token	7	delete_token
22	Can add capability	8	add_capability
23	Can change capability	8	change_capability
24	Can delete capability	8	delete_capability
25	Can add attribute	9	add_attribute
26	Can change attribute	9	change_attribute
27	Can delete attribute	9	delete_attribute
28	Can add command	10	add_command
29	Can change command	10	change_command
30	Can delete command	10	delete_command
31	Can add argument	11	add_argument
32	Can change argument	11	change_argument
33	Can delete argument	11	delete_argument
34	Can add st app permission	12	add_stapppermission
35	Can change st app permission	12	change_stapppermission
36	Can delete st app permission	12	delete_stapppermission
37	Can add st app	13	add_stapp
38	Can change st app	13	change_stapp
39	Can delete st app	13	delete_stapp
40	Can add st app conf page	14	add_stappconfpage
41	Can change st app conf page	14	change_stappconfpage
42	Can delete st app conf page	14	delete_stappconfpage
43	Can add st app conf section	15	add_stappconfsection
44	Can change st app conf section	15	change_stappconfsection
45	Can delete st app conf section	15	delete_stappconfsection
46	Can add st app conf section setting	16	add_stappconfsectionsetting
47	Can change st app conf section setting	16	change_stappconfsectionsetting
48	Can delete st app conf section setting	16	delete_stappconfsectionsetting
49	Can add st app instance	17	add_stappinstance
50	Can change st app instance	17	change_stappinstance
51	Can delete st app instance	17	delete_stappinstance
52	Can add device	18	add_device
53	Can change device	18	change_device
54	Can delete device	18	delete_device
55	Can add st app instance setting	19	add_stappinstancesetting
56	Can change st app instance setting	19	change_stappinstancesetting
57	Can delete st app instance setting	19	delete_stappinstancesetting
\.


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Data for Name: authtoken_token; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.authtoken_token (key, created, user_id) FROM stdin;
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	permission
3	auth	group
4	auth	user
5	contenttypes	contenttype
6	sessions	session
7	authtoken	token
8	smartthings	capability
9	smartthings	attribute
10	smartthings	command
11	smartthings	argument
12	smartthings	stapppermission
13	smartthings	stapp
14	smartthings	stappconfpage
15	smartthings	stappconfsection
16	smartthings	stappconfsectionsetting
17	smartthings	stappinstance
18	smartthings	device
19	smartthings	stappinstancesetting
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2018-10-12 17:32:34.302575-05
2	auth	0001_initial	2018-10-12 17:32:34.372262-05
3	admin	0001_initial	2018-10-12 17:32:34.396947-05
4	admin	0002_logentry_remove_auto_add	2018-10-12 17:32:34.420663-05
5	contenttypes	0002_remove_content_type_name	2018-10-12 17:32:34.440684-05
6	auth	0002_alter_permission_name_max_length	2018-10-12 17:32:34.452605-05
7	auth	0003_alter_user_email_max_length	2018-10-12 17:32:34.471378-05
8	auth	0004_alter_user_username_opts	2018-10-12 17:32:34.481742-05
9	auth	0005_alter_user_last_login_null	2018-10-12 17:32:34.488981-05
10	auth	0006_require_contenttypes_0002	2018-10-12 17:32:34.490884-05
11	auth	0007_alter_validators_add_error_messages	2018-10-12 17:32:34.51632-05
12	auth	0008_alter_user_username_max_length	2018-10-12 17:32:34.539485-05
13	auth	0009_alter_user_last_name_max_length	2018-10-12 17:32:34.556303-05
14	sessions	0001_initial	2018-10-12 17:32:34.564987-05
15	smartthings	0001_initial	2018-10-12 17:32:34.579268-05
16	smartthings	0002_auto_20181002_2204	2018-10-12 17:32:34.697283-05
17	smartthings	0003_auto_20181009_1243	2018-10-12 17:32:34.703585-05
18	smartthings	0004_auto_20181009_2147	2018-10-12 17:32:34.746495-05
19	smartthings	0005_auto_20181010_2103	2018-10-12 17:32:34.77915-05
20	smartthings	0006_auto_20181012_2232	2018-10-12 17:32:34.923194-05
21	authtoken	0001_initial	2018-10-12 19:06:24.017185-05
22	authtoken	0002_auto_20160226_1747	2018-10-12 19:06:24.072349-05
23	smartthings	0007_auto_20181012_2245	2018-10-15 13:45:50.383565-05
24	smartthings	0008_auto_20181012_2333	2018-10-15 13:45:50.41427-05
25	smartthings	0009_auto_20181012_2336	2018-10-15 13:45:50.445371-05
26	smartthings	0010_auto_20181016_1058	2018-10-16 16:06:53.341085-05
27	smartthings	0011_auto_20181018_1140	2018-10-18 13:27:09.852154-05
28	smartthings	0012_auto_20181018_1143	2018-10-18 13:27:09.866844-05
29	smartthings	0013_auto_20181018_1144	2018-10-18 13:27:09.883373-05
30	smartthings	0014_auto_20181019_1510	2018-10-19 10:10:51.753363-05
31	smartthings	0015_auto_20181019_1512	2018-10-19 10:12:32.201551-05
32	smartthings	0016_auto_20181019_1618	2018-10-19 11:18:52.982359-05
33	smartthings	0014_auto_20181018_2151	2018-10-19 15:06:20.253026-05
34	smartthings	0015_auto_20181018_2151	2018-10-19 15:06:20.329083-05
35	smartthings	0016_merge_20181019_1610	2018-10-19 15:06:20.331034-05
36	smartthings	0017_merge_20181019_2006	2018-10-19 15:06:20.333053-05
37	smartthings	0018_auto_20181022_2032	2018-10-22 15:37:34.619786-05
38	smartthings	0019_auto_20181022_2032	2018-10-22 15:37:34.639731-05
39	smartthings	0020_auto_20181022_2034	2018-10-22 15:37:34.665539-05
40	smartthings	0021_auto_20181022_2037	2018-10-22 15:37:34.693776-05
41	smartthings	0022_auto_20181022_2039	2018-10-22 15:39:25.647534-05
42	smartthings	0023_stapp_proj_endpoint	2018-10-29 13:46:05.190142-05
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
f2mlc9701qmpoac2tcul3k8m3ukcv7gd	ZDFjM2I4MGIyNGYyZjQ2YWM4ZDAwMTY0NzY1OWI5Y2E4YzMxZjFkNzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2YjMzY2YxMmQ0ODViNWY5ODFhYTg3ZGM2Yzg3MjE4YzU5MGRjMzE2In0=	2018-11-05 14:48:39.094388-06
6qwt5ah3se58v4lyznkd9khwzrqwo8ll	ZDFjM2I4MGIyNGYyZjQ2YWM4ZDAwMTY0NzY1OWI5Y2E4YzMxZjFkNzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2YjMzY2YxMmQ0ODViNWY5ODFhYTg3ZGM2Yzg3MjE4YzU5MGRjMzE2In0=	2018-12-03 12:44:02.910398-06
\.


--
-- Data for Name: smartthings_argument; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.smartthings_argument (id, name, command_id, data_type, required) FROM stdin;
1	volume	1	NUMBER	t
2	color	4	COLOR_MAP	t
3	hue	5	NUMBER	t
4	saturation	6	NUMBER	t
5	state	7	ENUM	t
6	mode	8	ENUM	t
7	speed	9	NUMBER	t
8	mode	10	ENUM	t
9	shuffle	11	ENUM	t
10	state	14	ENUM	t
11	setpoint	16	NUMBER	t
12	mode	17	ENUM	t
13	mode	18	ENUM	t
14	level	19	NUMBER	t
15	rate	19	NUMBER	f
16	mode	23	ENUM	t
17	mode	29	ENUM	t
18	channel	30	STRING	t
19	mode	33	ENUM	t
\.


--
-- Data for Name: smartthings_attribute; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.smartthings_attribute (id, name, value, capability_id, data_type, required) FROM stdin;
1	acceleration	\N	1	ENUM	t
2	airQuality	\N	2	NUMBER	t
3	volume	\N	3	NUMBER	t
4	button	\N	4	ENUM	t
5	numberOfButtons	\N	4	NUMBER	t
6	supportedButtonValues	\N	4	JSON_OBJECT	t
7	color	\N	5	STRING	t
8	hue	\N	5	NUMBER	t
9	saturation	\N	5	NUMBER	t
10	contact	\N	6	ENUM	t
11	machineState	\N	7	ENUM	t
12	supportedMachineStates	\N	7	JSON_OBJECT	t
13	dishwasherJobState	\N	7	ENUM	t
14	completionTime	\N	7	DATE	t
15	dryerMode	\N	8	ENUM	t
16	fineDustLevel	\N	9	NUMBER	t
17	dustLevel	\N	9	NUMBER	t
18	fanSpeed	\N	10	NUMBER	t
19	illuminance	\N	11	NUMBER	t
20	inputSource	\N	12	ENUM	t
21	supportedInputSources	\N	12	JSON_OBJECT	t
22	playbackShuffle	\N	13	ENUM	t
23	disabledTrackControlCommands	\N	14	JSON_OBJECT	t
24	odorLevel	\N	15	NUMBER	t
25	machineState	\N	16	ENUM	t
26	supportedMachineStates	\N	16	JSON_OBJECT	t
27	ovenJobState	\N	16	ENUM	t
28	completionTime	\N	16	DATE	t
29	operationTime	\N	16	NUMBER	t
30	progress	\N	16	NUMBER	t
31	power	\N	17	NUMBER	t
32	presence	\N	18	ENUM	t
33	refrigerationSetpoint	\N	19	NUMBER	t
34	robotCleanerCleaningMode	\N	20	ENUM	t
35	robotCleanerTurboMode	\N	21	ENUM	t
36	smoke	\N	22	ENUM	t
37	level	\N	23	NUMBER	t
38	temperature	\N	24	NUMBER	t
39	thermostatFanMode	\N	25	ENUM	t
40	supportedThermostatFanModes	\N	25	JSON_OBJECT	t
41	thermostatMode	\N	26	ENUM	t
42	supportedThermostatModes	\N	26	JSON_OBJECT	t
43	thermostatSetpoint	\N	27	NUMBER	t
44	tvChannel	\N	28	STRING	t
45	washerMode	\N	29	ENUM	t
46	water	\N	30	ENUM	t
\.


--
-- Data for Name: smartthings_capability; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.smartthings_capability (id, name, st_id) FROM stdin;
1	Acceleration Sensor	accelerationSensor
2	Air Quality Sensor	airQualitySensor
3	Audio Volume	audioVolume
4	Button	button
5	Color Control	colorControl
6	Contact Sensor	contactSensor
7	Dishwasher Operating State	dishwasherOperatingState
8	Dryer Mode	dryerMode
9	Dust Sensor	dustSensor
10	Fan Speed	fanSpeed
11	Illuminance Measurement	illuminanceMeasurement
12	Media Input Source	mediaInputSource
13	Media Playback Shuffle	mediaPlaybackShuffle
14	Media Track Control	mediaTrackControl
15	Odor Sensor	odorSensor
16	Oven Operating State	ovenOperatingState
17	Power Meter	powerMeter
18	Presence Sensor	presenceSensor
19	Refrigeration Setpoint	refrigerationSetpoint
20	Robot Cleaner Cleaning Mode	robotCleanerCleaningMode
21	Robot Cleaner Turbo Mode	robotCleanerTurboMode
22	Smoke Detector	smokeDetector
23	Switch Level	switchLevel
24	Temperature Measurement	temperatureMeasurement
25	Thermostat Fan Mode	thermostatFanMode
26	Thermostat Mode	thermostatMode
27	Thermostat Setpoint	thermostatSetpoint
28	Tv Channel	tvChannel
29	Washer Mode	washerMode
30	Water Sensor	waterSensor
\.


--
-- Data for Name: smartthings_command; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.smartthings_command (id, name, capability_id) FROM stdin;
1	setVolume	3
2	volumeUp	3
3	volumeDown	3
4	setColor	5
5	setHue	5
6	setSaturation	5
7	setMachineState	7
8	setDryerMode	8
9	setFanSpeed	10
10	setInputSource	12
11	setPlaybackShuffle	13
12	nextTrack	14
13	previousTrack	14
14	setMachineState	16
15	stop	16
16	setRefrigerationSetpoint	19
17	setRobotCleanerCleaningMode	20
18	setRobotCleanerTurboMode	21
19	setLevel	23
20	fanAuto	25
21	fanCirculate	25
22	fanOn	25
23	setThermostatFanMode	25
24	auto	26
25	cool	26
26	emergencyHeat	26
27	heat	26
28	off	26
29	setThermostatMode	26
30	setTvChannel	28
31	channelUp	28
32	channelDown	28
33	setWasherMode	29
\.


--
-- Data for Name: smartthings_device; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.smartthings_device (id, st_device_id, proj_device_id, component_id) FROM stdin;
2	LetThereBeLight_plz	4	main
3	e457978e-5e37-43e6-979d-18112e12c961	-1	main
4	74aac3bb-91f2-4a88-8c49-ae5e0a234d76	-1	main
\.


--
-- Data for Name: smartthings_device_capabilities; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.smartthings_device_capabilities (id, device_id, capability_id) FROM stdin;
3	2	11
4	2	4
\.


--
-- Data for Name: smartthings_stapp; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.smartthings_stapp (id, app_id, description, name, client_id, client_secret, proj_endpoint) FROM stdin;
1	ifttt	For accurately conveying user intention to IoT devices	superifttt	something_like_an_id	something_else_like_a_secret	\N
2	test_app_2	This is a test app.	Test App 2	\N	\N	\N
4	test_app_3	This is the test app v3.	Test App 3	client_id_for_test_app_3	client_secret_for_test_app_3	http://localhost:8000/st/update/
\.


--
-- Data for Name: smartthings_stapp_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.smartthings_stapp_permissions (id, stapp_id, stapppermission_id) FROM stdin;
8	2	15
9	2	6
12	4	15
13	4	6
\.


--
-- Data for Name: smartthings_stappconfpage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.smartthings_stappconfpage (id, "pageId", name, "nextPageId", "previousPageId", complete, st_app_id) FROM stdin;
1	Page0	superifttt_page	Page1	Page-1	f	1
2	test_app_2_page_1	page1	test_app_2_page_2	\N	f	2
3	test_app_2_page_2	page2	\N	test_app_2_page_1	t	2
6	test_app_3_page_1	page1	test_app_3_page_2	\N	f	4
7	test_app_3_page_2	page2	\N	test_app_3_page_1	t	4
\.


--
-- Data for Name: smartthings_stappconfsection; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.smartthings_stappconfsection (id, name, page_id, st_app_id) FROM stdin;
1	2018_symposium_for_superifttt_scholars	1	
2	section1	2	test_app_2
3	section2	2	test_app_2
4	section3	3	test_app_2
5	section4	3	test_app_2
10	section1	6	test_app_3
11	section2	6	test_app_3
12	section3	7	test_app_3
13	section4	7	test_app_3
\.


--
-- Data for Name: smartthings_stappconfsectionsetting; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.smartthings_stappconfsectionsetting (id, setting_id, name, description, setting_type, required, multiple, section_id, st_app_id) FROM stdin;
1	set_me_freeeeeee	2018_symposium_for_superifttt_scholars_super_section_settings	The super section of the 2018 Symposium for SuperIFTTT scholars; IFTTT section coming soon.	made-up	f	f	1	
2	setting1	Setting 1	This is setting 1 for app 2.	DEVICE	t	f	2	test_app_2
3	setting2	Setting 2	This is setting 2 for app 2.	DEVICE	t	f	3	test_app_2
4	setting3	Setting 3	This is setting 3 for app 2.	DEVICE	t	f	4	test_app_2
5	setting4	Setting 4	This is setting 4 for app 2.	DEVICE	t	f	5	test_app_2
10	setting1	Setting 1	This is setting 1 for app 3.	DEVICE	t	f	10	test_app_3
11	setting2	Setting 2	This is setting 2 for app 3.	DEVICE	t	f	11	test_app_3
12	setting3	Setting 3	This is setting 3 for app 3.	DEVICE	t	f	12	test_app_3
13	setting4	Setting 4	This is setting 4 for app 3.	DEVICE	t	f	13	test_app_3
\.


--
-- Data for Name: smartthings_stappconfsectionsetting_capabilities; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.smartthings_stappconfsectionsetting_capabilities (id, stappconfsectionsetting_id, capability_id) FROM stdin;
7	1	5
8	2	1
9	3	30
10	4	1
11	5	30
16	10	1
17	11	30
18	12	1
19	13	30
\.


--
-- Data for Name: smartthings_stappconfsectionsetting_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.smartthings_stappconfsectionsetting_permissions (id, stappconfsectionsetting_id, stapppermission_id) FROM stdin;
7	1	3
8	2	12
9	3	12
10	4	12
11	5	12
16	10	12
17	11	12
18	12	12
19	13	12
\.


--
-- Data for Name: smartthings_stappinstance; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.smartthings_stappinstance (id, st_installed_app_id, refresh_token, st_app_id, location_id) FROM stdin;
3	superifttt_id	I_am_a_refresh_token.Hear_me_moo	1	where_o_where_am_I
4	d692699d-e7a6-400d-a0b7-d5be96e7a564	string	2	e675a3d9-2499-406c-86dc-8a492a886494
\.


--
-- Data for Name: smartthings_stappinstancesetting; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.smartthings_stappinstancesetting (id, device_id, setting_id, st_app_instance_id) FROM stdin;
1	2	1	3
2	3	2	4
3	4	3	4
\.


--
-- Data for Name: smartthings_stapppermission; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.smartthings_stapppermission (id, scope) FROM stdin;
1	r:installedapps:*
2	l:installedapps
3	w:installedapps:*
4	r:apps:*
5	w:apps:*
6	l:devices
7	r:devices:*
8	w:devices:*
9	x:devices:*
10	r:deviceprofiles:*
11	w:deviceprofiles:*
12	i:deviceprofiles:*
13	l:scenes
14	x:scenes:*
15	r:schedules
16	w:schedules
17	l:locations
18	r:locations:*
19	w:locations:*
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 57, true);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 1, true);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1, true);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 19, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 42, true);


--
-- Name: smartthings_argument_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.smartthings_argument_id_seq', 19, true);


--
-- Name: smartthings_attribute_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.smartthings_attribute_id_seq', 46, true);


--
-- Name: smartthings_capability_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.smartthings_capability_id_seq', 30, true);


--
-- Name: smartthings_command_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.smartthings_command_id_seq', 33, true);


--
-- Name: smartthings_device_capabilities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.smartthings_device_capabilities_id_seq', 4, true);


--
-- Name: smartthings_device_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.smartthings_device_id_seq', 4, true);


--
-- Name: smartthings_stapp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.smartthings_stapp_id_seq', 4, true);


--
-- Name: smartthings_stapp_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.smartthings_stapp_permissions_id_seq', 13, true);


--
-- Name: smartthings_stappconfpage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.smartthings_stappconfpage_id_seq', 7, true);


--
-- Name: smartthings_stappconfsection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.smartthings_stappconfsection_id_seq', 13, true);


--
-- Name: smartthings_stappconfsectionsetting_capabilities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.smartthings_stappconfsectionsetting_capabilities_id_seq', 19, true);


--
-- Name: smartthings_stappconfsectionsetting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.smartthings_stappconfsectionsetting_id_seq', 13, true);


--
-- Name: smartthings_stappconfsectionsetting_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.smartthings_stappconfsectionsetting_permissions_id_seq', 19, true);


--
-- Name: smartthings_stappinstance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.smartthings_stappinstance_id_seq', 4, true);


--
-- Name: smartthings_stappinstancesettingdevice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.smartthings_stappinstancesettingdevice_id_seq', 3, true);


--
-- Name: smartthings_stapppermission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.smartthings_stapppermission_id_seq', 19, true);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: authtoken_token authtoken_token_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authtoken_token
    ADD CONSTRAINT authtoken_token_pkey PRIMARY KEY (key);


--
-- Name: authtoken_token authtoken_token_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authtoken_token
    ADD CONSTRAINT authtoken_token_user_id_key UNIQUE (user_id);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: smartthings_argument smartthings_argument_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_argument
    ADD CONSTRAINT smartthings_argument_pkey PRIMARY KEY (id);


--
-- Name: smartthings_attribute smartthings_attribute_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_attribute
    ADD CONSTRAINT smartthings_attribute_pkey PRIMARY KEY (id);


--
-- Name: smartthings_capability smartthings_capability_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_capability
    ADD CONSTRAINT smartthings_capability_pkey PRIMARY KEY (id);


--
-- Name: smartthings_command smartthings_command_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_command
    ADD CONSTRAINT smartthings_command_pkey PRIMARY KEY (id);


--
-- Name: smartthings_device_capabilities smartthings_device_capab_device_id_capability_id_0805a857_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_device_capabilities
    ADD CONSTRAINT smartthings_device_capab_device_id_capability_id_0805a857_uniq UNIQUE (device_id, capability_id);


--
-- Name: smartthings_device_capabilities smartthings_device_capabilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_device_capabilities
    ADD CONSTRAINT smartthings_device_capabilities_pkey PRIMARY KEY (id);


--
-- Name: smartthings_device smartthings_device_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_device
    ADD CONSTRAINT smartthings_device_pkey PRIMARY KEY (id);


--
-- Name: smartthings_stapp smartthings_stapp_app_id_071752e9_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stapp
    ADD CONSTRAINT smartthings_stapp_app_id_071752e9_uniq UNIQUE (app_id);


--
-- Name: smartthings_stapp smartthings_stapp_client_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stapp
    ADD CONSTRAINT smartthings_stapp_client_id_key UNIQUE (client_id);


--
-- Name: smartthings_stapp smartthings_stapp_client_secrete_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stapp
    ADD CONSTRAINT smartthings_stapp_client_secrete_key UNIQUE (client_secret);


--
-- Name: smartthings_stapp_permissions smartthings_stapp_permis_stapp_id_stapppermission_d4426249_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stapp_permissions
    ADD CONSTRAINT smartthings_stapp_permis_stapp_id_stapppermission_d4426249_uniq UNIQUE (stapp_id, stapppermission_id);


--
-- Name: smartthings_stapp_permissions smartthings_stapp_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stapp_permissions
    ADD CONSTRAINT smartthings_stapp_permissions_pkey PRIMARY KEY (id);


--
-- Name: smartthings_stapp smartthings_stapp_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stapp
    ADD CONSTRAINT smartthings_stapp_pkey PRIMARY KEY (id);


--
-- Name: smartthings_stappconfpage smartthings_stappconfpage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stappconfpage
    ADD CONSTRAINT smartthings_stappconfpage_pkey PRIMARY KEY (id);


--
-- Name: smartthings_stappconfsectionsetting_capabilities smartthings_stappconfsec_stappconfsectionsetting__c2659368_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stappconfsectionsetting_capabilities
    ADD CONSTRAINT smartthings_stappconfsec_stappconfsectionsetting__c2659368_uniq UNIQUE (stappconfsectionsetting_id, capability_id);


--
-- Name: smartthings_stappconfsectionsetting_permissions smartthings_stappconfsec_stappconfsectionsetting__e1e9b351_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stappconfsectionsetting_permissions
    ADD CONSTRAINT smartthings_stappconfsec_stappconfsectionsetting__e1e9b351_uniq UNIQUE (stappconfsectionsetting_id, stapppermission_id);


--
-- Name: smartthings_stappconfsection smartthings_stappconfsection_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stappconfsection
    ADD CONSTRAINT smartthings_stappconfsection_pkey PRIMARY KEY (id);


--
-- Name: smartthings_stappconfsectionsetting_capabilities smartthings_stappconfsectionsetting_capabilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stappconfsectionsetting_capabilities
    ADD CONSTRAINT smartthings_stappconfsectionsetting_capabilities_pkey PRIMARY KEY (id);


--
-- Name: smartthings_stappconfsectionsetting_permissions smartthings_stappconfsectionsetting_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stappconfsectionsetting_permissions
    ADD CONSTRAINT smartthings_stappconfsectionsetting_permissions_pkey PRIMARY KEY (id);


--
-- Name: smartthings_stappconfsectionsetting smartthings_stappconfsectionsetting_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stappconfsectionsetting
    ADD CONSTRAINT smartthings_stappconfsectionsetting_pkey PRIMARY KEY (id);


--
-- Name: smartthings_stappinstance smartthings_stappinstance_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stappinstance
    ADD CONSTRAINT smartthings_stappinstance_pkey PRIMARY KEY (id);


--
-- Name: smartthings_stappinstance smartthings_stappinstance_st_installed_app_id_d0e19e8f_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stappinstance
    ADD CONSTRAINT smartthings_stappinstance_st_installed_app_id_d0e19e8f_uniq UNIQUE (st_installed_app_id);


--
-- Name: smartthings_stappinstancesetting smartthings_stappinstancesettingdevice_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stappinstancesetting
    ADD CONSTRAINT smartthings_stappinstancesettingdevice_pkey PRIMARY KEY (id);


--
-- Name: smartthings_stapppermission smartthings_stapppermission_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stapppermission
    ADD CONSTRAINT smartthings_stapppermission_pkey PRIMARY KEY (id);


--
-- Name: smartthings_stapppermission smartthings_stapppermission_scope_2ad8c94a_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stapppermission
    ADD CONSTRAINT smartthings_stapppermission_scope_2ad8c94a_uniq UNIQUE (scope);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- Name: authtoken_token_key_10f0b77e_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX authtoken_token_key_10f0b77e_like ON public.authtoken_token USING btree (key varchar_pattern_ops);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: smartthings_argument_command_id_84b91bfa; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX smartthings_argument_command_id_84b91bfa ON public.smartthings_argument USING btree (command_id);


--
-- Name: smartthings_attribute_capability_id_5b7e29b7; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX smartthings_attribute_capability_id_5b7e29b7 ON public.smartthings_attribute USING btree (capability_id);


--
-- Name: smartthings_command_capability_id_e44700be; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX smartthings_command_capability_id_e44700be ON public.smartthings_command USING btree (capability_id);


--
-- Name: smartthings_device_capabilities_capability_id_51a76067; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX smartthings_device_capabilities_capability_id_51a76067 ON public.smartthings_device_capabilities USING btree (capability_id);


--
-- Name: smartthings_device_capabilities_device_id_9a2182e8; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX smartthings_device_capabilities_device_id_9a2182e8 ON public.smartthings_device_capabilities USING btree (device_id);


--
-- Name: smartthings_stapp_app_id_071752e9_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX smartthings_stapp_app_id_071752e9_like ON public.smartthings_stapp USING btree (app_id varchar_pattern_ops);


--
-- Name: smartthings_stapp_client_id_e2ff6bc4_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX smartthings_stapp_client_id_e2ff6bc4_like ON public.smartthings_stapp USING btree (client_id varchar_pattern_ops);


--
-- Name: smartthings_stapp_client_secrete_f84b561f_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX smartthings_stapp_client_secrete_f84b561f_like ON public.smartthings_stapp USING btree (client_secret varchar_pattern_ops);


--
-- Name: smartthings_stapp_permissions_stapp_id_f2db5303; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX smartthings_stapp_permissions_stapp_id_f2db5303 ON public.smartthings_stapp_permissions USING btree (stapp_id);


--
-- Name: smartthings_stapp_permissions_stapppermission_id_5d8e1958; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX smartthings_stapp_permissions_stapppermission_id_5d8e1958 ON public.smartthings_stapp_permissions USING btree (stapppermission_id);


--
-- Name: smartthings_stappconfpage_st_app_id_2c8696bf; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX smartthings_stappconfpage_st_app_id_2c8696bf ON public.smartthings_stappconfpage USING btree (st_app_id);


--
-- Name: smartthings_stappconfsecti_capability_id_fe9ec9d6; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX smartthings_stappconfsecti_capability_id_fe9ec9d6 ON public.smartthings_stappconfsectionsetting_capabilities USING btree (capability_id);


--
-- Name: smartthings_stappconfsecti_stappconfsectionsetting_id_6dfcbb7d; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX smartthings_stappconfsecti_stappconfsectionsetting_id_6dfcbb7d ON public.smartthings_stappconfsectionsetting_capabilities USING btree (stappconfsectionsetting_id);


--
-- Name: smartthings_stappconfsecti_stappconfsectionsetting_id_fe5d75ca; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX smartthings_stappconfsecti_stappconfsectionsetting_id_fe5d75ca ON public.smartthings_stappconfsectionsetting_permissions USING btree (stappconfsectionsetting_id);


--
-- Name: smartthings_stappconfsecti_stapppermission_id_ec01da66; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX smartthings_stappconfsecti_stapppermission_id_ec01da66 ON public.smartthings_stappconfsectionsetting_permissions USING btree (stapppermission_id);


--
-- Name: smartthings_stappconfsection_page_id_ec0a7e42; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX smartthings_stappconfsection_page_id_ec0a7e42 ON public.smartthings_stappconfsection USING btree (page_id);


--
-- Name: smartthings_stappconfsectionsetting_section_id_51621667; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX smartthings_stappconfsectionsetting_section_id_51621667 ON public.smartthings_stappconfsectionsetting USING btree (section_id);


--
-- Name: smartthings_stappinstance_st_app_id_0362bff0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX smartthings_stappinstance_st_app_id_0362bff0 ON public.smartthings_stappinstance USING btree (st_app_id);


--
-- Name: smartthings_stappinstance_st_installed_app_id_d0e19e8f_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX smartthings_stappinstance_st_installed_app_id_d0e19e8f_like ON public.smartthings_stappinstance USING btree (st_installed_app_id varchar_pattern_ops);


--
-- Name: smartthings_stappinstances_st_app_instance_id_c7191bca; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX smartthings_stappinstances_st_app_instance_id_c7191bca ON public.smartthings_stappinstancesetting USING btree (st_app_instance_id);


--
-- Name: smartthings_stappinstancesettingdevice_device_id_3016a3d5; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX smartthings_stappinstancesettingdevice_device_id_3016a3d5 ON public.smartthings_stappinstancesetting USING btree (device_id);


--
-- Name: smartthings_stappinstancesettingdevice_setting_id_437a9874; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX smartthings_stappinstancesettingdevice_setting_id_437a9874 ON public.smartthings_stappinstancesetting USING btree (setting_id);


--
-- Name: smartthings_stapppermission_scope_2ad8c94a_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX smartthings_stapppermission_scope_2ad8c94a_like ON public.smartthings_stapppermission USING btree (scope varchar_pattern_ops);


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: authtoken_token authtoken_token_user_id_35299eff_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authtoken_token
    ADD CONSTRAINT authtoken_token_user_id_35299eff_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: smartthings_argument smartthings_argument_command_id_84b91bfa_fk_smartthin; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_argument
    ADD CONSTRAINT smartthings_argument_command_id_84b91bfa_fk_smartthin FOREIGN KEY (command_id) REFERENCES public.smartthings_command(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: smartthings_attribute smartthings_attribut_capability_id_5b7e29b7_fk_smartthin; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_attribute
    ADD CONSTRAINT smartthings_attribut_capability_id_5b7e29b7_fk_smartthin FOREIGN KEY (capability_id) REFERENCES public.smartthings_capability(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: smartthings_command smartthings_command_capability_id_e44700be_fk_smartthin; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_command
    ADD CONSTRAINT smartthings_command_capability_id_e44700be_fk_smartthin FOREIGN KEY (capability_id) REFERENCES public.smartthings_capability(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: smartthings_device_capabilities smartthings_device_c_capability_id_51a76067_fk_smartthin; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_device_capabilities
    ADD CONSTRAINT smartthings_device_c_capability_id_51a76067_fk_smartthin FOREIGN KEY (capability_id) REFERENCES public.smartthings_capability(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: smartthings_device_capabilities smartthings_device_c_device_id_9a2182e8_fk_smartthin; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_device_capabilities
    ADD CONSTRAINT smartthings_device_c_device_id_9a2182e8_fk_smartthin FOREIGN KEY (device_id) REFERENCES public.smartthings_device(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: smartthings_stapp_permissions smartthings_stapp_pe_stapp_id_f2db5303_fk_smartthin; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stapp_permissions
    ADD CONSTRAINT smartthings_stapp_pe_stapp_id_f2db5303_fk_smartthin FOREIGN KEY (stapp_id) REFERENCES public.smartthings_stapp(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: smartthings_stapp_permissions smartthings_stapp_pe_stapppermission_id_5d8e1958_fk_smartthin; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stapp_permissions
    ADD CONSTRAINT smartthings_stapp_pe_stapppermission_id_5d8e1958_fk_smartthin FOREIGN KEY (stapppermission_id) REFERENCES public.smartthings_stapppermission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: smartthings_stappconfsectionsetting_capabilities smartthings_stappcon_capability_id_fe9ec9d6_fk_smartthin; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stappconfsectionsetting_capabilities
    ADD CONSTRAINT smartthings_stappcon_capability_id_fe9ec9d6_fk_smartthin FOREIGN KEY (capability_id) REFERENCES public.smartthings_capability(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: smartthings_stappconfsection smartthings_stappcon_page_id_ec0a7e42_fk_smartthin; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stappconfsection
    ADD CONSTRAINT smartthings_stappcon_page_id_ec0a7e42_fk_smartthin FOREIGN KEY (page_id) REFERENCES public.smartthings_stappconfpage(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: smartthings_stappconfsectionsetting smartthings_stappcon_section_id_51621667_fk_smartthin; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stappconfsectionsetting
    ADD CONSTRAINT smartthings_stappcon_section_id_51621667_fk_smartthin FOREIGN KEY (section_id) REFERENCES public.smartthings_stappconfsection(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: smartthings_stappconfpage smartthings_stappcon_st_app_id_2c8696bf_fk_smartthin; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stappconfpage
    ADD CONSTRAINT smartthings_stappcon_st_app_id_2c8696bf_fk_smartthin FOREIGN KEY (st_app_id) REFERENCES public.smartthings_stapp(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: smartthings_stappconfsectionsetting_capabilities smartthings_stappcon_stappconfsectionsett_6dfcbb7d_fk_smartthin; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stappconfsectionsetting_capabilities
    ADD CONSTRAINT smartthings_stappcon_stappconfsectionsett_6dfcbb7d_fk_smartthin FOREIGN KEY (stappconfsectionsetting_id) REFERENCES public.smartthings_stappconfsectionsetting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: smartthings_stappconfsectionsetting_permissions smartthings_stappcon_stappconfsectionsett_fe5d75ca_fk_smartthin; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stappconfsectionsetting_permissions
    ADD CONSTRAINT smartthings_stappcon_stappconfsectionsett_fe5d75ca_fk_smartthin FOREIGN KEY (stappconfsectionsetting_id) REFERENCES public.smartthings_stappconfsectionsetting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: smartthings_stappconfsectionsetting_permissions smartthings_stappcon_stapppermission_id_ec01da66_fk_smartthin; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stappconfsectionsetting_permissions
    ADD CONSTRAINT smartthings_stappcon_stapppermission_id_ec01da66_fk_smartthin FOREIGN KEY (stapppermission_id) REFERENCES public.smartthings_stapppermission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: smartthings_stappinstancesetting smartthings_stappins_device_id_3016a3d5_fk_smartthin; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stappinstancesetting
    ADD CONSTRAINT smartthings_stappins_device_id_3016a3d5_fk_smartthin FOREIGN KEY (device_id) REFERENCES public.smartthings_device(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: smartthings_stappinstancesetting smartthings_stappins_setting_id_437a9874_fk_smartthin; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stappinstancesetting
    ADD CONSTRAINT smartthings_stappins_setting_id_437a9874_fk_smartthin FOREIGN KEY (setting_id) REFERENCES public.smartthings_stappconfsectionsetting(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: smartthings_stappinstance smartthings_stappins_st_app_id_0362bff0_fk_smartthin; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stappinstance
    ADD CONSTRAINT smartthings_stappins_st_app_id_0362bff0_fk_smartthin FOREIGN KEY (st_app_id) REFERENCES public.smartthings_stapp(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: smartthings_stappinstancesetting smartthings_stappins_st_app_instance_id_1833f622_fk_smartthin; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartthings_stappinstancesetting
    ADD CONSTRAINT smartthings_stappins_st_app_instance_id_1833f622_fk_smartthin FOREIGN KEY (st_app_instance_id) REFERENCES public.smartthings_stappinstance(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

