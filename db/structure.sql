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


--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: applicants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.applicants (
    id bigint NOT NULL,
    company_id bigint NOT NULL,
    job_id bigint NOT NULL,
    freelancer_id bigint NOT NULL,
    state character varying DEFAULT 'quoting'::character varying NOT NULL,
    quotes_count integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    messages_count integer DEFAULT 0 NOT NULL
);


--
-- Name: applicants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.applicants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: applicants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.applicants_id_seq OWNED BY public.applicants.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.attachments (
    id bigint NOT NULL,
    file_data character varying,
    job_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    title character varying
);


--
-- Name: attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.attachments_id_seq OWNED BY public.attachments.id;


--
-- Name: audits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audits (
    id bigint NOT NULL,
    auditable_id integer,
    auditable_type character varying,
    associated_id integer,
    associated_type character varying,
    user_id integer,
    user_type character varying,
    username character varying,
    action character varying,
    audited_changes jsonb,
    version integer DEFAULT 0,
    comment character varying,
    remote_address character varying,
    request_uuid character varying,
    created_at timestamp without time zone
);


--
-- Name: audits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.audits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.audits_id_seq OWNED BY public.audits.id;


--
-- Name: certifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.certifications (
    id bigint NOT NULL,
    freelancer_id integer,
    certificate text,
    name text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    thumbnail text,
    certificate_data text,
    cert_type character varying
);


--
-- Name: certifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.certifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: certifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.certifications_id_seq OWNED BY public.certifications.id;


