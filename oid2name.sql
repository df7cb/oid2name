CREATE OR REPLACE FUNCTION oid2name(oid INOUT oid, class OUT name, schema OUT name, name OUT name)
RETURNS SETOF record
LANGUAGE plpgsql
STABLE STRICT
AS $$
DECLARE
	o oid;
BEGIN
	FOR class IN SELECT attrelid::regclass FROM pg_attribute WHERE attname = 'oid' AND attnum < 0 LOOP
		schema := NULL;
		name := NULL;
		IF class = 'pg_am' THEN
			FOR name IN EXECUTE 'SELECT amname FROM pg_am c WHERE c.oid = ' || oid LOOP
				RETURN NEXT;
			END LOOP;
		ELSIF class = 'pg_authid' THEN
			FOR name IN EXECUTE 'SELECT rolname FROM pg_authid c WHERE c.oid = ' || oid LOOP
				RETURN NEXT;
			END LOOP;
		ELSIF class = 'pg_class' THEN
			FOR schema, name IN EXECUTE 'SELECT nspname, relname FROM pg_class c JOIN pg_namespace n ON (c.relnamespace = n.oid) WHERE c.oid = ' || oid LOOP
				RETURN NEXT;
			END LOOP;
		ELSIF class = 'pg_collation' THEN
			FOR schema, name IN EXECUTE 'SELECT nspname, collname FROM pg_collation c JOIN pg_namespace n ON (c.collnamespace = n.oid) WHERE c.oid = ' || oid LOOP
				RETURN NEXT;
			END LOOP;
		ELSIF class = 'pg_database' THEN
			FOR name IN EXECUTE 'SELECT datname FROM pg_database c WHERE c.oid = ' || oid LOOP
				RETURN NEXT;
			END LOOP;
		ELSIF class = 'pg_language' THEN
			FOR name IN EXECUTE 'SELECT lanname FROM pg_language c WHERE c.oid = ' || oid LOOP
				RETURN NEXT;
			END LOOP;
		ELSIF class = 'pg_namespace' THEN
			FOR name IN EXECUTE 'SELECT nspname FROM pg_namespace c WHERE c.oid = ' || oid LOOP
				RETURN NEXT;
			END LOOP;
		ELSIF class = 'pg_opclass' THEN
			FOR schema, name IN EXECUTE 'SELECT nspname, opcname FROM pg_opclass c JOIN pg_namespace n ON (c.opcnamespace = n.oid) WHERE c.oid = ' || oid LOOP
				RETURN NEXT;
			END LOOP;
		ELSIF class = 'pg_operator' THEN
			FOR schema, name IN EXECUTE 'SELECT nspname, oprname FROM pg_operator c JOIN pg_namespace n ON (c.oprnamespace = n.oid) WHERE c.oid = ' || oid LOOP
				RETURN NEXT;
			END LOOP;
		ELSIF class = 'pg_opfamily' THEN
			FOR schema, name IN EXECUTE 'SELECT nspname, opfname FROM pg_opfamily c JOIN pg_namespace n ON (c.opfnamespace = n.oid) WHERE c.oid = ' || oid LOOP
				RETURN NEXT;
			END LOOP;
		ELSIF class = 'pg_proc' THEN
			FOR schema, name IN EXECUTE 'SELECT nspname, proname FROM pg_proc c JOIN pg_namespace n ON (c.pronamespace = n.oid) WHERE c.oid = ' || oid LOOP
				RETURN NEXT;
			END LOOP;
		ELSIF class = 'pg_tablespace' THEN
			FOR name IN EXECUTE 'SELECT spcname FROM pg_tablespace c WHERE c.oid = ' || oid LOOP
				RETURN NEXT;
			END LOOP;
		ELSIF class = 'pg_type' THEN
			FOR schema, name IN EXECUTE 'SELECT nspname, typname FROM pg_type c JOIN pg_namespace n ON (c.typnamespace = n.oid) WHERE c.oid = ' || oid LOOP
				RETURN NEXT;
			END LOOP;
		ELSE
			FOR o IN EXECUTE 'SELECT oid FROM ' || class || ' c WHERE c.oid = ' || oid LOOP
				RETURN NEXT;
			END LOOP;
		END IF;
	END LOOP;
	RETURN;
END;
$$;
