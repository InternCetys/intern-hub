--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1
-- Dumped by pg_dump version 14.5 (Homebrew)

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
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_graphql IS 'GraphQL support';


--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: pgsodium; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA pgsodium;


ALTER SCHEMA pgsodium OWNER TO postgres;

--
-- Name: pgsodium; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgsodium WITH SCHEMA pgsodium;


--
-- Name: EXTENSION pgsodium; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgsodium IS 'Pgsodium is a modern cryptography library for Postgres.';


--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: pgjwt; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgjwt WITH SCHEMA extensions;


--
-- Name: EXTENSION pgjwt; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgjwt IS 'JSON Web Token API for Postgresql';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: ProblemDifficulty; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."ProblemDifficulty" AS ENUM (
    'EASY',
    'MEDIUM',
    'HARD',
    'INSANE'
);


ALTER TYPE public."ProblemDifficulty" OWNER TO postgres;

--
-- Name: ProblemStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."ProblemStatus" AS ENUM (
    'SOLVED',
    'ATTEMPTED',
    'NOT_ATTEMPTED'
);


ALTER TYPE public."ProblemStatus" OWNER TO postgres;

--
-- Name: ResourceType; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."ResourceType" AS ENUM (
    'SLIDES',
    'VIDEO',
    'PDF',
    'DOCUMENT',
    'OTHER'
);


