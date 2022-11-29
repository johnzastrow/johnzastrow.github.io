---
id: 281
title: 'Example with PHP and Spatialite, part 1'
date: '2012-01-16T09:47:10-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=281'
permalink: /2012/01/16/example-with-php-and-spatialite-part-1/
categories:
    - 'Data processing'
    - Database
    - GIS
    - Linux
    - Spatialite
    - Uncategorized
    - Web
---

*This post is part of a series [\[1\]](http://northredoubt.com/n/2012/01/16/example-with-php-and-spatialite-part-1/ "Example with PHP and Spatialite, part 1"), [\[2\]](http://northredoubt.com/n/2012/01/17/example-with-php-and-spatialite-part-2/ "Example with PHP and Spatialite, part 2"), [\[3\]](http://northredoubt.com/n/2012/01/18/spatialite-and-spatial-indexes/ "Spatialite and Spatial Indexes"), [\[4\]](http://northredoubt.com/n/2012/01/20/spatialite-speed-test/ "Spatialite Speed Test")*

So, PHP supports SQLite out of the box (<http://www.sqlite.org/>, now at 3.7.10), making it a nice combo if you want to do some reads from your page. My impression is that SQLite is not recommended if you want stuff with database writes and you have more than a couple visitors. But reading seems to be fine.

I think this fits my use cases just fine as I just want to hang out some very basic utility services that can run on the “single beige box in the corner” or the “beige cloud in the sky” with few resources needed. First, I want to create a simple REST service that, when passed a pair of long/lat coordinates, will do nothing but return that name of the county they are in. Then I’ll do one for watershed identifiers ([USDA WBD HUC12](http://www.nrcs.usda.gov/wps/portal/nrcs/main/national/ngmc) to be exact), and eventually maybe I’ll work up to a nearest place service (<http://www.geonames.org/>) and so on. Maybe even some downstream/upstream routing with Spatialite’s network utilities [\[1\]](http://www.gaia-gis.it/spatialite-2.3.1/spatialite-network-2.3.1.html), [\[2\]](http://www.gaia-gis.it/gaia-sins/Using-Routing.pdf), [\[3\]](http://www.gaia-gis.it/spatialite-2.4.0-4/spatialite-cookbook/html/dijkstra.html).

Of course, these are spatial functions so I’m using the spatial extension to SQLite called Spatialite found at <http://www.gaia-gis.it/gaia-sins/>. ***I find Spatialite to be a profoundly elegant amalgam of existing projects (SQLite and GEOS) and new, efficient and pragmatic programming that fills an empty niche.*** Here that niche is don’t make me deploy anything more than I need. I simply want some basic, re-usable services that don’t do much, including have their data updated – and I don’t want to run a [heavy spatial infrastructure](http://postgis.refractions.net/) just to cheaply answer some basic questions on a $6/month virtual, private, cloud LA<span style="text-decoration: line-through;">M</span>P box with 256MB of memory or this little Pentium 4 appliance running in my snack drawer at work.

So, I began compiling spatialite, and at the time I was using 3.0beta1a, so I just kept running with it. I’m still learning the basics of spatialite so I dinked around a bit. Then I followed the instructions for getting spatialite running within PHP [\[here\]](http://www.gaia-gis.it/spatialite-2.4.0-4/spatialite-cookbook/html/php.html) and/or [\[here\]](http://www.gaia-gis.it/spatialite-2.4.0-4/splite-php.html) (not sure which one is the official guide. The site has been migrating to a new infrastructure lately).

After making way too many typos, I got it working and am getting the expected output. I also added some timer code which tells me that from my Ubuntu VM running on my 6-month-old laptop I’m completing these ~30,000 operations in about 6 seconds against the in-memory database, including opening and closing the connection to a database and tables that are created each page load.

<figure aria-describedby="caption-attachment-284" class="wp-caption alignnone" id="attachment_284" style="width: 300px">[![Sample spatialite with PHP screen](http://northredoubt.com/n/wp-content/uploads/2012/01/Screenshot-at-2012-01-16-094923-300x157.png "Sample spatialite with PHP screen")](http://northredoubt.com/n/wp-content/uploads/2012/01/Screenshot-at-2012-01-16-094923.png)<figcaption class="wp-caption-text" id="caption-attachment-284">Sample spatialite with PHP screen</figcaption></figure>

My next exercise will be to figure out how to connect to an existing disk-based DB and try some simpler operations. My goal will be to get my operations out the door in about 1 second on modest hardware under no load.

\[cc lang=’php’ \]

Testing SpatiaLite on PHP

# Testing SpatiaLite on PHP

loadExtension(‘libspatialite.so’);

\# enabling Spatial Metadata  
\# using v.2.4.0 this automatically initializes SPATIAL\_REF\_SYS  
\# and GEOMETRY\_COLUMNS  
$db-&gt;exec(“SELECT InitSpatialMetadata()”);

\# reporting some version info  
$rs = $db-&gt;query(‘SELECT sqlite\_version()’);  
while ($row = $rs-&gt;fetchArray())  
{  
print ”

### SQLite version: $row\[0\]

“;  
}  
$rs = $db-&gt;query(‘SELECT spatialite\_version()’);  
while ($row = $rs-&gt;fetchArray())  
{  
print ”

### SpatiaLite version: $row\[0\]

“;  
}

\# creating a POINT table  
$sql = “CREATE TABLE test\_pt (“;  
$sql .= “id INTEGER NOT NULL PRIMARY KEY,”;  
$sql .= “name TEXT NOT NULL)”;  
$db-&gt;exec($sql);  
\# creating a POINT Geometry column  
$sql = “SELECT AddGeometryColumn(‘test\_pt’, “;  
$sql .= “‘geom’, 4326, ‘POINT’, ‘XY’)”;  
$db-&gt;exec($sql);

\# creating a LINESTRING table  
$sql = “CREATE TABLE test\_ln (“;  
$sql .= “id INTEGER NOT NULL PRIMARY KEY,”;  
$sql .= “name TEXT NOT NULL)”;  
$db-&gt;exec($sql);  
\# creating a LINESTRING Geometry column  
$sql = “SELECT AddGeometryColumn(‘test\_ln’, “;  
$sql .= “‘geom’, 4326, ‘LINESTRING’, ‘XY’)”;  
$db-&gt;exec($sql);

\# creating a POLYGON table  
$sql = “CREATE TABLE test\_pg (“;  
$sql .= “id INTEGER NOT NULL PRIMARY KEY,”;  
$sql .= “name TEXT NOT NULL)”;  
$db-&gt;exec($sql);  
\# creating a POLYGON Geometry column  
$sql = “SELECT AddGeometryColumn(‘test\_pg’, “;  
$sql .= “‘geom’, 4326, ‘POLYGON’, ‘XY’)”;  
$db-&gt;exec($sql);

\# inserting some POINTs  
\# please note well: SQLite is ACID and Transactional  
\# so (to get best performance) the whole insert cycle  
\# will be handled as a single TRANSACTION  
$db-&gt;exec(“BEGIN”);  
for ($i = 0; $i &lt; 10000; $i++) { # for POINTs we’ll use full text sql statements $sql = “INSERT INTO test\_pt (id, name, geom) VALUES (“; $sql .= $i + 1; $sql .= “, ‘test POINT #”; $sql .= $i + 1; $sql .= “‘, GeomFromText(‘POINT(“; $sql .= $i / 1000.0; $sql .= ” “; $sql .= $i / 1000.0; $sql .= “)’, 4326))”; $db-&gt;exec($sql);  
}  
$db-&gt;exec(“COMMIT”);

\# checking POINTs  
$sql = “SELECT DISTINCT Count(\*), ST\_GeometryType(geom), “;  
$sql .= “ST\_Srid(geom) FROM test\_pt”;  
$rs = $db-&gt;query($sql);  
while ($row = $rs-&gt;fetchArray())  
{  
\# read the result set  
$msg = “Inserted “;  
$msg .= $row\[0\];  
$msg .= ” entities of type “;  
$msg .= $row\[1\];  
$msg .= ” SRID=”;  
$msg .= $row\[2\];  
print ”

### $msg

“;  
}

\# inserting some LINESTRINGs  
\# this time we’ll use a Prepared Statement  
$sql = “INSERT INTO test\_ln (id, name, geom) “;  
$sql .= “VALUES (?, ?, GeomFromText(?, 4326))”;  
$stmt = $db-&gt;prepare($sql);  
$db-&gt;exec(“BEGIN”);  
for ($i = 0; $i &lt; 10000; $i++) { # setting up values / binding $name = “test LINESTRING #”; $name .= $i + 1; $geom = “LINESTRING(“; if (($i%2) == 1) { # odd row: five points $geom .= “-180.0 -90.0, “; $geom .= -10.0 – ($i / 1000.0); $geom .= ” “; $geom .= -10.0 – ($i / 1000.0); $geom .= “, “; $geom .= -10.0 – ($i / 1000.0); $geom .= ” “; $geom .= 10.0 + ($i / 1000.0); $geom .= “, “; $geom .= 10.0 + ($i / 1000.0); $geom .= ” “; $geom .= 10.0 + ($i / 1000.0); $geom .= “, 180.0 90.0″; } else { # even row: two points $geom .= -10.0 – ($i / 1000.0); $geom .= ” “; $geom .= -10.0 – ($i / 1000.0); $geom .= “, “; $geom .= 10.0 + ($i / 1000.0); $geom .= ” “; $geom .= 10.0 + ($i / 1000.0); } $geom .= “)”; $stmt-&gt;reset();  
$stmt-&gt;clear();  
$stmt-&gt;bindValue(1, $i+1, SQLITE3\_INTEGER);  
$stmt-&gt;bindValue(2, $name, SQLITE3\_TEXT);  
$stmt-&gt;bindValue(3, $geom, SQLITE3\_TEXT);  
$stmt-&gt;execute();  
}  
$db-&gt;exec(“COMMIT”);

\# checking LINESTRINGs  
$sql = “SELECT DISTINCT Count(\*), ST\_GeometryType(geom), “;  
$sql .= “ST\_Srid(geom) FROM test\_ln”;  
$rs = $db-&gt;query($sql);  
while ($row = $rs-&gt;fetchArray())  
{  
\# read the result set  
$msg = “Inserted “;  
$msg .= $row\[0\];  
$msg .= ” entities of type “;  
$msg .= $row\[1\];  
$msg .= ” SRID=”;  
$msg .= $row\[2\];  
print ”

### $msg

“;  
}

\# insering some POLYGONs  
\# this time too we’ll use a Prepared Statement  
$sql = “INSERT INTO test\_pg (id, name, geom) “;  
$sql .= “VALUES (?, ?, GeomFromText(?, 4326))”;  
$stmt = $db-&gt;prepare($sql);  
$db-&gt;exec(“BEGIN”);  
for ($i = 0; $i &lt; 10000; $i++) { # setting up values / binding $name = “test POLYGON #”; $name .= $i + 1; $geom = “POLYGON((“; $geom .= -10.0 – ($i / 1000.0); $geom .= ” “; $geom .= -10.0 – ($i / 1000.0); $geom .= “, “; $geom .= 10.0 + ($i / 1000.0); $geom .= ” “; $geom .= -10.0 – ($i / 1000.0); $geom .= “, “; $geom .= 10.0 + ($i / 1000.0); $geom .= ” “; $geom .= 10.0 + ($i / 1000.0); $geom .= “, “; $geom .= -10.0 – ($i / 1000.0); $geom .= ” “; $geom .= 10.0 + ($i / 1000.0); $geom .= “, “; $geom .= -10.0 – ($i / 1000.0); $geom .= ” “; $geom .= -10.0 – ($i / 1000.0); $geom .= “))”; $stmt-&gt;reset();  
$stmt-&gt;clear();  
$stmt-&gt;bindValue(1, $i+1, SQLITE3\_INTEGER);  
$stmt-&gt;bindValue(2, $name, SQLITE3\_TEXT);  
$stmt-&gt;bindValue(3, $geom, SQLITE3\_TEXT);  
$stmt-&gt;execute();  
}  
$db-&gt;exec(“COMMIT”);

\# checking POLYGONs  
$sql = “SELECT DISTINCT Count(\*), ST\_GeometryType(geom), “;  
$sql .= “ST\_Srid(geom) FROM test\_pg”;  
$rs = $db-&gt;query($sql);  
while ($row = $rs-&gt;fetchArray())  
{  
\# read the result set  
$msg = “Inserted “;  
$msg .= $row\[0\];  
$msg .= ” entities of type “;  
$msg .= $row\[1\];  
$msg .= ” SRID=”;  
$msg .= $row\[2\];  
print ”

### $msg

“;  
}

\# closing the DB connection  
$db-&gt;close();

// End TIMER  
// ———  
$etimer = explode( ‘ ‘, microtime() );  
$etimer = $etimer\[1\] + $etimer\[0\];  
echo ‘

‘;  
printf( “Script timer: **%f** seconds.”, ($etimer-$stimer) );  
echo ‘

‘;  
// ———

?&gt;

\[/cc\]

<div class="zemanta-pixie">![](http://img.zemanta.com/pixy.gif?x-id=b905b2d7-4e01-8480-af63-6bb7ac2588a0)</div>