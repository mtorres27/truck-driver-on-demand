SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
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


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: admins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE admins (
    id bigint NOT NULL,
    token character varying,
    email character varying NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admins_id_seq OWNED BY admins.id;


--
-- Name: applicants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE applicants (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    freelancer_id bigint NOT NULL,
    state character varying DEFAULT 'interested'::character varying NOT NULL,
    quotes_count integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: applicants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE applicants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: applicants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE applicants_id_seq OWNED BY applicants.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: change_orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE change_orders (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    amount numeric(10,2) NOT NULL,
    body text NOT NULL,
    attachment_data text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: change_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE change_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: change_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE change_orders_id_seq OWNED BY change_orders.id;


--
-- Name: companies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE companies (
    id bigint NOT NULL,
    token character varying,
    email character varying NOT NULL,
    name character varying NOT NULL,
    contact_name character varying NOT NULL,
    currency character varying DEFAULT 'CAD'::character varying NOT NULL,
    address character varying,
    formatted_address character varying,
    area character varying,
    lat numeric(9,6),
    lng numeric(9,6),
    hq_country character varying,
    description character varying,
    avatar_data text,
    disabled boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE companies_id_seq OWNED BY companies.id;


--
-- Name: freelancers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE freelancers (
    id bigint NOT NULL,
    token character varying,
    email character varying NOT NULL,
    name character varying NOT NULL,
    avatar_data text,
    address character varying,
    formatted_address character varying,
    area character varying,
    lat numeric(9,6),
    lng numeric(9,6),
    pay_unit_time_preference character varying,
    pay_per_unit_time integer,
    tagline character varying,
    bio text,
    keywords character varying,
    years_of_experience integer DEFAULT 0 NOT NULL,
    profile_views integer DEFAULT 0 NOT NULL,
    projects_completed integer DEFAULT 0 NOT NULL,
    available boolean DEFAULT true NOT NULL,
    disabled boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: freelancers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE freelancers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: freelancers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE freelancers_id_seq OWNED BY freelancers.id;


--
-- Name: identities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE identities (
    id bigint NOT NULL,
    loginable_type character varying,
    loginable_id bigint NOT NULL,
    provider character varying NOT NULL,
    uid character varying NOT NULL,
    last_sign_in_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: identities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE identities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: identities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE identities_id_seq OWNED BY identities.id;


--
-- Name: jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE jobs (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    title character varying NOT NULL,
    state character varying DEFAULT 'created'::character varying NOT NULL,
    summary text NOT NULL,
    scope_of_work text,
    budget numeric(10,2) NOT NULL,
    job_function character varying NOT NULL,
    starts_on date NOT NULL,
    ends_on date,
    duration integer NOT NULL,
    pay_type character varying,
    freelancer_type character varying NOT NULL,
    keywords text,
    invite_only boolean DEFAULT false NOT NULL,
    scope_is_public boolean DEFAULT true NOT NULL,
    budget_is_public boolean DEFAULT true NOT NULL,
    working_days text[] DEFAULT '{}'::text[] NOT NULL,
    working_time character varying,
    contract_price numeric(10,2),
    payment_schedule jsonb DEFAULT '"{}"'::jsonb NOT NULL,
    reporting_frequency character varying,
    require_photos_on_updates boolean DEFAULT false NOT NULL,
    require_checkin boolean DEFAULT false NOT NULL,
    require_uniform boolean DEFAULT false NOT NULL,
    addendums text,
    applicants_count integer DEFAULT 0 NOT NULL,
    messages_count integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE jobs_id_seq OWNED BY jobs.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE messages (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    authorable_type character varying,
    authorable_id bigint NOT NULL,
    body text,
    attachment_data text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE messages_id_seq OWNED BY messages.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE payments (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    description character varying NOT NULL,
    amount numeric(10,2) NOT NULL,
    issued_on date,
    paid_on date,
    attachment_data text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE payments_id_seq OWNED BY payments.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE projects (
    id bigint NOT NULL,
    company_id bigint NOT NULL,
    external_project_id character varying,
    name character varying NOT NULL,
    budget numeric(10,2) NOT NULL,
    starts_on date,
    duration integer,
    address character varying NOT NULL,
    formatted_address character varying,
    area character varying,
    lat numeric(9,6),
    lng numeric(9,6),
    closed boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE projects_id_seq OWNED BY projects.id;


--
-- Name: quotes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE quotes (
    id bigint NOT NULL,
    applicant_id bigint NOT NULL,
    amount numeric(10,2) NOT NULL,
    pay_type character varying DEFAULT 'fixed'::character varying NOT NULL,
    rejected boolean DEFAULT false NOT NULL,
    body text,
    attachment_data text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: quotes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE quotes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quotes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE quotes_id_seq OWNED BY quotes.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: admins id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admins ALTER COLUMN id SET DEFAULT nextval('admins_id_seq'::regclass);


--
-- Name: applicants id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY applicants ALTER COLUMN id SET DEFAULT nextval('applicants_id_seq'::regclass);


--
-- Name: change_orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY change_orders ALTER COLUMN id SET DEFAULT nextval('change_orders_id_seq'::regclass);


--
-- Name: companies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY companies ALTER COLUMN id SET DEFAULT nextval('companies_id_seq'::regclass);


--
-- Name: freelancers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY freelancers ALTER COLUMN id SET DEFAULT nextval('freelancers_id_seq'::regclass);


--
-- Name: identities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY identities ALTER COLUMN id SET DEFAULT nextval('identities_id_seq'::regclass);


--
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY jobs ALTER COLUMN id SET DEFAULT nextval('jobs_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY messages ALTER COLUMN id SET DEFAULT nextval('messages_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY payments ALTER COLUMN id SET DEFAULT nextval('payments_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects ALTER COLUMN id SET DEFAULT nextval('projects_id_seq'::regclass);


--
-- Name: quotes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY quotes ALTER COLUMN id SET DEFAULT nextval('quotes_id_seq'::regclass);


--
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: applicants applicants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY applicants
    ADD CONSTRAINT applicants_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: change_orders change_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY change_orders
    ADD CONSTRAINT change_orders_pkey PRIMARY KEY (id);


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: freelancers freelancers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY freelancers
    ADD CONSTRAINT freelancers_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: quotes quotes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY quotes
    ADD CONSTRAINT quotes_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: index_admins_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_admins_on_email ON admins USING btree (email);


--
-- Name: index_applicants_on_freelancer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_applicants_on_freelancer_id ON applicants USING btree (freelancer_id);


--
-- Name: index_applicants_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_applicants_on_job_id ON applicants USING btree (job_id);


--
-- Name: index_change_orders_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_change_orders_on_job_id ON change_orders USING btree (job_id);


--
-- Name: index_companies_on_disabled; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_disabled ON companies USING btree (disabled);


--
-- Name: index_companies_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_email ON companies USING btree (email);


--
-- Name: index_companies_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_name ON companies USING btree (name);


--
-- Name: index_freelancers_on_area; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_freelancers_on_area ON freelancers USING btree (area);


--
-- Name: index_freelancers_on_available; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_freelancers_on_available ON freelancers USING btree (available);


--
-- Name: index_freelancers_on_disabled; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_freelancers_on_disabled ON freelancers USING btree (disabled);


--
-- Name: index_freelancers_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_freelancers_on_email ON freelancers USING btree (email);


--
-- Name: index_freelancers_on_keywords; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_freelancers_on_keywords ON freelancers USING btree (keywords);


--
-- Name: index_freelancers_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_freelancers_on_name ON freelancers USING btree (name);


--
-- Name: index_identities_on_loginable_type_and_loginable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_identities_on_loginable_type_and_loginable_id ON identities USING btree (loginable_type, loginable_id);


--
-- Name: index_identities_on_loginable_type_and_provider_and_uid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_identities_on_loginable_type_and_provider_and_uid ON identities USING btree (loginable_type, provider, uid);


--
-- Name: index_jobs_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_project_id ON jobs USING btree (project_id);


--
-- Name: index_messages_on_authorable_type_and_authorable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_messages_on_authorable_type_and_authorable_id ON messages USING btree (authorable_type, authorable_id);


--
-- Name: index_messages_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_messages_on_job_id ON messages USING btree (job_id);


--
-- Name: index_on_companies_loc; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_on_companies_loc ON companies USING gist (st_geographyfromtext((((('SRID=4326;POINT('::text || lng) || ' '::text) || lat) || ')'::text)));


--
-- Name: index_on_freelancers_loc; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_on_freelancers_loc ON freelancers USING gist (st_geographyfromtext((((('SRID=4326;POINT('::text || lng) || ' '::text) || lat) || ')'::text)));


--
-- Name: index_on_projects_loc; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_on_projects_loc ON projects USING gist (st_geographyfromtext((((('SRID=4326;POINT('::text || lng) || ' '::text) || lat) || ')'::text)));


--
-- Name: index_payments_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payments_on_job_id ON payments USING btree (job_id);


--
-- Name: index_projects_on_area; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_area ON projects USING btree (area);


--
-- Name: index_projects_on_budget; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_budget ON projects USING btree (budget);


--
-- Name: index_projects_on_closed; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_closed ON projects USING btree (closed);


--
-- Name: index_projects_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_company_id ON projects USING btree (company_id);


--
-- Name: index_projects_on_external_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_external_project_id ON projects USING btree (external_project_id);


--
-- Name: index_projects_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_name ON projects USING btree (name);


--
-- Name: index_projects_on_starts_on; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_starts_on ON projects USING btree (starts_on);


--
-- Name: index_quotes_on_applicant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_quotes_on_applicant_id ON quotes USING btree (applicant_id);


--
-- Name: jobs fk_rails_1977e8b5a6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY jobs
    ADD CONSTRAINT fk_rails_1977e8b5a6 FOREIGN KEY (project_id) REFERENCES projects(id);


--
-- Name: applicants fk_rails_32d387f70d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY applicants
    ADD CONSTRAINT fk_rails_32d387f70d FOREIGN KEY (job_id) REFERENCES jobs(id);


--
-- Name: projects fk_rails_44a549d7b3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT fk_rails_44a549d7b3 FOREIGN KEY (company_id) REFERENCES companies(id);


--
-- Name: applicants fk_rails_4b7bc91392; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY applicants
    ADD CONSTRAINT fk_rails_4b7bc91392 FOREIGN KEY (freelancer_id) REFERENCES freelancers(id);


--
-- Name: payments fk_rails_b35f361f8d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY payments
    ADD CONSTRAINT fk_rails_b35f361f8d FOREIGN KEY (job_id) REFERENCES jobs(id);


--
-- Name: quotes fk_rails_b73354eeb5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY quotes
    ADD CONSTRAINT fk_rails_b73354eeb5 FOREIGN KEY (applicant_id) REFERENCES applicants(id);


--
-- Name: change_orders fk_rails_cab1ecc845; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY change_orders
    ADD CONSTRAINT fk_rails_cab1ecc845 FOREIGN KEY (job_id) REFERENCES jobs(id);


--
-- Name: messages fk_rails_d7e012c0bb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT fk_rails_d7e012c0bb FOREIGN KEY (job_id) REFERENCES jobs(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20170414003540'),
('20170420140235'),
('20170420191758'),
('20170420191768'),
('20170421204647'),
('20170421205768'),
('20170422123135'),
('20170427143209'),
('20170427182445'),
('20170428154417'),
('20170505140409'),
('20170505140847'),
('20170509175102'),
('20170510154135'),
('20170515191347');


