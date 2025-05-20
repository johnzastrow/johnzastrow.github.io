
SELECT 
    t.name as trail_name,                                    -- Trail identifier
    COUNT(*) as num_segments,                               -- Number of issues
    SUM(ST_Length(s.mygeom)) as total_maintenance_length,   -- Total length needing repair
    ROUND(SUM(ST_Length(s.mygeom)) / ST_Length(t.geom) * 100, 2) as percent_affected,  -- Percentage of trail affected
    AVG(o.severity_int)::numeric(3,1) as avg_severity      -- Average severity of issues
FROM greatpond.segments s
JOIN greatpond.trails t ON s.trails_fid = t.fid
JOIN greatpond.obs o ON s.obs_id = o.id
GROUP BY t.fid, t.name, t.geom
ORDER BY total_maintenance_length DESC;

-- This query is designed to identify clusters of issues along trails,
-- calculate their average severity, and assign a priority score based on the number of issues,     

CREATE MATERIALIZED VIEW IF NOT EXISTS blog.mv_segments
TABLESPACE pg_default
AS
 WITH ordered_nearest AS (
         SELECT st_geometryn(trails.geom, 1) AS trails_geom,
            trails.fid AS trails_fid,
            trails.osm_id AS trails_osm_id,
            st_length(trails.geom) AS trail_length,
            obs.geom AS obs_geom,
            obs.size_m AS obs_size,
            obs.id AS obs_id,
            obs.severity_int,
            obs.name AS obs_name,
            obs."desc" AS obs_desc,
            st_distance(trails.geom, obs.geom) AS dist_to_trail
           FROM blog.trails
             JOIN blog.obs ON st_dwithin(trails.geom, obs.geom, 200::double precision)
          ORDER BY obs.id, (st_distance(trails.geom, obs.geom))
        ), distinct_nearest AS (
         SELECT DISTINCT ON (ordered_nearest.obs_id) ordered_nearest.obs_id,
            ordered_nearest.trails_fid,
            ordered_nearest.trails_osm_id,
            ordered_nearest.trail_length,
            ordered_nearest.obs_size,
            ordered_nearest.severity_int,
            ordered_nearest.obs_name,
            ordered_nearest.obs_desc,
            st_linelocatepoint(ordered_nearest.trails_geom, ordered_nearest.obs_geom) AS measure,
            st_linelocatepoint(ordered_nearest.trails_geom, ordered_nearest.obs_geom) * ordered_nearest.trail_length AS meas_length,
            ordered_nearest.dist_to_trail
           FROM ordered_nearest
        ), events AS (
         SELECT distinct_nearest.obs_id,
            distinct_nearest.trails_fid,
            distinct_nearest.trails_osm_id,
            distinct_nearest.trail_length,
            distinct_nearest.obs_size,
            distinct_nearest.severity_int,
            distinct_nearest.obs_name,
            distinct_nearest.obs_desc,
            distinct_nearest.measure,
            distinct_nearest.meas_length,
            distinct_nearest.dist_to_trail,
            1.0::double precision / distinct_nearest.trail_length AS meas_per_m,
            GREATEST(0::double precision, LEAST(1::double precision, (distinct_nearest.meas_length - distinct_nearest.obs_size / 2::double precision) / distinct_nearest.trail_length)) AS lower_m,
            GREATEST(0::double precision, LEAST(1::double precision, (distinct_nearest.meas_length + distinct_nearest.obs_size / 2::double precision) / distinct_nearest.trail_length)) AS upper_m
           FROM distinct_nearest
        ), events_adjusted AS (
         SELECT events.obs_id,
            events.trails_fid,
            events.trails_osm_id,
            events.trail_length,
            events.obs_size,
            events.severity_int,
            events.obs_name,
            events.obs_desc,
            events.measure,
            events.meas_length,
            events.dist_to_trail,
            events.meas_per_m,
            events.lower_m,
            events.upper_m,
            GREATEST(0::double precision, LEAST(1::double precision, events.lower_m)) AS lower_meas,
            GREATEST(0::double precision, LEAST(1::double precision, events.upper_m)) AS upper_meas
           FROM events
        ), event_points AS (
         SELECT st_lineinterpolatepoint(st_geometryn(trails.geom, 1), GREATEST(0::double precision, LEAST(1::double precision, events_adjusted.measure))) AS geom,
            events_adjusted.obs_id,
            events_adjusted.trails_fid,
            events_adjusted.trails_osm_id,
            events_adjusted.trail_length,
            events_adjusted.measure,
            events_adjusted.meas_length,
            events_adjusted.obs_size,
            events_adjusted.dist_to_trail,
            events_adjusted.meas_per_m,
            events_adjusted.lower_m,
            events_adjusted.upper_m,
            events_adjusted.lower_meas,
            events_adjusted.upper_meas
           FROM events_adjusted
             JOIN blog.trails ON trails.fid = events_adjusted.trails_fid
        ), cuts AS (
         SELECT events_adjusted.obs_id,
            events_adjusted.trails_fid,
            events_adjusted.lower_meas,
            events_adjusted.upper_meas,
            st_geometryn(trails.geom, 1) AS geom,
            trails.osm_id,
            trails.fid,
            trails.id
           FROM blog.trails
             JOIN events_adjusted ON trails.fid = events_adjusted.trails_fid
          ORDER BY events_adjusted.upper_meas
        )
 SELECT row_number() OVER (ORDER BY c.obs_id, c.trails_fid) AS segment_id,
    st_linesubstring(c.geom, c.lower_meas, c.upper_meas) AS geom,
    st_length(st_linesubstring(c.geom, c.lower_meas, c.upper_meas)) AS segment_length_m,
    c.obs_id,
    c.trails_fid,
    c.osm_id AS trails_osm_id,
    ea.severity_int,
    ea.obs_name,
    ea.obs_desc,
    ea.trail_length,
    ea.measure,
    ea.meas_length,
    ea.obs_size,
    ea.dist_to_trail,
    ea.meas_per_m,
    ea.lower_m,
    ea.upper_m,
    c.lower_meas,
    c.upper_meas
   FROM cuts c
     JOIN events_adjusted ea ON c.obs_id = ea.obs_id AND c.trails_fid = ea.trails_fid
WITH DATA;

