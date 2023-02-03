---
id: 230
title: 'Creating an ST_ table and view in Oracle for ArcSDE'
date: '2011-09-01T15:30:10-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'https://johnzastrow.github.io/2011/09/01/creating-an-st_-table-and-view-in-oracle-for-arcsde/'
permalink: /2011/09/01/creating-an-st_-table-and-view-in-oracle-for-arcsde/
categories:
    - 'Data processing'
    - Database
    - GIS
---

I created a table with ST_GEOMETRY as a column with SQL, inserted records, created a view with some filtering and registered both with ArcSDE.

They are both accessible and useable from ArcMap and ArcCatalog.

Steps:  
create and load the table

```sql  
CREATE TABLE TEST_GIS_PERMITS (OID integer NOT NULL, permit_no nvarchar2(12), location sde.st_geometry);

CREATE INDEX IX1_TGP ON TEST_GIS_PERMITS (LOCATION) INDEXTYPE IS SDE.ST_SPATIAL_INDEX PARAMETERS('ST_GRIDS = 4644.5262325165 ST_SRID = 8 ST_COMMIT_ROWS = 10000 PCTFREE 0 INITRANS 4′) NOPARALLEL;

CREATE UNIQUE INDEX UX1_TGP ON TEST_GIS_PERMITS (OID) NOLOGGING NOPARALLEL;

INSERT INTO TEST_GIS_PERMITS (OID, permit_no, location) (SELECT objectid, permit_no, shape FROM SW_PERMITS_09_2007);

commit;  
```

then create the view

```sql 

CREATE VIEW V_TEST_GIS_PERMITS

AS

SELECT oid, permit_no, location

FROM TEST_GIS_PERMITS

WHERE SUBSTR(permit_no,1,3) = 'A90′;

 ```

register the layer with SDE

```bash 

C:\\Users\\myname&gt;sdelayer -o register -l TEST_GIS_PERMITS,LOCATION -t ST_GEOMETRY -C OID,USER -u GA_DEV -p devGA0628 -s DIVS135GEODEV -i sde:oracle11g:/:GA_DEV -e p -R 1

ArcSDE 10.0 for Oracle11g Build 685 Fri May 14 12:05:43 2010  
Layer Administration Utility  
—————————————————–

Successfully Created Layer.

```

 Register the view with SDE

```bash 

C:\\Users\\myname&gt;sdelayer -o register -l V_TEST_GIS_PERMITS,LOCATION -t ST_GEOMETRY -C OID,USER -u GA_DEV -p devGA0628 -s DIVS135GEODEV -i sde:oracle11g:/:GA_DEV -e p -R 1

ArcSDE 10.0 for Oracle11g Build 685 Fri May 14 12:05:43 2010

Layer Administration Utility

—————————————————–

<span>Successfully Created Layer.</span>

```

Now we can read and write to this layer using ESRI's ST_ SQL or ArcMap. and read the latest records from the view (which limits the out of date records since we are versioning using home grown methods in Oracle tables) with ArcGIS Server OR ArcMAP OR our Oracle/.Net application which doesn't care about the geometry.