--
-- Name: change_orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.change_orders (
    id bigint NOT NULL,
    company_id bigint NOT NULL,
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

CREATE SEQUENCE public.change_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: change_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.change_orders_id_seq OWNED BY public.change_orders.id;


--
-- Name: companies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.companies (
    id bigint NOT NULL,
    token character varying,
    name character varying,
    address character varying,
    formatted_address character varying,
    area character varying,
    lat numeric(9,6),
    lng numeric(9,6),
    hq_country character varying,
    description character varying,
    avatar_data text,
    disabled boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    messages_count integer DEFAULT 0 NOT NULL,
    company_reviews_count integer DEFAULT 0 NOT NULL,
    profile_header_data text,
    contract_preference character varying DEFAULT 'no_preference'::character varying,
    job_markets public.citext,
    technical_skill_tags public.citext,
    profile_views integer DEFAULT 0 NOT NULL,
    website character varying,
    phone_number character varying,
    number_of_offices integer DEFAULT 0,
    number_of_employees character varying,
    established_in integer,
    header_color character varying DEFAULT 'FF6C38'::character varying,
    country character varying,
    header_source character varying DEFAULT 'default'::character varying,
    sales_tax_number character varying,
    line2 character varying,
    city character varying,
    state character varying,
    postal_code character varying,
    job_types public.citext,
    manufacturer_tags public.citext,
    registration_step character varying,
    saved_freelancers_ids public.citext
);


--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.companies_id_seq OWNED BY public.companies.id;


--
-- Name: company_favourites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.company_favourites (
    id bigint NOT NULL,
    freelancer_id integer,
    company_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: company_favourites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.company_favourites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_favourites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.company_favourites_id_seq OWNED BY public.company_favourites.id;


--
-- Name: company_installs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.company_installs (
    id bigint NOT NULL,
    company_id integer,
    year integer,
    installs integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: company_installs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.company_installs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_installs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.company_installs_id_seq OWNED BY public.company_installs.id;


--
-- Name: company_reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.company_reviews (
    id bigint NOT NULL,
    company_id bigint,
    freelancer_id bigint,
    job_id bigint,
    quality_of_information_provided integer NOT NULL,
    communication integer NOT NULL,
    materials_available_onsite integer NOT NULL,
    promptness_of_payment integer NOT NULL,
    overall_experience integer NOT NULL,
    comments text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: company_reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.company_reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.company_reviews_id_seq OWNED BY public.company_reviews.id;


--
-- Name: currency_rates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.currency_rates (
    id bigint NOT NULL,
    currency character varying,
    country character varying,
    rate numeric(10,2) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: currency_rates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.currency_rates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: currency_rates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.currency_rates_id_seq OWNED BY public.currency_rates.id;


--
-- Name: favourites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.favourites (
    id bigint NOT NULL,
    freelancer_id integer,
    company_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: favourites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.favourites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: favourites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.favourites_id_seq OWNED BY public.favourites.id;


--
-- Name: featured_projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.featured_projects (
    id bigint NOT NULL,
    company_id integer,
    name character varying,
    file character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    file_data character varying
);


--
-- Name: featured_projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.featured_projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: featured_projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.featured_projects_id_seq OWNED BY public.featured_projects.id;


--
-- Name: freelancer_affiliations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.freelancer_affiliations (
    id bigint NOT NULL,
    name character varying,
    image character varying,
    freelancer_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    image_data text
);


--
-- Name: freelancer_affiliations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.freelancer_affiliations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: freelancer_affiliations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.freelancer_affiliations_id_seq OWNED BY public.freelancer_affiliations.id;


--
-- Name: freelancer_clearances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.freelancer_clearances (
    id bigint NOT NULL,
    description text,
    image character varying,
    image_data text,
    freelancer_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: freelancer_clearances_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.freelancer_clearances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: freelancer_clearances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.freelancer_clearances_id_seq OWNED BY public.freelancer_clearances.id;


--
-- Name: freelancer_insurances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.freelancer_insurances (
    id bigint NOT NULL,
    name character varying,
    description text,
    freelancer_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    image character varying,
    image_data text
);


--
-- Name: freelancer_insurances_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.freelancer_insurances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: freelancer_insurances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.freelancer_insurances_id_seq OWNED BY public.freelancer_insurances.id;


--
-- Name: freelancer_portfolios; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.freelancer_portfolios (
    id bigint NOT NULL,
    name text,
    image character varying,
    image_data text,
    freelancer_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: freelancer_portfolios_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.freelancer_portfolios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: freelancer_portfolios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.freelancer_portfolios_id_seq OWNED BY public.freelancer_portfolios.id;


--
-- Name: freelancer_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.freelancer_profiles (
    id bigint NOT NULL,
    token character varying,
    avatar_data text,
    address character varying,
    formatted_address character varying,
    area character varying,
    lat numeric(9,6),
    lng numeric(9,6),
    pay_unit_time_preference character varying,
    pay_per_unit_time character varying,
    tagline character varying,
    bio text,
    job_markets public.citext,
    years_of_experience integer DEFAULT 0 NOT NULL,
    profile_views integer DEFAULT 0 NOT NULL,
    projects_completed integer DEFAULT 0 NOT NULL,
    available boolean DEFAULT true NOT NULL,
    disabled boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    freelancer_reviews_count integer DEFAULT 0 NOT NULL,
    technical_skill_tags public.citext,
    profile_header_data text,
    verified boolean DEFAULT false,
    header_color character varying DEFAULT 'FF6C38'::character varying,
    country character varying,
    freelancer_team_size character varying,
    freelancer_type character varying,
    header_source character varying DEFAULT 'default'::character varying,
    stripe_account_id character varying,
    stripe_account_status text,
    currency character varying,
    sales_tax_number character varying,
    line2 character varying,
    state character varying,
    postal_code character varying,
    service_areas character varying,
    city character varying,
    phone_number character varying,
    profile_score smallint,
    valid_driver boolean,
    own_tools boolean,
    company_name character varying,
    job_types public.citext,
    job_functions public.citext,
    manufacturer_tags public.citext,
    special_avj_fees numeric(10,2),
    avj_credit numeric(10,2) DEFAULT NULL::numeric,
    registration_step character varying,
    province character varying,
    freelancer_id integer,
    business_tax_number character varying
);


--
-- Name: freelancer_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.freelancer_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: freelancer_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.freelancer_profiles_id_seq OWNED BY public.freelancer_profiles.id;


--
-- Name: freelancer_reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.freelancer_reviews (
    id bigint NOT NULL,
    freelancer_id bigint,
    company_id bigint,
    job_id bigint,
    availability integer NOT NULL,
    communication integer NOT NULL,
    adherence_to_schedule integer NOT NULL,
    skill_and_quality_of_work integer NOT NULL,
    overall_experience integer NOT NULL,
    comments text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: freelancer_reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.freelancer_reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: freelancer_reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.freelancer_reviews_id_seq OWNED BY public.freelancer_reviews.id;


--
-- Name: friend_invites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.friend_invites (
    id bigint NOT NULL,
    email public.citext NOT NULL,
    name character varying NOT NULL,
    freelancer_id bigint NOT NULL,
    accepted boolean DEFAULT false
);


--
-- Name: friend_invites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.friend_invites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: friend_invites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.friend_invites_id_seq OWNED BY public.friend_invites.id;


--
-- Name: identities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.identities (
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

CREATE SEQUENCE public.identities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: identities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.identities_id_seq OWNED BY public.identities.id;


--
-- Name: job_collaborators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_collaborators (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    user_id bigint NOT NULL,
    receive_notifications boolean DEFAULT true
);


--
-- Name: job_collaborators_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.job_collaborators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_collaborators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.job_collaborators_id_seq OWNED BY public.job_collaborators.id;


--
-- Name: job_favourites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_favourites (
    id bigint NOT NULL,
    freelancer_id integer,
    job_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: job_favourites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.job_favourites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_favourites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.job_favourites_id_seq OWNED BY public.job_favourites.id;


--
-- Name: job_invites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_invites (
    id bigint NOT NULL,
    job_id integer,
    freelancer_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: job_invites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.job_invites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_invites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.job_invites_id_seq OWNED BY public.job_invites.id;


--
-- Name: jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jobs (
    id bigint NOT NULL,
    company_id bigint NOT NULL,
    title character varying,
    state character varying DEFAULT 'created'::character varying NOT NULL,
    summary text,
    scope_of_work text,
    budget numeric(10,2),
    job_function character varying,
    starts_on date,
    ends_on date,
    duration integer,
    pay_type character varying,
    freelancer_type character varying,
    technical_skill_tags text,
    invite_only boolean DEFAULT false NOT NULL,
    scope_is_public boolean DEFAULT true NOT NULL,
    budget_is_public boolean DEFAULT false NOT NULL,
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
    updated_at timestamp without time zone NOT NULL,
    currency character varying,
    address character varying,
    lat numeric(9,6),
    lng numeric(9,6),
    formatted_address character varying,
    contract_sent boolean DEFAULT false,
    opt_out_of_freelance_service_agreement boolean DEFAULT false,
    country character varying,
    scope_file_data text,
    applicable_sales_tax numeric(10,2),
    stripe_charge_id character varying,
    stripe_balance_transaction_id character varying,
    funds_available_on integer,
    funds_available boolean DEFAULT false,
    job_type public.citext,
    job_market public.citext,
    manufacturer_tags public.citext,
    company_plan_fees numeric(10,2) DEFAULT 0,
    contracted_at timestamp without time zone,
    state_province character varying,
    creation_step character varying,
    plan_fee numeric(10,2) DEFAULT 0,
    paid_by_company boolean DEFAULT false,
    total_amount numeric(10,2),
    tax_amount numeric(10,2),
    stripe_fees numeric(10,2),
    amount_subtotal numeric(10,2),
    variable_pay_type character varying,
    overtime_rate numeric(10,2),
    payment_terms integer,
    expired boolean DEFAULT false,
    fee_schema json,
    creator_id bigint
);


--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.jobs_id_seq OWNED BY public.jobs.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.messages (
    id bigint NOT NULL,
    authorable_type character varying,
    authorable_id bigint NOT NULL,
    receivable_type character varying,
    receivable_id bigint NOT NULL,
    body text,
    attachment_data text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    checkin boolean DEFAULT false,
    send_contract boolean DEFAULT false,
    unread boolean DEFAULT true
);


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    id bigint NOT NULL,
    authorable_type character varying,
    authorable_id bigint NOT NULL,
    receivable_type character varying,
    receivable_id bigint NOT NULL,
    body text,
    title text,
    read_at timestamp without time zone,
    url text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pages (
    id bigint NOT NULL,
    slug character varying NOT NULL,
    title character varying NOT NULL,
    body text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pages_id_seq OWNED BY public.pages.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    first_name character varying,
    last_name character varying,
    type character varying,
    messages_count integer DEFAULT 0 NOT NULL,
    company_id bigint,
    invitation_token character varying,
    invitation_created_at timestamp without time zone,
    invitation_sent_at timestamp without time zone,
    invitation_accepted_at timestamp without time zone,
    invitation_limit integer,
    invited_by_type character varying,
    invited_by_id bigint,
    invitations_count integer DEFAULT 0,
    enabled boolean DEFAULT true,
    role character varying,
    phone_number character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
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
-- Name: applicants id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.applicants ALTER COLUMN id SET DEFAULT nextval('public.applicants_id_seq'::regclass);


--
-- Name: attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attachments ALTER COLUMN id SET DEFAULT nextval('public.attachments_id_seq'::regclass);


--
-- Name: audits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audits ALTER COLUMN id SET DEFAULT nextval('public.audits_id_seq'::regclass);


--
-- Name: certifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certifications ALTER COLUMN id SET DEFAULT nextval('public.certifications_id_seq'::regclass);


--
-- Name: change_orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.change_orders ALTER COLUMN id SET DEFAULT nextval('public.change_orders_id_seq'::regclass);


--
-- Name: companies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies ALTER COLUMN id SET DEFAULT nextval('public.companies_id_seq'::regclass);


--
-- Name: company_favourites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_favourites ALTER COLUMN id SET DEFAULT nextval('public.company_favourites_id_seq'::regclass);


--
-- Name: company_installs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_installs ALTER COLUMN id SET DEFAULT nextval('public.company_installs_id_seq'::regclass);


--
-- Name: company_reviews id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_reviews ALTER COLUMN id SET DEFAULT nextval('public.company_reviews_id_seq'::regclass);


--
-- Name: currency_rates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.currency_rates ALTER COLUMN id SET DEFAULT nextval('public.currency_rates_id_seq'::regclass);


--
-- Name: favourites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favourites ALTER COLUMN id SET DEFAULT nextval('public.favourites_id_seq'::regclass);


--
-- Name: featured_projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.featured_projects ALTER COLUMN id SET DEFAULT nextval('public.featured_projects_id_seq'::regclass);


--
-- Name: freelancer_affiliations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.freelancer_affiliations ALTER COLUMN id SET DEFAULT nextval('public.freelancer_affiliations_id_seq'::regclass);


--
-- Name: freelancer_clearances id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.freelancer_clearances ALTER COLUMN id SET DEFAULT nextval('public.freelancer_clearances_id_seq'::regclass);


--
-- Name: freelancer_insurances id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.freelancer_insurances ALTER COLUMN id SET DEFAULT nextval('public.freelancer_insurances_id_seq'::regclass);


--
-- Name: freelancer_portfolios id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.freelancer_portfolios ALTER COLUMN id SET DEFAULT nextval('public.freelancer_portfolios_id_seq'::regclass);


--
-- Name: freelancer_profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.freelancer_profiles ALTER COLUMN id SET DEFAULT nextval('public.freelancer_profiles_id_seq'::regclass);


--
-- Name: freelancer_reviews id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.freelancer_reviews ALTER COLUMN id SET DEFAULT nextval('public.freelancer_reviews_id_seq'::regclass);


--
-- Name: friend_invites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friend_invites ALTER COLUMN id SET DEFAULT nextval('public.friend_invites_id_seq'::regclass);


--
-- Name: identities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identities ALTER COLUMN id SET DEFAULT nextval('public.identities_id_seq'::regclass);


--
-- Name: job_collaborators id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_collaborators ALTER COLUMN id SET DEFAULT nextval('public.job_collaborators_id_seq'::regclass);


--
-- Name: job_favourites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_favourites ALTER COLUMN id SET DEFAULT nextval('public.job_favourites_id_seq'::regclass);


--
-- Name: job_invites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_invites ALTER COLUMN id SET DEFAULT nextval('public.job_invites_id_seq'::regclass);


--
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs ALTER COLUMN id SET DEFAULT nextval('public.jobs_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: pages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages ALTER COLUMN id SET DEFAULT nextval('public.pages_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: applicants applicants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.applicants
    ADD CONSTRAINT applicants_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: attachments attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attachments
    ADD CONSTRAINT attachments_pkey PRIMARY KEY (id);


--
-- Name: audits audits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audits
    ADD CONSTRAINT audits_pkey PRIMARY KEY (id);


--
-- Name: certifications certifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certifications
    ADD CONSTRAINT certifications_pkey PRIMARY KEY (id);


--
-- Name: change_orders change_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.change_orders
    ADD CONSTRAINT change_orders_pkey PRIMARY KEY (id);


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: company_favourites company_favourites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_favourites
    ADD CONSTRAINT company_favourites_pkey PRIMARY KEY (id);


--
-- Name: company_installs company_installs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_installs
    ADD CONSTRAINT company_installs_pkey PRIMARY KEY (id);


--
-- Name: company_reviews company_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_reviews
    ADD CONSTRAINT company_reviews_pkey PRIMARY KEY (id);


--
-- Name: currency_rates currency_rates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.currency_rates
    ADD CONSTRAINT currency_rates_pkey PRIMARY KEY (id);


--
-- Name: favourites favourites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favourites
    ADD CONSTRAINT favourites_pkey PRIMARY KEY (id);


--
-- Name: featured_projects featured_projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.featured_projects
    ADD CONSTRAINT featured_projects_pkey PRIMARY KEY (id);


--
-- Name: freelancer_affiliations freelancer_affiliations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.freelancer_affiliations
    ADD CONSTRAINT freelancer_affiliations_pkey PRIMARY KEY (id);


--
-- Name: freelancer_clearances freelancer_clearances_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.freelancer_clearances
    ADD CONSTRAINT freelancer_clearances_pkey PRIMARY KEY (id);


--
-- Name: freelancer_insurances freelancer_insurances_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.freelancer_insurances
    ADD CONSTRAINT freelancer_insurances_pkey PRIMARY KEY (id);


--
-- Name: freelancer_portfolios freelancer_portfolios_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.freelancer_portfolios
    ADD CONSTRAINT freelancer_portfolios_pkey PRIMARY KEY (id);


--
-- Name: freelancer_profiles freelancer_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.freelancer_profiles
    ADD CONSTRAINT freelancer_profiles_pkey PRIMARY KEY (id);


--
-- Name: freelancer_reviews freelancer_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.freelancer_reviews
    ADD CONSTRAINT freelancer_reviews_pkey PRIMARY KEY (id);


--
-- Name: friend_invites friend_invites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friend_invites
    ADD CONSTRAINT friend_invites_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: job_collaborators job_collaborators_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_collaborators
    ADD CONSTRAINT job_collaborators_pkey PRIMARY KEY (id);


--
-- Name: job_favourites job_favourites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_favourites
    ADD CONSTRAINT job_favourites_pkey PRIMARY KEY (id);


--
-- Name: job_invites job_invites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_invites
    ADD CONSTRAINT job_invites_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: pages pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: associated_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX associated_index ON public.audits USING btree (associated_id, associated_type);


--
-- Name: auditable_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auditable_index ON public.audits USING btree (auditable_id, auditable_type);


--
-- Name: index_applicants_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_applicants_on_company_id ON public.applicants USING btree (company_id);


--
-- Name: index_applicants_on_freelancer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_applicants_on_freelancer_id ON public.applicants USING btree (freelancer_id);


--
-- Name: index_applicants_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_applicants_on_job_id ON public.applicants USING btree (job_id);


--
-- Name: index_audits_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_audits_on_created_at ON public.audits USING btree (created_at);


--
-- Name: index_audits_on_request_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_audits_on_request_uuid ON public.audits USING btree (request_uuid);


--
-- Name: index_change_orders_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_change_orders_on_company_id ON public.change_orders USING btree (company_id);


--
-- Name: index_change_orders_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_change_orders_on_job_id ON public.change_orders USING btree (job_id);


--
-- Name: index_companies_on_disabled; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_disabled ON public.companies USING btree (disabled);


--
-- Name: index_companies_on_job_markets; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_job_markets ON public.companies USING btree (job_markets);


--
-- Name: index_companies_on_manufacturer_tags; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_manufacturer_tags ON public.companies USING btree (manufacturer_tags);


--
-- Name: index_companies_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_name ON public.companies USING btree (name);


--
-- Name: index_companies_on_technical_skill_tags; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_technical_skill_tags ON public.companies USING btree (technical_skill_tags);


--
-- Name: index_company_reviews_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_company_reviews_on_company_id ON public.company_reviews USING btree (company_id);


--
-- Name: index_company_reviews_on_freelancer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_company_reviews_on_freelancer_id ON public.company_reviews USING btree (freelancer_id);


--
-- Name: index_company_reviews_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_company_reviews_on_job_id ON public.company_reviews USING btree (job_id);


--
-- Name: index_freelancer_profiles_on_area; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_freelancer_profiles_on_area ON public.freelancer_profiles USING btree (area);


--
-- Name: index_freelancer_profiles_on_available; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_freelancer_profiles_on_available ON public.freelancer_profiles USING btree (available);


--
-- Name: index_freelancer_profiles_on_disabled; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_freelancer_profiles_on_disabled ON public.freelancer_profiles USING btree (disabled);


--
-- Name: index_freelancer_profiles_on_freelancer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_freelancer_profiles_on_freelancer_id ON public.freelancer_profiles USING btree (freelancer_id);


--
-- Name: index_freelancer_profiles_on_job_functions; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_freelancer_profiles_on_job_functions ON public.freelancer_profiles USING btree (job_functions);


--
-- Name: index_freelancer_profiles_on_job_markets; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_freelancer_profiles_on_job_markets ON public.freelancer_profiles USING btree (job_markets);


--
-- Name: index_freelancer_profiles_on_manufacturer_tags; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_freelancer_profiles_on_manufacturer_tags ON public.freelancer_profiles USING btree (manufacturer_tags);


--
-- Name: index_freelancer_profiles_on_technical_skill_tags; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_freelancer_profiles_on_technical_skill_tags ON public.freelancer_profiles USING btree (technical_skill_tags);


--
-- Name: index_freelancer_reviews_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_freelancer_reviews_on_company_id ON public.freelancer_reviews USING btree (company_id);


--
-- Name: index_freelancer_reviews_on_freelancer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_freelancer_reviews_on_freelancer_id ON public.freelancer_reviews USING btree (freelancer_id);


--
-- Name: index_freelancer_reviews_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_freelancer_reviews_on_job_id ON public.freelancer_reviews USING btree (job_id);


--
-- Name: index_friend_invites_on_freelancer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friend_invites_on_freelancer_id ON public.friend_invites USING btree (freelancer_id);


--
-- Name: index_identities_on_loginable_type_and_loginable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_identities_on_loginable_type_and_loginable_id ON public.identities USING btree (loginable_type, loginable_id);


--
-- Name: index_identities_on_loginable_type_and_provider_and_uid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_identities_on_loginable_type_and_provider_and_uid ON public.identities USING btree (loginable_type, provider, uid);


--
-- Name: index_job_collaborators_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_job_collaborators_on_job_id ON public.job_collaborators USING btree (job_id);


--
-- Name: index_job_collaborators_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_job_collaborators_on_user_id ON public.job_collaborators USING btree (user_id);


--
-- Name: index_jobs_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_company_id ON public.jobs USING btree (company_id);


--
-- Name: index_jobs_on_creator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_creator_id ON public.jobs USING btree (creator_id);


--
-- Name: index_jobs_on_manufacturer_tags; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_manufacturer_tags ON public.jobs USING btree (manufacturer_tags);


--
-- Name: index_messages_on_authorable_type_and_authorable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_messages_on_authorable_type_and_authorable_id ON public.messages USING btree (authorable_type, authorable_id);


--
-- Name: index_messages_on_receivable_type_and_receivable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_messages_on_receivable_type_and_receivable_id ON public.messages USING btree (receivable_type, receivable_id);


--
-- Name: index_notifications_on_authorable_type_and_authorable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_authorable_type_and_authorable_id ON public.notifications USING btree (authorable_type, authorable_id);


--
-- Name: index_notifications_on_receivable_type_and_receivable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_receivable_type_and_receivable_id ON public.notifications USING btree (receivable_type, receivable_id);


--
-- Name: index_on_companies_loc; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_on_companies_loc ON public.companies USING gist (public.st_geographyfromtext((((('SRID=4326;POINT('::text || lng) || ' '::text) || lat) || ')'::text)));


--
-- Name: index_on_freelancer_profiles_loc; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_on_freelancer_profiles_loc ON public.freelancer_profiles USING gist (public.st_geographyfromtext((((('SRID=4326;POINT('::text || lng) || ' '::text) || lat) || ')'::text)));


--
-- Name: index_on_freelancers_loc; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_on_freelancers_loc ON public.freelancer_profiles USING gist (public.st_geographyfromtext((((('SRID=4326;POINT('::text || lng) || ' '::text) || lat) || ')'::text)));


--
-- Name: index_pages_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pages_on_slug ON public.pages USING btree (slug);


--
-- Name: index_users_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_company_id ON public.users USING btree (company_id);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON public.users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_invitation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_invitation_token ON public.users USING btree (invitation_token);


--
-- Name: index_users_on_invitations_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_invitations_count ON public.users USING btree (invitations_count);


--
-- Name: index_users_on_invited_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_invited_by_id ON public.users USING btree (invited_by_id);


--
-- Name: index_users_on_invited_by_type_and_invited_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_invited_by_type_and_invited_by_id ON public.users USING btree (invited_by_type, invited_by_id);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: user_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_index ON public.audits USING btree (user_id, user_type);


--
-- Name: company_reviews fk_rails_05756653f5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_reviews
    ADD CONSTRAINT fk_rails_05756653f5 FOREIGN KEY (job_id) REFERENCES public.jobs(id);


--
-- Name: freelancer_reviews fk_rails_2d750cb05f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.freelancer_reviews
    ADD CONSTRAINT fk_rails_2d750cb05f FOREIGN KEY (freelancer_id) REFERENCES public.users(id);


--
-- Name: applicants fk_rails_32d387f70d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.applicants
    ADD CONSTRAINT fk_rails_32d387f70d FOREIGN KEY (job_id) REFERENCES public.jobs(id);


--
-- Name: applicants fk_rails_4b7bc91392; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.applicants
    ADD CONSTRAINT fk_rails_4b7bc91392 FOREIGN KEY (freelancer_id) REFERENCES public.users(id);


--
-- Name: company_reviews fk_rails_54727610ca; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_reviews
    ADD CONSTRAINT fk_rails_54727610ca FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: job_collaborators fk_rails_5b6ad69406; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_collaborators
    ADD CONSTRAINT fk_rails_5b6ad69406 FOREIGN KEY (job_id) REFERENCES public.jobs(id);


--
-- Name: applicants fk_rails_7283c3d901; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.applicants
    ADD CONSTRAINT fk_rails_7283c3d901 FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: freelancer_reviews fk_rails_ab5db9ea44; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.freelancer_reviews
    ADD CONSTRAINT fk_rails_ab5db9ea44 FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: jobs fk_rails_b34da78090; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT fk_rails_b34da78090 FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: change_orders fk_rails_b3bebfe084; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.change_orders
    ADD CONSTRAINT fk_rails_b3bebfe084 FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: change_orders fk_rails_cab1ecc845; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.change_orders
    ADD CONSTRAINT fk_rails_cab1ecc845 FOREIGN KEY (job_id) REFERENCES public.jobs(id);


--
-- Name: job_collaborators fk_rails_d4b8b384a8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_collaborators
    ADD CONSTRAINT fk_rails_d4b8b384a8 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: company_reviews fk_rails_dfd5a40d4e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_reviews
    ADD CONSTRAINT fk_rails_dfd5a40d4e FOREIGN KEY (freelancer_id) REFERENCES public.users(id);


--
-- Name: freelancer_reviews fk_rails_f184aba2e9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.freelancer_reviews
    ADD CONSTRAINT fk_rails_f184aba2e9 FOREIGN KEY (job_id) REFERENCES public.jobs(id);


--
-- Name: jobs fk_rails_f251f165d2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT fk_rails_f251f165d2 FOREIGN KEY (creator_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20170414003540'),
('20170414003541'),
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
('20170515191347'),
('20170616143054'),
('20170710124433'),
('20170710124506'),
('20170712161401'),
('20170712165459'),
('20170728145820'),
('20170808203809'),
('20170808204344'),
('20170808204412'),
('20170809143023'),
('20170814162250'),
('20170815124107'),
('20170816140329'),
('20170816140705'),
('20170816141721'),
('20170816144823'),
('20170818132847'),
('20170818133107'),
('20170822182057'),
('20170822183600'),
('20170828175939'),
('20170828184903'),
('20170829140913'),
('20170829141232'),
('20170830104424'),
('20170831120937'),
('20170831122235'),
('20170831123047'),
('20170831171827'),
('20170831174408'),
('20170901144348'),
('20170901145302'),
('20170901150719'),
('20170901150851'),
('20170901182130'),
('20170901182440'),
('20170901182938'),
('20170905134525'),
('20170905135835'),
('20170905135846'),
('20170905135938'),
('20170908180901'),
('20170911175055'),
('20170911175108'),
('20170919185701'),
('20170920173223'),
('20170921184950'),
('20170925141902'),
('20170925143659'),
('20170926143146'),
('20170928133148'),
('20170928151229'),
('20170928151921'),
('20170929133938'),
('20171002193000'),
('20171003125747'),
('20171011195102'),
('20171017101132'),
('20171020113522'),
('20171020123018'),
('20171105210413'),
('20171113154821'),
('20171114170911'),
('20171114193831'),
('20171116153824'),
('20171117140302'),
('20171122143605'),
('20171122143916'),
('20171122150510'),
('20171122202327'),
('20171123045237'),
('20171125181227'),
('20171129231733'),
('20171207014259'),
('20171218020642'),
('20171218023711'),
('20171222051331'),
('20180119214528'),
('20180127120826'),
('20180127123843'),
('20180130000647'),
('20180130013756'),
('20180130022656'),
('20180201201033'),
('20180205194146'),
('20180206182339'),
('20180212001020'),
('20180214212732'),
('20180301165221'),
('20180301181649'),
('20180301194139'),
('20180305202451'),
('20180305202656'),
('20180309165026'),
('20180311184145'),
('20180311184319'),
('20180311185453'),
('20180311194837'),
('20180312143559'),
('20180312192616'),
('20180312205533'),
('20180319115900'),
('20180319144208'),
('20180321172650'),
('20180402194248'),
('20180404170355'),
('20180410210448'),
('20180413155543'),
('20180413190903'),
('20180418190453'),
('20180418195120'),
('20180420173017'),
('20180424155938'),
('20180424190619'),
('20180504205104'),
('20180506150209'),
('20180508222720'),
('20180509110048'),
('20180525003348'),
('20180530180210'),
('20180606180440'),
('20180606180539'),
('20180607204753'),
('20180611160634'),
('20180619175806'),
('20180704204319'),
('20180706223639'),
('20180725190313'),
('20180725222036'),
('20180726215803'),
('20180728165546'),
('20180730130124'),
('20180801180627'),
('20180801220123'),
('20180801230445'),
('20180802215944'),
('20180803160038'),
('20180808185712'),
('20180809145354'),
('20180809204356'),
('20180810215943'),
('20180814215826'),
('20180824200604'),
('20180906170002'),
('20180920171313'),
('20180929195929'),
('20181005155020'),
('20181024193655'),
('20181024211631'),
('20181114170452'),
('20181115173748'),
('20181116155610'),
('20181119182307'),
('20181128205316'),
('20181129154912'),
('20181203174528'),
('20181203184841'),
('20181212151759'),
('20190401182720'),
('20190417220517'),
('20190426172935'),
('20190503190656'),
('20190509185605');


