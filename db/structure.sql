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


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: admins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE admins (
    id bigint NOT NULL,
    token character varying,
    email citext NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet
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
-- Name: attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE attachments (
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

CREATE SEQUENCE attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE attachments_id_seq OWNED BY attachments.id;


--
-- Name: audits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE audits (
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

CREATE SEQUENCE audits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE audits_id_seq OWNED BY audits.id;


--
-- Name: certifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE certifications (
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

CREATE SEQUENCE certifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: certifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE certifications_id_seq OWNED BY certifications.id;


--
-- Name: change_orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE change_orders (
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
    email citext NOT NULL,
    name character varying NOT NULL,
    contact_name character varying NOT NULL,
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
    job_markets citext,
    technical_skill_tags citext,
    profile_views integer DEFAULT 0 NOT NULL,
    website character varying,
    phone_number character varying,
    number_of_offices integer DEFAULT 0,
    number_of_employees character varying,
    established_in integer,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    stripe_customer_id character varying,
    stripe_subscription_id character varying,
    stripe_plan_id character varying,
    subscription_cycle character varying,
    is_subscription_cancelled boolean DEFAULT false,
    subscription_status character varying,
    billing_period_ends_at timestamp without time zone,
    last_4_digits character varying,
    card_brand character varying,
    exp_month character varying,
    exp_year character varying,
    header_color character varying DEFAULT 'FF6C38'::character varying,
    country character varying,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    header_source character varying DEFAULT 'color'::character varying,
    province character varying,
    sales_tax_number character varying,
    line2 character varying,
    city character varying,
    state character varying,
    postal_code character varying,
    job_types citext,
    manufacturer_tags citext,
    plan_id bigint,
    is_trial_applicable boolean DEFAULT true,
    waived_jobs integer DEFAULT 1
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
-- Name: company_favourites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE company_favourites (
    id bigint NOT NULL,
    freelancer_id integer,
    company_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: company_favourites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE company_favourites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_favourites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE company_favourites_id_seq OWNED BY company_favourites.id;


--
-- Name: company_installs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE company_installs (
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

CREATE SEQUENCE company_installs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_installs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE company_installs_id_seq OWNED BY company_installs.id;


--
-- Name: company_reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE company_reviews (
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

CREATE SEQUENCE company_reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE company_reviews_id_seq OWNED BY company_reviews.id;


--
-- Name: currency_rates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE currency_rates (
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

CREATE SEQUENCE currency_rates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: currency_rates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE currency_rates_id_seq OWNED BY currency_rates.id;


--
-- Name: favourites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE favourites (
    id bigint NOT NULL,
    freelancer_id integer,
    company_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: favourites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE favourites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: favourites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE favourites_id_seq OWNED BY favourites.id;


--
-- Name: featured_projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE featured_projects (
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

CREATE SEQUENCE featured_projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: featured_projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE featured_projects_id_seq OWNED BY featured_projects.id;


--
-- Name: freelancer_affiliations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE freelancer_affiliations (
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

CREATE SEQUENCE freelancer_affiliations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: freelancer_affiliations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE freelancer_affiliations_id_seq OWNED BY freelancer_affiliations.id;


--
-- Name: freelancer_clearances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE freelancer_clearances (
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

CREATE SEQUENCE freelancer_clearances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: freelancer_clearances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE freelancer_clearances_id_seq OWNED BY freelancer_clearances.id;


--
-- Name: freelancer_insurances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE freelancer_insurances (
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

CREATE SEQUENCE freelancer_insurances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: freelancer_insurances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE freelancer_insurances_id_seq OWNED BY freelancer_insurances.id;


--
-- Name: freelancer_portfolios; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE freelancer_portfolios (
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

CREATE SEQUENCE freelancer_portfolios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: freelancer_portfolios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE freelancer_portfolios_id_seq OWNED BY freelancer_portfolios.id;


--
-- Name: freelancer_reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE freelancer_reviews (
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

CREATE SEQUENCE freelancer_reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: freelancer_reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE freelancer_reviews_id_seq OWNED BY freelancer_reviews.id;


--
-- Name: freelancers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE freelancers (
    id bigint NOT NULL,
    token character varying,
    email citext NOT NULL,
    name character varying,
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
    job_markets citext,
    years_of_experience integer DEFAULT 0 NOT NULL,
    profile_views integer DEFAULT 0 NOT NULL,
    projects_completed integer DEFAULT 0 NOT NULL,
    available boolean DEFAULT true NOT NULL,
    disabled boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    messages_count integer DEFAULT 0 NOT NULL,
    freelancer_reviews_count integer DEFAULT 0 NOT NULL,
    technical_skill_tags citext,
    profile_header_data text,
    verified boolean DEFAULT false,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    header_color character varying DEFAULT 'FF6C38'::character varying,
    country character varying,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    freelancer_team_size character varying,
    freelancer_type character varying,
    header_source character varying DEFAULT 'color'::character varying,
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
    job_types citext,
    job_functions citext,
    manufacturer_tags citext,
    special_avj_fees numeric(10,2),
    avj_credit numeric(10,2) DEFAULT NULL::numeric,
    registration_step character varying
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
-- Name: friend_invites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE friend_invites (
    id bigint NOT NULL,
    email citext NOT NULL,
    name character varying NOT NULL,
    freelancer_id bigint NOT NULL,
    accepted boolean DEFAULT false
);


--
-- Name: friend_invites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE friend_invites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: friend_invites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE friend_invites_id_seq OWNED BY friend_invites.id;


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
-- Name: job_favourites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE job_favourites (
    id bigint NOT NULL,
    freelancer_id integer,
    job_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: job_favourites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE job_favourites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_favourites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE job_favourites_id_seq OWNED BY job_favourites.id;


--
-- Name: job_invites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE job_invites (
    id bigint NOT NULL,
    job_id integer,
    freelancer_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: job_invites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE job_invites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_invites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE job_invites_id_seq OWNED BY job_invites.id;


--
-- Name: jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE jobs (
    id bigint NOT NULL,
    company_id bigint NOT NULL,
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
    job_type citext,
    job_market citext,
    manufacturer_tags citext,
    contracted_at timestamp without time zone,
    company_plan_fees numeric(10,2) DEFAULT 0
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
    unread boolean DEFAULT true,
    has_quote boolean DEFAULT false,
    quote_id integer,
    lat numeric(9,6),
    lng numeric(9,6)
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
-- Name: pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pages (
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

CREATE SEQUENCE pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pages_id_seq OWNED BY pages.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE payments (
    id bigint NOT NULL,
    company_id bigint NOT NULL,
    job_id bigint NOT NULL,
    description character varying NOT NULL,
    amount numeric(10,2) NOT NULL,
    issued_on date,
    paid_on date,
    attachment_data text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    tax_amount numeric(10,2),
    total_amount numeric(10,2),
    avj_fees numeric(10,2),
    avj_credit numeric(10,2) DEFAULT NULL::numeric
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
-- Name: plans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE plans (
    id bigint NOT NULL,
    name character varying,
    code character varying,
    trial_period integer,
    subscription_fee numeric(10,2),
    fee_schema json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description text,
    period character varying DEFAULT 'yearly'::character varying
);


--
-- Name: plans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE plans_id_seq OWNED BY plans.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE projects (
    id bigint NOT NULL,
    company_id bigint NOT NULL,
    external_project_id character varying,
    name character varying NOT NULL,
    formatted_address character varying,
    lat numeric(9,6),
    lng numeric(9,6),
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
    company_id bigint NOT NULL,
    applicant_id bigint NOT NULL,
    state character varying DEFAULT 'pending'::character varying NOT NULL,
    amount numeric(10,2) NOT NULL,
    pay_type character varying DEFAULT 'fixed'::character varying NOT NULL,
    attachment_data text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    number_of_hours integer,
    hourly_rate integer,
    number_of_days integer,
    daily_rate integer,
    author_type character varying DEFAULT 'freelancer'::character varying,
    accepted_by_freelancer boolean DEFAULT false,
    paid_by_company boolean DEFAULT false,
    paid_at timestamp without time zone,
    platform_fees_amount numeric(10,2),
    tax_amount numeric(10,2),
    total_amount numeric(10,2),
    applicable_sales_tax integer,
    avj_fees numeric(10,2),
    stripe_fees numeric(10,2),
    net_avj_fees numeric(10,2),
    accepted_at timestamp without time zone,
    plan_fee numeric(10,2) DEFAULT 0,
    avj_credit numeric(10,2) DEFAULT NULL::numeric
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
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE subscriptions (
    id bigint NOT NULL,
    company_id integer,
    plan_id integer,
    stripe_subscription_id character varying,
    is_active boolean,
    ends_at date,
    billing_perios_ends_at date,
    amount numeric,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    refund numeric(10,2) DEFAULT 0,
    tax numeric(10,2) DEFAULT 0,
    description character varying
);


--
-- Name: subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE subscriptions_id_seq OWNED BY subscriptions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
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
    meta_id integer,
    meta_type character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: admins id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admins ALTER COLUMN id SET DEFAULT nextval('admins_id_seq'::regclass);


--
-- Name: applicants id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY applicants ALTER COLUMN id SET DEFAULT nextval('applicants_id_seq'::regclass);


--
-- Name: attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY attachments ALTER COLUMN id SET DEFAULT nextval('attachments_id_seq'::regclass);


--
-- Name: audits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY audits ALTER COLUMN id SET DEFAULT nextval('audits_id_seq'::regclass);


--
-- Name: certifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY certifications ALTER COLUMN id SET DEFAULT nextval('certifications_id_seq'::regclass);


--
-- Name: change_orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY change_orders ALTER COLUMN id SET DEFAULT nextval('change_orders_id_seq'::regclass);


--
-- Name: companies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY companies ALTER COLUMN id SET DEFAULT nextval('companies_id_seq'::regclass);


--
-- Name: company_favourites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY company_favourites ALTER COLUMN id SET DEFAULT nextval('company_favourites_id_seq'::regclass);


--
-- Name: company_installs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY company_installs ALTER COLUMN id SET DEFAULT nextval('company_installs_id_seq'::regclass);


--
-- Name: company_reviews id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY company_reviews ALTER COLUMN id SET DEFAULT nextval('company_reviews_id_seq'::regclass);


--
-- Name: currency_rates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY currency_rates ALTER COLUMN id SET DEFAULT nextval('currency_rates_id_seq'::regclass);


--
-- Name: favourites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY favourites ALTER COLUMN id SET DEFAULT nextval('favourites_id_seq'::regclass);


--
-- Name: featured_projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY featured_projects ALTER COLUMN id SET DEFAULT nextval('featured_projects_id_seq'::regclass);


--
-- Name: freelancer_affiliations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY freelancer_affiliations ALTER COLUMN id SET DEFAULT nextval('freelancer_affiliations_id_seq'::regclass);


--
-- Name: freelancer_clearances id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY freelancer_clearances ALTER COLUMN id SET DEFAULT nextval('freelancer_clearances_id_seq'::regclass);


--
-- Name: freelancer_insurances id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY freelancer_insurances ALTER COLUMN id SET DEFAULT nextval('freelancer_insurances_id_seq'::regclass);


--
-- Name: freelancer_portfolios id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY freelancer_portfolios ALTER COLUMN id SET DEFAULT nextval('freelancer_portfolios_id_seq'::regclass);


--
-- Name: freelancer_reviews id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY freelancer_reviews ALTER COLUMN id SET DEFAULT nextval('freelancer_reviews_id_seq'::regclass);


--
-- Name: freelancers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY freelancers ALTER COLUMN id SET DEFAULT nextval('freelancers_id_seq'::regclass);


--
-- Name: friend_invites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY friend_invites ALTER COLUMN id SET DEFAULT nextval('friend_invites_id_seq'::regclass);


--
-- Name: identities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY identities ALTER COLUMN id SET DEFAULT nextval('identities_id_seq'::regclass);


--
-- Name: job_favourites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY job_favourites ALTER COLUMN id SET DEFAULT nextval('job_favourites_id_seq'::regclass);


--
-- Name: job_invites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY job_invites ALTER COLUMN id SET DEFAULT nextval('job_invites_id_seq'::regclass);


--
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY jobs ALTER COLUMN id SET DEFAULT nextval('jobs_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY messages ALTER COLUMN id SET DEFAULT nextval('messages_id_seq'::regclass);


--
-- Name: pages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pages ALTER COLUMN id SET DEFAULT nextval('pages_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY payments ALTER COLUMN id SET DEFAULT nextval('payments_id_seq'::regclass);


--
-- Name: plans id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY plans ALTER COLUMN id SET DEFAULT nextval('plans_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects ALTER COLUMN id SET DEFAULT nextval('projects_id_seq'::regclass);


--
-- Name: quotes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY quotes ALTER COLUMN id SET DEFAULT nextval('quotes_id_seq'::regclass);


--
-- Name: subscriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY subscriptions ALTER COLUMN id SET DEFAULT nextval('subscriptions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


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
-- Name: attachments attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY attachments
    ADD CONSTRAINT attachments_pkey PRIMARY KEY (id);


--
-- Name: audits audits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY audits
    ADD CONSTRAINT audits_pkey PRIMARY KEY (id);


--
-- Name: certifications certifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY certifications
    ADD CONSTRAINT certifications_pkey PRIMARY KEY (id);


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
-- Name: company_favourites company_favourites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY company_favourites
    ADD CONSTRAINT company_favourites_pkey PRIMARY KEY (id);


--
-- Name: company_installs company_installs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY company_installs
    ADD CONSTRAINT company_installs_pkey PRIMARY KEY (id);


--
-- Name: company_reviews company_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY company_reviews
    ADD CONSTRAINT company_reviews_pkey PRIMARY KEY (id);


--
-- Name: currency_rates currency_rates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY currency_rates
    ADD CONSTRAINT currency_rates_pkey PRIMARY KEY (id);


--
-- Name: favourites favourites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY favourites
    ADD CONSTRAINT favourites_pkey PRIMARY KEY (id);


--
-- Name: featured_projects featured_projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY featured_projects
    ADD CONSTRAINT featured_projects_pkey PRIMARY KEY (id);


--
-- Name: freelancer_affiliations freelancer_affiliations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY freelancer_affiliations
    ADD CONSTRAINT freelancer_affiliations_pkey PRIMARY KEY (id);


--
-- Name: freelancer_clearances freelancer_clearances_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY freelancer_clearances
    ADD CONSTRAINT freelancer_clearances_pkey PRIMARY KEY (id);


--
-- Name: freelancer_insurances freelancer_insurances_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY freelancer_insurances
    ADD CONSTRAINT freelancer_insurances_pkey PRIMARY KEY (id);


--
-- Name: freelancer_portfolios freelancer_portfolios_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY freelancer_portfolios
    ADD CONSTRAINT freelancer_portfolios_pkey PRIMARY KEY (id);


--
-- Name: freelancer_reviews freelancer_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY freelancer_reviews
    ADD CONSTRAINT freelancer_reviews_pkey PRIMARY KEY (id);


--
-- Name: freelancers freelancers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY freelancers
    ADD CONSTRAINT freelancers_pkey PRIMARY KEY (id);


--
-- Name: friend_invites friend_invites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY friend_invites
    ADD CONSTRAINT friend_invites_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: job_favourites job_favourites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY job_favourites
    ADD CONSTRAINT job_favourites_pkey PRIMARY KEY (id);


--
-- Name: job_invites job_invites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY job_invites
    ADD CONSTRAINT job_invites_pkey PRIMARY KEY (id);


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
-- Name: pages pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: plans plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY plans
    ADD CONSTRAINT plans_pkey PRIMARY KEY (id);


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
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: associated_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX associated_index ON audits USING btree (associated_id, associated_type);


--
-- Name: auditable_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auditable_index ON audits USING btree (auditable_id, auditable_type);


--
-- Name: index_admins_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admins_on_email ON admins USING btree (email);


--
-- Name: index_admins_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admins_on_reset_password_token ON admins USING btree (reset_password_token);


--
-- Name: index_applicants_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_applicants_on_company_id ON applicants USING btree (company_id);


--
-- Name: index_applicants_on_freelancer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_applicants_on_freelancer_id ON applicants USING btree (freelancer_id);


--
-- Name: index_applicants_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_applicants_on_job_id ON applicants USING btree (job_id);


--
-- Name: index_audits_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_audits_on_created_at ON audits USING btree (created_at);


--
-- Name: index_audits_on_request_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_audits_on_request_uuid ON audits USING btree (request_uuid);


--
-- Name: index_change_orders_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_change_orders_on_company_id ON change_orders USING btree (company_id);


--
-- Name: index_change_orders_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_change_orders_on_job_id ON change_orders USING btree (job_id);


--
-- Name: index_companies_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_companies_on_confirmation_token ON companies USING btree (confirmation_token);


--
-- Name: index_companies_on_disabled; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_disabled ON companies USING btree (disabled);


--
-- Name: index_companies_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_companies_on_email ON companies USING btree (email);


--
-- Name: index_companies_on_job_markets; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_job_markets ON companies USING btree (job_markets);


--
-- Name: index_companies_on_manufacturer_tags; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_manufacturer_tags ON companies USING btree (manufacturer_tags);


--
-- Name: index_companies_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_name ON companies USING btree (name);


--
-- Name: index_companies_on_plan_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_plan_id ON companies USING btree (plan_id);


--
-- Name: index_companies_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_companies_on_reset_password_token ON companies USING btree (reset_password_token);


--
-- Name: index_companies_on_technical_skill_tags; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_technical_skill_tags ON companies USING btree (technical_skill_tags);


--
-- Name: index_company_reviews_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_company_reviews_on_company_id ON company_reviews USING btree (company_id);


--
-- Name: index_company_reviews_on_freelancer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_company_reviews_on_freelancer_id ON company_reviews USING btree (freelancer_id);


--
-- Name: index_company_reviews_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_company_reviews_on_job_id ON company_reviews USING btree (job_id);


--
-- Name: index_freelancer_reviews_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_freelancer_reviews_on_company_id ON freelancer_reviews USING btree (company_id);


--
-- Name: index_freelancer_reviews_on_freelancer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_freelancer_reviews_on_freelancer_id ON freelancer_reviews USING btree (freelancer_id);


--
-- Name: index_freelancer_reviews_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_freelancer_reviews_on_job_id ON freelancer_reviews USING btree (job_id);


--
-- Name: index_freelancers_on_area; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_freelancers_on_area ON freelancers USING btree (area);


--
-- Name: index_freelancers_on_available; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_freelancers_on_available ON freelancers USING btree (available);


--
-- Name: index_freelancers_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_freelancers_on_confirmation_token ON freelancers USING btree (confirmation_token);


--
-- Name: index_freelancers_on_disabled; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_freelancers_on_disabled ON freelancers USING btree (disabled);


--
-- Name: index_freelancers_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_freelancers_on_email ON freelancers USING btree (email);


--
-- Name: index_freelancers_on_job_functions; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_freelancers_on_job_functions ON freelancers USING btree (job_functions);


--
-- Name: index_freelancers_on_job_markets; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_freelancers_on_job_markets ON freelancers USING btree (job_markets);


--
-- Name: index_freelancers_on_manufacturer_tags; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_freelancers_on_manufacturer_tags ON freelancers USING btree (manufacturer_tags);


--
-- Name: index_freelancers_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_freelancers_on_name ON freelancers USING btree (name);


--
-- Name: index_freelancers_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_freelancers_on_reset_password_token ON freelancers USING btree (reset_password_token);


--
-- Name: index_freelancers_on_technical_skill_tags; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_freelancers_on_technical_skill_tags ON freelancers USING btree (technical_skill_tags);


--
-- Name: index_friend_invites_on_freelancer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friend_invites_on_freelancer_id ON friend_invites USING btree (freelancer_id);


--
-- Name: index_identities_on_loginable_type_and_loginable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_identities_on_loginable_type_and_loginable_id ON identities USING btree (loginable_type, loginable_id);


--
-- Name: index_identities_on_loginable_type_and_provider_and_uid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_identities_on_loginable_type_and_provider_and_uid ON identities USING btree (loginable_type, provider, uid);


--
-- Name: index_jobs_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_company_id ON jobs USING btree (company_id);


--
-- Name: index_jobs_on_manufacturer_tags; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_manufacturer_tags ON jobs USING btree (manufacturer_tags);


--
-- Name: index_jobs_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_project_id ON jobs USING btree (project_id);


--
-- Name: index_messages_on_authorable_type_and_authorable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_messages_on_authorable_type_and_authorable_id ON messages USING btree (authorable_type, authorable_id);


--
-- Name: index_messages_on_receivable_type_and_receivable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_messages_on_receivable_type_and_receivable_id ON messages USING btree (receivable_type, receivable_id);


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
-- Name: index_pages_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pages_on_slug ON pages USING btree (slug);


--
-- Name: index_payments_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payments_on_company_id ON payments USING btree (company_id);


--
-- Name: index_payments_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payments_on_job_id ON payments USING btree (job_id);


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
-- Name: index_quotes_on_applicant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_quotes_on_applicant_id ON quotes USING btree (applicant_id);


--
-- Name: index_quotes_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_quotes_on_company_id ON quotes USING btree (company_id);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_meta_id_and_meta_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_meta_id_and_meta_type ON users USING btree (meta_id, meta_type);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: user_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_index ON audits USING btree (user_id, user_type);


--
-- Name: company_reviews fk_rails_05756653f5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY company_reviews
    ADD CONSTRAINT fk_rails_05756653f5 FOREIGN KEY (job_id) REFERENCES jobs(id);


--
-- Name: payments fk_rails_0fc68a9316; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY payments
    ADD CONSTRAINT fk_rails_0fc68a9316 FOREIGN KEY (company_id) REFERENCES companies(id);


--
-- Name: jobs fk_rails_1977e8b5a6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY jobs
    ADD CONSTRAINT fk_rails_1977e8b5a6 FOREIGN KEY (project_id) REFERENCES projects(id);


--
-- Name: freelancer_reviews fk_rails_2d750cb05f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY freelancer_reviews
    ADD CONSTRAINT fk_rails_2d750cb05f FOREIGN KEY (freelancer_id) REFERENCES freelancers(id);


--
-- Name: companies fk_rails_2e8c071a79; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY companies
    ADD CONSTRAINT fk_rails_2e8c071a79 FOREIGN KEY (plan_id) REFERENCES plans(id);


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
-- Name: company_reviews fk_rails_54727610ca; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY company_reviews
    ADD CONSTRAINT fk_rails_54727610ca FOREIGN KEY (company_id) REFERENCES companies(id);


--
-- Name: applicants fk_rails_7283c3d901; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY applicants
    ADD CONSTRAINT fk_rails_7283c3d901 FOREIGN KEY (company_id) REFERENCES companies(id);


--
-- Name: quotes fk_rails_9b32fbc45b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY quotes
    ADD CONSTRAINT fk_rails_9b32fbc45b FOREIGN KEY (company_id) REFERENCES companies(id);


--
-- Name: freelancer_reviews fk_rails_ab5db9ea44; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY freelancer_reviews
    ADD CONSTRAINT fk_rails_ab5db9ea44 FOREIGN KEY (company_id) REFERENCES companies(id);


--
-- Name: jobs fk_rails_b34da78090; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY jobs
    ADD CONSTRAINT fk_rails_b34da78090 FOREIGN KEY (company_id) REFERENCES companies(id);


--
-- Name: payments fk_rails_b35f361f8d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY payments
    ADD CONSTRAINT fk_rails_b35f361f8d FOREIGN KEY (job_id) REFERENCES jobs(id);


--
-- Name: change_orders fk_rails_b3bebfe084; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY change_orders
    ADD CONSTRAINT fk_rails_b3bebfe084 FOREIGN KEY (company_id) REFERENCES companies(id);


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
-- Name: company_reviews fk_rails_dfd5a40d4e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY company_reviews
    ADD CONSTRAINT fk_rails_dfd5a40d4e FOREIGN KEY (freelancer_id) REFERENCES freelancers(id);


--
-- Name: freelancer_reviews fk_rails_f184aba2e9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY freelancer_reviews
    ADD CONSTRAINT fk_rails_f184aba2e9 FOREIGN KEY (job_id) REFERENCES jobs(id);


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
('20180508222720'),
('20180508223949'),
('20180509110048');