ALTER TYPE public."ResourceType" OWNER TO postgres;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  	coalesce(
		nullif(current_setting('request.jwt.claim.email', true), ''),
		(nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
	)::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  	coalesce(
		nullif(current_setting('request.jwt.claim.role', true), ''),
		(nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
	)::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  	coalesce(
		nullif(current_setting('request.jwt.claim.sub', true), ''),
		(nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
	)::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: postgres
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  schema_is_cron bool;
BEGIN
  schema_is_cron = (
    SELECT n.nspname = 'cron'
    FROM pg_event_trigger_ddl_commands() AS ev
    LEFT JOIN pg_catalog.pg_namespace AS n
      ON ev.objid = n.oid
  );

  IF schema_is_cron
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option; 

  END IF;

END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO postgres;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: postgres
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN

        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

		-- This hook executes when `graphql.resolve` is created. That is not necessarily the last
		-- function in the extension so we need to grant permissions on existing entities AND
		-- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
		alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: postgres
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
    ALTER function net.http_collect_response(request_id bigint, async boolean) SECURITY DEFINER;

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
    ALTER function net.http_collect_response(request_id bigint, async boolean) SET search_path = net;

    REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
    REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
    REVOKE ALL ON FUNCTION net.http_collect_response(request_id bigint, async boolean) FROM PUBLIC;

    GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    GRANT EXECUTE ON FUNCTION net.http_collect_response(request_id bigint, async boolean) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO postgres;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: postgres
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: postgres
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RAISE WARNING 'PgBouncer auth request: %', p_usename;

    RETURN QUERY
    SELECT usename::TEXT, passwd::TEXT FROM pg_catalog.pg_shadow
    WHERE usename = p_usename;
END;
$$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO postgres;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
	select string_to_array(name, '/') into _parts;
	select _parts[array_length(_parts,1)] into _filename;
	-- @todo return the last part instead of 2
	return split_part(_filename, '.', 2);
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[1:array_length(_parts,1)-1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
  v_order_by text;
  v_sort_order text;
begin
  case
    when sortcolumn = 'name' then
      v_order_by = 'name';
    when sortcolumn = 'updated_at' then
      v_order_by = 'updated_at';
    when sortcolumn = 'created_at' then
      v_order_by = 'created_at';
    when sortcolumn = 'last_accessed_at' then
      v_order_by = 'last_accessed_at';
    else
      v_order_by = 'name';
  end case;

  case
    when sortorder = 'asc' then
      v_sort_order = 'asc';
    when sortorder = 'desc' then
      v_sort_order = 'desc';
    else
      v_sort_order = 'asc';
  end case;

  v_order_by = v_order_by || ' ' || v_sort_order;

  return query execute
    'with folders as (
       select path_tokens[$1] as folder
       from storage.objects
         where objects.name ilike $2 || $3 || ''%''
           and bucket_id = $4
           and array_length(regexp_split_to_array(objects.name, ''/''), 1) <> $1
       group by folder
       order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(regexp_split_to_array(objects.name, ''/''), 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone character varying(15) DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change character varying(15) DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: Account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Account" (
    id text NOT NULL,
    "userId" text NOT NULL,
    type text NOT NULL,
    provider text NOT NULL,
    "providerAccountId" text NOT NULL,
    refresh_token text,
    access_token text,
    expires_at integer,
    token_type text,
    scope text,
    id_token text,
    session_state text
);


ALTER TABLE public."Account" OWNER TO postgres;

--
-- Name: Attendance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Attendance" (
    id text NOT NULL,
    date date DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Attendance" OWNER TO postgres;

--
-- Name: AttendanceOnUsers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."AttendanceOnUsers" (
    "userId" text NOT NULL,
    "attendanceId" text NOT NULL
);


ALTER TABLE public."AttendanceOnUsers" OWNER TO postgres;

--
-- Name: InternSession; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."InternSession" (
    id text NOT NULL,
    title text NOT NULL,
    date date DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."InternSession" OWNER TO postgres;

--
-- Name: Problem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Problem" (
    id text NOT NULL,
    title text NOT NULL,
    link text NOT NULL,
    "weekId" text NOT NULL,
    difficulty public."ProblemDifficulty" NOT NULL
);


ALTER TABLE public."Problem" OWNER TO postgres;

--
-- Name: Resource; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Resource" (
    id text NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    link text NOT NULL,
    type public."ResourceType" NOT NULL,
    date date DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "internSessionId" text
);


ALTER TABLE public."Resource" OWNER TO postgres;

--
-- Name: Session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Session" (
    id text NOT NULL,
    "sessionToken" text NOT NULL,
    "userId" text NOT NULL,
    expires timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Session" OWNER TO postgres;

--
-- Name: User; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."User" (
    id text NOT NULL,
    name text,
    email text,
    "emailVerified" timestamp(3) without time zone,
    image text,
    "isInternMember" boolean DEFAULT false,
    admin boolean DEFAULT false NOT NULL
);


ALTER TABLE public."User" OWNER TO postgres;

--
-- Name: UserStatusOnProblem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."UserStatusOnProblem" (
    "userId" text NOT NULL,
    "problemId" text NOT NULL,
    status public."ProblemStatus" NOT NULL
);


ALTER TABLE public."UserStatusOnProblem" OWNER TO postgres;

--
-- Name: VerificationToken; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."VerificationToken" (
    identifier text NOT NULL,
    token text NOT NULL,
    expires timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."VerificationToken" OWNER TO postgres;

--
-- Name: Week; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Week" (
    id text NOT NULL,
    title text NOT NULL,
    number integer NOT NULL
);


ALTER TABLE public."Week" OWNER TO postgres;

--
-- Name: WeekResource; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."WeekResource" (
    id text NOT NULL,
    title text NOT NULL,
    type public."ResourceType" NOT NULL,
    link text NOT NULL,
    "weekId" text NOT NULL
);


ALTER TABLE public."WeekResource" OWNER TO postgres;

--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO postgres;

--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at) FROM stdin;
\.


--
-- Data for Name: key; Type: TABLE DATA; Schema: pgsodium; Owner: postgres
--

COPY pgsodium.key (id, status, created, expires, key_type, key_id, key_context, comment, user_data) FROM stdin;
ed81f770-2c2e-4e89-a64b-a6c7b1dfac1b	default	2022-08-22 07:44:16.9012	\N	\N	1	\\x7067736f6469756d	This is the default key used for vault.secrets	\N
\.


--
-- Data for Name: Account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Account" (id, "userId", type, provider, "providerAccountId", refresh_token, access_token, expires_at, token_type, scope, id_token, session_state) FROM stdin;
cl7ntgcl3003609mlgvwhibkk	cl7ntgcal002809mlb984j3l8	oauth	google	114723963765916538565	\N	ya29.a0AVA9y1vgomy2ftA7zCZwf0ifQNK9t-hPCvdCExDgxkc-2-M-H_maOsnNogr3VZsFnv4RNmm1LCKJzpx4fH0eZ2XnAPTfXcdHfIYM4sv2m5h2bcBXwGlowPbtLYW3Z82ObAM1QW4IYV5qM5eZlxlSg6Q3o1T4aCgYKATASAQASFQE65dr8uRSmSI-z5p9y7sRbyjkJ4Q0163	1662328714	Bearer	https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile openid	eyJhbGciOiJSUzI1NiIsImtpZCI6ImU4NDdkOTk0OGU4NTQ1OTQ4ZmE4MTU3YjczZTkxNWM1NjczMDJkNGUiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTQ3MjM5NjM3NjU5MTY1Mzg1NjUiLCJoZCI6ImNldHlzLmVkdS5teCIsImVtYWlsIjoiZGFuaWVsLmJhcm9jaW9AY2V0eXMuZWR1Lm14IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJQeXlrTnlGSFEwU1JaWncySEZqd3Z3IiwibmFtZSI6IkRBTklFTCBCQVJPQ0lPIiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hL0FJdGJ2bW02LWU2N3hZbnY3Z1BWMVVGbU9LR0llSW1zWUhfV3FXc0twc3hKPXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6IkRBTklFTCIsImZhbWlseV9uYW1lIjoiQkFST0NJTyIsImxvY2FsZSI6ImVuIiwiaWF0IjoxNjYyMzI1MTE1LCJleHAiOjE2NjIzMjg3MTV9.I5ipeQGfSM76DGfgk31op9h_1o9LTgwlzwgfmNwnilfT2n7h3DWfwB5RpMSwTJMr6-5pBELpq5KTSLI9D7hpU5AhefFRR3HmgJHqy8kuSg-I4cg-_jNouRs8R3flKsFUSHNp_6LvHJxcI5OkSgquT8Nd-SLzxA2r5tVRIP3Z8MJdeZUjlG2qXI4w_lcLIk1qmdPEWplibTw5ok2-r0HuBX8u6vXXU3HlBgFkM1krjkUbl-jsOR2lIJdM-ZOjxEbmd6_71-Vz49cfFiMtLw7Uhk-d5whqqlGtD47iV0eTLW9y0wiE-02tcDVHTNDuhO43wnsMqMNxQ_y6ikBrW9DZoA	\N
cl7ockgqk001309mpcw5tknu8	cl7ockgg0000609mp51u3qnpn	oauth	google	112832258745028919846	\N	ya29.a0AVA9y1udNd6SHbcdq3alnj2wJ6PpegyBAFUQyVtr2G-aGWahMz7lhfcrwUamYFYofNzmcTvfXW_wtoTQVpS1Gmuv3cD3cBkwMKtV0rmrF9dU86AIBRRBoiCX9wJMqLVl877Q7wpBaq7YAMP5MfawYSnDSOYhaCgYKATASAQASFQE65dr8s2llhu9TcTxQC4XcbjVmLQ0163	1662360818	Bearer	openid https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile	eyJhbGciOiJSUzI1NiIsImtpZCI6ImU4NDdkOTk0OGU4NTQ1OTQ4ZmE4MTU3YjczZTkxNWM1NjczMDJkNGUiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTI4MzIyNTg3NDUwMjg5MTk4NDYiLCJoZCI6ImNldHlzLmVkdS5teCIsImVtYWlsIjoiYWRyaWFuLmZlcm5hbmRlekBjZXR5cy5lZHUubXgiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiYXRfaGFzaCI6ImFEMHdQTVFGZE5vSG0wNThLWndlWlEiLCJuYW1lIjoiT1NDQVIgRkVSTkFOREVaIiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hLS9BRmRadWNxbDh0T2UyaFlad0lESTRPVXQxaDJuRkZsZ3JtRXB5ajFpeWMyWD1zOTYtYyIsImdpdmVuX25hbWUiOiJPU0NBUiIsImZhbWlseV9uYW1lIjoiRkVSTkFOREVaIiwibG9jYWxlIjoiZW4iLCJpYXQiOjE2NjIzNTcyMTksImV4cCI6MTY2MjM2MDgxOX0.bBwH963ScZoGoILbXSOx0IgR_lyb3QCxPyL01MBkLCY46mFsCdkKbymf-aex6_HtDXRVFalRiSF9lIB0PUv3XkOP0J4QQ7B9ZJLY98YdakDIGKC2b8P5I0pKO9OIyl_qhrXY1zuOs6C4beg3xZHjJksr3EYdR3GAQK5qkHQB6eax2sIJRx_Wprdi9FxyEjnajEDp_0mFjUenLql1zCbOKBj_dc-vtNTXdckvONtL33n03PRqsMXFzTCTtPkX-p8luqIP-MHu3MjfwVl7Ij2z8Bz-AGlE_vTmXs-VdoOzBxFfJlfD4qz6QiLfhBWa1Etx4yhSJc7vkdXJzl0xImxXUQ	\N
cl7owks0l002309jo2oq4v7vn	cl7owkrq9001509jo69570crb	oauth	google	106403282935431266813	\N	ya29.a0AVA9y1tgX5xkub8Ph69rjqermeWsRDwvSeCcO5YKFi0lTLLF2jF9tr81ApiZr3QHfPVc-lT84Gnq-88hL8PhBKRwVz-UWvMBJ7M9nL8dFrd8Xrj7dXS4XT2F4Ge5LaBIcmXliLfT7gVh3mv7ZPZQmijr4fHkaCgYKATASAQASFQE65dr8UBPRXyt6VxdpH6MpvMU-SQ0163	1662394425	Bearer	https://www.googleapis.com/auth/userinfo.profile openid https://www.googleapis.com/auth/userinfo.email	eyJhbGciOiJSUzI1NiIsImtpZCI6ImU4NDdkOTk0OGU4NTQ1OTQ4ZmE4MTU3YjczZTkxNWM1NjczMDJkNGUiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDY0MDMyODI5MzU0MzEyNjY4MTMiLCJoZCI6ImNldHlzLmVkdS5teCIsImVtYWlsIjoic3RlcGhhbmlhLnJhbW9zQGNldHlzLmVkdS5teCIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJhdF9oYXNoIjoia2Q0bnkzTU5wWjJDVXUya2IyLXZkQSIsIm5hbWUiOiJTVEVQSEFOSUEgUkFNT1MiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EvQUl0YnZtblotTkRGc05nS0RQWC1KVlowcjI4TE1NRmhENG15eEVyLUIzcjY9czk2LWMiLCJnaXZlbl9uYW1lIjoiU1RFUEhBTklBIiwiZmFtaWx5X25hbWUiOiJSQU1PUyIsImxvY2FsZSI6ImVuIiwiaWF0IjoxNjYyMzkwODI2LCJleHAiOjE2NjIzOTQ0MjZ9.TchxMtAxgyFqR4fEbS1c2I8DKqZpPM1byNQ8kGCXC1uzEfNe4dk6jvjYFskjRh3FxRmVu7PY9NZELB-RsHuLmSu5VExj3rI7XwOB9AlBhs-U-KDj8ARCqblUBU_Mq1nPyARj56GI974ZiT8CLKjIjl2GSAf2p6epiIjEOssEpMZIQ2H5jVEjsVCT9C0duX0x3t1NbgBXAHTDmbJ8GqA_GXbteXU-utQ9QNJzYhVzNTVbMahoi7MEaZ1KR-tx4O2NDirVFKQ8F7MZAgdZsMy_XT4-NactHxrO9mATYtEqF4i5diiJE2pQON2wB4pxOA4Ii1CRAcKsIIlc6nmOqJwktg	\N
cl7owl6gg007109jog8hptv83	cl7owl69j006309jobjdpggxr	oauth	google	115664355030412031064	\N	ya29.a0AVA9y1sLtBYMx9GZvzsWN9Bm7kL-yE-vURHeiP4kGbVt0pzSt9X08UP60xn9RdTBbYoLxmp3VWkhekdIvTa0jxXk9OAGs6G5aaC75RE7IkN53RCUR_szsLyTYhmq0ZAyY_MhWccM55YYWcS5xZ5bLiAPFKMkaCgYKATASAQASFQE65dr8uUQmQhSnPn550iTbbg1Bng0163	1662394444	Bearer	openid https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile	eyJhbGciOiJSUzI1NiIsImtpZCI6ImU4NDdkOTk0OGU4NTQ1OTQ4ZmE4MTU3YjczZTkxNWM1NjczMDJkNGUiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTU2NjQzNTUwMzA0MTIwMzEwNjQiLCJoZCI6ImNldHlzLmVkdS5teCIsImVtYWlsIjoibWFyaW9hbGJlcnRvLmJhcnJlcmFAY2V0eXMuZWR1Lm14IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJYaFB6aEctWTRjMnFxM3lqWE9XdGlnIiwibmFtZSI6Ik1hcmlvIEJhcnJlcmEiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EvQUl0YnZtbFloNXZKZXBRZGxRZzVxZ1pOYUwtVVkyUWRXcnNiTV9TVzdvd3M9czk2LWMiLCJnaXZlbl9uYW1lIjoiTWFyaW8iLCJmYW1pbHlfbmFtZSI6IkJhcnJlcmEiLCJsb2NhbGUiOiJlbiIsImlhdCI6MTY2MjM5MDg0NSwiZXhwIjoxNjYyMzk0NDQ1fQ.l2e3Lc9EwbVFqRXHIpR0GKP9f4WqzBNMT4Ftg7rZ_qI0lLz3qT4UV6M4S24yo_6qAgusVanrVgbFdUUZjy8xGzkno7m07fLq_86kBmGqgLd9E-NTxGBw8VfC1i5iy1-MTIwNt6FYxelMiTrsOzS56KN1O3ff7b9C6EYs-L2AenlyH4dzFp3JAk4R6uTuXMxXwSdkD211eK_oWQyZ44-1ln6X7BLtzuYqi25AYe72tY-55IVWTA_314GIGUw_SJeFnHJSD0xAVztGytRDT6cfGIW5Nd0GN2dxtekhmVxRx2XVYYyseIl0nGd6bcT5jglbFPzGdkZljA-NtaS213dxuA	\N
cl7owmb67009609jovo7x6yyj	cl7owmazc008909johk5np8an	oauth	google	110445092878993471456	\N	ya29.a0AVA9y1sgR0uLtqp6CIR3tZyIssQEGJuDpfMYaR64YpllPdgC-HaT_HdIYqHsNc0bvPDmYOP2uoUYJCpXIBA0ECQ1SifEmEsCiBKzr4_8xspNQnOUmp73DNzEMl5x5v90Be5PRHNJ6H6oKrDv7pIMaoQ9uNYbaCgYKATASAQASFQE65dr8IArgGW8UZtu1lCsAJJ2cEQ0163	1662394497	Bearer	openid https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile	eyJhbGciOiJSUzI1NiIsImtpZCI6ImU4NDdkOTk0OGU4NTQ1OTQ4ZmE4MTU3YjczZTkxNWM1NjczMDJkNGUiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTA0NDUwOTI4Nzg5OTM0NzE0NTYiLCJoZCI6ImNldHlzLmVkdS5teCIsImVtYWlsIjoiYXhlbC5jYWxkZXJhQGNldHlzLmVkdS5teCIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJhdF9oYXNoIjoiRllCbzF2SENTU3Y3MDJianB0V2VsdyIsIm5hbWUiOiJBWEVMIENBTERFUkEiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EvQUl0YnZtbDAwOTJJTGdnUUZnTlVCTC1FTVBGcVRGQjNaWlM3XzlZa3RadkU9czk2LWMiLCJnaXZlbl9uYW1lIjoiQVhFTCIsImZhbWlseV9uYW1lIjoiQ0FMREVSQSIsImxvY2FsZSI6ImVuIiwiaWF0IjoxNjYyMzkwODk4LCJleHAiOjE2NjIzOTQ0OTh9.WapyAa-227U9BV90WqJnBOkGM5kgnd-pqcq6sZEFDXWbNSkNLXlFdrv12P0ZlxXpRJ3vIVRKyWW_tDdYanlnRrGcDfkPtfsVpR06Zpa6v1u2Oc66KKAqX9edmoRSoNOpaxAs1bQMHWQ1uNYPxtuyddnJdpHi8KX1MtxDy_tZVjdysIjwJjdBgB1ln15OR4nW5CNVsj3PwRKWmgn257aubF8nfHZ-Z-gva8WsYbFQXuv8bT7NV3DpNuDBuTvqBlM-2_64J2qBMi4Jzc7KXeoez-yd8zsMj9bTip4lR8LN1Z7ZrY577IFGP_6jVGeK8MvczHZZe67vbYSqLipIh9DGkg	\N
cl7owo3qb015109jov0etwudx	cl7owo3jc014309johavu019g	oauth	google	110950140675092709283	\N	ya29.a0AVA9y1sEy6XGGNaxLe4HgSDp9RlzSOZnyuvJITii_lBoS5vEXl_loydXCH9d5sh35Dr8QKDvPK47hJ0qhiOgH8zWGJg6atN_xNFpcF6bqUaBKvKzmWvwZLctp7Wqm3GnY57SXQB3x8104fBzOKHh8OBLH5NZaCgYKATASAQASFQE65dr8zHyqy_VAwq5EbbSNk0lyhQ0163	1662394581	Bearer	https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile openid	eyJhbGciOiJSUzI1NiIsImtpZCI6ImU4NDdkOTk0OGU4NTQ1OTQ4ZmE4MTU3YjczZTkxNWM1NjczMDJkNGUiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTA5NTAxNDA2NzUwOTI3MDkyODMiLCJoZCI6ImNldHlzLmVkdS5teCIsImVtYWlsIjoib3NjYXIuZW5jaW5hc0BjZXR5cy5lZHUubXgiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiYXRfaGFzaCI6IklkN29hUEQtX1hLZmN4MUlBQ2NHMlEiLCJuYW1lIjoiT3NjYXIgRW5jaW5hcyIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS9BSXRidm1uSlEzOXdWeEtETVN5NW5UNW1RTVhJalFWNE41SFdKN3VvVzRvUz1zOTYtYyIsImdpdmVuX25hbWUiOiJPc2NhciIsImZhbWlseV9uYW1lIjoiRW5jaW5hcyIsImxvY2FsZSI6ImVuIiwiaWF0IjoxNjYyMzkwOTgyLCJleHAiOjE2NjIzOTQ1ODJ9.1L71nWGVxEOA2W9yYOZHTrXZsZ4BJsL_VqmCkGwdxhroB_bKt7T521QrjWAH4t9rD1LFhSDohp3bl2cZCgqT7Q6M9rES94u85_aIH2eSWM3uq-h_2QJj5AqQbtL_GQfl6Y4Bh9iBMKMV5SAUhzG7DZ0d3pU910t_zBa4FgXdsWaUHgT9vbBlIeH6z2cxOYT1CMGseWisrhkWKNIWFEkGCORHP6eg0QZJvT98DBjKq5CMW0VE6TlMKlhtW6HmViqw7gz8jRX2oVjYtQm85Jk1b1ekSNeUYbetFhipQqxCIlT_KDN8670MZeXJSJq8V4YSaUwcHM2gWRuF_AKKML6jmQ	\N
cl7owoxe3001709l90ow7qvtl	cl7owox3p000909l9t6bz7354	oauth	google	111810622689569888420	\N	ya29.a0AVA9y1tvlE2h7Z4MwUt_5rDPb3Sya-yYHBK3NMAS739XaPSVduevOskWWESsJ6Q5bnas1ZrbylARGWTCHn_38TowHjElt_UYQ-lVVCEseSZvqQ7QgLx5mE6BELgYF2SaVFv1PMm_fcBsVccHBD4i0sNP71I8aCgYKATASAQASFQE65dr8jO126fqT2IYRzHexZcv7HQ0163	1662394619	Bearer	https://www.googleapis.com/auth/userinfo.profile openid https://www.googleapis.com/auth/userinfo.email	eyJhbGciOiJSUzI1NiIsImtpZCI6ImU4NDdkOTk0OGU4NTQ1OTQ4ZmE4MTU3YjczZTkxNWM1NjczMDJkNGUiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTE4MTA2MjI2ODk1Njk4ODg0MjAiLCJoZCI6ImNldHlzLmVkdS5teCIsImVtYWlsIjoic2FudGlhZ28ucG1AY2V0eXMuZWR1Lm14IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJBT1hrMXFPR2l5YjJMOWtybmZ1bXJBIiwibmFtZSI6IlNBTlRJQUdPIFBFUkVaIE1BUklTQ0FMIiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hLS9BRmRadWNwdWo3eEdTLUJtd2djWHlLckoxalAyNU9qRE13aE5FM05QNHVPVz1zOTYtYyIsImdpdmVuX25hbWUiOiJTQU5USUFHTyIsImZhbWlseV9uYW1lIjoiUEVSRVogTUFSSVNDQUwiLCJsb2NhbGUiOiJlbiIsImlhdCI6MTY2MjM5MTAyMCwiZXhwIjoxNjYyMzk0NjIwfQ.YGdE3kg5DhYePHDenmhD-EFMMcwnwnxqggzN05R1gdar_q4YQuhCMyi7MG8MYNFuGvuzinNvc8ErkY17RTIQZL7JyIJLJ8IfnK71SI_taz0omd7ULB1Geso7LZK2OVi-o8qw5PeeFratA-iuaXuB6ppAzoqWdmDj5--sGBpmdbYB5UcYWdSHyejt6MVG62Vv9KhqEAuJMB3tCHFP7irCxFYxqz2LTkQ-_gsvJu1ZtRbutI8_Q9gJKNMr-a4oIdyodoXqHW2nE5XNd0wCAx1cQnT2XX3I8JoSvIjefWBK7AsVf-BDJpL925lp8ca7rouWej1ogDSHvJt0Dsp4QEGhTQ	\N
cl7owr428004209l9p0nuqb28	cl7owr3vg003509l9j91ooimd	oauth	google	102050210230878731358	\N	ya29.a0AVA9y1vSlYX7GLDX_aIEnkAp1jQ3XFG1LvDv3wBHxOH_lR5T1zi367B6GtgR3l2iYhsRiTcm9Hle6vDAYe8ow7DLzpjUc9cxdhd47qcZTz1EnZOdvnR8AGf3op5bIyVDUh64R6g3sOM2csppFQAShQVZNC8eaCgYKATASAQASFQE65dr8x8aqeztC_vwInobI8RmrBw0163	1662394721	Bearer	https://www.googleapis.com/auth/userinfo.profile openid https://www.googleapis.com/auth/userinfo.email	eyJhbGciOiJSUzI1NiIsImtpZCI6ImU4NDdkOTk0OGU4NTQ1OTQ4ZmE4MTU3YjczZTkxNWM1NjczMDJkNGUiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDIwNTAyMTAyMzA4Nzg3MzEzNTgiLCJoZCI6ImNldHlzLmVkdS5teCIsImVtYWlsIjoiYW5heC5zYWxjZWRvQGNldHlzLmVkdS5teCIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJhdF9oYXNoIjoicjBXQzh0YndfYUQ1V2IzczhwYkNwUSIsIm5hbWUiOiJBTkEgU0FMQ0VETyIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS9BSXRidm1rLTN3Sno0c3RacWxWbmRhYkYydkJZdDRwT3RYRVhXNHpmbmt2YT1zOTYtYyIsImdpdmVuX25hbWUiOiJBTkEiLCJmYW1pbHlfbmFtZSI6IlNBTENFRE8iLCJsb2NhbGUiOiJlbiIsImlhdCI6MTY2MjM5MTEyMiwiZXhwIjoxNjYyMzk0NzIyfQ.W0-WqQSfL4CvgEZxVfAM8qF95dyYeYXFZIbmgd03yqlJLLPCMSBFrW7SfDrUcxZISZBjw1tQTbvzGLu2J-eGYRM5iFro9vtYguAYs4rwOPkgPI1n0vZWswkJiDwc3DQLnFHR05t6VHJMQnWTnAc4oVCJyL6xN44l8Yd03gFrvlttpYwKS_jke5jZON99b27kgYy2IIPmh33CitvN1YNWKQREVnoIVVcev6viPrTEnB4Jo_vLPuObMzF7Jk_VTfiVpoynEvscr4j8BZLSKu63fya4HiOhs1IUhSU1Kvc5be3ryHu6cCZgGXKny42Ql1g2HwLmIPEst0yNjHcGngPfNA	\N
cl7ox2x5n008709l9f3ss3zlq	cl7ox2wvc007909l92kd05q5h	oauth	google	101630041598426958471	\N	ya29.a0AVA9y1u0CDnYxZc9AQL1Wxvk7DJRuPl5VJUnKEgCVEJFodgFtBOswHZXI-8xC595B4WNcZatbCTUfTBM41BQH_CsI5rb5pHEva4QXCirxKQznf_HN82ui8vyCEPj6OURPdzCnKrBMOeJPZ8WSQ2gMEKMF2wNaCgYKATASAQASFQE65dr8eMGz36RxBZvQGmbtupMQeQ0163	1662395272	Bearer	https://www.googleapis.com/auth/userinfo.profile openid https://www.googleapis.com/auth/userinfo.email	eyJhbGciOiJSUzI1NiIsImtpZCI6ImU4NDdkOTk0OGU4NTQ1OTQ4ZmE4MTU3YjczZTkxNWM1NjczMDJkNGUiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDE2MzAwNDE1OTg0MjY5NTg0NzEiLCJoZCI6ImNldHlzLmVkdS5teCIsImVtYWlsIjoibHVpcy5jb25zdWVsb3NAY2V0eXMuZWR1Lm14IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJWcm93Q19NTld0WFNFWHRVU1czUFp3IiwibmFtZSI6IkxVSVMgQ09OU1VFTE9TIiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hLS9BRmRadWNwVG01Nk8tZ2trcUEzUTV3ckM3OF9GU0prdnJNam1UTXJMbXdrLT1zOTYtYyIsImdpdmVuX25hbWUiOiJMVUlTIiwiZmFtaWx5X25hbWUiOiJDT05TVUVMT1MiLCJsb2NhbGUiOiJlbiIsImlhdCI6MTY2MjM5MTY3MywiZXhwIjoxNjYyMzk1MjczfQ.wroWRstRqy2lj8QCvP6XCsPQTmpLJKDZp1URUHouZBj_51nn4596EtgjnGt4R87hPVpnaE7BSOzP4VSZyc5kBfBJ6tWDcfZPwkOWkhpsuq883ahzcVk72QqlR70i3dwH2qWzbSIRlmxY_486_XqgWXduPQUnHtazbLwoxJkRFL2Izh3VVkoGWdEoUi8rEcUzyptyXdS3VWGT-SSlC9rfh-LmzhfGlJyh66_vcyBCPjZ1KQuoj5iYowE1VjnLhnvElRvthlO5pNfa2YC1hb-DicxcnFptW8ruxUTzBoYE7zhOefpIVDpytQKQPBeK8dZPv_esMPlKgqKA8nCZ6QO3tQ	\N
cl7oxh1d8004109mt3q5z7wtn	cl7oxh131003409mt7prk0e19	oauth	google	113136935283314108403	\N	ya29.a0AVA9y1uZTZAR7Qj9CLtVIo7TePAi5qG-wR5ryzf6YUJsW9p1HcIO962vHl2KpC6n585O00PZsk6qWBucKguKupwyaVzSTGDyO-k40FS8r3OUJDKJBs0oo6QRC0VDTp5J7whWtSqQRmv7hkocoYpTes12V8QPaCgYKATASAQASFQE65dr84-2fixHnGaltKC7lrNcYrQ0163	1662395930	Bearer	openid https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile	eyJhbGciOiJSUzI1NiIsImtpZCI6ImU4NDdkOTk0OGU4NTQ1OTQ4ZmE4MTU3YjczZTkxNWM1NjczMDJkNGUiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTMxMzY5MzUyODMzMTQxMDg0MDMiLCJoZCI6ImNldHlzLmVkdS5teCIsImVtYWlsIjoic2FudGlhZ28ucmVuYXVAY2V0eXMuZWR1Lm14IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiIzYVAtQ2s1cl9uQS1GZ0VldWdSSXFnIiwibmFtZSI6IlNBTlRJQUdPIENBTUFSRU5BIiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hL0FJdGJ2bW55Y3NBVEdHcXM1X1A4Tm0xWkpjeW1FTktidjhiU1FXV2dSekhYPXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6IlNBTlRJQUdPIiwiZmFtaWx5X25hbWUiOiJDQU1BUkVOQSIsImxvY2FsZSI6ImVuIiwiaWF0IjoxNjYyMzkyMzMxLCJleHAiOjE2NjIzOTU5MzF9.2ku8J3Z1P_JQjyKCK96HQ_t_L1l_Mg2Sovr-VpEMINriqwgIKmr9cCQGMPdC5Ggxen0y515KsuU5MvvZrtueQb7Gn_HsHCZalHoRzU-WhU2ocxtY4xIkCsTsUasf7N2-2zWEFY6LBNJzx_cvVrrkjYtUp7GRtvzLkg1xvX5dcA92APonEGBYuaGBn1fgcywhkNbfeqILFCNHaagwpwmW2V6-CUfzipp_cg8V8COjJrpK0DPgmf0EmBbjjZ2r5x0WJwiQ3PuIs1PPAF8jQTN1RRIjDSIW3KVGDC3zeetnk47U0jXbZGyqYSbdT4ZP58iJeo7JXyHE6ydaKquRwN6GKw	\N
cl7oxt4rc006609mt5d8xfg0d	cl7oxt4h3005909mtd0lqua7m	oauth	google	116629417277317185403	\N	ya29.a0AVA9y1tNeL1Pb5X61cheHDoUk_BonGM8h7FHHrw2XG_YyGVGYs4H7FMyfC6ytN1LZwWFFQ3dDcl0uF7LviEGL4vf1gyb-cHHe8eXi6A7T2XTfP9N05c1t-W1zbDlpwxrRalK0kHuggRXd6qOeLiM3_hMFl4RaCgYKATASAQASFQE65dr85o6F6RW8Pup4CZiIvw6XqA0163	1662396494	Bearer	https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email openid	eyJhbGciOiJSUzI1NiIsImtpZCI6ImU4NDdkOTk0OGU4NTQ1OTQ4ZmE4MTU3YjczZTkxNWM1NjczMDJkNGUiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTY2Mjk0MTcyNzczMTcxODU0MDMiLCJoZCI6ImNldHlzLmVkdS5teCIsImVtYWlsIjoibGVzbHkucm9qYXNAY2V0eXMuZWR1Lm14IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJ4RTQ1WjRXSHBlamhLVzRfRDZUUGdRIiwibmFtZSI6IkxFU0xZIFNBUkFJIFJPSkFTIFNBTkNIRVoiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EvQUl0YnZtbEpYS1VhTzI4bHdpOGtGVFhBWnVNb3dtN2QxWUFEUmFUNERycHI9czk2LWMiLCJnaXZlbl9uYW1lIjoiTEVTTFkgU0FSQUkiLCJmYW1pbHlfbmFtZSI6IlJPSkFTIFNBTkNIRVoiLCJsb2NhbGUiOiJlbiIsImlhdCI6MTY2MjM5Mjg5NSwiZXhwIjoxNjYyMzk2NDk1fQ.UHqNpGtVgeEWvXqM9mlxiBF_2ojHISwA215L3_GhdvT0KXArI7ftYs4JuyaqZTg6xS9pmoPfhkfjCdPJ17Yv4VlFD9bjStoaG0DodyFGhDqVtXak960l8b2GSEmuF6JlHcev0MYcfTZ_7GXbloVir0QjdLlHKmqjyYwL47VFOOuMEHQ_b-pJ7OtMYBDCRQqaDpH083C3R0medoB3wVTpFSRLBbthq4YloJc7LLQ2HfWNCQ3yUa1_dKkVta7R2ZpFL9LDbJ4qRXD8HFPtpIhV5QvJXAoiElO_S0jdL5QBAhTvYxGpdsFyfzA7RYp1eEHXoPIi4HzE944B0Xk-e19DIg	\N
cl7oxwrpu008809mtbyev3vef	cl7oxwriu008109mtpvla0gpz	oauth	google	113544712528193721827	\N	ya29.a0AVA9y1uPS17wn6uTKFgaXE68JIW7f7Dy9eF2U157dYxdEuCzzO0_MpjYmyyZmqTQe7_8L2otOo9cazKPC_o_yVRTojo3DyYNte5dEdrQgkFmELZEMvqkFbAqy8wyN8xJIGlenFpLCZ1tMBvPF7nP4Esu28PMaCgYKATASAQASFQE65dr8lJK7NHi8sGHIKG__MTMgtA0163	1662396665	Bearer	https://www.googleapis.com/auth/userinfo.profile openid https://www.googleapis.com/auth/userinfo.email	eyJhbGciOiJSUzI1NiIsImtpZCI6ImU4NDdkOTk0OGU4NTQ1OTQ4ZmE4MTU3YjczZTkxNWM1NjczMDJkNGUiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTM1NDQ3MTI1MjgxOTM3MjE4MjciLCJoZCI6ImNldHlzLmVkdS5teCIsImVtYWlsIjoiYW5kcmV0dGkucGVyZXpAY2V0eXMuZWR1Lm14IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJrc2NYQnh0cXRRb05LNGxBMmdGYldnIiwibmFtZSI6IkFORFJFVFRJIFFVSVJPWiIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS9BSXRidm1tdTlKc0l1eHZod1liVzkzb1FQeVFtQXlxRDQ2MTUtbU5tS3NnYj1zOTYtYyIsImdpdmVuX25hbWUiOiJBTkRSRVRUSSIsImZhbWlseV9uYW1lIjoiUVVJUk9aIiwibG9jYWxlIjoiZW4iLCJpYXQiOjE2NjIzOTMwNjYsImV4cCI6MTY2MjM5NjY2Nn0.MtUeC5nqcKzUc3YRcfvhi434CSSBo5Uz_zcCvIFCjvs81V8S8-9u_R4GbnFywzGVxQvvEtjGjs_Pj_b4tPiXr1-2A3ylwY5nWKEG1OaHxAZ8IyxbjwMyI7HY78CYqJMxvZ3ZIBnfz66V9pztGvvaFTerE8zx1n1raEgF4o32oM5GYw1E0hI8pEpmSnHkzq1KCIw4v41z0pGiyH-FSfzxdfwCtcNH-IGUlDVUHCjJSBhD0w3hD-zJcrzYiHYMpC1jlx8yGZ1rX7qqlKeWe5Fi1hXMk84sAMlcLj576LgL6RffPRHPHIJkgvzkO5XZL6e3hMZRWjqw9PIccSRxeA7_ZA	\N
cl7oy6mkk003709jm0d8yrmat	cl7oy6ma4003009jmrak1i3vh	oauth	google	110846114040051725531	\N	ya29.a0AVA9y1sAw2SHCFohsTgR-kepiv0tP96Z80Jbg4CnIJg42krd4ci5eHFUXsB9cm0AhRLh3wV4aK7EfmfvvfEli55YRHDLXEOhattEOecLFv0zJIq67Y38Uajl9T_M1JlpM8Xbab09Brc-0Xa_fU1K-IVT7tBlaCgYKATASAQASFQE65dr8TYg4hMuQlL-bpf53523gZA0163	1662397124	Bearer	https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email openid	eyJhbGciOiJSUzI1NiIsImtpZCI6ImU4NDdkOTk0OGU4NTQ1OTQ4ZmE4MTU3YjczZTkxNWM1NjczMDJkNGUiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTA4NDYxMTQwNDAwNTE3MjU1MzEiLCJoZCI6ImNldHlzLmVkdS5teCIsImVtYWlsIjoic2d1dGllcnJlekBjZXR5cy5lZHUubXgiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiYXRfaGFzaCI6Ii1iTWFjaFZ0OHZqNVViajVpNjhuM2ciLCJuYW1lIjoiU0FOVElBR08gU0FJTloiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EvQUl0YnZtbDE1M2ZrTzl4WDk2YjkxS0E4al9LQkxCMTdYRmt2UFhENEItU3k9czk2LWMiLCJnaXZlbl9uYW1lIjoiU0FOVElBR08iLCJmYW1pbHlfbmFtZSI6IlNBSU5aIiwibG9jYWxlIjoiZW4iLCJpYXQiOjE2NjIzOTM1MjUsImV4cCI6MTY2MjM5NzEyNX0.fL1611tbobnCQjJFCRAtMnoHUsflIzervrl2VsMMYHTk61TbB2YuLQuMkdxvBLiWDwPOrGte2jpOERVuhL-FV92AtWUPOo3CBLipBQAHOnQHR-zGhwg1-t-3L3uM9bx4XeqZ_u7JA9pbwnnhfv4KdImGhacOsm-_VSJePSFDASSiJ7DaFAcXEpLzkgm9OA-UiwBJ7kSt3AT7GsUKVrRNdiLeEKfRkZ_y69eP4bwI8SUnj82-P-5svvplUUb9zwknts1g-ioZuZ2mUaM29ghAO9bs9RHIUmNR7HehEGDMDpSwyCM5C_kG0pHy4GPXXw8TDV2t6wxRWrRKCelKsAQWDw	\N
cl7oy8fwp005909jm3msjprac	cl7oy8fpr005209jmk2csn6bi	oauth	google	114346779335542498707	\N	ya29.a0AVA9y1txQWmSmThDP7fwk7ozH0NrYOUVqCybzVlEV2-e0QbAG4fVtdt8Lz-3rYLqO4e5h3cU0-Jg65FsvWtEEJE9QqngqmABezeakqPwsZ2WdGUJqgBFYp7ucg8AncZ1FMlgBreeL42e0eDGFyIykXI8Lv0naCgYKATASAQASFQE65dr8Gmbe-xi6GIpIZ8s5aenWwA0163	1662397209	Bearer	openid https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile	eyJhbGciOiJSUzI1NiIsImtpZCI6ImU4NDdkOTk0OGU4NTQ1OTQ4ZmE4MTU3YjczZTkxNWM1NjczMDJkNGUiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTQzNDY3NzkzMzU1NDI0OTg3MDciLCJoZCI6ImNldHlzLmVkdS5teCIsImVtYWlsIjoibW11bm96QGNldHlzLmVkdS5teCIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJhdF9oYXNoIjoialVMN2Fod2gtX3FpWGIyUjZkeV96dyIsIm5hbWUiOiJNYXVyaWNpbyBNdcOxb3oiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EtL0FGZFp1Y3BQUHQtcTFHNnd0R2dydzZhaUNPUy1lRDEwVUk4Z2NaNzM4YmQwPXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6Ik1hdXJpY2lvIiwiZmFtaWx5X25hbWUiOiJNdcOxb3oiLCJsb2NhbGUiOiJlbiIsImlhdCI6MTY2MjM5MzYxMCwiZXhwIjoxNjYyMzk3MjEwfQ.sIs3doZDJapDp7onab1TfWrBeh-AnnWckePByJer24YL7brjrT7ABPFNL89f_ZGLv4FxxU46-F_jTNsovtu32Bx54w1X5-2Tpx52-Ygkn-d58rV1RVaEHfldSRNg35zxb6urr6r5zkUMXNnfjurMZX1LtT-r0u2NlglFsEqw3Xgb9Q5borWMP_5pbQBu_eo_7_fe38M-fMEKrj_nVowDzl8cD8904J7YV20FQsUi3lhg40XgRYBkRUhGS3fd2eRtglGf--h0xFwJ26AQp6TLFP4zTZQk50lnefg6T8dztl7QQK0O_oX6tgma8KbWGaL43_NQMxUFvnIDUtyWmilogg	\N
cl7oy9kd4008709jmvouorisv	cl7oy9k66008009jmt1ejwux5	oauth	google	100706716769411401764	\N	ya29.a0AVA9y1tlD9hubN43MJf240BjgEfmyIyhQ81ESnSVx20DU2b2oJ-Ne43Q0LMu7RPu_BnLIMskyMxWJVdSQsh-q_qS4haCW4yGhRWFRX4RSsR7rP7uF8-UiB-OEUoBBqzybTTonayrKO1JhjJCcd5Sqcw57xvDdQaCgYKATASAQASFQE65dr8UWnvZz_He6HPijBgKaqQ7A0165	1662397262	Bearer	https://www.googleapis.com/auth/userinfo.email openid https://www.googleapis.com/auth/userinfo.profile	eyJhbGciOiJSUzI1NiIsImtpZCI6ImU4NDdkOTk0OGU4NTQ1OTQ4ZmE4MTU3YjczZTkxNWM1NjczMDJkNGUiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDA3MDY3MTY3Njk0MTE0MDE3NjQiLCJoZCI6ImNldHlzLmVkdS5teCIsImVtYWlsIjoiam9zZWEuc29saXNAY2V0eXMuZWR1Lm14IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJseThTSjJEYVZYamh1Rk5wNEtacE5RIiwibmFtZSI6IkpPU0UgU09MSVMiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EvQUl0YnZtbHhLWWxvVGVOaW80dTh3MDBzZnRZcDVpb0ZCS2JsT3Rwdjc1cz1zOTYtYyIsImdpdmVuX25hbWUiOiJKT1NFIiwiZmFtaWx5X25hbWUiOiJTT0xJUyIsImxvY2FsZSI6ImVuIiwiaWF0IjoxNjYyMzkzNjYzLCJleHAiOjE2NjIzOTcyNjN9.VbR2dtklK_8M8HBnH20dg4ViIyDG6U3Cq1zxaBQOYtgLpFi3YpdBDVgQSGL5GDgnBV5riM_476pcw6nWGmRKlCFDixrXVuACWMX4kqIki_rjeZ_U6XerlCvf1utyd3URIvlESqKa0hMxTuD5fElDC4YA39ah3_0B7gdnBDaa8zXsptNsOE0c9LVyON1bQDwd_c3VShHzbdpajXVoJ79uRvN0MNqb5rK6cD-xkRvRkdoDP5eWeYR8v4-LNFtRoZaFqj1EBce1L3yuJ36C80IxsVzVbb5LOjQY87W2PCpGS80ZDMDYboyo62bqHYr0-ICC05YUCsQFuZYStdCpsZyj_Q	\N
cl7ozygjh026309mt30v93ds9	cl7ozyg9a025609mt3bc95exq	oauth	google	117567337254975098775	\N	ya29.a0AVA9y1tF7a0QVLrE38JIYypSg3VG4qLilvC4kQYnLFWIrOlaLgCg1hkdsJ4oH4GyPDc8dmUCe243vNq3w2WlndswuwGDDYdODhNrGToTEHzqEBYGkqQvHB8usO6ZEDa-Pop1lkmPya75vmXzYx_GykY7pFCEaCgYKATASAQASFQE65dr8dWMMxewuqK-W7Wbt-kg_bw0163	1662400102	Bearer	https://www.googleapis.com/auth/userinfo.profile openid https://www.googleapis.com/auth/userinfo.email	eyJhbGciOiJSUzI1NiIsImtpZCI6ImU4NDdkOTk0OGU4NTQ1OTQ4ZmE4MTU3YjczZTkxNWM1NjczMDJkNGUiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTc1NjczMzcyNTQ5NzUwOTg3NzUiLCJoZCI6ImNldHlzLmVkdS5teCIsImVtYWlsIjoiaXRhbG8udmF6cXVlekBjZXR5cy5lZHUubXgiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiYXRfaGFzaCI6IktJZm0wWEpOQnNpMUl6TXF6T0JoanciLCJuYW1lIjoiSVRBTE8gVkFaUVVFWiIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS9BSXRidm1rem9MMkJiM1VUb1FCMThFeEFFMGRaZTBodEVvNGxsSU9vUGE3SD1zOTYtYyIsImdpdmVuX25hbWUiOiJJVEFMTyIsImZhbWlseV9uYW1lIjoiVkFaUVVFWiIsImxvY2FsZSI6ImVuIiwiaWF0IjoxNjYyMzk2NTAzLCJleHAiOjE2NjI0MDAxMDN9.IqMPFvXO8G9iJQbAbS6utPqSy3WaF6GyaAd77ijoJIakbPnpZhG4dv1n5iw9QQgjTvqB_zFX3AqbYfg8WwHRWPCVlbQKCuKpf0jNDZjb3p4j7r6tjgRgmJI56Gbdq2xdW6yFEOob_kc-epO4iPgRteDNQ8_ouUECuN7AKvH75CLCt9xBSdKk5fyCVQGBLRz0cUEfUhJPmKxYv-N3aUElR55XAdKiwz9_9vrhmQLWqI9IhDIB1dpGkAgIjidrvUjdvEe_kcQaeb-fRQnC9aRk6NhidHvoVT3T5NB0CtARTCZDQ5TrAeLA_g6ljz1fAj0GpL4R_R8Gyq6w1hoJeANElA	\N
cl7p3r9b4001409ksfyzgnuon	cl7p3r90o000609ks8nrqjbfr	oauth	google	117778673436086884601	\N	ya29.a0AVA9y1sWhjLfDvcDrDSJDlcPkJb804Gv3cycUGWMAm9zvxULJ0gW8Dc8eRF2MyMKIYx8d3nmcHyRBTQ2tmLleeEbRcEOa2gsgOmgt38jwLsZN8aHCGzWyoyb3IIz17cncQS0MOGF059lAzjxEIUXlxLrKAO9aCgYKATASAQASFQE65dr8jVP0w1n-egcnNq4W6Ecj-g0163	1662406484	Bearer	https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile openid	eyJhbGciOiJSUzI1NiIsImtpZCI6ImU4NDdkOTk0OGU4NTQ1OTQ4ZmE4MTU3YjczZTkxNWM1NjczMDJkNGUiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTc3Nzg2NzM0MzYwODY4ODQ2MDEiLCJoZCI6ImNldHlzLmVkdS5teCIsImVtYWlsIjoidmVyb25pY2EuYmFycmlvc0BjZXR5cy5lZHUubXgiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiYXRfaGFzaCI6IkFfOFV2OXVWTmtETFZOYWxMYnZta0EiLCJuYW1lIjoiVkVST05JQ0EgWUFNSUwgQUdVSUxBUiBCQVJSSU9TIiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hL0FJdGJ2bW1XTzdoT3E3MnpVUmRFN1pCd2JLa2R6N0VKTGR5Z0dzb3RreXR6PXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6IlZFUk9OSUNBIFlBTUlMIiwiZmFtaWx5X25hbWUiOiJBR1VJTEFSIEJBUlJJT1MiLCJsb2NhbGUiOiJlbiIsImlhdCI6MTY2MjQwMjg4NSwiZXhwIjoxNjYyNDA2NDg1fQ.bQGPnbhUiM97kGiYQ0SLqDuzSjfJrG5yKnxmg3m4gRD6iCsZVuxUlznTaMWIZ41cEConat0CnbhVLRaMOKQK1OcN9N3XVfZ8udWOMyzsrlk8bcXPn3guWs5Ha9BdRddb-E22fmVZ_-Ee7sLvcYLwmuqbEBwuO1wUYOApIbucPFHhcyqytjMNGNWuERuxJhNpqCom-zO4G6siroo-btA97ByGaASGfzYhdgylmtnNE8Xay1BajiohKg1M1O_QVviSxKgoi3Eb1d7jr-NhhsG63N_y9PFZT-78NbjtmeT_7I2uWgRjZ80DQruS_fe1U2h54cvda6XymJR99CTLdpJrrA	\N
cl7pd00ca001409me8fckvbyc	cl7pd001p000609mer1i32wys	oauth	google	110471174895681014107	\N	ya29.a0AVA9y1teKLnN0FFejBvxoCcEY3RLRR2cEBTEZYUDVeSeaD_dEZWQmgI4_DkZZrpzk9ck5WU1gng-II_UNkpNEP8_UlS0nqI_fl2hfIh862zkX9EXtu6fAS1SV94KX9wJvy7VNViKsfoPNkzwhWC9efilaf6vaCgYKATASAQASFQE65dr8PAmKSwXpGP9qm2ql3uZpOA0163	1662422009	Bearer	https://www.googleapis.com/auth/userinfo.profile openid https://www.googleapis.com/auth/userinfo.email	eyJhbGciOiJSUzI1NiIsImtpZCI6ImU4NDdkOTk0OGU4NTQ1OTQ4ZmE4MTU3YjczZTkxNWM1NjczMDJkNGUiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTA0NzExNzQ4OTU2ODEwMTQxMDciLCJoZCI6ImNldHlzLmVkdS5teCIsImVtYWlsIjoiZGF2aWQuZHVyYW5AY2V0eXMuZWR1Lm14IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJwbE9ocWtRVnU2SEZaN0w1bVFhT1NBIiwibmFtZSI6IkRBVklEIERVUkFOIiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hLS9BRmRadWNxRDJubm8wZGhmWGJFbzk2Q09oQ2ZJYkdUWTdpLTRybjA5VXhtWj1zOTYtYyIsImdpdmVuX25hbWUiOiJEQVZJRCIsImZhbWlseV9uYW1lIjoiRFVSQU4iLCJsb2NhbGUiOiJlbiIsImlhdCI6MTY2MjQxODQxMCwiZXhwIjoxNjYyNDIyMDEwfQ.f8XN6ZK_LMvodJ__3ZhhHMrGYUewVzNzs7xrlzoX6AbPvnFOXQXEjv2_TIhQcWyxCiYXly-OgMPCVeYs7KW_2ugjDXFUUdPDF7TncDjUcb31XkuWxII0plY_eUj8yCo6spGitVjtIFKfaFF53ObBrO9s-y_g6ENSu4nyRJlV7b7Kol-sFOHq8M-3GRYkNFjDnnNdkgsicBxjgwjyA_mXuQwan8EvBtWXPNu3sUwp9mJborbSIWyUO6d6y8ylgEFTAI6waF0wDu92SAUMluEZbHEGNTBfANRMHgNg3u_gXmXbbYjGUw3dtNqJhA-4g2PHEvj1Uxnj1iGbeJqDxKzQXg	\N
cl7pq4q4w001309lcrrpv8z0t	cl7pq4pug000609lczl0ojo17	oauth	google	103959783607961869948	\N	ya29.a0AVA9y1u9IXkR49WV4UskEAmSJjw4tx6uRmjbSWbHcrltucCOv1IbF7qahLKCeKQuoYJ32jCYitQCPgAduSRK6ZEsREXqpVMZlouFl2WTM0_MG0MurWx_V9xfUKsTFHUQkhDk4C0ZaYOwzwUJaP-IZsMpXeabaCgYKATASAQASFQE65dr8ina1vlOF-xaIkNQOXG4xaw0163	1662444064	Bearer	openid https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile	eyJhbGciOiJSUzI1NiIsImtpZCI6ImU4NDdkOTk0OGU4NTQ1OTQ4ZmE4MTU3YjczZTkxNWM1NjczMDJkNGUiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDM5NTk3ODM2MDc5NjE4Njk5NDgiLCJoZCI6ImNldHlzLmVkdS5teCIsImVtYWlsIjoiaWFuLnRhbWF5b0BjZXR5cy5lZHUubXgiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiYXRfaGFzaCI6IkNqLWM5eWlNaXU4VlRsYmdGNjVKcEEiLCJuYW1lIjoiSUFOIFRBTUFZTyIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS9BSXRidm1sVElvS1QwZXRDcDBEUXB1QzFCeWVxOXJiS3BpWVZkV09sU3ZRaz1zOTYtYyIsImdpdmVuX25hbWUiOiJJQU4iLCJmYW1pbHlfbmFtZSI6IlRBTUFZTyIsImxvY2FsZSI6ImVuIiwiaWF0IjoxNjYyNDQwNDY1LCJleHAiOjE2NjI0NDQwNjV9.k15X6YpcxHzxub5ftmgiagTFYY45RCyAHAxgd4PzQmmv_iDsovUyNEspZ4mRQi4P3lxU3vpOZw67ilxFtvK1cxbA8LKPoypCvomhvNMwIhsXwrSCsdYeI_C7G37JqOEuSjt1zDF7L7mcD43AWzlEUOgHW4sRmGUZfW5vFUYZzCACuYHBFX-cccSwzd0GTI4PnPBlrHrnDlcOoYlm02nIBN7vTj9EHa6zDCVa2G_Puw5MqlCeBjBMqCoO-WY0SRzPjRdqP8yA3GLgqcDaGYNr3C4xgmdt0tN2lWF33aKwNBQwPS1B5tGIZ3O5vKRdaWxSG6n1-CfOsjHLQMAC2a-DOQ	\N
cl7tk7bzs012109l9o88eblxo	cl7tk7bp9011309l9pzlkgciv	oauth	google	112035934371948587246	\N	ya29.a0AVA9y1t3py2hMIwy6EVRNrzIqcfxIAdc59GaPln6e-LRCZ8OFYRnKKKhKCPeH_-7XVKG_xlcNNK5xzCwWZdyTy1ViMG21AclVcazrMhTVaVJZggJnGUqabyAj6LABSR2B_2F5hVnReSwlSwEIthIxG51YbwWaCgYKATASAQASFQE65dr8HpP48JeU6-CNtEyK2JcEmg0163	1662675974	Bearer	openid https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile	eyJhbGciOiJSUzI1NiIsImtpZCI6ImNhYWJmNjkwODE5MTYxNmE5MDhhMTM4OTIyMGE5NzViM2MwZmJjYTEiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTIwMzU5MzQzNzE5NDg1ODcyNDYiLCJoZCI6ImNldHlzLmVkdS5teCIsImVtYWlsIjoicmFtaXJvLm51bmV6QGNldHlzLmVkdS5teCIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJhdF9oYXNoIjoieUk1TzU2TFlYMmdDaUVtUkFvdDlvZyIsIm5hbWUiOiJSYW1pcm8gTsO6w7FleiBTw6FuY2hleiIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS0vQUZkWnVjcE5kWi1WSFNtM0t4bE9ZSnZYdkdJQ19aUmNMSU9wa3R6NUhBX3pGQT1zOTYtYyIsImdpdmVuX25hbWUiOiJSYW1pcm8iLCJmYW1pbHlfbmFtZSI6Ik7DusOxZXogU8OhbmNoZXoiLCJsb2NhbGUiOiJlbiIsImlhdCI6MTY2MjY3MjM3NSwiZXhwIjoxNjYyNjc1OTc1fQ.QG265kX4-m_2IqaORaC7dtgYULeDRdBb8uZMD791C0PdXsXbFe30Bc7WnYFdb3X-IV-rWq_cdKfBPbZ9AXdlkkeXp76EobZuWlk4hZxTsukGgu9-2B91HFWy2GfM0tBhx3ffDiZuKipIlL6rMYLSrg_bIiTX9nHAhNsSJ90DGMq7kCopqilADWqVxGmsZ2IJBeMwNPa6_zpH3ioCqCDImjN17Q7m1tQHUCdw8zvoGefBLsltIyuXQjiliEAkgVojtBKoXrC5Ys0BlOgjerPuzBjl1jj7zdao8fVvL_9gxy4Z2YDXPZsUX_GV25mTJCFRk-XCqU8ClnPXkb8EgvYqJg	\N
cl7tvyglc001409l0ysqut2aw	cl7tvygb5000609l0k2902jkg	oauth	google	109611239189598643790	\N	ya29.a0AVA9y1tcbQfAjNks3NoQ0iM2QbC2Pt4MJgo9CfTzksQmuQAOjc1hgTDOP3GPTORArWkOIe1YUqVzuyJxMmr2OD-3CNPtpmrs1e9XE0fW-4NHe9gsezgdYa2k50GFGkdTumZHgAyjna1dGMEKsLy63tbDvDzLaCgYKATASAQASFQE65dr85UzejjJuBvd0J1tVRvj3hw0163	1662695714	Bearer	https://www.googleapis.com/auth/userinfo.profile openid https://www.googleapis.com/auth/userinfo.email	eyJhbGciOiJSUzI1NiIsImtpZCI6ImNhYWJmNjkwODE5MTYxNmE5MDhhMTM4OTIyMGE5NzViM2MwZmJjYTEiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDk2MTEyMzkxODk1OTg2NDM3OTAiLCJoZCI6ImNldHlzLmVkdS5teCIsImVtYWlsIjoiam9zZXBAY2V0eXMuZWR1Lm14IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJ0M0FpQ1BFSVpldFFOWkdCcFNON1h3IiwibmFtZSI6IkpPU0UgQ0VKQSIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS9BSXRidm1rVE1nOFAzdTJVODR3bF9DT0ctc0NsMXBoMHBuU0NIaktGajMxcT1zOTYtYyIsImdpdmVuX25hbWUiOiJKT1NFIiwiZmFtaWx5X25hbWUiOiJDRUpBIiwibG9jYWxlIjoiZW4iLCJpYXQiOjE2NjI2OTIxMTUsImV4cCI6MTY2MjY5NTcxNX0.PViHd-uTX4nAh6J3tB2EhmCtA0EmhDTq1j55kUpmq3XhXs8BDNVO8OsnEL9_UXxPbtitz40_sLzPTZ_9FVDwOROl1zEgxulB4y31HHjiJ0EhbYFesr6ei-WL512hYsIDFpRJSv5IAqP6wcsldNgLzvdIOft7jGb1rcEk5aAnxYC1ibkKk7yq3wUGVsiKz9ooqXzGwOXJ2zEYmwb4ZRSYBsHxTe_Kq62WzbsAoDj_AXdQqYwS4H3rW3_D2ItY7dBo8lblxeRU3xvmbsMfzoLu3PhUE7h3rN4jV-LtBn6xu1Rela83p5Nbpd0wC9CpDwB1OrkB62DnP5TunVtBLM7JEA	\N
cl8eomkun004209lg91x10hmu	cl8eomkk3003409lg5tdy0ovr	oauth	google	102220535086320167349	\N	ya29.a0Aa4xrXOORHM9ZGDQvgFZ54Sk80p8h8NbLKyNkDDQ-tyKLro8Ec2FUHKQ518aVv_u8JgDSBzNiMD_3TuwWFaVFTgFhDspFVwGROujAcSXt-BfIJNSngLAcePuDNlrjHbppHhSwRd5Czgvh7XdNQNWEIkhIDPYaCgYKATASARMSFQEjDvL94FVthn3pLVxmqbsoDT2CDg0163	1663953193	Bearer	https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile openid	eyJhbGciOiJSUzI1NiIsImtpZCI6IjIwOWMwNTdkM2JkZDhjMDhmMmQ1NzM5Nzg4NjMyNjczZjdjNjI0MGYiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDIyMjA1MzUwODYzMjAxNjczNDkiLCJoZCI6ImNldHlzLmVkdS5teCIsImVtYWlsIjoib2N0YXZpby5jaGF2ZXpAY2V0eXMuZWR1Lm14IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJ1YkNDdWllQmxfSlRmRDhlRkl0bFJ3IiwibmFtZSI6IkpPUkdFIE9DVEFWSU8gQ0hBVkVaIFJJVkVSTyIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS9BTG01d3UyX0RvX0lUcWQwY2VrSWxiZmFzSHFTU25abXdiM0EtVzFkcFdHTj1zOTYtYyIsImdpdmVuX25hbWUiOiJKT1JHRSBPQ1RBVklPIiwiZmFtaWx5X25hbWUiOiJDSEFWRVogUklWRVJPIiwibG9jYWxlIjoiZW4iLCJpYXQiOjE2NjM5NDk1OTQsImV4cCI6MTY2Mzk1MzE5NH0.1b70lkKOGerwarz3Hg-fT3_NoeF5kzflk8tHiPT5KxC_JEtDnhi9U1d8ybFaJi2OavoSlmnArJwlh8lytp9n4UG3HtwcQWBUl29ZMgquJhZh-aJbxWq7kc5nu8ZkUwh6HQCnS3tidCDPPqQc4v6eALdAlSAX91dZEP4MMurEPiMumk69bsS9fOFcZ1xD13KdGfVPwc_csjrBaCWgOs25q7ARpCktReE3tHXMFDcQXOhNbeXAgsDpUQqOlnNPOv3DuPD_sbkD87bsB6Uiz5aAL67p5lSCDdN3HjEVT_AbPa-MGd70LH2rm-pyggW2hZduSdHgvsIHGSZ9zO6DlH_plw	\N
cl8eywk04014809jpjudp4aa9	cl8eywjo0014109jpwgc177s6	oauth	google	111812239827644945722	\N	ya29.a0Aa4xrXNzgTVeGZSaofJ6pw361DvFHzd1o3jCGfo0Tgm79eOmAuQJ48EuUkIZi-SfyWC7vCbJ-EeoHmvxse2vUld0a6IC_CEPBm-0-4cic8FyLnQfKhY1YR5fSbsHgeuZq5FxL8HdZN161rE8hkOSBgJb6cEuaCgYKATASARESFQEjDvL9NH3LQj9R9BD21fcY9cpvPA0163	1663970455	Bearer	https://www.googleapis.com/auth/userinfo.profile openid https://www.googleapis.com/auth/userinfo.email	eyJhbGciOiJSUzI1NiIsImtpZCI6IjIwOWMwNTdkM2JkZDhjMDhmMmQ1NzM5Nzg4NjMyNjczZjdjNjI0MGYiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTE4MTIyMzk4Mjc2NDQ5NDU3MjIiLCJoZCI6ImNldHlzLmVkdS5teCIsImVtYWlsIjoiYW5kcmVhLm51bmV6cm9zYWxlc0BjZXR5cy5lZHUubXgiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiYXRfaGFzaCI6IjBiRmpPekxYY3ZpbmVveGE0UUk5d2ciLCJuYW1lIjoiQW5kcmVhIE7DusOxZXogUm9zYWxlcyIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS0vQUNOUEV1LXljQTcyNzFjNUNkQkFfUXNUUnVZTk5vSWM1Z0RpdUpIcUpUT2g9czk2LWMiLCJnaXZlbl9uYW1lIjoiQW5kcmVhIE7DusOxZXoiLCJmYW1pbHlfbmFtZSI6IlJvc2FsZXMiLCJsb2NhbGUiOiJlbiIsImlhdCI6MTY2Mzk2Njg1NiwiZXhwIjoxNjYzOTcwNDU2fQ.Gacqh-yodYAUmLVOdNd-Vi69SbILzjR8zNNf_xMJYSfpkJTSvejDEhgOZoG_g0PX9wgKQiQQRChQTnz8TorZ6DqodG8wxiDsqXKLPJWbn2Dmhyxt-FbXAtkP_dAScgr4Cn7o-7HVUCBRnbFGmoBUkPXdpXtJTL6qk5RtdfZuhcxkHWrH6aya73fOIGjDxJ4gA1C6xNP7qyMQtFzOwMZHEFrF4pDvSl5ZsLv7Y-3_pQMxy9OTIaCz1vRHlNQjYwAYDOKdQrn5iACd8RR1iwNGxFkg-EUaIypmEIxzWmVodp7fGPYitzFgykdhD51tp_M70b_tXyMi2wpDsacj2Z-OMA	\N
cl8jdqnox001309mfbne4t7vw	cl8jdqneh000609mfhfhf4q53	oauth	google	103100239444555008961	\N	ya29.a0Aa4xrXO-yl1no4EjAK3nTiuxGDqkm0I5sIW002gSberHWUCRbpn73_YLx_GEIq2rSkXY0a6Oc30iqQ8edryl3xgu9uYhmvxtoC3w_nEDXkAZJeb11r9kXEeVMIS57AWDIBpFyXzLX7zD8jlXx5i41hOvucH0aCgYKATASARESFQEjDvL9u2G45m9LRQs8WtgUljrEQA0163	1664237238	Bearer	openid https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile	eyJhbGciOiJSUzI1NiIsImtpZCI6ImJhMDc5YjQyMDI2NDFlNTRhYmNlZDhmYjEzNTRjZTAzOTE5ZmIyOTQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDMxMDAyMzk0NDQ1NTUwMDg5NjEiLCJoZCI6ImNldHlzLmVkdS5teCIsImVtYWlsIjoiY2FsZWIucGF5YW5AY2V0eXMuZWR1Lm14IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJJajdyWk1wUUttZHlWcTdObjZaYXNBIiwibmFtZSI6IkFMT05TTyBQQVnDgU4iLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EvQUxtNXd1MjhEc2NHVk4zMzBiR2o4UHZPOHdNNnI5Umg1RFNieTBNbHBMb0c9czk2LWMiLCJnaXZlbl9uYW1lIjoiQUxPTlNPIiwiZmFtaWx5X25hbWUiOiJQQVnDgU4iLCJsb2NhbGUiOiJlbiIsImlhdCI6MTY2NDIzMzYzOSwiZXhwIjoxNjY0MjM3MjM5fQ.j1RdHVNczVhJH-v35XS5Q_h7WXsr5dRVfOekBMmeNtAILi1PtMA2_1HVgaxlxblN6OgGFCuUnIbiA_t5ojA97P8tSGwYiuDcqS_uELw-gJ51XF4sQS7YROWjkxWbGa0upae_PIrLf1CZv_CXdGf37vuUlo5jfZjjgvP2jfXNKSsL57cx-nV2AvreAODAFTai19-MnyCX-NDQiN9u6hRIIAoL-liHvfWA1bz3KmUe4sUGoBryqgQ5962Qb22rdJaJpJ27uA5VdGQKjX5vWSLc08rD1k2iK7AeHrQJDxq0R_MU784rw1h6TERg5M3kE0uDhUy7RARBeHLLQ3-7C4wB5Q	\N
cl8lrwymq012409l9wqnnuy39	cl8lrwyce011709l9gt95du29	oauth	google	116904961291752675376	\N	ya29.a0Aa4xrXO-T72Ylrsk1xcTFQx9sPNmF4cpDqPnbVb83LsjI77H8PuYxMiRpgdugFuyZ4UhtybQUobm9u4KMtku1dXfbyNhqGLm2qz1bxbgST-JMZ5FJ8ywl2BxrgUeneuUyaKnItV8bBSiB1BMd7wNsKqrh5XRaCgYKATASARISFQEjDvL9RuKIrlAgJOgiXskgxn8RNQ0163	1664381979	Bearer	openid https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile	eyJhbGciOiJSUzI1NiIsImtpZCI6ImJhMDc5YjQyMDI2NDFlNTRhYmNlZDhmYjEzNTRjZTAzOTE5ZmIyOTQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTY5MDQ5NjEyOTE3NTI2NzUzNzYiLCJoZCI6ImNldHlzLmVkdS5teCIsImVtYWlsIjoiaXNvbGV0dGUuYnJhdm9AY2V0eXMuZWR1Lm14IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiI3UW54UlJSbXViTklxNzhHeEJ5RjlnIiwibmFtZSI6IkRFWUFOSVJBIEJSQVZPIiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hL0FMbTV3dTBWNXhwdkY4Z3Vab004M081T0lPOHpGdjZKRXVCUWE1cTdHeHVDPXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6IkRFWUFOSVJBIiwiZmFtaWx5X25hbWUiOiJCUkFWTyIsImxvY2FsZSI6ImVuIiwiaWF0IjoxNjY0Mzc4MzgwLCJleHAiOjE2NjQzODE5ODB9.m5usIIR_sL0kXAxzwDAa6eVnPKKVQMLX1_VTLCJghHlyoaC2SatDNkJMCgmrc5GOp9l3HKEs8CIfd47xAybTTTE3sEaiDrIFcLupWJKC4IAwqFUl9gmbmp95BGwNLqWqoYwKSdHw2kZa6BkoS_tBOnuG9aymEMj6NQVUzrtUaJnYDb6oNXFh2hIx2_o0mQtSoTrBzsMOnNe2HtiQ00TdoOuvPpe8Yd7FZ8dDfBFGx1644EsMlyw_yhQ5xyKAkcbi-7aqpHwYfEBY7mPRAWClg1zOtQWItu3gx9AKtwoeNOrHg_nHu3TIzRAOH-521blfF15JsfpVcObWlnWoZEkrZg	\N
cl8ovjhiu050909l9f0bd65su	cl8ovjh8g050209l9wkaj76zt	oauth	google	104335885934452399725	\N	ya29.a0Aa4xrXOzUkJTE5DMX0Pr0FWg96cxjW1x6sW_fNWwHrH4GsiY04ddHJn8Brc9uX2zgrO6s2FSDhLkcRukqITUgX9zyCdSOEdBfRjr6Woy57aAlMZ-I5f--iosZPffDpmDzeG_1JhVGLT0J8NqAG2n9P8hdkeJaCgYKATASARASFQEjDvL9ve2SHBO0BmDdFIs8qumk7Q0163	1664569468	Bearer	openid https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile	eyJhbGciOiJSUzI1NiIsImtpZCI6ImJhMDc5YjQyMDI2NDFlNTRhYmNlZDhmYjEzNTRjZTAzOTE5ZmIyOTQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDQzMzU4ODU5MzQ0NTIzOTk3MjUiLCJoZCI6ImNldHlzLmVkdS5teCIsImVtYWlsIjoibWFudWVsLnJ1aXpAY2V0eXMuZWR1Lm14IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiI4LVk2WGJfNDI2NXVvRkpTcEowcE53IiwibmFtZSI6Ik1BTlVFTCBSVUlaIiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hL0FMbTV3dTJOYmx1a1pLM1pUZmNBSFg2Ukt2MU90N3pVejRLUjdtaFBlMzhhPXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6Ik1BTlVFTCIsImZhbWlseV9uYW1lIjoiUlVJWiIsImxvY2FsZSI6ImVuIiwiaWF0IjoxNjY0NTY1ODY5LCJleHAiOjE2NjQ1Njk0Njl9.u3TOniC71YD6hjxTHCENvZVMbKhl6_1rBZtgiYuKzU-cHoc8u7EPcMLjQGmejTQUzgMm3VMtKT05e4k6YUPaApgbRpIMYPyyKVNXw8ziurA_mpzw9fUzYXGWBupBd9GoPXpbTCxL55Pqn96KYReSFQXyH6fBr0BIUacjhwbY-Dnk4Np9CXLSmzmEbGlb_QDdmUQtrXMfD6x8cLmTqaAUAk93Epd8k2dDi5-Xx9xa2b9FYwbvZssH5_J8d0w87g3GCqK-92_u4MlfzZiY2Xraeqn8WHNKYsMFp2-GofMYpoTCSd-Ef3VHmnuoQcGcOcli5ZcHxY4UMG-C4UTo7UNTZA	\N
cl8ovucn0074809mvwl9nsqjr	cl8ovuccv074009mvd6nlm1wz	oauth	google	103697905626029375568	\N	ya29.a0Aa4xrXP5RhmijvDgvcwDIyhDeRKG2bkh4UJIMkK89s3RxcgwwVX4Rgjef3QEGE1hynUKrOnwUALqIWJNdOJvS55p_mupEa-psPdOn_nyIZLsh9fTsp_rSMhtm8PGwdK9Mq5gZgD5ZvT41dsA6y5xGLBmwDLcaCgYKATASARISFQEjDvL9JaiTrBAxE3y84YOQgNz3qg0163	1664569974	Bearer	openid https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile	eyJhbGciOiJSUzI1NiIsImtpZCI6ImJhMDc5YjQyMDI2NDFlNTRhYmNlZDhmYjEzNTRjZTAzOTE5ZmIyOTQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI3NTkwMzQ0Njg0MjYtaWI1czZka2pwaWRrc2FpYmFpczUyM2pnZmpzc2JtN2EuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDM2OTc5MDU2MjYwMjkzNzU1NjgiLCJoZCI6ImNldHlzLmVkdS5teCIsImVtYWlsIjoianVhbmMucGVsYXlvQGNldHlzLmVkdS5teCIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJhdF9oYXNoIjoieURoc0tSRGpaeV9sUkdOWXJOTDh2USIsIm5hbWUiOiJKVUFOIFBFTEFZTyIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS9BTG01d3UxTDVxLTc0TEx1M0NzdmJkS2pWRjAwMnJKUC1uS0QwNkd0U21hdD1zOTYtYyIsImdpdmVuX25hbWUiOiJKVUFOIiwiZmFtaWx5X25hbWUiOiJQRUxBWU8iLCJsb2NhbGUiOiJlbiIsImlhdCI6MTY2NDU2NjM3NSwiZXhwIjoxNjY0NTY5OTc1fQ.fNZsHwM_YHn2eY0hlE1he5ajast0zgGeajSGXtrAf0rpF8zyRbK45ZPYHniqY0GNwYLHDJVJdrEfQKlGhUM0NuVNMfZEXRUBjO0zJLxbiUIxKbJZhBOaOl5U9DLoU7JDUamDTlW9vBnnjXxxzVfFiQ1xDbTWH753_c5qnEgunGcW4EVovZ2KzxXBqsTD7R83lYLcXlht94lrPsngPfysinDLc8ujnKs1ZLlVLE_b5h1VvLJSQXbRVOLiMv9I3JAfhySizCl6VvNlvqeNKrMgdEJnQi5jMc4dIPRL1BA8hDggiXxv99LXDIyB-G7Jno2fumKdfz0LHAcHv5uKUmazmw	\N
\.


--
-- Data for Name: Attendance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Attendance" (id, date) FROM stdin;
cl82ba1na000009jls6z2zya7	2022-09-14
cl8eyvsai002909jp60fbgjj1	2022-09-23
cl8yxjz6a086209lcpqlg2oht	2022-10-07
cl9iv9nlx007009lag6y9dbkz	2022-10-21
\.


--
-- Data for Name: AttendanceOnUsers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."AttendanceOnUsers" ("userId", "attendanceId") FROM stdin;
cl7ntgcal002809mlb984j3l8	cl8yxjz6a086209lcpqlg2oht
cl8eywjo0014109jpwgc177s6	cl8yxjz6a086209lcpqlg2oht
cl8eomkk3003409lg5tdy0ovr	cl8yxjz6a086209lcpqlg2oht
cl7owkrq9001509jo69570crb	cl8yxjz6a086209lcpqlg2oht
cl7owmazc008909johk5np8an	cl8yxjz6a086209lcpqlg2oht
cl7owo3jc014309johavu019g	cl8yxjz6a086209lcpqlg2oht
cl7pq4pug000609lczl0ojo17	cl8yxjz6a086209lcpqlg2oht
cl7tk7bp9011309l9pzlkgciv	cl8yxjz6a086209lcpqlg2oht
cl7tvygb5000609l0k2902jkg	cl8yxjz6a086209lcpqlg2oht
cl7owkrq9001509jo69570crb	cl82ba1na000009jls6z2zya7
cl7owmazc008909johk5np8an	cl82ba1na000009jls6z2zya7
cl7owo3jc014309johavu019g	cl82ba1na000009jls6z2zya7
cl7pq4pug000609lczl0ojo17	cl82ba1na000009jls6z2zya7
cl7tvygb5000609l0k2902jkg	cl82ba1na000009jls6z2zya7
cl7oy8fpr005209jmk2csn6bi	cl82ba1na000009jls6z2zya7
cl7ockgg0000609mp51u3qnpn	cl82ba1na000009jls6z2zya7
cl7oy9k66008009jmt1ejwux5	cl82ba1na000009jls6z2zya7
cl7owox3p000909l9t6bz7354	cl82ba1na000009jls6z2zya7
cl7owr3vg003509l9j91ooimd	cl82ba1na000009jls6z2zya7
cl7ox2wvc007909l92kd05q5h	cl82ba1na000009jls6z2zya7
cl7ntgcal002809mlb984j3l8	cl82ba1na000009jls6z2zya7
cl7oxh131003409mt7prk0e19	cl82ba1na000009jls6z2zya7
cl7oxt4h3005909mtd0lqua7m	cl82ba1na000009jls6z2zya7
cl7oxwriu008109mtpvla0gpz	cl82ba1na000009jls6z2zya7
cl7oy6ma4003009jmrak1i3vh	cl82ba1na000009jls6z2zya7
cl7p3r90o000609ks8nrqjbfr	cl82ba1na000009jls6z2zya7
cl7pd001p000609mer1i32wys	cl82ba1na000009jls6z2zya7
cl7oy8fpr005209jmk2csn6bi	cl8yxjz6a086209lcpqlg2oht
cl7ockgg0000609mp51u3qnpn	cl8yxjz6a086209lcpqlg2oht
cl7oy9k66008009jmt1ejwux5	cl8yxjz6a086209lcpqlg2oht
cl7owox3p000909l9t6bz7354	cl8yxjz6a086209lcpqlg2oht
cl7owr3vg003509l9j91ooimd	cl8yxjz6a086209lcpqlg2oht
cl7oxh131003409mt7prk0e19	cl8yxjz6a086209lcpqlg2oht
cl7oxt4h3005909mtd0lqua7m	cl8yxjz6a086209lcpqlg2oht
cl7oxwriu008109mtpvla0gpz	cl8yxjz6a086209lcpqlg2oht
cl7pd001p000609mer1i32wys	cl8yxjz6a086209lcpqlg2oht
cl8lrwyce011709l9gt95du29	cl8yxjz6a086209lcpqlg2oht
cl8ovjh8g050209l9wkaj76zt	cl8yxjz6a086209lcpqlg2oht
cl8jdqneh000609mfhfhf4q53	cl8yxjz6a086209lcpqlg2oht
cl7ockgg0000609mp51u3qnpn	cl9iv9nlx007009lag6y9dbkz
cl7owox3p000909l9t6bz7354	cl9iv9nlx007009lag6y9dbkz
cl7oy6ma4003009jmrak1i3vh	cl9iv9nlx007009lag6y9dbkz
cl7owo3jc014309johavu019g	cl9iv9nlx007009lag6y9dbkz
cl7ntgcal002809mlb984j3l8	cl9iv9nlx007009lag6y9dbkz
cl7owmazc008909johk5np8an	cl9iv9nlx007009lag6y9dbkz
cl8eomkk3003409lg5tdy0ovr	cl9iv9nlx007009lag6y9dbkz
cl7owmazc008909johk5np8an	cl8eyvsai002909jp60fbgjj1
cl7owo3jc014309johavu019g	cl8eyvsai002909jp60fbgjj1
cl7pq4pug000609lczl0ojo17	cl8eyvsai002909jp60fbgjj1
cl7tvygb5000609l0k2902jkg	cl8eyvsai002909jp60fbgjj1
cl7oy8fpr005209jmk2csn6bi	cl8eyvsai002909jp60fbgjj1
cl7ockgg0000609mp51u3qnpn	cl8eyvsai002909jp60fbgjj1
cl7oy9k66008009jmt1ejwux5	cl8eyvsai002909jp60fbgjj1
cl7owox3p000909l9t6bz7354	cl8eyvsai002909jp60fbgjj1
cl7owr3vg003509l9j91ooimd	cl8eyvsai002909jp60fbgjj1
cl7ntgcal002809mlb984j3l8	cl8eyvsai002909jp60fbgjj1
cl7oxh131003409mt7prk0e19	cl8eyvsai002909jp60fbgjj1
cl7oxt4h3005909mtd0lqua7m	cl8eyvsai002909jp60fbgjj1
cl7oxwriu008109mtpvla0gpz	cl8eyvsai002909jp60fbgjj1
cl7p3r90o000609ks8nrqjbfr	cl8eyvsai002909jp60fbgjj1
cl7pd001p000609mer1i32wys	cl8eyvsai002909jp60fbgjj1
cl8eomkk3003409lg5tdy0ovr	cl8eyvsai002909jp60fbgjj1
\.


--
-- Data for Name: InternSession; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."InternSession" (id, title, date) FROM stdin;
cl82ba9zu006909jlyvdzii92	Exposicion De Proyectos	2022-09-14
cl8eywkdu015409jp5a1dtd46	Clase Git /Github	2022-09-23
cl8yxkber093409lcod9q2bzt	Arreglos	2022-10-07
cl9iv93ix005509lauedmhc9p	Dos Punteros	2022-10-21
\.


--
-- Data for Name: Problem; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Problem" (id, title, link, "weekId", difficulty) FROM stdin;
cl8hlau845165p5elz2g3r2x9	Sum of Two Numbers	https://app.codesignal.com/arcade/intro/level-1/jwr339Kq6e3LQTsfa	cl8ghe3gr00288belgbgjdu8e	EASY
cl8hlbq5b5222p5elw8zhx93j	Century	https://app.codesignal.com/arcade/intro/level-1/egbueTZRRL5Mm4TXN	cl8ghe3gr00288belgbgjdu8e	EASY
cl8hlcdz25269p5ell3rgham5	Palindrome	https://app.codesignal.com/arcade/intro/level-1/s5PbmwxfECC52PWyQ	cl8ghe3gr00288belgbgjdu8e	MEDIUM
cl8lsmqns037409l9atu5q0it	Odd Even	https://www.hackerrank.com/contests/opc-1/challenges/odd-even	cl8ghe3gr00288belgbgjdu8e	MEDIUM
cl8swrevh002209jodiufnjmh	Concatenation of Array	https://leetcode.com/problems/concatenation-of-array/	cl8swosm2003109js7keunl1r	EASY
cl8swt6es006509jopryhka1i	Build array from permutation	https://leetcode.com/problems/build-array-from-permutation/	cl8swosm2003109js7keunl1r	MEDIUM
cl8swtvnj009609jojhtg8d6v	Sum of 1D Array	https://leetcode.com/problems/running-sum-of-1d-array/	cl8swosm2003109js7keunl1r	EASY
cl8swv1wa012709jon8g3h2kc	Perform Operations	https://leetcode.com/problems/final-value-of-variable-after-performing-operations/	cl8swosm2003109js7keunl1r	EASY
cl8swvpvu015809jo0figcaae	Good Pairs	https://leetcode.com/problems/number-of-good-pairs/	cl8swosm2003109js7keunl1r	MEDIUM
cl98x1jfy003809jlfcpwqmxv	Two Sum	https://leetcode.com/problems/two-sum/	cl98x1c8t000809jlcjyjz67a	EASY
cl9iwfm1h015409ld72n7tcqf	Two Sum II	https://leetcode.com/problems/two-sum-ii-input-array-is-sorted/	cl9iwfd3k00460ajm60nyi8hk	EASY
\.


--
-- Data for Name: Resource; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Resource" (id, title, description, link, type, date, "internSessionId") FROM stdin;
cl8aztsh00302woelqy9a1j0o	Biblia Web Development	Recopilación de múltiples videos de Youtube enfocados totalmente en Web Development. Desde HTML hasta React.	https://docs.google.com/document/d/1hprG3k7Bx6myJCBRiHO_Gg-C4SR32qRBAc1iU0og5Uc/edit?usp=sharing	DOCUMENT	2022-09-21	cl82ba9zu006909jlyvdzii92
cl8cjojm40146y1el73zwvub1	Presentación Proyectos	Introducción a proyectos con referencias e ideas de ejemplo	public/Proyectos.pdf	SLIDES	2022-09-22	cl82ba9zu006909jlyvdzii92
cl8f9idcv0247oteloewz7arp	Presentación Git & Github	Pequeña presentación mencionando alguno de los features de Git y Github	public/git.pdf	SLIDES	2022-09-24	cl8eywkdu015409jp5a1dtd46
cl9ixq5to002309ihsgzfhiq2	Cracking the Coding Interview	Libro para estudiar algoritmos	public/Cracking-the-Coding-Interview-6th-Edition-189-Programming-Questions-and-Solutions.pdf	PDF	2022-10-21	cl9iv93ix005509lauedmhc9p
\.


--
-- Data for Name: Session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Session" (id, "sessionToken", "userId", expires) FROM stdin;
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."User" (id, name, email, "emailVerified", image, "isInternMember", admin) FROM stdin;
cl7pd001p000609mer1i32wys	DAVID DURAN	david.duran@cetys.edu.mx	\N	https://lh3.googleusercontent.com/a-/AFdZucqD2nno0dhfXbEo96COhCfIbGTY7i-4rn09UxmZ=s96-c	t	f
cl7p3r90o000609ks8nrqjbfr	VERONICA YAMIL AGUILAR BARRIOS	veronica.barrios@cetys.edu.mx	\N	https://lh3.googleusercontent.com/a/AItbvmmWO7hOq72zURdE7ZBwbKkdz7EJLdygGsotkytz=s96-c	t	f
cl7ozyg9a025609mt3bc95exq	ITALO VAZQUEZ	italo.vazquez@cetys.edu.mx	\N	https://lh3.googleusercontent.com/a/AItbvmkzoL2Bb3UToQB18ExAE0dZe0htEo4llIOoPa7H=s96-c	t	f
cl7oy6ma4003009jmrak1i3vh	SANTIAGO SAINZ	sgutierrez@cetys.edu.mx	\N	https://lh3.googleusercontent.com/a/AItbvml153fkO9xX96b91KA8j_KBLB17XFkvPXD4B-Sy=s96-c	t	f
cl7oxwriu008109mtpvla0gpz	ANDRETTI QUIROZ	andretti.perez@cetys.edu.mx	\N	https://lh3.googleusercontent.com/a/AItbvmmu9JsIuxvhwYbW93oQPyQmAyqD4615-mNmKsgb=s96-c	t	f
cl7oxt4h3005909mtd0lqua7m	LESLY SARAI ROJAS SANCHEZ	lesly.rojas@cetys.edu.mx	\N	https://lh3.googleusercontent.com/a/AItbvmlJXKUaO28lwi8kFTXAZuMowm7d1YADRaT4Drpr=s96-c	t	f
cl7oxh131003409mt7prk0e19	SANTIAGO CAMARENA	santiago.renau@cetys.edu.mx	\N	https://lh3.googleusercontent.com/a/AItbvmnycsATGGqs5_P8Nm1ZJcymENKbv8bSQWWgRzHX=s96-c	t	f
cl7ox2wvc007909l92kd05q5h	LUIS CONSUELOS	luis.consuelos@cetys.edu.mx	\N	https://lh3.googleusercontent.com/a-/AFdZucpTm56O-gkkqA3Q5wrC78_FSJkvrMjmTMrLmwk-=s96-c	t	f
cl7owr3vg003509l9j91ooimd	ANA SALCEDO	anax.salcedo@cetys.edu.mx	\N	https://lh3.googleusercontent.com/a/AItbvmk-3wJz4stZqlVndabF2vBYt4pOtXEXW4zfnkva=s96-c	t	f
cl7owox3p000909l9t6bz7354	SANTIAGO PEREZ MARISCAL	santiago.pm@cetys.edu.mx	\N	https://lh3.googleusercontent.com/a-/AFdZucpuj7xGS-BmwgcXyKrJ1jP25OjDMwhNE3NP4uOW=s96-c	t	f
cl7oy9k66008009jmt1ejwux5	JOSE SOLIS	josea.solis@cetys.edu.mx	\N	https://lh3.googleusercontent.com/a/AItbvmlxKYloTeNio4u8w00sftYp5ioFBKblOtpv75s=s96-c	t	f
cl7ockgg0000609mp51u3qnpn	OSCAR FERNANDEZ	adrian.fernandez@cetys.edu.mx	\N	https://lh3.googleusercontent.com/a-/AFdZucql8tOe2hYZwIDI4OUt1h2nFFlgrmEpyj1iyc2X=s96-c	t	f
cl7oy8fpr005209jmk2csn6bi	Mauricio Muñoz	mmunoz@cetys.edu.mx	\N	https://lh3.googleusercontent.com/a-/AFdZucpPPt-q1G6wtGgrw6aiCOS-eD10UI8gcZ738bd0=s96-c	t	t
cl7tvygb5000609l0k2902jkg	JOSE CEJA	josep@cetys.edu.mx	\N	https://lh3.googleusercontent.com/a/AItbvmkTMg8P3u2U84wl_COG-sCl1ph0pnSCHjKFj31q=s96-c	t	f
cl7tk7bp9011309l9pzlkgciv	Ramiro Núñez Sánchez	ramiro.nunez@cetys.edu.mx	\N	https://lh3.googleusercontent.com/a-/AFdZucpNdZ-VHSm3KxlOYJvXvGIC_ZRcLIOpktz5HA_zFA=s96-c	t	f
cl7pq4pug000609lczl0ojo17	IAN TAMAYO	ian.tamayo@cetys.edu.mx	\N	https://lh3.googleusercontent.com/a/AItbvmlTIoKT0etCp0DQpuC1Byeq9rbKpiYVdWOlSvQk=s96-c	t	f
cl7owo3jc014309johavu019g	Oscar Encinas	oscar.encinas@cetys.edu.mx	\N	https://lh3.googleusercontent.com/a/AItbvmnJQ39wVxKDMSy5nT5mQMXIjQV4N5HWJ7uoW4oS=s96-c	t	f
cl7owmazc008909johk5np8an	AXEL CALDERA	axel.caldera@cetys.edu.mx	\N	https://lh3.googleusercontent.com/a/AItbvml0092ILggQFgNUBL-EMPFqTFB3ZZS7_9YktZvE=s96-c	t	f
cl7owl69j006309jobjdpggxr	Mario Barrera	marioalberto.barrera@cetys.edu.mx	\N	https://lh3.googleusercontent.com/a/AItbvmlYh5vJepQdlQg5qgZNaL-UY2QdWrsbM_SW7ows=s96-c	t	f
cl7owkrq9001509jo69570crb	STEPHANIA RAMOS	stephania.ramos@cetys.edu.mx	\N	https://lh3.googleusercontent.com/a/AItbvmnZ-NDFsNgKDPX-JVZ0r28LMMFhD4myxEr-B3r6=s96-c	t	f
cl8eomkk3003409lg5tdy0ovr	JORGE OCTAVIO CHAVEZ RIVERO	octavio.chavez@cetys.edu.mx	\N	https://lh3.googleusercontent.com/a/ALm5wu2_Do_ITqd0cekIlbfasHqSSnZmwb3A-W1dpWGN=s96-c	t	f
cl8eywjo0014109jpwgc177s6	Andrea Núñez Rosales	andrea.nunezrosales@cetys.edu.mx	\N	https://lh3.googleusercontent.com/a-/ACNPEu-ycA7271c5CdBA_QsTRuYNNoIc5gDiuJHqJTOh=s96-c	t	f
cl7ntgcal002809mlb984j3l8	DANIEL BAROCIO	daniel.barocio@cetys.edu.mx	\N	https://lh3.googleusercontent.com/a/AItbvmm6-e67xYnv7gPV1UFmOKGIeImsYH_WqWsKpsxJ=s96-c	t	t
cl8jdqneh000609mfhfhf4q53	ALONSO PAYÁN	caleb.payan@cetys.edu.mx	\N	https://lh3.googleusercontent.com/a/ALm5wu28DscGVN330bGj8PvO8wM6r9Rh5DSby0MlpLoG=s96-c	t	f
cl8lrwyce011709l9gt95du29	DEYANIRA BRAVO	isolette.bravo@cetys.edu.mx	\N	https://lh3.googleusercontent.com/a/ALm5wu0V5xpvF8guZoM83O5OIO8zFv6JEuBQa5q7GxuC=s96-c	t	f
cl8ovjh8g050209l9wkaj76zt	MANUEL RUIZ	manuel.ruiz@cetys.edu.mx	\N	https://lh3.googleusercontent.com/a/ALm5wu2NblukZK3ZTfcAHX6RKv1Ot7zUz4KR7mhPe38a=s96-c	t	f
cl8ovuccv074009mvd6nlm1wz	JUAN PELAYO	juanc.pelayo@cetys.edu.mx	\N	https://lh3.googleusercontent.com/a/ALm5wu1L5q-74LLu3CsvbdKjVF002rJP-nKD06GtSmat=s96-c	t	f
\.


--
-- Data for Name: UserStatusOnProblem; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."UserStatusOnProblem" ("userId", "problemId", status) FROM stdin;
cl7owo3jc014309johavu019g	cl8swvpvu015809jo0figcaae	SOLVED
cl8jdqneh000609mfhfhf4q53	cl8swrevh002209jodiufnjmh	SOLVED
cl8jdqneh000609mfhfhf4q53	cl8swtvnj009609jojhtg8d6v	SOLVED
cl8jdqneh000609mfhfhf4q53	cl8swv1wa012709jon8g3h2kc	SOLVED
cl8jdqneh000609mfhfhf4q53	cl8swt6es006509jopryhka1i	SOLVED
cl8eomkk3003409lg5tdy0ovr	cl8swv1wa012709jon8g3h2kc	SOLVED
cl8eywjo0014109jpwgc177s6	cl8swrevh002209jodiufnjmh	ATTEMPTED
cl8eywjo0014109jpwgc177s6	cl8hlau845165p5elz2g3r2x9	SOLVED
cl7owmazc008909johk5np8an	cl8swrevh002209jodiufnjmh	SOLVED
cl7owmazc008909johk5np8an	cl8swtvnj009609jojhtg8d6v	SOLVED
cl7owmazc008909johk5np8an	cl8swv1wa012709jon8g3h2kc	SOLVED
cl7owox3p000909l9t6bz7354	cl8swv1wa012709jon8g3h2kc	SOLVED
cl7oxwriu008109mtpvla0gpz	cl8swtvnj009609jojhtg8d6v	SOLVED
cl7oxwriu008109mtpvla0gpz	cl8swv1wa012709jon8g3h2kc	SOLVED
cl7ntgcal002809mlb984j3l8	cl8hlau845165p5elz2g3r2x9	ATTEMPTED
cl7tk7bp9011309l9pzlkgciv	cl8hlau845165p5elz2g3r2x9	SOLVED
cl7tk7bp9011309l9pzlkgciv	cl8hlbq5b5222p5elw8zhx93j	SOLVED
cl7tk7bp9011309l9pzlkgciv	cl8hlcdz25269p5ell3rgham5	SOLVED
cl7oy8fpr005209jmk2csn6bi	cl8hlcdz25269p5ell3rgham5	ATTEMPTED
cl7owox3p000909l9t6bz7354	cl8hlau845165p5elz2g3r2x9	SOLVED
cl7owox3p000909l9t6bz7354	cl8hlbq5b5222p5elw8zhx93j	SOLVED
cl7owox3p000909l9t6bz7354	cl8hlcdz25269p5ell3rgham5	SOLVED
cl8lrwyce011709l9gt95du29	cl8hlau845165p5elz2g3r2x9	SOLVED
cl8lrwyce011709l9gt95du29	cl8hlbq5b5222p5elw8zhx93j	SOLVED
cl8lrwyce011709l9gt95du29	cl8hlcdz25269p5ell3rgham5	SOLVED
cl7oy9k66008009jmt1ejwux5	cl8hlau845165p5elz2g3r2x9	SOLVED
cl7oy9k66008009jmt1ejwux5	cl8hlbq5b5222p5elw8zhx93j	SOLVED
cl7oy9k66008009jmt1ejwux5	cl8hlcdz25269p5ell3rgham5	SOLVED
cl8jdqneh000609mfhfhf4q53	cl8hlau845165p5elz2g3r2x9	SOLVED
cl8jdqneh000609mfhfhf4q53	cl8hlbq5b5222p5elw8zhx93j	SOLVED
cl8jdqneh000609mfhfhf4q53	cl8hlcdz25269p5ell3rgham5	SOLVED
cl7oy8fpr005209jmk2csn6bi	cl8hlau845165p5elz2g3r2x9	SOLVED
cl7tvygb5000609l0k2902jkg	cl8hlau845165p5elz2g3r2x9	SOLVED
cl8eomkk3003409lg5tdy0ovr	cl8hlau845165p5elz2g3r2x9	SOLVED
cl7oxwriu008109mtpvla0gpz	cl8hlau845165p5elz2g3r2x9	SOLVED
cl7owmazc008909johk5np8an	cl8hlau845165p5elz2g3r2x9	SOLVED
cl7owl69j006309jobjdpggxr	cl8hlau845165p5elz2g3r2x9	SOLVED
cl7ntgcal002809mlb984j3l8	cl8lsmqns037409l9atu5q0it	SOLVED
cl8ovjh8g050209l9wkaj76zt	cl8hlcdz25269p5ell3rgham5	SOLVED
cl8ovjh8g050209l9wkaj76zt	cl8hlbq5b5222p5elw8zhx93j	SOLVED
cl7tk7bp9011309l9pzlkgciv	cl8lsmqns037409l9atu5q0it	SOLVED
cl7oxwriu008109mtpvla0gpz	cl8hlbq5b5222p5elw8zhx93j	SOLVED
cl7tvygb5000609l0k2902jkg	cl8swtvnj009609jojhtg8d6v	SOLVED
cl7oxwriu008109mtpvla0gpz	cl8hlcdz25269p5ell3rgham5	SOLVED
cl7ockgg0000609mp51u3qnpn	cl8hlau845165p5elz2g3r2x9	SOLVED
cl7ockgg0000609mp51u3qnpn	cl8hlbq5b5222p5elw8zhx93j	SOLVED
cl7ockgg0000609mp51u3qnpn	cl8hlcdz25269p5ell3rgham5	SOLVED
cl7owl69j006309jobjdpggxr	cl8hlbq5b5222p5elw8zhx93j	SOLVED
cl7owl69j006309jobjdpggxr	cl8hlcdz25269p5ell3rgham5	SOLVED
cl7owl69j006309jobjdpggxr	cl8lsmqns037409l9atu5q0it	SOLVED
cl7ockgg0000609mp51u3qnpn	cl8swrevh002209jodiufnjmh	SOLVED
cl7ockgg0000609mp51u3qnpn	cl8swtvnj009609jojhtg8d6v	SOLVED
cl7ockgg0000609mp51u3qnpn	cl8swv1wa012709jon8g3h2kc	SOLVED
cl7ockgg0000609mp51u3qnpn	cl8swt6es006509jopryhka1i	SOLVED
cl7ockgg0000609mp51u3qnpn	cl8swvpvu015809jo0figcaae	SOLVED
cl7tk7bp9011309l9pzlkgciv	cl8swrevh002209jodiufnjmh	SOLVED
cl7tk7bp9011309l9pzlkgciv	cl8swtvnj009609jojhtg8d6v	SOLVED
cl7tk7bp9011309l9pzlkgciv	cl8swv1wa012709jon8g3h2kc	SOLVED
cl7tk7bp9011309l9pzlkgciv	cl8swt6es006509jopryhka1i	SOLVED
cl7tk7bp9011309l9pzlkgciv	cl8swvpvu015809jo0figcaae	SOLVED
cl8eomkk3003409lg5tdy0ovr	cl8swrevh002209jodiufnjmh	SOLVED
cl7owox3p000909l9t6bz7354	cl8lsmqns037409l9atu5q0it	ATTEMPTED
cl8eomkk3003409lg5tdy0ovr	cl8swtvnj009609jojhtg8d6v	SOLVED
cl8lrwyce011709l9gt95du29	cl8lsmqns037409l9atu5q0it	SOLVED
cl8lrwyce011709l9gt95du29	cl8swt6es006509jopryhka1i	SOLVED
cl7owo3jc014309johavu019g	cl8swrevh002209jodiufnjmh	SOLVED
cl7owo3jc014309johavu019g	cl8swtvnj009609jojhtg8d6v	SOLVED
cl7owo3jc014309johavu019g	cl8swv1wa012709jon8g3h2kc	SOLVED
cl7owo3jc014309johavu019g	cl8swt6es006509jopryhka1i	SOLVED
cl7tvygb5000609l0k2902jkg	cl8swrevh002209jodiufnjmh	SOLVED
cl7oxwriu008109mtpvla0gpz	cl8swrevh002209jodiufnjmh	SOLVED
cl8jdqneh000609mfhfhf4q53	cl8swvpvu015809jo0figcaae	SOLVED
cl7oxwriu008109mtpvla0gpz	cl8lsmqns037409l9atu5q0it	SOLVED
cl7oxwriu008109mtpvla0gpz	cl8swt6es006509jopryhka1i	SOLVED
cl7owr3vg003509l9j91ooimd	cl8swtvnj009609jojhtg8d6v	SOLVED
cl7owr3vg003509l9j91ooimd	cl8swrevh002209jodiufnjmh	SOLVED
cl7owr3vg003509l9j91ooimd	cl8swv1wa012709jon8g3h2kc	SOLVED
cl7owox3p000909l9t6bz7354	cl8swtvnj009609jojhtg8d6v	ATTEMPTED
cl8eomkk3003409lg5tdy0ovr	cl8swt6es006509jopryhka1i	SOLVED
cl7oxwriu008109mtpvla0gpz	cl8swvpvu015809jo0figcaae	SOLVED
cl8lrwyce011709l9gt95du29	cl8swrevh002209jodiufnjmh	SOLVED
cl8lrwyce011709l9gt95du29	cl8swtvnj009609jojhtg8d6v	SOLVED
cl8lrwyce011709l9gt95du29	cl8swv1wa012709jon8g3h2kc	SOLVED
cl8eomkk3003409lg5tdy0ovr	cl8swvpvu015809jo0figcaae	SOLVED
cl8lrwyce011709l9gt95du29	cl8swvpvu015809jo0figcaae	SOLVED
cl8jdqneh000609mfhfhf4q53	cl98x1jfy003809jlfcpwqmxv	SOLVED
cl7ockgg0000609mp51u3qnpn	cl98x1jfy003809jlfcpwqmxv	SOLVED
cl7tk7bp9011309l9pzlkgciv	cl98x1jfy003809jlfcpwqmxv	SOLVED
cl7owo3jc014309johavu019g	cl98x1jfy003809jlfcpwqmxv	SOLVED
cl7ntgcal002809mlb984j3l8	cl98x1jfy003809jlfcpwqmxv	SOLVED
cl8lrwyce011709l9gt95du29	cl98x1jfy003809jlfcpwqmxv	SOLVED
cl7oxwriu008109mtpvla0gpz	cl98x1jfy003809jlfcpwqmxv	SOLVED
cl7owr3vg003509l9j91ooimd	cl98x1jfy003809jlfcpwqmxv	SOLVED
cl8eomkk3003409lg5tdy0ovr	cl98x1jfy003809jlfcpwqmxv	SOLVED
cl7tk7bp9011309l9pzlkgciv	cl9iwfm1h015409ld72n7tcqf	SOLVED
cl7oxwriu008109mtpvla0gpz	cl9iwfm1h015409ld72n7tcqf	SOLVED
cl8eomkk3003409lg5tdy0ovr	cl9iwfm1h015409ld72n7tcqf	SOLVED
\.


--
-- Data for Name: VerificationToken; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."VerificationToken" (identifier, token, expires) FROM stdin;
\.


--
-- Data for Name: Week; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Week" (id, title, number) FROM stdin;
cl8hi2rik1472p5el2ppsjqku	Matrices	40
cl8hi3hk51539p5elp7et82tu	Arreglos 2	41
cl8hi3smk1566p5el9la94ph8	Arreglos 2	42
cl8hi4pph1609p5el51f5zfb4	Hola	43
cl8hi58i31652p5elgm0ulpfk	buenas tardes	70
cl8ghe3gr00288belgbgjdu8e	Introducción a la Programación	1
cl8swosm2003109js7keunl1r	Arreglos	2
cl98x1c8t000809jlcjyjz67a	Complejidad	3
cl9iwfd3k00460ajm60nyi8hk	Dos Punteros	4
\.


--
-- Data for Name: WeekResource; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."WeekResource" (id, title, type, link, "weekId") FROM stdin;
cl8jekfik0384mcelt1a6tah0	Python: For and While loops	VIDEO	https://www.youtube.com/watch?v=BPdyZpXW9F8	cl8ghe3gr00288belgbgjdu8e
cl8jeo74z0467mcel2eschdqb	Python: Operador Módulo	VIDEO	https://www.youtube.com/watch?v=5ZHoalXZK8M	cl8ghe3gr00288belgbgjdu8e
cl8q10r2e119623elqh453bau	Python: Funciones	VIDEO	https://www.youtube.com/watch?v=u-OmVr_fT4s	cl8ghe3gr00288belgbgjdu8e
cl8swx4kj004209l3ur6gzujp	Python: Arrays	VIDEO	https://www.youtube.com/watch?v=tw7ror9x32s	cl8swosm2003109js7keunl1r
\.


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
7e2350fb-de60-4b9b-a268-471bd2352109	bfda65ad1f36e1d32d5defb97a86425a9d222065d34e6bb5bc4f8b210b73284a	2022-09-04 18:33:09.338044+00	20220904183308_add_authentication	\N	\N	2022-09-04 18:33:09.203474+00	1
6873c618-2c8a-4e9b-a70f-a4917ac28f30	7eac4eed82d19f7e9a1e908e514963ef60d881ddc33026c9e9405f4fc8f0c01b	2022-09-04 19:44:06.492731+00	20220904194406_add_is_intern_member_param_to_user	\N	\N	2022-09-04 19:44:06.401093+00	1
8b1ba66f-1ba5-4242-b21d-0d74eb15c3e2	8616b980a0d5eb95244787c600c132590a749beef567e2aff093cc313fc6868e	2022-09-05 23:56:28.90303+00	20220905235628_add_many_to_many_relation_between_attendance_and_users	\N	\N	2022-09-05 23:56:28.798305+00	1
3b750289-9527-4b58-a03c-43c1cce9a122	4f7387f12ada5059bb0d5fd830bb3364b9a8a627d250512a0c9765d811d4efcd	2022-09-06 00:38:58.694911+00	20220906003858_changing_datetime_for_date	\N	\N	2022-09-06 00:38:58.593991+00	1
aafd3253-ebaf-48a9-834b-a86f01a48ff0	70b7c1335e73e892d17b4ca6c5d825fa10c8234bcf670286878715f0296ab3ac	2022-09-06 00:52:12.999021+00	20220906005212_making_date_unique_inside_attendance_model	\N	\N	2022-09-06 00:52:12.905557+00	1
8261f941-8e52-4bde-8ded-917f6ca2dde1	ad8d3fee6bfdd90937bd7b8b6282699c30c2e0b41b87ff34e90469d28d815097	2022-09-07 02:17:47.400096+00	20220907021746_adding_intern_session	\N	\N	2022-09-07 02:17:47.291838+00	1
9da7f759-6c3a-4234-9276-a2a7f95dd6cb	3dd81f1c91140a0273e1e6ee788434e5c6afa258ee556b483802e460e091ebb8	2022-09-07 02:29:45.960514+00	20220907022945_removing_intern_session_self_relation	\N	\N	2022-09-07 02:29:45.870057+00	1
11053b43-c967-4cb0-b956-cd9280f13bac	2cec29bb3c0a86bc16b1d9466e00de482a1652066ff4b583b583dc4bb075842e	2022-09-07 03:00:09.103537+00	20220907030008_adding_admin_flag_to_user	\N	\N	2022-09-07 03:00:09.015239+00	1
cb0fbb80-1149-44f6-a557-a9bd2dc7918d	c0a37bf13b3773c0a8939e75787e8b96f6d791bee19c8fc4a129e38605e73355	2022-09-12 01:18:31.000877+00	20220912011830_adding_enum_to_resource_type	\N	\N	2022-09-12 01:18:30.891718+00	1
fdfa964f-8c7b-4148-b068-2a9f968569e8	1f2a1152d8972a9399f30fed1cfbb4fe2b8de56584f417b11329ae03f48c33ff	2022-09-23 05:13:18.132508+00	20220923051317_added_project_model	\N	\N	2022-09-23 05:13:18.039112+00	1
9e32630d-3aaf-4d58-95ce-8a67b493be19	180e9e46a12454dfd3a69746ae1ff6e8249e028c210e01a67257952df78d36b1	2022-09-24 16:18:09.534718+00	20220924161809_adding_models_to_handle_potw_logic	\N	\N	2022-09-24 16:18:09.398592+00	1
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public) FROM stdin;
resources	resources	\N	2022-09-13 01:07:18.660918+00	2022-09-13 01:07:18.660918+00	f
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2022-09-04 18:30:37.433134
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2022-09-04 18:30:37.439326
2	pathtoken-column	49756be03be4c17bb85fe70d4a861f27de7e49ad	2022-09-04 18:30:37.441282
3	add-migrations-rls	bb5d124c53d68635a883e399426c6a5a25fc893d	2022-09-04 18:30:37.472635
4	add-size-functions	6d79007d04f5acd288c9c250c42d2d5fd286c54d	2022-09-04 18:30:37.48149
5	change-column-name-in-get-size	fd65688505d2ffa9fbdc58a944348dd8604d688c	2022-09-04 18:30:37.484452
6	add-rls-to-buckets	63e2bab75a2040fee8e3fb3f15a0d26f3380e9b6	2022-09-04 18:30:37.489078
7	add-public-to-buckets	82568934f8a4d9e0a85f126f6fb483ad8214c418	2022-09-04 18:30:37.492946
8	fix-search-function	1a43a40eddb525f2e2f26efd709e6c06e58e059c	2022-09-04 18:30:37.49864
9	search-files-search-function	34c096597eb8b9d077fdfdde9878c88501b2fafc	2022-09-04 18:30:37.502058
10	add-trigger-to-auto-update-updated_at-column	37d6bb964a70a822e6d37f22f457b9bca7885928	2022-09-04 18:30:37.505474
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata) FROM stdin;
b11b5975-e8eb-429a-969a-54614bca7f70	resources	public/milomenafavico.png	\N	2022-09-13 01:07:27.333105+00	2022-09-13 01:07:27.531259+00	2022-09-13 01:07:27.333105+00	{"size": 17589, "mimetype": "image/png", "cacheControl": "max-age=3600"}
d79be573-7547-4ede-b82c-86d864a171d8	resources	public/Proyectos.pdf	\N	2022-09-22 04:19:14.877405+00	2022-09-22 04:19:15.671301+00	2022-09-22 04:19:14.877405+00	{"size": 2383511, "mimetype": "application/pdf", "cacheControl": "max-age=3600"}
da62a3b1-b05d-47c5-980d-ca5480d49fc8	resources	public/git.pdf	\N	2022-09-24 01:57:49.788526+00	2022-09-24 01:57:50.880174+00	2022-09-24 01:57:49.788526+00	{"size": 4961746, "mimetype": "application/pdf", "cacheControl": "max-age=3600"}
73fdca4c-eb0b-4745-8085-f4991d82d6c8	resources	public/Cracking-the-Coding-Interview-6th-Edition-189-Programming-Questions-and-Solutions.pdf	\N	2022-10-21 20:18:43.765604+00	2022-10-21 20:18:45.616019+00	2022-10-21 20:18:43.765604+00	{"size": 7191797, "mimetype": "application/pdf", "cacheControl": "max-age=3600"}
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 1, false);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (provider, id);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: Account Account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Account"
    ADD CONSTRAINT "Account_pkey" PRIMARY KEY (id);


