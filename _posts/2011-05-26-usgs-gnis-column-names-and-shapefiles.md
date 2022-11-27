---
id: 195
title: 'USGS GNIS column names and shapefiles'
date: '2011-05-26T14:10:36-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/2011/05/26/usgs-gnis-column-names-and-shapefiles/'
permalink: /2011/05/26/usgs-gnis-column-names-and-shapefiles/
categories:
    - Uncategorized
---

If you try to convert the USGS geographic names (GNIS) text files from the website straight into shapefiles, you will have field name collisions because the field names willbe truncated to 10 characters which result in duplicate field names.

Run this script to rename certain fields to avoid this. Note that the entire US results in a file that is over 2 million records. Interestingly, but not surprisingly, the tools that seems to handle this size of data most gracefully is QGIS, not ArcMap.

\#!/bin/sh  
sed -i ‘s/DATE\_CREATED/DT\_CREATE/g’ GNISNationalFile.txt  
sed -i ‘s/DATE\_EDITED/DT\_EDIT/g’ GNISNationalFile.txt  
sed -i ‘s/FEATURE\_CLASS/FEAT\_CLASS/g’ GNISNationalFile.txt  
sed -i ‘s/FEATURE\_NAME/FEAT\_NAME/g’ GNISNationalFile.txt  
sed -i ‘s/PRIM\_LAT\_DEC/YLAT\_DEC/g’ GNISNationalFile.txt  
sed -i ‘s/PRIM\_LONG\_DMS/XLONG\_DMS/g’ GNISNationalFile.txt  
sed -i ‘s/PRIM\_LONG\_DEC/XLONG\_DEC/g’ GNISNationalFile.txt  
sed -i ‘s/PRIMARY\_LAT\_DMS/YLAT\_DMS/g’ GNISNationalFile.txt  
sed -i ‘s/SOURCE\_LAT\_DMS/SRC\_Y\_DMS/g’ GNISNationalFile.txt  
sed -i ‘s/SOURCE\_LAT\_DEC/SRC\_Y\_DEC/g’ GNISNationalFile.txt  
sed -i ‘s/SOURCE\_LONG\_DMS/SRC\_X\_DMS/g’ GNISNationalFile.txt  
sed -i ‘s/SOURCE\_LONG\_DEC/SRC\_X\_DEC/g’ GNISNationalFile.txt  
sed -i ‘s/STATE\_ALPHA/STATE\_NAME/g’ GNISNationalFile.txt  
sed -i ‘s/STATE\_NUMERIC/STATE\_NUM/g’ GNISNationalFile.txt

<div class="zemanta-pixie">![](http://img.zemanta.com/pixy.gif?x-id=47dfdb49-9584-8cc8-925f-8f5fc3a881a9)</div>