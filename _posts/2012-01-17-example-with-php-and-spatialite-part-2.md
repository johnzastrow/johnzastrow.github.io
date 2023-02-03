---
id: 292
title: 'Example with PHP and Spatialite, part 2'
date: '2012-01-17T23:27:06-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=292'
permalink: /2012/01/17/example-with-php-and-spatialite-part-2/
categories:
    - 'Data processing'
    - Database
    - GIS
    - Linux
    - Spatialite
    - Uncategorized
    - Web
---

*This post is part of a series [[1]](https://johnzastrow.github.io/2012/01/16/example-with-php-and-spatialite-part-1/ "Example with PHP and Spatialite, part 1"), [[2]](https://johnzastrow.github.io/2012/01/17/example-with-php-and-spatialite-part-2/ "Example with PHP and Spatialite, part 2"), [[3]](https://johnzastrow.github.io/2012/01/18/spatialite-and-spatial-indexes/ "Spatialite and Spatial Indexes"), [[4]](https://johnzastrow.github.io/2012/01/20/spatialite-speed-test/ "Spatialite Speed Test")*

So I'm ready to take the next steps with my little project. This is a continuation of my [previous post ](https://johnzastrow.github.io/2012/01/16/example-with-php-and-spatialite-part-1/ "Example with PHP and Spatialite, part 1")about my little journey. At this point I am connecting to a physical database file that I loaded with some sample data (12-digit watersheds). Now I'm going to practice with queries and you can see the results below.

Here are the base data.

 [![](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/huc12all-240x300.png "12-digit US watersheds (HUC12)")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/huc12all.png)
 
 <figcaption><b> 12-digit US watersheds (HUC12) and the example data set used here. Found in Southern Maine, Cumberland</b> </figcaption>
 

And here are some close ups of the data. These are fairly dense polygons.

 [![Example of polygon vertices](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/huczoom-300x216.png "Example of polygon vertices")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/huczoom.png)
 
 <i>Example of polygon vertices</i>

In fact, it looks like this query is testing the relationship between the point and polygons formed by 144,700 coordinate pairs (vertices) by scanning without the help of an index.

 [![Lots of little points to check](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/nodes-300x136.png "Lots of little points to check")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/nodes.png)
 
 Lots of little points to check
 

At this point I'm just going to perform basic queries without using spatial indexes. You will almost always want to use spatial indexes, but I'm going to practice this in phases so these examples won't use indexes.

Note that unlike tradition database indexes, spatial databases like Spatialite and PostGIS (and their GiST/R-tree indexes) do not use indexes for spatial queries unless you explicitly tell them to (though PostGIS seems to use them by default some of the time). You must smartly craft the use of indexes the same way that you do the SQL itself… or at least it seems this way to me.

In Spatialite, the indexes are just tables and you have to add subqueries to your query to grab the bounding rectangles from the Rtrees to pre-filter your queries for the index-driven speed-up.

And here are the spatial indexes that spatialite sees.

 [![spatialite_indexes](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/spatialite_indexes-147x300.png "spatialite_indexes")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/spatialite_indexes.png)
 
 Spatial indexes used in spatialite
 

So what's in these indexes? Boxes…as we see below. Hopefully you can imagine how we get boxes from Xmin, Ymin, Xmax, Ymax extents. There is one box for each polygon HUC12 feature (note the PK_UID is the primary key of the main geometry layer). These simple boxes are much simpler to test for spatial relationships that the multitude of vertices we saw above. But also much less accurate; especially for funny shaped things like watersheds. But, we can use these simple boxes to pre-filter the number of features that have to be tested by the more accurate (but lengthy) spatial test – hence speeding up the overall operation in many cases.

 [![What is in a name... or an Rtree index.](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/index-300x152.png "What is in a name... or an Rtree index.")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/index.png)
 
 What is in a name... or an Rtree index.
 

Below is an example of the spatial query used in the code below. Translated, it says, "show me the name of the HUC12 that contains this point."

 [![The free gui provided by spatialite and a spatial query](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/spatialgui-300x276.png "The free gui provided by spatialite and a spatial query")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/spatialgui.png)
 
 The free gui provided by spatialite and a spatial query
 

Here are the files in the project so far. Of course you're not normally going to be putting a loadable extension library (libspatialite.so) in a web server file directory. But, this is just practice.

 [![Files so far for this project](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/files-300x122.png "Files so far for this project")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/files.png)
 
 Files so far for this project
 

Here's the code of db.php. This isn't using spatial indexes, so it's scanning 183 features and a whole bunch of vertices to figure out which polygon actually contains that point… and doing a couple simpler things like opening a connection, asking some simple questions, and closing the connection all in about 0.4 seconds.

```php

<html>  
<head>  
<title>Testing SpatiaLite on PHP</title>  
</head>  
<body>  
<h1>Testing SpatiaLite on PHP</h1>

<?php  
// Start TIMER  
// ———–  
$stimer = explode( ' ', microtime() );  
$stimer = $stimer[1] + $stimer[0];  
// ———–  
try {  
/*** connect to SQLite database ***/  
$db = new SQLite3('db.sqlite');

/*** a little message to say we did it ***/  
echo 'database connected';  
}  
catch(PDOException $e)  
{  
echo $e->getMessage();  
}  
# loading SpatiaLite as an extension  
$db->loadExtension('libspatialite.so');

# reporting some version info  
$rs = $db->query('SELECT sqlite_version()');  
while ($row = $rs->fetchArray())  
{  
print "<h3>SQLite version: $row[0]</h3>";  
}  
$rs = $db->query('SELECT spatialite_version()');  
while ($row = $rs->fetchArray())  
{  
print "<h3>SpatiaLite version: $row[0]</h3>";  
}

/* SELECT HU_12_NAME FROM huc12 WHERE ST_Contains(Geometry, MakePoint(-70.250,43.802));  
*/  
/*  
* Create a query  
*/  
$sql = "SELECT DISTINCT Count(*), ST_GeometryType(Geometry), ";  
$sql .= "ST_Srid(Geometry) FROM huc12";  
$rs = $db->query($sql);  
while ($row = $rs->fetchArray())  
{  
# read the result set  
$msg = "There are ";  
$msg .= $row[0];  
$msg .= " entities of type ";  
$msg .= $row[1];  
$msg .= " SRID=";  
$msg .= $row[2];  
print "<h3>$msg</h3>";  
}

$sql = "SELECT HU_12_NAME FROM huc12 WHERE ST_Contains(Geometry, MakePoint(-70.250,43.802))";  
$rs = $db->query($sql);  
while ($row = $rs->fetchArray())  
{  
# read the result set  
$msg = "Your point is in the HUC12: ";  
$msg .= $row[0];  
print "<h3>$msg</h3>";  
}  
/*  
* do not forget to release all handles !  
*/

# closing the DB connection  
$db->close();

// End TIMER  
// ———  
$etimer = explode( ' ', microtime() );  
$etimer = $etimer[1] + $etimer[0];  
echo '<p style="margin:auto; text-align:center">';  
printf( "Script timer: <b>%f</b> seconds.", ($etimer-$stimer) );  
echo '</p>';  
// ———

?>

</body>  
</html>

```

Not too bad, but I want this faster because I want to feed it much larger data in my final project.

 [![Results of the first try at this](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/testing-300x157.png "Results of the first try at this")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/testing.png)
 
 <i> Results of the first try at this </i>