--
-- Name: AttendanceOnUsers AttendanceOnUsers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."AttendanceOnUsers"
    ADD CONSTRAINT "AttendanceOnUsers_pkey" PRIMARY KEY ("userId", "attendanceId");


--
-- Name: Attendance Attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Attendance"
    ADD CONSTRAINT "Attendance_pkey" PRIMARY KEY (id);


--
-- Name: InternSession InternSession_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InternSession"
    ADD CONSTRAINT "InternSession_pkey" PRIMARY KEY (id);


--
-- Name: Problem Problem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Problem"
    ADD CONSTRAINT "Problem_pkey" PRIMARY KEY (id);


--
-- Name: Resource Resource_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Resource"
    ADD CONSTRAINT "Resource_pkey" PRIMARY KEY (id);


--
-- Name: Session Session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Session"
    ADD CONSTRAINT "Session_pkey" PRIMARY KEY (id);


--
-- Name: UserStatusOnProblem UserStatusOnProblem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserStatusOnProblem"
    ADD CONSTRAINT "UserStatusOnProblem_pkey" PRIMARY KEY ("userId", "problemId");


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: WeekResource WeekResource_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."WeekResource"
    ADD CONSTRAINT "WeekResource_pkey" PRIMARY KEY (id);


--
-- Name: Week Week_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Week"
    ADD CONSTRAINT "Week_pkey" PRIMARY KEY (id);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_token_session_id; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_token_session_id ON auth.refresh_tokens USING btree (session_id);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_token_idx ON auth.refresh_tokens USING btree (token);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: Account_provider_providerAccountId_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Account_provider_providerAccountId_key" ON public."Account" USING btree (provider, "providerAccountId");


