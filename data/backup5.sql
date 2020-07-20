--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.17
-- Dumped by pg_dump version 9.5.17

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO iftttuser;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO iftttuser;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO iftttuser;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO iftttuser;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO iftttuser;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO iftttuser;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: iftttuser
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


ALTER TABLE public.auth_user OWNER TO iftttuser;

--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO iftttuser;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_groups_id_seq OWNER TO iftttuser;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.auth_user_groups_id_seq OWNED BY public.auth_user_groups.id;


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_id_seq OWNER TO iftttuser;

--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.auth_user_id_seq OWNED BY public.auth_user.id;


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO iftttuser;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_user_permissions_id_seq OWNER TO iftttuser;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.auth_user_user_permissions_id_seq OWNED BY public.auth_user_user_permissions.id;


--
-- Name: backend_action; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_action (
    id integer NOT NULL,
    text text,
    cap_id integer NOT NULL,
    chan_id integer,
    dev_id integer NOT NULL
);


ALTER TABLE public.backend_action OWNER TO iftttuser;

--
-- Name: backend_action_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_action_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_action_id_seq OWNER TO iftttuser;

--
-- Name: backend_action_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_action_id_seq OWNED BY public.backend_action.id;


--
-- Name: backend_actioncondition; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_actioncondition (
    id integer NOT NULL,
    val text NOT NULL,
    action_id integer NOT NULL,
    par_id integer NOT NULL
);


ALTER TABLE public.backend_actioncondition OWNER TO iftttuser;

--
-- Name: backend_actioncondition_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_actioncondition_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_actioncondition_id_seq OWNER TO iftttuser;

--
-- Name: backend_actioncondition_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_actioncondition_id_seq OWNED BY public.backend_actioncondition.id;


--
-- Name: backend_actionparval; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_actionparval (
    id integer NOT NULL,
    val text NOT NULL,
    par_id integer NOT NULL,
    state_id integer NOT NULL
);


ALTER TABLE public.backend_actionparval OWNER TO iftttuser;

--
-- Name: backend_actionparval_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_actionparval_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_actionparval_id_seq OWNER TO iftttuser;

--
-- Name: backend_actionparval_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_actionparval_id_seq OWNED BY public.backend_actionparval.id;


--
-- Name: backend_binparam; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_binparam (
    parameter_ptr_id integer NOT NULL,
    tval text NOT NULL,
    fval text NOT NULL
);


ALTER TABLE public.backend_binparam OWNER TO iftttuser;

--
-- Name: backend_capability; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_capability (
    id integer NOT NULL,
    name character varying(30) NOT NULL,
    readable boolean NOT NULL,
    writeable boolean NOT NULL,
    statelabel text,
    commandlabel text,
    eventlabel text,
    commandname text
);


ALTER TABLE public.backend_capability OWNER TO iftttuser;

--
-- Name: backend_capability_channels; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_capability_channels (
    id integer NOT NULL,
    capability_id integer NOT NULL,
    channel_id integer NOT NULL
);


ALTER TABLE public.backend_capability_channels OWNER TO iftttuser;

--
-- Name: backend_capability_channels_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_capability_channels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_capability_channels_id_seq OWNER TO iftttuser;

--
-- Name: backend_capability_channels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_capability_channels_id_seq OWNED BY public.backend_capability_channels.id;


--
-- Name: backend_capability_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_capability_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_capability_id_seq OWNER TO iftttuser;

--
-- Name: backend_capability_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_capability_id_seq OWNED BY public.backend_capability.id;


--
-- Name: backend_channel; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_channel (
    id integer NOT NULL,
    name character varying(30) NOT NULL,
    icon text
);


ALTER TABLE public.backend_channel OWNER TO iftttuser;

--
-- Name: backend_channel_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_channel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_channel_id_seq OWNER TO iftttuser;

--
-- Name: backend_channel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_channel_id_seq OWNED BY public.backend_channel.id;


--
-- Name: backend_colorparam; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_colorparam (
    parameter_ptr_id integer NOT NULL,
    mode text NOT NULL
);


ALTER TABLE public.backend_colorparam OWNER TO iftttuser;

--
-- Name: backend_condition; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_condition (
    id integer NOT NULL,
    val text NOT NULL,
    comp text NOT NULL,
    par_id integer NOT NULL,
    trigger_id integer NOT NULL
);


ALTER TABLE public.backend_condition OWNER TO iftttuser;

--
-- Name: backend_condition_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_condition_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_condition_id_seq OWNER TO iftttuser;

--
-- Name: backend_condition_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_condition_id_seq OWNED BY public.backend_condition.id;


--
-- Name: backend_device; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_device (
    id integer NOT NULL,
    public boolean NOT NULL,
    dev_type text NOT NULL,
    name character varying(128) NOT NULL,
    icon text,
    location_id integer,
    is_subscribed boolean NOT NULL,
    label character varying(256) NOT NULL
);


ALTER TABLE public.backend_device OWNER TO iftttuser;

--
-- Name: backend_device_caps; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_device_caps (
    id integer NOT NULL,
    device_id integer NOT NULL,
    capability_id integer NOT NULL
);


ALTER TABLE public.backend_device_caps OWNER TO iftttuser;

--
-- Name: backend_device_caps_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_device_caps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_device_caps_id_seq OWNER TO iftttuser;

--
-- Name: backend_device_caps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_device_caps_id_seq OWNED BY public.backend_device_caps.id;


--
-- Name: backend_device_chans; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_device_chans (
    id integer NOT NULL,
    device_id integer NOT NULL,
    channel_id integer NOT NULL
);


ALTER TABLE public.backend_device_chans OWNER TO iftttuser;

--
-- Name: backend_device_chans_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_device_chans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_device_chans_id_seq OWNER TO iftttuser;

--
-- Name: backend_device_chans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_device_chans_id_seq OWNED BY public.backend_device_chans.id;


--
-- Name: backend_device_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_device_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_device_id_seq OWNER TO iftttuser;

--
-- Name: backend_device_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_device_id_seq OWNED BY public.backend_device.id;


