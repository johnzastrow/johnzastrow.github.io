---
id: 195
title: 'USGS GNIS column names and shapefiles'
date: '2011-05-26T14:10:36-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'https://johnzastrow.github.io/2011/05/26/usgs-gnis-column-names-and-shapefiles/'
permalink: /2011/05/26/usgs-gnis-column-names-and-shapefiles/
categories:
    - Uncategorized
---

If you try to convert the USGS geographic names (GNIS) text files from the website straight into shapefiles, you will have field name collisions because the field names willbe truncated to 10 characters which result in duplicate field names.

Run this script to rename certain fields to avoid this. Note that the entire US results in a file that is over 2 million records. Interestingly, but not surprisingly, the tools that seems to handle this size of data most gracefully is QGIS, not ArcMap.

```bash

#!/bin/sh  
sed -i 's/DATE_CREATED/DT_CREATE/g' GNISNationalFile.txt  
sed -i 's/DATE_EDITED/DT_EDIT/g' GNISNationalFile.txt  
sed -i 's/FEATURE_CLASS/FEAT_CLASS/g' GNISNationalFile.txt  
sed -i 's/FEATURE_NAME/FEAT_NAME/g' GNISNationalFile.txt  
sed -i 's/PRIM_LAT_DEC/YLAT_DEC/g' GNISNationalFile.txt  
sed -i 's/PRIM_LONG_DMS/XLONG_DMS/g' GNISNationalFile.txt  
sed -i 's/PRIM_LONG_DEC/XLONG_DEC/g' GNISNationalFile.txt  
sed -i 's/PRIMARY_LAT_DMS/YLAT_DMS/g' GNISNationalFile.txt  
sed -i 's/SOURCE_LAT_DMS/SRC_Y_DMS/g' GNISNationalFile.txt  
sed -i 's/SOURCE_LAT_DEC/SRC_Y_DEC/g' GNISNationalFile.txt  
sed -i 's/SOURCE_LONG_DMS/SRC_X_DMS/g' GNISNationalFile.txt  
sed -i 's/SOURCE_LONG_DEC/SRC_X_DEC/g' GNISNationalFile.txt  
sed -i 's/STATE_ALPHA/STATE_NAME/g' GNISNationalFile.txt  
sed -i 's/STATE_NUMERIC/STATE_NUM/g' GNISNationalFile.txt

```