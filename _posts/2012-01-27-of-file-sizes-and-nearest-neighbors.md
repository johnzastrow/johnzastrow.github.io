---
id: 361
title: 'Of file sizes and nearest neighbors'
date: '2012-01-27T14:18:25-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=361'
permalink: /2012/01/27/of-file-sizes-and-nearest-neighbors/
categories:
    - 'Data processing'
    - Database
    - GIS
    - Spatialite
    - Uncategorized
---

*This post is part of a series [\[1\]](http://northredoubt.com/n/2012/01/16/example-with-php-and-spatialite-part-1/ "Example with PHP and Spatialite, part 1"), [\[2\]](http://northredoubt.com/n/2012/01/17/example-with-php-and-spatialite-part-2/ "Example with PHP and Spatialite, part 2"), [\[3\]](http://northredoubt.com/n/2012/01/18/spatialite-and-spatial-indexes/ "Spatialite and Spatial Indexes"), [\[4\],](http://northredoubt.com/n/2012/01/20/spatialite-speed-test/ "Spatialite Speed Test")[ \[5\]](http://northredoubt.com/n/2012/01/27/of-file-sizes-and-nearest-neighbors/ "Of file sizes and nearest neighbors")*

I’m continuing my exploration of Spatialite and decided to try the classic problem of identifying the nearest feature to a selected feature. This is commonly known as a nearest neighbor question and Regina and Leo at Boston GIS cover the issues quite well in their posts [here](http://www.bostongis.com/PrinterFriendly.aspx?content_name=postgis_nearest_neighbor), [here](http://www.bostongis.com/PrinterFriendly.aspx?content_name=postgis_nearest_neighbor_generic), and [here](http://www.bostongis.com/blog/index.php?/categories/7-nearest-neighbor).

But, of course each computer system is a little different and generic solutions that work on many systems are rarely the most efficient. In spatial databases, how one uses indexes is a common difference and Spatialite doesn’t implement spatial indexes in the same was as say PostGIS. Therefore, the approach for accessing the indexes through SQL statements also differs.

So, I’ll keep running with my classic point that I’ve been using in this series. The new question is:

<span style="color: #008000;"> ***“What is the nearest “place feature” (another point) to the point location at -70.25 E, 43.802 N?”***</span>

As with my HUC12 question, I want to try to make Spatialite slow by asking a simple question against a lot of data. I want to push its boundaries or determine that its performance is essentially always within the “excellent” range when faced with any reasonable amount of data.

So, I needed to find a big point data set.. and hopefully oen that I might actually use later. While I think the [Geonames](<http://www.geonames.org/ >) dataset has like 7 million points, I decided to keep things closer to home and use the US national dataset from [GNIS at USGS](http://gnis.usgs.gov/domestic/download_data.htm). In the US national GNIS file there are about 2.2 million points of varying types.

 [![Lots of dots](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/22millionfeatures.png "Lots of dots")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/22millionfeatures.png)<figcaption class="wp-caption-text" id="caption-attachment-370">Lots of dots</figcaption> 

 [![All the dots](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/zoomout-300x127.png "All the dots")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/zoomout.png)<figcaption class="wp-caption-text" id="caption-attachment-377">All the dots</figcaption> 

**and here is the dot density for New York City area.**

 [![Recognize this shape?](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/ny-300x166.png "Recognize this shape?")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/ny.png)<figcaption class="wp-caption-text" id="caption-attachment-376">Recognize this shape?</figcaption> 

Which leads me to a <span style="text-decoration: underline;">&lt;digression&gt;</span>

These GNIS data are available as a pipe-delimited text file. But The first few characters in the first row (right before the first column name, or maybe it’s some kind of magic binary header) are always screwed up.. which confounds some software that starts with Arc… .

 [![The offending characters in the GNIS text files](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/offending_char.png "The offending characters in the GNIS text files")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/offending_char.png)<figcaption class="wp-caption-text" id="caption-attachment-367">The offending characters in the GNIS text files</figcaption> 

So, I always end up having to bring the data through Microsoft Access to cleanse them.. then back out again usually as a comma-delimited, double-quoted text file (CSV). In this case, I ran that “fixed” text file through ArcCatalog to make a Shapefile that I could import into Spatialite.. because I seem to like to torture myself. Of course, halfway through the import Spatialite informed me that it couldn’t proceed because one of the geometries was corrupted. Throwing my hands up, I switched to using Spatialite’s heavenly text import routine to import the pipe-delimited file into a table.

Then I simply ran these commands from a tutorial at Spatialite’s site:

```
<pre class="lang:default decode:true">SELECT AddGeometryColumn('XYGNIS', 'Geometry',  4326, 'POINT', 'XY', 0);
```

Where the value explanations are :

```
<pre class="lang:pgsql decode:true">AddGeometryColumn( table String , column String , srid Integer , geom_type String , dimension String [ , not_null Integer ] ) : Integer
```

Voila. This created the needed structures in the database to hold the indexes, setup needed triggers, etc. Then I created the point geometry with a recipe like the following:

```sql
UPDATE XYGNIS SET Geometry = MakePoint(PRIM_LONG_DEC, PRIM_LAT_DEC,4326);
```

Lastly, I had to tell Spatialite to build the spatial indexes. I just did this through the GUI by right-clicking on my new Geometry field.

Why am I telling you all this? Well, for it was interesting to see the differences in file sizes representing each data type. Each has varying amount of indexes (the Access .accdb has none, but Spatialite and the Shapefiles have spatial indexes). But it’s still interesting to see the differences in the amount of room needed to store the same records in various file formats. For education I also made an ArcGIS 9.3 Personal Geodatabase and File Geodatabase as shown below. I’m not going to test performance differences here. But maybe when I finally upgrade to ArcGIS 10.X and I have a handy SQL layer option I’ll try something like that.

 [![Geo Files Sizes](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/file_sizes.png "Geo Files Sizes")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/file_sizes.png)<figcaption class="wp-caption-text" id="caption-attachment-366">Geo Files Sizes</figcaption> 

<span style="text-decoration: underline;"> &lt;/digression&gt;</span>

But now back to my question. Here is the performance without using my indexes.


```sql
SELECT feature_name, feature_class, ST_Distance(Geometry,
MakePoint(-70.250, 43.802)) AS Distance
FROM XYGNIS
WHERE distance < 0.1
ORDER BY distance LIMIT 1
```

 [![No indexes, nearest point feature within 0.1 degrees](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/no-index_pt.png "No indexes, nearest point feature within 0.1 degrees")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/no-index_pt.png)<figcaption class="wp-caption-text" id="caption-attachment-378">No indexes, nearest point feature within 0.1 degrees</figcaption> 

**44.5 seconds.** Not as bad one would think. I’m using a radius of 0.1 degrees to limit how many results I get back. I played around with this value and you should too. To find the very nearest feature, I LIMIT the number of my results to 1, and because I’ve sorted, or ordered my results ascending by distance, I can get a single answer that is the very nearest feature.

I still want my queries to finish in less than a second, so with a little help from an email response from Sandro, here is the same query against 2.2 million points that **finishes in 0.036 seconds**. Barely enough time to open the database connection I think.


```sql
SELECT feature_name, feature_class, ST_Distance(Geometry,
MakePoint(-70.250, 43.802)) AS Distance
FROM XYGNIS
WHERE distance < 0.1
AND ROWID IN (
SELECT ROWID FROM SpatialIndex
WHERE f_table_name = 'XYGNIS'
AND search_frame =
BuildCircleMbr(-70.250, 43.802, 0.1))
ORDER BY distance LIMIT 10
```

 [![Still fast enough](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/even_faster.png "Still fast enough")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/even_faster.png)<figcaption class="wp-caption-text" id="caption-attachment-368">Still fast enough</figcaption> 

Pretty cool. BTW, if I wanted more than one result, I can just change the LIMIT to a higher number, like 10.

 [![When 1 isn't enough](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/nearest10.png "When 1 isn't enough")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/nearest10.png)<figcaption class="wp-caption-text" id="caption-attachment-369">When 1 isn’t enough</figcaption> 