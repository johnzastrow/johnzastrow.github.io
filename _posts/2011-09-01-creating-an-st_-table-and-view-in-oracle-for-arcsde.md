---
id: 230
title: 'Creating an ST_ table and view in Oracle for ArcSDE'
date: '2011-09-01T15:30:10-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/2011/09/01/creating-an-st_-table-and-view-in-oracle-for-arcsde/'
permalink: /2011/09/01/creating-an-st_-table-and-view-in-oracle-for-arcsde/
categories:
    - 'Data processing'
    - Database
    - GIS
---

I created a table with ST\_GEOMETRY as a column with SQL, inserted records, created a view with some filtering and registered both with ArcSDE.

They are both accessible and useable from ArcMap and ArcCatalog.

Steps:  
create and load the table

 \[cc lang=’sql’ \]  
CREATE TABLE TEST\_GIS\_PERMITS (OID integer NOT NULL, permit\_no nvarchar2(12), location sde.st\_geometry);

CREATE INDEX IX1\_TGP ON TEST\_GIS\_PERMITS (LOCATION) INDEXTYPE IS SDE.ST\_SPATIAL\_INDEX PARAMETERS(‘ST\_GRIDS = 4644.5262325165 ST\_SRID = 8 ST\_COMMIT\_ROWS = 10000 PCTFREE 0 INITRANS 4′) NOPARALLEL;

CREATE UNIQUE INDEX UX1\_TGP ON TEST\_GIS\_PERMITS (OID) NOLOGGING NOPARALLEL;

INSERT INTO TEST\_GIS\_PERMITS (OID, permit\_no, location) (SELECT objectid, permit\_no, shape FROM SW\_PERMITS\_09\_2007);

commit;  
\[/cc\]

then create the view

\[cc lang=’sql’ \]

CREATE VIEW V\_TEST\_GIS\_PERMITS

AS

SELECT oid, permit\_no, location

FROM TEST\_GIS\_PERMITS

WHERE SUBSTR(permit\_no,1,3) = ‘A90′;

 \[/cc\]

register the layer with SDE

\[cc lang=’bash’ \]

C:\\Users\\myname&gt;sdelayer -o register -l TEST\_GIS\_PERMITS,LOCATION -t ST\_GEOMETRY -C OID,USER -u GA\_DEV -p devGA0628 -s DIVS135GEODEV -i sde:oracle11g:/:GA\_DEV -e p -R 1

ArcSDE 10.0 for Oracle11g Build 685 Fri May 14 12:05:43 2010  
Layer Administration Utility  
—————————————————–

Successfully Created Layer.

\[/cc\]

 Register the view with SDE

\[cc lang=’bash’ \]

C:\\Users\\myname&gt;sdelayer -o register -l V\_TEST\_GIS\_PERMITS,LOCATION -t ST\_GEOMETRY -C OID,USER -u GA\_DEV -p devGA0628 -s DIVS135GEODEV -i sde:oracle11g:/:GA\_DEV -e p -R 1

ArcSDE 10.0 for Oracle11g Build 685 Fri May 14 12:05:43 2010

Layer Administration Utility

—————————————————–

<span>Successfully Created Layer.</span>

\[/cc\]

Now we can read and write to this layer using ESRI’s ST\_ SQL or ArcMap. and read the latest records from the view (which limits the out of date records since we are versioning using home grown methods in Oracle tables) with ArcGIS Server OR ArcMAP OR our Oracle/.Net application which doesn’t care about the geometry.