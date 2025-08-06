CREATE OR REPLACE FUNCTION api.create_observation(
    input api.observation_input
)
RETURNS json AS $$
DECLARE
    new_id integer;
    result json;
BEGIN
    INSERT INTO greatpond.obs (
        name,
        "desc",
        severity_int,
        size,
        geom,
        created_at,
        updated_at
    ) VALUES (
        input.name,
        input.description,
        input.severity_int,
        input.size,
        ST_SetSRID(ST_MakePoint(input.lon, input.lat), 6348),
        CURRENT_TIMESTAMP,
        CURRENT_TIMESTAMP
    )
    RETURNING id INTO new_id;
    
    SELECT json_build_object(
        'status', 'success',
        'id', new_id,
        'message', 'Observation created successfully'
    ) INTO result;
    
    RETURN result;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION api.delete_observation(
    p_id integer
)
RETURNS json AS $$
DECLARE
    result json;
BEGIN
    UPDATE greatpond.obs
    SET deleted_yn = 'Y',
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_id;
    
    SELECT json_build_object(
        'status', 'success',
        'id', p_id,
        'message', 'Observation deleted successfully'
    ) INTO result;
    
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- PostgreSQL type for observation input
CREATE TYPE api.observation_input AS (
    name varchar(50),
    description varchar(250),
    severity_int integer,
    size decimal,
    lat decimal,
    lon decimal
);

-- Sample table structure (for reference)
/*
CREATE TABLE greatpond.obs (
    id serial PRIMARY KEY,
    name varchar(50) NOT NULL,
    "desc" varchar(250),
    severity_int integer,
    size decimal,
    geom geometry(Point, 6348),
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_yn char(1)
);
*/
