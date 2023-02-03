---
id: 340
title: 'Spatialite Speed Test'
date: '2012-01-20T22:21:51-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=340'
permalink: /2012/01/20/spatialite-speed-test/
categories:
    - 'Data processing'
    - Database
    - GIS
    - Spatialite
---

*This post is part of a series [\[1\]](https://johnzastrow.github.io/2012/01/16/example-with-php-and-spatialite-part-1/ "Example with PHP and Spatialite, part 1"), [\[2\]](https://johnzastrow.github.io/2012/01/17/example-with-php-and-spatialite-part-2/ "Example with PHP and Spatialite, part 2"), [\[3\]](https://johnzastrow.github.io/2012/01/18/spatialite-and-spatial-indexes/ "Spatialite and Spatial Indexes"), [\[4\],](https://johnzastrow.github.io/2012/01/20/spatialite-speed-test/ "Spatialite Speed Test")[ \[5\]](https://johnzastrow.github.io/2012/01/27/of-file-sizes-and-nearest-neighbors/ "Of file sizes and nearest neighbors")[  ](https://johnzastrow.github.io/2012/01/20/spatialite-speed-test/ "Spatialite Speed Test")*

Based on my earlier tests I felt confident that I could expand the size of the dataset to my intended extent. So I grabbed 12-digit HUCS for the entire United States. I was confident this would crush spatialite and finally make the response time for my question extend to close to 1 second. But just in case it didn't, I would make my question harder at the same time.

> While I'm playing with these queries I need a reference guide. Of course the starting point is the spatialite SQL guide found here <http://www.gaia-gis.it/gaia-sins/spatialite-sql-3.0.0.html>. But, while this is a nice list of functions, I need more help than it provides. Thankfully, spatialite shares many technical concepts with PostGIS (follows OGC, etc. SQL and data standards, and they both use the GEOS spatial library). So, I've been successfully poaching help from the PostGIS documentation ([http://www.postgis.org/docs/ST\_GeomFromText.html](http://www.postgis.org/docs/ST_GeomFromText.html)) … which is quite good and gives plenty of use examples.

So, getting back to the data, here is my new queryable data set.

 [![12-digit hydrologic units for the entire US](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/whole_country.png "12-digit hydrologic units for the entire US")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/whole_country.png)
 <p><i> 

12-digit hydrologic units for the entire US
 </i></p> 


The pink blob on the right my new, harder question.. searching with not one pair of coordinates, but a bunch of pairs in the form of a pink polygon. Pink scares computers, so this should hurt it a little. It might also be scary that my database file representing the HUCs is now **1.9GB** in size (lots of coordinates and the indexes to describes them).

 [![Pink test polygon](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/example_poly.png "Pink test polygon")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/example_poly.png)
 <p><i> 

Pink test polygon
 </i></p> 


Because I'm likely going to be using coordinate pairs passed in from some kind of Web application, I converted the polygon to well-known text using

```sql
--- 
SELECT ST_AsText(geom) from test_polys;
```

which of course gives us

 [![](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/selectwkt.png "select a geometry (polygon) as well-known text (wkt)")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/selectwkt.png)
 <p><i> 

select a geometry (polygon) as well-known text (wkt)
 </i></p> 


With the handy text string to describe my polygon given to me, I'm able to just copy and paste it into my text SQL. So let's do that and the first query should really hurt because I'm not going to use an index. Note that I switched from Contains.. to Intersects since I want to detect anything that touches my pink poly.

```sql
--- 
select HU_12_NAME FROM huc12
WHERE ST_Intersects(Geometry, ST_GeomFromText('POLYGON((-70.286127 43.839038, 
-70.305482 43.823696, -70.30855 43.798912, -70.292028 43.773421, 
-70.243169 43.769644, -70.231367 43.774601, -70.193601 43.811186, 
-70.186048 43.836206, -70.264648 43.839274, -70.264648 43.839274, 
-70.274089 43.840218, -70.286127 43.839038))')) = 1
```

How did it do? Surprisingly well. 40 seconds give or take. Of course, that won't work for my application, so I'm keeping my fingers crossed that the index rescues me.

 [![Polygon query with no index](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/poly_no_index.png "Polygon query with no index")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/poly_no_index.png)
 <p><i> 

Polygon query with no index
 </i></p> 


Now how about with the index? Here's the query.

```sql
--- 
select HU_12_NAME FROM huc12
WHERE ST_Intersects(Geometry, ST_GeomFromText('POLYGON((-70.286127 43.839038, 
-70.305482 43.823696, -70.30855 43.798912, -70.292028 43.773421, 
-70.243169 43.769644, -70.231367 43.774601, -70.193601 43.811186, 
-70.186048 43.836206, -70.264648 43.839274, -70.264648 43.839274, 
-70.274089 43.840218, -70.286127 43.839038))')) = 1
AND ROWID IN (
SELECT ROWID
FROM SpatialIndex
WHERE f_table_name = 'huc12'
AND search_frame = ST_GeomFromText('POLYGON((-70.286127 43.839038, 
-70.305482 43.823696, -70.30855 43.798912, -70.292028 43.773421, 
-70.243169 43.769644, -70.231367 43.774601, -70.193601 43.811186, 
-70.186048 43.836206, -70.264648 43.839274, -70.264648 43.839274, 
-70.274089 43.840218, -70.286127 43.839038))'));
```

And survey says! **0.186 seconds!** Oh yeah.

 [![Pink polygon query with spatial index](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/poly_with_index.png "Pink polygon query with spatial index")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/poly_with_index.png)
 <p><i> 

Pink polygon query with spatial index
 </i></p> 


So this all well and good, but the real reason why these queries are so fast is because the test geometry (the pink polygon) is so small. So lets push that a little.

 [![Multipart polygon with lotsa geometry](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/lotsa_geometry.png "Multipart polygon with lotsa geometry")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/lotsa_geometry.png)
 <p><i> 

Multipart polygon with lotsa geometry
 </i></p> 


So, here I've made a single multipart polygon with lots of vertices to keep my query simple. I'll spare you the geometry and the query, but the pink polygon above, querying a whole country of HUC12s with the spatial index, took **1.4 seconds**. So, we finally broke our time limit with enough testing geometry.