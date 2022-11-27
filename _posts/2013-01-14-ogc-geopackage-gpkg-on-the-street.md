---
id: 634
title: 'OGC Geopackage [GPKG] on the street'
date: '2013-01-14T11:42:16-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=634'
permalink: /2013/01/14/ogc-geopackage-gpkg-on-the-street/
categories:
    - 'Data processing'
    - Database
    - GIS
    - Spatialite
---

I am thrilled to see the OGC Geopackage \[GPKG\] spec hit the street and see Sandro, Brad and Spatialite taking such a prominent role there. Using [Spatialite](http://www.gaia-gis.it/gaia-sins/) as the vector reference implementation makes a lot of sense. The spec does seem a little bloated to me. But OTOH, sometimes I would want all that stuff – and creating a standard to support them means that they will be there for me if I need them. Now maybe we can get Spatialite better supported out in the world… Tiles, rasters, metadata, improved SRS support, plus all the normal vector data I normally get all in an easy-to-use relational, SQL-compliant database – yippee! What’s next? Watershed delineation on my phone?!

Here’s the link to the announcement on the Spatialite list, and I’ll include Sandro’s announcement below.

<https://groups.google.com/forum/#!msg/spatialite-users/XPYzxnYMCrU/i5lxfnShTNUJ>

**sandro furieri &lt;a.furieri@lqt.it&gt; Sat, Jan 12, 2013 at 5:59 AM**  
**To: spatialite-users@googlegroups.com**

Hi List,  
I’m glad to announce you all that SpatiaLite is going to be adopted as the reference implementation by the candidate OGC GeoPackage (GPKG) standard. \[1\]

The current draft of the candidate GPKG standard is now available for download; comments are welcome. \[2\]  
\[1\] http://www.opengeospatial.org/standards/requests/95  
\[2\] https://portal.opengeospatial.org/files/?artifact\_id=51391

<span style="text-decoration: underline;">Very short abstract for busy readers:</span>

A GeoPackage is an open, non-proprietary, platform-independent container for distribution of all kinds of geospatial data. It’s a self-describing single file ready for immediate use  
supporting mapping and other geospatial applications. The primary purpose of GPKG is supporting Mobile device users who operate in disconnected or limited network connectivity.

But GPKG is a standard exchange format as well, supporting data distribution, collection of observations, and distribution of change-only updates.

**Gossips:**  
During the last months both Brad and I were members of the OGC Committee producing the candidate standard, and we contributed to its definition.

The next release of SpatiaLite 4.1.0 will (optionally) include a brand new GeoPackage extension developed by Brad.

bye Sandro

<span style="text-decoration: underline;">**Here are some other references:**</span>

- <http://foss4g-na.org/schedule/army-geospatial-center-geopackage-gpkg/>
- <http://www.opengeospatial.org/projects/groups/geopackageswg>
- <http://www.opengeospatial.org/node/1756>
- <http://spatiallyadjusted.com/2013/01/10/geopackage-comment-period-is-open/>
- <http://blog.geomusings.com/2013/01/09/comment-period-open-for-geopackage-specification-draft/>
- [http://www.weogeo.com/blog/The\_GeoPackage.html](http://www.weogeo.com/blog/The_GeoPackage.html)
- [http://osgeo-org.1560.n6.nabble.com/FYI-New-OGC-Standards-Activity-Candidate-GeoPackage-Standard-td5013223.html](http://osgeo-org.1560.n6.nabble.com/FYI-New-OGC-Standards-Activity-Candidate-GeoPackage-Standard-td5013223.htmlhttp://)
- [https://groups.google.com/forum/#!msg/geospatial-mobile-data-format-for-tiles/jEsh6tfTXkE/Nxl96snB\_MMJ](https://groups.google.com/forum/#!msg/geospatial-mobile-data-format-for-tiles/jEsh6tfTXkE/Nxl96snB_MMJ)
- <https://twitter.com/search?q=%23geopackage>
- <http://lists.osgeo.org/pipermail/standards/2012-October/000535.html>
- [http://northredoubt.com/n/?s=spatialite&amp;submit=Search](http://northredoubt.com/n/?s=spatialite&submit=Searchhttp://)