---
id: 751
title: 'PostgreSQL/PostGIS and ArcGIS ArcMap 10.2'
date: '2013-08-22T21:56:29-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=751'
permalink: /2013/08/22/postgresqlpostgis-and-arcgis-arcmap-10-2/
categories:
    - 'Data processing'
    - Database
    - GIS
    - Spatialite
---

Of course good things come to those who wait (at least that’s the wisdom that I pass along to my kids). We expect that after we’re done waiting we will get something awesome and worth the wait, right? But sometimes what we end up getting is a little underwhelming and as adults we’re forced to just accept it with a shrug and move on. I feel like that right now and it will become clear why by the end of the post.

But, for now I rejoice in the good part which is that I can finally connect to my handy Postgres/PostGIS database and see my data there using ArcMap. I can query, style and do most other basic things that I have tried. To see how to do this you may want to take a look at the [docs](http://resources.arcgis.com/en/help/main/10.2/index.html#/A_quick_tour_of_geodatabases_in_PostgreSQL/002p000000pt000000/). In this case I installed Postgres 9.2.4 and PostGIS 2.0.something using the EnterpriseDB installer and Stackbuilder ([http://postgis.net/windows\_downloads](http://postgis.net/windows_downloads)) . Esri will give you Postgres 9.2.2 which still has that [nasty security flaw](http://www.postgresql.org/support/security/faq/2013-04-04/) in it that everyone else upgraded from months ago. 9.2.4 seems to be working fine though using the 9.2.2 client drivers.

Note that Esri keeps the Postgres client drivers away from you unless you are “authorized” through your customer number to have these free/Free drivers that are not published by Esri. You must download them separately from the ArcMap install. Here’s mine [PostgreSQLClientLibs922](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2013/08/PostgreSQLClientLibs922.zip) if you can’t get access to them cuz you are trying the demo of ArcMap 10.2 – which makes you not worthy of gaining access to these drivers.

[![postgres_drivers](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2013/08/postgres_drivers-300x163.png)](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2013/08/postgres_drivers.png)

BTW, if you are a better reader than I you would immediately note that the bit-ness of the drivers should match the \*client\* software that you are installing them into, NOT the database you are connecting to. So, by installing the 64-bit database server, then trying to get ArcMap to use the 64-bit drivers I was doomed to suffer through the useless Esri errors for an hour until I had a face-palm moment. You must give ArcMap the **\*32-bit\*** drivers.

Bug alert: I can’t reproduce this right now, BUT when I first created the connection ArcMap complained because its default database port for Postgres came up as 54321. If you get an error while first connecting, recall that by default Postgres’s port is 5432. So you need to force that in the connection “Instance” field by entering the machine followed by a comma, then the port number like 127.0.0.1,5432 as shown below.

[![db_port](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2013/08/db_port-300x211.png)](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2013/08/db_port.png)

Once you connect this little issue goes away &lt;shrug&gt;.

So I finally got the DB connection working and was very excited. Here’s a pic.

[![database_data](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2013/08/database_data-300x201.png)](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2013/08/database_data.png)

You see some poly data from PostGIS (make sure that you set the SRID when loading) and a few points from my handy Spatialite database (no database connection needed to display these Spatialite data. Must be the GDAL/OGR baked right in). Bill Dollins explains a little more about using Spatialite data in ArcMap in this [post.](http://blog.geomusings.com/2013/08/07/spatialite-and-arcgis-10-dot-2/)From the docs it seems that Esri is supporting Spatialite 4.0, which may also support the current 4.1 as well.

Here’s the similar view from QGIS.

[![qgis_post](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2013/08/qgis_post-300x191.png)](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2013/08/qgis_post.png)

Ok, so now I’m feeling pretty good about myself. How about trying to edit some of these non-geodatabase data in ArcMap? Without too much drama, the short answer seems to be that you can’t. When Esri says “you may USE the database data in ArcMap” they mean you may VIEW it – and only view it. You may not edit PostGIS data directly in ArcMap.

[![no_editing](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2013/08/no_editing-300x100.png)](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2013/08/no_editing.png)

It’s not the end of the world since I can do most things in QGIS running side-by-side. But it’s annoying.

I’m pretty sure that the Spatialite layer can’t be edited either. Despite setting all layers displayed to EPSG SRID = 4326 (WGS84) ArcMap still feels that they layers are not in the same coordinate ref. Then goes on to complain about not being able to edit the layer.

[![postgis_coordref](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2013/08/postgis_coordref-300x213.png)](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2013/08/postgis_coordref.png)[![spatiliate_cref](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2013/08/spatiliate_cref-300x230.png)](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2013/08/spatiliate_cref.png)[![stillnoedit](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2013/08/stillnoedit-300x78.png)](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2013/08/stillnoedit.png)

So, I’ve been waiting a long time to be able to use my non-ESRI geodatabase database geodata in ArcMap with all the functions I expect including editing. But I guess I have to wait a bit longer… sigh..

Here is a picture of the geodata as seen by the free and included Postgres IDE pgAdmin III

[![gis_data_indb](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2013/08/gis_data_indb-268x300.png)](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2013/08/gis_data_indb.png)

**UPDATE:** I should mention one other thing. I did make some edits to a layer using QGIS and was hoping to see them appear in ArcMap after committing them to the DB. Alas, this did not happen and I had to remove/re-add the layer for the edits to appear. So, it seems that perhaps ArcMap is caching the layer (perhaps in a little hidden FGDB) when it loads.

The recommended approach for editing PostGIS data through off-the-shelf Esriware seems to be through the REST services and a feature service provided by ArcGIS Server 10.2 (since the [Spatial Data Server (SDS)](http://resources.arcgis.com/en/help/main/10.1/index.html#//01sq00000005000000) ) is now deprecated and appears to be rolled into Arc Server itself. I do hope that these edits made through Arc Server are immediately available through the online stuff and will not require refreshing any cache.

**<span style="text-decoration: underline;">Resources:</span>**

- Of course for simple non-editable basemap needs all you need is a simple tile server sending out pre-rendered pics just like Google does (there are a bunch of options for serving basemaps from [MBTiles](http://www.mapbox.com/developers/mbtiles/) using [php ](http://projects.bryanmcbride.com/php-mbtiles-server/leaflet.html)[\[1\]](http://gis.stackexchange.com/questions/45465/reusing-cached-tiles-with-leaflet-mbtiles-and-mbtiles-php), python, javascript through [nodejs](http://fuzzytolerance.info/blog/screencast-26-simple-mbtiles-server-in-node/http://), etc. and the ability to create to create an mbtile file is appearing in more software than just [tilemill, ](http://fuzzytolerance.info/blog/automating-tile-generation-with-tilemill/http://)[\[2\], ](http://fuzzytolerance.info/blog/screencast-11-a-quick-run-through-tilemill/)[\[3\]](http://fuzzytolerance.info/blog/screencast-16-tilemill-part-iii-all-done/)) – <http://blog.klokantech.com/2013/08/tileserver-wmts-from-map-tiles-and.html>
- The ability to read/write geodata in database is dependent on the software being able to understand the format in which the data are stored in the database. Most spatially-enabled DBs use some derivation of the well-known binary (WKB) for storing GEOMETRY or GEOGRAPHY. But each DB interprets that spec a little differently resulting in no two databases actually storing their data in the exact same format. We had an opportunity again recently for at least two projects to use the same format for storing vector geometries as the GeoPackage ALMOST accepted the Spatialite format. But in the end it was rejected.These pages highlight this concept and the issue: 
    - <http://cholmes.wordpress.com/2013/08/20/spatialite-and-geopackage/>
    - <http://www.gaia-gis.it/gaia-sins/BLOB-Geometry.html>
    - [http://resources.arcgis.com/en/help/main/10.2/index.html#/What\_is\_the\_PostGIS\_geometry\_type/002p0000006t000000/](http://resources.arcgis.com/en/help/main/10.2/index.html#/What_is_the_PostGIS_geometry_type/002p0000006t000000/)