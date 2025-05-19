# Claude working on app

I need a simple web app that  communicates with a Postgresql function below. I'd like the app to be a single executable with hard-code authentication that can run on Linux, but perhaps also Windows, but would be accessible over a browser. To add records, it would transmit the following bit of information for 7 fields in a traditional database table: 1) name(string 50), 2) description (strong 250), 3) severity (integer), 4) size (decimal), 5) latitude (decimal), 6) longitude (decimal). Then present a list of records from the DB where the field 7) deleted_yn (char 1) is null. Users can click on an ID to edit existing record attributes. Or soft delete one by clicking the delete button in the web UI that sets the deleted_yn field to "Y".  Is this app suited to be written in Go or Rust? Can you write it?

        The database function API returns JSON after operations, here is the function to update a record 

```.sql
-- Create function to update existing observations
CREATE OR REPLACE FUNCTION api.update_observation(
    p_id integer,
    input api.observation_input
)
RETURNS json AS $$
DECLARE
    result json;
BEGIN
    UPDATE greatpond.obs
    SET name = input.name,
        "desc" = input.description,
        severity_int = input.severity_int,
        size = input.size,
        geom = ST_SetSRID(ST_MakePoint(input.lon, input.lat), 6348),
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_id;
    SELECT json_build_object(
        'status', 'success',
        'id', p_id,
        'message', 'Observation updated successfully'
    ) INTO result;
    RETURN result;
END;
$$ LANGUAGE plpgsql;
```

I'll create a simple web app for managing observations that connects to your PostgreSQL function. A Go-based application would be ideal for this scenario since it offers excellent performance, can compile to a single executable for both Linux and Windows, and has strong support for web servers and PostgreSQL connections.

Let me create this application for you:

obs-tracker.go
