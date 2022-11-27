---
id: 138
title: 'Accessing versioned geodata in ArcSDE with SQL'
date: '2011-03-30T09:29:37-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=138'
permalink: /2011/03/30/accessing-versioned-geodata-in-arcsde-with-sql/
categories:
    - Database
    - GIS
---

This is excerpted from the following forum post:

“We’re running SDE and have several featuresets with versioning turned on…. We have numerous non-GIS applications that use SQL queries to access information from the spatial data. However, we don’t get all the features that I’m expecting to be returned. How do I access the features that have been added/deleted (and are, therefore, “hidden” from a straight SQL query)?”

As long as it is just the attributes that you are after, you can set up a multi-versioned view using sdetable.exe.

**```
sdetable.exe -o create_mv_view -T mvv_wMeter -t wMeter
```**

Then on your db connection, you execute the set\_current\_version stored proc to set the version, then issue your select statement on the multi-versioned view:

**```
exec sde.set_current_version 'SDE.SOMEOTHERVERSION'<br />
GO<br />
Select COUNT(*) from mvv_wMeter ; 
```**

> <span style="color: #999999;">i don’t have it my example, but sdetable.exe needs db connection info arguments: -s,-i,-u,-p,-D in some combination depending on your config (I usually just set the SDEDATABASE,SDEINSTANCE,SDESERVER env vars in a batch file–sdetable use the env vars if they exist). – Jay Cummins Aug 6 ’10 at 19:39</span>

[I think this ESRI support page may be relevant.](http://help.arcgis.com/en/arcgisdesktop/10.0/help/index.html#/in_SQL_Server/006z0000001r000000/)

I believe it is worth posting the warnings on that page here:

<span style="color: #999999;"><ins datetime="2011-03-30T14:23:06+00:00">Never use database management system (DBMS) tools to update any row ID (object ID) field maintained by Ar</ins>cSDE in the database. These object ID fields are allocated and managed by the geodatabase and, therefore, should not be altered using SQL.</span>

<span style="color: #999999;"> Never edit the DEFAULT version of the geodatabase using SQL. Starting an edit session on a version obtains an exclusive lock on the state that the version references. If you lock the DEFAULT version, you prevent ArcGIS users from connecting to the geodatabase.</span>

In the 9.3 help page they also warned against editing non-simple feature class attributes (Geometric Networks, Topologies, etc.) via SQL.