--
-- Name: backend_device_users; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_device_users (
    id integer NOT NULL,
    device_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.backend_device_users OWNER TO iftttuser;

--
-- Name: backend_device_users_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_device_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_device_users_id_seq OWNER TO iftttuser;

--
-- Name: backend_device_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_device_users_id_seq OWNED BY public.backend_device_users.id;


--
-- Name: backend_durationparam; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_durationparam (
    parameter_ptr_id integer NOT NULL,
    comp boolean NOT NULL,
    maxhours integer,
    maxmins integer,
    maxsecs integer
);


ALTER TABLE public.backend_durationparam OWNER TO iftttuser;

--
-- Name: backend_errorlog; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_errorlog (
    id integer NOT NULL,
    function character varying(64),
    err text,
    created timestamp with time zone
);


ALTER TABLE public.backend_errorlog OWNER TO iftttuser;

--
-- Name: backend_errorlog_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_errorlog_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_errorlog_id_seq OWNER TO iftttuser;

--
-- Name: backend_errorlog_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_errorlog_id_seq OWNED BY public.backend_errorlog.id;


--
-- Name: backend_esrule; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_esrule (
    rule_ptr_id integer NOT NULL,
    "Etrigger_id" integer NOT NULL,
    action_id integer NOT NULL
);


ALTER TABLE public.backend_esrule OWNER TO iftttuser;

--
-- Name: backend_esrule_Striggers; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public."backend_esrule_Striggers" (
    id integer NOT NULL,
    esrule_id integer NOT NULL,
    trigger_id integer NOT NULL
);


ALTER TABLE public."backend_esrule_Striggers" OWNER TO iftttuser;

--
-- Name: backend_esrule_Striggers_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public."backend_esrule_Striggers_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."backend_esrule_Striggers_id_seq" OWNER TO iftttuser;

--
-- Name: backend_esrule_Striggers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public."backend_esrule_Striggers_id_seq" OWNED BY public."backend_esrule_Striggers".id;


--
-- Name: backend_inputparam; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_inputparam (
    parameter_ptr_id integer NOT NULL,
    inputtype text NOT NULL
);


ALTER TABLE public.backend_inputparam OWNER TO iftttuser;

--
-- Name: backend_location; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_location (
    id integer NOT NULL,
    st_loc_id character varying(40) NOT NULL,
    name character varying(256) NOT NULL,
    st_installed_app_id character varying(40) NOT NULL,
    lat double precision,
    lon double precision
);


ALTER TABLE public.backend_location OWNER TO iftttuser;

--
-- Name: backend_location_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_location_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_location_id_seq OWNER TO iftttuser;

--
-- Name: backend_location_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_location_id_seq OWNED BY public.backend_location.id;


--
-- Name: backend_location_users; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_location_users (
    id integer NOT NULL,
    location_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.backend_location_users OWNER TO iftttuser;

--
-- Name: backend_location_users_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_location_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_location_users_id_seq OWNER TO iftttuser;

--
-- Name: backend_location_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_location_users_id_seq OWNED BY public.backend_location_users.id;


--
-- Name: backend_locationvirtualdevices; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_locationvirtualdevices (
    id integer NOT NULL,
    clock_dev_id integer NOT NULL,
    location_id integer NOT NULL,
    weather_dev_id integer NOT NULL
);


ALTER TABLE public.backend_locationvirtualdevices OWNER TO iftttuser;

--
-- Name: backend_locationvirtualdevices_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_locationvirtualdevices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_locationvirtualdevices_id_seq OWNER TO iftttuser;

--
-- Name: backend_locationvirtualdevices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_locationvirtualdevices_id_seq OWNED BY public.backend_locationvirtualdevices.id;


--
-- Name: backend_metaparam; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_metaparam (
    parameter_ptr_id integer NOT NULL,
    is_event boolean NOT NULL
);


ALTER TABLE public.backend_metaparam OWNER TO iftttuser;

--
-- Name: backend_parameter; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_parameter (
    id integer NOT NULL,
    name text NOT NULL,
    sysname text,
    is_command boolean,
    is_main_param boolean,
    type text NOT NULL,
    cap_id integer NOT NULL
);


ALTER TABLE public.backend_parameter OWNER TO iftttuser;

--
-- Name: backend_parameter_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_parameter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_parameter_id_seq OWNER TO iftttuser;

--
-- Name: backend_parameter_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_parameter_id_seq OWNED BY public.backend_parameter.id;


--
-- Name: backend_parval; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_parval (
    id integer NOT NULL,
    val text NOT NULL,
    par_id integer NOT NULL,
    state_id integer NOT NULL
);


ALTER TABLE public.backend_parval OWNER TO iftttuser;

--
-- Name: backend_parval_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_parval_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_parval_id_seq OWNER TO iftttuser;

--
-- Name: backend_parval_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_parval_id_seq OWNED BY public.backend_parval.id;


--
-- Name: backend_parvalmapping; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_parvalmapping (
    id integer NOT NULL,
    st_val text NOT NULL,
    val text NOT NULL,
    param_id integer NOT NULL
);


ALTER TABLE public.backend_parvalmapping OWNER TO iftttuser;

--
-- Name: backend_parvalmapping_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_parvalmapping_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_parvalmapping_id_seq OWNER TO iftttuser;

--
-- Name: backend_parvalmapping_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_parvalmapping_id_seq OWNED BY public.backend_parvalmapping.id;


--
-- Name: backend_rangeparam; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_rangeparam (
    parameter_ptr_id integer NOT NULL,
    min integer NOT NULL,
    max integer NOT NULL,
    "interval" double precision NOT NULL
);


ALTER TABLE public.backend_rangeparam OWNER TO iftttuser;

--
-- Name: backend_rule; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_rule (
    id integer NOT NULL,
    st_installed_app_id character varying(37),
    task integer,
    lastedit timestamp with time zone NOT NULL,
    type character varying(3) NOT NULL,
    owner_id integer,
    st_owner_id integer
);


ALTER TABLE public.backend_rule OWNER TO iftttuser;

--
-- Name: backend_rule_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_rule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_rule_id_seq OWNER TO iftttuser;

--
-- Name: backend_rule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_rule_id_seq OWNED BY public.backend_rule.id;


--
-- Name: backend_safetyprop; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_safetyprop (
    id integer NOT NULL,
    task integer NOT NULL,
    lastedit timestamp with time zone NOT NULL,
    type integer NOT NULL,
    always boolean NOT NULL,
    owner_id integer NOT NULL
);


ALTER TABLE public.backend_safetyprop OWNER TO iftttuser;

--
-- Name: backend_safetyprop_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_safetyprop_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_safetyprop_id_seq OWNER TO iftttuser;

--
-- Name: backend_safetyprop_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_safetyprop_id_seq OWNED BY public.backend_safetyprop.id;


--
-- Name: backend_setparam; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_setparam (
    parameter_ptr_id integer NOT NULL,
    numopts integer NOT NULL
);


ALTER TABLE public.backend_setparam OWNER TO iftttuser;

--
-- Name: backend_setparamopt; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_setparamopt (
    id integer NOT NULL,
    value text NOT NULL,
    param_id integer NOT NULL
);


ALTER TABLE public.backend_setparamopt OWNER TO iftttuser;

--
-- Name: backend_setparamopt_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_setparamopt_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_setparamopt_id_seq OWNER TO iftttuser;

--
-- Name: backend_setparamopt_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_setparamopt_id_seq OWNED BY public.backend_setparamopt.id;


--
-- Name: backend_sp1; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_sp1 (
    safetyprop_ptr_id integer NOT NULL
);


ALTER TABLE public.backend_sp1 OWNER TO iftttuser;

--
-- Name: backend_sp1_triggers; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_sp1_triggers (
    id integer NOT NULL,
    sp1_id integer NOT NULL,
    trigger_id integer NOT NULL
);


ALTER TABLE public.backend_sp1_triggers OWNER TO iftttuser;

--
-- Name: backend_sp1_triggers_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_sp1_triggers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_sp1_triggers_id_seq OWNER TO iftttuser;

--
-- Name: backend_sp1_triggers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_sp1_triggers_id_seq OWNED BY public.backend_sp1_triggers.id;


--
-- Name: backend_sp2; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_sp2 (
    safetyprop_ptr_id integer NOT NULL,
    comp text,
    "time" integer,
    state_id integer NOT NULL
);


ALTER TABLE public.backend_sp2 OWNER TO iftttuser;

--
-- Name: backend_sp2_conds; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_sp2_conds (
    id integer NOT NULL,
    sp2_id integer NOT NULL,
    trigger_id integer NOT NULL
);


ALTER TABLE public.backend_sp2_conds OWNER TO iftttuser;

--
-- Name: backend_sp2_conds_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_sp2_conds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_sp2_conds_id_seq OWNER TO iftttuser;

--
-- Name: backend_sp2_conds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_sp2_conds_id_seq OWNED BY public.backend_sp2_conds.id;


--
-- Name: backend_sp3; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_sp3 (
    safetyprop_ptr_id integer NOT NULL,
    comp text,
    occurrences integer,
    "time" integer,
    timecomp text,
    event_id integer NOT NULL
);


ALTER TABLE public.backend_sp3 OWNER TO iftttuser;

--
-- Name: backend_sp3_conds; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_sp3_conds (
    id integer NOT NULL,
    sp3_id integer NOT NULL,
    trigger_id integer NOT NULL
);


ALTER TABLE public.backend_sp3_conds OWNER TO iftttuser;

--
-- Name: backend_sp3_conds_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_sp3_conds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_sp3_conds_id_seq OWNER TO iftttuser;

--
-- Name: backend_sp3_conds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_sp3_conds_id_seq OWNED BY public.backend_sp3_conds.id;


--
-- Name: backend_ssrule; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_ssrule (
    rule_ptr_id integer NOT NULL,
    priority integer NOT NULL,
    action_id integer NOT NULL
);


ALTER TABLE public.backend_ssrule OWNER TO iftttuser;

--
-- Name: backend_ssrule_triggers; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_ssrule_triggers (
    id integer NOT NULL,
    ssrule_id integer NOT NULL,
    trigger_id integer NOT NULL
);


ALTER TABLE public.backend_ssrule_triggers OWNER TO iftttuser;

--
-- Name: backend_ssrule_triggers_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_ssrule_triggers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_ssrule_triggers_id_seq OWNER TO iftttuser;

--
-- Name: backend_ssrule_triggers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_ssrule_triggers_id_seq OWNED BY public.backend_ssrule_triggers.id;


--
-- Name: backend_state; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_state (
    id integer NOT NULL,
    action boolean NOT NULL,
    text text,
    cap_id integer NOT NULL,
    chan_id integer,
    dev_id integer NOT NULL
);


ALTER TABLE public.backend_state OWNER TO iftttuser;

--
-- Name: backend_state_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_state_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_state_id_seq OWNER TO iftttuser;

--
-- Name: backend_state_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_state_id_seq OWNED BY public.backend_state.id;


--
-- Name: backend_statelog; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_statelog (
    id integer NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    status smallint NOT NULL,
    value text NOT NULL,
    value_type character varying(13) NOT NULL,
    is_superifttt boolean NOT NULL,
    cap_id integer NOT NULL,
    dev_id integer NOT NULL,
    param_id integer NOT NULL,
    CONSTRAINT backend_statelog_status_check CHECK ((status >= 0))
);


ALTER TABLE public.backend_statelog OWNER TO iftttuser;

--
-- Name: backend_statelog_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_statelog_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_statelog_id_seq OWNER TO iftttuser;

--
-- Name: backend_statelog_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_statelog_id_seq OWNED BY public.backend_statelog.id;


--
-- Name: backend_stcapability; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_stcapability (
    id integer NOT NULL,
    name character varying(30) NOT NULL,
    command_type text
);


ALTER TABLE public.backend_stcapability OWNER TO iftttuser;

--
-- Name: backend_stcapability_capabilities; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_stcapability_capabilities (
    id integer NOT NULL,
    stcapability_id integer NOT NULL,
    capability_id integer NOT NULL
);


ALTER TABLE public.backend_stcapability_capabilities OWNER TO iftttuser;

--
-- Name: backend_stcapability_capabilities_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_stcapability_capabilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_stcapability_capabilities_id_seq OWNER TO iftttuser;

--
-- Name: backend_stcapability_capabilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_stcapability_capabilities_id_seq OWNED BY public.backend_stcapability_capabilities.id;


--
-- Name: backend_stcapability_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_stcapability_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_stcapability_id_seq OWNER TO iftttuser;

--
-- Name: backend_stcapability_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_stcapability_id_seq OWNED BY public.backend_stcapability.id;


--
-- Name: backend_timeparam; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_timeparam (
    parameter_ptr_id integer NOT NULL,
    mode text NOT NULL
);


ALTER TABLE public.backend_timeparam OWNER TO iftttuser;

--
-- Name: backend_trigger; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_trigger (
    id integer NOT NULL,
    pos integer,
    text text,
    cap_id integer NOT NULL,
    chan_id integer,
    dev_id integer NOT NULL
);


ALTER TABLE public.backend_trigger OWNER TO iftttuser;

--
-- Name: backend_trigger_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_trigger_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_trigger_id_seq OWNER TO iftttuser;

--
-- Name: backend_trigger_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_trigger_id_seq OWNED BY public.backend_trigger.id;


--
-- Name: backend_user_icse19; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_user_icse19 (
    id integer NOT NULL,
    name character varying(30),
    code text NOT NULL,
    mode character varying(5) NOT NULL
);


ALTER TABLE public.backend_user_icse19 OWNER TO iftttuser;

--
-- Name: backend_user_icse19_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_user_icse19_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_user_icse19_id_seq OWNER TO iftttuser;

--
-- Name: backend_user_icse19_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_user_icse19_id_seq OWNED BY public.backend_user_icse19.id;


--
-- Name: backend_userprofile; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.backend_userprofile (
    id integer NOT NULL,
    access_token character varying(256) NOT NULL,
    access_token_expired_at timestamp with time zone,
    refresh_token text,
    user_id integer NOT NULL,
    stapp_id character varying(256) NOT NULL
);


ALTER TABLE public.backend_userprofile OWNER TO iftttuser;

--
-- Name: backend_userprofile_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.backend_userprofile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_userprofile_id_seq OWNER TO iftttuser;

--
-- Name: backend_userprofile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.backend_userprofile_id_seq OWNED BY public.backend_userprofile.id;


--
-- Name: currentweather_weatherlog; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.currentweather_weatherlog (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    cityname character varying(50) NOT NULL,
    latitude integer NOT NULL,
    longitude integer NOT NULL,
    temp integer NOT NULL,
    humidity integer,
    condition character varying(50) NOT NULL,
    cond_code integer NOT NULL,
    long_desc character varying(80) NOT NULL,
    sunrise integer,
    sunset integer
);


ALTER TABLE public.currentweather_weatherlog OWNER TO iftttuser;

--
-- Name: currentweather_weatherlog_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.currentweather_weatherlog_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.currentweather_weatherlog_id_seq OWNER TO iftttuser;

--
-- Name: currentweather_weatherlog_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.currentweather_weatherlog_id_seq OWNED BY public.currentweather_weatherlog.id;


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: iftttuser
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


ALTER TABLE public.django_admin_log OWNER TO iftttuser;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_admin_log_id_seq OWNER TO iftttuser;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- Name: django_celery_beat_clockedschedule; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.django_celery_beat_clockedschedule (
    id integer NOT NULL,
    clocked_time timestamp with time zone NOT NULL,
    enabled boolean NOT NULL
);


ALTER TABLE public.django_celery_beat_clockedschedule OWNER TO iftttuser;

--
-- Name: django_celery_beat_clockedschedule_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.django_celery_beat_clockedschedule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_celery_beat_clockedschedule_id_seq OWNER TO iftttuser;

--
-- Name: django_celery_beat_clockedschedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.django_celery_beat_clockedschedule_id_seq OWNED BY public.django_celery_beat_clockedschedule.id;


--
-- Name: django_celery_beat_crontabschedule; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.django_celery_beat_crontabschedule (
    id integer NOT NULL,
    minute character varying(240) NOT NULL,
    hour character varying(96) NOT NULL,
    day_of_week character varying(64) NOT NULL,
    day_of_month character varying(124) NOT NULL,
    month_of_year character varying(64) NOT NULL,
    timezone character varying(63) NOT NULL
);


ALTER TABLE public.django_celery_beat_crontabschedule OWNER TO iftttuser;

--
-- Name: django_celery_beat_crontabschedule_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.django_celery_beat_crontabschedule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_celery_beat_crontabschedule_id_seq OWNER TO iftttuser;

--
-- Name: django_celery_beat_crontabschedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.django_celery_beat_crontabschedule_id_seq OWNED BY public.django_celery_beat_crontabschedule.id;


--
-- Name: django_celery_beat_intervalschedule; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.django_celery_beat_intervalschedule (
    id integer NOT NULL,
    every integer NOT NULL,
    period character varying(24) NOT NULL
);


ALTER TABLE public.django_celery_beat_intervalschedule OWNER TO iftttuser;

--
-- Name: django_celery_beat_intervalschedule_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.django_celery_beat_intervalschedule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_celery_beat_intervalschedule_id_seq OWNER TO iftttuser;

--
-- Name: django_celery_beat_intervalschedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.django_celery_beat_intervalschedule_id_seq OWNED BY public.django_celery_beat_intervalschedule.id;


--
-- Name: django_celery_beat_periodictask; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.django_celery_beat_periodictask (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    task character varying(200) NOT NULL,
    args text NOT NULL,
    kwargs text NOT NULL,
    queue character varying(200),
    exchange character varying(200),
    routing_key character varying(200),
    expires timestamp with time zone,
    enabled boolean NOT NULL,
    last_run_at timestamp with time zone,
    total_run_count integer NOT NULL,
    date_changed timestamp with time zone NOT NULL,
    description text NOT NULL,
    crontab_id integer,
    interval_id integer,
    solar_id integer,
    one_off boolean NOT NULL,
    start_time timestamp with time zone,
    priority integer,
    headers text NOT NULL,
    clocked_id integer,
    CONSTRAINT django_celery_beat_periodictask_priority_check CHECK ((priority >= 0)),
    CONSTRAINT django_celery_beat_periodictask_total_run_count_check CHECK ((total_run_count >= 0))
);


ALTER TABLE public.django_celery_beat_periodictask OWNER TO iftttuser;

--
-- Name: django_celery_beat_periodictask_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.django_celery_beat_periodictask_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_celery_beat_periodictask_id_seq OWNER TO iftttuser;

--
-- Name: django_celery_beat_periodictask_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.django_celery_beat_periodictask_id_seq OWNED BY public.django_celery_beat_periodictask.id;


--
-- Name: django_celery_beat_periodictasks; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.django_celery_beat_periodictasks (
    ident smallint NOT NULL,
    last_update timestamp with time zone NOT NULL
);


ALTER TABLE public.django_celery_beat_periodictasks OWNER TO iftttuser;

--
-- Name: django_celery_beat_solarschedule; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.django_celery_beat_solarschedule (
    id integer NOT NULL,
    event character varying(24) NOT NULL,
    latitude numeric(9,6) NOT NULL,
    longitude numeric(9,6) NOT NULL
);


ALTER TABLE public.django_celery_beat_solarschedule OWNER TO iftttuser;

--
-- Name: django_celery_beat_solarschedule_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.django_celery_beat_solarschedule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_celery_beat_solarschedule_id_seq OWNER TO iftttuser;

--
-- Name: django_celery_beat_solarschedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.django_celery_beat_solarschedule_id_seq OWNED BY public.django_celery_beat_solarschedule.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO iftttuser;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO iftttuser;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO iftttuser;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_migrations_id_seq OWNER TO iftttuser;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO iftttuser;

--
-- Name: oauth2_provider_accesstoken_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.oauth2_provider_accesstoken_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oauth2_provider_accesstoken_id_seq OWNER TO iftttuser;

--
-- Name: oauth2_provider_accesstoken; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.oauth2_provider_accesstoken (
    id bigint DEFAULT nextval('public.oauth2_provider_accesstoken_id_seq'::regclass) NOT NULL,
    token character varying(255) NOT NULL,
    expires timestamp with time zone NOT NULL,
    scope text NOT NULL,
    application_id bigint,
    user_id integer,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    source_refresh_token_id bigint
);


ALTER TABLE public.oauth2_provider_accesstoken OWNER TO iftttuser;

--
-- Name: oauth2_provider_application_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.oauth2_provider_application_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oauth2_provider_application_id_seq OWNER TO iftttuser;

--
-- Name: oauth2_provider_application; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.oauth2_provider_application (
    id bigint DEFAULT nextval('public.oauth2_provider_application_id_seq'::regclass) NOT NULL,
    client_id character varying(100) NOT NULL,
    redirect_uris text NOT NULL,
    client_type character varying(32) NOT NULL,
    authorization_grant_type character varying(32) NOT NULL,
    client_secret character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    user_id integer,
    skip_authorization boolean NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL
);


ALTER TABLE public.oauth2_provider_application OWNER TO iftttuser;

--
-- Name: oauth2_provider_grant_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.oauth2_provider_grant_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oauth2_provider_grant_id_seq OWNER TO iftttuser;

--
-- Name: oauth2_provider_grant; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.oauth2_provider_grant (
    id bigint DEFAULT nextval('public.oauth2_provider_grant_id_seq'::regclass) NOT NULL,
    code character varying(255) NOT NULL,
    expires timestamp with time zone NOT NULL,
    redirect_uri character varying(255) NOT NULL,
    scope text NOT NULL,
    application_id bigint NOT NULL,
    user_id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL
);


ALTER TABLE public.oauth2_provider_grant OWNER TO iftttuser;

--
-- Name: oauth2_provider_refreshtoken_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.oauth2_provider_refreshtoken_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oauth2_provider_refreshtoken_id_seq OWNER TO iftttuser;

--
-- Name: oauth2_provider_refreshtoken; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.oauth2_provider_refreshtoken (
    id bigint DEFAULT nextval('public.oauth2_provider_refreshtoken_id_seq'::regclass) NOT NULL,
    token character varying(255) NOT NULL,
    access_token_id bigint,
    application_id bigint NOT NULL,
    user_id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    revoked timestamp with time zone
);


ALTER TABLE public.oauth2_provider_refreshtoken OWNER TO iftttuser;

--
-- Name: user_auth_usermetadata; Type: TABLE; Schema: public; Owner: iftttuser
--

CREATE TABLE public.user_auth_usermetadata (
    id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.user_auth_usermetadata OWNER TO iftttuser;

--
-- Name: user_auth_usermetadata_id_seq; Type: SEQUENCE; Schema: public; Owner: iftttuser
--

CREATE SEQUENCE public.user_auth_usermetadata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_auth_usermetadata_id_seq OWNER TO iftttuser;

--
-- Name: user_auth_usermetadata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: iftttuser
--

ALTER SEQUENCE public.user_auth_usermetadata_id_seq OWNED BY public.user_auth_usermetadata.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_user ALTER COLUMN id SET DEFAULT nextval('public.auth_user_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_user_groups ALTER COLUMN id SET DEFAULT nextval('public.auth_user_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_user_user_permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_action ALTER COLUMN id SET DEFAULT nextval('public.backend_action_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_actioncondition ALTER COLUMN id SET DEFAULT nextval('public.backend_actioncondition_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_actionparval ALTER COLUMN id SET DEFAULT nextval('public.backend_actionparval_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_capability ALTER COLUMN id SET DEFAULT nextval('public.backend_capability_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_capability_channels ALTER COLUMN id SET DEFAULT nextval('public.backend_capability_channels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_channel ALTER COLUMN id SET DEFAULT nextval('public.backend_channel_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_condition ALTER COLUMN id SET DEFAULT nextval('public.backend_condition_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_device ALTER COLUMN id SET DEFAULT nextval('public.backend_device_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_device_caps ALTER COLUMN id SET DEFAULT nextval('public.backend_device_caps_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_device_chans ALTER COLUMN id SET DEFAULT nextval('public.backend_device_chans_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_device_users ALTER COLUMN id SET DEFAULT nextval('public.backend_device_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_errorlog ALTER COLUMN id SET DEFAULT nextval('public.backend_errorlog_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public."backend_esrule_Striggers" ALTER COLUMN id SET DEFAULT nextval('public."backend_esrule_Striggers_id_seq"'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_location ALTER COLUMN id SET DEFAULT nextval('public.backend_location_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_location_users ALTER COLUMN id SET DEFAULT nextval('public.backend_location_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_locationvirtualdevices ALTER COLUMN id SET DEFAULT nextval('public.backend_locationvirtualdevices_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_parameter ALTER COLUMN id SET DEFAULT nextval('public.backend_parameter_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_parval ALTER COLUMN id SET DEFAULT nextval('public.backend_parval_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_parvalmapping ALTER COLUMN id SET DEFAULT nextval('public.backend_parvalmapping_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_rule ALTER COLUMN id SET DEFAULT nextval('public.backend_rule_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_safetyprop ALTER COLUMN id SET DEFAULT nextval('public.backend_safetyprop_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_setparamopt ALTER COLUMN id SET DEFAULT nextval('public.backend_setparamopt_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp1_triggers ALTER COLUMN id SET DEFAULT nextval('public.backend_sp1_triggers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp2_conds ALTER COLUMN id SET DEFAULT nextval('public.backend_sp2_conds_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp3_conds ALTER COLUMN id SET DEFAULT nextval('public.backend_sp3_conds_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_ssrule_triggers ALTER COLUMN id SET DEFAULT nextval('public.backend_ssrule_triggers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_state ALTER COLUMN id SET DEFAULT nextval('public.backend_state_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_statelog ALTER COLUMN id SET DEFAULT nextval('public.backend_statelog_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_stcapability ALTER COLUMN id SET DEFAULT nextval('public.backend_stcapability_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_stcapability_capabilities ALTER COLUMN id SET DEFAULT nextval('public.backend_stcapability_capabilities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_trigger ALTER COLUMN id SET DEFAULT nextval('public.backend_trigger_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_user_icse19 ALTER COLUMN id SET DEFAULT nextval('public.backend_user_icse19_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_userprofile ALTER COLUMN id SET DEFAULT nextval('public.backend_userprofile_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.currentweather_weatherlog ALTER COLUMN id SET DEFAULT nextval('public.currentweather_weatherlog_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_celery_beat_clockedschedule ALTER COLUMN id SET DEFAULT nextval('public.django_celery_beat_clockedschedule_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_celery_beat_crontabschedule ALTER COLUMN id SET DEFAULT nextval('public.django_celery_beat_crontabschedule_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_celery_beat_intervalschedule ALTER COLUMN id SET DEFAULT nextval('public.django_celery_beat_intervalschedule_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_celery_beat_periodictask ALTER COLUMN id SET DEFAULT nextval('public.django_celery_beat_periodictask_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_celery_beat_solarschedule ALTER COLUMN id SET DEFAULT nextval('public.django_celery_beat_solarschedule_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.user_auth_usermetadata ALTER COLUMN id SET DEFAULT nextval('public.user_auth_usermetadata_id_seq'::regclass);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can view log entry	1	view_logentry
5	Can add user	2	add_user
6	Can change user	2	change_user
7	Can delete user	2	delete_user
8	Can view user	2	view_user
9	Can add group	3	add_group
10	Can change group	3	change_group
11	Can delete group	3	delete_group
12	Can view group	3	view_group
13	Can add permission	4	add_permission
14	Can change permission	4	change_permission
15	Can delete permission	4	delete_permission
16	Can view permission	4	view_permission
17	Can add content type	5	add_contenttype
18	Can change content type	5	change_contenttype
19	Can delete content type	5	delete_contenttype
20	Can view content type	5	view_contenttype
21	Can add session	6	add_session
22	Can change session	6	change_session
23	Can delete session	6	delete_session
24	Can view session	6	view_session
25	Can add refresh token	8	add_refreshtoken
26	Can change refresh token	8	change_refreshtoken
27	Can delete refresh token	8	delete_refreshtoken
28	Can view refresh token	8	view_refreshtoken
29	Can add application	7	add_application
30	Can change application	7	change_application
31	Can delete application	7	delete_application
32	Can view application	7	view_application
33	Can add access token	9	add_accesstoken
34	Can change access token	9	change_accesstoken
35	Can delete access token	9	delete_accesstoken
36	Can view access token	9	view_accesstoken
37	Can add grant	10	add_grant
38	Can change grant	10	change_grant
39	Can delete grant	10	delete_grant
40	Can view grant	10	view_grant
41	Can add user metadata	11	add_usermetadata
42	Can change user metadata	11	change_usermetadata
43	Can delete user metadata	11	delete_usermetadata
44	Can view user metadata	11	view_usermetadata
45	Can add capability	37	add_capability
46	Can change capability	37	change_capability
47	Can delete capability	37	delete_capability
48	Can view capability	37	view_capability
49	Can add state log	32	add_statelog
50	Can change state log	32	change_statelog
51	Can delete state log	32	delete_statelog
52	Can view state log	32	view_statelog
53	Can add action par val	40	add_actionparval
54	Can change action par val	40	change_actionparval
55	Can delete action par val	40	delete_actionparval
56	Can view action par val	40	view_actionparval
57	Can add user profile	26	add_userprofile
58	Can change user profile	26	change_userprofile
59	Can delete user profile	26	delete_userprofile
60	Can view user profile	26	view_userprofile
61	Can add state	29	add_state
62	Can change state	29	change_state
63	Can delete state	29	delete_state
64	Can view state	29	view_state
65	Can add par val	33	add_parval
66	Can change par val	33	change_parval
67	Can delete par val	33	delete_parval
68	Can view par val	33	view_parval
69	Can add channel	27	add_channel
70	Can change channel	27	change_channel
71	Can delete channel	27	delete_channel
72	Can view channel	27	view_channel
73	Can add location	16	add_location
74	Can change location	16	change_location
75	Can delete location	16	delete_location
76	Can view location	16	view_location
77	Can add parameter	12	add_parameter
78	Can change parameter	12	change_parameter
79	Can delete parameter	12	delete_parameter
80	Can view parameter	12	view_parameter
81	Can add device	19	add_device
82	Can change device	19	change_device
83	Can delete device	19	delete_device
84	Can view device	19	view_device
85	Can add range param	34	add_rangeparam
86	Can change range param	34	change_rangeparam
87	Can delete range param	34	delete_rangeparam
88	Can view range param	34	view_rangeparam
89	Can add trigger	28	add_trigger
90	Can change trigger	28	change_trigger
91	Can delete trigger	28	delete_trigger
92	Can view trigger	28	view_trigger
93	Can add condition	15	add_condition
94	Can change condition	15	change_condition
95	Can delete condition	15	delete_condition
96	Can view condition	15	view_condition
97	Can add time param	41	add_timeparam
98	Can change time param	41	change_timeparam
99	Can delete time param	41	delete_timeparam
100	Can view time param	41	view_timeparam
101	Can add set param opt	38	add_setparamopt
102	Can change set param opt	38	change_setparamopt
103	Can delete set param opt	38	delete_setparamopt
104	Can view set param opt	38	view_setparamopt
105	Can add input param	25	add_inputparam
106	Can change input param	25	change_inputparam
107	Can delete input param	25	delete_inputparam
108	Can view input param	25	view_inputparam
109	Can add user_ics e19	14	add_user_icse19
110	Can change user_ics e19	14	change_user_icse19
111	Can delete user_ics e19	14	delete_user_icse19
112	Can view user_ics e19	14	view_user_icse19
113	Can add safety prop	18	add_safetyprop
114	Can change safety prop	18	change_safetyprop
115	Can delete safety prop	18	delete_safetyprop
116	Can view safety prop	18	view_safetyprop
117	Can add color param	31	add_colorparam
118	Can change color param	31	change_colorparam
119	Can delete color param	31	delete_colorparam
120	Can view color param	31	view_colorparam
121	Can add rule	20	add_rule
122	Can change rule	20	change_rule
123	Can delete rule	20	delete_rule
124	Can view rule	20	view_rule
125	Can add error log	24	add_errorlog
126	Can change error log	24	change_errorlog
127	Can delete error log	24	delete_errorlog
128	Can view error log	24	view_errorlog
129	Can add set param	39	add_setparam
130	Can change set param	39	change_setparam
131	Can delete set param	39	delete_setparam
132	Can view set param	39	view_setparam
133	Can add meta param	35	add_metaparam
134	Can change meta param	35	change_metaparam
135	Can delete meta param	35	delete_metaparam
136	Can view meta param	35	view_metaparam
137	Can add ss rule	22	add_ssrule
138	Can change ss rule	22	change_ssrule
139	Can delete ss rule	22	delete_ssrule
140	Can view ss rule	22	view_ssrule
141	Can add s p2	23	add_sp2
142	Can change s p2	23	change_sp2
143	Can delete s p2	23	delete_sp2
144	Can view s p2	23	view_sp2
145	Can add duration param	30	add_durationparam
146	Can change duration param	30	change_durationparam
147	Can delete duration param	30	delete_durationparam
148	Can view duration param	30	view_durationparam
149	Can add bin param	21	add_binparam
150	Can change bin param	21	change_binparam
151	Can delete bin param	21	delete_binparam
152	Can view bin param	21	view_binparam
153	Can add s p1	17	add_sp1
154	Can change s p1	17	change_sp1
155	Can delete s p1	17	delete_sp1
156	Can view s p1	17	view_sp1
157	Can add es rule	36	add_esrule
158	Can change es rule	36	change_esrule
159	Can delete es rule	36	delete_esrule
160	Can view es rule	36	view_esrule
161	Can add s p3	13	add_sp3
162	Can change s p3	13	change_sp3
163	Can delete s p3	13	delete_sp3
164	Can view s p3	13	view_sp3
165	Can add st capability	42	add_stcapability
166	Can change st capability	42	change_stcapability
167	Can delete st capability	42	delete_stcapability
168	Can view st capability	42	view_stcapability
169	Can add action condition	43	add_actioncondition
170	Can change action condition	43	change_actioncondition
171	Can delete action condition	43	delete_actioncondition
172	Can view action condition	43	view_actioncondition
173	Can add par val mapping	45	add_parvalmapping
174	Can change par val mapping	45	change_parvalmapping
175	Can delete par val mapping	45	delete_parvalmapping
176	Can view par val mapping	45	view_parvalmapping
177	Can add action	44	add_action
178	Can change action	44	change_action
179	Can delete action	44	delete_action
180	Can view action	44	view_action
181	Can add location virtual devices	46	add_locationvirtualdevices
182	Can change location virtual devices	46	change_locationvirtualdevices
183	Can delete location virtual devices	46	delete_locationvirtualdevices
184	Can view location virtual devices	46	view_locationvirtualdevices
185	Can add periodic tasks	49	add_periodictasks
186	Can change periodic tasks	49	change_periodictasks
187	Can delete periodic tasks	49	delete_periodictasks
188	Can view periodic tasks	49	view_periodictasks
189	Can add clocked	47	add_clockedschedule
190	Can change clocked	47	change_clockedschedule
191	Can delete clocked	47	delete_clockedschedule
192	Can view clocked	47	view_clockedschedule
193	Can add crontab	52	add_crontabschedule
194	Can change crontab	52	change_crontabschedule
195	Can delete crontab	52	delete_crontabschedule
196	Can view crontab	52	view_crontabschedule
197	Can add periodic task	51	add_periodictask
198	Can change periodic task	51	change_periodictask
199	Can delete periodic task	51	delete_periodictask
200	Can view periodic task	51	view_periodictask
201	Can add interval	48	add_intervalschedule
202	Can change interval	48	change_intervalschedule
203	Can delete interval	48	delete_intervalschedule
204	Can view interval	48	view_intervalschedule
205	Can add solar event	50	add_solarschedule
206	Can change solar event	50	change_solarschedule
207	Can delete solar event	50	delete_solarschedule
208	Can view solar event	50	view_solarschedule
209	Can add weather log	53	add_weatherlog
210	Can change weather log	53	change_weatherlog
211	Can delete weather log	53	delete_weatherlog
212	Can view weather log	53	view_weatherlog
\.


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 212, true);


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 4, true);


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- Data for Name: backend_action; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_action (id, text, cap_id, chan_id, dev_id) FROM stdin;
\.


--
-- Name: backend_action_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_action_id_seq', 1, false);


--
-- Data for Name: backend_actioncondition; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_actioncondition (id, val, action_id, par_id) FROM stdin;
\.


--
-- Name: backend_actioncondition_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_actioncondition_id_seq', 1, false);


--
-- Data for Name: backend_actionparval; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_actionparval (id, val, par_id, state_id) FROM stdin;
\.


--
-- Name: backend_actionparval_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_actionparval_id_seq', 1, false);


--
-- Data for Name: backend_binparam; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_binparam (parameter_ptr_id, tval, fval) FROM stdin;
1	On	Off
12	Locked	Unlocked
13	Open	Closed
14	Motion	No Motion
20	Raining	Not Raining
25	Yes	No
26	On	Off
40	On	Off
62	Day	Night
64	On	Off
65	Open	Closed
66	Smoke Detected	No Smoke Detected
67	Open	Closed
68	Awake	Asleep
72	On	Off
78	detected	clear
81	active	inactive
82	open	closed
\.


--
-- Data for Name: backend_capability; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_capability (id, name, readable, writeable, statelabel, commandlabel, eventlabel, commandname) FROM stdin;
28	Record	t	t	{DEVICE} is{value/F| not} recording	({DEVICE}) {value/T|start}{value/F|stop} recording	{DEVICE} {value/T|starts}{value/F|stops} recording	\N
36	Channel	t	t	{DEVICE} is {channel/=|tuned to}{channel/!=|not tuned to}{channel/>|tuned above}{channel/<|tuned below} Channel {channel}	Tune {DEVICE} to Channel {channel}	{DEVICE} {channel/=|becomes tuned to}{channel/!=|becomes tuned to something other than}{channel/>|becomes tuned above}{channel/<|becomes tuned below} {channel}	\N
65	Oven Temperature	t	t	{DEVICE}'s temperature {temperature/=|is}{temperature/!=|is not}{temperature/>|is above}{temperature/<|is below} {temperature} degrees	Set {DEVICE}'s temperature to {temperature}	{DEVICE}'s temperature {temperature/=|becomes}{temperature/!=|changes from}{temperature/>|goes above}{temperature/<|falls below} {temperature} degrees	\N
27	Alarm Ringing	t	t	{DEVICE}'s Alarm is{value/F| not} going off	{value/T|Set off}{value/F|Turn off} {DEVICE}'s alarm	{DEVICE}'s Alarm {value/T|Starts}{value/F|Stops} going off	\N
38	How Much Coffee Is There?	t	f	({DEVICE}) There are {cups/=|exactly}{cups/!=|not exactly}{cups/>|more than}{cups/<|fewer than} {cups} cups of coffee brewed	\N	({DEVICE}) The number of cups of coffee {cups/=|becomes}{cups/!=|changes from}{cups/>|becomes larger than}{cups/<|falls below} {cups}	\N
18	Weather Sensor	t	f	({DEVICE}) The weather is{weather/!=| not} {weather}	\N	({DEVICE}) The weather {weather/=|becomes}{weather/!=|stops being} {weather}	\N
62	Heart Rate Sensor	t	f	({DEVICE}) My heart rate is {BPM/=|exactly}{BPM/!=|not}{BPM/>|above}{BPM/<|below} {BPM}BPM	\N	({DEVICE}) My heart rate {BPM/=|becomes}{BPM/!=|changes from}{BPM/>|goes above}{BPM/<|falls below} {BPM}BPM	\N
32	Track Package	t	f	({DEVICE}) Package #{trackingid} is{distance/!=| not} {distance/<|<}{distance/>|>}{distance} miles away	\N	({DEVICE}) Package #{trackingid} {distance/=|becomes}{distance/!=|stops being}{distance/>|becomes farther than}{distance/<|becomes closer than} {distance} miles away	\N
12	FM Tuner	t	t	{DEVICE} {frequency/=|is tuned to}{frequency/!=|is not tuned to}{frequency/>|is tuned above}{frequency/<|is tuned below} {frequency}FM	Tune {DEVICE} to {frequency}FM	{DEVICE} {frequency/=|becomes tuned to}{frequency/!=|stops being tuned to}{frequency/>|becomes tuned above}{frequency/<|becomes tuned below} {frequency}FM	\N
33	What's On My Shopping List?	t	f	({DEVICE}) {item} is{item/!=| not} on my Shopping List	\N	({DEVICE}) {item} {item/=|gets added to}{item/!=|gets removed from} my Shopping List	\N
37	What Show is On?	t	f	{name} is{name/!=| not} playing on {DEVICE}	\N	{name} {name/=|starts}{name/!=|stops} playing on {DEVICE}	\N
29	Take Photo	f	t	\N	({DEVICE}) Take a photo		\N
30	Order (Amazon)	f	t	\N	({DEVICE}) Order {quantity} {item} on Amazon		\N
31	Order Pizza	f	t	\N	({DEVICE}) Order {quantity} {size} Pizza(s) with {topping}		\N
40	Siren	t	t	{DEVICE}'s Siren is {value}	Turn {DEVICE}'s Siren {value}	{DEVICE}'s Siren turns {value}	\N
39	Brew Coffee	f	t	\N	({DEVICE}) Brew {cups} cup(s) of coffee		\N
64	Water On/Off	t	t	{DEVICE}'s water is {setting/F|not }running	Turn {setting} {DEVICE}'s water	{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}	\N
6	Light Color	t	t	{DEVICE}'s Color {color/=|is}{color/!=|is not} {color}	Set {DEVICE}'s Color to {color}	{DEVICE}'s color {color/=|becomes}{color/!=|changes from} {color}	\N
26	Set Alarm	t	t	{DEVICE}'s Alarm is {time/=|set for}{time/!=|not set for}{time/>|set for later than}{time/<|set for earlier than} {time}	({DEVICE}) Set an Alarm for {time}	{DEVICE}'s Alarm {time/=|gets set for}{time/!=|gets set for something other than}{time/>|gets set for later than}{time/<|gets set for earlier than} {time}	\N
19	Current Temperature	t	f	({DEVICE}) The temperature {temperature/=|is}{temperature/!=|is not}{temperature/>|is above}{temperature/<|is below} {temperature} degrees	\N	({DEVICE}) The temperature {temperature/=|becomes}{temperature/!=|changes from}{temperature/>|goes above}{temperature/<|falls below} {temperature} degrees	\N
50	Event Frequency	t	f	"{$trigger$}" has {occurrences/=|occurred exactly}{occurrences/!=|not occurred exactly}{occurrences/>|occurred more than}{occurrences/<|occurred fewer than} {occurrences} times in the last {time}	\N	It becomes true that "{$trigger$}" has {occurrences/!=|not occurred}{occurrences/=|occurred}{occurrences/>|occurred more than}{occurrences/<|occurred fewer than} {occurrences} times in the last {time}	\N
9	Genre	t	t	{DEVICE} is{genre/!=| not} playing {genre}	Start playing {genre} on {DEVICE}	{DEVICE} {genre/=|starts}{genre/!=|stops} playing {genre}	\N
13	Lock/Unlock	t	t	{DEVICE} is {setting}	{setting/T|Lock}{setting/F|Unlock} {DEVICE}	{DEVICE} {setting/T|Locks}{setting/F|Unlocks}	\N
14	Open/Close Window	t	t	{DEVICE} is {position}	{position/T|Open}{position/F|Close} {DEVICE}	{DEVICE} {position/T|Opens}{position/F|Closes}	\N
15	Detect Motion	t	f	{DEVICE} {status/T|detects}{status/F|does not detect} motion	\N	{DEVICE} {status/T|Starts}{status/F|Stops} Detecting Motion	\N
20	Is it Raining?	t	f	It is {condition}	\N	It {condition/T|starts}{condition/F|stops} raining	\N
35	Play Music	t	t	{name} is {name/!=|not }playing on {DEVICE}	Start playing {name} on {DEVICE}	{name} {name/=|starts}{name/!=|stops} playing on {DEVICE}	\N
49	Previous State	t	f	"{$trigger$}" was active {time} ago	\N	It becomes true that "{$trigger$}" was active {time} ago	\N
51	Time Since State	t	f	For {time/>|at least}{time/<|less than} {time}, the following has been the case: "{$trigger$}" 	\N	{time/=|Exactly} {time} ago, "{$trigger$}" became true and has been the case.	\N
52	Time Since Event	t	f	"{$trigger$}" last happened {time/>|more than}{time/<|less than}{time/=|exactly} {time} ago	\N	It becomes true that "{$trigger$}" last happened {time/>|more than}{time/<|less than}{time/=|exactly} {time} ago	\N
55	Is it Daytime?	t	f	It is {time}time	\N	It becomes {time}time	\N
56	Stop Music	f	t	\N	Stop playing music on {DEVICE}		\N
57	AC On/Off	t	t	The AC is {setting}	Turn {setting} the AC	The AC turns {setting}	\N
58	Open/Close Curtains	t	t	{DEVICE}'s curtains are {position}	{position/T|Open}{position/F|Close} {DEVICE}'s Curtains	{DEVICE}'s curtains {position/T|Open}{position/F|Close}	\N
59	Smoke Detection	t	f	({DEVICE}) {condition/F|No }Smoke is Detected	\N	{DEVICE} {condition/T|Starts}{condition/F|Stops} detecting smoke	\N
60	Open/Close Door	t	t	{DEVICE}'s door is {position}	{position/T|Open}{position/F|Close} {DEVICE}'s Door	{DEVICE}'s door {position/T|Opens}{position/F|Closes}	\N
61	Sleep Sensor	t	f	({DEVICE}) I am {status}	\N	({DEVICE}) I {status/T|Wake Up}{status/F|Fall Asleep}	\N
63	Detect Presence	t	f	{who/!=|Someone other than }{who} is {location/!=|not }in {location}	\N	{who/=|}{who/!=|Someone other than }{who} {location/=|Enters}{location/!=|Exits} {location}	\N
21	Thermostat	t	t	{DEVICE} is {temperature/!=|not set to}{temperature/=|set to}{temperature/>|set above}{temperature/<|set below} {temperature} degrees	Set {DEVICE} to {temperature}	{DEVICE}'s temperature {temperature/=|becomes set to}{temperature/!=|changes from being set to}{temperature/>|becomes set above}{temperature/<|becomes set below} {temperature} degrees	\N
3	Brightness	t	t	{DEVICE}'s Brightness {level/=|is}{level/!=|is not}{level/>|is above}{level/<|is below} {level}	Set {DEVICE}'s Brightness to {level}	{DEVICE}'s brightness {level/=|becomes}{level/!=|stops being}{level/>|goes above}{level/<|falls below} {level}	\N
8	Volume	t	t	{DEVICE}'s Volume {level/=|is}{level/!=|is not}{level/>|is above}{level/<|is below} {level}	Set {DEVICE}'s Volume to {level}	{DEVICE}'s Volume {level/=|becomes}{level/!=|changes from}{level/>|goes above}{level/<|falls below} {level}	\N
25	Clock	t	f	({DEVICE}) The time {time/=|is}{time/!=|is not}{time/>|is after}{time/<|is before} {time}	\N	({DEVICE}) The time {time/=|becomes}{time/!=|changes from}{time/>|becomes later than}{time/<|becomes earlier than} {time}	\N
2	Power On/Off	t	t	{DEVICE} is {setting}	Turn {DEVICE} {setting}	{DEVICE} turns {setting}	\N
66	Temperature Control	t	t	{DEVICE}'s temperature is {temperature/=|set to}{temperature/!=|not set to}{temperature/>|set above}{temperature/<|set below} {temperature} degrees	Set {DEVICE}'s temperature to {temperature}	{DEVICE}'s temperature {temperature/=|becomes set to}{temperature/!=|becomes set to something other than}{temperature/>|becomes set above}{temperature/<|becomes set below} {temperature} degrees	\N
69	Tamper Alert	t	f	{DEVICE} {tamper/T|detect}{tamper/F|does not detect} tamper		{DEVICE} {tamper/T|Starts}{tamper/F|Stops} Detecting tamper	
70	Power Meter	t	f	({DEVICE}) Power is {power/=|exactly}{power/!=|not}{power/>|above}{power/<|below} {power}W		({DEVICE}) Power {power/=|becomes}{power/!=|changes from}{power/>|goes above}{power/<|falls below} {power}W	
71	Ultraviolet Index	t	f	({DEVICE}) Ultraviolet index is {ultravioletIndex/=|exactly}{ultravioletIndex/!=|not}{ultravioletIndex/>|above}{ultravioletIndex/<|below} {ultravioletIndex}		({DEVICE}) Ultraviolet index {ultravioletIndex/=|becomes}{ultravioletIndex/!=|changes from}{ultravioletIndex/>|goes above}{ultravioletIndex/<|falls below} {ultravioletIndex}	
72	Acceleration Sensor	t	f	{DEVICE} {acceleration/T|detects}{acceleration/F|does not detect} vibration		{DEVICE} {acceleration/T|Starts}{acceleration/F|Stops} Detecting Vibration	
73	Contact Sensor	t	f	{DEVICE} Contact sensor is {contact/T|open}{contact/F|closed}		{DEVICE} Contact sensor becomes {contact/T|open}{contact/F|closed}	
68	Illuminance Measurement	t	f	({DEVICE}) Illuminance is {illuminance/=|exactly}{illuminance/!=|not}{illuminance/>|above}{illuminance/<|below} {illuminance} lux		({DEVICE}) Illuminance {illuminance/=|becomes}{illuminance/!=|changes from}{illuminance/>|goes above}{illuminance/<|falls below} {illuminance} lux	
74	Color Temperature	t	t	{DEVICE}'s Color temperature {colorTemperature/=|is}{colorTemperature/!=|is not}{colorTemperature/>|is above}{colorTemperature/<|is below} {colorTemperature}K	Set {DEVICE}'s Color temperature to {colorTemperature}K	{DEVICE}'s Color temperature {colorTemperature/=|becomes}{colorTemperature/!=|stops being}{colorTemperature/>|goes above}{colorTemperature/<|falls below} {colorTemperature}K	
75	Relative Humidity Measurement	t	f	({DEVICE}) Humidity is {humidity/=|exactly}{humidity/!=|not}{humidity/>|above}{humidity/<|below} {humidity}%		({DEVICE}) Humidity {humidity/=|becomes}{humidity/!=|changes from}{humidity/>|goes above}{humidity/<|falls below} {humidity}%	
\.


--
-- Data for Name: backend_capability_channels; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_capability_channels (id, capability_id, channel_id) FROM stdin;
9	2	1
11	3	2
12	6	2
14	8	3
15	9	3
16	12	3
17	13	4
18	14	5
19	8	12
20	15	6
23	18	6
24	18	7
25	19	8
26	19	6
27	20	7
28	21	8
30	25	9
31	26	9
32	27	9
33	28	10
34	29	10
35	30	11
36	31	11
37	31	13
38	32	11
39	33	11
40	35	3
41	36	12
42	37	12
43	38	13
44	39	13
45	40	4
50	49	14
51	50	14
52	51	14
53	52	14
56	55	9
57	56	3
58	21	13
59	57	8
60	58	5
61	59	6
62	2	2
63	2	3
64	2	12
65	2	13
66	60	13
67	60	5
68	61	16
69	61	6
70	62	16
71	62	6
72	63	6
73	63	15
74	64	17
75	64	13
76	65	13
77	19	13
78	66	8
79	66	13
80	2	18
81	13	13
82	13	5
83	68	2
84	68	6
85	69	4
86	69	6
87	70	1
88	71	6
89	71	7
90	72	6
91	73	6
92	74	2
93	75	6
94	75	7
\.


--
-- Name: backend_capability_channels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_capability_channels_id_seq', 94, true);


--
-- Name: backend_capability_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_capability_id_seq', 75, true);


--
-- Data for Name: backend_channel; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_channel (id, name, icon) FROM stdin;
6	Sensors	visibility
7	Weather	filter_drama
8	Temperature	ac_unit
9	Time	access_time
11	Shopping	shopping_cart
12	Television	tv
1	Power	power_settings_new
2	Lights	wb_incandescent
3	Music	library_music
4	Security	lock
15	Location	room
14	History	hourglass_empty
17	Water & Plumbing	local_drink
5	Windows & Doors	meeting_room
16	Health	favorite_border
10	Camera	photo_camera
13	Food & Cooking	fastfood
18	Cleaning	build
\.


--
-- Name: backend_channel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_channel_id_seq', 18, true);


--
-- Data for Name: backend_colorparam; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_colorparam (parameter_ptr_id, mode) FROM stdin;
83	hsv
\.


--
-- Data for Name: backend_condition; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_condition (id, val, comp, par_id, trigger_id) FROM stdin;
\.


--
-- Name: backend_condition_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_condition_id_seq', 1, false);


--
-- Data for Name: backend_device; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_device (id, public, dev_type, name, icon, location_id, is_subscribed, label) FROM stdin;
\.


--
-- Data for Name: backend_device_caps; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_device_caps (id, device_id, capability_id) FROM stdin;
\.


--
-- Name: backend_device_caps_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_device_caps_id_seq', 1, false);


--
-- Data for Name: backend_device_chans; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_device_chans (id, device_id, channel_id) FROM stdin;
\.


--
-- Name: backend_device_chans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_device_chans_id_seq', 1, false);


--
-- Name: backend_device_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_device_id_seq', 1, false);


--
-- Data for Name: backend_device_users; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_device_users (id, device_id, user_id) FROM stdin;
\.


--
-- Name: backend_device_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_device_users_id_seq', 1, false);


--
-- Data for Name: backend_durationparam; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_durationparam (parameter_ptr_id, comp, maxhours, maxmins, maxsecs) FROM stdin;
51	f	23	59	59
53	f	23	59	59
56	t	23	59	59
58	t	23	59	59
\.


--
-- Data for Name: backend_errorlog; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_errorlog (id, function, err, created) FROM stdin;
\.


--
-- Name: backend_errorlog_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_errorlog_id_seq', 1, false);


--
-- Data for Name: backend_esrule; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_esrule (rule_ptr_id, "Etrigger_id", action_id) FROM stdin;
\.


--
-- Data for Name: backend_esrule_Striggers; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public."backend_esrule_Striggers" (id, esrule_id, trigger_id) FROM stdin;
\.


--
-- Name: backend_esrule_Striggers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public."backend_esrule_Striggers_id_seq"', 1, false);


--
-- Data for Name: backend_inputparam; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_inputparam (parameter_ptr_id, inputtype) FROM stdin;
27	stxt
28	int
31	int
32	stxt
34	stxt
35	stxt
37	stxt
\.


--
-- Data for Name: backend_location; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_location (id, st_loc_id, name, st_installed_app_id, lat, lon) FROM stdin;
\.


--
-- Name: backend_location_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_location_id_seq', 1, false);


--
-- Data for Name: backend_location_users; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_location_users (id, location_id, user_id) FROM stdin;
\.


--
-- Name: backend_location_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_location_users_id_seq', 1, false);


--
-- Data for Name: backend_locationvirtualdevices; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_locationvirtualdevices (id, clock_dev_id, location_id, weather_dev_id) FROM stdin;
\.


--
-- Name: backend_locationvirtualdevices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_locationvirtualdevices_id_seq', 1, false);


--
-- Data for Name: backend_metaparam; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_metaparam (parameter_ptr_id, is_event) FROM stdin;
50	f
52	t
55	f
57	t
\.


--
-- Data for Name: backend_parameter; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_parameter (id, name, sysname, is_command, is_main_param, type, cap_id) FROM stdin;
17	weather	\N	\N	\N	set	18
11	frequency	\N	\N	\N	range	12
24	time	\N	\N	\N	time	26
25	value	\N	\N	\N	bin	27
26	value	\N	\N	\N	bin	28
28	quantity	\N	\N	\N	input	30
30	topping	\N	\N	\N	set	31
31	quantity	\N	\N	\N	input	31
33	distance	\N	\N	\N	range	32
34	item	\N	\N	\N	input	33
35	name	\N	\N	\N	input	35
37	name	\N	\N	\N	input	37
39	cups	\N	\N	\N	range	39
40	value	\N	\N	\N	bin	40
50	trigger	\N	\N	\N	meta	49
51	time	\N	\N	\N	duration	49
52	trigger	\N	\N	\N	meta	50
53	time	\N	\N	\N	duration	50
54	occurrences	\N	\N	\N	range	50
55	trigger	\N	\N	\N	meta	51
56	time	\N	\N	\N	duration	51
57	trigger	\N	\N	\N	meta	52
58	time	\N	\N	\N	duration	52
69	BPM	\N	\N	\N	range	62
71	who	\N	\N	\N	set	63
27	item	\N	\N	\N	input	30
73	cups	\N	\N	\N	range	38
74	temperature	\N	\N	\N	range	65
21	temperature	\N	\N	\N	range	21
29	size	\N	\N	\N	set	31
75	temperature	\N	\N	\N	range	66
70	location	\N	\N	\N	set	63
32	trackingid	\N	\N	\N	input	32
8	genre	\N	\N	\N	set	9
12	setting	\N	\N	\N	bin	13
13	position	\N	\N	\N	bin	14
20	condition	\N	\N	\N	bin	20
23	time	\N	\N	\N	time	25
62	time	\N	\N	\N	bin	55
64	setting	\N	\N	\N	bin	57
65	position	\N	\N	\N	bin	58
67	position	\N	\N	\N	bin	60
68	status	\N	\N	\N	bin	61
72	setting	\N	\N	\N	bin	64
1	setting	switch	\N	\N	bin	2
2	level	level	\N	\N	range	3
7	level	volume	\N	\N	range	8
14	status	motion	\N	\N	bin	15
36	channel	tvChannel	\N	\N	range	36
66	condition	smoke	\N	\N	bin	59
18	temperature	temperature	\N	\N	range	19
77	illuminance	illuminance	\N	\N	range	68
78	tamper	tamper	\N	\N	bin	69
79	power	power	\N	\N	range	70
80	ultravioletIndex	ultravioletIndex	\N	\N	range	71
81	acceleration	acceleration	\N	\N	bin	72
82	contact	contact	\N	\N	bin	73
83	color	color	\N	\N	color	6
84	colorTemperature	colorTemperature	\N	\N	range	74
85	humidity	humidity	\N	\N	range	75
\.


--
-- Name: backend_parameter_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_parameter_id_seq', 85, true);


--
-- Data for Name: backend_parval; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_parval (id, val, par_id, state_id) FROM stdin;
\.


--
-- Name: backend_parval_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_parval_id_seq', 1, false);


--
-- Data for Name: backend_parvalmapping; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_parvalmapping (id, st_val, val, param_id) FROM stdin;
1	on	On	1
2	off	Off	1
3	active	Motion	14
4	inactive	No Motion	14
5	clear	No Smoke Detected	66
6	detected	Smoke Detected	66
7	clear	clear	78
8	detected	detected	78
9	active	active	81
10	inactive	inactive	81
11	open	open	82
12	closed	closed	82
\.


--
-- Name: backend_parvalmapping_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_parvalmapping_id_seq', 12, true);


--
-- Data for Name: backend_rangeparam; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_rangeparam (parameter_ptr_id, min, max, "interval") FROM stdin;
2	1	5	1
7	0	100	1
11	88	108	0.100000000000000006
18	-50	120	1
21	60	90	1
33	1	250	1
36	0	2000	1
39	1	5	1
54	0	25	1
69	40	220	5
73	0	5	1
74	0	600	5
75	20	60	1
77	0	5000	1
79	0	1000	0.5
80	0	255	1
84	2000	6500	1
85	0	100	1
\.


--
-- Data for Name: backend_rule; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_rule (id, st_installed_app_id, task, lastedit, type, owner_id, st_owner_id) FROM stdin;
\.


--
-- Name: backend_rule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_rule_id_seq', 1, false);


--
-- Data for Name: backend_safetyprop; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_safetyprop (id, task, lastedit, type, always, owner_id) FROM stdin;
\.


--
-- Name: backend_safetyprop_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_safetyprop_id_seq', 1, false);


--
-- Data for Name: backend_setparam; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_setparam (parameter_ptr_id, numopts) FROM stdin;
8	7
17	15
29	3
30	8
70	5
71	3
\.


--
-- Data for Name: backend_setparamopt; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_setparamopt (id, value, param_id) FROM stdin;
7	Pop	8
8	Jazz	8
9	R&B	8
10	Hip-Hop	8
11	Rap	8
12	Country	8
13	News	8
14	Drizzle	17
15	Clouds	17
16	Mist	17
17	Rain	17
18	Thunderstorm	17
19	Snow	17
20	Smoke	17
21	Clear	17
24	Small	29
25	Medium	29
26	Large	29
27	No Toppings	30
28	Pepperoni	30
29	Vegetables	30
30	Sausage	30
31	Mushrooms	30
32	Ham & Pineapple	30
33	Extra Cheese	30
34	Anchovies	30
35	Home	70
36	Kitchen	70
37	Bedroom	70
38	Bathroom	70
39	Living Room	70
40	Anyone	71
41	Alice	71
42	Bobbie	71
44	A Family Member	71
43	A Guest	71
45	Nobody	71
46	Haze	17
47	Dust	17
48	Fog	17
49	Sand	17
50	Ash	17
51	Squall	17
52	Tornado	17
\.


--
-- Name: backend_setparamopt_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_setparamopt_id_seq', 52, true);


--
-- Data for Name: backend_sp1; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_sp1 (safetyprop_ptr_id) FROM stdin;
\.


--
-- Data for Name: backend_sp1_triggers; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_sp1_triggers (id, sp1_id, trigger_id) FROM stdin;
\.


--
-- Name: backend_sp1_triggers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_sp1_triggers_id_seq', 1, false);


--
-- Data for Name: backend_sp2; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_sp2 (safetyprop_ptr_id, comp, "time", state_id) FROM stdin;
\.


--
-- Data for Name: backend_sp2_conds; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_sp2_conds (id, sp2_id, trigger_id) FROM stdin;
\.


--
-- Name: backend_sp2_conds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_sp2_conds_id_seq', 1, false);


--
-- Data for Name: backend_sp3; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_sp3 (safetyprop_ptr_id, comp, occurrences, "time", timecomp, event_id) FROM stdin;
\.


--
-- Data for Name: backend_sp3_conds; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_sp3_conds (id, sp3_id, trigger_id) FROM stdin;
\.


--
-- Name: backend_sp3_conds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_sp3_conds_id_seq', 1, false);


--
-- Data for Name: backend_ssrule; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_ssrule (rule_ptr_id, priority, action_id) FROM stdin;
\.


--
-- Data for Name: backend_ssrule_triggers; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_ssrule_triggers (id, ssrule_id, trigger_id) FROM stdin;
\.


--
-- Name: backend_ssrule_triggers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_ssrule_triggers_id_seq', 1, false);


--
-- Data for Name: backend_state; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_state (id, action, text, cap_id, chan_id, dev_id) FROM stdin;
\.


--
-- Name: backend_state_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_state_id_seq', 1, false);


--
-- Data for Name: backend_statelog; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_statelog (id, "timestamp", status, value, value_type, is_superifttt, cap_id, dev_id, param_id) FROM stdin;
\.


--
-- Name: backend_statelog_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_statelog_id_seq', 1, false);


--
-- Data for Name: backend_stcapability; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_stcapability (id, name, command_type) FROM stdin;
5	motionSensor	\N
7	smokeDetector	\N
1	switch	enum_type_1
2	switchLevel	enum_type_2
3	colorControl	color_type
4	audioVolume	enum_type_2
6	tvChannel	enum_type_2
8	temperatureMeasurement	enum_type_2
9	illuminanceMeasurement	enum_type_2
10	tamperAlert	enum_type_1
11	powerMeter	enum_type_2
12	ultravioletIndex	enum_type_2
13	accelerationSensor	enum_type_1
14	contactSensor	enum_type_1
15	colorTemperature	enum_type_2
16	relativeHumidityMeasurement	enum_type_2
\.


--
-- Data for Name: backend_stcapability_capabilities; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_stcapability_capabilities (id, stcapability_id, capability_id) FROM stdin;
1	1	2
2	2	3
3	3	6
4	4	8
5	5	15
6	6	36
7	7	59
8	8	19
9	9	68
10	10	69
11	11	70
12	12	71
13	13	72
14	14	73
15	15	74
16	16	75
\.


--
-- Name: backend_stcapability_capabilities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_stcapability_capabilities_id_seq', 16, true);


--
-- Name: backend_stcapability_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_stcapability_id_seq', 16, true);


--
-- Data for Name: backend_timeparam; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_timeparam (parameter_ptr_id, mode) FROM stdin;
23	12
24	24
\.


--
-- Data for Name: backend_trigger; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_trigger (id, pos, text, cap_id, chan_id, dev_id) FROM stdin;
\.


--
-- Name: backend_trigger_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_trigger_id_seq', 1, false);


--
-- Data for Name: backend_user_icse19; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_user_icse19 (id, name, code, mode) FROM stdin;
\.


--
-- Name: backend_user_icse19_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_user_icse19_id_seq', 1, false);


--
-- Data for Name: backend_userprofile; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.backend_userprofile (id, access_token, access_token_expired_at, refresh_token, user_id, stapp_id) FROM stdin;
\.


--
-- Name: backend_userprofile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.backend_userprofile_id_seq', 4, true);


--
-- Data for Name: currentweather_weatherlog; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.currentweather_weatherlog (id, created, cityname, latitude, longitude, temp, humidity, condition, cond_code, long_desc, sunrise, sunset) FROM stdin;
\.


--
-- Name: currentweather_weatherlog_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.currentweather_weatherlog_id_seq', 1, false);


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
\.


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 25, true);


--
-- Data for Name: django_celery_beat_clockedschedule; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.django_celery_beat_clockedschedule (id, clocked_time, enabled) FROM stdin;
\.


--
-- Name: django_celery_beat_clockedschedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.django_celery_beat_clockedschedule_id_seq', 1, false);


--
-- Data for Name: django_celery_beat_crontabschedule; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.django_celery_beat_crontabschedule (id, minute, hour, day_of_week, day_of_month, month_of_year, timezone) FROM stdin;
1	0	4	*	*	*	UTC
2	*	*	*	*	*	UTC
\.


--
-- Name: django_celery_beat_crontabschedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.django_celery_beat_crontabschedule_id_seq', 2, true);


--
-- Data for Name: django_celery_beat_intervalschedule; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.django_celery_beat_intervalschedule (id, every, period) FROM stdin;
\.


--
-- Name: django_celery_beat_intervalschedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.django_celery_beat_intervalschedule_id_seq', 1, false);


--
-- Data for Name: django_celery_beat_periodictask; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.django_celery_beat_periodictask (id, name, task, args, kwargs, queue, exchange, routing_key, expires, enabled, last_run_at, total_run_count, date_changed, description, crontab_id, interval_id, solar_id, one_off, start_time, priority, headers, clocked_id) FROM stdin;
1	celery.backend_cleanup	celery.backend_cleanup	[]	{}	\N	\N	\N	\N	t	\N	0	2019-10-14 14:40:04.487517+00		1	\N	\N	f	\N	\N	{}	\N
3	record_current_weather	currentweather.tasks.record_current_weather	[]	{}	\N	\N	\N	\N	t	2019-10-14 14:49:00.006751+00	9	2019-10-14 14:49:20.09134+00		2	\N	\N	f	\N	\N	{}	\N
2	record_check_timer	celery_workers.tasks.check_current_timer	[]	{}	\N	\N	\N	\N	t	2019-10-14 14:49:00.012643+00	9	2019-10-14 14:49:20.113048+00		2	\N	\N	f	\N	\N	{}	\N
\.


--
-- Name: django_celery_beat_periodictask_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.django_celery_beat_periodictask_id_seq', 3, true);


--
-- Data for Name: django_celery_beat_periodictasks; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.django_celery_beat_periodictasks (ident, last_update) FROM stdin;
1	2019-10-14 14:40:04.511993+00
\.


--
-- Data for Name: django_celery_beat_solarschedule; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.django_celery_beat_solarschedule (id, event, latitude, longitude) FROM stdin;
\.


--
-- Name: django_celery_beat_solarschedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.django_celery_beat_solarschedule_id_seq', 1, false);


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	user
3	auth	group
4	auth	permission
5	contenttypes	contenttype
6	sessions	session
7	oauth2_provider	application
8	oauth2_provider	refreshtoken
9	oauth2_provider	accesstoken
10	oauth2_provider	grant
11	user_auth	usermetadata
12	backend	parameter
13	backend	sp3
14	backend	user_icse19
15	backend	condition
16	backend	location
17	backend	sp1
18	backend	safetyprop
19	backend	device
20	backend	rule
21	backend	binparam
22	backend	ssrule
23	backend	sp2
24	backend	errorlog
25	backend	inputparam
26	backend	userprofile
27	backend	channel
28	backend	trigger
29	backend	state
30	backend	durationparam
31	backend	colorparam
32	backend	statelog
33	backend	parval
34	backend	rangeparam
35	backend	metaparam
36	backend	esrule
37	backend	capability
38	backend	setparamopt
39	backend	setparam
40	backend	actionparval
41	backend	timeparam
42	backend	stcapability
43	backend	actioncondition
44	backend	action
45	backend	parvalmapping
46	backend	locationvirtualdevices
47	django_celery_beat	clockedschedule
48	django_celery_beat	intervalschedule
49	django_celery_beat	periodictasks
50	django_celery_beat	solarschedule
51	django_celery_beat	periodictask
52	django_celery_beat	crontabschedule
53	currentweather	weatherlog
\.


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 53, true);


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
45	contenttypes	0001_initial	2019-10-14 14:42:13.941622+00
46	auth	0001_initial	2019-10-14 14:42:13.944992+00
47	admin	0001_initial	2019-10-14 14:42:13.946877+00
48	admin	0002_logentry_remove_auto_add	2019-10-14 14:42:13.948662+00
49	admin	0003_logentry_add_action_flag_choices	2019-10-14 14:42:13.950495+00
50	contenttypes	0002_remove_content_type_name	2019-10-14 14:42:13.952453+00
51	auth	0002_alter_permission_name_max_length	2019-10-14 14:42:13.954254+00
52	auth	0003_alter_user_email_max_length	2019-10-14 14:42:13.956054+00
53	auth	0004_alter_user_username_opts	2019-10-14 14:42:13.957891+00
54	auth	0005_alter_user_last_login_null	2019-10-14 14:42:13.959386+00
55	auth	0006_require_contenttypes_0002	2019-10-14 14:42:13.960938+00
56	auth	0007_alter_validators_add_error_messages	2019-10-14 14:42:13.962401+00
57	auth	0008_alter_user_username_max_length	2019-10-14 14:42:13.963872+00
58	auth	0009_alter_user_last_name_max_length	2019-10-14 14:42:13.965482+00
59	auth	0010_alter_group_name_max_length	2019-10-14 14:42:13.967056+00
60	auth	0011_update_proxy_permissions	2019-10-14 14:42:13.968596+00
61	django_celery_beat	0001_initial	2019-10-14 14:42:13.970128+00
62	django_celery_beat	0002_auto_20161118_0346	2019-10-14 14:42:13.971599+00
63	django_celery_beat	0003_auto_20161209_0049	2019-10-14 14:42:13.97312+00
64	django_celery_beat	0004_auto_20170221_0000	2019-10-14 14:42:13.974733+00
65	django_celery_beat	0005_add_solarschedule_events_choices	2019-10-14 14:42:13.976348+00
66	django_celery_beat	0006_auto_20180322_0932	2019-10-14 14:42:13.977968+00
67	django_celery_beat	0007_auto_20180521_0826	2019-10-14 14:42:13.979459+00
68	django_celery_beat	0008_auto_20180914_1922	2019-10-14 14:42:13.980878+00
69	django_celery_beat	0006_auto_20180210_1226	2019-10-14 14:42:13.982586+00
70	django_celery_beat	0006_periodictask_priority	2019-10-14 14:42:13.984629+00
71	django_celery_beat	0009_periodictask_headers	2019-10-14 14:42:13.9862+00
72	django_celery_beat	0010_auto_20190429_0326	2019-10-14 14:42:13.987843+00
73	django_celery_beat	0011_auto_20190508_0153	2019-10-14 14:42:13.989508+00
74	oauth2_provider	0001_initial	2019-10-14 14:42:13.991206+00
75	oauth2_provider	0002_08_updates	2019-10-14 14:42:13.992811+00
76	oauth2_provider	0003_auto_20160316_1503	2019-10-14 14:42:13.994532+00
77	oauth2_provider	0004_auto_20160525_1623	2019-10-14 14:42:13.996124+00
78	oauth2_provider	0005_auto_20170514_1141	2019-10-14 14:42:13.997702+00
79	oauth2_provider	0006_auto_20171214_2232	2019-10-14 14:42:13.999369+00
80	sessions	0001_initial	2019-10-14 14:42:14.001028+00
81	backend	0001_initial	2019-10-14 14:43:50.544499+00
82	currentweather	0001_initial	2019-10-14 14:43:50.561149+00
83	user_auth	0001_initial	2019-10-14 14:43:50.612714+00
\.


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 83, true);


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
\.


--
-- Data for Name: oauth2_provider_accesstoken; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.oauth2_provider_accesstoken (id, token, expires, scope, application_id, user_id, created, updated, source_refresh_token_id) FROM stdin;
\.


--
-- Name: oauth2_provider_accesstoken_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.oauth2_provider_accesstoken_id_seq', 1, false);


--
-- Data for Name: oauth2_provider_application; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.oauth2_provider_application (id, client_id, redirect_uris, client_type, authorization_grant_type, client_secret, name, user_id, skip_authorization, created, updated) FROM stdin;
\.


--
-- Name: oauth2_provider_application_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.oauth2_provider_application_id_seq', 1, false);


--
-- Data for Name: oauth2_provider_grant; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.oauth2_provider_grant (id, code, expires, redirect_uri, scope, application_id, user_id, created, updated) FROM stdin;
\.


--
-- Name: oauth2_provider_grant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.oauth2_provider_grant_id_seq', 1, false);


--
-- Data for Name: oauth2_provider_refreshtoken; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.oauth2_provider_refreshtoken (id, token, access_token_id, application_id, user_id, created, updated, revoked) FROM stdin;
\.


--
-- Name: oauth2_provider_refreshtoken_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.oauth2_provider_refreshtoken_id_seq', 1, false);


--
-- Data for Name: user_auth_usermetadata; Type: TABLE DATA; Schema: public; Owner: iftttuser
--

COPY public.user_auth_usermetadata (id, user_id) FROM stdin;
\.


--
-- Name: user_auth_usermetadata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: iftttuser
--

SELECT pg_catalog.setval('public.user_auth_usermetadata_id_seq', 1, false);


--
-- Name: auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- Name: auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- Name: auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: backend_action_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_action
    ADD CONSTRAINT backend_action_pkey PRIMARY KEY (id);


--
-- Name: backend_actioncondition_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_actioncondition
    ADD CONSTRAINT backend_actioncondition_pkey PRIMARY KEY (id);


--
-- Name: backend_actionparval_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_actionparval
    ADD CONSTRAINT backend_actionparval_pkey PRIMARY KEY (id);


--
-- Name: backend_binparam_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_binparam
    ADD CONSTRAINT backend_binparam_pkey PRIMARY KEY (parameter_ptr_id);


--
-- Name: backend_capability_chann_capability_id_channel_id_131031e1_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_capability_channels
    ADD CONSTRAINT backend_capability_chann_capability_id_channel_id_131031e1_uniq UNIQUE (capability_id, channel_id);


--
-- Name: backend_capability_channels_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_capability_channels
    ADD CONSTRAINT backend_capability_channels_pkey PRIMARY KEY (id);


--
-- Name: backend_capability_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_capability
    ADD CONSTRAINT backend_capability_pkey PRIMARY KEY (id);


--
-- Name: backend_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_channel
    ADD CONSTRAINT backend_channel_pkey PRIMARY KEY (id);


--
-- Name: backend_colorparam_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_colorparam
    ADD CONSTRAINT backend_colorparam_pkey PRIMARY KEY (parameter_ptr_id);


--
-- Name: backend_condition_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_condition
    ADD CONSTRAINT backend_condition_pkey PRIMARY KEY (id);


--
-- Name: backend_device_caps_device_id_capability_id_e4bb98c0_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_device_caps
    ADD CONSTRAINT backend_device_caps_device_id_capability_id_e4bb98c0_uniq UNIQUE (device_id, capability_id);


--
-- Name: backend_device_caps_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_device_caps
    ADD CONSTRAINT backend_device_caps_pkey PRIMARY KEY (id);


--
-- Name: backend_device_chans_device_id_channel_id_d581e087_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_device_chans
    ADD CONSTRAINT backend_device_chans_device_id_channel_id_d581e087_uniq UNIQUE (device_id, channel_id);


--
-- Name: backend_device_chans_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_device_chans
    ADD CONSTRAINT backend_device_chans_pkey PRIMARY KEY (id);


--
-- Name: backend_device_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_device
    ADD CONSTRAINT backend_device_pkey PRIMARY KEY (id);


--
-- Name: backend_device_users_device_id_user_id_5c293a68_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_device_users
    ADD CONSTRAINT backend_device_users_device_id_user_id_5c293a68_uniq UNIQUE (device_id, user_id);


--
-- Name: backend_device_users_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_device_users
    ADD CONSTRAINT backend_device_users_pkey PRIMARY KEY (id);


--
-- Name: backend_durationparam_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_durationparam
    ADD CONSTRAINT backend_durationparam_pkey PRIMARY KEY (parameter_ptr_id);


--
-- Name: backend_errorlog_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_errorlog
    ADD CONSTRAINT backend_errorlog_pkey PRIMARY KEY (id);


--
-- Name: backend_esrule_Striggers_esrule_id_trigger_id_ea5826a3_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public."backend_esrule_Striggers"
    ADD CONSTRAINT "backend_esrule_Striggers_esrule_id_trigger_id_ea5826a3_uniq" UNIQUE (esrule_id, trigger_id);


--
-- Name: backend_esrule_Striggers_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public."backend_esrule_Striggers"
    ADD CONSTRAINT "backend_esrule_Striggers_pkey" PRIMARY KEY (id);


--
-- Name: backend_esrule_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_esrule
    ADD CONSTRAINT backend_esrule_pkey PRIMARY KEY (rule_ptr_id);


--
-- Name: backend_inputparam_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_inputparam
    ADD CONSTRAINT backend_inputparam_pkey PRIMARY KEY (parameter_ptr_id);


--
-- Name: backend_location_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_location
    ADD CONSTRAINT backend_location_pkey PRIMARY KEY (id);


--
-- Name: backend_location_users_location_id_user_id_14709016_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_location_users
    ADD CONSTRAINT backend_location_users_location_id_user_id_14709016_uniq UNIQUE (location_id, user_id);


--
-- Name: backend_location_users_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_location_users
    ADD CONSTRAINT backend_location_users_pkey PRIMARY KEY (id);


--
-- Name: backend_locationvirtualdevices_location_id_key; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_locationvirtualdevices
    ADD CONSTRAINT backend_locationvirtualdevices_location_id_key UNIQUE (location_id);


--
-- Name: backend_locationvirtualdevices_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_locationvirtualdevices
    ADD CONSTRAINT backend_locationvirtualdevices_pkey PRIMARY KEY (id);


--
-- Name: backend_metaparam_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_metaparam
    ADD CONSTRAINT backend_metaparam_pkey PRIMARY KEY (parameter_ptr_id);


--
-- Name: backend_parameter_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_parameter
    ADD CONSTRAINT backend_parameter_pkey PRIMARY KEY (id);


--
-- Name: backend_parval_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_parval
    ADD CONSTRAINT backend_parval_pkey PRIMARY KEY (id);


--
-- Name: backend_parvalmapping_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_parvalmapping
    ADD CONSTRAINT backend_parvalmapping_pkey PRIMARY KEY (id);


--
-- Name: backend_rangeparam_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_rangeparam
    ADD CONSTRAINT backend_rangeparam_pkey PRIMARY KEY (parameter_ptr_id);


--
-- Name: backend_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_rule
    ADD CONSTRAINT backend_rule_pkey PRIMARY KEY (id);


--
-- Name: backend_safetyprop_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_safetyprop
    ADD CONSTRAINT backend_safetyprop_pkey PRIMARY KEY (id);


--
-- Name: backend_setparam_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_setparam
    ADD CONSTRAINT backend_setparam_pkey PRIMARY KEY (parameter_ptr_id);


--
-- Name: backend_setparamopt_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_setparamopt
    ADD CONSTRAINT backend_setparamopt_pkey PRIMARY KEY (id);


--
-- Name: backend_sp1_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp1
    ADD CONSTRAINT backend_sp1_pkey PRIMARY KEY (safetyprop_ptr_id);


--
-- Name: backend_sp1_triggers_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp1_triggers
    ADD CONSTRAINT backend_sp1_triggers_pkey PRIMARY KEY (id);


--
-- Name: backend_sp1_triggers_sp1_id_trigger_id_8b45f99b_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp1_triggers
    ADD CONSTRAINT backend_sp1_triggers_sp1_id_trigger_id_8b45f99b_uniq UNIQUE (sp1_id, trigger_id);


--
-- Name: backend_sp2_conds_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp2_conds
    ADD CONSTRAINT backend_sp2_conds_pkey PRIMARY KEY (id);


--
-- Name: backend_sp2_conds_sp2_id_trigger_id_8df7a647_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp2_conds
    ADD CONSTRAINT backend_sp2_conds_sp2_id_trigger_id_8df7a647_uniq UNIQUE (sp2_id, trigger_id);


--
-- Name: backend_sp2_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp2
    ADD CONSTRAINT backend_sp2_pkey PRIMARY KEY (safetyprop_ptr_id);


--
-- Name: backend_sp3_conds_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp3_conds
    ADD CONSTRAINT backend_sp3_conds_pkey PRIMARY KEY (id);


--
-- Name: backend_sp3_conds_sp3_id_trigger_id_472a7be0_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp3_conds
    ADD CONSTRAINT backend_sp3_conds_sp3_id_trigger_id_472a7be0_uniq UNIQUE (sp3_id, trigger_id);


--
-- Name: backend_sp3_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp3
    ADD CONSTRAINT backend_sp3_pkey PRIMARY KEY (safetyprop_ptr_id);


--
-- Name: backend_ssrule_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_ssrule
    ADD CONSTRAINT backend_ssrule_pkey PRIMARY KEY (rule_ptr_id);


--
-- Name: backend_ssrule_triggers_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_ssrule_triggers
    ADD CONSTRAINT backend_ssrule_triggers_pkey PRIMARY KEY (id);


--
-- Name: backend_ssrule_triggers_ssrule_id_trigger_id_133318d9_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_ssrule_triggers
    ADD CONSTRAINT backend_ssrule_triggers_ssrule_id_trigger_id_133318d9_uniq UNIQUE (ssrule_id, trigger_id);


--
-- Name: backend_state_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_state
    ADD CONSTRAINT backend_state_pkey PRIMARY KEY (id);


--
-- Name: backend_statelog_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_statelog
    ADD CONSTRAINT backend_statelog_pkey PRIMARY KEY (id);


--
-- Name: backend_stcapability_cap_stcapability_id_capabili_a2995239_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_stcapability_capabilities
    ADD CONSTRAINT backend_stcapability_cap_stcapability_id_capabili_a2995239_uniq UNIQUE (stcapability_id, capability_id);


--
-- Name: backend_stcapability_capabilities_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_stcapability_capabilities
    ADD CONSTRAINT backend_stcapability_capabilities_pkey PRIMARY KEY (id);


--
-- Name: backend_stcapability_name_key; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_stcapability
    ADD CONSTRAINT backend_stcapability_name_key UNIQUE (name);


--
-- Name: backend_stcapability_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_stcapability
    ADD CONSTRAINT backend_stcapability_pkey PRIMARY KEY (id);


--
-- Name: backend_timeparam_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_timeparam
    ADD CONSTRAINT backend_timeparam_pkey PRIMARY KEY (parameter_ptr_id);


--
-- Name: backend_trigger_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_trigger
    ADD CONSTRAINT backend_trigger_pkey PRIMARY KEY (id);


--
-- Name: backend_user_icse19_name_key; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_user_icse19
    ADD CONSTRAINT backend_user_icse19_name_key UNIQUE (name);


--
-- Name: backend_user_icse19_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_user_icse19
    ADD CONSTRAINT backend_user_icse19_pkey PRIMARY KEY (id);


--
-- Name: backend_userprofile_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_userprofile
    ADD CONSTRAINT backend_userprofile_pkey PRIMARY KEY (id);


--
-- Name: backend_userprofile_user_id_key; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_userprofile
    ADD CONSTRAINT backend_userprofile_user_id_key UNIQUE (user_id);


--
-- Name: currentweather_weatherlog_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.currentweather_weatherlog
    ADD CONSTRAINT currentweather_weatherlog_pkey PRIMARY KEY (id);


--
-- Name: django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_celery_beat_clockedschedule_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_celery_beat_clockedschedule
    ADD CONSTRAINT django_celery_beat_clockedschedule_pkey PRIMARY KEY (id);


--
-- Name: django_celery_beat_crontabschedule_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_celery_beat_crontabschedule
    ADD CONSTRAINT django_celery_beat_crontabschedule_pkey PRIMARY KEY (id);


--
-- Name: django_celery_beat_intervalschedule_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_celery_beat_intervalschedule
    ADD CONSTRAINT django_celery_beat_intervalschedule_pkey PRIMARY KEY (id);


--
-- Name: django_celery_beat_periodictask_name_key; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_celery_beat_periodictask
    ADD CONSTRAINT django_celery_beat_periodictask_name_key UNIQUE (name);


--
-- Name: django_celery_beat_periodictask_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_celery_beat_periodictask
    ADD CONSTRAINT django_celery_beat_periodictask_pkey PRIMARY KEY (id);


--
-- Name: django_celery_beat_periodictasks_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_celery_beat_periodictasks
    ADD CONSTRAINT django_celery_beat_periodictasks_pkey PRIMARY KEY (ident);


--
-- Name: django_celery_beat_solar_event_latitude_longitude_ba64999a_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_celery_beat_solarschedule
    ADD CONSTRAINT django_celery_beat_solar_event_latitude_longitude_ba64999a_uniq UNIQUE (event, latitude, longitude);


--
-- Name: django_celery_beat_solarschedule_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_celery_beat_solarschedule
    ADD CONSTRAINT django_celery_beat_solarschedule_pkey PRIMARY KEY (id);


--
-- Name: django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: oauth2_provider_accesstoken_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.oauth2_provider_accesstoken
    ADD CONSTRAINT oauth2_provider_accesstoken_pkey PRIMARY KEY (id);


--
-- Name: oauth2_provider_accesstoken_source_refresh_token_id_key; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.oauth2_provider_accesstoken
    ADD CONSTRAINT oauth2_provider_accesstoken_source_refresh_token_id_key UNIQUE (source_refresh_token_id);


--
-- Name: oauth2_provider_accesstoken_token_8af090f8_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.oauth2_provider_accesstoken
    ADD CONSTRAINT oauth2_provider_accesstoken_token_8af090f8_uniq UNIQUE (token);


--
-- Name: oauth2_provider_application_client_id_key; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.oauth2_provider_application
    ADD CONSTRAINT oauth2_provider_application_client_id_key UNIQUE (client_id);


--
-- Name: oauth2_provider_application_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.oauth2_provider_application
    ADD CONSTRAINT oauth2_provider_application_pkey PRIMARY KEY (id);


--
-- Name: oauth2_provider_grant_code_49ab4ddf_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.oauth2_provider_grant
    ADD CONSTRAINT oauth2_provider_grant_code_49ab4ddf_uniq UNIQUE (code);


--
-- Name: oauth2_provider_grant_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.oauth2_provider_grant
    ADD CONSTRAINT oauth2_provider_grant_pkey PRIMARY KEY (id);


--
-- Name: oauth2_provider_refreshtoken_access_token_id_key; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.oauth2_provider_refreshtoken
    ADD CONSTRAINT oauth2_provider_refreshtoken_access_token_id_key UNIQUE (access_token_id);


--
-- Name: oauth2_provider_refreshtoken_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.oauth2_provider_refreshtoken
    ADD CONSTRAINT oauth2_provider_refreshtoken_pkey PRIMARY KEY (id);


--
-- Name: oauth2_provider_refreshtoken_token_revoked_af8a5134_uniq; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.oauth2_provider_refreshtoken
    ADD CONSTRAINT oauth2_provider_refreshtoken_token_revoked_af8a5134_uniq UNIQUE (token, revoked);


--
-- Name: user_auth_usermetadata_pkey; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.user_auth_usermetadata
    ADD CONSTRAINT user_auth_usermetadata_pkey PRIMARY KEY (id);


--
-- Name: user_auth_usermetadata_user_id_key; Type: CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.user_auth_usermetadata
    ADD CONSTRAINT user_auth_usermetadata_user_id_key UNIQUE (user_id);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- Name: backend_action_cap_id_6e082aa0; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_action_cap_id_6e082aa0 ON public.backend_action USING btree (cap_id);


--
-- Name: backend_action_chan_id_4f0af261; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_action_chan_id_4f0af261 ON public.backend_action USING btree (chan_id);


--
-- Name: backend_action_dev_id_52625625; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_action_dev_id_52625625 ON public.backend_action USING btree (dev_id);


--
-- Name: backend_actioncondition_action_id_730289f7; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_actioncondition_action_id_730289f7 ON public.backend_actioncondition USING btree (action_id);


--
-- Name: backend_actioncondition_par_id_16268af4; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_actioncondition_par_id_16268af4 ON public.backend_actioncondition USING btree (par_id);


--
-- Name: backend_actionparval_par_id_71518a37; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_actionparval_par_id_71518a37 ON public.backend_actionparval USING btree (par_id);


--
-- Name: backend_actionparval_state_id_378a1fb8; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_actionparval_state_id_378a1fb8 ON public.backend_actionparval USING btree (state_id);


--
-- Name: backend_capability_channels_capability_id_1bccd6c0; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_capability_channels_capability_id_1bccd6c0 ON public.backend_capability_channels USING btree (capability_id);


--
-- Name: backend_capability_channels_channel_id_84c47a3a; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_capability_channels_channel_id_84c47a3a ON public.backend_capability_channels USING btree (channel_id);


--
-- Name: backend_condition_par_id_bddbc67e; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_condition_par_id_bddbc67e ON public.backend_condition USING btree (par_id);


--
-- Name: backend_condition_trigger_id_5a7be7ee; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_condition_trigger_id_5a7be7ee ON public.backend_condition USING btree (trigger_id);


--
-- Name: backend_device_caps_capability_id_6d681664; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_device_caps_capability_id_6d681664 ON public.backend_device_caps USING btree (capability_id);


--
-- Name: backend_device_caps_device_id_582e64dc; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_device_caps_device_id_582e64dc ON public.backend_device_caps USING btree (device_id);


--
-- Name: backend_device_chans_channel_id_d5e05cbd; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_device_chans_channel_id_d5e05cbd ON public.backend_device_chans USING btree (channel_id);


--
-- Name: backend_device_chans_device_id_7eaeaa06; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_device_chans_device_id_7eaeaa06 ON public.backend_device_chans USING btree (device_id);


--
-- Name: backend_device_location_id_1a6aed8f; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_device_location_id_1a6aed8f ON public.backend_device USING btree (location_id);


--
-- Name: backend_device_users_device_id_97c50488; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_device_users_device_id_97c50488 ON public.backend_device_users USING btree (device_id);


--
-- Name: backend_device_users_user_id_f3e47977; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_device_users_user_id_f3e47977 ON public.backend_device_users USING btree (user_id);


--
-- Name: backend_esrule_Etrigger_id_7440ebf1; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX "backend_esrule_Etrigger_id_7440ebf1" ON public.backend_esrule USING btree ("Etrigger_id");


--
-- Name: backend_esrule_Striggers_esrule_id_dea8f5db; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX "backend_esrule_Striggers_esrule_id_dea8f5db" ON public."backend_esrule_Striggers" USING btree (esrule_id);


--
-- Name: backend_esrule_Striggers_trigger_id_5c3c8add; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX "backend_esrule_Striggers_trigger_id_5c3c8add" ON public."backend_esrule_Striggers" USING btree (trigger_id);


--
-- Name: backend_esrule_action_id_722dc031; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_esrule_action_id_722dc031 ON public.backend_esrule USING btree (action_id);


--
-- Name: backend_location_users_location_id_f4e2c736; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_location_users_location_id_f4e2c736 ON public.backend_location_users USING btree (location_id);


--
-- Name: backend_location_users_user_id_dc62e532; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_location_users_user_id_dc62e532 ON public.backend_location_users USING btree (user_id);


--
-- Name: backend_locationvirtualdevices_clock_dev_id_75a957be; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_locationvirtualdevices_clock_dev_id_75a957be ON public.backend_locationvirtualdevices USING btree (clock_dev_id);


--
-- Name: backend_locationvirtualdevices_weather_dev_id_9006c4af; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_locationvirtualdevices_weather_dev_id_9006c4af ON public.backend_locationvirtualdevices USING btree (weather_dev_id);


--
-- Name: backend_parameter_cap_id_b4de2acb; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_parameter_cap_id_b4de2acb ON public.backend_parameter USING btree (cap_id);


--
-- Name: backend_parval_par_id_049e0be4; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_parval_par_id_049e0be4 ON public.backend_parval USING btree (par_id);


--
-- Name: backend_parval_state_id_cde26674; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_parval_state_id_cde26674 ON public.backend_parval USING btree (state_id);


--
-- Name: backend_parvalmapping_param_id_aaf2dcd1; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_parvalmapping_param_id_aaf2dcd1 ON public.backend_parvalmapping USING btree (param_id);


--
-- Name: backend_rule_owner_id_32585cc6; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_rule_owner_id_32585cc6 ON public.backend_rule USING btree (owner_id);


--
-- Name: backend_rule_st_owner_id_54ab2f4a; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_rule_st_owner_id_54ab2f4a ON public.backend_rule USING btree (st_owner_id);


--
-- Name: backend_safetyprop_owner_id_0b165fad; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_safetyprop_owner_id_0b165fad ON public.backend_safetyprop USING btree (owner_id);


--
-- Name: backend_setparamopt_param_id_07e0f502; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_setparamopt_param_id_07e0f502 ON public.backend_setparamopt USING btree (param_id);


--
-- Name: backend_sp1_triggers_sp1_id_c4c1aca5; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_sp1_triggers_sp1_id_c4c1aca5 ON public.backend_sp1_triggers USING btree (sp1_id);


--
-- Name: backend_sp1_triggers_trigger_id_83a751db; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_sp1_triggers_trigger_id_83a751db ON public.backend_sp1_triggers USING btree (trigger_id);


--
-- Name: backend_sp2_conds_sp2_id_1fb0191a; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_sp2_conds_sp2_id_1fb0191a ON public.backend_sp2_conds USING btree (sp2_id);


--
-- Name: backend_sp2_conds_trigger_id_b90c6fa9; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_sp2_conds_trigger_id_b90c6fa9 ON public.backend_sp2_conds USING btree (trigger_id);


--
-- Name: backend_sp2_state_id_01caf21d; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_sp2_state_id_01caf21d ON public.backend_sp2 USING btree (state_id);


--
-- Name: backend_sp3_conds_sp3_id_f2c1fec5; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_sp3_conds_sp3_id_f2c1fec5 ON public.backend_sp3_conds USING btree (sp3_id);


--
-- Name: backend_sp3_conds_trigger_id_4aa9489f; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_sp3_conds_trigger_id_4aa9489f ON public.backend_sp3_conds USING btree (trigger_id);


--
-- Name: backend_sp3_event_id_b133fd92; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_sp3_event_id_b133fd92 ON public.backend_sp3 USING btree (event_id);


--
-- Name: backend_ssrule_action_id_6626b087; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_ssrule_action_id_6626b087 ON public.backend_ssrule USING btree (action_id);


--
-- Name: backend_ssrule_triggers_ssrule_id_c5913b93; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_ssrule_triggers_ssrule_id_c5913b93 ON public.backend_ssrule_triggers USING btree (ssrule_id);


--
-- Name: backend_ssrule_triggers_trigger_id_d0a0f6b6; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_ssrule_triggers_trigger_id_d0a0f6b6 ON public.backend_ssrule_triggers USING btree (trigger_id);


--
-- Name: backend_state_cap_id_25727ebe; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_state_cap_id_25727ebe ON public.backend_state USING btree (cap_id);


--
-- Name: backend_state_chan_id_b9d0a0d4; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_state_chan_id_b9d0a0d4 ON public.backend_state USING btree (chan_id);


--
-- Name: backend_state_dev_id_a376fae0; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_state_dev_id_a376fae0 ON public.backend_state USING btree (dev_id);


--
-- Name: backend_statelog_cap_id_a554767b; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_statelog_cap_id_a554767b ON public.backend_statelog USING btree (cap_id);


--
-- Name: backend_statelog_dev_id_63f7e345; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_statelog_dev_id_63f7e345 ON public.backend_statelog USING btree (dev_id);


--
-- Name: backend_statelog_param_id_ab9f8aa5; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_statelog_param_id_ab9f8aa5 ON public.backend_statelog USING btree (param_id);


--
-- Name: backend_stcapability_capabilities_capability_id_eec0e4f8; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_stcapability_capabilities_capability_id_eec0e4f8 ON public.backend_stcapability_capabilities USING btree (capability_id);


--
-- Name: backend_stcapability_capabilities_stcapability_id_210b0a60; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_stcapability_capabilities_stcapability_id_210b0a60 ON public.backend_stcapability_capabilities USING btree (stcapability_id);


--
-- Name: backend_stcapability_name_213f481c_like; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_stcapability_name_213f481c_like ON public.backend_stcapability USING btree (name varchar_pattern_ops);


--
-- Name: backend_trigger_cap_id_c28ac690; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_trigger_cap_id_c28ac690 ON public.backend_trigger USING btree (cap_id);


--
-- Name: backend_trigger_chan_id_bbc8de39; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_trigger_chan_id_bbc8de39 ON public.backend_trigger USING btree (chan_id);


--
-- Name: backend_trigger_dev_id_4a2e1853; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_trigger_dev_id_4a2e1853 ON public.backend_trigger USING btree (dev_id);


--
-- Name: backend_user_icse19_name_aedfacd4_like; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX backend_user_icse19_name_aedfacd4_like ON public.backend_user_icse19 USING btree (name varchar_pattern_ops);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_celery_beat_periodictask_clocked_id_47a69f82; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX django_celery_beat_periodictask_clocked_id_47a69f82 ON public.django_celery_beat_periodictask USING btree (clocked_id);


--
-- Name: django_celery_beat_periodictask_crontab_id_d3cba168; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX django_celery_beat_periodictask_crontab_id_d3cba168 ON public.django_celery_beat_periodictask USING btree (crontab_id);


--
-- Name: django_celery_beat_periodictask_interval_id_a8ca27da; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX django_celery_beat_periodictask_interval_id_a8ca27da ON public.django_celery_beat_periodictask USING btree (interval_id);


--
-- Name: django_celery_beat_periodictask_name_265a36b7_like; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX django_celery_beat_periodictask_name_265a36b7_like ON public.django_celery_beat_periodictask USING btree (name varchar_pattern_ops);


--
-- Name: django_celery_beat_periodictask_solar_id_a87ce72c; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX django_celery_beat_periodictask_solar_id_a87ce72c ON public.django_celery_beat_periodictask USING btree (solar_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: oauth2_provider_accesstoken_application_id_b22886e1; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX oauth2_provider_accesstoken_application_id_b22886e1 ON public.oauth2_provider_accesstoken USING btree (application_id);


--
-- Name: oauth2_provider_accesstoken_token_8af090f8_like; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX oauth2_provider_accesstoken_token_8af090f8_like ON public.oauth2_provider_accesstoken USING btree (token varchar_pattern_ops);


--
-- Name: oauth2_provider_accesstoken_user_id_6e4c9a65; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX oauth2_provider_accesstoken_user_id_6e4c9a65 ON public.oauth2_provider_accesstoken USING btree (user_id);


--
-- Name: oauth2_provider_application_client_id_03f0cc84_like; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX oauth2_provider_application_client_id_03f0cc84_like ON public.oauth2_provider_application USING btree (client_id varchar_pattern_ops);


--
-- Name: oauth2_provider_application_client_secret_53133678; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX oauth2_provider_application_client_secret_53133678 ON public.oauth2_provider_application USING btree (client_secret);


--
-- Name: oauth2_provider_application_client_secret_53133678_like; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX oauth2_provider_application_client_secret_53133678_like ON public.oauth2_provider_application USING btree (client_secret varchar_pattern_ops);


--
-- Name: oauth2_provider_application_user_id_79829054; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX oauth2_provider_application_user_id_79829054 ON public.oauth2_provider_application USING btree (user_id);


--
-- Name: oauth2_provider_grant_application_id_81923564; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX oauth2_provider_grant_application_id_81923564 ON public.oauth2_provider_grant USING btree (application_id);


--
-- Name: oauth2_provider_grant_code_49ab4ddf_like; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX oauth2_provider_grant_code_49ab4ddf_like ON public.oauth2_provider_grant USING btree (code varchar_pattern_ops);


--
-- Name: oauth2_provider_grant_user_id_e8f62af8; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX oauth2_provider_grant_user_id_e8f62af8 ON public.oauth2_provider_grant USING btree (user_id);


--
-- Name: oauth2_provider_refreshtoken_application_id_2d1c311b; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX oauth2_provider_refreshtoken_application_id_2d1c311b ON public.oauth2_provider_refreshtoken USING btree (application_id);


--
-- Name: oauth2_provider_refreshtoken_user_id_da837fce; Type: INDEX; Schema: public; Owner: iftttuser
--

CREATE INDEX oauth2_provider_refreshtoken_user_id_da837fce ON public.oauth2_provider_refreshtoken USING btree (user_id);


--
-- Name: auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_action_cap_id_6e082aa0_fk_backend_capability_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_action
    ADD CONSTRAINT backend_action_cap_id_6e082aa0_fk_backend_capability_id FOREIGN KEY (cap_id) REFERENCES public.backend_capability(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_action_chan_id_4f0af261_fk_backend_channel_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_action
    ADD CONSTRAINT backend_action_chan_id_4f0af261_fk_backend_channel_id FOREIGN KEY (chan_id) REFERENCES public.backend_channel(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_action_dev_id_52625625_fk_backend_device_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_action
    ADD CONSTRAINT backend_action_dev_id_52625625_fk_backend_device_id FOREIGN KEY (dev_id) REFERENCES public.backend_device(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_actioncondition_action_id_730289f7_fk_backend_action_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_actioncondition
    ADD CONSTRAINT backend_actioncondition_action_id_730289f7_fk_backend_action_id FOREIGN KEY (action_id) REFERENCES public.backend_action(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_actioncondition_par_id_16268af4_fk_backend_parameter_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_actioncondition
    ADD CONSTRAINT backend_actioncondition_par_id_16268af4_fk_backend_parameter_id FOREIGN KEY (par_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_actionparval_par_id_71518a37_fk_backend_parameter_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_actionparval
    ADD CONSTRAINT backend_actionparval_par_id_71518a37_fk_backend_parameter_id FOREIGN KEY (par_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_actionparval_state_id_378a1fb8_fk_backend_state_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_actionparval
    ADD CONSTRAINT backend_actionparval_state_id_378a1fb8_fk_backend_state_id FOREIGN KEY (state_id) REFERENCES public.backend_state(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_binparam_parameter_ptr_id_4fc53892_fk_backend_p; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_binparam
    ADD CONSTRAINT backend_binparam_parameter_ptr_id_4fc53892_fk_backend_p FOREIGN KEY (parameter_ptr_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_capability_c_capability_id_1bccd6c0_fk_backend_c; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_capability_channels
    ADD CONSTRAINT backend_capability_c_capability_id_1bccd6c0_fk_backend_c FOREIGN KEY (capability_id) REFERENCES public.backend_capability(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_capability_c_channel_id_84c47a3a_fk_backend_c; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_capability_channels
    ADD CONSTRAINT backend_capability_c_channel_id_84c47a3a_fk_backend_c FOREIGN KEY (channel_id) REFERENCES public.backend_channel(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_colorparam_parameter_ptr_id_2a10b1b1_fk_backend_p; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_colorparam
    ADD CONSTRAINT backend_colorparam_parameter_ptr_id_2a10b1b1_fk_backend_p FOREIGN KEY (parameter_ptr_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_condition_par_id_bddbc67e_fk_backend_parameter_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_condition
    ADD CONSTRAINT backend_condition_par_id_bddbc67e_fk_backend_parameter_id FOREIGN KEY (par_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_condition_trigger_id_5a7be7ee_fk_backend_trigger_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_condition
    ADD CONSTRAINT backend_condition_trigger_id_5a7be7ee_fk_backend_trigger_id FOREIGN KEY (trigger_id) REFERENCES public.backend_trigger(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_device_caps_capability_id_6d681664_fk_backend_c; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_device_caps
    ADD CONSTRAINT backend_device_caps_capability_id_6d681664_fk_backend_c FOREIGN KEY (capability_id) REFERENCES public.backend_capability(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_device_caps_device_id_582e64dc_fk_backend_device_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_device_caps
    ADD CONSTRAINT backend_device_caps_device_id_582e64dc_fk_backend_device_id FOREIGN KEY (device_id) REFERENCES public.backend_device(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_device_chans_channel_id_d5e05cbd_fk_backend_channel_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_device_chans
    ADD CONSTRAINT backend_device_chans_channel_id_d5e05cbd_fk_backend_channel_id FOREIGN KEY (channel_id) REFERENCES public.backend_channel(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_device_chans_device_id_7eaeaa06_fk_backend_device_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_device_chans
    ADD CONSTRAINT backend_device_chans_device_id_7eaeaa06_fk_backend_device_id FOREIGN KEY (device_id) REFERENCES public.backend_device(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_device_location_id_1a6aed8f_fk_backend_location_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_device
    ADD CONSTRAINT backend_device_location_id_1a6aed8f_fk_backend_location_id FOREIGN KEY (location_id) REFERENCES public.backend_location(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_device_users_device_id_97c50488_fk_backend_device_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_device_users
    ADD CONSTRAINT backend_device_users_device_id_97c50488_fk_backend_device_id FOREIGN KEY (device_id) REFERENCES public.backend_device(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_device_users_user_id_f3e47977_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_device_users
    ADD CONSTRAINT backend_device_users_user_id_f3e47977_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_durationpara_parameter_ptr_id_06b460c1_fk_backend_p; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_durationparam
    ADD CONSTRAINT backend_durationpara_parameter_ptr_id_06b460c1_fk_backend_p FOREIGN KEY (parameter_ptr_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_esrule_Etrigger_id_7440ebf1_fk_backend_trigger_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_esrule
    ADD CONSTRAINT "backend_esrule_Etrigger_id_7440ebf1_fk_backend_trigger_id" FOREIGN KEY ("Etrigger_id") REFERENCES public.backend_trigger(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_esrule_Strig_esrule_id_dea8f5db_fk_backend_e; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public."backend_esrule_Striggers"
    ADD CONSTRAINT "backend_esrule_Strig_esrule_id_dea8f5db_fk_backend_e" FOREIGN KEY (esrule_id) REFERENCES public.backend_esrule(rule_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_esrule_Strig_trigger_id_5c3c8add_fk_backend_t; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public."backend_esrule_Striggers"
    ADD CONSTRAINT "backend_esrule_Strig_trigger_id_5c3c8add_fk_backend_t" FOREIGN KEY (trigger_id) REFERENCES public.backend_trigger(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_esrule_action_id_722dc031_fk_backend_action_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_esrule
    ADD CONSTRAINT backend_esrule_action_id_722dc031_fk_backend_action_id FOREIGN KEY (action_id) REFERENCES public.backend_action(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_esrule_rule_ptr_id_f8f656ef_fk_backend_rule_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_esrule
    ADD CONSTRAINT backend_esrule_rule_ptr_id_f8f656ef_fk_backend_rule_id FOREIGN KEY (rule_ptr_id) REFERENCES public.backend_rule(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_inputparam_parameter_ptr_id_7d2d6fe8_fk_backend_p; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_inputparam
    ADD CONSTRAINT backend_inputparam_parameter_ptr_id_7d2d6fe8_fk_backend_p FOREIGN KEY (parameter_ptr_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_location_use_location_id_f4e2c736_fk_backend_l; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_location_users
    ADD CONSTRAINT backend_location_use_location_id_f4e2c736_fk_backend_l FOREIGN KEY (location_id) REFERENCES public.backend_location(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_location_users_user_id_dc62e532_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_location_users
    ADD CONSTRAINT backend_location_users_user_id_dc62e532_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_locationvirt_clock_dev_id_75a957be_fk_backend_d; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_locationvirtualdevices
    ADD CONSTRAINT backend_locationvirt_clock_dev_id_75a957be_fk_backend_d FOREIGN KEY (clock_dev_id) REFERENCES public.backend_device(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_locationvirt_location_id_e9ed7b6d_fk_backend_l; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_locationvirtualdevices
    ADD CONSTRAINT backend_locationvirt_location_id_e9ed7b6d_fk_backend_l FOREIGN KEY (location_id) REFERENCES public.backend_location(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_locationvirt_weather_dev_id_9006c4af_fk_backend_d; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_locationvirtualdevices
    ADD CONSTRAINT backend_locationvirt_weather_dev_id_9006c4af_fk_backend_d FOREIGN KEY (weather_dev_id) REFERENCES public.backend_device(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_metaparam_parameter_ptr_id_56ce872d_fk_backend_p; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_metaparam
    ADD CONSTRAINT backend_metaparam_parameter_ptr_id_56ce872d_fk_backend_p FOREIGN KEY (parameter_ptr_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_parameter_cap_id_b4de2acb_fk_backend_capability_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_parameter
    ADD CONSTRAINT backend_parameter_cap_id_b4de2acb_fk_backend_capability_id FOREIGN KEY (cap_id) REFERENCES public.backend_capability(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_parval_par_id_049e0be4_fk_backend_parameter_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_parval
    ADD CONSTRAINT backend_parval_par_id_049e0be4_fk_backend_parameter_id FOREIGN KEY (par_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_parval_state_id_cde26674_fk_backend_state_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_parval
    ADD CONSTRAINT backend_parval_state_id_cde26674_fk_backend_state_id FOREIGN KEY (state_id) REFERENCES public.backend_state(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_parvalmapping_param_id_aaf2dcd1_fk_backend_parameter_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_parvalmapping
    ADD CONSTRAINT backend_parvalmapping_param_id_aaf2dcd1_fk_backend_parameter_id FOREIGN KEY (param_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_rangeparam_parameter_ptr_id_9a607db7_fk_backend_p; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_rangeparam
    ADD CONSTRAINT backend_rangeparam_parameter_ptr_id_9a607db7_fk_backend_p FOREIGN KEY (parameter_ptr_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_rule_owner_id_32585cc6_fk_backend_user_icse19_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_rule
    ADD CONSTRAINT backend_rule_owner_id_32585cc6_fk_backend_user_icse19_id FOREIGN KEY (owner_id) REFERENCES public.backend_user_icse19(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_rule_st_owner_id_54ab2f4a_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_rule
    ADD CONSTRAINT backend_rule_st_owner_id_54ab2f4a_fk_auth_user_id FOREIGN KEY (st_owner_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_safetyprop_owner_id_0b165fad_fk_backend_user_icse19_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_safetyprop
    ADD CONSTRAINT backend_safetyprop_owner_id_0b165fad_fk_backend_user_icse19_id FOREIGN KEY (owner_id) REFERENCES public.backend_user_icse19(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_setparam_parameter_ptr_id_18bfc60c_fk_backend_p; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_setparam
    ADD CONSTRAINT backend_setparam_parameter_ptr_id_18bfc60c_fk_backend_p FOREIGN KEY (parameter_ptr_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_setparamopt_param_id_07e0f502_fk_backend_s; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_setparamopt
    ADD CONSTRAINT backend_setparamopt_param_id_07e0f502_fk_backend_s FOREIGN KEY (param_id) REFERENCES public.backend_setparam(parameter_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp1_safetyprop_ptr_id_d29a5f23_fk_backend_safetyprop_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp1
    ADD CONSTRAINT backend_sp1_safetyprop_ptr_id_d29a5f23_fk_backend_safetyprop_id FOREIGN KEY (safetyprop_ptr_id) REFERENCES public.backend_safetyprop(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp1_triggers_sp1_id_c4c1aca5_fk_backend_s; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp1_triggers
    ADD CONSTRAINT backend_sp1_triggers_sp1_id_c4c1aca5_fk_backend_s FOREIGN KEY (sp1_id) REFERENCES public.backend_sp1(safetyprop_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp1_triggers_trigger_id_83a751db_fk_backend_trigger_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp1_triggers
    ADD CONSTRAINT backend_sp1_triggers_trigger_id_83a751db_fk_backend_trigger_id FOREIGN KEY (trigger_id) REFERENCES public.backend_trigger(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp2_conds_sp2_id_1fb0191a_fk_backend_s; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp2_conds
    ADD CONSTRAINT backend_sp2_conds_sp2_id_1fb0191a_fk_backend_s FOREIGN KEY (sp2_id) REFERENCES public.backend_sp2(safetyprop_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp2_conds_trigger_id_b90c6fa9_fk_backend_trigger_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp2_conds
    ADD CONSTRAINT backend_sp2_conds_trigger_id_b90c6fa9_fk_backend_trigger_id FOREIGN KEY (trigger_id) REFERENCES public.backend_trigger(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp2_safetyprop_ptr_id_6057ecb9_fk_backend_safetyprop_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp2
    ADD CONSTRAINT backend_sp2_safetyprop_ptr_id_6057ecb9_fk_backend_safetyprop_id FOREIGN KEY (safetyprop_ptr_id) REFERENCES public.backend_safetyprop(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp2_state_id_01caf21d_fk_backend_trigger_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp2
    ADD CONSTRAINT backend_sp2_state_id_01caf21d_fk_backend_trigger_id FOREIGN KEY (state_id) REFERENCES public.backend_trigger(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp3_conds_sp3_id_f2c1fec5_fk_backend_s; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp3_conds
    ADD CONSTRAINT backend_sp3_conds_sp3_id_f2c1fec5_fk_backend_s FOREIGN KEY (sp3_id) REFERENCES public.backend_sp3(safetyprop_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp3_conds_trigger_id_4aa9489f_fk_backend_trigger_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp3_conds
    ADD CONSTRAINT backend_sp3_conds_trigger_id_4aa9489f_fk_backend_trigger_id FOREIGN KEY (trigger_id) REFERENCES public.backend_trigger(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp3_event_id_b133fd92_fk_backend_trigger_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp3
    ADD CONSTRAINT backend_sp3_event_id_b133fd92_fk_backend_trigger_id FOREIGN KEY (event_id) REFERENCES public.backend_trigger(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp3_safetyprop_ptr_id_ac7404ea_fk_backend_safetyprop_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_sp3
    ADD CONSTRAINT backend_sp3_safetyprop_ptr_id_ac7404ea_fk_backend_safetyprop_id FOREIGN KEY (safetyprop_ptr_id) REFERENCES public.backend_safetyprop(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_ssrule_action_id_6626b087_fk_backend_action_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_ssrule
    ADD CONSTRAINT backend_ssrule_action_id_6626b087_fk_backend_action_id FOREIGN KEY (action_id) REFERENCES public.backend_action(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_ssrule_rule_ptr_id_bb3cd0da_fk_backend_rule_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_ssrule
    ADD CONSTRAINT backend_ssrule_rule_ptr_id_bb3cd0da_fk_backend_rule_id FOREIGN KEY (rule_ptr_id) REFERENCES public.backend_rule(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_ssrule_trigg_ssrule_id_c5913b93_fk_backend_s; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_ssrule_triggers
    ADD CONSTRAINT backend_ssrule_trigg_ssrule_id_c5913b93_fk_backend_s FOREIGN KEY (ssrule_id) REFERENCES public.backend_ssrule(rule_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_ssrule_trigg_trigger_id_d0a0f6b6_fk_backend_t; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_ssrule_triggers
    ADD CONSTRAINT backend_ssrule_trigg_trigger_id_d0a0f6b6_fk_backend_t FOREIGN KEY (trigger_id) REFERENCES public.backend_trigger(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_state_cap_id_25727ebe_fk_backend_capability_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_state
    ADD CONSTRAINT backend_state_cap_id_25727ebe_fk_backend_capability_id FOREIGN KEY (cap_id) REFERENCES public.backend_capability(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_state_chan_id_b9d0a0d4_fk_backend_channel_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_state
    ADD CONSTRAINT backend_state_chan_id_b9d0a0d4_fk_backend_channel_id FOREIGN KEY (chan_id) REFERENCES public.backend_channel(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_state_dev_id_a376fae0_fk_backend_device_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_state
    ADD CONSTRAINT backend_state_dev_id_a376fae0_fk_backend_device_id FOREIGN KEY (dev_id) REFERENCES public.backend_device(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_statelog_cap_id_a554767b_fk_backend_capability_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_statelog
    ADD CONSTRAINT backend_statelog_cap_id_a554767b_fk_backend_capability_id FOREIGN KEY (cap_id) REFERENCES public.backend_capability(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_statelog_dev_id_63f7e345_fk_backend_device_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_statelog
    ADD CONSTRAINT backend_statelog_dev_id_63f7e345_fk_backend_device_id FOREIGN KEY (dev_id) REFERENCES public.backend_device(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_statelog_param_id_ab9f8aa5_fk_backend_parameter_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_statelog
    ADD CONSTRAINT backend_statelog_param_id_ab9f8aa5_fk_backend_parameter_id FOREIGN KEY (param_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_stcapability_capability_id_eec0e4f8_fk_backend_c; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_stcapability_capabilities
    ADD CONSTRAINT backend_stcapability_capability_id_eec0e4f8_fk_backend_c FOREIGN KEY (capability_id) REFERENCES public.backend_capability(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_stcapability_stcapability_id_210b0a60_fk_backend_s; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_stcapability_capabilities
    ADD CONSTRAINT backend_stcapability_stcapability_id_210b0a60_fk_backend_s FOREIGN KEY (stcapability_id) REFERENCES public.backend_stcapability(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_timeparam_parameter_ptr_id_fc36e993_fk_backend_p; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_timeparam
    ADD CONSTRAINT backend_timeparam_parameter_ptr_id_fc36e993_fk_backend_p FOREIGN KEY (parameter_ptr_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_trigger_cap_id_c28ac690_fk_backend_capability_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_trigger
    ADD CONSTRAINT backend_trigger_cap_id_c28ac690_fk_backend_capability_id FOREIGN KEY (cap_id) REFERENCES public.backend_capability(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_trigger_chan_id_bbc8de39_fk_backend_channel_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_trigger
    ADD CONSTRAINT backend_trigger_chan_id_bbc8de39_fk_backend_channel_id FOREIGN KEY (chan_id) REFERENCES public.backend_channel(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_trigger_dev_id_4a2e1853_fk_backend_device_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_trigger
    ADD CONSTRAINT backend_trigger_dev_id_4a2e1853_fk_backend_device_id FOREIGN KEY (dev_id) REFERENCES public.backend_device(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_userprofile_user_id_04220256_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.backend_userprofile
    ADD CONSTRAINT backend_userprofile_user_id_04220256_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_celery_beat_p_clocked_id_47a69f82_fk_django_ce; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_celery_beat_periodictask
    ADD CONSTRAINT django_celery_beat_p_clocked_id_47a69f82_fk_django_ce FOREIGN KEY (clocked_id) REFERENCES public.django_celery_beat_clockedschedule(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_celery_beat_p_crontab_id_d3cba168_fk_django_ce; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_celery_beat_periodictask
    ADD CONSTRAINT django_celery_beat_p_crontab_id_d3cba168_fk_django_ce FOREIGN KEY (crontab_id) REFERENCES public.django_celery_beat_crontabschedule(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_celery_beat_p_interval_id_a8ca27da_fk_django_ce; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_celery_beat_periodictask
    ADD CONSTRAINT django_celery_beat_p_interval_id_a8ca27da_fk_django_ce FOREIGN KEY (interval_id) REFERENCES public.django_celery_beat_intervalschedule(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_celery_beat_p_solar_id_a87ce72c_fk_django_ce; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.django_celery_beat_periodictask
    ADD CONSTRAINT django_celery_beat_p_solar_id_a87ce72c_fk_django_ce FOREIGN KEY (solar_id) REFERENCES public.django_celery_beat_solarschedule(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: oauth2_provider_acce_source_refresh_token_e66fbc72_fk_oauth2_pr; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.oauth2_provider_accesstoken
    ADD CONSTRAINT oauth2_provider_acce_source_refresh_token_e66fbc72_fk_oauth2_pr FOREIGN KEY (source_refresh_token_id) REFERENCES public.oauth2_provider_refreshtoken(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: oauth2_provider_accesstoken_application_id_b22886e1_fk; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.oauth2_provider_accesstoken
    ADD CONSTRAINT oauth2_provider_accesstoken_application_id_b22886e1_fk FOREIGN KEY (application_id) REFERENCES public.oauth2_provider_application(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: oauth2_provider_accesstoken_user_id_6e4c9a65_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.oauth2_provider_accesstoken
    ADD CONSTRAINT oauth2_provider_accesstoken_user_id_6e4c9a65_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: oauth2_provider_application_user_id_79829054_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.oauth2_provider_application
    ADD CONSTRAINT oauth2_provider_application_user_id_79829054_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: oauth2_provider_grant_application_id_81923564_fk; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.oauth2_provider_grant
    ADD CONSTRAINT oauth2_provider_grant_application_id_81923564_fk FOREIGN KEY (application_id) REFERENCES public.oauth2_provider_application(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: oauth2_provider_grant_user_id_e8f62af8_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.oauth2_provider_grant
    ADD CONSTRAINT oauth2_provider_grant_user_id_e8f62af8_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: oauth2_provider_refr_access_token_id_775e84e8_fk_oauth2_pr; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.oauth2_provider_refreshtoken
    ADD CONSTRAINT oauth2_provider_refr_access_token_id_775e84e8_fk_oauth2_pr FOREIGN KEY (access_token_id) REFERENCES public.oauth2_provider_accesstoken(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: oauth2_provider_refreshtoken_application_id_2d1c311b_fk; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.oauth2_provider_refreshtoken
    ADD CONSTRAINT oauth2_provider_refreshtoken_application_id_2d1c311b_fk FOREIGN KEY (application_id) REFERENCES public.oauth2_provider_application(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: oauth2_provider_refreshtoken_user_id_da837fce_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.oauth2_provider_refreshtoken
    ADD CONSTRAINT oauth2_provider_refreshtoken_user_id_da837fce_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_auth_usermetadata_user_id_26767ead_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: iftttuser
--

ALTER TABLE ONLY public.user_auth_usermetadata
    ADD CONSTRAINT user_auth_usermetadata_user_id_26767ead_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