--
-- Name: Attendance_date_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Attendance_date_key" ON public."Attendance" USING btree (date);


--
-- Name: InternSession_date_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "InternSession_date_key" ON public."InternSession" USING btree (date);


--
-- Name: Resource_date_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Resource_date_key" ON public."Resource" USING btree (date);


--
-- Name: Session_sessionToken_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Session_sessionToken_key" ON public."Session" USING btree ("sessionToken");


--
-- Name: User_email_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "User_email_key" ON public."User" USING btree (email);


--
-- Name: VerificationToken_identifier_token_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "VerificationToken_identifier_token_key" ON public."VerificationToken" USING btree (identifier, token);


--
-- Name: VerificationToken_token_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "VerificationToken_token_key" ON public."VerificationToken" USING btree (token);


--
-- Name: Week_number_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Week_number_key" ON public."Week" USING btree (number);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_parent_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_parent_fkey FOREIGN KEY (parent) REFERENCES auth.refresh_tokens(token);


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: Account Account_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Account"
    ADD CONSTRAINT "Account_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: AttendanceOnUsers AttendanceOnUsers_attendanceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."AttendanceOnUsers"
    ADD CONSTRAINT "AttendanceOnUsers_attendanceId_fkey" FOREIGN KEY ("attendanceId") REFERENCES public."Attendance"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: AttendanceOnUsers AttendanceOnUsers_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."AttendanceOnUsers"
    ADD CONSTRAINT "AttendanceOnUsers_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Problem Problem_weekId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Problem"
    ADD CONSTRAINT "Problem_weekId_fkey" FOREIGN KEY ("weekId") REFERENCES public."Week"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Resource Resource_internSessionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Resource"
    ADD CONSTRAINT "Resource_internSessionId_fkey" FOREIGN KEY ("internSessionId") REFERENCES public."InternSession"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Session Session_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Session"
    ADD CONSTRAINT "Session_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: UserStatusOnProblem UserStatusOnProblem_problemId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserStatusOnProblem"
    ADD CONSTRAINT "UserStatusOnProblem_problemId_fkey" FOREIGN KEY ("problemId") REFERENCES public."Problem"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: UserStatusOnProblem UserStatusOnProblem_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserStatusOnProblem"
    ADD CONSTRAINT "UserStatusOnProblem_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: WeekResource WeekResource_weekId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."WeekResource"
    ADD CONSTRAINT "WeekResource_weekId_fkey" FOREIGN KEY ("weekId") REFERENCES public."Week"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: buckets buckets_owner_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_owner_fkey FOREIGN KEY (owner) REFERENCES auth.users(id);


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: objects objects_owner_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_owner_fkey FOREIGN KEY (owner) REFERENCES auth.users(id);


