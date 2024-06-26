---
layout: post
title: Linear referencing events in PostGIS
subtitle: Points snapped to lines, describing linear conditions along the lines
gh-badge: [star, fork, follow]
date: '2023-02-02T12:47:41-05:00'
tags: [geodata, gis, spatial, data management, PostGIS, Spatialite]
comments: true
---

**This will be a growing post on my exploration of linear referencing in PostGIS.**

#### Intro

[![Example](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/linref1.jpg)](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/linref1.jpg)
*Figure 1. The real data* as shown in QGIS. Observations (*obs*) are point GPS collected by crews (exaggerated error included) these have sizes recorded from the field [pink highlighted attribute labels]. The process below snaps the observations to the nearest point along the trail line to eventually create *event_points* along with some ancillary attributes for fun. Event_points and their associated measures [light blue highlighted attribute labels] are then converted to linear *segments* that are referenced to the trail line and are sized according to the size recorded in the field with the *event_point* at the center of each segment. Other attributes are calculated and shown to demonstrate the concepts, but are not likely useful otherwise. The vertices are simply point coordinates from the line geometry - ignore them. GIS and PostGIS are like chocolate and peanut butter - you never eat one without the other.



{: .box-note}
<b>What is linear referencing or linear referencing systems (LRS): </b>
Adapted from From: [GIS Geography](https://gisgeography.com/linear-referencing-systems). [Linear referencing](http://postgis.net/workshops/postgis-intro/linear_referencing.html) systems store, or reference, relative positions on an existing line feature stored physically in the GIS with normal line geometry (coordinates for each vertex). Unlike basic line geometry (simple pairs of coordinates that describes points that when connected in the right order describe a line), linear referencing systems have m-values, which stands for “measurement” along the line feature (only lines, because we're talking about "linear" referencing). It records how far a reference (event point or segment) is along a line as a percentage from the "start" of the line - the first point. The reference may describe linear events (this article we'll call them segments for clarity) from each point event (or pair of points). Because the segment describes a measure along the physical line (the one with geometry) but does not contain geometry itself, the original line feature can change (the trail line gets moved due to erosion on the ground) and the segment magically follows it without edits. Linear events, or segments, can also overlap, where lines in a single GIS should not to maintain proper topology.  

{: .box-success}
**Use case** **- why is this useful?**: Consider assisting a land trust with recording field information about parts of trails that need repair. The trial lines almost never change, but the conditions on the trails change frequently. I don't want to record/delete all the geometry of a little line every time I want to describe a problem on the trail, and then its repair. I want to "reference" parts of the existing trail line.


**Process:** Crews travel the trails and collect observations from parts of the trails that need repair to turn into tasks for asset management, costing, and future work. Each observation might contain the following items:

1. **Coordinate pair (X,Y) or point location** (with error from GPS interference) from the part of the trail needing repair. Point is collected in the middle of the part. This is required input.
2. **Size in meters of the part needing repair** if the trail need 10 meters repaired, record 10 meters. This is required input.
3. **Notes and details about the condition and repair needed**. This is optional.

Then the organization would be able to produce reports, maps, and other products to visualize and otherwise manage the repair of the trails and efficiently track the progress against the conditions through simple updates to non-geometric records in the database. 



Therefore, below is an exploration of using Linear Referencing in the PostgreSQL/[PostGIS](https://postgis.net/docs/reference.html#Linear_Referencing) spatial database to solve the data storage and representation. I should note that my former desktop-level crush, [Spatialite](https://www.gaia-gis.it/gaia-sins/spatialite_topics.html), has [linear referencing](https://www.gaia-gis.it/gaia-sins/spatialite-sql-5.0.1.html#p14-) as well, and it's at least partially based on the GEOS engine that PostGIS uses. However there may be [differences](https://gis.stackexchange.com/questions/195279/dynamic-linear-referencing-of-events-in-qgis-from-excel-or-csv-using-virtual-lay) in how referencing is done between the two spatial databases.


#### CLEANUP: 
1. simplify names even more for demo
2. final version with month_year in output names
3. add prep steps like turn trails line into 3D/4D
4. add links to example data
5. cleanup DDL examples

## METHODS
1. This article uses pure PostGIS to perform the analysis, build the segments, and store everything.


#### INPUTS:
1.  **Observation table** containing point events, called event_points in the image, but they might be observations from our example use case. Here all work is being done in the schema called 'greatpond'. References are prefixed with that schema.

```sql
CREATE TABLE IF NOT EXISTS greatpond.obs
(
    id serial,
    name character varying(50),
    "desc" character varying(250),
    severity_int integer,
    size numeric NOT NULL,
--    geom geometry, -- we will load this field with POINTs, not MULTIPOINTs
    PRIMARY KEY (id)
);

COMMENT ON TABLE greatpond.obs
    IS 'Field observations';
	
	-- Add a spatial column to the table
	-- AddGeometryColumn(varchar schema_name, varchar table_name, 
	-- 		varchar column_name, integer srid, varchar type, integer dimension, boolean use_typmod=true);

SELECT AddGeometryColumn ('greatpond','obs','geom',6348,'POINT',2); -- EPSG:6348 - NAD83(2011) / UTM zone 19N
	
	CREATE INDEX obs_geom_idx
  ON greatpond.obs
  USING GIST (geom);
```

[![Example](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/event_points_info.png)](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/event_points_info.png)
*Figure 2. Notice the horizontal units are in meters. Do that.*


2. **Line features** to reference the observations against. In this case, we're using a trails layer I got from OpenStreetMap.

[![Example](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/trails.png)](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/trails.png)
*Figure 3. Notice the horizontal units are in meters. Do that again.*



### PROCESS:
**Step 1. Create events table** as the first output from the primary input which is the observations table. The other input is line layer (here trails) and here the layer is of type LINESTRINGMZ (single lines with room for M and Z measures), not MULTILINESTRING. 

This step will create the new events table from observations.

We first need to get a candidate set of maybe-closest trails, ordered by id and distance. In this example the trails layer is line layer of the trail, and observations are points of recorded single observations along the trail lines. We are going to keep osm_id as the primary id for the trails. 

```sql
DROP TABLE IF EXISTS greatpond.events;
CREATE TABLE greatpond.events AS
WITH ordered_nearest AS (
SELECT
  ST_GeometryN(greatpond.trails.geom,1) AS trails_geom, -- Reads in geom. Return the 1-based Nth element geometry of an input geometry.
  greatpond.trails.fid AS trails_fid,
  greatpond.trails.osm_id AS trails_osm_id,
  ST_LENGTH(greatpond.trails.geom) AS trail_length ,
  greatpond.obs.geom AS obs_geom,
  greatpond.obs.size AS obs_size,
  greatpond.obs.id AS obs_id,
  ST_Distance(greatpond.trails.geom, greatpond.obs.geom) AS dist_to_trail
FROM greatpond.trails
  JOIN greatpond.obs
  ON ST_DWithin(greatpond.trails.geom, greatpond.obs.geom, 200) -- Returns true if the geometries are within a given distance, in this case 200m
ORDER BY obs_id, dist_to_trail ASC
);
```

 We use the 'distinct on' PostgreSQL feature to get the first trail (the nearest) for each unique trail fid. We can then pass that one trail into ST_LineLocatePoint along with its candidate observation to calculate the measure along the trail.

```sql
SELECT
  DISTINCT ON (obs_id)
  obs_id,
  trails_fid,
  trails_osm_id,
  trail_length,
  obs_size,
  ST_LineLocatePoint(trails_geom, obs_geom) AS measure,
  ST_LineLocatePoint(trails_geom, obs_geom) * trail_length AS meas_length,
  dist_to_trail
FROM ordered_nearest;
```

**Step 1a. Update the table with some more value.** Primary keys are useful for visualization softwares. I also added some values to allow me to check on distances above and below the event to allow me to satisfy some curiosity and QC the outputs.

```sql

ALTER TABLE greatpond.events ADD PRIMARY KEY (obs_id);
ALTER TABLE greatpond.events 
	ADD column meas_per_m numeric, 
	ADD column lower_m numeric, 
	ADD column upper_m numeric, 
	ADD column lower_meas numeric, 
	ADD column upper_meas numeric
 ;

update greatpond.events SET
	meas_per_m = measure / meas_length,
	lower_m = meas_length - (obs_size/2),
	upper_m = meas_length + (obs_size/2);
	
update greatpond.events SET
	lower_meas = meas_per_m * lower_m,
	upper_meas = meas_per_m * upper_m -- this field did not update the first time so process as second step.
;
```

Here we force measures to be between 0 and 1, because a negative distance doesn't make sense. This script is then sensitive to observations being placed near the end of line segments... and therefore short segments. Consider dissolving (merging) segments that end at places other than intersections with other segments in the same layer.

```sql
update greatpond.events SET
	lower_meas = 0 where lower_meas < 0;
update greatpond.events SET
	lower_meas = 1 where lower_meas > 1;
update greatpond.events SET
	upper_meas = 1 where upper_meas > 1;
update greatpond.events SET
	upper_meas = 0 where lower_meas < 0;
;
```

**Step 2. Create events layer with point objects.** New table that turns events into spatial objects, points snapped to the line in this case

```sql

DROP TABLE IF EXISTS greatpond.event_points;
CREATE table greatpond.event_points AS
SELECT
  ST_LineInterpolatePoint(ST_GeometryN(greatpond.trails.geom, 1), events.measure) AS geom,
  obs_id,
  trails_fid,
  trails_osm_id,
  trail_length,
  measure,
  meas_length,
  obs_size,
  dist_to_trail,
  meas_per_m,
  lower_m ,
  upper_m,
  lower_meas,
  upper_meas
FROM greatpond.events
JOIN greatpond.trails
ON (greatpond.trails.fid = greatpond.events.trails_fid);

```

**Step 3. Create observation event segments based on observed sizes**

```sql

DROP TABLE IF EXISTS greatpond.segments;
create table greatpond.segments as (
WITH cuts AS (
    SELECT events.obs_id, events.trails_fid, events.lower_meas, events.upper_meas,	
	ST_GeometryN(trails.geom,1) as geom, trails.osm_id, trails.fid, trails.id 
	from greatpond.trails
	inner join greatpond.events
	ON trails.fid=events.trails_fid order by events.upper_meas 
)
SELECT
	ST_LineSubstring(geom, lower_meas, upper_meas) as mygeom, obs_id, trails_fid, lower_meas, upper_meas
FROM 
    cuts);
	
	ALTER TABLE greatpond.segments ADD column id serial; 
	ALTER TABLE greatpond.segments ADD PRIMARY KEY (id);

```

In this exploration I created intermediate and final products as physical tables. However, you can also just create them as [views](https://www.postgresql.org/docs/current/sql-createview.html) so that edits to the original *obs* table would result in automatic updates cascading into the final product without re-running anything. Below is Step 3 above as a database view by replacing ```create table``` with ```create view``` and removing the ability to have a [primary key](). You might also consider [Materialized Views](https://blog.devart.com/postgresql-materialized-views.html) if performance matters and you want a [unique index](https://www.postgresql.org/docs/current/sql-createindex.html) as a quasi replacement for a [PK](https://stackoverflow.com/questions/54154897/create-primary-key-on-materialized-view-in-postgres), but the updates would not be immediate as with a traditional view.

```sql
create view greatpond.v_segments as (
WITH cuts AS (
    SELECT events.obs_id, events.trails_fid, events.lower_meas, events.upper_meas,	
	ST_GeometryN(trails.geom,1) as geom, trails.osm_id, trails.fid, trails.id 
	from greatpond.trails
	inner join greatpond.events
	ON trails.fid=events.trails_fid order by events.upper_meas 
)
SELECT
	ST_LineSubstring(geom, lower_meas, upper_meas) as mygeom, obs_id, trails_fid, lower_meas, upper_meas
FROM 
    cuts);
```

Here it is graphically executing through the DB Manager in QGIS


[![1](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/lr_as_view.png)](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/lr_as_view.png)





#### RESULTS:



Here are the physical outputs from above

[![2](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/lr_outputs.png)](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/lr_outputs.png)


## REFERENCES:
1. [![https://gis.stackexchange.com/questions/112282/splitting-lines-into-non-overlapping-subsets-based-on-points-using-postgis]](https://gis.stackexchange.com/questions/112282/splitting-lines-into-non-overlapping-subsets-based-on-points-using-postgis)
2. [https://gis.stackexchange.com/questions/332213/splitting-lines-with-points-using-postgis?utm_source=pocket_mylist](https://gis.stackexchange.com/questions/332213/splitting-lines-with-points-using-postgis?utm_source=pocket_mylist)
3. [https://www.fhwa.dot.gov/policyinformation/hpms/documents/arnold_reference_manual_2014.pdf](https://www.fhwa.dot.gov/policyinformation/hpms/documents/arnold_reference_manual_2014.pdf)
4. [http://postgis.net/workshops/postgis-intro/linear_referencing.html](http://postgis.net/workshops/postgis-intro/linear_referencing.html)
5. [https://postgis.net/docs/reference.html#Linear_Referencing](https://postgis.net/docs/reference.html#Linear_Referencing ) 

### [Experimental](https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/creating-diagrams) [mermaid](https://mermaid.live/) mindmap

```mermaid
mindmap
  root((Open Source Spatial Databases))
    PostgreSQL
      PostGIS
        GEOS
    SQLite
      Geopackage
         Storage only
      Spatialite
        GEOS
        Builtin
    MySQL
      Boost Cplus p libraries
    MariaDB
      TBD
```

