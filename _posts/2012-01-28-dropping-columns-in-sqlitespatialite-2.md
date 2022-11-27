---
id: 714
title: 'Dropping columns in sqlite/spatialite'
date: '2012-01-28T18:32:00-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=714'
permalink: /2012/01/28/dropping-columns-in-sqlitespatialite-2/
categories:
    - 'Data processing'
    - Database
    - GIS
    - Spatialite
---

[SQLite doesn’t have a nice](http://www.sqlite.org/faq.html#q11) ALTER TABLE DROP COLUMN command and neither does spatialite. Instead, you get to run a long sequence of commands like this. Here I wanted to drop all the extra columns from my huc12 layer for the country.

So, starting with a table that looks like this

&lt;pre class=”lang:pgsql decode:true”&gt;

CREATE TABLE “huc12” (  
 PK\_UID INTEGER PRIMARY KEY AUTOINCREMENT,  
 “OBJECTID” INTEGER,  
 “HUC\_8” TEXT,  
 “HUC\_10” TEXT,  
 “HUC\_12” TEXT,  
 “ACRES” DOUBLE,  
 “NCONTRB\_A” DOUBLE,  
 “HU\_10\_GNIS” TEXT,  
 “HU\_12\_GNIS” TEXT,  
 “HU\_10\_DS” TEXT,  
 “HU\_10\_NAME” TEXT,  
 “HU\_10\_MOD” TEXT,  
 “HU\_10\_TYPE” TEXT,  
 “HU\_12\_DS” TEXT,  
 “HU\_12\_NAME” TEXT,  
 “HU\_12\_MOD” TEXT,  
 “HU\_12\_TYPE” TEXT,  
 “META\_ID” TEXT,  
 “STATES” TEXT,  
 “GlobalID” TEXT,  
 “SHAPE\_Leng” DOUBLE,  
 “SHAPE\_Area” DOUBLE, “Geometry” MULTIPOLYGON)

&lt;/pre&gt;

and ending with

```
<pre class="lang:sql decode:1 ">

CREATE TABLE "huc12" (
 PK_UID INTEGER PRIMARY KEY AUTOINCREMENT,
 "HUC_12" TEXT,
 "ACRES" DOUBLE,
 "HU_12_GNIS" TEXT,
 "HU_12_NAME" TEXT,
 "HU_12_MOD" TEXT,
 "HU_12_TYPE" TEXT,
 "GlobalID" TEXT,
 "Geometry" MULTIPOLYGON)
```

I ran this stuff in the middle.

```
<pre class="lang:sql decode:1 ">

BEGIN TRANSACTION;
 CREATE temporary TABLE "huc12sm" (
 PK_UID INTEGER PRIMARY KEY AUTOINCREMENT,
 "HUC_12" TEXT,
 "ACRES" DOUBLE,
 "HU_12_GNIS" TEXT,
 "HU_12_NAME" TEXT,
 "HU_12_MOD" TEXT,
 "HU_12_TYPE" TEXT,
 "GlobalID" TEXT,
 "Geometry" MULTIPOLYGON);
 INSERT INTO huc12sm SELECT PK_UID, HUC_12, ACRES, HU_12_GNIS, HU_12_NAME, HU_12_MOD, HU_12_TYPE, GlobalID, Geometry FROM huc12;
 DROP TABLE huc12;
 CREATE TABLE "huc12" (
 PK_UID INTEGER PRIMARY KEY AUTOINCREMENT,
 "HUC_12" TEXT,
 "ACRES" DOUBLE,
 "HU_12_GNIS" TEXT,
 "HU_12_NAME" TEXT,
 "HU_12_MOD" TEXT,
 "HU_12_TYPE" TEXT,
 "GlobalID" TEXT,
 "Geometry" MULTIPOLYGON);
 INSERT INTO huc12 SELECT PK_UID, HUC_12, ACRES, HU_12_GNIS, HU_12_NAME, HU_12_MOD, HU_12_TYPE, GlobalID, Geometry FROM huc12sm;
 DROP TABLE huc12sm;
 COMMIT;
 VACUUM;
 HUC_12, ACRES, HU_12_GNIS, HU_12
 SELECT Count(*), GeometryType("Geometry"), Srid("Geometry"), CoordDimension("Geometry")
 FROM "huc12"
 GROUP BY 2, 3, 4;

SELECT RebuildGeometryTriggers('huc12', 'Geometry')

```

I wish someone would package this stuff into a nice function… hint hint.