--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT ALL ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA graphql_public; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA graphql_public TO postgres;
GRANT USAGE ON SCHEMA graphql_public TO anon;
GRANT USAGE ON SCHEMA graphql_public TO authenticated;
GRANT USAGE ON SCHEMA graphql_public TO service_role;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT ALL ON SCHEMA storage TO postgres;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- Name: FUNCTION algorithm_sign(signables text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.algorithm_sign(signables text, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint) TO dashboard_user;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION sign(payload json, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.sign(payload json, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION try_cast_double(inp text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.try_cast_double(inp text) TO dashboard_user;


--
-- Name: FUNCTION url_decode(data text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.url_decode(data text) TO dashboard_user;


--
-- Name: FUNCTION url_encode(data bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.url_encode(data bytea) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- Name: FUNCTION verify(token text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.verify(token text, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION get_built_schema_version(); Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql.get_built_schema_version() TO postgres;
GRANT ALL ON FUNCTION graphql.get_built_schema_version() TO anon;
GRANT ALL ON FUNCTION graphql.get_built_schema_version() TO authenticated;
GRANT ALL ON FUNCTION graphql.get_built_schema_version() TO service_role;


--
-- Name: FUNCTION rebuild_on_ddl(); Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql.rebuild_on_ddl() TO postgres;
GRANT ALL ON FUNCTION graphql.rebuild_on_ddl() TO anon;
GRANT ALL ON FUNCTION graphql.rebuild_on_ddl() TO authenticated;
GRANT ALL ON FUNCTION graphql.rebuild_on_ddl() TO service_role;


--
-- Name: FUNCTION rebuild_on_drop(); Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql.rebuild_on_drop() TO postgres;
GRANT ALL ON FUNCTION graphql.rebuild_on_drop() TO anon;
GRANT ALL ON FUNCTION graphql.rebuild_on_drop() TO authenticated;
GRANT ALL ON FUNCTION graphql.rebuild_on_drop() TO service_role;


--
-- Name: FUNCTION rebuild_schema(); Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql.rebuild_schema() TO postgres;
GRANT ALL ON FUNCTION graphql.rebuild_schema() TO anon;
GRANT ALL ON FUNCTION graphql.rebuild_schema() TO authenticated;
GRANT ALL ON FUNCTION graphql.rebuild_schema() TO service_role;


--
-- Name: FUNCTION variable_definitions_sort(variable_definitions jsonb); Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql.variable_definitions_sort(variable_definitions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql.variable_definitions_sort(variable_definitions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql.variable_definitions_sort(variable_definitions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql.variable_definitions_sort(variable_definitions jsonb) TO service_role;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: postgres
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;


--
-- Name: SEQUENCE key_key_id_seq; Type: ACL; Schema: pgsodium; Owner: postgres
--

GRANT ALL ON SEQUENCE pgsodium.key_key_id_seq TO pgsodium_keyiduser;


--
-- Name: FUNCTION extension(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.extension(name text) TO anon;
GRANT ALL ON FUNCTION storage.extension(name text) TO authenticated;
GRANT ALL ON FUNCTION storage.extension(name text) TO service_role;
GRANT ALL ON FUNCTION storage.extension(name text) TO dashboard_user;
GRANT ALL ON FUNCTION storage.extension(name text) TO postgres;


--
-- Name: FUNCTION filename(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.filename(name text) TO anon;
GRANT ALL ON FUNCTION storage.filename(name text) TO authenticated;
GRANT ALL ON FUNCTION storage.filename(name text) TO service_role;
GRANT ALL ON FUNCTION storage.filename(name text) TO dashboard_user;
GRANT ALL ON FUNCTION storage.filename(name text) TO postgres;


--
-- Name: FUNCTION foldername(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.foldername(name text) TO anon;
GRANT ALL ON FUNCTION storage.foldername(name text) TO authenticated;
GRANT ALL ON FUNCTION storage.foldername(name text) TO service_role;
GRANT ALL ON FUNCTION storage.foldername(name text) TO dashboard_user;
GRANT ALL ON FUNCTION storage.foldername(name text) TO postgres;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT ALL ON TABLE auth.audit_log_entries TO postgres;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.identities TO postgres;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT ALL ON TABLE auth.instances TO postgres;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.mfa_amr_claims TO postgres;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.mfa_challenges TO postgres;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.mfa_factors TO postgres;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT ALL ON TABLE auth.refresh_tokens TO postgres;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.schema_migrations TO dashboard_user;
GRANT ALL ON TABLE auth.schema_migrations TO postgres;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.sessions TO postgres;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT ALL ON TABLE auth.users TO postgres;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- Name: TABLE schema_version; Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON TABLE graphql.schema_version TO postgres;
GRANT ALL ON TABLE graphql.schema_version TO anon;
GRANT ALL ON TABLE graphql.schema_version TO authenticated;
GRANT ALL ON TABLE graphql.schema_version TO service_role;


--
-- Name: SEQUENCE seq_schema_version; Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE graphql.seq_schema_version TO postgres;
GRANT ALL ON SEQUENCE graphql.seq_schema_version TO anon;
GRANT ALL ON SEQUENCE graphql.seq_schema_version TO authenticated;
GRANT ALL ON SEQUENCE graphql.seq_schema_version TO service_role;


--
-- Name: TABLE valid_key; Type: ACL; Schema: pgsodium; Owner: postgres
--

GRANT ALL ON TABLE pgsodium.valid_key TO pgsodium_keyiduser;


--
-- Name: TABLE "Account"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."Account" TO anon;
GRANT ALL ON TABLE public."Account" TO authenticated;
GRANT ALL ON TABLE public."Account" TO service_role;


--
-- Name: TABLE "Attendance"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."Attendance" TO anon;
GRANT ALL ON TABLE public."Attendance" TO authenticated;
GRANT ALL ON TABLE public."Attendance" TO service_role;


--
-- Name: TABLE "AttendanceOnUsers"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."AttendanceOnUsers" TO anon;
GRANT ALL ON TABLE public."AttendanceOnUsers" TO authenticated;
GRANT ALL ON TABLE public."AttendanceOnUsers" TO service_role;


--
-- Name: TABLE "InternSession"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."InternSession" TO anon;
GRANT ALL ON TABLE public."InternSession" TO authenticated;
GRANT ALL ON TABLE public."InternSession" TO service_role;


--
-- Name: TABLE "Problem"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."Problem" TO anon;
GRANT ALL ON TABLE public."Problem" TO authenticated;
GRANT ALL ON TABLE public."Problem" TO service_role;


--
-- Name: TABLE "Resource"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."Resource" TO anon;
GRANT ALL ON TABLE public."Resource" TO authenticated;
GRANT ALL ON TABLE public."Resource" TO service_role;


--
-- Name: TABLE "Session"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."Session" TO anon;
GRANT ALL ON TABLE public."Session" TO authenticated;
GRANT ALL ON TABLE public."Session" TO service_role;


--
-- Name: TABLE "User"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."User" TO anon;
GRANT ALL ON TABLE public."User" TO authenticated;
GRANT ALL ON TABLE public."User" TO service_role;


--
-- Name: TABLE "UserStatusOnProblem"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."UserStatusOnProblem" TO anon;
GRANT ALL ON TABLE public."UserStatusOnProblem" TO authenticated;
GRANT ALL ON TABLE public."UserStatusOnProblem" TO service_role;


--
-- Name: TABLE "VerificationToken"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."VerificationToken" TO anon;
GRANT ALL ON TABLE public."VerificationToken" TO authenticated;
GRANT ALL ON TABLE public."VerificationToken" TO service_role;


--
-- Name: TABLE "Week"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."Week" TO anon;
GRANT ALL ON TABLE public."Week" TO authenticated;
GRANT ALL ON TABLE public."Week" TO service_role;


--
-- Name: TABLE "WeekResource"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."WeekResource" TO anon;
GRANT ALL ON TABLE public."WeekResource" TO authenticated;
GRANT ALL ON TABLE public."WeekResource" TO service_role;


--
-- Name: TABLE _prisma_migrations; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public._prisma_migrations TO anon;
GRANT ALL ON TABLE public._prisma_migrations TO authenticated;
GRANT ALL ON TABLE public._prisma_migrations TO service_role;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO postgres;


--
-- Name: TABLE migrations; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.migrations TO anon;
GRANT ALL ON TABLE storage.migrations TO authenticated;
GRANT ALL ON TABLE storage.migrations TO service_role;
GRANT ALL ON TABLE storage.migrations TO postgres;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO postgres;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: pgsodium; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA pgsodium GRANT ALL ON SEQUENCES  TO pgsodium_keyiduser;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: pgsodium; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA pgsodium GRANT ALL ON TABLES  TO pgsodium_keyiduser;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO service_role;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: postgres
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE SCHEMA')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO postgres;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: postgres
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO postgres;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

