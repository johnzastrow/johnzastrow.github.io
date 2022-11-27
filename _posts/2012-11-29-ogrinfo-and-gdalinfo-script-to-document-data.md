---
id: 585
title: 'ogrinfo and gdalinfo script to document data'
date: '2012-11-29T11:19:11-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=585'
permalink: /2012/11/29/ogrinfo-and-gdalinfo-script-to-document-data/
categories:
    - 'Data processing'
    - GIS
---

I needed to recursively document a bunch of Shapefiles and geotiffs in a hierarchy of directories (soon file geodatabses). I can’t use Arc\*anything so I’m using ogrinfo and gdalinfo in many directories. I started using xargs, but ran into weirdness beyond white characters, and involving bash string manipulation (I’m running on Cygwin in windows…). So I switched approaches and came up with this little ditty.

```
<pre class="lang:bash decode:1 ">
#!/bin/sh

echo "********************** START Shapefiles ***********************"
echo ""
for x in $(find ./* -type f -name \*.shp); do
base=${x##*/}
echo "--- Found the Shapefile " $base "and the base layer of " ${base%.*}
/bin/GDAL/./ogrinfo.exe -ro -so -al -fields=YES -geom=SUMMARY $x
echo ""
done
echo ""
echo "********************** END Shapefiles ***********************"

echo "********************** START TIFFs ***********************"
echo ""
for y in $(find ./* -type f -name \*.tif); do
base=${y##*/}
echo "--- Found the TIFF file " $base "and the base layer of " ${base%.*}
/bin/GDAL/./gdalinfo.exe -approx_stats -mm -noct -proj4 $y
echo ""
done
echo ""
echo "********************** END TIFFs ***********************"
```

which outputs things like this for a TIFF

```
    --- Found the TIFF file melcd_2004_imperviousness.tif and the base layer of melcd_2004_imperviousness
    Driver: GTiff/GeoTIFF
    Files: ./Land_Characteristics/impervs/melcd_2004_imperviousness.tif
           ./Land_Characteristics/impervs/melcd_2004_imperviousness.tfw
           ./Land_Characteristics/impervs/melcd_2004_imperviousness.aux
    Size is 65102, 99355
    Coordinate System is:
    PROJCS["UTM",
        GEOGCS["NAD83",
            DATUM["North_American_Datum_1983",
                SPHEROID["GRS 1980",6378137,298.2572221010002,
                    AUTHORITY["EPSG","7019"]],
                AUTHORITY["EPSG","6269"]],
            PRIMEM["Greenwich",0],
            UNIT["degree",0.0174532925199433],
            AUTHORITY["EPSG","4269"]],
        PROJECTION["Transverse_Mercator"],
        PARAMETER["latitude_of_origin",0],
        PARAMETER["central_meridian",-69],
        PARAMETER["scale_factor",0.9996],
        PARAMETER["false_easting",500000],
        PARAMETER["false_northing",0],
        UNIT["meters",1],
        AUTHORITY["EPSG","26919"]]
    PROJ.4 string is:
    '+proj=utm +zone=19 +datum=NAD83 +units=m +no_defs '
    Origin = (336631.500000000000000,5256292.500000000000000)
    Pixel Size = (5.000000000000000,-5.000000000000000)
    Metadata:
      AREA_OR_POINT=Point
      TIFFTAG_RESOLUTIONUNIT=1 (unitless)
      TIFFTAG_SOFTWARE=IMAGINE TIFF Support
    Copyright 1991 - 1999 by ERDAS, Inc. All Rights Reserved
    @(#)$RCSfile: etif.c $ $Revision: 1.10.1.9.1.9.2.11 $ $Date: 2004/09/15 18:42:01EDT $
      TIFFTAG_XRESOLUTION=0.2
      TIFFTAG_YRESOLUTION=0.2
    Image Structure Metadata:
      COMPRESSION=CCITTRLE
      INTERLEAVE=BAND
    Corner Coordinates:
    Upper Left  (  336631.500, 5256292.500) ( 71d10' 0.27"W, 47d26'22.55"N)
    Lower Left  (  336631.500, 4759517.500) ( 71d 0'12.02"W, 42d58'14.82"N)
    Upper Right (  662141.500, 5256292.500) ( 66d50'58.28"W, 47d26'23.65"N)
    Lower Right (  662141.500, 4759517.500) ( 67d 0'42.12"W, 42d58'15.76"N)
    Center      (  499386.500, 5007905.000) ( 69d 0'28.13"W, 45d13'28.69"N)
    Band 1 Block=65102x2 Type=Byte, ColorInterp=Palette
      Description = Band_1
      Min=0.000 Max=1.000   Computed Min/Max=0.000,1.000
      Minimum=0.000, Maximum=1.000, Mean=0.992, StdDev=0.091
      Metadata:
        LAYER_TYPE=athematic
        STATISTICS_MAXIMUM=1
        STATISTICS_MEAN=0.99165311862261
        STATISTICS_MEDIAN=0
        STATISTICS_MINIMUM=0
        STATISTICS_MODE=1.9020308565413e-230
        STATISTICS_STDDEV=0.090979178661602
      Image Structure Metadata:
        NBITS=1
      Color Table (RGB with 2 entries)
    <GDALRasterAttributeTable />
```

and things like this for a Shapefile

```
********************** START Shapefiles ***********************
--- Found the Shapefile  acfish2.shp and the base layer of  acfish2
INFO: Open of <code>./Bio_Eco_Cons/acfish2s/acfish2.shp'
using driver </code>ESRI Shapefile' successful.

Layer name: acfish2
Geometry: Multi Point
Feature Count: 177
Extent: (356761.978694, 4771813.744319) - (653088.978694, 5004932.744319)
Layer SRS WKT:
PROJCS["NAD_1983_UTM_Zone_19N",
GEOGCS["GCS_North_American_1983",
DATUM["North_American_Datum_1983",
SPHEROID["GRS_1980",6378137.0,298.257222101]],
PRIMEM["Greenwich",0.0],
UNIT["Degree",0.0174532925199433]],
PROJECTION["Transverse_Mercator"],
PARAMETER["False_Easting",500000.0],
PARAMETER["False_Northing",0.0],
PARAMETER["Central_Meridian",-69.0],
PARAMETER["Scale_Factor",0.9996],
PARAMETER["Latitude_Of_Origin",0.0],
UNIT["Meter",1.0]]
ACFISH2_ID: Integer (9.0)
DMR_ID: String (5.0)
ECCM_ID: String (5.0)
YEAR: String (4.0)
ECCM_SP: String (10.0)
USFW_SP: String (10.0)
DMR_SP: String (10.0)
DMR_NAME: String (30.0)
```

Now I just need to see about getting this working with File geodatabases!