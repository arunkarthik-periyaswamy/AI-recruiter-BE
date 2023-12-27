
CREATE TABLE IF NOT EXISTS public."user"
(
    user_id integer NOT NULL,
    first_name text COLLATE pg_catalog."default",
    last_name text COLLATE pg_catalog."default",
    email text COLLATE pg_catalog."default",
    password text COLLATE pg_catalog."default",
    last_updated timestamp without time zone,
    jwt_token text COLLATE pg_catalog."default",
    CONSTRAINT user_pkey PRIMARY KEY (user_id)
);


CREATE TABLE IF NOT EXISTS public.designation
(
    dsg_id integer NOT NULL,
    name text COLLATE pg_catalog."default",
    last_updated timestamp without time zone,
    CONSTRAINT designation_pkey PRIMARY KEY (dsg_id)
);


CREATE TABLE IF NOT EXISTS public.domain
(
    d_id integer NOT NULL,
    name text COLLATE pg_catalog."default",
    sub_domain json,
    last_updated timestamp without time zone,
    CONSTRAINT domain_pkey PRIMARY KEY (d_id)
);

CREATE TABLE IF NOT EXISTS public.candidates
(
    c_id uuid NOT NULL,
    email text COLLATE pg_catalog."default" NOT NULL,
    phone_number bigint,
    valid_id text COLLATE pg_catalog."default",
    dsg_id integer NOT NULL,
    last_updated timestamp without time zone,
    expected_ctc double precision,
    years_of_experience double precision,
    c_name text COLLATE pg_catalog."default",
    password text COLLATE pg_catalog."default",
    CONSTRAINT candidates_pkey PRIMARY KEY (c_id),
    CONSTRAINT fk_deg_id FOREIGN KEY (dsg_id)
        REFERENCES public.designation (dsg_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS public.candidate_domain
(
    candidate_id uuid,
    domain_id integer,
    last_updated timestamp without time zone,
    CONSTRAINT candidate_id_fkey FOREIGN KEY (candidate_id)
        REFERENCES public.candidates (c_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT domain_id FOREIGN KEY (domain_id)
        REFERENCES public.domain (d_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);


CREATE TABLE IF NOT EXISTS public.question_bank
(
    question_id uuid NOT NULL,
    question text COLLATE pg_catalog."default",
    question_type text COLLATE pg_catalog."default",
    designation text COLLATE pg_catalog."default",
    answer_type text COLLATE pg_catalog."default",
    ai_answer text COLLATE pg_catalog."default",
    domain text COLLATE pg_catalog."default",
    sub_domain text COLLATE pg_catalog."default",
    max_answering_time smallint,
    preparation_time smallint,
    code_required boolean,
    difficulty_index smallint,
    clues text COLLATE pg_catalog."default",
    url text COLLATE pg_catalog."default",
    flagged boolean,
    user_id integer,
    last_updated timestamp without time zone,
    flag_expectation text COLLATE pg_catalog."default",
    CONSTRAINT question_bank_pkey PRIMARY KEY (question_id),
    CONSTRAINT fk_user_id FOREIGN KEY (user_id)
        REFERENCES public."user" (user_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

CREATE TABLE IF NOT EXISTS public.interview
(
    i_id uuid NOT NULL,
    c_id uuid NOT NULL,
    dsg_id integer NOT NULL,
    no_of_questions integer,
    status text COLLATE pg_catalog."default",
    evaluation_status text COLLATE pg_catalog."default",
    last_updated timestamp without time zone,
    date_of_interview timestamp with time zone,
    eval_status_code integer,
    created_by integer,
    CONSTRAINT interview_pkey PRIMARY KEY (i_id),
    CONSTRAINT candidate_id_fkey FOREIGN KEY (c_id)
        REFERENCES public.candidates (c_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fkey_dsg_id FOREIGN KEY (dsg_id)
        REFERENCES public.designation (dsg_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT user_id_fkey FOREIGN KEY (created_by)
        REFERENCES public."user" (user_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);


CREATE TABLE IF NOT EXISTS public.evaluations
(
    c_id uuid NOT NULL,
    q_id uuid NOT NULL,
    ai_answer text COLLATE pg_catalog."default",
    candidate_answer text COLLATE pg_catalog."default",
    score numeric,
    last_updated timestamp without time zone,
    is_clue_used boolean,
    is_flagged boolean,
    time_taken integer,
    interview_id uuid NOT NULL,
    question_number integer,
    CONSTRAINT c_id_q_id_interview_id PRIMARY KEY (c_id, q_id, interview_id)
);


CREATE SEQUENCE IF NOT EXISTS public.user_user_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1
    OWNED BY public."user".user_id;

ALTER TABLE public."user" ALTER COLUMN user_id SET DEFAULT nextval('user_user_id_seq');


CREATE SEQUENCE IF NOT EXISTS public.designation_dsg_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1
    OWNED BY designation.dsg_id;

ALTER TABLE designation ALTER COLUMN dsg_id SET DEFAULT nextval('designation_dsg_id_seq');


CREATE SEQUENCE IF NOT EXISTS public.domain_d_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1
    OWNED BY domain.d_id;

ALTER TABLE domain ALTER COLUMN d_id SET DEFAULT nextval('domain_d_id_seq');


-- Table: public.configurations

-- DROP TABLE IF EXISTS public.configurations;

CREATE TABLE IF NOT EXISTS public.configurations
(
    config_name text COLLATE pg_catalog."default" NOT NULL,
    config_value text COLLATE pg_catalog."default" NOT NULL,
    last_updated timestamp without time zone,
    CONSTRAINT configurations_pkey PRIMARY KEY (config_name, config_value),
    CONSTRAINT config_name_unique UNIQUE (config_name)
)


-- Table: public.roles

-- DROP TABLE IF EXISTS public.roles;

CREATE TABLE IF NOT EXISTS public.roles
(
    r_id integer NOT NULL,
    name text COLLATE pg_catalog."default",
    last_updated timestamp without time zone,
    CONSTRAINT roles_pkey PRIMARY KEY (r_id)
);

-- SEQUENCE: public.roles_r_id_seq

-- DROP SEQUENCE IF EXISTS public.roles_r_id_seq;

CREATE SEQUENCE IF NOT EXISTS public.roles_r_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1
    OWNED BY roles.r_id;

ALTER TABLE roles ALTER COLUMN r_id SET DEFAULT nextval('roles_r_id_seq');



-- Table: public.user_designation

-- DROP TABLE IF EXISTS public.user_designation;

CREATE TABLE IF NOT EXISTS public.user_designation
(
    user_id integer, 
    dsg_id integer,
    last_updated timestamp without time zone,
    CONSTRAINT dsg_id FOREIGN KEY (dsg_id)
        REFERENCES public.designation (dsg_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT user_id FOREIGN KEY (user_id)
        REFERENCES public.user (user_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);


-- Table: public.permission

-- DROP TABLE IF EXISTS public.permission;

CREATE TABLE IF NOT EXISTS public.permission
(
    p_id integer NOT NULL,evaluations
    name text COLLATE pg_catalog."default",
    CONSTRAINT permission_pkey PRIMARY KEY (p_id)
);

-- SEQUENCE: public.permission_p_id_seq

-- DROP SEQUENCE IF EXISTS public.permission_p_id_seq;

CREATE SEQUENCE IF NOT EXISTS public.permission_p_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1
    OWNED BY permission.p_id;

ALTER TABLE permission ALTER COLUMN p_id SET DEFAULT nextval('permission_p_id_seq');



-- Table: public.domain_designation

-- DROP TABLE IF EXISTS public.domain_designation;

CREATE TABLE IF NOT EXISTS public.domain_designation
(
    d_id integer, 
    dsg_id integer,
    last_updated timestamp without time zone,
    CONSTRAINT dsg_id FOREIGN KEY (dsg_id)
        REFERENCES public.designation (dsg_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT d_id FOREIGN KEY (d_id)
        REFERENCES public.domain (d_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);


CREATE TABLE IF NOT EXISTS public.tenant
(
    tenant_id uuid NOT NULL,
    name text NOT NULL,
    created_at timestamp without time zone,
    last_updated timestamp without time zone,
    
    CONSTRAINT tenant_id_pkey PRIMARY KEY (tenant_id),
);

CREATE TABLE IF NOT EXISTS public.tenant_user
(
    tenant_id uuid,
    user_id integer,
    last_updated timestamp without time zone,
    CONSTRAINT ctenant_id_fkey FOREIGN KEY (tenant_id)
        REFERENCES public.tenant (tenant_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT user_id FOREIGN KEY (user_id)
        REFERENCES public.user (user_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS public.sub_domain
(
    id SERIAL ,
    name text NOT NULL,
    domain_id integer NOT NULL,
    created_by integer,
    updated_by integer,
    created_at timestamp without time zone,
    last_updated timestamp without time zone,
    PRIMARY KEY (id),
    CONSTRAINT fk_domain FOREIGN KEY (domain_id)
        REFERENCES public.domain (d_id)
);

CREATE TABLE IF NOT EXISTS public.industry
(
    id SERIAL,
    name text NOT NULL,
    created_by integer,
    updated_by integer,
    created_at timestamp without time zone,
    last_updated timestamp without time zone,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.role
(
    id SERIAL,
    name text NOT NULL,
    created_by integer,
    updated_by integer,
    created_at timestamp without time zone,
    last_updated timestamp without time zone,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.permission
(
    id SERIAL,
    name text NOT NULL,
    path_url text NOT NULL,
    created_by integer,
    updated_by integer,
    created_at timestamp without time zone,
    last_updated timestamp without time zone,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.role_permission
(
    role_id integer,
    permission_id integer,
    last_updated timestamp without time zone,
    CONSTRAINT role_id FOREIGN KEY (role_id)
        REFERENCES public.role (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT permission_id FOREIGN KEY (permission_id)
        REFERENCES public.permission (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

ALTER TABLE IF EXISTS public.user ADD COLUMN role_id integer,
 ADD CONSTRAINT role_id FOREIGN KEY (role_id)
    REFERENCES public.role (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

CREATE TABLE IF NOT EXISTS public.page_component
(
    id SERIAL,
    name text NOT NULL,
    created_by integer,
    updated_by integer,
    created_at timestamp without time zone,
    last_updated timestamp without time zone,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.role_page_component
(
    role_id integer,
    page_component_id integer,
    last_updated timestamp without time zone,
    CONSTRAINT role_id FOREIGN KEY (role_id)
        REFERENCES public.role (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT page_component_id FOREIGN KEY (page_component_id)
        REFERENCES public.page_component (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
