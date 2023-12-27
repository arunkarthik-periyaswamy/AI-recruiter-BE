--
-- PostgreSQL database dump
--

-- Dumped from database version 14.10 (Ubuntu 14.10-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.10 (Ubuntu 14.10-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: candidate_domain; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.candidate_domain (
    candidate_id uuid,
    domain_id integer,
    last_updated timestamp without time zone
);


ALTER TABLE public.candidate_domain OWNER TO postgres;

--
-- Name: candidates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.candidates (
    c_id uuid NOT NULL,
    email text NOT NULL,
    phone_number bigint,
    valid_id text,
    dsg_id integer NOT NULL,
    last_updated timestamp without time zone,
    expected_ctc double precision,
    years_of_experience double precision,
    c_name text,
    password text,
    tenant_id uuid
);


ALTER TABLE public.candidates OWNER TO postgres;

--
-- Name: configurations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.configurations (
    config_name text NOT NULL,
    config_value text NOT NULL,
    last_updated timestamp without time zone,
    tenant_id uuid NOT NULL
);


ALTER TABLE public.configurations OWNER TO postgres;

--
-- Name: designation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.designation (
    dsg_id integer NOT NULL,
    name text,
    last_updated timestamp without time zone,
    tenant_id uuid,
    industry_id integer
);


ALTER TABLE public.designation OWNER TO postgres;

--
-- Name: designation_dsg_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.designation_dsg_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE public.designation_dsg_id_seq OWNER TO postgres;

--
-- Name: designation_dsg_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.designation_dsg_id_seq OWNED BY public.designation.dsg_id;


--
-- Name: domain; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.domain (
    d_id integer NOT NULL,
    name text,
    last_updated timestamp without time zone,
    created_by integer,
    created_at timestamp without time zone
);


ALTER TABLE public.domain OWNER TO postgres;

--
-- Name: domain_d_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.domain_d_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE public.domain_d_id_seq OWNER TO postgres;

--
-- Name: domain_d_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.domain_d_id_seq OWNED BY public.domain.d_id;


--
-- Name: domain_designation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.domain_designation (
    d_id integer,
    dsg_id integer,
    last_updated timestamp without time zone
);


ALTER TABLE public.domain_designation OWNER TO postgres;

--
-- Name: evaluations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.evaluations (
    c_id uuid NOT NULL,
    q_id uuid NOT NULL,
    ai_answer text,
    candidate_answer text,
    score numeric,
    last_updated timestamp without time zone,
    is_clue_used boolean,
    is_flagged boolean,
    time_taken integer,
    interview_id uuid NOT NULL,
    question_number integer,
    tenant_id uuid
);


ALTER TABLE public.evaluations OWNER TO postgres;

--
-- Name: industry; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.industry (
    id integer NOT NULL,
    name text NOT NULL,
    created_by integer,
    updated_by integer,
    created_at timestamp without time zone,
    last_updated timestamp without time zone
);


ALTER TABLE public.industry OWNER TO postgres;

--
-- Name: industry_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.industry_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.industry_id_seq OWNER TO postgres;

--
-- Name: industry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.industry_id_seq OWNED BY public.industry.id;


--
-- Name: interview; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.interview (
    i_id uuid NOT NULL,
    c_id uuid NOT NULL,
    dsg_id integer NOT NULL,
    no_of_questions integer,
    status text,
    evaluation_status text,
    last_updated timestamp without time zone,
    date_of_interview timestamp with time zone,
    eval_status_code integer,
    created_by integer,
    tenant_id uuid
);


ALTER TABLE public.interview OWNER TO postgres;

--
-- Name: page_component; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.page_component (
    id integer NOT NULL,
    name text NOT NULL,
    created_by integer,
    updated_by integer,
    created_at timestamp without time zone,
    last_updated timestamp without time zone
);


ALTER TABLE public.page_component OWNER TO postgres;

--
-- Name: page_component_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.page_component_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.page_component_id_seq OWNER TO postgres;

--
-- Name: page_component_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.page_component_id_seq OWNED BY public.page_component.id;


--
-- Name: permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permission (
    id integer NOT NULL,
    name text NOT NULL,
    request_method text NOT NULL,
    path_url text NOT NULL,
    created_by integer,
    updated_by integer,
    created_at timestamp without time zone,
    last_updated timestamp without time zone
);


ALTER TABLE public.permission OWNER TO postgres;

--
-- Name: permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.permission_id_seq OWNER TO postgres;

--
-- Name: permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.permission_id_seq OWNED BY public.permission.id;


--
-- Name: question_bank; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.question_bank (
    question_id uuid NOT NULL,
    question text,
    question_type text,
    designation text,
    answer_type text,
    ai_answer text,
    domain text,
    max_answering_time smallint,
    preparation_time smallint,
    code_required boolean,
    difficulty_index smallint,
    clues text,
    url text,
    flagged boolean,
    user_id integer,
    last_updated timestamp without time zone,
    flag_expectation text,
    sub_domain integer,
    tenant_id uuid
);


ALTER TABLE public.question_bank OWNER TO postgres;

--
-- Name: role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role (
    id integer NOT NULL,
    name text NOT NULL,
    created_by integer,
    updated_by integer,
    created_at timestamp without time zone,
    last_updated timestamp without time zone,
    superior_roles integer[] DEFAULT ARRAY[1]
);


ALTER TABLE public.role OWNER TO postgres;

--
-- Name: role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.role_id_seq OWNER TO postgres;

--
-- Name: role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.role_id_seq OWNED BY public.role.id;


--
-- Name: role_page_component; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_page_component (
    role_id integer,
    page_component_id integer,
    last_updated timestamp without time zone
);


ALTER TABLE public.role_page_component OWNER TO postgres;

--
-- Name: role_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_permission (
    role_id integer,
    permission_id integer,
    last_updated timestamp without time zone
);


ALTER TABLE public.role_permission OWNER TO postgres;

--
-- Name: sub_domain; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sub_domain (
    id integer NOT NULL,
    name text NOT NULL,
    domain_id integer NOT NULL,
    created_by integer,
    updated_by integer,
    created_at timestamp without time zone,
    last_updated timestamp without time zone
);


ALTER TABLE public.sub_domain OWNER TO postgres;

--
-- Name: sub_domain_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sub_domain_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sub_domain_id_seq OWNER TO postgres;

--
-- Name: sub_domain_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sub_domain_id_seq OWNED BY public.sub_domain.id;


--
-- Name: tenant; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tenant (
    tenant_id uuid NOT NULL,
    name text NOT NULL,
    created_at timestamp without time zone,
    last_updated timestamp without time zone
);


ALTER TABLE public.tenant OWNER TO postgres;

--
-- Name: tenant_designation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tenant_designation (
    tenant_id uuid,
    designation_id integer,
    last_updated timestamp without time zone
);


ALTER TABLE public.tenant_designation OWNER TO postgres;

--
-- Name: tenant_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tenant_user (
    tenant_id uuid,
    user_id integer,
    last_updated timestamp without time zone
);


ALTER TABLE public.tenant_user OWNER TO postgres;

--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    user_id integer NOT NULL,
    first_name text,
    last_name text,
    email text,
    password text,
    last_updated timestamp without time zone,
    jwt_token text,
    role_id integer
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: user_designation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_designation (
    user_id integer,
    dsg_id integer,
    last_updated timestamp without time zone
);


ALTER TABLE public.user_designation OWNER TO postgres;

--
-- Name: user_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE public.user_user_id_seq OWNER TO postgres;

--
-- Name: user_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_user_id_seq OWNED BY public."user".user_id;


--
-- Name: designation dsg_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.designation ALTER COLUMN dsg_id SET DEFAULT nextval('public.designation_dsg_id_seq'::regclass);


--
-- Name: domain d_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.domain ALTER COLUMN d_id SET DEFAULT nextval('public.domain_d_id_seq'::regclass);


--
-- Name: industry id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.industry ALTER COLUMN id SET DEFAULT nextval('public.industry_id_seq'::regclass);


--
-- Name: page_component id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.page_component ALTER COLUMN id SET DEFAULT nextval('public.page_component_id_seq'::regclass);


--
-- Name: permission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permission ALTER COLUMN id SET DEFAULT nextval('public.permission_id_seq'::regclass);


--
-- Name: role id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role ALTER COLUMN id SET DEFAULT nextval('public.role_id_seq'::regclass);


--
-- Name: sub_domain id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sub_domain ALTER COLUMN id SET DEFAULT nextval('public.sub_domain_id_seq'::regclass);


--
-- Name: user user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user" ALTER COLUMN user_id SET DEFAULT nextval('public.user_user_id_seq'::regclass);


--
-- Data for Name: candidate_domain; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.candidate_domain (candidate_id, domain_id, last_updated) FROM stdin;
\.


--
-- Data for Name: candidates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.candidates (c_id, email, phone_number, valid_id, dsg_id, last_updated, expected_ctc, years_of_experience, c_name, password, tenant_id) FROM stdin;
8f0991b0-5864-11ee-a33c-0dd4c2040095	giridhart1@ideas2it.com	9940494001	\N	1	2023-09-21 09:52:21.476035	3	1	Gridhar	\N	\N
189f8186-5866-11ee-a33c-0dd4c2040095	ari@iddea.com	9933992194	\N	1	2023-09-21 10:03:21.804303	3	1	ari	\N	\N
3dffa370-5866-11ee-a33c-0dd4c2040095	wer@yert.com	8837712103	\N	1	2023-09-21 10:04:24.511887	3	1	ddd	\N	\N
b4844954-5890-11ee-a33c-0dd4c2040095	johndoe1@test.com	9944491222	\N	1	2023-09-21 15:08:22.213845	3	1	johndoe1	\N	\N
118b303a-591e-11ee-a33c-0dd4c2040095	test1@gmail.com	9876543212	\N	1	2023-09-22 08:00:17.326871	3	1	Test 22/9/1	\N	\N
54681750-592e-11ee-a33c-0dd4c2040095	rectest@i2i.in	9947839002	\N	1	2023-09-22 09:56:41.447993	3	1	Test_Candidate	\N	\N
9be86b4c-593e-11ee-a33c-0dd4c2040095	rectest1@i2i.in	2234467896	\N	1	2023-09-22 11:53:13.359332	3	1	Test_Candidate1	\N	\N
b9c33480-5952-11ee-a33c-0dd4c2040095	tccan2@ii2i.in	9987688765	\N	1	2023-09-22 14:17:13.379257	3	1	test_candidate_2	\N	\N
6601365f-5c6e-11ee-a796-5405dbcf43b8	mahesh@gmail.com	9912387234	\N	1	2023-09-26 13:12:53.12325	3	1	Mahesh	\N	\N
7abceb11-5c6e-11ee-b500-5405dbcf43b8	suresh@iwi.com	8923498123	\N	1	2023-09-26 13:13:27.900678	3	1	Suresh	\N	\N
ae44a73d-5ec8-11ee-88cc-5405dbcf43b8	dhinesh@outlook.in	8823996478	\N	1	2023-09-29 13:04:09.474699	3	1	Dhinesh	\N	\N
ba0fc317-629f-11ee-951e-e04f4370e917	nithyashree@gmail.com	9929012345	\N	1	2023-10-04 10:21:04.800696	3	1	Nithya	\N	\N
5fccebe0-6368-11ee-a33c-0dd4c2040095	candid@dan.com	7823123434	\N	1	2023-10-05 10:17:23.005484	3	1	New candidate	\N	\N
9336dd10-6368-11ee-a33c-0dd4c2040095	sasa@sas.sas	7874393274	\N	1	2023-10-05 10:18:49.262766	3	1	asas	\N	\N
06aac2f2-6369-11ee-a33c-0dd4c2040095	tescan2@gmail.com	7782892002	\N	1	2023-10-05 10:22:02.960726	3	1	tescan2	\N	\N
a6f9cb14-6377-11ee-a33c-0dd4c2040095	sada@dasd.dsad	3123123213	\N	1	2023-10-05 12:06:44.864424	3	1	sdadsa	\N	\N
fd606e10-637a-11ee-a33c-0dd4c2040095	dasdasd@dsad.dsd	434234324324	\N	1	2023-10-05 12:30:38.315277	3	1	sadasa	\N	\N
d75ae316-637b-11ee-a33c-0dd4c2040095	asda@dasdsad.dsds	4432432434	\N	1	2023-10-05 12:36:44.022545	3	1	ddsada	\N	\N
0f497aa8-637c-11ee-a33c-0dd4c2040095	aadasd@dsads.dsadsa	873427497324974	\N	1	2023-10-05 12:38:17.859848	3	1	dasdasdsad	\N	\N
24d10c44-640b-11ee-a33c-0dd4c2040095	sdad@sadd.dsd	7472934732947	\N	1	2023-10-06 05:42:32.010514	3	1	asdad	\N	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	test11@test.com	4567899996	\N	1	2023-10-10 11:19:28.992724	3	1	test11	\N	\N
983f492c-680a-11ee-a33c-0dd4c2040095	testcan111@gmail.com	9872341231	\N	1	2023-10-11 07:48:40.828856	3	1	testcan111	\N	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	"tescan2@gmail.com"	7782892001	\N	1	2023-10-12 13:30:01.882202	3	1	test	\N	\N
fd402890-699b-11ee-a33c-0dd4c2040095	testccc11@gmail.com	5678292838	\N	1	2023-10-13 07:41:58.462059	3	1	testccc	\N	\N
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	candid@can.com	32433443434	\N	1	2023-10-16 10:02:24.428981	3	1	newCandid	\N	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
efccd448-6d19-11ee-a33c-0dd4c2040095	admin_added_man@gmail.com	6678489302	\N	34	2023-10-17 18:21:05.982065	3	1	admin_added_man	\N	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
654d7958-6dd2-11ee-a33c-0dd4c2040095	test_cannnd@GMAIL.com	7136824909	\N	34	2023-10-18 16:21:30.517149	3	1	test_cannnd	\N	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
cafc50c6-70fb-11ee-9b22-e454e805e8b9	dk_candidate@gmail.com	9444123123	\N	5	2023-10-22 16:55:21.682517	3	1	dk_test	\N	45ea898a-6f5d-11ee-aca0-e454e805e8b9
12365b74-7230-11ee-a33c-0dd4c2040095	pradeep@gmail.com	8596749565	\N	1	2023-10-24 05:42:08.458733	3	1	Pradeep	\N	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
fb027d06-7230-11ee-a33c-0dd4c2040095	kumar@gmail.com	7465827345	\N	8	2023-10-24 05:48:39.028363	3	1	Kumar	\N	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
51485da2-73f3-11ee-a33c-0dd4c2040095	tccan2@ii2i.in	7782892002	\N	1	2023-10-26 11:32:17.298126	3	1	test_candidate_2	\N	d79dfb76-73f0-11ee-a33c-0dd4c2040095
47c3016a-74b6-11ee-a33c-0dd4c2040095	monish@gmail.com	9876543210	\N	38	2023-10-27 10:47:53.187121	3	1	Monish	\N	d3fb23da-74b4-11ee-a33c-0dd4c2040095
448a0c3a-76e8-11ee-a33c-0dd4c2040095	candid@one.com	3244345534	\N	19	2023-10-30 05:50:44.939822	3	1	candidate one	\N	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
42c1be64-78a2-11ee-a33c-0dd4c2040095	thiru@one.dd	83748576	\N	8	2023-11-01 10:34:39.504827	3	1	thiru	\N	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
7f80b9e4-7952-11ee-a33c-0dd4c2040095	pathi@thiru.com	8475647589	\N	8	2023-11-02 07:36:12.84616	3	1	pathi	\N	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
602b87e6-7c67-11ee-a33c-0dd4c2040095	candid@onetwo.com	9586796685	\N	8	2023-11-06 05:43:13.198535	3	1	new candidate	\N	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
8b641956-7eeb-11ee-a33c-0dd4c2040095	c@ideas2it.com	8475668475	\N	8	2023-11-09 10:34:21.604827	3	1	newCandidate	\N	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
4689f8a2-7ef3-11ee-a33c-0dd4c2040095	2@ideas2it.com	7485768945	\N	8	2023-11-09 11:29:42.059752	3	1	candidate two	\N	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
7def4008-8dcc-11ee-a33c-0dd4c2040095	thiru@murai.com	9485768598	\N	8	2023-11-28 08:59:52.07128	3	1	thiru murai	\N	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
10dd9ff0-9434-11ee-a33c-0dd4c2040095	divyaksk3134@gmail.com	8925438862	\N	21	2023-12-06 12:36:23.720369	3	1	Divyakala	\N	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
402ab200-9d91-11ee-a33c-0dd4c2040095	summa@int.com	9939302993	\N	21	2023-12-18 10:36:06.739236	3	1	Giridhar	\N	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
f41beea0-9e3b-11ee-a33c-0dd4c2040095	summa1@int.com	9939302992	\N	21	2023-12-19 06:58:03.070357	3	1	Giridhar	\N	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
\.


--
-- Data for Name: configurations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.configurations (config_name, config_value, last_updated, tenant_id) FROM stdin;
OPENAI_API_KEY	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	2023-06-27 09:56:38.107425	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
\.


--
-- Data for Name: designation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.designation (dsg_id, name, last_updated, tenant_id, industry_id) FROM stdin;
1	python developer	2023-06-01 06:30:36.87668	07e3642c-14d0-11ee-a33c-0dd4c2040095	1
5	Java developer	2023-08-03 07:23:21.838097	\N	1
8	.Net Developer	2023-08-07 12:37:52.262314	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	1
9	C Developer	2023-08-22 16:49:35.519486	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	1
17	Manga Artist	2023-09-18 11:45:39.104417	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	1
18	Frontend Developer	2023-09-18 12:07:27.456003	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	1
19	Web Designer	2023-09-18 12:20:15.868542	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	2
20	React Developer	2023-09-18 12:42:05.721701	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	1
21	Data Scientist	2023-09-19 12:42:05.327973	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	1
22	Javascript Developer	2023-09-29 12:11:53.844498	f1a33f68-5eab-11ee-a33c-0dd4c2040095	1
23	Angular Developer	2023-09-29 12:14:57.76577	f1a33f68-5eab-11ee-a33c-0dd4c2040095	1
24	Python Developer I	2023-10-03 13:14:58.307683	be8484a3-61ee-11ee-8955-e04f4370e917	1
25	Senior Python Developer	2023-10-11 07:22:47.988556	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	1
26	Python	2023-10-13 06:38:05.511205	ab0152e2-6992-11ee-a33c-0dd4c2040095	1
27	Delivery Manager	2023-10-13 07:33:55.763313	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	1
28	Product Owner	2023-10-13 07:35:47.189616	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	1
29	New Developer	2023-10-13 09:18:03.309858	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	1
30	Developer One	2023-10-13 12:41:09.058632	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	1
31	Content One	2023-10-13 12:41:26.309158	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	2
32	Node Developer	2023-10-17 07:40:51.383886	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	1
33	Node1 Developer	2023-10-17 07:41:23.930779	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	1
34	Data Architect	2023-10-17 11:04:55.829029	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	1
35	Junior Data Scientist	2023-10-17 11:47:34.640592	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	1
36	Content Two	2023-10-24 08:47:24.283004	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	2
37	Content Three	2023-10-24 08:57:01.90946	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	2
38	Fresher	2023-10-25 13:10:33.556216	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	1
39	Senior	2023-10-25 13:12:17.047615	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	1
40	Freshers	2023-11-22 10:03:56.657669	d6282f14-8787-11ee-a33c-0dd4c2040095	1
41	Sql Developer	2023-12-06 12:53:01.424142	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	1
\.


--
-- Data for Name: domain; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.domain (d_id, name, last_updated, created_by, created_at) FROM stdin;
1	Web Development	2023-08-22 16:51:01.307022	4	2023-08-22 16:51:01.307022
2	Backend Development	2023-09-19 10:03:06.202794	4	2023-09-19 10:03:06.202794
3	Core Python Coding	2023-09-21 09:36:40.154526	4	2023-09-21 09:36:40.154526
4	Cybersecurity	2023-10-17 07:40:56.022615	\N	2023-10-17 07:40:56.022615
5	Data Science	2023-10-17 07:40:56.022615	\N	2023-10-17 07:40:56.022615
6	Algorithms And Data Structures	2023-10-17 07:40:56.022615	\N	2023-10-17 07:40:56.022615
7	Project Management	2023-10-17 07:40:56.022615	\N	2023-10-17 07:40:56.022615
8	Cloud Computing	2023-10-17 07:40:56.022615	\N	2023-10-17 07:40:56.022615
9	Artificial Intelligence	2023-10-17 07:40:56.022615	\N	2023-10-17 07:40:56.022615
10	Mobile App Development	2023-10-17 07:40:56.022615	\N	2023-10-17 07:40:56.022615
11	Software Development Life Cycle	2023-10-17 07:40:56.022615	\N	2023-10-17 07:40:56.022615
12	Software Testing	2023-10-17 07:40:56.022615	\N	2023-10-17 07:40:56.022615
13	Communication Skills	2023-10-17 07:40:56.022615	\N	2023-10-17 07:40:56.022615
14	Ui/Ux Design	2023-10-17 07:40:56.022615	\N	2023-10-17 07:40:56.022615
15	Agile Methodology	2023-10-17 07:40:56.022615	\N	2023-10-17 07:40:56.022615
16	Version Control	2023-10-17 07:40:56.022615	\N	2023-10-17 07:40:56.022615
17	Machine Learning	2023-10-17 07:40:56.022615	\N	2023-10-17 07:40:56.022615
18	Networking	2023-10-17 07:40:56.022615	\N	2023-10-17 07:40:56.022615
19	Critical Thinking	2023-10-17 07:40:56.022615	\N	2023-10-17 07:40:56.022615
20	Programming	2023-10-17 07:40:56.022615	\N	2023-10-17 07:40:56.022615
21	Problem Solving	2023-10-17 07:40:56.022615	\N	2023-10-17 07:40:56.022615
22	Database Management	2023-10-17 07:40:56.022615	\N	2023-10-17 07:40:56.022615
23	Computer Architecture	2023-10-17 11:47:39.714748	\N	2023-10-17 11:47:39.714748
24	Teamwork	2023-10-17 11:47:39.714748	\N	2023-10-17 11:47:39.714748
25	Operating Systems	2023-10-17 11:47:39.714748	\N	2023-10-17 11:47:39.714748
26	Time Management	2023-10-17 11:47:39.714748	\N	2023-10-17 11:47:39.714748
27	Software Engineering Principles	2023-10-17 11:47:39.714748	\N	2023-10-17 11:47:39.714748
28	Front End Development	2023-10-18 11:19:29.829363	4	2023-10-18 11:19:29.829363
29	Multi	2023-10-19 08:37:37.131229	4	2023-10-19 08:37:37.131229
30	Conti	2023-10-20 05:05:06.017117	4	2023-10-20 05:05:06.017117
31	Infrastructure	2023-10-20 05:07:08.46916	4	2023-10-20 05:07:08.46916
32	Development	2023-10-20 05:09:47.600359	4	2023-10-20 05:09:47.600359
33	Laboratory	2023-10-20 05:11:43.485792	4	2023-10-20 05:11:43.485792
34	Battery Technology	2023-10-20 05:12:58.720183	4	2023-10-20 05:12:58.720183
35	Automobiles	2023-10-20 05:21:12.10941	4	2023-10-20 05:21:12.10941
36	Backend	2023-10-24 05:47:29.011	4	2023-10-24 05:47:29.011
37	Seo Writing	2023-10-24 08:47:31.870636	\N	2023-10-24 08:47:31.870636
38	Collaboration	2023-10-24 08:47:31.870636	\N	2023-10-24 08:47:31.870636
39	Creativity	2023-10-24 08:47:31.870636	\N	2023-10-24 08:47:31.870636
40	Localization	2023-10-24 08:47:31.870636	\N	2023-10-24 08:47:31.870636
41	Content Marketing	2023-10-24 08:47:31.870636	\N	2023-10-24 08:47:31.870636
42	Research	2023-10-24 08:47:31.870636	\N	2023-10-24 08:47:31.870636
43	Proofreading	2023-10-24 08:47:31.870636	\N	2023-10-24 08:47:31.870636
44	Graphic Design	2023-10-24 08:47:31.870636	\N	2023-10-24 08:47:31.870636
45	Attention To Detail	2023-10-24 08:47:31.870636	\N	2023-10-24 08:47:31.870636
46	Social Media Management	2023-10-24 08:47:31.870636	\N	2023-10-24 08:47:31.870636
47	Content Strategy	2023-10-24 08:47:31.870636	\N	2023-10-24 08:47:31.870636
48	Audio Editing	2023-10-24 08:47:31.870636	\N	2023-10-24 08:47:31.870636
49	Video Editing	2023-10-24 08:47:31.870636	\N	2023-10-24 08:47:31.870636
50	Content Writing	2023-10-24 08:47:31.870636	\N	2023-10-24 08:47:31.870636
51	Copywriting	2023-10-24 08:47:31.870636	\N	2023-10-24 08:47:31.870636
52	Data Entry	2023-10-24 08:47:31.870636	\N	2023-10-24 08:47:31.870636
53	Editing	2023-10-24 08:47:31.870636	\N	2023-10-24 08:47:31.870636
54	Instructional Design	2023-10-24 08:47:31.870636	\N	2023-10-24 08:47:31.870636
55	Translation	2023-10-24 08:47:31.870636	\N	2023-10-24 08:47:31.870636
56	Web Design	2023-10-24 08:47:31.870636	\N	2023-10-24 08:47:31.870636
57	Technical Writing	2023-10-24 08:47:31.870636	\N	2023-10-24 08:47:31.870636
58	Transcription	2023-10-24 08:47:31.870636	\N	2023-10-24 08:47:31.870636
59	Illustration	2023-10-24 08:57:09.604668	\N	2023-10-24 08:57:09.604668
60	Photography	2023-10-24 08:57:09.604668	\N	2023-10-24 08:57:09.604668
61	Storyboarding	2023-10-24 08:57:09.604668	\N	2023-10-24 08:57:09.604668
62	Animation	2023-10-24 08:57:09.604668	\N	2023-10-24 08:57:09.604668
63	Scriptwriting	2023-10-24 08:57:09.604668	\N	2023-10-24 08:57:09.604668
64	Voiceover	2023-10-24 08:57:09.604668	\N	2023-10-24 08:57:09.604668
65	Client Communication	2023-10-25 13:10:40.107655	\N	2023-10-25 13:10:40.107655
66	Usability Testing	2023-10-25 13:10:40.107655	\N	2023-10-25 13:10:40.107655
67	Information Architecture	2023-10-25 13:10:40.107655	\N	2023-10-25 13:10:40.107655
68	Print Design	2023-10-25 13:10:40.107655	\N	2023-10-25 13:10:40.107655
69	Typography	2023-10-25 13:10:40.107655	\N	2023-10-25 13:10:40.107655
70	Wireframing	2023-10-25 13:10:40.107655	\N	2023-10-25 13:10:40.107655
71	Organizational Skills	2023-10-25 13:10:40.107655	\N	2023-10-25 13:10:40.107655
72	Adaptability	2023-10-25 13:10:40.107655	\N	2023-10-25 13:10:40.107655
73	Content Management Systems	2023-10-25 13:10:40.107655	\N	2023-10-25 13:10:40.107655
74	Prototyping	2023-10-25 13:10:40.107655	\N	2023-10-25 13:10:40.107655
75	User Research	2023-10-25 13:10:40.107655	\N	2023-10-25 13:10:40.107655
76	Brand Identity	2023-10-25 13:10:40.107655	\N	2023-10-25 13:10:40.107655
77	Color Theory	2023-10-25 13:10:40.107655	\N	2023-10-25 13:10:40.107655
78	Designing	2023-10-30 05:49:47.861917	4	2023-10-30 05:49:47.861917
79	Aptitude	2023-11-22 10:23:57.204793	89	2023-11-22 10:23:57.204793
80	Nlp	2023-11-23 07:37:22.256347	4	2023-11-23 07:37:22.256347
\.


--
-- Data for Name: domain_designation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.domain_designation (d_id, dsg_id, last_updated) FROM stdin;
1	5	2023-08-22 16:51:01.315852
2	1	2023-09-19 10:03:06.211983
3	1	2023-09-21 09:36:40.301581
1	32	2023-10-17 07:40:56.022615
4	32	2023-10-17 07:40:56.022615
5	32	2023-10-17 07:40:56.022615
6	32	2023-10-17 07:40:56.022615
7	32	2023-10-17 07:40:56.022615
8	32	2023-10-17 07:40:56.022615
9	32	2023-10-17 07:40:56.022615
10	32	2023-10-17 07:40:56.022615
11	32	2023-10-17 07:40:56.022615
12	32	2023-10-17 07:40:56.022615
13	32	2023-10-17 07:40:56.022615
14	32	2023-10-17 07:40:56.022615
15	32	2023-10-17 07:40:56.022615
16	32	2023-10-17 07:40:56.022615
17	32	2023-10-17 07:40:56.022615
18	32	2023-10-17 07:40:56.022615
19	32	2023-10-17 07:40:56.022615
20	32	2023-10-17 07:40:56.022615
21	32	2023-10-17 07:40:56.022615
22	32	2023-10-17 07:40:56.022615
1	33	2023-10-17 07:41:29.079173
4	33	2023-10-17 07:41:29.079173
5	33	2023-10-17 07:41:29.079173
6	33	2023-10-17 07:41:29.079173
7	33	2023-10-17 07:41:29.079173
8	33	2023-10-17 07:41:29.079173
9	33	2023-10-17 07:41:29.079173
10	33	2023-10-17 07:41:29.079173
11	33	2023-10-17 07:41:29.079173
12	33	2023-10-17 07:41:29.079173
13	33	2023-10-17 07:41:29.079173
14	33	2023-10-17 07:41:29.079173
15	33	2023-10-17 07:41:29.079173
16	33	2023-10-17 07:41:29.079173
17	33	2023-10-17 07:41:29.079173
18	33	2023-10-17 07:41:29.079173
19	33	2023-10-17 07:41:29.079173
20	33	2023-10-17 07:41:29.079173
21	33	2023-10-17 07:41:29.079173
22	33	2023-10-17 07:41:29.079173
1	34	2023-10-17 11:05:00.365549
4	34	2023-10-17 11:05:00.365549
5	34	2023-10-17 11:05:00.365549
6	34	2023-10-17 11:05:00.365549
7	34	2023-10-17 11:05:00.365549
8	34	2023-10-17 11:05:00.365549
9	34	2023-10-17 11:05:00.365549
10	34	2023-10-17 11:05:00.365549
11	34	2023-10-17 11:05:00.365549
12	34	2023-10-17 11:05:00.365549
13	34	2023-10-17 11:05:00.365549
14	34	2023-10-17 11:05:00.365549
15	34	2023-10-17 11:05:00.365549
16	34	2023-10-17 11:05:00.365549
17	34	2023-10-17 11:05:00.365549
18	34	2023-10-17 11:05:00.365549
19	34	2023-10-17 11:05:00.365549
20	34	2023-10-17 11:05:00.365549
21	34	2023-10-17 11:05:00.365549
22	34	2023-10-17 11:05:00.365549
1	35	2023-10-17 11:47:39.714748
4	35	2023-10-17 11:47:39.714748
5	35	2023-10-17 11:47:39.714748
6	35	2023-10-17 11:47:39.714748
7	35	2023-10-17 11:47:39.714748
8	35	2023-10-17 11:47:39.714748
9	35	2023-10-17 11:47:39.714748
10	35	2023-10-17 11:47:39.714748
11	35	2023-10-17 11:47:39.714748
12	35	2023-10-17 11:47:39.714748
13	35	2023-10-17 11:47:39.714748
14	35	2023-10-17 11:47:39.714748
15	35	2023-10-17 11:47:39.714748
16	35	2023-10-17 11:47:39.714748
17	35	2023-10-17 11:47:39.714748
18	35	2023-10-17 11:47:39.714748
19	35	2023-10-17 11:47:39.714748
20	35	2023-10-17 11:47:39.714748
21	35	2023-10-17 11:47:39.714748
22	35	2023-10-17 11:47:39.714748
23	35	2023-10-17 11:47:39.714748
24	35	2023-10-17 11:47:39.714748
25	35	2023-10-17 11:47:39.714748
26	35	2023-10-17 11:47:39.714748
27	35	2023-10-17 11:47:39.714748
28	1	2023-10-18 11:19:29.845541
17	1	2023-10-18 13:22:44.843999
29	1	2023-10-19 08:37:37.13705
30	1	2023-10-20 05:05:06.026071
31	1	2023-10-20 05:07:08.477228
32	1	2023-10-20 05:09:47.61612
33	1	2023-10-20 05:11:43.495929
34	1	2023-10-20 05:12:58.728096
35	1	2023-10-20 05:21:12.115683
36	8	2023-10-24 05:47:29.021355
7	36	2023-10-24 08:47:31.870636
13	36	2023-10-24 08:47:31.870636
14	36	2023-10-24 08:47:31.870636
19	36	2023-10-24 08:47:31.870636
21	36	2023-10-24 08:47:31.870636
26	36	2023-10-24 08:47:31.870636
37	36	2023-10-24 08:47:31.870636
38	36	2023-10-24 08:47:31.870636
39	36	2023-10-24 08:47:31.870636
40	36	2023-10-24 08:47:31.870636
41	36	2023-10-24 08:47:31.870636
42	36	2023-10-24 08:47:31.870636
43	36	2023-10-24 08:47:31.870636
44	36	2023-10-24 08:47:31.870636
45	36	2023-10-24 08:47:31.870636
46	36	2023-10-24 08:47:31.870636
47	36	2023-10-24 08:47:31.870636
48	36	2023-10-24 08:47:31.870636
49	36	2023-10-24 08:47:31.870636
50	36	2023-10-24 08:47:31.870636
51	36	2023-10-24 08:47:31.870636
52	36	2023-10-24 08:47:31.870636
53	36	2023-10-24 08:47:31.870636
54	36	2023-10-24 08:47:31.870636
55	36	2023-10-24 08:47:31.870636
56	36	2023-10-24 08:47:31.870636
57	36	2023-10-24 08:47:31.870636
58	36	2023-10-24 08:47:31.870636
7	37	2023-10-24 08:57:09.604668
13	37	2023-10-24 08:57:09.604668
14	37	2023-10-24 08:57:09.604668
19	37	2023-10-24 08:57:09.604668
21	37	2023-10-24 08:57:09.604668
26	37	2023-10-24 08:57:09.604668
37	37	2023-10-24 08:57:09.604668
39	37	2023-10-24 08:57:09.604668
41	37	2023-10-24 08:57:09.604668
42	37	2023-10-24 08:57:09.604668
43	37	2023-10-24 08:57:09.604668
44	37	2023-10-24 08:57:09.604668
45	37	2023-10-24 08:57:09.604668
46	37	2023-10-24 08:57:09.604668
47	37	2023-10-24 08:57:09.604668
49	37	2023-10-24 08:57:09.604668
50	37	2023-10-24 08:57:09.604668
51	37	2023-10-24 08:57:09.604668
52	37	2023-10-24 08:57:09.604668
53	37	2023-10-24 08:57:09.604668
55	37	2023-10-24 08:57:09.604668
56	37	2023-10-24 08:57:09.604668
58	37	2023-10-24 08:57:09.604668
59	37	2023-10-24 08:57:09.604668
60	37	2023-10-24 08:57:09.604668
61	37	2023-10-24 08:57:09.604668
62	37	2023-10-24 08:57:09.604668
63	37	2023-10-24 08:57:09.604668
64	37	2023-10-24 08:57:09.604668
7	38	2023-10-25 13:10:40.107655
13	38	2023-10-25 13:10:40.107655
14	38	2023-10-25 13:10:40.107655
19	38	2023-10-25 13:10:40.107655
21	38	2023-10-25 13:10:40.107655
26	38	2023-10-25 13:10:40.107655
37	38	2023-10-25 13:10:40.107655
38	38	2023-10-25 13:10:40.107655
39	38	2023-10-25 13:10:40.107655
41	38	2023-10-25 13:10:40.107655
43	38	2023-10-25 13:10:40.107655
44	38	2023-10-25 13:10:40.107655
45	38	2023-10-25 13:10:40.107655
46	38	2023-10-25 13:10:40.107655
47	38	2023-10-25 13:10:40.107655
49	38	2023-10-25 13:10:40.107655
50	38	2023-10-25 13:10:40.107655
51	38	2023-10-25 13:10:40.107655
53	38	2023-10-25 13:10:40.107655
56	38	2023-10-25 13:10:40.107655
59	38	2023-10-25 13:10:40.107655
60	38	2023-10-25 13:10:40.107655
62	38	2023-10-25 13:10:40.107655
65	38	2023-10-25 13:10:40.107655
66	38	2023-10-25 13:10:40.107655
67	38	2023-10-25 13:10:40.107655
68	38	2023-10-25 13:10:40.107655
69	38	2023-10-25 13:10:40.107655
70	38	2023-10-25 13:10:40.107655
71	38	2023-10-25 13:10:40.107655
72	38	2023-10-25 13:10:40.107655
73	38	2023-10-25 13:10:40.107655
74	38	2023-10-25 13:10:40.107655
75	38	2023-10-25 13:10:40.107655
76	38	2023-10-25 13:10:40.107655
77	38	2023-10-25 13:10:40.107655
7	39	2023-10-25 13:12:23.210111
13	39	2023-10-25 13:12:23.210111
14	39	2023-10-25 13:12:23.210111
21	39	2023-10-25 13:12:23.210111
26	39	2023-10-25 13:12:23.210111
37	39	2023-10-25 13:12:23.210111
38	39	2023-10-25 13:12:23.210111
39	39	2023-10-25 13:12:23.210111
41	39	2023-10-25 13:12:23.210111
43	39	2023-10-25 13:12:23.210111
44	39	2023-10-25 13:12:23.210111
45	39	2023-10-25 13:12:23.210111
46	39	2023-10-25 13:12:23.210111
47	39	2023-10-25 13:12:23.210111
49	39	2023-10-25 13:12:23.210111
50	39	2023-10-25 13:12:23.210111
51	39	2023-10-25 13:12:23.210111
53	39	2023-10-25 13:12:23.210111
56	39	2023-10-25 13:12:23.210111
59	39	2023-10-25 13:12:23.210111
60	39	2023-10-25 13:12:23.210111
62	39	2023-10-25 13:12:23.210111
65	39	2023-10-25 13:12:23.210111
66	39	2023-10-25 13:12:23.210111
67	39	2023-10-25 13:12:23.210111
68	39	2023-10-25 13:12:23.210111
69	39	2023-10-25 13:12:23.210111
70	39	2023-10-25 13:12:23.210111
72	39	2023-10-25 13:12:23.210111
73	39	2023-10-25 13:12:23.210111
74	39	2023-10-25 13:12:23.210111
75	39	2023-10-25 13:12:23.210111
76	39	2023-10-25 13:12:23.210111
77	39	2023-10-25 13:12:23.210111
78	19	2023-10-30 05:49:47.883648
1	40	2023-11-22 10:04:02.127296
4	40	2023-11-22 10:04:02.127296
5	40	2023-11-22 10:04:02.127296
6	40	2023-11-22 10:04:02.127296
7	40	2023-11-22 10:04:02.127296
8	40	2023-11-22 10:04:02.127296
9	40	2023-11-22 10:04:02.127296
10	40	2023-11-22 10:04:02.127296
11	40	2023-11-22 10:04:02.127296
12	40	2023-11-22 10:04:02.127296
13	40	2023-11-22 10:04:02.127296
14	40	2023-11-22 10:04:02.127296
15	40	2023-11-22 10:04:02.127296
16	40	2023-11-22 10:04:02.127296
17	40	2023-11-22 10:04:02.127296
18	40	2023-11-22 10:04:02.127296
19	40	2023-11-22 10:04:02.127296
20	40	2023-11-22 10:04:02.127296
21	40	2023-11-22 10:04:02.127296
22	40	2023-11-22 10:04:02.127296
23	40	2023-11-22 10:04:02.127296
24	40	2023-11-22 10:04:02.127296
25	40	2023-11-22 10:04:02.127296
26	40	2023-11-22 10:04:02.127296
27	40	2023-11-22 10:04:02.127296
79	40	2023-11-22 10:23:57.229684
17	21	2023-11-23 07:34:51.376512
80	21	2023-11-23 07:37:22.264902
1	41	2023-12-06 12:53:05.946438
4	41	2023-12-06 12:53:05.946438
5	41	2023-12-06 12:53:05.946438
6	41	2023-12-06 12:53:05.946438
7	41	2023-12-06 12:53:05.946438
8	41	2023-12-06 12:53:05.946438
9	41	2023-12-06 12:53:05.946438
10	41	2023-12-06 12:53:05.946438
11	41	2023-12-06 12:53:05.946438
12	41	2023-12-06 12:53:05.946438
13	41	2023-12-06 12:53:05.946438
14	41	2023-12-06 12:53:05.946438
15	41	2023-12-06 12:53:05.946438
16	41	2023-12-06 12:53:05.946438
17	41	2023-12-06 12:53:05.946438
18	41	2023-12-06 12:53:05.946438
19	41	2023-12-06 12:53:05.946438
20	41	2023-12-06 12:53:05.946438
21	41	2023-12-06 12:53:05.946438
22	41	2023-12-06 12:53:05.946438
\.


--
-- Data for Name: evaluations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.evaluations (c_id, q_id, ai_answer, candidate_answer, score, last_updated, is_clue_used, is_flagged, time_taken, interview_id, question_number, tenant_id) FROM stdin;
24d10c44-640b-11ee-a33c-0dd4c2040095	4e80dfcb-5863-11ee-b780-1826497b5137	\N	\N	\N	2023-10-06 05:42:32.010514	\N	\N	\N	24d10c45-640b-11ee-a33c-0dd4c2040095	1	\N
24d10c44-640b-11ee-a33c-0dd4c2040095	6be023f9-5863-11ee-b6ff-1826497b5137	\N	\N	\N	2023-10-06 05:42:32.010514	\N	\N	\N	24d10c45-640b-11ee-a33c-0dd4c2040095	2	\N
24d10c44-640b-11ee-a33c-0dd4c2040095	838b6c0b-5863-11ee-99f6-1826497b5137	\N	\N	\N	2023-10-06 05:42:32.010514	\N	\N	\N	24d10c45-640b-11ee-a33c-0dd4c2040095	3	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	eafbe038-6730-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	1	\N
b9c33480-5952-11ee-a33c-0dd4c2040095	6be023f9-5863-11ee-b6ff-1826497b5137	{"Evaluation": "High", "Score": "9", "Reason": "The answer accurately explains the difference between continue and pass in Python.", "Correct Answer": "", "Question_Type": "Open-Ended"}	Continue will skip the current iteration of a loop and pass is used to bypass an empty block of code.	9	2023-09-22 14:20:30.394086	f	f	120	b9c33481-5952-11ee-a33c-0dd4c2040095	2	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	3bb415a8-673c-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	2	\N
b9c33480-5952-11ee-a33c-0dd4c2040095	4e80dfcb-5863-11ee-b780-1826497b5137	{"Evaluation": "High", "Score": 9, "Reason": "The answer accurately describes what a decorator is in Python and provides an example of how it is used. It also explains that a decorator is used to extend the functionality of a function. However, the answer could be improved by providing a more detailed explanation of how decorators work and their purpose in Python.", "Correct Answer": "", "Question_Type": "Open-Ended"}	used to extend function.\nuses @symbol to declared and used on the line before a function as given below.\n@route\ndef signal();\nthis means that the signal function can also use all functionalities of route.	9	2023-10-04 08:53:00.817319	t	f	120	b9c33481-5952-11ee-a33c-0dd4c2040095	1	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	a046ceba-6742-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	3	\N
b9c33480-5952-11ee-a33c-0dd4c2040095	838b6c0b-5863-11ee-99f6-1826497b5137	{"Evaluation": "Low", "Score": 2, "Reason": "The provided answer is incorrect.", "Correct Answer": "numbers[1::2]", "Question_Type": "Closed"}	array=[1:len(array):2]	2	2023-10-04 09:39:51.089139	f	f	120	b9c33481-5952-11ee-a33c-0dd4c2040095	3	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	cfc53bfa-6755-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	4	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	81d0033c-6735-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	5	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	e63acf26-673c-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	6	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	12589016-673d-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	7	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	4ab98cee-673d-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	8	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	3d41f458-6746-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	9	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	4d5a077a-6757-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	10	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	4dd5f6a8-6736-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	11	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	6da3c4c0-673f-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	12	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	9dd45cca-6746-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	13	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	32078c8a-6758-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	14	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	585e607c-6738-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	15	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	92c8eea0-6740-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	16	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	db1fcc50-6740-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	17	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	257aaa7a-674d-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	18	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	9bb0654e-6758-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	19	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	ba9452e6-6739-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	20	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	1677d666-6742-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	21	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	52e3ae80-674d-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	22	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	c71e6aa6-674d-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	23	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	bf1a0b02-6758-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	24	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	df35e5f0-6758-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	25	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	ac743ca4-6694-11ee-8905-e454e805e8b9	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	26	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	ea27931a-6739-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	27	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	56e7a74e-6742-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	28	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	4e80dfcb-5863-11ee-b780-1826497b5137	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	29	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	6be023f9-5863-11ee-b6ff-1826497b5137	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	30	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	838b6c0b-5863-11ee-99f6-1826497b5137	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	31	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	96465a1e-674e-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	32	\N
72e29b7b-6903-11ee-9fb2-e454e805e8b9	0a302754-675c-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-12 13:30:01.882202	\N	\N	\N	72e86a09-6903-11ee-a3e7-e454e805e8b9	33	\N
47c3016a-74b6-11ee-a33c-0dd4c2040095	dd3b1616-74b5-11ee-a33c-0dd4c2040095	{"Evaluation": "Low", "Score": 2, "Reason": "The next number in the series is 21, not 26.", "Correct Answer": "21", "Question_Type": "Closed"}	26	2	2023-10-27 10:49:51.297496	f	f	120	47c3016b-74b6-11ee-a33c-0dd4c2040095	1	d3fb23da-74b4-11ee-a33c-0dd4c2040095
10dd9ff0-9434-11ee-a33c-0dd4c2040095	5852e78e-89d3-11ee-a33c-0dd4c2040095	{"Evaluation": "Low", "Score": 2, "Reason": "The answer is vague and does not provide specific information about the ways to convert text into features.", "Correct Answer": "Some common ways to convert text into features include bag-of-words representation, TF-IDF representation, word embeddings, and n-grams.", "Question_Type": "Open-Ended"}	CAn convert via various different methods	2	2023-12-06 12:46:14.015943	f	f	120	10dd9ff1-9434-11ee-a33c-0dd4c2040095	2	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
10dd9ff0-9434-11ee-a33c-0dd4c2040095	fe57bcaa-89d2-11ee-a33c-0dd4c2040095	{"Evaluation": "Low", "Score": 2, "Reason": "The answer is incorrect and does not accurately explain what random means in random forest.", "Correct Answer": "In random forest, 'random' refers to the process of randomly selecting a subset of features and data samples to build each individual decision tree in the ensemble.", "Question_Type": "Open-Ended"}	random forest is finding the  different numbers in a group	2	2023-12-06 12:46:14.015943	f	f	120	10dd9ff1-9434-11ee-a33c-0dd4c2040095	1	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	eafbe038-6730-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-10 11:19:28.992724	\N	\N	\N	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	1	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	3bb415a8-673c-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-10 11:19:28.992724	\N	\N	\N	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	2	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	a046ceba-6742-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-10 11:19:28.992724	\N	\N	\N	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	3	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	cfc53bfa-6755-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-10 11:19:28.992724	\N	\N	\N	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	4	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	81d0033c-6735-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-10 11:19:28.992724	\N	\N	\N	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	5	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	e63acf26-673c-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-10 11:19:28.992724	\N	\N	\N	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	6	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	4ab98cee-673d-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-10 11:19:28.992724	\N	\N	\N	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	8	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	3d41f458-6746-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-10 11:19:28.992724	\N	\N	\N	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	9	\N
53ccb20a-5b78-11ee-bf5b-5405dbcf43b8	4e80dfcb-5863-11ee-b780-1826497b5137	{"Evaluation": "Low", "Score": 2, "Reason": "The answer provided is incorrect.", "Correct Answer": "A decorator in Python is a design pattern that allows a user to add new functionality to an existing object or function without modifying its structure.", "Question_Type": "Open-Ended"}	fffgg	2	2023-09-25 07:53:07.834373	t	f	120	53d1a0b6-5b78-11ee-aa5e-5405dbcf43b8	3	\N
53ccb20a-5b78-11ee-bf5b-5405dbcf43b8	6be023f9-5863-11ee-b6ff-1826497b5137	{"Evaluation": "Low", "Score": 1, "Reason": "The provided answer is incorrect.", "Correct Answer": "The 'continue' statement is used to skip the rest of the code inside a loop and move to the next iteration, while the 'pass' statement is used as a placeholder for code that will be implemented later. 'pass' does nothing and is used when a statement is required syntactically but you don't want to execute any code.", "Question_Type": "Open-Ended"}	ggdfdf	1	2023-09-25 07:53:07.834373	f	f	120	53d1a0b6-5b78-11ee-aa5e-5405dbcf43b8	4	\N
53ccb20a-5b78-11ee-bf5b-5405dbcf43b8	838b6c0b-5863-11ee-99f6-1826497b5137	{"Evaluation": "Low", "Score": 2, "Reason": "The answer provided is incorrect.", "Correct Answer": "numbers[1::2]", "Question_Type": "Closed"}	[0:2:5]	2	2023-09-25 07:53:07.834373	f	f	120	53d1a0b6-5b78-11ee-aa5e-5405dbcf43b8	5	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	4d5a077a-6757-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-10 11:19:28.992724	\N	\N	\N	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	10	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	4dd5f6a8-6736-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-10 11:19:28.992724	\N	\N	\N	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	11	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	6da3c4c0-673f-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-10 11:19:28.992724	\N	\N	\N	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	12	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	9dd45cca-6746-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-10 11:19:28.992724	\N	\N	\N	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	13	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	585e607c-6738-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-10 11:19:28.992724	\N	\N	\N	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	15	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	92c8eea0-6740-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-10 11:19:28.992724	\N	\N	\N	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	16	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	db1fcc50-6740-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-10 11:19:28.992724	\N	\N	\N	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	17	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	9bb0654e-6758-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-10 11:19:28.992724	\N	\N	\N	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	19	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	ba9452e6-6739-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-10 11:19:28.992724	\N	\N	\N	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	20	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	52e3ae80-674d-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-10 11:19:28.992724	\N	\N	\N	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	22	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	c71e6aa6-674d-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-10 11:19:28.992724	\N	\N	\N	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	23	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	bf1a0b02-6758-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-10 11:19:28.992724	\N	\N	\N	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	24	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	df35e5f0-6758-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-10 11:19:28.992724	\N	\N	\N	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	25	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	ac743ca4-6694-11ee-8905-e454e805e8b9	\N	\N	\N	2023-10-10 11:19:28.992724	\N	\N	\N	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	26	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	ea27931a-6739-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-10 11:19:28.992724	\N	\N	\N	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	27	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	56e7a74e-6742-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-10 11:19:28.992724	\N	\N	\N	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	28	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	4e80dfcb-5863-11ee-b780-1826497b5137	\N	\N	\N	2023-10-10 11:19:28.992724	\N	\N	\N	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	29	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	6be023f9-5863-11ee-b6ff-1826497b5137	\N	\N	\N	2023-10-10 11:19:28.992724	\N	\N	\N	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	30	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	838b6c0b-5863-11ee-99f6-1826497b5137	\N	\N	\N	2023-10-10 11:19:28.992724	\N	\N	\N	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	31	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	96465a1e-674e-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-10 11:19:28.992724	\N	\N	\N	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	32	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	0a302754-675c-11ee-a33c-0dd4c2040095	\N	asdffgffg	\N	2023-10-10 12:21:57.772142	f	f	120	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	33	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	12589016-673d-11ee-a33c-0dd4c2040095	\N	affggaf	\N	2023-10-10 12:22:01.386115	f	f	120	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	7	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	1677d666-6742-11ee-a33c-0dd4c2040095	\N	asfgag	\N	2023-10-10 12:22:04.974984	f	f	120	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	21	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	257aaa7a-674d-11ee-a33c-0dd4c2040095	\N	afgagg	\N	2023-10-10 12:22:09.110914	f	f	120	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	18	\N
e0ba3b6e-675e-11ee-a33c-0dd4c2040095	32078c8a-6758-11ee-a33c-0dd4c2040095	\N	asfgag	\N	2023-10-10 12:22:12.686411	f	f	120	e0ba3b6f-675e-11ee-a33c-0dd4c2040095	14	\N
fd402890-699b-11ee-a33c-0dd4c2040095	eafbe038-6730-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	1	\N
fd402890-699b-11ee-a33c-0dd4c2040095	3bb415a8-673c-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	2	\N
fd402890-699b-11ee-a33c-0dd4c2040095	a046ceba-6742-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	3	\N
fd402890-699b-11ee-a33c-0dd4c2040095	cfc53bfa-6755-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	4	\N
fd402890-699b-11ee-a33c-0dd4c2040095	81d0033c-6735-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	5	\N
fd402890-699b-11ee-a33c-0dd4c2040095	e63acf26-673c-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	6	\N
fd402890-699b-11ee-a33c-0dd4c2040095	12589016-673d-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	7	\N
fd402890-699b-11ee-a33c-0dd4c2040095	4ab98cee-673d-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	8	\N
fd402890-699b-11ee-a33c-0dd4c2040095	3d41f458-6746-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	9	\N
fd402890-699b-11ee-a33c-0dd4c2040095	4d5a077a-6757-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	10	\N
fd402890-699b-11ee-a33c-0dd4c2040095	4dd5f6a8-6736-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	11	\N
fd402890-699b-11ee-a33c-0dd4c2040095	6da3c4c0-673f-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	12	\N
fd402890-699b-11ee-a33c-0dd4c2040095	9dd45cca-6746-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	13	\N
fd402890-699b-11ee-a33c-0dd4c2040095	32078c8a-6758-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	14	\N
fd402890-699b-11ee-a33c-0dd4c2040095	585e607c-6738-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	15	\N
fd402890-699b-11ee-a33c-0dd4c2040095	92c8eea0-6740-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	16	\N
fd402890-699b-11ee-a33c-0dd4c2040095	db1fcc50-6740-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	17	\N
fd402890-699b-11ee-a33c-0dd4c2040095	257aaa7a-674d-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	18	\N
fd402890-699b-11ee-a33c-0dd4c2040095	9bb0654e-6758-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	19	\N
fd402890-699b-11ee-a33c-0dd4c2040095	ba9452e6-6739-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	20	\N
fd402890-699b-11ee-a33c-0dd4c2040095	1677d666-6742-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	21	\N
fd402890-699b-11ee-a33c-0dd4c2040095	52e3ae80-674d-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	22	\N
fd402890-699b-11ee-a33c-0dd4c2040095	c71e6aa6-674d-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	23	\N
fd402890-699b-11ee-a33c-0dd4c2040095	bf1a0b02-6758-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	24	\N
fd402890-699b-11ee-a33c-0dd4c2040095	df35e5f0-6758-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	25	\N
fd402890-699b-11ee-a33c-0dd4c2040095	ac743ca4-6694-11ee-8905-e454e805e8b9	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	26	\N
fd402890-699b-11ee-a33c-0dd4c2040095	ea27931a-6739-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	27	\N
fd402890-699b-11ee-a33c-0dd4c2040095	56e7a74e-6742-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	28	\N
fd402890-699b-11ee-a33c-0dd4c2040095	4e80dfcb-5863-11ee-b780-1826497b5137	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	29	\N
fd402890-699b-11ee-a33c-0dd4c2040095	6be023f9-5863-11ee-b6ff-1826497b5137	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	30	\N
983f492c-680a-11ee-a33c-0dd4c2040095	eafbe038-6730-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	1	\N
983f492c-680a-11ee-a33c-0dd4c2040095	3bb415a8-673c-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	2	\N
983f492c-680a-11ee-a33c-0dd4c2040095	a046ceba-6742-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	3	\N
983f492c-680a-11ee-a33c-0dd4c2040095	cfc53bfa-6755-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	4	\N
983f492c-680a-11ee-a33c-0dd4c2040095	81d0033c-6735-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	5	\N
983f492c-680a-11ee-a33c-0dd4c2040095	e63acf26-673c-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	6	\N
983f492c-680a-11ee-a33c-0dd4c2040095	12589016-673d-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	7	\N
983f492c-680a-11ee-a33c-0dd4c2040095	4ab98cee-673d-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	8	\N
983f492c-680a-11ee-a33c-0dd4c2040095	3d41f458-6746-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	9	\N
8f3b9f8d-5c50-11ee-b93d-5405dbcf43b8	4e80dfcb-5863-11ee-b780-1826497b5137	{"Evaluation": "Average", "Score": "6", "Reason": "The answer provides a basic definition of a decorator in Python, but it lacks clarity and specific examples. It could be improved by providing more details on how decorators are used and examples of their implementation.", "Correct Answer": "A decorator is a design pattern in Python that allows a user to add new functionality to an existing object or function without modifying its structure. Decorators are implemented using the @ symbol and can be used to modify the behavior of functions, classes, or methods.", "Question_Type": "Open-Ended"}	A decorator is a class which is used to extend the basic Python functions. We use the add symbol. To define a declarative decorator.	6	2023-09-26 09:42:13.04538	f	f	120	8f4076be-5c50-11ee-968a-5405dbcf43b8	3	\N
8f3b9f8d-5c50-11ee-b93d-5405dbcf43b8	6be023f9-5863-11ee-b6ff-1826497b5137	{"Evaluation": "Average", "Score": 6, "Reason": "The answer provides a general understanding of the difference between continue and pass in Python, but it lacks specific details and examples.", "Correct Answer": "The 'continue' statement is used to skip the rest of the code inside a loop and move to the next iteration. It is typically used to bypass certain iterations based on a condition. On the other hand, the 'pass' statement is used as a placeholder when a statement is required syntactically but no action is needed. It is often used to escape empty segments of code or to create empty classes or functions.", "Question_Type": "Open-Ended"}	Continue to bypass loops and pass to escape empty segments of code.	6	2023-09-26 09:42:13.04538	f	f	120	8f4076be-5c50-11ee-968a-5405dbcf43b8	4	\N
8f3b9f8d-5c50-11ee-b93d-5405dbcf43b8	838b6c0b-5863-11ee-99f6-1826497b5137	{"Evaluation": "Low", "Score": 2, "Reason": "The answer provided is incorrect and syntactically incorrect. The slicing syntax should be [start:end:step].", "Correct Answer": "numbers[1:len(numbers):2]", "Question_Type": "Closed"}	[1:len(numbers:2]	2	2023-09-26 09:42:13.04538	f	f	120	8f4076be-5c50-11ee-968a-5405dbcf43b8	5	\N
983f492c-680a-11ee-a33c-0dd4c2040095	4d5a077a-6757-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	10	\N
983f492c-680a-11ee-a33c-0dd4c2040095	4dd5f6a8-6736-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	11	\N
983f492c-680a-11ee-a33c-0dd4c2040095	6da3c4c0-673f-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	12	\N
983f492c-680a-11ee-a33c-0dd4c2040095	9dd45cca-6746-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	13	\N
983f492c-680a-11ee-a33c-0dd4c2040095	32078c8a-6758-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	14	\N
983f492c-680a-11ee-a33c-0dd4c2040095	585e607c-6738-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	15	\N
983f492c-680a-11ee-a33c-0dd4c2040095	92c8eea0-6740-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	16	\N
983f492c-680a-11ee-a33c-0dd4c2040095	db1fcc50-6740-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	17	\N
983f492c-680a-11ee-a33c-0dd4c2040095	257aaa7a-674d-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	18	\N
983f492c-680a-11ee-a33c-0dd4c2040095	9bb0654e-6758-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	19	\N
983f492c-680a-11ee-a33c-0dd4c2040095	ba9452e6-6739-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	20	\N
983f492c-680a-11ee-a33c-0dd4c2040095	1677d666-6742-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	21	\N
983f492c-680a-11ee-a33c-0dd4c2040095	52e3ae80-674d-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	22	\N
983f492c-680a-11ee-a33c-0dd4c2040095	c71e6aa6-674d-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	23	\N
983f492c-680a-11ee-a33c-0dd4c2040095	bf1a0b02-6758-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	24	\N
983f492c-680a-11ee-a33c-0dd4c2040095	df35e5f0-6758-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	25	\N
983f492c-680a-11ee-a33c-0dd4c2040095	ac743ca4-6694-11ee-8905-e454e805e8b9	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	26	\N
983f492c-680a-11ee-a33c-0dd4c2040095	ea27931a-6739-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	27	\N
983f492c-680a-11ee-a33c-0dd4c2040095	56e7a74e-6742-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	28	\N
983f492c-680a-11ee-a33c-0dd4c2040095	4e80dfcb-5863-11ee-b780-1826497b5137	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	29	\N
983f492c-680a-11ee-a33c-0dd4c2040095	6be023f9-5863-11ee-b6ff-1826497b5137	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	30	\N
983f492c-680a-11ee-a33c-0dd4c2040095	838b6c0b-5863-11ee-99f6-1826497b5137	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	31	\N
983f492c-680a-11ee-a33c-0dd4c2040095	96465a1e-674e-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	32	\N
983f492c-680a-11ee-a33c-0dd4c2040095	0a302754-675c-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-11 07:48:40.828856	\N	\N	\N	983f492d-680a-11ee-a33c-0dd4c2040095	33	\N
fd402890-699b-11ee-a33c-0dd4c2040095	838b6c0b-5863-11ee-99f6-1826497b5137	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	31	\N
fd402890-699b-11ee-a33c-0dd4c2040095	96465a1e-674e-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	32	\N
fd402890-699b-11ee-a33c-0dd4c2040095	0a302754-675c-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-13 07:41:58.462059	\N	\N	\N	fd402891-699b-11ee-a33c-0dd4c2040095	33	\N
448a0c3a-76e8-11ee-a33c-0dd4c2040095	30a3d0e8-76e8-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-30 05:50:44.939822	\N	\N	\N	448a0c3b-76e8-11ee-a33c-0dd4c2040095	1	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
448a0c3a-76e8-11ee-a33c-0dd4c2040095	32b066da-76e8-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-30 05:50:44.939822	\N	\N	\N	448a0c3b-76e8-11ee-a33c-0dd4c2040095	2	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
448a0c3a-76e8-11ee-a33c-0dd4c2040095	3550680e-76e8-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-30 05:50:44.939822	\N	\N	\N	448a0c3b-76e8-11ee-a33c-0dd4c2040095	3	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
6601365f-5c6e-11ee-a796-5405dbcf43b8	4e80dfcb-5863-11ee-b780-1826497b5137	\N	\N	\N	2023-09-26 13:12:53.12325	\N	\N	\N	660619b4-5c6e-11ee-a11f-5405dbcf43b8	1	\N
6601365f-5c6e-11ee-a796-5405dbcf43b8	6be023f9-5863-11ee-b6ff-1826497b5137	\N	\N	\N	2023-09-26 13:12:53.12325	\N	\N	\N	660619b4-5c6e-11ee-a11f-5405dbcf43b8	2	\N
6601365f-5c6e-11ee-a796-5405dbcf43b8	838b6c0b-5863-11ee-99f6-1826497b5137	\N	\N	\N	2023-09-26 13:12:53.12325	\N	\N	\N	660619b4-5c6e-11ee-a11f-5405dbcf43b8	3	\N
7abceb11-5c6e-11ee-b500-5405dbcf43b8	4e80dfcb-5863-11ee-b780-1826497b5137	\N	\N	\N	2023-09-26 13:13:27.900678	\N	\N	\N	7abf660f-5c6e-11ee-b9a1-5405dbcf43b8	1	\N
7abceb11-5c6e-11ee-b500-5405dbcf43b8	6be023f9-5863-11ee-b6ff-1826497b5137	\N	\N	\N	2023-09-26 13:13:27.900678	\N	\N	\N	7abf660f-5c6e-11ee-b9a1-5405dbcf43b8	2	\N
7abceb11-5c6e-11ee-b500-5405dbcf43b8	838b6c0b-5863-11ee-99f6-1826497b5137	\N	\N	\N	2023-09-26 13:13:27.900678	\N	\N	\N	7abf660f-5c6e-11ee-b9a1-5405dbcf43b8	3	\N
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	eafbe038-6730-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	1	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	3bb415a8-673c-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	2	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	a046ceba-6742-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	3	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	cfc53bfa-6755-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	4	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	81d0033c-6735-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	5	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	e63acf26-673c-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	6	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	12589016-673d-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	7	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	4ab98cee-673d-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	8	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	3d41f458-6746-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	9	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	4d5a077a-6757-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	10	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	4dd5f6a8-6736-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	11	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	6da3c4c0-673f-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	12	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	9dd45cca-6746-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	13	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	32078c8a-6758-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	14	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	585e607c-6738-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	15	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	92c8eea0-6740-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	16	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	db1fcc50-6740-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	17	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	257aaa7a-674d-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	18	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	9bb0654e-6758-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	19	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	ba9452e6-6739-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	20	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	1677d666-6742-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	21	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	52e3ae80-674d-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	22	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	c71e6aa6-674d-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	23	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	bf1a0b02-6758-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	24	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	df35e5f0-6758-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	25	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	ac743ca4-6694-11ee-8905-e454e805e8b9	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	26	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	ea27931a-6739-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	27	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	56e7a74e-6742-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	28	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	4e80dfcb-5863-11ee-b780-1826497b5137	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	29	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	6be023f9-5863-11ee-b6ff-1826497b5137	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	30	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	838b6c0b-5863-11ee-99f6-1826497b5137	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	31	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	96465a1e-674e-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	32	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d20-6c0b-11ee-a33c-0dd4c2040095	0a302754-675c-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-16 10:02:24.428981	\N	\N	\N	1ac04d21-6c0b-11ee-a33c-0dd4c2040095	33	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
42c1be64-78a2-11ee-a33c-0dd4c2040095	eab72118-7230-11ee-a33c-0dd4c2040095	{"Evaluation": "Low", "Score": 2, "Reason": "The answer provided is not relevant to the question.", "Correct Answer": "", "Question_Type": "Open-Ended"}	adasda	2	2023-11-02 07:28:28.761826	f	f	120	42c1be65-78a2-11ee-a33c-0dd4c2040095	1	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
ae44a73d-5ec8-11ee-88cc-5405dbcf43b8	4e80dfcb-5863-11ee-b780-1826497b5137	{"Evaluation": "Average", "Score": 6, "Reason": "The answer provides a general understanding of decorators in Python, but it lacks specific details and examples.", "Correct Answer": "Decorators are a way to modify or enhance the behavior of functions or classes in Python by wrapping them with other functions or classes. They are typically used to add functionality to existing code without modifying it directly. Decorators are defined using the @ symbol followed by the name of the decorator function or class. They are commonly used in frameworks like Flask and Django to implement features such as authentication, logging, and caching.", "Question_Type": "Open-Ended"}	decorators are used for extending python objects	6	2023-09-29 13:06:48.622499	t	f	120	ae48bd9f-5ec8-11ee-9ad9-5405dbcf43b8	1	\N
ae44a73d-5ec8-11ee-88cc-5405dbcf43b8	6be023f9-5863-11ee-b6ff-1826497b5137	{"Evaluation": "High", "Score": 9, "Reason": "The answer accurately explains the difference between continue and pass in Python. It correctly states that continue is used to skip the remaining code in the current iteration and move to the next iteration of the loop, while pass is a placeholder for an empty block of code.", "Correct Answer": "", "Question_Type": "Open-Ended"}	Continue is used to skip the follow up execution and run to the next iteration of the loop and pass is a placeholder for a empty block.	9	2023-09-29 13:06:48.622499	f	f	120	ae48bd9f-5ec8-11ee-9ad9-5405dbcf43b8	2	\N
ae44a73d-5ec8-11ee-88cc-5405dbcf43b8	838b6c0b-5863-11ee-99f6-1826497b5137	{"Evaluation": "Low", "Score": 2, "Reason": "The answer provided is incorrect. The slicing syntax used is incorrect. To print just the even numbers using array/list slicing, the correct syntax would be 'numbers[1::2]'."}	numbers[1:2:2]	2	2023-09-29 13:06:48.622499	f	f	120	ae48bd9f-5ec8-11ee-9ad9-5405dbcf43b8	3	\N
7f80b9e4-7952-11ee-a33c-0dd4c2040095	eab72118-7230-11ee-a33c-0dd4c2040095	{"Evaluation": "Low", "Score": 2, "Reason": "The user prompt is empty, so it is not possible to evaluate the answer accurately. Please provide more information or a specific question.", "Correct Answer": "N/A", "Question_Type": "N/A"}	answer	2	2023-11-02 12:04:36.626254	f	f	120	7f80b9e5-7952-11ee-a33c-0dd4c2040095	1	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
efccd448-6d19-11ee-a33c-0dd4c2040095	68a7516a-6d18-11ee-a33c-0dd4c2040095	{"Evaluation": "High", "Score": 9, "Reason": "The answer provides a clear explanation of when to use a cloud solution and when not to use it. It mentions factors such as scalability, availability, and data integrity. It also provides a valid reason for not using a cloud solution if there are concerns about data integrity and the need to protect proprietary data. Overall, the answer is comprehensive and covers the main considerations for using or not using a cloud solution.", "Correct Answer": "", "Question_Type": "Open-Ended"}	It depends on several factors, most importantly cloud solutions are highly scalable because we can rent resources on demand whereas if we custom infra we can's scale quickly it might take a matter of days to scale. Availability is one other parameter which favours towards cloud. Usually Cloud is also considered safe. But one main reason not to use cloud infra would be if you are very much worried about data integrity and have some really important proprietary data like IP its better to use our own infra and keep the data encrypted insde. 	9	2023-10-17 18:27:46.708871	f	f	120	efccd449-6d19-11ee-a33c-0dd4c2040095	2	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
efccd448-6d19-11ee-a33c-0dd4c2040095	7d5b257c-6d19-11ee-a33c-0dd4c2040095	{"Evaluation": "Average", "Score": "6", "Reason": "The answer provides a range of 10-15 years of experience, which is accurate. However, it would be helpful to provide more specific information about the skills and qualifications required to become a Data Architect. Additionally, the answer mentions 'solutioning steams' which may be a typo or unclear terminology.", "Correct Answer": "A person would typically need 10-15 years of experience and a strong background in data management, database design, and data analysis to become a Data Architect.", "Question_Type": "Open-Ended"}	It is not a fixed value but based on experience they need 10-15 year and a lot of experience working in a range of solutioning steams.	6	2023-10-17 18:27:46.708871	f	f	120	efccd449-6d19-11ee-a33c-0dd4c2040095	4	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
efccd448-6d19-11ee-a33c-0dd4c2040095	ad7f69bc-6d18-11ee-a33c-0dd4c2040095	{"Evaluation": "Average", "Score": "5", "Reason": "The answer provides some information about the advantages of GCP over AWS, but it is not comprehensive. It mentions that some services of AWS may not be available in GCP, but does not provide any specific advantages of GCP. The answer also mentions that there may be workarounds, but does not elaborate on what those workarounds are. Overall, the answer is partially correct but lacks detail.", "Correct Answer": "Some advantages of GCP over AWS include better pricing options, more flexible and scalable infrastructure, and a wider range of machine learning and AI services.", "Question_Type": "Open-Ended"}	Both are same, some services of AWS may not be available in GCP, but there may be work arounds.	5	2023-10-17 18:27:46.708871	f	f	120	efccd449-6d19-11ee-a33c-0dd4c2040095	3	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
efccd448-6d19-11ee-a33c-0dd4c2040095	ddf29de6-6d16-11ee-a33c-0dd4c2040095	{"Evaluation": "High", "Score": "9", "Reason": "The answer accurately explains the difference between a data architect and a data engineer. It highlights that a data architect focuses on strategic decision-making and designing data solutions, while a data engineer is responsible for implementing and managing the data flow through the recommended technologies and services.", "Correct Answer": "", "Question_Type": "Open-Ended"}	Architecting a data solution is a strategic and experienced decision making process but data engineers work mainly on pipelining the data flow through the services and tech stacks suggested or identified by the architect.	9	2023-10-17 18:27:46.708871	f	f	120	efccd449-6d19-11ee-a33c-0dd4c2040095	1	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
ba0fc317-629f-11ee-951e-e04f4370e917	4e80dfcb-5863-11ee-b780-1826497b5137	{"Evaluation": "Average", "Score": 6, "Reason": "The answer provides a general understanding of decorators in Python, but it lacks clarity and precision. It could be improved by providing specific examples and explaining how decorators work in more detail.", "Correct Answer": "Decorators are a way to modify or enhance the behavior of functions or classes in Python. They are defined using the @ symbol followed by the decorator name, placed above the function or class definition. Decorators can be used to add functionality, such as logging or timing, to existing functions or classes without modifying their source code.", "Question_Type": "Open-Ended"}	decorators are used to extend the functionalities of python object with whatever the basic extra details that decorator function can actually do so anything defined as amperson symbol followed by a decorator name and the next line has function or an object which has different name that object is extended by the decorator	6	2023-10-04 10:28:11.624417	t	f	120	ba1408f5-629f-11ee-80df-e04f4370e917	1	\N
ba0fc317-629f-11ee-951e-e04f4370e917	6be023f9-5863-11ee-b6ff-1826497b5137	{"Evaluation": "High", "Score": 9, "Reason": "The answer accurately explains the difference between continue and pass in Python. It mentions that 'continue' is used to skip following iterations of a loop and move to the next iteration, while 'pass' is used as a placeholder for an empty block of code.", "Correct Answer": "", "Question_Type": "Open-Ended"}	continue is used in the context of a loop strictly within the context of a loop continue helps to skip following executions of a loop and go back to the next titration where as pass on the other hand is a General construct use within python where we just use it as a place told her to show empty block of code	9	2023-10-04 10:28:11.624417	f	f	120	ba1408f5-629f-11ee-80df-e04f4370e917	2	\N
ba0fc317-629f-11ee-951e-e04f4370e917	838b6c0b-5863-11ee-99f6-1826497b5137	{"Evaluation": "Low", "Score": 2, "Reason": "The provided answer is incorrect.", "Correct Answer": "numbers[1:len(numbers):2]", "Question_Type": "Closed"}	count[1:len(count):2]	2	2023-10-04 10:28:11.624417	f	f	120	ba1408f5-629f-11ee-80df-e04f4370e917	3	\N
602b87e6-7c67-11ee-a33c-0dd4c2040095	eab72118-7230-11ee-a33c-0dd4c2040095	{"Evaluation": "Low", "Score": 2, "Reason": "The answer provided is not relevant to the question. Please provide a valid answer.", "Correct Answer": "", "Question_Type": "Open-Ended"}	sdfs	2	2023-11-09 10:25:04.169663	f	f	120	602b87e7-7c67-11ee-a33c-0dd4c2040095	1	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
654d7958-6dd2-11ee-a33c-0dd4c2040095	68a7516a-6d18-11ee-a33c-0dd4c2040095	{"Evaluation": "Average", "Score": 6, "Reason": "The answer provides some information about when to use and when not to use a cloud solution, but it lacks clarity and organization. The answer could be improved by providing specific examples and addressing potential drawbacks of using a cloud solution. Additionally, the answer contains some grammatical errors and could benefit from better structure.", "Correct Answer": "A more comprehensive answer would include points such as cost-effectiveness, scalability, data security, and flexibility as factors to consider when deciding whether to use a cloud solution or not.", "Question_Type": "Open-Ended"}	cloud solutions are used whenever we have to ensure availability and one other big benefit is cloud solutions are also scalable we can rent resources assignment we need where as on the other hand if we have a own infrastructure the biggest problem is we can't immediately rent hardwares as and when we require and the other good think about owning around infrastructure is if I have proprietory data and if I have it within my own infrastructure the data would be protected so that's the biggest advantage that own infra has over cloud infra.	6	2023-10-18 16:31:27.559384	f	f	120	654d7959-6dd2-11ee-a33c-0dd4c2040095	2	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
654d7958-6dd2-11ee-a33c-0dd4c2040095	7d5b257c-6d19-11ee-a33c-0dd4c2040095	{"Evaluation": "Average", "Score": 6, "Reason": "The answer provides a range of 8 to 12 years of experience, which is generally accurate. However, the explanation provided is not clear and contains some assumptions. It would be better to provide a more concise and specific answer.", "Correct Answer": "On average, it would take around 8 to 12 years of experience to become a Data Architect.", "Question_Type": "Open-Ended"}	on an average for a data architect to be required at least 8 to 12 years of experience because for a data architect he has to have seen multiple stacks of solution and more importantly he has to have worked on several different kind of projects assuming the average duration for a project is let's say it months for a proper data architect to have worked on 10 projects you have take in more than 8 years so this would be a two estimate	6	2023-10-18 16:31:27.559384	f	f	120	654d7959-6dd2-11ee-a33c-0dd4c2040095	4	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
654d7958-6dd2-11ee-a33c-0dd4c2040095	ad7f69bc-6d18-11ee-a33c-0dd4c2040095	{"Evaluation": "Low", "Score": 2, "Reason": "The answer is incorrect and does not provide any advantages of GCP over AWS. It also contains a grammatical error.", "Correct Answer": "Some advantages of GCP over AWS include better pricing options, superior data analytics capabilities, and a more user-friendly interface.", "Question_Type": "Open-Ended"}	gcp has access to Google and aw AWS has no Google	2	2023-10-18 16:31:27.559384	f	f	120	654d7959-6dd2-11ee-a33c-0dd4c2040095	3	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
654d7958-6dd2-11ee-a33c-0dd4c2040095	ddf29de6-6d16-11ee-a33c-0dd4c2040095	{"Evaluation": "Average", "Score": "6", "Reason": "The answer provides some differentiation between a data architect and a data engineer, but it lacks clarity and specific details.", "Correct Answer": "A data architect is responsible for designing the overall data architecture and making decisions about tools and solution stacks. A data engineer focuses on building data pipelines based on the data architect's plan.", "Question_Type": "Open-Ended"}	a data architect builds the architecture diagram he choses the tools and the solution stacks where I said data engineer his primary role is to build the pipelines as per the data Architects plan.	6	2023-10-18 16:31:27.559384	f	f	120	654d7959-6dd2-11ee-a33c-0dd4c2040095	1	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
5fccebe0-6368-11ee-a33c-0dd4c2040095	4e80dfcb-5863-11ee-b780-1826497b5137	\N	\N	\N	2023-10-05 10:17:23.005484	\N	\N	\N	5fccebe1-6368-11ee-a33c-0dd4c2040095	1	\N
5fccebe0-6368-11ee-a33c-0dd4c2040095	6be023f9-5863-11ee-b6ff-1826497b5137	\N	\N	\N	2023-10-05 10:17:23.005484	\N	\N	\N	5fccebe1-6368-11ee-a33c-0dd4c2040095	2	\N
5fccebe0-6368-11ee-a33c-0dd4c2040095	838b6c0b-5863-11ee-99f6-1826497b5137	\N	\N	\N	2023-10-05 10:17:23.005484	\N	\N	\N	5fccebe1-6368-11ee-a33c-0dd4c2040095	3	\N
cafc50c6-70fb-11ee-9b22-e454e805e8b9	023bfcd0-70fb-11ee-9093-e454e805e8b9	{"Evaluation": "Average", "Score": 6, "Reason": "The answer provides a basic understanding of a stack in Java, but it could be more detailed and precise. It correctly mentions that a stack is a last in first out (LIFO) type of collection, but it could provide more information on how a stack is implemented in Java and its specific use cases. Additionally, the answer could be clearer in explaining how data is stacked and retrieved from a stack. Overall, the answer is average in terms of accuracy and completeness.", "Correct Answer": "A stack in Java is a data structure that follows the last in first out (LIFO) principle. It is implemented using the Stack class in Java and is used to store and retrieve data in a specific order. The push() method is used to add elements to the top of the stack, while the pop() method is used to remove and retrieve the topmost element. Other methods like peek() and isEmpty() are also available for stack operations."}	Stack is a last in first out type of collection in java which is used to stack a set of data and fetch the data which is at the top. the first data can be retrieved only at last	6	2023-10-22 16:59:24.519657	f	f	120	cb043a55-70fb-11ee-bc59-e454e805e8b9	2	45ea898a-6f5d-11ee-aca0-e454e805e8b9
cafc50c6-70fb-11ee-9b22-e454e805e8b9	4325fa80-70fa-11ee-8198-e454e805e8b9	{"Evaluation": "Average", "Score": "6", "Reason": "The answer provides some information about the types of collections available in Java, but it is not comprehensive. It mentions tree, map, and list, but does not provide any details about their characteristics or usage. Additionally, the answer mentions that there are multiple collections of subclasses available, but does not provide any examples or further explanation. Overall, the answer is partially correct but lacks sufficient detail.", "Correct Answer": "The types of collections available in Java include List, Set, and Map. List is an ordered collection that allows duplicate elements, Set is an unordered collection that does not allow duplicate elements, and Map is a collection that maps keys to values. Each of these types has multiple implementations, such as ArrayList and LinkedList for List, HashSet and TreeSet for Set, and HashMap and TreeMap for Map.", "Question_Type": "Open-Ended"}	types of collections in java are tree, map, list. user these major collection multiple collections of sub classes are available. for example hashmap, linked list, hashset etc	6	2023-10-22 16:59:24.519657	f	f	120	cb043a55-70fb-11ee-bc59-e454e805e8b9	1	45ea898a-6f5d-11ee-aca0-e454e805e8b9
cafc50c6-70fb-11ee-9b22-e454e805e8b9	4eaab457-70fb-11ee-b320-e454e805e8b9	{"Evaluation": "High", "Score": 9, "Reason": "The syntax for defining a route in Flask is correct. The '@blueprint.route' decorator is used to define a route in Flask. The 'path' parameter specifies the URL path for the route, and the 'method' parameter specifies the HTTP method(s) that the route will respond to. The answer provided includes both the path and method parameters, which is accurate.", "Correct Answer": null, "Question_Type": "Open-Ended"}	@blueprint.route("path", method=["POST"])	9	2023-10-22 16:59:24.519657	f	f	120	cb043a55-70fb-11ee-bc59-e454e805e8b9	3	45ea898a-6f5d-11ee-aca0-e454e805e8b9
8b641956-7eeb-11ee-a33c-0dd4c2040095	eab72118-7230-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-11-09 10:34:21.604827	\N	\N	\N	8b641957-7eeb-11ee-a33c-0dd4c2040095	1	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
9336dd10-6368-11ee-a33c-0dd4c2040095	4e80dfcb-5863-11ee-b780-1826497b5137	\N	\N	\N	2023-10-05 10:18:49.262766	\N	\N	\N	9336dd11-6368-11ee-a33c-0dd4c2040095	1	\N
9336dd10-6368-11ee-a33c-0dd4c2040095	6be023f9-5863-11ee-b6ff-1826497b5137	\N	\N	\N	2023-10-05 10:18:49.262766	\N	\N	\N	9336dd11-6368-11ee-a33c-0dd4c2040095	2	\N
9336dd10-6368-11ee-a33c-0dd4c2040095	838b6c0b-5863-11ee-99f6-1826497b5137	\N	\N	\N	2023-10-05 10:18:49.262766	\N	\N	\N	9336dd11-6368-11ee-a33c-0dd4c2040095	3	\N
06aac2f2-6369-11ee-a33c-0dd4c2040095	4e80dfcb-5863-11ee-b780-1826497b5137	{"Evaluation": "Low", "Score": 2, "Reason": "The answer is empty.", "Correct Answer": "A decorator in Python is a design pattern that allows a user to add new functionality to an existing object or function without modifying its structure. It is implemented using the @ symbol followed by the name of the decorator function."}		2	2023-10-05 10:23:11.367443	f	f	120	06aac2f3-6369-11ee-a33c-0dd4c2040095	1	\N
06aac2f2-6369-11ee-a33c-0dd4c2040095	6be023f9-5863-11ee-b6ff-1826497b5137	{"Evaluation": "Low", "Score": 2, "Reason": "The answer is not provided.", "Correct Answer": "The 'continue' statement is used to skip the rest of the code in the current iteration of a loop and move to the next iteration. The 'pass' statement is used as a placeholder for code that will be added later and does nothing.", "Question_Type": "Open-Ended"}		2	2023-10-05 10:23:11.367443	f	f	120	06aac2f3-6369-11ee-a33c-0dd4c2040095	2	\N
06aac2f2-6369-11ee-a33c-0dd4c2040095	838b6c0b-5863-11ee-99f6-1826497b5137	{"Evaluation": "Low", "Score": 2, "Reason": "The answer is incorrect or missing.", "Correct Answer": "numbers[1::2]", "Question_Type": "Closed"}		2	2023-10-05 10:23:11.367443	f	f	120	06aac2f3-6369-11ee-a33c-0dd4c2040095	3	\N
12365b74-7230-11ee-a33c-0dd4c2040095	cfc53bfa-6755-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	4	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	c993e888-6cf7-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	5	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	412a3f2e-6e6e-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	6	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	26da8a58-6ef4-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	7	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	f3118dc4-6f12-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	8	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	56da4c88-6f13-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	9	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	59ab8fa8-6f13-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	10	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	76b5bd44-6f13-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	11	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	81d0033c-6735-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	12	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	e63acf26-673c-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	13	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	12589016-673d-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	14	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	4ab98cee-673d-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	15	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	3d41f458-6746-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	16	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	4d5a077a-6757-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	17	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	459c6daa-6d17-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	18	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	380aae06-6e73-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	19	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	1c4e7ae8-6f05-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	20	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	4dd5f6a8-6736-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	21	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	6da3c4c0-673f-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	22	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	9dd45cca-6746-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	23	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	32078c8a-6758-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	24	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	9f11f56a-6e81-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	25	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	f189cbc6-6f0b-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	26	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	54345a2c-6f14-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	27	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	563ce866-6f14-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	28	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	588be522-6f14-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	29	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	585e607c-6738-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	30	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	92c8eea0-6740-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	31	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	db1fcc50-6740-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	32	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	257aaa7a-674d-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	33	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	9bb0654e-6758-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	34	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	000f39b8-6e82-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	35	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	2d57f8fc-6f0d-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	36	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	02de9c24-6f0e-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	37	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	056f8bf6-6f0e-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	38	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	fe0fab8c-6f14-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	39	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	ba9452e6-6739-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	40	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	1677d666-6742-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	41	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	52e3ae80-674d-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	42	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	c71e6aa6-674d-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	43	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	bf1a0b02-6758-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	44	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	df35e5f0-6758-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	45	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	3c3ca94a-6e85-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	46	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	c048b52e-6f0e-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	47	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	c3ff43fe-6f0e-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	48	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	d6e67122-6f0e-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	49	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	1fb1e732-6f15-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	50	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	c27bfdcc-6f15-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	51	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	b3fdb824-722d-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	52	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	ac743ca4-6694-11ee-8905-e454e805e8b9	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	53	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	ea27931a-6739-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	54	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	56e7a74e-6742-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	55	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	4e80dfcb-5863-11ee-b780-1826497b5137	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	56	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	6be023f9-5863-11ee-b6ff-1826497b5137	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	57	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	3bb415a8-673c-11ee-a33c-0dd4c2040095	\N	asd	\N	2023-10-24 05:44:47.824304	f	f	120	12365b75-7230-11ee-a33c-0dd4c2040095	2	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	a046ceba-6742-11ee-a33c-0dd4c2040095	\N	sadadsa	\N	2023-10-24 05:45:03.507857	f	f	120	12365b75-7230-11ee-a33c-0dd4c2040095	3	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	838b6c0b-5863-11ee-99f6-1826497b5137	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	58	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	96465a1e-674e-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	59	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	0a302754-675c-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	60	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
a6f9cb14-6377-11ee-a33c-0dd4c2040095	4e80dfcb-5863-11ee-b780-1826497b5137	{"Evaluation": "Low", "Score": 2, "Reason": "The provided answer is incorrect and unrelated to the question. It seems to be a generic greeting instead of an explanation of what a decorator is in Python.", "Correct Answer": "A decorator in Python is a design pattern that allows a user to add new functionality to an existing object or function without modifying its structure. It is achieved by wrapping the original object or function with another function, which provides the desired additional behavior.", "Question_Type": "Open-Ended"}	hello hello hello	2	2023-10-05 12:42:42.231884	f	f	120	a6f9cb15-6377-11ee-a33c-0dd4c2040095	1	\N
a6f9cb14-6377-11ee-a33c-0dd4c2040095	6be023f9-5863-11ee-b6ff-1826497b5137	{"Evaluation": "Low", "Score": 2, "Reason": "The provided answer is incorrect.", "Correct Answer": "The 'continue' statement is used to skip the rest of the code inside a loop and move to the next iteration, while the 'pass' statement is used as a placeholder for code that will be implemented later. 'pass' does nothing and is used when a statement is required syntactically but you don't want any code to execute.", "Question_Type": "Open-Ended"}	dasdsadasdadsadssadsad	2	2023-10-05 12:42:42.231884	f	f	120	a6f9cb15-6377-11ee-a33c-0dd4c2040095	2	\N
a6f9cb14-6377-11ee-a33c-0dd4c2040095	838b6c0b-5863-11ee-99f6-1826497b5137	{"Evaluation": "Low", "Score": 2, "Reason": "The provided answer is not related to the question and does not provide any information about printing even numbers using array/list slicing.", "Correct Answer": "To print just even numbers using array/list slicing, you can use the following code: numbers = [1,2,3,4,5,6,7,8,9,10]\\neven_numbers = numbers[1::2]\\nprint(even_numbers)", "Question_Type": "Closed"}	d asndsand,san,dsa	2	2023-10-05 12:42:42.231884	f	f	120	a6f9cb15-6377-11ee-a33c-0dd4c2040095	3	\N
12365b74-7230-11ee-a33c-0dd4c2040095	a2959ce4-6db6-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	61	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	c0eb0c06-6db6-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	62	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	63c04864-6e85-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	63	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	8f5d4008-6e85-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	64	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	eb038aa6-6f12-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	65	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	f12f0e82-6f12-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	66	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b74-7230-11ee-a33c-0dd4c2040095	9b01b136-6f21-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-24 05:42:08.458733	\N	\N	\N	12365b75-7230-11ee-a33c-0dd4c2040095	67	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
4689f8a2-7ef3-11ee-a33c-0dd4c2040095	eab72118-7230-11ee-a33c-0dd4c2040095	{"Evaluation": "Low", "Score": 2, "Reason": "The user did not provide an answer to the question.", "Correct Answer": "N/A", "Question_Type": "Open-Ended"}		2	2023-11-09 13:17:34.873427	f	f	120	4689f8a3-7ef3-11ee-a33c-0dd4c2040095	1	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
fd606e10-637a-11ee-a33c-0dd4c2040095	4e80dfcb-5863-11ee-b780-1826497b5137	\N	\N	\N	2023-10-05 12:30:38.315277	\N	\N	\N	fd606e11-637a-11ee-a33c-0dd4c2040095	1	\N
fd606e10-637a-11ee-a33c-0dd4c2040095	6be023f9-5863-11ee-b6ff-1826497b5137	\N	\N	\N	2023-10-05 12:30:38.315277	\N	\N	\N	fd606e11-637a-11ee-a33c-0dd4c2040095	2	\N
fd606e10-637a-11ee-a33c-0dd4c2040095	838b6c0b-5863-11ee-99f6-1826497b5137	\N	\N	\N	2023-10-05 12:30:38.315277	\N	\N	\N	fd606e11-637a-11ee-a33c-0dd4c2040095	3	\N
0f497aa8-637c-11ee-a33c-0dd4c2040095	4e80dfcb-5863-11ee-b780-1826497b5137	\N	\N	\N	2023-10-05 12:38:17.859848	\N	\N	\N	0f497aa9-637c-11ee-a33c-0dd4c2040095	1	\N
0f497aa8-637c-11ee-a33c-0dd4c2040095	6be023f9-5863-11ee-b6ff-1826497b5137	\N	\N	\N	2023-10-05 12:38:17.859848	\N	\N	\N	0f497aa9-637c-11ee-a33c-0dd4c2040095	2	\N
0f497aa8-637c-11ee-a33c-0dd4c2040095	838b6c0b-5863-11ee-99f6-1826497b5137	\N	\N	\N	2023-10-05 12:38:17.859848	\N	\N	\N	0f497aa9-637c-11ee-a33c-0dd4c2040095	3	\N
12365b74-7230-11ee-a33c-0dd4c2040095	eafbe038-6730-11ee-a33c-0dd4c2040095	\N	wfsaf	\N	2023-10-24 05:44:08.893419	f	f	120	12365b75-7230-11ee-a33c-0dd4c2040095	1	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
189f8186-5866-11ee-a33c-0dd4c2040095	4e80dfcb-5863-11ee-b780-1826497b5137	\N	\N	\N	2023-09-21 10:03:21.804303	\N	\N	\N	189f8187-5866-11ee-a33c-0dd4c2040095	21	\N
189f8186-5866-11ee-a33c-0dd4c2040095	6be023f9-5863-11ee-b6ff-1826497b5137	\N	\N	\N	2023-09-21 10:03:21.804303	\N	\N	\N	189f8187-5866-11ee-a33c-0dd4c2040095	22	\N
189f8186-5866-11ee-a33c-0dd4c2040095	838b6c0b-5863-11ee-99f6-1826497b5137	\N	\N	\N	2023-09-21 10:03:21.804303	\N	\N	\N	189f8187-5866-11ee-a33c-0dd4c2040095	23	\N
d75ae316-637b-11ee-a33c-0dd4c2040095	4e80dfcb-5863-11ee-b780-1826497b5137	\N	\N	\N	2023-10-05 12:36:44.022545	\N	\N	\N	d75ae317-637b-11ee-a33c-0dd4c2040095	1	\N
d75ae316-637b-11ee-a33c-0dd4c2040095	6be023f9-5863-11ee-b6ff-1826497b5137	\N	\N	\N	2023-10-05 12:36:44.022545	\N	\N	\N	d75ae317-637b-11ee-a33c-0dd4c2040095	2	\N
d75ae316-637b-11ee-a33c-0dd4c2040095	838b6c0b-5863-11ee-99f6-1826497b5137	\N	\N	\N	2023-10-05 12:36:44.022545	\N	\N	\N	d75ae317-637b-11ee-a33c-0dd4c2040095	3	\N
fb027d06-7230-11ee-a33c-0dd4c2040095	eab72118-7230-11ee-a33c-0dd4c2040095	{"Evaluation": "High", "Score": 9, "Reason": "The answer provided is correct and matches the question.", "Correct Answer": "", "Question_Type": "Open-Ended"}	Dot net developer	9	2023-10-24 05:49:33.744838	f	f	120	fb027d07-7230-11ee-a33c-0dd4c2040095	1	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
7def4008-8dcc-11ee-a33c-0dd4c2040095	eab72118-7230-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-11-28 08:59:52.07128	\N	\N	\N	7def4009-8dcc-11ee-a33c-0dd4c2040095	1	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
402ab200-9d91-11ee-a33c-0dd4c2040095	5852e78e-89d3-11ee-a33c-0dd4c2040095	{"Evaluation": "Average", "Score": 6, "Reason": "The answer provides some information about converting text into features, but it is not very clear and contains some grammatical errors. It mentions using word counts and document frequency, as well as word embedding methods. However, it could be more specific and provide more details about each method.", "Correct Answer": "There are several ways to convert text into features. Some common methods include using word counts, where the total number of occurrences of each word within the text corpus is used as a feature. Another method is using term frequency-inverse document frequency (TF-IDF), which weighs down the importance of words based on their occurrences in the entire document collection. Additionally, word embedding methods can be used to create high-level representations of the text."}	There are various ways to convert text into features. The most prominent ones are to use their accounts. The total number of occurrences. Of each words within the text corpus, that is one and the other method is. To use the same counts but inverse that with document frequency so that the number of documents that it appears on South that we can weigh it down by. Occurrences. The other option is to. Use word embedding methods where embedding is a high level representation of. All the text that is there within the corpus.	6	2023-12-18 10:42:25.38755	f	f	120	402ab201-9d91-11ee-a33c-0dd4c2040095	2	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
402ab200-9d91-11ee-a33c-0dd4c2040095	fe57bcaa-89d2-11ee-a33c-0dd4c2040095	{"Evaluation": "High", "Score": "9", "Reason": "The answer accurately explains that 'random' in Random Forest refers to two things: the random subset of features chosen at each node and the random subsampling of the entire dataset shared by all trees in the forest. The explanation is clear and comprehensive.", "Correct Answer": "", "Question_Type": "Open-Ended"}	Random in Random Forest means two things. The first is. The subset or the random subset of the features that we choose at each and every nodes? And the second one is the random subsampling that we do on the entire data set, the data points that we share to all the trees that are part of the random forest.	9	2023-12-18 10:42:25.38755	f	f	120	402ab201-9d91-11ee-a33c-0dd4c2040095	1	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
8f0991b0-5864-11ee-a33c-0dd4c2040095	4e80dfcb-5863-11ee-b780-1826497b5137	\N	\N	\N	2023-09-21 09:52:21.476035	\N	\N	\N	8f0991b1-5864-11ee-a33c-0dd4c2040095	21	\N
8f0991b0-5864-11ee-a33c-0dd4c2040095	6be023f9-5863-11ee-b6ff-1826497b5137	\N	\N	\N	2023-09-21 09:52:21.476035	\N	\N	\N	8f0991b1-5864-11ee-a33c-0dd4c2040095	22	\N
8f0991b0-5864-11ee-a33c-0dd4c2040095	838b6c0b-5863-11ee-99f6-1826497b5137	\N	\N	\N	2023-09-21 09:52:21.476035	\N	\N	\N	8f0991b1-5864-11ee-a33c-0dd4c2040095	23	\N
9be86b4c-593e-11ee-a33c-0dd4c2040095	838b6c0b-5863-11ee-99f6-1826497b5137	{"Evaluation":"Low","Score":2,"Reason":"The provided answer is incorrect. The slicing syntax [1:len(array):2] will give odd numbers, not even numbers. To print just even numbers using array/list slicing, the correct syntax would be [1:len(array):2]. Additionally, the variable 'array' is not defined in the given code snippet. The correct variable to use would be 'numbers'.","Correct Answer":"numbers[1::2]","Question_Type":"Closed"}	[1:len(array):2]	2	2023-09-25 10:09:40.439906	f	f	120	9be86b4d-593e-11ee-a33c-0dd4c2040095	3	\N
3dffa370-5866-11ee-a33c-0dd4c2040095	4e80dfcb-5863-11ee-b780-1826497b5137	\N	it is nothing but	\N	2023-09-27 09:57:59.119638	t	f	120	3dffa371-5866-11ee-a33c-0dd4c2040095	21	\N
3dffa370-5866-11ee-a33c-0dd4c2040095	6be023f9-5863-11ee-b6ff-1826497b5137	\N	keep the appointment	\N	2023-09-27 09:58:47.413509	t	f	120	3dffa371-5866-11ee-a33c-0dd4c2040095	22	\N
3dffa370-5866-11ee-a33c-0dd4c2040095	838b6c0b-5863-11ee-99f6-1826497b5137	\N	[start:stop:step]	\N	2023-09-27 09:59:04.530042	t	f	120	3dffa371-5866-11ee-a33c-0dd4c2040095	23	\N
51485da2-73f3-11ee-a33c-0dd4c2040095	d57cadb4-73f1-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-26 11:32:17.298126	\N	\N	\N	51485da3-73f3-11ee-a33c-0dd4c2040095	1	d79dfb76-73f0-11ee-a33c-0dd4c2040095
51485da2-73f3-11ee-a33c-0dd4c2040095	2f0c8b64-73f3-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-26 11:32:17.298126	\N	\N	\N	51485da3-73f3-11ee-a33c-0dd4c2040095	2	d79dfb76-73f0-11ee-a33c-0dd4c2040095
51485da2-73f3-11ee-a33c-0dd4c2040095	cdd6f9a6-73f2-11ee-a33c-0dd4c2040095	\N	\N	\N	2023-10-26 11:32:17.298126	\N	\N	\N	51485da3-73f3-11ee-a33c-0dd4c2040095	3	d79dfb76-73f0-11ee-a33c-0dd4c2040095
f41beea0-9e3b-11ee-a33c-0dd4c2040095	5852e78e-89d3-11ee-a33c-0dd4c2040095	{"Evaluation": "Low", "Score": 2, "Reason": "The answer provided is incorrect and lacks knowledge about the topic. The correct answer is: There are several ways to convert text into features, such as bag-of-words, TF-IDF, word embeddings, and n-grams.", "Correct Answer": "There are several ways to convert text into features, such as bag-of-words, TF-IDF, word embeddings, and n-grams.", "Question_Type": "Open-Ended"}	I don't know.	2	2023-12-19 07:02:19.535437	f	f	120	f41beea1-9e3b-11ee-a33c-0dd4c2040095	2	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
f41beea0-9e3b-11ee-a33c-0dd4c2040095	fe57bcaa-89d2-11ee-a33c-0dd4c2040095	{"Evaluation": "Low", "Score": 2, "Reason": "The answer provided is incorrect and lacks knowledge about the topic. Random in random forest refers to the process of randomly selecting a subset of features and data samples to build each decision tree in the forest.", "Correct Answer": "Random in random forest refers to the process of randomly selecting a subset of features and data samples to build each decision tree in the forest.", "Question_Type": "Open-Ended"}	I don't know.	2	2023-12-19 07:02:19.535437	f	f	120	f41beea1-9e3b-11ee-a33c-0dd4c2040095	1	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
b4844954-5890-11ee-a33c-0dd4c2040095	4e80dfcb-5863-11ee-b780-1826497b5137	\N	\N	\N	2023-09-21 15:08:22.213845	\N	\N	\N	b4844955-5890-11ee-a33c-0dd4c2040095	21	\N
b4844954-5890-11ee-a33c-0dd4c2040095	6be023f9-5863-11ee-b6ff-1826497b5137	\N	\N	\N	2023-09-21 15:08:22.213845	\N	\N	\N	b4844955-5890-11ee-a33c-0dd4c2040095	22	\N
b4844954-5890-11ee-a33c-0dd4c2040095	838b6c0b-5863-11ee-99f6-1826497b5137	\N	\N	\N	2023-09-21 15:08:22.213845	\N	\N	\N	b4844955-5890-11ee-a33c-0dd4c2040095	23	\N
118b303a-591e-11ee-a33c-0dd4c2040095	4e80dfcb-5863-11ee-b780-1826497b5137	\N	\N	\N	2023-09-22 08:00:17.326871	\N	\N	\N	118b303b-591e-11ee-a33c-0dd4c2040095	1	\N
118b303a-591e-11ee-a33c-0dd4c2040095	6be023f9-5863-11ee-b6ff-1826497b5137	\N	\N	\N	2023-09-22 08:00:17.326871	\N	\N	\N	118b303b-591e-11ee-a33c-0dd4c2040095	2	\N
118b303a-591e-11ee-a33c-0dd4c2040095	838b6c0b-5863-11ee-99f6-1826497b5137	\N	\N	\N	2023-09-22 08:00:17.326871	\N	\N	\N	118b303b-591e-11ee-a33c-0dd4c2040095	3	\N
9be86b4c-593e-11ee-a33c-0dd4c2040095	4e80dfcb-5863-11ee-b780-1826497b5137	{"Evaluation": "Average", "Score": 6, "Reason": "The answer is partially correct, but it lacks specific details about how decorators work in Python.", "Correct Answer": "Decorators are a way to modify or enhance the behavior of a function without changing its source code directly. They allow you to wrap another function and modify its behavior before or after the wrapped function is called.", "Question_Type": "Open-Ended"}	Decorators are used to extend a function in Python.	6	2023-09-22 11:56:20.926292	t	f	120	9be86b4d-593e-11ee-a33c-0dd4c2040095	1	\N
54681750-592e-11ee-a33c-0dd4c2040095	4e80dfcb-5863-11ee-b780-1826497b5137	{"Evaluation": "Low", "Score": 2, "Reason": "The answer is not accurate and does not provide a clear explanation of what a decorator is in Python.", "Correct Answer": "A decorator in Python is a design pattern that allows a user to add new functionality to an existing object or function without modifying its structure. Decorators are implemented as functions that take another function as input and return a modified version of that function."}	Decorators are functions. That are actually used to extend the usage of other functions that we built in Python. And they typically start with the. Ampersand symbol. And we predominantly use that in Python Flask applications. In order to determine droughts.	2	2023-09-22 10:05:17.812907	t	f	120	54681751-592e-11ee-a33c-0dd4c2040095	1	\N
54681750-592e-11ee-a33c-0dd4c2040095	6be023f9-5863-11ee-b6ff-1826497b5137	{"Evaluation": "Low", "Score": 2, "Reason": "The answer is not clear and contains grammatical errors. It does not provide a clear explanation of the difference between continue and pass in Python.", "Correct Answer": "Continue is used to skip the current iteration and move to the next iteration of a loop, while pass is used as a placeholder for an empty block of code.", "Question_Type": "Open-Ended"}	Both are used in loops and conditions and especially continue is used to bypass the current iteration and then go to the next iteration of the loop. Whereas pass is actually used to. Bypass and empty body within a loop or a. Loop or ARM? Condition.	2	2023-09-22 10:05:17.812907	f	f	120	54681751-592e-11ee-a33c-0dd4c2040095	2	\N
54681750-592e-11ee-a33c-0dd4c2040095	838b6c0b-5863-11ee-99f6-1826497b5137	{"Evaluation":"High","Score":9,"Reason":"The answer correctly uses array/list slicing to extract only the even numbers from the given list. The explanation provided is clear and demonstrates a good understanding of the concept.","Correct Answer":"","Question_Type":"Closed"}	numbers[1:len(numbers):2] using this will give only the even numners, I started with index 1 to get to the first even number in the list which is 2 and from there on I skip by 2 till length of the numbers list. 	9	2023-09-22 10:05:17.812907	f	f	120	54681751-592e-11ee-a33c-0dd4c2040095	3	\N
9be86b4c-593e-11ee-a33c-0dd4c2040095	6be023f9-5863-11ee-b6ff-1826497b5137	{"Evaluation": "High", "Score": "9", "Reason": "The answer accurately explains the difference between continue and pass in Python.", "Correct Answer": "", "Question_Type": "Open-Ended"}	Continue is actually used to skip the current iteration of a loop and go to the next iteration and pass is used to bypass the empty blocks.	9	2023-09-22 11:56:20.926292	f	f	120	9be86b4d-593e-11ee-a33c-0dd4c2040095	2	\N
\.


--
-- Data for Name: industry; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.industry (id, name, created_by, updated_by, created_at, last_updated) FROM stdin;
1	Software Industry	4	\N	2023-08-22 16:48:22.068158	2023-08-22 16:48:22.068158
2	Content Design	4	\N	2023-09-18 12:15:38.740642	2023-09-18 12:15:38.740642
\.


--
-- Data for Name: interview; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.interview (i_id, c_id, dsg_id, no_of_questions, status, evaluation_status, last_updated, date_of_interview, eval_status_code, created_by, tenant_id) FROM stdin;
660619b4-5c6e-11ee-a11f-5405dbcf43b8	6601365f-5c6e-11ee-a796-5405dbcf43b8	1	3	PENDING	NOT_STARTED	2023-09-26 13:12:53.12325	2023-09-26 13:12:52.289784+00	\N	4	\N
7abf660f-5c6e-11ee-b9a1-5405dbcf43b8	7abceb11-5c6e-11ee-b500-5405dbcf43b8	1	3	PENDING	NOT_STARTED	2023-09-26 13:13:27.900678	2023-09-26 13:13:27.058587+00	\N	4	\N
3dffa371-5866-11ee-a33c-0dd4c2040095	3dffa370-5866-11ee-a33c-0dd4c2040095	1	23	IN_PROGRESS	NOT_STARTED	2023-09-27 09:56:05.838054	2023-09-21 10:04:24.519286+00	\N	4	\N
24d10c45-640b-11ee-a33c-0dd4c2040095	24d10c44-640b-11ee-a33c-0dd4c2040095	1	3	PENDING	NOT_STARTED	2023-10-06 05:42:32.010514	2023-10-06 05:42:32.02061+00	\N	4	\N
e0ba3b6f-675e-11ee-a33c-0dd4c2040095	e0ba3b6e-675e-11ee-a33c-0dd4c2040095	1	33	IN_PROGRESS	NOT_STARTED	2023-10-10 11:58:31.621112	2023-10-10 11:19:28.997767+00	\N	4	\N
9be86b4d-593e-11ee-a33c-0dd4c2040095	9be86b4c-593e-11ee-a33c-0dd4c2040095	1	3	COMPLETED	COMPLETED	2023-09-25 10:09:40.439906	2023-09-22 11:53:13.362293+00	\N	4	\N
ae48bd9f-5ec8-11ee-9ad9-5405dbcf43b8	ae44a73d-5ec8-11ee-88cc-5405dbcf43b8	1	3	COMPLETED	COMPLETED	2023-09-29 13:06:48.622499	2023-09-29 13:04:10.553692+00	\N	4	\N
983f492d-680a-11ee-a33c-0dd4c2040095	983f492c-680a-11ee-a33c-0dd4c2040095	1	33	IN_PROGRESS	NOT_STARTED	2023-10-11 07:48:48.97465	2023-10-11 07:48:40.834636+00	\N	4	\N
b9c33481-5952-11ee-a33c-0dd4c2040095	b9c33480-5952-11ee-a33c-0dd4c2040095	1	3	COMPLETED	COMPLETED	2023-10-04 09:39:51.089139	2023-09-22 14:17:13.385638+00	\N	4	\N
72e86a09-6903-11ee-a3e7-e454e805e8b9	72e29b7b-6903-11ee-9fb2-e454e805e8b9	1	33	PENDING	NOT_STARTED	2023-10-12 13:30:01.882202	2023-10-12 13:30:02.871655+00	\N	4	\N
f41beea1-9e3b-11ee-a33c-0dd4c2040095	f41beea0-9e3b-11ee-a33c-0dd4c2040095	21	2	COMPLETED	COMPLETED	2023-12-19 07:02:19.535437	2023-12-19 06:58:03.081598+00	\N	4	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
fd402891-699b-11ee-a33c-0dd4c2040095	fd402890-699b-11ee-a33c-0dd4c2040095	1	33	IN_PROGRESS	NOT_STARTED	2023-10-13 07:44:19.384656	2023-10-13 07:41:58.484217+00	\N	4	\N
7f80b9e5-7952-11ee-a33c-0dd4c2040095	7f80b9e4-7952-11ee-a33c-0dd4c2040095	8	1	COMPLETED	COMPLETED	2023-11-02 12:04:36.626254	2023-11-02 07:36:12.850191+00	\N	4	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
ba1408f5-629f-11ee-80df-e04f4370e917	ba0fc317-629f-11ee-951e-e04f4370e917	1	3	COMPLETED	COMPLETED	2023-10-04 10:34:26.358814	2023-10-04 10:21:05.626136+00	\N	4	\N
fb027d07-7230-11ee-a33c-0dd4c2040095	fb027d06-7230-11ee-a33c-0dd4c2040095	8	1	COMPLETED	COMPLETED	2023-10-24 05:49:33.744838	2023-10-24 05:48:39.031976+00	\N	4	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1ac04d21-6c0b-11ee-a33c-0dd4c2040095	1ac04d20-6c0b-11ee-a33c-0dd4c2040095	1	33	IN_PROGRESS	NOT_STARTED	2023-10-24 05:54:22.857295	2023-10-16 10:02:24.43516+00	\N	4	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
efccd449-6d19-11ee-a33c-0dd4c2040095	efccd448-6d19-11ee-a33c-0dd4c2040095	34	4	COMPLETED	COMPLETED	2023-10-17 18:27:46.708871	2023-10-17 18:21:05.988517+00	\N	64	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
06aac2f3-6369-11ee-a33c-0dd4c2040095	06aac2f2-6369-11ee-a33c-0dd4c2040095	1	3	COMPLETED	COMPLETED	2023-10-05 10:23:11.367443	2023-10-05 10:22:02.965578+00	\N	4	\N
5fccebe1-6368-11ee-a33c-0dd4c2040095	5fccebe0-6368-11ee-a33c-0dd4c2040095	1	3	IN_PROGRESS	NOT_STARTED	2023-10-05 11:28:33.199034	2023-10-05 10:17:23.010601+00	\N	4	\N
9336dd11-6368-11ee-a33c-0dd4c2040095	9336dd10-6368-11ee-a33c-0dd4c2040095	1	3	IN_PROGRESS	NOT_STARTED	2023-10-05 12:03:25.268327	2023-10-05 10:18:49.26737+00	\N	4	\N
51485da3-73f3-11ee-a33c-0dd4c2040095	51485da2-73f3-11ee-a33c-0dd4c2040095	1	3	PENDING	NOT_STARTED	2023-10-26 11:32:17.298126	2023-10-26 11:32:17.303089+00	\N	72	d79dfb76-73f0-11ee-a33c-0dd4c2040095
d75ae317-637b-11ee-a33c-0dd4c2040095	d75ae316-637b-11ee-a33c-0dd4c2040095	1	3	PENDING	NOT_STARTED	2023-10-05 12:36:44.022545	2023-10-05 12:36:44.026691+00	\N	4	\N
10dd9ff1-9434-11ee-a33c-0dd4c2040095	10dd9ff0-9434-11ee-a33c-0dd4c2040095	21	2	COMPLETED	COMPLETED	2023-12-06 12:46:14.015943	2023-12-06 12:36:23.725508+00	\N	4	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
654d7959-6dd2-11ee-a33c-0dd4c2040095	654d7958-6dd2-11ee-a33c-0dd4c2040095	34	4	COMPLETED	COMPLETED	2023-10-18 16:31:27.559384	2023-10-18 16:21:30.523084+00	\N	64	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
a6f9cb15-6377-11ee-a33c-0dd4c2040095	a6f9cb14-6377-11ee-a33c-0dd4c2040095	1	3	COMPLETED	COMPLETED	2023-10-05 12:42:42.231884	2023-10-05 12:06:44.872963+00	\N	4	\N
fd606e11-637a-11ee-a33c-0dd4c2040095	fd606e10-637a-11ee-a33c-0dd4c2040095	1	3	IN_PROGRESS	NOT_STARTED	2023-10-05 12:43:52.044928	2023-10-05 12:30:38.319411+00	\N	4	\N
0f497aa9-637c-11ee-a33c-0dd4c2040095	0f497aa8-637c-11ee-a33c-0dd4c2040095	1	3	IN_PROGRESS	NOT_STARTED	2023-10-05 12:46:01.872671	2023-10-05 12:38:17.864803+00	\N	4	\N
47c3016b-74b6-11ee-a33c-0dd4c2040095	47c3016a-74b6-11ee-a33c-0dd4c2040095	38	1	COMPLETED	COMPLETED	2023-10-27 10:49:51.297496	2023-10-27 10:47:53.191718+00	\N	76	d3fb23da-74b4-11ee-a33c-0dd4c2040095
cb043a55-70fb-11ee-bc59-e454e805e8b9	cafc50c6-70fb-11ee-9b22-e454e805e8b9	5	3	COMPLETED	COMPLETED	2023-10-22 16:59:24.519657	2023-10-22 16:55:24.021819+00	\N	65	45ea898a-6f5d-11ee-aca0-e454e805e8b9
602b87e7-7c67-11ee-a33c-0dd4c2040095	602b87e6-7c67-11ee-a33c-0dd4c2040095	8	1	COMPLETED	COMPLETED	2023-11-09 10:25:04.169663	2023-11-06 05:43:13.20461+00	\N	4	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12365b75-7230-11ee-a33c-0dd4c2040095	12365b74-7230-11ee-a33c-0dd4c2040095	1	67	IN_PROGRESS	NOT_STARTED	2023-10-24 05:42:50.084693	2023-10-24 05:42:08.464124+00	\N	4	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
448a0c3b-76e8-11ee-a33c-0dd4c2040095	448a0c3a-76e8-11ee-a33c-0dd4c2040095	19	3	IN_PROGRESS	NOT_STARTED	2023-11-01 09:58:26.431716	2023-10-30 05:50:44.947354+00	\N	4	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
7def4009-8dcc-11ee-a33c-0dd4c2040095	7def4008-8dcc-11ee-a33c-0dd4c2040095	8	1	PENDING	NOT_STARTED	2023-11-28 08:59:52.07128	2023-11-28 08:59:52.076326+00	\N	4	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
8b641957-7eeb-11ee-a33c-0dd4c2040095	8b641956-7eeb-11ee-a33c-0dd4c2040095	8	1	IN_PROGRESS	NOT_STARTED	2023-11-09 10:34:54.39509	2023-11-09 10:34:21.610099+00	\N	4	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
42c1be65-78a2-11ee-a33c-0dd4c2040095	42c1be64-78a2-11ee-a33c-0dd4c2040095	8	1	COMPLETED	COMPLETED	2023-11-02 07:28:28.761826	2023-11-01 10:34:39.513699+00	\N	4	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
b4844955-5890-11ee-a33c-0dd4c2040095	b4844954-5890-11ee-a33c-0dd4c2040095	1	23	PENDING	NOT_STARTED	2023-09-21 15:08:22.213845	2023-09-21 15:08:22.21964+00	\N	4	\N
4689f8a3-7ef3-11ee-a33c-0dd4c2040095	4689f8a2-7ef3-11ee-a33c-0dd4c2040095	8	1	COMPLETED	COMPLETED	2023-11-09 13:17:34.873427	2023-11-09 11:29:42.068767+00	\N	4	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
118b303b-591e-11ee-a33c-0dd4c2040095	118b303a-591e-11ee-a33c-0dd4c2040095	1	3	PENDING	NOT_STARTED	2023-09-22 08:00:17.326871	2023-09-22 08:00:17.33166+00	\N	4	\N
402ab201-9d91-11ee-a33c-0dd4c2040095	402ab200-9d91-11ee-a33c-0dd4c2040095	21	2	COMPLETED	COMPLETED	2023-12-18 10:42:25.38755	2023-12-18 10:36:06.749063+00	\N	4	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
54681751-592e-11ee-a33c-0dd4c2040095	54681750-592e-11ee-a33c-0dd4c2040095	1	3	COMPLETED	COMPLETED	2023-09-22 10:05:17.812907	2023-09-22 09:56:41.457426+00	\N	4	\N
8f0991b1-5864-11ee-a33c-0dd4c2040095	8f0991b0-5864-11ee-a33c-0dd4c2040095	1	23	IN_PROGRESS	NOT_STARTED	2023-09-21 09:52:40.76893	2023-09-21 09:52:21.487968+00	\N	4	\N
189f8187-5866-11ee-a33c-0dd4c2040095	189f8186-5866-11ee-a33c-0dd4c2040095	1	23	PENDING	NOT_STARTED	2023-09-21 10:03:21.804303	2023-09-21 10:03:21.811057+00	\N	4	\N
\.


--
-- Data for Name: page_component; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.page_component (id, name, created_by, updated_by, created_at, last_updated) FROM stdin;
1	USERS	4	\N	2023-10-05 16:20:17.674052	2023-10-05 16:20:17.674052
2	QUESTION_BANK	4	\N	2023-10-05 16:20:22.806406	2023-10-05 16:20:22.806406
3	EVALUATIONS	4	\N	2023-10-06 06:41:33.940063	2023-10-06 06:41:33.940063
4	RESUME_PROFILER	4	\N	2023-10-09 05:32:48.318931	2023-10-09 05:32:48.318931
5	ROLES_AND_PERMISSIONS	4	\N	2023-10-09 05:32:59.960556	2023-10-09 05:32:59.960556
6	STRUCTURE_INTERVIEW	4	\N	2023-10-09 05:33:05.957204	2023-10-09 05:33:05.957204
8	HOME	4	\N	2023-10-25 14:46:17.953179	2023-10-25 14:46:17.953179
\.


--
-- Data for Name: permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permission (id, name, request_method, path_url, created_by, updated_by, created_at, last_updated) FROM stdin;
2	Create Roles	POST	^roles$	4	\N	2023-09-05 10:01:16.147987	2023-09-05 10:01:16.147987
3	Create Permission	POST	^permission$	4	\N	2023-09-05 10:01:16.147987	2023-09-05 10:01:16.147987
4	Get Permission	GET	^permission$	4	\N	2023-09-05 10:01:16.147987	2023-09-05 10:01:16.147987
5	Assign Permission	POST	^roles/\\d+/permission/\\d+$	4	\N	2023-09-05 10:01:16.147987	2023-09-05 10:01:16.147987
1	Get Roles	GET	^roles$	4	\N	2023-09-04 11:28:31.43346	2023-09-04 11:28:31.43346
6	Get Designations	GET	^designation$	4	\N	2023-09-06 07:12:10.168322	2023-09-06 07:12:10.168322
7	Create Designation	POST	^designation$	4	\N	2023-09-06 07:12:53.332071	2023-09-06 07:12:53.332071
8	Designation by Industry	GET	^designation/industry/\\d+$	4	\N	2023-09-06 07:27:48.238722	2023-09-06 07:27:48.238722
9	Questions by Designation	GET	^question$	4	\N	2023-09-06 07:30:51.749879	2023-09-06 07:30:51.749879
11	Upload Questions	POST	^question/upload$	4	\N	2023-09-06 07:33:16.501904	2023-09-06 07:33:16.501904
12	Generate QA	POST	^question/generate$	4	\N	2023-09-06 07:33:46.362409	2023-09-06 07:33:46.362409
13	Generate Report	GET	^evaluation/[\\w-]{36}/candidate/[\\w-]{36}/interview/generate$	4	\N	2023-09-06 07:34:40.7984	2023-09-06 07:34:40.7984
14	Get Industries	GET	^industry$	4	\N	2023-09-06 07:35:27.822013	2023-09-06 07:35:27.822013
15	Create Industry	POST	^industry$	4	\N	2023-09-06 07:35:46.527015	2023-09-06 07:35:46.527015
16	Get Domains	GET	^domain$	4	\N	2023-09-06 07:36:12.911121	2023-09-06 07:36:12.911121
17	Create Domain	POST	^domain$	4	\N	2023-09-06 07:36:28.729249	2023-09-06 07:36:28.729249
18	Domain by Designation	GET	^/domain/designation/\\d+$	4	\N	2023-09-06 07:37:41.064376	2023-09-06 07:37:41.064376
19	SubDomain by Domain	GET	^sub-domain/domain/\\d+$	4	\N	2023-09-06 07:38:10.155614	2023-09-06 07:38:10.155614
20	Create SubDomain	POST	^sub-domain$	4	\N	2023-09-06 07:38:42.760077	2023-09-06 07:38:42.760077
21	Start interview	POST	^interview/begin$	4	\N	2023-09-08 06:57:03.873621	2023-09-08 06:57:03.873621
22	Get candidates status	GET	^evaluation/candidate/status$	4	\N	2023-09-08 07:58:25.35674	2023-09-08 07:58:25.35674
23	Get Permissions for role	GET	^permission/role/\\d+$	4	\N	2023-09-11 13:32:53.922439	2023-09-11 13:32:53.922439
24	Get Users	GET	^user$	4	\N	2023-09-13 07:19:34.759828	2023-09-13 07:19:34.759828
25	Get Configuration	GET	^config$	4	\N	2023-09-22 08:03:28.495206	2023-09-22 08:03:28.495206
26	Overall Candidate	GET	^/candidate$	4	\N	2023-09-22 13:51:47.566504	2023-09-22 13:51:47.566504
27	Remove Candidate	GET	^candidate/[\\w-]{36}/candidate/delete$	4	\N	2023-09-22 13:56:51.213535	2023-09-22 13:56:51.213535
28	Download Evaluation	GET	^evaluation/[\\w-]{36}/candidate/[\\w-]{36}/interview/download$	4	\N	2023-09-25 07:42:41.51732	2023-09-25 07:42:41.51732
29	Get Page Component	GET	^page-component$	4	\N	2023-10-05 16:17:42.622316	2023-10-05 16:17:42.622316
30	Get Page Component by Role	GET	^page-component/role/\\d+$	4	\N	2023-10-05 16:18:23.797569	2023-10-05 16:18:23.797569
31	Create Page Component	POST	^page-component$	4	\N	2023-10-05 16:19:23.578008	2023-10-05 16:19:23.578008
32	Assign Page Component for Role	PUT	^page-component/role/\\d+$	4	\N	2023-10-05 16:19:58.921621	2023-10-05 16:19:58.921621
33	Generate answer	POST	^question/generate-answer$	4	\N	2023-10-06 13:51:40.673125	2023-10-06 13:51:40.673125
34	Assign designation to user	PUT	^designation/\\d+/user/\\d+$	4	\N	2023-10-09 11:13:12.715479	2023-10-09 11:13:12.715479
10	Create Question	POST	^question$	4	\N	2023-09-06 07:32:49.759749	2023-09-06 07:32:49.759749
35	Get questioners list for designation	GET	^designation/\\d+/questioners$	4	\N	2023-10-10 14:30:33.448632	2023-10-10 14:30:33.448632
36	remove designation from user	DELETE	^designation/\\d+/user/\\d+$	4	\N	2023-10-10 14:48:01.022141	2023-10-10 14:48:01.022141
37	Create user	POST	^user/signup$	4	\N	2023-10-11 11:30:25.880352	2023-10-11 11:30:25.880352
38	GET Questioner list	GET	^user/questioner$	4	\N	2023-10-18 15:27:55.8134	2023-10-18 15:27:55.8134
39	GET lower roles	GET	^roles/lower-roles$	4	\N	2023-11-02 10:17:16.496958	2023-11-02 10:17:16.496958
40	Send email	POST	^email/invite/[a-f0-9-]+$	4	\N	2023-11-02 14:33:04.71801	2023-11-02 14:33:04.71801
\.


--
-- Data for Name: question_bank; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.question_bank (question_id, question, question_type, designation, answer_type, ai_answer, domain, max_answering_time, preparation_time, code_required, difficulty_index, clues, url, flagged, user_id, last_updated, flag_expectation, sub_domain, tenant_id) FROM stdin;
eafbe038-6730-11ee-a33c-0dd4c2040095	python	Closed	python developer	NoCodeAnswer	This is default AI Answer, Not generated by AI. To generate AI answer please add Open API key.	Backend Development	5	30	f	5		\N	f	4	2023-10-10 05:50:29.358042	\N	2	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
3bb415a8-673c-11ee-a33c-0dd4c2040095	folder structure	OpenEnded	python developer	NoCodeAnswer		Backend Development	5	30	f	5		\N	t	4	2023-10-10 07:11:29.24376	flag	3	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
a046ceba-6742-11ee-a33c-0dd4c2040095	advanced django	Closed	python developer	NoCodeAnswer	Advanced Django refers to the deeper and more complex aspects of the Django web framework. It involves utilizing advanced features and techniques to build more sophisticated and scalable web applications.\n\nSome examples of advanced Django topics include:\n\n1. Customizing the Django Admin: Extending the built-in Django Admin interface to add custom functionality and improve the user experience.\n\n2. Building RESTful APIs: Using Django's REST framework to create APIs that allow communication between different systems or platforms.\n\n3. Performance Optimization: Implementing caching, database optimization, and other techniques to improve the speed and efficiency of Django applications.\n\n4. Advanced Database Queries: Utilizing Django's ORM to perform complex database queries, including joins, aggregations, and subqueries.\n\n5. Asynchronous Programming: Integrating asynchronous programming techniques, such as using Django Channels, to handle real-time updates and improve application responsiveness.\n\n6. Security and Authentication: Implementing advanced security measures, such as two-factor authentication, role-based access control, and handling sensitive data securely.\n\n7. Testing and Debugging: Writing comprehensive unit tests and using debugging tools to ensure the reliability and stability of Django applications.\n\nOverall, advanced Django skills demonstrate a deeper understanding of the framework and the ability to build more complex and robust web applications.	Backend Development	5	30	f	5		\N	f	4	2023-10-10 07:57:14.958771	\N	3	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
cfc53bfa-6755-11ee-a33c-0dd4c2040095	how can the dimond inheritance problem can be avoided	OpenEnded	python developer	NoCodeAnswer		Backend Development	5	30	f	5		\N	f	4	2023-10-10 10:14:35.077189	\N	3	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
22a4951a-676e-11ee-a33c-0dd4c2040095	Write about React memo.	OpenEnded	python developer	CodeBasedAnswer		Backend Development	5	30	t	5		\N	f	20	2023-10-10 13:08:42.035142	\N	3	f1a33f68-5eab-11ee-a33c-0dd4c2040095
c993e888-6cf7-11ee-a33c-0dd4c2040095	dadas	Closed	python developer	NoCodeAnswer	dsadsad	Backend Development	5	30	f	5		\N	f	49	2023-10-17 14:16:38.972569	\N	2	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
412a3f2e-6e6e-11ee-a33c-0dd4c2040095	sample question	Closed	python developer	NoCodeAnswer	Can you explain the role of a Data Architect?	Backend Development	5	30	f	5		\N	f	4	2023-10-19 10:57:11.386179	\N	3	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
26da8a58-6ef4-11ee-a33c-0dd4c2040095	new Question	OpenEnded	python developer	NoCodeAnswer		Backend Development	5	30	f	5		\N	f	4	2023-10-20 02:55:39.800748	\N	3	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
f3118dc4-6f12-11ee-a33c-0dd4c2040095	Write a Python function to calculate the average score of a player in a game. The function should take the player's name and a list of scores as input and return the average score.	OpenEnded	python developer	NoCodeAnswer	def calculate_average_score(player_name, scores):\n    average_score = sum(scores) / len(scores)\n    return average_score	Conti	5	30	f	5	\N	\N	f	4	2023-10-20 06:36:07.31903	\N	42	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
56da4c88-6f13-11ee-a33c-0dd4c2040095	What are some factors that can affect the performance of engine lubricants in automobiles?	OpenEnded	python developer	NoCodeAnswer	Some factors that can affect the performance of engine lubricants in automobiles include viscosity, temperature, pressure, and the presence of contaminants.	Automobiles	5	30	f	5	\N	\N	f	4	2023-10-20 06:38:54.72904	\N	44	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
59ab8fa8-6f13-11ee-a33c-0dd4c2040095	How can Python be used to analyze the performance of different engine lubricants in automobiles?	OpenEnded	python developer	NoCodeAnswer	Python can be used to analyze the performance of different engine lubricants in automobiles by collecting data on factors such as viscosity, temperature, and wear and tear. This data can then be analyzed using Python libraries such as pandas and matplotlib to identify trends and make comparisons between different lubricants.	Automobiles	5	30	f	5	\N	\N	f	4	2023-10-20 06:38:59.455575	\N	44	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
76b5bd44-6f13-11ee-a33c-0dd4c2040095	Write a Python code snippet to calculate the average wear and tear of an engine lubricant based on data collected from multiple automobiles.	OpenEnded	python developer	NoCodeAnswer	import pandas as pd\n\ndef calculate_average_wear_and_tear(data):\n    df = pd.DataFrame(data)\n    average_wear_and_tear = df['wear_and_tear'].mean()\n    return average_wear_and_tear	Automobiles	5	30	f	5	\N	\N	f	4	2023-10-20 06:39:48.175923	\N	44	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
4325fa80-70fa-11ee-8198-e454e805e8b9	explain types of collections available in java	OpenEnded	Java developer	NoCodeAnswer	In Java, there are several types of collections available. Some of the commonly used ones are:\n\n1. List: A List is an ordered collection that allows duplicate elements. It provides methods to add, remove, and access elements by their index.\n\n2. Set: A Set is a collection that does not allow duplicate elements. It ensures uniqueness of elements based on their equals() and hashCode() methods.\n\n3. Map: A Map is a collection that stores key-value pairs. It allows you to retrieve values based on their corresponding keys. Keys in a Map are unique, but values can be duplicated.\n\n4. Queue: A Queue is a collection that follows the FIFO (First-In-First-Out) principle. It provides methods to add elements at the end and remove elements from the front.\n\n5. Stack: A Stack is a collection that follows the LIFO (Last-In-First-Out) principle. It provides methods to add elements at the top and remove elements from the top.\n\nThese collections provide different functionalities and can be used based on the specific requirements of your application.	Web Development	5	30	f	5		\N	f	65	2023-10-22 16:44:24.557552	\N	57	45ea898a-6f5d-11ee-aca0-e454e805e8b9
d57cadb4-73f1-11ee-a33c-0dd4c2040095	What is python string manipulation	OpenEnded	python developer	NoCodeAnswer	Python string manipulation refers to the various operations that can be performed on strings, such as concatenation, slicing, replacing, and formatting. It's like playing with a set of building blocks to create, modify, or extract information from strings. For example, you can combine two strings using the "+" operator, extract a portion of a string using slicing, replace specific characters using the "replace()" method, or format strings using placeholders and formatting codes. String manipulation is a fundamental skill in Python programming and is used in many real-world applications, such as data processing, text analysis, and web development.	Development	2	5	f	3		\N	f	72	2023-10-26 11:21:40.112315	\N	28	d79dfb76-73f0-11ee-a33c-0dd4c2040095
493e856a-73f7-11ee-a33c-0dd4c2040095	How does Django handle database migrations?	OpenEnded	python developer	NoCodeAnswer	Django provides a built-in database migration system that allows developers to easily manage changes to the database schema over time. It uses a declarative approach, where developers define the desired database schema using Python code, and Django automatically generates the necessary SQL statements to apply the changes.	Backend Development	5	30	f	5	\N	\N	f	4	2023-10-26 12:00:41.802729	\N	3	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
5778b3a8-73f7-11ee-a33c-0dd4c2040095	What is the purpose of Django in backend development?	OpenEnded	python developer	NoCodeAnswer	Django is a high-level Python web framework that enables rapid development of secure and maintainable websites. It provides a set of tools and libraries for handling common web development tasks, such as URL routing, database management, and form handling.	Backend Development	5	30	f	5	\N	\N	t	4	2023-10-26 12:01:05.672068	flag	3	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
81d0033c-6735-11ee-a33c-0dd4c2040095	python developer	Closed	python developer	NoCodeAnswer	Yes, I am interviewing for the role of a Python developer. I have experience and expertise in using the Python programming language to develop software applications and solutions. I am familiar with the syntax, libraries, and frameworks commonly used in Python development. I have worked on projects involving web development, data analysis, automation, and more using Python. I am confident in my ability to write clean, efficient, and maintainable code in Python. I am also comfortable working in a team and collaborating with other developers to deliver high-quality software solutions.	Backend Development	5	30	f	5		\N	f	4	2023-10-10 06:23:20.389685	\N	3	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
e63acf26-673c-11ee-a33c-0dd4c2040095	python inital setup	Closed	python developer	NoCodeAnswer	To set up Python on your computer, you need to follow these steps:\n\n1. Download Python: Go to the official Python website (python.org) and download the latest version of Python that is compatible with your operating system.\n\n2. Install Python: Run the downloaded installer and follow the installation wizard. Make sure to check the option to add Python to your system's PATH, as this allows you to run Python from any directory in the command prompt or terminal.\n\n3. Verify the installation: Open a command prompt or terminal and type "python --version" to check if Python is installed correctly. You should see the version number displayed.\n\n4. Set up a development environment: You can choose to use an Integrated Development Environment (IDE) like PyCharm, Visual Studio Code, or simply use a text editor like Sublime Text or Atom. Install your preferred IDE or text editor and configure it to work with Python.\n\n5. Start coding: You are now ready to write and run Python code. Open your IDE or text editor, create a new Python file with a .py extension, and start coding!\n\nRemember to regularly update Python to the latest version to benefit from bug fixes and new features.	Core Python Coding	5	30	f	5		\N	t	4	2023-10-10 07:16:15.338826	flag answer	7	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
12589016-673d-11ee-a33c-0dd4c2040095	python inital hosting	Closed	python developer	NoCodeAnswer	To set up Python on your computer, you need to follow these steps:\n\n1. Download Python: Go to the official Python website (python.org) and download the latest version of Python that is compatible with your operating system.\n\n2. Install Python: Run the downloaded installer and follow the installation wizard. Make sure to check the option to add Python to your system's PATH, as this allows you to run Python from any directory in the command prompt or terminal.\n\n3. Verify the installation: Open a command prompt or terminal and type "python --version" to check if Python is installed correctly. You should see the version number displayed.\n\n4. Set up a development environment: You can choose to use an Integrated Development Environment (IDE) like PyCharm, Visual Studio Code, or simply use a text editor like Sublime Text or Atom. Install your preferred IDE or text editor and configure it to work with Python.\n\n5. Start coding: You are now ready to write and run Python code. Open your IDE or text editor, create a new Python file with a .py extension, and start coding!\n\nRemember to regularly update Python to the latest version to benefit from bug fixes and new features.	Core Python Coding	5	30	f	5		\N	f	4	2023-10-10 07:17:29.353536	\N	7	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
4ab98cee-673d-11ee-a33c-0dd4c2040095	flask setup	Closed	python developer	NoCodeAnswer	To set up Flask, you can follow these steps:\n\n1. Install Python: Make sure you have Python installed on your system.\n\n2. Create a virtual environment: This helps to isolate your project dependencies. Use a tool like `virtualenv` or `venv` to create a virtual environment.\n\n3. Activate the virtual environment: Activate the virtual environment using the appropriate command for your operating system.\n\n4. Install Flask: Use `pip` to install Flask within your virtual environment.\n\n5. Create a Flask app: Create a new Python file and import the Flask module. Define your Flask app by creating an instance of the Flask class.\n\n6. Define routes: Use the `@app.route` decorator to define routes for your app. Routes determine the URL paths that your app will respond to.\n\n7. Run the app: Use the `app.run()` method to start the Flask development server.\n\nThat's it! You now have a basic Flask setup. You can start building your web application by adding more routes, views, and templates.	Backend Development	5	30	f	5		\N	f	4	2023-10-10 07:19:03.941637	\N	2	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
3d41f458-6746-11ee-a33c-0dd4c2040095	what is big O notation	OpenEnded	python developer	NoCodeAnswer		Backend Development	5	30	f	5		\N	f	4	2023-10-10 08:23:06.821798	\N	2	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
4d5a077a-6757-11ee-a33c-0dd4c2040095	Django python	OpenEnded	python developer	NoCodeAnswer		Backend Development	5	30	f	5		\N	t	4	2023-10-10 10:25:15.264366	flagged	2	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
ddf29de6-6d16-11ee-a33c-0dd4c2040095	how does a data architect differentiate himself from a data engineer?	OpenEnded	Data Architect	NoCodeAnswer	A data architect focuses on designing the overall structure and organization of data systems, like an architect designing the blueprint of a building. They determine how data should be stored, accessed, and integrated to meet business needs. On the other hand, a data engineer focuses on implementing and maintaining the data systems, like a construction worker building the actual structure based on the architect's blueprint. They handle data pipelines, data integration, and data processing. While both roles are important, the data architect is more strategic and conceptual, while the data engineer is more hands-on and technical.	Web Development	2	30	f	2		\N	f	52	2023-10-17 17:59:07.547237	\N	1	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
459c6daa-6d17-11ee-a33c-0dd4c2040095	Can a python developer become data architect	OpenEnded	python developer	NoCodeAnswer	Yes, a Python developer can become a data architect. Python is a versatile programming language that is widely used in the field of data analysis and data engineering. As a Python developer, you already have a strong foundation in programming and problem-solving skills, which are essential for a data architect. To become a data architect, you would need to gain knowledge and experience in areas such as data modeling, database design, data integration, and data governance. You can acquire these skills through self-study, online courses, and practical projects. Additionally, it would be beneficial to learn about different database technologies, data warehousing, and cloud platforms. By combining your Python skills with a solid understanding of data architecture principles, you can transition into a data architect role.	Backend Development	2	30	f	2		\N	f	52	2023-10-17 18:02:01.464207	\N	5	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
380aae06-6e73-11ee-a33c-0dd4c2040095	New question	Closed	python developer	NoCodeAnswer	Can you explain the concept of data modeling and its importance in the field of data architecture?	Multi	5	30	f	5		\N	f	4	2023-10-19 11:32:43.56127	\N	24	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1c4e7ae8-6f05-11ee-a33c-0dd4c2040095	What is the purpose of Angular in front-end development?	OpenEnded	python developer	NoCodeAnswer	Angular is a JavaScript framework that is used for building web applications. It provides a structured way to develop dynamic web pages and applications by extending HTML with additional features and functionality.	Front End Development	5	30	f	5	\N	\N	\N	4	2023-10-20 04:57:03.552982	\N	11	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
023bfcd0-70fb-11ee-9093-e454e805e8b9	What is a stack in Java?	OpenEnded	Java developer	NoCodeAnswer	A stack is a data structure that follows the Last-In-First-Out (LIFO) principle. It is a collection of elements with two main operations: push, which adds an element to the top of the stack, and pop, which removes the top element from the stack.	Web Development	5	30	f	5	\N	\N	f	69	2023-10-22 16:49:45.068117	\N	57	45ea898a-6f5d-11ee-aca0-e454e805e8b9
2f0c8b64-73f3-11ee-a33c-0dd4c2040095	What is decorators	Closed	python developer	NoCodeAnswer	Decorators in Python are a way to modify the behavior of a function or a class without changing its source code. They allow you to wrap a function or a class with another function, which can add additional functionality or modify the existing behavior. It's like adding a layer of functionality to an existing function or class, without modifying its core functionality.	Core Python Coding	2	10	f	4		\N	f	74	2023-10-26 11:31:19.867522	\N	7	d79dfb76-73f0-11ee-a33c-0dd4c2040095
af08759e-73f3-11ee-a33c-0dd4c2040095	new req	OpenEnded	python developer	NoCodeAnswer	Sure, I'm ready to answer your question. Please go ahead and ask me.	Front End Development	2	20	f	5		\N	f	4	2023-10-26 11:34:54.589074	\N	11	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
6806dc9a-73f7-11ee-a33c-0dd4c2040095	Write a Python class named 'Car' with a method 'get_color' that returns the color of the car.	OpenEnded	python developer	NoCodeAnswer	class Car:\n    def __init__(self, color):\n        self.color = color\n\n    def get_color(self):\n        return self.color	Core Python Coding	1	15	f	5	\N	\N	t	4	2023-10-26 12:01:33.448742	flag	13	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
69fe8764-73f7-11ee-a33c-0dd4c2040095	Write a Python class named 'Employee' that inherits from the 'Person' class and has an additional method 'get_salary' that returns the salary of the employee.	OpenEnded	python developer	NoCodeAnswer	class Employee(Person):\n    def __init__(self, name, salary):\n        super().__init__(name)\n        self.salary = salary\n\n    def get_salary(self):\n        return self.salary	Core Python Coding	1	15	f	5	\N	\N	f	4	2023-10-26 12:01:36.74807	\N	13	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
8280484a-73f7-11ee-a33c-0dd4c2040095	Write a Python class named 'Circle' with one attribute 'radius'. Implement a method 'circumference' that calculates and returns the circumference of the circle.	OpenEnded	python developer	NoCodeAnswer	python\nclass Circle:\n    def __init__(self, radius):\n        self.radius = radius\n\n    def circumference(self):\n        return 2 * 3.14 * self.radius\n	Core Python Coding	6	50	f	5	\N	\N	t	4	2023-10-26 12:02:17.86415	flag	12	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
4dd5f6a8-6736-11ee-a33c-0dd4c2040095	Python programer	Closed	python developer	NoCodeAnswer	Yes, I am a Python programmer. I have experience in writing code in Python and solving problems using Python programming language. I am familiar with the syntax, data structures, and libraries in Python. I have worked on various projects where I have used Python to develop applications, automate tasks, and analyze data. I am confident in my ability to write clean, efficient, and maintainable code in Python.	Backend Development	5	30	f	5		\N	t	4	2023-10-10 06:29:02.684687	Flagged answer	3	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
6da3c4c0-673f-11ee-a33c-0dd4c2040095	how to declare constants in python	Closed	python developer	NoCodeAnswer	In Python, you can declare constants by using uppercase variable names and assigning them a value that should not be changed. For example, you can declare a constant named PI and assign it the value of 3.14159. By convention, constants are written in uppercase to distinguish them from regular variables.	Backend Development	5	30	f	5		\N	f	4	2023-10-10 07:34:21.513228	\N	3	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
9dd45cca-6746-11ee-a33c-0dd4c2040095	what is O log(n) give an example	OpenEnded	python developer	NoCodeAnswer		Backend Development	5	30	f	5		\N	f	4	2023-10-10 08:25:48.844698	\N	3	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
32078c8a-6758-11ee-a33c-0dd4c2040095	new setup django	OpenEnded	python developer	NoCodeAnswer		Backend Development	5	30	f	5		\N	t	4	2023-10-10 10:31:38.921655	flask	3	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
68a7516a-6d18-11ee-a33c-0dd4c2040095	When o use cloud solution and when not to use a cloud solution?	OpenEnded	Data Architect	NoCodeAnswer	Cloud solutions are beneficial when you need scalability, flexibility, and cost-effectiveness. Use cloud solutions when you have variable workloads, need to quickly scale resources up or down, or want to avoid upfront infrastructure costs. However, if you have strict data security requirements, sensitive data that cannot be stored off-premises, or if you have predictable and consistent workloads, an on-premises solution may be more suitable. It's important to consider factors like data privacy, compliance, and the specific needs of your organization before deciding whether to use a cloud solution or not.	Web Development	2	30	f	2		\N	f	49	2023-10-17 18:10:09.751815	\N	1	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
9f11f56a-6e81-11ee-a33c-0dd4c2040095	sadasd	Closed	python developer	NoCodeAnswer	I'm sorry, but I'm unable to understand your question. Could you please provide more information or rephrase your question?	Backend Development	5	30	f	5		\N	f	4	2023-10-19 13:15:49.36698	\N	3	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
f189cbc6-6f0b-11ee-a33c-0dd4c2040095	What are some advantages of using Grails over other backend frameworks?	OpenEnded	python developer	NoCodeAnswer	Some advantages of using Grails include its convention-over-configuration approach, which reduces the amount of boilerplate code required, its seamless integration with existing Java libraries and frameworks, and its built-in support for features such as database access, security, and caching.	Backend Development	5	30	f	5	\N	\N	\N	4	2023-10-20 05:45:58.273764	\N	17	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
54345a2c-6f14-11ee-a33c-0dd4c2040095	What is Kubernetes and why is it used in backend development?	OpenEnded	python developer	NoCodeAnswer	Kubernetes is an open-source container orchestration platform that automates the deployment, scaling, and management of containerized applications. It is used in backend development to simplify the deployment and management of applications, improve scalability and availability, and enable efficient resource utilization.	Backend Development	5	30	f	5	\N	\N	f	4	2023-10-20 06:45:59.782471	\N	6	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
563ce866-6f14-11ee-a33c-0dd4c2040095	How can you deploy a Python application on Kubernetes?	OpenEnded	python developer	NoCodeAnswer	To deploy a Python application on Kubernetes, you can create a Docker image of your application, push it to a container registry, and then create a Kubernetes deployment manifest that specifies the image and other configuration details. You can use tools like kubectl or Kubernetes API to deploy the application.	Backend Development	5	30	f	5	\N	\N	f	4	2023-10-20 06:46:03.193691	\N	6	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
588be522-6f14-11ee-a33c-0dd4c2040095	How can you scale a Python application deployed on Kubernetes based on CPU utilization?	OpenEnded	python developer	NoCodeAnswer	To scale a Python application deployed on Kubernetes based on CPU utilization, you can use the Horizontal Pod Autoscaler (HPA) feature of Kubernetes. You can configure the HPA to monitor the CPU utilization of the application and automatically adjust the number of replicas based on the defined thresholds.	Backend Development	5	30	f	5	\N	\N	f	4	2023-10-20 06:46:07.067426	\N	6	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
4eaab457-70fb-11ee-b320-e454e805e8b9	What is the syntax for defining a route in Flask?	OpenEnded	Java developer	NoCodeAnswer	To define a route in Flask, you can use the `@app.route()` decorator followed by the URL pattern as a string. For example, `@app.route('/home')` defines a route for the '/home' URL.	Web Development	5	30	f	5	\N	\N	f	69	2023-10-22 16:51:53.297868	\N	1	45ea898a-6f5d-11ee-aca0-e454e805e8b9
cdd6f9a6-73f2-11ee-a33c-0dd4c2040095	Write a Python program to find the sum of all even numbers between 1 and 100.	OpenEnded	python developer	NoCodeAnswer	python\nsum_of_evens = 0\nfor num in range(1, 101):\n    if num % 2 == 0:\n        sum_of_evens += num\n\nprint(sum_of_evens)\n	Core Python Coding	5	30	f	5	\N	\N	f	73	2023-10-26 11:28:36.777546	\N	10	d79dfb76-73f0-11ee-a33c-0dd4c2040095
b89dc786-5a2a-11ee-868d-b7c381fb643a	what is decorator in python?	OpenEnded	Java developer	NoCodeAnswer	\N	\N	\N	\N	f	4	clues	\N	\N	4	2023-09-23 16:03:22.649588	\N	\N	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
b89dc787-5a2a-11ee-868d-b7c381fb643a	6 difficulty Visualization Matplotlib test question	Closed	Java developer	CodeBased	\N	\N	\N	\N	t	6	clues	\N	\N	4	2023-09-23 16:03:22.649588	\N	\N	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
585e607c-6738-11ee-a33c-0dd4c2040095	advanced python 	Closed	python developer	NoCodeAnswer	Advanced Python refers to the deeper and more complex aspects of the Python programming language. It involves understanding and utilizing advanced features, libraries, and concepts to write more efficient, scalable, and maintainable code. This includes topics such as object-oriented programming, decorators, generators, metaclasses, multithreading, and multiprocessing. Advanced Python skills enable developers to tackle more complex problems and build sophisticated applications.	Backend Development	5	30	f	5		\N	t	4	2023-10-10 06:43:39.349685	new question	3	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
92c8eea0-6740-11ee-a33c-0dd4c2040095	Django setup	Closed	python developer	NoCodeAnswer	To set up Django, you first need to have Python installed on your system. Once Python is installed, you can use pip, the package installer for Python, to install Django. Open your command line or terminal and run the command "pip install django". This will download and install the latest version of Django. After installation, you can verify that Django is installed correctly by running the command "django-admin --version". If you see the version number, then Django is successfully set up on your system.	Backend Development	5	30	f	5		\N	t	4	2023-10-10 07:42:33.328829	flagged question	2	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
db1fcc50-6740-11ee-a33c-0dd4c2040095	Django setup unchaged	Closed	python developer	NoCodeAnswer	To set up Django, you first need to have Python installed on your system. Once Python is installed, you can use pip, the package installer for Python, to install Django. Open your command line or terminal and run the command "pip install django". This will download and install the latest version of Django. After installation, you can verify that Django is installed correctly by running the command "django-admin --version". If you see the version number, then Django is successfully set up on your system.	Backend Development	5	30	f	5		\N	t	4	2023-10-10 07:44:34.693721	flag	2	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
257aaa7a-674d-11ee-a33c-0dd4c2040095	Django setup from scratch	Closed	python developer	NoCodeAnswer	To set up Django, you first need to have Python installed on your system. Once Python is installed, you can use pip, the package installer for Python, to install Django. Open your command line or terminal and run the command "pip install django". This will download and install the latest version of Django. After installation, you can verify that Django is installed correctly by running the command "django-admin --version". If you see the version number, then Django is successfully set up on your system.	Backend Development	5	30	f	5		\N	f	4	2023-10-10 09:12:33.401727	\N	3	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
9bb0654e-6758-11ee-a33c-0dd4c2040095	asdsad	OpenEnded	python developer	NoCodeAnswer		Backend Development	5	30	f	5		\N	f	4	2023-10-10 10:34:36.197003	\N	3	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
ad7f69bc-6d18-11ee-a33c-0dd4c2040095	What are some of the advantages of GCP over AWS?	OpenEnded	Data Architect	NoCodeAnswer	Some advantages of GCP (Google Cloud Platform) over AWS (Amazon Web Services) include:\n\n1. Data Analytics: GCP offers BigQuery, a powerful and scalable data analytics platform, which makes it easier to analyze large datasets. It also provides Dataflow for real-time data processing.\n\n2. Machine Learning: GCP has a strong focus on machine learning with services like AutoML, AI Platform, and TensorFlow. It provides pre-trained models and tools to build and deploy ML models efficiently.\n\n3. Networking: GCP offers a global network with high-speed interconnectivity, allowing for faster data transfer and reduced latency. It also provides Cloud Load Balancing and Cloud CDN for efficient content delivery.\n\n4. Pricing: GCP offers competitive pricing models, including sustained use discounts and committed use contracts, which can help optimize costs for long-term usage.\n\n5. Kubernetes: GCP was the first cloud provider to develop and release Kubernetes, an open-source container orchestration platform. GCP provides managed Kubernetes services like GKE, making it easier to deploy and manage containerized applications.\n\n6. Data Storage: GCP provides various storage options like Cloud Storage, Cloud SQL, Cloud Spanner, and Cloud Bigtable, offering flexibility and scalability for different data storage needs.\n\n7. Global Infrastructure: GCP has a robust global infrastructure with data centers located in different regions worldwide, allowing for better geographical coverage and compliance with data sovereignty requirements.\n\nIt's important to note that the choice between GCP and AWS depends on specific requirements and preferences, and both platforms have their own strengths and weaknesses.	Web Development	2	30	f	2		\N	t	49	2023-10-17 18:12:05.253053	Lengthy	1	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
000f39b8-6e82-11ee-a33c-0dd4c2040095	new quest	Closed	python developer	NoCodeAnswer	Sure, I'm ready for the new question. Please go ahead and ask.	Core Python Coding	5	30	f	5		\N	f	4	2023-10-19 13:18:32.08786	\N	10	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
2d57f8fc-6f0d-11ee-a33c-0dd4c2040095	What are the key features of Angular?	OpenEnded	python developer	NoCodeAnswer	Some key features of Angular include declarative templates, dependency injection, modular architecture, and extensive tooling support.	Front End Development	5	30	f	5	\N	\N	\N	4	2023-10-20 05:54:48.107544	\N	11	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
02de9c24-6f0e-11ee-a33c-0dd4c2040095	How can you optimize the fuel tank capacity in a car to improve fuel efficiency?	OpenEnded	python developer	NoCodeAnswer	One way to optimize the fuel tank capacity in a car is to reduce the weight of the tank itself. This can be achieved by using lighter materials such as aluminum or carbon fiber instead of steel. Additionally, the shape of the tank can be optimized to minimize air resistance and improve aerodynamics. Another approach is to incorporate fuel-saving technologies such as fuel injection systems or hybrid powertrains.	Automobiles	5	30	f	5	\N	\N	\N	4	2023-10-20 06:00:46.344436	\N	38	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
056f8bf6-6f0e-11ee-a33c-0dd4c2040095	Write a Python function that calculates the optimal fuel tank capacity for a given car model based on its weight, aerodynamics, and fuel efficiency.	OpenEnded	python developer	NoCodeAnswer	def calculate_optimal_capacity(car_model, weight, aerodynamics, fuel_efficiency):\n    # Code to calculate optimal fuel tank capacity\n    pass	Automobiles	5	30	f	5	\N	\N	\N	4	2023-10-20 06:00:50.649887	\N	38	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
fe0fab8c-6f14-11ee-a33c-0dd4c2040095	Truth	OpenEnded	python developer	NoCodeAnswer	In Python, the concept of truth is closely related to boolean values. In Python, True and False are the two boolean values that represent truth and falsehood, respectively. \n\nWhen we evaluate a condition or an expression in Python, it will return either True or False based on its truth value. For example, if we compare two numbers using the greater than operator (>) and the condition is true, it will return True. Otherwise, it will return False.\n\nPython also has the concept of truthiness, which means that certain values can be considered as true or false in a boolean context. For example, an empty string, an empty list, or the number zero are considered as false, while any non-empty string, non-empty list, or any non-zero number is considered as true.\n\nUnderstanding truth in Python is important for writing conditional statements, such as if-else statements, and for controlling the flow of your program based on certain conditions.	Infrastructure	5	30	f	5		\N	f	4	2023-10-20 06:50:44.75444	\N	47	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
fb45b6fc-5b92-11ee-868d-b7c381fb643a	Is python compiler or interpretor language	OpenEnded	Java developer	NoCodeAnswer	\N	\N	\N	\N	f	4	clues	\N	\N	4	2023-09-25 11:02:13.366933	\N	\N	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
fb45b6fd-5b92-11ee-868d-b7c381fb643a	explain __rep__ 	Closed	Java developer	CodeBased	\N	\N	\N	\N	t	6	clues	\N	\N	4	2023-09-25 11:02:13.366933	\N	\N	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
ba9452e6-6739-11ee-a33c-0dd4c2040095	what is inheritance	Closed	python developer	NoCodeAnswer	Inheritance is a concept in object-oriented programming where a class can inherit the properties and methods of another class. It's like a parent-child relationship, where the child class inherits the characteristics of the parent class. This allows for code reuse and promotes a hierarchical structure in your code.	Backend Development	5	30	f	5		\N	f	4	2023-10-10 06:53:33.615815	\N	3	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1677d666-6742-11ee-a33c-0dd4c2040095	one is to many	OpenEnded	python developer	NoCodeAnswer		Backend Development	5	30	f	5		\N	f	4	2023-10-10 07:53:23.755831	\N	3	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
52e3ae80-674d-11ee-a33c-0dd4c2040095	New code base setup	OpenEnded	python developer	NoCodeAnswer		Backend Development	5	30	f	5		\N	f	4	2023-10-10 09:13:49.587607	\N	2	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
c71e6aa6-674d-11ee-a33c-0dd4c2040095	What is a dynamically typed language? 	OpenEnded	python developer	NoCodeAnswer		Backend Development	5	30	f	5		\N	f	4	2023-10-10 09:17:04.588579	\N	2	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
bf1a0b02-6758-11ee-a33c-0dd4c2040095	saADSADA	OpenEnded	python developer	NoCodeAnswer		Backend Development	5	30	f	5		\N	f	4	2023-10-10 10:35:35.605533	\N	3	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
df35e5f0-6758-11ee-a33c-0dd4c2040095	sndsvnds	OpenEnded	python developer	NoCodeAnswer		Backend Development	5	30	f	5		\N	t	4	2023-10-10 10:36:29.471604	flag	3	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
7d5b257c-6d19-11ee-a33c-0dd4c2040095	How much years of experience would it take for a person to become a Data Architect on an average?	OpenEnded	Data Architect	NoCodeAnswer	The number of years of experience required to become a Data Architect can vary depending on various factors such as the individual's background, education, and the specific industry or organization. On average, it may take around 5-10 years of relevant experience to become a proficient Data Architect. However, it's important to note that experience alone is not the sole determinant of expertise. Continuous learning, staying updated with industry trends, and gaining practical hands-on experience are equally important in becoming a successful Data Architect.	Web Development	1	5	f	2		\N	f	64	2023-10-17 18:17:53.981195	\N	1	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
3c3ca94a-6e85-11ee-a33c-0dd4c2040095	dasdsa	Closed	python developer	NoCodeAnswer	I'm sorry, but I didn't understand your input. Could you please rephrase or provide more context?	Backend Development	5	30	f	5		\N	f	4	2023-10-19 13:41:41.539295	\N	2	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
c048b52e-6f0e-11ee-a33c-0dd4c2040095	What is the difference between the 'new' keyword and the 'init' method in Python?	OpenEnded	python developer	NoCodeAnswer	The 'new' keyword is used to create a new instance of a class, while the 'init' method is used to initialize the attributes of the instance.	Conti	5	30	f	5	\N	\N	\N	4	2023-10-20 06:06:04.129216	\N	26	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
c3ff43fe-6f0e-11ee-a33c-0dd4c2040095	What is the purpose of the 'new' keyword in Python?	OpenEnded	python developer	NoCodeAnswer	The 'new' keyword in Python is used to create a new instance of a class.	Conti	5	30	f	5	\N	\N	\N	4	2023-10-20 06:06:10.358841	aasdasdsa	26	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
d6e67122-6f0e-11ee-a33c-0dd4c2040095	dasdsadasd	OpenEnded	python developer	NoCodeAnswer		Laboratory	5	30	f	5		\N	t	4	2023-10-20 06:06:42.075399	dasdasds	30	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
1fb1e732-6f15-11ee-a33c-0dd4c2040095	What is the syntax for creating a table in Hive for the Software Development industry?	OpenEnded	python developer	NoCodeAnswer	To create a table in Hive for the Software Development industry, you can use the following syntax:\n\nCREATE TABLE table_name (\n  column1 data_type,\n  column2 data_type,\n  ...\n) [PARTITIONED BY (column_name data_type, ...)] [CLUSTERED BY (column_name) [SORTED BY (column_name ASC|DESC)] INTO num_buckets BUCKETS] [ROW FORMAT row_format] [STORED AS file_format] [LOCATION 'hdfs_path'];\n\nYou can specify the column names and data types, partitioning, clustering, row format, file format, and storage location as per your requirements.	Infrastructure	5	30	f	5	\N	\N	f	4	2023-10-20 06:51:41.182576	\N	49	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
c27bfdcc-6f15-11ee-a33c-0dd4c2040095	How does Angular handle data binding and change detection?	OpenEnded	python developer	NoCodeAnswer	Angular uses a two-way data binding approach, where changes in the model are automatically reflected in the view and vice versa. It also employs change detection mechanism to efficiently track and update the DOM when data changes.	Front End Development	5	30	f	5	\N	\N	f	4	2023-10-20 06:56:14.300667	\N	11	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
b3fdb824-722d-11ee-a33c-0dd4c2040095	How can you perform dimensionality reduction using Principal Component Analysis (PCA) in unsupervised learning?	OpenEnded	python developer	NoCodeAnswer	Principal Component Analysis (PCA) is a technique used for dimensionality reduction in unsupervised learning. It is used to transform a dataset with a large number of variables into a dataset with fewer variables, while still retaining most of the information. PCA works by finding the directions (principal components) in the data that explain the maximum amount of variance. These principal components are then used to create a new set of variables that capture the most important information in the original dataset.	Machine Learning	5	30	f	5	\N	\N	f	4	2023-10-24 05:25:11.393063	\N	16	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
7f8dae4e-73f6-11ee-a33c-0dd4c2040095	What are the main components of a Django project?	OpenEnded	python developer	NoCodeAnswer	A Django project consists of several components, including the project directory, settings module, URL configuration, and one or more Django applications. The project directory contains the main settings file, URL configuration file, and other project-specific files. The settings module contains the configuration settings for the project, such as database connection details and installed applications. The URL configuration file maps URLs to views, and the Django applications contain the models, views, and templates for specific functionality.	Backend Development	1	10	f	5	\N	\N	t	4	2023-10-26 11:55:03.421889	dasd	3	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
847988d2-73f7-11ee-a33c-0dd4c2040095	Write a Python class named 'Rectangle' with two attributes 'length' and 'width'. Implement a method 'area' that calculates and returns the area of the rectangle.	OpenEnded	python developer	NoCodeAnswer	python\nclass Rectangle:\n    def __init__(self, length, width):\n        self.length = length\n        self.width = width\n\n    def area(self):\n        return self.length * self.width\n	Core Python Coding	6	50	f	5	\N	\N	f	4	2023-10-26 12:02:21.175025	\N	12	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
dd3b1616-74b5-11ee-a33c-0dd4c2040095	What would be the next number in the series?\n13... 17.. 19.. 24..	Closed	Fresher	NoCodeAnswer	The next number in the series would be 26. The pattern in the series is that each number is obtained by adding a prime number to the previous number. For example, 13 + 4 (which is a prime number) equals 17. Then, 17 + 2 (another prime number) equals 19. Continuing this pattern, 19 + 5 (a prime number) equals 24. Finally, 24 + 2 (a prime number) equals 26, giving us the next number in the series.	Problem Solving	2	30	f	5		\N	f	76	2023-10-27 10:44:54.462781	\N	59	d3fb23da-74b4-11ee-a33c-0dd4c2040095
ac743ca4-6694-11ee-8905-e454e805e8b9	Explain AutoScaling in cloud computing 1	Closed	python developer	CodeBased	value	Backend Development	1	2	f	1	 value	value	f	4	2023-10-09 11:12:01.757295	value	2	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
ea27931a-6739-11ee-a33c-0dd4c2040095	what is polymorphism	Closed	python developer	NoCodeAnswer	Polymorphism is the ability of an object to take on many forms. In Python, it allows different objects to be treated as if they were the same type, as long as they have a common interface or base class. It's like a shape-shifter that can transform into different forms while still retaining its essential characteristics. For example, a "Cat" and a "Dog" can both be treated as "Animals" because they share common behaviors like "eat" and "sleep".	Backend Development	5	30	f	5		\N	t	4	2023-10-10 06:54:53.437812	flag answer	3	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
56e7a74e-6742-11ee-a33c-0dd4c2040095	Django setup new	OpenEnded	python developer	NoCodeAnswer		Backend Development	5	30	f	5		\N	f	4	2023-10-10 07:55:11.863313	\N	6	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
4e80dfcb-5863-11ee-b780-1826497b5137	what is a decorator in python?	Closed	python developer	CodeBased	value	Core Python Coding	1	2	f	2	 @route on a line before a function	value	f	4	2023-09-21 09:43:18.339802	value	7	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
6be023f9-5863-11ee-b6ff-1826497b5137	What is the difference between continue and pass in Python?	Closed	python developer	CodeBased	value	Core Python Coding	1	2	f	2	Explain from an context of for loop	value	f	4	2023-09-21 09:44:07.554509	value	7	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
838b6c0b-5863-11ee-99f6-1826497b5137	numbers = [1,2,3,4,5,6,7,8,9,10] print just even numbers using array/list slicing?	Closed	python developer	CodeBased	value	Core Python Coding	1	2	t	2	[start:stop:step]	value	f	4	2023-09-21 09:44:47.264461	value	7	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
96465a1e-674e-11ee-a33c-0dd4c2040095	new question	Closed	python developer	NoCodeAnswer	Sure, I'm ready for the next question. Please go ahead and ask.	Backend Development	5	30	f	5		\N	t	4	2023-10-10 09:22:52.13832	new question	3	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
0a302754-675c-11ee-a33c-0dd4c2040095	python basics question	Closed	python developer	NoCodeAnswer	Sure, I'm ready to answer your question about Python basics. Please go ahead and ask me.	Backend Development	5	30	f	5		\N	f	4	2023-10-10 10:59:10.067053	\N	2	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
a2959ce4-6db6-11ee-a33c-0dd4c2040095	new question one	Closed	python developer	NoCodeAnswer	Can you explain the role of a Data Architect?	Backend Development	5	30	f	5		\N	t	4	2023-10-18 13:02:47.42669	dsad	2	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
c0eb0c06-6db6-11ee-a33c-0dd4c2040095	new question two	Closed	python developer	NoCodeAnswer	Question: Can you explain the concept of data modeling and its importance in the field of data architecture?\n\nAnswer: Data modeling is the process of creating a visual representation of how data is organized and structured within a database or system. It involves identifying entities (such as customers or products), their attributes (such as name or price), and the relationships between them. \n\nData modeling is crucial in data architecture because it helps ensure that data is organized, consistent, and easily accessible. It acts as a blueprint for designing databases and systems, allowing for efficient storage, retrieval, and manipulation of data. \n\nThink of data modeling as creating a map for a city. Without a map, it would be challenging to navigate and find specific locations. Similarly, without data modeling, it would be difficult to understand the relationships between different data elements and efficiently retrieve the information we need.	Backend Development	5	30	f	5		\N	f	4	2023-10-18 13:03:38.318569	\N	3	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
63c04864-6e85-11ee-a33c-0dd4c2040095	dasdsad	OpenEnded	python developer	NoCodeAnswer	I'm sorry, but I'm unable to understand your input. Could you please provide a specific question or topic related to the role of a Data Architect?	Backend Development	5	30	f	5		\N	f	4	2023-10-19 13:42:47.83699	\N	3	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
8f5d4008-6e85-11ee-a33c-0dd4c2040095	a question	Closed	python developer	CodeBasedAnswer	Yes, please go ahead and ask your question. I'm ready to answer.	Backend Development	5	30	t	5		\N	f	4	2023-10-19 13:44:01.003579	\N	14	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
eb038aa6-6f12-11ee-a33c-0dd4c2040095	Write a Python function to find the maximum score of a player in a game. The function should take the player's name and a list of scores as input and return the maximum score.	OpenEnded	python developer	NoCodeAnswer	def find_max_score(player_name, scores):\n    max_score = max(scores)\n    return max_score	Conti	5	30	f	5	\N	\N	f	4	2023-10-20 06:35:53.804856	\N	42	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
f12f0e82-6f12-11ee-a33c-0dd4c2040095	Write a Python function to calculate the score of a player in a game. The function should take the player's name and a list of scores as input and return the total score.	OpenEnded	python developer	NoCodeAnswer	def calculate_score(player_name, scores):\n    total_score = sum(scores)\n    return total_score	Conti	5	30	f	5	\N	\N	t	4	2023-10-20 06:36:04.156369	Falgged answer	42	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
9b01b136-6f21-11ee-a33c-0dd4c2040095	Formal question	OpenEnded	python developer	NoCodeAnswer	Can you explain the concept of object-oriented programming (OOP) in Python?	Conti	5	30	f	5		\N	t	4	2023-10-20 08:21:02.026462	Flagged answer	46	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
eab72118-7230-11ee-a33c-0dd4c2040095	New question for dot net developer	OpenEnded	.Net Developer	NoCodeAnswer	Sure, I'm ready for the next question. Please go ahead and ask.	Backend	5	30	f	5		\N	f	4	2023-10-24 05:48:11.69443	\N	58	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
fc4b5e0e-73f6-11ee-a33c-0dd4c2040095	What is the purpose of dimensionality reduction in unsupervised learning?	OpenEnded	python developer	NoCodeAnswer	The purpose of dimensionality reduction in unsupervised learning is to reduce the number of variables or features in a dataset while retaining most of the information. This can be beneficial for several reasons:\n\n1. Simplification: By reducing the dimensionality of the dataset, it becomes easier to visualize and understand the data.\n2. Noise reduction: Dimensionality reduction can help to remove noise or irrelevant features from the dataset, which can improve the performance of machine learning algorithms.\n3. Computational efficiency: With fewer variables, the computational cost of analyzing the data is reduced.\n\nOverall, dimensionality reduction is a useful technique in unsupervised learning for simplifying and improving the analysis of high-dimensional datasets.	Machine Learning	5	30	f	5	\N	\N	t	4	2023-10-26 11:58:32.702289	sadsad	16	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
38540548-73f9-11ee-a33c-0dd4c2040095	new Designation	OpenEnded	python developer	NoCodeAnswer	As a Python developer, your new designation would involve using the Python programming language to develop software applications, websites, or other solutions. You would be responsible for writing clean and efficient code, debugging and troubleshooting issues, and collaborating with other team members to deliver high-quality products. Your role would also include staying updated with the latest Python libraries and frameworks, and continuously improving your coding skills to enhance the overall performance and functionality of the projects you work on.	Backend Development	5	30	f	5		\N	f	4	2023-10-26 12:14:32.415708	\N	4	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
30a3d0e8-76e8-11ee-a33c-0dd4c2040095	What are the basic tools in Figma for designing?	OpenEnded	Web Designer	NoCodeAnswer	The basic tools in Figma for designing include the selection tool, shape tools (rectangle, ellipse, line, etc.), text tool, pen tool, and vector editing tools. These tools allow you to create and manipulate various elements in your design.	Designing	5	30	f	5	\N	\N	f	4	2023-10-30 05:50:11.561084	\N	61	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
32b066da-76e8-11ee-a33c-0dd4c2040095	How can you create a responsive design in Figma?	OpenEnded	Web Designer	NoCodeAnswer	To create a responsive design in Figma, you can use the Auto Layout feature. Auto Layout allows you to create flexible designs that adapt to different screen sizes. You can set constraints on elements and define how they should behave when the screen size changes. This ensures that your design looks good on different devices.	Designing	5	30	f	5	\N	\N	f	4	2023-10-30 05:50:15.006075	\N	61	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
3550680e-76e8-11ee-a33c-0dd4c2040095	How can you create a component with interactive states in Figma?	OpenEnded	Web Designer	NoCodeAnswer	To create a component with interactive states in Figma, you can use the Interactive Components feature. This feature allows you to add interactions and animations to your components. You can define different states for the component and specify how it should behave when certain events occur, such as mouse hover or click.	Designing	5	30	f	5	\N	\N	f	4	2023-10-30 05:50:19.403091	\N	61	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
17e3d1f6-8922-11ee-a33c-0dd4c2040095	What would be the next letter group in the following series?\nacz, egy, ikx, mow, ? 	Closed	Freshers	NoCodeAnswer	The next letter group in the series would be "qru". Each letter group consists of three letters, and the pattern is that the first letter is three positions ahead in the alphabet from the previous group, the second letter is two positions ahead, and the third letter is one position ahead. So, starting with "acz", the next group would be "qru".	Aptitude	2	30	f	3		\N	f	89	2023-11-22 10:30:01.780966	\N	62	d6282f14-8787-11ee-a33c-0dd4c2040095
c491d20e-8922-11ee-a33c-0dd4c2040095	Find the missing number in the below series -\n\n3, 12, 27, 48, 75, 108,?	Closed	Freshers	NoCodeAnswer	To find the missing number in the series, let's look for a pattern. If we observe the given numbers closely, we can see that each number is obtained by adding a consecutive odd number to the previous number.\n\nStarting with 3, we add 1 (the first odd number) to get 4. Then, we add 3 (the next odd number) to get 7. Continuing this pattern, we add 5, 7, 9, and 11 to get the subsequent numbers.\n\nSo, to find the missing number, we need to add 13 (the next odd number) to the last number in the series, which is 108.\n\nTherefore, the missing number in the series is 108 + 13 = 121.	Aptitude	5	30	f	5		\N	f	89	2023-11-22 10:34:51.486321	\N	62	d6282f14-8787-11ee-a33c-0dd4c2040095
b90ebb70-8924-11ee-a33c-0dd4c2040095	The ages of Cindy Carson and Emily Jonah differ by 16 years. Six years ago, Emily Jonah’s age was thrice that of Cindy’s, find their present ages.	Closed	Freshers	NoCodeAnswer	Let's denote Cindy's current age as C and Emily's current age as E. From the problem, we know two things:\n\n1. E = C + 16 (Emily's age is 16 years more than Cindy's)\n2. E - 6 = 3 * (C - 6) (Six years ago, Emily's age was thrice that of Cindy's)\n\nSubstituting the first equation into the second, we get:\n\nC + 16 - 6 = 3 * (C - 6)\n\nSolving this equation, we find that Cindy's current age (C) is 14 years old. Substituting C = 14 into the first equation, we find that Emily's current age (E) is 30 years old.	Aptitude	2	30	f	5		\N	f	89	2023-11-22 10:48:51.169999	\N	63	d6282f14-8787-11ee-a33c-0dd4c2040095
fe57bcaa-89d2-11ee-a33c-0dd4c2040095	What does random mean in random forest?	Closed	Data Scientist	NoCodeAnswer	In Random Forest, "random" refers to two aspects. First, each decision tree in the forest is built on a random subset of the training data. Second, at each node of the tree, a random set of features are considered for splitting. This randomness helps to make the model more robust and less prone to overfitting.	Machine Learning	1	30	f	3		\N	f	4	2023-11-23 07:36:19.837801	\N	64	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
5852e78e-89d3-11ee-a33c-0dd4c2040095	What are the ways to convert text into features?	Closed	Data Scientist	NoCodeAnswer	There are several ways to convert text into features for machine learning models:\n\n1. Bag of Words: This method transforms text into a matrix where each row represents a document and each column represents a unique word in all documents.\n\n2. TF-IDF (Term Frequency-Inverse Document Frequency): This method not only counts the occurrence of words but also weighs them according to their importance. Words that are common in a document but rare in other documents get higher weight.\n\n3. Word Embeddings: This method represents words in a high-dimensional space where similar words are closer to each other. Examples include Word2Vec and GloVe.\n\n4. N-grams: This method considers a sequence of 'n' words instead of individual words. It's useful for capturing phrases or common sequences of words.\n\n5. One-hot Encoding: This method represents each word as a vector of 0s and 1s, where 1 indicates the presence of the word and 0 indicates the absence.\n\n6. Count Vector: This method represents text by counting the number of times each word appears in the document. \n\nRemember, the choice of method depends on the specific task and the nature of the text data.	Nlp	5	30	f	3		\N	f	4	2023-11-23 07:38:50.801229	\N	65	d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0
32fb0ab8-8e9f-11ee-a33c-0dd4c2040095	A bead seller arranged some beads in a multi-layer box. The first layer of the box was square-shaped with 4 rows and 6 columns. Each layer was 1 less in each dimension of the previous layer. What will be the maximum number of beads that could have been in the third layer?	OpenEnded	Freshers	NoCodeAnswer	The third layer would have 2 rows and 4 columns, as each layer is 1 less in each dimension of the previous layer. So, the maximum number of beads that could have been in the third layer is 2*4 = 8 beads.	Aptitude	2	30	f	3		\N	f	89	2023-11-29 10:08:10.133392	\N	67	d6282f14-8787-11ee-a33c-0dd4c2040095
\.


--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role (id, name, created_by, updated_by, created_at, last_updated, superior_roles) FROM stdin;
1	Super Admin	4	\N	2023-09-04 11:21:10.401379	2023-09-04 11:21:10.401379	{1}
3	Questioner manager	4	\N	2023-09-06 07:51:23.342921	2023-09-06 07:51:23.342921	{1,2}
4	Questioner	4	\N	2023-09-06 09:50:31.787869	2023-09-06 09:50:31.787869	{1,2,3}
2	Admin	4	\N	2023-09-05 10:21:03.597315	2023-09-05 10:21:03.597315	{1,2}
\.


--
-- Data for Name: role_page_component; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_page_component (role_id, page_component_id, last_updated) FROM stdin;
1	1	2023-10-05 16:20:29.733068
1	2	2023-10-05 16:20:29.733068
1	3	2023-10-06 10:24:21.856109
1	4	2023-10-09 05:35:04.623818
1	5	2023-10-09 05:35:04.623818
1	6	2023-10-09 05:35:04.623818
3	2	2023-10-10 07:54:42.384328
4	2	2023-10-10 07:55:20.213783
2	1	2023-10-10 08:00:26.796562
2	2	2023-10-10 08:00:26.796562
1	8	2023-10-25 14:47:16.705995
2	8	2023-10-25 14:48:17.105725
3	8	2023-10-25 14:48:47.08275
3	1	2023-10-25 14:49:31.431541
4	8	2023-10-25 14:49:43.687804
2	6	2023-10-27 06:27:55.034364
2	3	2023-10-27 06:29:35.258139
3	6	2023-10-27 06:30:22.220797
\.


--
-- Data for Name: role_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_permission (role_id, permission_id, last_updated) FROM stdin;
1	1	2023-09-04 11:29:16.208322
1	2	2023-09-05 10:07:13.270054
1	3	2023-09-05 10:07:16.532434
1	4	2023-09-05 10:07:24.089017
1	5	2023-09-05 10:07:27.626473
1	6	2023-09-06 07:13:36.197917
1	7	2023-09-06 07:24:38.600115
1	8	2023-09-06 07:30:02.638776
1	9	2023-09-06 07:30:58.461028
1	10	2023-09-06 07:32:54.862643
1	11	2023-09-06 07:33:21.440395
1	12	2023-09-06 07:33:51.331495
1	13	2023-09-06 07:35:07.640516
1	14	2023-09-06 07:35:32.449794
1	15	2023-09-06 07:35:53.201853
1	16	2023-09-06 07:36:17.380465
1	17	2023-09-06 07:36:34.777521
1	18	2023-09-06 07:37:45.512849
1	19	2023-09-06 07:38:17.171522
1	20	2023-09-06 07:38:48.057708
2	6	2023-09-06 07:46:44.195692
2	7	2023-09-06 07:47:15.334074
2	8	2023-09-06 07:47:21.461883
2	9	2023-09-06 07:47:24.967865
2	10	2023-09-06 07:47:28.450088
2	11	2023-09-06 07:47:34.510173
2	12	2023-09-06 07:47:37.32144
2	13	2023-09-06 07:47:40.119113
2	14	2023-09-06 07:47:43.016057
2	15	2023-09-06 07:47:45.785826
2	16	2023-09-06 07:47:48.37653
2	17	2023-09-06 07:47:51.14418
2	18	2023-09-06 07:47:53.825575
2	19	2023-09-06 07:47:56.561975
2	20	2023-09-06 07:48:00.677995
3	4	2023-09-06 07:55:59.217797
3	6	2023-09-06 09:47:24.61473
3	8	2023-09-06 09:47:24.61473
3	9	2023-09-06 09:47:24.61473
3	10	2023-09-06 09:47:24.61473
3	11	2023-09-06 09:47:24.61473
3	12	2023-09-06 09:47:24.61473
3	14	2023-09-06 09:47:24.61473
3	16	2023-09-06 09:47:24.61473
3	18	2023-09-06 09:47:24.61473
3	19	2023-09-06 09:47:24.61473
4	6	2023-09-06 09:50:32.13909
4	8	2023-09-06 09:50:32.13909
4	9	2023-09-06 09:50:32.13909
4	10	2023-09-06 09:50:32.13909
4	11	2023-09-06 09:50:32.13909
4	12	2023-09-06 09:50:32.13909
4	14	2023-09-06 09:50:32.13909
4	16	2023-09-06 09:50:32.13909
4	18	2023-09-06 09:50:32.13909
4	19	2023-09-06 09:50:32.13909
1	21	2023-09-08 06:57:14.925593
1	22	2023-09-08 07:58:30.904457
1	23	2023-09-11 13:33:01.224759
1	24	2023-09-13 07:19:45.349758
1	25	2023-09-22 08:05:05.474219
2	25	2023-09-22 08:05:30.150068
1	26	2023-09-22 13:52:29.779971
1	27	2023-09-22 13:57:15.709122
1	28	2023-09-25 07:47:21.421176
4	28	2023-09-25 07:47:44.332021
2	22	2023-10-04 07:08:20.847993
1	29	2023-10-05 16:17:50.739345
2	29	2023-10-05 16:17:55.439003
2	30	2023-10-05 16:18:31.31952
1	30	2023-10-05 16:18:36.397046
1	31	2023-10-05 16:19:30.212218
1	32	2023-10-05 16:20:06.353695
1	33	2023-10-06 13:51:49.342078
1	34	2023-10-09 11:13:22.000796
2	34	2023-10-09 11:13:25.683064
2	35	2023-10-10 14:30:41.918954
1	35	2023-10-10 14:30:46.998882
1	36	2023-10-10 14:48:08.861659
2	36	2023-10-10 14:48:13.477432
2	37	2023-10-11 11:30:31.597788
1	37	2023-10-11 11:30:35.597994
2	33	2023-10-13 07:03:25.236968
3	25	2023-10-17 11:44:59.499413
4	25	2023-10-17 11:45:12.552371
3	22	2023-10-17 11:49:37.153304
3	29	2023-10-17 11:52:53.782867
3	35	2023-10-17 12:02:11.551804
3	1	2023-10-17 12:03:04.473971
3	37	2023-10-17 13:44:30.727302
3	34	2023-10-17 13:48:14.340265
4	33	2023-10-17 17:57:20.060849
3	33	2023-10-17 18:09:14.859209
2	21	2023-10-17 18:20:57.817703
2	13	2023-10-17 18:29:38.941367
2	28	2023-10-17 18:30:31.018793
3	38	2023-10-18 15:28:04.564391
2	38	2023-10-18 15:28:09.941397
1	38	2023-10-18 15:28:14.870866
2	1	2023-10-20 15:34:20.371684
2	4	2023-10-20 15:34:33.709448
2	24	2023-10-22 16:38:56.292454
3	30	2023-10-22 16:48:43.193279
3	30	2023-10-22 16:48:45.11321
3	36	2023-10-26 11:04:50.035301
1	39	2023-11-02 10:17:24.189423
2	39	2023-11-02 10:17:27.005397
3	39	2023-11-02 10:17:30.483528
1	40	2023-11-02 14:33:12.642538
\.


--
-- Data for Name: sub_domain; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sub_domain (id, name, domain_id, created_by, updated_by, created_at, last_updated) FROM stdin;
1	flask	1	4	\N	2023-08-22 16:51:47.454611	2023-08-22 16:51:47.454611
2	Flask	2	4	\N	2023-09-19 10:59:39.920139	2023-09-19 10:59:39.920139
3	Django	2	4	\N	2023-09-19 11:00:00.368968	2023-09-19 11:00:00.368968
4	OAuth and JWT	2	4	\N	2023-09-19 11:01:06.342143	2023-09-19 11:01:06.342143
5	Docker	2	4	\N	2023-09-19 11:01:16.317716	2023-09-19 11:01:16.317716
6	Kubernetes	2	4	\N	2023-09-19 11:01:38.941754	2023-09-19 11:01:38.941754
7	Coding concepts	3	4	\N	2023-09-21 09:40:52.219712	2023-09-21 09:40:52.219712
8	react	28	4	\N	2023-10-18 12:42:53.849103	2023-10-18 12:42:53.849103
9	Supervised Learning	17	4	\N	2023-10-18 13:24:32.084451	2023-10-18 13:24:32.084451
10	Competitive Programing	3	4	\N	2023-10-18 13:26:57.980136	2023-10-18 13:26:57.980136
11	Angular	28	4	\N	2023-10-18 13:29:15.349988	2023-10-18 13:29:15.349988
12	class	3	4	\N	2023-10-18 13:43:20.323085	2023-10-18 13:43:20.323085
13	new class	3	4	\N	2023-10-18 13:46:11.956875	2023-10-18 13:46:11.956875
14	Java	2	4	\N	2023-10-18 14:02:29.533106	2023-10-18 14:02:29.533106
15	Spring Boot	2	4	\N	2023-10-18 14:02:57.249481	2023-10-18 14:02:57.249481
16	Unsupervised Learning	17	4	\N	2023-10-18 14:04:06.763631	2023-10-18 14:04:06.763631
17	Grails	2	4	\N	2023-10-18 14:07:19.708581	2023-10-18 14:07:19.708581
18	Hibernate	2	4	\N	2023-10-18 14:08:52.952401	2023-10-18 14:08:52.952401
19	Programing	3	4	\N	2023-10-18 14:09:27.274514	2023-10-18 14:09:27.274514
20	Deep Learning	17	4	\N	2023-10-18 14:10:37.686114	2023-10-18 14:10:37.686114
21	Google Web Toolkit	3	4	\N	2023-10-18 14:11:36.306197	2023-10-18 14:11:36.306197
22	Vaadin	2	4	\N	2023-10-18 14:12:10.044073	2023-10-18 14:12:10.044073
23	Play Framework	2	4	\N	2023-10-18 14:12:36.484017	2023-10-18 14:12:36.484017
24	language	29	4	\N	2023-10-19 08:37:51.246085	2023-10-19 08:37:51.246085
25	domain	29	4	\N	2023-10-20 05:04:50.199037	2023-10-20 05:04:50.199037
26	new	30	4	\N	2023-10-20 05:05:19.811796	2023-10-20 05:05:19.811796
27	aws	31	4	\N	2023-10-20 05:07:27.255732	2023-10-20 05:07:27.255732
28	core	32	4	\N	2023-10-20 05:09:58.257386	2023-10-20 05:09:58.257386
29	formula	32	4	\N	2023-10-20 05:11:25.825696	2023-10-20 05:11:25.825696
30	Experiment	33	4	\N	2023-10-20 05:12:15.968798	2023-10-20 05:12:15.968798
31	Lithium ion	34	4	\N	2023-10-20 05:13:15.443126	2023-10-20 05:13:15.443126
32	Brakes	35	4	\N	2023-10-20 05:21:26.961586	2023-10-20 05:21:26.961586
33	Engine	35	4	\N	2023-10-20 05:21:35.693865	2023-10-20 05:21:35.693865
34	Clutch	35	4	\N	2023-10-20 05:21:55.521467	2023-10-20 05:21:55.521467
35	Silencer	35	4	\N	2023-10-20 05:22:12.806762	2023-10-20 05:22:12.806762
36	Air Filter	35	4	\N	2023-10-20 05:26:07.685638	2023-10-20 05:26:07.685638
37	Wheels	35	4	\N	2023-10-20 05:27:07.764202	2023-10-20 05:27:07.764202
38	Fuel tanks	35	4	\N	2023-10-20 05:27:39.999588	2023-10-20 05:27:39.999588
39	titan	29	4	\N	2023-10-20 06:27:21.108371	2023-10-20 06:27:21.108371
40	funel	33	4	\N	2023-10-20 06:33:12.534789	2023-10-20 06:33:12.534789
41	cart	29	4	\N	2023-10-20 06:35:19.431131	2023-10-20 06:35:19.431131
42	game	30	4	\N	2023-10-20 06:35:36.045324	2023-10-20 06:35:36.045324
43	Suspension	35	4	\N	2023-10-20 06:38:00.58017	2023-10-20 06:38:00.58017
44	Engine lubricant	35	4	\N	2023-10-20 06:38:26.559181	2023-10-20 06:38:26.559181
45	flow	30	4	\N	2023-10-20 06:49:34.92462	2023-10-20 06:49:34.92462
46	sequence	30	4	\N	2023-10-20 06:49:47.380187	2023-10-20 06:49:47.380187
47	docker	31	4	\N	2023-10-20 06:50:11.880916	2023-10-20 06:50:11.880916
48	differed	30	4	\N	2023-10-20 06:51:04.376901	2023-10-20 06:51:04.376901
49	hive	31	4	\N	2023-10-20 06:51:15.637827	2023-10-20 06:51:15.637827
50	puppet	33	4	\N	2023-10-20 06:52:15.211729	2023-10-20 06:52:15.211729
51	duke	30	4	\N	2023-10-20 06:52:44.89313	2023-10-20 06:52:44.89313
52	GCP	31	4	\N	2023-10-20 06:58:21.590026	2023-10-20 06:58:21.590026
53	Digital Ocean	31	4	\N	2023-10-20 06:59:06.945635	2023-10-20 06:59:06.945635
54	sub conti	30	4	\N	2023-10-20 08:21:19.061378	2023-10-20 08:21:19.061378
55	national	29	4	\N	2023-10-20 08:21:32.588873	2023-10-20 08:21:32.588873
56	differential	30	4	\N	2023-10-20 08:34:33.47084	2023-10-20 08:34:33.47084
57	Data structures	1	65	\N	2023-10-22 16:43:40.813318	2023-10-22 16:43:40.813318
58	python	36	4	\N	2023-10-24 05:47:35.781112	2023-10-24 05:47:35.781112
59	math	21	76	\N	2023-10-27 10:44:00.372174	2023-10-27 10:44:00.372174
60	Number series	19	76	\N	2023-10-27 10:52:59.772415	2023-10-27 10:52:59.772415
61	figma	78	4	\N	2023-10-30 05:49:53.39409	2023-10-30 05:49:53.39409
62	series	79	89	\N	2023-11-22 10:24:27.015887	2023-11-22 10:24:27.015887
63	Logical Reasoning	79	89	\N	2023-11-22 10:41:31.089941	2023-11-22 10:41:31.089941
64	Random Forest	17	4	\N	2023-11-23 07:35:25.131631	2023-11-23 07:35:25.131631
65	Vectorization	80	4	\N	2023-11-23 07:38:01.342597	2023-11-23 07:38:01.342597
66	average	79	89	\N	2023-11-29 10:04:01.650961	2023-11-29 10:04:01.650961
67	Numbers	79	89	\N	2023-11-29 10:07:08.905142	2023-11-29 10:07:08.905142
68	SQL Joins	20	4	\N	2023-12-06 12:54:01.407777	2023-12-06 12:54:01.407777
\.


--
-- Data for Name: tenant; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tenant (tenant_id, name, created_at, last_updated) FROM stdin;
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	recruitment_platform	2023-06-27 07:00:55.678295	2023-06-27 07:00:55.678295
07e3642c-14d0-11ee-a33c-0dd4c2040095	element-5	2023-06-27 09:50:21.712947	2023-06-27 09:50:21.712947
027a9aa3-7a82-48b8-9fce-d3f8ae581db9	recruitment_platform	2023-06-27 10:20:20.607563	2023-06-27 10:20:20.607563
47285fac-4c89-11ee-a33c-0dd4c2040095	test	2023-09-06 07:44:58.533584	2023-09-06 07:44:58.533584
9cc714ac-4e1a-11ee-a33c-0dd4c2040095	Ideas2IT Tech	2023-09-08 07:37:50.389433	2023-09-08 07:37:50.389433
7b76a442-4e1c-11ee-9665-e454e805e8b9	test2	2023-09-08 07:51:11.898598	2023-09-08 07:51:11.898598
64cd7bc2-4e24-11ee-a33c-0dd4c2040095	Test	2023-09-08 08:47:51.209212	2023-09-08 08:47:51.209212
f68b1d38-4e26-11ee-a33c-0dd4c2040095	testing_1	2023-09-08 09:06:14.711498	2023-09-08 09:06:14.711498
496a73c8-4e31-11ee-a33c-0dd4c2040095	Anandu	2023-09-08 10:20:08.715477	2023-09-08 10:20:08.715477
3d3deb66-56d3-11ee-a33c-0dd4c2040095	ideas2it	2023-09-19 09:59:36.064703	2023-09-19 09:59:36.064703
d97f3496-5c44-11ee-868d-b7c381fb643a	idea2It	2023-09-26 08:15:27.210709	2023-09-26 08:15:27.210709
f10b2822-5c44-11ee-868d-b7c381fb643a	idea2it	2023-09-26 08:16:06.713271	2023-09-26 08:16:06.713271
b1b9dbf4-5c4f-11ee-868d-b7c381fb643a	Ideas	2023-09-26 09:33:05.552714	2023-09-26 09:33:05.552714
e05cd376-5c4f-11ee-868d-b7c381fb643a	idea	2023-09-26 09:34:23.794978	2023-09-26 09:34:23.794978
f1a33f68-5eab-11ee-a33c-0dd4c2040095	recruitmentAdmin	2023-09-29 09:38:28.153356	2023-09-29 09:38:28.153356
912ae446-5eac-11ee-a33c-0dd4c2040095	recruitmentAdmin1	2023-09-29 09:42:55.797461	2023-09-29 09:42:55.797461
be8484a3-61ee-11ee-8955-e04f4370e917	UATTester	2023-10-03 13:14:12.713661	2023-10-03 13:14:12.713661
f789058e-673e-11ee-a33c-0dd4c2040095	UAT	2023-10-10 07:31:03.366954	2023-10-10 07:31:03.366954
09eed6a4-6762-11ee-a33c-0dd4c2040095	NewOrg	2023-10-10 11:42:06.618116	2023-10-10 11:42:06.618116
7896bf22-6762-11ee-a33c-0dd4c2040095	NewjOrg	2023-10-10 11:45:12.268064	2023-10-10 11:45:12.268064
dad81adc-6762-11ee-a33c-0dd4c2040095	newaOrg	2023-10-10 11:47:57.112887	2023-10-10 11:47:57.112887
1a369576-6765-11ee-a33c-0dd4c2040095	newborg	2023-10-10 12:04:02.422616	2023-10-10 12:04:02.422616
6f5e4b56-6766-11ee-a33c-0dd4c2040095	newcorg	2023-10-10 12:13:34.785765	2023-10-10 12:13:34.785765
f247ee00-6766-11ee-a33c-0dd4c2040095	dasdas@dsdsaf.cvcxv%%cxzczxc	2023-10-10 12:17:14.420201	2023-10-10 12:17:14.420201
d43ba666-6808-11ee-a33c-0dd4c2040095	uat	2023-10-11 07:36:02.478945	2023-10-11 07:36:02.478945
3ce3418c-680a-11ee-a33c-0dd4c2040095	uat1	2023-10-11 07:46:07.559491	2023-10-11 07:46:07.559491
ab0152e2-6992-11ee-a33c-0dd4c2040095	PKP	2023-10-13 06:35:15.023676	2023-10-13 06:35:15.023676
45ea898a-6f5d-11ee-aca0-e454e805e8b9	dk_testing	2023-10-20 15:28:08.193476	2023-10-20 15:28:08.193476
d79dfb76-73f0-11ee-a33c-0dd4c2040095	uat_test	2023-10-26 11:14:34.18789	2023-10-26 11:14:34.18789
d3fb23da-74b4-11ee-a33c-0dd4c2040095	Ideas2IT	2023-10-27 10:37:29.446617	2023-10-27 10:37:29.446617
d6282f14-8787-11ee-a33c-0dd4c2040095	Ideas2it	2023-11-20 09:33:17.837677	2023-11-20 09:33:17.837677
1b3590ce-878d-11ee-a33c-0dd4c2040095	id2it	2023-11-20 10:11:01.172741	2023-11-20 10:11:01.172741
\.


--
-- Data for Name: tenant_designation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tenant_designation (tenant_id, designation_id, last_updated) FROM stdin;
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	9	2023-09-06 07:19:26.642665
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	8	2023-09-06 07:19:40.867149
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	17	2023-09-18 11:45:39.104417
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	18	2023-09-18 12:07:27.456003
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	19	2023-09-18 12:20:15.868542
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	20	2023-09-18 12:42:05.721701
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	1	2023-09-19 09:53:23.609396
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	21	2023-09-19 12:42:05.327973
f1a33f68-5eab-11ee-a33c-0dd4c2040095	20	2023-09-29 12:02:26.749571
f1a33f68-5eab-11ee-a33c-0dd4c2040095	22	2023-09-29 12:11:53.844498
f1a33f68-5eab-11ee-a33c-0dd4c2040095	5	2023-09-29 12:12:17.310603
f1a33f68-5eab-11ee-a33c-0dd4c2040095	1	2023-09-29 12:13:57.135748
f1a33f68-5eab-11ee-a33c-0dd4c2040095	23	2023-09-29 12:14:57.76577
be8484a3-61ee-11ee-8955-e04f4370e917	24	2023-10-03 13:14:58.307683
be8484a3-61ee-11ee-8955-e04f4370e917	5	2023-10-05 17:01:52.469662
47285fac-4c89-11ee-a33c-0dd4c2040095	5	2023-10-09 11:04:07.078458
47285fac-4c89-11ee-a33c-0dd4c2040095	8	2023-10-09 11:15:53.828718
f789058e-673e-11ee-a33c-0dd4c2040095	1	2023-10-10 08:02:07.657271
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	25	2023-10-11 07:22:47.988556
ab0152e2-6992-11ee-a33c-0dd4c2040095	26	2023-10-13 06:38:05.511205
ab0152e2-6992-11ee-a33c-0dd4c2040095	1	2023-10-13 06:40:11.101026
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	27	2023-10-13 07:33:55.763313
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	28	2023-10-13 07:35:47.189616
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	29	2023-10-13 09:18:03.309858
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	30	2023-10-13 12:41:09.058632
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	31	2023-10-13 12:41:26.309158
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	32	2023-10-17 07:40:51.383886
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	33	2023-10-17 07:41:23.930779
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	34	2023-10-17 11:04:55.829029
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	35	2023-10-17 11:47:34.640592
45ea898a-6f5d-11ee-aca0-e454e805e8b9	5	2023-10-20 15:29:19.977864
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	36	2023-10-24 08:47:24.283004
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	37	2023-10-24 08:57:01.90946
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	38	2023-10-25 13:10:33.556216
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	39	2023-10-25 13:12:17.047615
d79dfb76-73f0-11ee-a33c-0dd4c2040095	1	2023-10-26 11:16:10.50821
d79dfb76-73f0-11ee-a33c-0dd4c2040095	5	2023-10-26 11:33:18.701603
45ea898a-6f5d-11ee-aca0-e454e805e8b9	1	2023-10-27 06:43:25.005949
d3fb23da-74b4-11ee-a33c-0dd4c2040095	38	2023-10-27 10:38:12.076843
d6282f14-8787-11ee-a33c-0dd4c2040095	1	2023-11-20 09:50:17.462891
1b3590ce-878d-11ee-a33c-0dd4c2040095	1	2023-11-20 10:16:41.977777
d6282f14-8787-11ee-a33c-0dd4c2040095	21	2023-11-21 11:23:34.088948
d6282f14-8787-11ee-a33c-0dd4c2040095	40	2023-11-22 10:03:56.657669
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	41	2023-12-06 12:53:01.424142
\.


--
-- Data for Name: tenant_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tenant_user (tenant_id, user_id, last_updated) FROM stdin;
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	1	2023-06-27 07:02:17.810433
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	2	2023-06-27 07:02:21.580421
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	3	2023-06-27 07:02:25.461024
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	4	2023-06-27 09:49:32.348982
07e3642c-14d0-11ee-a33c-0dd4c2040095	5	2023-06-27 09:50:21.712947
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	4	2023-06-27 10:20:20.607563
47285fac-4c89-11ee-a33c-0dd4c2040095	8	2023-09-06 07:44:58.533584
47285fac-4c89-11ee-a33c-0dd4c2040095	9	2023-09-06 09:39:04.286263
9cc714ac-4e1a-11ee-a33c-0dd4c2040095	10	2023-09-08 07:37:50.389433
7b76a442-4e1c-11ee-9665-e454e805e8b9	11	2023-09-08 07:51:11.898598
64cd7bc2-4e24-11ee-a33c-0dd4c2040095	12	2023-09-08 08:47:51.209212
f68b1d38-4e26-11ee-a33c-0dd4c2040095	13	2023-09-08 09:06:14.711498
496a73c8-4e31-11ee-a33c-0dd4c2040095	14	2023-09-08 10:20:08.715477
3d3deb66-56d3-11ee-a33c-0dd4c2040095	15	2023-09-19 09:59:36.064703
d97f3496-5c44-11ee-868d-b7c381fb643a	16	2023-09-26 08:15:27.210709
f10b2822-5c44-11ee-868d-b7c381fb643a	17	2023-09-26 08:16:06.713271
b1b9dbf4-5c4f-11ee-868d-b7c381fb643a	18	2023-09-26 09:33:05.552714
e05cd376-5c4f-11ee-868d-b7c381fb643a	19	2023-09-26 09:34:23.794978
f1a33f68-5eab-11ee-a33c-0dd4c2040095	20	2023-09-29 09:38:28.153356
912ae446-5eac-11ee-a33c-0dd4c2040095	21	2023-09-29 09:42:55.797461
be8484a3-61ee-11ee-8955-e04f4370e917	22	2023-10-03 13:14:12.713661
f789058e-673e-11ee-a33c-0dd4c2040095	23	2023-10-10 07:31:03.366954
09eed6a4-6762-11ee-a33c-0dd4c2040095	24	2023-10-10 11:42:06.618116
7896bf22-6762-11ee-a33c-0dd4c2040095	25	2023-10-10 11:45:12.268064
dad81adc-6762-11ee-a33c-0dd4c2040095	26	2023-10-10 11:47:57.112887
1a369576-6765-11ee-a33c-0dd4c2040095	27	2023-10-10 12:04:02.422616
6f5e4b56-6766-11ee-a33c-0dd4c2040095	28	2023-10-10 12:13:34.785765
f247ee00-6766-11ee-a33c-0dd4c2040095	29	2023-10-10 12:17:14.420201
d43ba666-6808-11ee-a33c-0dd4c2040095	30	2023-10-11 07:36:02.478945
3ce3418c-680a-11ee-a33c-0dd4c2040095	31	2023-10-11 07:46:07.559491
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	32	2023-10-11 11:30:45.55013
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	33	2023-10-11 11:31:05.48907
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	34	2023-10-11 11:31:14.872816
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	35	2023-10-11 14:22:50.650942
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	36	2023-10-11 14:22:57.884399
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	37	2023-10-11 14:23:24.111692
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	38	2023-10-11 14:23:32.702705
ab0152e2-6992-11ee-a33c-0dd4c2040095	39	2023-10-13 06:35:15.023676
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	40	2023-10-17 03:48:33.841171
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	41	2023-10-17 06:28:11.616746
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	42	2023-10-17 07:00:39.682522
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	43	2023-10-17 07:08:45.255615
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	44	2023-10-17 07:11:03.718688
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	45	2023-10-17 07:12:35.384132
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	46	2023-10-17 07:21:13.387342
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	47	2023-10-17 07:28:08.707025
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	48	2023-10-17 07:28:42.551627
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	49	2023-10-17 11:06:26.508678
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	50	2023-10-17 13:11:56.253168
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	51	2023-10-17 13:45:49.23418
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	52	2023-10-17 13:49:24.821034
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	53	2023-10-17 14:52:04.082094
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	54	2023-10-17 14:53:03.208988
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	55	2023-10-17 14:54:10.038943
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	56	2023-10-17 16:37:17.253649
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	57	2023-10-17 16:43:07.645105
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	58	2023-10-17 16:44:35.483825
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	59	2023-10-17 16:54:28.067449
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	60	2023-10-17 16:57:08.099094
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	61	2023-10-17 17:01:20.748112
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	62	2023-10-17 17:08:34.145388
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	63	2023-10-17 17:10:52.247989
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	64	2023-10-17 18:14:48.101073
45ea898a-6f5d-11ee-aca0-e454e805e8b9	65	2023-10-20 15:28:08.193476
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	66	2023-10-20 15:35:09.380476
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	67	2023-10-20 16:47:00.273526
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	68	2023-10-20 16:49:14.140058
45ea898a-6f5d-11ee-aca0-e454e805e8b9	69	2023-10-22 16:40:50.638201
45ea898a-6f5d-11ee-aca0-e454e805e8b9	70	2023-10-22 16:51:02.452699
45ea898a-6f5d-11ee-aca0-e454e805e8b9	71	2023-10-26 10:53:22.626263
d79dfb76-73f0-11ee-a33c-0dd4c2040095	72	2023-10-26 11:14:34.18789
d79dfb76-73f0-11ee-a33c-0dd4c2040095	73	2023-10-26 11:17:59.404001
d79dfb76-73f0-11ee-a33c-0dd4c2040095	74	2023-10-26 11:23:44.860495
d3b1f00a-5a0b-43bb-86ad-9a6afbaf58a0	75	2023-10-26 12:11:33.96589
d3fb23da-74b4-11ee-a33c-0dd4c2040095	76	2023-10-27 10:37:29.446617
d3fb23da-74b4-11ee-a33c-0dd4c2040095	77	2023-10-27 10:39:45.769803
d6282f14-8787-11ee-a33c-0dd4c2040095	78	2023-11-20 09:33:17.837677
1b3590ce-878d-11ee-a33c-0dd4c2040095	79	2023-11-20 10:11:01.172741
1b3590ce-878d-11ee-a33c-0dd4c2040095	80	2023-11-21 06:50:28.568935
1b3590ce-878d-11ee-a33c-0dd4c2040095	85	2023-11-21 10:46:14.437372
d6282f14-8787-11ee-a33c-0dd4c2040095	86	2023-11-21 11:17:06.187052
d6282f14-8787-11ee-a33c-0dd4c2040095	87	2023-11-21 11:23:18.819725
d6282f14-8787-11ee-a33c-0dd4c2040095	88	2023-11-21 11:28:43.656921
d6282f14-8787-11ee-a33c-0dd4c2040095	89	2023-11-22 10:19:38.183194
d6282f14-8787-11ee-a33c-0dd4c2040095	90	2023-12-01 10:58:58.864607
d6282f14-8787-11ee-a33c-0dd4c2040095	91	2023-12-01 10:59:10.686231
d6282f14-8787-11ee-a33c-0dd4c2040095	92	2023-12-01 10:59:55.443153
d6282f14-8787-11ee-a33c-0dd4c2040095	93	2023-12-01 11:00:42.21992
d79dfb76-73f0-11ee-a33c-0dd4c2040095	94	2023-12-02 03:32:59.662559
d79dfb76-73f0-11ee-a33c-0dd4c2040095	95	2023-12-02 03:52:22.590559
d79dfb76-73f0-11ee-a33c-0dd4c2040095	96	2023-12-02 03:54:38.467291
d79dfb76-73f0-11ee-a33c-0dd4c2040095	97	2023-12-02 03:56:40.020706
d79dfb76-73f0-11ee-a33c-0dd4c2040095	98	2023-12-02 04:00:16.26869
d79dfb76-73f0-11ee-a33c-0dd4c2040095	99	2023-12-02 04:02:19.561686
d79dfb76-73f0-11ee-a33c-0dd4c2040095	100	2023-12-02 04:04:04.785713
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (user_id, first_name, last_name, email, password, last_updated, jwt_token, role_id) FROM stdin;
1	esakki	muthu	esakki@ideas2it.com	pbkdf2:sha256:260000$IqQBCcUFCDTPBE3k$0454fc93294f3cb45c8a8d2896c7b0a21b0b9979af446e766fa831ebe832e14c	2023-06-01 06:37:22.694873	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxLCJkZXNpZ25hdGlvbiI6WzFdLCJleHAiOjE2ODU2MDUwNDJ9.R1e4cQEj1AhNVBS7MNfXXPfpIdJX077JaU1YVmumwCc	\N
2	esakki	muthu	esakki+1@ideas2it.com	pbkdf2:sha256:260000$LFVPh9ZfX2XswwXw$8be884249e1c387f693ff30830f18d82f070ca0bfe0918a6439d9d56422c3a0e	2023-06-02 07:33:49.416649	\N	\N
3	super	admin	recruitment_admin@ideas2it.com	pbkdf2:sha256:260000$UBsCM9OwYv5P8SZ1$06d3a3a5e702a61678aaba2569c8ee1dd8261154e2e170343ec35190dd63c957	2023-06-27 07:01:00.618086	2023-06-27 07:01:00.618086+00	\N
5	element-5	element-5	element-5@airecruitment.com	pbkdf2:sha256:260000$to3COO8mtBOQl1Cj$2c921998c94c7ddaf97b1751ae33231ce5b744c4f12bfbe410e4d25a1d023c45	2023-06-27 09:50:21.712947	\N	\N
4	super	admin	recruitment_admin@airecruitment.com	pbkdf2:sha256:260000$UBsCM9OwYv5P8SZ1$06d3a3a5e702a61678aaba2569c8ee1dd8261154e2e170343ec35190dd63c957	2023-06-27 09:48:11.369136	2023-06-27 09:48:11.369136+00	1
8	test	test	test@airecruitment.com	pbkdf2:sha256:260000$iyuhd19mreEQbr3U$da7e3df3dfceb6d58e993ad846903498e9c1f20485b02134fb75a0d7a75c6b06	2023-09-06 07:44:58.533584	\N	2
9	Questioner	manager	ques_manager@gmail.com	pbkdf2:sha256:260000$E8Plu4uiS62kzoOb$5b414eaef4de6c47374df897c62d41cd249c4f683405d79565e666808b01717f	2023-09-06 09:39:04.286263	\N	3
10	Ideas2IT Tech	Ideas2IT Tech	Ideas2IT Tech@airecruitment.com	pbkdf2:sha256:260000$ijoWEk4BzWfYoLXV$2af631833f30b48b86df14fdc327941373c8c8e99a40711a30e8282a5446dd41	2023-09-08 07:37:50.389433	\N	2
11	fname	lname	test2@airecruitment.com	pbkdf2:sha256:260000$Kc8eA5iBdmezTdOX$2dc20b10b77292104f4a30f5bdcdece7c07c026caf6d0de9f7ce7786954f60ac	2023-09-08 07:51:11.898598	\N	2
12	Test	Admin	test@gmail.com	pbkdf2:sha256:260000$2adWrcZHPS9txvoV$fcfa077ee775a4e594282eee1575bed496f81bd2766fbe68dfb3fb5cec4a4889	2023-09-08 08:47:51.209212	\N	2
13	testing_1	Admin	testing@gmail.com	pbkdf2:sha256:260000$QkzRY7Bkh5m3FXx8$99aa2483c552a8935412f89d0cfff84bd69b321c80a9bda6b77238dc6cdfa8be	2023-09-08 09:06:14.711498	\N	2
14	Anandu	Admin	anandu@gmail.com	pbkdf2:sha256:260000$fPgzj0p56d3B1uHj$069ff7a9768152901eb2c4a680b588c34de340df2ffe61228fe39b0802431af9	2023-09-08 10:20:08.715477	\N	2
15	ideas2it	Admin	ideas2it@mailinator.com	pbkdf2:sha256:260000$ZtYZz8eUIVwNegFc$3517f996b95cbf8729e175b1a31ff56c2fc148841477b096b9a920f1ba29b896	2023-09-19 09:59:36.064703	\N	2
16	idea2It	Admin	idea2it@airecruitment.com	pbkdf2:sha256:260000$Jsk9tVUBCtHveHgA$b712c33d4faadc4b7ab1c5fa19f39a63c888d50b307883dad1a6fa991018d615	2023-09-26 08:15:27.210709	\N	2
17	idea2it	Admin	idea2it_admin@airecruitment.com	pbkdf2:sha256:260000$D938FOTh6WdALXA7$9d518007e9eaafe72596f48d93b4736df9bde241f748f4ee51add3048bd8d823	2023-09-26 08:16:06.713271	\N	2
18	Ideas	Admin	ideas@gmail.com	pbkdf2:sha256:260000$nVIxoDqbEXbemHG8$3c58e68c00febe0ecb6c487fb795a7e858757dd0968415a0e87d286dadc74993	2023-09-26 09:33:05.552714	\N	2
19	idea	Admin	idea@airecruitment.com	pbkdf2:sha256:260000$d7HiMIhTJ6o47sRp$34da1f4457f91c0b55802663babfff031fc18a3d4a82be0eff297368cc8ebe5a	2023-09-26 09:34:23.794978	\N	2
20	recruitmentAdmin	Admin	recruitmentAdmin@ideas2it.com	pbkdf2:sha256:260000$aL3zyHPhzk3xmrpC$46b0007acc23265f8ba18d2eeb5480d7fffc3f7aef978ef3e3faeb508d0aca3f	2023-09-29 09:38:28.153356	\N	2
21	recruitmentAdmin1	Admin	recruitmentAdmin1@ideas2it.com	pbkdf2:sha256:260000$tqYtWaGaBPByESx2$491db836f0a211b55cd83640d8d8e0802741676a67a0016d38badfb89e44f6fc	2023-09-29 09:42:55.797461	\N	2
22	UATTester	Admin	uat_tester@uattester.com	pbkdf2:sha256:260000$SPi7oKtLaA61GiVW$ae003cb69b6c63def6d8515862421148a225e97e4f31594247d9a264bbea7674	2023-10-03 13:14:12.713661	\N	2
23	UAT	Admin	uattest_admin@uat.com	pbkdf2:sha256:260000$SOTM1rINyfBHXWlk$f487281704a44a36390f4940b0db53d3257c626fd7f9b593282565aeff24ec74	2023-10-10 07:31:03.366954	\N	2
24	NewOrg	Admin	neworg_admin@airecruitment.com	pbkdf2:sha256:260000$rdpejUCPMszsKN4L$2ef429b064d4cf84542dd008a69a27d8da0392b3756942aef14037a6d9006472	2023-10-10 11:42:06.618116	\N	2
25	NewjOrg	Admin	newJorg_admin@airecruitment.com	pbkdf2:sha256:260000$z7bady3Uf9o7kelj$636174dc2bcef359930f6386dff5acc98f7985a654ed1c340da755569687682c	2023-10-10 11:45:12.268064	\N	2
26	newaOrg	Admin	newaorg_admin@airecruitment.com	pbkdf2:sha256:260000$np2vnDi73dELDV8w$022f6475720b222933ab2386ab38c6ab7f009c2241bea8d5cd81bb4a15315fb2	2023-10-10 11:47:57.112887	\N	2
27	newborg	Admin	newborg_admin@airecruitment.com	pbkdf2:sha256:260000$xiOR5HBwyHCX74LH$78d35bcf3d0d399c40742a768b47b0650314817063c79682ea9c1bf29d4e7b81	2023-10-10 12:04:02.422616	\N	2
28	newcorg	Admin	newcorg_admin@airecruitment.com	pbkdf2:sha256:260000$1Ta1TmGkIchcY7qq$7a3ed2d580d566e106ba33055d2820055cf1d4c71b35b04ac64729a9dd6487d1	2023-10-10 12:13:34.785765	\N	2
29	dasdas@dsdsaf.cvcxv%%cxzczxc	Admin	newaorg_adcxz54334min@airecruitment.com	pbkdf2:sha256:260000$XSRlkCre3N1nmkax$b430012d35ec47dccf9edc477f69c5856b126a7b40438222cf114d7b62e35ce4	2023-10-10 12:17:14.420201	\N	2
30	uat	Admin	uat_admin@uat.com	pbkdf2:sha256:260000$sdqqRIDcJBAYJK1v$5d272fdac4e13b8ffa27243f77aa1a129e334c0ca4cd6beaa68e0ca6638ac757	2023-10-11 07:36:02.478945	\N	2
31	uat1	Admin	uat1_admin@uat.com	pbkdf2:sha256:260000$9XW7N2pWOPft6TGb$7f6c3451c5b95bf4d4a01ac769621738e1d9f8f917c8d63bbd7ed53c51d4ac89	2023-10-11 07:46:07.559491	\N	2
32	Questioner	manager	ques_manager1@gmail.com	pbkdf2:sha256:260000$sp28KSl0CLLYUvLK$2f175c245b533b0dff5bdd56a2cd5beac4984276d4f6ce4fb3f11c4ce0f5bd7e	2023-10-11 11:30:45.55013	\N	3
33	Questioner	user	questioner1@gmail.com	pbkdf2:sha256:260000$0j1vkaEJBjymXHeI$3efc441c47d51a4146070fe80ecf77411eb8d666870f0f29d3b28655a4a2b01d	2023-10-11 11:31:05.48907	\N	4
34	Questioner	user 2	questioner2@gmail.com	pbkdf2:sha256:260000$a6zMD1hyYgsftPPt$ca54be9ff1d3f79250d96dfb7a9acbd25c6f4e40892d30073ac97ab6f7e2b3fe	2023-10-11 11:31:14.872816	\N	4
35	Questioner	user 3	questioner3@gmail.com	pbkdf2:sha256:260000$a3eQVxBykSGkjDrK$fe224520868dd73fe385c8d553438ef61e042ec6ccaf1ff2494b0b48050a9262	2023-10-11 14:22:50.650942	\N	4
36	Questioner	user 4	questioner4@gmail.com	pbkdf2:sha256:260000$SjEn5QWpZMH43Duk$1e7a7ddca884843fb566c9720888c3134d1471bdd2ac83757b3c73078eaa8470	2023-10-11 14:22:57.884399	\N	4
37	Questioner	manager 2	questionermanager2@gmail.com	pbkdf2:sha256:260000$mjcIpZQryN6sVV4D$47ed91a4176fa03de500158fa3d67fd254b313cad67a77582020096390307a2d	2023-10-11 14:23:24.111692	\N	3
38	Questioner	manager 3	questionermanager3@gmail.com	pbkdf2:sha256:260000$3qvfloPr3quFAQPa$3a72065efb6fd8986dedb6cb3f4f584644f95b9f1ddbd05e0466c5064b136d05	2023-10-11 14:23:32.702705	\N	3
40	dadas	dsada	dsasda@ddasd.dasdas	pbkdf2:sha256:260000$3nXNV1aLNl1Fulfw$ea9343ee4cd639fc3c0a92d786988320fe0314992554f2eeb9a41a87060435b9	2023-10-17 03:48:33.841171	\N	4
41	newuser	one	rnewuserone@airecruitment.com	pbkdf2:sha256:260000$PPQf9RT6cHacKlWb$9a70cf404eda93511f3ee30785ca1819891418d1c65d807f7349c763790800ea	2023-10-17 06:28:11.616746	\N	4
42	ss	ss	sstwo@airecruitment.com	pbkdf2:sha256:260000$cj2UvGXI68EoXbdy$347a94ad74c56bb5fd3c06b05aeebec684a4e31320815ec957dcc0065f54b84c	2023-10-17 07:00:39.682522	\N	4
43	dsad	dsada	threedsad@airecruitment.com	pbkdf2:sha256:260000$8VzuQ4OtnZJMVCHQ$8639077c32b950bc9804a5b0b456e33e8daf4750ee880bce00f6ccba490ab632	2023-10-17 07:08:45.255615	\N	4
44	sas	dsds	fourdsd@airecruitment.com	pbkdf2:sha256:260000$jV5KEoz004nkoRui$be1df5f2c1d6a164343d37acdd5bd074b1af70e919ea4e731d8f3edc2420d371	2023-10-17 07:11:03.718688	\N	3
45	five	sasa	fivessd@airecruitment.com	pbkdf2:sha256:260000$EZPDG366RL04Hvnk$57132e9097774e63bcbba0a657559ff5cbff99f0952e588a9928a1c2ca182451	2023-10-17 07:12:35.384132	\N	4
46	six	questioner	sixQuestioner@airecruitment.com	pbkdf2:sha256:260000$Byo4GjCEqgkJb3Fn$ed1ef9b8d4542dd3a598bf66812995608c0452dcc99506adc93293d4c14f57ca	2023-10-17 07:21:13.387342	\N	4
47	seven	qam	sevenQAM@airecruitment.com	pbkdf2:sha256:260000$QurCLB6q9RcAXAww$dbb0420a761c6a819452ad8d4d16bb5a0f75d5b2f800b64e8201ddadb81d5832	2023-10-17 07:28:08.707025	\N	3
48	one	qa	onwQA@dsdsd.dsdsd	pbkdf2:sha256:260000$Qvu3p2pMLPPs7WfX$a9ecfa3599b49aaa77febc44540330161cb1cfc434cb0f37fbb74f81ad20c68b	2023-10-17 07:28:42.551627	\N	2
49	Giridhar	Chandrasekaran	giridhar.chandrasekaran@airecruitment.com	pbkdf2:sha256:260000$BQ92NakeAoKchVXz$2a16356640e2d1d6a47f8ca29551c5cd61fa63937290c798e0c10dd0ff6b2148	2023-10-17 11:06:26.508678	\N	3
50	adsad	eight	eightlkds@airecruitment.com	pbkdf2:sha256:260000$tLqg11IwQpyAq2ud$60a1324d27c47d1d5a2094e7c2fd2aec106ac42963c063312c1d866ad887e8c7	2023-10-17 13:11:56.253168	\N	4
51	Arun	Kumar	arunkumar@airecruitment.com	pbkdf2:sha256:260000$fcaoebUAZUebivKy$7e5892d965cc83684ca9b344844f13408890dcb949fcafcaa817770587ee2482	2023-10-17 13:45:49.23418	\N	4
52	Aruna	Kumari	arunakumari@airecruitment.com	pbkdf2:sha256:260000$6zkyBSqgHf31dJHk$3ed9ac7c2fd1b4d1f601f2280a76987907620a1a036a57279596d11923665f49	2023-10-17 13:49:24.821034	\N	4
53	dsadas	sadad	sadsakjdjsad@ddsamdsk.dsd	pbkdf2:sha256:260000$uJO8iJ4sXbzYonbp$1b63b5a1814b836034fa8c7614a4552bfbc31b1b9651c39904b78528f14e2b78	2023-10-17 14:52:04.082094	\N	3
54	dasdsd	jkkjcnkjxzcn	recruitment_admisadsadsadn@airecruitment.com	pbkdf2:sha256:260000$sdgOjnixzk8xqLPA$0d05328c525cc74eb23356a3dcb2fd7859995e09d800976fdd36cb41c6c9a852	2023-10-17 14:53:03.208988	\N	3
55	namsjdsnacn	nknacnacsk	xaszxzczxcvrecruitment_admin@airecruitment.com	pbkdf2:sha256:260000$ccZYh4ff6plTnVJQ$e826f94b42a54faed0c0f0977d26c659bb1484b382cba6099428b15151a555e7	2023-10-17 14:54:10.038943	\N	3
56	sevenhills	seven	seven@sdsds.rrt	pbkdf2:sha256:260000$VvdnqpoH1MSGQgE7$fe8d8fb58bb551369cf7fe6cde9775bfbc8ce225abb2e4afddef60b01ef6be22	2023-10-17 16:37:17.253649	\N	4
57	dsadasdasd	scsdsf	fsdfd@fsdfds.ffddf	pbkdf2:sha256:260000$kSMxKJ9A0ZpCYdPL$c7a37a24655094effc3176a493e07cc7384f37c47ca6e7a9348eb5bcfeb5fcdf	2023-10-17 16:43:07.645105	\N	4
58	asdsdaf	sadasd	dsadasdsa@dd.dsd	pbkdf2:sha256:260000$VuvdSVt3X9ifOqQV$a477bd3b0d2d20ed1e63325f93a13b3cf8088a8b47cf43652014358f925bfee0	2023-10-17 16:44:35.483825	\N	3
59	adasdasd	dasdasdasd	dadsd@dsdsd.dsdsd	pbkdf2:sha256:260000$CgENFWPdVGTHhuR8$1eed43f1f2a8b5a0ba893d26281bd105cf63f5d80150719b937c4f1f26a14842	2023-10-17 16:54:28.067449	\N	3
60	ssdsadasd	asdasdsad	dasdsad@dasdsd.dasdasd	pbkdf2:sha256:260000$0iJPwnUNRsochTcu$52f81beac2b66e61f7781c85c80e816dbcf8b0fdb96b032f3514466ca080efcd	2023-10-17 16:57:08.099094	\N	4
61	sevendsdas	vxcvretht	fsdavzrth@dsfgdsgsn.dfvc	pbkdf2:sha256:260000$AAILeaPoK8XTBEJw$044d4da89209ff19b248e013394563657fa5470908032875f7cd73f7d363d93d	2023-10-17 17:01:20.748112	\N	4
62	bjkdbcsdn	nsanckjsdvnxc ,mcxn,	fdsdvjhdgjdjkgh@dssdv.cxcxc	pbkdf2:sha256:260000$eYYyZcrGiStxLjq2$0e017bfeeea652e4f5c63fab68c651ba8d790deb0eac23d82c0e322576552422	2023-10-17 17:08:34.145388	\N	4
63	fdsf	dvfer	fregdfshy@fsdfdv.bgb	pbkdf2:sha256:260000$y0awVqy8cYTxW4Ux$ed671797b132ca8480d9b070ecc45ff1e39404f436b0f59583f642e4ac6bc1e0	2023-10-17 17:10:52.247989	\N	4
64	Jack	Reacher	jackreacher@airecruitment.com	pbkdf2:sha256:260000$DNtewR3P5BujM7zZ$6b2f95bc08d4c2a977374bad889f5d21d7de17254601a4538007799e287e72fb	2023-10-17 18:14:48.101073	\N	2
65	dk_testing	Admin	dk_testing@gmail.com	pbkdf2:sha256:260000$SBiKqdNP51kVCFNT$bd17dbb8f44473826d29fbba7ec0bc7a68c22f5ac9495ed3e6ca57c9b324cd01	2023-10-20 15:28:08.193476	\N	2
66	dk	QM	dk_QM@gmail.com	pbkdf2:sha256:260000$PuEjXNfLAAbCj9qK$c671d82cb37c065fea02e143f841aac47c236a4084605bcd1e93c1e0806361db	2023-10-20 15:35:09.380476	\N	3
67	twelve	one	twelve@one.two	pbkdf2:sha256:260000$OKpmGEdf1WHYJydr$a6b8f62e39e610f335a44a5d02301448eedd8bc29063b2e6aeffb3ab590e417b	2023-10-20 16:47:00.273526	\N	3
68	thirteen	one	dsadsd@dsd.ds	pbkdf2:sha256:260000$f6ooPxFeKcjTFJW2$8c251f9113ff9d96f826e820dee142e5964086d1391ffdabf8d8af9496710bb3	2023-10-20 16:49:14.140058	\N	4
69	dk_testing	QM	dk_testing_qm@gmail.com	pbkdf2:sha256:260000$I8BDmHHKsX4o0Rq7$2f4f8ea5a4b76b1f2377d4392f4a85a77132900a60660989d75f7a7580152e3d	2023-10-22 16:40:50.638201	\N	3
70	dk_testing	questioner	dk_testing_ques@gmail.com	pbkdf2:sha256:260000$m49goK8X9ucBhXyi$8327fbf47a1a9c51aaf07c7711afa872ea16a0d4c61b1bfb2b3447f5d23c5f7c	2023-10-22 16:51:02.452699	\N	4
71	dk_testing	QM2	dk_testing_qm2@gmail.com	pbkdf2:sha256:260000$UrmbK4JDdfdVqO6K$14b1b7a7e780e9c3299846994d6174ba46735c29daecc42e0930b12efd16bc76	2023-10-26 10:53:22.626263	\N	3
72	uat_test	Admin	uattestadmin@uat.com	pbkdf2:sha256:260000$ZzVaEKZH47lse1pE$fe50aa95d380118f0c397d2f9a00bc9d31577170eb53d23755c33ea151d68764	2023-10-26 11:14:34.18789	\N	2
73	uatpython	manager	uattestqm@uat.com	pbkdf2:sha256:260000$qtNMOv8x1bltxrYv$77a090e45731a82e5051601098f48cb89d04fb916c9c95c1712e291fcd45670a	2023-10-26 11:17:59.404001	\N	3
74	uatpython	questioner	uattestq@uat.com	pbkdf2:sha256:260000$KQlkMI2oIyccptIK$6b95fe154727045e3d36868fda658968c930e36ddc72a610790d9eee42398251	2023-10-26 11:23:44.860495	\N	4
75	Jack	trader	jacktrader_admin@airecruitment.com	pbkdf2:sha256:260000$0y8d2SWfYZzPdD8r$ccc16f120febb5199859b7c3f73c0f2ebde246e757b663c263fda3be711e6fc2	2023-10-26 12:11:33.96589	\N	3
76	Ideas2IT	Admin	santhini@ideas2it.com	pbkdf2:sha256:260000$4NAtDFU1Ti6jQvz0$eccde8989ffc9225957186a0050976930b036ac625f73d6d087fcf2494cda3cc	2023-10-27 10:37:29.446617	\N	2
77	karthick	R	karthick@ideas2it.com	pbkdf2:sha256:260000$DpbvFKOrQbhshNCb$e37682745fbb6995f32cdcbcca0ae5bef9681ee73a498fb17721dcc2d93b06e2	2023-10-27 10:39:45.769803	\N	2
78	Ideas2it	Admin	ashwitha.ravichandran@ideas2it.com	pbkdf2:sha256:260000$9EPx7qIEBoMa1JSg$e63fa143028cfa06d184756f8f6b7cd5270c48ca8ed1ec6c406d64bc4848d480	2023-11-20 09:33:17.837677	\N	2
79	id2it	Admin	admin@id2it.com	pbkdf2:sha256:260000$6ktqgfZX68KaJJd9$c48a7aba91140d8e8d2b163db7ee0e139e054d0c06494e1eaba246516d4cec62	2023-11-20 10:11:01.172741	\N	2
80	questioner	manager	questioner_manager@airecruitment.com	pbkdf2:sha256:260000$5BBMohEU42lZk2yV$2eb77187b4c4827f216a6ccfb6a1b94f64051e09a0f8b873b78405b03f12898c	2023-11-21 06:50:28.568935	\N	3
85	Giridhar	Chandrasekaran	crcldnangiri@gmail.com	pbkdf2:sha256:260000$sMLqXKs6nkk6jsQJ$40ed26306ac52b17f35500c70b246f0506c1af0584418d05bd66e1e15899b841	2023-11-21 10:46:14.437372	\N	3
86	Giridhar	C	giridhar.chandrasekaran@ideas2it.com	pbkdf2:sha256:260000$h7geer8oToBbweQ3$b5e36eeea1b40d959ab24b1451ca50118d481035070aa21fd4e8fd8b2af02af0	2023-11-21 11:17:06.187052	\N	3
87	Nithin	KA	nithin@ideas2it.com	pbkdf2:sha256:260000$MFIICr2XGwaDN7wx$8cc63840adfa24da61e666449576bb61898c60c5fdc2a7866df257fc949b955f	2023-11-21 11:23:18.819725	\N	3
39	PKP	Admin	karthikeyantest@ideas2it.com	pbkdf2:sha256:260000$x2pRNVpnnrG3PgRi$a302ae7f5b6ab5ab0d1f61a724f47a75aefe8aea33e28c6fbf3f438fc88bdaf2	2023-10-13 06:35:15.023676	\N	2
88	Karthikeyan	P	karthikeyan.p@ideas2it.com	pbkdf2:sha256:260000$4874IMI7rguCUYAk$34e33415a1e5c9c99cb6666d7c2729cb77b62fb41d9c37179ff3b1c32e0c360d	2023-11-21 11:28:43.656921	\N	3
89	Merin	C	merin.kolath@ideas2it.com	pbkdf2:sha256:260000$QUL9MhaZdaUxS1RP$89b1520c283a67220d6602d2095f4eb563af786197f83d3896300eae15ea9747	2023-11-22 10:19:38.183194	\N	2
90	Shrinath	Suresh	shrinath@ideas2it.com	pbkdf2:sha256:260000$YtZJhJXF09EASzPm$f8090ef2753e35f3686ccc83d9ef4236a0f5cc6c8d1733a178599751c5150072	2023-12-01 10:58:58.864607	\N	4
91	Shrinath	Suresh	shrinath1@ideas2it.com	pbkdf2:sha256:260000$8JzO4EA12dAWMYRe$08f6256cccce35e283f0ff31f5b726f9963fb18077d0c5862039bbeacbb96e6e	2023-12-01 10:59:10.686231	\N	4
92	Shrinath	Suresh	shrinath2@ideas2it.com	pbkdf2:sha256:260000$cfhaSbzn5aqur0MI$f35902d6b6ee5611320bacb176afa05e1c4ed195481c4f8aff3a11ae8ee77fc7	2023-12-01 10:59:55.443153	\N	4
93	Shrinath	Suresh	shrinath3@ideas2it.com	pbkdf2:sha256:260000$M7zobskyFfonTGqI$c6e356a563b23b6f0dd9b1e693d12ccb9a700e42fde11cbab0a7a175365593c8	2023-12-01 11:00:42.21992	\N	4
94	test	questioner	uattestq1@uat.com	pbkdf2:sha256:260000$CZ5lqm1eeNNCYOW4$e9b279a3903acff7464b79925109ec48151000fb27e82ca6de20d0b8955e4314	2023-12-02 03:32:59.662559	\N	4
95	uat	quets2	uatquest2@gmail.com	pbkdf2:sha256:260000$phnWx55BLkQfgtK6$f83846b3d481ad19f3e7df044fd23a79e10f547c798e1a0e51af8da624fd1d86	2023-12-02 03:52:22.590559	\N	4
96	uat	quets3	uatquest3@gmail.com	pbkdf2:sha256:260000$pcWZ9Yo51vXrlqLV$11a25955269370b1288db5e43349a8739883872a0f1b1d6fd6e9083dcdfcbd76	2023-12-02 03:54:38.467291	\N	4
97	uat	quets4	uatquest4@gmail.com	pbkdf2:sha256:260000$QHD6i6pw4E3uNWPs$cd55586c7e2538be9af8e8a73df1d51bcf3247a9d5d27ab37b92bc0c2b86c63c	2023-12-02 03:56:40.020706	\N	4
98	uat	quets5	uatquest5@gmail.com	pbkdf2:sha256:260000$H0gA5yIdcFh5OkXe$308ffc2698972fcbac52e9fc3602bd2c2e6870d99dcd6fc06238c030c16d2f2f	2023-12-02 04:00:16.26869	\N	4
99	uat	quets6	uatquest6@gmail.com	pbkdf2:sha256:260000$7Mf29b4jy4M9U3zP$6186d216ae8a205b356d51a648c57e3c5faaabba609d0aa69c619b51d023978f	2023-12-02 04:02:19.561686	\N	4
100	uat	quets7	uatquest7@gmail.com	pbkdf2:sha256:260000$JXMQZztXOsB7Ru2m$2088d9e216f342ef25dad4dfca8bafdd5783d20e096e0c7f88c28262505cf21a	2023-12-02 04:04:04.785713	\N	4
\.


--
-- Data for Name: user_designation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_designation (user_id, dsg_id, last_updated) FROM stdin;
9	5	2023-10-11 09:43:11.835207
35	8	2023-10-11 14:24:35.505393
38	9	2023-10-11 14:24:56.725432
49	34	2023-10-17 11:06:27.24009
52	34	2023-10-17 13:49:25.451551
64	1	2023-10-17 18:14:48.848006
48	8	2023-10-20 07:00:00.792558
4	8	2023-10-20 08:29:09.110968
67	9	2023-10-20 16:47:00.711797
68	9	2023-10-20 16:49:14.657824
71	5	2023-10-26 10:54:53.369605
69	5	2023-10-26 10:55:53.169708
73	1	2023-10-26 11:17:59.74575
74	1	2023-10-26 11:23:45.28162
75	1	2023-10-26 12:11:34.461767
70	5	2023-10-27 06:41:57.337487
77	38	2023-10-27 10:39:46.11939
80	1	2023-11-21 06:50:28.940467
86	1	2023-11-21 11:17:07.539463
87	1	2023-11-21 11:23:20.12815
88	21	2023-11-21 11:28:44.929111
89	40	2023-11-22 10:19:39.625986
90	21	2023-12-01 11:02:35.544441
\.


--
-- Name: designation_dsg_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.designation_dsg_id_seq', 41, true);


--
-- Name: domain_d_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.domain_d_id_seq', 80, true);


--
-- Name: industry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.industry_id_seq', 2, true);


--
-- Name: page_component_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.page_component_id_seq', 8, true);


--
-- Name: permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permission_id_seq', 40, true);


--
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.role_id_seq', 4, true);


--
-- Name: sub_domain_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sub_domain_id_seq', 68, true);


--
-- Name: user_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_user_id_seq', 100, true);


--
-- Name: evaluations c_id_q_id_interview_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluations
    ADD CONSTRAINT c_id_q_id_interview_id PRIMARY KEY (c_id, q_id, interview_id);


--
-- Name: candidates candidates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.candidates
    ADD CONSTRAINT candidates_pkey PRIMARY KEY (c_id);


--
-- Name: configurations config_name_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.configurations
    ADD CONSTRAINT config_name_unique UNIQUE (config_name);


--
-- Name: configurations configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.configurations
    ADD CONSTRAINT configurations_pkey PRIMARY KEY (config_name, config_value);


--
-- Name: designation designation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.designation
    ADD CONSTRAINT designation_pkey PRIMARY KEY (dsg_id);


--
-- Name: domain domain_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.domain
    ADD CONSTRAINT domain_pkey PRIMARY KEY (d_id);


--
-- Name: industry industry_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.industry
    ADD CONSTRAINT industry_pkey PRIMARY KEY (id);


--
-- Name: interview interview_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interview
    ADD CONSTRAINT interview_pkey PRIMARY KEY (i_id);


--
-- Name: page_component page_component_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.page_component
    ADD CONSTRAINT page_component_pkey PRIMARY KEY (id);


--
-- Name: permission permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permission
    ADD CONSTRAINT permission_pkey PRIMARY KEY (id);


--
-- Name: question_bank question_bank_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_bank
    ADD CONSTRAINT question_bank_pkey PRIMARY KEY (question_id);


--
-- Name: role role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);


--
-- Name: sub_domain sub_domain_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sub_domain
    ADD CONSTRAINT sub_domain_pkey PRIMARY KEY (id);


--
-- Name: tenant tenant_id_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tenant
    ADD CONSTRAINT tenant_id_pkey PRIMARY KEY (tenant_id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (user_id);


--
-- Name: candidate_domain candidate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.candidate_domain
    ADD CONSTRAINT candidate_id_fkey FOREIGN KEY (candidate_id) REFERENCES public.candidates(c_id);


--
-- Name: interview candidate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interview
    ADD CONSTRAINT candidate_id_fkey FOREIGN KEY (c_id) REFERENCES public.candidates(c_id);


--
-- Name: tenant_user ctenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tenant_user
    ADD CONSTRAINT ctenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenant(tenant_id);


--
-- Name: domain_designation d_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.domain_designation
    ADD CONSTRAINT d_id FOREIGN KEY (d_id) REFERENCES public.domain(d_id);


--
-- Name: tenant_designation designation_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tenant_designation
    ADD CONSTRAINT designation_id FOREIGN KEY (designation_id) REFERENCES public.designation(dsg_id);


--
-- Name: candidate_domain domain_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.candidate_domain
    ADD CONSTRAINT domain_id FOREIGN KEY (domain_id) REFERENCES public.domain(d_id);


--
-- Name: user_designation dsg_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_designation
    ADD CONSTRAINT dsg_id FOREIGN KEY (dsg_id) REFERENCES public.designation(dsg_id);


--
-- Name: domain_designation dsg_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.domain_designation
    ADD CONSTRAINT dsg_id FOREIGN KEY (dsg_id) REFERENCES public.designation(dsg_id);


--
-- Name: candidates fk_deg_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.candidates
    ADD CONSTRAINT fk_deg_id FOREIGN KEY (dsg_id) REFERENCES public.designation(dsg_id);


--
-- Name: sub_domain fk_domain; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sub_domain
    ADD CONSTRAINT fk_domain FOREIGN KEY (domain_id) REFERENCES public.domain(d_id);


--
-- Name: designation fk_industry; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.designation
    ADD CONSTRAINT fk_industry FOREIGN KEY (industry_id) REFERENCES public.industry(id);


--
-- Name: question_bank fk_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_bank
    ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES public."user"(user_id);


--
-- Name: interview fkey_dsg_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interview
    ADD CONSTRAINT fkey_dsg_id FOREIGN KEY (dsg_id) REFERENCES public.designation(dsg_id);


--
-- Name: configurations fkey_tenant_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.configurations
    ADD CONSTRAINT fkey_tenant_id FOREIGN KEY (tenant_id) REFERENCES public.tenant(tenant_id);


--
-- Name: designation fkey_tenant_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.designation
    ADD CONSTRAINT fkey_tenant_id FOREIGN KEY (tenant_id) REFERENCES public.tenant(tenant_id) NOT VALID;


--
-- Name: role_page_component page_component_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_page_component
    ADD CONSTRAINT page_component_id FOREIGN KEY (page_component_id) REFERENCES public.page_component(id);


--
-- Name: role_permission permission_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permission
    ADD CONSTRAINT permission_id FOREIGN KEY (permission_id) REFERENCES public.permission(id);


--
-- Name: role_permission role_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permission
    ADD CONSTRAINT role_id FOREIGN KEY (role_id) REFERENCES public.role(id);


--
-- Name: user role_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT role_id FOREIGN KEY (role_id) REFERENCES public.role(id);


--
-- Name: role_page_component role_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_page_component
    ADD CONSTRAINT role_id FOREIGN KEY (role_id) REFERENCES public.role(id);


--
-- Name: tenant_designation tenant_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tenant_designation
    ADD CONSTRAINT tenant_id FOREIGN KEY (tenant_id) REFERENCES public.tenant(tenant_id);


--
-- Name: user_designation user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_designation
    ADD CONSTRAINT user_id FOREIGN KEY (user_id) REFERENCES public."user"(user_id);


--
-- Name: tenant_user user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tenant_user
    ADD CONSTRAINT user_id FOREIGN KEY (user_id) REFERENCES public."user"(user_id);


--
-- Name: interview user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interview
    ADD CONSTRAINT user_id_fkey FOREIGN KEY (created_by) REFERENCES public."user"(user_id) NOT VALID;


--
-- PostgreSQL database dump complete
--

