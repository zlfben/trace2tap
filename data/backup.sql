--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.9
-- Dumped by pg_dump version 9.6.9

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
-- Name: auth_group; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(80) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO iftttuser;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO iftttuser;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO iftttuser;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO iftttuser;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO iftttuser;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO iftttuser;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: jessejmart
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
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO iftttuser;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_groups_id_seq OWNER TO iftttuser;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.auth_user_groups_id_seq OWNED BY public.auth_user_groups.id;


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_id_seq OWNER TO iftttuser;

--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.auth_user_id_seq OWNED BY public.auth_user.id;


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO iftttuser;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_user_permissions_id_seq OWNER TO iftttuser;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.auth_user_user_permissions_id_seq OWNED BY public.auth_user_user_permissions.id;


--
-- Name: backend_binparam; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_binparam (
    parameter_ptr_id integer NOT NULL,
    tval text NOT NULL,
    fval text NOT NULL
);


ALTER TABLE public.backend_binparam OWNER TO iftttuser;

--
-- Name: backend_capability; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_capability (
    id integer NOT NULL,
    name character varying(30) NOT NULL,
    commandlabel text,
    eventlabel text,
    statelabel text,
    readable boolean NOT NULL,
    writeable boolean NOT NULL,
    commandname text
);


ALTER TABLE public.backend_capability OWNER TO iftttuser;

--
-- Name: backend_capability_channels; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_capability_channels (
    id integer NOT NULL,
    capability_id integer NOT NULL,
    channel_id integer NOT NULL
);


ALTER TABLE public.backend_capability_channels OWNER TO iftttuser;

--
-- Name: backend_capability_channels_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.backend_capability_channels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_capability_channels_id_seq OWNER TO iftttuser;

--
-- Name: backend_capability_channels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.backend_capability_channels_id_seq OWNED BY public.backend_capability_channels.id;


--
-- Name: backend_capability_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.backend_capability_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_capability_id_seq OWNER TO iftttuser;

--
-- Name: backend_capability_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.backend_capability_id_seq OWNED BY public.backend_capability.id;


--
-- Name: backend_channel; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_channel (
    id integer NOT NULL,
    name character varying(30) NOT NULL,
    icon text
);


ALTER TABLE public.backend_channel OWNER TO iftttuser;

--
-- Name: backend_channel_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.backend_channel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_channel_id_seq OWNER TO iftttuser;

--
-- Name: backend_channel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.backend_channel_id_seq OWNED BY public.backend_channel.id;


--
-- Name: backend_colorparam; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_colorparam (
    parameter_ptr_id integer NOT NULL,
    mode text NOT NULL
);


ALTER TABLE public.backend_colorparam OWNER TO iftttuser;

--
-- Name: backend_condition; Type: TABLE; Schema: public; Owner: jessejmart
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
-- Name: backend_condition_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.backend_condition_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_condition_id_seq OWNER TO iftttuser;

--
-- Name: backend_condition_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.backend_condition_id_seq OWNED BY public.backend_condition.id;


--
-- Name: backend_device; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_device (
    id integer NOT NULL,
    name character varying(32) NOT NULL,
    owner_id integer NOT NULL,
    public boolean NOT NULL,
    icon text
);


ALTER TABLE public.backend_device OWNER TO iftttuser;

--
-- Name: backend_device_caps; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_device_caps (
    id integer NOT NULL,
    device_id integer NOT NULL,
    capability_id integer NOT NULL
);


ALTER TABLE public.backend_device_caps OWNER TO iftttuser;

--
-- Name: backend_device_capabilities_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.backend_device_capabilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_device_capabilities_id_seq OWNER TO iftttuser;

--
-- Name: backend_device_capabilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.backend_device_capabilities_id_seq OWNED BY public.backend_device_caps.id;


--
-- Name: backend_device_chans; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_device_chans (
    id integer NOT NULL,
    device_id integer NOT NULL,
    channel_id integer NOT NULL
);


ALTER TABLE public.backend_device_chans OWNER TO iftttuser;

--
-- Name: backend_device_chans_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.backend_device_chans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_device_chans_id_seq OWNER TO iftttuser;

--
-- Name: backend_device_chans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.backend_device_chans_id_seq OWNED BY public.backend_device_chans.id;


--
-- Name: backend_device_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.backend_device_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_device_id_seq OWNER TO iftttuser;

--
-- Name: backend_device_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.backend_device_id_seq OWNED BY public.backend_device.id;


--
-- Name: backend_durationparam; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_durationparam (
    parameter_ptr_id integer NOT NULL,
    maxhours integer,
    maxmins integer,
    maxsecs integer,
    comp boolean NOT NULL
);


ALTER TABLE public.backend_durationparam OWNER TO iftttuser;

--
-- Name: backend_esrule; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_esrule (
    action_id integer NOT NULL,
    "Etrigger_id" integer NOT NULL,
    rule_ptr_id integer NOT NULL
);


ALTER TABLE public.backend_esrule OWNER TO iftttuser;

--
-- Name: backend_esrule_Striggers; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public."backend_esrule_Striggers" (
    id integer NOT NULL,
    esrule_id integer NOT NULL,
    trigger_id integer NOT NULL
);


ALTER TABLE public."backend_esrule_Striggers" OWNER TO iftttuser;

--
-- Name: backend_esrule_triggersS_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public."backend_esrule_triggersS_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."backend_esrule_triggersS_id_seq" OWNER TO iftttuser;

--
-- Name: backend_esrule_triggersS_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public."backend_esrule_triggersS_id_seq" OWNED BY public."backend_esrule_Striggers".id;


--
-- Name: backend_inputparam; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_inputparam (
    parameter_ptr_id integer NOT NULL,
    inputtype text NOT NULL
);


ALTER TABLE public.backend_inputparam OWNER TO iftttuser;

--
-- Name: backend_metaparam; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_metaparam (
    parameter_ptr_id integer NOT NULL,
    is_event boolean NOT NULL
);


ALTER TABLE public.backend_metaparam OWNER TO iftttuser;

--
-- Name: backend_parameter; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_parameter (
    id integer NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    cap_id integer NOT NULL
);


ALTER TABLE public.backend_parameter OWNER TO iftttuser;

--
-- Name: backend_parameter_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.backend_parameter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_parameter_id_seq OWNER TO iftttuser;

--
-- Name: backend_parameter_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.backend_parameter_id_seq OWNED BY public.backend_parameter.id;


--
-- Name: backend_parval; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_parval (
    id integer NOT NULL,
    val text NOT NULL,
    par_id integer NOT NULL,
    state_id integer NOT NULL
);


ALTER TABLE public.backend_parval OWNER TO iftttuser;

--
-- Name: backend_parval_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.backend_parval_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_parval_id_seq OWNER TO iftttuser;

--
-- Name: backend_parval_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.backend_parval_id_seq OWNED BY public.backend_parval.id;


--
-- Name: backend_rangeparam; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_rangeparam (
    parameter_ptr_id integer NOT NULL,
    min integer NOT NULL,
    max integer NOT NULL,
    "interval" double precision NOT NULL
);


ALTER TABLE public.backend_rangeparam OWNER TO iftttuser;

--
-- Name: backend_rule; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_rule (
    id integer NOT NULL,
    owner_id integer NOT NULL,
    type character varying(3) NOT NULL,
    task integer NOT NULL,
    lastedit timestamp with time zone NOT NULL
);


ALTER TABLE public.backend_rule OWNER TO iftttuser;

--
-- Name: backend_rule_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.backend_rule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_rule_id_seq OWNER TO iftttuser;

--
-- Name: backend_rule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.backend_rule_id_seq OWNED BY public.backend_rule.id;


--
-- Name: backend_safetyprop; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_safetyprop (
    id integer NOT NULL,
    type integer NOT NULL,
    owner_id integer NOT NULL,
    always boolean NOT NULL,
    task integer NOT NULL,
    lastedit timestamp with time zone NOT NULL
);


ALTER TABLE public.backend_safetyprop OWNER TO iftttuser;

--
-- Name: backend_safetyprop_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.backend_safetyprop_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_safetyprop_id_seq OWNER TO iftttuser;

--
-- Name: backend_safetyprop_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.backend_safetyprop_id_seq OWNED BY public.backend_safetyprop.id;


--
-- Name: backend_setparam; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_setparam (
    parameter_ptr_id integer NOT NULL,
    numopts integer NOT NULL
);


ALTER TABLE public.backend_setparam OWNER TO iftttuser;

--
-- Name: backend_setparamopt; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_setparamopt (
    id integer NOT NULL,
    value text NOT NULL,
    param_id integer NOT NULL
);


ALTER TABLE public.backend_setparamopt OWNER TO iftttuser;

--
-- Name: backend_setparamopt_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.backend_setparamopt_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_setparamopt_id_seq OWNER TO iftttuser;

--
-- Name: backend_setparamopt_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.backend_setparamopt_id_seq OWNED BY public.backend_setparamopt.id;


--
-- Name: backend_sp1; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_sp1 (
    safetyprop_ptr_id integer NOT NULL
);


ALTER TABLE public.backend_sp1 OWNER TO iftttuser;

--
-- Name: backend_sp1_triggers; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_sp1_triggers (
    id integer NOT NULL,
    sp1_id integer NOT NULL,
    trigger_id integer NOT NULL
);


ALTER TABLE public.backend_sp1_triggers OWNER TO iftttuser;

--
-- Name: backend_sp1_triggers_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.backend_sp1_triggers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_sp1_triggers_id_seq OWNER TO iftttuser;

--
-- Name: backend_sp1_triggers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.backend_sp1_triggers_id_seq OWNED BY public.backend_sp1_triggers.id;


--
-- Name: backend_sp2; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_sp2 (
    safetyprop_ptr_id integer NOT NULL,
    comp text,
    "time" integer,
    state_id integer NOT NULL
);


ALTER TABLE public.backend_sp2 OWNER TO iftttuser;

--
-- Name: backend_sp2_conds; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_sp2_conds (
    id integer NOT NULL,
    sp2_id integer NOT NULL,
    trigger_id integer NOT NULL
);


ALTER TABLE public.backend_sp2_conds OWNER TO iftttuser;

--
-- Name: backend_sp2_conds_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.backend_sp2_conds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_sp2_conds_id_seq OWNER TO iftttuser;

--
-- Name: backend_sp2_conds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.backend_sp2_conds_id_seq OWNED BY public.backend_sp2_conds.id;


--
-- Name: backend_sp3; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_sp3 (
    safetyprop_ptr_id integer NOT NULL,
    comp text,
    occurrences integer,
    "time" integer,
    event_id integer NOT NULL,
    timecomp text
);


ALTER TABLE public.backend_sp3 OWNER TO iftttuser;

--
-- Name: backend_sp3_conds; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_sp3_conds (
    id integer NOT NULL,
    sp3_id integer NOT NULL,
    trigger_id integer NOT NULL
);


ALTER TABLE public.backend_sp3_conds OWNER TO iftttuser;

--
-- Name: backend_sp3_conds_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.backend_sp3_conds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_sp3_conds_id_seq OWNER TO iftttuser;

--
-- Name: backend_sp3_conds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.backend_sp3_conds_id_seq OWNED BY public.backend_sp3_conds.id;


--
-- Name: backend_ssrule; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_ssrule (
    priority integer NOT NULL,
    action_id integer NOT NULL,
    rule_ptr_id integer NOT NULL
);


ALTER TABLE public.backend_ssrule OWNER TO iftttuser;

--
-- Name: backend_ssrule_triggers; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_ssrule_triggers (
    id integer NOT NULL,
    ssrule_id integer NOT NULL,
    trigger_id integer NOT NULL
);


ALTER TABLE public.backend_ssrule_triggers OWNER TO iftttuser;

--
-- Name: backend_ssrule_triggers_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.backend_ssrule_triggers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_ssrule_triggers_id_seq OWNER TO iftttuser;

--
-- Name: backend_ssrule_triggers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.backend_ssrule_triggers_id_seq OWNED BY public.backend_ssrule_triggers.id;


--
-- Name: backend_state; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_state (
    id integer NOT NULL,
    cap_id integer NOT NULL,
    dev_id integer NOT NULL,
    action boolean NOT NULL,
    text text,
    chan_id integer
);


ALTER TABLE public.backend_state OWNER TO iftttuser;

--
-- Name: backend_state_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.backend_state_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_state_id_seq OWNER TO iftttuser;

--
-- Name: backend_state_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.backend_state_id_seq OWNED BY public.backend_state.id;


--
-- Name: backend_statelog; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_statelog (
    id integer NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    is_current boolean NOT NULL,
    cap_id integer NOT NULL,
    dev_id integer NOT NULL,
    value text NOT NULL,
    param_id integer NOT NULL
);


ALTER TABLE public.backend_statelog OWNER TO iftttuser;

--
-- Name: backend_statelog_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.backend_statelog_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_statelog_id_seq OWNER TO iftttuser;

--
-- Name: backend_statelog_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.backend_statelog_id_seq OWNED BY public.backend_statelog.id;


--
-- Name: backend_timeparam; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_timeparam (
    parameter_ptr_id integer NOT NULL,
    mode text NOT NULL
);


ALTER TABLE public.backend_timeparam OWNER TO iftttuser;

--
-- Name: backend_trigger; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_trigger (
    id integer NOT NULL,
    cap_id integer NOT NULL,
    dev_id integer NOT NULL,
    chan_id integer,
    pos integer,
    text text
);


ALTER TABLE public.backend_trigger OWNER TO iftttuser;

--
-- Name: backend_trigger_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.backend_trigger_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_trigger_id_seq OWNER TO iftttuser;

--
-- Name: backend_trigger_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.backend_trigger_id_seq OWNED BY public.backend_trigger.id;


--
-- Name: backend_user; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.backend_user (
    id integer NOT NULL,
    name character varying(30),
    mode character varying(5) NOT NULL,
    code text NOT NULL
);


ALTER TABLE public.backend_user OWNER TO iftttuser;

--
-- Name: backend_user_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.backend_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.backend_user_id_seq OWNER TO iftttuser;

--
-- Name: backend_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.backend_user_id_seq OWNED BY public.backend_user.id;


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: jessejmart
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
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_admin_log_id_seq OWNER TO iftttuser;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO iftttuser;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO iftttuser;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO iftttuser;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_migrations_id_seq OWNER TO iftttuser;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO iftttuser;

--
-- Name: rule_management_abstractcharecteristic; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.rule_management_abstractcharecteristic (
    id integer NOT NULL,
    characteristic_name character varying(200) NOT NULL
);


ALTER TABLE public.rule_management_abstractcharecteristic OWNER TO iftttuser;

--
-- Name: rule_management_abstractcharecteristic_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.rule_management_abstractcharecteristic_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rule_management_abstractcharecteristic_id_seq OWNER TO iftttuser;

--
-- Name: rule_management_abstractcharecteristic_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.rule_management_abstractcharecteristic_id_seq OWNED BY public.rule_management_abstractcharecteristic.id;


--
-- Name: rule_management_device; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.rule_management_device (
    id integer NOT NULL,
    device_name character varying(200) NOT NULL
);


ALTER TABLE public.rule_management_device OWNER TO iftttuser;

--
-- Name: rule_management_device_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.rule_management_device_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rule_management_device_id_seq OWNER TO iftttuser;

--
-- Name: rule_management_device_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.rule_management_device_id_seq OWNED BY public.rule_management_device.id;


--
-- Name: rule_management_device_users; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.rule_management_device_users (
    id integer NOT NULL,
    device_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.rule_management_device_users OWNER TO iftttuser;

--
-- Name: rule_management_device_users_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.rule_management_device_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rule_management_device_users_id_seq OWNER TO iftttuser;

--
-- Name: rule_management_device_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.rule_management_device_users_id_seq OWNED BY public.rule_management_device_users.id;


--
-- Name: rule_management_devicecharecteristic; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.rule_management_devicecharecteristic (
    id integer NOT NULL,
    abstract_charecteristic_id integer NOT NULL,
    device_id integer NOT NULL
);


ALTER TABLE public.rule_management_devicecharecteristic OWNER TO iftttuser;

--
-- Name: rule_management_devicecharecteristic_affected_rules; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.rule_management_devicecharecteristic_affected_rules (
    id integer NOT NULL,
    devicecharecteristic_id integer NOT NULL,
    rule_id integer NOT NULL
);


ALTER TABLE public.rule_management_devicecharecteristic_affected_rules OWNER TO iftttuser;

--
-- Name: rule_management_devicecharecteristic_affected_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.rule_management_devicecharecteristic_affected_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rule_management_devicecharecteristic_affected_rules_id_seq OWNER TO iftttuser;

--
-- Name: rule_management_devicecharecteristic_affected_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.rule_management_devicecharecteristic_affected_rules_id_seq OWNED BY public.rule_management_devicecharecteristic_affected_rules.id;


--
-- Name: rule_management_devicecharecteristic_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.rule_management_devicecharecteristic_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rule_management_devicecharecteristic_id_seq OWNER TO iftttuser;

--
-- Name: rule_management_devicecharecteristic_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.rule_management_devicecharecteristic_id_seq OWNED BY public.rule_management_devicecharecteristic.id;


--
-- Name: rule_management_rule; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.rule_management_rule (
    id integer NOT NULL,
    rule_name character varying(200) NOT NULL
);


ALTER TABLE public.rule_management_rule OWNER TO iftttuser;

--
-- Name: rule_management_rule_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.rule_management_rule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rule_management_rule_id_seq OWNER TO iftttuser;

--
-- Name: rule_management_rule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.rule_management_rule_id_seq OWNED BY public.rule_management_rule.id;


--
-- Name: st_end_device; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.st_end_device (
    id integer NOT NULL,
    device_id character varying(40) NOT NULL,
    device_name character varying(80) NOT NULL,
    device_label character varying(80) NOT NULL
);


ALTER TABLE public.st_end_device OWNER TO iftttuser;

--
-- Name: st_end_device_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.st_end_device_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.st_end_device_id_seq OWNER TO iftttuser;

--
-- Name: st_end_device_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.st_end_device_id_seq OWNED BY public.st_end_device.id;


--
-- Name: st_end_stapp; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.st_end_stapp (
    id integer NOT NULL,
    st_installed_app_id character varying(40) NOT NULL,
    refresh_token character varying(40) NOT NULL
);


ALTER TABLE public.st_end_stapp OWNER TO iftttuser;

--
-- Name: st_end_stapp_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.st_end_stapp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.st_end_stapp_id_seq OWNER TO iftttuser;

--
-- Name: st_end_stapp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.st_end_stapp_id_seq OWNED BY public.st_end_stapp.id;


--
-- Name: user_auth_usermetadata; Type: TABLE; Schema: public; Owner: jessejmart
--

CREATE TABLE public.user_auth_usermetadata (
    id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.user_auth_usermetadata OWNER TO iftttuser;

--
-- Name: user_auth_usermetadata_id_seq; Type: SEQUENCE; Schema: public; Owner: jessejmart
--

CREATE SEQUENCE public.user_auth_usermetadata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_auth_usermetadata_id_seq OWNER TO iftttuser;

--
-- Name: user_auth_usermetadata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jessejmart
--

ALTER SEQUENCE public.user_auth_usermetadata_id_seq OWNED BY public.user_auth_usermetadata.id;


--
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- Name: auth_user id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.auth_user ALTER COLUMN id SET DEFAULT nextval('public.auth_user_id_seq'::regclass);


--
-- Name: auth_user_groups id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.auth_user_groups ALTER COLUMN id SET DEFAULT nextval('public.auth_user_groups_id_seq'::regclass);


--
-- Name: auth_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_user_user_permissions_id_seq'::regclass);


--
-- Name: backend_capability id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_capability ALTER COLUMN id SET DEFAULT nextval('public.backend_capability_id_seq'::regclass);


--
-- Name: backend_capability_channels id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_capability_channels ALTER COLUMN id SET DEFAULT nextval('public.backend_capability_channels_id_seq'::regclass);


--
-- Name: backend_channel id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_channel ALTER COLUMN id SET DEFAULT nextval('public.backend_channel_id_seq'::regclass);


--
-- Name: backend_condition id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_condition ALTER COLUMN id SET DEFAULT nextval('public.backend_condition_id_seq'::regclass);


--
-- Name: backend_device id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_device ALTER COLUMN id SET DEFAULT nextval('public.backend_device_id_seq'::regclass);


--
-- Name: backend_device_caps id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_device_caps ALTER COLUMN id SET DEFAULT nextval('public.backend_device_capabilities_id_seq'::regclass);


--
-- Name: backend_device_chans id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_device_chans ALTER COLUMN id SET DEFAULT nextval('public.backend_device_chans_id_seq'::regclass);


--
-- Name: backend_esrule_Striggers id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public."backend_esrule_Striggers" ALTER COLUMN id SET DEFAULT nextval('public."backend_esrule_triggersS_id_seq"'::regclass);


--
-- Name: backend_parameter id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_parameter ALTER COLUMN id SET DEFAULT nextval('public.backend_parameter_id_seq'::regclass);


--
-- Name: backend_parval id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_parval ALTER COLUMN id SET DEFAULT nextval('public.backend_parval_id_seq'::regclass);


--
-- Name: backend_rule id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_rule ALTER COLUMN id SET DEFAULT nextval('public.backend_rule_id_seq'::regclass);


--
-- Name: backend_safetyprop id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_safetyprop ALTER COLUMN id SET DEFAULT nextval('public.backend_safetyprop_id_seq'::regclass);


--
-- Name: backend_setparamopt id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_setparamopt ALTER COLUMN id SET DEFAULT nextval('public.backend_setparamopt_id_seq'::regclass);


--
-- Name: backend_sp1_triggers id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_sp1_triggers ALTER COLUMN id SET DEFAULT nextval('public.backend_sp1_triggers_id_seq'::regclass);


--
-- Name: backend_sp2_conds id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_sp2_conds ALTER COLUMN id SET DEFAULT nextval('public.backend_sp2_conds_id_seq'::regclass);


--
-- Name: backend_sp3_conds id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_sp3_conds ALTER COLUMN id SET DEFAULT nextval('public.backend_sp3_conds_id_seq'::regclass);


--
-- Name: backend_ssrule_triggers id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_ssrule_triggers ALTER COLUMN id SET DEFAULT nextval('public.backend_ssrule_triggers_id_seq'::regclass);


--
-- Name: backend_state id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_state ALTER COLUMN id SET DEFAULT nextval('public.backend_state_id_seq'::regclass);


--
-- Name: backend_statelog id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_statelog ALTER COLUMN id SET DEFAULT nextval('public.backend_statelog_id_seq'::regclass);


--
-- Name: backend_trigger id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_trigger ALTER COLUMN id SET DEFAULT nextval('public.backend_trigger_id_seq'::regclass);


--
-- Name: backend_user id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_user ALTER COLUMN id SET DEFAULT nextval('public.backend_user_id_seq'::regclass);


--
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- Name: rule_management_abstractcharecteristic id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.rule_management_abstractcharecteristic ALTER COLUMN id SET DEFAULT nextval('public.rule_management_abstractcharecteristic_id_seq'::regclass);


--
-- Name: rule_management_device id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.rule_management_device ALTER COLUMN id SET DEFAULT nextval('public.rule_management_device_id_seq'::regclass);


--
-- Name: rule_management_device_users id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.rule_management_device_users ALTER COLUMN id SET DEFAULT nextval('public.rule_management_device_users_id_seq'::regclass);


--
-- Name: rule_management_devicecharecteristic id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.rule_management_devicecharecteristic ALTER COLUMN id SET DEFAULT nextval('public.rule_management_devicecharecteristic_id_seq'::regclass);


--
-- Name: rule_management_devicecharecteristic_affected_rules id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.rule_management_devicecharecteristic_affected_rules ALTER COLUMN id SET DEFAULT nextval('public.rule_management_devicecharecteristic_affected_rules_id_seq'::regclass);


--
-- Name: rule_management_rule id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.rule_management_rule ALTER COLUMN id SET DEFAULT nextval('public.rule_management_rule_id_seq'::regclass);


--
-- Name: st_end_device id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.st_end_device ALTER COLUMN id SET DEFAULT nextval('public.st_end_device_id_seq'::regclass);


--
-- Name: st_end_stapp id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.st_end_stapp ALTER COLUMN id SET DEFAULT nextval('public.st_end_stapp_id_seq'::regclass);


--
-- Name: user_auth_usermetadata id; Type: DEFAULT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.user_auth_usermetadata ALTER COLUMN id SET DEFAULT nextval('public.user_auth_usermetadata_id_seq'::regclass);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: jessejmart
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
19	Can add user metadata	7	add_usermetadata
20	Can change user metadata	7	change_usermetadata
21	Can delete user metadata	7	delete_usermetadata
22	Can add rule	8	add_rule
23	Can change rule	8	change_rule
24	Can delete rule	8	delete_rule
25	Can add device	9	add_device
26	Can change device	9	change_device
27	Can delete device	9	delete_device
28	Can add abstract charecteristic	10	add_abstractcharecteristic
29	Can change abstract charecteristic	10	change_abstractcharecteristic
30	Can delete abstract charecteristic	10	delete_abstractcharecteristic
31	Can add device charecteristic	11	add_devicecharecteristic
32	Can change device charecteristic	11	change_devicecharecteristic
33	Can delete device charecteristic	11	delete_devicecharecteristic
34	Can add user	12	add_user
35	Can change user	12	change_user
36	Can delete user	12	delete_user
37	Can add channel	13	add_channel
38	Can change channel	13	change_channel
39	Can delete channel	13	delete_channel
40	Can add capability	14	add_capability
41	Can change capability	14	change_capability
42	Can delete capability	14	delete_capability
43	Can add parameter	15	add_parameter
44	Can change parameter	15	change_parameter
45	Can delete parameter	15	delete_parameter
46	Can add set param	16	add_setparam
47	Can change set param	16	change_setparam
48	Can delete set param	16	delete_setparam
49	Can add set param opt	17	add_setparamopt
50	Can change set param opt	17	change_setparamopt
51	Can delete set param opt	17	delete_setparamopt
52	Can add range param	18	add_rangeparam
53	Can change range param	18	change_rangeparam
54	Can delete range param	18	delete_rangeparam
55	Can add bin param	19	add_binparam
56	Can change bin param	19	change_binparam
57	Can delete bin param	19	delete_binparam
58	Can add color param	20	add_colorparam
59	Can change color param	20	change_colorparam
60	Can delete color param	20	delete_colorparam
61	Can add time param	21	add_timeparam
62	Can change time param	21	change_timeparam
63	Can delete time param	21	delete_timeparam
64	Can add duration param	22	add_durationparam
65	Can change duration param	22	change_durationparam
66	Can delete duration param	22	delete_durationparam
67	Can add input param	23	add_inputparam
68	Can change input param	23	change_inputparam
69	Can delete input param	23	delete_inputparam
70	Can add meta param	24	add_metaparam
71	Can change meta param	24	change_metaparam
72	Can delete meta param	24	delete_metaparam
73	Can add par val	25	add_parval
74	Can change par val	25	change_parval
75	Can delete par val	25	delete_parval
76	Can add condition	26	add_condition
77	Can change condition	26	change_condition
78	Can delete condition	26	delete_condition
79	Can add device	27	add_device
80	Can change device	27	change_device
81	Can delete device	27	delete_device
82	Can add state	28	add_state
83	Can change state	28	change_state
84	Can delete state	28	delete_state
85	Can add trigger	29	add_trigger
86	Can change trigger	29	change_trigger
87	Can delete trigger	29	delete_trigger
88	Can add rule	30	add_rule
89	Can change rule	30	change_rule
90	Can delete rule	30	delete_rule
91	Can add es rule	31	add_esrule
92	Can change es rule	31	change_esrule
93	Can delete es rule	31	delete_esrule
94	Can add ss rule	32	add_ssrule
95	Can change ss rule	32	change_ssrule
96	Can delete ss rule	32	delete_ssrule
97	Can add safety prop	33	add_safetyprop
98	Can change safety prop	33	change_safetyprop
99	Can delete safety prop	33	delete_safetyprop
100	Can add s p1	34	add_sp1
101	Can change s p1	34	change_sp1
102	Can delete s p1	34	delete_sp1
103	Can add s p2	35	add_sp2
104	Can change s p2	35	change_sp2
105	Can delete s p2	35	delete_sp2
106	Can add s p3	36	add_sp3
107	Can change s p3	36	change_sp3
108	Can delete s p3	36	delete_sp3
109	Can add state log	37	add_statelog
110	Can change state log	37	change_statelog
111	Can delete state log	37	delete_statelog
112	Can add st app	38	add_stapp
113	Can change st app	38	change_stapp
114	Can delete st app	38	delete_stapp
115	Can add device	39	add_device
116	Can change device	39	change_device
117	Can delete device	39	delete_device
\.


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 126, true);


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 1, false);


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- Data for Name: backend_binparam; Type: TABLE DATA; Schema: public; Owner: jessejmart
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
\.


--
-- Data for Name: backend_capability; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.backend_capability (id, name, commandlabel, eventlabel, statelabel, readable, writeable) FROM stdin;
28	Record	({DEVICE}) {value/T|start}{value/F|stop} recording	{DEVICE} {value/T|starts}{value/F|stops} recording	{DEVICE} is{value/F| not} recording	t	t
36	Channel	Tune {DEVICE} to Channel {channel}	{DEVICE} {channel/=|becomes tuned to}{channel/!=|becomes tuned to something other than}{channel/>|becomes tuned above}{channel/<|becomes tuned below} {channel}	{DEVICE} is {channel/=|tuned to}{channel/!=|not tuned to}{channel/>|tuned above}{channel/<|tuned below} Channel {channel}	t	t
65	Oven Temperature	Set {DEVICE}'s temperature to {temperature}	{DEVICE}'s temperature {temperature/=|becomes}{temperature/!=|changes from}{temperature/>|goes above}{temperature/<|falls below} {temperature} degrees	{DEVICE}'s temperature {temperature/=|is}{temperature/!=|is not}{temperature/>|is above}{temperature/<|is below} {temperature} degrees	t	t
27	Alarm Ringing	{value/T|Set off}{value/F|Turn off} {DEVICE}'s alarm	{DEVICE}'s Alarm {value/T|Starts}{value/F|Stops} going off	{DEVICE}'s Alarm is{value/F| not} going off	t	t
38	How Much Coffee Is There?	\N	({DEVICE}) The number of cups of coffee {cups/=|becomes}{cups/!=|changes from}{cups/>|becomes larger than}{cups/<|falls below} {cups}	({DEVICE}) There are {cups/=|exactly}{cups/!=|not exactly}{cups/>|more than}{cups/<|fewer than} {cups} cups of coffee brewed	t	f
18	Weather Sensor	\N	({DEVICE}) The weather {weather/=|becomes}{weather/!=|stops being} {weather}	({DEVICE}) The weather is{weather/!=| not} {weather}	t	f
62	Heart Rate Sensor	\N	({DEVICE}) My heart rate {BPM/=|becomes}{BPM/!=|changes from}{BPM/>|goes above}{BPM/<|falls below} {BPM}BPM	({DEVICE}) My heart rate is {BPM/=|exactly}{BPM/!=|not}{BPM/>|above}{BPM/<|below} {BPM}BPM	t	f
32	Track Package	\N	({DEVICE}) Package #{trackingid} {distance/=|becomes}{distance/!=|stops being}{distance/>|becomes farther than}{distance/<|becomes closer than} {distance} miles away	({DEVICE}) Package #{trackingid} is{distance/!=| not} {distance/<|<}{distance/>|>}{distance} miles away	t	f
12	FM Tuner	Tune {DEVICE} to {frequency}FM	{DEVICE} {frequency/=|becomes tuned to}{frequency/!=|stops being tuned to}{frequency/>|becomes tuned above}{frequency/<|becomes tuned below} {frequency}FM	{DEVICE} {frequency/=|is tuned to}{frequency/!=|is not tuned to}{frequency/>|is tuned above}{frequency/<|is tuned below} {frequency}FM	t	t
33	What's On My Shopping List?	\N	({DEVICE}) {item} {item/=|gets added to}{item/!=|gets removed from} my Shopping List	({DEVICE}) {item} is{item/!=| not} on my Shopping List	t	f
37	What Show is On?	\N	{name} {name/=|starts}{name/!=|stops} playing on {DEVICE}	{name} is{name/!=| not} playing on {DEVICE}	t	f
29	Take Photo	({DEVICE}) Take a photo		\N	f	t
30	Order (Amazon)	({DEVICE}) Order {quantity} {item} on Amazon		\N	f	t
31	Order Pizza	({DEVICE}) Order {quantity} {size} Pizza(s) with {topping}		\N	f	t
40	Siren	Turn {DEVICE}'s Siren {value}	{DEVICE}'s Siren turns {value}	{DEVICE}'s Siren is {value}	t	t
39	Brew Coffee	({DEVICE}) Brew {cups} cup(s) of coffee		\N	f	t
64	Water On/Off	Turn {setting} {DEVICE}'s water	{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}	{DEVICE}'s water is {setting/F|not }running	t	t
6	Light Color	Set {DEVICE}'s Color to {color}	{DEVICE}'s color {color/=|becomes}{color/!=|changes from} {color}	{DEVICE}'s Color {color/=|is}{color/!=|is not} {color}	t	t
26	Set Alarm	({DEVICE}) Set an Alarm for {time}	{DEVICE}'s Alarm {time/=|gets set for}{time/!=|gets set for something other than}{time/>|gets set for later than}{time/<|gets set for earlier than} {time}	{DEVICE}'s Alarm is {time/=|set for}{time/!=|not set for}{time/>|set for later than}{time/<|set for earlier than} {time}	t	t
19	Current Temperature	\N	({DEVICE}) The temperature {temperature/=|becomes}{temperature/!=|changes from}{temperature/>|goes above}{temperature/<|falls below} {temperature} degrees	({DEVICE}) The temperature {temperature/=|is}{temperature/!=|is not}{temperature/>|is above}{temperature/<|is below} {temperature} degrees	t	f
50	Event Frequency	\N	It becomes true that "{$trigger$}" has {occurrences/!=|not occurred}{occurrences/=|occurred}{occurrences/>|occurred more than}{occurrences/<|occurred fewer than} {occurrences} times in the last {time}	"{$trigger$}" has {occurrences/=|occurred exactly}{occurrences/!=|not occurred exactly}{occurrences/>|occurred more than}{occurrences/<|occurred fewer than} {occurrences} times in the last {time}	t	f
9	Genre	Start playing {genre} on {DEVICE}	{DEVICE} {genre/=|starts}{genre/!=|stops} playing {genre}	{DEVICE} is{genre/!=| not} playing {genre}	t	t
13	Lock/Unlock	{setting/T|Lock}{setting/F|Unlock} {DEVICE}	{DEVICE} {setting/T|Locks}{setting/F|Unlocks}	{DEVICE} is {setting}	t	t
14	Open/Close Window	{position/T|Open}{position/F|Close} {DEVICE}	{DEVICE} {position/T|Opens}{position/F|Closes}	{DEVICE} is {position}	t	t
15	Detect Motion	\N	{DEVICE} {status/T|Starts}{status/F|Stops} Detecting Motion	{DEVICE} {status/T|detects}{status/F|does not detect} motion	t	f
20	Is it Raining?	\N	It {condition/T|starts}{condition/F|stops} raining	It is {condition}	t	f
35	Play Music	Start playing {name} on {DEVICE}	{name} {name/=|starts}{name/!=|stops} playing on {DEVICE}	{name} is {name/!=|not }playing on {DEVICE}	t	t
49	Previous State	\N	It becomes true that "{$trigger$}" was active {time} ago	"{$trigger$}" was active {time} ago	t	f
51	Time Since State	\N	It becomes true that "{$trigger$}" was last in effect {time/>|more than}{time/<|less than}{time/=|exactly} {time} ago	"{$trigger$}" was last in effect {time/>|more than}{time/<|less than}{time/=|exactly} {time} ago	t	f
52	Time Since Event	\N	It becomes true that "{$trigger$}" last happened {time/>|more than}{time/<|less than}{time/=|exactly} {time} ago	"{$trigger$}" last happened {time/>|more than}{time/<|less than}{time/=|exactly} {time} ago	t	f
55	Is it Daytime?	\N	It becomes {time}time	It is {time}time	t	f
56	Stop Music	Stop playing music on {DEVICE}		\N	f	t
57	AC On/Off	Turn {setting} the AC	The AC turns {setting}	The AC is {setting}	t	t
58	Open/Close Curtains	{position/T|Open}{position/F|Close} {DEVICE}'s Curtains	{DEVICE}'s curtains {position/T|Open}{position/F|Close}	{DEVICE}'s curtains are {position}	t	t
59	Smoke Detection	\N	{DEVICE} {condition/T|Starts}{condition/F|Stops} detecting smoke	({DEVICE}) {condition/F|No }Smoke is Detected	t	f
60	Open/Close Door	{position/T|Open}{position/F|Close} {DEVICE}'s Door	{DEVICE}'s door {position/T|Opens}{position/F|Closes}	{DEVICE}'s door is {position}	t	t
61	Sleep Sensor	\N	({DEVICE}) I {status/T|Wake Up}{status/F|Fall Asleep}	({DEVICE}) I am {status}	t	f
63	Detect Presence	\N	{who/=|}{who/!=|Someone other than }{who} {location/=|Enters}{location/!=|Exits} {location}	{who/!=|Someone other than }{who} is {location/!=|not }in {location}	t	f
21	Thermostat	Set {DEVICE} to {temperature}	{DEVICE}'s temperature {temperature/=|becomes set to}{temperature/!=|changes from being set to}{temperature/>|becomes set above}{temperature/<|becomes set below} {temperature} degrees	{DEVICE} is {temperature/!=|not set to}{temperature/=|set to}{temperature/>|set above}{temperature/<|set below} {temperature} degrees	t	t
3	Brightness	Set {DEVICE}'s Brightness to {level}	{DEVICE}'s brightness {level/=|becomes}{level/!=|stops being}{level/>|goes above}{level/<|falls below} {level}	{DEVICE}'s Brightness {level/=|is}{level/!=|is not}{level/>|is above}{level/<|is below} {level}	t	t
8	Volume	Set {DEVICE}'s Volume to {level}	{DEVICE}'s Volume {level/=|becomes}{level/!=|changes from}{level/>|goes above}{level/<|falls below} {level}	{DEVICE}'s Volume {level/=|is}{level/!=|is not}{level/>|is above}{level/<|is below} {level}	t	t
25	Clock	\N	({DEVICE}) The time {time/=|becomes}{time/!=|changes from}{time/>|becomes later than}{time/<|becomes earlier than} {time}	({DEVICE}) The time {time/=|is}{time/!=|is not}{time/>|is after}{time/<|is before} {time}	t	f
2	Power On/Off	Turn {DEVICE} {setting}	{DEVICE} turns {setting}	{DEVICE} is {setting}	t	t
66	Temperature Control	Set {DEVICE}'s temperature to {temperature}	{DEVICE}'s temperature {temperature/=|becomes set to}{temperature/!=|becomes set to something other than}{temperature/>|becomes set above}{temperature/<|becomes set below} {temperature} degrees	{DEVICE}'s temperature is {temperature/=|set to}{temperature/!=|not set to}{temperature/>|set above}{temperature/<|set below} {temperature} degrees	t	t
\.


--
-- Data for Name: backend_capability_channels; Type: TABLE DATA; Schema: public; Owner: jessejmart
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
\.


--
-- Name: backend_capability_channels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.backend_capability_channels_id_seq', 82, true);


--
-- Name: backend_capability_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.backend_capability_id_seq', 67, true);


--
-- Data for Name: backend_channel; Type: TABLE DATA; Schema: public; Owner: jessejmart
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
-- Name: backend_channel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.backend_channel_id_seq', 18, true);


--
-- Data for Name: backend_colorparam; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.backend_colorparam (parameter_ptr_id, mode) FROM stdin;
\.


--
-- Data for Name: backend_condition; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.backend_condition (id, val, comp, par_id, trigger_id) FROM stdin;
104	Open	=	67	94
105	Open	=	67	95
106	On	=	72	96
107	Open	=	13	97
108	On	=	72	98
110	On	=	1	100
112	On	=	26	102
113	Open	=	67	103
114	Kitchen	=	70	104
115	Bobby	=	71	104
119	On	=	1	107
120	On	=	1	108
123	Open	=	67	111
124	Open	=	67	112
126	Red	!=	3	114
127	On	=	72	115
128	Open	=	13	116
129	70	>	18	117
130	Open	=	13	118
131	Raining	=	20	119
133	Home	=	70	121
134	Anyone	=	71	121
135	Pop	=	8	122
139	Open	=	65	126
41	Asleep	=	68	41
42	On	=	1	42
43	22	=	69	43
44	Red	=	3	44
140	On	=	1	127
46	Living Room	=	70	46
47	Anyone	=	71	46
142	Open	=	13	129
143	On	=	1	130
51	On	=	72	50
52	Kitchen	=	70	51
53	Anyone	=	71	51
144	Asleep	=	68	131
56	Red	!=	3	54
57	On	=	72	55
58	Kitchen	=	70	56
59	Anyone	=	71	56
60	Kitchen	=	70	57
61	Anyone	=	71	57
62	Kitchen	=	70	58
63	Anyone	=	71	58
64	Kitchen	=	70	59
65	Anyone	=	71	59
145	On	=	1	132
67	Asleep	=	68	61
68	Red	=	3	62
146	Asleep	=	68	133
147	On	=	1	134
148	Asleep	=	68	135
72	Open	=	67	66
74	Off	=	64	68
75	On	=	26	69
76	On	=	26	70
77	On	=	26	71
150	Asleep	=	68	137
79	On	=	26	73
80	28	<	73	74
151	On	=	1	138
152	Asleep	=	68	139
154	Asleep	=	68	141
155	Asleep	=	68	142
86	Open	=	67	80
87	Kitchen	=	70	81
88	Bobby	=	71	81
91	Awake	=	68	84
156	On	=	1	143
162	1	=	73	149
163	Open	=	13	150
164	Raining	=	20	151
165	Open	=	13	152
166	70	>	18	153
167	80	<	18	154
168	Open	=	13	155
169	70	>	18	156
170	80	<	18	157
171	Not Raining	=	20	158
172	Open	=	13	159
173	Raining	=	20	160
175	Raining	=	20	162
176	Open	=	67	163
177	Kitchen	=	70	164
178	Bobbie	=	71	164
179	80	<	21	165
180	80	<	21	166
181	40	<	18	167
182	Raining	=	20	168
183	Open	=	13	169
184	Open	=	67	170
185	Open	=	13	171
186	80	<	18	172
187	70	>	18	173
188	Not Raining	=	20	174
189	70	>	21	175
190	Home	=	70	176
191	Anyone	=	71	176
192	70	>	21	177
193	Home	=	70	178
194	Anyone	=	71	178
195	75	<	21	179
196	Home	=	70	180
197	Anyone	=	71	180
198	Open	=	65	181
199	Pop	=	8	182
200	On	=	1	183
201	Open	=	65	184
202	Unlocked	=	12	185
203	Home	!=	70	186
204	Family Member	=	71	186
205	Unlocked	=	12	187
206	Home	!=	70	188
207	A Family Member	=	71	188
208	On	=	1	189
209	Home	=	70	190
210	A Guest	=	71	190
214	On	=	1	193
216	Bedroom	=	70	195
217	Bobbie	=	71	195
218	On	=	1	196
219	Night	=	62	197
220	Off	=	1	198
221	On	=	1	199
222	Off	=	1	200
226	On	=	1	204
227	Night	=	62	205
232	On	=	26	209
233	On	=	1	210
234	On	=	1	211
237	On	=	1	214
239	On	=	1	216
240	On	=	1	217
242	Open	=	13	219
243	Raining	=	20	220
245	Open	=	13	222
246	Closed	=	13	223
247	Closed	=	13	224
248	Closed	=	13	225
249	Closed	=	13	226
250	Closed	=	13	227
251	Closed	=	13	228
252	Closed	=	13	229
253	Closed	=	13	230
254	Closed	=	13	231
255	Open	=	67	232
256	Kitchen	=	70	233
257	Bobbie	=	71	233
258	Kitchen	=	70	234
259	Bobbie	=	71	234
260	Open	=	67	235
261	80	>	18	236
262	40	<	18	237
263	{'channel': {'name': 'Water & Plumbing', 'id': 17, 'icon': 'local_drink'}, 'parameters': [{'name': 'setting', 'type': 'bin', 'id': 72, 'values': ['On', 'Off']}], 'device': {'name': 'Smart Faucet', 'id': 22}, 'capability': {'name': 'Water On/Off', 'id': 64, 'label': "{DEVICE}'s water is {setting/F|not }running"}, 'parameterVals': [{'comparator': '=', 'value': 'Off'}], 'text': "Smart Faucet's water is not running"}	=	55	238
264	{'seconds': 0, 'hours': 0, 'minutes': 1}	=	56	238
265	{'channel': {'name': 'Water & Plumbing', 'id': 17, 'icon': 'local_drink'}, 'parameters': [{'name': 'setting', 'type': 'bin', 'id': 72, 'values': ['On', 'Off']}], 'device': {'name': 'Smart Faucet', 'id': 22}, 'capability': {'name': 'Water On/Off', 'id': 64, 'label': "{DEVICE}'s water is {setting/F|not }running"}, 'parameterVals': [{'comparator': '=', 'value': 'Off'}], 'text': "Smart Faucet's water is not running"}	=	55	239
266	{'seconds': 0, 'hours': 0, 'minutes': 5}	=	56	239
267	80	<	18	240
268	70	>	18	241
269	Clear	=	17	242
270	Closed	=	13	243
271	70	>	18	244
272	80	<	18	245
273	Clear	=	17	246
274	Closed	=	13	247
275	Clear	=	17	248
276	80	<	18	249
277	70	>	18	250
278	Closed	=	13	251
279	Closed	=	13	252
280	80	<	18	253
281	70	>	18	254
282	Clear	=	17	255
283	On	=	1	256
284	Home	=	70	257
285	A Guest	=	71	257
286	Unlocked	=	12	258
287	On	=	1	259
288	On	=	1	260
289	Home	=	70	261
290	Anyone	=	71	261
291	On	=	1	262
292	Home	=	70	263
293	Anyone	=	71	263
295	Home	=	70	265
296	Anyone	=	71	265
298	On	=	1	267
300	On	=	1	269
302	On	=	1	271
304	On	=	1	273
305	On	=	1	274
306	Home	=	70	275
307	A Family Member	=	71	275
314	Closed	=	13	280
315	Closed	=	13	281
316	Open	=	67	282
317	Kitchen		70	283
318	Bobbie		71	283
319	80	>	21	284
320	40	<	18	285
321	{'text': "Smart Refrigerator's door Opens", 'parameterVals': [{'comparator': '=', 'value': 'Open'}], 'device': {'name': 'Smart Refrigerator', 'id': 8}, 'parameters': [{'name': 'position', 'id': 67, 'type': 'bin', 'values': ['Open', 'Closed']}], 'capability': {'name': 'Open/Close Door', 'id': 60, 'label': "{DEVICE}'s door {position/T|Opens}{position/F|Closes}"}, 'channel': {'name': 'Food & Cooking', 'id': 13, 'icon': 'fastfood'}}	=	57	286
322	{'hours': 0, 'seconds': 0, 'minutes': 1}	>	58	286
323	{'text': "Smart Faucet's water is running", 'parameterVals': [{'comparator': '=', 'value': ' '}], 'device': {'name': 'Smart Faucet', 'id': 22}, 'parameters': [{'name': 'setting', 'id': 72, 'type': 'bin', 'values': ['On', 'Off']}], 'capability': {'name': 'Water On/Off', 'id': 64, 'label': "{DEVICE}'s water is {setting/F|not }running"}, 'channel': {'name': 'Water & Plumbing', 'id': 17, 'icon': 'local_drink'}}	=	55	287
324	{'hours': 0, 'seconds': 15, 'minutes': 0}	>	56	287
325	40	=	18	288
326	40	<	18	289
327	Asleep	=	68	290
328	{'text': '(FitBit) I fall asleep', 'parameterVals': [{'comparator': '=', 'value': 'Asleep'}], 'device': {'name': 'FitBit', 'id': 21}, 'parameters': [{'name': 'status', 'id': 68, 'type': 'bin', 'values': ['Awake', 'Asleep']}], 'capability': {'name': 'Sleep Sensor', 'id': 61, 'label': '({DEVICE}) I {status/T|wake up}{status/F|fall asleep}'}, 'channel': {'name': 'Health', 'id': 16, 'icon': 'favorite_border'}}	=	57	291
329	{'hours': 0, 'seconds': 0, 'minutes': 30}	>	58	291
330	On	=	1	292
331	60	>	18	293
332	80	<	18	294
333	Not Raining	=	20	295
334	Closed	=	13	296
335	Pop	=	35	297
336	On	=	1	298
337	Open	=	65	299
338	Unlocked	=	12	300
339	Asleep	=	68	301
340	On	=	1	302
341	{'text': 'A Guest enters Home', 'parameterVals': [{'comparator': '=', 'value': 'Home'}, {'comparator': ' ', 'value': 'A Guest'}], 'device': {'name': 'Location Sensor', 'id': 12}, 'parameters': [{'name': 'location', 'id': 70, 'type': 'set', 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room']}, {'name': 'who', 'id': 71, 'type': 'set', 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest']}], 'capability': {'name': 'Detect Presence', 'id': 63, 'label': '{who/!=|Someone other than }{who} {location/=|enters}{location/!=|exits} {location}'}, 'channel': {'name': 'Location', 'id': 15, 'icon': 'room'}}	=	57	303
342	{'hours': 3, 'seconds': 0, 'minutes': 0}	<	58	303
343	{'text': '(FitBit) I fall asleep', 'parameterVals': [{'comparator': '=', 'value': 'Asleep'}], 'device': {'name': 'FitBit', 'id': 21}, 'parameters': [{'name': 'status', 'id': 68, 'type': 'bin', 'values': ['Awake', 'Asleep']}], 'capability': {'name': 'Sleep Sensor', 'id': 61, 'label': '({DEVICE}) I {status/T|wake up}{status/F|fall asleep}'}, 'channel': {'name': 'Health', 'id': 16, 'icon': 'favorite_border'}}	=	57	304
344	{'hours': 0, 'seconds': 0, 'minutes': 30}	>	58	304
345	On	=	1	305
346	Open	=	67	306
347	Open	=	67	307
348	75	<	21	308
349	Home	 	70	309
350	Anyone	 	71	309
351	80	=	21	310
352	80	=	21	311
353	Off	=	1	312
354	Asleep	=	68	313
355	On	=	1	314
356	Home	 	70	315
357	A Guest	 	71	315
358	Unlocked	=	12	316
359	Asleep	=	68	317
360	On	=	1	318
361	Open	=	65	319
362	Pop	=	35	320
363	Open	=	65	321
364	70	<	21	322
365	Open	=	13	323
366	60	>	18	324
367	80	<	18	325
368	Not Raining	=	20	326
372	 	=	72	330
373	Open	=	67	331
374	40	<	18	332
375	80	<	18	333
376	Open	=	67	334
377	Kitchen	 	70	335
378	Bobbie	 	71	335
379	Open	=	13	336
380	Raining	=	20	337
381	Open	=	67	338
382	On	=	1	339
383	80	>	18	340
384	On	=	1	341
385	Home	 	70	342
386	A Guest	 	71	342
387	Closed	=	13	343
388	Closed	=	13	344
389	Closed	=	13	345
390	Night	=	62	346
391	On	=	1	347
392	75	<	21	348
393	Home	 	70	349
394	Anyone	=	71	349
395	70	>	21	350
396	Home	 	70	351
397	Anyone	 	71	351
398	40	<	75	352
399	On	=	64	353
400	80	>	18	354
401	On	=	1	355
402	adam	 	37	356
403	Asleep	=	68	357
404	On	=	1	358
405	Asleep	=	68	359
406	On	=	1	360
407	Off	=	1	361
408	Off	=	1	362
409		=	52	363
410	{'seconds': 0, 'hours': 0, 'minutes': 0}	=	53	363
411	8	=	54	363
412	275	!=	74	364
413	Off	=	1	365
415	On	=	1	367
416	Pop	=	8	368
417	40	<	18	369
418	80	>	18	370
419	5	>	74	371
420	Open	=	67	372
421	5	>	74	373
422	Open	=	67	374
423	80	>	18	375
424	Open	=	13	376
425	60	<	18	377
426	Kitchen	=	70	378
427	Bobbie	 	71	378
428	40	<	18	379
429	Pop	=	8	380
430	{'text': "Smart Faucet's water turns On", 'parameters': [{'id': 72, 'type': 'bin', 'values': ['On', 'Off'], 'name': 'setting'}], 'capability': {'label': "{DEVICE}'s water turns {setting}", 'id': 64, 'name': 'Water On/Off'}, 'device': {'id': 22, 'name': 'Smart Faucet'}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'parameterVals': [{'comparator': '=', 'value': 'On'}]}	=	52	381
431	{'minutes': 0, 'seconds': 15, 'hours': 0}	=	53	381
432	1	>	54	381
433	On	=	1	382
434	{'text': "Smart Faucet's water turns On", 'parameters': [{'id': 72, 'type': 'bin', 'values': ['On', 'Off'], 'name': 'setting'}], 'capability': {'label': "{DEVICE}'s water turns {setting}", 'id': 64, 'name': 'Water On/Off'}, 'device': {'id': 22, 'name': 'Smart Faucet'}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'parameterVals': [{'comparator': '=', 'value': 'On'}]}	=	52	383
435	{'minutes': 0, 'seconds': 15, 'hours': 0}	=	53	383
436	1	>	54	383
437	Pop	!=	8	384
438	Closed	=	13	385
439	Closed	=	13	386
440	Open	=	13	387
441	Pop	 	8	388
442	Open	=	67	389
443	Open	=	67	390
444	On	=	1	391
450	On	=	1	397
451	Asleep	=	68	398
453	On	=	1	400
456	Off	=	72	403
457	Off	=	72	404
458	Open	=	13	405
459	Closed	=	13	406
460	Closed	=	13	407
461	Open	=	13	408
462	Closed	=	13	409
463	Closed	=	13	410
464	 	=	72	411
465	Off	=	72	412
466	Open	=	13	413
467	Closed	=	13	414
468	Closed	=	13	415
469	On	=	1	416
470	15:00	<	23	417
471	00:00	>	23	418
472	80	<	18	419
473	On	=	1	420
474	15:00	<	23	421
475	00:00	>	23	422
476	80	<	18	423
478	Closed	=	65	425
479	Open	=	65	426
480	On	=	1	427
481	Closed	=	65	428
482	80	>	18	429
483	80	=	18	430
484	80	>	18	431
485	80	=	18	432
487	On	=	64	434
488	Off	=	1	435
489	Home	 	70	436
490	A Guest	 	71	436
492	Home	!=	70	438
493	Anyone	!=	71	438
494	On	=	64	439
495	80	=	18	440
496	Off	=	1	441
497	Asleep	=	68	442
498	Open	=	65	443
500	Closed	=	65	445
501	80	>	18	446
503	80	>	18	448
504	Home	!=	70	449
505	Anyone	=	71	449
509	On	=	1	452
510	Open	=	65	453
511	Open	=	65	454
512	Open	=	65	455
513	80	>	18	456
514	Open	=	67	457
515	Open	=	67	458
517	Open	=	65	460
518	Locked	=	12	461
519	Asleep	=	68	462
520	Home	=	70	463
521	A Guest	 	71	463
522	Open	=	13	464
523	Open	=	13	465
524	Open	=	13	466
525	60	>	18	467
526	80	<	18	468
527	Locked	=	12	469
528	Asleep	=	68	470
529	Open	=	13	471
530	60	>	18	472
531	80	<	18	473
532	Not Raining	=	20	474
533	Open	=	65	475
534	{'text': 'A Guest enters Home', 'parameters': [{'id': 70, 'type': 'set', 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room'], 'name': 'location'}, {'id': 71, 'type': 'set', 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest'], 'name': 'who'}], 'capability': {'label': '{who/!=|Someone other than }{who} {location/=|enters}{location/!=|exits} {location}', 'id': 63, 'name': 'Detect Presence'}, 'device': {'id': 12, 'name': 'Location Sensor'}, 'channel': {'icon': 'visibility', 'id': 6, 'name': 'Sensors'}, 'parameterVals': [{'comparator': '=', 'value': 'Home'}, {'comparator': ' ', 'value': 'A Guest'}]}	=	57	476
535	{'minutes': 0, 'seconds': 0, 'hours': 3}	>	58	476
536	80	<	18	477
537	75	>	21	478
538	Kitchen	=	70	479
539	Bobbie	=	71	479
540	73	=	21	480
541	80	>	18	481
542	Off	=	72	482
543	 	=	72	483
544	Open	=	65	484
545	Pop	=	8	485
546	Asleep	=	68	486
547	39	=	75	487
548	40	>	75	488
549	pop music	!=	35	489
550	Closed	=	13	490
551	Closed	=	13	491
552	Closed	=	13	492
553	Closed	=	13	493
554	Closed	=	13	494
555	Closed	=	13	495
556	Open	=	67	496
557	{'text': "Smart Refrigerator's door Opens", 'parameters': [{'id': 67, 'type': 'bin', 'values': ['Open', 'Closed'], 'name': 'position'}], 'capability': {'label': "{DEVICE}'s door {position/T|Opens}{position/F|Closes}", 'id': 60, 'name': 'Open/Close Door'}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'parameterVals': [{'comparator': '=', 'value': 'Open'}]}	=	57	497
558	{'minutes': 2, 'seconds': 0, 'hours': 0}	=	58	497
559	81	=	21	498
560	Home	 	70	499
561	Anyone	=	71	499
562	Closed	=	13	500
563	Closed	=	13	501
564	Open	=	67	502
565	{'text': "Smart Refrigerator's door Opens", 'parameters': [{'id': 67, 'type': 'bin', 'values': ['Open', 'Closed'], 'name': 'position'}], 'capability': {'label': "{DEVICE}'s door {position/T|Opens}{position/F|Closes}", 'id': 60, 'name': 'Open/Close Door'}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'parameterVals': [{'comparator': '=', 'value': 'Open'}]}	=	57	503
566	{'minutes': 2, 'seconds': 0, 'hours': 0}	=	58	503
567	81	=	21	504
568	Home	 	70	505
569	Anyone	=	71	505
570	Closed	=	13	506
571	Closed	=	13	507
572	Off	=	1	508
573	Asleep	=	68	509
574	0	=	7	510
575	Pop	 	8	511
576	Off	=	72	512
577		=	72	513
578	Off	=	1	514
579	Asleep	=	68	515
580	Asleep	=	68	516
581	Home	=	70	517
582	Anyone	=	71	517
583	Open	=	13	518
584	80	>	18	519
585	60	>	18	520
586	Raining	=	20	521
587	Sunny	 	17	522
588	Snowing	 	17	523
589	Unlocked	=	12	524
590	Bedroom	 	70	525
591	Anyone	=	71	525
592	{'text': "Smart Faucet's water is running", 'parameters': [{'id': 72, 'type': 'bin', 'values': ['On', 'Off'], 'name': 'setting'}], 'capability': {'label': "{DEVICE}'s water is {setting/F|not }running", 'id': 64, 'name': 'Water On/Off'}, 'device': {'id': 22, 'name': 'Smart Faucet'}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'parameterVals': [{'comparator': '=', 'value': ' '}]}	=	50	526
593	{'minutes': 0, 'seconds': 15, 'hours': 0}	=	51	526
594	Open	=	13	527
595	Raining	=	20	528
596	Open	=	13	529
597	80	=	18	530
598	On	=	1	531
599	Kitchen	=	70	532
600	Bobbie	=	71	532
601	Kitchen	!=	70	533
602	A Family Member	=	71	533
603	Open	=	13	534
604	60	<	18	535
605	Open	=	13	536
606	59	>	18	537
607	Open	=	13	538
608	81	<	18	539
609	Closed	=	67	540
610	Open	=	67	541
611	40	!=	75	542
612	30	<	18	543
613	Home	!=	70	544
614	Anyone	 	71	544
615	Open	=	13	545
616	Raining	=	17	546
617	Open	=	67	547
618	Home	=	70	548
619	Anyone	 	71	548
620	Open	=	13	549
621	Raining	!=	17	550
623	On	=	1	552
624	Closed	=	13	553
625	70	=	18	554
626	On	=	72	555
627	 	=	72	556
628	Closed	=	13	557
629	70	>	18	558
630	Open	=	13	559
631	Closed	=	13	560
632	80	>	18	561
633	Pop	!=	8	562
634	Closed	=	13	563
635	60	<	18	564
636	On	=	1	565
637	Open	=	65	566
638	Closed	=	13	567
639	Raining	=	20	568
640	On	=	64	569
641	Home	!=	70	570
642	Anyone	 	71	570
643	Off	=	64	571
644	Home	 	70	572
645	Anyone	=	71	572
646	80	>	18	573
647	67	<	18	574
648	80	>	18	575
649	67	<	18	576
650	Pop	=	8	577
651	On	=	64	578
653	On	=	1	580
654	Pop	=	8	581
655	72	!=	18	582
656	Home	 	70	583
657	Anyone	 	71	583
658	Closed	=	65	584
659	On	=	1	585
660	Closed	=	65	586
661	On	=	1	587
662	Closed	=	65	588
663	On	=	1	589
664	Closed	=	13	590
665	Closed	=	13	591
666	Closed	=	13	592
667	Unlocked	=	12	593
668	Living Room	!=	70	594
669	A Family Member	 	71	594
670	No	=	25	595
671	Closed	=	13	596
672	Closed	=	13	597
673	Closed	=	13	598
674	On	=	72	599
675	{'text': "Smart Faucet's water turns On", 'parameters': [{'id': 72, 'type': 'bin', 'values': ['On', 'Off'], 'name': 'setting'}], 'capability': {'label': "{DEVICE}'s water turns {setting}", 'id': 64, 'name': 'Water On/Off'}, 'device': {'id': 22, 'name': 'Smart Faucet'}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'parameterVals': [{'comparator': '=', 'value': 'On'}]}	=	57	600
676	{'minutes': 0, 'seconds': 14, 'hours': 0}	>	58	600
677	Unlocked	=	12	601
678	Asleep	=	68	602
679	Closed	=	13	603
680	Closed	=	13	604
681	Closed	=	13	605
682	Closed	=	13	606
683	Closed	=	13	607
684	Open	=	13	608
685	Unlocked	=	12	609
686	Living Room	!=	70	610
687	A Family Member	 	71	610
688	No	=	25	611
689	Asleep	=	68	612
690	On	=	1	613
691	23:00	>	23	614
692	Unlocked	=	12	615
693	Living Room	!=	70	616
694	A Family Member	 	71	616
695	 	=	25	617
696	Kitchen	=	70	618
697	Bobbie	 	71	618
698	Kitchen	!=	70	619
699	Bobbie	!=	71	619
700	Open	=	65	620
701	On	=	1	621
702	Open	=	65	622
703	On	=	1	623
704	 	=	72	624
705	Open	=	65	625
706	On	=	1	626
707	80	=	18	627
708	Asleep	=	68	628
709	42	<	18	629
710	40	=	18	630
711	Home	 	70	631
712	Anyone	=	71	631
713	70	<	21	632
714	Home	=	70	633
715	Anyone	=	71	633
716	75	>	21	634
717	Asleep	=	68	635
718	Open	=	13	636
719	80	>	18	637
720	Asleep	=	68	638
721	Closed	=	13	639
722	Closed	=	13	640
723	Closed	=	13	641
724	Open	=	13	642
725	60	<	18	643
726	Closed	=	13	644
727	Closed	=	13	645
728	Closed	=	13	646
729	Open	=	13	647
730	Raining	=	20	648
731	40	=	18	649
732	40	<	75	650
733	Closed	=	13	651
734	Closed	=	13	652
735	Closed	=	13	653
736	Pop	=	8	654
737	Locked	=	12	655
738	On	=	1	656
741	On	=	1	658
742	Home	 	70	659
743	A Guest	=	71	659
744	Day	=	62	660
745	Open	=	13	661
746	Open	=	65	662
747	Open	=	65	663
748	Home	=	70	664
749	A Guest	 	71	664
750	Day	=	62	665
751	On	=	1	666
752	80	=	18	667
753	 	=	72	668
754	40	<	18	669
755	Day	=	62	670
756	Night	=	62	671
757	Off	=	1	672
758	Asleep	=	68	673
759	81	=	18	674
760	79	=	18	675
761	On	=	64	676
762	Pop	=	8	677
764	23:00	>	23	679
765	On	=	1	680
766	On	=	1	681
767	23:50	>	23	682
768	Locked	=	12	683
769	Kitchen	 	70	684
770	Bobbie	 	71	684
771	Locked	=	12	685
772	Kitchen	 	70	686
773	Bobbie	 	71	686
774	72	=	18	687
775	Home	 	70	688
776	A Family Member	 	71	688
777	Closed	=	67	689
778	Locked	=	12	690
779	76	=	21	691
780	Home	!=	70	692
781	Anyone	 	71	692
782	Locked	=	12	693
783	On	=	1	694
784	Home	!=	70	695
785	Anyone	=	71	695
786	Home	!=	70	696
787	Anyone	=	71	696
788	75	>	18	697
789	On	=	40	698
790	23:45	>	23	699
791	70	=	18	700
792	On	=	64	701
793	40	>	18	702
794	44	<	18	703
795	Motion	=	14	704
796	23:45	>	23	705
797	Closed	=	67	706
798	Open	=	67	707
799	Unlocked	=	12	708
800	300	>	74	709
801	On	=	1	710
802	Home	 	70	711
803	A Guest	 	71	711
804	On	=	1	712
805	Home	 	70	713
806	A Guest	 	71	713
807	Open	=	67	714
808	45	>	75	715
809	Open	=	65	716
810	Open	=	67	717
811	Kitchen	 	70	718
812	Bobbie	 	71	718
813	Open	=	67	719
814	Kitchen	 	70	720
815	Bobbie	 	71	720
816	Open	=	67	721
817	Pop Music	=	35	722
818	Open	=	67	723
819	Kitchen	 	70	724
820	Bobbie	 	71	724
821	Off	=	1	725
822	Asleep	=	68	726
823	On	=	72	727
824	Off	=	1	728
825	Asleep	=	68	729
826	Open	=	65	730
827	On	=	1	731
828	Awake	=	68	732
829	Closed	=	13	733
830	Closed	=	13	734
831	Closed	=	13	735
832	Off	=	1	736
833	Asleep	=	68	737
834	Off	=	1	738
835	Asleep	=	68	739
836	Off	=	1	740
837	Asleep	=	68	741
838	Bathroom	 	70	742
839	Anyone	 	71	742
840	Open	=	65	743
841	Off	=	1	744
842	Asleep	=	68	745
843	Off	=	1	746
844	Asleep	=	68	747
845	On	=	1	748
846	Open	=	65	749
847	On	=	1	750
848	Open	=	65	751
849	On	=	1	752
850	Open	=	65	753
851	Pop	=	8	754
852	On	=	1	755
853	Pop	 	8	756
854	70	>	18	757
855	Home	=	70	758
856	Anyone	=	71	758
857	75	<	18	759
858	Home	=	70	760
859	Anyone	=	71	760
860	Pop	=	8	761
861	Home	 	70	762
862	Anyone	 	71	762
863	Pop	 	8	763
864	 	=	72	764
865	 	=	72	765
866	40	<	75	766
867	80	<	21	767
868	80	>	18	768
869	80	>	18	769
870	40	<	18	770
871	40	<	18	771
872	40	<	75	772
873	{'text': "Open Smart Refrigerator's Door", 'parameters': [{'id': 67, 'type': 'bin', 'values': ['Open', 'Closed'], 'name': 'position'}], 'capability': {'label': "{position/T|Open}{position/F|Close} {DEVICE}'s Door", 'id': 60, 'name': 'Open/Close Door'}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'parameterVals': [{'comparator': '=', 'value': 'Open'}]}	=	50	773
874	{'minutes': 2, 'seconds': 0, 'hours': 0}	=	51	773
875	Open	=	67	774
876	80	>	18	775
877	80	>	18	776
878	80	>	18	777
880	80	>	18	779
881	22:30	=	23	780
882	Night	=	62	781
883	22:30	=	23	782
885	60	<	18	784
887	Raining	=	20	786
888	On	=	1	787
889	Open	=	13	788
890	On	=	1	789
891	Home	=	70	790
892	Anyone	=	71	790
893	{'text': 'Anyone is in Home', 'parameters': [{'id': 70, 'type': 'set', 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room'], 'name': 'location'}, {'id': 71, 'type': 'set', 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest'], 'name': 'who'}], 'capability': {'label': '{who/!=|Someone other than }{who} is {location/!=|not }in {location}', 'id': 63, 'name': 'Detect Presence'}, 'device': {'id': 12, 'name': 'Location Sensor'}, 'channel': {'icon': 'visibility', 'id': 6, 'name': 'Sensors'}, 'parameterVals': [{'comparator': '=', 'value': 'Home'}, {'comparator': '=', 'value': 'Anyone'}]}	=	57	791
894	{'minutes': 59, 'seconds': 59, 'hours': 2}	<	58	791
895	Open	=	13	792
896	Raining	=	20	793
897	Open	=	13	794
898	80	>	18	795
899	On	=	1	796
900	On	=	1	797
901	Open	=	13	798
902	60	<	18	799
903	On	=	1	800
904	Open	=	13	801
905	Clear	 	17	802
907	Clear	 	17	804
908	Open	=	13	805
909	Asleep	=	68	806
910	Off	=	1	807
911	On	=	1	808
1065	On	=	1	931
1189	Open	=	65	1046
1193	39	=	18	1049
1196	Closed	=	13	1052
1197	Closed	=	13	1053
912	{'text': 'Anyone is in Home', 'parameters': [{'id': 70, 'type': 'set', 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room'], 'name': 'location'}, {'id': 71, 'type': 'set', 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest'], 'name': 'who'}], 'capability': {'label': '{who/!=|Someone other than }{who} is {location/!=|not }in {location}', 'id': 63, 'name': 'Detect Presence'}, 'device': {'id': 12, 'name': 'Location Sensor'}, 'channel': {'icon': 'visibility', 'id': 6, 'name': 'Sensors'}, 'parameterVals': [{'comparator': '=', 'value': 'Home'}, {'comparator': '=', 'value': 'Anyone'}]}	=	57	809
913	{'minutes': 0, 'seconds': 1, 'hours': 0}	=	58	809
914	{'text': 'Anyone is in Home', 'parameters': [{'id': 70, 'type': 'set', 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room'], 'name': 'location'}, {'id': 71, 'type': 'set', 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest'], 'name': 'who'}], 'capability': {'label': '{who/!=|Someone other than }{who} is {location/!=|not }in {location}', 'id': 63, 'name': 'Detect Presence'}, 'device': {'id': 12, 'name': 'Location Sensor'}, 'channel': {'icon': 'room', 'id': 15, 'name': 'Location'}, 'parameterVals': [{'comparator': '=', 'value': 'Home'}, {'comparator': '=', 'value': 'Anyone'}]}	=	57	810
915	{'minutes': 0, 'seconds': 1, 'hours': 3}	>	58	810
917	23:59	<	23	812
918	Asleep	=	68	813
919	On	=	1	814
920	23:59	<	23	815
921	Open	=	13	816
922	Closed	=	13	817
923	On	=	1	818
924	Open	=	13	819
925	Closed	=	13	820
926	Open	=	13	821
927	Closed	=	13	822
928	Open	=	13	823
929	Closed	=	13	824
930	Open	=	13	825
931	Closed	=	13	826
932	Open	=	13	827
933	Closed	=	13	828
934	40	<	18	829
935	Asleep	=	68	830
936	On	=	1	831
937	23:59	<	23	832
938	Open	=	67	833
939	Kitchen	!=	70	834
940	Anyone	 	71	834
941	{'text': "Open Smart Refrigerator's Door", 'parameters': [{'id': 67, 'type': 'bin', 'values': ['Open', 'Closed'], 'name': 'position'}], 'capability': {'label': "{position/T|Open}{position/F|Close} {DEVICE}'s Door", 'id': 60, 'name': 'Open/Close Door'}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'parameterVals': [{'comparator': '=', 'value': 'Open'}]}	=	55	835
942	{'minutes': 2, 'seconds': 0, 'hours': 0}	>	56	835
943	Open	=	67	836
944	Kitchen	=	70	837
945	Anyone	 	71	837
946	Locked	=	12	838
947	On	=	72	839
948	{'text': "Smart Faucet's water turns On", 'parameters': [{'id': 72, 'type': 'bin', 'values': ['On', 'Off'], 'name': 'setting'}], 'capability': {'label': "{DEVICE}'s water turns {setting}", 'id': 64, 'name': 'Water On/Off'}, 'device': {'id': 22, 'name': 'Smart Faucet'}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'parameterVals': [{'comparator': '=', 'value': 'On'}]}	=	57	840
949	{'minutes': 0, 'seconds': 15, 'hours': 0}	>	58	840
950	Open	=	65	841
951	{'text': "Smart Faucet's water turns On", 'parameters': [{'id': 72, 'type': 'bin', 'values': ['On', 'Off'], 'name': 'setting'}], 'capability': {'label': "{DEVICE}'s water turns {setting}", 'id': 64, 'name': 'Water On/Off'}, 'device': {'id': 22, 'name': 'Smart Faucet'}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'parameterVals': [{'comparator': '=', 'value': 'On'}]}	=	57	842
952	{'minutes': 0, 'seconds': 15, 'hours': 0}	>	58	842
956	On	=	1	845
957	Kitchen	!=	70	846
958	Bobbie	!=	71	846
959	On	=	72	847
963	pop music	=	35	850
964	On	=	1	851
965	Home	=	70	852
966	A Guest	 	71	852
967	{'text': 'A Guest is in Home', 'parameters': [{'id': 70, 'type': 'set', 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room'], 'name': 'location'}, {'id': 71, 'type': 'set', 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest'], 'name': 'who'}], 'capability': {'label': '{who/!=|Someone other than }{who} is {location/!=|not }in {location}', 'id': 63, 'name': 'Detect Presence'}, 'device': {'id': 12, 'name': 'Location Sensor'}, 'channel': {'icon': 'room', 'id': 15, 'name': 'Location'}, 'parameterVals': [{'comparator': ' ', 'value': 'Home'}, {'comparator': ' ', 'value': 'A Guest'}]}	=	57	853
968	{'minutes': 0, 'seconds': 0, 'hours': 3}	<	58	853
969	Bathroom	=	70	854
970	Anyone	 	71	854
971	On	=	1	855
972	Home	=	70	856
973	A Guest	 	71	856
974	{'text': 'A Guest is in Home', 'parameters': [{'id': 70, 'type': 'set', 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room'], 'name': 'location'}, {'id': 71, 'type': 'set', 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest'], 'name': 'who'}], 'capability': {'label': '{who/!=|Someone other than }{who} is {location/!=|not }in {location}', 'id': 63, 'name': 'Detect Presence'}, 'device': {'id': 12, 'name': 'Location Sensor'}, 'channel': {'icon': 'room', 'id': 15, 'name': 'Location'}, 'parameterVals': [{'comparator': ' ', 'value': 'Home'}, {'comparator': ' ', 'value': 'A Guest'}]}	=	57	857
975	{'minutes': 0, 'seconds': 0, 'hours': 3}	<	58	857
976	On	=	1	858
977	Home	 	70	859
978	A Guest	 	71	859
1187	Off	=	1	1044
1188	Asleep	=	68	1045
1190	Open	=	67	1047
1191	Kitchen	=	70	1048
1192	Bobbie	=	71	1048
1194	On	=	1	1050
1195	Locked	=	12	1051
979	{'text': 'A Guest is in Home', 'parameters': [{'id': 70, 'type': 'set', 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room'], 'name': 'location'}, {'id': 71, 'type': 'set', 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest'], 'name': 'who'}], 'capability': {'label': '{who/!=|Someone other than }{who} is {location/!=|not }in {location}', 'id': 63, 'name': 'Detect Presence'}, 'device': {'id': 12, 'name': 'Location Sensor'}, 'channel': {'icon': 'room', 'id': 15, 'name': 'Location'}, 'parameterVals': [{'comparator': ' ', 'value': 'Home'}, {'comparator': ' ', 'value': 'A Guest'}]}	=	57	860
980	{'minutes': 0, 'seconds': 0, 'hours': 3}	>	58	860
981	Open	=	65	861
982	Day	=	62	862
983	Night	=	62	863
984	Open	=	67	864
985	{'text': "Smart Refrigerator's door Opens", 'parameters': [{'id': 67, 'type': 'bin', 'values': ['Open', 'Closed'], 'name': 'position'}], 'capability': {'label': "{DEVICE}'s door {position/T|Opens}{position/F|Closes}", 'id': 60, 'name': 'Open/Close Door'}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'parameterVals': [{'comparator': '=', 'value': 'Open'}]}	=	57	865
986	{'minutes': 2, 'seconds': 0, 'hours': 0}	>	58	865
987	Asleep	=	68	866
988	On	=	1	867
989	{'text': 'Smart TV is On', 'parameters': [{'id': 1, 'type': 'bin', 'values': ['On', 'Off'], 'name': 'setting'}], 'capability': {'label': '{DEVICE} is {setting}', 'id': 2, 'name': 'Power On/Off'}, 'device': {'id': 5, 'name': 'Smart TV'}, 'channel': {'icon': 'tv', 'id': 12, 'name': 'Television'}, 'parameterVals': [{'comparator': '=', 'value': 'On'}]}	=	50	868
990	{'minutes': 30, 'seconds': 0, 'hours': 0}	=	51	868
991	Open	=	65	869
992	Open	=	65	870
993	Pop	=	8	871
994	Pop	=	8	872
995	Pop	=	8	873
996	Pop	=	8	874
997	Home	=	70	875
998	A Guest	=	71	875
999	On	=	1	876
1000	Asleep	=	68	877
1001	On	=	1	878
1002	{'text': '(FitBit) I fall asleep', 'parameters': [{'id': 68, 'type': 'bin', 'values': ['Awake', 'Asleep'], 'name': 'status'}], 'capability': {'label': '({DEVICE}) I {status/T|wake up}{status/F|fall asleep}', 'id': 61, 'name': 'Sleep Sensor'}, 'device': {'id': 21, 'name': 'FitBit'}, 'channel': {'icon': 'favorite_border', 'id': 16, 'name': 'Health'}, 'parameterVals': [{'comparator': '=', 'value': 'Asleep'}]}	=	57	879
1003	{'minutes': 30, 'seconds': 0, 'hours': 0}	>	58	879
1004	Off	=	1	880
1005	{'text': 'Roomba turns Off', 'parameters': [{'id': 1, 'type': 'bin', 'values': ['On', 'Off'], 'name': 'setting'}], 'capability': {'label': '{DEVICE} turns {setting}', 'id': 2, 'name': 'Power On/Off'}, 'device': {'id': 1, 'name': 'Roomba'}, 'channel': {'icon': 'build', 'id': 18, 'name': 'Cleaning'}, 'parameterVals': [{'comparator': '=', 'value': 'Off'}]}	=	57	881
1006	{'minutes': 0, 'seconds': 0, 'hours': 3}	>	58	881
1007	Day	=	62	882
1008	On	=	1	883
1009	80	>	18	884
1010	60	<	18	885
1011	Raining	=	20	886
1012	80	>	18	887
1013	Open	=	13	888
1014	60	<	18	889
1015	Open	=	13	890
1016	Asleep	=	68	891
1017	Raining	=	20	892
1018	Open	=	13	893
1019	80	<	18	894
1020	Closed	=	13	895
1021	80	<	18	896
1022	Closed	=	13	897
1023	Not Raining	=	20	898
1024	60	>	18	899
1025	Not Raining	=	20	900
1026	60	>	18	901
1027	Not Raining	=	20	902
1028	Closed	=	13	903
1029	Motion	=	14	904
1030	40	<	18	905
1031	On	=	72	906
1032	{'text': "Smart Faucet's water turns On", 'parameters': [{'id': 72, 'type': 'bin', 'values': ['On', 'Off'], 'name': 'setting'}], 'capability': {'label': "{DEVICE}'s water turns {setting}", 'id': 64, 'name': 'Water On/Off'}, 'device': {'id': 22, 'name': 'Smart Faucet'}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'parameterVals': [{'comparator': '=', 'value': 'On'}]}	=	57	907
1033	{'minutes': 0, 'seconds': 15, 'hours': 0}	=	58	907
1034	Home	=	70	908
1035	A Guest	 	71	908
1036	On	=	1	909
1037	Kitchen	=	70	910
1038	Bobbie	 	71	910
1039	On	=	1	911
1040	80	=	18	912
1041	Asleep	=	68	913
1042	Pop	=	8	914
1043	Kitchen	=	70	915
1044	Bobbie	 	71	915
1045	On	=	1	916
1046	Kitchen	!=	70	917
1047	Bobbie	 	71	917
1048	On	=	1	918
1049	Open	=	67	919
1050	{'text': "Smart Refrigerator's door Opens", 'parameters': [{'id': 67, 'type': 'bin', 'values': ['Open', 'Closed'], 'name': 'position'}], 'capability': {'label': "{DEVICE}'s door {position/T|Opens}{position/F|Closes}", 'id': 60, 'name': 'Open/Close Door'}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'parameterVals': [{'comparator': '=', 'value': 'Open'}]}	=	57	920
1051	{'minutes': 2, 'seconds': 0, 'hours': 0}	=	58	920
1052	Home	=	70	921
1053	A Family Member	!=	71	921
1054	Night	=	62	922
1055	60	>	18	923
1056	Not Raining	=	20	924
1057	80	<	18	925
1058	On	=	72	926
1059	{'text': "Smart Faucet's water turns On", 'parameters': [{'id': 72, 'type': 'bin', 'values': ['On', 'Off'], 'name': 'setting'}], 'capability': {'label': "{DEVICE}'s water turns {setting}", 'id': 64, 'name': 'Water On/Off'}, 'device': {'id': 22, 'name': 'Smart Faucet'}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'parameterVals': [{'comparator': '=', 'value': 'On'}]}	=	57	927
1060	{'minutes': 0, 'seconds': 15, 'hours': 0}	=	58	927
1061	Bathroom	=	70	928
1062	Anyone	 	71	928
1063	Open	=	65	929
1064	Open	=	65	930
1066	{'text': 'Smart TV is On', 'parameters': [{'id': 1, 'type': 'bin', 'values': ['On', 'Off'], 'name': 'setting'}], 'capability': {'label': '{DEVICE} is {setting}', 'id': 2, 'name': 'Power On/Off'}, 'device': {'id': 5, 'name': 'Smart TV'}, 'channel': {'icon': 'tv', 'id': 12, 'name': 'Television'}, 'parameterVals': [{'comparator': '=', 'value': 'On'}]}	=	50	932
1067	{'minutes': 31, 'seconds': 0, 'hours': 0}	=	51	932
1068	Asleep	=	68	933
1069	Off	=	72	934
1070	 	=	72	935
1071	 	=	72	936
1072	Off	=	1	937
1073	 	=	72	938
1074	On	=	1	939
1075	Off	=	72	940
1076	On	=	1	941
1077	On	=	1	942
1078	On	=	1	943
1079	On	=	1	944
1080	Off	=	72	945
1081	3	!=	2	946
1082	On	=	1	947
1083	155	>	74	948
1084	Off	=	1	949
1085	Closed	=	65	950
1086	Open	=	65	951
1087	{'device': {'id': 21, 'name': 'FitBit'}, 'capability': {'id': 61, 'label': '({DEVICE}) I {status/T|Wake Up}{status/F|Fall Asleep}', 'name': 'Sleep Sensor'}, 'channel': {'id': 16, 'icon': 'favorite_border', 'name': 'Health'}, 'parameterVals': [{'value': 'Asleep', 'comparator': '='}], 'parameters': [{'id': 68, 'values': ['Awake', 'Asleep'], 'type': 'bin', 'name': 'status'}], 'text': '(FitBit) I Fall Asleep'}	=	57	952
1088	{'seconds': 0, 'minutes': 30, 'hours': 0}	=	58	952
1089	Open	=	67	953
1090	Open	=	65	954
1091	Bathroom	=	70	955
1092	Anyone	=	71	955
1093	Closed	=	13	956
1094	Closed	=	13	957
1095	Closed	=	13	958
1096	80	>	21	959
1097	70	<	18	960
1098	Home	=	70	961
1099	Anyone	=	71	961
1100	Pop	=	8	962
1101	Closed	=	13	963
1102	60	>	18	964
1103	80	<	18	965
1104	Not Raining	=	20	966
1105	Closed	=	13	967
1106	60	>	18	968
1107	80	<	18	969
1108	Not Raining	=	20	970
1109	39	=	18	971
1110	Closed	=	13	972
1111	Closed	=	13	973
1112	Closed	=	13	974
1113	Closed	=	13	975
1114	Closed	=	65	976
1115	Closed	=	13	977
1116	Closed	=	13	978
1117	Closed	=	13	979
1118	Closed	=	13	980
1119	Kitchen	=	70	981
1120	Bobbie	=	71	981
1121	On	=	1	982
1123	Closed	=	13	984
1124	Open	=	13	985
1125	Open	=	65	986
1126	Open	=	13	987
1127	80	>	18	988
1128	Asleep	=	68	989
1129	On	=	1	990
1130	{'device': {'id': 21, 'name': 'FitBit'}, 'capability': {'id': 61, 'label': '({DEVICE}) I {status/T|Wake Up}{status/F|Fall Asleep}', 'name': 'Sleep Sensor'}, 'channel': {'id': 16, 'icon': 'favorite_border', 'name': 'Health'}, 'parameterVals': [{'value': 'Asleep', 'comparator': '='}], 'parameters': [{'id': 68, 'values': ['Awake', 'Asleep'], 'type': 'bin', 'name': 'status'}], 'text': '(FitBit) I Fall Asleep'}	=	57	991
1131	{'seconds': 0, 'minutes': 30, 'hours': 0}	>	58	991
1132	40	=	18	992
1133	Home	=	70	993
1134	Alice	!=	71	993
1135	79	>	18	994
1136	Closed	=	65	995
1137	Open	=	65	996
1138	Open	=	13	997
1139	60	<	18	998
1140	Open	=	13	999
1141	60	<	18	1000
1142	Open	=	13	1001
1143	60	<	18	1002
1145	60	<	18	1004
1146	Open	=	13	1005
1147	80	>	18	1006
1148	{'device': {'id': 12, 'name': 'Location Sensor'}, 'capability': {'id': 63, 'label': '{who/=|}{who/!=|Someone other than }{who} {location/=|Enters}{location/!=|Exits} {location}', 'name': 'Detect Presence'}, 'channel': {'id': 15, 'icon': 'room', 'name': 'Location'}, 'parameterVals': [{'value': 'Home', 'comparator': '='}, {'value': 'Alice', 'comparator': '!='}], 'parameters': [{'id': 70, 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room'], 'type': 'set', 'name': 'location'}, {'id': 71, 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest'], 'type': 'set', 'name': 'who'}], 'text': 'Someone other than Alice Enters Home'}	=	57	1007
1149	{'seconds': 0, 'minutes': 0, 'hours': 3}	=	58	1007
1150	Open	=	13	1008
1151	Raining	=	20	1009
1152	Unlocked	=	12	1010
1153	Night	=	62	1011
1154	40	>	75	1012
1155	Pop	=	8	1013
1156	Pop	=	8	1014
1157	Pop	=	8	1015
1158	40	>	75	1016
1159	Unlocked	=	12	1017
1160	Night	=	62	1018
1161	Open	=	65	1019
1162	Open	=	65	1020
1163	Open	=	65	1021
1164	Kitchen	=	70	1022
1165	Alice	!=	71	1022
1166	41	<	75	1023
1167	41	!=	18	1024
1168	pop music	=	35	1025
1169	Off	=	72	1026
1170	On	=	1	1027
1171	Open	=	65	1028
1172	Off	=	72	1029
1173	Open	=	65	1030
1174	Locked	=	12	1031
1175	Motion	=	14	1032
1176	Locked	=	12	1033
1178	Open	=	67	1035
1179	Open	=	67	1036
1180	Open	=	67	1037
1181	Open	=	13	1038
1182	Raining	=	20	1039
1183	80	>	18	1040
1184	60	<	18	1041
1185	Off	=	72	1042
1186	80	=	18	1043
1198	Open	=	65	1054
1199	Open	=	67	1055
1200	Locked	=	12	1056
1201	Night	=	62	1057
1202	On	=	1	1058
1203	Closed	=	65	1059
1204	Kitchen	!=	70	1060
1205	Alice	=	71	1060
1206	{'device': {'id': 8, 'name': 'Smart Refrigerator'}, 'capability': {'id': 60, 'label': "{DEVICE}'s door {position/T|Opens}{position/F|Closes}", 'name': 'Open/Close Door'}, 'channel': {'id': 13, 'icon': 'fastfood', 'name': 'Food & Cooking'}, 'parameterVals': [{'value': 'Open', 'comparator': '='}], 'parameters': [{'id': 67, 'values': ['Open', 'Closed'], 'type': 'bin', 'name': 'position'}], 'text': "Smart Refrigerator's door Opens"}	=	57	1061
1207	{'seconds': 0, 'minutes': 2, 'hours': 0}	>	58	1061
1208	40	<	18	1062
1209	Asleep	=	68	1063
1210	{'device': {'id': 24, 'name': 'Bathroom Window'}, 'capability': {'id': 14, 'label': '{DEVICE} is {position}', 'name': 'Open/Close Window'}, 'channel': {'id': 5, 'icon': 'meeting_room', 'name': 'Windows & Doors'}, 'parameterVals': [{'value': 'Closed', 'comparator': '='}], 'parameters': [{'id': 13, 'values': ['Open', 'Closed'], 'type': 'bin', 'name': 'position'}], 'text': 'Bathroom Window is Closed'}	=	50	1064
1211	{'seconds': 1, 'minutes': 0, 'hours': 0}	=	51	1064
1212	Closed	=	13	1065
1213	Closed	=	13	1066
1214	 	=	72	1067
1216	Home	!=	70	1069
1217	A Guest	!=	71	1069
1218	Off	=	1	1070
1219	Home	=	70	1071
1220	A Guest	 	71	1071
1221	Asleep	=	68	1072
1222	On	=	1	1073
1223	Off	=	1	1074
1224	{'device': {'id': 21, 'name': 'FitBit'}, 'capability': {'id': 61, 'label': '({DEVICE}) I am {status}', 'name': 'Sleep Sensor'}, 'channel': {'id': 16, 'icon': 'favorite_border', 'name': 'Health'}, 'parameterVals': [{'value': 'Asleep', 'comparator': '='}], 'parameters': [{'id': 68, 'values': ['Awake', 'Asleep'], 'type': 'bin', 'name': 'status'}], 'text': '(FitBit) I am Asleep'}	=	57	1075
1225	{'seconds': 0, 'minutes': 30, 'hours': 0}	>	58	1075
1226	Closed	=	13	1076
1227	Closed	=	13	1077
1228	Closed	=	13	1078
1229	Off	=	1	1079
1230	Open	=	65	1080
1231	Kitchen	=	70	1081
1232	Bobbie	=	71	1081
1233	On	=	1	1082
1234	On	=	1	1083
1235	Home	=	70	1084
1236	A Guest	=	71	1084
1237	Closed	=	13	1085
1238	Closed	=	13	1086
1239	Closed	=	13	1087
1240	On	=	1	1088
1241	Off	=	1	1089
1242	Home	!=	70	1090
1243	A Guest	=	71	1090
1244	Off	=	1	1091
1245	Open	=	65	1092
1246	Off	=	1	1093
1247	Open	=	65	1094
1248	Open	=	13	1095
1249	Home	=	70	1096
1250	A Family Member	=	71	1096
1251	Asleep	=	68	1097
1252	Unlocked	=	12	1098
1253	Locked	=	12	1099
1254	Motion	=	14	1100
1255	Locked	=	12	1101
1256	Asleep	=	68	1102
1257	On	=	1	1103
1258	On	=	1	1104
1259	Unlocked	=	12	1105
1260	Asleep	=	68	1106
1261	Open	=	65	1107
1262	On	=	1	1108
1263	Asleep	=	68	1109
1264	Locked	=	12	1110
1265	Sunny	=	17	1111
1266	70	=	18	1112
1267	Unlocked	=	12	1113
1268	Asleep	=	68	1114
1269	Asleep	=	68	1115
1270	On	=	64	1116
1271	80	>	18	1117
1272		=	72	1118
1273	Locked	=	12	1119
1274	Asleep	=	68	1120
1276	On	=	1	1122
1277	Open	=	65	1123
1278	On	=	1	1124
1279	Closed	=	65	1125
1280	Open	=	65	1126
1281	On	=	1	1127
1282	On	=	1	1128
1283	Open	=	65	1129
1284	Open	=	65	1130
1285	 	=	72	1131
1286	Pop	=	8	1132
1287	This 	=	35	1133
1288	Open	=	13	1134
1289	80	>	18	1135
1290	Open	=	13	1136
1291	80	=	18	1137
1292	Asleep	=	68	1138
1293	On	=	1	1139
1294	Asleep	=	68	1140
1295	On	=	1	1141
1296	Open	=	13	1142
1297	Raining	=	20	1143
1298	Open	=	13	1144
1299	80	>	18	1145
1300	40	<	18	1146
1302	Open	=	13	1148
1303	60	<	18	1149
1304	Open	=	13	1150
1305	60	<	18	1151
1306	Pop	=	8	1152
1307	Open	=	13	1153
1308	Raining	=	20	1154
1309	40	<	18	1155
1310	On	=	1	1156
1311	Kitchen	=	70	1157
1312	Bobbie	=	71	1157
1313	Open	=	13	1158
1314	60	<	18	1159
1315	Open	=	13	1160
1316	80	>	18	1161
1317	Closed	=	67	1162
1318	Kitchen	 	70	1163
1319	Bobbie	 	71	1163
1320	On	=	1	1164
1321	Closed	=	65	1165
1322	Kitchen	 	70	1166
1323	Bobbie	 	71	1166
1324	Locked	=	12	1167
1325	Open	=	13	1168
1326	Locked	=	12	1169
1327	Kitchen	!=	70	1170
1328	Alice	=	71	1170
1329	Unlocked	=	12	1171
1330	Kitchen	=	70	1172
1331	Alice	=	71	1172
1332	Open	=	67	1173
1333		=	55	1174
1334	{'seconds': 0, 'minutes': 2, 'hours': 0}	=	56	1174
1335	On	=	1	1175
1336	75	=	21	1176
1337	Home	!=	70	1177
1338	Anyone	=	71	1177
1339	Open	=	67	1178
1340		=	55	1179
1341	{'seconds': 0, 'minutes': 2, 'hours': 0}	=	56	1179
1342	75	=	21	1180
1343	Home	!=	70	1181
1344	Anyone	=	71	1181
1345	Pop	 	8	1182
1346	On	=	1	1183
1347	Pop music	=	35	1184
1348	80	>	18	1185
1349	80	>	18	1186
1350	80	<	21	1187
1351	70	=	21	1188
1352	Home	 	70	1189
1353	Anyone	 	71	1189
1354	On	=	1	1190
1355	70	=	21	1191
1356	Home	 	70	1192
1357	Anyone	 	71	1192
1358	Pop	!=	8	1193
1359	80	>	21	1194
1360	Locked	=	12	1195
1361	Night	=	62	1196
1362	On	=	64	1197
1363	80	>	18	1198
1364	On	=	64	1199
1365	79	<	18	1200
1366	40	>	18	1201
1367	Unlocked	=	12	1202
1368	Asleep	=	68	1203
1369	Open	=	67	1204
1370	Open	=	67	1205
1371	40	<	18	1206
1372	Unlocked	=	12	1207
1373	Off	=	1	1208
1374	Closed	=	13	1209
1375	Raining	=	20	1210
1377	48	>	18	1212
1378	Open	=	13	1213
1379	80	=	18	1214
1380	40	<	75	1215
1381	00:00	>	23	1216
1382	00:00	>	23	1217
1383	Unlocked	=	12	1218
1384	00:00	>	23	1219
1385	Open	=	13	1220
1386	60	<	18	1221
1387	Pop	=	8	1222
1388	Open	=	13	1223
1389	80	>	18	1224
1390	80	>	18	1225
1391	Unlocked	=	12	1226
1392	Off	=	1	1227
1393	Open	=	13	1228
1394	80	<	18	1229
1395	60	>	18	1230
1396	Not Raining	=	20	1231
1397	70	!=	21	1232
1398	Home	=	70	1233
1399	Anyone	=	71	1233
1400	On	=	1	1234
1401	Open	=	65	1235
1402	Open	=	65	1236
1403	Home	=	70	1237
1404	Anyone	=	71	1237
1405	40	>	18	1238
1406	50	<	18	1239
1407	Home	!=	70	1240
1408	Anyone	=	71	1240
1409	On	=	1	1241
1410	On	=	1	1242
1411	Open	=	65	1243
1412	On	=	1	1244
1413	Home	=	70	1245
1414	Anyone	=	71	1245
1415	72	=	21	1246
1416	Home	!=	70	1247
1417	Anyone	=	71	1247
1418	Off	=	64	1248
1419	Kitchen	=	70	1249
1420	Bobbie	=	71	1249
1421	On	=	64	1250
1422	Home	=	70	1251
1423	Anyone	=	71	1251
1424	Closed	=	13	1252
1425	Raining	=	20	1253
1426	Closed	=	13	1254
1427	Raining	=	20	1255
1428	Locked	=	12	1256
1429	80	>	18	1257
1430	Closed	=	13	1258
1431	60	<	18	1259
1432	Pop	=	8	1260
1433	Closed	=	65	1261
1434	80	>	18	1262
1435	On	=	1	1263
1436	Kitchen	=	70	1264
1437	Bobbie	 	71	1264
1438	Unlocked	=	12	1265
1439	Locked	=	12	1266
1440	Night	=	62	1267
1441	On	=	72	1268
1442	On	=	40	1269
1443	Night	=	62	1270
1444	Closed	=	65	1271
1445	Open	=	65	1272
1446	Closed	=	65	1273
1447	79	>	18	1274
1448	Open	=	13	1275
1449	60	>	18	1276
1450	65	=	18	1277
1451	80	<	18	1278
1452	Not Raining	=	20	1279
1453	Closed	=	13	1280
1454	79	>	18	1281
1455	Open	=	13	1282
1456	79	=	18	1283
1457	Open	=	13	1284
1458	Raining	=	20	1285
1460	Home	!=	70	1287
1461	Anyone	 	71	1287
1462	Locked	=	12	1288
1463	On	=	1	1289
1464	Open	=	67	1290
1465	Open	=	67	1291
1466	On	=	1	1292
1467	On	=	1	1293
1468	12:00	>	23	1294
1469	Off	=	1	1295
1470	19:00	<	23	1296
1471	Open	=	67	1297
1472	Open	=	67	1298
1473	Off	=	1	1299
1474	20:00	>	23	1300
1475	On	=	1	1301
1476	Home	=	70	1302
1477	A Guest	 	71	1302
1478	Locked	=	12	1303
1479	Night	=	62	1304
1480	80	>	18	1305
1481	On	=	64	1306
1482	Locked	=	12	1307
1483	Night	=	62	1308
1484	On	=	1	1309
1485	Home	!=	70	1310
1486	Anyone	 	71	1310
1487	Open	=	67	1311
1488	80	>	74	1312
1489	Pop	!=	8	1313
1490	On	=	72	1314
1491	 	=	72	1315
1492	Open	=	13	1316
1493	Not Raining	=	20	1317
1494	Open	=	67	1318
1495	Open	=	13	1319
1496	70	<	18	1320
1497	Not Raining	=	20	1321
1498	Open	=	65	1322
1499	Open	=	65	1323
1500	Off	=	1	1324
1502	Off	=	1	1326
1503	Closed	=	65	1327
1504	70	=	21	1328
1505	Home	=	70	1329
1506	Anyone	 	71	1329
1507	Home	!=	70	1330
1508	Anyone	=	71	1330
1509	Off	=	64	1331
1510	Home	=	70	1332
1511	Anyone	=	71	1332
1512	Kitchen	=	70	1333
1513	Bobbie	=	71	1333
1514	Closed	=	67	1334
1515	Home	!=	70	1335
1516	Anyone	=	71	1335
1517	Locked	=	12	1336
1518	Asleep	=	68	1337
1519	Day	=	62	1338
1520	Open	=	13	1339
1521	On	=	64	1340
1522	80	>	21	1341
1523	80	>	18	1342
1524	On	=	1	1343
1525	Home	!=	70	1344
1526	Anyone	=	71	1344
1527	Open	=	65	1345
1528	On	=	1	1346
1529	On	=	1	1347
1530	40	<	75	1348
1531	Open	=	13	1349
1532	Open	=	13	1350
1534	{'device': {'id': 22, 'name': 'Smart Faucet'}, 'capability': {'id': 64, 'label': "{DEVICE}'s water is {setting/F|not }running", 'name': 'Water On/Off'}, 'channel': {'id': 17, 'icon': 'local_drink', 'name': 'Water & Plumbing'}, 'parameterVals': [{'value': ' ', 'comparator': '='}], 'parameters': [{'id': 72, 'values': ['On', 'Off'], 'type': 'bin', 'name': 'setting'}], 'text': "Smart Faucet's water is running"}	=	50	1352
1535	{'seconds': 15, 'minutes': 0, 'hours': 0}	=	51	1352
1536	{'device': {'id': 22, 'name': 'Smart Faucet'}, 'capability': {'id': 64, 'label': "{DEVICE}'s water is {setting/F|not }running", 'name': 'Water On/Off'}, 'channel': {'id': 17, 'icon': 'local_drink', 'name': 'Water & Plumbing'}, 'parameterVals': [{'value': 'Off', 'comparator': '='}], 'parameters': [{'id': 72, 'values': ['On', 'Off'], 'type': 'bin', 'name': 'setting'}], 'text': "Smart Faucet's water is not running"}	=	55	1353
1537	{'seconds': 16, 'minutes': 0, 'hours': 0}	=	56	1353
1538	Open	=	13	1354
1539	Raining	=	20	1355
1540	Open	=	13	1356
1541	Night	=	62	1357
1542	{'device': {'id': 22, 'name': 'Smart Faucet'}, 'capability': {'id': 64, 'label': "{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}", 'name': 'Water On/Off'}, 'channel': {'id': 17, 'icon': 'local_drink', 'name': 'Water & Plumbing'}, 'parameterVals': [{'value': 'On', 'comparator': '='}], 'parameters': [{'id': 72, 'values': ['On', 'Off'], 'type': 'bin', 'name': 'setting'}], 'text': "Smart Faucet's water Turns On"}	=	57	1358
1543	{'seconds': 15, 'minutes': 0, 'hours': 0}	=	58	1358
1544	 	=	72	1359
1545	Off	=	1	1360
1546	Asleep	=	68	1361
1547		=	23	1362
1548	120	<	69	1363
1549	Asleep	=	68	1364
1550	Open	=	13	1365
1551	80	<	18	1366
1552	60	>	21	1367
1553	{'device': {'id': 21, 'name': 'FitBit'}, 'capability': {'id': 61, 'label': '({DEVICE}) I {status/T|Wake Up}{status/F|Fall Asleep}', 'name': 'Sleep Sensor'}, 'channel': {'id': 16, 'icon': 'favorite_border', 'name': 'Health'}, 'parameterVals': [{'value': 'Asleep', 'comparator': '='}], 'parameters': [{'id': 68, 'values': ['Awake', 'Asleep'], 'type': 'bin', 'name': 'status'}], 'text': '(FitBit) I Fall Asleep'}	=	57	1368
1554	{'seconds': 0, 'minutes': 30, 'hours': 0}	=	58	1368
1555	On	=	1	1369
1556	Day	=	62	1370
1557	Night	=	62	1371
1558	Night	=	62	1372
1559	80	>	18	1373
1560	60	<	18	1374
1561	Raining	=	20	1375
1562	Open	=	67	1376
1563	On	=	1	1377
1564	Open	=	67	1378
1565	On	=	1	1379
1566	Closed	=	67	1380
1567	On	=	1	1381
1568	Bedroom	=	70	1382
1569	A Family Member	=	71	1382
1570	Night	=	62	1383
1571	Bedroom	=	70	1384
1572	A Family Member	=	71	1384
1573	Night	=	62	1385
1574	80	>	18	1386
1575	80	=	18	1387
1576	60	<	18	1388
1577	60	>	18	1389
1578	80	<	18	1390
1579	80	<	18	1391
1580	60	>	18	1392
1581	Open	=	65	1393
1582	On	=	1	1394
1583	Raining	=	20	1395
1584	60	>	18	1396
1585	80	<	18	1397
1586	Home	=	70	1398
1587	Anyone	=	71	1398
1588	Home	!=	70	1399
1589	Anyone	=	71	1399
1590	Not Raining	=	20	1400
1591	60	>	18	1401
1592	80	<	18	1402
1593	Pop	=	8	1403
1594	Home	=	70	1404
1595	A Guest	=	71	1404
1596	On	=	1	1405
1597	40	<	18	1406
1598	Bathroom	=	70	1407
1599	Anyone	=	71	1407
1600	80	>	18	1408
1601	Off	=	64	1409
1602	Closed	=	13	1410
1603	Home	 	70	1411
1604	A Family Member	=	71	1411
1606	Home	 	70	1413
1607	A Family Member	=	71	1413
1608	Kitchen	=	70	1414
1609	Alice	!=	71	1414
1610	Closed	=	13	1415
1611	Kitchen	=	70	1416
1612	Alice	!=	71	1416
1613	Home	=	70	1417
1614	Anyone	=	71	1417
1615	80	=	18	1418
1616	Pop Music	=	35	1419
1617	Closed	=	13	1420
1618	Closed	=	13	1421
1619	Closed	=	13	1422
1620	Home	=	70	1423
1621	Anyone	=	71	1423
1622	Closed	=	13	1424
1623	Closed	=	13	1425
1624	Closed	=	13	1426
1625	Closed	=	13	1427
1626	Closed	=	13	1428
1627	Closed	=	13	1429
1628	Closed	=	13	1430
1629	Closed	=	13	1431
1630	Closed	=	13	1432
1631	Closed	=	13	1433
1632	Closed	=	13	1434
1633	Closed	=	13	1435
1634	Closed	=	13	1436
1635	Closed	=	13	1437
1636	Closed	=	13	1438
1637	Closed	=	13	1439
1638	Closed	=	13	1440
1639	Closed	=	13	1441
1640	Closed	=	13	1442
1641	Closed	=	13	1443
1642	Closed	=	13	1444
1643	Off	=	1	1445
1644		>	24	1446
1645	Home	=	70	1447
1646	Anyone	=	71	1447
1647	75	>	18	1448
1648	Off	=	1	1449
1649		>	24	1450
1652	Home	=	70	1452
1653	Anyone	=	71	1452
1654	70	<	18	1453
1655	{'device': {'id': 22, 'name': 'Smart Faucet'}, 'capability': {'id': 64, 'label': "{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}", 'name': 'Water On/Off'}, 'channel': {'id': 17, 'icon': 'local_drink', 'name': 'Water & Plumbing'}, 'parameterVals': [{'value': 'On', 'comparator': '='}], 'parameters': [{'id': 72, 'values': ['On', 'Off'], 'type': 'bin', 'name': 'setting'}], 'text': "Smart Faucet's water Turns On"}	=	57	1454
1656	{'seconds': 15, 'minutes': 0, 'hours': 0}	=	58	1454
1657	{'device': {'id': 22, 'name': 'Smart Faucet'}, 'capability': {'id': 64, 'label': "{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}", 'name': 'Water On/Off'}, 'channel': {'id': 17, 'icon': 'local_drink', 'name': 'Water & Plumbing'}, 'parameterVals': [{'value': 'On', 'comparator': '='}], 'parameters': [{'id': 72, 'values': ['On', 'Off'], 'type': 'bin', 'name': 'setting'}], 'text': "Smart Faucet's water Turns On"}	=	57	1455
1658	{'seconds': 15, 'minutes': 0, 'hours': 0}	=	58	1455
1659	Unlocked	=	12	1456
1660	Asleep	=	68	1457
1661	Open	=	67	1458
1662	Pop	=	8	1459
1663	On	=	1	1460
1664	Open	=	65	1461
1665	{'device': {'id': 5, 'name': 'Smart TV'}, 'capability': {'id': 2, 'label': '{DEVICE} is {setting}', 'name': 'Power On/Off'}, 'channel': {'id': 12, 'icon': 'tv', 'name': 'Television'}, 'parameterVals': [{'value': 'On', 'comparator': '='}], 'parameters': [{'id': 1, 'values': ['On', 'Off'], 'type': 'bin', 'name': 'setting'}], 'text': 'Smart TV is On'}	=	50	1462
1666	{'seconds': 5, 'minutes': 0, 'hours': 0}	=	51	1462
1667	{'device': {'id': 21, 'name': 'FitBit'}, 'capability': {'id': 61, 'label': '({DEVICE}) I {status/T|Wake Up}{status/F|Fall Asleep}', 'name': 'Sleep Sensor'}, 'channel': {'id': 6, 'icon': 'visibility', 'name': 'Sensors'}, 'parameterVals': [{'value': 'Asleep', 'comparator': '='}], 'parameters': [{'id': 68, 'values': ['Awake', 'Asleep'], 'type': 'bin', 'name': 'status'}], 'text': '(FitBit) I Fall Asleep'}	=	57	1463
1668	{'seconds': 0, 'minutes': 30, 'hours': 0}	=	58	1463
1669	79	>	18	1464
1670	80	>	18	1465
1671	40	<	75	1466
1672	Open	=	65	1467
1673	Home	=	70	1468
1674	A Guest	!=	71	1468
1675	Open	=	65	1469
1677	On	=	1	1471
1678	{'device': {'id': 12, 'name': 'Location Sensor'}, 'capability': {'id': 63, 'label': '{who/=|}{who/!=|Someone other than }{who} {location/=|Enters}{location/!=|Exits} {location}', 'name': 'Detect Presence'}, 'channel': {'id': 15, 'icon': 'room', 'name': 'Location'}, 'parameterVals': [{'value': 'Home', 'comparator': '='}, {'value': 'A Guest', 'comparator': '='}], 'parameters': [{'id': 70, 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room'], 'type': 'set', 'name': 'location'}, {'id': 71, 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest'], 'type': 'set', 'name': 'who'}], 'text': 'A Guest Enters Home'}	=	57	1472
1679	{'seconds': 0, 'minutes': 0, 'hours': 3}	<	58	1472
1681	Home	 	70	1474
1682	Anyone	 	71	1474
1685	{'device': {'id': 12, 'name': 'Location Sensor'}, 'capability': {'id': 63, 'label': '{who/=|}{who/!=|Someone other than }{who} {location/=|Enters}{location/!=|Exits} {location}', 'name': 'Detect Presence'}, 'channel': {'id': 6, 'icon': 'visibility', 'name': 'Sensors'}, 'parameterVals': [{'value': 'Home', 'comparator': '='}, {'value': 'A Family Member', 'comparator': '!='}], 'parameters': [{'id': 70, 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room'], 'type': 'set', 'name': 'location'}, {'id': 71, 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest'], 'type': 'set', 'name': 'who'}], 'text': 'Someone other than A Family Member Enters Home'}	=	57	1476
1686	{'seconds': 0, 'minutes': 0, 'hours': 3}	=	58	1476
1687	80	>	21	1477
1690	Home	!=	70	1479
1691	A Family Member	!=	71	1479
1773	Off	=	1	1549
1774	Asleep	=	68	1550
1775	Kitchen	=	70	1551
1776	Bobbie	=	71	1551
1777	On	=	1	1552
1778	On	=	1	1553
1779	Kitchen	 	70	1554
1780	Bobbie	 	71	1554
1781	80	>	18	1555
1782	40	<	18	1556
1875	Open	=	65	1633
1876	40	<	18	1634
1877	On	=	72	1635
1878	{'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}"}, 'device': {'id': 22, 'name': 'Smart Faucet'}, 'parameterVals': [{'comparator': '=', 'value': 'On'}], 'parameters': [{'id': 72, 'type': 'bin', 'values': ['On', 'Off'], 'name': 'setting'}], 'text': "Smart Faucet's water Turns On", 'channel': {'id': 17, 'icon': 'local_drink', 'name': 'Water & Plumbing'}}	=	57	1636
1879	{'minutes': 0, 'seconds': 15, 'hours': 0}	=	58	1636
1880	Open	=	13	1637
1694	{'device': {'id': 12, 'name': 'Location Sensor'}, 'capability': {'id': 63, 'label': '{who/=|}{who/!=|Someone other than }{who} {location/=|Enters}{location/!=|Exits} {location}', 'name': 'Detect Presence'}, 'channel': {'id': 6, 'icon': 'visibility', 'name': 'Sensors'}, 'parameterVals': [{'value': 'Home', 'comparator': '='}, {'value': 'A Family Member', 'comparator': '!='}], 'parameters': [{'id': 70, 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room'], 'type': 'set', 'name': 'location'}, {'id': 71, 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest'], 'type': 'set', 'name': 'who'}], 'text': 'Someone other than A Family Member Enters Home'}	=	57	1481
1695	{'seconds': 0, 'minutes': 0, 'hours': 3}	=	58	1481
1698	{'device': {'id': 12, 'name': 'Location Sensor'}, 'capability': {'id': 63, 'label': '{who/=|}{who/!=|Someone other than }{who} {location/=|Enters}{location/!=|Exits} {location}', 'name': 'Detect Presence'}, 'channel': {'id': 6, 'icon': 'visibility', 'name': 'Sensors'}, 'parameterVals': [{'value': 'Home', 'comparator': '!='}, {'value': 'A Family Member', 'comparator': '!='}], 'parameters': [{'id': 70, 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room'], 'type': 'set', 'name': 'location'}, {'id': 71, 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest'], 'type': 'set', 'name': 'who'}], 'text': 'Someone other than A Family Member Exits Home'}	=	57	1483
1699	{'seconds': 1, 'minutes': 0, 'hours': 0}	=	58	1483
1700	On	=	72	1484
1701	{'device': {'id': 22, 'name': 'Smart Faucet'}, 'capability': {'id': 64, 'label': "{DEVICE}'s water is {setting/F|not }running", 'name': 'Water On/Off'}, 'channel': {'id': 17, 'icon': 'local_drink', 'name': 'Water & Plumbing'}, 'parameterVals': [{'value': ' ', 'comparator': '='}], 'parameters': [{'id': 72, 'values': ['On', 'Off'], 'type': 'bin', 'name': 'setting'}], 'text': "Smart Faucet's water is running"}	=	50	1485
1702	{'seconds': 15, 'minutes': 0, 'hours': 0}	=	51	1485
1703	Pop	=	8	1486
1704	{'device': {'id': 12, 'name': 'Location Sensor'}, 'capability': {'id': 63, 'label': '{who/=|}{who/!=|Someone other than }{who} {location/=|Enters}{location/!=|Exits} {location}', 'name': 'Detect Presence'}, 'channel': {'id': 6, 'icon': 'visibility', 'name': 'Sensors'}, 'parameterVals': [{'value': 'Home', 'comparator': '='}, {'value': 'A Family Member', 'comparator': '!='}], 'parameters': [{'id': 70, 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room'], 'type': 'set', 'name': 'location'}, {'id': 71, 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest'], 'type': 'set', 'name': 'who'}], 'text': 'Someone other than A Family Member Enters Home'}	=	57	1487
1705	{'seconds': 1, 'minutes': 0, 'hours': 3}	<	58	1487
1706	{'device': {'id': 12, 'name': 'Location Sensor'}, 'capability': {'id': 63, 'label': '{who/=|}{who/!=|Someone other than }{who} {location/=|Enters}{location/!=|Exits} {location}', 'name': 'Detect Presence'}, 'channel': {'id': 6, 'icon': 'visibility', 'name': 'Sensors'}, 'parameterVals': [{'value': 'Home', 'comparator': '!='}, {'value': 'A Family Member', 'comparator': '!='}], 'parameters': [{'id': 70, 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room'], 'type': 'set', 'name': 'location'}, {'id': 71, 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest'], 'type': 'set', 'name': 'who'}], 'text': 'Someone other than A Family Member Exits Home'}	=	57	1488
1707	{'seconds': 0, 'minutes': 0, 'hours': 3}	<	58	1488
1708	Locked	=	12	1489
1709	22:00	>	23	1490
1710	Locked	=	12	1491
1711	08:00	>	23	1492
1712	Unlocked	=	12	1493
1713	Locked	=	12	1494
1714	22:00	>	23	1495
1715	Locked	=	12	1496
1716	08:00	>	23	1497
1717	Unlocked	=	12	1498
1718	On	=	1	1499
1719	Day	=	62	1500
1720	Home	 	70	1501
1721	A Family Member	!=	71	1501
1722	On	=	1	1502
1723	On	=	72	1503
1724	On	=	1	1504
1725	10	>	74	1505
1726	Closed	=	13	1506
1727	Closed	=	13	1507
1728	Closed	=	13	1508
1729	Open	=	13	1509
1730	Raining	 	17	1510
1731	Open	=	13	1511
1732	80	>	18	1512
1733	Open	=	13	1513
1734	60	<	18	1514
1735	40	<	18	1515
1736	Closed	=	13	1516
1737	Closed	=	13	1517
1738	Closed	=	13	1518
1739	Unlocked	=	12	1519
1740	Kitchen	 	70	1520
1741	Bobbie	=	71	1520
1742	80	>	21	1521
1743	Open	=	67	1522
1744	 	=	72	1523
1745	Open	=	13	1524
1746	60	>	18	1525
1747	80	<	18	1526
1748	Not Raining	=	20	1527
1749	70	>	21	1528
1750	Home	 	70	1529
1751	A Family Member	 	71	1529
1752	Closed	=	13	1530
1753	Closed	=	13	1531
1754	Closed	=	13	1532
1756	Home	 	70	1534
1757	A Family Member	 	71	1534
1758	Open	=	65	1535
1759	Pop	=	8	1536
1760	On	=	1	1537
1761	Open	=	65	1538
1762	Unlocked	=	12	1539
1763	Asleep	=	68	1540
1764	On	=	1	1541
1765	Home	=	70	1542
1766	A Guest	=	71	1542
1767	Closed	=	13	1543
1768	Closed	=	13	1544
1769	Closed	=	13	1545
1770	Closed	=	13	1546
1771	Closed	=	13	1547
1772	Closed	=	13	1548
1783	{'parameterVals': [{'value': 'Off', 'comparator': '='}], 'channel': {'id': 17, 'icon': 'local_drink', 'name': 'Water & Plumbing'}, 'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'device': {'id': 22, 'name': 'Smart Faucet'}, 'capability': {'id': 64, 'label': "{DEVICE}'s water is {setting/F|not }running", 'name': 'Water On/Off'}, 'text': "Smart Faucet's water is not running"}	=	55	1557
1784	{'minutes': 0, 'seconds': 15, 'hours': 0}	=	56	1557
1785	On	=	1	1558
1786	On	=	72	1559
1787	80	<	18	1560
1788	60	>	18	1561
1789	Not Raining	=	20	1562
1790	80	<	18	1563
1791	60	>	18	1564
1792	Not Raining	=	20	1565
1793	60	>	18	1566
1794	80	<	18	1567
1795	Not Raining	=	20	1568
1796	Not Raining	=	20	1569
1797	60	>	18	1570
1798	80	<	18	1571
1799	Home	=	70	1572
1800	Anyone	=	71	1572
1801	Open	=	65	1573
1802	On	=	1	1574
1803	Open	=	65	1575
1804	On	=	1	1576
1805	Unlocked	=	12	1577
1806	Asleep	=	68	1578
1807	Asleep	=	68	1579
1808	Unlocked	=	12	1580
1809	Home	=	70	1581
1810	A Guest	=	71	1581
1811	On	=	1	1582
1812	On	=	1	1583
1813	Home	 	70	1584
1814	A Guest	 	71	1584
1815	{'text': '(FitBit) I Fall Asleep', 'capability': {'id': 61, 'name': 'Sleep Sensor', 'label': '({DEVICE}) I {status/T|Wake Up}{status/F|Fall Asleep}'}, 'device': {'id': 21, 'name': 'FitBit'}, 'parameters': [{'id': 68, 'type': 'bin', 'values': ['Awake', 'Asleep'], 'name': 'status'}], 'parameterVals': [{'value': 'Asleep', 'comparator': '='}], 'channel': {'id': 16, 'icon': 'favorite_border', 'name': 'Health'}}	=	57	1585
1816	{'seconds': 0, 'hours': 0, 'minutes': 30}	=	58	1585
1817	{'text': '(FitBit) I Fall Asleep', 'capability': {'id': 61, 'name': 'Sleep Sensor', 'label': '({DEVICE}) I {status/T|Wake Up}{status/F|Fall Asleep}'}, 'device': {'id': 21, 'name': 'FitBit'}, 'parameters': [{'id': 68, 'type': 'bin', 'values': ['Awake', 'Asleep'], 'name': 'status'}], 'parameterVals': [{'value': 'Asleep', 'comparator': '='}], 'channel': {'id': 16, 'icon': 'favorite_border', 'name': 'Health'}}	=	57	1586
1818	{'seconds': 0, 'hours': 0, 'minutes': 30}	=	58	1586
1819	{'text': '(FitBit) I Fall Asleep', 'capability': {'id': 61, 'name': 'Sleep Sensor', 'label': '({DEVICE}) I {status/T|Wake Up}{status/F|Fall Asleep}'}, 'device': {'id': 21, 'name': 'FitBit'}, 'parameters': [{'id': 68, 'type': 'bin', 'values': ['Awake', 'Asleep'], 'name': 'status'}], 'parameterVals': [{'value': 'Asleep', 'comparator': '='}], 'channel': {'id': 16, 'icon': 'favorite_border', 'name': 'Health'}}	=	57	1587
1820	{'seconds': 0, 'hours': 0, 'minutes': 30}	=	58	1587
1821	On	=	26	1588
1822	Off	=	1	1589
1823	Raining	=	20	1590
1824	Raining	=	20	1591
1825	Open	=	13	1592
1826	{'capability': {'id': 63, 'name': 'Detect Presence', 'label': '{who/!=|Someone other than }{who} is {location/!=|not }in {location}'}, 'device': {'id': 12, 'name': 'Location Sensor'}, 'parameterVals': [{'comparator': ' ', 'value': 'Home'}, {'comparator': ' ', 'value': 'Nobody'}], 'parameters': [{'id': 70, 'type': 'set', 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room'], 'name': 'location'}, {'id': 71, 'type': 'set', 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest', 'Nobody'], 'name': 'who'}], 'text': 'Nobody is in Home', 'channel': {'id': 15, 'icon': 'room', 'name': 'Location'}}	=	50	1593
1827	{'minutes': 0, 'seconds': 1, 'hours': 0}	=	51	1593
1828	Closed	=	65	1594
1829	On	=	64	1595
1830	80	=	21	1596
1831	On	=	64	1597
1832	80	=	21	1598
1833	72	=	18	1599
1834	Not Raining	=	20	1600
1835	Home	=	70	1601
1836	Anyone	=	71	1601
1837	75	>	18	1602
1838	Home	=	70	1603
1839	Anyone	=	71	1603
1840	Home	=	70	1604
1841	A Guest	=	71	1604
1842	17:00	>	23	1605
1843	20:00	<	23	1606
1844	Off	=	1	1607
1845	Open	=	65	1608
1846	Home	=	70	1609
1847	A Guest	=	71	1609
1848	17:00	>	23	1610
1849	20:00	<	23	1611
1850	Off	=	1	1612
1851	Open	=	65	1613
1852	Open	=	67	1614
1853	{'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door is {position}"}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}, 'parameterVals': [{'comparator': '=', 'value': 'Open'}], 'parameters': [{'id': 67, 'type': 'bin', 'values': ['Open', 'Closed'], 'name': 'position'}], 'text': "Smart Refrigerator's door is Open", 'channel': {'id': 13, 'icon': 'fastfood', 'name': 'Food & Cooking'}}	=	50	1615
1854	{'minutes': 2, 'seconds': 0, 'hours': 0}	=	51	1615
1855	Home	=	70	1616
1856	A Guest	=	71	1616
1857	17:00	>	23	1617
1858	20:00	<	23	1618
1859	70	=	18	1619
1860	Closed	=	13	1620
1861	Closed	=	13	1621
1862	Off	=	1	1622
1863	Open	=	65	1623
1864	Open	=	67	1624
1865	{'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door is {position}"}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}, 'parameterVals': [{'comparator': '=', 'value': 'Open'}], 'parameters': [{'id': 67, 'type': 'bin', 'values': ['Open', 'Closed'], 'name': 'position'}], 'text': "Smart Refrigerator's door is Open", 'channel': {'id': 13, 'icon': 'fastfood', 'name': 'Food & Cooking'}}	=	50	1625
1866	{'minutes': 2, 'seconds': 0, 'hours': 0}	=	51	1625
1867	On	=	1	1626
1868	Closed	=	65	1627
1869	Locked	=	12	1628
1870	Bedroom	 	70	1629
1871	Anyone	 	71	1629
1872	40	=	75	1630
1873	40	=	75	1631
1874	40	<	75	1632
1881	80	=	18	1638
1882	Asleep	=	68	1639
1883	Closed	=	65	1640
1884	Open	=	13	1641
1885	80	=	18	1642
1886	Asleep	=	68	1643
1887	80	=	18	1644
1888	Pop	=	8	1645
1889	Music	 	35	1646
1890	80	=	18	1647
1891	Closed	=	13	1648
1892	60	=	21	1649
1893	80	>	21	1650
1894	{'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door {position/T|Opens}{position/F|Closes}"}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}, 'parameterVals': [{'comparator': '=', 'value': 'Open'}], 'parameters': [{'id': 67, 'type': 'bin', 'values': ['Open', 'Closed'], 'name': 'position'}], 'text': "Smart Refrigerator's door Opens", 'channel': {'id': 13, 'icon': 'fastfood', 'name': 'Food & Cooking'}}	=	57	1651
1895	{'minutes': 2, 'seconds': 0, 'hours': 0}	>	58	1651
1896	40	=	18	1652
1897	On	=	1	1653
1898	Asleep	=	68	1654
1899	Motion	=	14	1655
1900	Asleep	=	68	1656
1901	Locked	=	12	1657
1902	Locked	=	12	1658
1903	Closed	=	67	1659
1904	Kitchen	 	70	1660
1905	Bobbie	 	71	1660
1909	Off	=	72	1662
1910	Off	=	1	1663
1911	Open	=	13	1664
1912	Open	=	67	1665
1913	80	=	18	1666
1914	Open	=	13	1667
1915	60	<	18	1668
1916	Open	=	13	1669
1917	Open	=	13	1670
1918	Closed	=	13	1671
1919	{'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door {position/T|Opens}{position/F|Closes}"}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}, 'parameterVals': [{'comparator': '=', 'value': 'Open'}], 'parameters': [{'id': 67, 'type': 'bin', 'values': ['Open', 'Closed'], 'name': 'position'}], 'text': "Smart Refrigerator's door Opens", 'channel': {'id': 13, 'icon': 'fastfood', 'name': 'Food & Cooking'}}	=	57	1672
1920	{'minutes': 2, 'seconds': 0, 'hours': 0}	>	58	1672
1921	Kitchen	!=	70	1673
1922	Anyone	 	71	1673
1923	Home	!=	70	1674
1924	Alice	!=	71	1674
1925	Closed	=	65	1675
1927	80	=	18	1677
1928	Clear	=	17	1678
1930	60	=	18	1680
1931	{'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door is {position}"}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}, 'parameterVals': [{'comparator': '=', 'value': 'Open'}], 'parameters': [{'id': 67, 'type': 'bin', 'values': ['Open', 'Closed'], 'name': 'position'}], 'text': "Smart Refrigerator's door is Open", 'channel': {'id': 13, 'icon': 'fastfood', 'name': 'Food & Cooking'}}	=	55	1681
1932	{'minutes': 2, 'seconds': 0, 'hours': 0}	>	56	1681
1933	Open	=	67	1682
1934		=	52	1683
1935	{'minutes': 0, 'seconds': 0, 'hours': 2}	=	53	1683
1936	0	!=	54	1683
1937	 	=	72	1684
1938	70	=	18	1685
1939	30	=	7	1686
1940	Open	=	67	1687
1941	80	=	18	1688
1942	Off	=	64	1689
1943	59	>	18	1690
1944	81	<	18	1691
1945	Not Raining	=	20	1692
1946	Closed	=	13	1693
1947	80	=	18	1694
1948	On	=	72	1695
1949	{'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}"}, 'device': {'id': 22, 'name': 'Smart Faucet'}, 'parameterVals': [{'comparator': '=', 'value': 'On'}], 'parameters': [{'id': 72, 'type': 'bin', 'values': ['On', 'Off'], 'name': 'setting'}], 'text': "Smart Faucet's water Turns On", 'channel': {'id': 17, 'icon': 'local_drink', 'name': 'Water & Plumbing'}}	=	57	1696
1950	{'minutes': 0, 'seconds': 15, 'hours': 0}	=	58	1696
1951	1	>	73	1697
1952	Kitchen	!=	70	1698
1953	Alice	!=	71	1698
1954	81	=	18	1699
1955	40	<	18	1700
1956	Home	=	70	1701
1957	A Guest	!=	71	1701
1958	On	=	1	1702
1959	Home	!=	70	1703
1960	A Family Member	!=	71	1703
1961	Closed	=	13	1704
1962	60	!=	18	1705
1963	45	>	18	1706
1964	Kitchen	=	70	1707
1965	Bobbie	=	71	1707
1966	Asleep	=	68	1708
1967	2	=	2	1709
1968	Closed	=	13	1710
1969	Raining	=	20	1711
1970	59	>	18	1712
1971	81	<	18	1713
1972	Not Raining	=	20	1714
1973	On	=	1	1715
1974	Open	=	65	1716
1975	Open	=	67	1717
1976	{'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door {position/T|Opens}{position/F|Closes}"}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}, 'parameterVals': [{'comparator': '=', 'value': 'Open'}], 'parameters': [{'id': 67, 'type': 'bin', 'values': ['Open', 'Closed'], 'name': 'position'}], 'text': "Smart Refrigerator's door Opens", 'channel': {'id': 13, 'icon': 'fastfood', 'name': 'Food & Cooking'}}	=	57	1718
1977	{'minutes': 2, 'seconds': 0, 'hours': 0}	>	58	1718
1978	Kitchen	!=	70	1719
1979	Anyone	 	71	1719
1980	60	<	18	1720
1981	Open	=	65	1721
1982	On	=	1	1722
1983	80	>	18	1723
1984	Open	=	65	1724
1985	On	=	1	1725
1986	Raining	=	20	1726
1987	Pop	=	8	1727
1988	On	=	1	1728
1989	80	=	18	1729
1990	 	=	72	1730
1991	Open	=	13	1731
1992	80	<	18	1732
1993	60	>	18	1733
1994	22:00	=	23	1734
1995	Closed	=	65	1735
1996	Bathroom	=	70	1736
1997	Anyone	!=	71	1736
1998	Locked	=	12	1737
1999	Kitchen	=	70	1738
2000	Bobbie	=	71	1738
2001	22:00	=	23	1739
2002	Closed	=	13	1740
2003	40	=	75	1741
2004	On	=	1	1742
2005	Home	 	70	1743
2006	Nobody	=	71	1743
2007	40	<	18	1744
2008	Closed	=	65	1745
2009	Closed	=	65	1746
2010	Closed	=	65	1747
2011	Closed	=	65	1748
2012	Closed	=	13	1749
2013	60	>	18	1750
2014	Not Raining	=	20	1751
2015	Home	=	70	1752
2016	A Family Member	=	71	1752
2017	Off	=	64	1753
2018	{'capability': {'id': 6, 'name': 'Light Color', 'label': "Set {DEVICE}'s Color to {color}"}, 'device': {'id': 4, 'name': 'HUE Lights'}, 'parameterVals': [{'comparator': '=', 'value': 'Orange'}], 'parameters': [{'id': 3, 'type': 'set', 'values': ['Red', 'Orange', 'Yellow', 'Green', 'Blue', 'Violet'], 'name': 'color'}], 'text': "Set HUE Lights's Color to Orange", 'channel': {'id': 2, 'icon': 'wb_incandescent', 'name': 'Lights'}}	=	50	1754
2019	{'minutes': 0, 'seconds': 0, 'hours': 1}	=	51	1754
2020	On	=	1	1755
2021	Open	=	65	1756
2022	75	=	21	1757
2023	Home	 	70	1758
2024	Anyone	!=	71	1758
2025	Raining	=	20	1759
2026	80	<	18	1760
2027	Not Raining	=	20	1761
2028	Closed	=	13	1762
2029	{'capability': {'id': 63, 'name': 'Detect Presence', 'label': '{who/=|}{who/!=|Someone other than }{who} {location/=|Enters}{location/!=|Exits} {location}'}, 'device': {'id': 12, 'name': 'Location Sensor'}, 'parameterVals': [{'comparator': '=', 'value': 'Home'}, {'comparator': '!=', 'value': 'A Family Member'}], 'parameters': [{'id': 70, 'type': 'set', 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room'], 'name': 'location'}, {'id': 71, 'type': 'set', 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest', 'Nobody'], 'name': 'who'}], 'text': 'Someone other than A Family Member Enters Home', 'channel': {'id': 6, 'icon': 'visibility', 'name': 'Sensors'}}	=	57	1763
2030	{'minutes': 0, 'seconds': 0, 'hours': 3}	>	58	1763
2031	On	=	1	1764
2032	Kitchen	 	70	1765
2033	A Family Member	 	71	1765
2034	73	=	21	1766
2035	Home	=	70	1767
2036	Anyone	 	71	1767
2037	80	=	18	1768
2038	Open	=	65	1769
2039	On	=	1	1770
2040	Yes	=	25	1771
2041	60	<	18	1772
2042	Open	=	13	1773
2043	60	=	18	1774
2044	80	>	18	1775
2045	80	>	18	1776
2046	39	=	18	1777
2047	59	=	18	1778
2048	On	=	1	1779
2049	Home	 	70	1780
2050	Nobody	!=	71	1780
2051		=	57	1781
2052	{'minutes': 0, 'seconds': 0, 'hours': 3}	=	58	1781
2053	Off	=	64	1782
2054	Home	=	70	1783
2055	Nobody	=	71	1783
2056	Off	=	72	1784
2057	Closed	=	13	1785
2058	80	=	18	1786
2059	60	<	18	1787
2060	Closed	=	67	1788
2061	Open	=	67	1789
2062	On	=	64	1790
2063	Home	=	70	1791
2064	Anyone	=	71	1791
2065	40	=	18	1792
2068	80	>	18	1795
2069	59	>	18	1796
2070	81	<	18	1797
2071	Pop	=	8	1798
2074	Home	 	70	1800
2075	A Family Member	=	71	1800
2076	75	=	18	1801
2077	On	=	72	1802
2078	81	<	18	1803
2079	59	>	18	1804
2080	On	=	72	1805
2081	Home	=	70	1806
2082	A Family Member	!=	71	1806
2083	40	<	75	1807
2084	20:30	=	23	1808
2087	On	=	72	1811
2088	On	=	64	1812
2089	78	=	21	1813
2090	Home	=	70	1814
2091	Anyone	=	71	1814
2092	40	<	18	1815
2093	Asleep	=	68	1816
2094	On	=	1	1817
2095	{'capability': {'id': 61, 'name': 'Sleep Sensor', 'label': '({DEVICE}) I am {status}'}, 'device': {'id': 21, 'name': 'FitBit'}, 'parameterVals': [{'comparator': '=', 'value': 'Asleep'}], 'parameters': [{'id': 68, 'type': 'bin', 'values': ['Awake', 'Asleep'], 'name': 'status'}], 'text': '(FitBit) I am Asleep', 'channel': {'id': 16, 'icon': 'favorite_border', 'name': 'Health'}}	=	55	1818
2096	{'minutes': 30, 'seconds': 0, 'hours': 0}	=	56	1818
2097	Open	=	65	1819
2098	On	=	1	1820
2099	Motion	=	14	1821
2100	40	<	18	1822
2101	40	<	18	1823
2102	Open	=	13	1824
2103	Home	=	70	1825
2104	Anyone	=	71	1825
2106	Asleep	=	68	1827
2107	38	=	18	1828
2108	80	>	21	1829
2111	On	=	64	1831
2113	Unlocked	=	12	1833
2114	Bedroom	 	70	1834
2115	Anyone	 	71	1834
2116	Open	=	67	1835
2117	Pop	=	8	1836
2118	40	!=	18	1837
2119	Open	=	65	1838
2120	40	>	75	1839
2121	{'capability': {'id': 2, 'name': 'Power On/Off', 'label': '{DEVICE} turns {setting}'}, 'device': {'id': 1, 'name': 'Roomba'}, 'parameterVals': [{'comparator': '=', 'value': 'On'}], 'parameters': [{'id': 1, 'type': 'bin', 'values': ['On', 'Off'], 'name': 'setting'}], 'text': 'Roomba turns On', 'channel': {'id': 18, 'icon': 'build', 'name': 'Cleaning'}}	=	57	1840
2122	{'minutes': 0, 'seconds': 0, 'hours': 0}	=	58	1840
2124	On	=	64	1842
2125	Home	 	70	1843
2126	Nobody	!=	71	1843
2127	73	=	18	1844
2128	73	=	21	1845
2129	Closed	=	65	1846
2130	42	!=	18	1847
2131	Off	=	1	1848
2132	Home	!=	70	1849
2133	A Family Member	!=	71	1849
2134	Open	=	67	1850
2135	Off	=	64	1851
2136	Home	 	70	1852
2137	Anyone	 	71	1852
2138	Open	=	65	1853
2139	37	=	18	1854
2140	75	>	18	1855
2141	Home	=	70	1856
2142	Anyone	 	71	1856
2143	Off	=	1	1857
2144	Asleep	=	68	1858
2145	80	>	21	1859
2146	On	=	64	1860
2147	Home	!=	70	1861
2148	Anyone	 	71	1861
2149	39	=	75	1862
2150	70	<	18	1863
2151	Home	=	70	1864
2152	Anyone	=	71	1864
2153	Open	=	67	1865
2154	Home	 	70	1866
2155	Anyone	 	71	1866
2156	Home	 	70	1867
2157	Anyone	 	71	1867
2158	Open	=	65	1868
2159	80	<	18	1869
2160	On	=	1	1870
2161	Open	=	65	1871
2162	Pop	=	8	1872
2167	Pop	=	8	1875
2169	Open	=	65	1877
2170	Hip-Hop	=	8	1878
2171	Pop	 	8	1879
2172	Open	=	13	1880
2173	36	=	75	1881
2174	{'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}"}, 'device': {'id': 22, 'name': 'Smart Faucet'}, 'parameterVals': [{'comparator': '=', 'value': 'On'}], 'parameters': [{'id': 72, 'type': 'bin', 'values': ['On', 'Off'], 'name': 'setting'}], 'text': "Smart Faucet's water Turns On", 'channel': {'id': 17, 'icon': 'local_drink', 'name': 'Water & Plumbing'}}	=	57	1882
2175	{'minutes': 0, 'seconds': 15, 'hours': 0}	>	58	1882
2176	music	!=	35	1883
2177	Closed	=	13	1884
2178	Closed	=	13	1885
2179	Closed	=	13	1886
2180	music	!=	35	1887
2181	On	=	1	1888
2182	Open	=	65	1889
2183	Home	!=	70	1890
2184	Anyone	=	71	1890
2185	Closed	=	65	1891
2186	35	=	75	1892
2187	On	=	72	1893
2188	On	=	1	1894
2189	Open	=	65	1895
2190	Open	=	65	1896
2191	Open	=	65	1897
2192	34	=	75	1898
2193	33	=	75	1899
2195	Closed	=	67	1901
2196	72	=	21	1902
2197	Home	 	70	1903
2198	Anyone	 	71	1903
2199	Open	=	13	1904
2200	Home	!=	70	1905
2201	Anyone	=	71	1905
2204	Home	=	70	1907
2205	Anyone	=	71	1907
2206	Open	=	13	1908
2209	2	=	2	1910
2210	Home	=	70	1911
2211	Anyone	=	71	1911
2212	Kitchen	=	70	1912
2213	Bobbie	=	71	1912
2214	Kitchen	!=	70	1913
2215	Bobbie	!=	71	1913
2217	Open	=	13	1915
2218	On	=	1	1916
2219	Closed	=	13	1917
2220	Closed	=	13	1918
2221	Closed	=	13	1919
2222	Open	=	13	1920
2223	Open	=	13	1921
2224	Closed	=	13	1922
2225	Closed	=	13	1923
2226	Open	=	13	1924
2228	Unlocked	=	12	1926
2229	On	=	1	1927
2230	Open	=	65	1928
2231	Open	=	67	1929
2232	Open	=	13	1930
2233	Kitchen	=	70	1931
2234	Bobbie	!=	71	1931
2235	Kitchen	 	70	1932
2236	Bobbie	 	71	1932
2237	Open	=	13	1933
2238	Closed	=	13	1934
2239	Closed	=	13	1935
2241	{'capability': {'id': 2, 'name': 'Power On/Off', 'label': '{DEVICE} is {setting}'}, 'device': {'id': 1, 'name': 'Roomba'}, 'parameterVals': [{'comparator': '=', 'value': 'Off'}], 'parameters': [{'id': 1, 'type': 'bin', 'values': ['On', 'Off'], 'name': 'setting'}], 'text': 'Roomba is Off', 'channel': {'id': 18, 'icon': 'build', 'name': 'Cleaning'}}	=	50	1937
2242	{'minutes': 0, 'seconds': 0, 'hours': 1}	=	51	1937
2243	{'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water is {setting/F|not }running"}, 'device': {'id': 22, 'name': 'Smart Faucet'}, 'parameterVals': [{'comparator': '=', 'value': ' '}], 'parameters': [{'id': 72, 'type': 'bin', 'values': ['On', 'Off'], 'name': 'setting'}], 'text': "Smart Faucet's water is running", 'channel': {'id': 13, 'icon': 'fastfood', 'name': 'Food & Cooking'}}	=	50	1938
2244	{'minutes': 1, 'seconds': 0, 'hours': 0}	=	51	1938
2245	Open	=	65	1939
2246	Open	=	13	1940
2247	Closed	=	13	1941
2248	Closed	=	13	1942
2249	Kitchen	!=	70	1943
2250	Anyone	=	71	1943
2251	Kitchen	 	70	1944
2252	Bobbie	 	71	1944
2253	Pop	=	8	1945
2254	Home	=	70	1946
2255	A Family Member	=	71	1946
2256	Kitchen	!=	70	1947
2257	Bobbie	=	71	1947
2258	Closed	=	65	1948
2259	Closed	=	13	1949
2260	Open	=	13	1950
2261	80	!=	18	1951
2262	Off	=	72	1952
2263	On	=	72	1953
2264	40	<	75	1954
2265	On	=	1	1955
2266	Open	=	65	1956
2267	On	=	1	1957
2268	Open	=	65	1958
2269	On	=	1	1959
2270	Open	=	65	1960
2271	On	=	1	1961
2272	Closed	=	65	1962
2273	Open	=	13	1963
2274	60	<	18	1964
2275	80	>	18	1965
2276	Home	=	70	1966
2277	Anyone	=	71	1966
2278	Open	=	65	1967
2279	Open	=	13	1968
2280	80	>	18	1969
2281	60	<	18	1970
2282	Open	=	13	1971
2283	Pop	=	8	1972
2285	60	<	18	1974
2286	Closed	=	65	1975
2287	Closed	=	13	1976
2288	Closed	=	65	1977
2289	Closed	=	65	1978
2290	On	=	72	1979
2291	79	=	18	1980
2293	Pop	=	8	1982
2294	Open	=	13	1983
2295	80	>	18	1984
2296	60	<	18	1985
2297	Open	=	65	1986
2298	Pop	=	8	1987
2299	Pop music	=	35	1988
2300	Unlocked	=	12	1989
2301	Open	=	13	1990
2302	Open	=	13	1991
2303	Open	=	13	1992
2304	Off	=	1	1993
2305	On	=	1	1994
2307	Home	!=	70	1996
2308	Alice	=	71	1996
2309	On	=	72	1997
2310	Off	=	72	1998
2311	{'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}"}, 'device': {'id': 22, 'name': 'Smart Faucet'}, 'parameterVals': [{'comparator': '=', 'value': 'On'}], 'parameters': [{'id': 72, 'type': 'bin', 'values': ['On', 'Off'], 'name': 'setting'}], 'text': "Smart Faucet's water Turns On", 'channel': {'id': 17, 'icon': 'local_drink', 'name': 'Water & Plumbing'}}	=	57	1999
2312	{'minutes': 0, 'seconds': 15, 'hours': 0}	=	58	1999
2313	Locked	=	12	2000
2314	Night	=	62	2001
2315	On	=	72	2002
2316	Off	=	72	2003
2317	{'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}"}, 'device': {'id': 22, 'name': 'Smart Faucet'}, 'parameterVals': [{'comparator': '=', 'value': 'On'}], 'parameters': [{'id': 72, 'type': 'bin', 'values': ['On', 'Off'], 'name': 'setting'}], 'text': "Smart Faucet's water Turns On", 'channel': {'id': 17, 'icon': 'local_drink', 'name': 'Water & Plumbing'}}	=	57	2004
2318	{'minutes': 0, 'seconds': 15, 'hours': 0}	=	58	2004
2319	80	>	18	2005
2320	80	>	18	2006
2321	Pop music	=	35	2007
2322	{'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water is {setting/F|not }running"}, 'device': {'id': 22, 'name': 'Smart Faucet'}, 'parameterVals': [{'comparator': '=', 'value': 'Off'}], 'parameters': [{'id': 72, 'type': 'bin', 'values': ['On', 'Off'], 'name': 'setting'}], 'text': "Smart Faucet's water is not running", 'channel': {'id': 17, 'icon': 'local_drink', 'name': 'Water & Plumbing'}}	=	55	2008
2323	{'minutes': 0, 'seconds': 15, 'hours': 0}	=	56	2008
2324	Open	=	13	2009
2325	Closed	=	13	2010
2326	Closed	=	13	2011
2327	Partly Cloudy	=	17	2012
2328	Open	=	13	2013
2329	Closed	=	13	2014
2330	Closed	=	13	2015
2331	Off	=	1	2016
2332	Asleep	=	68	2017
2336	Asleep	=	68	2019
2337	On	=	1	2020
2338	Open	=	65	2021
2339	Home	=	70	2022
2340	A Guest	=	71	2022
2343	Open	=	65	2025
2344	Open	=	67	2026
2345	{'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door {position/T|Opens}{position/F|Closes}"}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}, 'parameterVals': [{'comparator': '=', 'value': 'Open'}], 'parameters': [{'id': 67, 'type': 'bin', 'values': ['Open', 'Closed'], 'name': 'position'}], 'text': "Smart Refrigerator's door Opens", 'channel': {'id': 13, 'icon': 'fastfood', 'name': 'Food & Cooking'}}	=	52	2027
2346	{'minutes': 2, 'seconds': 0, 'hours': 0}	=	53	2027
2347	1	>	54	2027
2348	Off	=	72	2028
2349	Off	=	72	2029
2350	Off	=	72	2030
2351	Off	=	72	2031
2352	{'capability': {'id': 63, 'name': 'Detect Presence', 'label': '{who/=|}{who/!=|Someone other than }{who} {location/=|Enters}{location/!=|Exits} {location}'}, 'device': {'id': 12, 'name': 'Location Sensor'}, 'parameterVals': [{'comparator': '=', 'value': 'Home'}, {'comparator': '=', 'value': 'A Guest'}], 'parameters': [{'id': 70, 'type': 'set', 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room'], 'name': 'location'}, {'id': 71, 'type': 'set', 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest', 'Nobody'], 'name': 'who'}], 'text': 'A Guest Enters Home', 'channel': {'id': 6, 'icon': 'visibility', 'name': 'Sensors'}}	=	57	2032
2353	{'minutes': 0, 'seconds': 0, 'hours': 3}	>	58	2032
2354	Open	=	65	2033
2355	Open	=	65	2034
2356	Home	=	70	2035
2357	A Family Member	!=	71	2035
2358	{'capability': {'id': 2, 'name': 'Power On/Off', 'label': '{DEVICE} is {setting}'}, 'device': {'id': 1, 'name': 'Roomba'}, 'parameterVals': [{'comparator': '=', 'value': 'Off'}], 'parameters': [{'id': 1, 'type': 'bin', 'values': ['On', 'Off'], 'name': 'setting'}], 'text': 'Roomba is Off', 'channel': {'id': 18, 'icon': 'build', 'name': 'Cleaning'}}	=	50	2036
2359	{'minutes': 0, 'seconds': 0, 'hours': 1}	=	51	2036
2360	Open	=	65	2037
2361	On	=	1	2038
2362	72	=	21	2039
2363	Motion	=	14	2040
2364	Open	=	65	2041
2365	On	=	1	2042
2366	Off	=	1	2043
2367	23:00	=	23	2044
2368	80	>	18	2045
2371	On	=	64	2048
2372	No Motion	=	14	2049
2373	Open	=	65	2050
2374	On	=	1	2051
2375	Open	=	65	2052
2376	Open	=	65	2053
2377	Locked	=	12	2054
2378	Night	=	62	2055
2379	Raining	=	17	2056
2380	Unlocked	=	12	2057
2381	Night	=	62	2058
2382	Closed	=	13	2059
2383	80	>	18	2060
2384	81	=	18	2061
2385	Closed	=	67	2062
2386	Open	=	67	2063
2387	+96+5+5	!=	34	2064
2388	Awake	=	68	2065
2389	{'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door {position/T|Opens}{position/F|Closes}"}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}, 'parameterVals': [{'comparator': '=', 'value': 'Open'}], 'parameters': [{'id': 67, 'type': 'bin', 'values': ['Open', 'Closed'], 'name': 'position'}], 'text': "Smart Refrigerator's door Opens", 'channel': {'id': 13, 'icon': 'fastfood', 'name': 'Food & Cooking'}}	=	57	2066
2390	{'minutes': 2, 'seconds': 0, 'hours': 0}	>	58	2066
2393	59	=	18	2068
2394	Closed	=	13	2069
2395	60	<	18	2070
2396	On	=	1	2071
2397	Unlocked	=	12	2072
2398	pop music	=	35	2073
2399	Locked	=	12	2074
2400	Open	=	65	2075
2401	Closed	=	67	2076
2402	Open	=	67	2077
2403	Raining	=	20	2078
2404	Raining	=	17	2079
2406	80	>	21	2081
2407	On	=	64	2082
2408	80	>	21	2083
2410	80	>	21	2085
2411	Locked	=	12	2086
2412	125	=	74	2087
2413	{'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water is {setting/F|not }running"}, 'device': {'id': 22, 'name': 'Smart Faucet'}, 'parameterVals': [{'comparator': '=', 'value': ' '}], 'parameters': [{'id': 72, 'type': 'bin', 'values': ['On', 'Off'], 'name': 'setting'}], 'text': "Smart Faucet's water is running", 'channel': {'id': 17, 'icon': 'local_drink', 'name': 'Water & Plumbing'}}	=	50	2088
2414	{'minutes': 15, 'seconds': 0, 'hours': 0}	=	51	2088
2415	 	=	72	2089
2416	60	<	18	2090
2417	On	=	72	2091
2418	On	=	64	2092
2419	80	>	18	2093
2420	80	>	18	2094
2421	41	=	75	2095
2422	40	=	75	2096
2423	Open	=	65	2097
2424	Pop	=	8	2098
2425	{'capability': {'id': 63, 'name': 'Detect Presence', 'label': '{who/!=|Someone other than }{who} is {location/!=|not }in {location}'}, 'device': {'id': 12, 'name': 'Location Sensor'}, 'parameterVals': [{'comparator': '!=', 'value': 'Home'}, {'comparator': '=', 'value': 'Anyone'}], 'parameters': [{'id': 70, 'type': 'set', 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room'], 'name': 'location'}, {'id': 71, 'type': 'set', 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest', 'Nobody'], 'name': 'who'}], 'text': 'Anyone is not in Home', 'channel': {'id': 6, 'icon': 'visibility', 'name': 'Sensors'}}	=	55	2099
2426	{'minutes': 10, 'seconds': 0, 'hours': 0}	=	56	2099
2427	60	>	18	2100
2428	80	<	18	2101
2429	{'capability': {'id': 61, 'name': 'Sleep Sensor', 'label': '({DEVICE}) I {status/T|Wake Up}{status/F|Fall Asleep}'}, 'device': {'id': 21, 'name': 'FitBit'}, 'parameterVals': [{'comparator': '=', 'value': 'Asleep'}], 'parameters': [{'id': 68, 'type': 'bin', 'values': ['Awake', 'Asleep'], 'name': 'status'}], 'text': '(FitBit) I Fall Asleep', 'channel': {'id': 6, 'icon': 'visibility', 'name': 'Sensors'}}	=	57	2102
2430	{'minutes': 30, 'seconds': 0, 'hours': 0}	>	58	2102
2431	Open	=	13	2103
2432	Closed	=	13	2104
2433	Closed	=	13	2105
2434	Home	=	70	2106
2435	Anyone	=	71	2106
2436	Open	=	13	2107
2437	Closed	=	13	2108
2438	Closed	=	13	2109
2439	Open	=	13	2110
2440	Closed	=	13	2111
2441	On	=	1	2112
2442	60	>	18	2113
2443	80	<	18	2114
2444	60	>	18	2115
2445	80	<	18	2116
2446	Off	=	1	2117
2447	21:00	=	23	2118
2448	Closed	=	13	2119
2449	pop	=	35	2120
2450	Open	=	13	2121
2451	Closed	=	13	2122
2452	Off	=	1	2123
2453	21:00	=	23	2124
2454	Closed	=	13	2125
2455	Closed	=	13	2126
2456	Home	=	70	2127
2457	Anyone	=	71	2127
2458	Closed	=	13	2128
2459	Closed	=	13	2129
2460	Closed	=	13	2130
2461	Closed	=	13	2131
2462	Closed	=	13	2132
2463	73	!=	18	2133
2464	Clear	=	17	2134
2465	59	>	18	2135
2466	81	<	18	2136
2467	Open	=	65	2137
2468	Closed	=	13	2138
2469	Closed	=	13	2139
2470	Day	=	62	2140
2471	Closed	=	65	2141
2472	On	=	1	2142
2473	Open	=	65	2143
2474	On	=	1	2144
2475	Asleep	=	68	2145
2476	Closed	=	65	2146
2477	On	=	1	2147
2478	Closed	=	65	2148
2479	On	=	1	2149
2480	Off	=	72	2150
2481	On	=	72	2151
2482	Kitchen	=	70	2152
2483	Bobbie	=	71	2152
2484	On	=	1	2153
2485	Kitchen	=	70	2154
2486	Bobbie	=	71	2154
2487	On	=	1	2155
2488	59	>	18	2156
2489	Clear	 	17	2157
2490	Open	=	65	2158
2491	On	=	1	2159
2492	{'capability': {'id': 61, 'name': 'Sleep Sensor', 'label': '({DEVICE}) I {status/T|Wake Up}{status/F|Fall Asleep}'}, 'device': {'id': 21, 'name': 'FitBit'}, 'parameterVals': [{'comparator': '=', 'value': 'Asleep'}], 'parameters': [{'id': 68, 'type': 'bin', 'values': ['Awake', 'Asleep'], 'name': 'status'}], 'text': '(FitBit) I Fall Asleep', 'channel': {'id': 6, 'icon': 'visibility', 'name': 'Sensors'}}	=	57	2160
2493	{'minutes': 31, 'seconds': 0, 'hours': 0}	=	58	2160
2494	81	<	18	2161
2495	Clear	 	17	2162
2496	Open	=	65	2163
2497	On	=	1	2164
2498	80	=	18	2165
2499	Open	=	67	2166
2500	Home	=	70	2167
2501	Anyone	=	71	2167
2506	Pop	=	8	2170
2507	Pop	 	8	2171
2508	Open	=	65	2172
2509	Home	!=	70	2173
2510	Anyone	=	71	2173
2511	On	=	64	2174
2512	Closed	=	13	2175
2513	Closed	=	13	2176
2514	Closed	=	13	2177
2515	25	>	74	2178
2516	Kitchen	 	70	2179
2517	Alice	 	71	2179
2518	Closed	=	13	2180
2519	Closed	=	13	2181
2520	Closed	=	13	2182
2521	Closed	=	13	2183
2522	Closed	=	13	2184
2523	Closed	=	13	2185
2524	Open	=	13	2186
2525	60	>	18	2187
2526	{'capability': {'id': 61, 'name': 'Sleep Sensor', 'label': '({DEVICE}) I am {status}'}, 'device': {'id': 21, 'name': 'FitBit'}, 'parameterVals': [{'comparator': '=', 'value': 'Asleep'}], 'parameters': [{'id': 68, 'type': 'bin', 'values': ['Awake', 'Asleep'], 'name': 'status'}], 'text': '(FitBit) I am Asleep', 'channel': {'id': 6, 'icon': 'visibility', 'name': 'Sensors'}}	=	55	2188
2527	{'minutes': 30, 'seconds': 0, 'hours': 0}	>	56	2188
2528	Closed	=	13	2189
2529	Closed	=	13	2190
2530	Closed	=	13	2191
2531	Closed	=	13	2192
2532	Closed	=	13	2193
2533	Closed	=	13	2194
2534	Closed	=	13	2195
2535	Closed	=	13	2196
2536	Closed	=	13	2197
2537	Motion	=	14	2198
2538	Open	=	13	2199
2539	80	>	18	2200
2540	Home	=	70	2201
2541	Anyone	=	71	2201
2542	Home	=	70	2202
2543	Anyone	=	71	2202
2544	Home	=	70	2203
2545	Anyone	=	71	2203
2546	{'capability': {'id': 15, 'name': 'Detect Motion', 'label': '{DEVICE} {status/T|Starts}{status/F|Stops} Detecting Motion'}, 'device': {'id': 10, 'name': 'Security Camera'}, 'parameterVals': [{'comparator': '=', 'value': 'No Motion'}], 'parameters': [{'id': 14, 'type': 'bin', 'values': ['Motion', 'No Motion'], 'name': 'status'}], 'text': 'Security Camera Stops Detecting Motion', 'channel': {'id': 6, 'icon': 'visibility', 'name': 'Sensors'}}	=	57	2204
2547	{'minutes': 0, 'seconds': 0, 'hours': 3}	=	58	2204
2548	Closed	=	13	2205
2549	80	>	18	2206
2550	Open	=	67	2207
2551	{'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door {position/T|Opens}{position/F|Closes}"}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}, 'parameterVals': [{'comparator': '=', 'value': 'Open'}], 'parameters': [{'id': 67, 'type': 'bin', 'values': ['Open', 'Closed'], 'name': 'position'}], 'text': "Smart Refrigerator's door Opens", 'channel': {'id': 13, 'icon': 'fastfood', 'name': 'Food & Cooking'}}	=	57	2208
2552	{'minutes': 2, 'seconds': 0, 'hours': 0}	=	58	2208
2553	Closed	=	13	2209
2554	60	<	18	2210
2555	Pop	=	8	2211
2556	Pop	=	8	2212
2557	Closed	=	13	2213
2558	59	<	18	2214
2559	{'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door is {position}"}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}, 'parameterVals': [{'comparator': '=', 'value': 'Closed'}], 'parameters': [{'id': 67, 'type': 'bin', 'values': ['Open', 'Closed'], 'name': 'position'}], 'text': "Smart Refrigerator's door is Closed", 'channel': {'id': 13, 'icon': 'fastfood', 'name': 'Food & Cooking'}}	=	55	2215
2560	{'minutes': 2, 'seconds': 0, 'hours': 0}	=	56	2215
2561	40	<	75	2216
2562	Closed	=	67	2217
2563	Open	=	65	2218
2564	Open	=	65	2219
2565	40	<	75	2220
2566	{'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door is {position}"}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}, 'parameterVals': [{'comparator': '=', 'value': 'Closed'}], 'parameters': [{'id': 67, 'type': 'bin', 'values': ['Open', 'Closed'], 'name': 'position'}], 'text': "Smart Refrigerator's door is Closed", 'channel': {'id': 13, 'icon': 'fastfood', 'name': 'Food & Cooking'}}	=	55	2221
2567	{'minutes': 2, 'seconds': 0, 'hours': 0}	>	56	2221
2568	40	!=	18	2222
2569	{'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water is {setting/F|not }running"}, 'device': {'id': 22, 'name': 'Smart Faucet'}, 'parameterVals': [{'comparator': '=', 'value': 'Off'}], 'parameters': [{'id': 72, 'type': 'bin', 'values': ['On', 'Off'], 'name': 'setting'}], 'text': "Smart Faucet's water is not running", 'channel': {'id': 17, 'icon': 'local_drink', 'name': 'Water & Plumbing'}}	=	55	2223
2570	{'minutes': 0, 'seconds': 15, 'hours': 0}	=	56	2223
2571	40	<	18	2224
2572	Closed	=	67	2225
2573	40	<	75	2226
2574	Closed	=	67	2227
2575	Asleep	=	68	2228
2576	On	=	1	2229
2577	Home	 	70	2230
2578	A Guest	 	71	2230
2579	{'capability': {'id': 63, 'name': 'Detect Presence', 'label': '{who/=|}{who/!=|Someone other than }{who} {location/=|Enters}{location/!=|Exits} {location}'}, 'device': {'id': 12, 'name': 'Location Sensor'}, 'parameterVals': [{'comparator': '=', 'value': 'Home'}, {'comparator': '=', 'value': 'A Guest'}], 'parameters': [{'id': 70, 'type': 'set', 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room'], 'name': 'location'}, {'id': 71, 'type': 'set', 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest', 'Nobody'], 'name': 'who'}], 'text': 'A Guest Enters Home', 'channel': {'id': 6, 'icon': 'visibility', 'name': 'Sensors'}}	=	57	2231
2580	{'minutes': 0, 'seconds': 0, 'hours': 3}	<	58	2231
2581	45	>	18	2232
2582	Closed	=	67	2233
2583	Open	=	65	2234
2584	Closed	=	13	2235
2585	Closed	=	13	2236
2586	Home	=	70	2237
2587	A Family Member	=	71	2237
2588	70	<	18	2238
2589	75	>	18	2239
2590	Raining	=	20	2240
2591	Open	=	13	2241
2592	80	>	18	2242
2593	Open	=	13	2243
2594	Asleep	=	68	2244
2595	On	=	1	2245
2596	No Motion	=	14	2246
2597	{'capability': {'id': 61, 'name': 'Sleep Sensor', 'label': '({DEVICE}) I {status/T|Wake Up}{status/F|Fall Asleep}'}, 'device': {'id': 21, 'name': 'FitBit'}, 'parameterVals': [{'comparator': '=', 'value': 'Asleep'}], 'parameters': [{'id': 68, 'type': 'bin', 'values': ['Awake', 'Asleep'], 'name': 'status'}], 'text': '(FitBit) I Fall Asleep', 'channel': {'id': 16, 'icon': 'favorite_border', 'name': 'Health'}}	=	57	2247
2598	{'minutes': 30, 'seconds': 0, 'hours': 0}	=	58	2247
2599	{'capability': {'id': 14, 'name': 'Open/Close Window', 'label': '{DEVICE} is {position}'}, 'device': {'id': 24, 'name': 'Bathroom Window'}, 'parameterVals': [{'comparator': '=', 'value': 'Closed'}], 'parameters': [{'id': 13, 'type': 'bin', 'values': ['Open', 'Closed'], 'name': 'position'}], 'text': 'Bathroom Window is Closed', 'channel': {'id': 5, 'icon': 'meeting_room', 'name': 'Windows & Doors'}}	=	55	2248
2600	{'minutes': 0, 'seconds': 0, 'hours': 0}	=	56	2248
2601	{'capability': {'id': 14, 'name': 'Open/Close Window', 'label': '{DEVICE} is {position}'}, 'device': {'id': 14, 'name': 'Bedroom Window'}, 'parameterVals': [{'comparator': '=', 'value': 'Closed'}], 'parameters': [{'id': 13, 'type': 'bin', 'values': ['Open', 'Closed'], 'name': 'position'}], 'text': 'Bedroom Window is Closed', 'channel': {'id': 5, 'icon': 'meeting_room', 'name': 'Windows & Doors'}}	=	55	2249
2602	{'minutes': 0, 'seconds': 0, 'hours': 0}	=	56	2249
2603	{'capability': {'id': 14, 'name': 'Open/Close Window', 'label': '{DEVICE} is {position}'}, 'device': {'id': 25, 'name': 'Living Room Window'}, 'parameterVals': [{'comparator': '=', 'value': 'Closed'}], 'parameters': [{'id': 13, 'type': 'bin', 'values': ['Open', 'Closed'], 'name': 'position'}], 'text': 'Living Room Window is Closed', 'channel': {'id': 5, 'icon': 'meeting_room', 'name': 'Windows & Doors'}}	=	55	2250
2604	{'minutes': 0, 'seconds': 0, 'hours': 0}	=	56	2250
2605	60	<	18	2251
2606	Open	=	13	2252
2607	On	=	1	2253
2608	Locked	=	12	2254
2609	On	=	1	2255
2610	Home	=	70	2256
2611	A Guest	=	71	2256
2612	Bedroom	=	70	2257
2613	A Family Member	=	71	2257
2614	80	<	18	2258
2615	60	>	18	2259
2616	Not Raining	=	20	2260
2617	Closed	=	13	2261
2619	41	>	18	2263
2620	{'capability': {'id': 15, 'name': 'Detect Motion', 'label': '{DEVICE} {status/T|Starts}{status/F|Stops} Detecting Motion'}, 'device': {'id': 10, 'name': 'Security Camera'}, 'parameterVals': [{'comparator': '=', 'value': 'No Motion'}], 'parameters': [{'id': 14, 'type': 'bin', 'values': ['Motion', 'No Motion'], 'name': 'status'}], 'text': 'Security Camera Stops Detecting Motion', 'channel': {'id': 6, 'icon': 'visibility', 'name': 'Sensors'}}	=	57	2264
2621	{'minutes': 30, 'seconds': 0, 'hours': 0}	>	58	2264
2622	Open	=	67	2265
2719	1	<	2	2350
2720	Day	=	62	2351
2721	Night	=	62	2352
2724	Home	!=	70	2355
2725	Nobody	 	71	2355
2726	Pop	=	8	2356
2727	Closed	=	65	2357
2728	76	=	18	2358
2623	{'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door {position/T|Opens}{position/F|Closes}"}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}, 'parameterVals': [{'comparator': '=', 'value': 'Open'}], 'parameters': [{'id': 67, 'type': 'bin', 'values': ['Open', 'Closed'], 'name': 'position'}], 'text': "Smart Refrigerator's door Opens", 'channel': {'id': 13, 'icon': 'fastfood', 'name': 'Food & Cooking'}}	=	52	2266
2624	{'minutes': 2, 'seconds': 0, 'hours': 0}	=	53	2266
2625	1	<	54	2266
2626	Pop	!=	8	2267
2627	Pop	 	8	2268
2628	On	=	1	2269
2629	Open	=	65	2270
2630	Open	=	65	2271
2631	Open	=	13	2272
2632	60	<	18	2273
2633	Open	=	13	2274
2634	80	>	18	2275
2635	Raining	=	20	2276
2636	Open	=	13	2277
2637	Open	=	67	2278
2638	{'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door {position/T|Opens}{position/F|Closes}"}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}, 'parameterVals': [{'comparator': '=', 'value': 'Open'}], 'parameters': [{'id': 67, 'type': 'bin', 'values': ['Open', 'Closed'], 'name': 'position'}], 'text': "Smart Refrigerator's door Opens", 'channel': {'id': 13, 'icon': 'fastfood', 'name': 'Food & Cooking'}}	=	57	2279
2639	{'minutes': 2, 'seconds': 0, 'hours': 0}	>	58	2279
2640	Pop	=	8	2280
2642	Open	=	65	2282
2643	Open	=	65	2283
2644	Pop	=	8	2284
2645	Pop	=	8	2285
2646	Pop	=	8	2286
2647	Closed	=	65	2287
2648	Pop	=	8	2288
2649	Pop	=	8	2289
2650	On	=	1	2290
2651	Pop	=	8	2291
2652	On	=	1	2292
2653	Asleep	=	68	2293
2654	On	=	1	2294
2655	{'text': '(FitBit) I Fall Asleep', 'parameters': [{'values': ['Awake', 'Asleep'], 'id': 68, 'name': 'status', 'type': 'bin'}], 'channel': {'icon': 'visibility', 'id': 6, 'name': 'Sensors'}, 'capability': {'id': 61, 'name': 'Sleep Sensor', 'label': '({DEVICE}) I {status/T|Wake Up}{status/F|Fall Asleep}'}, 'device': {'id': 21, 'name': 'FitBit'}, 'parameterVals': [{'comparator': '=', 'value': 'Asleep'}]}	=	57	2295
2656	{'minutes': 30, 'hours': 0, 'seconds': 0}	=	58	2295
2657	Unlocked	=	12	2296
2658	Asleep	=	68	2297
2659	Closed	=	13	2298
2660	Not Raining	=	20	2299
2661	59	>	18	2300
2662	81	<	18	2301
2663	Closed	=	13	2302
2664	Closed	=	13	2303
2665	On	=	72	2304
2666	{'text': "Smart Faucet's water is running", 'parameters': [{'values': ['On', 'Off'], 'id': 72, 'name': 'setting', 'type': 'bin'}], 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water is {setting/F|not }running"}, 'device': {'id': 22, 'name': 'Smart Faucet'}, 'parameterVals': [{'comparator': '=', 'value': ' '}]}	=	55	2305
2667	{'minutes': 15, 'hours': 0, 'seconds': 0}	=	56	2305
2668	On	=	1	2306
2670	On	=	1	2308
2671	Home	=	70	2309
2672	A Guest	=	71	2309
2673	On	=	1	2310
2674	Open	=	65	2311
2675	On	=	1	2312
2676	Living Room	 	70	2313
2677	A Family Member	 	71	2313
2678	Night	=	62	2314
2679	On	=	1	2315
2680	On	=	1	2316
2681	On	=	1	2317
2682	On	=	1	2318
2683	On	=	1	2319
2684	Open	=	13	2320
2685	On	=	1	2321
2686	Open	=	65	2322
2687	Open	=	67	2323
2688	{'parameters': [{'id': 67, 'name': 'position', 'type': 'bin', 'values': ['Open', 'Closed']}], 'parameterVals': [{'value': 'Closed', 'comparator': '='}], 'text': "Smart Refrigerator's door Closes", 'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door {position/T|Opens}{position/F|Closes}"}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}}	=	57	2324
2689	{'seconds': 0, 'hours': 0, 'minutes': 2}	>	58	2324
2690	40	=	18	2325
2691	80	>	18	2326
2692	80	>	21	2327
2693	Open	=	67	2328
2694	Pop	=	8	2329
2695	On	=	1	2330
2696	Open	=	65	2331
2697	On	=	1	2332
2698	On	=	1	2333
2699	Open	=	65	2334
2700	On	=	1	2335
2701	Open	=	65	2336
2702	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': 'On', 'comparator': '='}], 'text': "Smart Faucet's water Turns On", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}"}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	57	2337
2703	{'seconds': 15, 'hours': 0, 'minutes': 0}	>	58	2337
2704	On	=	1	2338
2705	Open	=	65	2339
2706	Asleep	=	68	2340
2707	On	=	1	2341
2708	{'parameters': [{'id': 68, 'name': 'status', 'type': 'bin', 'values': ['Awake', 'Asleep']}], 'parameterVals': [{'value': 'Asleep', 'comparator': '='}], 'text': '(FitBit) I Fall Asleep', 'capability': {'id': 61, 'name': 'Sleep Sensor', 'label': '({DEVICE}) I {status/T|Wake Up}{status/F|Fall Asleep}'}, 'channel': {'icon': 'visibility', 'id': 6, 'name': 'Sensors'}, 'device': {'id': 21, 'name': 'FitBit'}}	=	57	2342
2709	{'seconds': 0, 'hours': 0, 'minutes': 30}	=	58	2342
2710	80	>	18	2343
2711	On	=	1	2344
2712	Open	=	65	2345
2713	Bedroom	=	70	2346
2714	Alice	=	71	2346
2715	Open	=	67	2347
2717	Home	!=	70	2349
2718	Anyone	!=	71	2349
2722	Night	=	62	2353
2723	72	!=	18	2354
2729	Home	 	70	2359
2730	Anyone	 	71	2359
2731	Closed	=	13	2360
2732	Closed	=	13	2361
2733	Bathroom	=	70	2362
2734	Anyone	=	71	2362
2735	69	=	18	2363
2736	Home	 	70	2364
2737	Anyone	 	71	2364
2738	On	=	72	2365
2739	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': 'On', 'comparator': '='}], 'text': "Smart Faucet's water Turns On", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}"}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	57	2366
2740	{'seconds': 15, 'hours': 0, 'minutes': 0}	>	58	2366
2741	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': 'On', 'comparator': '='}], 'text': "Smart Faucet's water Turns On", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}"}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	57	2367
2742	{'seconds': 15, 'hours': 0, 'minutes': 0}	=	58	2367
2743	On	=	1	2368
2744	Open	=	65	2369
2745	Open	=	13	2370
2746	Open	=	65	2371
2747	68	=	18	2372
2748	88	!=	18	2373
2751	Home	=	70	2375
2752	A Guest	 	71	2375
2753	Bathroom	=	70	2376
2754	Anyone	=	71	2376
2755	On	=	72	2377
2756	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': 'On', 'comparator': '='}], 'text': "Smart Faucet's water Turns On", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}"}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	52	2378
2757	{'seconds': 15, 'hours': 0, 'minutes': 0}	=	53	2378
2758	1	=	54	2378
2759	Locked	=	12	2379
2760	79	>	18	2380
2761	Asleep	=	68	2381
2762	Unlocked	=	12	2382
2763	Home	=	70	2383
2764	A Guest	=	71	2383
2765	71	=	18	2384
2766	Closed	=	67	2385
2767	Open	=	67	2386
2768	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': 'On', 'comparator': '='}], 'text': "Smart Faucet's water Turns On", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}"}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	57	2387
2769	{'seconds': 15, 'hours': 0, 'minutes': 0}	=	58	2387
2770	Open	=	67	2388
2771	{'parameters': [{'id': 67, 'name': 'position', 'type': 'bin', 'values': ['Open', 'Closed']}], 'parameterVals': [{'value': 'Open', 'comparator': '='}], 'text': "Smart Refrigerator's door is Open", 'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door is {position}"}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}}	=	55	2389
2772	{'seconds': 0, 'hours': 0, 'minutes': 2}	=	56	2389
2773	Asleep	=	68	2390
2774	Awake	=	68	2391
2775	Home	!=	70	2392
2776	A Guest	=	71	2392
2778	Open	=	65	2394
2779	Open	=	13	2395
2780	Pop	=	8	2396
2781	Pop	=	8	2397
2782	80	>	18	2398
2783	{'parameters': [{'id': 70, 'name': 'location', 'type': 'set', 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room']}, {'id': 71, 'name': 'who', 'type': 'set', 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest', 'Nobody']}], 'parameterVals': [{'value': 'Home', 'comparator': '='}, {'value': 'A Guest', 'comparator': '='}], 'text': 'A Guest Enters Home', 'capability': {'id': 63, 'name': 'Detect Presence', 'label': '{who/=|}{who/!=|Someone other than }{who} {location/=|Enters}{location/!=|Exits} {location}'}, 'channel': {'icon': 'visibility', 'id': 6, 'name': 'Sensors'}, 'device': {'id': 12, 'name': 'Location Sensor'}}	=	57	2399
2784	{'seconds': 0, 'hours': 3, 'minutes': 1}	=	58	2399
2785	Home	=	70	2400
2786	A Guest	 	71	2400
2787	Raining	=	17	2401
2788	60	<	18	2402
2789	39	=	18	2403
2790	43	>	75	2404
2793	Kitchen	=	70	2406
2794	Bobbie	=	71	2406
2795	On	=	1	2407
2796	Asleep	=	68	2408
2797	Home	=	70	2409
2798	Anyone	=	71	2409
2799	Asleep	=	68	2410
2800	Closed	=	13	2411
2801	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': 'On', 'comparator': '='}], 'text': "Smart Faucet's water Turns On", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}"}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	57	2412
2802	{'seconds': 15, 'hours': 0, 'minutes': 0}	=	58	2412
2803	Home	=	70	2413
2804	Nobody	=	71	2413
2805	Closed	=	13	2414
2806	Home	=	70	2415
2807	Nobody	=	71	2415
2808	{'parameters': [{'id': 68, 'name': 'status', 'type': 'bin', 'values': ['Awake', 'Asleep']}], 'parameterVals': [{'value': 'Asleep', 'comparator': '='}], 'text': '(FitBit) I Fall Asleep', 'capability': {'id': 61, 'name': 'Sleep Sensor', 'label': '({DEVICE}) I {status/T|Wake Up}{status/F|Fall Asleep}'}, 'channel': {'icon': 'visibility', 'id': 6, 'name': 'Sensors'}, 'device': {'id': 21, 'name': 'FitBit'}}	=	57	2416
2809	{'seconds': 0, 'hours': 0, 'minutes': 30}	>	58	2416
2810	On	=	1	2417
2811	Closed	=	13	2418
2812	Closed	=	65	2419
2813	Off	=	1	2420
2814	Asleep	=	68	2421
2815	40	<	75	2422
2816	On	=	72	2423
2817	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': 'On', 'comparator': '='}], 'text': "Smart Faucet's water Turns On", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}"}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	57	2424
2818	{'seconds': 15, 'hours': 0, 'minutes': 0}	=	58	2424
2819	Unlocked	=	12	2425
2820	Asleep	=	68	2426
2821	Bathroom	=	70	2427
2822	Anyone	=	71	2427
2823	Pop	=	8	2428
2824	{'parameters': [{'id': 67, 'name': 'position', 'type': 'bin', 'values': ['Open', 'Closed']}], 'parameterVals': [{'value': 'Open', 'comparator': '='}], 'text': "Smart Refrigerator's door Opens", 'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door {position/T|Opens}{position/F|Closes}"}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}}	=	57	2429
2825	{'seconds': 0, 'hours': 0, 'minutes': 2}	=	58	2429
2826	Kitchen	=	70	2430
2827	Anyone	=	71	2430
2828	Open	=	67	2431
2829	Pop	=	8	2432
2830	Off	=	1	2433
2831	Asleep	=	68	2434
2832	60	<	18	2435
2833	Open	=	13	2436
2834	On	=	1	2437
2835	On	=	1	2438
2836	80	>	18	2439
2837	Open	=	13	2440
2839	Closed	=	65	2442
2840	Locked	=	12	2443
2841	Asleep	=	68	2444
2842	Pop	=	8	2445
2843	On	=	1	2446
2844	Open	=	65	2447
2845	Closed	=	13	2448
2846	Closed	=	13	2449
2847	Closed	=	13	2450
2848	Raining	=	20	2451
2849	On	=	1	2452
2850	Open	=	65	2453
2851	Raining	=	20	2454
2852	Open	=	13	2455
2853	Off	=	1	2456
2854	Asleep	=	68	2457
2855	On	=	1	2458
2856	Open	=	65	2459
2857	Unlocked	=	12	2460
2858	Kitchen	=	70	2461
2859	Bobbie	=	71	2461
2860	80	>	18	2462
2861	Off	=	1	2463
2862	Asleep	=	68	2464
2863	Closed	=	65	2465
2864	Bathroom	=	70	2466
2865	Anyone	=	71	2466
2866	Closed	=	67	2467
2867	Open	=	67	2468
2868	60	<	18	2469
2869	60	=	18	2470
2870	80	<	18	2471
2871	Off	=	1	2472
2872	Awake	=	68	2473
2873	Off	=	1	2474
2874	Unlocked	=	12	2475
2875	Kitchen	 	70	2476
2876	Bobbie	 	71	2476
2877	Open	=	65	2477
2878	Pop	=	8	2478
2879	Clear	=	17	2479
2880	60	>	18	2480
2881	80	<	18	2481
2882	On	=	64	2482
2883	Home	!=	70	2483
2884	Anyone	=	71	2483
2885	Pop	=	8	2484
2886	Home	=	70	2485
2887	Anyone	=	71	2485
2888	Off	=	72	2486
2889	On	=	72	2487
2890	Open	=	13	2488
2891	Home	=	70	2489
2892	A Family Member	=	71	2489
2893	{'parameters': [{'id': 67, 'name': 'position', 'type': 'bin', 'values': ['Open', 'Closed']}], 'parameterVals': [{'value': 'Open', 'comparator': '='}], 'text': "Smart Refrigerator's door is Open", 'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door is {position}"}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}}	=	55	2490
2894	{'seconds': 0, 'hours': 0, 'minutes': 2}	=	56	2490
2895	On	=	1	2491
2896	Kitchen	 	70	2492
2897	Bobbie	=	71	2492
2898	Open	=	13	2493
2899	Bedroom	=	70	2494
2900	A Family Member	=	71	2494
2901	Kitchen	=	70	2495
2902	Bobbie	=	71	2495
2903	Kitchen	!=	70	2496
2904	Bobbie	!=	71	2496
2905	60	=	21	2497
2906	Home	 	70	2498
2907	Anyone	 	71	2498
2908	{'parameters': [{'id': 70, 'name': 'location', 'type': 'set', 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room']}, {'id': 71, 'name': 'who', 'type': 'set', 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest', 'Nobody']}], 'parameterVals': [{'value': 'Home', 'comparator': '='}, {'value': 'A Guest', 'comparator': '='}], 'text': 'A Guest Enters Home', 'capability': {'id': 63, 'name': 'Detect Presence', 'label': '{who/=|}{who/!=|Someone other than }{who} {location/=|Enters}{location/!=|Exits} {location}'}, 'channel': {'icon': 'room', 'id': 15, 'name': 'Location'}, 'device': {'id': 12, 'name': 'Location Sensor'}}	=	57	2499
2909	{'seconds': 0, 'hours': 3, 'minutes': 0}	<	58	2499
2910	Closed	=	13	2500
2911	Closed	=	13	2501
2912	71	=	21	2502
2913	Home	 	70	2503
2914	Anyone	 	71	2503
2915	Closed	=	13	2504
2916	Closed	=	13	2505
2917	{'parameters': [{'id': 70, 'name': 'location', 'type': 'set', 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room']}, {'id': 71, 'name': 'who', 'type': 'set', 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest', 'Nobody']}], 'parameterVals': [{'value': 'Home', 'comparator': '='}, {'value': 'A Guest', 'comparator': '='}], 'text': 'A Guest Enters Home', 'capability': {'id': 63, 'name': 'Detect Presence', 'label': '{who/=|}{who/!=|Someone other than }{who} {location/=|Enters}{location/!=|Exits} {location}'}, 'channel': {'icon': 'room', 'id': 15, 'name': 'Location'}, 'device': {'id': 12, 'name': 'Location Sensor'}}	=	57	2506
2918	{'seconds': 0, 'hours': 3, 'minutes': 0}	>	58	2506
2919	{'parameters': [{'id': 67, 'name': 'position', 'type': 'bin', 'values': ['Open', 'Closed']}], 'parameterVals': [{'value': 'Open', 'comparator': '='}], 'text': "Smart Refrigerator's door Opens", 'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door {position/T|Opens}{position/F|Closes}"}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}}	=	57	2507
2920	{'seconds': 0, 'hours': 0, 'minutes': 2}	>	58	2507
2921	Kitchen	!=	70	2508
2922	Anyone	=	71	2508
2923	Kitchen	=	70	2509
2924	Bobbie	=	71	2509
2925	On	=	1	2510
2926	Raining	=	20	2511
2927	Closed	=	13	2512
2928	Closed	=	13	2513
2929	Closed	=	13	2514
2930	Closed	=	13	2515
2931	Kitchen	!=	70	2516
2932	Bobbie	=	71	2516
2933	On	=	1	2517
2934	Open	=	13	2518
2935	Raining	=	20	2519
2936	81	=	18	2520
2937	59	=	18	2521
2938	Closed	=	13	2522
2939	Closed	=	13	2523
2940	60	<	18	2524
2941	78	<	21	2525
2942	On	=	1	2526
2943	Open	=	65	2527
2944	Open	=	65	2528
2945	Open	=	65	2529
2946	Open	=	13	2530
2947	Closed	=	13	2531
2948	On	=	1	2532
2949	Open	=	65	2533
2950	Open	=	65	2534
2951	Open	=	65	2535
2952	80	>	18	2536
2953	Open	=	65	2537
2954	On	=	1	2538
2955	Pop	=	8	2539
2956	Open	=	65	2540
2957	On	=	1	2541
2958	Pop	!=	8	2542
2959	 	=	72	2543
2960	Open	=	65	2544
2961	On	=	1	2545
2962	80	>	18	2546
2963	Off	=	64	2547
2964	Kitchen	=	70	2548
2965	Bobbie	=	71	2548
2966	On	=	1	2549
2967	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': 'On', 'comparator': '='}], 'text': "Smart Faucet's water Turns On", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}"}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	57	2550
2968	{'seconds': 15, 'hours': 0, 'minutes': 0}	>	58	2550
2969	Kitchen	!=	70	2551
2970	Bobbie	=	71	2551
2971	On	=	1	2552
2972	{'parameters': [{'id': 67, 'name': 'position', 'type': 'bin', 'values': ['Open', 'Closed']}], 'parameterVals': [{'value': 'Open', 'comparator': '='}], 'text': "Smart Refrigerator's door is Open", 'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door is {position}"}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}}	=	55	2553
2973	{'seconds': 0, 'hours': 0, 'minutes': 2}	>	56	2553
2974	On	=	64	2554
2975	80	=	18	2555
2976	Pop	=	8	2556
2977	80	>	18	2557
2978	Pop	!=	8	2558
2979	Closed	=	67	2559
2980	Kitchen	!=	70	2560
2981	Anyone	=	71	2560
2982	Open	=	67	2561
2983	80	>	18	2562
2984	Open	=	13	2563
2985	Open	=	65	2564
2986	Closed	=	13	2565
2988	Open	=	13	2567
2989	100	=	74	2568
2990	Asleep	=	68	2569
2991	Bedroom	=	70	2570
2992	Anyone	=	71	2570
2993	Raining	=	20	2571
2994	Open	=	13	2572
2995	80	>	18	2573
2996	Open	=	13	2574
2997	60	<	18	2575
2998	Open	=	13	2576
2999	Home	=	70	2577
3000	A Family Member	!=	71	2577
3001	On	=	1	2578
3002	Open	=	65	2579
3003	80	>	18	2580
3004	Home	=	70	2581
3005	A Family Member	!=	71	2581
3006	On	=	1	2582
3007	Home	=	70	2583
3008	A Guest	=	71	2583
3009	{'parameters': [{'id': 70, 'name': 'location', 'type': 'set', 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room']}, {'id': 71, 'name': 'who', 'type': 'set', 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest', 'Nobody']}], 'parameterVals': [{'value': 'Home', 'comparator': '='}, {'value': 'A Guest', 'comparator': '='}], 'text': 'A Guest Enters Home', 'capability': {'id': 63, 'name': 'Detect Presence', 'label': '{who/=|}{who/!=|Someone other than }{who} {location/=|Enters}{location/!=|Exits} {location}'}, 'channel': {'icon': 'room', 'id': 15, 'name': 'Location'}, 'device': {'id': 12, 'name': 'Location Sensor'}}	=	57	2584
3010	{'seconds': 0, 'hours': 3, 'minutes': 0}	<	58	2584
3011	80	=	18	2585
3012	Home	=	70	2586
3013	A Family Member	!=	71	2586
3106	100	=	74	2665
3107	75	>	18	2666
3108	Home	 	70	2667
3109	Anyone	=	71	2667
3110	Closed	=	13	2668
3111	Closed	=	13	2669
3014	{'parameters': [{'id': 70, 'name': 'location', 'type': 'set', 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room']}, {'id': 71, 'name': 'who', 'type': 'set', 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest', 'Nobody']}], 'parameterVals': [{'value': 'Home', 'comparator': '='}, {'value': 'A Guest', 'comparator': '='}], 'text': 'A Guest Enters Home', 'capability': {'id': 63, 'name': 'Detect Presence', 'label': '{who/=|}{who/!=|Someone other than }{who} {location/=|Enters}{location/!=|Exits} {location}'}, 'channel': {'icon': 'room', 'id': 15, 'name': 'Location'}, 'device': {'id': 12, 'name': 'Location Sensor'}}	=	57	2587
3015	{'seconds': 0, 'hours': 3, 'minutes': 1}	=	58	2587
3016	On	=	1	2588
3017	Home	=	70	2589
3018	A Guest	=	71	2589
3019	On	=	1	2590
3020	Home	=	70	2591
3021	Nobody	=	71	2591
3022	Pop	=	8	2592
3023	Home	=	70	2593
3024	A Guest	=	71	2593
3025	On	=	1	2594
3026	Asleep	=	68	2595
3027	Not Raining	=	20	2596
3028	60	>	18	2597
3029	80	<	18	2598
3030	Closed	=	13	2599
3031	Closed	=	13	2600
3032	Closed	=	13	2601
3033	Open	=	67	2602
3034	Pop	=	8	2603
3035	Closed	=	13	2604
3036	Closed	=	13	2605
3037	Closed	=	13	2606
3038	Closed	=	13	2607
3039	Closed	=	13	2608
3040	Closed	=	13	2609
3041	Closed	=	13	2610
3042	Closed	=	13	2611
3043	Closed	=	13	2612
3044	Closed	=	13	2613
3045	Closed	=	13	2614
3046	Closed	=	13	2615
3047	{'parameters': [{'id': 67, 'name': 'position', 'type': 'bin', 'values': ['Open', 'Closed']}], 'parameterVals': [{'value': 'Open', 'comparator': '='}], 'text': "Smart Refrigerator's door Opens", 'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door {position/T|Opens}{position/F|Closes}"}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}}	=	57	2616
3048	{'seconds': 0, 'hours': 0, 'minutes': 2}	>	58	2616
3049	Kitchen	=	70	2617
3050	Bobbie	=	71	2617
3051	On	=	1	2618
3052	On	=	72	2619
3053	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': 'On', 'comparator': '='}], 'text': "Smart Faucet's water Turns On", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}"}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	57	2620
3054	{'seconds': 15, 'hours': 0, 'minutes': 0}	>	58	2620
3055	 	=	72	2621
3056	Kitchen	=	70	2622
3057	Bobbie	=	71	2622
3058	On	=	1	2623
3059	Asleep	=	68	2624
3061	Home	=	70	2626
3062	A Family Member	!=	71	2626
3064	Open	=	65	2628
3065	On	=	1	2629
3066	Open	=	65	2630
3067	On	=	1	2631
3068	Open	=	65	2632
3069	On	=	1	2633
3070	Open	=	65	2634
3071	79	>	18	2635
3072	79	<	18	2636
3073	80	<	21	2637
3074	80	=	18	2638
3075	Closed	=	65	2639
3076	Off	=	72	2640
3077	On	=	72	2641
3078	Home	=	70	2642
3079	A Guest	=	71	2642
3080	On	=	1	2643
3081	Closed	=	67	2644
3082	Open	=	67	2645
3083	{'parameters': [{'id': 67, 'name': 'position', 'type': 'bin', 'values': ['Open', 'Closed']}], 'parameterVals': [{'value': 'Open', 'comparator': '='}], 'text': "Smart Refrigerator's door is Open", 'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door is {position}"}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}}	=	50	2646
3084	{'seconds': 0, 'hours': 0, 'minutes': 2}	=	51	2646
3085	Open	=	67	2647
3086	{'parameters': [{'id': 67, 'name': 'position', 'type': 'bin', 'values': ['Open', 'Closed']}], 'parameterVals': [{'value': 'Open', 'comparator': '='}], 'text': "Smart Refrigerator's door is Open", 'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door is {position}"}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}}	=	50	2648
3087	{'seconds': 0, 'hours': 0, 'minutes': 2}	=	51	2648
3088	Open	=	67	2649
3089	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': ' ', 'comparator': '='}], 'text': "Smart Faucet's water is running", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water is {setting/F|not }running"}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	55	2650
3090	{'seconds': 0, 'hours': 0, 'minutes': 0}	=	56	2650
3091	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': 'On', 'comparator': '='}], 'text': "Smart Faucet's water Turns On", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}"}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	57	2651
3092	{'seconds': 15, 'hours': 0, 'minutes': 0}	=	58	2651
3093	Off	=	1	2652
3094	Open	=	65	2653
3095	Open	=	65	2654
3096	Open	=	65	2655
3097	Open	=	13	2656
3098	Open	=	13	2657
3099	Open	=	13	2658
3100	Locked	=	12	2659
3101	23:30	=	23	2660
3102	Open	=	13	2661
3103	Raining	=	20	2662
3104	60	<	18	2663
3105	80	>	18	2664
3112	Closed	=	13	2670
3113	40	<	18	2671
3114	{'parameters': [{'id': 68, 'name': 'status', 'type': 'bin', 'values': ['Awake', 'Asleep']}], 'parameterVals': [{'value': 'Asleep', 'comparator': '='}], 'text': '(FitBit) I Fall Asleep', 'capability': {'id': 61, 'name': 'Sleep Sensor', 'label': '({DEVICE}) I {status/T|Wake Up}{status/F|Fall Asleep}'}, 'channel': {'icon': 'favorite_border', 'id': 16, 'name': 'Health'}, 'device': {'id': 21, 'name': 'FitBit'}}	=	57	2672
3115	{'seconds': 0, 'hours': 0, 'minutes': 30}	>	58	2672
3116	60	<	18	2673
3117	80	>	18	2674
3118	Open	=	13	2675
3119	70	>	74	2676
3120	Kitchen	!=	70	2677
3121	Bobbie	!=	71	2677
3122	Unlocked	=	12	2678
3123	Locked	=	12	2679
3124	Asleep	=	68	2680
3125	Open	=	13	2681
3126	80	=	18	2682
3127	Closed	=	13	2683
3128	60	=	18	2684
3129	On	=	1	2685
3130	{'parameters': [{'id': 70, 'name': 'location', 'type': 'set', 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room']}, {'id': 71, 'name': 'who', 'type': 'set', 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest', 'Nobody']}], 'parameterVals': [{'value': 'Home', 'comparator': '='}, {'value': 'A Family Member', 'comparator': '!='}], 'text': 'Someone other than A Family Member is in Home', 'capability': {'id': 63, 'name': 'Detect Presence', 'label': '{who/!=|Someone other than }{who} is {location/!=|not }in {location}'}, 'channel': {'icon': 'room', 'id': 15, 'name': 'Location'}, 'device': {'id': 12, 'name': 'Location Sensor'}}	=	57	2686
3131	{'seconds': 0, 'hours': 3, 'minutes': 0}	<	58	2686
3132	Open	=	13	2687
3133	60	=	18	2688
3134	Closed	=	13	2689
3135	59	=	18	2690
3136	Closed	=	13	2691
3137	Raining	=	20	2692
3138	Closed	=	13	2693
3139	Raining	=	20	2694
3140	60	<	18	2695
3141	88	=	18	2696
3142	84	>	18	2697
3143	77	=	21	2698
3144	83	=	18	2699
3145	pop	=	35	2700
3146	Home	=	70	2701
3147	A Guest	=	71	2701
3148	On	=	1	2702
3150	Closed	=	13	2704
3151	80	>	18	2705
3152	60	<	18	2706
3153	Closed	=	65	2707
3154	Pop	!=	8	2708
3155	80	<	18	2709
3156	Open	=	65	2710
3157	Open	=	65	2711
3158	Open	=	65	2712
3159	Locked	=	12	2713
3160	Pop	=	8	2714
3161	Yes	=	25	2715
3162	49	=	18	2716
3163	 	=	72	2717
3164	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': 'Off', 'comparator': '='}], 'text': "Turn Off Smart Faucet's water", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "Turn {setting} {DEVICE}'s water"}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	55	2718
3165	{'seconds': 15, 'hours': 0, 'minutes': 0}	>	56	2718
3166	41	=	75	2719
3167	Closed	=	65	2720
3168	Open	=	65	2721
3169	Open	=	65	2722
3170	Open	=	65	2723
3171	Open	=	67	2724
3172	Bathroom	=	70	2725
3173	Anyone	=	71	2725
3174	72	=	21	2726
3175	Home	 	70	2727
3176	Anyone	 	71	2727
3177	72	=	21	2728
3178	Home	!=	70	2729
3179	Anyone	 	71	2729
3180	On	=	1	2730
3181	Home	=	70	2731
3182	A Guest	!=	71	2731
3183	On	=	1	2732
3184	Home	=	70	2733
3185	A Guest	 	71	2733
3186	On	=	1	2734
3187	Home	 	70	2735
3188	A Guest	!=	71	2735
3189	On	=	1	2736
3190	Open	=	65	2737
3191	Open	=	65	2738
3192	Open	=	65	2739
3193	{'parameters': [{'id': 67, 'name': 'position', 'type': 'bin', 'values': ['Open', 'Closed']}], 'parameterVals': [{'value': 'Open', 'comparator': '='}], 'text': "Smart Refrigerator's door Opens", 'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door {position/T|Opens}{position/F|Closes}"}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}}	=	57	2740
3194	{'seconds': 0, 'hours': 0, 'minutes': 2}	>	58	2740
3195	On	=	1	2741
3196	Night	=	62	2742
3197	Bedroom	 	70	2743
3198	Anyone	 	71	2743
3199	Asleep	=	68	2744
3200	On	=	1	2745
3201	Home	 	70	2746
3202	A Guest	 	71	2746
3203	17:00	>	23	2747
3204	On	=	1	2748
3205	Home	=	70	2749
3206	A Family Member	!=	71	2749
3207	 	=	72	2750
3208	Open	=	13	2751
3209	Closed	=	13	2752
3210	Closed	=	13	2753
3211	Open	=	13	2754
3212	Closed	=	13	2755
3213	Closed	=	13	2756
3214	Open	=	13	2757
3215	Closed	=	13	2758
3216	Closed	=	13	2759
3217	Open	=	65	2760
3218	Open	=	67	2761
3219	On	=	1	2762
3220	Open	=	65	2763
3221	Open	=	65	2764
3222	Open	=	65	2765
3224	On	=	72	2767
3226	On	=	72	2769
3228	On	=	72	2771
3230	On	=	72	2773
3232	On	=	72	2775
3234	On	=	72	2777
3236	On	=	72	2779
3238	On	=	72	2781
3240	On	=	72	2783
3242	On	=	72	2785
3244	On	=	72	2787
3245	Off	=	72	2788
3246	On	=	72	2789
3247	Off	=	72	2790
3248	On	=	72	2791
3249	Off	=	72	2792
3250	On	=	72	2793
3251	Off	=	72	2794
3252	On	=	72	2795
3253	Off	=	72	2796
3254	On	=	72	2797
3255	Off	=	72	2798
3256	On	=	72	2799
3257	Off	=	72	2800
3258	On	=	72	2801
3259	Off	=	72	2802
3260	On	=	72	2803
3261	Off	=	72	2804
3262	On	=	72	2805
3263	Off	=	72	2806
3264	On	=	72	2807
3265	Off	=	72	2808
3266	Off	=	72	2809
3267	Open	=	65	2810
3268	On	=	1	2811
3269	Locked	=	12	2812
3270	Kitchen	=	70	2813
3271	Bobbie	=	71	2813
3272	Locked	=	12	2814
3273	Kitchen	=	70	2815
3274	Bobbie	=	71	2815
3275	Open	=	67	2816
3276	Open	=	67	2817
3277	Closed	=	67	2818
3278	Closed	=	67	2819
3279	Closed	=	67	2820
3280	100	>	74	2821
3281	Closed	=	65	2822
3282	On	=	1	2823
3283	Off	=	72	2824
3284	Off	=	72	2825
3285	39	=	18	2826
3286	Asleep	=	68	2827
3287	Night	=	62	2828
3288	 	=	26	2829
3289	2	=	35	2830
3290	Closed	=	13	2831
3291	Closed	=	13	2832
3292	 	=	72	2833
3293	Closed	=	13	2834
3294	Closed	=	13	2835
3295	 	=	72	2836
3296	Closed	=	13	2837
3297	Closed	=	13	2838
3298	140	=	69	2839
3299	{'parameters': [{'id': 68, 'name': 'status', 'type': 'bin', 'values': ['Awake', 'Asleep']}], 'parameterVals': [{'value': 'Asleep', 'comparator': '='}], 'text': '(FitBit) I Fall Asleep', 'capability': {'id': 61, 'name': 'Sleep Sensor', 'label': '({DEVICE}) I {status/T|Wake Up}{status/F|Fall Asleep}'}, 'channel': {'icon': 'favorite_border', 'id': 16, 'name': 'Health'}, 'device': {'id': 21, 'name': 'FitBit'}}	=	57	2840
3300	{'seconds': 0, 'hours': 0, 'minutes': 30}	=	58	2840
3301	On	=	1	2841
3302	100	>	74	2842
3303	Closed	=	67	2843
3304	1	 	34	2844
3305	81	=	18	2845
3306	80	=	18	2846
3307	{'parameters': [{'id': 18, 'name': 'temperature', 'type': 'range', 'values': [-50, 120, 1]}], 'parameterVals': [{'value': 45, 'comparator': '>'}], 'text': '(Weather Sensor) The temperature goes above 45 degrees', 'capability': {'id': 19, 'name': 'Current Temperature', 'label': '({DEVICE}) The temperature {temperature/=|becomes}{temperature/!=|changes from}{temperature/>|goes above}{temperature/<|falls below} {temperature} degrees'}, 'channel': {'icon': 'ac_unit', 'id': 8, 'name': 'Temperature'}, 'device': {'id': 18, 'name': 'Weather Sensor'}}	=	52	2847
3308	{'seconds': 14, 'hours': 2, 'minutes': 6}	=	53	2847
3309	13	=	54	2847
3310	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': 'On', 'comparator': '='}], 'text': "Smart Faucet's water Turns On", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}"}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	57	2848
3311	{'seconds': 16, 'hours': 0, 'minutes': 0}	=	58	2848
3312	Blue	=	3	2849
3313	Bathroom	!=	70	2850
3314	Alice	=	71	2850
3315	70	=	21	2851
3316	Home	 	70	2852
3317	Anyone	=	71	2852
3318	{'parameters': [{'id': 13, 'name': 'position', 'type': 'bin', 'values': ['Open', 'Closed']}], 'parameterVals': [{'value': 'Closed', 'comparator': '='}], 'text': 'Bathroom Window is Closed', 'capability': {'id': 14, 'name': 'Open/Close Window', 'label': '{DEVICE} is {position}'}, 'channel': {'icon': 'meeting_room', 'id': 5, 'name': 'Windows & Doors'}, 'device': {'id': 24, 'name': 'Bathroom Window'}}	=	50	2853
3319	{'seconds': 0, 'hours': 0, 'minutes': 0}	=	51	2853
3320	Closed	=	13	2854
3321	Closed	=	13	2855
3322	Closed	=	13	2856
3323	Closed	=	13	2857
3324	Closed	=	13	2858
3325	Partly Cloudy	!=	17	2859
3326	Closed	=	13	2860
3327	Closed	=	13	2861
3328	Closed	=	13	2862
3329	On	=	1	2863
3330	Kitchen	 	70	2864
3331	Alice	!=	71	2864
3332	Open	=	67	2865
3333	78	=	18	2866
3334	78	=	18	2867
3335	Closed	=	13	2868
3336	Closed	=	13	2869
3337	Closed	=	13	2870
3338	Closed	=	13	2871
3339	Closed	=	13	2872
3340	Closed	=	13	2873
3341	Open	=	65	2874
3342	Bedroom	 	70	2875
3343	Anyone	 	71	2875
3345	Open	=	13	2877
3346	Closed	=	13	2878
3347	80	>	18	2879
3471	Bobbie	=	71	2989
3472	Open	=	13	2990
3473	80	>	18	2991
3474	On	=	1	2992
3475	Asleep	=	68	2993
3572	A Family Member	!=	71	3074
3573	Home	 	70	3075
3574	Alice	!=	71	3075
3575	Home	 	70	3076
3576	Bobbie	!=	71	3076
3348	{'parameters': [{'id': 70, 'name': 'location', 'type': 'set', 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room']}, {'id': 71, 'name': 'who', 'type': 'set', 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest', 'Nobody']}], 'parameterVals': [{'value': 'Home', 'comparator': '='}, {'value': 'Nobody', 'comparator': '!='}], 'text': 'Someone other than Nobody Enters Home', 'capability': {'id': 63, 'name': 'Detect Presence', 'label': '{who/=|}{who/!=|Someone other than }{who} {location/=|Enters}{location/!=|Exits} {location}'}, 'channel': {'icon': 'visibility', 'id': 6, 'name': 'Sensors'}, 'device': {'id': 12, 'name': 'Location Sensor'}}	=	57	2880
3349	{'seconds': 0, 'hours': 3, 'minutes': 0}	<	58	2880
3350	41	=	75	2881
3351	Open	=	67	2882
3352	Pop	=	8	2883
3353	Pop	=	8	2884
3354	Asleep	=	68	2885
3355	72	=	21	2886
3356	Locked	=	12	2887
3357	Night	=	62	2888
3358	Closed	=	67	2889
3359	Open	=	67	2890
3360	Closed	=	67	2891
3361	Open	=	67	2892
3362	Open	=	13	2893
3363	Raining	!=	17	2894
3364	Thunderstorms	=	17	2895
3365	Snowing	=	17	2896
3366	Hailing	=	17	2897
3367	Raining	=	20	2898
3368	Open	=	13	2899
3369	Sunny	 	17	2900
3370	Clear	 	17	2901
3371	Open	=	13	2902
3372	Raining	!=	17	2903
3373	Thunderstorms	=	17	2904
3374	Snowing	=	17	2905
3375	Hailing	=	17	2906
3376	Raining	=	20	2907
3377	40	<	75	2908
3379	Motion	=	14	2910
3380	Pop	=	8	2911
3381	81	=	18	2912
3382	Pop	=	8	2913
3383	60	<	21	2914
3384	80	>	18	2915
3385	Pop	=	8	2916
3386	Pop	=	8	2917
3387	Pop	=	8	2918
3388	Off	=	72	2919
3389	On	=	72	2920
3390	80	>	18	2921
3391	Raining	=	20	2922
3392	Asleep	=	68	2923
3393	Unlocked	=	12	2924
3394	On	=	1	2925
3395	Living Room	 	70	2926
3396	A Family Member	!=	71	2926
3397	Locked	=	12	2927
3398	Night	=	62	2928
3399	72	=	21	2929
3400	Home	=	70	2930
3401	A Family Member	=	71	2930
3402	On	=	72	2931
3404	Pop	=	8	2933
3405	Locked	=	12	2934
3406	Kitchen	=	70	2935
3407	Bobbie	=	71	2935
3408	On	=	72	2936
3409	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': ' ', 'comparator': '='}], 'text': "Smart Faucet's water is running", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water is {setting/F|not }running"}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	50	2937
3410	{'seconds': 15, 'hours': 0, 'minutes': 0}	=	51	2937
3411	Open	=	13	2938
3412	60	<	18	2939
3413	80	>	18	2940
3414	Raining	=	20	2941
3415	On	=	1	2942
3416	Living Room	 	70	2943
3417	A Family Member	!=	71	2943
3418	{'parameters': [{'id': 70, 'name': 'location', 'type': 'set', 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room']}, {'id': 71, 'name': 'who', 'type': 'set', 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest', 'Nobody']}], 'parameterVals': [{'value': 'Living Room', 'comparator': ' '}, {'value': 'A Family Member', 'comparator': '!='}], 'text': 'Someone other than A Family Member is in Living Room', 'capability': {'id': 63, 'name': 'Detect Presence', 'label': '{who/!=|Someone other than }{who} is {location/!=|not }in {location}'}, 'channel': {'icon': 'room', 'id': 15, 'name': 'Location'}, 'device': {'id': 12, 'name': 'Location Sensor'}}	=	57	2944
3419	{'seconds': 0, 'hours': 3, 'minutes': 0}	<	58	2944
3421	Living Room	 	70	2946
3422	A Family Member	!=	71	2946
3424	Open	=	65	2948
3425	On	=	1	2949
3426	Open	=	65	2950
3427	On	=	1	2951
3428	Open	=	65	2952
3429	On	=	1	2953
3430	Closed	=	65	2954
3431	On	=	1	2955
3432	Open	=	65	2956
3433	39	=	18	2957
3434	On	=	1	2958
3435	Open	=	65	2959
3436	41	=	18	2960
3437	On	=	1	2961
3438	Asleep	=	68	2962
3439	On	=	1	2963
3440	Kitchen	 	70	2964
3441	Bobbie	=	71	2964
3442	73	=	21	2965
3443	Home	 	70	2966
3444	Anyone	 	71	2966
3445	Kitchen	=	70	2967
3446	Bobbie	=	71	2967
3447	On	=	1	2968
3448	Open	=	13	2969
3449	60	>	18	2970
3450	Raining	!=	17	2971
3451	80	<	18	2972
3452	On	=	1	2973
3453	Open	=	65	2974
3454	Open	=	65	2975
3455	Open	=	65	2976
3456	Off	=	1	2977
3457	Asleep	=	68	2978
3458	Off	=	1	2979
3459	Asleep	=	68	2980
3460	Off	=	1	2981
3461	Asleep	=	68	2982
3462	Open	=	13	2983
3463	Raining	=	20	2984
3464	Asleep	=	68	2985
3465	On	=	1	2986
3466	Home	=	70	2987
3467	A Family Member	!=	71	2987
3468	Home	 	70	2988
3469	Alice	=	71	2988
3470	Home	=	70	2989
3476	{'parameters': [{'id': 1, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': 'On', 'comparator': '='}], 'text': 'Smart TV turns On', 'capability': {'id': 2, 'name': 'Power On/Off', 'label': '{DEVICE} turns {setting}'}, 'channel': {'icon': 'tv', 'id': 12, 'name': 'Television'}, 'device': {'id': 5, 'name': 'Smart TV'}}	=	57	2994
3477	{'seconds': 0, 'hours': 0, 'minutes': 30}	=	58	2994
3478	Closed	=	65	2995
3479	On	=	1	2996
3480	Closed	=	65	2997
3481	Closed	=	65	2998
3482	Open	=	13	2999
3483	60	<	18	3000
3484	Home	=	70	3001
3485	A Family Member	!=	71	3001
3486	Home	 	70	3002
3487	Alice	=	71	3002
3488	Home	=	70	3003
3489	Bobbie	=	71	3003
3490	Open	=	65	3004
3491	Open	=	65	3005
3492	40	<	75	3006
3493	40	<	75	3007
3494	Home	=	70	3008
3495	A Family Member	!=	71	3008
3496	On	=	1	3009
3497	Open	=	65	3010
3498	On	=	1	3011
3499	Open	=	65	3012
3500	On	=	1	3013
3501	Open	=	65	3014
3502	On	=	1	3015
3503	Open	=	65	3016
3504	Pop	 	8	3017
3505	Raining	!=	17	3018
3506	60	>	18	3019
3507	80	<	18	3020
3509	On	=	72	3022
3511	Off	=	72	3024
3512	On	=	72	3025
3513	Kitchen	!=	70	3026
3514	Anyone	=	71	3026
3515	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': 'On', 'comparator': '='}], 'text': "Smart Faucet's water Turns On", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}"}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	57	3027
3516	{'seconds': 15, 'hours': 0, 'minutes': 0}	=	58	3027
3517	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': ' ', 'comparator': '='}], 'text': "Smart Faucet's water is running", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water is {setting/F|not }running"}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	55	3028
3518	{'seconds': 0, 'hours': 0, 'minutes': 0}	=	56	3028
3519	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': 'On', 'comparator': '='}], 'text': "Smart Faucet's water Turns On", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}"}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	57	3029
3520	{'seconds': 15, 'hours': 0, 'minutes': 0}	=	58	3029
3521	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': ' ', 'comparator': '='}], 'text': "Smart Faucet's water is running", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water is {setting/F|not }running"}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	55	3030
3522	{'seconds': 1, 'hours': 0, 'minutes': 0}	=	56	3030
3523	Locked	=	12	3031
3524	Night	=	62	3032
3525	100	=	74	3033
3526	Kitchen	 	70	3034
3527	Alice	!=	71	3034
3528	Open	=	65	3035
3529	On	=	1	3036
3530	Home	=	70	3037
3531	A Family Member	!=	71	3037
3533	Off	=	72	3039
3534	{'parameters': [{'id': 67, 'name': 'position', 'type': 'bin', 'values': ['Open', 'Closed']}], 'parameterVals': [{'value': 'Open', 'comparator': '='}], 'text': "Smart Refrigerator's door Opens", 'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door {position/T|Opens}{position/F|Closes}"}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}}	=	57	3040
3535	{'seconds': 0, 'hours': 0, 'minutes': 2}	=	58	3040
3536	{'parameters': [{'id': 67, 'name': 'position', 'type': 'bin', 'values': ['Open', 'Closed']}], 'parameterVals': [{'value': 'Open', 'comparator': '='}], 'text': "Smart Refrigerator's door is Open", 'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door is {position}"}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}}	=	55	3041
3537	{'seconds': 1, 'hours': 0, 'minutes': 0}	=	56	3041
3538	Open	=	65	3042
3540	On	=	1	3044
3541	Asleep	=	68	3045
3542	Pop	=	8	3046
3543	{'parameters': [{'id': 68, 'name': 'status', 'type': 'bin', 'values': ['Awake', 'Asleep']}], 'parameterVals': [{'value': 'Asleep', 'comparator': '='}], 'text': '(FitBit) I am Asleep', 'capability': {'id': 61, 'name': 'Sleep Sensor', 'label': '({DEVICE}) I am {status}'}, 'channel': {'icon': 'visibility', 'id': 6, 'name': 'Sensors'}, 'device': {'id': 21, 'name': 'FitBit'}}	=	55	3047
3544	{'seconds': 0, 'hours': 0, 'minutes': 30}	=	56	3047
3549	Open	=	13	3052
3550	Closed	=	13	3053
3551	Closed	=	13	3054
3552	Locked	=	12	3055
3553	Closed	=	67	3056
3557	40	=	18	3060
3558	Open	=	13	3061
3559	Raining	=	20	3062
3560	60	=	18	3063
3561	80	=	18	3064
3562	Off	=	1	3065
3563	23:00	>	23	3066
3564	Off	=	1	3067
3565	Night	=	62	3068
3566	Open	=	67	3069
3567	On	=	1	3070
3568	17:00	>	23	3071
3569	On	=	1	3072
3570	Motion	=	14	3073
3571	Home	 	70	3074
3577	Open	=	67	3077
3578	{'parameters': [{'id': 67, 'name': 'position', 'type': 'bin', 'values': ['Open', 'Closed']}], 'parameterVals': [{'value': 'Open', 'comparator': '='}], 'text': "Smart Refrigerator's door Opens", 'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door {position/T|Opens}{position/F|Closes}"}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}}	=	57	3078
3579	{'seconds': 0, 'hours': 0, 'minutes': 2}	>	58	3078
3580	No	=	25	3079
3581	Night	=	62	3080
3582	Off	=	1	3081
3583	23:00	=	23	3082
3585	17:00	=	23	3084
3586	On	=	72	3085
3587	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': 'On', 'comparator': '='}], 'text': "Smart Faucet's water Turns On", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}"}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	57	3086
3588	{'seconds': 15, 'hours': 0, 'minutes': 0}	>	58	3086
3589	Off	=	1	3087
3590	17:00	=	23	3088
3593	Home	=	70	3091
3594	Anyone	=	71	3091
3595	Pop	=	8	3092
3596	Home	!=	70	3093
3597	Anyone	=	71	3093
3598	Home	!=	70	3094
3599	Anyone	=	71	3094
3600	Off	=	64	3095
3601	Home	!=	70	3096
3602	A Family Member	=	71	3096
3603	Off	=	1	3097
3604	17:00	=	23	3098
3605	Off	=	72	3099
3606	On	=	72	3100
3607	Open	=	13	3101
3608	Locked	=	12	3102
3609	Kitchen	=	70	3103
3610	Bobbie	 	71	3103
3611	Home	=	70	3104
3612	Alice	!=	71	3104
3613	{'parameters': [{'id': 70, 'name': 'location', 'type': 'set', 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room']}, {'id': 71, 'name': 'who', 'type': 'set', 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest', 'Nobody']}], 'parameterVals': [{'value': 'Home', 'comparator': '='}, {'value': 'Anyone', 'comparator': '!='}], 'text': 'Someone other than Anyone Enters Home', 'capability': {'id': 63, 'name': 'Detect Presence', 'label': '{who/=|}{who/!=|Someone other than }{who} {location/=|Enters}{location/!=|Exits} {location}'}, 'channel': {'icon': 'visibility', 'id': 6, 'name': 'Sensors'}, 'device': {'id': 12, 'name': 'Location Sensor'}}	=	57	3105
3614	{'seconds': 0, 'hours': 3, 'minutes': 0}	>	58	3105
3615	Closed	=	65	3106
3616	On	=	1	3107
3617	Night	=	62	3108
3618	22:00	=	23	3109
3619	Pop	!=	8	3110
3620	On	=	1	3111
3621	Open	=	65	3112
3622	Day	=	62	3113
3623	Locked	=	12	3114
3624	Not Raining	=	20	3115
3625	Bedroom	=	70	3116
3626	Anyone	=	71	3116
3627	Closed	=	65	3117
3628	Pop	=	8	3118
3629	Day	=	62	3119
3630	Home	!=	70	3120
3631	Anyone	 	71	3120
3632	Not Raining	=	20	3121
3633	Bedroom	!=	70	3122
3634	A Family Member	=	71	3122
3635	Locked	=	12	3123
3636	Pop	=	8	3124
3637	80	>	18	3125
3638	Closed	=	13	3126
3639	Night	=	62	3127
3640	On	=	1	3128
3641	Open	=	65	3129
3642	Open	=	65	3130
3643	Open	=	65	3131
3644	On	=	72	3132
3645	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': 'On', 'comparator': '='}], 'text': "Smart Faucet's water Turns On", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}"}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	57	3133
3646	{'seconds': 15, 'hours': 0, 'minutes': 0}	=	58	3133
3647	Off	=	1	3134
3648	Night	=	62	3135
3649	Home	=	70	3136
3650	Anyone	=	71	3136
3651	Pop music	=	35	3137
3652	Unlocked	=	12	3138
3653	Off	=	1	3139
3654	Night	=	62	3140
3655	On	=	1	3141
3656	Home	=	70	3142
3657	A Guest	 	71	3142
3658	Day	=	62	3143
3659	Home	 	70	3144
3660	Anyone	 	71	3144
3661	Unlocked	=	12	3145
3662	Closed	=	13	3146
3663	Off	=	1	3147
3664	Asleep	=	68	3148
3665	Locked	=	12	3149
3666	Asleep	=	68	3150
3667	On	=	1	3151
3668	Asleep	=	68	3152
3669	Off	=	64	3153
3670	79	>	18	3154
3671	Day	=	62	3155
3672	Home	!=	70	3156
3673	Anyone	 	71	3156
3674	Locked	=	12	3157
3675	Closed	=	13	3158
3676	Closed	=	13	3159
3677	Closed	=	13	3160
3678	40	!=	75	3161
3679	Unlocked	=	12	3162
3680	Home	!=	70	3163
3681	Anyone	 	71	3163
3682	Locked	=	12	3164
3683	Asleep	=	68	3165
3684	80	=	18	3166
3685	Off	=	1	3167
3686	Asleep	=	68	3168
3687	Closed	=	13	3169
3688	Closed	=	13	3170
3689	Closed	=	13	3171
3690	Home	=	70	3172
3691	Anyone	=	71	3172
3692	Day	=	62	3173
3693	Unlocked	=	12	3174
3694	Closed	=	13	3175
3695	Closed	=	13	3176
3696	Closed	=	13	3177
3697	POP Music	=	35	3178
3698	75	>	18	3179
3699	Home	 	70	3180
3700	Nobody	!=	71	3180
3701	75	>	18	3181
3702	Home	 	70	3182
3703	Nobody	!=	71	3182
3704	75	>	18	3183
3705	Home	 	70	3184
3706	Nobody	!=	71	3184
3707	On	=	1	3185
3708	Open	=	65	3186
3709	On	=	72	3187
3710	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': 'On', 'comparator': '='}], 'text': "Smart Faucet's water Turns On", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}"}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	57	3188
3711	{'seconds': 0, 'hours': 0, 'minutes': 15}	=	58	3188
3712	60	>	18	3189
3713	80	>	18	3190
3717	Motion	=	14	3193
3718	Asleep	=	68	3194
3719	Motion	=	14	3195
3720	Asleep	=	68	3196
3721	80	>	18	3197
3722	Off	=	64	3198
3723	80	=	18	3199
3724	On	=	1	3200
3725	Awake	=	68	3201
3726	75	<	69	3202
3727	On	=	1	3203
3728	Home	=	70	3204
3729	Anyone	=	71	3204
3730	On	=	1	3205
3731	Home	 	70	3206
3732	A Guest	 	71	3206
3733	Pop	=	8	3207
3734	Off	=	64	3208
3735	80	=	18	3209
3736	Open	=	67	3210
3737	Pop	=	8	3211
3738	On	=	1	3212
3739	Home	=	70	3213
3740	Anyone	=	71	3213
3741	Open	=	65	3214
3742	Pop	!=	8	3215
3743	Home	=	70	3216
3744	Anyone	=	71	3216
3745	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': 'On', 'comparator': '='}], 'text': "Smart Faucet's water Turns On", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}"}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	57	3217
3746	{'seconds': 15, 'hours': 0, 'minutes': 0}	>	58	3217
3747	 	=	72	3218
3748	On	=	72	3219
3749	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': 'On', 'comparator': '='}], 'text': "Smart Faucet's water Turns On", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}"}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	52	3220
3750	{'seconds': 15, 'hours': 0, 'minutes': 0}	=	53	3220
3751	1	=	54	3220
3753	80	>	18	3222
3754	Open	=	13	3223
3755	60	<	18	3224
3756	Kitchen	=	70	3225
3757	Bobbie	=	71	3225
3758	Pop	=	8	3226
3759	Open	=	65	3227
3760	On	=	1	3228
3761	Home	!=	70	3229
3762	Anyone	=	71	3229
3763	75	>	21	3230
3764	Off	=	1	3231
3765	Asleep	=	68	3232
3766	Home	!=	70	3233
3767	Anyone	=	71	3233
3769	Open	=	13	3235
3770	Closed	=	13	3236
3771	Closed	=	13	3237
3772	Motion	=	14	3238
3773	On	=	1	3239
3774	 	=	72	3240
3775	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': ' ', 'comparator': '='}], 'text': "Smart Faucet's water is running", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water is {setting/F|not }running"}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	57	3241
3776	{'seconds': 15, 'hours': 0, 'minutes': 0}	=	58	3241
3778	Asleep	=	68	3243
3779	Open	=	65	3244
3780	On	=	1	3245
3781	Closed	=	67	3246
3782	Open	=	65	3247
3783	40	<	18	3248
3784	Open	=	13	3249
3785	Closed	=	13	3250
3786	Closed	=	13	3251
3787	Open	=	65	3252
3788	Kitchen	=	70	3253
3789	Bobbie	=	71	3253
3790	Kitchen	 	70	3254
3791	Nobody	 	71	3254
3792	Closed	=	67	3255
3793	Home	 	70	3256
3794	Anyone	=	71	3256
3795	73	=	21	3257
3796	Home	=	70	3258
3797	A Guest	=	71	3258
3798	{'parameters': [{'id': 70, 'name': 'location', 'type': 'set', 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room']}, {'id': 71, 'name': 'who', 'type': 'set', 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest', 'Nobody']}], 'parameterVals': [{'value': 'Home', 'comparator': '='}, {'value': 'A Guest', 'comparator': '='}], 'text': 'A Guest Enters Home', 'capability': {'id': 63, 'name': 'Detect Presence', 'label': '{who/=|}{who/!=|Someone other than }{who} {location/=|Enters}{location/!=|Exits} {location}'}, 'channel': {'icon': 'visibility', 'id': 6, 'name': 'Sensors'}, 'device': {'id': 12, 'name': 'Location Sensor'}}	=	57	3259
3799	{'seconds': 0, 'hours': 3, 'minutes': 0}	>	58	3259
3800	80	>	18	3260
3801	Open	=	13	3261
3802	Closed	=	13	3262
3803	Closed	=	13	3263
3804	Kitchen	=	70	3264
3805	Bobbie	=	71	3264
3806	Kitchen	 	70	3265
3807	Nobody	 	71	3265
3808	Open	=	67	3266
3809	Locked	=	12	3267
3810	Asleep	=	68	3268
3811	Unlocked	=	12	3269
3812	Asleep	=	68	3270
3814	Unlocked	=	12	3272
3815	Night	=	62	3273
3816	Locked	=	12	3274
3817	Motion	=	14	3275
3818	On	=	1	3276
3819	Open	=	67	3277
3821	Bedroom	=	70	3279
3822	A Family Member	=	71	3279
3823	Closed	=	13	3280
3824	Closed	=	13	3281
3825	Pop	=	8	3282
3826	pop	 	35	3283
3827	Home	=	70	3284
3828	Anyone	=	71	3284
3829	On	=	1	3285
3830	Asleep	=	68	3286
3831	Open	=	67	3287
3832	Locked	=	12	3288
3833	Bedroom	=	70	3289
3834	Nobody	!=	71	3289
3835	Open	=	67	3290
3836	 	=	25	3291
3837	40	<	18	3292
3838	45	>	18	3293
3840	Kitchen	 	70	3295
3841	Anyone	 	71	3295
3842	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': ' ', 'comparator': '='}], 'text': "Smart Faucet's water is running", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water is {setting/F|not }running"}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	55	3296
3843	{'seconds': 15, 'hours': 0, 'minutes': 0}	>	56	3296
3844	Pop	!=	8	3297
3845	Raining	=	20	3298
3846	Off	=	1	3299
3847	Asleep	=	68	3300
3848	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': 'On', 'comparator': '='}], 'text': "Smart Faucet's water Turns On", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}"}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	57	3301
3849	{'seconds': 15, 'hours': 0, 'minutes': 0}	=	58	3301
3850	{'parameters': [{'id': 67, 'name': 'position', 'type': 'bin', 'values': ['Open', 'Closed']}], 'parameterVals': [{'value': 'Closed', 'comparator': '='}], 'text': "Smart Oven's door Closes", 'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door {position/T|Opens}{position/F|Closes}"}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'device': {'id': 23, 'name': 'Smart Oven'}}	=	57	3302
3851	{'seconds': 1, 'hours': 0, 'minutes': 0}	=	58	3302
3852	Kitchen	 	70	3303
3853	Bobbie	 	71	3303
3854	40	>	75	3304
3855	Off	=	1	3305
3856	Day	=	62	3306
3857	Off	=	1	3307
3858	Asleep	=	68	3308
3859	On	=	1	3309
3860	On	=	1	3310
3861	Open	=	13	3311
3862	Raining	=	20	3312
3863	80	>	18	3313
3866	On	=	72	3315
3867	Asleep	=	68	3316
3868	01:00	>	23	3317
3869	On	=	64	3318
3870	79	>	18	3319
3871	Open	=	13	3320
3872	60	<	18	3321
3873	Open	=	67	3322
3874	Closed	=	13	3323
3875	Closed	=	13	3324
3876	Pop	!=	8	3325
3877	Off	=	64	3326
3878	70	<	18	3327
3879	Closed	=	13	3328
3880	Closed	=	13	3329
3881	Raining	=	20	3330
3882	Open	=	13	3331
3883	Open	=	13	3332
3884	Home	 	70	3333
3885	Anyone	 	71	3333
3886	40	<	18	3334
3887	60	>	18	3335
3888	Open	=	65	3336
3889	Bathroom	!=	70	3337
3890	Anyone	=	71	3337
3891	80	>	18	3338
3892	Open	=	13	3339
3893	{'parameters': [{'id': 12, 'name': 'setting', 'type': 'bin', 'values': ['Locked', 'Unlocked']}], 'parameterVals': [{'value': 'Locked', 'comparator': '='}], 'text': 'Front Door Lock Locks', 'capability': {'id': 13, 'name': 'Lock/Unlock', 'label': '{DEVICE} {setting/T|Locks}{setting/F|Unlocks}'}, 'channel': {'icon': 'meeting_room', 'id': 5, 'name': 'Windows & Doors'}, 'device': {'id': 13, 'name': 'Front Door Lock'}}	=	57	3340
3894	{'seconds': 0, 'hours': 9, 'minutes': 0}	=	58	3340
3895	On	=	1	3341
3896	Home	 	70	3342
3897	A Guest	 	71	3342
3898	{'parameters': [{'id': 70, 'name': 'location', 'type': 'set', 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room']}, {'id': 71, 'name': 'who', 'type': 'set', 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest', 'Nobody']}], 'parameterVals': [{'value': 'Home', 'comparator': '='}, {'value': 'A Guest', 'comparator': ' '}], 'text': 'A Guest is in Home', 'capability': {'id': 63, 'name': 'Detect Presence', 'label': '{who/!=|Someone other than }{who} is {location/!=|not }in {location}'}, 'channel': {'icon': 'room', 'id': 15, 'name': 'Location'}, 'device': {'id': 12, 'name': 'Location Sensor'}}	=	57	3343
3899	{'seconds': 0, 'hours': 3, 'minutes': 0}	<	58	3343
3900	Closed	=	13	3344
3901	Closed	=	13	3345
3902	110	=	69	3346
3903	60	<	18	3347
3904	Open	=	13	3348
3905	02:00	=	23	3349
3906	On	=	1	3350
3907	80	>	18	3351
3908	Off	=	72	3352
3909	On	=	72	3353
3910	On	=	64	3354
3911	Home	 	70	3355
3912	Anyone	 	71	3355
3913	72	=	21	3356
3914	On	=	1	3357
3915	On	=	1	3358
3916	Home	!=	70	3359
3917	A Family Member	!=	71	3359
3918	75	=	21	3360
3919	Home	=	70	3361
3920	Nobody	 	71	3361
3921	Pop	=	8	3362
3922	Open	=	13	3363
3923	Raining	=	20	3364
3924	Unlocked	=	12	3365
3925	Open	=	13	3366
3926	80	>	18	3367
3927	72	=	21	3368
3928	Home	 	70	3369
3929	Anyone	 	71	3369
3930	Open	=	13	3370
3931	60	>	18	3371
3932	80	<	18	3372
3933	Not Raining	=	20	3373
3934	Closed	=	65	3374
3935	Home	 	70	3375
3936	Anyone	 	71	3375
3937	Open	=	13	3376
3938	60	<	18	3377
3939	Locked	=	12	3378
3940	Asleep	=	68	3379
3941	On	=	1	3380
3942	{'parameters': [{'id': 70, 'name': 'location', 'type': 'set', 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room']}, {'id': 71, 'name': 'who', 'type': 'set', 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest', 'Nobody']}], 'parameterVals': [{'value': 'Home', 'comparator': ' '}, {'value': 'Anyone', 'comparator': '='}], 'text': 'Anyone is in Home', 'capability': {'id': 63, 'name': 'Detect Presence', 'label': '{who/!=|Someone other than }{who} is {location/!=|not }in {location}'}, 'channel': {'icon': 'visibility', 'id': 6, 'name': 'Sensors'}, 'device': {'id': 12, 'name': 'Location Sensor'}}	=	55	3381
3943	{'seconds': 1, 'hours': 0, 'minutes': 0}	=	56	3381
3944	On	=	1	3382
3945	Home	=	70	3383
3946	A Guest	=	71	3383
3947	Off	=	72	3384
3948	On	=	72	3385
3949	Open	=	65	3386
3950	On	=	64	3387
3951	Home	!=	70	3388
3952	Anyone	=	71	3388
3953	Asleep	=	68	3389
3954	On	=	1	3390
3955	{'parameters': [{'id': 68, 'name': 'status', 'type': 'bin', 'values': ['Awake', 'Asleep']}], 'parameterVals': [{'value': 'Asleep', 'comparator': '='}], 'text': '(FitBit) I Fall Asleep', 'capability': {'id': 61, 'name': 'Sleep Sensor', 'label': '({DEVICE}) I {status/T|Wake Up}{status/F|Fall Asleep}'}, 'channel': {'icon': 'favorite_border', 'id': 16, 'name': 'Health'}, 'device': {'id': 21, 'name': 'FitBit'}}	=	57	3391
3956	{'seconds': 0, 'hours': 0, 'minutes': 30}	=	58	3391
3957	Open	=	67	3392
3958	Closed	=	65	3393
3959	On	=	1	3394
3960	Open	=	65	3395
3961	Pop	=	8	3396
3962	 	=	72	3397
3963	Open	=	13	3398
3964	80	<	18	3399
3965	60	>	18	3400
3966	{'parameters': [{'id': 67, 'name': 'position', 'type': 'bin', 'values': ['Open', 'Closed']}], 'parameterVals': [{'value': 'Open', 'comparator': '='}], 'text': "Smart Refrigerator's door Opens", 'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door {position/T|Opens}{position/F|Closes}"}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}}	=	57	3401
3967	{'seconds': 0, 'hours': 0, 'minutes': 2}	>	58	3401
3968	Open	=	67	3402
3969	Open	=	65	3403
3970	{'parameters': [{'id': 67, 'name': 'position', 'type': 'bin', 'values': ['Open', 'Closed']}], 'parameterVals': [{'value': 'Open', 'comparator': '='}], 'text': "Smart Refrigerator's door Opens", 'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door {position/T|Opens}{position/F|Closes}"}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}}	=	57	3404
3971	{'seconds': 0, 'hours': 0, 'minutes': 2}	>	58	3404
3972	Open	=	67	3405
3973	On	=	1	3406
3974	Locked	=	12	3407
3975	{'parameters': [{'id': 67, 'name': 'position', 'type': 'bin', 'values': ['Open', 'Closed']}], 'parameterVals': [{'value': 'Open', 'comparator': '='}], 'text': "Smart Refrigerator's door Opens", 'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door {position/T|Opens}{position/F|Closes}"}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}}	=	57	3408
3976	{'seconds': 0, 'hours': 0, 'minutes': 2}	>	58	3408
3977	Open	=	67	3409
3978	Motion	=	14	3410
3979	On	=	1	3411
3980	Living Room	!=	70	3412
3981	A Guest	!=	71	3412
3982	Off	=	1	3413
3983	Asleep	=	68	3414
3984	Unlocked	=	12	3415
3985	Home	 	70	3416
3986	Alice	=	71	3416
3987	Night	=	62	3417
3988	Pop	=	8	3418
3989	40	=	75	3419
3990	Open	=	65	3420
3991	Open	=	13	3421
3992	61	=	18	3422
3993	79	=	18	3423
3994	Not Raining	=	20	3424
3995	Open	=	65	3425
3996	On	=	1	3426
3997	{'parameters': [{'id': 1, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': 'On', 'comparator': '='}], 'text': 'Roomba turns On', 'capability': {'id': 2, 'name': 'Power On/Off', 'label': '{DEVICE} turns {setting}'}, 'channel': {'icon': 'build', 'id': 18, 'name': 'Cleaning'}, 'device': {'id': 1, 'name': 'Roomba'}}	=	52	3427
3998	{'seconds': 0, 'hours': 72, 'minutes': 0}	=	53	3427
3999	1	=	54	3427
4000	Home	=	70	3428
4001	Alice	!=	71	3428
4002	On	=	1	3429
4003	Open	=	65	3430
4004	On	=	1	3431
4005	Open	=	65	3432
4006	On	=	1	3433
4007	Closed	=	65	3434
4008	On	=	1	3435
4009	On	=	1	3436
4010	Home	 	70	3437
4011	A Guest	 	71	3437
4012	{'parameters': [{'id': 1, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': 'On', 'comparator': '='}], 'text': 'Roomba is On', 'capability': {'id': 2, 'name': 'Power On/Off', 'label': '{DEVICE} is {setting}'}, 'channel': {'icon': 'build', 'id': 18, 'name': 'Cleaning'}, 'device': {'id': 1, 'name': 'Roomba'}}	=	57	3438
4013	{'seconds': 1, 'hours': 3, 'minutes': 0}	>	58	3438
4014	Off	=	1	3439
4015	Closed	=	65	3440
4016	Home	=	70	3441
4017	Anyone	=	71	3441
4018	72	=	18	3442
4019	Off	=	1	3443
4020	Night	=	62	3444
4021	80	=	18	3445
4022	80	<	21	3446
4023	Off	=	64	3447
4024	Off	=	1	3448
4025	Closed	=	65	3449
4026	80	>	21	3450
4027	Open	=	13	3451
4028	60	>	18	3452
4029	80	!=	18	3453
4030	Off	=	1	3454
4031	Living Room	 	70	3455
4032	A Family Member	!=	71	3455
4033	Off	=	1	3456
4034	Closed	=	65	3457
4035	On	=	1	3458
4036	Asleep	=	68	3459
4037	Asleep	=	68	3460
4038	Unlocked	=	12	3461
4039	80	=	18	3462
4040	80	=	18	3463
4041	81	<	21	3464
4042	Off	=	64	3465
4043	Open	=	13	3466
4044	Raining	=	20	3467
4045	Locked	=	12	3468
4046	Night	=	62	3469
4047	Home	=	70	3470
4048	Anyone	=	71	3470
4049	On	=	1	3471
4050	Open	=	65	3472
4051	80	>	18	3473
4052	80	>	21	3474
4053	Off	=	64	3475
4054	On	=	1	3476
4055	Open	=	65	3477
4056	Closed	=	13	3478
4057	80	>	18	3479
4058	Pop	=	8	3480
4059	On	=	1	3481
4060	Open	=	65	3482
4061	Closed	=	13	3483
4062	60	<	18	3484
4063	Pop	!=	8	3485
4064	Pop	 	8	3486
4065	23:00	>	23	3487
4066	Locked	=	12	3488
4067	Off	=	1	3489
4068	Asleep	=	68	3490
4069	Closed	=	13	3491
4070	Closed	=	13	3492
4071	Closed	=	13	3493
4072	41	<	18	3494
4073	Off	=	1	3495
4074	Asleep	=	68	3496
4075	Closed	=	13	3497
4076	Closed	=	13	3498
4077	Closed	=	13	3499
4078	 	=	72	3500
4079	Off	=	72	3501
4080	On	=	72	3502
4081	Closed	=	13	3503
4082	Closed	=	13	3504
4083	Closed	=	13	3505
4084	Off	=	72	3506
4085	On	=	72	3507
4086	{'parameters': [{'id': 68, 'name': 'status', 'type': 'bin', 'values': ['Awake', 'Asleep']}], 'parameterVals': [{'value': 'Asleep', 'comparator': '='}], 'text': '(FitBit) I Fall Asleep', 'capability': {'id': 61, 'name': 'Sleep Sensor', 'label': '({DEVICE}) I {status/T|Wake Up}{status/F|Fall Asleep}'}, 'channel': {'icon': 'visibility', 'id': 6, 'name': 'Sensors'}, 'device': {'id': 21, 'name': 'FitBit'}}	=	57	3508
4087	{'seconds': 0, 'hours': 0, 'minutes': 30}	>	58	3508
4088	On	=	1	3509
4089	Closed	=	13	3510
4090	Closed	=	13	3511
4091	Closed	=	13	3512
4092	Open	=	13	3513
4093	79	>	18	3514
4094	60	<	18	3515
4095	Not Raining	=	20	3516
4096	80	>	21	3517
4097	Open	=	65	3518
4098	{'parameters': [{'id': 68, 'name': 'status', 'type': 'bin', 'values': ['Awake', 'Asleep']}], 'parameterVals': [{'value': 'Asleep', 'comparator': '='}], 'text': '(FitBit) I Fall Asleep', 'capability': {'id': 61, 'name': 'Sleep Sensor', 'label': '({DEVICE}) I {status/T|Wake Up}{status/F|Fall Asleep}'}, 'channel': {'icon': 'visibility', 'id': 6, 'name': 'Sensors'}, 'device': {'id': 21, 'name': 'FitBit'}}	=	57	3519
4099	{'seconds': 0, 'hours': 0, 'minutes': 30}	>	58	3519
4100	On	=	1	3520
4101	Asleep	=	68	3521
4102	On	=	1	3522
4103	Open	=	65	3523
4104	Closed	=	67	3524
4105	Open	=	67	3525
4106	On	=	1	3526
4107	Open	=	65	3527
4108	On	=	1	3528
4109	Open	=	65	3529
4110	On	=	1	3530
4111	Home	 	70	3531
4112	Alice	!=	71	3531
4113	Home	 	70	3532
4114	Bobbie	!=	71	3532
4115	{'parameters': [{'id': 67, 'name': 'position', 'type': 'bin', 'values': ['Open', 'Closed']}], 'parameterVals': [{'value': 'Open', 'comparator': '='}], 'text': "Smart Refrigerator's door is Open", 'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door is {position}"}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}}	=	55	3533
4116	{'seconds': 0, 'hours': 0, 'minutes': 2}	=	56	3533
4117	Kitchen	!=	70	3534
4118	Anyone	=	71	3534
4119	Open	=	13	3535
4120	80	<	18	3536
4121	60	>	18	3537
4122	Not Raining	=	20	3538
4123	Night	=	62	3539
4124	{'parameters': [{'id': 1, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': 'On', 'comparator': '='}], 'text': 'Roomba is On', 'capability': {'id': 2, 'name': 'Power On/Off', 'label': '{DEVICE} is {setting}'}, 'channel': {'icon': 'build', 'id': 18, 'name': 'Cleaning'}, 'device': {'id': 1, 'name': 'Roomba'}}	=	55	3540
4125	{'seconds': 0, 'hours': 1, 'minutes': 0}	=	56	3540
4126	Home	=	70	3541
4127	Anyone	 	71	3541
4128	70	>	21	3542
4129	75	<	21	3543
4130	Locked	=	12	3544
4131	On	=	1	3545
4135	16:00	=	23	3547
4136	{'parameters': [{'id': 1, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': 'Off', 'comparator': '='}], 'text': 'Roomba is Off', 'capability': {'id': 2, 'name': 'Power On/Off', 'label': '{DEVICE} is {setting}'}, 'channel': {'icon': 'build', 'id': 18, 'name': 'Cleaning'}, 'device': {'id': 1, 'name': 'Roomba'}}	=	55	3548
4137	{'seconds': 0, 'hours': 48, 'minutes': 0}	=	56	3548
4138	Open	=	65	3549
4139	Open	=	65	3550
4140	Open	=	65	3551
4141	Open	=	65	3552
4142	On	=	1	3553
4143	Open	=	65	3554
4144	On	=	1	3555
4145	76	=	18	3556
4146	40	>	18	3557
4147	Unlocked	=	12	3558
4148	Kitchen	=	70	3559
4149	Bobbie	=	71	3559
4150	75	>	18	3560
4151	75	>	18	3561
4152	80	>	18	3562
4153	80	=	18	3563
4154	Pop	=	8	3564
4155	Open	=	67	3565
4156	{'parameters': [{'id': 18, 'name': 'temperature', 'type': 'range', 'values': [-50, 120, 1]}], 'parameterVals': [{'value': 75, 'comparator': '!='}], 'text': '(Weather Sensor) The temperature is not 75 degrees', 'capability': {'id': 19, 'name': 'Current Temperature', 'label': '({DEVICE}) The temperature {temperature/=|is}{temperature/!=|is not}{temperature/>|is above}{temperature/<|is below} {temperature} degrees'}, 'channel': {'icon': 'ac_unit', 'id': 8, 'name': 'Temperature'}, 'device': {'id': 18, 'name': 'Weather Sensor'}}	=	55	3566
4157	{'seconds': 3, 'hours': 0, 'minutes': 0}	=	56	3566
4158	Open	=	13	3567
4159	70	=	21	3568
4160	Raining	=	20	3569
4161	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': ' ', 'comparator': '='}], 'text': "Smart Faucet's water is running", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water is {setting/F|not }running"}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	55	3570
4162	{'seconds': 15, 'hours': 0, 'minutes': 0}	=	56	3570
4165	 	=	72	3572
4166	Home	!=	70	3573
4167	Alice	=	71	3573
4168	Home	 	70	3574
4169	Nobody	 	71	3574
4170	 	=	72	3575
4171	Home	!=	70	3576
4172	Bobbie	=	71	3576
4173	Home	=	70	3577
4174	Nobody	=	71	3577
4176	 	=	72	3579
4177	Locked	=	12	3580
4178	Kitchen	=	70	3581
4179	Bobbie	=	71	3581
4180	70	>	21	3582
4181	Home	=	70	3583
4182	Anyone	 	71	3583
4183	75	<	21	3584
4184	Home	=	70	3585
4185	Anyone	 	71	3585
4186	Closed	=	13	3586
4187	Closed	=	13	3587
4188	Closed	=	65	3588
4189	Closed	=	13	3589
4190	Closed	=	13	3590
4191	Closed	=	13	3591
4192	08:00	=	23	3592
4193	Closed	=	13	3593
4194	Closed	=	13	3594
4195	Closed	=	13	3595
4196	Closed	=	13	3596
4197	Closed	=	13	3597
4198	Closed	=	13	3598
4199	On	=	1	3599
4200	Off	=	1	3600
4201	Home	=	70	3601
4202	A Family Member	=	71	3601
4203	Night	=	62	3602
4204	80	>	21	3603
4205	Closed	=	13	3604
4206	Closed	=	13	3605
4207	Closed	=	13	3606
4208	Pop music	=	35	3607
4209	08:00	=	23	3608
4210	Night	=	62	3609
4211	Bedroom	=	70	3610
4212	Anyone	=	71	3610
4213	Off	=	1	3611
4214	No Motion	=	14	3612
4215	{'parameters': [{'id': 14, 'name': 'status', 'type': 'bin', 'values': ['Motion', 'No Motion']}], 'parameterVals': [{'value': 'No Motion', 'comparator': '='}], 'text': 'Security Camera Stops Detecting Motion', 'capability': {'id': 15, 'name': 'Detect Motion', 'label': '{DEVICE} {status/T|Starts}{status/F|Stops} Detecting Motion'}, 'channel': {'icon': 'visibility', 'id': 6, 'name': 'Sensors'}, 'device': {'id': 10, 'name': 'Security Camera'}}	=	57	3613
4216	{'seconds': 0, 'hours': 0, 'minutes': 30}	>	58	3613
4217	On	=	1	3614
4218	Asleep	=	68	3615
4219	41	<	18	3616
4220	 	=	72	3617
4221	46	=	18	3618
4222	On	=	72	3619
4223	45	>	18	3620
4224	On	=	72	3621
4225	Unlocked	=	12	3622
4226	Asleep	=	68	3623
4227	On	=	72	3624
4228	Pop	=	8	3625
4229	Open	=	13	3626
4230	Pop	 	8	3627
4231	{'parameters': [{'id': 70, 'name': 'location', 'type': 'set', 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room']}, {'id': 71, 'name': 'who', 'type': 'set', 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest', 'Nobody']}], 'parameterVals': [{'value': 'Home', 'comparator': '='}, {'value': 'A Family Member', 'comparator': '!='}], 'text': 'Someone other than A Family Member Enters Home', 'capability': {'id': 63, 'name': 'Detect Presence', 'label': '{who/=|}{who/!=|Someone other than }{who} {location/=|Enters}{location/!=|Exits} {location}'}, 'channel': {'icon': 'room', 'id': 15, 'name': 'Location'}, 'device': {'id': 12, 'name': 'Location Sensor'}}	=	57	3628
4232	{'seconds': 0, 'hours': 3, 'minutes': 0}	=	58	3628
4414	{'parameters': [{'id': 1, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': 'Off', 'comparator': '='}], 'text': 'Roomba turns Off', 'capability': {'id': 2, 'name': 'Power On/Off', 'label': '{DEVICE} turns {setting}'}, 'channel': {'icon': 'build', 'id': 18, 'name': 'Cleaning'}, 'device': {'id': 1, 'name': 'Roomba'}}	=	57	3781
4233	{'parameters': [{'id': 70, 'name': 'location', 'type': 'set', 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room']}, {'id': 71, 'name': 'who', 'type': 'set', 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest', 'Nobody']}], 'parameterVals': [{'value': 'Home', 'comparator': '='}, {'value': 'A Family Member', 'comparator': '!='}], 'text': 'Someone other than A Family Member Enters Home', 'capability': {'id': 63, 'name': 'Detect Presence', 'label': '{who/=|}{who/!=|Someone other than }{who} {location/=|Enters}{location/!=|Exits} {location}'}, 'channel': {'icon': 'room', 'id': 15, 'name': 'Location'}, 'device': {'id': 12, 'name': 'Location Sensor'}}	=	57	3629
4234	{'seconds': 0, 'hours': 3, 'minutes': 0}	=	58	3629
4238	73	=	18	3633
4239	Home	 	70	3634
4240	Anyone	 	71	3634
4241	70	<	18	3635
4242	Home	=	70	3636
4243	Anyone	=	71	3636
4244	39	=	18	3637
4245	75	>	18	3638
4246	Home	=	70	3639
4247	Anyone	=	71	3639
4249	Closed	=	13	3641
4250	Closed	=	13	3642
4251	Asleep	=	68	3643
4252	On	=	1	3644
4253	80	=	18	3645
4254	70	<	18	3646
4255	Home	 	70	3647
4256	Nobody	 	71	3647
4257	On	=	64	3648
4258	80	>	18	3649
4259	Pop	=	8	3650
4260	60	<	18	3651
4261	80	>	18	3652
4262	Raining	=	20	3653
4263	81	=	18	3654
4264	40	=	75	3655
4265	Not Raining	=	20	3656
4266	81	=	18	3657
4267	80	=	18	3658
4268	Open	=	65	3659
4269	On	=	1	3660
4270	80	=	18	3661
4271	Kitchen	=	70	3662
4272	Bobbie	=	71	3662
4273	On	=	1	3663
4274	Closed	=	67	3664
4275	Kitchen	 	70	3665
4276	Bobbie	 	71	3665
4277	Open	=	65	3666
4278	On	=	1	3667
4279	40	<	18	3668
4280	Locked	=	12	3669
4281	Kitchen	 	70	3670
4282	Bobbie	 	71	3670
4283	Open	=	65	3671
4284	On	=	1	3672
4285	Pop	=	8	3673
4286	Pop	=	8	3674
4287	Asleep	=	68	3675
4288	On	=	1	3676
4289	{'parameters': [{'id': 68, 'name': 'status', 'type': 'bin', 'values': ['Awake', 'Asleep']}], 'parameterVals': [{'value': 'Asleep', 'comparator': '='}], 'text': '(FitBit) I Fall Asleep', 'capability': {'id': 61, 'name': 'Sleep Sensor', 'label': '({DEVICE}) I {status/T|Wake Up}{status/F|Fall Asleep}'}, 'channel': {'icon': 'visibility', 'id': 6, 'name': 'Sensors'}, 'device': {'id': 21, 'name': 'FitBit'}}	=	57	3677
4290	{'seconds': 0, 'hours': 0, 'minutes': 31}	=	58	3677
4291	Closed	=	67	3678
4292	Open	=	67	3679
4293	Clear	=	17	3680
4294	Not Raining	=	20	3681
4295	60	<	18	3682
4296	Closed	=	65	3683
4297	Day	=	62	3684
4298	80	=	18	3685
4299	80	>	18	3686
4300	On	=	1	3687
4301	Open	=	65	3688
4302	On	=	1	3689
4303	Open	=	65	3690
4304	Off	=	1	3691
4305	Home	 	70	3692
4306	A Guest	 	71	3692
4307	On	=	1	3693
4308	Open	=	65	3694
4309	Open	=	65	3695
4310	Open	=	65	3696
4311	Open	=	65	3697
4312	Raining	=	17	3698
4313	80	>	18	3699
4314	Unlocked	=	12	3700
4315	Asleep	=	68	3701
4316	 	=	72	3702
4317	Kitchen	=	70	3703
4318	Bobbie	=	71	3703
4319	On	=	1	3704
4321	On	=	1	3706
4322	Home	=	70	3707
4323	A Guest	 	71	3707
4324	{'parameters': [{'id': 70, 'name': 'location', 'type': 'set', 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room']}, {'id': 71, 'name': 'who', 'type': 'set', 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest', 'Nobody']}], 'parameterVals': [{'value': 'Home', 'comparator': '='}, {'value': 'A Guest', 'comparator': '='}], 'text': 'A Guest Enters Home', 'capability': {'id': 63, 'name': 'Detect Presence', 'label': '{who/=|}{who/!=|Someone other than }{who} {location/=|Enters}{location/!=|Exits} {location}'}, 'channel': {'icon': 'visibility', 'id': 6, 'name': 'Sensors'}, 'device': {'id': 12, 'name': 'Location Sensor'}}	=	57	3708
4325	{'seconds': 0, 'hours': 3, 'minutes': 0}	<	58	3708
4326	Closed	=	67	3709
4327	Open	=	67	3710
4328	Closed	=	13	3711
4329	Closed	=	13	3712
4330	Closed	=	13	3713
4331	Closed	=	13	3714
4332	40	<	18	3715
4333	Closed	=	13	3716
4334	Closed	=	13	3717
4335	Kitchen	=	70	3718
4336	Bobbie	=	71	3718
4337	On	=	1	3719
4338	Unlocked	=	12	3720
4339	Asleep	=	68	3721
4340	Unlocked	=	12	3722
4341	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': 'On', 'comparator': '='}], 'text': "Smart Faucet's water Turns On", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}"}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	57	3723
4342	{'seconds': 15, 'hours': 0, 'minutes': 0}	=	58	3723
4343	Unlocked	=	12	3724
4344	Open	=	67	3725
4345	On	=	1	3726
4346	Asleep	=	68	3727
4415	{'seconds': 0, 'hours': 3, 'minutes': 0}	=	58	3781
4421	On	=	1	3787
4422	00:00	>	23	3788
4347	{'parameters': [{'id': 67, 'name': 'position', 'type': 'bin', 'values': ['Open', 'Closed']}], 'parameterVals': [{'value': 'Open', 'comparator': '='}], 'text': "Smart Refrigerator's door Opens", 'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door {position/T|Opens}{position/F|Closes}"}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}}	=	57	3728
4348	{'seconds': 0, 'hours': 0, 'minutes': 2}	>	58	3728
4349	Open	=	67	3729
4350	{'parameters': [{'id': 67, 'name': 'position', 'type': 'bin', 'values': ['Open', 'Closed']}], 'parameterVals': [{'value': 'Open', 'comparator': '='}], 'text': "Smart Refrigerator's door is Open", 'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door is {position}"}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}}	=	55	3730
4351	{'seconds': 0, 'hours': 0, 'minutes': 2}	>	56	3730
4352	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': 'On', 'comparator': '='}], 'text': "Smart Faucet's water Turns On", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}"}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	57	3731
4353	{'seconds': 15, 'hours': 0, 'minutes': 0}	=	58	3731
4354	Home	=	70	3732
4355	Bobbie	!=	71	3732
4356	On	=	1	3733
4357	{'parameters': [{'id': 67, 'name': 'position', 'type': 'bin', 'values': ['Open', 'Closed']}], 'parameterVals': [{'value': 'Closed', 'comparator': '='}], 'text': "Smart Refrigerator's door is Closed", 'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door is {position}"}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}}	=	55	3734
4358	{'seconds': 0, 'hours': 0, 'minutes': 2}	=	56	3734
4359	Asleep	=	68	3735
4360	On	=	1	3736
4361	{'parameters': [{'id': 67, 'name': 'position', 'type': 'bin', 'values': ['Open', 'Closed']}], 'parameterVals': [{'value': 'Open', 'comparator': '='}], 'text': "Smart Refrigerator's door is Open", 'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door is {position}"}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}}	=	55	3737
4362	{'seconds': 0, 'hours': 0, 'minutes': 2}	>	56	3737
4363	Open	=	67	3738
4364	{'parameters': [{'id': 67, 'name': 'position', 'type': 'bin', 'values': ['Open', 'Closed']}], 'parameterVals': [{'value': 'Closed', 'comparator': '='}], 'text': "Smart Refrigerator's door is Closed", 'capability': {'id': 60, 'name': 'Open/Close Door', 'label': "{DEVICE}'s door is {position}"}, 'channel': {'icon': 'fastfood', 'id': 13, 'name': 'Food & Cooking'}, 'device': {'id': 8, 'name': 'Smart Refrigerator'}}	=	55	3739
4365	{'seconds': 0, 'hours': 0, 'minutes': 2}	>	56	3739
4366	On	=	1	3740
4367	On	=	1	3741
4368	On	=	1	3742
4369	Night	=	62	3743
4370	Home	=	70	3744
4371	A Family Member	!=	71	3744
4372	Locked	=	12	3745
4373	{'parameters': [{'id': 14, 'name': 'status', 'type': 'bin', 'values': ['Motion', 'No Motion']}], 'parameterVals': [{'value': 'No Motion', 'comparator': '='}], 'text': 'Security Camera Stops Detecting Motion', 'capability': {'id': 15, 'name': 'Detect Motion', 'label': '{DEVICE} {status/T|Starts}{status/F|Stops} Detecting Motion'}, 'channel': {'icon': 'visibility', 'id': 6, 'name': 'Sensors'}, 'device': {'id': 10, 'name': 'Security Camera'}}	=	57	3746
4374	{'seconds': 0, 'hours': 0, 'minutes': 30}	=	58	3746
4375	{'parameters': [{'id': 13, 'name': 'position', 'type': 'bin', 'values': ['Open', 'Closed']}], 'parameterVals': [{'value': 'Closed', 'comparator': '='}], 'text': 'Bathroom Window is Closed', 'capability': {'id': 14, 'name': 'Open/Close Window', 'label': '{DEVICE} is {position}'}, 'channel': {'icon': 'meeting_room', 'id': 5, 'name': 'Windows & Doors'}, 'device': {'id': 24, 'name': 'Bathroom Window'}}	=	50	3747
4376	{'seconds': 0, 'hours': 0, 'minutes': 0}	=	51	3747
4377	Closed	=	13	3748
4378	Closed	=	13	3749
4379	4	>	2	3750
4380	22	=	18	3751
4381	Open	=	65	3752
4382	Open	=	13	3753
4383	80	>	18	3754
4384	60	<	18	3755
4385	Raining	=	20	3756
4386	Open	=	13	3757
4387	80	>	18	3758
4388	60	<	18	3759
4389	Raining	=	20	3760
4390	Open	=	65	3761
4391	On	=	1	3762
4393	On	=	1	3764
4394	40	<	18	3765
4395	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': ' ', 'comparator': '='}], 'text': "Smart Faucet's water is running", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water is {setting/F|not }running"}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	50	3766
4396	{'seconds': 15, 'hours': 0, 'minutes': 0}	=	51	3766
4397	On	=	72	3767
4398	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': ' ', 'comparator': '='}], 'text': "Smart Faucet's water is running", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water is {setting/F|not }running"}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	50	3768
4399	{'seconds': 15, 'hours': 0, 'minutes': 0}	=	51	3768
4400	Off	=	72	3769
4401	On	=	1	3770
4402	Off	=	72	3771
4403	Kitchen	=	70	3772
4404	A Family Member	!=	71	3772
4405	Pop	=	8	3773
4406	Pop	=	8	3774
4407	Kitchen	 	70	3775
4408	Bobbie	 	71	3775
4409	Open	=	67	3776
4410	88	=	18	3777
4411	83	=	18	3778
4412	Closed	=	13	3779
4413	Clear	 	17	3780
4416	Raining	=	20	3782
4417	758	!=	36	3783
4418	Jazz	=	8	3784
4419	animal planet	!=	37	3785
4420	21:00	=	23	3786
4423	Open	=	65	3789
4424	Partly Cloudy	=	17	3790
4425	Raining	=	20	3791
4426	Snowing	=	17	3792
4427	pop music	=	35	3793
4428	Raining	=	17	3794
4429	75	=	21	3795
4430	Sunny	=	17	3796
4431	69	=	21	3797
4432	Bathroom	=	70	3798
4433	Anyone	=	71	3798
4434	Pop	=	8	3799
4435	Pop	=	8	3800
4436	Closed	=	13	3801
4437	Day	=	62	3802
4438	Pop	=	8	3803
4439	Pop	=	8	3804
4440	On	=	1	3805
4441	Home	!=	70	3806
4442	Nobody	 	71	3806
4443	Closed	=	65	3807
4444	Closed	=	65	3808
4445	Closed	=	65	3809
4446	On	=	72	3810
4447	On	=	1	3811
4448	Closed	=	67	3812
4449	Home	!=	70	3813
4450	Bobbie	!=	71	3813
4451	80	>	18	3814
4452	Bedroom	=	70	3815
4453	Anyone	=	71	3815
4454	{'parameters': [{'id': 68, 'name': 'status', 'type': 'bin', 'values': ['Awake', 'Asleep']}], 'parameterVals': [{'value': 'Asleep', 'comparator': '='}], 'text': '(FitBit) I am Asleep', 'capability': {'id': 61, 'name': 'Sleep Sensor', 'label': '({DEVICE}) I am {status}'}, 'channel': {'icon': 'favorite_border', 'id': 16, 'name': 'Health'}, 'device': {'id': 21, 'name': 'FitBit'}}	=	50	3816
4455	{'seconds': 0, 'hours': 0, 'minutes': 30}	=	51	3816
4456	Asleep	=	68	3817
4457	Unlocked	=	12	3818
4458	Home	=	70	3819
4459	Anyone	=	71	3819
4460	Closed	=	13	3820
4461	Closed	=	13	3821
4462	Closed	=	13	3822
4463	Off	=	72	3823
4464	On	=	72	3824
4465	Locked	=	12	3825
4466	200	>	74	3826
4467	Bedroom	=	70	3827
4468	Anyone	=	71	3827
4469	Not Raining	=	20	3828
4470	80	<	18	3829
4471	60	>	18	3830
4472	Bedroom	=	70	3831
4473	Anyone	=	71	3831
4474	Not Raining	=	20	3832
4475	80	<	18	3833
4476	60	>	18	3834
4477	On	=	1	3835
4478	Open	=	65	3836
4479	80	>	18	3837
4480	On	=	1	3838
4481	Open	=	65	3839
4482	On	=	1	3840
4483	Open	=	65	3841
4484	Open	=	13	3842
4485	Open	=	13	3843
4486	Pop	=	8	3844
4487	{'parameters': [{'id': 72, 'name': 'setting', 'type': 'bin', 'values': ['On', 'Off']}], 'parameterVals': [{'value': 'On', 'comparator': '='}], 'text': "Smart Faucet's water Turns On", 'capability': {'id': 64, 'name': 'Water On/Off', 'label': "{DEVICE}'s water {setting/T|Turns On}{setting/F|Turns Off}"}, 'channel': {'icon': 'local_drink', 'id': 17, 'name': 'Water & Plumbing'}, 'device': {'id': 22, 'name': 'Smart Faucet'}}	=	57	3845
4488	{'seconds': 15, 'hours': 0, 'minutes': 0}	>	58	3845
4490	Pop	=	8	3847
4491	On	=	1	3848
4492	18:00	>	23	3849
4493	Kitchen	=	70	3850
4494	Bobbie	=	71	3850
4495	Open	=	13	3851
4496	80	<	18	3852
4497	60	>	18	3853
4498	Not Raining	=	20	3854
4503	Home	!=	70	3857
4504	Anyone	=	71	3857
4505	75	>	18	3858
4506	Home	=	70	3859
4507	Anyone	=	71	3859
4508	70	<	18	3860
4509	Home	=	70	3861
4510	Anyone	=	71	3861
4511	73	<	18	3862
4512	73	<	18	3863
4513	Home	=	70	3864
4514	Anyone	=	71	3864
4515	On	=	64	3865
4516	Home	=	70	3866
4517	Nobody	=	71	3866
4518	66	>	21	3867
4519	Home	=	70	3868
4520	Nobody	=	71	3868
4521	62	>	18	3869
4522	Home	=	70	3870
4523	Nobody	=	71	3870
4524	{'parameters': [{'id': 68, 'name': 'status', 'type': 'bin', 'values': ['Awake', 'Asleep']}], 'parameterVals': [{'value': 'Asleep', 'comparator': '='}], 'text': '(FitBit) I Fall Asleep', 'capability': {'id': 61, 'name': 'Sleep Sensor', 'label': '({DEVICE}) I {status/T|Wake Up}{status/F|Fall Asleep}'}, 'channel': {'icon': 'favorite_border', 'id': 16, 'name': 'Health'}, 'device': {'id': 21, 'name': 'FitBit'}}	=	57	3871
4525	{'seconds': 0, 'hours': 0, 'minutes': 30}	>	58	3871
4526	On	=	1	3872
4527	{'parameters': [{'id': 70, 'name': 'location', 'type': 'set', 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room']}, {'id': 71, 'name': 'who', 'type': 'set', 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest', 'Nobody']}], 'parameterVals': [{'value': 'Home', 'comparator': '='}, {'value': 'A Family Member', 'comparator': '!='}], 'text': 'Someone other than A Family Member Enters Home', 'capability': {'id': 63, 'name': 'Detect Presence', 'label': '{who/=|}{who/!=|Someone other than }{who} {location/=|Enters}{location/!=|Exits} {location}'}, 'channel': {'icon': 'room', 'id': 15, 'name': 'Location'}, 'device': {'id': 12, 'name': 'Location Sensor'}}	=	57	3873
4528	{'seconds': 0, 'hours': 3, 'minutes': 0}	<	58	3873
4529	{'parameters': [{'id': 70, 'name': 'location', 'type': 'set', 'values': ['Home', 'Kitchen', 'Bedroom', 'Bathroom', 'Living Room']}, {'id': 71, 'name': 'who', 'type': 'set', 'values': ['Anyone', 'Alice', 'Bobbie', 'A Family Member', 'A Guest', 'Nobody']}], 'parameterVals': [{'value': 'Home', 'comparator': '='}, {'value': 'A Family Member', 'comparator': '!='}], 'text': 'Someone other than A Family Member Enters Home', 'capability': {'id': 63, 'name': 'Detect Presence', 'label': '{who/=|}{who/!=|Someone other than }{who} {location/=|Enters}{location/!=|Exits} {location}'}, 'channel': {'icon': 'room', 'id': 15, 'name': 'Location'}, 'device': {'id': 12, 'name': 'Location Sensor'}}	=	57	3874
4530	{'seconds': 0, 'hours': 3, 'minutes': 0}	>	58	3874
4531	Kitchen	=	70	3875
4532	Bobbie	=	71	3875
4533	On	=	1	3876
4534	Open	=	65	3877
4535	Off	=	1	3878
4536	Motion	=	14	3879
4537	80	>	18	3880
4538	On	=	1	3881
4539	Asleep	=	68	3882
4540	Closed	=	13	3883
4541	Closed	=	13	3884
4542	Closed	=	13	3885
4543	Closed	=	13	3886
4544	Closed	=	13	3887
4545	Closed	=	13	3888
4546	Closed	=	13	3889
4547	Closed	=	13	3890
4548	Closed	=	13	3891
4549	Unlocked	=	12	3892
4550	Locked	=	12	3893
4551	Asleep	=	68	3894
4552	Asleep	=	68	3895
4553	Unlocked	=	12	3896
4554	Asleep	=	68	3897
4555	Open	=	13	3898
4556	60	>	18	3899
4557	80	<	18	3900
4558	Not Raining	=	20	3901
4559	Asleep	=	68	3902
4560	Unlocked	=	12	3903
4561	73	=	21	3904
4562	Home	=	70	3905
4563	Anyone	=	71	3905
4564	Closed	=	65	3906
4565	On	=	1	3907
4566	40	<	75	3908
4567	40	<	75	3909
4568	Open	=	65	3910
4569	On	=	1	3911
4570	Home	=	70	3912
4571	A Family Member	 	71	3912
4572	Home	 	70	3913
4573	A Guest	 	71	3913
4574	Pop	=	8	3914
4575	Open	=	67	3915
4576	Open	=	67	3916
4577	Closed	=	67	3917
4578	80	=	18	3918
4579	On	=	1	3919
4580	On	=	1	3920
4581	Locked	=	12	3921
4582	Off	=	72	3922
4583	{'device': {'id': 9, 'name': 'Coffee Pot'}, 'text': '(Coffee Pot) There are exactly 1 cups of coffee brewed', 'parameterVals': [{'comparator': '=', 'value': 1}], 'channel': {'id': 13, 'icon': 'fastfood', 'name': 'Food & Cooking'}, 'parameters': [{'id': 73, 'name': 'cups', 'values': [0, 5, 1], 'type': 'range'}], 'capability': {'id': 38, 'label': '({DEVICE}) There are {cups/=|exactly}{cups/!=|not exactly}{cups/>|more than}{cups/<|fewer than} {cups} cups of coffee brewed', 'name': 'How Much Coffee Is There?'}}	=	52	3923
4584	{'hours': 1, 'seconds': 0, 'minutes': 0}	=	53	3923
4585	6	=	54	3923
4586	On	=	1	3924
4587	Raining	=	20	3925
\.


--
-- Name: backend_condition_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.backend_condition_id_seq', 4589, true);


--
-- Data for Name: backend_device; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.backend_device (id, name, owner_id, public, icon) FROM stdin;
7	Speakers	1	t	speaker
5	Smart TV	1	t	tv
21	FitBit	1	t	watch
9	Coffee Pot	1	t	local_cafe
12	Location Sensor	1	t	pin_drop
10	Security Camera	1	t	videocam
11	Device Tracker	1	t	history
6	Smart Plug	1	t	power
1	Roomba	1	t	room_service
8	Smart Refrigerator	1	t	kitchen
18	Weather Sensor	1	t	wb_cloudy
19	Smoke Detector	1	t	disc_full
3	Amazon Echo	1	t	assistant
17	Clock	1	t	access_alarm
22	Smart Faucet	1	t	waves
2	Thermostat	1	t	brightness_medium
4	HUE Lights	1	t	highlight
23	Smart Oven	1	t	\N
24	Bathroom Window	1	t	\N
25	Living Room Window	1	t	\N
14	Bedroom Window	1	t	crop_original
13	Front Door Lock	1	t	lock
20	Power Main	1	f	power
\.


--
-- Name: backend_device_capabilities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.backend_device_capabilities_id_seq', 88, true);


--
-- Data for Name: backend_device_caps; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.backend_device_caps (id, device_id, capability_id) FROM stdin;
7	1	2
8	2	19
9	2	21
10	3	32
11	3	33
13	3	35
14	3	8
15	3	9
16	3	12
23	3	30
24	3	31
26	4	2
27	4	3
28	4	6
29	5	8
30	5	2
31	5	36
32	5	37
33	6	2
34	7	8
35	7	9
36	7	2
37	7	35
38	7	12
39	8	33
41	9	2
42	9	38
43	9	39
44	10	28
45	10	29
46	10	15
47	10	40
52	11	49
53	11	50
54	11	51
55	11	52
57	13	13
58	14	13
59	14	14
60	17	25
61	17	26
62	17	27
63	17	55
64	3	56
65	7	56
66	10	2
67	18	18
68	18	19
69	18	20
70	2	57
71	14	58
72	19	59
73	20	2
74	8	60
75	21	61
76	21	62
77	12	63
78	22	64
79	23	2
80	23	60
81	23	65
82	8	19
83	8	66
84	24	58
85	24	14
86	25	58
87	25	14
88	23	13
\.


--
-- Data for Name: backend_device_chans; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.backend_device_chans (id, device_id, channel_id) FROM stdin;
1	1	1
2	2	8
3	3	1
4	3	3
5	3	6
6	3	7
7	3	8
8	3	9
9	3	11
10	3	13
11	4	1
12	4	2
13	5	1
14	5	12
15	6	1
16	7	1
17	7	3
18	8	13
19	8	11
20	9	13
21	10	4
22	10	1
23	10	10
24	10	6
25	12	6
26	13	4
27	14	4
28	14	5
29	11	14
30	17	9
31	9	1
32	12	15
33	18	8
34	18	6
35	18	7
36	19	6
37	20	1
38	21	16
39	21	6
40	22	17
41	22	13
42	23	13
43	1	18
44	24	5
45	25	5
46	13	5
\.


--
-- Name: backend_device_chans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.backend_device_chans_id_seq', 46, true);


--
-- Name: backend_device_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.backend_device_id_seq', 25, true);


--
-- Data for Name: backend_durationparam; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.backend_durationparam (parameter_ptr_id, maxhours, maxmins, maxsecs, comp) FROM stdin;
51	23	59	59	f
53	23	59	59	f
56	23	59	59	t
58	23	59	59	t
\.


--
-- Data for Name: backend_esrule; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.backend_esrule (action_id, "Etrigger_id", rule_ptr_id) FROM stdin;
44	219	35
46	223	37
47	226	38
48	229	39
49	232	40
50	234	41
51	236	42
52	237	43
53	238	44
54	239	45
55	240	46
56	244	47
57	248	48
58	252	49
59	258	50
63	282	54
64	284	55
65	285	56
66	286	57
67	287	58
69	289	59
70	290	60
71	293	61
72	297	62
73	298	63
74	300	64
75	302	65
76	304	66
77	355	67
78	368	68
79	369	69
80	370	70
81	378	71
82	379	72
83	380	73
85	382	75
86	383	74
87	385	76
88	426	77
89	463	78
90	476	79
91	479	80
92	481	81
93	484	82
94	486	83
95	490	84
96	492	85
97	494	86
100	502	87
101	504	88
102	516	89
103	517	90
104	526	91
105	531	92
106	544	93
107	548	94
109	569	96
110	571	97
111	577	98
112	578	99
113	581	100
114	582	101
116	599	103
118	612	104
119	615	102
120	618	105
121	620	106
122	622	107
123	625	108
124	627	109
125	628	110
126	629	111
127	635	112
128	638	113
129	639	114
130	644	115
131	651	116
132	654	117
134	662	119
135	663	120
136	664	121
137	667	122
138	670	123
139	671	124
140	674	125
141	675	126
144	681	128
145	695	129
146	698	130
147	700	131
148	704	132
149	708	133
150	714	134
151	716	135
152	721	136
153	722	137
154	727	138
155	733	139
157	769	140
158	775	141
159	776	142
160	777	143
161	780	144
162	782	145
163	787	146
164	796	147
165	797	148
166	800	149
167	806	150
168	807	151
171	818	154
172	829	155
173	830	153
174	838	156
175	839	157
176	841	158
177	842	159
178	845	160
179	847	161
180	850	162
181	854	163
182	861	164
183	864	165
184	866	166
185	869	167
186	870	168
187	871	169
188	872	170
189	873	171
190	874	172
191	875	173
192	877	174
193	880	175
194	882	176
195	883	177
196	884	178
197	885	179
198	886	180
199	887	181
200	889	182
201	891	183
202	892	184
204	896	185
206	901	186
207	904	187
208	905	188
209	906	189
210	908	190
211	910	191
212	912	192
213	913	193
214	914	194
215	915	195
216	917	196
217	919	197
218	921	198
219	923	199
220	926	200
221	928	201
222	929	202
223	932	203
224	950	204
225	951	205
226	952	206
227	953	207
228	956	208
229	959	209
230	962	210
232	967	211
233	971	212
234	974	213
235	976	214
236	977	215
237	979	216
238	986	217
239	989	218
240	992	219
241	993	220
242	996	221
244	1001	222
246	1007	224
247	1010	225
249	1015	226
250	1017	227
251	1019	228
252	1022	229
253	1024	230
254	1025	231
255	1027	232
256	1030	233
258	1035	235
259	1043	236
260	1046	237
261	1049	238
262	1052	239
263	1054	240
264	1060	241
265	1063	242
266	1064	243
268	1081	245
269	1085	244
270	1088	246
271	1099	234
272	1102	247
273	1104	248
274	1107	249
275	1111	250
276	1115	251
277	1132	252
278	1138	253
279	1152	254
280	1156	255
281	1164	256
282	1175	257
283	1183	258
284	1190	259
285	1202	260
286	1204	261
287	1206	262
288	1216	263
289	1222	264
290	1232	265
291	1237	266
292	1240	267
293	1249	268
294	1263	269
295	1268	270
296	1274	271
297	1277	272
298	1297	273
299	1314	274
300	1332	275
301	1335	276
302	1338	277
304	1358	279
305	1364	280
306	1368	281
307	1370	282
308	1371	283
309	1372	284
310	1373	285
311	1374	286
312	1375	287
314	1378	288
315	1380	289
317	1384	290
318	1386	291
319	1387	292
320	1388	293
321	1389	294
322	1391	295
323	1393	296
324	1395	297
325	1398	298
326	1399	299
327	1400	300
328	1403	301
329	1404	302
330	1406	303
331	1407	304
332	1408	305
336	1415	308
337	1416	307
338	1417	309
339	1418	310
340	1419	311
341	1420	312
342	1423	313
343	1424	314
345	1430	316
347	1436	315
348	1439	317
349	1442	318
350	1447	319
352	1452	321
354	1455	322
355	1459	323
356	1462	324
357	1468	325
358	1469	326
359	1471	327
364	1484	332
365	1486	333
366	1487	334
368	1494	335
369	1499	336
370	1503	337
371	1504	338
372	1505	339
373	1506	340
374	1509	341
375	1511	342
376	1513	343
377	1515	344
378	1530	345
379	1543	346
380	1546	347
381	1551	348
382	1553	349
383	1555	350
384	1556	351
385	1557	352
386	1560	353
387	1563	354
388	1566	355
389	1569	356
390	1572	357
391	1573	358
392	1574	359
393	1575	360
394	1577	361
395	1579	362
396	1581	363
397	1583	364
404	1591	365
405	1593	366
406	1599	367
408	1602	369
409	1603	368
413	1616	370
414	1619	372
415	1624	371
416	1632	373
417	1633	374
418	1634	375
419	1635	376
420	1639	377
421	1643	378
422	1644	379
423	1647	380
424	1650	381
426	1652	383
427	1653	384
428	1655	385
430	1666	387
431	1672	382
432	1674	388
433	1678	389
434	1681	390
435	1685	391
437	1695	393
438	1701	394
439	1707	395
440	1712	392
441	1718	396
442	1720	397
443	1721	398
444	1723	399
445	1724	400
446	1726	401
447	1727	402
449	1729	404
450	1734	405
451	1739	406
452	1740	407
453	1744	408
455	1749	410
456	1750	411
457	1752	412
458	1759	413
464	1769	409
459	1760	414
460	1762	415
461	1763	416
462	1764	403
463	1768	417
465	1771	418
466	1772	419
467	1775	420
468	1776	421
469	1777	422
470	1778	423
471	1787	424
472	1792	425
473	1796	426
477	1803	429
479	1806	428
480	1807	430
481	1808	431
483	1814	432
484	1816	433
485	1829	434
488	1833	437
489	1835	438
490	1836	439
492	1838	441
493	1840	442
494	1846	443
495	1847	440
496	1853	444
498	1863	445
501	1868	447
502	1872	448
503	1875	449
504	1880	450
505	1882	451
507	1884	453
508	1887	452
510	1893	454
511	1904	455
512	1905	446
513	1907	456
514	1908	457
515	1911	458
516	1912	459
517	1915	460
518	1916	461
519	1920	462
521	1927	464
522	1929	465
523	1930	463
524	1931	466
526	1939	468
527	1943	469
528	1946	470
529	1947	471
531	1954	473
532	1961	474
534	1966	475
535	1967	472
536	1975	476
537	1977	477
538	1979	478
539	1980	479
540	1982	480
541	1987	481
542	1988	482
543	1989	483
545	2002	484
546	2008	485
547	2012	486
548	2022	487
549	2025	488
550	2026	489
555	2032	490
556	2035	491
558	2037	492
559	2041	493
560	2045	494
561	2050	495
562	2052	496
563	2056	497
564	2061	498
565	2064	499
566	2066	500
568	2068	502
569	2071	503
570	2073	504
571	2074	505
572	2078	506
573	2079	507
574	2088	508
575	2090	509
576	2091	510
577	2094	511
578	2097	512
579	2099	513
580	2100	514
581	2102	515
582	2105	516
583	2106	517
584	2109	518
585	2112	519
587	2115	520
588	2119	521
589	2120	522
590	2125	523
591	2127	524
592	2131	525
593	2133	526
594	2134	527
596	2138	529
597	2140	530
598	2143	528
599	2145	531
601	2154	532
602	2156	533
603	2158	534
604	2160	535
605	2161	536
606	2163	537
607	2165	538
608	2167	539
611	2170	542
612	2172	543
613	2173	544
615	2178	546
618	2188	549
619	2189	545
620	2192	547
621	2195	548
622	2198	550
623	2201	551
625	2203	552
626	2204	553
627	2207	554
629	2212	555
630	2215	556
633	2219	558
634	2221	559
635	2222	560
636	2223	561
637	2224	562
638	2226	557
639	2228	563
640	2229	564
641	2232	565
642	2234	566
643	2235	567
644	2237	568
645	2240	569
646	2242	570
647	2244	571
648	2248	572
649	2251	573
650	2257	574
652	2264	576
654	2278	577
655	2280	578
658	2283	580
659	2284	581
660	2285	582
661	2286	583
662	2288	584
663	2289	585
664	2290	586
665	2291	587
666	2294	588
667	2298	589
668	2302	590
669	2304	591
670	2306	592
671	2316	593
672	2323	594
673	2325	595
674	2326	596
675	2327	597
676	2328	598
677	2329	599
678	2330	600
679	2331	601
680	2337	602
681	2340	603
682	2343	604
683	2344	605
684	2346	606
685	2347	607
687	2350	609
688	2351	610
689	2352	611
690	2353	612
691	2354	613
692	2356	614
693	2357	615
694	2358	616
695	2360	617
696	2362	618
697	2363	619
698	2365	620
699	2367	621
701	2371	623
702	2372	624
703	2373	625
705	2376	627
706	2377	628
707	2379	629
708	2380	630
709	2381	631
710	2383	632
711	2384	633
712	2387	634
713	2388	635
714	2390	636
715	2391	637
716	2392	638
718	2396	639
719	2397	640
720	2398	641
721	2399	642
722	2401	643
723	2402	644
724	2403	645
725	2404	646
727	2406	648
728	2408	649
729	2409	650
730	2410	651
731	2411	652
732	2412	653
733	2413	654
734	2414	655
735	2415	656
736	2416	657
737	2418	658
738	2422	659
739	2423	660
740	2427	661
741	2428	662
742	2429	663
743	2432	664
744	2435	665
747	2439	668
748	2445	669
749	2446	670
750	2448	671
751	2451	672
752	2452	667
753	2454	673
754	2458	666
755	2460	674
756	2462	675
757	2469	676
758	2470	677
759	2477	678
761	2479	680
762	2482	681
763	2484	679
764	2485	682
765	2490	683
766	2495	684
767	2499	685
768	2500	686
769	2504	687
770	2506	688
771	2507	689
772	2509	690
773	2511	691
774	2512	692
775	2514	693
776	2516	694
777	2522	695
778	2524	696
780	2530	698
781	2532	697
782	2536	699
783	2537	700
784	2540	701
785	2544	702
786	2546	703
787	2548	704
788	2550	705
789	2551	706
790	2553	707
791	2556	708
792	2557	709
793	2558	710
795	2565	712
797	2568	714
798	2569	715
799	2571	711
800	2573	716
801	2575	717
802	2577	718
803	2580	719
804	2581	720
805	2583	721
806	2585	722
807	2586	723
808	2587	724
809	2589	725
810	2591	726
811	2592	727
812	2593	728
813	2596	729
814	2599	730
815	2603	731
816	2604	732
817	2607	733
818	2610	734
819	2616	735
820	2619	736
821	2622	737
822	2624	738
824	2628	740
825	2629	741
826	2631	742
827	2633	743
828	2638	744
829	2642	745
831	2648	746
832	2650	747
833	2661	748
834	2665	749
835	2666	750
836	2668	751
837	2671	752
838	2672	753
839	2673	754
840	2678	755
841	2695	756
842	2700	757
843	2701	758
844	2707	759
845	2710	760
846	2713	761
847	2715	762
848	2716	763
849	2721	764
850	2725	765
851	2740	766
852	2810	767
853	2812	768
854	2814	769
855	2816	770
856	2821	771
857	2822	772
858	2826	773
859	2827	774
860	2831	775
861	2834	776
862	2837	777
863	2840	778
864	2842	779
866	2846	780
867	2848	781
869	2856	782
872	2867	784
873	2868	785
874	2871	783
875	2874	786
876	2880	787
877	2884	788
878	2885	789
880	2914	791
881	2915	790
882	2918	792
883	2922	793
884	2931	794
885	2933	795
886	2936	796
887	2957	797
888	2958	798
889	2960	799
890	2963	800
891	2967	801
892	2985	802
894	2992	804
896	3004	805
897	3005	806
898	3007	807
899	3008	803
900	3018	808
901	3026	809
903	3029	810
904	3033	811
905	3035	812
906	3040	813
907	3042	814
908	3046	815
909	3047	816
910	3067	817
911	3072	818
912	3077	819
913	3085	820
914	3091	821
915	3092	822
916	3093	823
917	3104	824
919	3116	826
920	3117	827
922	3124	828
923	3125	829
925	3128	831
926	3132	832
927	3136	833
928	3137	834
929	3143	835
930	3155	825
931	3158	836
932	3162	837
933	3166	838
934	3169	839
935	3172	830
936	3175	840
937	3178	841
940	3183	842
941	3185	843
942	3187	844
943	3189	845
945	3195	846
946	3197	847
947	3200	848
948	3210	849
949	3211	850
950	3214	851
951	3216	852
952	3217	853
953	3219	854
954	3222	855
955	3225	856
956	3226	857
957	3229	858
958	3233	859
960	3238	861
961	3244	862
962	3246	863
963	3247	864
964	3248	865
965	3252	866
966	3253	867
967	3258	868
968	3260	869
969	3264	870
971	3272	872
972	3273	873
973	3276	874
974	3279	875
975	3280	876
976	3282	877
977	3284	878
978	3296	879
979	3298	880
980	3301	881
981	3302	882
982	3309	883
983	3311	884
985	3315	886
986	3316	887
987	3320	888
988	3323	889
989	3328	890
990	3330	891
991	3335	892
992	3336	893
993	3338	894
994	3340	895
995	3344	896
996	3346	897
997	3347	898
998	3351	899
999	3354	900
1000	3356	901
1001	3363	902
1002	3365	903
1003	3366	904
1004	3374	905
1005	3376	906
1006	3380	907
1008	3389	909
1011	3408	910
1012	3419	911
1013	3425	912
1015	3428	908
1016	3430	914
1017	3432	915
1018	3439	916
1020	3448	918
1021	3450	919
1022	3456	920
1023	3463	917
1024	3473	921
1025	3491	922
1026	3494	923
1028	3503	924
1030	3510	926
1031	3519	925
1032	3530	927
1033	3533	928
1034	3539	929
1035	3540	930
1037	3548	931
1038	3549	932
1039	3550	933
1040	3551	934
1042	3554	935
1045	3561	936
1047	3563	937
1048	3566	938
1049	3570	939
1051	3573	941
1052	3576	942
1055	3589	945
1057	3593	943
1058	3596	944
1059	3599	947
1060	3602	948
1061	3608	946
1062	3609	949
1063	3616	950
1066	3620	951
1068	3624	952
1069	3625	953
1071	3629	954
1072	3635	955
1073	3637	956
1074	3638	957
1075	3643	958
1077	3650	960
1078	3651	961
1079	3652	959
1080	3653	962
1082	3656	964
1085	3659	965
1086	3661	963
1087	3662	966
1088	3666	967
1089	3671	968
1091	3674	969
1092	3675	970
1093	3680	971
1094	3682	972
1095	3683	973
1096	3685	974
1098	3687	976
1099	3689	977
1100	3693	978
1101	3695	979
1102	3698	980
1103	3699	975
1104	3703	981
1106	3706	983
1107	3711	984
1108	3713	985
1109	3715	986
1110	3716	987
1111	3718	988
1112	3721	989
1113	3723	990
1114	3724	991
1115	3725	992
1117	3731	994
1118	3732	995
1119	3734	996
1120	3735	997
1121	3737	993
1122	3740	998
1123	3741	999
1124	3742	1000
1125	3743	1001
1126	3744	1002
1127	3746	1003
1128	3747	1004
1129	3750	1005
1130	3751	1006
1131	3752	1007
1133	3767	1009
1134	3768	1008
1135	3769	1010
1136	3770	1011
1137	3772	1012
1139	3774	1013
1140	3777	1014
1141	3778	1015
1142	3781	1016
1143	3782	1017
1144	3784	1018
1145	3785	1019
1146	3786	1020
1147	3788	1021
1148	3790	1022
1149	3791	1023
1150	3792	1024
1151	3794	1025
1152	3795	1026
1153	3796	1027
1154	3797	1028
1155	3798	1029
1157	3801	1031
1158	3803	1030
1159	3805	1032
1160	3810	1033
1161	3811	1034
1162	3814	1035
1163	3815	1036
1164	3817	1037
1165	3819	1038
1167	3831	1039
1168	3835	1040
1169	3838	1041
1170	3840	1042
1171	3845	1043
1173	3847	1045
1174	3850	1046
1177	3858	1049
1178	3860	1050
1180	3863	1051
1181	3865	1052
1183	3869	1053
1184	3871	1054
1185	3873	1055
1186	3874	1056
1187	3875	1057
1188	3877	1058
1189	3880	1059
1190	3883	1060
1191	3886	1061
1192	3889	1062
1194	3896	1063
1195	3902	1064
1197	3909	1065
1198	3910	1066
1199	3911	1067
1200	3914	1068
1201	3915	1069
1202	3918	1070
1203	3919	1071
1204	3920	1072
1205	3924	1073
1206	3925	1074
\.


--
-- Data for Name: backend_esrule_Striggers; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public."backend_esrule_Striggers" (id, esrule_id, trigger_id) FROM stdin;
7	35	220
9	37	224
10	37	225
11	38	227
12	38	228
13	39	230
14	39	231
15	40	233
16	41	235
17	46	241
18	46	242
19	46	243
20	47	245
21	47	246
22	47	247
23	48	249
24	48	250
25	48	251
26	49	253
27	49	254
28	49	255
29	50	259
32	54	283
33	60	291
34	60	292
35	61	294
36	61	295
37	61	296
38	63	299
39	64	301
40	65	303
41	66	305
42	67	356
43	76	386
44	76	387
45	77	427
46	84	491
47	85	493
48	86	495
53	87	503
54	88	505
55	88	506
56	88	507
57	92	532
58	92	533
60	96	570
61	97	572
62	101	583
65	103	600
68	104	613
69	104	614
70	102	616
71	102	617
72	105	619
73	106	621
74	107	623
75	108	626
76	114	640
77	114	641
78	115	645
79	115	646
80	116	652
81	116	653
85	121	665
86	121	666
87	126	676
89	128	682
90	129	696
91	129	697
92	130	699
93	131	701
94	132	705
95	133	709
96	134	715
97	139	734
98	139	735
99	144	781
103	153	831
104	153	832
105	157	840
106	160	846
107	164	862
108	164	863
109	165	865
110	166	867
111	166	868
112	173	876
113	174	878
114	174	879
115	175	881
116	181	888
117	182	890
118	184	893
120	185	897
121	185	898
123	186	902
124	186	903
125	189	907
126	190	909
127	191	911
128	195	916
129	196	918
130	197	920
131	198	922
132	199	924
133	199	925
134	200	927
135	202	930
136	202	931
137	203	933
138	208	957
139	208	958
143	211	968
144	211	969
145	211	970
146	213	975
147	215	978
148	216	980
149	218	990
150	218	991
152	222	1002
154	225	1011
155	227	1018
156	228	1020
157	228	1021
158	232	1028
161	235	1036
162	235	1037
163	239	1053
164	241	1061
165	243	1065
166	243	1066
169	245	1082
170	244	1086
171	244	1087
172	246	1089
173	246	1090
174	234	1100
175	234	1101
176	247	1103
177	249	1108
178	250	1112
179	252	1133
180	253	1139
181	253	1140
182	253	1141
183	255	1157
184	256	1165
185	260	1203
186	261	1205
187	263	1217
188	265	1233
189	269	1264
190	272	1278
191	272	1279
192	273	1298
193	274	1315
196	279	1359
197	281	1369
199	288	1379
200	289	1381
202	290	1385
203	294	1390
204	295	1392
205	296	1394
206	297	1396
207	297	1397
208	300	1401
209	300	1402
210	302	1405
211	305	1409
214	312	1421
215	312	1422
216	314	1425
217	314	1426
220	316	1431
221	316	1432
224	315	1437
225	315	1438
226	317	1440
227	317	1441
228	318	1443
229	318	1444
230	319	1448
231	321	1453
232	324	1463
233	327	1472
238	332	1485
239	334	1488
244	335	1495
245	335	1496
246	335	1497
247	335	1498
248	336	1500
249	336	1501
250	336	1502
251	340	1507
252	340	1508
253	341	1510
254	342	1512
255	343	1514
256	345	1531
257	345	1532
258	346	1544
259	346	1545
260	347	1547
261	347	1548
262	348	1552
263	349	1554
264	353	1561
265	353	1562
266	354	1564
267	354	1565
268	355	1567
269	355	1568
270	356	1570
271	356	1571
272	360	1576
273	361	1578
274	362	1580
275	363	1582
276	364	1584
277	365	1592
278	367	1600
284	370	1617
285	370	1618
286	372	1620
287	372	1621
288	371	1625
289	376	1636
290	384	1654
291	385	1656
292	385	1657
293	385	1658
296	387	1667
297	387	1668
298	387	1669
299	382	1673
300	390	1682
301	391	1686
304	393	1696
305	394	1702
306	394	1703
307	392	1713
308	392	1714
309	396	1719
310	398	1722
311	400	1725
315	411	1751
316	412	1753
317	414	1761
318	403	1765
319	409	1770
320	426	1797
321	429	1804
322	433	1817
323	433	1818
325	437	1834
327	445	1864
328	453	1885
329	453	1886
330	459	1913
331	464	1928
332	466	1932
335	469	1944
337	476	1976
338	477	1978
341	484	2003
342	484	2004
343	489	2027
344	492	2038
345	493	2042
346	495	2051
347	499	2065
348	503	2072
349	508	2089
350	514	2101
352	520	2116
353	523	2126
354	524	2128
355	524	2129
356	524	2130
357	525	2132
358	527	2135
359	527	2136
360	529	2139
361	528	2144
363	532	2155
364	533	2157
365	534	2159
366	536	2162
367	537	2164
368	542	2171
369	544	2174
372	546	2179
377	545	2190
378	545	2191
379	547	2193
380	547	2194
381	548	2196
382	548	2197
383	554	2208
385	562	2225
386	557	2227
387	564	2230
388	564	2231
389	565	2233
390	567	2236
391	568	2238
392	568	2239
393	569	2241
394	570	2243
395	571	2245
396	571	2246
397	571	2247
398	572	2249
399	572	2250
400	573	2252
401	574	2258
402	574	2259
403	574	2260
404	574	2261
407	577	2279
408	588	2295
409	589	2299
410	589	2300
411	589	2301
412	590	2303
413	591	2305
414	594	2324
415	601	2332
416	603	2341
417	603	2342
418	605	2345
420	613	2355
421	616	2359
422	617	2361
423	619	2364
424	620	2366
428	628	2378
429	631	2382
430	635	2389
433	642	2400
434	648	2407
435	657	2417
436	660	2424
437	663	2430
438	663	2431
439	665	2436
440	668	2440
441	670	2447
442	671	2449
443	671	2450
444	667	2453
445	673	2455
446	666	2459
447	674	2461
448	677	2471
449	680	2480
450	680	2481
451	681	2483
452	684	2496
453	686	2501
454	687	2505
455	689	2508
456	690	2510
457	692	2513
458	693	2515
459	694	2517
460	695	2523
464	698	2531
465	697	2533
466	697	2534
467	697	2535
468	700	2538
469	701	2541
470	702	2545
471	703	2547
472	704	2549
473	706	2552
476	715	2570
477	711	2572
478	716	2574
479	717	2576
480	720	2582
481	721	2584
482	724	2588
483	725	2590
484	729	2597
485	729	2598
486	730	2600
487	730	2601
488	732	2605
489	732	2606
490	733	2608
491	733	2609
492	734	2611
493	734	2612
494	736	2620
495	736	2621
496	737	2623
497	741	2630
498	742	2632
499	743	2634
500	745	2643
502	746	2649
503	747	2651
504	748	2662
505	748	2663
506	748	2664
507	750	2667
508	751	2669
509	751	2670
510	754	2674
511	754	2675
512	756	2696
513	756	2697
514	756	2698
515	756	2699
516	758	2702
517	760	2711
518	760	2712
519	764	2722
520	764	2723
521	767	2811
522	768	2813
523	769	2815
524	770	2817
525	770	2818
526	770	2819
527	770	2820
528	774	2828
529	775	2832
530	776	2835
531	777	2838
532	778	2841
533	779	2843
536	782	2857
537	782	2858
540	785	2869
541	785	2870
542	783	2872
543	783	2873
544	786	2875
545	796	2937
546	798	2959
547	800	2964
548	801	2968
549	802	2986
552	804	2993
553	804	2994
556	803	3009
557	808	3019
558	808	3020
560	810	3030
561	811	3034
562	813	3041
563	817	3068
564	818	3073
565	818	3074
566	818	3075
567	818	3076
568	819	3078
569	819	3079
570	820	3086
571	823	3094
572	824	3105
578	831	3129
579	831	3130
580	831	3131
581	832	3133
582	835	3144
583	835	3145
584	835	3146
585	825	3156
586	825	3157
587	836	3159
588	836	3160
589	837	3163
590	839	3170
591	839	3171
592	830	3173
593	830	3174
594	840	3176
595	840	3177
598	842	3184
599	843	3186
600	844	3188
602	846	3196
603	848	3201
604	848	3202
605	853	3218
606	854	3220
607	855	3223
608	855	3224
609	858	3230
610	861	3239
611	862	3245
612	867	3254
613	867	3255
614	868	3259
615	870	3265
616	870	3266
617	873	3274
618	873	3275
619	874	3277
620	876	3281
621	877	3283
622	882	3303
623	883	3310
624	884	3312
625	887	3317
626	888	3321
627	889	3324
628	890	3329
629	891	3331
630	893	3337
631	894	3339
632	896	3345
633	898	3348
634	900	3355
635	902	3364
636	904	3367
637	905	3375
638	906	3377
641	909	3390
642	909	3391
645	910	3409
646	912	3426
647	908	3429
648	914	3431
649	915	3433
650	916	3440
653	918	3449
654	920	3457
655	917	3464
656	917	3465
657	921	3474
658	921	3475
659	922	3492
660	922	3493
663	924	3504
664	924	3505
666	926	3511
667	926	3512
668	925	3520
669	925	3521
670	927	3531
671	927	3532
672	928	3534
675	935	3555
676	938	3567
677	938	3568
678	938	3569
679	941	3574
680	942	3577
681	945	3590
682	945	3591
683	943	3594
684	943	3595
685	944	3597
686	944	3598
687	949	3610
688	949	3611
689	949	3612
690	949	3613
691	955	3636
692	957	3639
693	958	3644
694	965	3660
695	966	3663
696	967	3667
697	968	3672
698	970	3676
699	970	3677
700	971	3681
701	973	3684
702	976	3688
703	977	3690
704	978	3694
705	979	3696
706	979	3697
707	981	3704
708	983	3707
709	983	3708
710	984	3712
711	985	3714
712	987	3717
713	988	3719
714	988	3720
715	989	3722
718	995	3733
719	997	3736
720	993	3738
721	993	3739
722	1002	3745
723	1004	3748
724	1004	3749
725	1011	3771
726	1017	3783
727	1020	3787
729	1031	3802
730	1030	3804
731	1032	3806
732	1032	3807
733	1032	3808
734	1032	3809
735	1034	3812
736	1034	3813
737	1036	3816
738	1037	3818
739	1038	3820
740	1038	3821
741	1038	3822
745	1039	3832
746	1039	3833
747	1039	3834
748	1040	3836
749	1041	3839
750	1042	3841
752	1049	3859
753	1050	3861
754	1051	3864
755	1052	3866
757	1053	3870
758	1054	3872
759	1057	3876
760	1060	3884
761	1060	3885
762	1061	3887
763	1061	3888
764	1062	3890
765	1062	3891
766	1063	3897
767	1064	3903
768	1067	3912
769	1067	3913
770	1069	3916
771	1069	3917
772	1072	3921
\.


--
-- Name: backend_esrule_triggersS_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public."backend_esrule_triggersS_id_seq"', 772, true);


--
-- Data for Name: backend_inputparam; Type: TABLE DATA; Schema: public; Owner: jessejmart
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
-- Data for Name: backend_metaparam; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.backend_metaparam (parameter_ptr_id, is_event) FROM stdin;
50	f
52	t
55	f
57	t
\.


--
-- Data for Name: backend_parameter; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.backend_parameter (id, name, type, cap_id) FROM stdin;
3	color	set	6
17	weather	set	18
11	frequency	range	12
24	time	time	26
25	value	bin	27
26	value	bin	28
28	quantity	input	30
30	topping	set	31
31	quantity	input	31
33	distance	range	32
34	item	input	33
35	name	input	35
36	channel	range	36
37	name	input	37
39	cups	range	39
40	value	bin	40
50	trigger	meta	49
51	time	duration	49
52	trigger	meta	50
53	time	duration	50
54	occurrences	range	50
55	trigger	meta	51
56	time	duration	51
57	trigger	meta	52
58	time	duration	52
69	BPM	range	62
71	who	set	63
27	item	input	30
73	cups	range	38
74	temperature	range	65
18	temperature	range	19
21	temperature	range	21
29	size	set	31
75	temperature	range	66
70	location	set	63
32	trackingid	input	32
1	setting	bin	2
2	level	range	3
7	level	range	8
8	genre	set	9
12	setting	bin	13
13	position	bin	14
20	condition	bin	20
23	time	time	25
14	status	bin	15
62	time	bin	55
64	setting	bin	57
65	position	bin	58
66	condition	bin	59
67	position	bin	60
68	status	bin	61
72	setting	bin	64
\.


--
-- Name: backend_parameter_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.backend_parameter_id_seq', 76, true);


--
-- Data for Name: backend_parval; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.backend_parval (id, val, par_id, state_id) FROM stdin;
\.


--
-- Name: backend_parval_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.backend_parval_id_seq', 1, false);


--
-- Data for Name: backend_rangeparam; Type: TABLE DATA; Schema: public; Owner: jessejmart
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
\.


--
-- Data for Name: backend_rule; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.backend_rule (id, owner_id, type, task, lastedit) FROM stdin;
35	1	es	1	2018-08-09 20:23:22.79171-05
37	1	es	2	2018-08-09 20:28:00.997979-05
38	1	es	2	2018-08-09 20:29:23.921173-05
39	1	es	2	2018-08-09 20:30:40.190673-05
40	1	es	3	2018-08-09 20:32:00.349084-05
41	1	es	3	2018-08-09 20:32:55.219512-05
42	1	es	4	2018-08-09 22:02:53.507562-05
43	1	es	5	2018-08-09 22:04:30.382947-05
44	1	es	6	2018-08-09 22:15:31.818393-05
45	1	es	7	2018-08-09 22:30:14.19687-05
46	1	es	8	2018-08-09 22:34:40.717071-05
47	1	es	8	2018-08-09 22:36:20.640195-05
48	1	es	8	2018-08-09 22:37:45.473294-05
49	1	es	8	2018-08-09 22:58:35.799463-05
50	5	es	1	2018-08-10 14:46:57.477845-05
54	3	es	1	2018-08-13 09:18:50.265866-05
55	3	es	1	2018-08-13 09:20:30.788082-05
56	3	es	1	2018-08-13 09:21:55.439809-05
57	3	es	1	2018-08-13 09:23:33.509848-05
58	3	es	1	2018-08-13 10:39:05.92608-05
59	3	es	5	2018-08-13 11:22:36.636747-05
60	3	es	16	2018-08-13 11:33:22.848021-05
61	3	es	1	2018-08-13 12:36:49.133968-05
62	3	es	1	2018-08-13 12:43:42.492829-05
63	3	es	1	2018-08-13 13:21:32.763621-05
64	3	es	1	2018-08-13 13:23:12.525295-05
65	3	es	1	2018-08-13 13:40:10.903578-05
66	3	es	1	2018-08-13 13:55:17.037733-05
67	5	es	1	2018-08-15 16:22:22.363361-05
68	5	es	11	2018-08-16 18:17:39.205868-05
69	5	es	5	2018-08-16 18:21:00.883528-05
70	15	es	4	2018-08-16 18:39:24.372441-05
71	15	es	3	2018-08-16 18:43:44.212028-05
72	15	es	5	2018-08-16 18:46:46.876267-05
73	15	es	11	2018-08-16 18:49:30.493046-05
75	15	es	12	2018-08-16 18:50:57.348866-05
74	18	es	7	2018-08-16 18:51:18.759559-05
76	15	es	2	2018-08-16 18:54:01.09811-05
77	24	es	12	2018-08-16 19:07:34.631762-05
78	24	es	15	2018-08-16 19:21:04.405183-05
79	24	es	15	2018-08-16 19:23:34.644121-05
80	27	es	3	2018-08-16 19:25:23.480375-05
81	24	es	4	2018-08-16 19:26:03.870399-05
82	24	es	10	2018-08-16 19:27:21.600919-05
83	27	es	14	2018-08-16 19:27:50.926231-05
84	24	es	2	2018-08-16 19:29:34.128565-05
85	24	es	2	2018-08-16 19:30:13.154017-05
86	24	es	2	2018-08-16 19:31:45.467327-05
87	27	es	6	2018-08-16 19:33:27.315774-05
88	28	es	4	2018-08-16 19:33:29.879516-05
89	24	es	14	2018-08-16 19:35:23.330154-05
90	27	es	10	2018-08-16 19:36:42.94571-05
91	27	es	7	2018-08-16 19:39:45.001667-05
92	28	es	3	2018-08-16 19:40:34.447392-05
93	27	es	9	2018-08-16 19:43:02.083797-05
94	27	es	9	2018-08-16 19:43:42.983027-05
96	30	es	9	2018-08-16 19:46:58.615969-05
97	30	es	9	2018-08-16 19:47:54.556366-05
98	27	es	11	2018-08-16 19:48:31.139904-05
99	30	es	9	2018-08-16 19:48:32.485505-05
100	30	es	11	2018-08-16 19:50:22.201564-05
101	32	es	9	2018-08-16 19:50:22.393692-05
103	30	es	7	2018-08-16 19:55:23.387672-05
163	40	es	10	2018-08-16 21:54:42.406412-05
104	32	es	16	2018-08-16 19:57:39.895876-05
102	28	es	6	2018-08-16 19:57:40.558269-05
105	30	es	3	2018-08-16 19:57:58.14905-05
106	33	es	12	2018-08-16 19:58:16.703941-05
107	33	es	12	2018-08-16 19:58:50.703268-05
108	33	es	12	2018-08-16 19:59:20.721411-05
109	30	es	4	2018-08-16 19:59:20.896577-05
110	32	es	14	2018-08-16 20:01:59.546944-05
111	30	es	5	2018-08-16 20:02:26.018167-05
112	30	es	14	2018-08-16 20:04:18.672393-05
113	30	es	14	2018-08-16 20:04:42.364736-05
114	33	es	2	2018-08-16 20:04:48.818426-05
115	33	es	2	2018-08-16 20:05:54.08551-05
116	33	es	2	2018-08-16 20:06:59.256069-05
117	32	es	11	2018-08-16 20:10:19.444206-05
119	33	es	10	2018-08-16 20:12:00.912097-05
120	32	es	10	2018-08-16 20:12:32.701416-05
121	28	es	15	2018-08-16 20:12:52.718648-05
122	32	es	4	2018-08-16 20:14:05.8187-05
123	33	es	15	2018-08-16 20:15:16.715609-05
124	33	es	15	2018-08-16 20:16:32.645357-05
125	33	es	4	2018-08-16 20:20:50.031867-05
126	33	es	4	2018-08-16 20:22:01.941911-05
128	28	es	16	2018-08-16 20:27:43.481989-05
129	33	es	9	2018-08-16 20:33:00.51056-05
130	28	es	14	2018-08-16 20:33:57.271617-05
131	33	es	9	2018-08-16 20:34:52.766248-05
132	28	es	14	2018-08-16 20:35:32.022267-05
133	37	es	15	2018-08-16 20:42:05.887539-05
134	37	es	6	2018-08-16 20:44:43.518736-05
135	37	es	10	2018-08-16 20:45:43.719874-05
136	33	es	6	2018-08-16 20:46:17.126958-05
137	37	es	11	2018-08-16 20:46:57.734719-05
138	37	es	7	2018-08-16 20:53:19.216359-05
139	37	es	2	2018-08-16 20:55:21.783008-05
140	40	es	4	2018-08-16 21:15:12.490251-05
141	40	es	4	2018-08-16 21:19:34.861345-05
142	40	es	4	2018-08-16 21:20:08.463248-05
143	40	es	4	2018-08-16 21:20:33.441882-05
144	40	es	14	2018-08-16 21:22:33.17502-05
145	40	es	14	2018-08-16 21:23:23.64581-05
146	41	es	15	2018-08-16 21:25:55.234116-05
147	40	es	12	2018-08-16 21:28:03.561006-05
148	40	es	12	2018-08-16 21:28:21.070366-05
149	40	es	12	2018-08-16 21:28:36.936909-05
150	40	es	14	2018-08-16 21:31:28.329054-05
151	41	es	16	2018-08-16 21:32:37.756512-05
154	41	es	12	2018-08-16 21:36:03.361556-05
155	41	es	5	2018-08-16 21:40:26.324254-05
153	40	es	16	2018-08-16 21:40:29.501515-05
156	41	es	9	2018-08-16 21:44:10.540444-05
157	40	es	7	2018-08-16 21:45:45.475888-05
158	41	es	10	2018-08-16 21:46:50.48865-05
159	40	es	7	2018-08-16 21:47:24.627892-05
160	41	es	3	2018-08-16 21:51:11.773341-05
161	42	es	7	2018-08-16 21:51:21.981238-05
162	42	es	11	2018-08-16 21:54:12.629847-05
164	40	es	10	2018-08-16 21:57:04.725739-05
165	43	es	6	2018-08-16 21:57:29.258331-05
166	42	es	16	2018-08-16 22:01:16.971688-05
167	40	es	10	2018-08-16 22:03:13.276082-05
168	43	es	10	2018-08-16 22:03:31.711429-05
169	40	es	11	2018-08-16 22:08:22.815694-05
170	40	es	11	2018-08-16 22:08:47.747102-05
171	40	es	11	2018-08-16 22:09:20.115282-05
172	40	es	11	2018-08-16 22:09:51.510453-05
173	42	es	15	2018-08-16 22:09:59.758534-05
174	43	es	16	2018-08-16 22:10:59.238165-05
175	42	es	15	2018-08-16 22:11:19.716166-05
176	42	es	12	2018-08-16 22:15:16.993967-05
177	43	es	12	2018-08-16 22:15:26.456769-05
178	42	es	8	2018-08-16 22:18:09.669215-05
179	42	es	8	2018-08-16 22:19:14.894638-05
180	42	es	8	2018-08-16 22:19:51.721516-05
181	43	es	8	2018-08-16 22:21:01.663323-05
182	43	es	8	2018-08-16 22:21:53.839025-05
183	42	es	14	2018-08-16 22:22:24.983263-05
184	43	es	8	2018-08-16 22:23:05.477474-05
185	43	es	8	2018-08-16 22:26:26.230976-05
186	43	es	8	2018-08-16 22:27:41.767928-05
187	44	es	9	2018-08-16 22:38:33.872156-05
188	44	es	5	2018-08-16 22:42:25.920734-05
189	44	es	7	2018-08-16 22:45:18.529754-05
190	44	es	15	2018-08-16 22:48:08.104696-05
191	44	es	3	2018-08-16 22:50:43.872688-05
192	44	es	4	2018-08-16 22:52:56.458925-05
193	44	es	14	2018-08-16 22:54:58.456516-05
194	43	es	11	2018-08-16 23:02:28.679432-05
195	43	es	3	2018-08-16 23:05:15.425484-05
196	43	es	3	2018-08-16 23:06:08.28089-05
197	45	es	6	2018-08-16 23:58:56.72192-05
198	45	es	14	2018-08-17 00:04:44.466643-05
199	45	es	8	2018-08-17 00:09:47.921286-05
200	45	es	7	2018-08-17 00:13:18.490921-05
201	45	es	10	2018-08-17 00:15:48.116254-05
202	45	es	12	2018-08-17 00:18:53.067144-05
203	45	es	16	2018-08-17 00:25:43.778819-05
204	46	es	10	2018-08-18 21:45:35.923008-05
205	46	es	10	2018-08-18 21:46:08.599885-05
206	47	es	16	2018-08-18 21:48:20.685255-05
207	46	es	3	2018-08-18 21:48:25.265891-05
208	49	es	2	2018-08-18 21:49:51.021101-05
209	46	es	4	2018-08-18 21:50:00.908808-05
210	46	es	11	2018-08-18 21:51:22.661136-05
211	48	es	8	2018-08-18 21:51:47.107447-05
212	49	es	5	2018-08-18 21:53:08.570677-05
213	46	es	2	2018-08-18 21:53:40.443627-05
214	50	es	10	2018-08-18 21:53:42.342613-05
215	46	es	2	2018-08-18 21:54:10.935325-05
216	46	es	2	2018-08-18 21:54:49.130267-05
217	46	es	12	2018-08-18 21:56:51.19597-05
218	48	es	16	2018-08-18 21:57:30.556515-05
219	54	es	5	2018-08-18 21:57:35.541643-05
220	47	es	15	2018-08-18 21:57:41.473118-05
221	49	es	10	2018-08-18 21:57:57.993255-05
222	50	es	8	2018-08-18 21:58:14.37736-05
224	47	es	15	2018-08-18 21:58:45.593133-05
225	46	es	14	2018-08-18 21:59:23.675092-05
226	54	es	11	2018-08-18 21:59:50.36386-05
227	46	es	14	2018-08-18 22:00:22.417372-05
228	49	es	12	2018-08-18 22:00:24.881819-05
229	47	es	3	2018-08-18 22:01:03.050911-05
230	48	es	5	2018-08-18 22:01:41.171661-05
231	49	es	11	2018-08-18 22:02:26.949077-05
232	54	es	12	2018-08-18 22:03:42.081155-05
233	48	es	10	2018-08-18 22:04:17.780443-05
235	49	es	6	2018-08-18 22:04:56.799891-05
236	54	es	2	2018-08-18 22:06:40.851315-05
237	57	es	10	2018-08-18 22:07:37.451262-05
238	47	es	5	2018-08-18 22:07:51.165897-05
239	54	es	2	2018-08-18 22:09:03.099761-05
240	47	es	10	2018-08-18 22:09:37.853599-05
241	48	es	6	2018-08-18 22:13:51.866895-05
242	59	es	14	2018-08-18 22:14:08.533182-05
243	47	es	2	2018-08-18 22:14:28.770485-05
245	48	es	3	2018-08-18 22:18:58.51533-05
244	57	es	2	2018-08-18 22:19:08.85687-05
246	54	es	16	2018-08-18 22:19:51.500732-05
234	50	es	14	2018-08-18 22:22:04.872503-05
247	54	es	16	2018-08-18 22:22:06.984217-05
248	48	es	12	2018-08-18 22:22:08.824183-05
249	48	es	12	2018-08-18 22:22:57.780232-05
250	50	es	14	2018-08-18 22:24:31.616109-05
251	57	es	14	2018-08-18 22:25:34.802741-05
252	50	es	11	2018-08-18 22:29:29.545576-05
253	59	es	16	2018-08-18 22:30:06.803899-05
254	64	es	11	2018-08-18 22:32:01.862114-05
255	57	es	3	2018-08-18 22:32:54.037513-05
256	50	es	12	2018-08-18 22:33:29.40135-05
257	57	es	12	2018-08-18 22:36:58.474356-05
258	57	es	12	2018-08-18 22:37:34.710474-05
259	57	es	12	2018-08-18 22:38:35.874313-05
260	64	es	14	2018-08-18 22:42:02.685949-05
261	50	es	6	2018-08-18 22:42:10.551396-05
262	57	es	5	2018-08-18 22:42:39.62777-05
263	59	es	10	2018-08-18 22:45:53.288087-05
264	57	es	11	2018-08-18 22:46:36.593892-05
265	64	es	9	2018-08-18 22:50:32.311449-05
266	59	es	9	2018-08-18 22:50:43.972181-05
267	59	es	9	2018-08-18 22:53:10.158024-05
268	59	es	3	2018-08-18 22:56:20.971945-05
269	64	es	3	2018-08-18 23:00:12.577213-05
270	59	es	7	2018-08-18 23:02:20.725142-05
271	64	es	4	2018-08-18 23:05:30.079917-05
272	59	es	8	2018-08-18 23:06:23.138581-05
273	64	es	6	2018-08-18 23:19:45.651126-05
274	64	es	7	2018-08-18 23:28:06.455997-05
275	68	es	9	2018-08-18 23:45:30.849302-05
276	68	es	9	2018-08-18 23:46:20.971101-05
277	68	es	12	2018-08-18 23:52:47.616255-05
279	68	es	7	2018-08-19 00:03:08.001912-05
280	68	es	14	2018-08-19 00:05:16.480786-05
281	68	es	16	2018-08-19 00:08:28.581437-05
282	68	es	2	2018-08-19 00:11:00.750554-05
283	68	es	2	2018-08-19 00:11:53.370585-05
284	68	es	2	2018-08-19 00:12:21.480039-05
285	68	es	8	2018-08-19 00:15:21.054364-05
286	68	es	8	2018-08-19 00:16:06.850946-05
287	68	es	8	2018-08-19 00:16:39.066234-05
288	70	es	3	2018-08-19 00:50:02.891192-05
289	70	es	3	2018-08-19 00:51:04.478932-05
290	71	es	14	2018-08-19 00:51:56.914383-05
291	70	es	8	2018-08-19 00:56:03.942234-05
292	71	es	4	2018-08-19 00:56:30.85323-05
293	70	es	8	2018-08-19 00:56:35.853851-05
294	70	es	8	2018-08-19 00:58:03.555838-05
295	70	es	8	2018-08-19 00:58:44.146957-05
296	71	es	12	2018-08-19 01:01:49.459692-05
297	72	es	8	2018-08-19 01:03:44.7097-05
298	70	es	9	2018-08-19 01:03:49.545544-05
299	70	es	9	2018-08-19 01:04:42.593253-05
300	72	es	8	2018-08-19 01:05:17.888698-05
301	70	es	11	2018-08-19 01:08:03.501253-05
302	71	es	15	2018-08-19 01:15:26.216703-05
303	70	es	5	2018-08-19 01:17:15.920338-05
304	70	es	10	2018-08-19 01:18:49.82154-05
305	72	es	4	2018-08-19 01:21:25.395678-05
327	72	es	15	2018-08-19 02:03:27.960111-05
308	71	es	2	2018-08-19 01:23:17.614211-05
307	73	es	3	2018-08-19 01:23:23.344423-05
309	70	es	4	2018-08-19 01:23:37.896962-05
310	70	es	4	2018-08-19 01:24:09.42572-05
311	71	es	11	2018-08-19 01:26:47.539053-05
312	72	es	2	2018-08-19 01:30:46.193904-05
313	71	es	9	2018-08-19 01:31:15.261113-05
314	72	es	2	2018-08-19 01:31:39.685842-05
316	72	es	2	2018-08-19 01:32:40.987499-05
315	73	es	2	2018-08-19 01:33:10.4403-05
317	73	es	2	2018-08-19 01:33:55.644291-05
318	73	es	2	2018-08-19 01:34:52.168249-05
319	72	es	9	2018-08-19 01:39:36.580328-05
321	72	es	9	2018-08-19 01:41:30.237126-05
322	73	es	7	2018-08-19 01:43:18.625792-05
323	72	es	9	2018-08-19 01:47:19.255607-05
324	73	es	16	2018-08-19 01:51:55.991533-05
325	73	es	9	2018-08-19 01:58:44.136823-05
326	73	es	10	2018-08-19 02:01:31.408989-05
332	72	es	7	2018-08-19 02:14:08.120937-05
333	72	es	6	2018-08-19 02:14:47.948449-05
334	73	es	15	2018-08-19 02:16:37.520809-05
335	77	es	14	2018-08-19 05:34:37.422115-05
336	77	es	15	2018-08-19 05:41:47.73264-05
337	77	es	7	2018-08-19 05:49:38.525617-05
338	77	es	3	2018-08-19 05:54:43.339724-05
339	77	es	3	2018-08-19 05:55:47.764043-05
340	77	es	2	2018-08-19 05:59:34.791908-05
341	77	es	8	2018-08-19 06:04:43.090208-05
342	77	es	8	2018-08-19 06:05:57.061567-05
343	77	es	8	2018-08-19 06:07:38.749431-05
344	77	es	5	2018-08-19 06:10:24.452219-05
345	3	es	1	2018-08-19 14:04:55.231221-05
346	3	es	1	2018-08-19 14:11:40.250568-05
347	3	es	1	2018-08-19 14:12:15.005211-05
348	3	es	1	2018-08-19 14:14:03.477555-05
349	3	es	1	2018-08-19 14:16:55.279954-05
350	3	es	1	2018-08-19 14:19:36.637672-05
351	3	es	1	2018-08-19 14:21:02.299459-05
352	3	es	1	2018-08-19 14:31:55.941374-05
353	3	es	1	2018-08-19 14:45:10.897396-05
354	3	es	1	2018-08-19 14:53:56.165209-05
355	3	es	1	2018-08-19 14:55:13.14848-05
356	3	es	1	2018-08-19 14:57:51.961743-05
357	3	es	1	2018-08-19 15:13:44.917977-05
358	3	es	1	2018-08-19 15:32:26.25642-05
359	3	es	1	2018-08-19 15:41:06.057035-05
360	3	es	1	2018-08-19 15:41:37.15957-05
361	3	es	1	2018-08-19 15:43:52.706121-05
362	3	es	1	2018-08-19 15:44:22.018495-05
363	3	es	1	2018-08-19 15:45:42.35699-05
364	3	es	1	2018-08-19 15:46:21.813665-05
365	1	es	1	2018-08-19 16:07:56.281145-05
366	5	es	1	2018-08-19 18:31:59.025259-05
367	79	es	8	2018-08-19 18:54:47.963289-05
369	81	es	9	2018-08-19 18:57:01.653129-05
368	81	es	9	2018-08-19 18:57:18.050196-05
370	80	es	15	2018-08-19 18:59:05.458481-05
372	79	es	8	2018-08-19 18:59:05.716406-05
371	82	es	6	2018-08-19 18:59:17.161525-05
373	81	es	5	2018-08-19 19:01:54.893317-05
374	88	es	10	2018-08-19 19:02:44.933929-05
375	81	es	5	2018-08-19 19:02:45.582225-05
376	82	es	7	2018-08-19 19:03:42.620666-05
377	80	es	14	2018-08-19 19:04:47.662971-05
378	80	es	14	2018-08-19 19:05:09.294011-05
379	81	es	4	2018-08-19 19:05:14.284602-05
380	81	es	4	2018-08-19 19:05:50.868422-05
381	81	es	4	2018-08-19 19:06:26.025633-05
383	91	es	5	2018-08-19 19:06:36.088716-05
384	3	es	1	2018-08-19 19:06:40.561085-05
385	80	es	14	2018-08-19 19:07:35.316758-05
387	82	es	8	2018-08-19 19:08:41.585185-05
382	89	es	6	2018-08-19 19:08:55.955609-05
388	3	es	1	2018-08-19 19:09:20.628279-05
389	91	es	2	2018-08-19 19:09:37.430339-05
390	81	es	6	2018-08-19 19:11:46.318231-05
391	90	es	8	2018-08-19 19:12:03.111766-05
393	79	es	8	2018-08-19 19:12:42.506563-05
394	82	es	15	2018-08-19 19:13:36.411197-05
395	91	es	3	2018-08-19 19:13:57.899457-05
392	89	es	8	2018-08-19 19:14:23.693083-05
396	80	es	6	2018-08-19 19:14:43.449791-05
397	89	es	8	2018-08-19 19:14:48.051482-05
398	81	es	12	2018-08-19 19:15:07.925354-05
399	89	es	8	2018-08-19 19:15:10.262825-05
400	81	es	12	2018-08-19 19:15:32.421288-05
401	89	es	8	2018-08-19 19:15:33.911558-05
402	91	es	11	2018-08-19 19:15:43.260952-05
404	96	es	4	2018-08-19 19:16:45.680923-05
405	91	es	14	2018-08-19 19:17:47.589635-05
406	91	es	14	2018-08-19 19:18:09.537344-05
407	97	es	2	2018-08-19 19:18:43.863461-05
408	80	es	5	2018-08-19 19:18:59.866596-05
410	97	es	2	2018-08-19 19:19:26.223867-05
411	81	es	8	2018-08-19 19:19:27.293743-05
412	79	es	8	2018-08-19 19:19:52.925676-05
413	91	es	8	2018-08-19 19:20:24.247034-05
414	81	es	8	2018-08-19 19:20:30.521971-05
415	97	es	2	2018-08-19 19:20:42.907564-05
416	89	es	15	2018-08-19 19:20:43.674354-05
403	79	es	8	2018-08-19 19:20:51.803343-05
417	91	es	8	2018-08-19 19:21:08.693073-05
409	82	es	12	2018-08-19 19:21:13.056107-05
418	90	es	4	2018-08-19 19:21:16.367504-05
419	81	es	8	2018-08-19 19:21:18.918521-05
420	81	es	8	2018-08-19 19:21:35.896702-05
421	80	es	8	2018-08-19 19:21:41.519655-05
422	96	es	5	2018-08-19 19:21:41.599176-05
423	91	es	8	2018-08-19 19:21:48.987466-05
424	80	es	8	2018-08-19 19:22:14.832659-05
425	99	es	5	2018-08-19 19:22:52.197107-05
426	80	es	8	2018-08-19 19:23:31.551729-05
429	80	es	8	2018-08-19 19:24:16.793617-05
428	89	es	15	2018-08-19 19:24:20.98737-05
430	79	es	8	2018-08-19 19:24:25.393304-05
431	96	es	14	2018-08-19 19:24:28.320269-05
432	91	es	15	2018-08-19 19:24:50.237242-05
433	82	es	16	2018-08-19 19:25:32.092175-05
434	79	es	8	2018-08-19 19:27:11.741077-05
437	81	es	14	2018-08-19 19:27:34.651042-05
438	94	es	6	2018-08-19 19:27:52.88585-05
439	82	es	11	2018-08-19 19:28:13.340585-05
441	102	es	12	2018-08-19 19:28:15.986704-05
442	5	es	1	2018-08-19 19:28:23.430675-05
443	102	es	12	2018-08-19 19:28:43.803473-05
440	89	es	5	2018-08-19 19:28:44.782413-05
444	97	es	10	2018-08-19 19:29:25.804242-05
445	99	es	9	2018-08-19 19:30:52.701762-05
447	89	es	10	2018-08-19 19:31:19.323854-05
448	97	es	11	2018-08-19 19:31:55.827222-05
449	88	es	11	2018-08-19 19:32:53.671123-05
450	96	es	2	2018-08-19 19:33:22.303629-05
451	99	es	7	2018-08-19 19:33:52.153279-05
453	89	es	2	2018-08-19 19:34:15.229537-05
452	97	es	11	2018-08-19 19:34:50.176064-05
484	97	es	7	2018-08-19 19:51:23.380567-05
454	102	es	7	2018-08-19 19:35:23.141082-05
455	96	es	2	2018-08-19 19:36:25.920836-05
446	80	es	9	2018-08-19 19:36:27.787299-05
456	80	es	9	2018-08-19 19:36:57.105538-05
457	96	es	2	2018-08-19 19:37:10.000855-05
458	80	es	9	2018-08-19 19:37:23.706006-05
459	89	es	3	2018-08-19 19:37:24.153862-05
460	96	es	2	2018-08-19 19:37:52.810966-05
461	90	es	15	2018-08-19 19:37:56.149265-05
462	96	es	2	2018-08-19 19:38:19.846462-05
464	88	es	12	2018-08-19 19:39:14.262335-05
465	102	es	6	2018-08-19 19:39:19.853585-05
463	96	es	2	2018-08-19 19:39:24.336524-05
466	89	es	3	2018-08-19 19:39:24.690518-05
468	80	es	12	2018-08-19 19:40:13.289141-05
469	89	es	3	2018-08-19 19:40:21.792081-05
470	97	es	9	2018-08-19 19:40:31.783979-05
471	89	es	3	2018-08-19 19:40:48.637653-05
473	94	es	5	2018-08-19 19:41:58.798722-05
474	90	es	7	2018-08-19 19:43:00.770597-05
485	104	es	7	2018-08-19 19:52:48.913658-05
475	102	es	9	2018-08-19 19:43:22.309514-05
472	80	es	12	2018-08-19 19:43:29.757037-05
476	80	es	12	2018-08-19 19:44:21.601749-05
477	80	es	12	2018-08-19 19:44:48.49014-05
478	88	es	7	2018-08-19 19:45:04.834049-05
479	97	es	4	2018-08-19 19:45:21.964073-05
480	94	es	11	2018-08-19 19:46:08.058723-05
481	94	es	11	2018-08-19 19:46:59.770256-05
482	94	es	11	2018-08-19 19:48:09.373551-05
483	88	es	14	2018-08-19 19:49:22.824021-05
486	90	es	2	2018-08-19 19:53:19.525486-05
487	99	es	15	2018-08-19 19:55:41.28016-05
488	94	es	10	2018-08-19 19:56:29.94062-05
489	97	es	6	2018-08-19 19:56:39.497723-05
490	99	es	15	2018-08-19 19:57:07.411469-05
491	90	es	14	2018-08-19 19:58:35.150469-05
492	104	es	12	2018-08-19 19:59:04.26077-05
493	104	es	12	2018-08-19 19:59:49.673317-05
494	99	es	4	2018-08-19 20:00:02.8801-05
495	104	es	12	2018-08-19 20:01:00.210668-05
496	96	es	10	2018-08-19 20:01:23.800362-05
497	96	es	8	2018-08-19 20:03:10.947964-05
498	96	es	8	2018-08-19 20:04:10.577691-05
499	3	es	2	2018-08-19 20:04:29.858736-05
500	99	es	6	2018-08-19 20:04:40.196642-05
502	96	es	8	2018-08-19 20:04:42.729684-05
503	88	es	3	2018-08-19 20:06:35.06583-05
504	96	es	11	2018-08-19 20:07:07.410963-05
505	90	es	6	2018-08-19 20:07:27.681822-05
506	104	es	8	2018-08-19 20:08:03.212089-05
507	99	es	8	2018-08-19 20:08:07.622665-05
508	107	es	7	2018-08-19 20:09:07.625842-05
509	104	es	8	2018-08-19 20:09:35.251632-05
510	94	es	7	2018-08-19 20:09:41.927218-05
511	104	es	8	2018-08-19 20:10:19.893612-05
512	108	es	10	2018-08-19 20:12:06.490295-05
513	107	es	9	2018-08-19 20:14:06.792481-05
514	88	es	8	2018-08-19 20:14:07.115654-05
515	108	es	16	2018-08-19 20:14:49.189977-05
516	94	es	2	2018-08-19 20:15:26.895186-05
517	107	es	9	2018-08-19 20:15:28.210136-05
518	94	es	2	2018-08-19 20:16:02.499972-05
519	108	es	12	2018-08-19 20:16:21.883717-05
520	109	es	8	2018-08-19 20:17:09.347041-05
521	94	es	2	2018-08-19 20:17:24.05351-05
522	108	es	11	2018-08-19 20:17:38.526754-05
523	107	es	15	2018-08-19 20:19:23.817482-05
524	110	es	2	2018-08-19 20:19:28.132721-05
525	107	es	15	2018-08-19 20:20:03.854373-05
526	108	es	4	2018-08-19 20:20:09.066212-05
527	104	es	8	2018-08-19 20:20:12.660852-05
529	107	es	15	2018-08-19 20:20:48.276559-05
530	111	es	12	2018-08-19 20:21:15.438078-05
528	111	es	12	2018-08-19 20:21:30.137912-05
531	108	es	14	2018-08-19 20:21:30.324944-05
532	109	es	3	2018-08-19 20:22:19.891635-05
533	104	es	8	2018-08-19 20:22:24.454469-05
534	94	es	12	2018-08-19 20:22:35.930347-05
535	107	es	16	2018-08-19 20:22:52.87372-05
536	104	es	8	2018-08-19 20:23:23.120911-05
537	94	es	12	2018-08-19 20:23:39.140279-05
538	111	es	4	2018-08-19 20:23:52.677852-05
539	112	es	9	2018-08-19 20:24:40.675879-05
542	110	es	11	2018-08-19 20:25:16.586584-05
543	107	es	13	2018-08-19 20:25:25.35068-05
544	112	es	9	2018-08-19 20:26:46.683394-05
546	111	es	3	2018-08-19 20:27:47.372823-05
549	110	es	16	2018-08-19 20:29:23.464479-05
545	109	es	2	2018-08-19 20:29:27.936555-05
547	109	es	2	2018-08-19 20:29:31.032852-05
548	109	es	2	2018-08-19 20:29:33.877862-05
550	104	es	15	2018-08-19 20:30:10.23001-05
551	110	es	9	2018-08-19 20:32:35.650059-05
552	109	es	9	2018-08-19 20:32:55.752769-05
553	104	es	15	2018-08-19 20:33:00.604937-05
554	111	es	6	2018-08-19 20:33:04.597246-05
555	109	es	11	2018-08-19 20:35:29.145849-05
556	110	es	6	2018-08-19 20:36:13.57159-05
558	109	es	10	2018-08-19 20:37:38.184037-05
559	104	es	6	2018-08-19 20:38:46.216034-05
560	102	es	5	2018-08-19 20:39:08.617573-05
561	110	es	7	2018-08-19 20:39:09.238368-05
562	112	es	5	2018-08-19 20:39:28.934783-05
557	112	es	5	2018-08-19 20:39:42.023732-05
563	109	es	14	2018-08-19 20:40:19.342758-05
564	111	es	15	2018-08-19 20:40:48.73588-05
565	112	es	5	2018-08-19 20:40:53.928901-05
566	110	es	10	2018-08-19 20:41:35.812945-05
567	102	es	2	2018-08-19 20:41:46.857278-05
568	111	es	9	2018-08-19 20:45:57.176586-05
569	111	es	8	2018-08-19 20:49:40.187392-05
570	111	es	8	2018-08-19 20:50:43.105226-05
571	102	es	16	2018-08-19 20:50:45.082965-05
572	104	es	2	2018-08-19 20:51:04.401509-05
573	111	es	8	2018-08-19 20:51:24.879718-05
574	111	es	8	2018-08-19 20:54:56.70667-05
576	104	es	16	2018-08-19 20:56:48.165193-05
577	112	es	6	2018-08-19 21:07:16.859874-05
578	112	es	11	2018-08-19 21:15:13.268761-05
580	118	es	10	2018-08-19 21:18:53.59206-05
581	112	es	11	2018-08-19 21:19:56.980577-05
582	112	es	11	2018-08-19 21:20:22.604266-05
583	112	es	11	2018-08-19 21:20:51.021314-05
584	112	es	11	2018-08-19 21:21:50.814563-05
585	112	es	11	2018-08-19 21:22:16.337192-05
586	118	es	12	2018-08-19 21:22:33.65838-05
587	118	es	11	2018-08-19 21:24:22.4431-05
588	118	es	16	2018-08-19 21:28:19.219067-05
589	118	es	8	2018-08-19 21:37:16.860571-05
590	118	es	2	2018-08-19 21:39:20.237922-05
591	118	es	7	2018-08-19 21:42:23.326645-05
592	123	es	12	2018-08-19 21:53:24.884834-05
593	126	es	1	2018-08-20 10:22:54.745452-05
594	127	es	6	2018-08-20 13:02:18.878201-05
595	128	es	5	2018-08-20 13:02:31.27925-05
596	130	es	4	2018-08-20 13:04:22.952885-05
597	130	es	4	2018-08-20 13:05:47.4323-05
598	128	es	6	2018-08-20 13:06:54.839794-05
599	127	es	11	2018-08-20 13:07:26.199095-05
600	132	es	12	2018-08-20 13:08:17.946192-05
601	129	es	12	2018-08-20 13:08:50.000916-05
602	133	es	7	2018-08-20 13:11:00.299723-05
603	131	es	16	2018-08-20 13:12:20.159562-05
604	127	es	4	2018-08-20 13:12:35.381428-05
605	128	es	12	2018-08-20 13:13:14.848209-05
606	127	es	14	2018-08-20 13:14:42.313319-05
607	129	es	6	2018-08-20 13:14:42.870002-05
609	129	es	6	2018-08-20 13:15:49.480929-05
610	136	es	2	2018-08-20 13:16:10.646668-05
611	128	es	14	2018-08-20 13:16:18.380809-05
612	136	es	2	2018-08-20 13:16:49.376381-05
613	135	es	9	2018-08-20 13:18:07.042517-05
614	128	es	11	2018-08-20 13:18:19.88851-05
615	129	es	10	2018-08-20 13:18:48.854731-05
616	135	es	9	2018-08-20 13:19:20.741677-05
617	127	es	2	2018-08-20 13:19:45.810375-05
618	136	es	10	2018-08-20 13:19:51.673998-05
619	135	es	9	2018-08-20 13:21:09.106787-05
620	127	es	7	2018-08-20 13:21:47.06207-05
621	132	es	7	2018-08-20 13:21:57.892511-05
623	127	es	10	2018-08-20 13:22:58.448881-05
624	128	es	8	2018-08-20 13:23:58.425536-05
625	129	es	9	2018-08-20 13:24:14.907432-05
627	138	es	10	2018-08-20 13:26:34.759366-05
628	135	es	7	2018-08-20 13:26:36.487949-05
629	129	es	14	2018-08-20 13:26:39.973706-05
630	138	es	4	2018-08-20 13:27:52.189721-05
631	133	es	14	2018-08-20 13:27:52.751439-05
632	136	es	15	2018-08-20 13:28:17.927272-05
633	128	es	9	2018-08-20 13:28:23.669446-05
634	137	es	7	2018-08-20 13:29:13.174999-05
635	135	es	6	2018-08-20 13:29:15.062798-05
636	138	es	14	2018-08-20 13:29:20.160634-05
637	138	es	14	2018-08-20 13:29:53.429738-05
638	136	es	15	2018-08-20 13:29:59.228829-05
649	135	es	14	2018-08-20 13:33:56.7254-05
639	135	es	11	2018-08-20 13:30:49.525373-05
640	129	es	11	2018-08-20 13:31:00.810012-05
641	138	es	8	2018-08-20 13:31:21.245555-05
642	136	es	15	2018-08-20 13:31:40.248837-05
643	138	es	8	2018-08-20 13:31:48.103631-05
644	138	es	8	2018-08-20 13:32:10.70966-05
645	135	es	5	2018-08-20 13:32:28.366634-05
646	129	es	5	2018-08-20 13:32:48.361868-05
648	138	es	3	2018-08-20 13:33:43.407509-05
650	137	es	9	2018-08-20 13:34:39.692039-05
651	136	es	14	2018-08-20 13:35:00.745666-05
652	135	es	2	2018-08-20 13:35:31.599118-05
653	131	es	12	2018-08-20 13:35:32.727529-05
654	137	es	9	2018-08-20 13:35:38.063051-05
655	135	es	2	2018-08-20 13:35:51.774759-05
656	138	es	9	2018-08-20 13:36:05.977251-05
657	133	es	16	2018-08-20 13:36:08.227238-05
658	135	es	2	2018-08-20 13:36:12.375401-05
659	141	es	5	2018-08-20 13:37:01.070231-05
660	138	es	7	2018-08-20 13:37:42.160657-05
661	143	es	10	2018-08-20 13:37:57.218289-05
662	144	es	11	2018-08-20 13:38:25.146156-05
663	136	es	6	2018-08-20 13:38:26.049851-05
664	141	es	11	2018-08-20 13:39:54.058723-05
665	137	es	8	2018-08-20 13:40:33.411922-05
668	137	es	8	2018-08-20 13:41:27.435615-05
669	143	es	11	2018-08-20 13:42:05.845682-05
670	133	es	12	2018-08-20 13:42:30.031428-05
671	131	es	2	2018-08-20 13:42:32.737886-05
672	136	es	8	2018-08-20 13:42:33.242202-05
667	133	es	12	2018-08-20 13:42:44.720694-05
673	137	es	8	2018-08-20 13:42:55.389818-05
666	133	es	12	2018-08-20 13:43:02.109549-05
674	141	es	3	2018-08-20 13:43:34.531896-05
675	136	es	8	2018-08-20 13:43:48.120239-05
676	136	es	8	2018-08-20 13:44:11.187117-05
677	137	es	8	2018-08-20 13:44:29.611495-05
678	141	es	10	2018-08-20 13:46:37.887329-05
680	136	es	8	2018-08-20 13:46:50.499231-05
681	143	es	9	2018-08-20 13:47:15.436283-05
679	131	es	11	2018-08-20 13:47:21.080188-05
682	143	es	9	2018-08-20 13:48:01.421274-05
683	137	es	6	2018-08-20 13:49:09.05274-05
684	136	es	3	2018-08-20 13:50:11.255924-05
685	133	es	15	2018-08-20 13:51:05.037828-05
686	137	es	2	2018-08-20 13:51:16.041336-05
687	137	es	2	2018-08-20 13:51:59.740844-05
688	133	es	15	2018-08-20 13:52:08.224133-05
689	141	es	6	2018-08-20 13:52:12.890903-05
690	143	es	3	2018-08-20 13:52:34.60171-05
691	131	es	8	2018-08-20 13:52:42.573343-05
692	137	es	2	2018-08-20 13:52:52.866574-05
693	137	es	2	2018-08-20 13:53:56.683828-05
694	143	es	3	2018-08-20 13:53:57.733078-05
695	137	es	2	2018-08-20 13:54:46.133046-05
696	131	es	8	2018-08-20 13:54:49.638554-05
698	137	es	2	2018-08-20 13:55:47.334968-05
697	141	es	12	2018-08-20 13:56:14.149452-05
699	131	es	8	2018-08-20 13:56:20.190241-05
700	145	es	12	2018-08-20 13:56:53.907197-05
701	145	es	12	2018-08-20 13:57:32.624196-05
702	145	es	12	2018-08-20 13:58:08.625626-05
703	133	es	4	2018-08-20 13:58:58.391152-05
704	137	es	3	2018-08-20 13:59:00.09863-05
705	141	es	7	2018-08-20 13:59:35.689669-05
706	137	es	3	2018-08-20 13:59:51.049905-05
707	143	es	6	2018-08-20 14:00:00.615063-05
708	137	es	11	2018-08-20 14:02:23.799412-05
709	145	es	4	2018-08-20 14:03:25.604011-05
710	137	es	11	2018-08-20 14:04:03.299817-05
712	143	es	2	2018-08-20 14:06:11.077815-05
714	132	es	3	2018-08-20 14:06:18.355497-05
715	145	es	14	2018-08-20 14:06:27.64547-05
711	133	es	8	2018-08-20 14:07:34.026343-05
716	133	es	8	2018-08-20 14:08:32.717344-05
717	133	es	8	2018-08-20 14:09:14.69806-05
718	132	es	15	2018-08-20 14:09:26.503167-05
719	143	es	4	2018-08-20 14:10:09.06665-05
720	130	es	15	2018-08-20 14:11:24.589054-05
721	145	es	15	2018-08-20 14:11:50.761839-05
722	132	es	4	2018-08-20 14:11:56.24411-05
723	130	es	15	2018-08-20 14:12:40.815426-05
724	131	es	15	2018-08-20 14:13:37.41351-05
725	130	es	15	2018-08-20 14:14:11.30824-05
726	130	es	15	2018-08-20 14:14:46.745248-05
727	145	es	11	2018-08-20 14:15:00.714695-05
728	130	es	15	2018-08-20 14:15:20.9812-05
729	132	es	8	2018-08-20 14:18:02.1732-05
730	145	es	2	2018-08-20 14:20:15.028805-05
731	130	es	11	2018-08-20 14:20:50.158011-05
732	145	es	2	2018-08-20 14:21:05.794017-05
733	132	es	2	2018-08-20 14:21:15.063989-05
734	145	es	2	2018-08-20 14:22:08.103895-05
735	130	es	6	2018-08-20 14:24:19.047741-05
736	145	es	7	2018-08-20 14:28:23.944663-05
737	130	es	3	2018-08-20 14:30:59.336176-05
738	148	es	14	2018-08-20 14:32:22.29651-05
740	148	es	12	2018-08-20 14:36:20.219025-05
741	130	es	12	2018-08-20 14:36:31.602351-05
742	130	es	12	2018-08-20 14:37:44.074316-05
743	130	es	12	2018-08-20 14:38:14.201398-05
744	148	es	4	2018-08-20 14:39:45.191739-05
745	148	es	15	2018-08-20 14:46:38.242238-05
746	32	es	6	2018-08-20 14:47:28.443353-05
747	130	es	7	2018-08-20 14:47:51.510174-05
748	150	es	8	2018-08-20 14:57:59.624295-05
749	32	es	3	2018-08-20 14:58:17.506507-05
750	148	es	9	2018-08-20 15:01:20.504701-05
751	32	es	2	2018-08-20 15:03:16.440801-05
752	150	es	5	2018-08-20 15:06:18.27149-05
753	148	es	16	2018-08-20 15:07:56.61961-05
754	32	es	8	2018-08-20 15:10:11.021163-05
755	150	es	9	2018-08-20 15:12:32.563262-05
756	153	es	8	2018-08-20 15:17:37.722742-05
757	150	es	11	2018-08-20 15:19:11.154915-05
758	32	es	15	2018-08-20 15:19:52.848657-05
759	153	es	10	2018-08-20 15:22:04.341891-05
760	32	es	12	2018-08-20 15:24:11.931445-05
761	153	es	3	2018-08-20 15:24:54.906905-05
762	150	es	7	2018-08-20 15:26:23.75863-05
763	153	es	5	2018-08-20 15:28:00.269152-05
764	150	es	12	2018-08-20 15:31:54.96319-05
765	150	es	10	2018-08-20 15:36:23.103794-05
766	148	es	6	2018-08-20 15:51:24.676213-05
767	155	es	12	2018-08-20 18:08:53.573033-05
768	155	es	3	2018-08-20 18:13:02.320219-05
769	155	es	3	2018-08-20 18:13:02.390462-05
770	155	es	6	2018-08-20 18:16:22.879187-05
771	156	es	3	2018-08-20 18:29:55.093668-05
772	158	es	12	2018-08-20 18:31:15.38548-05
773	156	es	5	2018-08-20 18:34:07.233598-05
774	158	es	16	2018-08-20 18:35:02.365515-05
775	158	es	2	2018-08-20 18:38:39.24433-05
776	158	es	2	2018-08-20 18:39:28.11851-05
777	158	es	2	2018-08-20 18:40:27.665606-05
778	156	es	16	2018-08-20 18:42:05.153782-05
779	158	es	3	2018-08-20 18:43:57.373175-05
780	156	es	4	2018-08-20 18:45:41.247805-05
781	158	es	7	2018-08-20 18:49:29.890147-05
782	156	es	2	2018-08-20 18:52:13.502573-05
784	161	es	4	2018-08-20 18:53:42.673131-05
785	156	es	2	2018-08-20 18:53:58.643546-05
783	156	es	2	2018-08-20 18:54:37.994796-05
786	158	es	10	2018-08-20 18:54:54.20472-05
787	156	es	15	2018-08-20 18:59:09.840484-05
788	158	es	11	2018-08-20 19:01:05.185579-05
789	156	es	14	2018-08-20 19:02:02.054888-05
791	164	es	8	2018-08-20 19:19:05.259276-05
790	164	es	8	2018-08-20 19:19:47.635109-05
792	165	es	11	2018-08-20 19:20:06.972277-05
793	164	es	8	2018-08-20 19:22:43.567113-05
794	165	es	7	2018-08-20 19:27:02.374965-05
795	164	es	11	2018-08-20 19:28:55.625123-05
796	165	es	7	2018-08-20 19:30:48.840991-05
797	164	es	5	2018-08-20 19:34:36.054657-05
798	165	es	12	2018-08-20 19:35:15.433692-05
799	164	es	5	2018-08-20 19:35:41.97016-05
800	165	es	3	2018-08-20 19:38:01.818357-05
801	165	es	3	2018-08-20 19:38:46.062802-05
802	165	es	16	2018-08-20 19:44:47.559034-05
804	165	es	16	2018-08-20 19:47:11.460083-05
814	164	es	10	2018-08-20 20:18:43.330128-05
805	167	es	12	2018-08-20 19:48:13.875998-05
806	165	es	10	2018-08-20 19:48:33.183549-05
807	165	es	5	2018-08-20 19:51:32.392938-05
803	164	es	15	2018-08-20 19:52:25.219983-05
808	167	es	8	2018-08-20 19:59:37.66756-05
809	164	es	6	2018-08-20 20:07:12.296422-05
810	167	es	7	2018-08-20 20:08:54.930061-05
811	167	es	3	2018-08-20 20:12:51.398642-05
812	164	es	12	2018-08-20 20:13:00.643722-05
813	167	es	6	2018-08-20 20:17:02.354084-05
815	167	es	11	2018-08-20 20:20:49.840178-05
816	167	es	16	2018-08-20 20:23:26.493544-05
817	171	es	14	2018-08-20 20:37:43.431541-05
818	172	es	15	2018-08-20 20:47:16.972584-05
819	171	es	6	2018-08-20 20:47:33.550548-05
820	171	es	7	2018-08-20 20:49:49.46201-05
821	172	es	9	2018-08-20 20:51:25.757267-05
822	171	es	11	2018-08-20 20:52:45.893911-05
823	172	es	9	2018-08-20 20:52:49.51172-05
824	171	es	15	2018-08-20 21:01:48.855859-05
826	171	es	10	2018-08-20 21:03:57.199821-05
827	177	es	10	2018-08-20 21:04:25.704956-05
836	180	es	2	2018-08-20 21:09:41.14006-05
828	179	es	11	2018-08-20 21:05:22.03426-05
829	171	es	4	2018-08-20 21:05:23.490573-05
831	176	es	12	2018-08-20 21:06:02.753178-05
832	172	es	7	2018-08-20 21:06:08.267175-05
833	181	es	2	2018-08-20 21:06:59.768647-05
834	177	es	11	2018-08-20 21:07:19.165181-05
835	178	es	2	2018-08-20 21:08:06.979351-05
825	178	es	2	2018-08-20 21:09:33.23131-05
837	178	es	2	2018-08-20 21:10:11.761464-05
838	176	es	4	2018-08-20 21:10:28.348643-05
839	180	es	2	2018-08-20 21:10:35.250272-05
830	178	es	2	2018-08-20 21:11:14.651146-05
840	180	es	2	2018-08-20 21:11:27.210835-05
841	172	es	11	2018-08-20 21:12:04.001055-05
959	209	es	8	2018-08-20 22:56:22.376193-05
842	185	es	9	2018-08-20 21:12:48.128993-05
843	178	es	12	2018-08-20 21:13:06.171232-05
844	177	es	7	2018-08-20 21:13:19.200176-05
845	183	es	8	2018-08-20 21:14:02.80629-05
846	185	es	14	2018-08-20 21:15:17.066309-05
847	183	es	8	2018-08-20 21:15:25.457633-05
848	178	es	16	2018-08-20 21:16:09.915961-05
849	188	es	6	2018-08-20 21:16:52.736513-05
850	186	es	11	2018-08-20 21:16:57.917683-05
851	185	es	10	2018-08-20 21:17:08.310819-05
852	176	es	9	2018-08-20 21:18:06.266049-05
853	180	es	7	2018-08-20 21:18:16.951324-05
854	179	es	7	2018-08-20 21:18:22.888655-05
855	177	es	8	2018-08-20 21:18:35.373345-05
856	185	es	3	2018-08-20 21:20:37.667493-05
857	188	es	11	2018-08-20 21:20:40.545489-05
858	178	es	9	2018-08-20 21:21:02.058459-05
859	176	es	9	2018-08-20 21:21:39.572509-05
861	177	es	3	2018-08-20 21:22:23.888002-05
862	185	es	12	2018-08-20 21:22:58.447697-05
863	188	es	3	2018-08-20 21:23:06.644496-05
864	186	es	10	2018-08-20 21:23:13.996153-05
865	179	es	5	2018-08-20 21:23:19.018847-05
866	176	es	10	2018-08-20 21:23:48.598105-05
867	180	es	3	2018-08-20 21:23:56.487246-05
868	178	es	15	2018-08-20 21:24:39.737831-05
869	185	es	4	2018-08-20 21:25:10.045991-05
870	180	es	3	2018-08-20 21:25:28.466451-05
872	186	es	14	2018-08-20 21:26:29.397622-05
873	177	es	14	2018-08-20 21:26:46.932426-05
874	191	es	2	2018-08-20 21:27:27.370967-05
875	176	es	14	2018-08-20 21:27:32.321439-05
876	185	es	2	2018-08-20 21:27:35.714049-05
877	178	es	11	2018-08-20 21:27:40.636148-05
878	179	es	9	2018-08-20 21:28:15.14946-05
879	190	es	7	2018-08-20 21:30:46.713329-05
880	191	es	4	2018-08-20 21:30:53.637306-05
881	176	es	7	2018-08-20 21:31:22.059492-05
882	180	es	3	2018-08-20 21:31:24.999634-05
883	188	es	12	2018-08-20 21:32:44.594776-05
884	179	es	8	2018-08-20 21:33:08.58364-05
886	191	es	7	2018-08-20 21:33:55.63971-05
887	183	es	16	2018-08-20 21:34:04.417813-05
888	179	es	8	2018-08-20 21:34:25.466916-05
889	176	es	2	2018-08-20 21:34:41.085524-05
890	176	es	2	2018-08-20 21:35:15.704214-05
891	180	es	8	2018-08-20 21:35:16.95487-05
892	179	es	8	2018-08-20 21:35:33.125104-05
893	190	es	10	2018-08-20 21:35:50.212548-05
894	180	es	8	2018-08-20 21:35:56.8847-05
895	186	es	14	2018-08-20 21:35:58.051933-05
896	176	es	2	2018-08-20 21:36:24.013907-05
897	191	es	14	2018-08-20 21:36:26.699571-05
898	180	es	8	2018-08-20 21:36:31.912142-05
899	179	es	8	2018-08-20 21:36:34.915013-05
900	188	es	9	2018-08-20 21:36:59.417974-05
901	191	es	9	2018-08-20 21:38:20.705765-05
902	180	es	8	2018-08-20 21:39:42.010409-05
903	191	es	12	2018-08-20 21:40:05.357802-05
904	180	es	8	2018-08-20 21:40:24.245813-05
905	188	es	10	2018-08-20 21:40:59.960994-05
906	180	es	8	2018-08-20 21:41:13.693477-05
907	191	es	16	2018-08-20 21:41:53.172635-05
909	179	es	16	2018-08-20 21:42:26.119449-05
962	209	es	8	2018-08-20 22:57:00.514333-05
910	180	es	6	2018-08-20 21:47:41.686199-05
911	199	es	5	2018-08-20 21:48:46.799506-05
912	179	es	12	2018-08-20 21:49:20.548067-05
908	190	es	15	2018-08-20 21:49:52.721661-05
914	179	es	12	2018-08-20 21:50:04.830189-05
915	179	es	12	2018-08-20 21:50:53.617627-05
916	179	es	12	2018-08-20 21:51:47.457441-05
918	179	es	12	2018-08-20 21:52:43.099067-05
919	180	es	4	2018-08-20 21:52:58.877665-05
920	179	es	12	2018-08-20 21:53:31.19123-05
917	180	es	4	2018-08-20 21:54:14.20197-05
921	180	es	4	2018-08-20 21:55:40.945715-05
922	199	es	2	2018-08-20 21:57:43.260016-05
923	190	es	5	2018-08-20 21:58:12.964878-05
924	199	es	2	2018-08-20 21:59:33.438723-05
926	199	es	2	2018-08-20 22:00:21.720389-05
925	180	es	16	2018-08-20 22:02:02.733262-05
927	188	es	15	2018-08-20 22:03:25.578118-05
928	190	es	6	2018-08-20 22:06:15.533763-05
929	199	es	14	2018-08-20 22:07:14.421929-05
930	186	es	15	2018-08-20 22:07:56.549526-05
931	186	es	15	2018-08-20 22:12:07.208106-05
932	199	es	12	2018-08-20 22:12:25.262821-05
933	199	es	12	2018-08-20 22:12:45.37285-05
934	199	es	12	2018-08-20 22:13:07.420415-05
935	190	es	12	2018-08-20 22:16:53.263747-05
964	209	es	8	2018-08-20 22:57:34.901808-05
936	199	es	9	2018-08-20 22:19:27.400037-05
937	186	es	4	2018-08-20 22:23:40.816878-05
938	190	es	8	2018-08-20 22:25:57.647664-05
939	186	es	7	2018-08-20 22:29:21.784964-05
941	199	es	9	2018-08-20 22:35:01.150884-05
942	199	es	9	2018-08-20 22:35:46.619485-05
945	186	es	2	2018-08-20 22:41:54.100973-05
943	186	es	2	2018-08-20 22:42:28.169616-05
944	186	es	2	2018-08-20 22:42:55.758593-05
947	203	es	11	2018-08-20 22:43:49.972802-05
948	203	es	11	2018-08-20 22:44:51.682568-05
946	203	es	11	2018-08-20 22:46:11.010053-05
949	199	es	16	2018-08-20 22:46:29.063285-05
950	207	es	5	2018-08-20 22:46:39.691716-05
951	207	es	5	2018-08-20 22:48:10.753443-05
975	204	es	8	2018-08-20 23:06:28.268605-05
952	204	es	7	2018-08-20 22:49:03.281857-05
953	199	es	11	2018-08-20 22:49:31.29861-05
954	206	es	15	2018-08-20 22:51:28.479887-05
955	207	es	9	2018-08-20 22:51:59.940284-05
956	209	es	5	2018-08-20 22:52:33.746516-05
957	207	es	9	2018-08-20 22:52:47.262438-05
958	208	es	16	2018-08-20 22:54:30.978205-05
960	204	es	11	2018-08-20 22:55:50.358395-05
961	209	es	8	2018-08-20 22:55:57.929317-05
981	208	es	3	2018-08-20 23:07:46.912003-05
965	208	es	12	2018-08-20 22:58:45.660878-05
963	203	es	4	2018-08-20 22:58:54.122905-05
966	204	es	3	2018-08-20 22:59:02.232383-05
967	208	es	12	2018-08-20 22:59:27.000542-05
968	208	es	12	2018-08-20 22:59:58.632551-05
969	209	es	11	2018-08-20 23:00:49.276913-05
970	207	es	16	2018-08-20 23:02:04.260312-05
971	209	es	2	2018-08-20 23:03:19.767603-05
972	204	es	8	2018-08-20 23:04:04.343141-05
973	206	es	12	2018-08-20 23:04:07.698491-05
974	208	es	4	2018-08-20 23:04:39.834517-05
976	207	es	12	2018-08-20 23:04:52.521972-05
977	207	es	12	2018-08-20 23:05:20.711696-05
978	207	es	12	2018-08-20 23:05:47.381009-05
979	209	es	12	2018-08-20 23:05:52.711339-05
980	204	es	8	2018-08-20 23:06:05.20396-05
983	207	es	15	2018-08-20 23:09:54.948183-05
984	208	es	2	2018-08-20 23:10:55.878322-05
985	208	es	2	2018-08-20 23:11:21.650243-05
986	206	es	5	2018-08-20 23:11:32.757204-05
987	208	es	2	2018-08-20 23:11:48.714143-05
988	207	es	3	2018-08-20 23:13:05.671226-05
989	208	es	14	2018-08-20 23:13:43.51086-05
990	209	es	7	2018-08-20 23:13:53.08749-05
991	203	es	6	2018-08-20 23:14:25.613723-05
992	204	es	6	2018-08-20 23:14:36.852851-05
994	208	es	7	2018-08-20 23:16:29.870995-05
995	209	es	15	2018-08-20 23:17:28.700099-05
996	206	es	6	2018-08-20 23:18:44.269927-05
997	204	es	16	2018-08-20 23:19:32.980065-05
993	207	es	6	2018-08-20 23:20:58.698924-05
998	204	es	12	2018-08-20 23:23:09.706478-05
999	204	es	12	2018-08-20 23:23:32.237264-05
1000	204	es	12	2018-08-20 23:24:03.326194-05
1001	206	es	14	2018-08-20 23:24:05.811129-05
1002	206	es	14	2018-08-20 23:25:32.786982-05
1003	206	es	16	2018-08-20 23:34:48.799793-05
1004	206	es	2	2018-08-20 23:37:56.759217-05
1005	210	es	12	2018-08-20 23:43:49.957527-05
1006	210	es	12	2018-08-20 23:45:40.448926-05
1007	210	es	12	2018-08-20 23:46:28.255569-05
1009	210	es	7	2018-08-20 23:55:12.326364-05
1008	212	es	7	2018-08-20 23:55:36.935713-05
1010	210	es	7	2018-08-20 23:56:34.387394-05
1011	210	es	7	2018-08-20 23:58:29.805835-05
1012	210	es	7	2018-08-21 00:00:13.410949-05
1013	212	es	11	2018-08-21 00:02:19.779045-05
1014	210	es	4	2018-08-21 00:05:48.538809-05
1015	210	es	4	2018-08-21 00:06:51.286814-05
1016	212	es	15	2018-08-21 00:09:23.885231-05
1017	210	es	16	2018-08-21 00:10:30.444054-05
1018	210	es	16	2018-08-21 00:11:48.07691-05
1019	210	es	16	2018-08-21 00:13:31.993381-05
1020	212	es	16	2018-08-21 00:14:30.109793-05
1021	210	es	16	2018-08-21 00:14:40.864194-05
1022	210	es	2	2018-08-21 00:18:36.265475-05
1023	210	es	2	2018-08-21 00:19:10.950823-05
1024	210	es	2	2018-08-21 00:19:59.899998-05
1025	210	es	2	2018-08-21 00:21:57.890274-05
1026	210	es	9	2018-08-21 00:25:01.138243-05
1027	210	es	9	2018-08-21 00:25:56.595897-05
1028	210	es	9	2018-08-21 00:27:00.809624-05
1029	210	es	10	2018-08-21 00:30:37.92463-05
1031	210	es	10	2018-08-21 00:33:42.950235-05
1030	213	es	11	2018-08-21 00:34:08.299468-05
1032	213	es	12	2018-08-21 00:47:21.881038-05
1033	213	es	7	2018-08-21 00:52:20.640799-05
1034	213	es	3	2018-08-21 01:01:46.540023-05
1035	213	es	8	2018-08-21 01:03:33.311395-05
1036	213	es	16	2018-08-21 01:08:08.307223-05
1037	213	es	14	2018-08-21 01:09:59.186399-05
1038	214	es	2	2018-08-21 01:45:27.950954-05
1039	214	es	8	2018-08-21 01:58:19.501348-05
1040	214	es	12	2018-08-21 02:06:12.1928-05
1041	214	es	12	2018-08-21 02:09:52.837105-05
1042	214	es	12	2018-08-21 02:10:41.437825-05
1043	214	es	7	2018-08-21 02:16:05.230843-05
1045	214	es	11	2018-08-21 02:20:10.323449-05
1046	214	es	3	2018-08-21 02:22:59.599665-05
1049	214	es	9	2018-08-21 02:46:54.815018-05
1050	214	es	9	2018-08-21 02:49:33.146371-05
1051	214	es	9	2018-08-21 02:50:59.917786-05
1052	214	es	9	2018-08-21 02:53:08.778313-05
1053	214	es	9	2018-08-21 02:56:02.329573-05
1054	216	es	16	2018-08-21 03:04:03.186921-05
1055	216	es	15	2018-08-21 03:15:50.203427-05
1056	216	es	15	2018-08-21 03:16:51.694982-05
1057	216	es	3	2018-08-21 03:23:37.811448-05
1058	216	es	10	2018-08-21 03:27:17.425922-05
1059	216	es	4	2018-08-21 03:31:55.160632-05
1060	216	es	2	2018-08-21 03:36:25.934934-05
1061	216	es	2	2018-08-21 03:37:20.479075-05
1062	216	es	2	2018-08-21 03:38:04.41713-05
1063	216	es	14	2018-08-21 03:42:58.865327-05
1064	216	es	14	2018-08-21 03:43:30.58556-05
1065	218	es	5	2018-08-21 04:38:09.580085-05
1066	218	es	10	2018-08-21 04:42:50.809678-05
1067	218	es	10	2018-08-21 04:55:21.607731-05
1068	218	es	11	2018-08-21 04:58:15.83541-05
1069	218	es	6	2018-08-21 05:06:42.521487-05
1070	218	es	4	2018-08-21 05:10:32.847595-05
1071	218	es	4	2018-08-21 05:12:29.941424-05
1072	3	es	1	2018-10-04 13:17:59.369108-05
1073	3	es	1	2018-10-08 14:50:17.627352-05
1074	1	es	1	2018-10-08 16:14:58.601424-05
\.


--
-- Name: backend_rule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.backend_rule_id_seq', 1074, true);


--
-- Data for Name: backend_safetyprop; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.backend_safetyprop (id, type, owner_id, always, task, lastedit) FROM stdin;
48	1	1	f	1	2018-08-09 12:33:58.730979-05
35	2	1	f	1	2018-08-09 12:33:58.730979-05
49	2	1	t	1	2018-08-09 12:33:58.730979-05
50	2	1	f	1	2018-08-09 12:33:58.730979-05
51	1	1	f	1	2018-08-09 12:33:58.730979-05
52	2	1	f	1	2018-08-09 12:33:58.730979-05
36	2	1	t	1	2018-08-09 12:33:58.730979-05
53	2	1	t	1	2018-08-09 12:33:58.730979-05
54	2	1	t	1	2018-08-09 12:33:58.730979-05
55	3	1	f	1	2018-08-09 12:33:58.730979-05
56	3	1	f	1	2018-08-09 12:33:58.730979-05
57	3	1	f	1	2018-08-09 12:33:58.730979-05
58	3	1	f	1	2018-08-09 12:33:58.730979-05
59	3	1	f	1	2018-08-09 12:33:58.730979-05
63	3	1	f	1	2018-08-09 12:33:58.730979-05
72	1	1	f	1	2018-08-10 11:17:32.325939-05
109	3	7	t	1000	2018-08-14 11:04:39.800957-05
130	2	17	t	15	2018-08-16 19:06:03.657201-05
62	3	1	f	1	2018-08-09 14:01:20.148127-05
110	1	5	f	1	2018-08-15 19:19:23.843647-05
70	3	1	f	1	2018-08-09 15:56:44.829124-05
71	3	1	f	1	2018-08-09 15:58:28.520927-05
111	1	13	t	16	2018-08-15 19:20:25.905415-05
112	2	14	f	16	2018-08-15 19:22:24.237283-05
113	3	14	t	16	2018-08-15 19:23:23.963621-05
149	1	22	t	2	2018-08-16 19:21:19.29189-05
78	2	7	t	1000	2018-08-10 15:27:36.952202-05
169	3	17	t	8	2018-08-16 19:41:16.374707-05
115	1	16	f	3	2018-08-16 18:40:51.476287-05
80	2	12	f	6	2018-08-13 14:58:37.052699-05
81	3	3	f	1	2018-08-13 14:58:43.871563-05
82	3	3	f	1	2018-08-13 15:04:39.898537-05
83	3	3	f	1	2018-08-13 15:07:00.569345-05
84	3	3	t	1	2018-08-13 19:14:44.124497-05
85	3	3	f	1	2018-08-13 19:15:43.017907-05
86	3	3	f	1	2018-08-13 19:16:35.166309-05
87	2	3	f	1	2018-08-13 19:18:39.999214-05
88	3	3	f	1	2018-08-13 19:19:08.170958-05
89	3	3	f	1	2018-08-13 19:19:49.725453-05
90	2	3	f	1	2018-08-13 19:21:24.888995-05
91	2	3	t	1	2018-08-13 19:24:30.148927-05
116	1	16	f	8	2018-08-16 18:43:26.859413-05
117	2	20	f	11	2018-08-16 18:54:20.562987-05
133	2	21	t	10	2018-08-16 19:08:04.063415-05
148	1	23	t	14	2018-08-16 19:21:54.390412-05
95	2	3	f	1	2018-08-13 20:12:04.68657-05
170	3	17	t	8	2018-08-16 19:42:29.071286-05
96	2	3	f	1	2018-08-13 20:14:47.396366-05
97	2	3	f	1	2018-08-13 20:15:32.508309-05
98	2	3	t	1	2018-08-13 20:16:37.618138-05
99	1	3	f	1	2018-08-13 20:17:11.162331-05
100	1	3	f	1	2018-08-13 20:17:57.768119-05
101	3	12	f	3	2018-08-14 09:53:47.208081-05
102	3	12	f	4	2018-08-14 09:55:24.187186-05
103	3	12	f	15	2018-08-14 09:57:53.79615-05
104	2	12	f	2	2018-08-14 10:01:10.534858-05
105	1	12	f	13	2018-08-14 10:02:22.248104-05
106	2	12	t	9	2018-08-14 10:04:14.681674-05
107	2	12	t	9	2018-08-14 10:05:04.958717-05
108	2	12	f	5	2018-08-14 10:13:37.742578-05
118	2	20	f	6	2018-08-16 18:56:25.620529-05
150	2	21	t	8	2018-08-16 19:22:01.379755-05
151	3	25	f	10	2018-08-16 19:22:06.369243-05
136	2	20	f	15	2018-08-16 19:10:49.312115-05
123	2	20	f	16	2018-08-16 18:59:40.08119-05
152	2	21	t	4	2018-08-16 19:24:37.750168-05
137	3	25	t	4	2018-08-16 19:11:30.870594-05
153	3	22	f	9	2018-08-16 19:25:15.657675-05
138	2	21	t	16	2018-08-16 19:12:15.849752-05
139	2	20	f	10	2018-08-16 19:12:34.201935-05
154	2	23	t	9	2018-08-16 19:25:48.980416-05
126	2	20	t	2	2018-08-16 19:02:32.019589-05
127	2	20	t	2	2018-08-16 19:03:29.950943-05
155	3	17	t	7	2018-08-16 19:26:22.422953-05
128	2	21	f	7	2018-08-16 19:03:37.61299-05
129	2	20	t	2	2018-08-16 19:04:11.048808-05
156	3	21	f	11	2018-08-16 19:27:46.331714-05
141	2	20	f	4	2018-08-16 19:14:39.84796-05
157	2	25	f	5	2018-08-16 19:27:53.962783-05
158	2	23	t	5	2018-08-16 19:28:02.602796-05
159	3	22	f	11	2018-08-16 19:28:09.31368-05
143	1	21	f	12	2018-08-16 19:15:33.751452-05
144	3	23	f	4	2018-08-16 19:16:21.055951-05
160	3	29	f	16	2018-08-16 19:33:31.991755-05
145	2	25	f	6	2018-08-16 19:17:03.939688-05
147	3	17	f	10	2018-08-16 19:18:05.206322-05
171	3	29	t	6	2018-08-16 19:42:31.079443-05
161	3	17	t	11	2018-08-16 19:33:38.079636-05
162	3	23	t	7	2018-08-16 19:34:55.106699-05
163	3	29	t	16	2018-08-16 19:35:12.781507-05
164	1	22	t	8	2018-08-16 19:38:18.72937-05
165	3	25	f	14	2018-08-16 19:38:56.348655-05
166	1	23	f	8	2018-08-16 19:40:05.453162-05
167	1	23	f	8	2018-08-16 19:40:32.117981-05
168	1	23	f	8	2018-08-16 19:41:15.174258-05
172	3	22	t	5	2018-08-16 19:42:57.983647-05
177	2	23	t	2	2018-08-16 19:45:00.012352-05
183	3	22	f	4	2018-08-16 19:48:23.834898-05
174	2	29	f	6	2018-08-16 19:43:33.422906-05
175	3	17	t	8	2018-08-16 19:45:30.13093-05
173	3	17	t	8	2018-08-16 19:43:45.666039-05
176	3	25	f	7	2018-08-16 19:44:49.610344-05
178	2	31	t	11	2018-08-16 19:45:59.987289-05
179	3	17	t	8	2018-08-16 19:46:07.60225-05
180	1	29	f	12	2018-08-16 19:46:21.220472-05
181	3	17	t	8	2018-08-16 19:46:40.476377-05
182	3	22	f	4	2018-08-16 19:48:23.62926-05
185	2	31	t	12	2018-08-16 19:51:06.571922-05
186	2	31	t	12	2018-08-16 19:52:02.822531-05
187	2	31	t	12	2018-08-16 19:52:30.496629-05
188	1	29	f	2	2018-08-16 19:52:30.841062-05
189	1	17	f	2	2018-08-16 19:53:53.88266-05
190	1	29	f	14	2018-08-16 19:55:47.755063-05
191	1	31	f	2	2018-08-16 19:56:19.765329-05
192	2	17	t	2	2018-08-16 19:56:35.398767-05
193	2	31	f	7	2018-08-16 19:59:10.701899-05
194	2	17	t	5	2018-08-16 20:02:58.441709-05
195	1	29	f	9	2018-08-16 20:03:40.028258-05
196	1	29	f	9	2018-08-16 20:04:17.213697-05
197	2	31	f	8	2018-08-16 20:04:29.938564-05
198	2	31	f	8	2018-08-16 20:05:19.460863-05
199	2	31	f	8	2018-08-16 20:05:57.013009-05
200	3	17	t	5	2018-08-16 20:06:39.769179-05
201	2	31	t	3	2018-08-16 20:10:35.267859-05
202	2	34	t	2	2018-08-16 20:11:55.448322-05
203	2	34	f	7	2018-08-16 20:14:38.88785-05
204	2	31	f	5	2018-08-16 20:14:52.622967-05
205	3	34	t	16	2018-08-16 20:19:38.492575-05
206	3	34	f	11	2018-08-16 20:25:15.682898-05
207	3	34	t	3	2018-08-16 20:27:49.864735-05
208	1	36	t	3	2018-08-16 20:30:40.998651-05
209	2	34	t	9	2018-08-16 20:30:52.941944-05
210	2	35	t	3	2018-08-16 20:31:48.533292-05
211	3	34	t	9	2018-08-16 20:32:05.389537-05
212	1	35	t	3	2018-08-16 20:32:56.319925-05
213	1	34	t	5	2018-08-16 20:35:01.85151-05
214	3	36	t	6	2018-08-16 20:36:36.780233-05
236	2	38	f	5	2018-08-16 21:16:30.565888-05
237	2	35	f	15	2018-08-16 21:17:01.098386-05
215	2	36	f	15	2018-08-16 20:43:46.19347-05
292	1	53	t	12	2018-08-18 22:12:49.540292-05
216	1	38	f	3	2018-08-16 20:46:11.583198-05
217	3	38	f	3	2018-08-16 20:47:57.576643-05
275	2	53	t	2	2018-08-18 21:56:38.327447-05
219	2	38	f	10	2018-08-16 20:53:57.986906-05
220	2	36	t	16	2018-08-16 20:55:20.961026-05
242	1	35	f	15	2018-08-16 21:26:12.147079-05
243	1	38	f	8	2018-08-16 21:26:38.099369-05
244	1	38	f	8	2018-08-16 21:27:27.008358-05
245	1	38	f	8	2018-08-16 21:28:29.840184-05
218	2	36	f	16	2018-08-16 20:56:07.503593-05
221	3	35	t	16	2018-08-16 20:57:33.591621-05
222	1	38	f	10	2018-08-16 20:58:37.724183-05
223	2	35	f	16	2018-08-16 20:58:43.26132-05
224	1	36	t	16	2018-08-16 20:59:19.314768-05
225	1	35	f	12	2018-08-16 21:03:09.151777-05
226	1	35	f	12	2018-08-16 21:03:27.712606-05
227	1	35	f	12	2018-08-16 21:03:47.089657-05
228	3	38	f	11	2018-08-16 21:04:02.62558-05
230	2	36	t	9	2018-08-16 21:04:57.682648-05
231	2	36	t	9	2018-08-16 21:06:00.257035-05
232	3	38	f	11	2018-08-16 21:06:37.760348-05
277	3	30	f	4	2018-08-18 21:57:41.798847-05
229	2	38	f	11	2018-08-16 21:06:57.051982-05
278	2	52	t	10	2018-08-18 21:57:52.466472-05
246	2	38	t	8	2018-08-16 21:30:40.116115-05
233	2	36	f	7	2018-08-16 21:12:27.400151-05
247	2	35	t	15	2018-08-16 21:33:30.995531-05
235	2	36	t	4	2018-08-16 21:14:54.902324-05
248	2	35	t	2	2018-08-16 21:35:57.140986-05
249	2	35	t	2	2018-08-16 21:36:27.423421-05
234	2	38	f	5	2018-08-16 21:15:45.326621-05
250	2	35	t	2	2018-08-16 21:36:56.288836-05
251	2	35	t	2	2018-08-16 21:37:34.407268-05
252	2	35	t	2	2018-08-16 21:38:03.348389-05
253	2	35	t	2	2018-08-16 21:38:21.856696-05
254	1	38	f	6	2018-08-16 21:41:25.776967-05
279	3	51	f	8	2018-08-18 21:58:01.150176-05
255	2	38	t	6	2018-08-16 21:43:18.585685-05
293	3	56	f	5	2018-08-18 22:14:02.839713-05
276	3	51	f	8	2018-08-18 21:58:26.470538-05
258	1	38	f	15	2018-08-16 21:54:55.286948-05
259	1	38	t	15	2018-08-16 21:57:01.374321-05
260	3	7	t	1000	2018-08-17 12:15:34.083442-05
280	3	51	f	8	2018-08-18 21:59:10.6866-05
261	2	7	f	1000	2018-08-17 12:17:58.207164-05
262	1	5	t	1	2018-08-17 15:07:48.660514-05
263	1	3	t	1	2018-08-17 16:36:05.917296-05
264	2	3	f	1	2018-08-17 17:26:14.035629-05
265	2	3	t	1	2018-08-18 19:43:00.402159-05
309	2	62	t	14	2018-08-18 22:25:57.219639-05
266	2	3	f	1	2018-08-18 19:43:15.51108-05
267	2	3	t	1	2018-08-18 19:43:35.797328-05
268	2	3	f	1	2018-08-18 19:44:04.069907-05
269	1	5	t	1	2018-08-18 20:03:01.392486-05
270	3	30	f	10	2018-08-18 21:48:35.865546-05
271	3	30	f	9	2018-08-18 21:51:22.609137-05
272	1	30	f	2	2018-08-18 21:53:35.804051-05
273	3	30	f	3	2018-08-18 21:55:29.829668-05
282	3	30	f	11	2018-08-18 21:59:36.854014-05
294	2	58	f	7	2018-08-18 22:15:26.450367-05
281	2	53	t	5	2018-08-18 21:59:51.977614-05
283	3	30	f	5	2018-08-18 22:01:10.702331-05
296	1	53	t	15	2018-08-18 22:16:42.232258-05
297	3	52	t	16	2018-08-18 22:17:47.747343-05
298	3	56	t	12	2018-08-18 22:18:41.201279-05
299	3	51	f	15	2018-08-18 22:19:01.908351-05
285	1	53	f	8	2018-08-18 22:05:10.93806-05
300	3	56	t	12	2018-08-18 22:20:00.228542-05
286	2	51	f	7	2018-08-18 22:05:25.759419-05
287	3	52	t	16	2018-08-18 22:07:35.808831-05
288	3	56	f	3	2018-08-18 22:07:50.72257-05
289	1	53	t	3	2018-08-18 22:08:13.587905-05
290	2	51	f	6	2018-08-18 22:10:02.329095-05
291	1	53	t	14	2018-08-18 22:10:39.311513-05
301	3	56	t	12	2018-08-18 22:20:37.123817-05
302	3	51	t	2	2018-08-18 22:21:45.627377-05
303	1	52	f	14	2018-08-18 22:21:57.876743-05
304	3	52	f	14	2018-08-18 22:22:47.495266-05
305	1	52	t	14	2018-08-18 22:23:22.026857-05
306	3	56	f	14	2018-08-18 22:25:31.712535-05
307	2	51	t	4	2018-08-18 22:25:35.596356-05
308	2	60	f	7	2018-08-18 22:25:52.271327-05
311	1	52	f	12	2018-08-18 22:26:41.894686-05
312	1	52	t	12	2018-08-18 22:27:31.399272-05
313	2	52	f	12	2018-08-18 22:28:36.542498-05
314	1	51	f	12	2018-08-18 22:28:38.333226-05
318	3	56	f	8	2018-08-18 22:30:25.264852-05
315	2	62	f	7	2018-08-18 22:29:26.830151-05
316	3	56	f	8	2018-08-18 22:29:42.147602-05
321	3	56	f	8	2018-08-18 22:31:05.94636-05
317	3	60	f	8	2018-08-18 22:33:18.629029-05
319	2	58	f	5	2018-08-18 22:32:46.957238-05
324	1	52	t	3	2018-08-18 22:33:26.434506-05
323	3	60	f	8	2018-08-18 22:32:26.256588-05
325	1	52	t	3	2018-08-18 22:34:48.526622-05
322	3	60	f	8	2018-08-18 22:32:59.951249-05
326	2	56	t	2	2018-08-18 22:34:56.451288-05
327	1	62	t	3	2018-08-18 22:35:15.772535-05
328	1	62	t	3	2018-08-18 22:36:11.056833-05
329	1	63	f	6	2018-08-18 22:37:02.630098-05
330	2	65	t	9	2018-08-18 22:37:10.969807-05
331	2	58	f	11	2018-08-18 22:37:20.383892-05
332	3	58	f	11	2018-08-18 22:37:57.266838-05
333	2	52	f	4	2018-08-18 22:37:59.084619-05
334	3	56	f	4	2018-08-18 22:38:06.554303-05
335	2	52	t	4	2018-08-18 22:38:28.703497-05
336	3	65	t	9	2018-08-18 22:38:52.832936-05
337	2	60	t	11	2018-08-18 22:38:56.815443-05
338	2	52	f	4	2018-08-18 22:39:30.82481-05
339	2	63	t	14	2018-08-18 22:40:25.980299-05
340	3	56	t	4	2018-08-18 22:40:26.693669-05
341	1	52	t	4	2018-08-18 22:40:31.521757-05
342	2	62	t	5	2018-08-18 22:41:45.031054-05
343	3	58	f	14	2018-08-18 22:44:01.989968-05
344	3	52	t	8	2018-08-18 22:44:26.153005-05
421	2	7	f	1000	2018-08-19 14:00:02.639736-05
347	3	63	f	5	2018-08-18 22:45:03.039868-05
348	1	58	f	14	2018-08-18 22:45:56.325805-05
349	1	52	f	8	2018-08-18 22:45:57.936225-05
346	1	52	f	8	2018-08-18 22:46:51.694138-05
350	2	63	f	4	2018-08-18 22:47:11.305702-05
351	2	58	f	14	2018-08-18 22:47:15.005319-05
352	2	52	t	8	2018-08-18 22:48:41.420016-05
353	1	63	f	12	2018-08-18 22:50:43.897358-05
354	1	62	t	5	2018-08-18 22:51:04.158093-05
391	2	66	f	15	2018-08-18 23:38:38.606611-05
356	1	60	f	12	2018-08-18 22:54:06.632844-05
392	2	66	t	10	2018-08-18 23:42:35.417251-05
355	2	63	f	16	2018-08-18 22:54:28.755474-05
357	1	62	t	9	2018-08-18 22:54:39.652829-05
358	1	62	t	9	2018-08-18 22:55:43.477753-05
359	3	62	t	9	2018-08-18 22:56:42.734212-05
393	1	67	f	9	2018-08-18 23:44:38.225765-05
394	1	66	t	3	2018-08-18 23:45:53.665218-05
360	3	63	t	8	2018-08-18 22:57:35.881635-05
362	3	63	t	8	2018-08-18 22:59:13.575142-05
363	2	62	f	11	2018-08-18 22:59:29.916943-05
395	3	67	t	14	2018-08-18 23:50:54.677559-05
361	3	63	t	8	2018-08-18 22:59:33.29044-05
396	3	69	f	5	2018-08-18 23:55:02.082927-05
364	2	58	f	6	2018-08-18 23:00:57.830821-05
365	2	60	t	14	2018-08-18 23:01:50.093096-05
366	3	60	t	14	2018-08-18 23:02:26.886794-05
367	3	62	t	10	2018-08-18 23:02:27.796961-05
368	2	62	t	10	2018-08-18 23:02:53.500037-05
369	1	65	t	8	2018-08-18 23:05:33.875914-05
370	1	65	t	8	2018-08-18 23:07:26.5123-05
371	1	65	f	8	2018-08-18 23:08:03.405949-05
372	1	65	f	8	2018-08-18 23:09:11.995348-05
374	3	60	t	3	2018-08-18 23:16:26.38248-05
397	2	67	f	4	2018-08-18 23:56:39.03508-05
375	2	65	f	6	2018-08-18 23:17:04.753033-05
376	3	60	f	3	2018-08-18 23:17:18.972897-05
377	3	58	t	15	2018-08-18 23:18:29.38356-05
398	2	69	f	5	2018-08-18 23:57:22.997577-05
378	3	58	t	15	2018-08-18 23:20:07.38155-05
379	3	58	f	15	2018-08-18 23:21:57.102928-05
399	3	67	f	10	2018-08-18 23:58:22.216897-05
381	3	60	f	4	2018-08-18 23:22:36.279213-05
380	1	66	t	14	2018-08-18 23:23:08.340854-05
382	2	58	t	15	2018-08-18 23:25:24.024775-05
383	3	65	f	3	2018-08-18 23:25:49.162393-05
384	2	66	t	11	2018-08-18 23:26:58.309924-05
385	2	65	t	2	2018-08-18 23:29:24.648241-05
400	1	69	f	5	2018-08-18 23:59:24.474319-05
386	2	66	f	6	2018-08-18 23:29:41.284856-05
387	2	65	t	2	2018-08-18 23:31:28.736238-05
388	2	58	f	10	2018-08-18 23:32:46.239755-05
389	3	58	f	10	2018-08-18 23:33:41.298812-05
401	3	67	f	5	2018-08-19 00:00:24.840457-05
422	2	7	t	1000	2018-08-19 14:03:04.35992-05
402	1	69	t	2	2018-08-19 00:01:13.954659-05
403	2	69	f	2	2018-08-19 00:01:56.052678-05
404	2	69	f	2	2018-08-19 00:03:00.621337-05
405	1	67	t	16	2018-08-19 00:03:37.250838-05
406	2	67	t	8	2018-08-19 00:07:39.58131-05
423	2	7	t	1000	2018-08-19 14:04:18.81536-05
407	3	74	t	16	2018-08-19 01:41:03.936566-05
408	1	74	f	14	2018-08-19 01:43:26.713938-05
409	2	74	f	6	2018-08-19 01:47:00.617968-05
410	1	74	f	12	2018-08-19 01:50:20.646465-05
425	3	7	f	1000	2018-08-19 14:06:39.995668-05
411	3	74	f	4	2018-08-19 01:54:18.967393-05
412	3	74	f	5	2018-08-19 01:56:58.391917-05
413	3	74	f	10	2018-08-19 01:58:27.310875-05
426	3	7	f	1000	2018-08-19 14:07:14.109986-05
416	2	75	f	4	2018-08-19 02:08:28.581162-05
417	1	7	f	1000	2018-08-19 13:52:45.631446-05
418	1	7	f	1000	2018-08-19 13:53:57.792561-05
419	2	7	f	1000	2018-08-19 13:55:16.273327-05
427	3	7	f	1000	2018-08-19 14:08:47.564772-05
420	2	7	f	1000	2018-08-19 13:59:19.62955-05
428	3	7	f	1000	2018-08-19 14:09:32.913028-05
429	3	7	f	1000	2018-08-19 14:10:40.224789-05
430	3	7	t	1000	2018-08-19 14:13:56.618183-05
431	3	3	t	1	2018-08-19 14:34:42.860659-05
432	2	78	f	10	2018-08-19 18:50:14.973049-05
439	2	85	t	5	2018-08-19 19:01:48.619839-05
448	2	86	t	10	2018-08-19 19:09:21.311824-05
433	3	84	t	4	2018-08-19 18:54:08.838922-05
434	3	83	t	12	2018-08-19 18:57:57.49467-05
435	3	83	t	12	2018-08-19 18:58:39.461648-05
436	3	83	t	12	2018-08-19 18:59:06.92096-05
437	1	86	f	12	2018-08-19 19:00:36.879199-05
438	1	87	t	14	2018-08-19 19:00:37.677303-05
441	2	87	t	10	2018-08-19 19:04:49.496306-05
454	1	92	t	8	2018-08-19 19:12:31.030801-05
440	3	86	t	8	2018-08-19 19:04:55.599539-05
442	2	83	f	11	2018-08-19 19:05:27.119992-05
443	3	86	t	8	2018-08-19 19:06:12.171257-05
444	1	87	t	3	2018-08-19 19:07:36.324279-05
445	2	92	t	8	2018-08-19 19:08:12.350278-05
446	2	83	f	6	2018-08-19 19:08:14.59971-05
447	3	84	t	2	2018-08-19 19:08:48.042737-05
451	1	3	t	1	2018-08-19 19:12:02.820632-05
455	2	3	f	1	2018-08-19 19:12:52.731007-05
452	2	86	f	6	2018-08-19 19:12:08.179159-05
453	1	87	f	4	2018-08-19 19:12:10.197468-05
456	3	87	f	4	2018-08-19 19:12:54.954757-05
457	2	83	f	5	2018-08-19 19:13:04.12958-05
458	1	92	t	8	2018-08-19 19:13:38.554335-05
459	2	83	f	5	2018-08-19 19:13:57.327767-05
460	1	3	f	1	2018-08-19 19:14:17.391634-05
461	3	92	t	8	2018-08-19 19:14:17.882997-05
462	2	84	f	12	2018-08-19 19:14:25.174132-05
463	2	95	f	6	2018-08-19 19:14:39.709157-05
464	2	87	f	7	2018-08-19 19:17:09.233699-05
465	1	93	t	8	2018-08-19 19:17:46.924755-05
466	1	84	t	10	2018-08-19 19:17:49.500788-05
467	3	83	t	3	2018-08-19 19:18:06.848406-05
468	2	92	t	5	2018-08-19 19:18:54.960003-05
469	1	86	f	15	2018-08-19 19:18:55.130989-05
470	2	3	f	1	2018-08-19 19:20:02.819535-05
471	1	87	f	12	2018-08-19 19:20:12.46487-05
472	2	95	t	9	2018-08-19 19:20:17.930068-05
473	2	83	t	9	2018-08-19 19:21:07.513555-05
474	3	84	t	8	2018-08-19 19:21:21.622124-05
475	1	86	t	15	2018-08-19 19:21:53.469149-05
476	2	83	t	9	2018-08-19 19:21:59.745475-05
527	3	100	t	7	2018-08-19 19:41:23.860883-05
477	2	95	t	7	2018-08-19 19:22:01.385239-05
478	3	84	t	8	2018-08-19 19:22:11.075806-05
479	3	87	t	6	2018-08-19 19:22:33.552003-05
480	2	83	t	9	2018-08-19 19:22:36.642958-05
557	3	98	f	14	2018-08-19 20:03:23.307322-05
482	3	86	f	4	2018-08-19 19:23:31.493068-05
483	3	95	f	11	2018-08-19 19:23:43.580917-05
484	2	86	t	4	2018-08-19 19:24:01.117616-05
486	3	86	t	4	2018-08-19 19:24:44.265682-05
528	1	92	f	12	2018-08-19 19:42:13.873896-05
488	3	95	f	10	2018-08-19 19:25:57.55841-05
489	2	98	f	15	2018-08-19 19:25:58.135945-05
529	1	92	f	12	2018-08-19 19:42:35.595488-05
530	1	92	f	12	2018-08-19 19:42:59.951557-05
531	2	98	f	8	2018-08-19 19:43:20.424193-05
487	2	93	f	5	2018-08-19 19:26:26.894195-05
490	3	83	t	2	2018-08-19 19:26:28.075707-05
492	2	100	f	5	2018-08-19 19:27:09.89084-05
493	2	95	t	5	2018-08-19 19:28:20.383669-05
532	2	101	f	8	2018-08-19 19:43:46.651609-05
495	2	86	t	9	2018-08-19 19:28:28.592134-05
496	2	98	t	15	2018-08-19 19:28:49.375585-05
498	1	86	f	9	2018-08-19 19:29:05.354786-05
499	3	100	f	5	2018-08-19 19:29:33.661536-05
500	3	92	t	16	2018-08-19 19:29:41.503869-05
501	2	95	f	4	2018-08-19 19:30:07.436851-05
502	2	86	f	9	2018-08-19 19:30:23.497937-05
503	3	100	f	5	2018-08-19 19:30:25.101114-05
533	2	93	t	2	2018-08-19 19:43:48.333551-05
497	3	101	f	3	2018-08-19 19:31:04.137381-05
504	2	93	t	4	2018-08-19 19:31:38.73033-05
505	3	98	f	12	2018-08-19 19:31:52.163734-05
558	1	106	t	8	2018-08-19 20:03:45.474581-05
534	3	100	f	11	2018-08-19 19:44:02.273236-05
508	3	92	t	11	2018-08-19 19:33:19.133887-05
509	2	100	f	5	2018-08-19 19:33:26.032642-05
511	2	92	t	10	2018-08-19 19:35:16.669059-05
512	2	100	f	5	2018-08-19 19:35:20.681019-05
559	3	100	t	6	2018-08-19 20:04:18.363946-05
510	2	98	f	12	2018-08-19 19:35:39.30802-05
513	2	100	f	5	2018-08-19 19:35:47.328844-05
514	2	100	f	5	2018-08-19 19:36:10.774598-05
560	1	106	t	8	2018-08-19 20:04:46.661965-05
516	3	101	t	9	2018-08-19 19:36:18.244946-05
561	3	100	f	10	2018-08-19 20:07:34.024155-05
520	1	92	f	2	2018-08-19 19:38:00.023362-05
521	1	92	t	2	2018-08-19 19:38:51.879337-05
562	3	105	t	6	2018-08-19 20:08:03.166033-05
523	1	92	t	2	2018-08-19 19:39:42.672283-05
524	1	92	t	2	2018-08-19 19:40:15.160871-05
525	2	93	f	11	2018-08-19 19:40:23.161999-05
536	2	98	f	8	2018-08-19 19:46:10.229486-05
537	2	93	f	10	2018-08-19 19:46:55.783722-05
538	1	98	f	2	2018-08-19 19:49:37.708538-05
539	3	100	t	16	2018-08-19 19:49:53.097617-05
590	1	103	f	8	2018-08-19 21:05:22.94307-05
541	2	101	t	14	2018-08-19 19:50:29.795894-05
564	2	98	t	4	2018-08-19 20:08:57.138233-05
542	3	103	f	4	2018-08-19 19:51:49.549628-05
543	3	101	f	11	2018-08-19 19:52:45.733213-05
544	2	98	t	2	2018-08-19 19:52:51.656363-05
545	2	98	t	2	2018-08-19 19:54:02.282191-05
546	3	93	f	16	2018-08-19 19:54:17.050063-05
579	2	106	f	6	2018-08-19 20:24:01.60248-05
548	1	101	f	12	2018-08-19 19:54:47.13059-05
566	3	106	t	3	2018-08-19 20:08:58.717794-05
567	2	98	t	4	2018-08-19 20:10:04.677363-05
550	2	98	f	10	2018-08-19 19:57:33.34882-05
551	2	100	t	9	2018-08-19 19:59:22.079518-05
552	3	101	t	16	2018-08-19 20:00:02.092567-05
554	3	100	f	9	2018-08-19 20:00:34.764761-05
555	3	105	f	10	2018-08-19 20:02:06.755789-05
556	2	98	t	14	2018-08-19 20:02:35.971564-05
580	3	105	t	8	2018-08-19 20:29:14.243385-05
568	2	106	t	5	2018-08-19 20:11:30.217584-05
569	2	106	f	11	2018-08-19 20:13:03.374767-05
570	3	106	t	2	2018-08-19 20:15:03.350021-05
571	3	106	t	2	2018-08-19 20:15:33.758042-05
572	3	106	t	2	2018-08-19 20:16:08.393126-05
581	3	105	f	8	2018-08-19 20:31:47.472975-05
574	3	106	t	2	2018-08-19 20:18:31.8502-05
582	3	105	t	8	2018-08-19 20:33:02.015188-05
573	3	105	t	16	2018-08-19 20:18:38.293212-05
575	3	106	t	12	2018-08-19 20:21:15.491365-05
576	3	106	t	12	2018-08-19 20:21:32.302921-05
577	3	106	t	12	2018-08-19 20:21:53.226702-05
578	3	105	t	7	2018-08-19 20:22:00.647244-05
591	1	103	f	8	2018-08-19 21:05:58.654375-05
583	3	105	t	8	2018-08-19 20:36:00.164489-05
584	3	103	f	5	2018-08-19 20:38:44.160505-05
585	1	103	t	3	2018-08-19 20:51:29.632568-05
586	2	105	f	15	2018-08-19 20:54:30.202416-05
592	2	103	t	10	2018-08-19 21:20:54.748708-05
593	1	103	f	16	2018-08-19 21:26:53.736946-05
587	2	105	f	11	2018-08-19 21:01:21.22261-05
588	1	114	f	12	2018-08-19 21:02:51.99076-05
589	1	103	f	8	2018-08-19 21:03:25.370128-05
594	3	103	f	14	2018-08-19 21:28:56.271143-05
598	2	7	t	1000	2018-08-20 10:16:58.778588-05
596	3	7	f	1000	2018-08-19 23:19:48.593144-05
597	1	124	f	14	2018-08-20 10:16:58.059154-05
599	2	3	t	1	2018-08-20 10:29:51.677806-05
600	2	3	f	1	2018-08-20 10:30:22.927269-05
601	1	126	f	1	2018-08-20 11:53:50.834783-05
602	1	126	f	1	2018-08-20 11:57:19.72748-05
603	1	134	f	12	2018-08-20 13:10:02.36492-05
604	1	134	f	12	2018-08-20 13:10:51.169875-05
605	1	134	f	12	2018-08-20 13:11:34.464705-05
606	3	139	t	6	2018-08-20 13:29:11.915193-05
607	2	142	t	10	2018-08-20 13:36:49.917771-05
608	3	139	t	16	2018-08-20 13:36:52.25922-05
609	2	140	f	14	2018-08-20 13:37:48.208522-05
610	3	142	t	16	2018-08-20 13:40:26.572387-05
613	3	142	t	14	2018-08-20 13:42:04.192506-05
612	3	139	t	10	2018-08-20 13:43:57.269042-05
614	3	140	t	16	2018-08-20 13:43:52.88713-05
615	3	142	t	6	2018-08-20 13:44:11.032513-05
616	2	140	f	16	2018-08-20 13:46:07.039105-05
617	2	134	f	15	2018-08-20 13:46:12.989622-05
618	1	142	f	3	2018-08-20 13:46:20.112076-05
619	3	142	t	7	2018-08-20 13:48:05.130357-05
620	3	139	t	2	2018-08-20 13:48:46.178351-05
621	1	140	f	3	2018-08-20 13:49:17.753685-05
622	3	139	t	2	2018-08-20 13:49:44.334105-05
623	1	142	f	9	2018-08-20 13:50:49.348034-05
624	1	142	t	9	2018-08-20 13:51:29.455912-05
625	1	140	f	8	2018-08-20 13:54:03.118042-05
626	2	139	t	4	2018-08-20 13:55:11.941414-05
627	3	140	f	11	2018-08-20 13:57:02.485487-05
628	2	140	t	11	2018-08-20 13:57:36.431228-05
671	2	154	f	7	2018-08-20 16:08:45.415765-05
629	2	139	f	7	2018-08-20 13:57:58.437773-05
630	3	140	t	4	2018-08-20 14:00:42.264536-05
631	3	140	t	6	2018-08-20 14:04:34.8091-05
632	2	140	f	6	2018-08-20 14:05:18.365442-05
633	3	146	f	10	2018-08-20 14:05:30.135488-05
634	1	146	f	12	2018-08-20 14:10:00.695624-05
672	2	154	t	2	2018-08-20 16:11:18.439414-05
635	2	146	f	16	2018-08-20 14:16:38.193308-05
636	2	146	f	6	2018-08-20 14:20:17.234329-05
637	1	146	f	2	2018-08-20 14:23:35.566855-05
638	1	146	f	3	2018-08-20 14:27:59.503364-05
673	2	154	t	2	2018-08-20 16:12:06.488624-05
640	3	149	f	4	2018-08-20 14:39:21.157291-05
641	2	149	t	10	2018-08-20 14:41:49.774937-05
642	3	149	t	7	2018-08-20 14:43:47.879206-05
643	3	149	t	6	2018-08-20 14:46:51.095987-05
644	1	149	t	12	2018-08-20 14:49:23.468705-05
645	2	149	t	2	2018-08-20 14:50:45.104417-05
646	2	149	t	2	2018-08-20 14:50:59.41311-05
647	2	149	t	2	2018-08-20 14:51:17.465079-05
648	1	149	t	14	2018-08-20 14:52:47.761762-05
649	1	151	f	3	2018-08-20 15:10:35.427313-05
650	1	151	t	14	2018-08-20 15:13:00.892408-05
674	2	154	t	2	2018-08-20 16:12:44.513244-05
653	3	146	f	15	2018-08-20 15:15:28.057465-05
675	2	154	f	10	2018-08-20 16:15:05.688104-05
651	3	152	t	8	2018-08-20 15:15:30.923469-05
652	3	152	t	8	2018-08-20 15:15:48.928479-05
676	2	154	f	6	2018-08-20 16:17:01.134415-05
677	1	154	f	12	2018-08-20 16:19:23.257197-05
654	3	152	t	8	2018-08-20 15:17:18.28543-05
656	1	151	t	8	2018-08-20 15:21:13.339102-05
658	2	151	t	4	2018-08-20 15:23:45.276793-05
657	3	152	f	11	2018-08-20 15:24:57.027928-05
659	1	151	t	7	2018-08-20 15:28:07.651126-05
660	2	152	t	5	2018-08-20 15:28:31.257441-05
661	2	151	t	10	2018-08-20 15:30:43.309227-05
662	2	152	f	6	2018-08-20 15:33:25.967081-05
663	1	152	t	9	2018-08-20 15:36:46.436337-05
664	2	152	f	9	2018-08-20 15:38:00.566977-05
665	1	152	f	15	2018-08-20 15:41:50.49085-05
666	2	152	t	15	2018-08-20 15:43:39.340169-05
667	1	152	f	12	2018-08-20 15:47:13.194991-05
668	2	154	f	16	2018-08-20 15:55:58.91745-05
669	2	154	f	15	2018-08-20 16:01:49.279794-05
670	3	154	f	15	2018-08-20 16:06:43.485514-05
714	3	162	f	11	2018-08-20 19:00:08.326353-05
689	3	7	t	1000	2018-08-20 17:39:24.140349-05
690	3	7	t	1000	2018-08-20 17:39:24.301143-05
691	3	7	t	1000	2018-08-20 17:39:24.476163-05
692	3	7	t	1000	2018-08-20 17:39:24.624704-05
693	3	7	t	1000	2018-08-20 17:39:24.786102-05
694	3	7	t	1000	2018-08-20 17:39:24.934235-05
695	3	7	t	1000	2018-08-20 17:39:25.086512-05
696	3	7	t	1000	2018-08-20 17:39:25.242569-05
697	3	7	t	1000	2018-08-20 17:39:25.401727-05
698	3	7	t	1000	2018-08-20 17:40:58.793897-05
699	3	7	t	1000	2018-08-20 17:42:42.006108-05
700	2	157	t	15	2018-08-20 18:32:21.117953-05
701	1	157	f	5	2018-08-20 18:38:33.604956-05
715	2	159	t	4	2018-08-20 19:02:37.408412-05
716	2	159	t	14	2018-08-20 19:06:49.968385-05
702	2	159	f	7	2018-08-20 18:39:36.853896-05
703	3	157	f	6	2018-08-20 18:41:06.349742-05
704	2	157	t	7	2018-08-20 18:45:02.657082-05
705	3	157	f	4	2018-08-20 18:48:12.509193-05
706	1	157	t	3	2018-08-20 18:50:32.362133-05
707	2	159	t	9	2018-08-20 18:50:49.224802-05
708	2	157	f	14	2018-08-20 18:52:42.421021-05
709	1	162	f	3	2018-08-20 18:52:56.349141-05
717	3	163	t	6	2018-08-20 19:08:31.143864-05
711	3	162	t	2	2018-08-20 18:57:45.317681-05
712	3	160	f	4	2018-08-20 18:58:12.741538-05
713	3	159	t	6	2018-08-20 19:00:03.515635-05
718	3	160	t	6	2018-08-20 19:10:14.069695-05
720	2	159	t	8	2018-08-20 19:12:52.688733-05
730	3	163	t	14	2018-08-20 19:26:26.496163-05
719	2	159	f	8	2018-08-20 19:13:10.129835-05
721	3	163	f	5	2018-08-20 19:14:15.926441-05
738	2	166	f	12	2018-08-20 19:33:16.088099-05
723	3	163	f	11	2018-08-20 19:16:58.730686-05
724	2	166	f	11	2018-08-20 19:18:00.432031-05
731	2	166	t	9	2018-08-20 19:26:55.16527-05
725	2	159	f	11	2018-08-20 19:20:05.289653-05
726	3	166	t	7	2018-08-20 19:20:26.868252-05
727	3	163	f	4	2018-08-20 19:21:28.083844-05
728	1	166	f	14	2018-08-20 19:23:11.064542-05
733	2	166	t	3	2018-08-20 19:29:48.086956-05
734	2	163	f	8	2018-08-20 19:31:15.469713-05
735	1	160	f	15	2018-08-20 19:31:27.002586-05
743	1	160	f	12	2018-08-20 19:40:04.976906-05
746	1	160	f	8	2018-08-20 19:44:36.295453-05
737	2	166	f	12	2018-08-20 19:32:49.228029-05
739	2	166	f	12	2018-08-20 19:34:00.069223-05
745	3	162	f	16	2018-08-20 19:43:25.438998-05
740	2	166	f	16	2018-08-20 19:36:44.981058-05
741	2	163	t	9	2018-08-20 19:38:23.364757-05
742	2	162	t	8	2018-08-20 19:39:43.307758-05
747	2	160	f	8	2018-08-20 19:46:35.040368-05
744	3	162	t	16	2018-08-20 19:43:46.268685-05
748	1	162	f	17	2018-08-20 19:47:13.782817-05
749	2	160	f	8	2018-08-20 19:47:52.88809-05
750	3	162	f	5	2018-08-20 19:50:16.365697-05
751	3	160	f	10	2018-08-20 19:52:32.454064-05
753	2	168	f	12	2018-08-20 19:55:36.168373-05
752	3	168	f	12	2018-08-20 19:55:58.405514-05
754	2	160	f	11	2018-08-20 19:57:11.254112-05
757	3	168	t	7	2018-08-20 20:04:12.840084-05
758	2	170	t	14	2018-08-20 20:09:17.331932-05
759	1	168	f	15	2018-08-20 20:13:35.963294-05
761	2	170	t	7	2018-08-20 20:16:28.439405-05
763	2	168	f	16	2018-08-20 20:20:46.326179-05
766	1	168	t	2	2018-08-20 20:25:52.12672-05
767	2	170	t	3	2018-08-20 20:26:50.438813-05
769	2	170	t	5	2018-08-20 20:31:42.151913-05
770	1	168	f	8	2018-08-20 20:36:00.104998-05
771	3	170	t	16	2018-08-20 20:37:32.199587-05
772	2	168	f	6	2018-08-20 20:39:29.670415-05
774	1	173	t	16	2018-08-20 20:47:59.560762-05
856	3	182	f	11	2018-08-20 21:48:37.122965-05
821	2	193	t	11	2018-08-20 21:30:49.08191-05
822	3	189	t	16	2018-08-20 21:31:21.44187-05
777	1	173	t	9	2018-08-20 20:52:50.708692-05
823	2	194	t	5	2018-08-20 21:31:50.499252-05
776	2	170	t	15	2018-08-20 20:53:33.016991-05
778	3	173	t	7	2018-08-20 20:56:19.731889-05
779	2	170	t	2	2018-08-20 20:57:34.210277-05
780	1	173	t	3	2018-08-20 20:59:32.7424-05
781	2	175	t	10	2018-08-20 21:01:52.761468-05
782	1	174	f	16	2018-08-20 21:02:20.480529-05
783	3	173	t	11	2018-08-20 21:02:22.020182-05
784	3	175	f	10	2018-08-20 21:02:24.514931-05
785	3	174	f	11	2018-08-20 21:04:40.143492-05
786	1	173	t	14	2018-08-20 21:05:02.596946-05
824	3	192	t	12	2018-08-20 21:31:52.545451-05
788	2	174	f	14	2018-08-20 21:07:25.678952-05
789	2	173	t	15	2018-08-20 21:07:55.313289-05
825	3	189	f	16	2018-08-20 21:32:43.351712-05
787	3	175	t	16	2018-08-20 21:08:36.930451-05
826	3	175	f	4	2018-08-20 21:33:14.129682-05
791	2	175	f	16	2018-08-20 21:09:28.649403-05
792	2	174	f	4	2018-08-20 21:09:32.106359-05
793	3	182	f	5	2018-08-20 21:10:10.412987-05
827	3	175	t	4	2018-08-20 21:34:09.70459-05
790	2	184	t	14	2018-08-20 21:10:19.555807-05
794	3	175	f	16	2018-08-20 21:10:31.835638-05
795	3	184	f	4	2018-08-20 21:14:13.556294-05
828	2	184	f	6	2018-08-20 21:34:29.785927-05
799	2	174	f	15	2018-08-20 21:16:33.077258-05
800	3	184	f	11	2018-08-20 21:16:33.762122-05
829	2	194	t	11	2018-08-20 21:34:45.775569-05
797	3	187	f	4	2018-08-20 21:16:52.140135-05
830	3	175	t	4	2018-08-20 21:34:56.863421-05
798	3	175	f	15	2018-08-20 21:17:00.885602-05
801	2	184	t	11	2018-08-20 21:17:32.185017-05
831	3	187	t	2	2018-08-20 21:35:28.160364-05
803	1	175	f	12	2018-08-20 21:20:44.658935-05
804	3	184	t	16	2018-08-20 21:21:13.481755-05
805	2	189	t	2	2018-08-20 21:22:21.352607-05
806	1	174	f	7	2018-08-20 21:22:28.97425-05
808	2	189	t	2	2018-08-20 21:23:39.604126-05
809	1	174	t	9	2018-08-20 21:24:21.267309-05
810	2	189	t	2	2018-08-20 21:25:16.911619-05
811	2	175	t	14	2018-08-20 21:25:40.917938-05
812	3	175	f	14	2018-08-20 21:26:05.063564-05
832	3	184	f	6	2018-08-20 21:35:31.091729-05
814	2	193	f	16	2018-08-20 21:28:27.226666-05
833	2	195	f	15	2018-08-20 21:36:12.150624-05
815	2	175	f	6	2018-08-20 21:28:40.579776-05
816	3	187	t	14	2018-08-20 21:28:50.2826-05
817	1	182	t	6	2018-08-20 21:28:54.980779-05
818	2	184	f	5	2018-08-20 21:29:01.485406-05
819	2	184	f	5	2018-08-20 21:29:33.180449-05
834	1	182	f	16	2018-08-20 21:36:33.526801-05
835	3	189	t	7	2018-08-20 21:36:52.312534-05
836	1	193	f	15	2018-08-20 21:38:50.449656-05
837	3	187	t	9	2018-08-20 21:39:05.86638-05
838	3	189	f	11	2018-08-20 21:39:32.25991-05
839	3	187	t	9	2018-08-20 21:40:32.641387-05
840	2	184	t	8	2018-08-20 21:40:44.939272-05
841	2	193	t	14	2018-08-20 21:41:23.606425-05
842	3	197	t	7	2018-08-20 21:41:55.235503-05
843	3	189	f	10	2018-08-20 21:42:14.12674-05
844	2	195	f	9	2018-08-20 21:42:20.844607-05
857	3	197	f	10	2018-08-20 21:49:07.512244-05
845	2	194	f	6	2018-08-20 21:42:27.715648-05
846	2	189	t	10	2018-08-20 21:42:46.011937-05
847	1	193	f	12	2018-08-20 21:43:26.787977-05
848	3	197	f	11	2018-08-20 21:44:29.190242-05
849	2	194	f	7	2018-08-20 21:44:55.830342-05
850	2	182	t	8	2018-08-20 21:45:12.236035-05
851	2	193	f	10	2018-08-20 21:45:52.374032-05
852	1	189	t	3	2018-08-20 21:47:06.908226-05
853	1	197	f	15	2018-08-20 21:47:50.882078-05
854	3	192	t	16	2018-08-20 21:48:16.542652-05
855	2	195	f	14	2018-08-20 21:48:34.257699-05
858	2	193	t	8	2018-08-20 21:49:15.634801-05
859	2	200	t	12	2018-08-20 21:51:20.096019-05
860	1	187	f	15	2018-08-20 21:51:38.578372-05
861	1	197	t	9	2018-08-20 21:52:13.324324-05
862	1	194	t	15	2018-08-20 21:52:18.430257-05
863	1	189	t	8	2018-08-20 21:53:19.756407-05
864	3	192	t	15	2018-08-20 21:53:26.087233-05
874	3	182	f	12	2018-08-20 21:56:37.605907-05
865	2	195	f	16	2018-08-20 21:53:34.794027-05
866	1	200	f	12	2018-08-20 21:54:10.860573-05
867	3	197	f	4	2018-08-20 21:54:13.455111-05
868	2	189	f	8	2018-08-20 21:54:21.889862-05
869	2	196	t	14	2018-08-20 21:54:43.260643-05
870	3	182	f	12	2018-08-20 21:55:18.39013-05
871	3	182	f	12	2018-08-20 21:56:05.376135-05
872	3	192	t	8	2018-08-20 21:56:15.080494-05
873	3	200	f	12	2018-08-20 21:56:33.914399-05
875	3	192	t	8	2018-08-20 21:56:47.084359-05
876	3	187	t	11	2018-08-20 21:56:56.765426-05
877	1	197	t	14	2018-08-20 21:57:39.200233-05
878	3	194	f	16	2018-08-20 21:57:39.39942-05
879	3	194	t	16	2018-08-20 21:58:16.680511-05
880	2	200	f	12	2018-08-20 21:58:58.506186-05
881	3	192	t	7	2018-08-20 21:58:58.865925-05
882	3	187	t	7	2018-08-20 21:59:48.471613-05
883	2	195	f	8	2018-08-20 22:00:52.424589-05
884	2	192	f	4	2018-08-20 22:01:02.984609-05
885	2	200	f	12	2018-08-20 22:01:38.93947-05
886	1	194	f	12	2018-08-20 22:02:28.648769-05
887	3	192	t	6	2018-08-20 22:02:51.706646-05
888	1	194	f	12	2018-08-20 22:02:57.724973-05
889	1	194	f	12	2018-08-20 22:03:17.71705-05
890	2	200	t	12	2018-08-20 22:06:16.000756-05
891	1	182	t	9	2018-08-20 22:09:04.664414-05
892	3	200	t	12	2018-08-20 22:09:35.562178-05
893	2	196	t	5	2018-08-20 22:17:55.057524-05
894	1	195	f	3	2018-08-20 22:18:25.682821-05
895	3	196	f	11	2018-08-20 22:24:39.115316-05
896	2	195	f	6	2018-08-20 22:25:32.418935-05
897	2	196	f	7	2018-08-20 22:32:38.72467-05
898	2	201	f	7	2018-08-20 22:37:08.579499-05
900	3	196	t	3	2018-08-20 22:38:17.097931-05
901	3	202	t	9	2018-08-20 22:38:59.61629-05
902	3	202	t	9	2018-08-20 22:39:35.227938-05
903	2	202	t	10	2018-08-20 22:41:26.654775-05
904	3	202	t	15	2018-08-20 22:43:58.607646-05
905	2	202	f	4	2018-08-20 22:45:23.84419-05
906	1	196	f	2	2018-08-20 22:45:51.311919-05
907	3	201	f	11	2018-08-20 22:46:09.847827-05
908	2	205	f	16	2018-08-20 22:46:34.816107-05
909	2	202	f	7	2018-08-20 22:47:04.495026-05
910	3	202	f	14	2018-08-20 22:48:38.362898-05
911	2	201	t	2	2018-08-20 22:50:05.290882-05
912	2	202	f	11	2018-08-20 22:50:54.62256-05
914	3	205	t	9	2018-08-20 22:51:57.73362-05
916	2	205	t	9	2018-08-20 22:55:07.539214-05
917	3	196	t	4	2018-08-20 22:55:11.728887-05
918	2	205	t	5	2018-08-20 22:57:14.171262-05
919	2	205	t	3	2018-08-20 22:59:19.931961-05
920	3	201	f	5	2018-08-20 22:59:33.449271-05
921	2	205	t	3	2018-08-20 22:59:49.015237-05
922	3	205	t	6	2018-08-20 23:02:19.624166-05
923	2	205	t	15	2018-08-20 23:05:44.089639-05
924	1	201	f	14	2018-08-20 23:06:40.205558-05
925	2	205	f	7	2018-08-20 23:07:35.463682-05
926	3	201	t	6	2018-08-20 23:10:26.105522-05
927	2	201	f	16	2018-08-20 23:15:13.484423-05
928	1	211	f	8	2018-08-20 23:49:22.117749-05
929	2	211	f	12	2018-08-20 23:51:55.046369-05
931	2	211	f	5	2018-08-20 23:54:44.310963-05
932	1	211	f	3	2018-08-21 00:02:32.395564-05
933	2	211	f	2	2018-08-21 00:07:48.660317-05
934	2	211	f	10	2018-08-21 00:17:15.608784-05
935	3	211	f	11	2018-08-21 00:20:50.360696-05
936	3	215	t	7	2018-08-21 01:46:40.936493-05
937	3	215	t	3	2018-08-21 01:52:22.157918-05
938	3	215	f	4	2018-08-21 02:08:23.34386-05
939	2	215	t	2	2018-08-21 02:13:23.171769-05
940	2	215	t	2	2018-08-21 02:13:55.829333-05
941	3	215	f	11	2018-08-21 02:15:57.866769-05
942	3	215	f	15	2018-08-21 02:20:45.062155-05
943	2	215	t	8	2018-08-21 02:25:53.331591-05
944	3	217	t	15	2018-08-21 03:30:24.717622-05
945	2	217	t	16	2018-08-21 03:36:25.540846-05
946	2	217	f	6	2018-08-21 03:38:24.367365-05
947	2	217	t	14	2018-08-21 03:39:34.608408-05
948	2	217	t	8	2018-08-21 03:43:23.522923-05
949	2	217	t	9	2018-08-21 03:45:16.901697-05
950	3	217	t	12	2018-08-21 03:46:49.558024-05
951	1	3	f	1	2018-10-04 13:19:15.351731-05
\.


--
-- Name: backend_safetyprop_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.backend_safetyprop_id_seq', 952, true);


--
-- Data for Name: backend_setparam; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.backend_setparam (parameter_ptr_id, numopts) FROM stdin;
3	6
8	7
17	8
29	3
30	8
70	5
71	3
\.


--
-- Data for Name: backend_setparamopt; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.backend_setparamopt (id, value, param_id) FROM stdin;
1	Red	3
2	Orange	3
3	Yellow	3
4	Green	3
5	Blue	3
6	Violet	3
7	Pop	8
8	Jazz	8
9	R&B	8
10	Hip-Hop	8
11	Rap	8
12	Country	8
13	News	8
14	Sunny	17
15	Cloudy	17
16	Partly Cloudy	17
17	Raining	17
18	Thunderstorms	17
19	Snowing	17
20	Hailing	17
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
\.


--
-- Name: backend_setparamopt_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.backend_setparamopt_id_seq', 45, true);


--
-- Data for Name: backend_sp1; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.backend_sp1 (safetyprop_ptr_id) FROM stdin;
48
51
72
99
100
105
110
111
115
116
143
148
149
164
166
167
168
180
188
189
190
191
195
196
208
212
213
216
222
224
225
226
227
242
243
244
245
254
258
259
262
263
269
272
285
289
291
292
296
303
305
311
312
314
324
325
327
328
329
341
346
348
349
353
354
356
357
358
369
370
371
372
380
393
394
400
402
405
408
410
417
418
437
438
444
451
453
454
458
460
465
466
469
471
475
498
520
521
523
524
528
529
530
538
548
558
560
585
588
589
590
591
593
597
601
602
603
604
605
618
621
623
624
625
634
637
638
644
648
649
650
656
659
663
665
667
677
701
706
709
728
735
743
746
748
759
766
770
774
777
780
782
786
803
806
809
817
834
836
847
852
853
860
861
862
863
866
877
886
888
889
891
894
906
924
928
932
951
\.


--
-- Data for Name: backend_sp1_triggers; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.backend_sp1_triggers (id, sp1_id, trigger_id) FROM stdin;
82	149	464
83	149	465
84	148	469
85	148	470
86	164	518
87	164	519
88	164	520
89	164	521
90	164	522
91	164	523
92	166	527
93	166	528
94	167	529
95	167	530
96	168	534
97	168	535
98	180	565
99	180	566
100	188	590
101	188	591
102	188	592
103	189	596
104	189	597
105	189	598
106	190	601
107	190	602
110	191	605
111	191	606
112	191	607
113	195	631
114	195	632
115	196	633
116	196	634
117	208	685
118	208	686
119	212	693
120	212	694
121	213	702
43	48	163
44	48	164
45	51	168
46	51	169
47	72	256
48	72	257
49	99	334
50	99	335
51	100	336
52	100	337
53	105	346
54	105	347
122	213	703
57	110	359
58	110	360
59	111	361
60	111	362
125	216	719
63	115	373
64	115	374
65	116	375
66	116	376
67	116	377
126	216	720
127	222	742
128	222	743
129	224	746
130	224	747
131	225	748
132	225	749
133	226	750
76	143	452
77	143	453
78	143	454
79	143	455
134	226	751
135	227	752
136	227	753
137	242	789
138	242	790
139	242	791
140	243	792
141	243	793
142	244	794
143	244	795
144	245	798
145	245	799
146	254	833
147	254	834
148	254	835
156	258	855
157	258	856
158	258	857
159	259	858
160	259	859
161	259	860
162	262	937
163	262	938
164	263	939
165	263	940
166	269	948
167	269	949
168	272	972
169	272	973
170	285	1038
171	285	1039
172	285	1040
173	285	1041
174	289	1050
175	289	1051
176	291	1056
177	291	1057
178	292	1058
179	292	1059
180	296	1070
181	296	1071
182	303	1097
183	303	1098
184	305	1109
185	305	1110
186	311	1122
187	311	1123
188	312	1124
189	312	1125
190	314	1128
191	314	1129
192	314	1130
193	324	1162
194	324	1163
195	325	1166
196	325	1167
197	327	1169
198	327	1170
199	328	1171
200	328	1172
203	329	1178
204	329	1179
205	341	1199
206	341	1200
209	348	1218
210	348	1219
211	349	1220
212	349	1221
213	346	1223
214	346	1224
215	353	1234
216	353	1235
217	353	1236
218	354	1238
219	354	1239
220	356	1242
221	356	1243
222	357	1245
223	357	1246
224	358	1247
225	358	1248
226	369	1275
227	369	1276
228	370	1280
229	370	1281
230	371	1282
231	371	1283
232	372	1284
233	372	1285
236	380	1307
237	380	1308
238	393	1328
239	393	1329
240	393	1330
241	393	1331
242	394	1333
243	394	1334
244	400	1346
245	400	1347
246	402	1349
247	402	1350
248	405	1360
249	405	1361
250	405	1362
251	405	1363
252	408	1456
253	408	1457
254	410	1460
255	410	1461
256	417	1516
257	417	1517
258	417	1518
259	418	1519
260	418	1520
261	437	1626
262	437	1627
263	438	1628
264	438	1629
265	444	1659
266	444	1660
267	451	1683
268	451	1684
269	453	1688
270	453	1689
271	454	1693
272	454	1694
273	458	1704
274	458	1705
275	460	1708
276	460	1709
277	465	1731
278	465	1732
279	465	1733
280	466	1735
281	466	1736
282	469	1742
283	469	1743
284	471	1755
285	471	1756
286	475	1779
287	475	1780
288	475	1781
293	498	1851
294	498	1852
297	520	1917
298	520	1918
299	520	1919
300	521	1921
301	521	1922
302	521	1923
303	523	1933
304	523	1934
305	523	1935
306	524	1940
307	524	1941
308	524	1942
309	528	1955
310	528	1956
311	529	1957
312	529	1958
313	530	1959
314	530	1960
315	538	1990
316	538	1991
317	538	1992
318	548	2020
319	548	2021
324	558	2059
325	558	2060
326	560	2069
327	560	2070
328	585	2253
329	585	2254
330	588	2269
331	588	2270
332	588	2271
333	589	2272
334	589	2273
335	590	2274
336	590	2275
337	591	2276
338	591	2277
339	593	2292
340	593	2293
341	597	2310
342	597	2311
343	601	2319
344	601	2320
345	602	2321
346	602	2322
347	603	2333
348	603	2334
349	604	2335
350	604	2336
351	605	2338
352	605	2339
353	618	2475
354	618	2476
355	621	2491
356	621	2492
357	623	2497
358	623	2498
359	624	2502
360	624	2503
361	625	2518
362	625	2519
363	625	2520
364	625	2521
365	634	2578
366	634	2579
367	637	2613
368	637	2614
369	637	2615
370	638	2617
371	638	2618
372	644	2652
373	644	2653
374	644	2654
375	644	2655
376	648	2659
377	648	2660
378	649	2676
379	649	2677
380	650	2679
381	650	2680
382	656	2704
383	656	2705
384	656	2706
385	659	2717
386	659	2718
387	663	2726
388	663	2727
391	665	2732
392	665	2733
393	667	2736
394	667	2737
395	667	2738
396	667	2739
397	677	2762
398	677	2763
399	677	2764
400	677	2765
401	701	2829
402	701	2830
403	706	2849
404	706	2850
405	709	2863
406	709	2864
407	709	2865
408	728	2923
409	728	2924
410	735	2942
411	735	2943
412	735	2944
413	743	2973
414	743	2974
415	743	2975
416	743	2976
417	746	2983
418	746	2984
419	748	2995
420	748	2996
421	748	2997
422	748	2998
423	759	3036
424	759	3037
428	766	3052
429	766	3053
430	766	3054
434	770	3061
435	770	3062
436	770	3063
437	770	3064
440	774	3080
441	774	3081
442	774	3082
445	777	3095
446	777	3096
447	780	3102
448	780	3103
449	782	3107
450	782	3108
451	782	3109
452	786	3122
453	786	3123
456	803	3227
457	803	3228
458	806	3240
459	806	3241
460	809	3256
461	809	3257
462	817	3290
463	817	3291
464	834	3349
465	834	3350
466	836	3357
467	836	3358
468	836	3359
469	847	3394
470	847	3395
471	852	3406
472	852	3407
473	853	3410
474	853	3411
475	853	3412
476	860	3436
477	860	3437
478	860	3438
479	861	3441
480	861	3442
481	862	3443
482	862	3444
483	863	3451
484	863	3452
485	863	3453
486	866	3460
487	866	3461
488	877	3487
489	877	3488
490	886	3522
491	886	3523
492	888	3526
493	888	3527
494	889	3528
495	889	3529
496	891	3541
497	891	3542
498	891	3543
499	894	3558
500	894	3559
501	906	3604
502	906	3605
503	906	3606
507	924	3700
508	924	3701
513	928	3757
514	928	3758
515	928	3759
516	928	3760
517	932	3775
518	932	3776
519	951	3922
520	951	3923
\.


--
-- Name: backend_sp1_triggers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.backend_sp1_triggers_id_seq', 522, true);


--
-- Data for Name: backend_sp2; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.backend_sp2 (safetyprop_ptr_id, comp, "time", state_id) FROM stdin;
96	>	60	331
97	\N	\N	332
98	\N	\N	333
104	\N	\N	343
49	\N	\N	166
50	\N	\N	167
52	>	60	170
106	\N	\N	348
36	\N	\N	171
53	\N	\N	175
107	\N	\N	350
54	\N	\N	179
108	\N	\N	352
112	\N	\N	363
133	\N	\N	428
35	>	300	115
117	\N	\N	388
136	>	10800	435
220	\N	\N	731
78	\N	\N	274
138	=	2400	441
118	>	120	390
139	\N	\N	443
80		120	306
87	\N	\N	318
90	\N	\N	322
91	\N	\N	323
384	\N	\N	1313
281	\N	\N	1016
123	>	1800	397
141	\N	\N	446
541	\N	\N	2000
218	<	1800	738
95	>	15	330
385	\N	\N	1316
145	=	120	457
223	=	1799	744
150	\N	\N	471
126	\N	\N	405
127	\N	\N	408
152	\N	\N	477
128	=	15	411
129	\N	\N	413
154	\N	\N	480
157	\N	\N	487
158	\N	\N	488
130	\N	\N	420
230	\N	\N	757
174	>	120	547
231	\N	\N	759
177	>	86399	559
178	\N	\N	562
185	\N	\N	584
186	\N	\N	586
187	\N	\N	588
192	\N	\N	608
193	=	15	624
194	\N	\N	630
197	\N	\N	636
198	\N	\N	642
199	\N	\N	647
201	\N	\N	655
202	\N	\N	661
545	\N	\N	2013
203	=	900	668
204	\N	\N	669
209	\N	\N	687
210	\N	\N	689
229	\N	\N	763
386	>	120	1318
215	=	10800	712
387	\N	\N	1319
233	>	15	765
388	\N	\N	1322
551	\N	\N	2039
286	>	15	1042
219	\N	\N	730
235	\N	\N	767
421	>	15	1523
290	>	120	1055
234	\N	\N	771
236	\N	\N	772
237	=	1	773
294	>	900	1067
307	\N	\N	1116
308	>	15	1118
309	\N	\N	1119
246	\N	\N	805
247	\N	\N	808
248	\N	\N	816
249	\N	\N	819
250	\N	\N	821
251	\N	\N	823
252	\N	\N	825
253	\N	\N	827
255	=	120	836
313	\N	\N	1126
261	=	900	936
264	>	3600	941
265	\N	\N	942
422	\N	\N	1524
266	>	3600	943
267	\N	\N	944
315	>	15	1131
268	>	3600	946
275	\N	\N	985
278	\N	\N	995
423	\N	\N	1528
319	\N	\N	1155
326	\N	\N	1168
740	>	1800	2961
391	>	10800	1326
330	\N	\N	1180
331	\N	\N	1182
333	\N	\N	1185
335	\N	\N	1187
337	\N	\N	1193
338	\N	\N	1194
339	\N	\N	1195
342	\N	\N	1201
350	\N	\N	1225
351	\N	\N	1226
352	\N	\N	1228
742	\N	\N	2969
392	\N	\N	1327
397	\N	\N	1341
355	>	1800	1244
363	\N	\N	1260
364	>	120	1265
365	\N	\N	1266
368	\N	\N	1273
579	>	120	2166
398	\N	\N	1343
375	>	120	1290
382	\N	\N	1309
403	\N	\N	1354
404	\N	\N	1356
406	\N	\N	1365
409	>	120	1458
749	\N	\N	2999
432	\N	\N	1594
416	\N	\N	1477
419	\N	\N	1521
568	\N	\N	2096
420	>	15	1522
439	\N	\N	1631
441	\N	\N	1640
442	\N	\N	1645
445	\N	\N	1664
544	\N	\N	2009
446	>	120	1665
448	\N	\N	1675
452	>	120	1687
455	\N	\N	1697
457	\N	\N	1700
459	\N	\N	1706
462	\N	\N	1715
463	>	120	1717
464	>	15	1730
468	\N	\N	1741
470	\N	\N	1754
472	\N	\N	1757
473	\N	\N	1766
476	\N	\N	1782
739	\N	\N	2955
477	>	15	1784
480	\N	\N	1790
484	\N	\N	1801
550	\N	\N	2034
556	\N	\N	2054
489	>	10805	1820
564	\N	\N	2082
567	\N	\N	2092
487	\N	\N	1823
492	\N	\N	1828
493	\N	\N	1839
741	\N	\N	2965
495	\N	\N	1842
496	\N	\N	1848
501	\N	\N	1859
502	\N	\N	1860
504	\N	\N	1869
509	\N	\N	1881
569	\N	\N	2098
511	\N	\N	1891
512	\N	\N	1892
586	\N	\N	2255
510	\N	\N	1894
513	\N	\N	1898
514	\N	\N	1899
747	\N	\N	2990
753	\N	\N	3013
754	\N	\N	3017
587	\N	\N	2268
592	\N	\N	2287
525	\N	\N	1945
531	\N	\N	1963
532	\N	\N	1968
533	\N	\N	1971
819	\N	\N	3293
536	\N	\N	1983
537	\N	\N	1986
758	\N	\N	3031
598	\N	\N	2312
599	\N	\N	2317
600	>	60	2318
607	\N	\N	2419
609	\N	\N	2425
616	\N	\N	2472
617	\N	\N	2474
626	\N	\N	2525
628	\N	\N	2542
850	\N	\N	3398
629	>	15	2543
632	>	120	2561
635	>	1800	2594
636	>	120	2602
641	\N	\N	2639
645	\N	\N	2656
646	\N	\N	2657
647	\N	\N	2658
658	\N	\N	2709
660	\N	\N	2719
661	\N	\N	2720
761	>	15	3039
662	>	120	2724
664	\N	\N	2728
666	\N	\N	2734
668	>	1800	2741
669	\N	\N	2745
821	\N	\N	3297
671	>	15	2750
672	\N	\N	2751
673	\N	\N	2754
674	\N	\N	2757
675	\N	\N	2760
676	>	120	2761
700	\N	\N	2823
823	\N	\N	3304
763	>	1800	3044
702	>	15	2836
704	\N	\N	2844
707	\N	\N	2851
708	\N	\N	2859
767	\N	\N	3055
715	\N	\N	2886
716	\N	\N	2887
769	\N	\N	3060
720	\N	\N	2899
719	\N	\N	2902
724	\N	\N	2913
851	\N	\N	3403
772	>	120	3069
725	\N	\N	2917
731	\N	\N	2929
828	>	120	3322
733	\N	\N	2934
734	\N	\N	2938
737	\N	\N	2949
738	\N	\N	2951
829	\N	\N	3325
833	\N	\N	3341
776	>	25200	3097
779	\N	\N	3101
781	\N	\N	3106
788	\N	\N	3138
789	>	10800	3141
840	\N	\N	3370
791	>	3600	3151
792	\N	\N	3153
841	\N	\N	3378
790	\N	\N	3164
799	\N	\N	3205
801	\N	\N	3215
805	\N	\N	3235
808	\N	\N	3249
810	\N	\N	3261
811	\N	\N	3267
844	\N	\N	3387
814	>	3600	3285
815	>	180	3287
818	\N	\N	3292
855	\N	\N	3415
845	>	120	3392
846	\N	\N	3393
849	>	15	3397
858	\N	\N	3421
859	\N	\N	3434
865	>	1800	3458
868	\N	\N	3466
869	\N	\N	3468
880	>	15	3500
883	\N	\N	3513
884	\N	\N	3517
885	\N	\N	3518
890	\N	\N	3535
893	\N	\N	3557
896	>	120	3565
897	>	15	3572
898	>	15	3579
903	\N	\N	3588
905	\N	\N	3603
908	>	1800	3614
909	>	15	3617
911	\N	\N	3626
912	\N	\N	3627
916	\N	\N	3646
918	\N	\N	3655
919	\N	\N	3664
921	\N	\N	3669
923	>	10800	3691
925	>	15	3702
927	>	1800	3726
929	\N	\N	3761
931	\N	\N	3765
933	\N	\N	3779
934	\N	\N	3789
939	\N	\N	3842
940	\N	\N	3843
943	\N	\N	3851
945	>	2100	3881
946	>	120	3892
947	\N	\N	3893
948	\N	\N	3898
949	\N	\N	3904
\.


--
-- Data for Name: backend_sp2_conds; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.backend_sp2_conds (id, sp2_id, trigger_id) FROM stdin;
14	36	172
15	36	173
16	36	174
17	53	176
19	54	180
25	78	275
26	80	307
27	87	319
28	91	324
29	91	325
30	91	326
31	104	344
32	104	345
33	106	349
34	107	351
35	123	398
38	126	406
39	126	407
40	127	409
41	127	410
42	128	412
43	129	414
44	129	415
47	130	421
48	130	422
49	136	436
50	138	442
51	145	458
54	150	472
55	150	473
56	150	474
57	185	585
58	186	587
59	187	589
60	197	637
61	198	643
62	199	648
63	201	656
64	209	688
65	210	690
67	215	713
70	220	732
72	218	739
73	223	745
74	230	758
75	231	760
76	237	774
79	247	809
80	247	810
81	248	817
82	249	820
83	250	822
84	251	824
85	252	826
86	253	828
87	255	837
88	267	945
89	268	947
91	307	1117
92	309	1120
93	313	1127
95	330	1181
96	339	1196
97	351	1227
98	352	1229
99	352	1230
100	352	1231
101	365	1267
103	382	1310
104	385	1317
105	387	1320
106	387	1321
107	397	1342
108	398	1344
109	403	1355
110	404	1357
111	406	1366
112	406	1367
114	422	1525
115	422	1526
116	422	1527
117	423	1529
119	442	1646
120	455	1698
121	462	1716
122	472	1758
123	473	1767
124	476	1783
125	480	1791
126	489	1821
127	495	1843
128	495	1844
129	495	1845
130	496	1849
131	502	1861
133	510	1895
134	510	1896
135	510	1897
137	531	1964
138	531	1965
139	532	1969
140	532	1970
141	536	1984
142	536	1985
144	541	2001
145	544	2010
146	544	2011
147	545	2014
148	545	2015
149	551	2040
150	556	2055
152	564	2083
154	567	2093
155	586	2256
156	598	2313
157	598	2314
158	609	2426
159	616	2473
160	635	2595
161	664	2729
162	666	2735
163	668	2742
164	668	2743
165	668	2744
166	669	2746
167	669	2747
168	672	2752
169	672	2753
170	673	2755
171	673	2756
172	674	2758
173	674	2759
174	700	2824
175	700	2825
176	707	2852
177	716	2888
183	720	2900
184	720	2901
185	719	2903
186	719	2904
187	719	2905
188	719	2906
189	719	2907
190	731	2930
191	733	2935
192	734	2939
193	734	2940
194	734	2941
195	737	2950
196	738	2952
198	739	2956
199	740	2962
200	741	2966
201	742	2970
202	742	2971
203	742	2972
204	747	2991
205	749	3000
206	753	3014
207	758	3032
208	763	3045
209	767	3056
211	776	3098
212	788	3139
213	788	3140
214	789	3142
216	791	3152
217	792	3154
218	790	3165
219	799	3206
220	805	3236
221	805	3237
222	808	3250
223	808	3251
224	810	3262
225	810	3263
226	811	3268
227	814	3286
229	833	3342
230	833	3343
231	840	3371
232	840	3372
233	840	3373
234	841	3379
235	844	3388
236	850	3399
237	850	3400
238	855	3416
239	855	3417
240	858	3422
241	858	3423
242	858	3424
243	859	3435
244	865	3459
245	868	3467
246	869	3469
247	869	3470
248	883	3514
249	883	3515
250	883	3516
251	890	3536
252	890	3537
253	890	3538
254	908	3615
257	916	3647
258	919	3665
259	921	3670
260	923	3692
261	927	3727
262	929	3762
263	933	3780
264	943	3852
265	943	3853
266	943	3854
267	945	3882
268	947	3894
269	948	3899
270	948	3900
271	948	3901
272	949	3905
\.


--
-- Name: backend_sp2_conds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.backend_sp2_conds_id_seq', 272, true);


--
-- Data for Name: backend_sp3; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.backend_sp3 (safetyprop_ptr_id, comp, occurrences, "time", event_id, timecomp) FROM stdin;
323	\N	\N	\N	1153	\N
70	>	2	60	210	\N
176	\N	\N	15	555	=
71	>	2	60	211	\N
322	\N	\N	\N	1158	\N
81	\N	\N	\N	308	\N
82	\N	\N	\N	310	\N
83	\N	\N	\N	311	\N
84	\N	\N	1800	312	=
85	\N	\N	10800	314	<
86	\N	\N	\N	316	\N
88	\N	\N	\N	320	\N
89	\N	\N	\N	321	\N
101	\N	\N	\N	338	\N
55	\N	\N	\N	181	\N
56	\N	\N	\N	182	\N
57	\N	\N	\N	183	\N
102	\N	\N	\N	340	\N
103	\N	\N	10800	341	<
58	\N	\N	\N	187	\N
59	\N	\N	\N	189	\N
109	\N	\N	\N	353	\N
113	\N	\N	\N	364	\N
175	\N	\N	\N	560	\N
63	\N	\N	7200	198	<
179	\N	\N	\N	563	\N
181	\N	\N	\N	567	\N
182	\N	\N	\N	573	\N
62	\N	\N	\N	204	\N
183	\N	\N	\N	575	\N
436	\N	\N	\N	1622	\N
317	\N	\N	\N	1160	\N
200	\N	\N	\N	649	\N
137	\N	\N	\N	439	\N
144	\N	\N	\N	456	\N
205	\N	\N	1800	672	=
147	\N	\N	\N	460	\N
151	\N	\N	\N	475	\N
153	\N	\N	\N	478	\N
155	\N	\N	15	482	=
156	\N	\N	\N	485	\N
159	\N	\N	\N	489	\N
160	\N	\N	1800	508	<
161	\N	\N	\N	510	\N
162	\N	\N	15	512	>
163	\N	\N	3000	514	=
165	\N	\N	\N	524	\N
169	\N	\N	\N	536	\N
170	\N	\N	\N	538	\N
171	\N	\N	120	540	=
172	\N	\N	\N	542	\N
206	\N	\N	\N	677	\N
207	\N	\N	\N	683	\N
173	\N	\N	\N	549	\N
211	\N	\N	\N	691	\N
214	\N	\N	120	706	>
217	\N	\N	\N	723	\N
221	\N	\N	1800	740	=
228	\N	\N	\N	754	\N
232	\N	\N	\N	761	\N
332	\N	\N	\N	1184	\N
334	\N	\N	\N	1186	\N
619	\N	\N	20	2486	<
260	\N	\N	900	934	=
270	\N	\N	\N	954	\N
271	\N	\N	\N	960	\N
273	\N	\N	\N	981	\N
277	\N	\N	\N	994	\N
279	\N	\N	\N	997	\N
336	\N	\N	\N	1191	\N
276	\N	\N	\N	1005	\N
280	\N	\N	\N	1008	\N
282	\N	\N	\N	1013	\N
283	\N	\N	\N	1023	\N
287	\N	\N	\N	1044	\N
288	\N	\N	\N	1047	\N
293	\N	\N	\N	1062	\N
340	\N	\N	\N	1197	\N
297	\N	\N	\N	1072	\N
298	\N	\N	\N	1079	\N
299	\N	\N	\N	1083	\N
300	\N	\N	\N	1091	\N
301	\N	\N	\N	1093	\N
302	\N	\N	\N	1095	\N
304	\N	\N	\N	1105	\N
306	\N	\N	\N	1113	\N
343	\N	\N	\N	1207	\N
316	\N	\N	\N	1134	\N
344	\N	\N	\N	1209	\N
318	\N	\N	\N	1142	\N
622	\N	\N	\N	2493	\N
321	\N	\N	\N	1148	\N
630	\N	\N	\N	2554	\N
440	\N	\N	\N	1641	\N
347	\N	\N	\N	1215	\N
359	\N	\N	\N	1250	\N
633	\N	\N	\N	2564	\N
443	\N	\N	0	1648	<
360	\N	\N	\N	1254	\N
362	\N	\N	\N	1258	\N
447	\N	\N	\N	1670	\N
361	\N	\N	\N	1261	\N
366	\N	\N	\N	1269	\N
367	\N	\N	\N	1271	\N
374	\N	\N	\N	1288	\N
376	\N	\N	\N	1291	\N
377	\N	\N	\N	1293	\N
640	\N	\N	\N	2635	\N
643	\N	\N	120	2644	<
378	\N	\N	\N	1299	\N
379	\N	\N	\N	1301	\N
381	\N	\N	\N	1305	\N
383	\N	\N	\N	1311	\N
389	\N	\N	\N	1323	\N
395	\N	\N	\N	1336	\N
396	\N	\N	\N	1339	\N
399	\N	\N	\N	1345	\N
401	\N	\N	\N	1348	\N
407	\N	\N	\N	1449	\N
456	\N	\N	\N	1699	\N
411	\N	\N	\N	1465	\N
412	\N	\N	\N	1466	\N
413	\N	\N	\N	1467	\N
425	\N	\N	\N	1535	\N
426	\N	\N	\N	1536	\N
427	\N	\N	\N	1537	\N
428	\N	\N	\N	1539	\N
429	\N	\N	10800	1541	<
430	\N	\N	1800	1549	<
431	\N	\N	3600	1558	<
652	\N	\N	\N	2689	\N
461	\N	\N	\N	1710	\N
433	\N	\N	\N	1597	\N
434	\N	\N	\N	1607	\N
435	\N	\N	\N	1612	\N
467	\N	\N	\N	1737	\N
474	\N	\N	\N	1773	\N
478	\N	\N	\N	1785	\N
479	\N	\N	120	1788	<
482	\N	\N	\N	1795	\N
483	\N	\N	\N	1798	\N
486	\N	\N	\N	1812	\N
488	\N	\N	\N	1819	\N
490	\N	\N	\N	1824	\N
499	\N	\N	\N	1854	\N
500	\N	\N	1800	1857	<
503	\N	\N	\N	1862	\N
497	\N	\N	\N	1865	\N
505	\N	\N	\N	1870	\N
620	\N	\N	\N	2488	\N
508	\N	\N	\N	1878	\N
627	\N	\N	\N	2539	\N
516	\N	\N	\N	1902	\N
631	\N	\N	\N	2559	\N
816	\N	\N	\N	3288	\N
527	\N	\N	15	1952	<
534	\N	\N	\N	1972	\N
642	\N	\N	15	2640	<
539	\N	\N	5400	1993	<
653	\N	\N	\N	2685	\N
542	\N	\N	\N	2006	\N
543	\N	\N	\N	2007	\N
546	\N	\N	1800	2016	<
822	\N	\N	\N	3299	\N
651	\N	\N	\N	2687	\N
552	\N	\N	2700	2043	<
554	\N	\N	\N	2048	\N
555	\N	\N	\N	2053	\N
557	\N	\N	\N	2057	\N
559	\N	\N	120	2062	<
561	\N	\N	\N	2075	\N
562	\N	\N	120	2076	<
566	\N	\N	\N	2086	\N
570	\N	\N	\N	2103	\N
571	\N	\N	\N	2107	\N
572	\N	\N	\N	2110	\N
574	\N	\N	\N	2121	\N
654	\N	\N	\N	2693	\N
573	\N	\N	3600	2123	>
575	\N	\N	\N	2141	\N
576	\N	\N	\N	2146	\N
577	\N	\N	\N	2148	\N
578	\N	\N	15	2150	<
580	\N	\N	\N	2186	\N
581	\N	\N	\N	2199	\N
582	\N	\N	\N	2205	\N
824	\N	\N	\N	3305	\N
583	\N	\N	\N	2213	\N
584	\N	\N	\N	2220	\N
594	\N	\N	\N	2296	\N
596	\N	\N	10800	2308	<
606	\N	\N	120	2385	<
608	\N	\N	2700	2420	<
610	\N	\N	3600	2433	<
657	\N	\N	\N	2714	\N
613	\N	\N	\N	2443	\N
670	\N	\N	\N	2748	\N
614	\N	\N	\N	2463	\N
612	\N	\N	\N	2465	\N
615	\N	\N	120	2467	<
689	\N	\N	\N	2788	\N
690	\N	\N	\N	2790	\N
691	\N	\N	\N	2792	\N
692	\N	\N	\N	2794	\N
693	\N	\N	\N	2796	\N
694	\N	\N	\N	2798	\N
695	\N	\N	\N	2800	\N
696	\N	\N	\N	2802	\N
697	\N	\N	\N	2804	\N
698	\N	\N	15	2806	<
699	\N	\N	\N	2808	\N
703	\N	\N	\N	2839	\N
705	\N	\N	\N	2847	\N
711	\N	\N	\N	2877	\N
712	\N	\N	\N	2879	\N
713	\N	\N	\N	2881	\N
714	\N	\N	\N	2883	\N
717	\N	\N	120	2889	<
718	\N	\N	120	2891	<
721	\N	\N	\N	2908	\N
825	\N	\N	1800	3307	<
723	\N	\N	\N	2911	\N
726	\N	\N	15	2919	<
727	\N	\N	\N	2921	\N
730	\N	\N	\N	2927	\N
826	\N	\N	\N	3313	\N
827	\N	\N	\N	3318	\N
745	\N	\N	1800	2979	<
830	\N	\N	\N	3326	\N
744	\N	\N	1860	2981	>
750	\N	\N	\N	3006	\N
751	\N	\N	\N	3010	\N
831	\N	\N	\N	3332	\N
752	\N	\N	\N	3015	\N
757	\N	\N	15	3024	<
771	\N	\N	\N	3065	\N
832	\N	\N	\N	3334	\N
778	\N	\N	930	3099	<
783	\N	\N	\N	3110	\N
784	\N	\N	\N	3112	\N
785	\N	\N	\N	3118	\N
835	\N	\N	900	3352	<
787	\N	\N	3600	3147	>
793	\N	\N	\N	3161	\N
794	\N	\N	1800	3167	<
795	\N	\N	\N	3190	\N
837	\N	\N	\N	3360	\N
800	\N	\N	\N	3207	\N
797	\N	\N	\N	3208	\N
838	\N	\N	\N	3362	\N
798	\N	\N	10800	3212	>
804	\N	\N	1800	3231	<
812	\N	\N	\N	3269	\N
839	\N	\N	\N	3368	\N
842	\N	\N	15	3384	<
843	\N	\N	\N	3386	\N
848	\N	\N	\N	3396	\N
854	\N	\N	2400	3413	<
856	\N	\N	\N	3418	\N
857	\N	\N	\N	3420	\N
864	\N	\N	\N	3454	\N
867	\N	\N	\N	3462	\N
870	\N	\N	\N	3471	\N
871	\N	\N	\N	3476	\N
872	\N	\N	\N	3478	\N
873	\N	\N	\N	3480	\N
874	\N	\N	\N	3481	\N
875	\N	\N	\N	3483	\N
876	\N	\N	\N	3485	\N
878	\N	\N	1800	3489	<
879	\N	\N	1860	3495	<
881	\N	\N	15	3501	<
882	\N	\N	15	3506	<
887	\N	\N	120	3524	<
892	\N	\N	\N	3544	\N
895	\N	\N	\N	3564	\N
900	\N	\N	\N	3580	\N
901	\N	\N	\N	3582	\N
902	\N	\N	\N	3584	\N
904	\N	\N	\N	3600	\N
907	\N	\N	\N	3607	\N
910	\N	\N	\N	3622	\N
914	\N	\N	\N	3633	\N
917	\N	\N	\N	3648	\N
920	\N	\N	\N	3668	\N
922	\N	\N	120	3678	<
926	\N	\N	120	3709	<
935	\N	\N	\N	3793	\N
936	\N	\N	15	3823	<
937	\N	\N	\N	3825	\N
938	\N	\N	\N	3837	\N
941	\N	\N	\N	3844	\N
942	\N	\N	\N	3848	\N
944	\N	\N	10800	3878	<
950	\N	\N	\N	3906	\N
\.


--
-- Data for Name: backend_sp3_conds; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.backend_sp3_conds (id, sp3_id, trigger_id) FROM stdin;
10	57	184
12	58	188
13	59	190
17	63	199
18	62	205
22	81	309
23	84	313
24	85	315
25	86	317
26	101	339
27	103	342
28	109	354
29	113	365
36	137	440
37	155	483
38	160	509
39	161	511
40	162	513
41	163	515
42	165	525
43	169	537
44	170	539
45	171	541
46	172	543
48	173	550
50	176	556
52	175	561
53	179	564
54	181	568
55	182	574
56	183	576
58	200	650
59	205	673
60	207	684
61	211	692
62	214	707
63	217	724
64	221	741
65	228	755
66	232	762
70	260	935
71	270	955
72	271	961
73	273	982
75	279	998
76	276	1006
77	280	1009
78	287	1045
79	288	1048
81	297	1073
82	297	1074
83	297	1075
84	298	1080
85	299	1084
86	300	1092
87	301	1094
88	302	1096
89	304	1106
90	306	1114
91	316	1135
93	318	1143
95	321	1149
97	323	1154
98	322	1159
99	317	1161
101	336	1192
102	340	1198
103	343	1208
104	344	1210
106	359	1251
108	360	1255
110	362	1259
111	361	1262
112	366	1270
113	367	1272
114	374	1289
115	376	1292
116	377	1294
118	378	1300
119	379	1302
120	381	1306
121	383	1312
122	395	1337
123	396	1340
125	407	1450
126	427	1538
127	428	1540
128	429	1542
129	430	1550
130	431	1559
132	433	1598
133	434	1608
134	435	1613
135	436	1623
137	440	1642
138	443	1649
139	447	1671
142	461	1711
143	467	1738
144	474	1774
145	478	1786
146	479	1789
147	486	1813
148	490	1825
150	500	1858
151	505	1871
153	508	1879
155	516	1903
158	527	1953
160	539	1994
161	546	2017
163	552	2044
164	554	2049
165	557	2058
166	559	2063
167	562	2077
168	566	2087
169	570	2104
170	571	2108
171	572	2111
173	574	2122
174	573	2124
175	575	2142
176	576	2147
177	577	2149
178	578	2151
179	580	2187
180	581	2200
181	582	2206
183	583	2214
184	594	2297
185	596	2309
186	606	2386
187	608	2421
188	610	2434
189	613	2444
191	614	2464
192	612	2466
193	615	2468
194	619	2487
195	620	2489
196	622	2494
197	630	2555
198	631	2560
200	640	2636
201	640	2637
202	642	2641
203	643	2645
206	653	2686
207	651	2688
208	652	2690
210	654	2694
211	670	2749
223	689	2789
224	690	2791
225	691	2793
226	692	2795
227	693	2797
228	694	2799
229	695	2801
230	696	2803
231	697	2805
232	698	2807
233	699	2809
234	711	2878
235	713	2882
236	717	2890
237	718	2892
239	726	2920
241	730	2928
245	745	2980
246	744	2982
248	752	3016
250	757	3025
251	771	3066
253	778	3100
254	783	3111
256	787	3148
257	794	3168
260	797	3209
261	798	3213
262	804	3232
264	812	3270
265	816	3289
266	822	3300
267	824	3306
268	825	3308
269	827	3319
270	830	3327
271	831	3333
272	835	3353
273	837	3361
274	839	3369
275	842	3385
276	854	3414
277	864	3455
278	870	3472
279	871	3477
280	872	3479
281	874	3482
282	875	3484
283	876	3486
284	878	3490
285	879	3496
286	881	3502
287	882	3507
288	887	3525
289	892	3545
290	900	3581
291	901	3583
292	902	3585
293	904	3601
294	910	3623
295	914	3634
296	917	3649
297	922	3679
298	926	3710
300	936	3824
301	937	3826
302	942	3849
303	944	3879
304	950	3907
\.


--
-- Name: backend_sp3_conds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.backend_sp3_conds_id_seq', 304, true);


--
-- Data for Name: backend_ssrule; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.backend_ssrule (priority, action_id, rule_ptr_id) FROM stdin;
\.


--
-- Data for Name: backend_ssrule_triggers; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.backend_ssrule_triggers (id, ssrule_id, trigger_id) FROM stdin;
\.


--
-- Name: backend_ssrule_triggers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.backend_ssrule_triggers_id_seq', 1, false);


--
-- Data for Name: backend_state; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.backend_state (id, cap_id, dev_id, action, text, chan_id) FROM stdin;
18	35	7	t	Start playing despacito on Speakers	\N
19	35	7	t	Start playing despacito on Speakers	\N
22	8	3	t	Set Amazon Echo's Volume to 47	3
23	64	22	t	Turn On Smart Faucet's water	17
26	64	22	t	Turn On Smart Faucet's water	17
27	64	22	t	Turn On Smart Faucet's water	17
28	64	22	t	Turn On Smart Faucet's water	17
29	64	22	t	Turn On Smart Faucet's water	17
33	31	3	t	(Amazon Echo) Order 500 {size} Pizza(s) with Vegetables	11
41	2	5	t	Turn Smart TV On	12
42	2	5	t	Turn Smart TV On	12
44	14	25	t	Close Living Room Window	5
46	14	24	t	Open Bathroom Window	5
47	14	14	t	Open Bedroom Window	5
48	14	25	t	Open Living Room Window	5
49	60	23	t	Close Smart Oven's Door	13
50	60	23	t	Close Smart Oven's Door	13
51	21	2	t	Set Thermostat to 75	8
52	66	8	t	Set Smart Refrigerator's temperature to 45	13
53	64	22	t	Turn Off Smart Faucet's water	13
54	64	22	t	Turn Off Smart Faucet's water	17
55	14	14	t	Open Bedroom Window	5
56	14	14	t	Open Bedroom Window	5
57	14	14	t	Open Bedroom Window	5
58	14	14	t	Open Bedroom Window	5
59	64	22	t	Turn On Smart Faucet's water	17
63	60	23	t	Close Smart Oven's Door	13
64	21	2	t	Set Thermostat to 75	8
65	66	8	t	Set Smart Refrigerator's temperature to 45	13
66	60	8	t	Close Smart Refrigerator's Door	13
67	64	22	t	Turn Off Smart Faucet's water	17
68	66	8	t	Set Smart Refrigerator's temperature to 40	13
69	66	8	t	Set Smart Refrigerator's temperature to 40	13
70	2	5	t	Turn Smart TV Off	12
71	14	14	t	Open Bedroom Window	5
72	56	3	t	Stop playing music on Amazon Echo	3
73	2	1	t	Turn Roomba Off	18
74	13	13	t	Lock Smart Door Lock	5
75	2	1	t	Turn Roomba Off	18
76	2	5	t	Turn Smart TV Off	12
77	3	4	t	Set HUE Lights's Brightness to 4	2
78	56	3	t	Stop playing music on Amazon Echo	3
79	66	8	t	Set Smart Refrigerator's temperature to 50	13
80	57	2	t	Turn On the AC	8
81	35	3	t	Start playing Alert on Amazon Echo	3
82	66	8	t	Set Smart Refrigerator's temperature to 37	13
83	9	3	t	Start playing R&B on Amazon Echo	3
84	64	22	t	Turn Off Smart Faucet's water	17
85	58	14	t	Close Bedroom Window's Curtains	5
86	64	22	t	Turn Off Smart Faucet's water	17
87	14	24	t	Open Bathroom Window	5
88	2	1	t	Turn Roomba Off	18
89	2	1	t	Turn Roomba Off	18
90	2	1	t	Turn Roomba On	18
91	13	23	t	Lock Smart Oven	13
92	57	2	t	Turn On the AC	8
93	58	24	t	Close Bathroom Window's Curtains	5
94	13	13	t	Lock Front Door Lock	4
95	14	25	t	Open Living Room Window	5
96	14	14	t	Open Bedroom Window	5
97	14	24	t	Open Bathroom Window	5
98	60	8	t	Close Smart Refrigerator's Door	13
99	21	2	t	Set Thermostat to 70	8
100	60	8	t	Close Smart Refrigerator's Door	13
101	21	2	t	Set Thermostat to 70	8
102	13	13	t	Lock Front Door Lock	4
103	58	24	t	Close Bathroom Window's Curtains	5
104	64	22	t	Turn Off Smart Faucet's water	17
105	2	23	t	Turn Smart Oven Off	13
106	57	2	t	Turn Off the AC	8
107	21	2	t	Set Thermostat to 72	8
109	57	2	t	Turn On the AC	8
110	57	2	t	Turn On the AC	8
111	9	3	t	Start playing Rap on Amazon Echo	3
112	21	2	t	Set Thermostat to 70	8
113	9	3	t	Start playing Jazz on Amazon Echo	3
114	21	2	t	Set Thermostat to 72	8
115	13	13	t	Lock Front Door Lock	4
116	64	22	t	Turn Off Smart Faucet's water	17
117	13	13	t	Lock Front Door Lock	4
118	2	5	t	Turn Smart TV Off	12
119	13	13	t	Lock Front Door Lock	4
120	2	23	t	Turn Smart Oven Off	13
121	2	1	t	Turn Roomba Off	18
122	2	1	t	Turn Roomba Off	18
123	2	1	t	Turn Roomba Off	18
124	57	2	t	Turn On the AC	8
125	13	13	t	Lock Front Door Lock	4
126	66	8	t	Set Smart Refrigerator's temperature to 45	13
127	13	14	t	Lock Bedroom Window	4
128	13	13	t	Lock Front Door Lock	4
129	14	25	t	Open Living Room Window	5
130	14	25	t	Open Living Room Window	5
131	14	14	t	Open Bedroom Window	5
132	35	3	t	Start playing The Greatest Showman Soundtrack on Amazon Echo	3
134	58	24	t	Close Bathroom Window's Curtains	5
135	58	24	t	Close Bathroom Window's Curtains	5
136	2	1	t	Turn Roomba Off	18
137	57	2	t	Turn On the AC	8
138	2	1	t	Turn Roomba On	18
139	2	1	t	Turn Roomba Off	18
140	57	2	t	Turn On the AC	8
141	57	2	t	Turn Off the AC	8
143	2	5	t	Turn Smart TV Off	12
144	2	5	t	Turn Smart TV Off	12
145	57	2	t	Turn On the AC	8
146	13	13	t	Lock Front Door Lock	4
147	57	2	t	Turn Off the AC	8
148	13	13	t	Lock Front Door Lock	4
149	2	1	t	Turn Roomba Off	18
150	60	8	t	Close Smart Refrigerator's Door	13
151	58	24	t	Close Bathroom Window's Curtains	5
152	60	8	t	Close Smart Refrigerator's Door	13
153	56	3	t	Stop playing music on Amazon Echo	3
154	64	22	t	Turn Off Smart Faucet's water	17
155	14	25	t	Open Living Room Window	5
156	57	2	t	Turn On the AC	8
157	57	2	t	Turn On the AC	8
158	14	25	t	Close Living Room Window	5
159	14	14	t	Close Bedroom Window	5
160	14	24	t	Close Bathroom Window	5
161	13	13	t	Lock Front Door Lock	4
162	13	14	t	Lock Bedroom Window	4
163	13	13	t	Lock Front Door Lock	5
164	58	24	t	Close Bathroom Window's Curtains	5
165	58	14	t	Close Bedroom Window's Curtains	5
166	58	25	t	Close Living Room Window's Curtains	5
167	13	13	t	Lock Front Door Lock	4
168	2	4	t	Turn HUE Lights Off	2
170	2	5	t	Turn Smart TV On	12
171	2	1	t	Turn Roomba Off	18
172	66	8	t	Set Smart Refrigerator's temperature to 45	13
173	2	5	t	Turn Smart TV Off	12
174	21	2	t	Set Thermostat to 70	8
175	64	22	t	Turn Off Smart Faucet's water	17
176	58	24	t	Close Bathroom Window's Curtains	5
177	64	22	t	Turn Off Smart Faucet's water	17
178	13	23	t	Lock Smart Oven	13
179	64	22	t	Turn Off Smart Faucet's water	17
180	56	3	t	Stop playing music on Amazon Echo	3
181	58	24	t	Close Bathroom Window's Curtains	5
182	58	24	t	Close Bathroom Window's Curtains	5
183	60	8	t	Close Smart Refrigerator's Door	13
184	2	5	t	Turn Smart TV Off	12
185	58	24	t	Close Bathroom Window's Curtains	5
186	58	24	t	Close Bathroom Window's Curtains	5
187	9	3	t	Start playing Jazz on Amazon Echo	3
188	9	3	t	Start playing R&B on Amazon Echo	3
189	9	3	t	Start playing Hip-Hop on Amazon Echo	3
190	9	3	t	Start playing Rap on Amazon Echo	3
191	2	1	t	Turn Roomba Off	18
192	2	5	t	Turn Smart TV Off	12
193	2	1	t	Turn Roomba On	18
194	2	1	t	Turn Roomba Off	18
195	58	25	t	Close Living Room Window's Curtains	5
196	14	14	t	Close Bedroom Window	5
197	14	14	t	Close Bedroom Window	5
198	14	14	t	Close Bedroom Window	5
199	14	14	t	Close Bedroom Window	5
200	14	14	t	Close Bedroom Window	5
201	13	13	t	Lock Front Door Lock	4
202	14	14	t	Close Bedroom Window	5
203	14	14	t	Open Bedroom Window	5
204	14	14	t	Open Bedroom Window	5
205	14	14	t	Open Bedroom Window	5
206	14	14	t	Open Bedroom Window	5
207	21	2	t	Set Thermostat to 73	8
208	66	8	t	Set Smart Refrigerator's temperature to 43	13
209	64	22	t	Turn Off Smart Faucet's water	17
210	2	1	t	Turn Roomba Off	18
211	2	23	t	Turn Smart Oven Off	13
212	57	2	t	Turn On the AC	8
213	13	13	t	Lock Front Door Lock	4
214	56	3	t	Stop playing music on Amazon Echo	3
215	13	23	t	Lock Smart Oven	13
216	13	23	t	Unlock Smart Oven	13
217	60	8	t	Close Smart Refrigerator's Door	13
218	13	13	t	Lock Front Door Lock	5
219	14	14	t	Open Bedroom Window	5
220	64	22	t	Turn Off Smart Faucet's water	17
221	58	24	t	Close Bathroom Window's Curtains	5
222	2	1	t	Turn Roomba Off	18
223	2	5	t	Turn Smart TV Off	12
224	6	4	t	Set HUE Lights's Color to Blue	2
225	9	7	t	Start playing Hip-Hop on Speakers	3
226	2	5	t	Turn Smart TV Off	12
227	35	3	t	Start playing Star Spangled Banner on Amazon Echo	3
228	14	25	t	Open Living Room Window	5
229	57	2	t	Turn On the AC	8
230	56	3	t	Stop playing music on Amazon Echo	3
231	14	14	t	Open Bedroom Window	5
232	14	14	t	Open Bedroom Window	5
233	66	8	t	Set Smart Refrigerator's temperature to 40	13
234	14	25	t	Open Living Room Window	5
235	14	24	t	Close Bathroom Window	5
236	14	14	t	Open Bedroom Window	5
237	14	24	t	Open Bathroom Window	5
238	2	1	t	Turn Roomba Off	18
239	2	5	t	Turn Smart TV Off	1
240	66	8	t	Set Smart Refrigerator's temperature to 45	13
241	2	1	t	Turn Roomba Off	18
242	58	24	t	Close Bathroom Window's Curtains	5
243	14	14	t	Close Bedroom Window	5
244	14	14	t	Close Bedroom Window	5
246	2	1	t	Turn Roomba On	18
247	35	7	t	Start playing Bad Boys on Speakers	3
248	56	3	t	Stop playing music on Amazon Echo	3
249	56	3	t	Stop playing music on Amazon Echo	3
250	40	10	t	Turn Security Camera's Siren On	4
251	2	1	t	Turn Roomba Off	18
252	13	23	t	Lock Smart Oven	13
253	66	8	t	Set Smart Refrigerator's temperature to 41	13
254	12	3	t	Tune Amazon Echo to 100.5FM	3
255	2	1	t	Turn Roomba Off	18
256	58	24	t	Close Bathroom Window's Curtains	5
257	13	13	t	Lock Front Door Lock	4
258	60	8	t	Close Smart Refrigerator's Door	13
259	21	2	t	Set Thermostat to 76	8
260	58	24	t	Close Bathroom Window's Curtains	5
261	66	8	t	Set Smart Refrigerator's temperature to 40	13
262	14	25	t	Open Living Room Window	5
263	58	24	t	Close Bathroom Window's Curtains	5
264	60	8	t	Close Smart Refrigerator's Door	13
265	13	13	t	Lock Front Door Lock	5
266	14	25	t	Open Living Room Window	5
267	14	14	t	Open Bedroom Window	5
268	13	23	t	Lock Smart Oven	13
269	14	14	t	Open Bedroom Window	5
270	2	1	t	Turn Roomba On	18
271	13	13	t	Lock Front Door Lock	4
272	2	5	t	Turn Smart TV Off	12
273	58	25	t	Close Living Room Window's Curtains	5
274	58	25	t	Close Living Room Window's Curtains	5
275	21	2	t	Set Thermostat to 70	8
276	13	13	t	Lock Front Door Lock	4
277	56	3	t	Stop playing music on Amazon Echo	3
278	2	5	t	Turn Smart TV Off	12
279	56	3	t	Stop playing music on Amazon Echo	3
280	13	23	t	Lock Smart Oven	13
281	58	25	t	Close Living Room Window's Curtains	5
282	58	14	t	Close Bedroom Window's Curtains	5
283	58	25	t	Close Living Room Window's Curtains	5
284	58	24	t	Close Bathroom Window's Curtains	5
285	13	13	t	Lock Front Door Lock	5
286	60	8	t	Close Smart Refrigerator's Door	13
287	66	8	t	Set Smart Refrigerator's temperature to 40	13
288	58	24	t	Close Bathroom Window's Curtains	5
289	9	3	t	Start playing Country on Amazon Echo	3
290	21	2	t	Set Thermostat to 70	8
291	21	2	t	Set Thermostat to 72	8
292	21	2	t	Set Thermostat to 75	8
293	13	23	t	Lock Smart Oven	13
294	13	23	t	Lock Smart Oven	13
295	64	22	t	Turn Off Smart Faucet's water	17
296	57	2	t	Turn On the AC	8
297	14	14	t	Open Bedroom Window	5
298	60	8	t	Close Smart Refrigerator's Door	13
299	64	22	t	Turn Off Smart Faucet's water	17
300	21	2	t	Set Thermostat to 73	8
301	21	2	t	Set Thermostat to 61	8
302	2	1	t	Turn Roomba Off	18
304	64	22	t	Turn Off Smart Faucet's water	17
305	13	13	t	Lock Front Door Lock	4
306	2	5	t	Turn Smart TV Off	12
307	14	14	t	Open Bedroom Window	5
308	14	14	t	Close Bedroom Window	5
309	14	25	t	Open Living Room Window	5
310	14	14	t	Close Bedroom Window	5
311	14	14	t	Close Bedroom Window	5
312	14	14	t	Close Bedroom Window	5
313	65	23	t	Set Smart Oven's temperature to 5	13
314	2	23	t	Turn Smart Oven Off	13
315	13	23	t	Lock Smart Oven	13
316	13	13	t	Lock Front Door Lock	5
317	13	13	t	Lock Front Door Lock	5
318	14	14	t	Close Bedroom Window	5
319	57	2	t	Turn On the AC	8
320	14	14	t	Close Bedroom Window	5
321	14	14	t	Open Bedroom Window	5
322	14	14	t	Open Bedroom Window	5
323	58	25	t	Close Living Room Window's Curtains	5
324	14	14	t	Close Bedroom Window	5
325	21	2	t	Set Thermostat to 73	8
326	57	2	t	Turn Off the AC	8
327	14	14	t	Open Bedroom Window	5
328	56	3	t	Stop playing music on Amazon Echo	3
329	2	1	t	Turn Roomba Off	18
330	66	8	t	Set Smart Refrigerator's temperature to 40	13
331	58	24	t	Close Bathroom Window's Curtains	5
332	57	2	t	Turn On the AC	8
333	14	14	t	Open Bedroom Window	5
335	13	23	t	Lock Smart Oven	13
336	14	14	t	Open Bedroom Window	5
337	13	23	t	Lock Smart Oven	13
338	21	2	t	Set Thermostat to 80	8
339	57	2	t	Turn On the AC	8
340	2	7	t	Turn Speakers Off	1
341	14	24	t	Open Bathroom Window	5
342	21	2	t	Set Thermostat to 72	8
343	14	14	t	Open Bedroom Window	5
344	14	24	t	Open Bathroom Window	5
345	14	25	t	Open Living Room Window	5
346	14	25	t	Open Living Room Window	5
347	14	14	t	Open Bedroom Window	5
348	14	14	t	Open Bedroom Window	5
349	14	25	t	Open Living Room Window	5
350	57	2	t	Turn On the AC	8
352	57	2	t	Turn On the AC	8
353	64	22	t	Turn Off Smart Faucet's water	17
354	64	22	t	Turn Off Smart Faucet's water	17
355	56	3	t	Stop playing music on Amazon Echo	3
356	2	5	t	Turn Smart TV Off	12
357	21	2	t	Set Thermostat to 73	8
358	58	24	t	Close Bathroom Window's Curtains	5
359	2	1	t	Turn Roomba Off	1
364	64	22	t	Turn Off Smart Faucet's water	17
365	56	3	t	Stop playing music on Amazon Echo	3
366	2	1	t	Turn Roomba Off	18
367	13	13	t	Unlock Front Door Lock	5
368	13	13	t	Unlock Front Door Lock	5
369	2	1	t	Turn Roomba Off	18
370	64	22	t	Turn Off Smart Faucet's water	17
371	13	23	t	Lock Smart Oven	13
372	13	23	t	Lock Smart Oven	13
373	14	14	t	Open Bedroom Window	5
374	14	14	t	Close Bedroom Window	5
375	14	14	t	Close Bedroom Window	5
376	14	14	t	Close Bedroom Window	5
377	66	8	t	Set Smart Refrigerator's temperature to 40	13
378	14	24	t	Open Bathroom Window	5
379	14	14	t	Open Bedroom Window	5
380	14	25	t	Open Living Room Window	5
381	13	23	t	Lock Smart Oven	13
382	13	23	t	Lock Smart Oven	13
383	57	2	t	Turn On the AC	8
384	66	8	t	Set Smart Refrigerator's temperature to 45	13
385	64	22	t	Turn Off Smart Faucet's water	17
386	14	14	t	Open Bedroom Window	5
387	14	14	t	Open Bedroom Window	5
388	14	14	t	Open Bedroom Window	5
389	14	14	t	Open Bedroom Window	5
390	21	2	t	Set Thermostat to 72	8
391	58	24	t	Close Bathroom Window's Curtains	5
392	58	14	t	Close Bedroom Window's Curtains	5
393	58	14	t	Close Bedroom Window's Curtains	5
394	13	13	t	Lock Front Door Lock	5
395	13	13	t	Lock Front Door Lock	5
396	2	1	t	Turn Roomba Off	18
397	2	1	t	Turn Roomba Off	18
398	2	5	t	Turn Smart TV Off	12
399	2	5	t	Turn Smart TV Off	12
400	2	5	t	Turn Smart TV Off	12
401	31	3	t	(Amazon Echo) Order 1 Medium Pizza(s) with Pepperoni	13
402	27	17	t	Set off Clock's alarm	9
403	14	25	t	Close Living Room Window	5
404	14	25	t	Close Living Room Window	5
405	57	2	t	Turn Off the AC	8
406	14	14	t	Open Bedroom Window	5
407	21	2	t	Set Thermostat to 72	8
408	57	2	t	Turn On the AC	8
409	21	2	t	Set Thermostat to 72	8
410	2	1	t	Turn Roomba Off	18
411	2	1	t	Turn Roomba Off	18
412	60	8	t	Close Smart Refrigerator's Door	13
413	2	1	t	Turn Roomba Off	18
414	14	25	t	Open Living Room Window	5
415	60	8	t	Close Smart Refrigerator's Door	13
416	66	8	t	Set Smart Refrigerator's temperature to 45	13
417	58	24	t	Close Bathroom Window's Curtains	5
418	66	8	t	Set Smart Refrigerator's temperature to 45	13
419	64	22	t	Turn Off Smart Faucet's water	17
420	13	14	t	Lock Bedroom Window	4
421	13	13	t	Lock Front Door Lock	4
422	57	2	t	Turn On the AC	8
423	21	2	t	Set Thermostat to 70	8
424	21	2	t	Set Thermostat to 70	8
425	60	8	t	Close Smart Refrigerator's Door	13
426	66	8	t	Set Smart Refrigerator's temperature to 41	13
427	2	9	t	Turn Coffee Pot Off	13
428	40	10	t	Turn Security Camera's Siren On	4
430	14	14	t	Close Bedroom Window	5
431	60	8	t	Close Smart Refrigerator's Door	13
432	6	4	t	Set HUE Lights's Color to Orange	2
433	14	24	t	Open Bathroom Window	5
434	60	8	t	Close Smart Refrigerator's Door	13
435	8	7	t	Set Speakers's Volume to 14	3
436	14	14	t	Open Bedroom Window	5
437	64	22	t	Turn Off Smart Faucet's water	17
438	2	1	t	Turn Roomba Off	18
439	13	23	t	Lock Smart Oven	13
440	14	14	t	Open Bedroom Window	5
441	60	8	t	Close Smart Refrigerator's Door	13
442	14	14	t	Close Bedroom Window	5
443	58	14	t	Close Bedroom Window's Curtains	5
444	14	14	t	Close Bedroom Window	5
445	58	25	t	Close Living Room Window's Curtains	5
446	14	14	t	Close Bedroom Window	5
447	56	3	t	Stop playing music on Amazon Echo	3
448	60	23	t	Close Smart Oven's Door	13
449	57	2	t	Turn On the AC	8
450	13	13	t	Lock Front Door Lock	4
451	13	14	t	Lock Bedroom Window	4
452	14	24	t	Open Bathroom Window	5
453	66	8	t	Set Smart Refrigerator's temperature to 40	13
454	2	1	t	Turn Roomba On	18
455	14	25	t	Open Living Room Window	5
456	14	14	t	Open Bedroom Window	5
457	21	2	t	Set Thermostat to 72	8
458	14	14	t	Close Bedroom Window	5
459	14	14	t	Open Bedroom Window	5
460	14	25	t	Open Living Room Window	5
461	2	1	t	Turn Roomba On	1
462	60	23	t	Close Smart Oven's Door	13
463	14	14	t	Close Bedroom Window	5
464	2	1	t	Turn Roomba Off	18
465	57	2	t	Turn On the AC	8
466	14	14	t	Close Bedroom Window	5
467	14	14	t	Close Bedroom Window	5
468	14	14	t	Close Bedroom Window	5
469	66	8	t	Set Smart Refrigerator's temperature to 40	13
470	14	14	t	Close Bedroom Window	5
471	14	14	t	Close Bedroom Window	5
472	66	8	t	Set Smart Refrigerator's temperature to 30	13
473	14	14	t	Open Bedroom Window	5
475	2	1	t	Turn Roomba Off	18
476	64	22	t	Turn Off Smart Faucet's water	17
477	14	14	t	Open Bedroom Window	5
478	64	22	t	Turn Off Smart Faucet's water	17
479	2	1	t	Turn Roomba Off	18
480	66	8	t	Set Smart Refrigerator's temperature to 45	13
481	13	13	t	Lock Front Door Lock	4
482	64	22	t	Turn Off Smart Faucet's water	17
483	2	1	t	Turn Roomba On	18
484	2	5	t	Turn Smart TV Off	12
485	21	2	t	Set Thermostat to 72	8
488	13	13	t	Lock Front Door Lock	5
489	27	17	t	Set off Clock's alarm	9
490	56	3	t	Stop playing music on Amazon Echo	3
491	66	8	t	Set Smart Refrigerator's temperature to 40	13
492	2	1	t	Turn Roomba Off	18
493	2	9	t	Turn Coffee Pot Off	13
494	2	1	t	Turn Roomba On	18
495	66	8	t	Set Smart Refrigerator's temperature to 42	13
496	58	24	t	Close Bathroom Window's Curtains	5
497	21	2	t	Set Thermostat to 73	8
498	21	2	t	Set Thermostat to 73	8
499	21	2	t	Set Thermostat to 73	8
500	21	2	t	Set Thermostat to 73	8
501	58	24	t	Close Bathroom Window's Curtains	5
502	56	3	t	Stop playing music on Amazon Echo	3
503	9	3	t	Start playing Jazz on Amazon Echo	3
504	14	14	t	Close Bedroom Window	5
505	64	22	t	Turn Off Smart Faucet's water	17
506	9	3	t	Start playing Country on Amazon Echo	3
507	14	25	t	Open Living Room Window	5
508	9	3	t	Start playing Country on Amazon Echo	3
509	57	2	t	Turn Off the AC	8
510	27	17	t	Set off Clock's alarm	9
511	14	25	t	Close Living Room Window	5
512	57	2	t	Turn Off the AC	8
513	57	2	t	Turn On the AC	8
514	14	24	t	Close Bathroom Window	5
515	21	2	t	Set Thermostat to 73	8
516	13	23	t	Lock Smart Oven	13
517	14	25	t	Close Living Room Window	5
518	64	22	t	Turn On Smart Faucet's water	17
519	14	24	t	Close Bathroom Window	5
520	14	24	t	Close Bathroom Window	5
521	2	1	t	Turn Roomba Off	18
522	27	17	t	Set off Clock's alarm	9
523	14	14	t	Close Bedroom Window	5
524	13	23	t	Unlock Smart Oven	13
526	2	1	t	Turn Roomba Off	18
527	13	23	t	Lock Smart Oven	13
528	21	2	t	Set Thermostat to 73	8
529	13	23	t	Unlock Smart Oven	13
530	2	1	t	Turn Roomba On	18
531	27	17	t	Set off Clock's alarm	9
532	64	22	t	Turn On Smart Faucet's water	17
533	2	1	t	Turn Roomba Off	18
534	21	2	t	Set Thermostat to 70	8
535	2	1	t	Turn Roomba Off	18
536	2	1	t	Turn Roomba On	18
537	2	1	t	Turn Roomba On	18
538	64	22	t	Turn Off Smart Faucet's water	17
539	21	2	t	Set Thermostat to 77	8
540	56	3	t	Stop playing music on Amazon Echo	3
541	2	7	t	Turn Speakers Off	1
542	35	3	t	Start playing a different genre on Amazon Echo	3
543	13	13	t	Lock Front Door Lock	5
544	64	22	t	Turn Off Smart Faucet's water	17
545	64	22	t	Turn Off Smart Faucet's water	17
546	64	22	t	Turn Off Smart Faucet's water	17
547	14	25	t	Open Living Room Window	5
548	2	1	t	Turn Roomba Off	18
857	2	1	t	Turn Roomba On	18
549	58	24	t	Close Bathroom Window's Curtains	5
550	60	8	t	Close Smart Refrigerator's Door	13
551	21	2	t	Set Thermostat to 69	8
552	21	2	t	Set Thermostat to 69	8
553	21	2	t	Set Thermostat to 69	8
554	21	2	t	Set Thermostat to 69	8
555	2	1	t	Turn Roomba On	18
556	13	13	t	Lock Front Door Lock	5
557	2	9	t	Turn Coffee Pot Off	1
558	2	1	t	Turn Roomba Off	18
559	2	1	t	Turn Roomba Off	18
560	21	2	t	Set Thermostat to 74	8
561	2	1	t	Turn Roomba Off	18
562	58	24	t	Close Bathroom Window's Curtains	5
563	14	14	t	Close Bedroom Window	5
564	14	14	t	Close Bedroom Window	5
565	9	7	t	Start playing Jazz on Speakers	3
566	60	8	t	Close Smart Refrigerator's Door	13
568	14	14	t	Close Bedroom Window	5
569	2	23	t	Turn Smart Oven Off	13
570	9	3	t	Start playing Hip-Hop on Amazon Echo	3
571	60	8	t	Close Smart Refrigerator's Door	13
572	14	14	t	Close Bedroom Window	5
573	14	14	t	Close Bedroom Window	5
574	64	22	t	Turn Off Smart Faucet's water	17
575	14	14	t	Close Bedroom Window	5
576	64	22	t	Turn Off Smart Faucet's water	17
577	14	14	t	Close Bedroom Window	5
578	58	24	t	Close Bathroom Window's Curtains	5
579	21	2	t	Set Thermostat to 60	8
580	14	14	t	Open Bedroom Window	5
581	2	5	t	Turn Smart TV Off	12
582	14	14	t	Open Bedroom Window	5
583	21	2	t	Set Thermostat to 72	8
584	14	24	t	Open Bathroom Window	5
585	58	25	t	Close Living Room Window's Curtains	5
586	14	14	t	Open Bedroom Window	5
587	14	14	t	Open Bedroom Window	5
588	14	24	t	Open Bathroom Window	5
589	56	3	t	Stop playing music on Amazon Echo	3
590	14	25	t	Open Living Room Window	5
591	14	25	t	Open Living Room Window	5
592	14	14	t	Open Bedroom Window	5
593	21	2	t	Set Thermostat to 73	8
594	14	14	t	Open Bedroom Window	5
595	2	1	t	Turn Roomba Off	18
596	14	24	t	Open Bathroom Window	5
597	2	1	t	Turn Roomba On	18
598	2	1	t	Turn Roomba Off	18
599	13	13	t	Lock Front Door Lock	5
600	13	23	t	Lock Smart Oven	13
601	13	23	t	Lock Smart Oven	13
602	14	14	t	Open Bedroom Window	5
603	58	25	t	Close Living Room Window's Curtains	5
604	2	5	t	Turn Smart TV Off	12
605	14	14	t	Open Bedroom Window	5
606	58	14	t	Close Bedroom Window's Curtains	5
607	57	2	t	Turn On the AC	8
608	21	2	t	Set Thermostat to 72	8
611	2	7	t	Turn Speakers Off	3
612	2	1	t	Turn Roomba Off	18
613	57	2	t	Turn Off the AC	8
614	14	24	t	Open Bathroom Window	5
615	13	23	t	Lock Smart Oven	13
616	14	14	t	Open Bedroom Window	5
617	14	25	t	Open Living Room Window	5
618	2	5	t	Turn Smart TV Off	12
619	14	24	t	Open Bathroom Window	5
620	14	14	t	Open Bedroom Window	5
621	14	25	t	Open Living Room Window	5
622	2	1	t	Turn Roomba Off	18
623	21	2	t	Set Thermostat to 70	8
624	21	2	t	Set Thermostat to 73	8
625	21	2	t	Set Thermostat to 73	8
626	2	1	t	Turn Roomba On	18
627	60	8	t	Close Smart Refrigerator's Door	13
628	56	3	t	Stop playing music on Amazon Echo	3
629	56	3	t	Stop playing music on Amazon Echo	3
630	35	3	t	Start playing Ice Ice Baby on Amazon Echo	3
631	66	8	t	Set Smart Refrigerator's temperature to 45	13
632	58	24	t	Close Bathroom Window's Curtains	5
633	58	24	t	Close Bathroom Window's Curtains	5
634	60	8	t	Close Smart Refrigerator's Door	13
635	66	8	t	Set Smart Refrigerator's temperature to 40	13
636	64	22	t	Turn Off Smart Faucet's water	17
637	66	8	t	Set Smart Refrigerator's temperature to 41	13
638	66	8	t	Set Smart Refrigerator's temperature to 41	13
639	13	13	t	Lock Front Door Lock	4
640	2	1	t	Turn Roomba Off	18
641	66	8	t	Set Smart Refrigerator's temperature to 41	13
642	58	24	t	Close Bathroom Window's Curtains	5
643	14	25	t	Open Living Room Window	5
644	57	2	t	Turn On the AC	8
645	14	14	t	Close Bedroom Window	5
646	14	14	t	Close Bedroom Window	5
647	2	5	t	Turn Smart TV Off	12
648	14	25	t	Open Living Room Window	5
649	14	14	t	Close Bedroom Window	5
650	14	14	t	Open Bedroom Window	5
652	2	5	t	Turn Smart TV Off	12
653	66	8	t	Set Smart Refrigerator's temperature to 41	13
654	66	8	t	Set Smart Refrigerator's temperature to 41	13
655	9	3	t	Start playing Hip-Hop on Amazon Echo	3
657	58	24	t	Close Bathroom Window's Curtains	5
658	58	24	t	Close Bathroom Window's Curtains	5
659	9	3	t	Start playing Jazz on Amazon Echo	3
660	9	3	t	Start playing R&B on Amazon Echo	3
661	9	3	t	Start playing Rap on Amazon Echo	3
662	9	3	t	Start playing Country on Amazon Echo	3
663	9	3	t	Start playing News on Amazon Echo	3
664	58	25	t	Close Living Room Window's Curtains	5
665	9	3	t	Start playing Jazz on Amazon Echo	3
666	2	5	t	Turn Smart TV Off	12
667	14	14	t	Open Bedroom Window	5
668	14	25	t	Open Living Room Window	5
669	64	22	t	Turn Off Smart Faucet's water	17
670	6	4	t	Set HUE Lights's Color to Red	2
671	58	25	t	Close Living Room Window's Curtains	5
672	60	8	t	Close Smart Refrigerator's Door	13
673	60	8	t	Close Smart Refrigerator's Door	13
674	57	2	t	Turn On the AC	8
675	21	2	t	Set Thermostat to 79	8
676	60	8	t	Close Smart Refrigerator's Door	13
677	56	3	t	Stop playing music on Amazon Echo	3
678	14	25	t	Close Living Room Window	5
679	2	4	t	Turn HUE Lights Off	2
680	64	22	t	Turn Off Smart Faucet's water	17
681	2	5	t	Turn Smart TV Off	12
682	21	2	t	Set Thermostat to 65	8
683	2	1	t	Turn Roomba Off	18
684	13	13	t	Lock Front Door Lock	4
685	2	4	t	Turn HUE Lights On	1
687	60	8	t	Close Smart Refrigerator's Door	13
688	14	25	t	Open Living Room Window	5
689	13	13	t	Lock Front Door Lock	4
690	14	24	t	Open Bathroom Window	5
691	21	2	t	Set Thermostat to 72	8
692	56	3	t	Stop playing music on Amazon Echo	3
693	13	13	t	Lock Front Door Lock	4
694	21	2	t	Set Thermostat to 72	8
695	14	25	t	Open Living Room Window	5
696	58	24	t	Close Bathroom Window's Curtains	5
697	21	2	t	Set Thermostat to 72	8
698	64	22	t	Turn Off Smart Faucet's water	17
699	64	22	t	Turn Off Smart Faucet's water	17
700	2	1	t	Turn Roomba Off	18
701	58	24	t	Close Bathroom Window's Curtains	5
702	58	14	t	Open Bedroom Window's Curtains	5
703	57	2	t	Turn On the AC	8
705	58	24	t	Close Bathroom Window's Curtains	5
706	64	22	t	Turn Off Smart Faucet's water	17
707	40	10	t	Turn Security Camera's Siren On	4
708	57	2	t	Turn On the AC	8
709	13	13	t	Lock Front Door Lock	4
710	2	1	t	Turn Roomba Off	18
711	57	2	t	Turn On the AC	8
712	64	22	t	Turn Off Smart Faucet's water	17
713	60	8	t	Close Smart Refrigerator's Door	13
714	13	13	t	Lock Front Door Lock	4
715	13	13	t	Unlock Front Door Lock	4
716	2	1	t	Turn Roomba On	18
718	56	3	t	Stop playing music on Amazon Echo	3
719	35	3	t	Start playing jazz on Amazon Echo	3
720	14	14	t	Close Bedroom Window	5
721	2	1	t	Turn Roomba On	18
722	14	14	t	Close Bedroom Window	5
723	14	14	t	Close Bedroom Window	5
724	66	8	t	Set Smart Refrigerator's temperature to 40	13
725	66	8	t	Set Smart Refrigerator's temperature to 40	13
727	13	23	t	Lock Smart Oven	13
728	13	13	t	Lock Front Door Lock	5
729	21	2	t	Set Thermostat to 73	8
730	13	13	t	Lock Front Door Lock	4
731	14	14	t	Open Bedroom Window	5
732	64	22	t	Turn Off Smart Faucet's water	17
733	57	2	t	Turn Off the AC	8
734	14	24	t	Open Bathroom Window	5
735	21	2	t	Set Thermostat to 73	8
736	2	5	t	Turn Smart TV Off	12
737	14	14	t	Open Bedroom Window	5
738	66	8	t	Set Smart Refrigerator's temperature to 40	13
739	64	22	t	Turn Off Smart Faucet's water	17
740	58	24	t	Close Bathroom Window's Curtains	5
741	2	7	t	Turn Speakers Off	1
742	60	8	t	Close Smart Refrigerator's Door	13
743	9	3	t	Start playing Country on Amazon Echo	3
744	14	14	t	Close Bedroom Window	5
745	58	24	t	Close Bathroom Window's Curtains	5
746	58	14	t	Close Bedroom Window's Curtains	5
747	14	14	t	Close Bedroom Window	5
748	9	3	t	Start playing R&B on Amazon Echo	3
749	58	25	t	Close Living Room Window's Curtains	5
750	14	25	t	Open Living Room Window	5
751	14	14	t	Close Bedroom Window	5
752	58	14	t	Close Bedroom Window's Curtains	5
753	14	14	t	Close Bedroom Window	5
754	58	24	t	Close Bathroom Window's Curtains	5
755	13	23	t	Lock Smart Oven	13
756	14	14	t	Close Bedroom Window	5
757	14	14	t	Close Bedroom Window	5
758	14	14	t	Open Bedroom Window	5
759	58	24	t	Close Bathroom Window's Curtains	5
760	56	3	t	Stop playing music on Amazon Echo	3
761	14	14	t	Open Bedroom Window	5
762	57	2	t	Turn Off the AC	8
763	56	3	t	Stop playing music on Amazon Echo	3
764	21	2	t	Set Thermostat to 75	8
765	60	8	t	Close Smart Refrigerator's Door	13
766	2	23	t	Turn Smart Oven Off	13
767	2	1	t	Turn Roomba Off	18
768	14	24	t	Open Bathroom Window	5
769	14	25	t	Open Living Room Window	5
770	2	1	t	Turn Roomba On	18
771	60	8	t	Close Smart Refrigerator's Door	13
772	13	23	t	Lock Smart Oven	13
773	14	14	t	Close Bedroom Window	5
774	14	14	t	Open Bedroom Window	5
775	14	14	t	Open Bedroom Window	5
776	13	23	t	Unlock Smart Oven	13
777	14	25	t	Open Living Room Window	5
778	14	14	t	Close Bedroom Window	5
779	58	24	t	Close Bathroom Window's Curtains	5
780	14	24	t	Open Bathroom Window	5
781	2	1	t	Turn Roomba Off	1
782	14	14	t	Close Bedroom Window	5
783	2	1	t	Turn Roomba Off	1
784	2	1	t	Turn Roomba Off	1
785	2	1	t	Turn Roomba Off	18
786	57	2	t	Turn On the AC	8
787	13	23	t	Lock Smart Oven	13
788	64	22	t	Turn Off Smart Faucet's water	13
789	13	23	t	Unlock Smart Oven	13
790	60	8	t	Close Smart Refrigerator's Door	13
791	56	3	t	Stop playing music on Amazon Echo	3
792	57	2	t	Turn On the AC	8
793	35	3	t	Start playing music  on Amazon Echo	3
794	14	14	t	Close Bedroom Window	5
795	14	25	t	Open Living Room Window	5
797	13	23	t	Lock Smart Oven	13
798	13	13	t	Lock Front Door Lock	5
799	14	14	t	Close Bedroom Window	5
800	14	14	t	Close Bedroom Window	5
801	14	14	t	Close Bedroom Window	5
802	2	1	t	Turn Roomba Off	18
803	21	2	t	Set Thermostat to 70	8
804	2	1	t	Turn Roomba Off	18
805	2	1	t	Turn Roomba Off	18
806	57	2	t	Turn On the AC	8
807	2	1	t	Turn Roomba Off	18
808	2	1	t	Turn Roomba Off	18
809	2	1	t	Turn Roomba Off	18
810	2	1	t	Turn Roomba On	18
811	9	3	t	Start playing Jazz on Amazon Echo	3
812	2	1	t	Turn Roomba Off	18
813	14	14	t	Open Bedroom Window	5
814	14	24	t	Open Bathroom Window	5
815	56	3	t	Stop playing music on Amazon Echo	3
816	14	14	t	Open Bedroom Window	5
817	14	14	t	Open Bedroom Window	5
818	14	25	t	Open Living Room Window	5
819	60	8	t	Close Smart Refrigerator's Door	13
820	64	22	t	Turn Off Smart Faucet's water	17
821	2	23	t	Turn Smart Oven Off	13
822	13	13	t	Lock Front Door Lock	5
824	2	1	t	Turn Roomba Off	18
825	58	25	t	Close Living Room Window's Curtains	5
826	58	14	t	Close Bedroom Window's Curtains	5
827	58	24	t	Close Bathroom Window's Curtains	5
828	57	2	t	Turn On the AC	8
829	2	1	t	Turn Roomba Off	18
830	6	4	t	Set HUE Lights's Color to Red	2
831	6	4	t	Set HUE Lights's Color to Red	2
832	64	22	t	Turn Off Smart Faucet's water	17
833	14	14	t	Close Bedroom Window	5
834	13	23	t	Lock Smart Oven	13
835	57	2	t	Turn On the AC	8
836	9	7	t	Start playing Pop on Speakers	3
837	66	8	t	Set Smart Refrigerator's temperature to 45	13
838	2	5	t	Turn Smart TV Off	12
839	35	7	t	Start playing Rock on Speakers	3
840	21	2	t	Set Thermostat to 72	8
841	14	14	t	Open Bedroom Window	5
842	56	3	t	Stop playing music on Amazon Echo	3
843	2	1	t	Turn Roomba Off	18
844	58	14	t	Close Bedroom Window's Curtains	5
845	2	1	t	Turn Roomba Off	18
846	2	23	t	Turn Smart Oven Off	13
847	64	22	t	Turn Off Smart Faucet's water	17
848	66	8	t	Set Smart Refrigerator's temperature to 49	13
849	2	1	t	Turn Roomba Off	18
850	58	24	t	Close Bathroom Window's Curtains	5
851	60	8	t	Close Smart Refrigerator's Door	13
852	2	1	t	Turn Roomba Off	18
853	13	23	t	Lock Smart Oven	13
854	13	23	t	Lock Smart Oven	13
855	60	8	t	Close Smart Refrigerator's Door	13
856	13	23	t	Lock Smart Oven	13
858	66	8	t	Set Smart Refrigerator's temperature to 40	13
859	2	5	t	Turn Smart TV Off	1
860	14	25	t	Open Living Room Window	5
861	14	24	t	Open Bathroom Window	5
862	14	14	t	Open Bedroom Window	5
863	2	5	t	Turn Smart TV Off	12
864	13	23	t	Lock Smart Oven	13
865	57	2	t	Turn On the AC	8
866	57	2	t	Turn On the AC	8
867	64	22	t	Turn Off Smart Faucet's water	13
868	14	25	t	Open Living Room Window	5
869	14	25	t	Open Living Room Window	5
870	14	24	t	Open Bathroom Window	5
871	57	2	t	Turn On the AC	8
872	57	2	t	Turn On the AC	8
873	14	24	t	Open Bathroom Window	5
874	14	25	t	Open Living Room Window	5
875	58	14	t	Close Bedroom Window's Curtains	5
876	2	1	t	Turn Roomba Off	18
877	9	3	t	Start playing R&B on Amazon Echo	3
878	13	13	t	Lock Front Door Lock	5
879	14	14	t	Open Bedroom Window	5
880	14	14	t	Close Bedroom Window	5
881	14	14	t	Open Bedroom Window	5
882	56	3	t	Stop playing music on Amazon Echo	3
883	14	14	t	Close Bedroom Window	5
884	64	22	t	Turn On Smart Faucet's water	17
885	9	3	t	Start playing R&B on Amazon Echo	3
886	64	22	t	Turn Off Smart Faucet's water	17
887	66	8	t	Set Smart Refrigerator's temperature to 40	13
888	2	1	t	Turn Roomba Off	18
889	66	8	t	Set Smart Refrigerator's temperature to 40	13
890	13	23	t	Lock Smart Oven	13
891	13	23	t	Lock Smart Oven	13
892	2	5	t	Turn Smart TV On	12
893	2	1	t	Turn Roomba Off	18
894	2	5	t	Turn Smart TV Off	12
895	2	1	t	Turn Roomba Off	18
896	2	1	t	Turn Roomba Off	18
897	58	24	t	Close Bathroom Window's Curtains	5
898	66	8	t	Set Smart Refrigerator's temperature to 40	13
899	2	1	t	Turn Roomba Off	18
900	14	14	t	Open Bedroom Window	5
901	60	8	t	Close Smart Refrigerator's Door	13
902	64	22	t	Turn Off Smart Faucet's water	17
903	64	22	t	Turn Off Smart Faucet's water	17
904	13	23	t	Lock Smart Oven	13
905	2	1	t	Turn Roomba Off	18
906	60	8	t	Close Smart Refrigerator's Door	13
907	58	24	t	Close Bathroom Window's Curtains	5
908	56	3	t	Stop playing music on Amazon Echo	3
909	2	5	t	Turn Smart TV Off	12
910	13	13	t	Lock Front Door Lock	4
911	2	1	t	Turn Roomba Off	18
912	27	17	t	Set off Clock's alarm	9
913	27	17	t	Set off Clock's alarm	9
914	21	2	t	Set Thermostat to 73	8
915	56	3	t	Stop playing music on Amazon Echo	3
916	21	2	t	Set Thermostat to 80	8
917	2	1	t	Turn Roomba On	18
918	13	14	t	Unlock Bedroom Window	4
919	58	24	t	Close Bathroom Window's Curtains	5
920	58	24	t	Close Bathroom Window's Curtains	5
921	14	14	t	Open Bedroom Window	5
922	56	3	t	Stop playing music on Amazon Echo	3
923	57	2	t	Turn On the AC	8
924	14	24	t	Open Bathroom Window	5
925	2	1	t	Turn Roomba Off	18
926	64	22	t	Turn Off Smart Faucet's water	17
927	14	25	t	Open Living Room Window	5
928	56	3	t	Stop playing music on Amazon Echo	3
929	13	14	t	Unlock Bedroom Window	5
930	13	14	t	Unlock Bedroom Window	5
931	14	25	t	Open Living Room Window	5
932	14	14	t	Open Bedroom Window	5
933	57	2	t	Turn On the AC	8
934	14	24	t	Open Bathroom Window	5
935	14	24	t	Open Bathroom Window	5
936	14	14	t	Open Bedroom Window	5
937	9	3	t	Start playing Hip-Hop on Amazon Echo	3
938	57	2	t	Turn On the AC	8
939	57	2	t	Turn On the AC	8
940	57	2	t	Turn On the AC	8
941	58	25	t	Close Living Room Window's Curtains	5
942	64	22	t	Turn Off Smart Faucet's water	17
943	14	14	t	Open Bedroom Window	5
944	40	10	t	Turn Security Camera's Siren On	4
945	40	10	t	Turn Security Camera's Siren On	4
946	14	14	t	Close Bedroom Window	5
947	2	5	t	Turn Smart TV Off	12
948	60	8	t	Close Smart Refrigerator's Door	13
949	56	3	t	Stop playing music on Amazon Echo	3
950	58	24	t	Close Bathroom Window's Curtains	5
951	21	2	t	Set Thermostat to 73	8
952	64	22	t	Turn Off Smart Faucet's water	17
953	64	22	t	Turn Off Smart Faucet's water	17
954	14	14	t	Close Bedroom Window	5
955	13	23	t	Lock Smart Oven	13
956	56	3	t	Stop playing music on Amazon Echo	3
957	21	2	t	Set Thermostat to 75	8
958	21	2	t	Set Thermostat to 80	8
960	13	23	t	Lock Smart Oven	13
961	58	25	t	Close Living Room Window's Curtains	5
962	13	23	t	Lock Smart Oven	13
963	58	24	t	Close Bathroom Window's Curtains	5
964	66	8	t	Set Smart Refrigerator's temperature to 40	13
965	58	24	t	Close Bathroom Window's Curtains	5
966	13	23	t	Lock Smart Oven	13
967	2	1	t	Turn Roomba On	18
968	57	2	t	Turn On the AC	8
969	60	23	t	Close Smart Oven's Door	13
971	13	13	t	Lock Front Door Lock	5
972	40	10	t	Turn Security Camera's Siren On	4
973	40	10	t	Turn Security Camera's Siren On	4
974	13	13	t	Lock Front Door Lock	5
975	14	24	t	Open Bathroom Window	5
976	35	3	t	Start playing something else on Amazon Echo	3
977	21	2	t	Set Thermostat to 75	8
978	64	22	t	Turn Off Smart Faucet's water	17
979	2	1	t	Turn Roomba Off	18
980	64	22	t	Turn Off Smart Faucet's water	17
981	13	23	t	Lock Smart Oven	13
982	58	25	t	Close Living Room Window's Curtains	5
983	14	14	t	Close Bedroom Window	5
985	26	17	t	(Clock) Set an Alarm for 02:00	9
986	2	5	t	Turn Smart TV Off	12
987	14	14	t	Close Bedroom Window	5
988	14	25	t	Open Living Room Window	5
989	14	14	t	Open Bedroom Window	5
990	14	14	t	Close Bedroom Window	5
991	14	14	t	Open Bedroom Window	5
992	58	24	t	Close Bathroom Window's Curtains	5
993	14	14	t	Close Bedroom Window	5
994	13	13	t	Unlock Front Door Lock	5
995	14	24	t	Open Bathroom Window	5
996	30	3	t	(Amazon Echo) Order 3 1 on Amazon	11
997	14	14	t	Close Bedroom Window	5
998	14	14	t	Close Bedroom Window	5
999	21	2	t	Set Thermostat to 72	8
1000	57	2	t	Turn On the AC	8
1001	14	14	t	Close Bedroom Window	5
1002	27	17	t	Set off Clock's alarm	9
1003	14	14	t	Close Bedroom Window	5
1004	58	24	t	Close Bathroom Window's Curtains	5
1005	14	14	t	Close Bedroom Window	5
1006	36	5	t	Tune Smart TV to Channel 699	12
1007	2	1	t	Turn Roomba Off	18
1008	2	5	t	Turn Smart TV Off	12
1009	60	8	t	Close Smart Refrigerator's Door	13
1010	60	8	t	Close Smart Refrigerator's Door	13
1011	60	8	t	Close Smart Refrigerator's Door	13
1012	66	8	t	Set Smart Refrigerator's temperature to 35	13
1013	58	25	t	Close Living Room Window's Curtains	5
1014	2	1	t	Turn Roomba Off	18
1015	2	1	t	Turn Roomba Off	18
1016	58	14	t	Close Bedroom Window's Curtains	5
1017	58	24	t	Close Bathroom Window's Curtains	5
1018	58	25	t	Open Living Room Window's Curtains	5
1019	57	2	t	Turn On the AC	8
1020	58	14	t	Open Bedroom Window's Curtains	5
1021	21	2	t	Set Thermostat to 80	8
1022	58	24	t	Open Bathroom Window's Curtains	5
1023	57	2	t	Turn On the AC	8
1024	57	2	t	Turn On the AC	8
1025	14	14	t	Open Bedroom Window	5
1026	66	8	t	Set Smart Refrigerator's temperature to 43	13
1027	14	24	t	Open Bathroom Window	5
1028	14	25	t	Open Living Room Window	5
1029	2	5	t	Turn Smart TV Off	12
1030	14	24	t	Open Bathroom Window	5
1031	2	5	t	Turn Smart TV Off	12
1032	2	1	t	Turn Roomba Off	18
1033	60	8	t	Close Smart Refrigerator's Door	13
1034	13	13	t	Lock Front Door Lock	4
1035	2	1	t	Turn Roomba Off	18
1037	2	1	t	Turn Roomba On	18
1038	2	1	t	Turn Roomba Off	18
1039	2	1	t	Turn Roomba Off	18
1040	2	1	t	Turn Roomba Off	18
1041	58	25	t	Open Living Room Window's Curtains	5
1042	58	25	t	Close Living Room Window's Curtains	5
1043	57	2	t	Turn On the AC	8
1044	57	2	t	Turn On the AC	8
1045	57	2	t	Turn On the AC	8
1046	57	2	t	Turn On the AC	8
1047	57	2	t	Turn On the AC	8
1048	14	14	t	Close Bedroom Window	5
1049	64	22	t	Turn Off Smart Faucet's water	17
1051	57	2	t	Turn Off the AC	8
1052	57	2	t	Turn Off the AC	8
1053	14	14	t	Open Bedroom Window	5
1054	14	24	t	Open Bathroom Window	5
1055	14	25	t	Open Living Room Window	5
1056	35	3	t	Start playing Jazz on Amazon Echo	3
1057	14	14	t	Open Bedroom Window	5
1058	14	24	t	Open Bathroom Window	5
1059	9	3	t	Start playing R&B on Amazon Echo	3
1060	9	3	t	Start playing Country on Amazon Echo	3
1061	35	3	t	Start playing Jazz on Amazon Echo	3
1062	2	5	t	Turn Smart TV Off	12
1063	66	8	t	Set Smart Refrigerator's temperature to 43	13
1064	66	8	t	Set Smart Refrigerator's temperature to 43	13
1065	64	22	t	Turn Off Smart Faucet's water	17
1066	66	8	t	Set Smart Refrigerator's temperature to 43	13
1067	64	22	t	Turn Off Smart Faucet's water	17
1068	64	22	t	Turn Off Smart Faucet's water	17
1069	9	3	t	Start playing R&B on Amazon Echo	3
1070	2	1	t	Turn Roomba On	18
1071	2	1	t	Turn Roomba On	18
1072	21	2	t	Set Thermostat to 73	8
1073	66	8	t	Set Smart Refrigerator's temperature to 40	13
1074	21	2	t	Set Thermostat to 73	8
1075	2	5	t	Turn Smart TV Off	12
1076	14	14	t	Close Bedroom Window	5
1077	56	3	t	Stop playing music on Amazon Echo	3
1078	14	14	t	Close Bedroom Window	5
1079	14	14	t	Close Bedroom Window	5
1080	14	14	t	Close Bedroom Window	5
1081	57	2	t	Turn On the AC	8
1082	58	14	t	Open Bedroom Window's Curtains	5
1083	57	2	t	Turn On the AC	8
1084	57	2	t	Turn On the AC	8
1085	58	24	t	Close Bathroom Window's Curtains	5
1086	57	2	t	Turn On the AC	8
1087	2	23	t	Turn Smart Oven Off	13
1088	58	14	t	Close Bedroom Window's Curtains	5
1089	58	25	t	Close Living Room Window's Curtains	5
1090	56	3	t	Stop playing music on Amazon Echo	3
1091	9	3	t	Start playing Hip-Hop on Amazon Echo	3
1092	2	5	t	Turn Smart TV Off	1
1093	14	25	t	Open Living Room Window	5
1094	14	14	t	Close Bedroom Window	5
1095	2	1	t	Turn Roomba On	18
1096	21	2	t	Set Thermostat to 70	8
1097	14	14	t	Open Bedroom Window	5
1098	2	1	t	Turn Roomba Off	1
1099	2	1	t	Turn Roomba Off	1
1100	2	1	t	Turn Roomba Off	1
1101	2	1	t	Turn Roomba Off	18
1102	14	14	t	Close Bedroom Window	5
1103	14	14	t	Close Bedroom Window	5
1104	13	23	t	Lock Smart Oven	13
1106	2	1	t	Turn Roomba Off	1
1107	14	25	t	Open Living Room Window	5
1108	14	24	t	Open Bathroom Window	5
1109	66	8	t	Set Smart Refrigerator's temperature to 45	13
1110	14	14	t	Open Bedroom Window	5
1111	13	23	t	Lock Smart Oven	13
1112	13	13	t	Lock Front Door Lock	5
1113	64	22	t	Turn Off Smart Faucet's water	17
1114	13	13	t	Lock Front Door Lock	5
1115	27	17	t	Set off Clock's alarm	9
1116	60	8	t	Close Smart Refrigerator's Door	13
1117	64	22	t	Turn Off Smart Faucet's water	17
1118	2	1	t	Turn Roomba Off	18
1119	60	8	t	Close Smart Refrigerator's Door	13
1120	2	5	t	Turn Smart TV Off	1
1121	60	8	t	Close Smart Refrigerator's Door	13
1122	58	24	t	Close Bathroom Window's Curtains	5
1123	58	14	t	Close Bedroom Window's Curtains	5
1124	58	25	t	Close Living Room Window's Curtains	5
1125	13	13	t	Lock Front Door Lock	4
1126	40	10	t	Turn Security Camera's Siren On	4
1127	2	5	t	Turn Smart TV Off	1
1128	14	25	t	Open Living Room Window	5
1129	2	1	t	Turn Roomba On	18
1130	2	1	t	Turn Roomba On	18
1131	2	1	t	Turn Roomba On	18
1132	64	22	t	Turn Off Smart Faucet's water	17
1133	64	22	t	Turn On Smart Faucet's water	13
1134	64	22	t	Turn Off Smart Faucet's water	17
1135	64	22	t	Turn Off Smart Faucet's water	17
1136	64	22	t	Turn Off Smart Faucet's water	17
1137	64	22	t	Turn Off Smart Faucet's water	17
1138	56	3	t	Stop playing music on Amazon Echo	3
1139	56	3	t	Stop playing music on Amazon Echo	3
1140	21	2	t	Set Thermostat to 80	8
1141	57	2	t	Turn On the AC	8
1142	2	1	t	Turn Roomba On	18
1143	2	5	t	Turn Smart TV Off	12
1144	2	5	t	Turn Smart TV Off	12
1145	2	5	t	Turn Smart TV Off	12
1146	2	5	t	Turn Smart TV Off	1
1147	2	5	t	Turn Smart TV Off	12
1148	58	25	t	Open Living Room Window's Curtains	5
1149	14	14	t	Open Bedroom Window	5
1150	14	25	t	Open Living Room Window	5
1151	58	25	t	Close Living Room Window's Curtains	5
1152	57	2	t	Turn Off the AC	8
1153	21	2	t	Set Thermostat to 70	8
1154	57	2	t	Turn On the AC	8
1155	58	24	t	Close Bathroom Window's Curtains	5
1156	9	3	t	Start playing R&B on Amazon Echo	3
1157	58	14	t	Close Bedroom Window's Curtains	5
1158	9	3	t	Start playing R&B on Amazon Echo	3
1159	2	1	t	Turn Roomba Off	1
1160	27	17	t	Set off Clock's alarm	9
1161	13	23	t	Lock Smart Oven	13
1162	14	14	t	Close Bedroom Window	5
1163	2	5	t	Turn Smart TV Off	12
1164	13	13	t	Lock Front Door Lock	5
1165	14	25	t	Open Living Room Window	5
1166	14	14	t	Open Bedroom Window	5
1167	14	14	t	Open Bedroom Window	5
1168	58	25	t	Close Living Room Window's Curtains	5
1169	58	24	t	Close Bathroom Window's Curtains	5
1170	58	14	t	Close Bedroom Window's Curtains	5
1171	64	22	t	Turn Off Smart Faucet's water	17
1173	56	3	t	Stop playing music on Amazon Echo	3
1174	13	23	t	Lock Smart Oven	13
1177	57	2	t	Turn On the AC	8
1178	21	2	t	Set Thermostat to 72	8
1179	57	2	t	Turn Off the AC	8
1180	57	2	t	Turn Off the AC	8
1181	57	2	t	Turn Off the AC	8
1182	21	2	t	Set Thermostat to 62	8
1183	21	2	t	Set Thermostat to 62	8
1184	2	5	t	Turn Smart TV Off	1
1185	2	1	t	Turn Roomba Off	18
1186	2	1	t	Turn Roomba On	1
1187	13	23	t	Lock Smart Oven	13
1188	58	24	t	Close Bathroom Window's Curtains	5
1189	57	2	t	Turn On the AC	8
1190	14	25	t	Open Living Room Window	5
1191	14	24	t	Open Bathroom Window	5
1192	14	14	t	Open Bedroom Window	5
1193	13	13	t	Lock Front Door Lock	5
1194	13	13	t	Lock Front Door Lock	5
1195	13	13	t	Lock Front Door Lock	4
1196	66	8	t	Set Smart Refrigerator's temperature to 42	13
1197	66	8	t	Set Smart Refrigerator's temperature to 42	13
1198	58	24	t	Close Bathroom Window's Curtains	5
1199	2	1	t	Turn Roomba Off	18
1200	35	3	t	Start playing rock on Amazon Echo	3
1201	60	8	t	Close Smart Refrigerator's Door	13
1202	57	2	t	Turn On the AC	8
1203	13	23	t	Lock Smart Oven	13
1204	3	4	t	Set HUE Lights's Brightness to 3	2
1205	29	10	t	(Security Camera) Take a photo	10
1206	14	24	t	Close Bathroom Window	5
\.


--
-- Name: backend_state_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.backend_state_id_seq', 1206, true);


--
-- Data for Name: backend_statelog; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.backend_statelog (id, "timestamp", is_current, cap_id, dev_id, value, param_id) FROM stdin;
\.


--
-- Name: backend_statelog_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.backend_statelog_id_seq', 1, false);


--
-- Data for Name: backend_timeparam; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.backend_timeparam (parameter_ptr_id, mode) FROM stdin;
23	12
24	24
\.


--
-- Data for Name: backend_trigger; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.backend_trigger (id, cap_id, dev_id, chan_id, pos, text) FROM stdin;
94	60	8	13	0	Smart Refrigerator's door is Open
95	60	8	13	0	Smart Refrigerator's door is Open
96	64	22	17	0	Smart Faucet's water is running
97	14	14	5	0	Window is Open
98	64	22	17	0	Smart Faucet's water is running
100	2	4	2	0	HUE Lights is On
102	28	10	10	0	Security Camera is recording
103	60	23	13	0	Smart Oven's door is Open
104	63	12	15	0	Bobby is in Kitchen
107	2	4	2	0	HUE Lights is On
108	2	4	2	0	HUE Lights is On
111	60	8	13	0	Smart Refrigerator's door is Open
112	60	8	13	0	Smart Refrigerator's door is Open
114	6	4	2	0	HUE Lights's Color is not Red
115	64	22	17	0	Smart Faucet's water is running
116	14	14	5	0	Window is Open
117	19	2	8	0	(Thermostat) The temperature is above 70
118	14	14	5	0	Window is Open
119	20	18	7	0	(Weather Sensor) It is Raining
121	63	12	15	0	Anyone is in Home
122	9	3	3	0	Amazon Echo is playing Pop
126	58	14	5	0	Window's curtains are Open
127	2	1	1	0	Roomba turns On
129	14	14	5	0	Window Opens
41	61	21	16	0	(FitBit) I am Asleep
42	2	4	2	0	HUE Lights is On
43	62	21	16	0	(FitBit) My heart rate is 22BPM
44	6	4	2	0	HUE Lights's Color is Red
130	2	4	2	0	HUE Lights turns On
46	63	12	15	0	Anyone is in Living Room
131	61	21	16	0	(FitBit) I fall asleep
132	2	4	2	0	HUE Lights turns On
133	61	21	16	0	(FitBit) I fall asleep
50	64	22	13	0	Smart Faucet's water turns On
51	63	12	15	0	Anyone enters Kitchen
134	2	4	2	0	HUE Lights turns On
54	6	4	2	1	HUE Lights's Color stops being Red
55	64	22	17	0	Smart Faucet's water is not running
56	63	12	15	0	Anyone enters Kitchen
57	63	12	15	0	Anyone enters Kitchen
58	63	12	15	0	Anyone enters Kitchen
59	63	12	15	0	Anyone enters Kitchen
135	61	21	16	0	(FitBit) I fall asleep
61	61	21	16	0	(FitBit) I am Asleep
62	6	4	2	0	HUE Lights's Color is Red
137	61	21	16	0	(FitBit) I fall asleep
138	2	1	1	0	Roomba turns On
66	60	8	13	0	Smart Refrigerator's door is Open
139	61	21	16	0	(FitBit) I fall asleep
68	57	2	8	0	The AC is Off
69	28	10	10	0	Security Camera is recording
70	28	10	10	0	Security Camera is recording
71	28	10	10	0	Security Camera is recording
73	28	10	10	0	Security Camera is recording
74	38	9	13	0	(Coffee Pot) There are <28 cups of coffee brewed
141	61	21	16	0	(FitBit) I fall asleep
142	61	21	16	0	(FitBit) I am Asleep
143	2	4	2	0	HUE Lights is On
80	60	23	13	0	Smart Oven's door is Open
81	63	12	15	0	Bobby is in Kitchen
84	61	21	16	0	(FitBit) I wake up
149	38	9	13	0	(Coffee Pot) There are 1 cups of coffee brewed
150	14	14	5	0	Window is Open
151	20	18	7	0	It is Raining
152	14	14	5	0	Window is Open
153	19	2	8	0	(Thermostat) The temperature is above 70
154	19	2	8	0	(Thermostat) The temperature is below 80
155	14	14	5	0	Window is Open
156	19	2	8	0	(Thermostat) The temperature is above 70
157	19	2	8	0	(Thermostat) The temperature is below 80
158	20	18	7	0	It is Not Raining
159	14	14	5	0	Window is Open
160	20	18	7	0	It is Raining
162	20	18	7	0	It is Raining
163	60	23	13	0	Smart Oven's door is Open
164	63	12	15	0	Bobbie is in Kitchen
165	21	2	8	0	Thermostat is set to <80 degrees
166	21	2	8	0	Thermostat is set to <80 degrees
167	19	8	13	0	(Smart Refrigerator) The temperature is below 40
168	20	18	7	0	It is Raining
169	14	14	5	0	Window is Open
170	60	8	13	0	Smart Refrigerator's door is Open
171	14	14	5	0	Window is Open
172	19	18	8	0	(Weather Sensor) The temperature is below 80
173	19	18	8	1	(Weather Sensor) The temperature is above 70
174	20	18	7	0	It is Not Raining
175	21	2	8	0	Thermostat is set to >70 degrees
176	63	12	15	0	Anyone is in Home
177	21	2	8	0	Thermostat is set to >70 degrees
178	63	12	15	0	Anyone is in Home
179	21	2	8	0	Thermostat is set to <75 degrees
180	63	12	15	0	Anyone is in Home
181	58	14	5	0	Window's curtains Open
182	9	3	3	0	Amazon Echo starts playing Pop
183	2	1	1	0	Roomba turns On
184	58	14	5	0	Window's curtains are Open
185	13	13	4	0	Smart Door Lock becomes Unlocked
186	63	12	15	0	Family Member is not in Home
187	13	13	4	0	Smart Door Lock becomes Unlocked
188	63	12	15	0	A Family Member is not in Home
189	2	1	1	0	Roomba turns On
190	63	12	15	0	A Guest is in Home
193	2	4	2	0	HUE Lights is On
195	63	12	15	0	Bobbie is in Bedroom
196	2	5	12	0	Smart TV turns On
197	55	17	9	0	(Clock) It is Nighttime
198	2	5	12	0	Smart TV turns Off
199	2	5	12	0	Smart TV is On
200	2	4	2	0	HUE Lights turns Off
204	2	5	12	0	Smart TV turns On
205	55	17	9	0	It is Nighttime
209	28	10	10	0	Security Camera is recording
210	2	4	2	0	HUE Lights turns On
211	2	4	2	0	HUE Lights turns On
214	2	4	2	1	HUE Lights turns On
216	2	4	2	0	HUE Lights turns On
217	2	4	2	0	HUE Lights turns On
219	14	25	5	0	Living Room Window Opens
220	20	18	7	1	It is Raining
222	14	25	5	1	Living Room Window is Open
223	14	24	5	0	Bathroom Window Closes
224	14	14	5	1	Bedroom Window is Closed
225	14	25	5	2	Living Room Window is Closed
226	14	14	5	0	Bedroom Window Closes
227	14	24	5	1	Bathroom Window is Closed
228	14	25	5	2	Living Room Window is Closed
229	14	25	5	0	Living Room Window Closes
230	14	24	5	1	Bathroom Window is Closed
231	14	14	5	2	Bedroom Window is Closed
232	60	23	13	0	Smart Oven's door Opens
233	63	12	15	1	Bobbie is in Kitchen
234	63	12	15	0	Bobbie enters Kitchen
235	60	23	13	1	Smart Oven's door is Open
236	19	2	8	0	(Thermostat) The temperature goes above 80
237	19	8	13	0	(Smart Refrigerator) The temperature falls below 40
238	51	11	14	0	It becomes true that "Smart Faucet's water is not running" was last in effect 1m  ago
239	51	11	14	0	It becomes true that "Smart Faucet's water is not running" was last in effect 5m  ago
240	19	2	8	0	(Thermostat) The temperature falls below 80
241	19	2	8	1	(Thermostat) The temperature is above 70
242	18	18	7	2	(Weather Sensor) The weather is Clear
243	14	14	5	3	Bedroom Window is Closed
244	19	2	8	0	(Thermostat) The temperature goes above 70
245	19	2	8	1	(Thermostat) The temperature is below 80
246	18	18	7	2	(Weather Sensor) The weather is Clear
247	14	14	5	3	Bedroom Window is Closed
248	18	18	7	0	(Weather Sensor) The weather changes to Clear
249	19	2	8	1	(Thermostat) The temperature is below 80
250	19	2	8	2	(Thermostat) The temperature is above 70
251	14	14	5	3	Bedroom Window is Closed
252	14	14	5	0	Bedroom Window Closes
253	19	2	8	1	(Thermostat) The temperature is below 80
254	19	2	8	2	(Thermostat) The temperature is above 70
255	18	18	7	3	(Weather Sensor) The weather is Clear
256	2	1	18	0	Roomba is On
257	63	12	15	0	A Guest is in Home
258	13	14	4	0	Bedroom Window becomes Unlocked
259	2	1	18	1	Roomba is On
260	2	1	18	0	Roomba is On
261	63	12	15	0	Anyone is in Home
262	2	1	18	0	Roomba is On
263	63	12	15	0	Anyone is in Home
265	63	12	15	0	Anyone is in Home
267	2	1	18	0	Roomba is On
269	2	4	2	0	HUE Lights is On
271	2	4	2	0	HUE Lights is On
273	2	4	2	0	HUE Lights is On
274	2	4	2	0	HUE Lights is On
275	63	12	15	0	A Family Member is in Home
280	14	24	5	1	Bathroom Window is Closed
281	14	14	5	2	Bedroom Window is Closed
282	60	23	13	0	Smart Oven's door Opens
283	63	12	15	1	Bobbie is in Kitchen
284	21	2	8	0	Thermostat becomes set to >80 degrees
285	19	8	13	0	(Smart Refrigerator) The temperature falls below 40
286	52	11	14	0	It becomes true that "Smart Refrigerator's door Opens" last happened >1m  ago
287	51	11	14	0	It becomes true that "Smart Faucet's water is running" was last in effect >15s  ago
288	19	8	13	0	(Smart Refrigerator) The temperature becomes 40
289	19	8	13	0	(Smart Refrigerator) The temperature falls below 40
290	61	21	16	0	(FitBit) I fall asleep
291	52	11	14	1	"(FitBit) I fall asleep" last happened >30m  ago
292	2	5	12	2	Smart TV is On
293	19	18	8	0	(Weather Sensor) The temperature goes above 60
294	19	18	8	1	(Weather Sensor) The temperature is below 80
295	20	18	7	2	It is Not Raining
296	14	14	5	3	Bedroom Window is Closed
297	35	3	3	0	Pop starts playing on Amazon Echo
298	2	1	18	0	Roomba turns On
299	58	14	5	1	Bedroom Window's curtains are Open
300	13	13	5	0	Smart Door Lock becomes Unlocked
301	61	21	16	1	(FitBit) I am Asleep
302	2	1	18	0	Roomba turns On
303	52	11	14	1	"A Guest enters Home" last happened <3h  ago
304	52	11	14	0	It becomes true that "(FitBit) I fall asleep" last happened >30m  ago
305	2	5	12	1	Smart TV is On
306	60	8	13	0	Smart Refrigerator's door is Open
307	60	8	13	0	Smart Refrigerator's door is Open
308	21	2	8	0	Thermostat becomes set to <75 degrees
309	63	12	15	0	Anyone is in Home
310	21	2	8	0	Thermostat becomes set to 80 degrees
311	21	2	8	0	Thermostat becomes set to 80 degrees
312	2	5	12	0	Smart TV turns Off
313	61	21	16	0	(FitBit) I am Asleep
314	2	1	18	0	Roomba turns On
315	63	12	15	0	A Guest is in Home
316	13	13	5	0	Smart Door Lock becomes Unlocked
317	61	21	16	0	(FitBit) I am Asleep
318	2	1	18	0	Roomba is On
319	58	14	5	0	Bedroom Window's curtains are Open
320	35	3	3	0	Pop starts playing on Amazon Echo
321	58	24	5	0	Bathroom Window's curtains Open
322	21	2	8	0	Thermostat is set to <70 degrees
323	14	14	5	0	Bedroom Window is Open
324	19	18	8	0	(Weather Sensor) The temperature is above 60
325	19	18	8	0	(Weather Sensor) The temperature is below 80
326	20	18	7	0	It is Not Raining
330	64	22	17	0	Smart Faucet's water is running
331	60	8	13	0	Smart Refrigerator's door is Open
332	19	8	13	0	(Smart Refrigerator) The temperature is below 40
333	19	2	8	0	(Thermostat) The temperature is below 80
334	60	23	13	0	Smart Oven's door is Open
335	63	12	15	0	Bobbie is in Kitchen
336	14	25	5	0	Living Room Window is Open
337	20	18	7	0	It is Raining
338	60	23	13	0	Smart Oven's door Opens
339	2	23	13	0	Smart Oven is On
340	19	2	8	0	(Thermostat) The temperature goes above 80
341	2	1	18	0	Roomba turns On
342	63	12	15	0	A Guest is in Home
343	14	24	5	0	Bathroom Window is Closed
344	14	14	5	0	Bedroom Window is Closed
345	14	25	5	0	Living Room Window is Closed
346	55	17	9	0	It is Nighttime
347	2	4	2	0	HUE Lights is On
348	21	2	8	0	Thermostat is set below 75 degrees
349	63	12	15	0	Anyone is in Home
350	21	2	8	0	Thermostat is set above 70 degrees
351	63	12	15	0	Anyone is in Home
352	66	8	13	0	Smart Refrigerator's temperature is set below 40 degrees
353	57	2	8	0	The AC turns On
354	19	18	8	0	(Weather Sensor) The temperature is above 80
355	2	1	18	0	Roomba turns On
356	37	5	12	1	adam is playing on Smart TV
357	61	21	16	0	(FitBit) I am Asleep
358	2	1	18	0	Roomba is On
359	61	21	16	0	(FitBit) I am Asleep
360	2	1	18	0	Roomba is On
361	2	1	18	0	Roomba is Off
362	2	1	18	0	Roomba is Off
363	50	11	14	0	"undefined" has occurred 8 times in the last 
364	65	23	13	0	Smart Oven's temperature changes from 275 degrees
365	2	1	18	0	Roomba is Off
367	2	1	18	0	Roomba is On
368	9	3	3	0	Amazon Echo starts playing Pop
369	19	8	13	0	(Smart Refrigerator) The temperature falls below 40
370	19	2	8	0	(Thermostat) The temperature goes above 80
371	65	23	13	0	Smart Oven's temperature is above below 5 degrees
372	60	23	13	0	Smart Oven's door is Open
373	65	23	13	0	Smart Oven's temperature is above below 5 degrees
374	60	23	13	0	Smart Oven's door is Open
375	19	2	8	0	(Thermostat) The temperature is above 80
376	14	14	5	0	Bedroom Window is Open
377	19	2	8	0	(Thermostat) The temperature is below 60
378	63	12	6	0	Bobbie enters Kitchen
379	19	8	13	0	(Smart Refrigerator) The temperature falls below 40
380	9	3	3	0	Amazon Echo starts playing Pop
381	50	11	14	0	It becomes true that "Smart Faucet's water turns On" has occurred >1 times in the last 15s 
382	2	1	18	0	Roomba turns On
383	50	11	14	0	It becomes true that "Smart Faucet's water turns On" has occurred >1 times in the last 15s 
384	9	3	3	0	Amazon Echo is not playing Pop
385	14	14	5	0	Bedroom Window Closes
386	14	25	5	1	Living Room Window is Closed
387	14	24	5	2	Bathroom Window is Open
388	9	3	3	0	Amazon Echo is playing Pop
389	60	8	13	0	Smart Refrigerator's door is Open
390	60	8	13	0	Smart Refrigerator's door is Open
391	2	1	18	0	Roomba is On
397	2	5	12	0	Smart TV is On
398	61	21	16	0	(FitBit) I am Asleep
400	2	1	18	0	Roomba is On
403	64	22	17	0	Smart Faucet's water is not running
404	64	22	17	0	Smart Faucet's water is not running
405	14	24	5	0	Bathroom Window is Open
406	14	14	5	0	Bedroom Window is Closed
407	14	25	5	0	Living Room Window is Closed
408	14	14	5	0	Bedroom Window is Open
409	14	24	5	0	Bathroom Window is Closed
410	14	25	5	0	Living Room Window is Closed
411	64	22	17	0	Smart Faucet's water is running
412	64	22	17	0	Smart Faucet's water is not running
413	14	25	5	0	Living Room Window is Open
414	14	24	5	0	Bathroom Window is Closed
415	14	14	5	0	Bedroom Window is Closed
416	2	1	18	0	Roomba is On
417	25	17	9	0	(Clock) The time is{time/!=| not}{time/>| after}{time/<| before} 15:00
418	25	17	9	0	(Clock) The time is{time/!=| not}{time/>| after}{time/<| before} 00:00
419	19	2	8	0	(Thermostat) The temperature is below 80
420	2	1	18	0	Roomba is On
421	25	17	9	0	(Clock) The time is{time/!=| not}{time/>| after}{time/<| before} 15:00
422	25	17	9	1	(Clock) The time is{time/!=| not}{time/>| after}{time/<| before} 00:00
423	19	2	8	0	(Thermostat) The temperature is below 80
425	58	24	5	0	Bathroom Window's curtains are Closed
426	58	25	5	0	Living Room Window's curtains Open
427	2	1	18	1	Roomba is On
428	58	24	5	0	Bathroom Window's curtains are Closed
429	19	2	8	0	(Thermostat) The temperature goes above 80
430	19	2	8	0	(Thermostat) The temperature is 80
431	19	2	8	0	(Thermostat) The temperature goes above 80
432	19	2	8	0	(Thermostat) The temperature is 80
434	57	2	8	0	The AC is On
435	2	1	18	0	Roomba is Off
436	63	12	15	0	A Guest is in Home
438	63	12	6	0	Someone other than Anyone is not in Home
439	57	2	8	0	The AC turns On
440	19	2	8	0	(Thermostat) The temperature is 80
441	2	5	12	0	Smart TV is Off
442	61	21	16	0	(FitBit) I am Asleep
443	58	24	5	0	Bathroom Window's curtains are Open
445	58	24	5	0	Bathroom Window's curtains are Closed
446	19	2	8	0	(Thermostat) The temperature is above 80
448	19	2	8	0	(Thermostat) The temperature is above 80
449	63	12	15	0	Anyone is not in Home
452	2	1	18	0	Roomba is On
453	58	25	5	0	Living Room Window's curtains are Open
454	58	24	5	0	Bathroom Window's curtains are Open
455	58	25	5	0	Living Room Window's curtains are Open
456	19	2	8	0	(Thermostat) The temperature goes above 80
457	60	8	13	0	Smart Refrigerator's door is Open
458	60	8	13	0	Smart Refrigerator's door is Open
460	58	24	5	0	Bathroom Window's curtains Open
461	13	13	4	0	Front Door Lock is Locked
462	61	21	16	0	(FitBit) I am Asleep
463	63	12	6	0	A Guest enters Home
464	14	14	5	0	Bedroom Window is Open
465	14	14	5	0	Bedroom Window is Open
466	14	14	5	0	Bedroom Window is Open
467	19	18	8	0	(Weather Sensor) The temperature is above 60
468	19	18	8	0	(Weather Sensor) The temperature is below 80
469	13	13	4	0	Front Door Lock is Locked
470	61	21	16	0	(FitBit) I am Asleep
471	14	14	5	0	Bedroom Window is Open
472	19	18	8	0	(Weather Sensor) The temperature is above 60
473	19	18	8	0	(Weather Sensor) The temperature is below 80
474	20	18	7	0	It is Not Raining
475	58	24	5	0	Bathroom Window's curtains Open
476	52	11	14	0	It becomes true that "A Guest enters Home" last happened more than{time/=|exactly} 3h  ago
477	19	18	6	0	(Weather Sensor) The temperature is below 80
478	21	2	8	0	Thermostat becomes set to >75 degrees
479	63	12	6	0	Bobbie enters Kitchen
480	21	2	8	0	Thermostat is set to 73 degrees
481	19	2	8	0	(Thermostat) The temperature goes above 80
482	64	22	17	0	Smart Faucet's water turns Off
483	64	22	17	0	Smart Faucet's water is running
484	58	24	5	0	Bathroom Window's curtains Open
485	9	3	3	0	Amazon Echo starts playing Pop
486	61	21	16	0	(FitBit) I fall asleep
487	66	8	13	0	Smart Refrigerator's temperature is set to 39 degrees
488	66	8	13	0	Smart Refrigerator's temperature is set above 40 degrees
489	35	3	3	0	pop music stops playing on Amazon Echo
490	14	24	5	0	Bathroom Window Closes
491	14	14	5	1	Bedroom Window is Closed
492	14	25	5	0	Living Room Window Closes
493	14	24	5	1	Bathroom Window is Closed
494	14	25	5	0	Living Room Window Closes
495	14	14	5	1	Bedroom Window is Closed
496	60	8	13	0	Smart Refrigerator's door Opens
497	52	11	14	1	It becomes true that "Smart Refrigerator's door Opens" last happened {time/=|exactly} 2m  ago
498	21	2	8	0	Thermostat becomes set to 81 degrees
499	63	12	15	1	Anyone is in Home
500	14	25	5	2	Living Room Window is Closed
501	14	14	5	3	Bedroom Window is Closed
502	60	8	13	0	Smart Refrigerator's door Opens
503	52	11	14	1	It becomes true that "Smart Refrigerator's door Opens" last happened {time/=|exactly} 2m  ago
504	21	2	8	0	Thermostat becomes set to 81 degrees
505	63	12	15	1	Anyone is in Home
506	14	25	5	2	Living Room Window is Closed
507	14	14	5	3	Bedroom Window is Closed
508	2	5	12	0	Smart TV turns Off
509	61	21	6	0	(FitBit) I am Asleep
510	8	3	3	0	Amazon Echo's Volume becomes 0
511	9	3	3	0	Amazon Echo is playing Pop
512	64	22	17	0	Smart Faucet's water turns Off
513	64	22	17	0	Smart Faucet's water is running
514	2	5	12	0	Smart TV turns Off
515	61	21	6	0	(FitBit) I am Asleep
516	61	21	6	0	(FitBit) I fall asleep
517	63	12	6	0	Anyone enters Home
518	14	14	5	0	Bedroom Window is Open
519	19	18	8	0	(Weather Sensor) The temperature is above 80
1326	2	1	18	0	Roomba is Off
520	19	18	8	0	(Weather Sensor) The temperature is above 60
521	20	18	7	0	It is Raining
522	18	18	7	0	(Weather Sensor) The weather is Sunny
523	18	18	7	0	(Weather Sensor) The weather is Snowing
524	13	13	5	0	Front Door Lock becomes Unlocked
525	63	12	6	0	Anyone is in Bedroom
526	49	11	14	0	"Smart Faucet's water is running" {time/=|became}{time/!=|stopped being} active 15s  ago
527	14	14	5	0	Bedroom Window is Open
528	20	18	7	0	It is Raining
529	14	14	5	0	Bedroom Window is Open
530	19	2	8	0	(Thermostat) The temperature is 80
531	2	23	13	0	Smart Oven turns On
532	63	12	15	1	Bobbie is in Kitchen
533	63	12	15	2	A Family Member is not in Kitchen
534	14	14	5	0	Bedroom Window is Open
535	19	2	8	0	(Thermostat) The temperature is below 60
536	14	14	5	0	Bedroom Window Opens
537	19	18	6	0	(Weather Sensor) The temperature is above 59
538	14	14	5	0	Bedroom Window Opens
539	19	18	6	0	(Weather Sensor) The temperature is below 81
540	60	8	13	0	Smart Refrigerator's door Closes
541	60	8	13	0	Smart Refrigerator's door is Open
542	66	8	13	0	Smart Refrigerator's temperature stops being set to 40 degrees
543	19	8	13	0	(Smart Refrigerator) The temperature is below 30
544	63	12	6	0	Anyone exits Home
545	14	14	5	0	Bedroom Window Opens
546	18	18	7	0	(Weather Sensor) The weather is Raining
547	60	8	13	0	Smart Refrigerator's door is Open
548	63	12	6	0	Anyone enters Home
549	14	14	5	0	Bedroom Window Opens
550	18	18	7	0	(Weather Sensor) The weather is not Raining
552	2	5	12	1	Smart TV is On
553	14	14	5	0	Bedroom Window Closes
554	19	18	6	0	(Weather Sensor) The temperature is 70
555	64	22	17	0	Smart Faucet's water turns On
556	64	22	17	0	Smart Faucet's water is running
557	14	14	5	0	Bedroom Window Closes
558	19	18	6	0	(Weather Sensor) The temperature is above 70
559	14	25	5	0	Living Room Window is Open
560	14	14	5	0	Bedroom Window Closes
561	19	18	6	0	(Weather Sensor) The temperature is above 80
562	9	3	3	0	Amazon Echo is not playing Pop
563	14	14	5	0	Bedroom Window Closes
564	19	18	6	0	(Weather Sensor) The temperature is below 60
565	2	1	18	0	Roomba is On
566	58	25	5	0	Living Room Window's curtains are Open
567	14	14	5	0	Bedroom Window Closes
568	20	18	7	0	It is Raining
569	57	2	8	0	The AC turns On
570	63	12	15	1	Anyone is not in Home
571	57	2	8	0	The AC turns Off
572	63	12	15	1	Anyone is in Home
573	19	18	8	0	(Weather Sensor) The temperature goes above 80
574	19	18	8	0	(Weather Sensor) The temperature is below 67
575	19	18	8	0	(Weather Sensor) The temperature goes above 80
576	19	18	8	0	(Weather Sensor) The temperature is below 67
577	9	3	3	0	Amazon Echo starts playing Pop
578	57	2	8	0	The AC turns On
580	2	1	18	0	Roomba is On
581	9	3	3	0	Amazon Echo starts playing Pop
582	19	2	8	0	(Thermostat) The temperature changes from 72
583	63	12	6	1	Anyone is in Home
584	58	24	5	0	Bathroom Window's curtains are Closed
585	2	1	18	0	Roomba is On
586	58	14	5	0	Bedroom Window's curtains are Closed
587	2	1	18	0	Roomba is On
588	58	25	5	0	Living Room Window's curtains are Closed
589	2	1	18	0	Roomba is On
590	14	25	5	0	Living Room Window is Closed
591	14	14	5	0	Bedroom Window is Closed
592	14	24	5	0	Bathroom Window is Closed
593	13	13	5	0	Front Door Lock becomes Unlocked
594	63	12	15	1	A Family Member is not in Living Room
595	27	17	9	2	Clock's Alarm is not going off
596	14	24	5	0	Bathroom Window is Closed
597	14	14	5	0	Bedroom Window is Closed
598	14	25	5	0	Living Room Window is Closed
599	64	22	17	0	Smart Faucet's water turns On
600	52	11	14	1	"Smart Faucet's water turns On" last happened more than{time/=|exactly} 14s  ago
601	13	13	4	0	Front Door Lock is Unlocked
602	61	21	6	0	(FitBit) I am Asleep
603	14	24	5	0	Bathroom Window is Closed
604	14	14	5	0	Bedroom Window is Closed
605	14	24	5	0	Bathroom Window is Closed
606	14	14	5	0	Bedroom Window is Closed
607	14	25	5	0	Living Room Window is Closed
608	14	25	5	0	Living Room Window is Open
609	13	13	5	0	Front Door Lock becomes Unlocked
610	63	12	15	1	A Family Member is not in Living Room
611	27	17	9	2	Clock's Alarm is not going off
612	61	21	6	0	(FitBit) I fall asleep
613	2	5	12	1	Smart TV is On
614	25	17	9	2	(Clock) The time is{time/!=| not}{time/>| after}{time/<| before} 23:00
615	13	13	5	0	Front Door Lock becomes Unlocked
616	63	12	15	1	A Family Member is not in Living Room
617	27	17	9	2	Clock's Alarm is going off
618	63	12	15	0	Bobbie enters Kitchen
1626	2	1	18	0	Roomba is On
619	63	12	15	1	Someone other than Bobbie is not in Kitchen
620	58	25	5	0	Living Room Window's curtains Open
621	2	1	18	1	Roomba is On
622	58	14	5	0	Bedroom Window's curtains Open
623	2	1	18	1	Roomba is On
624	64	22	17	0	Smart Faucet's water is running
625	58	24	5	0	Bathroom Window's curtains Open
626	2	1	18	1	Roomba is On
627	19	2	8	0	(Thermostat) The temperature becomes 80
628	61	21	6	0	(FitBit) I fall asleep
629	19	8	13	0	(Smart Refrigerator) The temperature falls below 42
630	19	8	13	0	(Smart Refrigerator) The temperature is 40
631	63	12	15	0	Anyone is in Home
632	21	2	8	0	Thermostat is set below 70 degrees
633	63	12	6	0	Anyone is in Home
634	21	2	8	0	Thermostat is set above 75 degrees
635	61	21	6	0	(FitBit) I fall asleep
636	14	14	5	0	Bedroom Window is Open
637	19	18	8	0	(Weather Sensor) The temperature is above 80
638	61	21	6	0	(FitBit) I fall asleep
639	14	24	5	0	Bathroom Window Closes
640	14	14	5	1	Bedroom Window is Closed
641	14	25	5	2	Living Room Window is Closed
642	14	14	5	0	Bedroom Window is Open
643	19	18	8	0	(Weather Sensor) The temperature is below 60
644	14	14	5	0	Bedroom Window Closes
645	14	24	5	1	Bathroom Window is Closed
646	14	25	5	2	Living Room Window is Closed
647	14	14	5	0	Bedroom Window is Open
648	20	18	7	0	It is Raining
649	19	8	13	0	(Smart Refrigerator) The temperature becomes 40
650	66	8	13	0	Smart Refrigerator's temperature is set below 40 degrees
651	14	25	5	0	Living Room Window Closes
652	14	14	5	1	Bedroom Window is Closed
653	14	24	5	2	Bathroom Window is Closed
654	9	3	3	0	Amazon Echo starts playing Pop
655	13	23	13	0	Smart Oven is Locked
656	2	23	13	0	Smart Oven is On
658	2	1	18	1	Roomba is On
659	63	12	15	2	A Guest is in Home
660	55	17	9	3	It is Daytime
661	14	25	5	0	Living Room Window is Open
662	58	24	5	0	Bathroom Window's curtains Open
663	58	24	5	0	Bathroom Window's curtains Open
664	63	12	15	0	A Guest enters Home
665	55	17	9	1	It is Daytime
666	2	1	18	2	Roomba is On
667	19	2	8	0	(Thermostat) The temperature becomes 80
668	64	22	17	0	Smart Faucet's water is running
669	19	8	13	0	(Smart Refrigerator) The temperature is below 40
670	55	17	9	0	It becomes Daytime
671	55	17	9	0	It becomes Nighttime
672	2	5	12	0	Smart TV turns Off
673	61	21	6	0	(FitBit) I am Asleep
674	19	2	8	0	(Thermostat) The temperature becomes 81
675	19	2	8	0	(Thermostat) The temperature becomes 79
676	57	2	8	1	The AC is On
677	9	3	3	0	Amazon Echo starts playing Pop
679	25	17	9	1	(Clock) The time is{time/!=| not}{time/>| after}{time/<| before} 23:00
680	2	5	12	0	Smart TV turns On
681	2	5	12	0	Smart TV turns On
682	25	17	9	1	(Clock) The time is{time/!=| not}{time/>| after}{time/<| before} 23:50
683	13	23	13	0	Smart Oven becomes Locked
684	63	12	6	0	Bobbie is in Kitchen
685	13	23	13	0	Smart Oven is Locked
686	63	12	15	0	Bobbie is in Kitchen
687	19	2	8	0	(Thermostat) The temperature is 72
688	63	12	6	0	A Family Member is in Home
689	60	23	13	0	Smart Oven's door is Closed
690	13	23	13	0	Smart Oven is Locked
691	21	2	8	0	Thermostat becomes set to 76 degrees
692	63	12	6	0	Anyone is not in Home
693	13	23	13	0	Smart Oven is Locked
694	2	23	13	0	Smart Oven is On
695	63	12	15	0	Anyone exits Home
696	63	12	15	1	Anyone is not in Home
697	19	18	8	2	(Weather Sensor) The temperature is above 75
698	40	10	4	0	Security Camera's Siren turns On
699	25	17	9	1	(Clock) The time is{time/!=| not}{time/>| after}{time/<| before} 23:45
700	19	2	8	0	(Thermostat) The temperature becomes 70
701	57	2	8	1	The AC is On
702	19	8	13	0	(Smart Refrigerator) The temperature is above 40
703	19	8	13	0	(Smart Refrigerator) The temperature is below 44
704	15	10	6	0	Security Camera starts detecting motion
705	25	17	9	1	(Clock) The time is{time/!=| not}{time/>| after}{time/<| before} 23:45
706	60	8	13	0	Smart Refrigerator's door Closes
707	60	8	13	0	Smart Refrigerator's door is Open
708	13	13	5	0	Front Door Lock becomes Unlocked
709	65	23	13	1	Smart Oven's temperature is above below 300 degrees
710	2	1	18	0	Roomba is On
711	63	12	6	0	A Guest is in Home
712	2	1	18	0	Roomba is On
713	63	12	6	0	A Guest is in Home
714	60	8	13	0	Smart Refrigerator's door Opens
715	66	8	13	1	Smart Refrigerator's temperature is set above 45 degrees
716	58	24	5	0	Bathroom Window's curtains Open
717	60	23	13	0	Smart Oven's door is Open
718	63	12	15	0	Bobbie is in Kitchen
719	60	23	13	0	Smart Oven's door is Open
720	63	12	15	0	Bobbie is in Kitchen
721	60	8	13	0	Smart Refrigerator's door Opens
722	35	3	3	0	Pop Music starts playing on Amazon Echo
723	60	23	13	0	Smart Oven's door Opens
724	63	12	15	0	Bobbie is in Kitchen
725	2	5	12	0	Smart TV is Off
726	61	21	6	0	(FitBit) I am Asleep
727	64	22	17	0	Smart Faucet's water turns On
728	2	5	12	0	Smart TV is Off
729	61	21	6	0	(FitBit) I am Asleep
730	58	24	5	0	Bathroom Window's curtains are Open
731	2	5	12	0	Smart TV is On
732	61	21	6	0	(FitBit) I am Awake
733	14	24	5	0	Bathroom Window Closes
734	14	14	5	1	Bedroom Window is Closed
735	14	25	5	2	Living Room Window is Closed
736	2	5	12	0	Smart TV is Off
737	61	21	6	0	(FitBit) I am Asleep
738	2	5	12	0	Smart TV is Off
739	61	21	6	0	(FitBit) I am Asleep
740	2	5	12	0	Smart TV turns Off
741	61	21	16	0	(FitBit) I am Asleep
742	63	12	15	0	Anyone is in Bathroom
743	58	24	5	0	Bathroom Window's curtains are Open
744	2	5	12	0	Smart TV is Off
745	61	21	6	0	(FitBit) I am Asleep
746	2	5	12	0	Smart TV is Off
747	61	21	6	0	(FitBit) I am Asleep
748	2	1	18	0	Roomba is On
749	58	24	5	0	Bathroom Window's curtains are Open
750	2	1	18	0	Roomba is On
751	58	14	5	0	Bedroom Window's curtains are Open
752	2	1	18	0	Roomba is On
753	58	25	5	0	Living Room Window's curtains are Open
754	9	3	3	0	Amazon Echo starts playing Pop
755	2	7	3	0	Speakers is On
756	9	3	3	0	Amazon Echo is playing Pop
757	19	2	8	0	(Thermostat) The temperature is above 70
758	63	12	6	0	Anyone is in Home
759	19	2	8	0	(Thermostat) The temperature is below 75
760	63	12	6	0	Anyone is in Home
761	9	3	3	0	Amazon Echo starts playing Pop
762	63	12	15	0	Anyone is in Home
763	9	3	3	0	Amazon Echo is playing Pop
764	64	22	17	0	Smart Faucet's water is running
765	64	22	17	0	Smart Faucet's water is running
766	66	8	13	0	Smart Refrigerator's temperature is set below 40 degrees
767	21	2	8	0	Thermostat is set below 80 degrees
768	19	2	8	0	(Thermostat) The temperature goes above 80
769	19	2	8	0	(Thermostat) The temperature goes above 80
770	19	8	13	0	(Smart Refrigerator) The temperature is below 40
771	19	8	13	0	(Smart Refrigerator) The temperature is below 40
772	66	8	13	0	Smart Refrigerator's temperature is set below 40 degrees
773	49	11	14	0	"Open Smart Refrigerator's Door" was active 2m  ago
774	60	8	13	0	Smart Refrigerator's door is Open
775	19	2	8	0	(Thermostat) The temperature goes above 80
776	19	2	8	0	(Thermostat) The temperature goes above 80
777	19	2	8	0	(Thermostat) The temperature goes above 80
779	19	2	8	0	(Thermostat) The temperature is above 80
780	25	17	9	0	(Clock) The time {time/=|becomes}{time/!=|stops being}{time/>|becomes later than}{time/<|becomes earlier than} 22:30
781	55	17	9	1	It is Nighttime
782	25	17	9	0	(Clock) The time {time/=|becomes}{time/!=|stops being}{time/>|becomes later than}{time/<|becomes earlier than} 22:30
784	19	2	8	0	(Thermostat) The temperature is below 60
786	20	18	7	0	It is Raining
787	2	1	18	0	Roomba turns On
788	14	14	5	0	Bedroom Window is Open
789	2	1	18	0	Roomba is On
790	63	12	6	0	Anyone is in Home
791	52	11	14	0	"Anyone is in Home" last happened less than{time/=|exactly} 2h 59m 59s  ago
792	14	14	5	0	Bedroom Window is Open
793	20	18	7	0	It is Raining
794	14	14	5	0	Bedroom Window is Open
795	19	2	8	0	(Thermostat) The temperature is above 80
796	2	1	18	0	Roomba turns On
797	2	1	18	0	Roomba turns On
798	14	14	5	0	Bedroom Window is Open
799	19	2	8	0	(Thermostat) The temperature is below 60
800	2	1	18	0	Roomba turns On
801	14	14	5	0	Bedroom Window is Open
802	18	18	7	0	(Weather Sensor) The weather is Clear
804	18	18	7	0	(Weather Sensor) The weather is Clear
805	14	14	5	0	Bedroom Window is Open
806	61	21	16	0	(FitBit) I fall asleep
807	2	5	1	0	Smart TV turns Off
808	2	1	18	0	Roomba is On
809	52	11	14	0	"Anyone is in Home" last happened {time/=|exactly} 1s  ago
810	52	11	14	0	"Anyone is in Home" last happened more than{time/=|exactly} 3h 1s  ago
812	25	17	9	1	(Clock) The time is{time/!=| not}{time/>| after}{time/<| before} 23:59
813	61	21	16	0	(FitBit) I fall asleep
814	2	5	12	1	Smart TV is On
815	25	17	9	2	(Clock) The time is{time/!=| not}{time/>| after}{time/<| before} 23:59
816	14	24	5	0	Bathroom Window is Open
817	14	14	5	0	Bedroom Window is Closed
818	2	4	2	0	HUE Lights turns On
819	14	24	5	0	Bathroom Window is Open
820	14	25	5	0	Living Room Window is Closed
821	14	14	5	0	Bedroom Window is Open
822	14	24	5	0	Bathroom Window is Closed
823	14	14	5	0	Bedroom Window is Open
824	14	25	5	0	Living Room Window is Closed
825	14	25	5	0	Living Room Window is Open
826	14	24	5	0	Bathroom Window is Closed
827	14	25	5	0	Living Room Window is Open
828	14	14	5	0	Bedroom Window is Closed
829	19	8	13	0	(Smart Refrigerator) The temperature falls below 40
830	61	21	16	0	(FitBit) I fall asleep
831	2	5	12	1	Smart TV is On
832	25	17	9	2	(Clock) The time is{time/!=| not}{time/>| after}{time/<| before} 23:59
833	60	8	13	0	Smart Refrigerator's door is Open
834	63	12	15	0	Anyone is not in Kitchen
835	51	11	14	0	"Open Smart Refrigerator's Door" was last in effect more than{time/=|exactly} 2m  ago
836	60	8	13	0	Smart Refrigerator's door is Open
837	63	12	15	0	Anyone is in Kitchen
838	13	13	4	0	Front Door Lock becomes Locked
839	64	22	17	0	Smart Faucet's water turns On
840	52	11	14	1	"Smart Faucet's water turns On" last happened more than{time/=|exactly} 15s  ago
841	58	24	5	0	Bathroom Window's curtains Open
842	52	11	14	0	It becomes true that "Smart Faucet's water turns On" last happened more than{time/=|exactly} 15s  ago
845	2	23	13	0	Smart Oven turns On
846	63	12	6	1	Someone other than Bobbie is not in Kitchen
847	64	22	17	0	Smart Faucet's water turns On
850	35	3	3	0	pop music starts playing on Amazon Echo
851	2	1	18	0	Roomba is On
852	63	12	15	0	A Guest is in Home
853	52	11	14	0	"A Guest is in Home" last happened less than{time/=|exactly} 3h  ago
854	63	12	15	0	Anyone enters Bathroom
855	2	1	18	0	Roomba is On
856	63	12	15	0	A Guest is in Home
857	52	11	14	0	"A Guest is in Home" last happened less than{time/=|exactly} 3h  ago
858	2	1	18	0	Roomba is On
859	63	12	15	0	A Guest is in Home
860	52	11	14	0	"A Guest is in Home" last happened more than{time/=|exactly} 3h  ago
861	58	24	5	0	Bathroom Window's curtains Open
862	55	17	9	1	It is Daytime
863	55	17	9	2	It is Nighttime
864	60	8	13	0	Smart Refrigerator's door Opens
865	52	11	14	1	"Smart Refrigerator's door Opens" last happened more than{time/=|exactly} 2m  ago
866	61	21	16	0	(FitBit) I fall asleep
867	2	5	12	1	Smart TV is On
868	49	11	14	2	"Smart TV is On" was active 30m  ago
869	58	24	5	0	Bathroom Window's curtains Open
870	58	24	5	0	Bathroom Window's curtains Open
871	9	3	3	0	Amazon Echo starts playing Pop
872	9	3	3	0	Amazon Echo starts playing Pop
873	9	3	3	0	Amazon Echo starts playing Pop
874	9	3	3	0	Amazon Echo starts playing Pop
875	63	12	6	0	A Guest enters Home
876	2	1	18	1	Roomba is On
877	61	21	16	0	(FitBit) I fall asleep
878	2	5	12	1	Smart TV is On
879	52	11	14	2	"(FitBit) I fall asleep" last happened more than{time/=|exactly} 30m  ago
880	2	1	18	0	Roomba turns Off
881	52	11	14	1	"Roomba turns Off" last happened more than{time/=|exactly} 3h  ago
882	55	17	9	0	It becomes Daytime
883	2	1	18	0	Roomba turns On
884	19	2	8	0	(Thermostat) The temperature goes above 80
885	19	2	8	0	(Thermostat) The temperature falls below 60
886	20	18	7	0	It starts Raining
887	19	18	8	0	(Weather Sensor) The temperature goes above 80
888	14	14	5	1	Bedroom Window is Open
889	19	18	8	0	(Weather Sensor) The temperature falls below 60
890	14	14	5	1	Bedroom Window is Open
891	61	21	6	0	(FitBit) I fall asleep
892	20	18	7	0	It starts Raining
893	14	14	5	1	Bedroom Window is Open
894	19	2	8	0	(Thermostat) The temperature falls below 80
895	14	14	5	1	Bedroom Window is Closed
896	19	2	8	0	(Thermostat) The temperature falls below 80
897	14	14	5	1	Bedroom Window is Closed
898	20	18	7	2	It is Not Raining
899	19	2	8	0	(Thermostat) The temperature goes above 60
900	20	18	7	1	It is Not Raining
901	19	2	8	0	(Thermostat) The temperature goes above 60
902	20	18	7	1	It is Not Raining
903	14	14	5	2	Bedroom Window is Closed
904	15	10	6	0	Security Camera starts detecting motion
905	19	8	13	0	(Smart Refrigerator) The temperature falls below 40
906	64	22	17	0	Smart Faucet's water turns On
907	52	11	14	1	"Smart Faucet's water turns On" last happened {time/=|exactly} 15s  ago
908	63	12	6	0	A Guest enters Home
909	2	1	18	1	Roomba is On
910	63	12	6	0	Bobbie enters Kitchen
911	2	23	13	1	Smart Oven is On
912	19	2	8	0	(Thermostat) The temperature becomes 80
913	61	21	6	0	(FitBit) I fall asleep
914	9	3	3	0	Amazon Echo starts playing Pop
915	63	12	15	0	Bobbie enters Kitchen
916	2	23	13	1	Smart Oven is On
917	63	12	15	0	Bobbie exits Kitchen
918	2	23	13	1	Smart Oven is On
919	60	8	13	0	Smart Refrigerator's door Opens
920	52	11	14	1	"Smart Refrigerator's door Opens" last happened {time/=|exactly} 2m  ago
921	63	12	6	0	Someone other than A Family Member enters Home
922	55	17	9	1	It is Nighttime
923	19	2	8	0	(Thermostat) The temperature goes above 60
924	20	18	7	1	It is Not Raining
925	19	2	8	2	(Thermostat) The temperature is below 80
926	64	22	17	0	Smart Faucet's water turns On
927	52	11	14	1	"Smart Faucet's water turns On" last happened {time/=|exactly} 15s  ago
928	63	12	6	0	Anyone enters Bathroom
929	58	25	5	0	Living Room Window's curtains Open
930	58	14	5	1	Bedroom Window's curtains are Open
931	2	1	18	2	Roomba is On
932	49	11	14	0	"Smart TV is On" {time/=|became}{time/!=|stopped being} active 31m  ago
933	61	21	16	1	(FitBit) I am Asleep
934	64	22	17	0	Smart Faucet's water turns Off
935	64	22	17	0	Smart Faucet's water is running
936	64	22	17	0	Smart Faucet's water is running
937	2	1	18	0	Roomba is Off
938	64	22	13	0	Smart Faucet's water is running
939	2	4	2	0	HUE Lights is On
940	64	22	17	0	Smart Faucet's water is not running
941	2	4	2	0	HUE Lights is On
942	2	4	2	0	HUE Lights is On
943	2	4	2	0	HUE Lights is On
944	2	4	2	0	HUE Lights is On
945	64	22	17	0	Smart Faucet's water is not running
946	3	4	2	0	HUE Lights's Brightness is not 3
947	2	4	2	0	HUE Lights is On
948	65	23	13	0	Smart Oven's temperature is above below 155 degrees
949	2	1	18	0	Roomba is Off
950	58	24	5	0	Bathroom Window's curtains Close
951	58	24	5	0	Bathroom Window's curtains Open
952	52	11	14	0	It becomes true that "(FitBit) I Fall Asleep" last happened exactly 30m  ago
953	60	23	13	0	Smart Oven's door Opens
954	58	24	5	0	Bathroom Window's curtains Open
955	63	12	15	0	Anyone is in Bathroom
956	14	14	5	0	Bedroom Window Closes
957	14	24	5	1	Bathroom Window is Closed
958	14	25	5	2	Living Room Window is Closed
959	21	2	8	0	Thermostat's temperature becomes set abovebecomes set below 80 degrees
960	19	2	8	0	(Thermostat) The temperature falls below 70 degrees
961	63	12	15	0	Anyone is in Home
962	9	3	3	0	Amazon Echo starts playing Pop
963	14	14	5	0	Bedroom Window Closes
964	19	18	8	1	(Weather Sensor) The temperature is above 60
965	19	18	8	2	(Weather Sensor) The temperature is below 80
966	20	18	7	3	It is Not Raining
967	14	14	5	0	Bedroom Window Closes
968	19	18	8	1	(Weather Sensor) The temperature is above 60
969	19	18	8	2	(Weather Sensor) The temperature is below 80
970	20	18	7	3	It is Not Raining
971	19	8	13	0	(Smart Refrigerator) The temperature becomes 39 degrees
972	14	14	5	0	Bedroom Window is Closed
973	14	25	5	0	Living Room Window is Closed
974	14	24	5	0	Bathroom Window Closes
975	14	14	5	1	Bedroom Window is Closed
976	58	24	5	0	Bathroom Window's curtains Close
977	14	24	5	0	Bathroom Window Closes
978	14	25	5	1	Living Room Window is Closed
979	14	14	5	0	Bedroom Window Closes
980	14	25	5	1	Living Room Window is Closed
981	63	12	15	0	Bobbie Enters Kitchen
982	2	23	13	0	Smart Oven is On
984	14	14	5	0	Bedroom Window is Closed
985	14	25	5	0	Living Room Window is Open
986	58	25	5	0	Living Room Window's curtains Open
987	14	14	5	0	Bedroom Window Opens
988	19	2	8	0	(Thermostat) The temperature is above 80
989	61	21	6	0	(FitBit) I Fall Asleep
990	2	5	12	1	Smart TV is On
991	52	11	14	2	"(FitBit) I Fall Asleep" last happened more than 30m  ago
992	19	8	13	0	(Smart Refrigerator) The temperature becomes 40 degrees
993	63	12	15	0	Someone other than Alice Enters Home
994	19	2	8	0	(Thermostat) The temperature goes above 79 degrees
995	58	24	5	0	Bathroom Window's curtains are Closed
996	58	24	5	0	Bathroom Window's curtains Open
997	14	14	5	0	Bedroom Window Opens
998	19	18	8	0	(Weather Sensor) The temperature is below 60
999	14	14	5	0	Bedroom Window Opens
1000	19	18	8	1	(Weather Sensor) The temperature is below 60
1001	14	14	5	0	Bedroom Window Opens
1002	19	18	8	1	(Weather Sensor) The temperature is below 60
1004	19	18	8	1	(Weather Sensor) The temperature is below 60
1005	14	14	5	0	Bedroom Window Opens
1006	19	18	8	0	(Weather Sensor) The temperature is above 80
1007	52	11	14	0	It becomes true that "Someone other than Alice Enters Home" last happened exactly 3h  ago
1008	14	14	5	0	Bedroom Window Opens
1009	20	18	7	0	It is Raining
1010	13	13	5	0	Front Door Lock Unlocks
1011	55	17	9	1	It is Nighttime
1012	66	8	13	0	Smart Refrigerator's temperature is set above 40 degrees
1013	9	3	3	0	Amazon Echo starts playing Pop
1014	9	3	3	0	Amazon Echo starts playing Pop
1015	9	3	3	0	Amazon Echo starts playing Pop
1016	66	8	13	0	Smart Refrigerator's temperature is set above 40 degrees
1017	13	13	5	0	Front Door Lock Unlocks
1018	55	17	9	1	It is Nighttime
1019	58	24	5	0	Bathroom Window's curtains Open
1020	58	14	5	1	Bedroom Window's curtains are Open
1021	58	25	5	2	Living Room Window's curtains are Open
1022	63	12	15	0	Someone other than Alice Enters Kitchen
1023	66	8	13	0	Smart Refrigerator's temperature becomes set below 41 degrees
1024	19	8	13	0	(Smart Refrigerator) The temperature changes from 41 degrees
1025	35	3	3	0	pop music starts playing on Amazon Echo
1026	64	22	17	0	Smart Faucet's water is not running
1027	2	1	18	0	Roomba turns On
1028	58	25	5	1	Living Room Window's curtains are Open
1029	64	22	17	0	Smart Faucet's water is not running
1030	58	24	5	0	Bathroom Window's curtains Open
1031	13	13	5	0	Front Door Lock Locks
1032	15	10	6	1	Security Camera detects motion
1033	13	13	4	2	Front Door Lock is Locked
1035	60	8	13	0	Smart Refrigerator's door Opens
1036	60	8	13	1	Smart Refrigerator's door is Open
1037	60	8	13	2	Smart Refrigerator's door is Open
1038	14	14	5	0	Bedroom Window is Open
1039	20	18	7	0	It is Raining
1040	19	18	8	1	(Weather Sensor) The temperature is above 80
1041	19	18	8	0	(Weather Sensor) The temperature is below 60
1042	64	22	17	0	Smart Faucet's water is not running
1043	19	2	8	0	(Thermostat) The temperature becomes 80 degrees
1044	2	5	12	0	Smart TV turns Off
1045	61	21	16	0	(FitBit) I am Asleep
1046	58	24	5	0	Bathroom Window's curtains Open
1047	60	23	13	0	Smart Oven's door Opens
1048	63	12	15	0	Bobbie is in Kitchen
1049	19	8	13	0	(Smart Refrigerator) The temperature becomes 39 degrees
1050	2	23	13	0	Smart Oven is On
1051	13	23	13	0	Smart Oven is Locked
1052	14	24	5	0	Bathroom Window Closes
1053	14	24	5	1	Bathroom Window is Closed
1054	58	24	5	0	Bathroom Window's curtains Open
1055	60	8	13	0	Smart Refrigerator's door is Open
1056	13	13	5	0	Front Door Lock is Locked
1057	55	17	9	0	It is Nighttime
1058	2	1	18	0	Roomba is On
1059	58	25	5	0	Living Room Window's curtains are Closed
1060	63	12	6	0	Alice Exits Kitchen
1061	52	11	14	1	"Smart Refrigerator's door Opens" last happened more than 2m  ago
1062	19	8	13	0	(Smart Refrigerator) The temperature falls below 40 degrees
1063	61	21	16	0	(FitBit) I Fall Asleep
1064	49	11	14	0	It becomes true that "Bathroom Window is Closed" was active 1s  ago
1065	14	14	5	1	Bedroom Window is Closed
1066	14	25	5	2	Living Room Window is Closed
1067	64	22	17	0	Smart Faucet's water is running
1069	63	12	6	0	Someone other than A Guest is not in Home
1070	2	1	18	0	Roomba is Off
1071	63	12	6	0	A Guest is in Home
1072	61	21	16	0	(FitBit) I Fall Asleep
1073	2	5	12	0	Smart TV is On
1074	2	5	12	1	Smart TV is Off
1075	52	11	14	0	"(FitBit) I am Asleep" last happened more than 30m  ago
1076	14	24	5	0	Bathroom Window Closes
1077	14	14	5	1	Bedroom Window is Closed
1078	14	25	5	2	Living Room Window is Closed
1079	2	1	18	0	Roomba turns Off
1080	58	25	5	0	Living Room Window's curtains are Open
1081	63	12	6	0	Bobbie Enters Kitchen
1082	2	23	13	1	Smart Oven is On
1083	2	1	18	0	Roomba turns On
1084	63	12	6	0	A Guest is in Home
1085	14	24	5	0	Bathroom Window Closes
1086	14	14	5	1	Bedroom Window is Closed
1087	14	25	5	2	Living Room Window is Closed
1088	2	1	18	0	Roomba turns On
1089	2	1	18	1	Roomba is Off
1090	63	12	6	2	A Guest is not in Home
1091	2	1	18	0	Roomba turns Off
1092	58	14	5	0	Bedroom Window's curtains are Open
1093	2	1	18	0	Roomba turns Off
1094	58	24	5	0	Bathroom Window's curtains are Open
1095	14	25	5	0	Living Room Window Opens
1096	63	12	6	0	A Family Member is in Home
1097	61	21	16	0	(FitBit) I am Asleep
1098	13	13	4	0	Front Door Lock is Unlocked
1099	13	13	5	0	Front Door Lock Locks
1100	15	10	6	1	Security Camera detects motion
1101	13	13	4	2	Front Door Lock is Locked
1102	61	21	6	0	(FitBit) I Fall Asleep
1103	2	5	12	1	Smart TV is On
1104	2	1	18	0	Roomba turns On
1105	13	13	4	0	Front Door Lock Unlocks
1106	61	21	16	0	(FitBit) I am Asleep
1107	58	25	5	0	Living Room Window's curtains Open
1108	2	1	18	1	Roomba is On
1109	61	21	6	0	(FitBit) I am Asleep
1110	13	13	4	0	Front Door Lock is Locked
1111	18	18	7	0	(Weather Sensor) The weather becomes Sunny
1112	19	2	8	1	(Thermostat) The temperature is 70
1113	13	13	5	0	Front Door Lock Unlocks
1114	61	21	16	0	(FitBit) I am Asleep
1115	61	21	16	0	(FitBit) I Fall Asleep
1116	57	2	8	0	The AC is On
1117	19	2	8	0	(Thermostat) The temperature is above 80
1118	64	22	17	0	Smart Faucet's water is running
1119	13	13	5	0	Front Door Lock is Locked
1120	61	21	6	0	(FitBit) I am Asleep
1122	2	1	18	0	Roomba is On
1916	2	1	18	0	Roomba turns On
2308	2	1	18	0	Roomba turns On
1123	58	25	5	0	Living Room Window's curtains are Open
1124	2	1	18	0	Roomba is On
1125	58	25	5	0	Living Room Window's curtains are Closed
1126	58	25	5	0	Living Room Window's curtains are Open
1127	2	1	18	0	Roomba is On
1128	2	1	18	0	Roomba is On
1129	58	25	5	0	Living Room Window's curtains are Open
1130	58	14	5	0	Bedroom Window's curtains are Open
1131	64	22	17	0	Smart Faucet's water is running
1132	9	3	3	0	Amazon Echo starts playing Pop
1133	35	3	3	1	This  is playing on Amazon Echo
1134	14	14	5	0	Bedroom Window Opens
1135	19	18	8	0	(Weather Sensor) The temperature is above 80
1136	14	14	5	0	Bedroom Window Opens
1137	19	2	8	0	(Thermostat) The temperature is 80
1138	61	21	16	0	(FitBit) I Fall Asleep
1139	2	5	1	1	Smart TV is On
1140	61	21	6	2	(FitBit) I am Asleep
1141	2	5	12	3	Smart TV is On
1142	14	14	5	0	Bedroom Window Opens
1143	20	18	7	0	It is Raining
1144	14	14	5	0	Bedroom Window Opens
1145	19	2	8	0	(Thermostat) The temperature is above 80
1146	19	8	13	0	(Smart Refrigerator) The temperature is below 40
1148	14	14	5	0	Bedroom Window Opens
1149	19	18	8	0	(Weather Sensor) The temperature is below 60
1150	14	14	5	0	Bedroom Window Opens
1151	19	2	8	0	(Thermostat) The temperature is below 60
1152	9	3	3	0	Amazon Echo starts playing Pop
1153	14	14	5	0	Bedroom Window Opens
1154	20	18	7	0	It is Raining
1155	19	8	13	0	(Smart Refrigerator) The temperature is below 40
1156	2	23	13	0	Smart Oven turns On
1157	63	12	15	1	Bobbie is in Kitchen
1158	14	14	5	0	Bedroom Window Opens
1159	19	18	8	0	(Weather Sensor) The temperature is below 60
1160	14	14	5	0	Bedroom Window Opens
1161	19	18	8	0	(Weather Sensor) The temperature is above 80
1162	60	23	13	0	Smart Oven's door is Closed
1163	63	12	15	0	Bobbie is in Kitchen
1164	2	1	18	0	Roomba turns On
1165	58	14	5	1	Bedroom Window's curtains are Closed
1166	63	12	6	0	Bobbie is in Kitchen
1167	13	23	13	0	Smart Oven is Locked
1168	14	25	5	0	Living Room Window is Open
1169	13	23	13	0	Smart Oven is Locked
1170	63	12	15	0	Alice is not in Kitchen
1171	13	23	13	0	Smart Oven is Unlocked
1172	63	12	15	0	Alice is in Kitchen
1173	60	8	13	0	Smart Refrigerator's door is Open
1174	51	11	14	0	"undefined" was last in effect exactly 2m  ago
1175	2	1	18	0	Roomba turns On
1176	21	2	8	0	Thermostat is set to 75 degrees
1177	63	12	15	0	Anyone is not in Home
1178	60	8	13	0	Smart Refrigerator's door is Open
1179	51	11	14	0	"undefined" was last in effect exactly 2m  ago
1180	21	2	8	0	Thermostat is set to 75 degrees
1181	63	12	15	0	Anyone is not in Home
1182	9	3	3	0	Amazon Echo is playing Pop
1183	2	1	18	0	Roomba turns On
1184	35	3	3	0	Pop music starts playing on Amazon Echo
1185	19	2	8	0	(Thermostat) The temperature is above 80
1186	19	2	8	0	(Thermostat) The temperature goes above 80 degrees
1187	21	2	8	0	Thermostat is set below 80 degrees
1188	21	2	8	0	Thermostat's temperature becomes set to 70 degrees
1189	63	12	15	0	Anyone is in Home
1190	2	1	18	0	Roomba turns On
1191	21	2	8	0	Thermostat's temperature becomes set to 70 degrees
1192	63	12	15	0	Anyone is in Home
1193	9	3	3	0	Amazon Echo is not playing Pop
1194	21	2	8	0	Thermostat is set above 80 degrees
1195	13	13	5	0	Front Door Lock is Locked
1196	55	17	9	0	It is Nighttime
1197	57	2	8	0	The AC turns On
1198	19	2	8	0	(Thermostat) The temperature is above 80
1199	57	2	8	0	The AC is On
1200	19	2	8	0	(Thermostat) The temperature is below 79
1201	19	8	13	0	(Smart Refrigerator) The temperature is above 40
1202	13	13	4	0	Front Door Lock Unlocks
1203	61	21	16	1	(FitBit) I am Asleep
1204	60	8	13	0	Smart Refrigerator's door Opens
1205	60	8	13	1	Smart Refrigerator's door is Open
1206	19	8	13	0	(Smart Refrigerator) The temperature falls below 40 degrees
1207	13	13	5	0	Front Door Lock Unlocks
1208	2	4	2	0	HUE Lights is Off
1209	14	14	5	0	Bedroom Window Closes
1210	20	18	7	0	It is Raining
1212	19	8	13	0	(Smart Refrigerator) The temperature is above 48
1213	14	24	5	0	Bathroom Window is Open
1214	19	18	8	0	(Weather Sensor) The temperature is 80
1215	66	8	13	0	Smart Refrigerator's temperature becomes set below 40 degrees
1216	25	17	9	0	(Clock) The time becomes later than 00:00
1217	25	17	9	1	(Clock) The time is after 00:00
1218	13	13	4	0	Front Door Lock is Unlocked
1219	25	17	9	0	(Clock) The time is after 00:00
1220	14	14	5	0	Bedroom Window is Open
1221	19	18	8	0	(Weather Sensor) The temperature is below 60
1222	9	3	3	0	Amazon Echo starts playing Pop
1223	14	24	5	0	Bathroom Window is Open
1224	19	18	8	0	(Weather Sensor) The temperature is above 80
1225	19	2	8	0	(Thermostat) The temperature is above 80
1226	13	13	4	0	Front Door Lock is Unlocked
1227	2	4	2	0	HUE Lights is Off
1228	14	14	5	0	Bedroom Window is Open
1229	19	18	8	0	(Weather Sensor) The temperature is below 80
1230	19	18	8	0	(Weather Sensor) The temperature is above 60
1231	20	18	7	0	It is Not Raining
1232	21	2	8	0	Thermostat's temperature changes from being set to 70 degrees
1233	63	12	6	1	Anyone is in Home
1234	2	1	1	0	Roomba is On
1235	58	24	5	0	Bathroom Window's curtains are Open
1236	58	14	5	0	Bedroom Window's curtains are Open
1237	63	12	15	0	Anyone Enters Home
1238	19	8	13	0	(Smart Refrigerator) The temperature is above 40
1239	19	8	13	0	(Smart Refrigerator) The temperature is below 50
1240	63	12	15	0	Anyone Exits Home
1241	2	5	1	0	Smart TV is On
1242	2	1	18	0	Roomba is On
1243	58	25	5	0	Living Room Window's curtains are Open
1244	2	5	1	0	Smart TV is On
1245	63	12	15	0	Anyone is in Home
1246	21	2	8	0	Thermostat is set to 72 degrees
1247	63	12	15	0	Anyone is not in Home
1248	57	2	8	0	The AC is Off
1249	63	12	6	0	Bobbie Enters Kitchen
1250	57	2	8	0	The AC turns On
1251	63	12	15	0	Anyone is in Home
1252	14	14	5	0	Bedroom Window Closes
1253	20	18	7	0	It is Raining
1254	14	14	5	0	Bedroom Window Closes
1255	20	18	7	0	It is Raining
1256	13	14	5	0	Bedroom Window Locks
1257	19	18	8	0	(Weather Sensor) The temperature is above 80
1258	14	14	5	0	Bedroom Window Closes
1259	19	18	8	0	(Weather Sensor) The temperature is below 60
1260	9	3	3	0	Amazon Echo is playing Pop
1261	58	14	5	0	Bedroom Window's curtains Close
1262	19	18	8	0	(Weather Sensor) The temperature is above 80
1263	2	23	13	0	Smart Oven turns On
1264	63	12	6	1	Bobbie is in Kitchen
1265	13	13	5	0	Front Door Lock is Unlocked
1266	13	13	4	0	Front Door Lock is Locked
1267	55	17	9	0	It is Nighttime
1268	64	22	17	0	Smart Faucet's water Turns On
1269	40	10	4	0	Security Camera's Siren turns On
1270	55	17	9	0	It is Nighttime
1271	58	24	5	0	Bathroom Window's curtains Close
1272	58	24	5	0	Bathroom Window's curtains are Open
1273	58	24	5	0	Bathroom Window's curtains are Closed
1274	19	2	8	0	(Thermostat) The temperature goes above 79 degrees
1275	14	14	5	0	Bedroom Window is Open
1276	19	18	8	0	(Weather Sensor) The temperature is above 60
1277	19	2	8	0	(Thermostat) The temperature becomes 65 degrees
1278	19	2	8	1	(Thermostat) The temperature is below 80
1279	20	18	7	2	It is Not Raining
1280	14	14	5	0	Bedroom Window is Closed
1281	19	18	8	0	(Weather Sensor) The temperature is above 79
1282	14	14	5	0	Bedroom Window is Open
1283	19	18	8	0	(Weather Sensor) The temperature is 79
1284	14	14	5	0	Bedroom Window is Open
1285	20	18	7	0	It is Raining
1287	63	12	6	0	Anyone is not in Home
1288	13	23	13	0	Smart Oven Locks
1289	2	23	13	0	Smart Oven is On
1290	60	8	13	0	Smart Refrigerator's door is Open
1291	60	23	13	0	Smart Oven's door Opens
1292	2	23	13	0	Smart Oven is On
1293	2	1	18	0	Roomba turns On
1294	25	17	9	0	(Clock) The time is after 12:00
1295	2	1	18	0	Roomba turns Off
1296	25	17	9	0	(Clock) The time is before 19:00
1297	60	8	13	0	Smart Refrigerator's door Opens
1298	60	8	13	1	Smart Refrigerator's door is Open
1299	2	1	18	0	Roomba turns Off
1300	25	17	9	0	(Clock) The time is after 20:00
1301	2	1	18	0	Roomba turns On
1302	63	12	15	0	A Guest is in Home
1303	13	13	4	0	Front Door Lock is Locked
1304	55	17	9	0	It is Nighttime
1305	19	2	8	0	(Thermostat) The temperature goes above 80 degrees
1306	57	2	8	0	The AC is On
1307	13	13	4	0	Front Door Lock is Locked
1308	55	17	9	0	It is Nighttime
1309	2	1	18	0	Roomba is On
1310	63	12	15	0	Anyone is not in Home
1311	60	23	13	0	Smart Oven's door Opens
1312	65	23	13	0	Smart Oven's temperature is above below 80 degrees
1313	9	3	3	0	Amazon Echo is not playing Pop
1314	64	22	17	0	Smart Faucet's water Turns On
1315	64	22	17	1	Smart Faucet's water is running
1316	14	25	5	0	Living Room Window is Open
1317	20	18	7	0	It is Not Raining
1318	60	8	13	0	Smart Refrigerator's door is Open
1319	14	25	5	0	Living Room Window is Open
1320	19	18	8	0	(Weather Sensor) The temperature is below 70
1321	20	18	7	0	It is Not Raining
1322	58	24	5	0	Bathroom Window's curtains are Open
1323	58	24	5	0	Bathroom Window's curtains Open
1324	2	1	18	0	Roomba is Off
1327	58	24	5	0	Bathroom Window's curtains are Closed
1328	21	2	8	0	Thermostat is set to 70 degrees
1329	63	12	6	0	Anyone is in Home
1330	63	12	6	0	Anyone is not in Home
1331	57	2	8	0	The AC is Off
1332	63	12	15	0	Anyone Enters Home
1333	63	12	6	0	Bobbie is in Kitchen
1334	60	23	13	0	Smart Oven's door is Closed
1335	63	12	15	0	Anyone Exits Home
1336	13	13	4	0	Front Door Lock Locks
1337	61	21	6	0	(FitBit) I am Asleep
1338	55	17	9	0	It becomes Daytime
1339	14	25	5	0	Living Room Window Opens
1340	57	2	8	0	The AC is On
1341	21	2	8	0	Thermostat is set above 80 degrees
1342	19	2	8	0	(Thermostat) The temperature is above 80
1343	2	4	2	0	HUE Lights is On
1344	63	12	6	0	Anyone is not in Home
1345	58	24	5	0	Bathroom Window's curtains Open
1346	2	1	18	0	Roomba is On
1347	2	7	3	0	Speakers is On
1348	66	8	13	0	Smart Refrigerator's temperature becomes set below 40 degrees
1349	14	14	5	0	Bedroom Window is Open
1350	14	25	5	0	Living Room Window is Open
1352	49	11	17	1	"Smart Faucet's water is running" was active 15s  ago
1353	51	11	14	2	It becomes true that "Smart Faucet's water is not running" was last in effect exactly 16s  ago
1354	14	25	5	0	Living Room Window is Open
1355	20	18	7	0	It is Raining
1356	14	25	5	0	Living Room Window is Open
1357	55	17	9	0	It is Nighttime
1358	52	11	14	0	It becomes true that "Smart Faucet's water Turns On" last happened exactly 15s  ago
1359	64	22	17	1	Smart Faucet's water is running
1360	2	5	12	0	Smart TV is Off
1361	61	21	6	0	(FitBit) I am Asleep
1362	25	17	9	0	(Clock) The time is 
1363	62	21	6	0	(FitBit) My heart rate is below 120BPM
1364	61	21	16	0	(FitBit) I Fall Asleep
1365	14	14	5	0	Bedroom Window is Open
1366	19	18	8	0	(Weather Sensor) The temperature is below 80
1367	21	2	8	0	Thermostat is set above 60 degrees
1368	52	11	14	0	It becomes true that "(FitBit) I Fall Asleep" last happened exactly 30m  ago
1369	2	5	12	1	Smart TV is On
1370	55	17	9	0	It becomes Daytime
1371	55	17	9	0	It becomes Nighttime
1372	55	17	9	0	It becomes Nighttime
1373	19	18	8	0	(Weather Sensor) The temperature goes above 80 degrees
1374	19	18	8	0	(Weather Sensor) The temperature falls below 60 degrees
1375	20	18	7	0	It starts raining
1376	60	23	13	0	Smart Oven's door Opens
1377	2	23	13	1	Smart Oven is On
1378	60	23	13	0	Smart Oven's door Opens
1379	2	23	13	1	Smart Oven is On
1380	60	23	13	0	Smart Oven's door Closes
1381	2	23	13	1	Smart Oven is On
1382	63	12	15	0	A Family Member Enters Bedroom
1383	55	17	9	1	It is Nighttime
1384	63	12	15	0	A Family Member Enters Bedroom
1385	55	17	9	1	It is Nighttime
1386	19	2	8	0	(Thermostat) The temperature goes above 80 degrees
1387	19	2	8	0	(Thermostat) The temperature becomes 80 degrees
1388	19	2	8	0	(Thermostat) The temperature falls below 60 degrees
1389	19	2	8	0	(Thermostat) The temperature goes above 60 degrees
1390	19	2	8	1	(Thermostat) The temperature is below 80
1391	19	2	8	0	(Thermostat) The temperature falls below 80 degrees
1392	19	2	8	1	(Thermostat) The temperature is above 60
1393	58	25	5	0	Living Room Window's curtains Open
1394	2	1	18	1	Roomba is On
1395	20	18	7	0	It starts raining
1396	19	18	8	1	(Weather Sensor) The temperature is above 60
1397	19	18	8	2	(Weather Sensor) The temperature is below 80
1398	63	12	15	0	Anyone Enters Home
1399	63	12	15	0	Anyone Exits Home
1400	20	18	7	0	It stops raining
1401	19	18	8	1	(Weather Sensor) The temperature is above 60
1402	19	18	8	2	(Weather Sensor) The temperature is below 80
1403	9	3	3	0	Amazon Echo starts playing Pop
1404	63	12	6	0	A Guest Enters Home
1405	2	1	18	1	Roomba is On
1406	19	8	13	0	(Smart Refrigerator) The temperature falls below 40 degrees
1407	63	12	15	0	Anyone Enters Bathroom
1408	19	2	8	0	(Thermostat) The temperature goes above 80 degrees
1409	57	2	8	1	The AC is Off
1410	14	25	5	0	Living Room Window Closes
1411	63	12	15	1	A Family Member is in Home
1413	63	12	15	1	A Family Member is in Home
1414	63	12	6	0	Someone other than Alice Enters Kitchen
1415	14	25	5	0	Living Room Window Closes
1416	63	12	6	0	Someone other than Alice Enters Kitchen
1417	63	12	15	0	Anyone Enters Home
1418	19	2	8	0	(Thermostat) The temperature becomes 80 degrees
1419	35	3	3	0	Pop Music starts playing on Amazon Echo
1420	14	24	5	0	Bathroom Window Closes
1421	14	14	5	1	Bedroom Window is Closed
1422	14	25	5	2	Living Room Window is Closed
1423	63	12	6	0	Anyone Enters Home
1424	14	14	5	0	Bedroom Window Closes
1425	14	24	5	1	Bathroom Window is Closed
1426	14	25	5	2	Living Room Window is Closed
1427	14	25	5	0	Living Room Window Closes
1428	14	24	5	1	Bathroom Window is Closed
1429	14	14	5	2	Bedroom Window is Closed
1430	14	25	5	0	Living Room Window Closes
1431	14	24	5	1	Bathroom Window is Closed
1432	14	14	5	2	Bedroom Window is Closed
1433	14	24	5	0	Bathroom Window Closes
1434	14	14	5	1	Bedroom Window is Closed
1435	14	25	5	2	Living Room Window is Closed
1436	14	25	5	0	Living Room Window Closes
1437	14	24	5	1	Bathroom Window is Closed
1438	14	14	5	2	Bedroom Window is Closed
1439	14	24	5	0	Bathroom Window Closes
1440	14	14	5	1	Bedroom Window is Closed
1441	14	25	5	2	Living Room Window is Closed
1442	14	14	5	0	Bedroom Window Closes
1443	14	25	5	1	Living Room Window is Closed
1444	14	24	5	2	Bathroom Window is Closed
1445	2	5	12	0	Smart TV turns Off
1446	26	17	9	0	Clock has an Alarm set for after 
1447	63	12	15	0	Anyone Enters Home
1448	19	2	8	1	(Thermostat) The temperature is above 75
1449	2	5	12	0	Smart TV turns Off
1450	26	17	9	0	Clock has an Alarm set for after 
1452	63	12	6	0	Anyone Enters Home
1453	19	2	8	1	(Thermostat) The temperature is below 70
1454	52	11	14	0	It becomes true that "Smart Faucet's water Turns On" last happened exactly 15s  ago
1455	52	11	14	0	It becomes true that "Smart Faucet's water Turns On" last happened exactly 15s  ago
1456	13	13	4	0	Front Door Lock is Unlocked
1457	61	21	16	0	(FitBit) I am Asleep
1458	60	8	13	0	Smart Refrigerator's door is Open
1459	9	3	3	0	Amazon Echo starts playing Pop
1460	2	1	18	0	Roomba is On
1461	58	25	5	0	Living Room Window's curtains are Open
1462	49	11	14	0	It becomes true that "Smart TV is On" was active 5s  ago
1463	52	11	14	1	"(FitBit) I Fall Asleep" last happened exactly 30m  ago
1464	19	2	8	0	(Thermostat) The temperature goes above 79 degrees
1465	19	2	8	0	(Thermostat) The temperature goes above 80 degrees
1466	66	8	13	0	Smart Refrigerator's temperature becomes set below 40 degrees
1467	58	24	5	0	Bathroom Window's curtains Open
1468	63	12	15	0	Someone other than A Guest Enters Home
1469	58	24	5	0	Bathroom Window's curtains Open
1471	2	1	18	0	Roomba turns On
1472	52	11	14	1	"A Guest Enters Home" last happened less than 3h  ago
1474	63	12	6	0	Anyone is in Home
1476	52	11	14	1	It becomes true that "Someone other than A Family Member Enters Home" last happened exactly 3h  ago
1477	21	2	8	0	Thermostat is set above 80 degrees
1479	63	12	6	1	Someone other than A Family Member is not in Home
1481	52	11	14	1	"Someone other than A Family Member Enters Home" last happened exactly 3h  ago
1483	52	11	14	1	"Someone other than A Family Member Exits Home" last happened exactly 1s  ago
1484	64	22	17	0	Smart Faucet's water Turns On
1485	49	11	14	1	"Smart Faucet's water is running" was active 15s  ago
1486	9	3	3	0	Amazon Echo starts playing Pop
1487	52	11	14	0	It becomes true that "Someone other than A Family Member Enters Home" last happened less than 3h 1s  ago
1488	52	11	14	1	"Someone other than A Family Member Exits Home" last happened less than 3h  ago
1489	13	13	5	0	Front Door Lock Locks
1490	25	17	9	1	(Clock) The time is after 22:00
1491	13	13	4	2	Front Door Lock is Locked
1492	25	17	9	3	(Clock) The time is after 08:00
1493	13	13	5	4	Front Door Lock is Unlocked
1494	13	13	5	0	Front Door Lock Locks
1495	25	17	9	1	(Clock) The time is after 22:00
1496	13	13	4	2	Front Door Lock is Locked
1497	25	17	9	3	(Clock) The time is after 08:00
1498	13	13	5	4	Front Door Lock is Unlocked
1499	2	1	18	0	Roomba turns On
1500	55	17	9	1	It is Daytime
1501	63	12	6	2	Someone other than A Family Member is in Home
1502	2	1	1	3	Roomba is On
1503	64	22	17	0	Smart Faucet's water Turns On
1504	2	23	13	0	Smart Oven turns On
1505	65	23	13	0	Smart Oven's temperature goes above 10 degrees
1506	14	24	5	0	Bathroom Window Closes
1507	14	14	5	1	Bedroom Window is Closed
1508	14	25	5	2	Living Room Window is Closed
1509	14	14	5	0	Bedroom Window Opens
1510	18	18	7	1	(Weather Sensor) The weather is Raining
1511	14	14	5	0	Bedroom Window Opens
1512	19	18	8	1	(Weather Sensor) The temperature is above 80
1513	14	14	5	0	Bedroom Window Opens
1514	19	18	8	1	(Weather Sensor) The temperature is below 60
1515	19	8	13	0	(Smart Refrigerator) The temperature falls below 40 degrees
1516	14	24	5	0	Bathroom Window is Closed
1517	14	14	5	0	Bedroom Window is Closed
1518	14	25	5	0	Living Room Window is Closed
1519	13	23	13	0	Smart Oven is Unlocked
1520	63	12	15	0	Bobbie is in Kitchen
1521	21	2	8	0	Thermostat is set above 80 degrees
1522	60	8	13	0	Smart Refrigerator's door is Open
1523	64	22	17	0	Smart Faucet's water is running
1524	14	25	5	0	Living Room Window is Open
1525	19	18	8	0	(Weather Sensor) The temperature is above 60
1526	19	18	8	0	(Weather Sensor) The temperature is below 80
1527	20	18	7	0	It is Not Raining
1528	21	2	8	0	Thermostat is set above 70 degrees
1529	63	12	15	0	A Family Member is in Home
1530	14	24	5	0	Bathroom Window Closes
1531	14	14	5	1	Bedroom Window is Closed
1532	14	25	5	2	Living Room Window is Closed
1534	63	12	15	0	A Family Member is in Home
1535	58	24	5	0	Bathroom Window's curtains Open
1536	9	3	3	0	Amazon Echo starts playing Pop
1537	2	1	18	0	Roomba turns On
1538	58	25	5	0	Living Room Window's curtains are Open
1539	13	13	5	0	Front Door Lock Unlocks
1540	61	21	16	0	(FitBit) I am Asleep
1541	2	1	18	0	Roomba turns On
1542	63	12	15	0	A Guest Enters Home
1543	14	14	5	0	Bedroom Window Closes
1544	14	24	5	1	Bathroom Window is Closed
1545	14	25	5	2	Living Room Window is Closed
1546	14	25	5	0	Living Room Window Closes
1547	14	24	5	1	Bathroom Window is Closed
1548	14	14	5	2	Bedroom Window is Closed
1549	2	5	12	0	Smart TV turns Off
1550	61	21	16	0	(FitBit) I Fall Asleep
1551	63	12	15	0	Bobbie Enters Kitchen
1552	2	23	13	1	Smart Oven is On
1553	2	23	13	0	Smart Oven turns On
1554	63	12	15	1	Bobbie is in Kitchen
1555	19	18	8	0	(Weather Sensor) The temperature goes above 80 degrees
1556	19	8	13	0	(Smart Refrigerator) The temperature falls below 40 degrees
1557	51	11	14	0	It becomes true that "Smart Faucet's water is not running" was last in effect exactly 15s  ago
1558	2	4	2	0	HUE Lights turns On
1559	64	22	17	0	Smart Faucet's water Turns On
1560	19	18	8	0	(Weather Sensor) The temperature falls below 80 degrees
1561	19	18	8	1	(Weather Sensor) The temperature is above 60 degrees
1562	20	18	7	2	It is Not Raining
1563	19	18	8	0	(Weather Sensor) The temperature falls below 80 degrees
1564	19	18	8	1	(Weather Sensor) The temperature is above 60 degrees
1565	20	18	7	2	It is Not Raining
1566	19	18	8	0	(Weather Sensor) The temperature goes above 60 degrees
1567	19	18	8	1	(Weather Sensor) The temperature is below 80 degrees
1568	20	18	7	2	It is Not Raining
1569	20	18	7	0	It stops raining
1570	19	18	8	1	(Weather Sensor) The temperature is above 60 degrees
1571	19	18	8	2	(Weather Sensor) The temperature is below 80 degrees
1572	63	12	15	0	Anyone Enters Home
1573	58	24	5	0	Bathroom Window's curtains Open
1574	2	1	18	0	Roomba turns On
1575	58	14	5	0	Bedroom Window's curtains Open
1576	2	1	18	1	Roomba is On
1577	13	13	5	0	Front Door Lock Unlocks
1578	61	21	16	1	(FitBit) I am Asleep
1579	61	21	16	0	(FitBit) I Fall Asleep
1580	13	13	5	1	Front Door Lock is Unlocked
1581	63	12	15	0	A Guest Enters Home
1582	2	1	18	1	Roomba is On
1583	2	1	18	0	Roomba turns On
1584	63	12	15	1	A Guest is in Home
1585	52	11	14	0	It becomes true that "(FitBit) I Fall Asleep" last happened exactly 30m  ago
1586	52	11	14	0	It becomes true that "(FitBit) I Fall Asleep" last happened exactly 30m  ago
1587	52	11	14	0	It becomes true that "(FitBit) I Fall Asleep" last happened exactly 30m  ago
1588	28	10	10	0	Security Camera starts recording
1589	2	1	18	0	Roomba turns Off
1590	20	18	7	0	It starts raining
1591	20	18	7	0	It starts raining
1592	14	25	5	1	Living Room Window is Open
1593	49	11	14	0	It becomes true that "Nobody is in Home" was active 1s  ago
1594	58	24	5	0	Bathroom Window's curtains are Closed
1595	57	2	8	0	The AC turns On
1596	21	2	8	0	Thermostat is set to 80 degrees
1597	57	2	8	0	The AC turns On
1598	21	2	8	0	Thermostat is set to 80 degrees
1599	19	18	8	0	(Weather Sensor) The temperature becomes 72 degrees
1600	20	18	7	1	It is Not Raining
1601	63	12	15	0	Anyone Enters Home
1602	19	2	8	0	(Thermostat) The temperature goes above 75 degrees
1603	63	12	15	0	Anyone Enters Home
1604	63	12	15	0	A Guest Enters Home
1605	25	17	9	1	(Clock) The time is after 17:00
1606	25	17	9	2	(Clock) The time is before 20:00
1607	2	1	1	0	Roomba turns Off
1608	58	25	5	0	Living Room Window's curtains are Open
1609	63	12	15	0	A Guest Enters Home
1610	25	17	9	1	(Clock) The time is after 17:00
1611	25	17	9	2	(Clock) The time is before 20:00
1612	2	1	1	0	Roomba turns Off
1613	58	24	5	0	Bathroom Window's curtains are Open
1614	60	8	13	0	Smart Refrigerator's door Opens
1615	49	11	14	1	"Smart Refrigerator's door is Open" was active 2m  ago
1616	63	12	15	0	A Guest Enters Home
1617	25	17	9	1	(Clock) The time is after 17:00
1618	25	17	9	2	(Clock) The time is before 20:00
1619	19	18	8	0	(Weather Sensor) The temperature becomes 70 degrees
1620	14	24	5	1	Bathroom Window is Closed
1621	14	14	5	2	Bedroom Window is Closed
1622	2	1	1	0	Roomba turns Off
1623	58	14	5	0	Bedroom Window's curtains are Open
1624	60	8	13	0	Smart Refrigerator's door Opens
1625	49	11	14	1	"Smart Refrigerator's door is Open" was active 2m  ago
1627	58	25	5	0	Living Room Window's curtains are Closed
1628	13	13	4	0	Front Door Lock is Locked
1629	63	12	6	0	Anyone is in Bedroom
1630	66	8	13	0	Smart Refrigerator's temperature is set to 40 degrees
1631	66	8	13	0	Smart Refrigerator's temperature is set to 40 degrees
1632	66	8	13	0	Smart Refrigerator's temperature becomes set below 40 degrees
1633	58	24	5	0	Bathroom Window's curtains Open
1634	19	8	13	0	(Smart Refrigerator) The temperature falls below 40 degrees
1635	64	22	17	0	Smart Faucet's water Turns On
1636	52	11	14	1	"Smart Faucet's water Turns On" last happened exactly 15s  ago
1637	14	14	5	0	Bedroom Window Opens
1638	19	2	8	0	(Thermostat) The temperature is 80 degrees
1639	61	21	16	0	(FitBit) I Fall Asleep
1640	58	24	5	0	Bathroom Window's curtains are Closed
1641	14	14	5	0	Bedroom Window Opens
1642	19	2	8	0	(Thermostat) The temperature is 80 degrees
1643	61	21	6	0	(FitBit) I Fall Asleep
1644	19	2	8	0	(Thermostat) The temperature becomes 80 degrees
1645	9	3	3	0	Amazon Echo is playing Pop
1646	35	3	3	0	Music is playing on Amazon Echo
1647	19	2	8	0	(Thermostat) The temperature becomes 80 degrees
1648	14	14	5	0	Bedroom Window Closes
1649	21	2	8	0	Thermostat's temperature becomes set to 60 degrees
1650	21	2	8	0	Thermostat's temperature becomes set above 80 degrees
1651	52	11	14	0	It becomes true that "Smart Refrigerator's door Opens" last happened more than 2m  ago
1652	19	8	13	0	(Smart Refrigerator) The temperature becomes 40 degrees
1653	2	1	18	0	Roomba turns On
1654	61	21	16	1	(FitBit) I am Asleep
1655	15	10	6	0	Security Camera Starts Detecting Motion
1656	61	21	6	1	(FitBit) I am Asleep
1657	13	14	4	2	Bedroom Window is Locked
1658	13	13	4	3	Front Door Lock is Locked
1659	60	23	13	0	Smart Oven's door is Closed
1660	63	12	6	0	Bobbie is in Kitchen
1662	64	22	13	1	Smart Faucet's water is not running
1663	2	1	18	2	Roomba is Off
1664	14	14	5	0	Bedroom Window is Open
1665	60	8	13	0	Smart Refrigerator's door is Open
1666	19	18	8	0	(Weather Sensor) The temperature becomes 80 degrees
1667	14	14	5	1	Bedroom Window is Open
1668	19	18	8	2	(Weather Sensor) The temperature is below 60 degrees
1669	14	14	5	3	Bedroom Window is Open
1670	14	25	5	0	Living Room Window Opens
1671	14	14	5	0	Bedroom Window is Closed
1672	52	11	14	0	It becomes true that "Smart Refrigerator's door Opens" last happened more than 2m  ago
1673	63	12	6	1	Anyone is not in Kitchen
1674	63	12	15	0	Someone other than Alice Exits Home
1675	58	24	5	0	Bathroom Window's curtains are Closed
1677	19	18	8	0	(Weather Sensor) The temperature is 80 degrees
1678	18	18	7	0	(Weather Sensor) The weather becomes Clear
1680	19	18	8	0	(Weather Sensor) The temperature is 60 degrees
1681	51	11	14	0	It becomes true that "Smart Refrigerator's door is Open" was last in effect more than 2m  ago
1682	60	8	13	1	Smart Refrigerator's door is Open
1683	50	11	14	0	"undefined" has not occurred 0 times in the last 2h 
1684	64	22	13	0	Smart Faucet's water is running
1685	19	18	8	0	(Weather Sensor) The temperature becomes 70 degrees
1686	8	5	12	1	Smart TV's Volume is 30
1687	60	8	13	0	Smart Refrigerator's door is Open
1688	19	2	8	0	(Thermostat) The temperature is 80 degrees
1689	57	2	8	0	The AC is Off
1690	19	2	8	0	(Thermostat) The temperature goes above 59 degrees
1691	19	2	8	1	(Thermostat) The temperature is below 81 degrees
1692	20	18	7	2	It is Not Raining
1693	14	14	5	0	Bedroom Window is Closed
1694	19	18	8	0	(Weather Sensor) The temperature is 80 degrees
1695	64	22	17	0	Smart Faucet's water Turns On
1696	52	11	14	1	"Smart Faucet's water Turns On" last happened exactly 15s  ago
1697	38	9	13	0	(Coffee Pot) There are >1 cups of coffee brewed
1698	63	12	15	0	Someone other than Alice is not in Kitchen
1699	19	2	8	0	(Thermostat) The temperature becomes 81 degrees
1700	19	8	13	0	(Smart Refrigerator) The temperature is below 40 degrees
1701	63	12	6	0	Someone other than A Guest Enters Home
1702	2	1	18	1	Roomba is On
1703	63	12	6	2	Someone other than A Family Member is not in Home
1704	14	14	5	0	Bedroom Window is Closed
1705	19	18	8	0	(Weather Sensor) The temperature is not 60 degrees
1706	19	8	13	0	(Smart Refrigerator) The temperature is above 45 degrees
1707	63	12	6	0	Bobbie Enters Kitchen
1708	61	21	16	0	(FitBit) I am Asleep
1709	3	4	2	0	HUE Lights's Brightness is 2
1710	14	14	5	0	Bedroom Window Closes
1711	20	18	7	0	It is Raining
1712	19	2	8	0	(Thermostat) The temperature goes above 59 degrees
1713	19	2	8	1	(Thermostat) The temperature is below 81 degrees
1714	20	18	7	2	It is Not Raining
1715	2	1	18	0	Roomba is On
1716	58	25	5	0	Living Room Window's curtains are Open
1717	60	8	13	0	Smart Refrigerator's door is Open
1718	52	11	14	0	It becomes true that "Smart Refrigerator's door Opens" last happened more than 2m  ago
1719	63	12	15	1	Anyone is not in Kitchen
1720	19	2	8	0	(Thermostat) The temperature falls below 60 degrees
1721	58	14	5	0	Bedroom Window's curtains Open
1722	2	1	1	1	Roomba is On
1723	19	2	8	0	(Thermostat) The temperature goes above 80 degrees
1724	58	25	5	0	Living Room Window's curtains Open
1725	2	1	1	1	Roomba is On
1726	20	18	7	0	It starts raining
1727	9	3	3	0	Amazon Echo starts playing Pop
1728	2	23	13	0	Smart Oven turns On
1729	19	2	8	0	(Thermostat) The temperature becomes 80 degrees
1730	64	22	17	0	Smart Faucet's water is running
1731	14	14	5	0	Bedroom Window is Open
1732	19	2	8	0	(Thermostat) The temperature is below 80 degrees
1733	19	2	8	0	(Thermostat) The temperature is above 60 degrees
1734	25	17	9	0	(Clock) The time becomes 22:00
1735	58	24	5	0	Bathroom Window's curtains are Closed
1736	63	12	15	0	Someone other than Anyone is in Bathroom
1737	13	23	13	0	Smart Oven Locks
1738	63	12	6	0	Bobbie is in Kitchen
1739	25	17	9	0	(Clock) The time becomes 22:00
1740	14	14	5	0	Bedroom Window Closes
1741	66	8	13	0	Smart Refrigerator's temperature is set to 40 degrees
1742	2	1	18	0	Roomba is On
1743	63	12	15	0	Nobody is in Home
1744	19	8	13	0	(Smart Refrigerator) The temperature falls below 40 degrees
1745	58	25	5	0	Living Room Window's curtains Close
1746	58	14	5	1	Bedroom Window's curtains are Closed
1747	58	24	5	2	Bathroom Window's curtains are Closed
1748	58	24	5	3	Bathroom Window's curtains are Closed
1749	14	24	5	0	Bathroom Window Closes
1750	19	18	8	0	(Weather Sensor) The temperature goes above 60 degrees
1751	20	18	7	1	It is Not Raining
1752	63	12	15	0	A Family Member Enters Home
1753	57	2	8	1	The AC is Off
1754	49	11	14	0	"Set HUE Lights's Color to Orange" was active 1h  ago
1755	2	1	18	0	Roomba is On
1756	58	25	5	0	Living Room Window's curtains are Open
1757	21	2	8	0	Thermostat is set to 75 degrees
1758	63	12	15	0	Someone other than Anyone is in Home
1759	20	18	7	0	It starts raining
1760	19	18	8	0	(Weather Sensor) The temperature falls below 80 degrees
1761	20	18	7	1	It is Not Raining
1762	14	14	5	0	Bedroom Window Closes
1763	52	11	14	0	It becomes true that "Someone other than A Family Member Enters Home" last happened more than 3h  ago
1764	2	23	13	0	Smart Oven turns On
1765	63	12	15	1	A Family Member is in Kitchen
1766	21	2	8	0	Thermostat is set to 73 degrees
1767	63	12	6	0	Anyone is in Home
1768	19	2	8	0	(Thermostat) The temperature becomes 80 degrees
1769	58	25	5	0	Living Room Window's curtains Open
1770	2	1	18	1	Roomba is On
1771	27	17	9	0	Clock's Alarm Starts going off
1772	19	18	8	0	(Weather Sensor) The temperature falls below 60 degrees
1773	14	14	5	0	Bedroom Window Opens
1774	19	2	8	0	(Thermostat) The temperature is 60 degrees
1775	19	18	8	0	(Weather Sensor) The temperature goes above 80 degrees
1776	19	18	6	0	(Weather Sensor) The temperature goes above 80 degrees
1777	19	8	13	0	(Smart Refrigerator) The temperature becomes 39 degrees
1778	19	2	8	0	(Thermostat) The temperature becomes 59 degrees
1779	2	1	18	0	Roomba is On
1780	63	12	15	0	Someone other than Nobody is in Home
1781	52	11	14	1	"undefined" last happened exactly 3h  ago
1782	57	2	8	0	The AC is Off
1783	63	12	6	0	Nobody is in Home
1784	64	22	17	0	Smart Faucet's water is not running
1785	14	14	5	0	Bedroom Window Closes
1786	19	18	8	0	(Weather Sensor) The temperature is 80 degrees
1787	19	18	8	0	(Weather Sensor) The temperature falls below 60 degrees
1788	60	8	13	0	Smart Refrigerator's door Closes
1789	60	8	13	0	Smart Refrigerator's door Opens
1790	57	2	8	0	The AC is On
1791	63	12	6	0	Anyone is in Home
1792	19	8	13	0	(Smart Refrigerator) The temperature becomes 40 degrees
1795	19	18	8	0	(Weather Sensor) The temperature goes above 80 degrees
1796	19	18	8	0	(Weather Sensor) The temperature goes above 59 degrees
1797	19	18	8	1	(Weather Sensor) The temperature is below 81 degrees
1798	9	3	3	0	Amazon Echo starts playing Pop
1800	63	12	15	0	A Family Member is in Home
1801	19	18	8	0	(Weather Sensor) The temperature is 75 degrees
1802	64	22	17	0	Smart Faucet's water Turns On
1803	19	18	8	0	(Weather Sensor) The temperature falls below 81 degrees
1804	19	18	8	1	(Weather Sensor) The temperature is above 59 degrees
1805	64	22	17	0	Smart Faucet's water Turns On
1806	63	12	15	0	Someone other than A Family Member Enters Home
1807	66	8	13	0	Smart Refrigerator's temperature becomes set below 40 degrees
1808	25	17	9	0	(Clock) The time becomes 20:30
1811	64	22	17	0	Smart Faucet's water Turns On
1812	57	2	8	0	The AC turns On
1813	21	2	8	0	Thermostat is set to 78 degrees
1814	63	12	15	0	Anyone Enters Home
1815	19	8	13	0	(Smart Refrigerator) The temperature is below 40 degrees
1816	61	21	16	0	(FitBit) I Fall Asleep
1817	2	5	12	1	Smart TV is On
1818	51	11	14	2	"(FitBit) I am Asleep" was last in effect exactly 30m  ago
1819	58	24	5	0	Bathroom Window's curtains Open
1820	2	1	18	0	Roomba is On
1821	15	10	6	0	Security Camera detects motion
1822	19	8	13	0	(Smart Refrigerator) The temperature is below 40 degrees
1823	19	8	13	0	(Smart Refrigerator) The temperature is below 40 degrees
1824	14	25	5	0	Living Room Window Opens
1825	63	12	6	0	Anyone is in Home
1827	61	21	16	0	(FitBit) I am Asleep
1828	19	8	13	0	(Smart Refrigerator) The temperature is 38 degrees
1829	21	2	8	0	Thermostat's temperature becomes set above 80 degrees
1831	57	2	8	1	The AC is On
1833	13	13	5	0	Front Door Lock Unlocks
1834	63	12	15	1	Anyone is in Bedroom
1835	60	8	13	0	Smart Refrigerator's door Opens
1836	9	3	3	0	Amazon Echo starts playing Pop
1837	19	8	13	0	(Smart Refrigerator) The temperature changes from 40 degrees
1838	58	25	5	0	Living Room Window's curtains Open
1839	66	8	13	0	Smart Refrigerator's temperature is set above 40 degrees
1840	52	11	14	0	It becomes true that "Roomba turns On" last happened exactly  ago
1842	57	2	8	0	The AC is On
1843	63	12	15	0	Someone other than Nobody is in Home
1844	19	2	8	0	(Thermostat) The temperature is 73 degrees
1845	21	2	8	0	Thermostat is set to 73 degrees
1846	58	25	5	0	Living Room Window's curtains Close
1847	19	8	13	0	(Smart Refrigerator) The temperature changes from 42 degrees
1848	2	1	18	0	Roomba is Off
1849	63	12	6	0	Someone other than A Family Member is not in Home
1850	60	23	13	0	Smart Oven's door Opens
1851	57	2	8	0	The AC is Off
1852	63	12	15	0	Anyone is in Home
1853	58	24	5	0	Bathroom Window's curtains Open
1854	19	8	13	0	(Smart Refrigerator) The temperature becomes 37 degrees
1855	19	2	8	0	(Thermostat) The temperature goes above 75 degrees
1856	63	12	6	1	Anyone is in Home
1857	2	5	12	0	Smart TV turns Off
1858	61	21	16	0	(FitBit) I Fall Asleep
1859	21	2	8	0	Thermostat is set above 80 degrees
1860	57	2	8	0	The AC is On
1861	63	12	15	0	Anyone is not in Home
1862	66	8	13	0	Smart Refrigerator's temperature becomes set to 39 degrees
1863	19	2	8	0	(Thermostat) The temperature falls below 70 degrees
1864	63	12	6	1	Anyone is in Home
1865	60	23	13	0	Smart Oven's door Opens
1866	63	12	15	0	Anyone is in Home
1867	63	12	15	0	Anyone is in Home
1868	58	24	5	0	Bathroom Window's curtains Open
1869	19	2	8	0	(Thermostat) The temperature is below 80 degrees
1870	2	1	18	0	Roomba turns On
1871	58	25	5	0	Living Room Window's curtains are Open
1872	9	3	3	0	Amazon Echo starts playing Pop
1875	9	3	3	0	Amazon Echo starts playing Pop
1877	58	25	5	0	Living Room Window's curtains are Open
1878	9	3	3	0	Amazon Echo starts playing Hip-Hop
1879	9	3	3	0	Amazon Echo is playing Pop
1880	14	24	5	0	Bathroom Window Opens
1881	66	8	13	0	Smart Refrigerator's temperature is set to 36 degrees
1882	52	11	14	0	It becomes true that "Smart Faucet's water Turns On" last happened more than 15s  ago
1883	35	3	3	0	music stops playing on Amazon Echo
1884	14	14	5	0	Bedroom Window Closes
1885	14	24	5	1	Bathroom Window is Closed
1886	14	25	5	2	Living Room Window is Closed
1887	35	3	3	0	music stops playing on Amazon Echo
1888	2	1	18	0	Roomba is On
1889	58	25	5	0	Living Room Window's curtains are Open
1890	63	12	6	0	Anyone Exits Home
1891	58	24	5	0	Bathroom Window's curtains are Closed
1892	66	8	13	0	Smart Refrigerator's temperature is set to 35 degrees
1893	64	22	17	0	Smart Faucet's water Turns On
1894	2	1	18	0	Roomba is On
1895	58	25	5	0	Living Room Window's curtains are Open
1896	58	14	5	0	Bedroom Window's curtains are Open
1897	58	24	5	0	Bathroom Window's curtains are Open
1898	66	8	13	0	Smart Refrigerator's temperature is set to 34 degrees
1899	66	8	13	0	Smart Refrigerator's temperature is set to 33 degrees
1901	60	23	13	0	Smart Oven's door Closes
1902	21	2	8	0	Thermostat's temperature becomes set to 72 degrees
1903	63	12	6	0	Anyone is in Home
1904	14	24	5	0	Bathroom Window Opens
1905	63	12	15	0	Anyone Exits Home
1907	63	12	15	0	Anyone Enters Home
1908	14	14	5	0	Bedroom Window Opens
1910	3	4	2	0	HUE Lights's Brightness is 2
1911	63	12	15	0	Anyone Enters Home
1912	63	12	6	0	Bobbie Enters Kitchen
1913	63	12	6	1	Someone other than Bobbie is not in Kitchen
1915	14	14	5	0	Bedroom Window Opens
1917	14	24	5	0	Bathroom Window is Closed
1918	14	14	5	0	Bedroom Window is Closed
1919	14	25	5	0	Living Room Window is Closed
1920	14	25	5	0	Living Room Window Opens
1921	14	24	5	0	Bathroom Window is Open
1922	14	14	5	0	Bedroom Window is Closed
1923	14	25	5	0	Living Room Window is Closed
1924	14	25	5	0	Living Room Window Opens
1926	13	13	5	0	Front Door Lock is Unlocked
1927	2	1	18	0	Roomba turns On
1928	58	25	5	1	Living Room Window's curtains are Open
1929	60	8	13	0	Smart Refrigerator's door Opens
1930	14	25	5	0	Living Room Window Opens
1931	63	12	6	0	Someone other than Bobbie Enters Kitchen
1932	63	12	6	1	Bobbie is in Kitchen
1933	14	14	5	0	Bedroom Window is Open
1934	14	24	5	0	Bathroom Window is Closed
1935	14	25	5	0	Living Room Window is Closed
1937	49	11	14	1	"Roomba is Off" was active 1h  ago
1938	49	11	14	2	"Smart Faucet's water is running" was active 1m  ago
1939	58	14	5	0	Bedroom Window's curtains Open
1940	14	25	5	0	Living Room Window is Open
1941	14	24	5	0	Bathroom Window is Closed
1942	14	14	5	0	Bedroom Window is Closed
1943	63	12	6	0	Anyone Exits Kitchen
1944	63	12	6	1	Bobbie is in Kitchen
1945	9	3	3	0	Amazon Echo is playing Pop
1946	63	12	6	0	A Family Member Enters Home
1947	63	12	6	0	Bobbie Exits Kitchen
1948	58	14	5	0	Bedroom Window's curtains Close
1949	14	25	5	1	Living Room Window is Closed
1950	14	14	5	0	Bedroom Window Opens
1951	19	18	8	0	(Weather Sensor) The temperature is not 80 degrees
1952	64	22	17	0	Smart Faucet's water Turns Off
1953	64	22	17	0	Smart Faucet's water Turns On
1954	66	8	13	0	Smart Refrigerator's temperature becomes set below 40 degrees
1955	2	1	18	0	Roomba is On
1956	58	24	5	0	Bathroom Window's curtains are Open
1957	2	1	18	0	Roomba is On
1958	58	14	5	0	Bedroom Window's curtains are Open
1959	2	1	18	0	Roomba is On
1960	58	25	5	0	Living Room Window's curtains are Open
1961	2	1	18	0	Roomba turns On
1962	58	25	5	0	Living Room Window's curtains Close
1963	14	14	5	0	Bedroom Window is Open
1964	19	18	8	0	(Weather Sensor) The temperature is below 60 degrees
1965	19	18	8	0	(Weather Sensor) The temperature is above 80 degrees
1966	63	12	6	0	Anyone Enters Home
1967	58	25	5	0	Living Room Window's curtains Open
1968	14	14	5	0	Bedroom Window is Open
1969	19	2	8	0	(Thermostat) The temperature is above 80 degrees
1970	19	2	8	0	(Thermostat) The temperature is below 60 degrees
1971	14	25	5	0	Living Room Window is Open
1972	9	3	3	0	Amazon Echo starts playing Pop
1974	19	18	8	0	(Weather Sensor) The temperature is below 60 degrees
1975	58	14	5	0	Bedroom Window's curtains Close
1976	14	25	5	1	Living Room Window is Closed
1977	58	25	5	0	Living Room Window's curtains Close
1978	58	14	5	1	Bedroom Window's curtains are Closed
1979	64	22	17	0	Smart Faucet's water Turns On
1980	19	2	8	0	(Thermostat) The temperature becomes 79 degrees
1982	9	3	3	0	Amazon Echo starts playing Pop
1983	14	14	5	0	Bedroom Window is Open
1984	19	2	8	0	(Thermostat) The temperature is above 80 degrees
1985	19	2	8	0	(Thermostat) The temperature is below 60 degrees
1986	58	24	5	0	Bathroom Window's curtains are Open
1987	9	3	3	0	Amazon Echo starts playing Pop
1988	35	3	3	0	Pop music starts playing on Amazon Echo
1989	13	13	5	0	Front Door Lock Unlocks
1990	14	24	5	0	Bathroom Window is Open
1991	14	14	5	0	Bedroom Window is Open
1992	14	25	5	0	Living Room Window is Open
1993	2	5	12	0	Smart TV turns Off
1994	2	5	12	0	Smart TV turns On
1996	63	12	15	0	Alice is not in Home
1997	64	22	17	0	Smart Faucet's water Turns On
1998	64	22	17	1	Smart Faucet's water is not running
1999	52	11	14	2	"Smart Faucet's water Turns On" last happened exactly 15s  ago
2000	13	13	4	0	Front Door Lock is Locked
2001	55	17	9	0	It is Nighttime
2002	64	22	17	0	Smart Faucet's water Turns On
2003	64	22	17	1	Smart Faucet's water is not running
2004	52	11	14	2	"Smart Faucet's water Turns On" last happened exactly 15s  ago
2005	19	2	8	0	(Thermostat) The temperature goes above 80 degrees
2006	19	2	8	0	(Thermostat) The temperature goes above 80 degrees
2007	35	3	3	0	Pop music starts playing on Amazon Echo
2008	51	11	14	0	It becomes true that "Smart Faucet's water is not running" was last in effect exactly 15s  ago
2009	14	14	5	0	Bedroom Window is Open
2010	14	24	5	0	Bathroom Window is Closed
2011	14	25	5	0	Living Room Window is Closed
2012	18	18	7	0	(Weather Sensor) The weather becomes Partly Cloudy
2013	14	25	5	0	Living Room Window is Open
2014	14	24	5	0	Bathroom Window is Closed
2309	63	12	15	0	A Guest Enters Home
2312	2	4	2	0	HUE Lights is On
2313	63	12	15	0	A Family Member is in Living Room
2314	55	17	9	0	It is Nighttime
2015	14	14	5	0	Bedroom Window is Closed
2016	2	5	12	0	Smart TV turns Off
2017	61	21	6	0	(FitBit) I Fall Asleep
2019	61	21	16	0	(FitBit) I Fall Asleep
2020	2	1	18	0	Roomba is On
2021	58	14	5	0	Bedroom Window's curtains are Open
2022	63	12	6	0	A Guest Enters Home
2025	58	24	5	0	Bathroom Window's curtains Open
2026	60	8	13	0	Smart Refrigerator's door Opens
2027	50	11	14	1	"Smart Refrigerator's door Opens" has occurred >1 times in the last 2m 
2028	64	22	13	0	Smart Faucet's water Turns Off
2029	64	22	13	0	Smart Faucet's water Turns Off
2030	64	22	13	0	Smart Faucet's water Turns Off
2031	64	22	13	0	Smart Faucet's water Turns Off
2032	52	11	14	0	It becomes true that "A Guest Enters Home" last happened more than 3h  ago
2033	58	14	5	0	Bedroom Window's curtains are Open
2034	58	24	5	0	Bathroom Window's curtains are Open
2035	63	12	15	0	Someone other than A Family Member Enters Home
2036	49	11	14	0	It becomes true that "Roomba is Off" was active 1h  ago
2037	58	24	5	0	Bathroom Window's curtains Open
2038	2	1	18	1	Roomba is On
2039	21	2	8	0	Thermostat is set to 72 degrees
2040	15	10	6	0	Security Camera detects motion
2041	58	14	5	0	Bedroom Window's curtains Open
2042	2	1	18	1	Roomba is On
2043	2	5	12	0	Smart TV turns Off
2044	25	17	9	0	(Clock) The time becomes 23:00
2045	19	2	8	0	(Thermostat) The temperature goes above 80 degrees
2048	57	2	8	0	The AC turns On
2049	15	10	6	0	Security Camera does not detect motion
2050	58	25	5	0	Living Room Window's curtains Open
2051	2	1	18	1	Roomba is On
2052	58	24	5	0	Bathroom Window's curtains Open
2053	58	24	5	0	Bathroom Window's curtains Open
2054	13	13	4	0	Front Door Lock is Locked
2055	55	17	9	0	It is Nighttime
2056	18	18	7	0	(Weather Sensor) The weather becomes Raining
2057	13	13	4	0	Front Door Lock Unlocks
2058	55	17	9	0	It is Nighttime
2059	14	14	5	0	Bedroom Window is Closed
2060	19	18	6	0	(Weather Sensor) The temperature is above 80 degrees
2061	19	2	8	0	(Thermostat) The temperature becomes 81 degrees
2062	60	8	13	0	Smart Refrigerator's door Closes
2063	60	8	13	0	Smart Refrigerator's door Opens
2064	33	8	11	0	(Smart Refrigerator) +96+5+5 gets removed from my Shopping List
2065	61	21	16	1	(FitBit) I am Awake
2066	52	11	14	0	It becomes true that "Smart Refrigerator's door Opens" last happened more than 2m  ago
2068	19	2	8	0	(Thermostat) The temperature becomes 59 degrees
2069	14	14	5	0	Bedroom Window is Closed
2070	19	18	8	0	(Weather Sensor) The temperature is below 60 degrees
2071	2	23	13	0	Smart Oven turns On
2072	13	23	13	1	Smart Oven is Unlocked
2073	35	3	3	0	pop music starts playing on Amazon Echo
2074	13	13	5	0	Front Door Lock Locks
2075	58	24	5	0	Bathroom Window's curtains Open
2076	60	8	13	0	Smart Refrigerator's door Closes
2077	60	8	13	0	Smart Refrigerator's door Opens
2078	20	18	7	0	It starts raining
2079	18	18	6	0	(Weather Sensor) The weather becomes Raining
2081	21	2	8	0	Thermostat is set above 80 degrees
2082	57	2	8	0	The AC is On
2083	21	2	8	0	Thermostat is set above 80 degrees
2085	21	2	8	0	Thermostat is set above 80 degrees
2086	13	23	13	0	Smart Oven Locks
2087	65	23	13	0	Smart Oven's temperature is 125 degrees
2088	49	11	14	0	It becomes true that "Smart Faucet's water is running" was active 15m  ago
2089	64	22	17	1	Smart Faucet's water is running
2090	19	2	8	0	(Thermostat) The temperature falls below 60 degrees
2091	64	22	17	0	Smart Faucet's water Turns On
2092	57	2	8	0	The AC is On
2093	19	18	8	0	(Weather Sensor) The temperature is above 80 degrees
2094	19	2	8	0	(Thermostat) The temperature goes above 80 degrees
2095	66	8	13	0	Smart Refrigerator's temperature is set to 41 degrees
2096	66	8	13	0	Smart Refrigerator's temperature is set to 40 degrees
2097	58	24	5	0	Bathroom Window's curtains Open
2098	9	3	3	0	Amazon Echo is playing Pop
2099	51	11	14	0	It becomes true that "Anyone is not in Home" was last in effect exactly 10m  ago
2100	19	2	8	0	(Thermostat) The temperature goes above 60 degrees
2101	19	2	8	1	(Thermostat) The temperature is below 80 degrees
2102	52	11	14	0	It becomes true that "(FitBit) I Fall Asleep" last happened more than 30m  ago
2103	14	24	5	0	Bathroom Window Opens
2104	14	14	5	0	Bedroom Window is Closed
2105	14	24	5	0	Bathroom Window Closes
2106	63	12	6	0	Anyone Enters Home
2107	14	25	5	0	Living Room Window Opens
2108	14	24	5	0	Bathroom Window is Closed
2109	14	14	5	0	Bedroom Window Closes
2110	14	14	5	0	Bedroom Window Opens
2111	14	24	5	0	Bathroom Window is Closed
2112	2	1	18	0	Roomba turns On
2113	19	2	8	0	(Thermostat) The temperature goes above 60 degrees
2114	19	2	8	1	(Thermostat) The temperature is below 80 degrees
2115	19	2	8	0	(Thermostat) The temperature goes above 60 degrees
2310	2	1	18	0	Roomba is On
2116	19	2	8	1	(Thermostat) The temperature is below 80 degrees
2117	2	5	1	0	Smart TV turns Off
2118	25	17	9	0	(Clock) The time becomes 21:00
2119	14	25	5	0	Living Room Window Closes
2120	35	3	3	0	pop starts playing on Amazon Echo
2121	14	24	5	0	Bathroom Window Opens
2122	14	25	5	0	Living Room Window is Closed
2123	2	5	1	0	Smart TV turns Off
2124	25	17	9	0	(Clock) The time becomes 21:00
2125	14	24	5	0	Bathroom Window Closes
2126	14	14	5	1	Bedroom Window is Closed
2127	63	12	6	0	Anyone Enters Home
2128	14	24	5	1	Bathroom Window is Closed
2129	14	14	5	2	Bedroom Window is Closed
2130	14	25	5	3	Living Room Window is Closed
2131	14	14	5	0	Bedroom Window Closes
2132	14	25	5	1	Living Room Window is Closed
2133	19	2	8	0	(Thermostat) The temperature changes from 73 degrees
2134	18	18	7	0	(Weather Sensor) The weather becomes Clear
2135	19	18	8	1	(Weather Sensor) The temperature is above 59 degrees
2136	19	18	8	2	(Weather Sensor) The temperature is below 81 degrees
2137	58	25	5	0	Living Room Window's curtains Open
2138	14	25	5	0	Living Room Window Closes
2139	14	14	5	1	Bedroom Window is Closed
2140	55	17	9	0	It becomes Daytime
2141	58	24	5	0	Bathroom Window's curtains Close
2142	2	1	18	0	Roomba is On
2143	58	25	5	0	Living Room Window's curtains Open
2144	2	1	18	1	Roomba is On
2145	61	21	6	0	(FitBit) I Fall Asleep
2146	58	14	5	0	Bedroom Window's curtains Close
2147	2	1	18	0	Roomba is On
2148	58	25	5	0	Living Room Window's curtains Close
2149	2	1	18	0	Roomba is On
2150	64	22	17	0	Smart Faucet's water Turns Off
2151	64	22	17	0	Smart Faucet's water Turns On
2152	63	12	15	0	Bobbie Enters Kitchen
2153	2	23	13	1	Smart Oven is On
2154	63	12	15	0	Bobbie Enters Kitchen
2155	2	23	13	1	Smart Oven is On
2156	19	18	8	0	(Weather Sensor) The temperature goes above 59 degrees
2157	18	18	7	1	(Weather Sensor) The weather is Clear
2158	58	25	5	0	Living Room Window's curtains Open
2159	2	1	18	1	Roomba is On
2160	52	11	14	0	It becomes true that "(FitBit) I Fall Asleep" last happened exactly 31m  ago
2161	19	18	8	0	(Weather Sensor) The temperature falls below 81 degrees
2162	18	18	7	1	(Weather Sensor) The weather is Clear
2163	58	14	5	0	Bedroom Window's curtains Open
2164	2	1	18	1	Roomba is On
2165	19	2	8	0	(Thermostat) The temperature becomes 80 degrees
2166	60	8	13	0	Smart Refrigerator's door is Open
2167	63	12	15	0	Anyone Enters Home
2170	9	3	3	0	Amazon Echo starts playing Pop
2171	9	3	3	1	Amazon Echo is playing Pop
2172	58	25	5	0	Living Room Window's curtains Open
2173	63	12	15	0	Anyone Exits Home
2174	57	2	8	1	The AC is On
2175	14	24	5	0	Bathroom Window Closes
2176	14	14	5	1	Bedroom Window is Closed
2177	14	25	5	2	Living Room Window is Closed
2178	65	23	13	0	Smart Oven's temperature goes above 25 degrees
2179	63	12	6	1	Alice is in Kitchen
2180	14	14	5	0	Bedroom Window Closes
2181	14	24	5	1	Bathroom Window is Closed
2182	14	25	5	2	Living Room Window is Closed
2183	14	25	5	0	Living Room Window Closes
2184	14	24	5	1	Bathroom Window is Closed
2185	14	14	5	2	Bedroom Window is Closed
2186	14	14	5	0	Bedroom Window Opens
2187	19	2	8	0	(Thermostat) The temperature is above 60 degrees
2188	51	11	14	0	It becomes true that "(FitBit) I am Asleep" was last in effect more than 30m  ago
2189	14	24	5	0	Bathroom Window Closes
2190	14	14	5	1	Bedroom Window is Closed
2191	14	25	5	2	Living Room Window is Closed
2192	14	14	5	0	Bedroom Window Closes
2193	14	24	5	1	Bathroom Window is Closed
2194	14	25	5	2	Living Room Window is Closed
2195	14	25	5	0	Living Room Window Closes
2196	14	24	5	1	Bathroom Window is Closed
2197	14	14	5	2	Bedroom Window is Closed
2198	15	10	6	0	Security Camera Starts Detecting Motion
2199	14	14	5	0	Bedroom Window Opens
2200	19	2	8	0	(Thermostat) The temperature is above 80 degrees
2201	63	12	6	0	Anyone Enters Home
2202	63	12	6	0	Anyone Enters Home
2203	63	12	6	0	Anyone Enters Home
2204	52	11	14	0	It becomes true that "Security Camera Stops Detecting Motion" last happened exactly 3h  ago
2205	14	14	5	0	Bedroom Window Closes
2206	19	2	8	0	(Thermostat) The temperature is above 80 degrees
2207	60	8	13	0	Smart Refrigerator's door Opens
2208	52	11	14	1	"Smart Refrigerator's door Opens" last happened exactly 2m  ago
2209	14	14	5	0	Bedroom Window Closes
2210	19	2	8	0	(Thermostat) The temperature is below 60 degrees
2211	9	3	3	0	Amazon Echo starts playing Pop
2212	9	3	3	0	Amazon Echo starts playing Pop
2213	14	14	5	0	Bedroom Window Closes
2214	19	2	8	0	(Thermostat) The temperature is below 59 degrees
2311	58	25	5	0	Living Room Window's curtains are Open
2215	51	11	14	0	It becomes true that "Smart Refrigerator's door is Closed" was last in effect exactly 2m  ago
2216	66	8	13	0	Smart Refrigerator's temperature becomes set below 40 degrees
2217	60	8	13	1	Smart Refrigerator's door is Closed
2218	58	24	5	0	Bathroom Window's curtains Open
2219	58	24	5	0	Bathroom Window's curtains Open
2220	66	8	13	0	Smart Refrigerator's temperature becomes set below 40 degrees
2221	51	11	14	0	It becomes true that "Smart Refrigerator's door is Closed" was last in effect more than 2m  ago
2222	19	8	13	0	(Smart Refrigerator) The temperature changes from 40 degrees
2223	51	11	14	0	It becomes true that "Smart Faucet's water is not running" was last in effect exactly 15s  ago
2224	19	8	13	0	(Smart Refrigerator) The temperature falls below 40 degrees
2225	60	8	13	1	Smart Refrigerator's door is Closed
2226	66	8	13	0	Smart Refrigerator's temperature becomes set below 40 degrees
2227	60	8	13	1	Smart Refrigerator's door is Closed
2228	61	21	16	0	(FitBit) I Fall Asleep
2229	2	1	18	0	Roomba turns On
2230	63	12	6	1	A Guest is in Home
2231	52	11	14	2	"A Guest Enters Home" last happened less than 3h  ago
2232	19	8	13	0	(Smart Refrigerator) The temperature goes above 45 degrees
2233	60	8	13	1	Smart Refrigerator's door is Closed
2234	58	24	5	0	Bathroom Window's curtains Open
2235	14	24	5	0	Bathroom Window Closes
2236	14	14	5	1	Bedroom Window is Closed
2237	63	12	6	0	A Family Member Enters Home
2238	19	2	8	1	(Thermostat) The temperature is below 70 degrees
2239	19	2	8	2	(Thermostat) The temperature is above 75 degrees
2240	20	18	7	0	It starts raining
2241	14	14	5	1	Bedroom Window is Open
2242	19	18	8	0	(Weather Sensor) The temperature goes above 80 degrees
2243	14	14	5	1	Bedroom Window is Open
2244	61	21	6	0	(FitBit) I Fall Asleep
2245	2	5	12	1	Smart TV is On
2246	15	10	6	2	Security Camera does not detect motion
2247	52	11	14	3	"(FitBit) I Fall Asleep" last happened exactly 30m  ago
2248	51	11	14	0	It becomes true that "Bathroom Window is Closed" was last in effect exactly  ago
2249	51	11	14	1	"Bedroom Window is Closed" was last in effect exactly  ago
2250	51	11	14	2	"Living Room Window is Closed" was last in effect exactly  ago
2251	19	18	8	0	(Weather Sensor) The temperature falls below 60 degrees
2252	14	14	5	1	Bedroom Window is Open
2253	2	23	13	0	Smart Oven is On
2254	13	23	13	0	Smart Oven is Locked
2255	2	1	18	0	Roomba is On
2256	63	12	6	0	A Guest is in Home
2257	63	12	6	0	A Family Member Enters Bedroom
2258	19	18	8	1	(Weather Sensor) The temperature is below 80 degrees
2259	19	18	8	2	(Weather Sensor) The temperature is above 60 degrees
2260	20	18	7	3	It is Not Raining
2261	14	14	5	4	Bedroom Window is Closed
2263	19	8	13	1	(Smart Refrigerator) The temperature is above 41 degrees
2264	52	11	14	0	It becomes true that "Security Camera Stops Detecting Motion" last happened more than 30m  ago
2265	60	8	13	0	Smart Refrigerator's door Opens
2266	50	11	14	1	"Smart Refrigerator's door Opens" has occurred <1 times in the last 2m 
2267	9	3	3	0	Amazon Echo is not playing Pop
2268	9	3	3	0	Amazon Echo is playing Pop
2269	2	1	18	0	Roomba is On
2270	58	14	5	0	Bedroom Window's curtains are Open
2271	58	25	5	1	Living Room Window's curtains are Open
2272	14	14	5	0	Bedroom Window is Open
2273	19	18	8	0	(Weather Sensor) The temperature is below 60 degrees
2274	14	24	5	0	Bathroom Window is Open
2275	19	18	8	0	(Weather Sensor) The temperature is above 80 degrees
2276	20	18	7	0	It is Raining
2277	14	14	5	0	Bedroom Window is Open
2278	60	8	13	0	Smart Refrigerator's door Opens
2279	52	11	14	1	"Smart Refrigerator's door Opens" last happened more than 2m  ago
2280	9	3	3	0	Amazon Echo starts playing Pop
2282	58	24	5	0	Bathroom Window's curtains Open
2283	58	24	5	0	Bathroom Window's curtains Open
2284	9	3	3	0	Amazon Echo starts playing Pop
2285	9	3	3	0	Amazon Echo starts playing Pop
2286	9	3	3	0	Amazon Echo starts playing Pop
2287	58	24	5	0	Bathroom Window's curtains are Closed
2288	9	3	3	0	Amazon Echo starts playing Pop
2289	9	3	3	0	Amazon Echo starts playing Pop
2290	2	1	18	0	Roomba turns On
2291	9	3	3	0	Amazon Echo starts playing Pop
2292	2	5	12	0	Smart TV is On
2293	61	21	6	0	(FitBit) I am Asleep
2294	2	5	12	0	Smart TV turns On
2295	52	11	14	1	"(FitBit) I Fall Asleep" last happened exactly 30m  ago
2296	13	13	5	0	Front Door Lock Unlocks
2297	61	21	6	0	(FitBit) I am Asleep
2298	14	14	5	0	Bedroom Window Closes
2299	20	18	7	1	It is Not Raining
2300	19	18	8	2	(Weather Sensor) The temperature is above 59 degrees
2301	19	18	8	3	(Weather Sensor) The temperature is below 81 degrees
2302	14	24	5	0	Bathroom Window Closes
2303	14	14	5	1	Bedroom Window is Closed
2304	64	22	17	0	Smart Faucet's water Turns On
2305	51	11	14	1	"Smart Faucet's water is running" was last in effect exactly 15m  ago
2306	2	1	18	0	Roomba turns On
2315	2	1	18	0	Roomba is On
2316	2	1	18	0	Roomba turns On
2317	2	4	2	0	HUE Lights is On
2318	2	4	2	0	HUE Lights is On
2319	2	1	18	0	Roomba is On
2320	14	25	5	0	Living Room Window is Open
2321	2	1	18	0	Roomba is On
2322	58	25	5	0	Living Room Window's curtains are Open
2323	60	8	13	0	Smart Refrigerator's door Opens
2324	52	11	14	1	"Smart Refrigerator's door Closes" last happened more than 2m  ago
2325	19	8	13	0	(Smart Refrigerator) The temperature becomes 40 degrees
2326	19	2	8	0	(Thermostat) The temperature goes above 80 degrees
2327	21	2	8	0	Thermostat's temperature becomes set above 80 degrees
2328	60	8	13	0	Smart Refrigerator's door Opens
2329	9	3	3	0	Amazon Echo starts playing Pop
2330	2	1	18	0	Roomba turns On
2331	58	25	5	0	Living Room Window's curtains Open
2332	2	1	18	1	Roomba is On
2333	2	1	18	0	Roomba is On
2334	58	25	5	0	Living Room Window's curtains are Open
2335	2	1	18	0	Roomba is On
2336	58	14	5	0	Bedroom Window's curtains are Open
2337	52	11	14	0	It becomes true that "Smart Faucet's water Turns On" last happened more than 15s  ago
2338	2	1	18	0	Roomba is On
2339	58	24	5	0	Bathroom Window's curtains are Open
2340	61	21	6	0	(FitBit) I Fall Asleep
2341	2	5	12	1	Smart TV is On
2342	52	11	14	2	"(FitBit) I Fall Asleep" last happened exactly 30m  ago
2343	19	2	8	0	(Thermostat) The temperature goes above 80 degrees
2344	2	1	18	0	Roomba turns On
2345	58	14	5	1	Bedroom Window's curtains are Open
2346	63	12	15	0	Alice Enters Bedroom
2347	60	8	13	0	Smart Refrigerator's door Opens
2349	63	12	15	1	Someone other than Anyone is not in Home
2350	3	4	2	0	HUE Lights's brightness falls below 1
2351	55	17	9	0	It becomes Daytime
2352	55	17	9	0	It becomes Nighttime
2353	55	17	9	0	It becomes Nighttime
2354	19	2	8	0	(Thermostat) The temperature changes from 72 degrees
2355	63	12	15	1	Nobody is not in Home
2356	9	3	3	0	Amazon Echo starts playing Pop
2357	58	25	5	0	Living Room Window's curtains Close
2358	19	2	8	0	(Thermostat) The temperature becomes 76 degrees
2359	63	12	15	1	Anyone is in Home
2360	14	24	5	0	Bathroom Window Closes
2361	14	14	5	1	Bedroom Window is Closed
2362	63	12	15	0	Anyone Enters Bathroom
2363	19	2	8	0	(Thermostat) The temperature becomes 69 degrees
2364	63	12	15	1	Anyone is in Home
2365	64	22	17	0	Smart Faucet's water Turns On
2366	52	11	14	1	"Smart Faucet's water Turns On" last happened more than 15s  ago
2367	52	11	14	0	It becomes true that "Smart Faucet's water Turns On" last happened exactly 15s  ago
2368	2	1	18	0	Roomba turns On
2369	58	14	5	1	Bedroom Window's curtains are Open
2370	14	25	5	2	Living Room Window is Open
2371	58	24	5	0	Bathroom Window's curtains Open
2372	19	18	8	0	(Weather Sensor) The temperature becomes 68 degrees
2373	19	18	8	0	(Weather Sensor) The temperature changes from 88 degrees
2375	63	12	15	1	A Guest is in Home
2376	63	12	15	0	Anyone Enters Bathroom
2377	64	22	17	0	Smart Faucet's water Turns On
2378	50	11	14	1	"Smart Faucet's water Turns On" has occurred exactly 1 times in the last 15s 
2379	13	13	5	0	Front Door Lock Locks
2380	19	2	8	0	(Thermostat) The temperature goes above 79 degrees
2381	61	21	6	0	(FitBit) I Fall Asleep
2382	13	13	4	1	Front Door Lock is Unlocked
2383	63	12	15	0	A Guest Enters Home
2384	19	18	8	0	(Weather Sensor) The temperature becomes 71 degrees
2385	60	8	13	0	Smart Refrigerator's door Closes
2386	60	8	13	0	Smart Refrigerator's door Opens
2387	52	11	14	0	It becomes true that "Smart Faucet's water Turns On" last happened exactly 15s  ago
2388	60	8	13	0	Smart Refrigerator's door Opens
2389	51	11	14	1	"Smart Refrigerator's door is Open" was last in effect exactly 2m  ago
2390	61	21	6	0	(FitBit) I Fall Asleep
2391	61	21	6	0	(FitBit) I Wake Up
2392	63	12	6	0	A Guest Exits Home
2394	58	14	5	1	Bedroom Window's curtains are Open
2395	14	25	5	2	Living Room Window is Open
2396	9	3	3	0	Amazon Echo starts playing Pop
2397	9	3	3	0	Amazon Echo starts playing Pop
2398	19	18	8	0	(Weather Sensor) The temperature goes above 80 degrees
2399	52	11	14	0	It becomes true that "A Guest Enters Home" last happened exactly 3h 1m  ago
2400	63	12	6	1	A Guest is in Home
2401	18	18	6	0	(Weather Sensor) The weather becomes Raining
2402	19	18	8	0	(Weather Sensor) The temperature falls below 60 degrees
2403	19	8	13	0	(Smart Refrigerator) The temperature becomes 39 degrees
2404	66	8	13	0	Smart Refrigerator's temperature becomes set above 43 degrees
2406	63	12	15	0	Bobbie Enters Kitchen
2407	2	23	13	1	Smart Oven is On
2408	61	21	6	0	(FitBit) I Fall Asleep
2409	63	12	15	0	Anyone Enters Home
2410	61	21	16	0	(FitBit) I Fall Asleep
2411	14	24	5	0	Bathroom Window Closes
2412	52	11	14	0	It becomes true that "Smart Faucet's water Turns On" last happened exactly 15s  ago
2413	63	12	15	0	Nobody Enters Home
2414	14	14	5	0	Bedroom Window Closes
2415	63	12	15	0	Nobody Enters Home
2416	52	11	14	0	It becomes true that "(FitBit) I Fall Asleep" last happened more than 30m  ago
2417	2	5	12	1	Smart TV is On
2418	14	25	5	0	Living Room Window Closes
2419	58	14	5	0	Bedroom Window's curtains are Closed
2420	2	5	12	0	Smart TV turns Off
2421	61	21	6	0	(FitBit) I Fall Asleep
2422	66	8	13	0	Smart Refrigerator's temperature becomes set below 40 degrees
2423	64	22	17	0	Smart Faucet's water Turns On
2424	52	11	14	1	"Smart Faucet's water Turns On" last happened exactly 15s  ago
2425	13	13	4	0	Front Door Lock is Unlocked
2426	61	21	16	0	(FitBit) I am Asleep
2427	63	12	15	0	Anyone Enters Bathroom
2428	9	3	3	0	Amazon Echo starts playing Pop
2429	52	11	14	0	It becomes true that "Smart Refrigerator's door Opens" last happened exactly 2m  ago
2430	63	12	15	1	Anyone is in Kitchen
2431	60	8	13	2	Smart Refrigerator's door is Open
2432	9	3	3	0	Amazon Echo starts playing Pop
2433	2	5	12	0	Smart TV turns Off
2434	61	21	16	0	(FitBit) I Fall Asleep
2435	19	18	8	0	(Weather Sensor) The temperature falls below 60 degrees
2436	14	14	5	1	Bedroom Window is Open
2437	2	1	18	0	Roomba turns On
2438	2	1	18	0	Roomba turns On
2439	19	18	8	0	(Weather Sensor) The temperature goes above 80 degrees
2440	14	14	5	1	Bedroom Window is Open
2442	58	24	5	0	Bathroom Window's curtains Close
2443	13	13	4	0	Front Door Lock Locks
2444	61	21	16	0	(FitBit) I am Asleep
2445	9	3	3	0	Amazon Echo starts playing Pop
2446	2	1	18	0	Roomba turns On
2447	58	25	5	1	Living Room Window's curtains are Open
2448	14	24	5	0	Bathroom Window Closes
2449	14	14	5	1	Bedroom Window is Closed
2450	14	25	5	2	Living Room Window is Closed
2451	20	18	7	0	It starts raining
2452	2	1	18	0	Roomba turns On
2453	58	14	5	1	Bedroom Window's curtains are Open
2454	20	18	7	0	It starts raining
2455	14	14	5	1	Bedroom Window is Open
2456	2	5	1	0	Smart TV turns Off
2457	61	21	16	0	(FitBit) I am Asleep
2458	2	1	18	0	Roomba turns On
2459	58	24	5	1	Bathroom Window's curtains are Open
2460	13	23	13	0	Smart Oven Unlocks
2461	63	12	15	1	Bobbie is in Kitchen
2462	19	2	8	0	(Thermostat) The temperature goes above 80 degrees
2463	2	5	1	0	Smart TV turns Off
2464	61	21	16	0	(FitBit) I am Asleep
2465	58	24	5	0	Bathroom Window's curtains Close
2466	63	12	6	0	Anyone is in Bathroom
2467	60	8	13	0	Smart Refrigerator's door Closes
2468	60	8	13	0	Smart Refrigerator's door Opens
2469	19	2	8	0	(Thermostat) The temperature falls below 60 degrees
2470	19	18	8	0	(Weather Sensor) The temperature becomes 60 degrees
2471	19	18	8	1	(Weather Sensor) The temperature is below 80 degrees
2472	2	5	12	0	Smart TV is Off
2473	61	21	16	0	(FitBit) I am Awake
2474	2	1	18	0	Roomba is Off
2475	13	23	13	0	Smart Oven is Unlocked
2476	63	12	6	0	Bobbie is in Kitchen
2477	58	24	5	0	Bathroom Window's curtains Open
2478	9	3	3	0	Amazon Echo starts playing Pop
2479	18	18	6	0	(Weather Sensor) The weather becomes Clear
2480	19	2	8	1	(Thermostat) The temperature is above 60 degrees
2481	19	2	8	2	(Thermostat) The temperature is below 80 degrees
2482	57	2	8	0	The AC turns On
2483	63	12	15	1	Anyone is not in Home
2484	9	3	3	0	Amazon Echo starts playing Pop
2485	63	12	15	0	Anyone Enters Home
2486	64	22	17	0	Smart Faucet's water Turns Off
2487	64	22	17	0	Smart Faucet's water Turns On
2488	14	25	5	0	Living Room Window Opens
2489	63	12	6	0	A Family Member is in Home
2490	51	11	14	0	It becomes true that "Smart Refrigerator's door is Open" was last in effect exactly 2m  ago
2491	2	23	13	0	Smart Oven is On
2492	63	12	6	0	Bobbie is in Kitchen
2493	14	14	5	0	Bedroom Window Opens
2494	63	12	6	0	A Family Member is in Bedroom
2495	63	12	15	0	Bobbie Enters Kitchen
2496	63	12	15	1	Someone other than Bobbie is not in Kitchen
2497	21	2	8	0	Thermostat is set to 60 degrees
2498	63	12	6	0	Anyone is in Home
2499	52	11	14	0	It becomes true that "A Guest Enters Home" last happened less than 3h  ago
2500	14	25	5	0	Living Room Window Closes
2501	14	14	5	1	Bedroom Window is Closed
2502	21	2	8	0	Thermostat is set to 71 degrees
2503	63	12	6	0	Anyone is in Home
2504	14	24	5	0	Bathroom Window Closes
2505	14	14	5	1	Bedroom Window is Closed
2506	52	11	14	0	It becomes true that "A Guest Enters Home" last happened more than 3h  ago
2507	52	11	14	0	It becomes true that "Smart Refrigerator's door Opens" last happened more than 2m  ago
2508	63	12	15	1	Anyone is not in Kitchen
2509	63	12	15	0	Bobbie Enters Kitchen
2510	2	23	13	1	Smart Oven is On
2511	20	18	7	0	It starts raining
2512	14	25	5	0	Living Room Window Closes
2513	14	24	5	1	Bathroom Window is Closed
2514	14	24	5	0	Bathroom Window Closes
2515	14	25	5	1	Living Room Window is Closed
2516	63	12	15	0	Bobbie Exits Kitchen
2517	2	23	13	1	Smart Oven is On
2518	14	14	5	0	Bedroom Window is Open
2519	20	18	7	0	It is Raining
2520	19	18	8	0	(Weather Sensor) The temperature is 81 degrees
2521	19	18	8	0	(Weather Sensor) The temperature is 59 degrees
2522	14	14	5	0	Bedroom Window Closes
2523	14	24	5	1	Bathroom Window is Closed
2524	19	18	6	0	(Weather Sensor) The temperature falls below 60 degrees
2525	21	2	8	0	Thermostat is set below 78 degrees
2526	2	1	18	0	Roomba turns On
2527	58	24	5	1	Bathroom Window's curtains are Open
2528	58	14	5	2	Bedroom Window's curtains are Open
2529	58	25	5	3	Living Room Window's curtains are Open
2530	14	14	5	0	Bedroom Window Opens
2531	14	25	5	1	Living Room Window is Closed
2532	2	1	18	0	Roomba turns On
2533	58	24	5	1	Bathroom Window's curtains are Open
2534	58	14	5	2	Bedroom Window's curtains are Open
2535	58	25	5	3	Living Room Window's curtains are Open
2536	19	2	8	0	(Thermostat) The temperature goes above 80 degrees
2537	58	25	5	0	Living Room Window's curtains Open
2538	2	1	18	1	Roomba is On
2539	9	3	3	0	Amazon Echo starts playing Pop
2540	58	24	5	0	Bathroom Window's curtains Open
2541	2	1	18	1	Roomba is On
2542	9	3	3	0	Amazon Echo is not playing Pop
2543	64	22	17	0	Smart Faucet's water is running
2544	58	14	5	0	Bedroom Window's curtains Open
2545	2	1	18	1	Roomba is On
2546	19	2	8	0	(Thermostat) The temperature goes above 80 degrees
2547	57	2	8	1	The AC is Off
2548	63	12	15	0	Bobbie Enters Kitchen
2549	2	23	13	1	Smart Oven is On
2550	52	11	14	0	It becomes true that "Smart Faucet's water Turns On" last happened more than 15s  ago
2551	63	12	15	0	Bobbie Exits Kitchen
2552	2	23	13	1	Smart Oven is On
2553	51	11	14	0	It becomes true that "Smart Refrigerator's door is Open" was last in effect more than 2m  ago
2554	57	2	8	0	The AC turns On
2555	19	18	8	0	(Weather Sensor) The temperature is 80 degrees
2556	9	3	3	0	Amazon Echo starts playing Pop
2557	19	18	8	0	(Weather Sensor) The temperature goes above 80 degrees
2558	9	3	3	0	Amazon Echo stops playing Pop
2559	60	8	13	0	Smart Refrigerator's door Closes
2560	63	12	6	0	Anyone is not in Kitchen
2561	60	8	13	0	Smart Refrigerator's door is Open
2562	19	18	8	0	(Weather Sensor) The temperature goes above 80 degrees
2563	14	14	5	1	Bedroom Window is Open
2564	58	24	5	0	Bathroom Window's curtains Open
2565	14	25	5	0	Living Room Window Closes
2567	14	14	5	1	Bedroom Window is Open
2568	65	23	13	0	Smart Oven's temperature becomes 100 degrees
2569	61	21	16	0	(FitBit) I Fall Asleep
2570	63	12	6	1	Anyone is in Bedroom
2571	20	18	7	0	It starts raining
2572	14	14	5	1	Bedroom Window is Open
2573	19	18	8	0	(Weather Sensor) The temperature goes above 80 degrees
2574	14	14	5	1	Bedroom Window is Open
2575	19	18	8	0	(Weather Sensor) The temperature falls below 60 degrees
2576	14	14	5	1	Bedroom Window is Open
2577	63	12	6	0	Someone other than A Family Member Enters Home
2578	2	1	18	0	Roomba is On
2579	58	14	5	0	Bedroom Window's curtains are Open
2580	19	2	8	0	(Thermostat) The temperature goes above 80 degrees
2581	63	12	6	0	Someone other than A Family Member Enters Home
2582	2	1	18	1	Roomba is On
2583	63	12	15	0	A Guest Enters Home
2584	52	11	14	1	"A Guest Enters Home" last happened less than 3h  ago
2585	19	2	8	0	(Thermostat) The temperature becomes 80 degrees
2586	63	12	6	0	Someone other than A Family Member Enters Home
2587	52	11	14	0	It becomes true that "A Guest Enters Home" last happened exactly 3h 1m  ago
2588	2	1	18	1	Roomba is On
2589	63	12	15	0	A Guest Enters Home
2590	2	1	18	1	Roomba is On
2591	63	12	6	0	Nobody Enters Home
2592	9	3	3	0	Amazon Echo starts playing Pop
2593	63	12	6	0	A Guest Enters Home
2594	2	5	12	0	Smart TV is On
2595	61	21	16	0	(FitBit) I am Asleep
2596	20	18	7	0	It stops raining
2597	19	18	8	1	(Weather Sensor) The temperature is above 60 degrees
2598	19	18	8	2	(Weather Sensor) The temperature is below 80 degrees
2599	14	24	5	0	Bathroom Window Closes
2600	14	14	5	1	Bedroom Window is Closed
2601	14	25	5	2	Living Room Window is Closed
2602	60	8	13	0	Smart Refrigerator's door is Open
2603	9	3	3	0	Amazon Echo starts playing Pop
2604	14	14	5	0	Bedroom Window Closes
2605	14	24	5	1	Bathroom Window is Closed
2606	14	25	5	2	Living Room Window is Closed
2607	14	24	5	0	Bathroom Window Closes
2608	14	25	5	1	Living Room Window is Closed
2609	14	14	5	2	Bedroom Window is Closed
2610	14	25	5	0	Living Room Window Closes
2611	14	24	5	1	Bathroom Window is Closed
2612	14	14	5	2	Bedroom Window is Closed
2613	14	24	5	0	Bathroom Window is Closed
2614	14	14	5	0	Bedroom Window is Closed
2615	14	25	5	0	Living Room Window is Closed
2616	52	11	14	0	It becomes true that "Smart Refrigerator's door Opens" last happened more than 2m  ago
2617	63	12	15	0	Bobbie is in Kitchen
2618	2	23	13	0	Smart Oven is On
2619	64	22	17	0	Smart Faucet's water Turns On
2620	52	11	14	1	"Smart Faucet's water Turns On" last happened more than 15s  ago
2621	64	22	17	2	Smart Faucet's water is running
2622	63	12	15	0	Bobbie Enters Kitchen
2623	2	23	13	1	Smart Oven is On
2624	61	21	16	0	(FitBit) I Fall Asleep
2626	63	12	15	0	Someone other than A Family Member is in Home
2628	58	25	5	0	Living Room Window's curtains Open
2629	2	1	18	0	Roomba turns On
2630	58	25	5	1	Living Room Window's curtains are Open
2631	2	1	18	0	Roomba turns On
2632	58	14	5	1	Bedroom Window's curtains are Open
2633	2	1	18	0	Roomba turns On
2634	58	24	5	1	Bathroom Window's curtains are Open
2635	19	2	8	0	(Thermostat) The temperature goes above 79 degrees
2636	19	2	8	0	(Thermostat) The temperature is below 79 degrees
2637	21	2	8	0	Thermostat is set below 80 degrees
2638	19	18	8	0	(Weather Sensor) The temperature becomes 80 degrees
2639	58	24	5	0	Bathroom Window's curtains are Closed
2640	64	22	17	0	Smart Faucet's water Turns Off
2641	64	22	17	0	Smart Faucet's water Turns On
2642	63	12	15	0	A Guest Enters Home
2643	2	1	18	1	Roomba is On
2644	60	8	13	0	Smart Refrigerator's door Closes
2645	60	8	13	0	Smart Refrigerator's door Opens
2646	49	11	14	0	It becomes true that "Smart Refrigerator's door is Open" was active 2m  ago
2647	60	8	13	1	Smart Refrigerator's door is Open
2648	49	11	14	0	It becomes true that "Smart Refrigerator's door is Open" was active 2m  ago
2649	60	8	13	1	Smart Refrigerator's door is Open
2650	51	11	14	0	It becomes true that "Smart Faucet's water is running" was last in effect exactly  ago
2651	52	11	14	1	"Smart Faucet's water Turns On" last happened exactly 15s  ago
2652	2	1	18	0	Roomba is Off
2653	58	24	5	0	Bathroom Window's curtains are Open
2654	58	14	5	0	Bedroom Window's curtains are Open
2655	58	25	5	0	Living Room Window's curtains are Open
2656	14	24	5	0	Bathroom Window is Open
2657	14	14	5	0	Bedroom Window is Open
2658	14	25	5	0	Living Room Window is Open
2659	13	13	5	0	Front Door Lock is Locked
2660	25	17	9	0	(Clock) The time is 23:30
2661	14	14	5	0	Bedroom Window Opens
2662	20	18	7	1	It is Raining
2663	19	2	8	2	(Thermostat) The temperature is below 60 degrees
2664	19	2	8	3	(Thermostat) The temperature is above 80 degrees
2665	65	23	13	0	Smart Oven's temperature becomes 100 degrees
2666	19	2	8	0	(Thermostat) The temperature goes above 75 degrees
2667	63	12	15	1	Anyone is in Home
2668	14	24	5	0	Bathroom Window Closes
2669	14	14	5	1	Bedroom Window is Closed
2670	14	25	5	2	Living Room Window is Closed
2671	19	8	13	0	(Smart Refrigerator) The temperature falls below 40 degrees
2672	52	11	14	0	It becomes true that "(FitBit) I Fall Asleep" last happened more than 30m  ago
2673	19	18	8	0	(Weather Sensor) The temperature falls below 60 degrees
2674	19	18	8	1	(Weather Sensor) The temperature is above 80 degrees
2675	14	14	5	2	Bedroom Window is Open
2676	65	23	13	0	Smart Oven's temperature is above 70 degrees
2677	63	12	15	0	Someone other than Bobbie is not in Kitchen
2678	13	13	5	0	Front Door Lock Unlocks
2679	13	13	5	0	Front Door Lock is Locked
2680	61	21	16	0	(FitBit) I am Asleep
2681	14	14	5	0	Bedroom Window Opens
2682	19	18	8	0	(Weather Sensor) The temperature is 80 degrees
2683	14	14	5	0	Bedroom Window Closes
2684	19	18	8	0	(Weather Sensor) The temperature is 60 degrees
2685	2	1	18	0	Roomba turns On
2686	52	11	14	0	"Someone other than A Family Member is in Home" last happened less than 3h  ago
2687	14	14	5	0	Bedroom Window Opens
2688	19	18	8	0	(Weather Sensor) The temperature is 60 degrees
2689	14	14	5	0	Bedroom Window Closes
2690	19	18	8	0	(Weather Sensor) The temperature is 59 degrees
2691	14	14	5	0	Bedroom Window Closes
2692	20	18	7	0	It is Raining
2693	14	14	5	0	Bedroom Window Closes
2694	20	18	7	0	It is Raining
2695	19	2	8	0	(Thermostat) The temperature falls below 60 degrees
2696	19	2	8	1	(Thermostat) The temperature is 88 degrees
2697	19	18	8	2	(Weather Sensor) The temperature is above 84 degrees
2698	21	2	8	3	Thermostat is set to 77 degrees
2699	19	2	8	4	(Thermostat) The temperature is 83 degrees
2700	35	3	3	0	pop starts playing on Amazon Echo
2701	63	12	6	0	A Guest Enters Home
2702	2	1	18	1	Roomba is On
2704	14	14	5	0	Bedroom Window is Closed
2705	19	18	8	0	(Weather Sensor) The temperature is above 80 degrees
2706	19	18	8	0	(Weather Sensor) The temperature is below 60 degrees
2707	58	14	5	0	Bedroom Window's curtains Close
2708	9	3	3	0	Amazon Echo stops playing Pop
2709	19	18	8	0	(Weather Sensor) The temperature is below 80 degrees
2710	58	25	5	0	Living Room Window's curtains Open
2711	58	14	5	1	Bedroom Window's curtains are Open
2712	58	24	5	2	Bathroom Window's curtains are Open
2713	13	23	13	0	Smart Oven Locks
2714	9	3	3	0	Amazon Echo starts playing Pop
2715	27	17	9	0	Clock's Alarm Starts going off
2716	19	8	13	0	(Smart Refrigerator) The temperature becomes 49 degrees
2717	64	22	17	0	Smart Faucet's water is running
2718	51	11	14	0	"Turn Off Smart Faucet's water" was last in effect more than 15s  ago
2719	66	8	13	0	Smart Refrigerator's temperature is set to 41 degrees
2720	58	24	5	0	Bathroom Window's curtains are Closed
2721	58	25	5	0	Living Room Window's curtains Open
2722	58	14	5	1	Bedroom Window's curtains are Open
2723	58	24	5	2	Bathroom Window's curtains are Open
2724	60	8	13	0	Smart Refrigerator's door is Open
2725	63	12	15	0	Anyone Enters Bathroom
2726	21	2	8	0	Thermostat is set to 72 degrees
2727	63	12	15	0	Anyone is in Home
2728	21	2	8	0	Thermostat is set to 72 degrees
2729	63	12	15	0	Anyone is not in Home
2730	2	1	18	0	Roomba is On
2731	63	12	6	0	Someone other than A Guest is in Home
2732	2	1	18	0	Roomba is On
2733	63	12	15	0	A Guest is in Home
2734	2	1	18	0	Roomba is On
2735	63	12	15	0	Someone other than A Guest is in Home
2736	2	1	18	0	Roomba is On
2737	58	25	5	0	Living Room Window's curtains are Open
2738	58	14	5	0	Bedroom Window's curtains are Open
2739	58	24	5	0	Bathroom Window's curtains are Open
2740	52	11	14	0	It becomes true that "Smart Refrigerator's door Opens" last happened more than 2m  ago
2741	2	5	12	0	Smart TV is On
2742	55	17	9	0	It is Nighttime
2743	63	12	15	0	Anyone is in Bedroom
2744	61	21	6	0	(FitBit) I am Asleep
2745	2	1	18	0	Roomba is On
2746	63	12	6	0	A Guest is in Home
2747	25	17	9	0	(Clock) The time is after 17:00
2748	2	1	18	0	Roomba turns On
2749	63	12	6	0	Someone other than A Family Member is in Home
2750	64	22	13	0	Smart Faucet's water is running
2751	14	24	5	0	Bathroom Window is Open
2752	14	14	5	0	Bedroom Window is Closed
2753	14	25	5	0	Living Room Window is Closed
2754	14	14	5	0	Bedroom Window is Open
2755	14	24	5	0	Bathroom Window is Closed
2756	14	25	5	0	Living Room Window is Closed
2757	14	25	5	0	Living Room Window is Open
2758	14	14	5	0	Bedroom Window is Closed
2759	14	24	5	0	Bathroom Window is Closed
2760	58	24	5	0	Bathroom Window's curtains are Open
2761	60	8	13	0	Smart Refrigerator's door is Open
2762	2	1	18	0	Roomba is On
2763	58	24	5	0	Bathroom Window's curtains are Open
2764	58	14	5	0	Bedroom Window's curtains are Open
2765	58	25	5	0	Living Room Window's curtains are Open
2767	64	22	17	0	Smart Faucet's water Turns On
2769	64	22	17	0	Smart Faucet's water Turns On
2771	64	22	17	0	Smart Faucet's water Turns On
2773	64	22	17	0	Smart Faucet's water Turns On
2775	64	22	17	0	Smart Faucet's water Turns On
2777	64	22	17	0	Smart Faucet's water Turns On
2779	64	22	17	0	Smart Faucet's water Turns On
2781	64	22	17	0	Smart Faucet's water Turns On
2783	64	22	17	0	Smart Faucet's water Turns On
2785	64	22	17	0	Smart Faucet's water Turns On
2787	64	22	17	0	Smart Faucet's water Turns On
2788	64	22	17	0	Smart Faucet's water Turns Off
2789	64	22	17	0	Smart Faucet's water Turns On
2790	64	22	17	0	Smart Faucet's water Turns Off
2791	64	22	17	0	Smart Faucet's water Turns On
2792	64	22	17	0	Smart Faucet's water Turns Off
2793	64	22	17	0	Smart Faucet's water Turns On
2794	64	22	17	0	Smart Faucet's water Turns Off
2795	64	22	17	0	Smart Faucet's water Turns On
2796	64	22	17	0	Smart Faucet's water Turns Off
2797	64	22	17	0	Smart Faucet's water Turns On
2798	64	22	17	0	Smart Faucet's water Turns Off
2799	64	22	17	0	Smart Faucet's water Turns On
2800	64	22	17	0	Smart Faucet's water Turns Off
2801	64	22	17	0	Smart Faucet's water Turns On
2802	64	22	17	0	Smart Faucet's water Turns Off
3107	2	5	12	0	Smart TV is On
3108	55	17	9	0	It is Nighttime
3109	25	17	9	0	(Clock) The time is 22:00
3213	63	12	15	0	Anyone Enters Home
2803	64	22	17	0	Smart Faucet's water Turns On
2804	64	22	17	0	Smart Faucet's water Turns Off
2805	64	22	17	0	Smart Faucet's water Turns On
2806	64	22	17	0	Smart Faucet's water Turns Off
2807	64	22	17	0	Smart Faucet's water Turns On
2808	64	22	17	0	Smart Faucet's water Turns Off
2809	64	22	17	0	Smart Faucet's water Turns Off
2810	58	25	5	0	Living Room Window's curtains Open
2811	2	1	18	1	Roomba is On
2812	13	23	13	0	Smart Oven Locks
2813	63	12	6	1	Bobbie is in Kitchen
2814	13	23	13	0	Smart Oven Locks
2815	63	12	6	1	Bobbie is in Kitchen
2816	60	8	13	0	Smart Refrigerator's door Opens
2817	60	8	13	1	Smart Refrigerator's door is Open
2818	60	8	13	2	Smart Refrigerator's door is Closed
2819	60	8	13	3	Smart Refrigerator's door is Closed
2820	60	8	13	4	Smart Refrigerator's door is Closed
2821	65	23	13	0	Smart Oven's temperature goes above 100 degrees
2822	58	25	5	0	Living Room Window's curtains Close
2823	2	1	1	0	Roomba is On
2824	64	22	17	0	Smart Faucet's water is not running
2825	64	22	13	0	Smart Faucet's water is not running
2826	19	8	13	0	(Smart Refrigerator) The temperature becomes 39 degrees
2827	61	21	16	0	(FitBit) I Fall Asleep
2828	55	17	9	1	It is Nighttime
2829	28	10	10	0	Security Camera is recording
2830	35	7	3	0	2 is playing on Speakers
2831	14	24	5	0	Bathroom Window Closes
2832	14	14	5	1	Bedroom Window is Closed
2833	64	22	17	0	Smart Faucet's water is running
2834	14	14	5	0	Bedroom Window Closes
2835	14	25	5	1	Living Room Window is Closed
2836	64	22	17	0	Smart Faucet's water is running
2837	14	24	5	0	Bathroom Window Closes
2838	14	25	5	1	Living Room Window is Closed
2839	62	21	16	0	(FitBit) My heart rate becomes 140BPM
2840	52	11	14	0	It becomes true that "(FitBit) I Fall Asleep" last happened exactly 30m  ago
2841	2	5	12	1	Smart TV is On
2842	65	23	13	0	Smart Oven's temperature goes above 100 degrees
2843	60	23	13	1	Smart Oven's door is Closed
2844	33	8	11	0	(Smart Refrigerator) 1 is on my Shopping List
2845	19	2	8	0	(Thermostat) The temperature becomes 81 degrees
2846	19	2	8	0	(Thermostat) The temperature becomes 80 degrees
2847	50	11	14	0	It becomes true that "(Weather Sensor) The temperature goes above 45 degrees" has occurred 13 times in the last 2h 6m 14s 
2848	52	11	14	0	It becomes true that "Smart Faucet's water Turns On" last happened exactly 16s  ago
2849	6	4	2	0	HUE Lights's Color is Blue
2850	63	12	15	0	Alice is not in Bathroom
2851	21	2	8	0	Thermostat is set to 70 degrees
2852	63	12	15	0	Anyone is in Home
2853	49	11	14	0	It becomes true that "Bathroom Window is Closed" was active  ago
2854	14	14	5	1	Bedroom Window is Closed
2855	14	25	5	2	Living Room Window is Closed
2856	14	24	5	0	Bathroom Window Closes
2857	14	14	5	1	Bedroom Window is Closed
2858	14	25	5	2	Living Room Window is Closed
2859	18	18	7	0	(Weather Sensor) The weather is not Partly Cloudy
2860	14	14	5	0	Bedroom Window Closes
2861	14	24	5	1	Bathroom Window is Closed
2862	14	25	5	2	Living Room Window is Closed
2863	2	23	13	0	Smart Oven is On
2864	63	12	15	0	Someone other than Alice is in Kitchen
2865	60	23	13	0	Smart Oven's door is Open
2866	19	2	8	0	(Thermostat) The temperature becomes 78 degrees
2867	19	2	8	0	(Thermostat) The temperature becomes 78 degrees
2868	14	25	5	0	Living Room Window Closes
2869	14	24	5	1	Bathroom Window is Closed
2870	14	14	5	2	Bedroom Window is Closed
2871	14	14	5	0	Bedroom Window Closes
2872	14	24	5	1	Bathroom Window is Closed
2873	14	25	5	2	Living Room Window is Closed
2874	58	14	5	0	Bedroom Window's curtains Open
2875	63	12	6	1	Anyone is in Bedroom
2877	14	24	5	0	Bathroom Window Opens
2878	14	14	5	0	Bedroom Window is Closed
2879	19	2	8	0	(Thermostat) The temperature goes above 80 degrees
2880	52	11	14	0	It becomes true that "Someone other than Nobody Enters Home" last happened less than 3h  ago
2881	66	8	13	0	Smart Refrigerator's temperature becomes set to 41 degrees
2882	60	8	13	0	Smart Refrigerator's door is Open
2883	9	3	3	0	Amazon Echo starts playing Pop
2884	9	3	3	0	Amazon Echo starts playing Pop
2885	61	21	16	0	(FitBit) I Fall Asleep
2886	21	2	8	0	Thermostat is set to 72 degrees
2887	13	13	5	0	Front Door Lock is Locked
2888	55	17	9	0	It is Nighttime
2889	60	8	13	0	Smart Refrigerator's door Closes
2890	60	8	13	0	Smart Refrigerator's door Opens
2891	60	8	13	0	Smart Refrigerator's door Closes
2892	60	8	13	0	Smart Refrigerator's door Opens
2893	14	14	5	0	Bedroom Window is Open
2894	18	18	7	0	(Weather Sensor) The weather is not Raining
2895	18	18	7	0	(Weather Sensor) The weather is Thunderstorms
2896	18	18	7	0	(Weather Sensor) The weather is Snowing
2897	18	18	7	0	(Weather Sensor) The weather is Hailing
2898	20	18	7	0	It is Raining
2899	14	14	5	0	Bedroom Window is Open
2900	18	18	7	0	(Weather Sensor) The weather is Sunny
2901	18	18	7	0	(Weather Sensor) The weather is Clear
2902	14	14	5	0	Bedroom Window is Open
2903	18	18	7	0	(Weather Sensor) The weather is not Raining
2904	18	18	7	0	(Weather Sensor) The weather is Thunderstorms
2905	18	18	7	0	(Weather Sensor) The weather is Snowing
2906	18	18	7	0	(Weather Sensor) The weather is Hailing
2907	20	18	7	0	It is Raining
2908	66	8	13	0	Smart Refrigerator's temperature becomes set below 40 degrees
2910	15	10	6	0	Security Camera detects motion
2911	9	3	3	0	Amazon Echo starts playing Pop
2912	19	2	8	0	(Thermostat) The temperature becomes 81 degrees
2913	9	3	3	0	Amazon Echo is playing Pop
2914	21	2	8	0	Thermostat's temperature becomes set below 60 degrees
2915	19	2	8	0	(Thermostat) The temperature goes above 80 degrees
2916	9	3	3	0	Amazon Echo is playing Pop
2917	9	3	3	0	Amazon Echo is playing Pop
2918	9	3	3	0	Amazon Echo starts playing Pop
2919	64	22	17	0	Smart Faucet's water Turns Off
2920	64	22	17	0	Smart Faucet's water Turns On
2921	19	18	8	0	(Weather Sensor) The temperature goes above 80 degrees
2922	20	18	7	0	It starts raining
2923	61	21	16	0	(FitBit) I am Asleep
2924	13	13	4	0	Front Door Lock is Unlocked
2925	2	1	18	0	Roomba turns On
2926	63	12	15	0	Someone other than A Family Member is in Living Room
2927	13	13	4	0	Front Door Lock Locks
2928	55	17	9	0	It is Nighttime
2929	21	2	8	0	Thermostat is set to 72 degrees
2930	63	12	6	0	A Family Member is in Home
2931	64	22	17	0	Smart Faucet's water Turns On
2933	9	3	3	0	Amazon Echo starts playing Pop
2934	13	23	13	0	Smart Oven is Locked
2935	63	12	15	0	Bobbie is in Kitchen
2936	64	22	17	0	Smart Faucet's water Turns On
2937	49	11	14	1	"Smart Faucet's water is running" was active 15s  ago
2938	14	14	5	0	Bedroom Window is Open
2939	19	2	8	0	(Thermostat) The temperature is below 60 degrees
2940	19	2	8	0	(Thermostat) The temperature is above 80 degrees
2941	20	18	7	0	It is Raining
2942	2	1	18	0	Roomba is On
2943	63	12	15	0	Someone other than A Family Member is in Living Room
2944	52	11	14	0	"Someone other than A Family Member is in Living Room" last happened less than 3h  ago
2946	63	12	15	0	Someone other than A Family Member is in Living Room
2948	58	24	5	0	Bathroom Window's curtains are Open
2949	2	1	18	0	Roomba is On
2950	58	14	5	0	Bedroom Window's curtains are Open
2951	2	1	18	0	Roomba is On
2952	58	25	5	0	Living Room Window's curtains are Open
2953	2	1	18	0	Roomba is On
2954	58	24	5	0	Bathroom Window's curtains are Closed
2955	2	1	18	0	Roomba is On
2956	58	24	5	0	Bathroom Window's curtains are Open
2957	19	8	13	0	(Smart Refrigerator) The temperature becomes 39 degrees
2958	2	1	18	0	Roomba turns On
2959	58	25	5	1	Living Room Window's curtains are Open
2960	19	8	13	0	(Smart Refrigerator) The temperature becomes 41 degrees
2961	2	5	12	0	Smart TV is On
2962	61	21	16	0	(FitBit) I am Asleep
2963	2	23	13	0	Smart Oven turns On
2964	63	12	15	1	Bobbie is in Kitchen
2965	21	2	8	0	Thermostat is set to 73 degrees
2966	63	12	15	0	Anyone is in Home
2967	63	12	15	0	Bobbie Enters Kitchen
2968	2	23	13	1	Smart Oven is On
2969	14	14	5	0	Bedroom Window is Open
2970	19	18	8	0	(Weather Sensor) The temperature is above 60 degrees
2971	18	18	7	1	(Weather Sensor) The weather is not Raining
2972	19	18	8	0	(Weather Sensor) The temperature is below 80 degrees
2973	2	1	18	0	Roomba is On
2974	58	24	5	0	Bathroom Window's curtains are Open
2975	58	14	5	0	Bedroom Window's curtains are Open
2976	58	25	5	0	Living Room Window's curtains are Open
2977	2	5	12	0	Smart TV turns Off
2978	61	21	6	0	(FitBit) I Fall Asleep
2979	2	5	12	0	Smart TV turns Off
2980	61	21	6	0	(FitBit) I Fall Asleep
2981	2	5	12	0	Smart TV turns Off
2982	61	21	6	0	(FitBit) I Fall Asleep
2983	14	14	5	0	Bedroom Window is Open
2984	20	18	7	0	It is Raining
2985	61	21	16	0	(FitBit) I Fall Asleep
2986	2	5	12	1	Smart TV is On
2987	63	12	6	0	Someone other than A Family Member Enters Home
2988	63	12	6	1	Alice is in Home
2989	63	12	6	2	Bobbie is in Home
2990	14	14	5	0	Bedroom Window is Open
2991	19	2	8	0	(Thermostat) The temperature is above 80 degrees
2992	2	5	12	0	Smart TV turns On
2993	61	21	16	1	(FitBit) I am Asleep
2994	52	11	14	2	"Smart TV turns On" last happened exactly 30m  ago
2995	58	24	5	0	Bathroom Window's curtains are Closed
2996	2	1	18	0	Roomba is On
2997	58	14	5	1	Bedroom Window's curtains are Closed
2998	58	25	5	0	Living Room Window's curtains are Closed
2999	14	14	5	0	Bedroom Window is Open
3000	19	2	8	0	(Thermostat) The temperature is below 60 degrees
3001	63	12	6	0	Someone other than A Family Member Enters Home
3002	63	12	6	1	Alice is in Home
3003	63	12	6	2	Bobbie is in Home
3004	58	25	5	0	Living Room Window's curtains Open
3005	58	24	5	0	Bathroom Window's curtains Open
3006	66	8	13	0	Smart Refrigerator's temperature becomes set below 40 degrees
3007	66	8	13	0	Smart Refrigerator's temperature becomes set below 40 degrees
3008	63	12	15	0	Someone other than A Family Member Enters Home
3009	2	1	18	1	Roomba is On
3010	58	24	5	0	Bathroom Window's curtains Open
3011	2	1	18	0	Roomba turns On
3012	58	25	5	0	Living Room Window's curtains are Open
3013	2	1	18	0	Roomba is On
3014	58	25	5	0	Living Room Window's curtains are Open
3015	2	1	18	0	Roomba turns On
3016	58	14	5	0	Bedroom Window's curtains are Open
3017	9	3	3	0	Amazon Echo is playing Pop
3018	18	18	6	0	(Weather Sensor) The weather stops being Raining
3019	19	18	6	1	(Weather Sensor) The temperature is above 60 degrees
3020	19	2	8	2	(Thermostat) The temperature is below 80 degrees
3022	64	22	17	0	Smart Faucet's water Turns On
3024	64	22	17	0	Smart Faucet's water Turns Off
3025	64	22	17	0	Smart Faucet's water Turns On
3026	63	12	6	0	Anyone Exits Kitchen
3027	52	11	14	0	It becomes true that "Smart Faucet's water Turns On" last happened exactly 15s  ago
3028	51	11	14	1	"Smart Faucet's water is running" was last in effect exactly  ago
3029	52	11	14	0	It becomes true that "Smart Faucet's water Turns On" last happened exactly 15s  ago
3030	51	11	14	1	"Smart Faucet's water is running" was last in effect exactly 1s  ago
3031	13	13	5	0	Front Door Lock is Locked
3032	55	17	9	0	It is Nighttime
3033	65	23	13	0	Smart Oven's temperature becomes 100 degrees
3034	63	12	15	1	Someone other than Alice is in Kitchen
3035	58	25	5	0	Living Room Window's curtains Open
3036	2	1	18	0	Roomba is On
3037	63	12	6	0	Someone other than A Family Member is in Home
3039	64	22	17	0	Smart Faucet's water is not running
3040	52	11	14	0	It becomes true that "Smart Refrigerator's door Opens" last happened exactly 2m  ago
3041	51	11	14	1	"Smart Refrigerator's door is Open" was last in effect exactly 1s  ago
3042	58	24	5	0	Bathroom Window's curtains Open
3044	2	5	12	0	Smart TV is On
3045	61	21	16	0	(FitBit) I am Asleep
3046	9	3	3	0	Amazon Echo starts playing Pop
3047	51	11	14	0	It becomes true that "(FitBit) I am Asleep" was last in effect exactly 30m  ago
3052	14	24	5	0	Bathroom Window is Open
3053	14	14	5	0	Bedroom Window is Closed
3054	14	25	5	0	Living Room Window is Closed
3055	13	23	13	0	Smart Oven is Locked
3056	60	23	13	0	Smart Oven's door is Closed
3060	19	8	13	0	(Smart Refrigerator) The temperature is 40 degrees
3061	14	14	5	0	Bedroom Window is Open
3062	20	18	7	0	It is Raining
3063	19	18	8	0	(Weather Sensor) The temperature is 60 degrees
3064	19	18	8	0	(Weather Sensor) The temperature is 80 degrees
3065	2	5	12	0	Smart TV turns Off
3066	25	17	9	0	(Clock) The time is after 23:00
3067	2	4	2	0	HUE Lights turns Off
3068	55	17	9	1	It is Nighttime
3069	60	8	13	0	Smart Refrigerator's door is Open
3070	2	1	18	0	Roomba is On
3071	25	17	9	0	(Clock) The time is after 17:00
3072	2	1	18	0	Roomba turns On
3073	15	10	6	1	Security Camera detects motion
3074	63	12	6	2	Someone other than A Family Member is in Home
3075	63	12	6	3	Someone other than Alice is in Home
3076	63	12	6	4	Someone other than Bobbie is in Home
3077	60	8	13	0	Smart Refrigerator's door Opens
3078	52	11	14	1	"Smart Refrigerator's door Opens" last happened more than 2m  ago
3079	27	17	9	2	Clock's Alarm is not going off
3080	55	17	9	0	It is Nighttime
3081	2	5	1	0	Smart TV is Off
3082	25	17	9	0	(Clock) The time is 23:00
3084	25	17	9	0	(Clock) The time is 17:00
3085	64	22	17	0	Smart Faucet's water Turns On
3086	52	11	14	1	"Smart Faucet's water Turns On" last happened more than 15s  ago
3087	2	1	18	0	Roomba is Off
3088	25	17	9	0	(Clock) The time is 17:00
3091	63	12	6	0	Anyone Enters Home
3092	9	3	3	0	Amazon Echo starts playing Pop
3093	63	12	6	0	Anyone Exits Home
3094	63	12	6	1	Anyone is not in Home
3095	57	2	8	0	The AC is Off
3096	63	12	6	0	A Family Member is not in Home
3097	2	1	18	0	Roomba is Off
3098	25	17	9	0	(Clock) The time is 17:00
3099	64	22	17	0	Smart Faucet's water Turns Off
3100	64	22	17	0	Smart Faucet's water Turns On
3101	14	25	5	0	Living Room Window is Open
3102	13	23	13	0	Smart Oven is Locked
3103	63	12	6	0	Bobbie is in Kitchen
3104	63	12	15	0	Someone other than Alice Enters Home
3105	52	11	14	1	"Someone other than Anyone Enters Home" last happened more than 3h  ago
3106	58	24	5	0	Bathroom Window's curtains are Closed
3110	9	3	3	0	Amazon Echo stops playing Pop
3111	2	7	3	0	Speakers is On
3112	58	24	5	0	Bathroom Window's curtains Open
3113	55	17	9	0	It becomes Daytime
3114	13	14	4	1	Bedroom Window is Locked
3115	20	18	7	2	It is Not Raining
3116	63	12	15	0	Anyone Enters Bedroom
3117	58	24	5	0	Bathroom Window's curtains Close
3118	9	3	3	0	Amazon Echo starts playing Pop
3119	55	17	9	0	It becomes Daytime
3120	63	12	6	1	Anyone is not in Home
3121	20	18	7	2	It is Not Raining
3122	63	12	6	0	A Family Member is not in Bedroom
3123	13	13	4	0	Front Door Lock is Locked
3124	9	3	3	0	Amazon Echo starts playing Pop
3125	19	2	8	0	(Thermostat) The temperature goes above 80 degrees
3126	14	24	5	0	Bathroom Window Closes
3127	55	17	9	1	It is Nighttime
3128	2	1	18	0	Roomba turns On
3129	58	24	5	1	Bathroom Window's curtains are Open
3130	58	14	5	2	Bedroom Window's curtains are Open
3131	58	25	5	3	Living Room Window's curtains are Open
3132	64	22	17	0	Smart Faucet's water Turns On
3133	52	11	14	1	"Smart Faucet's water Turns On" last happened exactly 15s  ago
3134	2	5	12	0	Smart TV turns Off
3135	55	17	9	0	It becomes Nighttime
3136	63	12	15	0	Anyone Enters Home
3137	35	3	3	0	Pop music starts playing on Amazon Echo
3138	13	13	4	0	Front Door Lock is Unlocked
3139	2	4	2	0	HUE Lights is Off
3140	55	17	9	0	It is Nighttime
3141	2	1	18	0	Roomba is On
3142	63	12	6	0	A Guest is in Home
3143	55	17	9	0	It becomes Daytime
3144	63	12	6	1	Anyone is in Home
3145	13	14	5	2	Bedroom Window is Unlocked
3146	14	14	5	3	Bedroom Window is Closed
3147	2	5	12	0	Smart TV turns Off
3148	61	21	6	0	(FitBit) I Fall Asleep
3149	13	13	5	0	Front Door Lock is Locked
3150	61	21	16	0	(FitBit) I am Asleep
3151	2	5	12	0	Smart TV is On
3152	61	21	6	0	(FitBit) I am Asleep
3153	57	2	8	0	The AC is Off
3154	19	2	8	0	(Thermostat) The temperature is above 79 degrees
3155	55	17	9	0	It becomes Daytime
3156	63	12	6	1	Anyone is not in Home
3157	13	14	5	2	Bedroom Window is Locked
3158	14	24	5	0	Bathroom Window Closes
3159	14	25	5	1	Living Room Window is Closed
3160	14	14	5	2	Bedroom Window is Closed
3161	66	8	13	0	Smart Refrigerator's temperature becomes set to something other than 40 degrees
3162	13	14	5	0	Bedroom Window Unlocks
3163	63	12	6	1	Anyone is not in Home
3164	13	13	5	0	Front Door Lock is Locked
3165	61	21	16	0	(FitBit) I am Asleep
3166	19	2	8	0	(Thermostat) The temperature becomes 80 degrees
3167	2	5	12	0	Smart TV turns Off
3168	61	21	6	0	(FitBit) I Fall Asleep
3169	14	14	5	0	Bedroom Window Closes
3170	14	24	5	1	Bathroom Window is Closed
3171	14	25	5	2	Living Room Window is Closed
3172	63	12	6	0	Anyone Enters Home
3173	55	17	9	1	It is Daytime
3174	13	14	5	2	Bedroom Window is Unlocked
3175	14	25	5	0	Living Room Window Closes
3176	14	24	5	1	Bathroom Window is Closed
3177	14	14	5	2	Bedroom Window is Closed
3178	35	3	3	0	POP Music starts playing on Amazon Echo
3179	19	2	8	0	(Thermostat) The temperature goes above 75 degrees
3180	63	12	6	1	Someone other than Nobody is in Home
3181	19	2	8	0	(Thermostat) The temperature goes above 75 degrees
3182	63	12	6	1	Someone other than Nobody is in Home
3183	19	2	8	0	(Thermostat) The temperature goes above 75 degrees
3184	63	12	6	1	Someone other than Nobody is in Home
3185	2	1	18	0	Roomba turns On
3186	58	25	5	1	Living Room Window's curtains are Open
3187	64	22	17	0	Smart Faucet's water Turns On
3188	52	11	14	1	"Smart Faucet's water Turns On" last happened exactly 15m  ago
3189	19	18	8	0	(Weather Sensor) The temperature goes above 60 degrees
3190	19	2	8	0	(Thermostat) The temperature goes above 80 degrees
3193	15	10	6	0	Security Camera Starts Detecting Motion
3194	61	21	6	1	(FitBit) I am Asleep
3195	15	10	6	0	Security Camera Starts Detecting Motion
3196	61	21	6	1	(FitBit) I am Asleep
3197	19	18	8	0	(Weather Sensor) The temperature goes above 80 degrees
3198	57	2	8	0	The AC turns Off
3199	19	18	8	0	(Weather Sensor) The temperature is 80 degrees
3200	2	5	12	0	Smart TV turns On
3201	61	21	6	1	(FitBit) I am Awake
3202	62	21	16	2	(FitBit) My heart rate is below 75BPM
3203	2	1	18	0	Roomba turns On
3204	63	12	15	0	Anyone Enters Home
3205	2	1	18	0	Roomba is On
3206	63	12	6	0	A Guest is in Home
3207	9	3	3	0	Amazon Echo starts playing Pop
3208	57	2	8	0	The AC turns Off
3209	19	18	8	0	(Weather Sensor) The temperature is 80 degrees
3210	60	8	13	0	Smart Refrigerator's door Opens
3211	9	3	3	0	Amazon Echo starts playing Pop
3212	2	1	18	0	Roomba turns On
3214	58	24	5	0	Bathroom Window's curtains Open
3215	9	3	3	0	Amazon Echo is not playing Pop
3216	63	12	15	0	Anyone Enters Home
3217	52	11	14	0	It becomes true that "Smart Faucet's water Turns On" last happened more than 15s  ago
3218	64	22	17	1	Smart Faucet's water is running
3219	64	22	17	0	Smart Faucet's water Turns On
3220	50	11	14	1	"Smart Faucet's water Turns On" has occurred exactly 1 times in the last 15s 
3222	19	18	8	0	(Weather Sensor) The temperature goes above 80 degrees
3223	14	14	5	1	Bedroom Window is Open
3224	19	18	8	2	(Weather Sensor) The temperature is below 60 degrees
3225	63	12	6	0	Bobbie Enters Kitchen
3226	9	3	3	0	Amazon Echo starts playing Pop
3227	58	25	5	0	Living Room Window's curtains are Open
3228	2	1	18	0	Roomba is On
3229	63	12	15	0	Anyone Exits Home
3230	21	2	8	1	Thermostat is set above 75 degrees
3231	2	5	12	0	Smart TV turns Off
3232	61	21	16	0	(FitBit) I Fall Asleep
3233	63	12	15	0	Anyone Exits Home
3235	14	14	5	0	Bedroom Window is Open
3236	14	25	5	0	Living Room Window is Closed
3237	14	24	5	0	Bathroom Window is Closed
3238	15	10	6	0	Security Camera Starts Detecting Motion
3239	2	23	13	1	Smart Oven is On
3240	64	22	17	0	Smart Faucet's water is running
3241	52	11	14	0	"Smart Faucet's water is running" last happened exactly 15s  ago
3243	61	21	16	0	(FitBit) I Fall Asleep
3244	58	25	5	0	Living Room Window's curtains Open
3245	2	1	18	1	Roomba is On
3246	60	23	13	0	Smart Oven's door Closes
3247	58	24	5	0	Bathroom Window's curtains Open
3248	19	8	13	0	(Smart Refrigerator) The temperature falls below 40 degrees
3249	14	25	5	0	Living Room Window is Open
3250	14	14	5	0	Bedroom Window is Closed
3251	14	24	5	0	Bathroom Window is Closed
3252	58	24	5	0	Bathroom Window's curtains Open
3253	63	12	15	0	Bobbie Enters Kitchen
3254	63	12	15	1	Nobody is in Kitchen
3255	60	23	13	2	Smart Oven's door is Closed
3256	63	12	6	0	Anyone is in Home
3257	21	2	8	0	Thermostat is set to 73 degrees
3258	63	12	6	0	A Guest Enters Home
3259	52	11	14	1	It becomes true that "A Guest Enters Home" last happened more than 3h  ago
3260	19	2	8	0	(Thermostat) The temperature goes above 80 degrees
3261	14	24	5	0	Bathroom Window is Open
3262	14	14	5	0	Bedroom Window is Closed
3263	14	25	5	0	Living Room Window is Closed
3264	63	12	15	0	Bobbie Enters Kitchen
3265	63	12	15	1	Nobody is in Kitchen
3266	60	23	13	2	Smart Oven's door is Open
3267	13	13	5	0	Front Door Lock is Locked
3268	61	21	6	0	(FitBit) I am Asleep
3269	13	13	5	0	Front Door Lock Unlocks
3270	61	21	6	0	(FitBit) I am Asleep
3272	13	13	5	0	Front Door Lock Unlocks
3273	55	17	9	0	It becomes Nighttime
3274	13	13	5	1	Front Door Lock is Locked
3275	15	10	6	2	Security Camera detects motion
3276	2	4	2	0	HUE Lights turns On
3277	60	23	13	1	Smart Oven's door is Open
3279	63	12	6	0	A Family Member Enters Bedroom
3280	14	14	5	0	Bedroom Window Closes
3281	14	25	5	1	Living Room Window is Closed
3282	9	3	3	0	Amazon Echo starts playing Pop
3283	35	3	3	1	pop is playing on Amazon Echo
3284	63	12	15	0	Anyone Enters Home
3285	2	5	12	0	Smart TV is On
3286	61	21	6	0	(FitBit) I am Asleep
3287	60	8	13	0	Smart Refrigerator's door is Open
3288	13	13	5	0	Front Door Lock Locks
3289	63	12	15	0	Someone other than Nobody is in Bedroom
3290	60	8	13	0	Smart Refrigerator's door is Open
3291	27	17	9	0	Clock's Alarm is going off
3292	19	8	13	0	(Smart Refrigerator) The temperature is below 40 degrees
3293	19	8	13	0	(Smart Refrigerator) The temperature is above 45 degrees
3295	63	12	6	0	Anyone is in Kitchen
3296	51	11	14	0	It becomes true that "Smart Faucet's water is running" was last in effect more than 15s  ago
3297	9	3	3	0	Amazon Echo is not playing Pop
3298	20	18	7	0	It starts raining
3299	2	5	12	0	Smart TV turns Off
3300	61	21	16	0	(FitBit) I am Asleep
3301	52	11	14	0	It becomes true that "Smart Faucet's water Turns On" last happened exactly 15s  ago
3302	52	11	14	0	It becomes true that "Smart Oven's door Closes" last happened exactly 1s  ago
3303	63	12	15	1	Bobbie is in Kitchen
3304	66	8	13	0	Smart Refrigerator's temperature is set above 40 degrees
3305	2	1	18	0	Roomba turns Off
3306	55	17	9	0	It is Daytime
3307	2	5	1	0	Smart TV turns Off
3308	61	21	16	0	(FitBit) I Fall Asleep
3309	2	1	18	0	Roomba turns On
3310	2	1	18	1	Roomba is On
3311	14	14	5	0	Bedroom Window Opens
3312	20	18	7	1	It is Raining
3313	19	2	8	0	(Thermostat) The temperature goes above 80 degrees
3315	64	22	17	0	Smart Faucet's water Turns On
3316	61	21	16	0	(FitBit) I Fall Asleep
3317	25	17	9	1	(Clock) The time is after 01:00
3318	57	2	8	0	The AC turns On
3319	19	2	8	0	(Thermostat) The temperature is above 79 degrees
3320	14	14	5	0	Bedroom Window Opens
3321	19	18	8	1	(Weather Sensor) The temperature is below 60 degrees
3322	60	8	13	0	Smart Refrigerator's door is Open
3323	14	14	5	0	Bedroom Window Closes
3324	14	24	5	1	Bathroom Window is Closed
3325	9	3	3	0	Amazon Echo is not playing Pop
3326	57	2	8	0	The AC turns Off
3327	19	2	8	0	(Thermostat) The temperature is below 70 degrees
3328	14	25	5	0	Living Room Window Closes
3329	14	24	5	1	Bathroom Window is Closed
3330	20	18	7	0	It starts raining
3331	14	14	5	1	Bedroom Window is Open
3332	14	25	5	0	Living Room Window Opens
3333	63	12	6	0	Anyone is in Home
3334	19	8	13	0	(Smart Refrigerator) The temperature falls below 40 degrees
3335	19	18	8	0	(Weather Sensor) The temperature goes above 60 degrees
3336	58	24	5	0	Bathroom Window's curtains Open
3337	63	12	6	1	Anyone is not in Bathroom
3338	19	18	6	0	(Weather Sensor) The temperature goes above 80 degrees
3339	14	14	5	1	Bedroom Window is Open
3340	52	11	14	0	It becomes true that "Front Door Lock Locks" last happened exactly 9h  ago
3341	2	1	18	0	Roomba is On
3342	63	12	15	0	A Guest is in Home
3343	52	11	14	0	"A Guest is in Home" last happened less than 3h  ago
3344	14	14	5	0	Bedroom Window Closes
3345	14	25	5	1	Living Room Window is Closed
3346	62	21	16	0	(FitBit) My heart rate becomes 110BPM
3347	19	18	6	0	(Weather Sensor) The temperature falls below 60 degrees
3348	14	14	5	1	Bedroom Window is Open
3349	25	17	9	0	(Clock) The time is 02:00
3350	2	5	12	0	Smart TV is On
3351	19	18	8	0	(Weather Sensor) The temperature goes above 80 degrees
3352	64	22	17	0	Smart Faucet's water Turns Off
3353	64	22	17	0	Smart Faucet's water Turns On
3354	57	2	8	0	The AC turns On
3355	63	12	15	1	Anyone is in Home
3356	21	2	8	0	Thermostat's temperature becomes set to 72 degrees
3357	2	1	18	0	Roomba is On
3358	2	23	13	0	Smart Oven is On
3359	63	12	6	1	Someone other than A Family Member is not in Home
3360	21	2	8	0	Thermostat's temperature becomes set to 75 degrees
3361	63	12	6	0	Nobody is in Home
3362	9	3	3	0	Amazon Echo starts playing Pop
3363	14	14	5	0	Bedroom Window Opens
3364	20	18	7	1	It is Raining
3365	13	14	4	0	Bedroom Window Unlocks
3366	14	14	5	0	Bedroom Window Opens
3367	19	18	8	1	(Weather Sensor) The temperature is above 80 degrees
3368	21	2	8	0	Thermostat's temperature becomes set to 72 degrees
3369	63	12	6	0	Anyone is in Home
3370	14	14	5	0	Bedroom Window is Open
3371	19	18	8	0	(Weather Sensor) The temperature is above 60 degrees
3372	19	18	8	0	(Weather Sensor) The temperature is below 80 degrees
3373	20	18	7	0	It is Not Raining
3374	58	24	5	0	Bathroom Window's curtains Close
3375	63	12	15	1	Anyone is in Home
3376	14	14	5	0	Bedroom Window Opens
3377	19	18	8	1	(Weather Sensor) The temperature is below 60 degrees
3378	13	14	4	0	Bedroom Window is Locked
3379	61	21	16	0	(FitBit) I am Asleep
3380	2	1	1	0	Roomba turns On
3381	51	11	14	0	It becomes true that "Anyone is in Home" was last in effect exactly 1s  ago
3382	2	1	18	1	Roomba is On
3383	63	12	6	2	A Guest is in Home
3384	64	22	17	0	Smart Faucet's water Turns Off
3385	64	22	17	0	Smart Faucet's water Turns On
3386	58	24	5	0	Bathroom Window's curtains Open
3387	57	2	8	0	The AC is On
3388	63	12	15	0	Anyone is not in Home
3389	61	21	16	0	(FitBit) I Fall Asleep
3390	2	5	12	1	Smart TV is On
3391	52	11	14	2	"(FitBit) I Fall Asleep" last happened exactly 30m  ago
3392	60	8	13	0	Smart Refrigerator's door is Open
3393	58	24	5	0	Bathroom Window's curtains are Closed
3394	2	1	18	0	Roomba is On
3395	58	25	5	0	Living Room Window's curtains are Open
3396	9	3	3	0	Amazon Echo starts playing Pop
3397	64	22	17	0	Smart Faucet's water is running
3398	14	14	5	0	Bedroom Window is Open
3399	19	2	8	0	(Thermostat) The temperature is below 80 degrees
3400	19	2	8	0	(Thermostat) The temperature is above 60 degrees
3401	52	11	14	0	It becomes true that "Smart Refrigerator's door Opens" last happened more than 2m  ago
3402	60	8	13	1	Smart Refrigerator's door is Open
3403	58	24	5	0	Bathroom Window's curtains are Open
3404	52	11	14	0	It becomes true that "Smart Refrigerator's door Opens" last happened more than 2m  ago
3405	60	8	13	1	Smart Refrigerator's door is Open
3406	2	23	13	0	Smart Oven is On
3407	13	23	13	0	Smart Oven is Locked
3408	52	11	14	0	It becomes true that "Smart Refrigerator's door Opens" last happened more than 2m  ago
3409	60	8	13	1	Smart Refrigerator's door is Open
3410	15	10	6	0	Security Camera detects motion
3411	2	1	18	0	Roomba is On
3611	2	4	2	2	HUE Lights is Off
3412	63	12	15	0	Someone other than A Guest is not in Living Room
3413	2	5	12	0	Smart TV turns Off
3414	61	21	6	0	(FitBit) I Fall Asleep
3415	13	13	4	0	Front Door Lock is Unlocked
3416	63	12	15	0	Alice is in Home
3417	55	17	9	0	It is Nighttime
3418	9	3	3	0	Amazon Echo starts playing Pop
3419	66	8	13	0	Smart Refrigerator's temperature becomes set to 40 degrees
3420	58	24	5	0	Bathroom Window's curtains Open
3421	14	14	5	0	Bedroom Window is Open
3422	19	18	8	0	(Weather Sensor) The temperature is 61 degrees
3423	19	18	8	0	(Weather Sensor) The temperature is 79 degrees
3424	20	18	7	0	It is Not Raining
3425	58	25	5	0	Living Room Window's curtains Open
3426	2	1	18	1	Roomba is On
3427	50	11	14	0	It becomes true that "Roomba turns On" has occurred 1 times in the last 72h 
3428	63	12	6	0	Someone other than Alice Enters Home
3429	2	1	18	1	Roomba is On
3430	58	14	5	0	Bedroom Window's curtains Open
3431	2	1	18	1	Roomba is On
3432	58	24	5	0	Bathroom Window's curtains Open
3433	2	1	18	1	Roomba is On
3434	58	25	5	0	Living Room Window's curtains are Closed
3435	2	1	18	0	Roomba is On
3436	2	1	18	0	Roomba is On
3437	63	12	6	0	A Guest is in Home
3438	52	11	14	0	"Roomba is On" last happened more than 3h 1s  ago
3439	2	1	18	0	Roomba turns Off
3440	58	25	5	1	Living Room Window's curtains are Closed
3441	63	12	6	0	Anyone is in Home
3442	19	2	8	0	(Thermostat) The temperature is 72 degrees
3443	2	1	18	0	Roomba is Off
3444	55	17	9	0	It is Nighttime
3445	19	2	8	0	(Thermostat) The temperature becomes 80 degrees
3446	21	2	8	1	Thermostat is set below 80 degrees
3447	57	2	8	2	The AC is Off
3448	2	1	18	0	Roomba turns Off
3449	58	14	5	1	Bedroom Window's curtains are Closed
3450	21	2	8	0	Thermostat's temperature becomes set above 80 degrees
3451	14	14	5	0	Bedroom Window is Open
3452	19	18	8	0	(Weather Sensor) The temperature is above 60 degrees
3453	19	18	8	0	(Weather Sensor) The temperature is not 80 degrees
3454	2	1	18	0	Roomba turns Off
3455	63	12	15	0	Someone other than A Family Member is in Living Room
3456	2	1	18	0	Roomba turns Off
3457	58	24	5	1	Bathroom Window's curtains are Closed
3458	2	5	12	0	Smart TV is On
3459	61	21	16	0	(FitBit) I am Asleep
3460	61	21	16	0	(FitBit) I am Asleep
3461	13	13	4	0	Front Door Lock is Unlocked
3462	19	2	8	0	(Thermostat) The temperature becomes 80 degrees
3463	19	2	8	0	(Thermostat) The temperature becomes 80 degrees
3464	21	2	8	1	Thermostat is set below 81 degrees
3465	57	2	8	2	The AC is Off
3466	14	14	5	0	Bedroom Window is Open
3467	20	18	7	0	It is Raining
3468	13	13	4	0	Front Door Lock is Locked
3469	55	17	9	0	It is Nighttime
3470	63	12	15	0	Anyone is in Home
3471	2	1	18	0	Roomba turns On
3472	58	25	5	0	Living Room Window's curtains are Open
3473	19	2	8	0	(Thermostat) The temperature goes above 80 degrees
3474	21	2	8	1	Thermostat is set above 80 degrees
3475	57	2	8	2	The AC is Off
3476	2	1	18	0	Roomba turns On
3477	58	14	5	0	Bedroom Window's curtains are Open
3478	14	14	5	0	Bedroom Window Closes
3479	19	2	8	0	(Thermostat) The temperature is above 80 degrees
3480	9	3	3	0	Amazon Echo starts playing Pop
3481	2	1	18	0	Roomba turns On
3482	58	24	5	0	Bathroom Window's curtains are Open
3483	14	14	5	0	Bedroom Window Closes
3484	19	2	8	0	(Thermostat) The temperature is below 60 degrees
3485	9	3	3	0	Amazon Echo stops playing Pop
3486	9	3	3	0	Amazon Echo is playing Pop
3487	25	17	9	0	(Clock) The time is after 23:00
3488	13	13	5	0	Front Door Lock is Locked
3489	2	5	12	0	Smart TV turns Off
3490	61	21	16	0	(FitBit) I Fall Asleep
3491	14	24	5	0	Bathroom Window Closes
3492	14	14	5	1	Bedroom Window is Closed
3493	14	25	5	2	Living Room Window is Closed
3494	19	8	13	0	(Smart Refrigerator) The temperature falls below 41 degrees
3495	2	5	12	0	Smart TV turns Off
3496	61	21	16	0	(FitBit) I Fall Asleep
3497	14	14	5	0	Bedroom Window Closes
3498	14	25	5	1	Living Room Window is Closed
3499	14	24	5	2	Bathroom Window is Closed
3500	64	22	17	0	Smart Faucet's water is running
3501	64	22	17	0	Smart Faucet's water Turns Off
3502	64	22	17	0	Smart Faucet's water Turns On
3503	14	14	5	0	Bedroom Window Closes
3504	14	25	5	1	Living Room Window is Closed
3505	14	24	5	2	Bathroom Window is Closed
3506	64	22	17	0	Smart Faucet's water Turns Off
3507	64	22	17	0	Smart Faucet's water Turns On
3508	52	11	14	0	It becomes true that "(FitBit) I Fall Asleep" last happened more than 30m  ago
3509	2	5	12	1	Smart TV is On
3510	14	25	5	0	Living Room Window Closes
3511	14	24	5	1	Bathroom Window is Closed
3512	14	14	5	2	Bedroom Window is Closed
3513	14	14	5	0	Bedroom Window is Open
3514	19	18	8	0	(Weather Sensor) The temperature is above 79 degrees
3515	19	18	8	0	(Weather Sensor) The temperature is below 60 degrees
3516	20	18	7	0	It is Not Raining
3517	21	2	8	0	Thermostat is set above 80 degrees
3518	58	24	5	0	Bathroom Window's curtains are Open
3519	52	11	14	0	It becomes true that "(FitBit) I Fall Asleep" last happened more than 30m  ago
3520	2	5	12	1	Smart TV is On
3521	61	21	6	2	(FitBit) I am Asleep
3522	2	1	18	0	Roomba is On
3523	58	14	5	0	Bedroom Window's curtains are Open
3524	60	8	13	0	Smart Refrigerator's door Closes
3525	60	8	13	0	Smart Refrigerator's door Opens
3526	2	1	18	0	Roomba is On
3527	58	24	5	0	Bathroom Window's curtains are Open
3528	2	1	18	0	Roomba is On
3529	58	25	5	0	Living Room Window's curtains are Open
3530	2	1	18	0	Roomba turns On
3531	63	12	15	1	Someone other than Alice is in Home
3532	63	12	15	2	Someone other than Bobbie is in Home
3533	51	11	14	0	It becomes true that "Smart Refrigerator's door is Open" was last in effect exactly 2m  ago
3534	63	12	6	1	Anyone is not in Kitchen
3535	14	14	5	0	Bedroom Window is Open
3536	19	18	8	0	(Weather Sensor) The temperature is below 80 degrees
3537	19	18	8	0	(Weather Sensor) The temperature is above 60 degrees
3538	20	18	7	0	It is Not Raining
3539	55	17	9	0	It becomes Nighttime
3540	51	11	14	0	It becomes true that "Roomba is On" was last in effect exactly 1h  ago
3541	63	12	6	0	Anyone is in Home
3542	21	2	8	0	Thermostat is set above 70 degrees
3543	21	2	8	0	Thermostat is set below 75 degrees
3544	13	23	13	0	Smart Oven Locks
3545	2	23	13	0	Smart Oven is On
3547	25	17	9	1	(Clock) The time is 16:00
3548	51	11	14	0	It becomes true that "Roomba is Off" was last in effect exactly 48h  ago
3549	58	24	5	0	Bathroom Window's curtains Open
3550	58	14	5	0	Bedroom Window's curtains Open
3551	58	25	5	0	Living Room Window's curtains Open
3552	58	25	5	0	Living Room Window's curtains Open
3553	2	1	18	1	Roomba is On
3554	58	25	5	0	Living Room Window's curtains Open
3555	2	1	18	1	Roomba is On
3556	19	2	8	0	(Thermostat) The temperature becomes 76 degrees
3557	19	8	13	0	(Smart Refrigerator) The temperature is above 40 degrees
3558	13	23	13	0	Smart Oven is Unlocked
3559	63	12	15	0	Bobbie is in Kitchen
3560	19	2	8	0	(Thermostat) The temperature goes above 75 degrees
3561	19	2	8	0	(Thermostat) The temperature goes above 75 degrees
3562	19	2	8	0	(Thermostat) The temperature goes above 80 degrees
3563	19	2	8	0	(Thermostat) The temperature becomes 80 degrees
3564	9	3	3	0	Amazon Echo starts playing Pop
3565	60	8	13	0	Smart Refrigerator's door is Open
3566	51	11	14	0	It becomes true that "(Weather Sensor) The temperature is not 75 degrees" was last in effect exactly 3s  ago
3567	14	14	5	1	Bedroom Window is Open
3568	21	2	8	2	Thermostat is set to 70 degrees
3569	20	18	7	3	It is Raining
3570	51	11	14	0	It becomes true that "Smart Faucet's water is running" was last in effect exactly 15s  ago
3572	64	22	17	0	Smart Faucet's water is running
3573	63	12	6	0	Alice Exits Home
3574	63	12	6	1	Nobody is in Home
3575	64	22	17	0	Smart Faucet's water is running
3576	63	12	6	0	Bobbie Exits Home
3577	63	12	6	1	Nobody is in Home
3579	64	22	17	0	Smart Faucet's water is running
3580	13	23	13	0	Smart Oven Locks
3581	63	12	6	0	Bobbie is in Kitchen
3582	21	2	8	0	Thermostat's temperature becomes set above 70 degrees
3583	63	12	15	0	Anyone is in Home
3584	21	2	8	0	Thermostat's temperature becomes set below 75 degrees
3585	63	12	15	0	Anyone is in Home
3586	14	14	5	0	Bedroom Window Closes
3587	14	24	5	0	Bathroom Window Closes
3588	58	24	5	0	Bathroom Window's curtains are Closed
3589	14	25	5	0	Living Room Window Closes
3590	14	14	5	1	Bedroom Window is Closed
3591	14	24	5	2	Bathroom Window is Closed
3592	25	17	9	0	(Clock) The time becomes 08:00
3593	14	14	5	0	Bedroom Window Closes
3594	14	24	5	1	Bathroom Window is Closed
3595	14	25	5	2	Living Room Window is Closed
3596	14	24	5	0	Bathroom Window Closes
3597	14	14	5	1	Bedroom Window is Closed
3598	14	25	5	2	Living Room Window is Closed
3599	2	9	1	0	Coffee Pot turns On
3600	2	1	18	0	Roomba turns Off
3601	63	12	15	0	A Family Member is in Home
3602	55	17	9	0	It becomes Nighttime
3603	21	2	8	0	Thermostat is set above 80 degrees
3604	14	24	5	0	Bathroom Window is Closed
3605	14	14	5	0	Bedroom Window is Closed
3606	14	25	5	0	Living Room Window is Closed
3607	35	3	3	0	Pop music starts playing on Amazon Echo
3608	25	17	9	0	(Clock) The time becomes 08:00
3609	55	17	9	0	It becomes Nighttime
3610	63	12	6	1	Anyone is in Bedroom
3612	15	10	6	3	Security Camera does not detect motion
3613	52	11	14	4	"Security Camera Stops Detecting Motion" last happened more than 30m  ago
3614	2	5	12	0	Smart TV is On
3615	61	21	16	0	(FitBit) I am Asleep
3616	19	8	13	0	(Smart Refrigerator) The temperature falls below 41 degrees
3617	64	22	17	0	Smart Faucet's water is running
3618	19	8	13	0	(Smart Refrigerator) The temperature becomes 46 degrees
3619	64	22	17	0	Smart Faucet's water Turns On
3620	19	8	13	0	(Smart Refrigerator) The temperature goes above 45 degrees
3621	64	22	17	0	Smart Faucet's water Turns On
3622	13	13	5	0	Front Door Lock Unlocks
3623	61	21	6	0	(FitBit) I am Asleep
3624	64	22	17	0	Smart Faucet's water Turns On
3625	9	3	3	0	Amazon Echo starts playing Pop
3626	14	25	5	0	Living Room Window is Open
3627	9	3	3	0	Amazon Echo is playing Pop
3628	52	11	14	0	It becomes true that "Someone other than A Family Member Enters Home" last happened exactly 3h  ago
3629	52	11	14	0	It becomes true that "Someone other than A Family Member Enters Home" last happened exactly 3h  ago
3633	19	2	8	0	(Thermostat) The temperature becomes 73 degrees
3634	63	12	6	0	Anyone is in Home
3635	19	2	8	0	(Thermostat) The temperature falls below 70 degrees
3636	63	12	6	1	Anyone is in Home
3637	19	8	13	0	(Smart Refrigerator) The temperature becomes 39 degrees
3638	19	2	8	0	(Thermostat) The temperature goes above 75 degrees
3639	63	12	6	1	Anyone is in Home
3641	14	14	5	0	Bedroom Window is Closed
3642	14	24	5	1	Bathroom Window is Closed
3643	61	21	16	0	(FitBit) I Fall Asleep
3644	2	5	12	1	Smart TV is On
3645	19	18	8	0	(Weather Sensor) The temperature becomes 80 degrees
3646	19	2	8	0	(Thermostat) The temperature is below 70 degrees
3647	63	12	6	0	Nobody is in Home
3648	57	2	8	0	The AC turns On
3649	19	2	8	0	(Thermostat) The temperature is above 80 degrees
3650	9	3	3	0	Amazon Echo starts playing Pop
3651	19	18	8	0	(Weather Sensor) The temperature falls below 60 degrees
3652	19	18	8	0	(Weather Sensor) The temperature goes above 80 degrees
3653	20	18	7	0	It starts raining
3654	19	2	8	0	(Thermostat) The temperature becomes 81 degrees
3655	66	8	13	0	Smart Refrigerator's temperature is set to 40 degrees
3656	20	18	7	0	It stops raining
3657	19	2	8	0	(Thermostat) The temperature becomes 81 degrees
3658	19	2	8	0	(Thermostat) The temperature becomes 80 degrees
3659	58	24	5	0	Bathroom Window's curtains Open
3660	2	1	1	1	Roomba is On
3661	19	2	8	0	(Thermostat) The temperature becomes 80 degrees
3662	63	12	6	0	Bobbie Enters Kitchen
3663	2	23	13	1	Smart Oven is On
3664	60	23	13	0	Smart Oven's door is Closed
3665	63	12	6	0	Bobbie is in Kitchen
3666	58	14	5	0	Bedroom Window's curtains Open
3667	2	1	1	1	Roomba is On
3668	19	8	13	0	(Smart Refrigerator) The temperature falls below 40 degrees
3669	13	23	13	0	Smart Oven is Locked
3670	63	12	6	0	Bobbie is in Kitchen
3671	58	25	5	0	Living Room Window's curtains Open
3672	2	1	1	1	Roomba is On
3673	9	3	3	0	Amazon Echo starts playing Pop
3674	9	3	3	0	Amazon Echo starts playing Pop
3675	61	21	6	0	(FitBit) I Fall Asleep
3676	2	5	1	1	Smart TV is On
3677	52	11	14	2	"(FitBit) I Fall Asleep" last happened exactly 31m  ago
3678	60	8	13	0	Smart Refrigerator's door Closes
3679	60	8	13	0	Smart Refrigerator's door Opens
3680	18	18	6	0	(Weather Sensor) The weather becomes Clear
3681	20	18	7	1	It is Not Raining
3682	19	18	8	0	(Weather Sensor) The temperature falls below 60 degrees
3683	58	25	5	0	Living Room Window's curtains Close
3684	55	17	9	1	It is Daytime
3685	19	2	8	0	(Thermostat) The temperature becomes 80 degrees
3686	19	18	8	0	(Weather Sensor) The temperature goes above 80 degrees
3687	2	1	1	0	Roomba turns On
3688	58	24	5	1	Bathroom Window's curtains are Open
3689	2	1	1	0	Roomba turns On
3690	58	14	5	1	Bedroom Window's curtains are Open
3691	2	1	18	0	Roomba is Off
3692	63	12	6	0	A Guest is in Home
3693	2	1	1	0	Roomba turns On
3694	58	25	5	1	Living Room Window's curtains are Open
3695	58	25	5	0	Living Room Window's curtains Open
3696	58	14	5	1	Bedroom Window's curtains are Open
3697	58	24	5	2	Bathroom Window's curtains are Open
3698	18	18	6	0	(Weather Sensor) The weather becomes Raining
3699	19	18	8	0	(Weather Sensor) The temperature goes above 80 degrees
3700	13	13	5	0	Front Door Lock is Unlocked
3701	61	21	16	0	(FitBit) I am Asleep
3702	64	22	13	0	Smart Faucet's water is running
3703	63	12	15	0	Bobbie Enters Kitchen
3704	2	23	13	1	Smart Oven is On
3706	2	1	1	0	Roomba turns On
3707	63	12	6	1	A Guest is in Home
3708	52	11	14	2	"A Guest Enters Home" last happened less than 3h  ago
3709	60	8	13	0	Smart Refrigerator's door Closes
3710	60	8	13	0	Smart Refrigerator's door Opens
3711	14	24	5	0	Bathroom Window Closes
3712	14	14	5	1	Bedroom Window is Closed
3713	14	14	5	0	Bedroom Window Closes
3714	14	25	5	1	Living Room Window is Closed
3715	19	8	13	0	(Smart Refrigerator) The temperature falls below 40 degrees
3716	14	25	5	0	Living Room Window Closes
3717	14	24	5	1	Bathroom Window is Closed
3718	63	12	6	0	Bobbie Enters Kitchen
3719	2	23	13	1	Smart Oven is On
3720	13	23	13	2	Smart Oven is Unlocked
3721	61	21	6	0	(FitBit) I Fall Asleep
3722	13	13	5	1	Front Door Lock is Unlocked
3723	52	11	14	0	It becomes true that "Smart Faucet's water Turns On" last happened exactly 15s  ago
3724	13	13	5	0	Front Door Lock Unlocks
3725	60	8	13	0	Smart Refrigerator's door Opens
3726	2	5	12	0	Smart TV is On
3727	61	21	16	0	(FitBit) I am Asleep
3728	52	11	14	0	It becomes true that "Smart Refrigerator's door Opens" last happened more than 2m  ago
3729	60	8	13	1	Smart Refrigerator's door is Open
3730	51	11	14	2	"Smart Refrigerator's door is Open" was last in effect more than 2m  ago
3731	52	11	14	0	It becomes true that "Smart Faucet's water Turns On" last happened exactly 15s  ago
3732	63	12	6	0	Someone other than Bobbie Enters Home
3733	2	1	18	1	Roomba is On
3734	51	11	14	0	It becomes true that "Smart Refrigerator's door is Closed" was last in effect exactly 2m  ago
3735	61	21	16	0	(FitBit) I Fall Asleep
3736	2	5	12	1	Smart TV is On
3737	51	11	14	0	It becomes true that "Smart Refrigerator's door is Open" was last in effect more than 2m  ago
3738	60	8	13	1	Smart Refrigerator's door is Open
3739	51	11	14	2	"Smart Refrigerator's door is Closed" was last in effect more than 2m  ago
3740	2	1	18	0	Roomba turns On
3741	2	1	18	0	Roomba turns On
3742	2	1	18	0	Roomba turns On
3743	55	17	9	0	It becomes Nighttime
3744	63	12	6	0	Someone other than A Family Member Enters Home
3745	13	13	4	1	Front Door Lock is Locked
3746	52	11	14	0	It becomes true that "Security Camera Stops Detecting Motion" last happened exactly 30m  ago
3747	49	11	14	0	It becomes true that "Bathroom Window is Closed" was active  ago
3748	14	14	5	1	Bedroom Window is Closed
3749	14	25	5	2	Living Room Window is Closed
3750	3	4	2	0	HUE Lights's brightness goes above 4
3751	19	18	8	0	(Weather Sensor) The temperature becomes 22 degrees
3752	58	25	5	0	Living Room Window's curtains Open
3753	14	14	5	0	Bedroom Window is Open
3754	19	18	8	0	(Weather Sensor) The temperature is above 80 degrees
3755	19	18	8	0	(Weather Sensor) The temperature is below 60 degrees
3756	20	18	7	0	It is Raining
3757	14	14	5	0	Bedroom Window is Open
3758	19	18	8	0	(Weather Sensor) The temperature is above 80 degrees
3759	19	18	8	0	(Weather Sensor) The temperature is below 60 degrees
3760	20	18	7	0	It is Raining
3761	58	25	5	0	Living Room Window's curtains are Open
3762	2	1	18	0	Roomba is On
3764	2	1	18	0	Roomba turns On
3765	19	8	13	0	(Smart Refrigerator) The temperature is below 40 degrees
3766	49	11	14	0	It becomes true that "Smart Faucet's water is running" was active 15s  ago
3767	64	22	17	0	Smart Faucet's water Turns On
3768	49	11	14	0	It becomes true that "Smart Faucet's water is running" was active 15s  ago
3769	64	22	13	0	Smart Faucet's water Turns Off
3770	2	10	1	0	Security Camera turns On
3771	64	22	13	1	Smart Faucet's water is not running
3772	63	12	15	0	Someone other than A Family Member Enters Kitchen
3773	9	3	3	0	Amazon Echo starts playing Pop
3774	9	3	3	0	Amazon Echo starts playing Pop
3775	63	12	6	0	Bobbie is in Kitchen
3776	60	23	13	0	Smart Oven's door is Open
3777	19	18	8	0	(Weather Sensor) The temperature becomes 88 degrees
3778	19	18	8	0	(Weather Sensor) The temperature becomes 83 degrees
3779	14	25	5	0	Living Room Window is Closed
3780	18	18	7	0	(Weather Sensor) The weather is Clear
3781	52	11	14	0	It becomes true that "Roomba turns Off" last happened exactly 3h  ago
3782	20	18	7	0	It starts raining
3783	36	5	12	1	Smart TV is not tuned to Channel 758
3784	9	3	3	0	Amazon Echo starts playing Jazz
3785	37	5	12	0	animal planet stops playing on Smart TV
3786	25	17	9	0	(Clock) The time becomes 21:00
3787	2	5	12	1	Smart TV is On
3788	25	17	9	0	(Clock) The time becomes later than 00:00
3789	58	24	5	0	Bathroom Window's curtains are Open
3790	18	18	7	0	(Weather Sensor) The weather becomes Partly Cloudy
3791	20	18	7	0	It starts raining
3792	18	18	6	0	(Weather Sensor) The weather becomes Snowing
3793	35	3	3	0	pop music starts playing on Amazon Echo
3794	18	18	7	0	(Weather Sensor) The weather becomes Raining
3795	21	2	8	0	Thermostat's temperature becomes set to 75 degrees
3796	18	18	7	0	(Weather Sensor) The weather becomes Sunny
3797	21	2	8	0	Thermostat's temperature becomes set to 69 degrees
3798	63	12	6	0	Anyone Enters Bathroom
3799	9	3	3	0	Amazon Echo starts playing Pop
3800	9	3	3	1	Amazon Echo is playing Pop
3801	14	24	5	0	Bathroom Window Closes
3802	55	17	9	1	It is Daytime
3803	9	3	3	0	Amazon Echo starts playing Pop
3804	9	3	3	1	Amazon Echo is playing Pop
3805	2	1	18	0	Roomba turns On
3806	63	12	15	1	Nobody is not in Home
3807	58	24	5	2	Bathroom Window's curtains are Closed
3808	58	14	5	3	Bedroom Window's curtains are Closed
3809	58	25	5	4	Living Room Window's curtains are Closed
3810	64	22	17	0	Smart Faucet's water Turns On
3811	2	23	13	0	Smart Oven turns On
3812	60	23	13	1	Smart Oven's door is Closed
3813	63	12	6	2	Someone other than Bobbie is not in Home
3814	19	18	8	0	(Weather Sensor) The temperature goes above 80 degrees
3815	63	12	15	0	Anyone Enters Bedroom
3816	49	11	14	1	It becomes true that "(FitBit) I am Asleep" was active 30m  ago
3817	61	21	16	0	(FitBit) I Fall Asleep
3818	13	13	5	1	Front Door Lock is Unlocked
3819	63	12	15	0	Anyone Enters Home
3820	14	14	5	1	Bedroom Window is Closed
3821	14	25	5	2	Living Room Window is Closed
3822	14	24	5	3	Bathroom Window is Closed
3823	64	22	17	0	Smart Faucet's water Turns Off
3824	64	22	17	0	Smart Faucet's water Turns On
3825	13	23	13	0	Smart Oven Locks
3826	65	23	13	0	Smart Oven's temperature is above 200 degrees
3827	63	12	15	0	Anyone Enters Bedroom
3828	20	18	7	1	It is Not Raining
3829	19	2	8	2	(Thermostat) The temperature is below 80 degrees
3830	19	2	8	3	(Thermostat) The temperature is above 60 degrees
3831	63	12	15	0	Anyone Enters Bedroom
3832	20	18	7	1	It is Not Raining
3833	19	2	8	2	(Thermostat) The temperature is below 80 degrees
3834	19	2	8	3	(Thermostat) The temperature is above 60 degrees
3835	2	1	18	0	Roomba turns On
3836	58	25	5	1	Living Room Window's curtains are Open
3837	19	2	8	0	(Thermostat) The temperature goes above 80 degrees
3838	2	1	18	0	Roomba turns On
3839	58	24	5	1	Bathroom Window's curtains are Open
3840	2	1	18	0	Roomba turns On
3841	58	14	5	1	Bedroom Window's curtains are Open
3842	14	25	5	0	Living Room Window is Open
3843	14	14	5	0	Bedroom Window is Open
3844	9	3	3	0	Amazon Echo starts playing Pop
3845	52	11	14	0	It becomes true that "Smart Faucet's water Turns On" last happened more than 15s  ago
3847	9	3	3	0	Amazon Echo starts playing Pop
3848	2	1	18	0	Roomba turns On
3849	25	17	9	0	(Clock) The time is after 18:00
3850	63	12	15	0	Bobbie Enters Kitchen
3851	14	14	5	0	Bedroom Window is Open
3852	19	18	8	0	(Weather Sensor) The temperature is below 80 degrees
3853	19	18	8	1	(Weather Sensor) The temperature is above 60 degrees
3854	20	18	7	2	It is Not Raining
3857	63	12	15	1	Anyone is not in Home
3858	19	2	8	0	(Thermostat) The temperature goes above 75 degrees
3859	63	12	15	1	Anyone is in Home
3860	19	2	8	0	(Thermostat) The temperature falls below 70 degrees
3861	63	12	15	1	Anyone is in Home
3862	19	2	8	0	(Thermostat) The temperature falls below 73 degrees
3863	19	2	8	0	(Thermostat) The temperature falls below 73 degrees
3864	63	12	15	1	Anyone is in Home
3865	57	2	8	0	The AC turns On
3866	63	12	15	1	Nobody is in Home
3867	21	2	8	0	Thermostat's temperature becomes set above 66 degrees
3868	63	12	15	1	Nobody is in Home
3869	19	18	8	0	(Weather Sensor) The temperature goes above 62 degrees
3870	63	12	15	1	Nobody is in Home
3871	52	11	14	0	It becomes true that "(FitBit) I Fall Asleep" last happened more than 30m  ago
3872	2	5	12	1	Smart TV is On
3873	52	11	14	0	It becomes true that "Someone other than A Family Member Enters Home" last happened less than 3h  ago
3874	52	11	14	0	It becomes true that "Someone other than A Family Member Enters Home" last happened more than 3h  ago
3875	63	12	15	0	Bobbie Enters Kitchen
3876	2	23	13	1	Smart Oven is On
3877	58	24	5	0	Bathroom Window's curtains Open
3878	2	1	18	0	Roomba turns Off
3879	15	10	6	0	Security Camera Starts Detecting Motion
3880	19	2	8	0	(Thermostat) The temperature goes above 80 degrees
3881	2	5	12	0	Smart TV is On
3882	61	21	16	0	(FitBit) I am Asleep
3883	14	24	5	0	Bathroom Window Closes
3884	14	14	5	1	Bedroom Window is Closed
3885	14	25	5	2	Living Room Window is Closed
3886	14	14	5	0	Bedroom Window Closes
3887	14	24	5	1	Bathroom Window is Closed
3888	14	25	5	2	Living Room Window is Closed
3889	14	25	5	0	Living Room Window Closes
3890	14	24	5	1	Bathroom Window is Closed
3891	14	14	5	2	Bedroom Window is Closed
3892	13	13	5	0	Front Door Lock is Unlocked
3893	13	13	4	0	Front Door Lock is Locked
3894	61	21	16	0	(FitBit) I am Asleep
3895	61	21	16	0	(FitBit) I Fall Asleep
3896	13	13	5	0	Front Door Lock Unlocks
3897	61	21	16	1	(FitBit) I am Asleep
3898	14	14	5	0	Bedroom Window is Open
3899	19	2	8	0	(Thermostat) The temperature is above 60 degrees
3900	19	2	8	0	(Thermostat) The temperature is below 80 degrees
3901	20	18	7	0	It is Not Raining
3902	61	21	16	0	(FitBit) I Fall Asleep
3903	13	13	5	1	Front Door Lock is Unlocked
3904	21	2	8	0	Thermostat is set to 73 degrees
3905	63	12	15	0	Anyone is in Home
3906	58	14	5	0	Bedroom Window's curtains Close
3907	2	1	18	0	Roomba is On
3908	66	8	13	0	Smart Refrigerator's temperature becomes set below 40 degrees
3909	66	8	13	0	Smart Refrigerator's temperature becomes set below 40 degrees
3910	58	24	5	0	Bathroom Window's curtains Open
3911	2	1	18	0	Roomba turns On
3912	63	12	6	1	A Family Member is in Home
3913	63	12	6	2	A Guest is in Home
3914	9	3	3	0	Amazon Echo starts playing Pop
3915	60	8	13	0	Smart Refrigerator's door Opens
3916	60	8	13	1	Smart Refrigerator's door is Open
3917	60	8	13	2	Smart Refrigerator's door is Closed
3918	19	2	8	0	(Thermostat) The temperature becomes 80 degrees
3919	2	23	13	0	Smart Oven turns On
3920	2	1	18	0	Roomba turns On
3921	13	14	4	1	Bedroom Window is Locked
3922	64	22	13	0	Smart Faucet's water is not running
3923	50	11	14	0	"(Coffee Pot) There are exactly 1 cups of coffee brewed" has occurred exactly 6 times in the last 1h 
3924	2	9	13	0	Coffee Pot turns On
3925	20	18	7	0	It starts raining
\.


--
-- Name: backend_trigger_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.backend_trigger_id_seq', 3927, true);


--
-- Data for Name: backend_user; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.backend_user (id, name, mode, code) FROM stdin;
129	\N	rules	A1WAH8PEKTJ0GP
3	noah	rules	1
1	jesse	rules	jesse
4	\N	rules	8
5	\N	rules	blase
6	\N	sp	2
7	\N	sp	100
9	\N	rules	someusername
10	will2	rules	wbrack
11	jesse2	sp	jesse2
12	roshni	rules	roshni
8	will	rules	will
13	\N	sp	fds
14	\N	sp	gfd
15	\N	rules	A3GPTSDDHJ2DBV
16	\N	sp	ATUY1BTU5BQDE
17	\N	sp	A3VE8U98QF4FVV
18	\N	rules	A188SHJZPHE8BA
19	\N	sp	A2PMT4061B1NDP
20	\N	sp	A132MSWBBVTOES
21	\N	sp	A2VBSFSJXLZZ7A
22	\N	sp	A1LSTI58FIV8RD
23	\N	sp	A3QLGMZOLGMBQ1
24	\N	rules	A3696JXTRKL2FI
25	\N	sp	AA9V4NE8SOA4I
26	\N	sp	A3HAPMZV7CYDY8
27	\N	rules	A320QA9HJFUOZO
28	\N	rules	A3POD149IG0DIW
29	\N	sp	A1P6OXEJ86HQRM
30	\N	rules	A1PUHCEBSOWETV
31	\N	sp	A1VPQJR2V850OM
32	\N	rules	A1PLB1NZOE2PQ7
33	\N	rules	A1JV64BL3WCK0G
34	\N	sp	A2YM550H2AL6JO
35	\N	sp	A1DBPM1UHEP4MU
36	\N	sp	A1XDMS0KFSF5JW
37	\N	rules	A2JP9IKRHNLRPI
38	\N	sp	A2XOP6WJGR59QR
39	\N	sp	undefined
40	\N	rules	A3LRZX8477TYYZ
41	\N	rules	ALZHJRQ5PGM9Y
42	\N	rules	A3U2UNSYDPS933
43	\N	rules	A2LC2DS8OH7NCA
44	\N	rules	A28ZPY6D5AS7GZ
45	\N	rules	A1CH3TODZNQCES
46	\N	rules	A11BSFO4LMHPXQ
47	\N	rules	A2YQAE441JMA7V
48	\N	rules	A2YQBBAK7NBZHU
49	\N	rules	A3OYMC2LSHPQV9
50	\N	rules	AG1BNU31ZP490
51	\N	sp	AYUTE88MPK24K
52	\N	sp	ASW9MABLSXSPK
53	\N	sp	A1PTH9KTRO06EG
54	\N	rules	A1ZT30BGR3266K
55	\N	sp	A12R2U6TBB3OOG
56	\N	sp	A3CZ2S6TCQTJBK
57	\N	rules	A14ADQ7RUN6TDY
58	\N	sp	A13VM24YC4SOFT
59	\N	rules	A1VW8Y7XCV3DRW
60	\N	sp	A2OVWCQ4B9AHFY
61	\N	sp	A2Z3VYYYAIOGHC
62	\N	sp	AHY3YAYJLTW32
63	\N	sp	A3AY0315YWWNXY
64	\N	rules	A1ING769NXJIHR
65	\N	sp	A2FFGTL0FBW7OQ
66	\N	sp	A1S2NQYJGZ0C5F
67	\N	sp	A37EV8RZ82WT8E
68	\N	rules	A272X64FOZFYLB
69	\N	sp	AZBH4LJ5SL456
70	\N	rules	A2WWYVKGZZXBOB
71	\N	rules	A2YJFCTJPPX66
72	\N	rules	A3HE29W5IDR394
73	\N	rules	A2A07J1P6YEW6Z
74	\N	sp	A1ODA3Q5H6HTDQ
75	\N	sp	A30KYQGABO7JER
76	\N	sp	A324AD5U1SV0OA
77	\N	rules	A3W24IE6P9O302
78	\N	sp	A3FFZN4FO3Q789
79	\N	rules	A1XGI8153WBWFQ
80	\N	rules	A34UER5ZQ5APMB
81	\N	rules	A3DTPUNCHRVGP4
82	\N	rules	A4ZPIPBDO624H
83	\N	sp	A1W4I23IIZY6UR
84	\N	sp	A1XATJA7ENOGWB
85	\N	sp	A1ZTSCPETU3UJW
86	\N	sp	A2O5OJXCUFQ3FV
87	\N	sp	A21SIPO89DP66I
88	\N	rules	A3F51C49T9A34D
89	\N	rules	AYKZ9H4BNW810
90	\N	rules	ASMEIXETQPZV2
91	\N	rules	A3UUH3632AI3ZX
92	\N	sp	A3S5UROKNNCNSB
93	\N	sp	AX52PJTN3QQBI
94	\N	rules	A2GHME4F11G828
95	\N	sp	A2RBF3IIJP15IH
96	\N	rules	A36IYIE23IO4HE
97	\N	rules	A27K37YQZDPER6
98	\N	sp	AVJUIF9QHQRY8
99	\N	rules	A2ADEPVGNNXNPA
100	\N	sp	A1V2H0UF94ATWY
101	\N	sp	A2VNK2H6USLQTK
102	\N	rules	APR6H3HAOE9OU
103	\N	sp	A31681CCEVDIH3
104	\N	rules	A3CDJ8PZX578GQ
105	\N	sp	A1MNJ1VJEZE8NY
106	\N	sp	A1MYLQQL8BBOYT
107	\N	rules	A4IH4CO046EV3
108	\N	rules	A1AKX1C8GCVCTP
109	\N	rules	A1B4WL7N3ACF2T
110	\N	rules	A3KCUB6P3IE8NL
111	\N	rules	AG263U3LX899H
112	\N	rules	A2871R3LEPWMMK
113	\N	sp	A30VLAIIJIG5IS
114	\N	sp	AZVJA0TUHIUJK
115	\N	rules	jesse7
116	\N	rules	A1A2XH9JVSN8Z0
117	\N	sp	A147F5PJTHOB8A
118	\N	rules	A33QIOA2EYW0LC
119	\N	rules	jesse8
120	\N	rules	jesse9
121	\N	rules	jesse10
122	\N	sp	jesse11
123	\N	rules	jesse12
124	\N	sp	jesse13
125	\N	rules	jesse14
126	\N	sp	jesse15
127	\N	rules	A1ZD8RU6YB0VEU
128	\N	rules	A2JCHN90PRUWDH
130	\N	rules	AM155T4U3RE1A
131	\N	rules	A1GTYHV8OYQQLV
132	\N	rules	A3LJ2FHESYV9QQ
133	\N	rules	A341KLOTTTS5I4
134	\N	sp	A3J0IAI8AJBGKX
135	\N	rules	AX06ZUCRNSGB3
136	\N	rules	A2AG45K4ULNBHF
137	\N	rules	AQ9Y6WD8O72ZC
138	\N	rules	A39GADIK8RLMVC
139	\N	sp	A28Z4EOSSQAZM2
140	\N	sp	A3LL096CAY5WHB
141	\N	rules	A1DIGREVLNOXT3
142	\N	sp	A20SL254675EOK
143	\N	rules	AU7A3QNJF3O00
144	\N	rules	A1PZ1YZAQEXRSQ
145	\N	rules	A183WYXN12P2TJ
146	\N	sp	A1U5BE8XJRXKW3
147	\N	sp	A3N7R7P9HP2YB6
148	\N	rules	A2Q3FS9G8ITCN7
149	\N	sp	A1LOUZD99NZCT2
150	\N	rules	A11MCPY8W4U6FL
151	\N	sp	A1Z8AOIDT5IV43
152	\N	sp	A2S3SV1LQTKJ8K
153	\N	rules	A2SC0NTXAEEFX
154	\N	sp	ALF9AAZGQP4K5
155	\N	rules	A133QG754CGS3I
156	\N	rules	A35JCNZJI2MQ20
157	\N	sp	A3VD9VK9NLEVMN
158	\N	rules	A30H5IF78HYZJ4
159	\N	sp	A2ML4TEAJTDQD0
160	\N	sp	ALXZBIM9FIMR5
161	\N	rules	A2R8IV2PWFTY00
162	\N	sp	A3JTQ0H4YY2BLS
163	\N	sp	A2196WCNDZULFS
164	\N	rules	A3IW9415ZOO0EX
165	\N	rules	A35U2XAPA429W7
166	\N	sp	A3HESOWHVBQOEI
167	\N	rules	A3O0QZQ4V2IXT7
168	\N	sp	ANZKTE853UXSD
169	\N	sp	A3HSMUPSPOKD0M
170	\N	sp	ARWF605I7RWM7
171	\N	rules	A1VIP6S8H2XXH7
172	\N	rules	A3EJ44J2ZNRMDA
173	\N	sp	AHEVIE2NY1W1Z
174	\N	sp	A21UA6O7ZFAIQJ
175	\N	sp	A2AAY4VT9L71SY
176	\N	rules	A33KB8LHYO0HI9
177	\N	rules	A3HXIGBCL1CRFS
178	\N	rules	A14SEFVPXYZ9TN
179	\N	rules	A34SUZWGLXIWM8
180	\N	rules	A22ABLVEI5EGPL
181	\N	rules	A114JRUBJ5IN7D
182	\N	sp	AKNYT1NTK2UFK
183	\N	rules	A3OXOYNCOPR23H
184	\N	sp	A3W6T1WDYXMR3
185	\N	rules	AEXF5EUX32U0M
186	\N	rules	A24L39U14B2FUT
187	\N	sp	A3E8SXH0BAYG85
188	\N	rules	A2M5VW97GIYLHB
189	\N	sp	A2GOJCVBYZ6H75
190	\N	rules	A6X00WR4L3B11
191	\N	rules	A3QEC8YFR7OFJN
192	\N	sp	A207IHY6GERCFO
193	\N	sp	A1L92Y6VBTRFP5
194	\N	sp	ACAJFF4MF5S5X
195	\N	sp	A1W8B7P1WVD7TX
196	\N	sp	A1RATFICCKLCQ
197	\N	sp	ALEJV7D94ZLHF
198	\N	sp	A3GK90X2QOFR53
199	\N	rules	A20BMZQJS92QY2
200	\N	sp	A2ZNOMZ35LKY8Q
201	\N	sp	A1X1IRFYQZ40LD
202	\N	sp	A35TWG9VW1MB5S
203	\N	rules	A18T30ATR2VLK1
204	\N	rules	A2Z70GL7HTFFQR
205	\N	sp	A35NVKW9R833VF
206	\N	rules	A1FLNAFLLO3UPK
207	\N	rules	A2WKZI3JQCE3Z6
208	\N	rules	A17LRY89BBPCUG
209	\N	rules	A2W3DI02JARCZM
210	\N	rules	A3389CKDG69V5Q
211	\N	sp	A9HQ3E0F2AGVO
212	\N	rules	A2QV8VQP7P4VQ4
213	\N	rules	AROEBUDI2L9G9
214	\N	rules	A3BHRFFG75X3GO
215	\N	sp	A2F9V69F6TZIAB
216	\N	rules	A2GZ00IMOT6L3X
217	\N	sp	A31A4YKVSOYRVS
218	\N	rules	A3J55BJGV95JKH
219	\N	rules	abhi
\.


--
-- Name: backend_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.backend_user_id_seq', 219, true);


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
\.


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1, false);


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	permission
3	auth	group
4	auth	user
5	contenttypes	contenttype
6	sessions	session
7	user_auth	usermetadata
8	rule_management	rule
9	rule_management	device
10	rule_management	abstractcharecteristic
11	rule_management	devicecharecteristic
12	backend	user
13	backend	channel
14	backend	capability
15	backend	parameter
16	backend	setparam
17	backend	setparamopt
18	backend	rangeparam
19	backend	binparam
20	backend	colorparam
21	backend	timeparam
22	backend	durationparam
23	backend	inputparam
24	backend	metaparam
25	backend	parval
26	backend	condition
27	backend	device
28	backend	state
29	backend	trigger
30	backend	rule
31	backend	esrule
32	backend	ssrule
33	backend	safetyprop
34	backend	sp1
35	backend	sp2
36	backend	sp3
37	backend	statelog
38	st_end	stapp
39	st_end	device
\.


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 42, true);


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2018-07-30 19:11:18.208421-05
2	auth	0001_initial	2018-07-30 19:11:18.292461-05
3	admin	0001_initial	2018-07-30 19:11:18.316381-05
4	admin	0002_logentry_remove_auto_add	2018-07-30 19:11:18.322893-05
5	contenttypes	0002_remove_content_type_name	2018-07-30 19:11:18.338061-05
6	auth	0002_alter_permission_name_max_length	2018-07-30 19:11:18.344863-05
7	auth	0003_alter_user_email_max_length	2018-07-30 19:11:18.355484-05
8	auth	0004_alter_user_username_opts	2018-07-30 19:11:18.363363-05
9	auth	0005_alter_user_last_login_null	2018-07-30 19:11:18.370475-05
10	auth	0006_require_contenttypes_0002	2018-07-30 19:11:18.372051-05
11	auth	0007_alter_validators_add_error_messages	2018-07-30 19:11:18.381063-05
12	auth	0008_alter_user_username_max_length	2018-07-30 19:11:18.402165-05
13	auth	0009_alter_user_last_name_max_length	2018-07-30 19:11:18.410984-05
14	backend	0001_initial	2018-07-30 19:11:18.525187-05
15	backend	0002_auto_20180612_1716	2018-07-30 19:11:18.526732-05
16	backend	0002_remove_state_dev	2018-07-30 19:11:18.537275-05
17	backend	0003_state_dev	2018-07-30 19:11:18.549216-05
18	backend	0004_better_ssrule	2018-07-30 19:11:18.600227-05
19	backend	0005_auto_20180612_2205	2018-07-30 19:11:18.615116-05
20	backend	0006_auto_20180613_1902	2018-07-30 19:11:18.681048-05
21	backend	0007_eerule_esrule	2018-07-30 19:11:18.734547-05
22	backend	0008_auto_20180614_1834	2018-07-30 19:11:18.749367-05
23	backend	0009_auto_20180614_1929	2018-07-30 19:11:18.75801-05
24	backend	0010_auto_20180616_0903	2018-07-30 19:11:18.794076-05
25	backend	0011_auto_20180616_2048	2018-07-30 19:11:18.814-05
26	backend	0012_auto_20180618_1938	2018-07-30 19:11:18.881166-05
27	backend	0013_auto_20180618_2026	2018-07-30 19:11:18.933036-05
28	backend	0014_auto_20180618_2050	2018-07-30 19:11:18.946705-05
29	backend	0015_auto_20180621_1727	2018-07-30 19:11:18.958718-05
30	backend	0016_auto_20180621_2036	2018-07-30 19:11:18.974373-05
31	backend	0017_statelog	2018-07-30 19:11:18.992047-05
32	backend	0018_auto_20180703_2113	2018-07-30 19:11:19.040739-05
33	backend	0019_auto_20180706_1621	2018-07-30 19:11:19.049521-05
34	backend	0020_auto_20180708_2350	2018-07-30 19:11:19.133714-05
35	backend	0021_auto_20180709_1505	2018-07-30 19:11:19.246348-05
36	backend	0022_auto_20180709_1526	2018-07-30 19:11:19.256616-05
37	backend	0023_auto_20180709_1620	2018-07-30 19:11:19.296641-05
38	backend	0024_auto_20180710_1621	2018-07-30 19:11:19.307588-05
39	backend	0025_auto_20180710_1622	2018-07-30 19:11:19.399849-05
40	backend	0026_auto_20180710_1819	2018-07-30 19:11:19.534818-05
41	backend	0027_auto_20180711_2140	2018-07-30 19:11:19.610214-05
42	backend	0028_auto_20180712_2052	2018-07-30 19:11:19.72355-05
43	backend	0029_auto_20180712_2053	2018-07-30 19:11:19.830329-05
44	backend	0030_auto_20180716_1520	2018-07-30 19:11:19.944751-05
45	backend	0031_auto_20180716_1543	2018-07-30 19:11:20.03333-05
46	backend	0032_auto_20180716_1654	2018-07-30 19:11:20.067525-05
47	backend	0033_channel_icon	2018-07-30 19:11:20.07347-05
48	backend	0034_auto_20180718_1611	2018-07-30 19:11:20.085153-05
49	backend	0035_auto_20180719_2044	2018-07-30 19:11:20.096341-05
50	backend	0036_auto_20180723_1835	2018-07-30 19:11:20.131168-05
51	backend	0037_metaparam	2018-07-30 19:11:20.146187-05
52	backend	0038_auto_20180724_1622	2018-07-30 19:11:20.1849-05
53	backend	0039_auto_20180725_1808	2018-07-30 19:11:20.285871-05
54	backend	0040_auto_20180727_1516	2018-07-30 19:11:20.424509-05
55	backend	0041_durationparam_comp	2018-07-30 19:11:20.437862-05
56	backend	0042_auto_20180727_2108	2018-07-30 19:11:20.657446-05
57	backend	0043_state_chan	2018-07-30 19:11:20.678963-05
58	backend	0044_auto_20180730_1605	2018-07-30 19:11:20.709922-05
59	backend	0045_auto_20180730_1657	2018-07-30 19:11:20.732636-05
60	rule_management	0001_initial	2018-07-30 19:11:20.782939-05
61	sessions	0001_initial	2018-07-30 19:11:20.793209-05
62	st_end	0001_initial	2018-07-30 19:11:20.802377-05
63	user_auth	0001_initial	2018-07-30 19:11:20.820275-05
64	backend	0001_squashed_0002_auto_20180612_1716	2018-07-30 19:11:20.822998-05
69	backend	0046_auto_20180731_2207	2018-07-31 18:46:22.236628-05
70	backend	0047_device_chans	2018-08-03 11:19:29.578388-05
71	backend	0048_auto_20180806_2354	2018-08-06 18:55:12.489552-05
72	backend	0049_auto_20180807_0004	2018-08-06 19:04:27.841946-05
73	backend	0050_auto_20180807_1625	2018-08-07 11:25:04.897361-05
74	backend	0051_sp3_timecomp	2018-08-09 12:01:48.946052-05
75	backend	0052_auto_20180809_1733	2018-08-09 12:33:58.74554-05
76	backend	0053_auto_20180809_2232	2018-08-09 17:32:19.505896-05
\.


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 76, true);


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
dlj4j8x2r3nqhkszvxx31wn201c0irzw	Y2NjMDE2YWRmYTE4Y2E4ZTk0NjMyMGFlN2JlNjllMjc3Njc3ZWI0Mzp7InVzZXJpZCI6M30=	2018-09-02 15:14:46.653664-05
ig3uf1447mnatyo29pgflym321rq4vqy	Y2NjMDE2YWRmYTE4Y2E4ZTk0NjMyMGFlN2JlNjllMjc3Njc3ZWI0Mzp7InVzZXJpZCI6M30=	2018-09-02 15:15:38.692772-05
3lx9t084idov0zczazh71rox0jn3kkgu	MzIwM2I1MTY4ZWE0M2RiMDZmZDczZTlkYzkxNzM3NzZkZTRiNThmNTp7InVzZXJpZCI6NywidGFza2lkIjoxMDAwfQ==	2018-09-03 21:33:20.139845-05
v9mvggdlrxctdwlbq3ij64giv4ulli3k	ZDQ2NWIyMDg1YTJhY2Q2NWJmYWI1MDgzY2M4ZTQyY2E3NTU2MTQwOTp7InVzZXJpZCI6Nzl9	2018-09-02 18:50:00.666087-05
3omn95dsvs3fiqp1ehc5x90a2jdfddwj	ZjZhNDQxNGVmNzk2NDY4YjNhMTIzOTk0NmM0MGRhMzZkNmMyODY1Mjp7InVzZXJpZCI6ODB9	2018-09-02 18:51:26.998081-05
lcr0nyd8t93ukcin1kni6uu5rjkawd7j	NjNkYTg3MDMyOWUxMWM2NmNlZjk2NGUxMzIxZjQ5MWZjNmFmMDNlMDp7InVzZXJpZCI6ODF9	2018-09-02 18:51:35.857613-05
le9ad75tjqp2te5b0cvgodhtiylagco9	ZjE2MTU0OGIwZmE2YjhjZjYwNTk0ZDEyN2UxNjUzZmE4M2FlZjRlOTp7InVzZXJpZCI6ODJ9	2018-09-02 18:51:57.471333-05
tf0hmo8g1rsymb60to5wdwbhtznvtacj	YjY5ZDc0Yzk0Y2ZjMDhmYmJhMDg0NzcyOTQ5NGZhYmM4NjA3NmYyNTp7InVzZXJpZCI6ODh9	2018-09-02 19:00:20.657646-05
t4az0gi1uzupapxbd28pcd236152tx4o	OTk4MWY1YzU5N2I5NTA0ZDc2NGYzMDFjY2IxMmU5NjMxMGI5NzRhNDp7InVzZXJpZCI6ODl9	2018-09-02 19:02:06.507511-05
ihbrxthc5w9m74h0qssolm026aeb1hlt	NDhmZDU5MzE2NDJkMGVmNjU0NzEzNWFkY2NmMjkwY2UwMjlhMDcyNzp7InVzZXJpZCI6OTB9	2018-09-02 19:05:40.140966-05
pai9w18wxbjd89lecm8tsv8yt8w7ap4o	ODI2NTMxOTI2NzlkYmRhMjg3YjZhM2M2ZjEzMjhjODhmYTAwMDU5ODp7InVzZXJpZCI6OTF9	2018-09-02 19:05:41.824696-05
vozu5kwrq6ale9q4hyyftpn81hn1uq9p	Y2NjMDE2YWRmYTE4Y2E4ZTk0NjMyMGFlN2JlNjllMjc3Njc3ZWI0Mzp7InVzZXJpZCI6M30=	2018-09-02 19:08:49.980519-05
oqx74j6ohst42fj3lvdjjdpf4r2l8w1w	NmY1NzhiMmRkYjNjY2ZiM2RlMzVmOWNkNjY3MTc0YmYxZTI5ZGNhNzp7InVzZXJpZCI6OTR9	2018-09-02 19:12:01.671909-05
39j73sm4od940cfemii410s2l61c9f97	NjZmMDU5MDQ1MmU3OGM0YzMyZjU4NTMzZmMzZmJmYzIzY2E1N2E0ZTp7InVzZXJpZCI6OTZ9	2018-09-02 19:15:02.084498-05
67cug1wb0oovk9p3vq1p93m7snf6lgt5	MTM3MWEyMDE0MjU0YmE4OWMxYmQ0ZTI3NGQ5ZDFhNDJhZTQ1NWMxODp7InVzZXJpZCI6OTd9	2018-09-02 19:15:47.461307-05
hlp0j38cqazvuu69o1nplq33s6xr9ree	MDc5ZGIwNjUzYjAyNjY5NDFmZTUwNjFiMjM0NDM4Mjc0ODAzMDUwNTp7InVzZXJpZCI6OTl9	2018-09-02 19:19:42.166391-05
53pu9ock4epaayykwrboy6r4fm5cxkgf	NWUzZGEyZGVhMTI1MzU4NjgzZmRjNzFkNzZhYzI5MzAyZGM2ODQ3Njp7InVzZXJpZCI6MTAyfQ==	2018-09-02 19:26:59.512322-05
4ywhp01n9zp7poc2yjn69nrrjg8cdz70	YjY5ZDc0Yzk0Y2ZjMDhmYmJhMDg0NzcyOTQ5NGZhYmM4NjA3NmYyNTp7InVzZXJpZCI6ODh9	2018-09-02 19:27:27.656295-05
revktlybudcpp36jiyky0p7t75jtgef0	Y2NjMDE2YWRmYTE4Y2E4ZTk0NjMyMGFlN2JlNjllMjc3Njc3ZWI0Mzp7InVzZXJpZCI6M30=	2018-09-02 19:39:15.309085-05
y96xkqh3zg3fdnkuiv6dx1a5tpksfuat	NWNhNDAzNWNmZmQzMTllMTc5NTdmNzMwYTRlYThiOWY3ODY1YjIwNDp7InVzZXJpZCI6MTA0fQ==	2018-09-02 19:50:13.519991-05
apie6v1a06cjbu3bjvcoue0qdt9a9apc	Y2NjMDE2YWRmYTE4Y2E4ZTk0NjMyMGFlN2JlNjllMjc3Njc3ZWI0Mzp7InVzZXJpZCI6M30=	2018-09-02 19:55:46.284879-05
fo9tz5r5lmnb4wyawvfai961sw2vjjgq	NWY4ZTI2YjA0MTgwZjg4ZWZhOTI4ZTNlYTBhZmUxNTM0Y2E4Njc5Njp7InVzZXJpZCI6MTA3fQ==	2018-09-02 20:06:06.753114-05
d9mgxb5m2jxw85so0inku7qcac2kv29o	N2Y0NmVlMjhlMWQ2NTliNzM3NGJjMzRjNmY5MTVlMzU2ODgxNmZkYTp7InVzZXJpZCI6MTA4fQ==	2018-09-02 20:10:59.256574-05
lhidmi3cpkoe3km9ra5h2xv1xpts77ea	ODA1MzIxZjQyYmE2NTQyOTE5MmY5YmI1OTI0NmQ1YmI5YjhkOWYxMTp7InVzZXJpZCI6MTEwfQ==	2018-09-02 20:12:20.031886-05
xuszx1li9mzh8cqawgk52aoxr8vrtsc7	MzU0ZWE4YjU0MTgxYWMxZGExNzdiNTBlMjc5MmZiZDU2ODNhZGY0OTp7InVzZXJpZCI6MTExfQ==	2018-09-02 20:19:19.939174-05
a2pgcp4s6pxa288db0j4hm48em1d1app	NGE5YWEwMDAxOGNkOTE5M2I2N2FlM2Y5OWNlNjZkYjY1OTA4NTI1NDp7InVzZXJpZCI6MTEyfQ==	2018-09-02 20:20:14.70095-05
6bmmfuuko1yb5hvxpllwfga3f6t9rthp	NGQ2NTUwODdhYTUyMzYyMzJhYmNjNGRlMGI1MGM4Nzc5NzE4ZjIyNjp7InVzZXJpZCI6MTE1fQ==	2018-09-02 20:54:55.826483-05
u0mk9cio99pql68gws5ceyx3gko5z7wn	Y2JmMDQwNzFlOTdiMDA3NzE0MTU0MDQ3ZmY1ZTIzMThkNjFiNzkzYTp7InVzZXJpZCI6MTE2fQ==	2018-09-02 20:57:21.897187-05
4c2k1elwm5i6cw4rlyy2okwyguhikpu7	NzNlNjdkZjBkZGZkMmNhMjk0MTljZmFiYTM1ZmYwZTNiOGM4YjVmODp7InVzZXJpZCI6MTY5LCJ0YXNraWQiOjEwfQ==	2018-09-03 20:03:25.281838-05
89lpddc2encnl9ygs51vy13kmq22y8w2	Njk0NzljYjNlMDI3YzFiNzlmYTg4MGNiZWZiODYzMGZhM2QyNjg3ZTp7InVzZXJpZCI6MTAzfQ==	2018-09-02 21:19:17.33127-05
h89591se6anl5idiub1tkiq4mu4yspgb	MTI3ZTA2MWEwMDFhYzBiN2NhNGFiYWRmZjczNjBkZTUxMWQyNGVlNDp7InVzZXJpZCI6MTE5fQ==	2018-09-02 21:24:50.516758-05
yov92dxxxaiob1079klsix2jmxq98kde	NGY2OTA4ZjQ0NmQxNzVjNjJmZDBjZmFjNjJmYzE0YmYyYzlkZDk2Nzp7InVzZXJpZCI6MTIwfQ==	2018-09-02 21:25:44.527162-05
8ov9t5vqyr1jqatrdh5bi6md7lbeq8t4	YTZhNzVjNWQ4N2QxYzhmYjY5ODA2ZDMwNmI3ZGRhNjI5NTlkOGY1Njp7InVzZXJpZCI6MTIxfQ==	2018-09-02 21:35:25.903422-05
tgogvrh3whr6qjyz0hgpq09xdr7wu83u	YTAwMDBjMjcyNzEzMGRhOWU5OGQ4MDgwZjEzOWExNzA4N2VhMzdmMjp7InVzZXJpZCI6MTIyfQ==	2018-09-02 21:35:47.910541-05
vs8lk1g93yj2i89ez55ts3b7bkxeml2w	MTFlNjU2NTMzM2UyNDU1MjJhZDM1NTU1ZjZlYWNmYWZhYWQwNmM1Zjp7InVzZXJpZCI6MTIzfQ==	2018-09-02 21:52:09.773441-05
fti7wdmaycmi8xmp88t81yngpxjzs4do	MmYwNmRiMTEyNGNmNjgyYmQ4NWU0NmRiYWQ3MjYyY2JmNWUyNWNiYTp7InVzZXJpZCI6MTI0fQ==	2018-09-02 21:56:52.513797-05
cbkiioe43oz7k1tfng2tt0a0fsh46tjc	Y2NjMDE2YWRmYTE4Y2E4ZTk0NjMyMGFlN2JlNjllMjc3Njc3ZWI0Mzp7InVzZXJpZCI6M30=	2018-09-03 08:42:24.927126-05
aie40y2dfyqomwjssb1lcivqej0tlskj	MmYwNmRiMTEyNGNmNjgyYmQ4NWU0NmRiYWQ3MjYyY2JmNWUyNWNiYTp7InVzZXJpZCI6MTI0fQ==	2018-09-03 10:01:45.685812-05
atgbslxj7378ojqdnfyn7ibjqi8d8iae	NjYzY2RjNDllMjg5Njk0NmUyYjc1ZDdkYTE3NjI0M2RkNDg0ZmU0NTp7InVzZXJpZCI6MTI1fQ==	2018-09-03 10:17:56.065666-05
w4fke9bzlwz6ykgu0emxxgarqt4q5dmz	Y2NjMDE2YWRmYTE4Y2E4ZTk0NjMyMGFlN2JlNjllMjc3Njc3ZWI0Mzp7InVzZXJpZCI6M30=	2018-09-03 10:30:09.04356-05
j08b9sh2xvzibqe7s1fh7w5hkllt9awd	ODA3MGQxMWIwNDEwM2RkNjk1MjMyY2Y2NmI1ZGQ4ZWJkNjVlMmFiZDp7InVzZXJpZCI6MTQ4LCJ0YXNraWQiOjE2fQ==	2018-09-03 15:22:02.18922-05
fkq5j1g48k5q2pjtwuosgmjkw1jo82ix	NTUzNTk0MWYxODZmMWFhZTcyOWUzMzg3YmU2ODNhMWM1ZGE4NDRiMDp7InVzZXJpZCI6MTE4LCJ0YXNraWQiOjh9	2018-09-03 19:06:34.63159-05
c08x3pgd9udcumw9768n1uyb1ft3jjiy	ODA5MTYzMzQ4NjM4ZmI2MjUyZTE2ZWU2NGQxNjA2YjVkMWY0MDliZjp7InVzZXJpZCI6MTQ4LCJ0YXNraWQiOjE1fQ==	2018-09-03 15:25:43.864998-05
hx4gj58z11k3n82ivo3mcuhrazth2q35	MGZlYjZmZTg4YTljODYyNjAzNGIxMjJiMjNlYmMyY2I1NmU3ZDg1Yzp7InRhc2tpZCI6IjEiLCJ1c2VyaWQiOjEyNn0=	2018-09-03 11:53:20.146902-05
pn1z92smfkt9xe1ybsze6gtbbj7xt36w	ZDhkMmY0NDU5NWRjMTk2MzMwZmE3M2U4NTVjNzRkOTFhYzc5M2NkMjp7InVzZXJpZCI6MTM3LCJ0YXNraWQiOjExfQ==	2018-09-03 14:07:02.925294-05
c0gya6pqmio888jtljrq5plvlovyi5gh	NTZkMGFlNjVhYjg1Mjc2ZDAxNzViOTFjMTE3ZWIzNDk1YTkyYjVlMjp7InVzZXJpZCI6MjE3LCJ0YXNraWQiOjEyfQ==	2018-09-04 03:46:50.151532-05
dt0j0qftylbk5y8a29baieq2bcoqcvw3	OGEzNjQyNGU5YWZkMjAwZjIxYjlmMzczZmViN2IzYmEzNTYwNDY3ZDp7InVzZXJpZCI6MTA5LCJ0YXNraWQiOjN9	2018-09-03 16:30:04.893114-05
idea94pwe7r486826w81fl11ay15vfpa	YWY5ZGY5MTI5MjNmNzkxZDZjOWUzMWUwNDAyMjVmZGVhMmFkOGNkNjp7InVzZXJpZCI6MTQ2LCJ0YXNraWQiOjE1fQ==	2018-09-03 15:15:28.261432-05
tgdvntgxd2s8tmnlkblx1znqffpij8rp	ZDQ2ZmNiZjJkNzU5N2QyMmZjYmViNWUzMDY3ZjMyYjM1YWRhMjZiNTp7InVzZXJpZCI6MSwidGFza2lkIjoxfQ==	2018-09-03 13:15:46.452691-05
9ctv868xy63ljsymfwbqs74knjuu1met	OTgzM2Y2Y2IyOTIzNGY2MzNlNDY0OGY2MzE1ZGI2M2Q5NDEzMTFkYTp7InVzZXJpZCI6MTQ3LCJ0YXNraWQiOjE2fQ==	2018-09-03 14:13:15.992406-05
qzr8wvlvg6wg55o1evrwct2y6o9vc6dr	ZTI0Y2U0ZmEwNTE5MTUzMzMwZjUxYzliZTM2NmJiZmNmMDFlY2QwZTp7InVzZXJpZCI6MTQxLCJ0YXNraWQiOjd9	2018-09-03 13:59:35.776483-05
o23g0nflfmhcp9eawrat3lut37l4zmy4	NWJlYjgxYzdmMjFjOGExNDZiNWRhYTg2YzAwZTBlZThjZTI0YzBhMzp7InVzZXJpZCI6MTQwLCJ0YXNraWQiOjZ9	2018-09-03 14:05:18.463464-05
lmdo9xf9aaca8vcri20m85isvf94ycut	M2VjMTk4MDQzNGVhOGEzYjQ2NjU1MmMyYTAwMDliYWUyOTU1NTBjMTp7InVzZXJpZCI6NSwidGFza2lkIjozfQ==	2018-09-03 22:04:51.004851-05
drfr2bqygzweuv1l0kb037wvzsiotqjp	OWZjYmMxZTUwMGUxMTFiYWVmN2M0ZThjN2E2YzliYWZkZjA3Y2NjOTp7InVzZXJpZCI6MTM0LCJ0YXNraWQiOjE1fQ==	2018-09-03 13:46:13.234206-05
7pt6hntm8cucb9spwiulc0t4mf1sx6no	M2I4NDg0M2UzNTQ5OGFkNTVlYWRlOTA5Njk3YzAyYmQ1MWZlZjEzZjp7InVzZXJpZCI6MTYxLCJ0YXNraWQiOjR9	2018-09-03 18:53:42.852827-05
c6s39k2icy1i7k0rd8r89jhb8ysf8kkb	MzIwM2I1MTY4ZWE0M2RiMDZmZDczZTlkYzkxNzM3NzZkZTRiNThmNTp7InVzZXJpZCI6NywidGFza2lkIjoxMDAwfQ==	2018-09-03 22:49:10.757033-05
4kms36y1gkmvbbczb2620lpusbm8oby2	ZTIxMmRiOTJlNzE0ZjdiNjQxNmFjY2JhZjY1MTk1ODM5YjAyNWQyNTp7InVzZXJpZCI6MTQ4LCJ0YXNraWQiOjZ9	2018-09-03 15:41:24.854258-05
jfv70dwsrakxhgyhpbvmps65rzj7b96d	MjU0M2RmYjBmNGRmOTVlMTBiNTJjZGE4NmYwMGM3M2E2OTJkMGRkZTp7InVzZXJpZCI6MTI3LCJ0YXNraWQiOjEwfQ==	2018-09-03 13:22:58.552343-05
3xtwvee9n6be9n7gcximjwtihsov7c5e	NDZkNzk2MWJjMDAyOTgxZmU1Mzc1MDUwNWI5Yzc5ODQzODNmZjcyNzp7InVzZXJpZCI6MTMyLCJ0YXNraWQiOjJ9	2018-09-03 14:21:15.262612-05
8dhoyabywq7osmdr5d3ev16t8u0qjvz2	MTVjYmM5OGZmOWYxMDZmNGZlMjg2ODg3NDAxNTlhMjZmMmQ4YzYzNTp7InVzZXJpZCI6MjA5LCJ0YXNraWQiOjE1fQ==	2018-09-03 23:17:28.78873-05
ymk9lxtskua74t7bm7ilg1a6819ewzp3	OGE3MmNiN2I1OTQ4MGYwNTI4MDdhNzMyZDUyMzIyYjQzYTY1MDU1NDp7InVzZXJpZCI6MTMwLCJ0YXNraWQiOjd9	2018-09-03 14:47:51.692419-05
82i0kdeo53vayunazavuvodizp00wolc	ZjhmYTQwYjMwNGIyN2RmZmNjNDVlYTBhNjZlNzVjNjg5ZThjZjA3Mzp7InVzZXJpZCI6MTUyLCJ0YXNraWQiOjEyfQ==	2018-09-03 15:47:13.338801-05
3seo4wixoo9gobnxgxk56sdj7nftbgdg	YWEyMzVhM2JkYzEzZWVlMmU0YTkwOWMwYzY4MTdlOTQ4MzY4Yjc2Yjp7InVzZXJpZCI6MTI5LCJ0YXNraWQiOjV9	2018-09-03 13:32:48.56491-05
xoahsgzi66pf6pidq1gsto96nsajp9x6	N2Y0MjBhZmU4YzVlMThmNjA5NTdiMmU4YzdlZjliZGRjOWI4NzlkZjp7InVzZXJpZCI6MTQ1LCJ0YXNraWQiOjd9	2018-09-03 14:28:24.155468-05
7xvc4zwd7dhjf3sgylvecihmj8738uw8	NzI0YzQ4NGFjNDU2ZDRhMGYzNjE2ZWQzNzA5NDNkYWZmODZkNjQ1Yzp7InVzZXJpZCI6MTM5LCJ0YXNraWQiOjd9	2018-09-03 13:57:59.809059-05
9lhf9z2j8s6fvx8kdnys1npek51n43xg	NGFiZGI1N2QxYzljY2M1ODVkMzFhNmIyYTIxMGEwYTc0ZjUxNjZkMjp7InVzZXJpZCI6MTU1LCJ0YXNraWQiOjZ9	2018-09-03 18:16:22.996391-05
3mt3jzeraq8ivhj714jlyh18c2s6xrgg	MmJkOWQ3MzU1NjkzNzcxOTlmNmZhMGMzOWIzZGVkZWVmYzBhZmI0NTp7InVzZXJpZCI6MTcwLCJ0YXNraWQiOjJ9	2018-09-03 20:57:34.270417-05
no5n9dijwhv46xrlf4awkn51detgc9k5	MzU1YzI2NDM0NmFjNjhlMDdhZjY2OTg4OGJlNzNiMDJhMzNlMThhMjp7InVzZXJpZCI6MTY0LCJ0YXNraWQiOjEwfQ==	2018-09-03 20:18:43.494635-05
n1cz67a78m2duiq96fxlitbw0dybeys1	ZGUxYjcyYTg0NjNlZTE1MTVmNTBjMTk1ZDRjYjhkODI3Yzg3YTkyZTp7InVzZXJpZCI6MTMzLCJ0YXNraWQiOjh9	2018-09-03 14:09:14.990516-05
1q557jl5e66tsmiae6rmy4aofydi7c29	MTZlYjI2YzhhNjA3N2FiZDQyMWI0ODU1N2Y5MjdiNGM5MjkxYzZjYjp7InVzZXJpZCI6MTQ5LCJ0YXNraWQiOjE0fQ==	2018-09-03 14:52:47.852539-05
pm8ldwcp3wttqyq2pbfha8iopeujv59x	ZTIxMmRiOTJlNzE0ZjdiNjQxNmFjY2JhZjY1MTk1ODM5YjAyNWQyNTp7InVzZXJpZCI6MTQ4LCJ0YXNraWQiOjZ9	2018-09-03 15:51:24.932641-05
8sqkdta2ktuuzbdsk1k857e3iqthcehl	ZWI3ZjY3MGZiOTI4NzgxNDBjZmMxZjkwODA5NTk3YmM2M2FhM2Y2Yzp7InVzZXJpZCI6MTM2LCJ0YXNraWQiOjN9	2018-09-03 13:50:11.423869-05
a7eor1oflv0gxt77azpqhw9ryikm35jw	NDRhOTdjNzk4NGM2ZjczZjIzMTAxODY3ZDZkOGZkYmFhZTM4ZDhlZjp7InVzZXJpZCI6MTQzLCJ0YXNraWQiOjR9	2018-09-03 14:10:09.22857-05
w4ledu8jynzjrrcqhj0f44ubw28lo8n4	NzhhYTRjZGM2ZTc3NDRhYTQ2YjAwOGMwZWE5ZDdiZjFmMmM5MjQxNzp7InVzZXJpZCI6MTc2LCJ0YXNraWQiOjJ9	2018-09-03 21:36:24.148877-05
rup3cpkiox7skl91hh6o1oge7g2s1cl7	OTg4MzZmM2E5NjFlOTA5MDk3MDM2YmNiYmY1ZWE4MjYwYjRiN2I2Mzp7InVzZXJpZCI6MTI4LCJ0YXNraWQiOjl9	2018-09-03 13:28:23.859132-05
6hjvd10lgjg1ru2uv04pycawfryr5v46	N2FjNWRkODJlZDBmYmQyODZjZTZkNDYzNGYzZWNmNGRhNTZkMmJjMTp7InVzZXJpZCI6MTQyLCJ0YXNraWQiOjl9	2018-09-03 13:51:29.660239-05
68a0dgcfesgqz8ojexg6q3dddr0lxj1o	ODA5MTYzMzQ4NjM4ZmI2MjUyZTE2ZWU2NGQxNjA2YjVkMWY0MDliZjp7InVzZXJpZCI6MTQ4LCJ0YXNraWQiOjE1fQ==	2018-09-03 15:23:55.794695-05
syz0uhdo73snkeli1eme86lrwyzrblkz	ZDlhYjQ5ZDMyMWRlNjFjNzY5ODUzNmExYjUzZTI0MDM0NmY1MWEzMjp7InVzZXJpZCI6MTMxLCJ0YXNraWQiOjE1fQ==	2018-09-03 14:13:37.58783-05
ld4xknqcca68fxv7vgj5ohkksvzcx6pz	Y2QxOWI1MDRkYjMzODFjMTM4OTJhMTVmMGQzYzMxYmNiZGM3ZGNhNDp7InVzZXJpZCI6MTM1LCJ0YXNraWQiOjJ9	2018-09-03 13:36:12.479381-05
lq3uvy9vg5ntx2n9w0nd8n79dj7v6pkf	MGFmOTE1MDIwODc4ZWM1MzJlYTI0YTZlMmFkMWNmYWViOWYyMmQ1MDp7InVzZXJpZCI6MTY3LCJ0YXNraWQiOjE2fQ==	2018-09-03 20:23:26.596336-05
x4f4dygcv4h1ebbet60cbxavlhrcshq4	NTJhZDk2YjhiNmYxZWZmNmZmMzkxYWU0NGQ3N2ZmZWUxYTFlYjY4NTp7InVzZXJpZCI6MTYyLCJ0YXNraWQiOjV9	2018-09-03 19:50:16.46455-05
c0pas11n01laur4tdn1db1ll3bydu2gp	MTI0ZWMwNzkwMGNlNzgzOWUzYzFjMDRjNjJlMDE3ZmU0NGE1NTkzODp7InVzZXJpZCI6MTU4LCJ0YXNraWQiOjExfQ==	2018-09-03 19:01:05.714347-05
3hwsjikc077kd2pgo1no21k6ucpultl8	YTE3NDczYTE5YTMxMzliOWY5YjcyMTk4N2E5MmRmZmZjNzhjZTA3Zjp7InVzZXJpZCI6MTY1LCJ0YXNraWQiOjV9	2018-09-03 19:51:32.574645-05
k6iqpdkzgybw2ydp0q4uk3io8fvx60vz	NDQ5MDI4MmFlNDdhYTUwOTc2MzRjYmZjNjNmMDFiNzcyNWZiYWQ5ZDp7InVzZXJpZCI6MzIsInRhc2tpZCI6MTF9	2018-09-03 15:26:05.489737-05
mqwwifi88gfkt2ygcoc12mrwbmz5xuqj	ZGQxMTBhYjFiMzRkY2VmODg2ZjAwOGE5MzhlYzUyYTIzNzYwOWNmNDp7InVzZXJpZCI6MTM4LCJ0YXNraWQiOjd9	2018-09-03 13:37:42.36036-05
qj228bh4xlyluu51obiumlqpxv7cos1n	ODk3ZTQ5ZDVhZjg1YmRhNjc2NDY4NWM4MWFmMDM2MzcwZDE1NjY0ZDp7InVzZXJpZCI6MTQ0LCJ0YXNraWQiOjd9	2018-09-03 13:43:22.969384-05
erbu2e1n80x5v10rugmja3g2zwwiyn2b	MzIwM2I1MTY4ZWE0M2RiMDZmZDczZTlkYzkxNzM3NzZkZTRiNThmNTp7InVzZXJpZCI6NywidGFza2lkIjoxMDAwfQ==	2018-09-05 14:44:51.663388-05
218lpuy7w8uyg9by63gkiga6m6donw91	MGIxZGM3MDY4NzRiOGI2YjhhNGY3MTg5MTMxMWFkYWU1NjkxMWE0Yjp7InVzZXJpZCI6MTU2LCJ0YXNraWQiOjE0fQ==	2018-09-03 19:02:02.240083-05
svima8aonqau3gpqs23bqpscotdktboz	Y2I4NjhjNWNkOGQ3ZDAwMWFlZmI2YTM4MjUwZjczMjA5MmFjYTU2YTp7InVzZXJpZCI6MTU0LCJ0YXNraWQiOjEyfQ==	2018-09-03 16:20:21.493902-05
s37xupjficqesvwdewoytyvr3n8mhwgs	NTYxZTg3ZjhmMmY2YmYzYTcxN2E4MjBkYjcwNTVlYWI2YjZhOWY4MDp7InVzZXJpZCI6MTYwLCJ0YXNraWQiOjExfQ==	2018-09-03 19:57:13.5213-05
eptqsh0w7mxiq8247p50abm80matsvya	ODY3MjViM2UwYWNkODMwOTdkZDg4OWViYzMwM2UwYjYwZGVjNGE2ODp7InVzZXJpZCI6MTUxLCJ0YXNraWQiOjEwfQ==	2018-09-03 15:30:43.428502-05
6sw82uut88flbbcan51kt9kzppm55g23	MzIwM2I1MTY4ZWE0M2RiMDZmZDczZTlkYzkxNzM3NzZkZTRiNThmNTp7InVzZXJpZCI6NywidGFza2lkIjoxMDAwfQ==	2018-09-03 17:43:31.074409-05
z43sea0fm1mlzyysoyyto6qli9ufbp76	NWU0ODY3NDZmODQ2MjAwMTgzNWI1ZWU1ODc4YzIxNWI4ODcyNjBkNzp7InVzZXJpZCI6MTUwLCJ0YXNraWQiOjEwfQ==	2018-09-03 15:36:23.282896-05
70h4zinmab2cctd92e0pu4n2wa6dpie8	MmZhZThmODQ4NTNkMTEyMjExNTE4N2JiOThiZGM3NzQxZTBlODNjOTp7InVzZXJpZCI6MTY2LCJ0YXNraWQiOjE2fQ==	2018-09-03 19:36:45.13516-05
b8hsoq2w82u95fx1yfuvk5ppeuxt08vr	YjhhYmFmOTJmODIyZmQ2MDQwNTdlNjNjOWY0NWIxNDBmODI0NjA2ODp7InVzZXJpZCI6MTUzLCJ0YXNraWQiOjd9	2018-09-03 15:39:52.913773-05
ava0q5fkew435nale7v3mghl0ngzbt4v	NGZkZDZlZWZmMjNiMmJjNTA0ZjhiZTAyYzQ5NmU0ODViZmMxNjk0Mzp7InVzZXJpZCI6MTY4LCJ0YXNraWQiOjZ9	2018-09-03 20:39:29.853828-05
h8zwe8smqvejkyc7zo7y79h6qzl7u1f8	MzllNzQ0NjViMGUzMzhkNjBiYzgzZDU1N2RhODIxNTVjNGYyMDg5ODp7InVzZXJpZCI6MTYzLCJ0YXNraWQiOjl9	2018-09-03 19:38:23.716614-05
w6t2rm0cer1th9usi9ck9qo1ai63pw5z	MTBiOTBiZGZhNzUxZjY2YTgzY2NkNmJjZjFjZDYxN2NjNmU0MGVjNTp7InVzZXJpZCI6MTU5LCJ0YXNraWQiOjExfQ==	2018-09-03 19:20:05.6898-05
y6qdcvysyidsqv7j7qjfldv4b5nkaccu	ZmE0N2JhMjhiNjE5YWM3OGJmYzUyZWZlMWVkZTY5NDRjZTMyODMxODp7InVzZXJpZCI6MTU3LCJ0YXNraWQiOjE0fQ==	2018-09-03 18:52:43.291745-05
a8cl1u3l24i2eqj1lrkc0b8qnw4nspyo	MjUzZTBmMTEyNGIxYjZhM2Y3MTk1Njk4YWYwNmI0ZDhhNmYyNDQ5MDp7InVzZXJpZCI6MTk1LCJ0YXNraWQiOjZ9	2018-09-03 22:25:32.553406-05
3ipcywvezxt2bome5njoh5qmn9hiq8jk	OWUzNmMwNGJmNzYzMGRlMGM4NGQ2MjM2MDYxZDNmZmQ1NWUxOWVkMzp7InVzZXJpZCI6MTkwLCJ0YXNraWQiOjh9	2018-09-03 22:25:57.833909-05
eb42i83qu1ym14yodrehubye83qg2l3u	NmE3OGNhNmYxYWQ3NDU5MjAyMGM1ZDE0YzJjNDM3MjQwYmNjNjg2ZDp7InVzZXJpZCI6MTgxLCJ0YXNraWQiOjd9	2018-09-03 21:10:14.827408-05
63i97wc354tycskbckpdv4uu9xoq23jo	ZDA3YWNkZDIzOTBiZWRhYTY3NjMzZTRlYzI2YTk1OTQ3YmQ1NDE4Mzp7InVzZXJpZCI6MjE0LCJ0YXNraWQiOjl9	2018-09-04 02:56:02.495087-05
3tzfelhqy3lur2brf93esf0ukktk95ui	NzA0MDdhMzAxYjIxODlmNDU2ZDhkMDU3YWFjY2RlZjY3NjgzMTJjYzp7InVzZXJpZCI6MTgwLCJ0YXNraWQiOjE2fQ==	2018-09-03 22:02:02.985836-05
mz4qy8dl59gtd9ybm51so9y3aqcv3vb5	ZjEyOTU0ZDEyNmQ4YTllMDVmZWMyZmQyZWFhNzUzYmNkYWU0OGFjMzp7InVzZXJpZCI6MTg0LCJ0YXNraWQiOjh9	2018-09-03 21:40:45.629796-05
wuyyn3x23h9h1xaih21mr74ic9ksxgma	MmEyMWRiNDA4MDA3MDY3YWVlYjM1ZjJmYTNhM2U2YjEyMzBhZWNkYTp7InVzZXJpZCI6MTkyLCJ0YXNraWQiOjZ9	2018-09-03 22:02:52.07797-05
317atro5uf8xw8fv3wlgnes2xtmh9k2z	YmRlM2M0OGI3ZjU4NzcxMjcwNjJhMjJkYTliMzY3YWFkMjAyM2VlZTp7InVzZXJpZCI6MTgzLCJ0YXNraWQiOjE2fQ==	2018-09-03 21:34:04.570028-05
bg9im93hblzl6ycxcnz5v4mekycgsllj	NDRhMTMzZGQ2NDNjNTQzNDJjZGY2NTNkZjZhZmQ1Y2Y1ZTdhNmUwZDp7InVzZXJpZCI6MTk0LCJ0YXNraWQiOjEyfQ==	2018-09-03 22:03:17.982706-05
3gsp418yrdpokugf5c98bf1kn10xvw09	MzZiM2RjMmVhOWE5NGM5MjFkZjZmOTdlOWZmMTczMjgwZmU5NzcwYjp7InVzZXJpZCI6MjAxLCJ0YXNraWQiOjE2fQ==	2018-09-03 23:15:13.587103-05
c7fco8lnamdqlig220tn0wmoosx0thqe	OTBhNjcwYzM4ZjE2M2MzNWVmZDhlNWU2ZmVjZmY2ZjRkMGI3YzMyODp7InVzZXJpZCI6MTg4LCJ0YXNraWQiOjE1fQ==	2018-09-03 22:03:25.907525-05
gryuz3401xr9ea4iedn1hyoy22p90c0u	NjQ0YzI4Yzc2NWYzMWNjOGY4MDkyYjJlMDdiYWY2MDhhZDg5MzI4NTp7InVzZXJpZCI6MTk5LCJ0YXNraWQiOjExfQ==	2018-09-03 22:49:31.714861-05
jbdc0a1lyeu8dzz7lseshoozrpdyw6pe	MDY2MjExZDU0YWJjYmE0NmYwNDZjOTI4Mjc3MjU1OTQ4ODlkM2M1Njp7InVzZXJpZCI6MTkxLCJ0YXNraWQiOjE2fQ==	2018-09-03 21:41:54.015082-05
m3v7iuyfcu50xa3fmbxg9faswvu81zav	MTJkZDIyOTA5ZGE0YzBiODE3OGVlYWEyMWI4MjA0OWVkZGQ5MWYwNDp7InVzZXJpZCI6MTc3LCJ0YXNraWQiOjE0fQ==	2018-09-03 21:26:47.051112-05
0t1gqopizsvmpimb9cfeojgq1vn38tkz	NTY0MGQyZWU0MTMxMTczNmNmMzljN2QwMTkzMDA4OThjMTIxNjk0Zjp7InVzZXJpZCI6MTc1LCJ0YXNraWQiOjR9	2018-09-03 21:34:56.964678-05
780x13c6w32ji3ref0ihbzbdyq0upejn	MzNjYWUzNjkwZjA5MzM0YTI3NmJkMGRkNDllY2I1YzYwZDM0YmEyMzp7InVzZXJpZCI6MTcyLCJ0YXNraWQiOjE1fQ==	2018-09-03 21:12:50.566372-05
mk8rcivlzyieffmpnneg7rq3hnyqjzid	MmRkNmJmMTE4M2QwOWZmZGNkZjA4M2NhMDczY2U3NmM4NGJlYTliZjp7InVzZXJpZCI6MTc5LCJ0YXNraWQiOjEyfQ==	2018-09-03 21:53:32.632809-05
mwcczmdhe55lnoklxdqqp8gooh6d5j3c	NGNiMGM2YmIwMzAzNDg0NzBmNTIzNzczZmM3MDdjMDcxZjVhMTM4OTp7InVzZXJpZCI6MTcxLCJ0YXNraWQiOjR9	2018-09-03 21:05:23.727885-05
kh769tpwtadqu5qiya2uevchfl7fam9s	Y2VkYzA0MjZlM2VlMjA1YmM3OWYyNGQ2MTc1NDQwMjNlNzZkZjA1Mzp7InVzZXJpZCI6MjAyLCJ0YXNraWQiOjExfQ==	2018-09-03 22:50:55.002602-05
uqjjntgbbycbka6ptkk2n4kpsucz20jc	ZjYxODhiNWNiYmJhZTkxZDY5ZDYwODhmOTM3OWU2N2JlNjhmYzEyNTp7InVzZXJpZCI6MTg1LCJ0YXNraWQiOjJ9	2018-09-03 21:27:35.88569-05
hd66zdmfm2e3cxofj2kawjvysk2fskyr	NWIxMTE0NDBhMzUzZmExOWZmMDE1N2FlYmFhYWQxNDJlNGI2N2I4YTp7InVzZXJpZCI6MjA4LCJ0YXNraWQiOjd9	2018-09-03 23:16:30.069855-05
wmkwdlhpumtxddtykazfln56be5ra1fz	YTY1Mzk5NTBkM2FhZWRkMjk3NTg0NjFiZDUyYTliOGY4NDkzMDdiZDp7InVzZXJpZCI6MTc4LCJ0YXNraWQiOjExfQ==	2018-09-03 21:27:40.812334-05
1jys8wdiwcgukqesa2j9wry45526moob	ZjE0ZTRmYTQyZjM1MGU1YjQ5YmFmNDdmYjQ2N2MyZjJjYTdlOTE0ZTp7InVzZXJpZCI6MjEzLCJ0YXNraWQiOjE0fQ==	2018-09-04 01:09:59.37372-05
ez0v72h4v2stw55v6ji670su2l4ffvyf	ODQ5NjUwOTJkMDZlNmI0ODViOTllMDMwMDExZTZiY2ViMzc4M2E4NTp7InVzZXJpZCI6MTgyLCJ0YXNraWQiOjl9	2018-09-03 22:09:05.307001-05
b9ipln62knmklf4507rtv1nyfndkwooc	N2U5NDQ2NGU3NTEyYTQxMTdmMmEzMGJkZDQ3YWNjOTE3YzY0ZDRmZDp7InVzZXJpZCI6MjAwLCJ0YXNraWQiOjEyfQ==	2018-09-03 22:09:35.722054-05
wq8q3j4xpxsb3m9is004yaxxa5lf9r6x	NjRjM2EwMjIyYzM5NGQ3YzJjYTQ3ZDk0MDkxYmQzMWY2MjVjNGU4NTp7InVzZXJpZCI6MTg5LCJ0YXNraWQiOjh9	2018-09-03 21:54:22.062673-05
v6xmxrgnhllr2y4cc3nu84o9eapfldi4	OWUyYTI2YjFkOTk3OWIzMzkwMDY4YjZiZThkNWEwNTk1Y2IxYTUzMTp7InVzZXJpZCI6MTk4LCJ0YXNraWQiOjEyfQ==	2018-09-03 21:44:31.894698-05
jft01zvrpxlnoruzenp2o1lfytz523wf	N2U2MzlmODkyNTMyODMxYzIxODYzZjc2MjIzZDk3M2IzMjBmNDEyMzp7InVzZXJpZCI6MTczLCJ0YXNraWQiOjE1fQ==	2018-09-03 21:07:55.87915-05
z31zro380ups0m95qqwmxhet8boefaqo	NTc1NjQ0MTMzODhjZTdiZDZhMzVmNmIxZDk3NTEyOGQ4ZjAyMzY1Njp7InVzZXJpZCI6MjA3LCJ0YXNraWQiOjZ9	2018-09-03 23:20:58.893793-05
07rbemineup5y28wtnuorcboi1hp3efp	MzI1NTFhNzIyMWIzOTEyNTIxZjBhNzY0YzkwNDMzNGIyMjAwNWFiNTp7InVzZXJpZCI6MTg2LCJ0YXNraWQiOjJ9	2018-09-03 22:42:55.984641-05
imhqlkqffyhre310qqw0dzoen29lgi0j	NTkzNTBkNmVhMWRlYzViZDJkNWExYjk1Yzg4ZTExM2U3NDgwOGU1ZTp7InVzZXJpZCI6MTk2LCJ0YXNraWQiOjR9	2018-09-03 22:55:12.451719-05
d13tsrx0fg0sqn9dpc2tg4er82y7kyh4	ZjdjY2UyYmQzNzQwNWIwYmVhYTYyZjVkYzdjNzc5ZTNkNWEzMTE0Njp7InVzZXJpZCI6MjA0LCJ0YXNraWQiOjEyfQ==	2018-09-03 23:24:03.696667-05
e7mcf15s4mfgjw8p2qd5sacw6u1ux434	MTRlZTI2MTA2MjQwNDZhZDdhNGYyMTY5MTUwYjlmODU4OTA1NDViYTp7InVzZXJpZCI6MjE2LCJ0YXNraWQiOjE0fQ==	2018-09-04 03:43:30.771553-05
lmtkyati0v5q4nxe79yxdzxqnd7wvyoe	YzY4NDRjMTc0ODI3MDliNzU3YjUyNDVkMjAzOTAxZmFkMTlmZmY0Yjp7InVzZXJpZCI6MSwidGFza2lkIjo4fQ==	2018-09-04 00:10:03.264291-05
htt1pkv7auoe2u2poyl97snivsgj8jum	ODM3NDNiNWJmNDI2MmI1NDVjOGNiZTM2ZDY3YTlmYTE2YWM5NjIyMDp7InVzZXJpZCI6MTk3LCJ0YXNraWQiOjE0fQ==	2018-09-03 21:57:39.79043-05
z2uwp6qplo66y5kzfkr4uzgd5znmy8oq	M2ZlZjg0ZjQzOTI1YjU4Nzc4YjI2M2UxNWExYjI3NDZiNmM1MjZiNjp7InVzZXJpZCI6MTc0LCJ0YXNraWQiOjl9	2018-09-03 21:24:21.440593-05
5imtu7sitvseuyhr1gtm7xr62az03xt3	MzIwM2I1MTY4ZWE0M2RiMDZmZDczZTlkYzkxNzM3NzZkZTRiNThmNTp7InVzZXJpZCI6NywidGFza2lkIjoxMDAwfQ==	2018-09-03 21:30:37.189165-05
a9jxh5uxoz8e6rrful8iss1tzrbi1mb3	YjNjNjU4OTFkMTUyODJkZWNjNjkxMTE2ZTZlNzFjMTE1ZDZjZDg1MDp7InVzZXJpZCI6MjA1LCJ0YXNraWQiOjd9	2018-09-03 23:07:35.715161-05
ixje3dqqtyqxnw1osfht8vsdapagwfrj	YTlmY2U1NWVjNjRhMTEzMmY1YjRmMzEzMzVjZTgxZGEwYzgyMmI2Yjp7InVzZXJpZCI6MjEyLCJ0YXNraWQiOjE2fQ==	2018-09-04 00:14:30.358138-05
pxzj4iiluftzt2wh0860hm40tkoffu2b	MjA4YmIyYTgwM2ZhYjdjODViNjgwM2IxYzA2ZjNhOTYzMWE4MWVlYzp7InVzZXJpZCI6MjE4LCJ0YXNraWQiOjR9	2018-09-04 05:12:30.24185-05
jmogkl7mqnfobp9opbfmty6v40cj196w	OTgyMTQwMjU3Y2IyZGU3NDQzZGE2OTAyYjhkOGY4ZDAxY2Y3ODBmZjp7InVzZXJpZCI6MTg3LCJ0YXNraWQiOjd9	2018-09-03 21:59:48.749568-05
o62utr00lt745hl5mlao4ljtdub09565	ZDUxZTlhZGJiNWI3ZDhkYjBmOWE0NDcyOGNiM2JhZDdkMTcxMjA1Yjp7InVzZXJpZCI6MjA2LCJ0YXNraWQiOjJ9	2018-09-03 23:37:57.072658-05
ue17fve2g14qvmklaiyylpd02h3mhccj	NWFjYjRjY2M4ZTNjMzE3YWY2ZDY2MDBlMjJlYmNkMTg4NDc4ZmViYTp7InVzZXJpZCI6MjAzLCJ0YXNraWQiOjZ9	2018-09-03 23:40:16.12052-05
kqkau8yuyu9mimpxm967n7a32lt7iicd	NzJhNDJhOTA3Njg5MzY0ZDYzZTcxMThmNDUxM2VmZDA3ZGQ5MzVkNzp7InVzZXJpZCI6MjExLCJ0YXNraWQiOjExfQ==	2018-09-04 00:20:50.511328-05
iya17u7yf815j3zzimmqhf31x0cfrq7r	Yzk5ODY0ZTk3MmVmMzM4M2QyMmZkMzQ4NGNmMDcxYzY4YjkyNzc1MTp7InVzZXJpZCI6MTkzLCJ0YXNraWQiOjh9	2018-09-03 21:49:15.984571-05
sep2gzfpj0uo2m62k1le8672xxi9oz4x	NjFlYTIyYTRhZDZlMTBhYzBmOTJkOWE4ZDhjMWRkNTM0YTA5MGVkODp7InVzZXJpZCI6MjE1LCJ0YXNraWQiOjh9	2018-09-04 02:25:55.900229-05
lsj21xedvjss8mpdnygu848gxi6a4rsi	YzRhZDY1YmUxYjM1OTRiNGI1YjhjNGQ3OTU3NGEwZGI1YjRhYTE5MTp7InVzZXJpZCI6MjEwLCJ0YXNraWQiOjEwfQ==	2018-09-04 00:33:43.350142-05
v7evs2nl2p6jlor7643k2cmr421kc4g4	ZmY2NzkzNTRhMjE5ODZiNzExZjZhMDhlOTc4Yzk5Y2M1ODY0ZDAyZjp7InVzZXJpZCI6MywidGFza2lkIjoxfQ==	2018-09-05 14:46:52.435755-05
yq2bwlxh2nuh3pe12y0vnpfbkx4666zw	YmRjNzkxZTdlYzliZWZiNmJiNGU5ZTM1YzczZTRkZjUxYmQzMTAxMjp7InRhc2tpZCI6MSwidXNlcmlkIjoxfQ==	2018-09-13 13:58:38.712206-05
bx32ae1pd3a1ftjdiew5e7uycbrqgjzs	NjMxMjQ3ZjZjYjg1NjFhNDJjNmRmNWNjMWQxOWRkZTcyYjAzZmM1ODp7InRhc2tpZCI6MSwidXNlcmlkIjozfQ==	2018-09-25 14:58:45.200414-05
roba2io1pmw6u3dr3xbto6szqskzcq58	NjMxMjQ3ZjZjYjg1NjFhNDJjNmRmNWNjMWQxOWRkZTcyYjAzZmM1ODp7InRhc2tpZCI6MSwidXNlcmlkIjozfQ==	2018-09-25 14:58:45.282356-05
o1gusxorf2a0ekodn9l00k0hbb1usa96	NjMxMjQ3ZjZjYjg1NjFhNDJjNmRmNWNjMWQxOWRkZTcyYjAzZmM1ODp7InRhc2tpZCI6MSwidXNlcmlkIjozfQ==	2018-09-26 13:54:50.702593-05
gb45lys6cf2h0eawwye158517eqs3zyo	NjMxMjQ3ZjZjYjg1NjFhNDJjNmRmNWNjMWQxOWRkZTcyYjAzZmM1ODp7InRhc2tpZCI6MSwidXNlcmlkIjozfQ==	2018-10-09 12:22:40.171559-05
tyn9n2uajixum17ir1ttjf24rxrp9wlg	ZmY2NzkzNTRhMjE5ODZiNzExZjZhMDhlOTc4Yzk5Y2M1ODY0ZDAyZjp7InVzZXJpZCI6MywidGFza2lkIjoxfQ==	2018-10-15 14:54:10.936467-05
or6ca0ojqiiw6uvw7it2h6r2bfk2tks4	ZmY2NzkzNTRhMjE5ODZiNzExZjZhMDhlOTc4Yzk5Y2M1ODY0ZDAyZjp7InVzZXJpZCI6MywidGFza2lkIjoxfQ==	2018-10-18 13:20:05.983827-05
y5gmvwfuxfwbaqdin1sqetaruwe0cf5f	NjMxMjQ3ZjZjYjg1NjFhNDJjNmRmNWNjMWQxOWRkZTcyYjAzZmM1ODp7InRhc2tpZCI6MSwidXNlcmlkIjozfQ==	2018-10-22 15:01:30.537599-05
5824h7kk0horkoir89rso3a66xovv7cn	YmRjNzkxZTdlYzliZWZiNmJiNGU5ZTM1YzczZTRkZjUxYmQzMTAxMjp7InRhc2tpZCI6MSwidXNlcmlkIjoxfQ==	2018-10-22 16:18:14.110556-05
uimy932gvll1t49n0v2ejjnqqsyk7b7y	YTU2YWJhZWNmZTEyNDhjNDU2MmVhMzE3OTAzMDU0OTAzMTE5NDJlZDp7InRhc2tpZCI6MSwidXNlcmlkIjoyMTl9	2018-10-22 16:45:58.638107-05
7vghk17wu4bohse1hmz9dvosj4geu24l	MzIwM2I1MTY4ZWE0M2RiMDZmZDczZTlkYzkxNzM3NzZkZTRiNThmNTp7InVzZXJpZCI6NywidGFza2lkIjoxMDAwfQ==	2018-10-24 15:00:19.110878-05
8moq0onlherw22vt70tv24a92ns9voas	MmUwNjY0NzJmY2E3MmFmYjhjOTYwNTExMzU1MjlhMTM4ZjQyYTJjNDp7InRhc2tpZCI6MTAwMCwidXNlcmlkIjo3fQ==	2018-10-29 11:03:17.973549-05
\.


--
-- Data for Name: rule_management_abstractcharecteristic; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.rule_management_abstractcharecteristic (id, characteristic_name) FROM stdin;
\.


--
-- Name: rule_management_abstractcharecteristic_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.rule_management_abstractcharecteristic_id_seq', 1, false);


--
-- Data for Name: rule_management_device; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.rule_management_device (id, device_name) FROM stdin;
\.


--
-- Name: rule_management_device_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.rule_management_device_id_seq', 1, false);


--
-- Data for Name: rule_management_device_users; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.rule_management_device_users (id, device_id, user_id) FROM stdin;
\.


--
-- Name: rule_management_device_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.rule_management_device_users_id_seq', 1, false);


--
-- Data for Name: rule_management_devicecharecteristic; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.rule_management_devicecharecteristic (id, abstract_charecteristic_id, device_id) FROM stdin;
\.


--
-- Data for Name: rule_management_devicecharecteristic_affected_rules; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.rule_management_devicecharecteristic_affected_rules (id, devicecharecteristic_id, rule_id) FROM stdin;
\.


--
-- Name: rule_management_devicecharecteristic_affected_rules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.rule_management_devicecharecteristic_affected_rules_id_seq', 1, false);


--
-- Name: rule_management_devicecharecteristic_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.rule_management_devicecharecteristic_id_seq', 1, false);


--
-- Data for Name: rule_management_rule; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.rule_management_rule (id, rule_name) FROM stdin;
\.


--
-- Name: rule_management_rule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.rule_management_rule_id_seq', 1, false);


--
-- Data for Name: st_end_device; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.st_end_device (id, device_id, device_name, device_label) FROM stdin;
\.


--
-- Name: st_end_device_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.st_end_device_id_seq', 1, false);


--
-- Data for Name: st_end_stapp; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.st_end_stapp (id, st_installed_app_id, refresh_token) FROM stdin;
\.


--
-- Name: st_end_stapp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.st_end_stapp_id_seq', 1, false);


--
-- Data for Name: user_auth_usermetadata; Type: TABLE DATA; Schema: public; Owner: jessejmart
--

COPY public.user_auth_usermetadata (id, user_id) FROM stdin;
\.


--
-- Name: user_auth_usermetadata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jessejmart
--

SELECT pg_catalog.setval('public.user_auth_usermetadata_id_seq', 1, false);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: backend_binparam backend_binparam_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_binparam
    ADD CONSTRAINT backend_binparam_pkey PRIMARY KEY (parameter_ptr_id);


--
-- Name: backend_capability_channels backend_capability_chann_capability_id_channel_id_131031e1_uniq; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_capability_channels
    ADD CONSTRAINT backend_capability_chann_capability_id_channel_id_131031e1_uniq UNIQUE (capability_id, channel_id);


--
-- Name: backend_capability_channels backend_capability_channels_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_capability_channels
    ADD CONSTRAINT backend_capability_channels_pkey PRIMARY KEY (id);


--
-- Name: backend_capability backend_capability_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_capability
    ADD CONSTRAINT backend_capability_pkey PRIMARY KEY (id);


--
-- Name: backend_channel backend_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_channel
    ADD CONSTRAINT backend_channel_pkey PRIMARY KEY (id);


--
-- Name: backend_colorparam backend_colorparam_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_colorparam
    ADD CONSTRAINT backend_colorparam_pkey PRIMARY KEY (parameter_ptr_id);


--
-- Name: backend_condition backend_condition_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_condition
    ADD CONSTRAINT backend_condition_pkey PRIMARY KEY (id);


--
-- Name: backend_device_caps backend_device_capabilit_device_id_capability_id_690d9551_uniq; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_device_caps
    ADD CONSTRAINT backend_device_capabilit_device_id_capability_id_690d9551_uniq UNIQUE (device_id, capability_id);


--
-- Name: backend_device_caps backend_device_capabilities_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_device_caps
    ADD CONSTRAINT backend_device_capabilities_pkey PRIMARY KEY (id);


--
-- Name: backend_device_chans backend_device_chans_device_id_channel_id_d581e087_uniq; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_device_chans
    ADD CONSTRAINT backend_device_chans_device_id_channel_id_d581e087_uniq UNIQUE (device_id, channel_id);


--
-- Name: backend_device_chans backend_device_chans_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_device_chans
    ADD CONSTRAINT backend_device_chans_pkey PRIMARY KEY (id);


--
-- Name: backend_device backend_device_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_device
    ADD CONSTRAINT backend_device_pkey PRIMARY KEY (id);


--
-- Name: backend_durationparam backend_durationparam_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_durationparam
    ADD CONSTRAINT backend_durationparam_pkey PRIMARY KEY (parameter_ptr_id);


--
-- Name: backend_esrule backend_esrule_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_esrule
    ADD CONSTRAINT backend_esrule_pkey PRIMARY KEY (rule_ptr_id);


--
-- Name: backend_esrule_Striggers backend_esrule_triggersS_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public."backend_esrule_Striggers"
    ADD CONSTRAINT "backend_esrule_triggersS_pkey" PRIMARY KEY (id);


--
-- Name: backend_esrule_Striggers backend_esrule_triggerss_esrule_id_state_id_e2f7e575_uniq; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public."backend_esrule_Striggers"
    ADD CONSTRAINT backend_esrule_triggerss_esrule_id_state_id_e2f7e575_uniq UNIQUE (esrule_id, trigger_id);


--
-- Name: backend_inputparam backend_inputparam_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_inputparam
    ADD CONSTRAINT backend_inputparam_pkey PRIMARY KEY (parameter_ptr_id);


--
-- Name: backend_metaparam backend_metaparam_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_metaparam
    ADD CONSTRAINT backend_metaparam_pkey PRIMARY KEY (parameter_ptr_id);


--
-- Name: backend_parameter backend_parameter_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_parameter
    ADD CONSTRAINT backend_parameter_pkey PRIMARY KEY (id);


--
-- Name: backend_parval backend_parval_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_parval
    ADD CONSTRAINT backend_parval_pkey PRIMARY KEY (id);


--
-- Name: backend_rangeparam backend_rangeparam_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_rangeparam
    ADD CONSTRAINT backend_rangeparam_pkey PRIMARY KEY (parameter_ptr_id);


--
-- Name: backend_rule backend_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_rule
    ADD CONSTRAINT backend_rule_pkey PRIMARY KEY (id);


--
-- Name: backend_safetyprop backend_safetyprop_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_safetyprop
    ADD CONSTRAINT backend_safetyprop_pkey PRIMARY KEY (id);


--
-- Name: backend_setparam backend_setparam_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_setparam
    ADD CONSTRAINT backend_setparam_pkey PRIMARY KEY (parameter_ptr_id);


--
-- Name: backend_setparamopt backend_setparamopt_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_setparamopt
    ADD CONSTRAINT backend_setparamopt_pkey PRIMARY KEY (id);


--
-- Name: backend_sp1 backend_sp1_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_sp1
    ADD CONSTRAINT backend_sp1_pkey PRIMARY KEY (safetyprop_ptr_id);


--
-- Name: backend_sp1_triggers backend_sp1_triggers_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_sp1_triggers
    ADD CONSTRAINT backend_sp1_triggers_pkey PRIMARY KEY (id);


--
-- Name: backend_sp1_triggers backend_sp1_triggers_sp1_id_trigger_id_8b45f99b_uniq; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_sp1_triggers
    ADD CONSTRAINT backend_sp1_triggers_sp1_id_trigger_id_8b45f99b_uniq UNIQUE (sp1_id, trigger_id);


--
-- Name: backend_sp2_conds backend_sp2_conds_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_sp2_conds
    ADD CONSTRAINT backend_sp2_conds_pkey PRIMARY KEY (id);


--
-- Name: backend_sp2_conds backend_sp2_conds_sp2_id_trigger_id_8df7a647_uniq; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_sp2_conds
    ADD CONSTRAINT backend_sp2_conds_sp2_id_trigger_id_8df7a647_uniq UNIQUE (sp2_id, trigger_id);


--
-- Name: backend_sp2 backend_sp2_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_sp2
    ADD CONSTRAINT backend_sp2_pkey PRIMARY KEY (safetyprop_ptr_id);


--
-- Name: backend_sp3_conds backend_sp3_conds_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_sp3_conds
    ADD CONSTRAINT backend_sp3_conds_pkey PRIMARY KEY (id);


--
-- Name: backend_sp3_conds backend_sp3_conds_sp3_id_trigger_id_472a7be0_uniq; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_sp3_conds
    ADD CONSTRAINT backend_sp3_conds_sp3_id_trigger_id_472a7be0_uniq UNIQUE (sp3_id, trigger_id);


--
-- Name: backend_sp3 backend_sp3_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_sp3
    ADD CONSTRAINT backend_sp3_pkey PRIMARY KEY (safetyprop_ptr_id);


--
-- Name: backend_ssrule backend_ssrule_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_ssrule
    ADD CONSTRAINT backend_ssrule_pkey PRIMARY KEY (rule_ptr_id);


--
-- Name: backend_ssrule_triggers backend_ssrule_triggers_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_ssrule_triggers
    ADD CONSTRAINT backend_ssrule_triggers_pkey PRIMARY KEY (id);


--
-- Name: backend_ssrule_triggers backend_ssrule_triggers_ssrule_id_state_id_9e03b8bc_uniq; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_ssrule_triggers
    ADD CONSTRAINT backend_ssrule_triggers_ssrule_id_state_id_9e03b8bc_uniq UNIQUE (ssrule_id, trigger_id);


--
-- Name: backend_state backend_state_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_state
    ADD CONSTRAINT backend_state_pkey PRIMARY KEY (id);


--
-- Name: backend_statelog backend_statelog_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_statelog
    ADD CONSTRAINT backend_statelog_pkey PRIMARY KEY (id);


--
-- Name: backend_timeparam backend_timeparam_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_timeparam
    ADD CONSTRAINT backend_timeparam_pkey PRIMARY KEY (parameter_ptr_id);


--
-- Name: backend_trigger backend_trigger_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_trigger
    ADD CONSTRAINT backend_trigger_pkey PRIMARY KEY (id);


--
-- Name: backend_user backend_user_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_user
    ADD CONSTRAINT backend_user_pkey PRIMARY KEY (id);


--
-- Name: backend_user backend_user_username_key; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_user
    ADD CONSTRAINT backend_user_username_key UNIQUE (name);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: rule_management_abstractcharecteristic rule_management_abstractcharecteristic_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.rule_management_abstractcharecteristic
    ADD CONSTRAINT rule_management_abstractcharecteristic_pkey PRIMARY KEY (id);


--
-- Name: rule_management_device rule_management_device_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.rule_management_device
    ADD CONSTRAINT rule_management_device_pkey PRIMARY KEY (id);


--
-- Name: rule_management_device_users rule_management_device_users_device_id_user_id_cfae06ea_uniq; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.rule_management_device_users
    ADD CONSTRAINT rule_management_device_users_device_id_user_id_cfae06ea_uniq UNIQUE (device_id, user_id);


--
-- Name: rule_management_device_users rule_management_device_users_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.rule_management_device_users
    ADD CONSTRAINT rule_management_device_users_pkey PRIMARY KEY (id);


--
-- Name: rule_management_devicecharecteristic_affected_rules rule_management_devicech_devicecharecteristic_id__d946f497_uniq; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.rule_management_devicecharecteristic_affected_rules
    ADD CONSTRAINT rule_management_devicech_devicecharecteristic_id__d946f497_uniq UNIQUE (devicecharecteristic_id, rule_id);


--
-- Name: rule_management_devicecharecteristic_affected_rules rule_management_devicecharecteristic_affected_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.rule_management_devicecharecteristic_affected_rules
    ADD CONSTRAINT rule_management_devicecharecteristic_affected_rules_pkey PRIMARY KEY (id);


--
-- Name: rule_management_devicecharecteristic rule_management_devicecharecteristic_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.rule_management_devicecharecteristic
    ADD CONSTRAINT rule_management_devicecharecteristic_pkey PRIMARY KEY (id);


--
-- Name: rule_management_rule rule_management_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.rule_management_rule
    ADD CONSTRAINT rule_management_rule_pkey PRIMARY KEY (id);


--
-- Name: st_end_device st_end_device_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.st_end_device
    ADD CONSTRAINT st_end_device_pkey PRIMARY KEY (id);


--
-- Name: st_end_stapp st_end_stapp_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.st_end_stapp
    ADD CONSTRAINT st_end_stapp_pkey PRIMARY KEY (id);


--
-- Name: user_auth_usermetadata user_auth_usermetadata_pkey; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.user_auth_usermetadata
    ADD CONSTRAINT user_auth_usermetadata_pkey PRIMARY KEY (id);


--
-- Name: user_auth_usermetadata user_auth_usermetadata_user_id_key; Type: CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.user_auth_usermetadata
    ADD CONSTRAINT user_auth_usermetadata_user_id_key UNIQUE (user_id);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- Name: backend_capability_channels_capability_id_1bccd6c0; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_capability_channels_capability_id_1bccd6c0 ON public.backend_capability_channels USING btree (capability_id);


--
-- Name: backend_capability_channels_channel_id_84c47a3a; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_capability_channels_channel_id_84c47a3a ON public.backend_capability_channels USING btree (channel_id);


--
-- Name: backend_condition_par_id_bddbc67e; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_condition_par_id_bddbc67e ON public.backend_condition USING btree (par_id);


--
-- Name: backend_condition_trigger_id_5a7be7ee; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_condition_trigger_id_5a7be7ee ON public.backend_condition USING btree (trigger_id);


--
-- Name: backend_device_capabilities_capability_id_b710e85c; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_device_capabilities_capability_id_b710e85c ON public.backend_device_caps USING btree (capability_id);


--
-- Name: backend_device_capabilities_device_id_d1ec2214; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_device_capabilities_device_id_d1ec2214 ON public.backend_device_caps USING btree (device_id);


--
-- Name: backend_device_chans_channel_id_d5e05cbd; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_device_chans_channel_id_d5e05cbd ON public.backend_device_chans USING btree (channel_id);


--
-- Name: backend_device_chans_device_id_7eaeaa06; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_device_chans_device_id_7eaeaa06 ON public.backend_device_chans USING btree (device_id);


--
-- Name: backend_device_owner_id_a248fd8b; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_device_owner_id_a248fd8b ON public.backend_device USING btree (owner_id);


--
-- Name: backend_esrule_actionstate_id_e2e66cac; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_esrule_actionstate_id_e2e66cac ON public.backend_esrule USING btree (action_id);


--
-- Name: backend_esrule_triggerE_id_91b6be8d; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX "backend_esrule_triggerE_id_91b6be8d" ON public.backend_esrule USING btree ("Etrigger_id");


--
-- Name: backend_esrule_triggersS_esrule_id_7ea33e3d; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX "backend_esrule_triggersS_esrule_id_7ea33e3d" ON public."backend_esrule_Striggers" USING btree (esrule_id);


--
-- Name: backend_esrule_triggersS_state_id_22f7e9e4; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX "backend_esrule_triggersS_state_id_22f7e9e4" ON public."backend_esrule_Striggers" USING btree (trigger_id);


--
-- Name: backend_parameter_cap_id_b4de2acb; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_parameter_cap_id_b4de2acb ON public.backend_parameter USING btree (cap_id);


--
-- Name: backend_parval_par_id_049e0be4; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_parval_par_id_049e0be4 ON public.backend_parval USING btree (par_id);


--
-- Name: backend_parval_state_id_cde26674; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_parval_state_id_cde26674 ON public.backend_parval USING btree (state_id);


--
-- Name: backend_rule_owner_id_32585cc6; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_rule_owner_id_32585cc6 ON public.backend_rule USING btree (owner_id);


--
-- Name: backend_safetyprop_owner_id_0b165fad; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_safetyprop_owner_id_0b165fad ON public.backend_safetyprop USING btree (owner_id);


--
-- Name: backend_setparamopt_param_id_07e0f502; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_setparamopt_param_id_07e0f502 ON public.backend_setparamopt USING btree (param_id);


--
-- Name: backend_sp1_triggers_sp1_id_c4c1aca5; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_sp1_triggers_sp1_id_c4c1aca5 ON public.backend_sp1_triggers USING btree (sp1_id);


--
-- Name: backend_sp1_triggers_trigger_id_83a751db; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_sp1_triggers_trigger_id_83a751db ON public.backend_sp1_triggers USING btree (trigger_id);


--
-- Name: backend_sp2_conds_sp2_id_1fb0191a; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_sp2_conds_sp2_id_1fb0191a ON public.backend_sp2_conds USING btree (sp2_id);


--
-- Name: backend_sp2_conds_trigger_id_b90c6fa9; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_sp2_conds_trigger_id_b90c6fa9 ON public.backend_sp2_conds USING btree (trigger_id);


--
-- Name: backend_sp2_state_id_01caf21d; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_sp2_state_id_01caf21d ON public.backend_sp2 USING btree (state_id);


--
-- Name: backend_sp3_conds_sp3_id_f2c1fec5; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_sp3_conds_sp3_id_f2c1fec5 ON public.backend_sp3_conds USING btree (sp3_id);


--
-- Name: backend_sp3_conds_trigger_id_4aa9489f; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_sp3_conds_trigger_id_4aa9489f ON public.backend_sp3_conds USING btree (trigger_id);


--
-- Name: backend_sp3_event_id_b133fd92; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_sp3_event_id_b133fd92 ON public.backend_sp3 USING btree (event_id);


--
-- Name: backend_ssrule_actionstate_id_c9461e31; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_ssrule_actionstate_id_c9461e31 ON public.backend_ssrule USING btree (action_id);


--
-- Name: backend_ssrule_triggers_ssrule_id_c5913b93; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_ssrule_triggers_ssrule_id_c5913b93 ON public.backend_ssrule_triggers USING btree (ssrule_id);


--
-- Name: backend_ssrule_triggers_state_id_c7f0416f; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_ssrule_triggers_state_id_c7f0416f ON public.backend_ssrule_triggers USING btree (trigger_id);


--
-- Name: backend_state_cap_id_25727ebe; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_state_cap_id_25727ebe ON public.backend_state USING btree (cap_id);


--
-- Name: backend_state_chan_id_b9d0a0d4; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_state_chan_id_b9d0a0d4 ON public.backend_state USING btree (chan_id);


--
-- Name: backend_state_dev_id_a376fae0; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_state_dev_id_a376fae0 ON public.backend_state USING btree (dev_id);


--
-- Name: backend_statelog_cap_id_a554767b; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_statelog_cap_id_a554767b ON public.backend_statelog USING btree (cap_id);


--
-- Name: backend_statelog_dev_id_63f7e345; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_statelog_dev_id_63f7e345 ON public.backend_statelog USING btree (dev_id);


--
-- Name: backend_statelog_param_id_ab9f8aa5; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_statelog_param_id_ab9f8aa5 ON public.backend_statelog USING btree (param_id);


--
-- Name: backend_trigger_cap2_id_b0a35770; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_trigger_cap2_id_b0a35770 ON public.backend_trigger USING btree (cap_id);


--
-- Name: backend_trigger_chan_id_bbc8de39; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_trigger_chan_id_bbc8de39 ON public.backend_trigger USING btree (chan_id);


--
-- Name: backend_trigger_dev2_id_f21c5876; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_trigger_dev2_id_f21c5876 ON public.backend_trigger USING btree (dev_id);


--
-- Name: backend_user_username_eb55703b_like; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX backend_user_username_eb55703b_like ON public.backend_user USING btree (name varchar_pattern_ops);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: rule_management_device_users_device_id_d457f89d; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX rule_management_device_users_device_id_d457f89d ON public.rule_management_device_users USING btree (device_id);


--
-- Name: rule_management_device_users_user_id_71361e1a; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX rule_management_device_users_user_id_71361e1a ON public.rule_management_device_users USING btree (user_id);


--
-- Name: rule_management_devicechar_abstract_charecteristic_id_a55f6ccb; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX rule_management_devicechar_abstract_charecteristic_id_a55f6ccb ON public.rule_management_devicecharecteristic USING btree (abstract_charecteristic_id);


--
-- Name: rule_management_devicechar_devicecharecteristic_id_62d7357a; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX rule_management_devicechar_devicecharecteristic_id_62d7357a ON public.rule_management_devicecharecteristic_affected_rules USING btree (devicecharecteristic_id);


--
-- Name: rule_management_devicechar_rule_id_07fbc410; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX rule_management_devicechar_rule_id_07fbc410 ON public.rule_management_devicecharecteristic_affected_rules USING btree (rule_id);


--
-- Name: rule_management_devicecharecteristic_device_id_2fc7b33f; Type: INDEX; Schema: public; Owner: jessejmart
--

CREATE INDEX rule_management_devicecharecteristic_device_id_2fc7b33f ON public.rule_management_devicecharecteristic USING btree (device_id);


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_binparam backend_binparam_parameter_ptr_id_4fc53892_fk_backend_p; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_binparam
    ADD CONSTRAINT backend_binparam_parameter_ptr_id_4fc53892_fk_backend_p FOREIGN KEY (parameter_ptr_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_capability_channels backend_capability_c_capability_id_1bccd6c0_fk_backend_c; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_capability_channels
    ADD CONSTRAINT backend_capability_c_capability_id_1bccd6c0_fk_backend_c FOREIGN KEY (capability_id) REFERENCES public.backend_capability(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_capability_channels backend_capability_c_channel_id_84c47a3a_fk_backend_c; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_capability_channels
    ADD CONSTRAINT backend_capability_c_channel_id_84c47a3a_fk_backend_c FOREIGN KEY (channel_id) REFERENCES public.backend_channel(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_colorparam backend_colorparam_parameter_ptr_id_2a10b1b1_fk_backend_p; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_colorparam
    ADD CONSTRAINT backend_colorparam_parameter_ptr_id_2a10b1b1_fk_backend_p FOREIGN KEY (parameter_ptr_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_condition backend_condition_par_id_bddbc67e_fk_backend_parameter_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_condition
    ADD CONSTRAINT backend_condition_par_id_bddbc67e_fk_backend_parameter_id FOREIGN KEY (par_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_condition backend_condition_trigger_id_5a7be7ee_fk_backend_trigger_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_condition
    ADD CONSTRAINT backend_condition_trigger_id_5a7be7ee_fk_backend_trigger_id FOREIGN KEY (trigger_id) REFERENCES public.backend_trigger(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_device_caps backend_device_caps_capability_id_6d681664_fk_backend_c; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_device_caps
    ADD CONSTRAINT backend_device_caps_capability_id_6d681664_fk_backend_c FOREIGN KEY (capability_id) REFERENCES public.backend_capability(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_device_caps backend_device_caps_device_id_582e64dc_fk_backend_device_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_device_caps
    ADD CONSTRAINT backend_device_caps_device_id_582e64dc_fk_backend_device_id FOREIGN KEY (device_id) REFERENCES public.backend_device(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_device_chans backend_device_chans_channel_id_d5e05cbd_fk_backend_channel_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_device_chans
    ADD CONSTRAINT backend_device_chans_channel_id_d5e05cbd_fk_backend_channel_id FOREIGN KEY (channel_id) REFERENCES public.backend_channel(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_device_chans backend_device_chans_device_id_7eaeaa06_fk_backend_device_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_device_chans
    ADD CONSTRAINT backend_device_chans_device_id_7eaeaa06_fk_backend_device_id FOREIGN KEY (device_id) REFERENCES public.backend_device(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_device backend_device_owner_id_a248fd8b_fk_backend_user_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_device
    ADD CONSTRAINT backend_device_owner_id_a248fd8b_fk_backend_user_id FOREIGN KEY (owner_id) REFERENCES public.backend_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_durationparam backend_durationpara_parameter_ptr_id_06b460c1_fk_backend_p; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_durationparam
    ADD CONSTRAINT backend_durationpara_parameter_ptr_id_06b460c1_fk_backend_p FOREIGN KEY (parameter_ptr_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_esrule backend_esrule_action_id_722dc031_fk_backend_state_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_esrule
    ADD CONSTRAINT backend_esrule_action_id_722dc031_fk_backend_state_id FOREIGN KEY (action_id) REFERENCES public.backend_state(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_esrule backend_esrule_rule_ptr_id_f8f656ef_fk_backend_rule_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_esrule
    ADD CONSTRAINT backend_esrule_rule_ptr_id_f8f656ef_fk_backend_rule_id FOREIGN KEY (rule_ptr_id) REFERENCES public.backend_rule(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_inputparam backend_inputparam_parameter_ptr_id_7d2d6fe8_fk_backend_p; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_inputparam
    ADD CONSTRAINT backend_inputparam_parameter_ptr_id_7d2d6fe8_fk_backend_p FOREIGN KEY (parameter_ptr_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_metaparam backend_metaparam_parameter_ptr_id_56ce872d_fk_backend_p; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_metaparam
    ADD CONSTRAINT backend_metaparam_parameter_ptr_id_56ce872d_fk_backend_p FOREIGN KEY (parameter_ptr_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_parameter backend_parameter_cap_id_b4de2acb_fk_backend_capability_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_parameter
    ADD CONSTRAINT backend_parameter_cap_id_b4de2acb_fk_backend_capability_id FOREIGN KEY (cap_id) REFERENCES public.backend_capability(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_parval backend_parval_par_id_049e0be4_fk_backend_parameter_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_parval
    ADD CONSTRAINT backend_parval_par_id_049e0be4_fk_backend_parameter_id FOREIGN KEY (par_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_parval backend_parval_state_id_cde26674_fk_backend_state_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_parval
    ADD CONSTRAINT backend_parval_state_id_cde26674_fk_backend_state_id FOREIGN KEY (state_id) REFERENCES public.backend_state(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_rangeparam backend_rangeparam_parameter_ptr_id_9a607db7_fk_backend_p; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_rangeparam
    ADD CONSTRAINT backend_rangeparam_parameter_ptr_id_9a607db7_fk_backend_p FOREIGN KEY (parameter_ptr_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_rule backend_rule_owner_id_32585cc6_fk_backend_user_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_rule
    ADD CONSTRAINT backend_rule_owner_id_32585cc6_fk_backend_user_id FOREIGN KEY (owner_id) REFERENCES public.backend_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_safetyprop backend_safetyprop_owner_id_0b165fad_fk_backend_user_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_safetyprop
    ADD CONSTRAINT backend_safetyprop_owner_id_0b165fad_fk_backend_user_id FOREIGN KEY (owner_id) REFERENCES public.backend_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_setparam backend_setparam_parameter_ptr_id_18bfc60c_fk_backend_p; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_setparam
    ADD CONSTRAINT backend_setparam_parameter_ptr_id_18bfc60c_fk_backend_p FOREIGN KEY (parameter_ptr_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_setparamopt backend_setparamopt_param_id_07e0f502_fk_backend_s; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_setparamopt
    ADD CONSTRAINT backend_setparamopt_param_id_07e0f502_fk_backend_s FOREIGN KEY (param_id) REFERENCES public.backend_setparam(parameter_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp1 backend_sp1_safetyprop_ptr_id_d29a5f23_fk_backend_safetyprop_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_sp1
    ADD CONSTRAINT backend_sp1_safetyprop_ptr_id_d29a5f23_fk_backend_safetyprop_id FOREIGN KEY (safetyprop_ptr_id) REFERENCES public.backend_safetyprop(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp1_triggers backend_sp1_triggers_sp1_id_c4c1aca5_fk_backend_s; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_sp1_triggers
    ADD CONSTRAINT backend_sp1_triggers_sp1_id_c4c1aca5_fk_backend_s FOREIGN KEY (sp1_id) REFERENCES public.backend_sp1(safetyprop_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp1_triggers backend_sp1_triggers_trigger_id_83a751db_fk_backend_trigger_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_sp1_triggers
    ADD CONSTRAINT backend_sp1_triggers_trigger_id_83a751db_fk_backend_trigger_id FOREIGN KEY (trigger_id) REFERENCES public.backend_trigger(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp2_conds backend_sp2_conds_sp2_id_1fb0191a_fk_backend_s; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_sp2_conds
    ADD CONSTRAINT backend_sp2_conds_sp2_id_1fb0191a_fk_backend_s FOREIGN KEY (sp2_id) REFERENCES public.backend_sp2(safetyprop_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp2_conds backend_sp2_conds_trigger_id_b90c6fa9_fk_backend_trigger_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_sp2_conds
    ADD CONSTRAINT backend_sp2_conds_trigger_id_b90c6fa9_fk_backend_trigger_id FOREIGN KEY (trigger_id) REFERENCES public.backend_trigger(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp2 backend_sp2_safetyprop_ptr_id_6057ecb9_fk_backend_safetyprop_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_sp2
    ADD CONSTRAINT backend_sp2_safetyprop_ptr_id_6057ecb9_fk_backend_safetyprop_id FOREIGN KEY (safetyprop_ptr_id) REFERENCES public.backend_safetyprop(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp2 backend_sp2_state_id_01caf21d_fk_backend_trigger_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_sp2
    ADD CONSTRAINT backend_sp2_state_id_01caf21d_fk_backend_trigger_id FOREIGN KEY (state_id) REFERENCES public.backend_trigger(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp3_conds backend_sp3_conds_sp3_id_f2c1fec5_fk_backend_s; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_sp3_conds
    ADD CONSTRAINT backend_sp3_conds_sp3_id_f2c1fec5_fk_backend_s FOREIGN KEY (sp3_id) REFERENCES public.backend_sp3(safetyprop_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp3_conds backend_sp3_conds_trigger_id_4aa9489f_fk_backend_trigger_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_sp3_conds
    ADD CONSTRAINT backend_sp3_conds_trigger_id_4aa9489f_fk_backend_trigger_id FOREIGN KEY (trigger_id) REFERENCES public.backend_trigger(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp3 backend_sp3_event_id_b133fd92_fk_backend_trigger_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_sp3
    ADD CONSTRAINT backend_sp3_event_id_b133fd92_fk_backend_trigger_id FOREIGN KEY (event_id) REFERENCES public.backend_trigger(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_sp3 backend_sp3_safetyprop_ptr_id_ac7404ea_fk_backend_safetyprop_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_sp3
    ADD CONSTRAINT backend_sp3_safetyprop_ptr_id_ac7404ea_fk_backend_safetyprop_id FOREIGN KEY (safetyprop_ptr_id) REFERENCES public.backend_safetyprop(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_ssrule backend_ssrule_action_id_6626b087_fk_backend_state_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_ssrule
    ADD CONSTRAINT backend_ssrule_action_id_6626b087_fk_backend_state_id FOREIGN KEY (action_id) REFERENCES public.backend_state(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_ssrule backend_ssrule_rule_ptr_id_bb3cd0da_fk_backend_rule_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_ssrule
    ADD CONSTRAINT backend_ssrule_rule_ptr_id_bb3cd0da_fk_backend_rule_id FOREIGN KEY (rule_ptr_id) REFERENCES public.backend_rule(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_state backend_state_cap_id_25727ebe_fk_backend_capability_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_state
    ADD CONSTRAINT backend_state_cap_id_25727ebe_fk_backend_capability_id FOREIGN KEY (cap_id) REFERENCES public.backend_capability(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_state backend_state_chan_id_b9d0a0d4_fk_backend_channel_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_state
    ADD CONSTRAINT backend_state_chan_id_b9d0a0d4_fk_backend_channel_id FOREIGN KEY (chan_id) REFERENCES public.backend_channel(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_state backend_state_dev_id_a376fae0_fk_backend_device_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_state
    ADD CONSTRAINT backend_state_dev_id_a376fae0_fk_backend_device_id FOREIGN KEY (dev_id) REFERENCES public.backend_device(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_statelog backend_statelog_cap_id_a554767b_fk_backend_capability_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_statelog
    ADD CONSTRAINT backend_statelog_cap_id_a554767b_fk_backend_capability_id FOREIGN KEY (cap_id) REFERENCES public.backend_capability(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_statelog backend_statelog_dev_id_63f7e345_fk_backend_device_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_statelog
    ADD CONSTRAINT backend_statelog_dev_id_63f7e345_fk_backend_device_id FOREIGN KEY (dev_id) REFERENCES public.backend_device(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_statelog backend_statelog_param_id_ab9f8aa5_fk_backend_parameter_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_statelog
    ADD CONSTRAINT backend_statelog_param_id_ab9f8aa5_fk_backend_parameter_id FOREIGN KEY (param_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_timeparam backend_timeparam_parameter_ptr_id_fc36e993_fk_backend_p; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_timeparam
    ADD CONSTRAINT backend_timeparam_parameter_ptr_id_fc36e993_fk_backend_p FOREIGN KEY (parameter_ptr_id) REFERENCES public.backend_parameter(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_trigger backend_trigger_cap_id_c28ac690_fk_backend_capability_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_trigger
    ADD CONSTRAINT backend_trigger_cap_id_c28ac690_fk_backend_capability_id FOREIGN KEY (cap_id) REFERENCES public.backend_capability(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_trigger backend_trigger_chan_id_bbc8de39_fk_backend_channel_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_trigger
    ADD CONSTRAINT backend_trigger_chan_id_bbc8de39_fk_backend_channel_id FOREIGN KEY (chan_id) REFERENCES public.backend_channel(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: backend_trigger backend_trigger_dev_id_4a2e1853_fk_backend_device_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.backend_trigger
    ADD CONSTRAINT backend_trigger_dev_id_4a2e1853_fk_backend_device_id FOREIGN KEY (dev_id) REFERENCES public.backend_device(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: rule_management_devicecharecteristic rule_management_devi_abstract_charecteris_a55f6ccb_fk_rule_mana; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.rule_management_devicecharecteristic
    ADD CONSTRAINT rule_management_devi_abstract_charecteris_a55f6ccb_fk_rule_mana FOREIGN KEY (abstract_charecteristic_id) REFERENCES public.rule_management_abstractcharecteristic(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: rule_management_devicecharecteristic rule_management_devi_device_id_2fc7b33f_fk_rule_mana; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.rule_management_devicecharecteristic
    ADD CONSTRAINT rule_management_devi_device_id_2fc7b33f_fk_rule_mana FOREIGN KEY (device_id) REFERENCES public.rule_management_device(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: rule_management_device_users rule_management_devi_device_id_d457f89d_fk_rule_mana; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.rule_management_device_users
    ADD CONSTRAINT rule_management_devi_device_id_d457f89d_fk_rule_mana FOREIGN KEY (device_id) REFERENCES public.rule_management_device(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: rule_management_devicecharecteristic_affected_rules rule_management_devi_devicecharecteristic_62d7357a_fk_rule_mana; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.rule_management_devicecharecteristic_affected_rules
    ADD CONSTRAINT rule_management_devi_devicecharecteristic_62d7357a_fk_rule_mana FOREIGN KEY (devicecharecteristic_id) REFERENCES public.rule_management_devicecharecteristic(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: rule_management_devicecharecteristic_affected_rules rule_management_devi_rule_id_07fbc410_fk_rule_mana; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.rule_management_devicecharecteristic_affected_rules
    ADD CONSTRAINT rule_management_devi_rule_id_07fbc410_fk_rule_mana FOREIGN KEY (rule_id) REFERENCES public.rule_management_rule(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: rule_management_device_users rule_management_device_users_user_id_71361e1a_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.rule_management_device_users
    ADD CONSTRAINT rule_management_device_users_user_id_71361e1a_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_auth_usermetadata user_auth_usermetadata_user_id_26767ead_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: jessejmart
--

ALTER TABLE ONLY public.user_auth_usermetadata
    ADD CONSTRAINT user_auth_usermetadata_user_id_26767ead_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

