---
id: 594
title: 'Spatialite is my default'
date: '2013-01-09T23:47:15-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=594'
permalink: /2013/01/09/spatialite-is-my-default/
categories:
    - 'Data processing'
    - Database
    - GIS
    - Spatialite
    - Uncategorized
---

Like [James Fee](http://spatiallyadjusted.com/2012/12/18/the-kml-problem/), and a few [others](http://blog.safe.com/2010/09/the-future-looks-bright-for-spatiallite/): I [love](https://johnzastrow.github.io/2012/01/16/example-with-php-and-spatialite-part-1/ "Example with PHP and Spatialite, part 1") [Spatialite](http://www.gaia-gis.it/gaia-sins/) and want to use it more. I find myself keeping maybe three 500MB .sqlite files in my Dropbox folder with my favorite and newly found data ready for use. Although I have access to and use ArcMap at home and work, I still spend a lot of time escaping the bloat and doggy performance in the warm, snappy arms of [Qgis](http://qgis.org/). Qgis works great with Spatialite (except for the aging data providers restricted to older spatialite versions – due to up-to-date with the next release of Qgis).

[![spatialite_files](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/12/spatialite_files-300x263.png)](https://johnzastrow.github.io/2013/01/09/spatialite-is-my-default/spatialite_files/)

I like [spatialite](http://slashgeo.org/2010/09/15/FOSS4G-2010-Notes-SpatiaLite-Shapefile-Future), or at least what it provides, because like Qgis, it attempts to be an elegant mix of capabilities that focus on what I need most of the time. It also addresses some of the shortcomings of its primary competitor, Shapefiles. In fact, other [people](http://slashgeo.org/2012/12/21/OGC-Draft-GeoPackage-Specification-Finally-Shapefile-Format-Replacement "http://slashgeo.org/2012/12/21/OGC-Draft-GeoPackage-Specification-Finally-Shapefile-Format-Replacement") involved with the [OGC](http://spatiallyadjusted.com/2012/12/20/ogc-draft-geopackage-specification/) like it too for the same reasons. In this post I'm going to jot down some of my thoughts on the strengths that Spatialite brings to the table. Then in my next post I'll record some of the weaknesses or areas for improvement – perhaps in comparison to ESRI Shapefiles and their modern replacement – [ESRI File Geodatabases](http://resources.arcgis.com/content/geodatabases/10.0/file-gdb-api).

Specifically, I like the following capabilities and aspects of the software:

- **Cross-platform** – Libraries and files for \*NIX and Win, along with Win binaries kindly provided. The Windows stuff are always available at the main site, while eventually binaries get released in the usual Ubuntu repos (not sure about RPMs).
- **Reuse** – it stands on the shoulders of other very successful projects and only reinvents the wheels needed for lighter weight implementations than say exist in PostGIS.
- **Flexible** – Being essentially Sqlite, which is just a database, Spatialite stores many types of GIS data such as rasters, vectors, etc in a single file, along with other types of non-traditional GIS data and [information](https://groups.google.com/d/msg/spatialite-users/-/ZLiNvyv7wKoJ.). Notice I say file (single) and not file format. I don't like keeping track of many different little files on disk (Shapefiles, Coverages, File geodatabases). I cut my teeth in GIS in the early-mid 1990's enjoying the simplicity of the [Microimages TNTmips](http://www.microimages.com) .RVC (raster, vector, CAD) all-in-one file format. Since coming to ESRI, I miss that simplicity. Spatialite's ability to also store tabular data, and whatever structures I can create in those tables, means that I could even devise a way to [store my metadata](http://gis.stackexchange.com/questions/40994/standard-for-storing-human-metadata-in-spatial-databases) right in the .sqlite file and never let my documentation be separated from my data again (could someone please promulgate a standard for keeping metadata in a RDBMS so that OSS tools can be built around this? UPDATE: maybe we're [one step closer](https://groups.google.com/d/msg/spatialite-users/-/ZLiNvyv7wKoJ.)). Heck you could probably even store map project files right in the database alongside the data and documentation. Holy one stop shopping Batman!

[![Simple Qgis project file loading a Spatialite layer](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/12/qgis_project_file-300x243.png)](https://johnzastrow.github.io/2013/01/09/spatialite-is-my-default/qgis_project_file/)

Simple Qgis project file (XML) loading a Spatialite layer

- **It's Just a Database** – Unlike file geodbs that kinda act/smell like databases, sqlite/spatialite IS a database. It is a simple cousin to the real RDBMS and follows the same standards. So, you can actually use complex and complete SQL constructs for example instead just basic SELECTs.

- **It's Not a Database Server** – If I want to run a full spatially-enabled server and feed and water it – I would and do run Postgres/PostGIS. But with Spatialite, the data are just files and the software that connects to them is where the magic happens. Simple.

- **Large Amounts of Data** – Though limited by the fact that a Spatialite database is a single file on the file system, we can still store AND use many 10's of GB of data in them. And that's plenty for me, especially since if I need more, or I need to support a lot of connections I'm going to run a server anyhow. I don't need fast, multiple connections in my file-based data store.
- **Capable** – There are fewer and fewer things that I want to do in any spatial database that I can't do in Spatialite – take a look the huge function list <http://www.gaia-gis.it/gaia-sins/spatialite-sql-4.0.0.html> . Calculate "a grid of triangular cells (having the edge length of *size*) precisely covering the input Geometry" right in the database? As the Gecko says, "No problem." In fact, if anything I wish Sandro would stop adding spatial functions and capabilities and add a little more glue to the project.. but that's my next post.
- **Fast** – Yep, Spatialite is snappy just like Sqlite. You will find some benchmarks in the wild, including on this site. Spatialite is plenty fast and just [keeps getting faster](https://www.gaia-gis.it/fossil/libspatialite/wiki?name=speed-optimization).
- **Common** – Well not quite yet. But others folks are slowly getting interested in and supporting it as the project matures. [FME ](http://docs.safe.com/fme/reader_writerPDF/spatialitefdo.pdf)finally got there.
- **Moving** – Spatialite development is progressing, despite really only being actively developed by Sandro and Brad ([it appears](https://www.gaia-gis.it/fossil/libspatialite/timeline)). I'll say more about development in my wishlist post, but at this point I'm just glad that the project is active.

I've probably missed listing some things, but you get the idea. Simply stated, there is a lot for me to like. I think we'll continue to hear more about Spatialite in the future as the simple and easy (easy ALWAYS wins) solutions continue to overtake the complex ones… so stay tuned!

<span style="text-decoration: underline;">*References and random links:*</span>

- [http://www.frogmouth.net/blog/?cat=3](https://www.gaia-gis.it/fossil/libspatialite/wiki?name=switching-to-4.0)
- [http://northredoubt.com/n/?s=spatialite&amp;submit=Search](https://www.gaia-gis.it/fossil/libspatialite/wiki?name=switching-to-4.0)

- <https://www.gaia-gis.it/fossil/libspatialite/wiki?name=switching-to-4.0>