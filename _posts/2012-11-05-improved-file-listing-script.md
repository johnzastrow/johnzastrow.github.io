---
id: 582
title: 'Improved File Listing Script'
date: '2012-11-05T16:06:20-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=582'
permalink: /2012/11/05/improved-file-listing-script/
categories:
    - 'Data processing'
---

Run this anywhere and it will recurse through your directories and make some readable output of your files. It's set to list interesting things for GIS data. I also finally got it working where it will find all the .zip files and list their contents on most environments – even with spaces in the file names and directories.

```bash

#!/bin/sh
# jcz 2012-June-16
# listfiles.sh

set -vx
# Variables pretty self explanatory, S is seconds
dater=$(date +%Y-%m-%d)
dayer=$(date +%a)
namer=$(hostname)
startdir=$(pwd)

echo "* WELCOME TO THE FILELISTING SCRIPT FOR THE HOSTNAME" $namer
echo "* THE CORRECT USAGE IN A *NIX (CYWGIN) SHELL ENVIRONMENT WOULD BE SOMETHING LIKE"
echo "* listfiles.sh > /cygdrive/c/prvi/metlist.txt"
echo "* I am running on: " $dater, $dater
echo "* --------------------------------------------------"
echo "* Open this file in a spreadsheet program like Excel"
echo "* and use a pipe ( | ) delimited text format"
echo "* RESULTS WILL BE SAVED TO" $startdir
echo "* --------------------------------------------------"
echo ""
echo "Directories space use:"
du -h --max-depth=1
echo " --------------------------------------"
echo ""
echo "All Directories are:"
find ./* -type d
echo " --------------------------------------"
echo ""
echo "Searched on:" $(date)
echo "On system:" $namer
echo "From the directory:" $startdir
echo " --------------------------------------"
echo ""
echo "Filename|Filesize (bytes)|Modified"
find ./* -type f -print0 | xargs -0  stat -c '%N |%s |%y'
echo ""
echo ""
echo ""
echo "Shapefiles:"
echo " ---------|----------------|-------------"
echo "Filename|Filesize (bytes)|Modified"
find ./* -type f -name \*.shp -print0 | xargs -0  stat -c '%N |%s |%y'
find ./* -type f -name \*.SHP -print0 | xargs -0  stat -c '%N |%s |%y'

echo ""
echo ""
echo "PDFs:"
echo " ---------|----------------|-------------"
echo "Filename|Filesize (bytes)|Modified"
find ./* -type f -name \*.pdf -print0 | xargs -0  stat -c '%N |%s |%y'
find ./* -type f -name \*.PDF -print0 | xargs -0  stat -c '%N |%s |%y'

echo ""
echo ""
echo "ZIP files:"
echo " ---------|----------------|-------------"
echo "Filename|Filesize (bytes)|Modified"
find ./* -type f -name \*.zip -print0 | xargs -0  stat -c '%N |%s |%y'
find ./* -type f -name \*.ZIP -print0 | xargs -0  stat -c '%N |%s |%y'

echo ""
echo ""
echo "MDB files:"
echo " ---------|----------------|-------------"
echo "Filename|Filesize (bytes)|Modified"
find ./* -type f -name \*.mdb -print0 | xargs -0  stat -c '%N |%s |%y'
find ./* -type f -name \*.MDB -print0 | xargs -0  stat -c '%N |%s |%y'

echo ""
echo ""
echo "GDB files:"
echo " ---------|----------------|-------------"
echo "Filename|Filesize (bytes)|Modified"
find ./* -type d -name \*.gdb -print0 | xargs -0  stat -c '%N |%s |%y'
find ./* -type d -name \*.GDB -print0 | xargs -0  stat -c '%N |%s |%y'
echo ""
echo ""
echo ""
echo ""
echo "**********************************************************************************************"
echo ""
echo ""
echo ""
echo "ZIP file contents:"
echo " ---------|----------------|-------------"
find ./* -type f -name \*.zip |while read D; do cd "$D"; echo "$D"; unzip -lv "$D"; echo ""; echo ""; echo "******************************"; done

```

and here is some example content. Clearly some cleanup to do here, but it met my needs today.

```
 
* WELCOME TO THE FILELISTING SCRIPT FOR THE HOSTNAME DIVL-GY4K3R1
 * THE CORRECT USAGE IN A *NIX (CYWGIN) SHELL ENVIRONMENT WOULD BE SOMETHING LIKE
 * listfiles.sh > /cygdrive/c/prvi/metlist.txt
 * I am running on:  2012-11-05, 2012-11-05
 * --------------------------------------------------
 * Open this file in a spreadsheet program like Excel
 * and use a pipe ( | ) delimited text format
 * RESULTS WILL BE SAVED TO /cygdrive/f
 * --------------------------------------------------
Directories space use:
 71M    ./Long Creek WMD GIS Files (from others)
 4.7G    ./CCSWCD GIS DATA
 96K    ./CONTACTS
 4.8G    .
  --------------------------------------
All Directories are:
 ./CCSWCD GIS DATA
 ./CCSWCD GIS DATA/GIS - Data Layers
 ./CCSWCD GIS DATA/GIS - Data Layers/aquifer_contactss
 ./CCSWCD GIS DATA/GIS - Data Layers/aquifer_polygonss
 ./CCSWCD GIS DATA/GIS - Data Layers/bedrocks
 ./CCSWCD GIS DATA/GIS - Data Layers/Capisic_Brook
 ./CCSWCD GIS DATA/GIS - Data Layers/cnty24s
 ./CCSWCD GIS DATA/GIS - Data Layers/contourss
 ./CCSWCD GIS DATA/GIS - Data Layers/cumberland_county_2009
 ./CCSWCD GIS DATA/GIS - Data Layers/e911rdss
 <snip>
 --------------------------------------
Searched on: Mon, Nov 05, 2012 3:59:50 PM
 On system: DIVL-GY4K3R1
 From the directory: /cygdrive/f
  --------------------------------------
Filename|Filesize (bytes)|Modified
<code>./CCSWCD GIS DATA/GIS - Data Layers/ConcordGullyBrookSubwatershed.lyr' |13312 |2011-06-01 09:59:38.000000000 -0400
</code>./CCSWCD GIS DATA/GIS - Data Layers/Gray_Ag_Parcels.zip' |23740 |2012-06-22 16:10:52.000000000 -0400
<code>./CCSWCD GIS DATA/GIS - Data Layers/Long_Creek_Watershed_Boundary,_Revised_Summer_2010.lyr' |13824 |2011-10-20 10:52:00.000000000 -0400
</code>./CCSWCD GIS DATA/GIS - Data Layers/metwp24s.zip' |22320631 |2012-03-28 15:01:18.000000000 -0400
<code>./CCSWCD GIS DATA/GIS - Data Layers/municipal_separate_stormwater_sewer_systems_regulated_area_shapes.zip' |262570 |2012-05-11 09:50:58.000000000 -0400
</code>./CCSWCD GIS DATA/GIS - Data Layers/naip_2009.lyr' |9216 |2011-10-14 08:38:40.000000000 -0400
<code>./CCSWCD GIS DATA/GIS - Data Layers/NRPA_Inland_Wading_Waterfowl_Habitat.zip' |42173498 |2012-05-11 09:50:26.000000000 -0400
</code>./CCSWCD GIS DATA/GIS - Data Layers/OW_WBD_NAD83.lyr' |8704 |2011-06-01 09:25:56.000000000 -0400
<code>./CCSWCD GIS DATA/GIS - Data Layers/Shoreland_Zoning_Inland_Wading_Waterfowl.zip' |22922726 |2012-05-11 09:51:58.000000000 -0400
</code>./CCSWCD GIS DATA/GIS - Data Layers/soil_me005.zip' |21390552 |2012-05-11 14:48:30.000000000 -0400
<code>./CCSWCD GIS DATA/GIS - Data Layers/south_portland_2005.lyr' |9216 |2011-10-14 08:36:46.000000000 -0400
</code>./CCSWCD GIS DATA/GIS - Data Layers/water_classification.zip' |36186571 |2012-05-10 14:28:16.000000000 -0400
<snip>
<code>./CCSWCD GIS DATA/GIS - Data Layers/Surficial_Geology_By_Quadrangle/cape_elizabeth_surficial/cape_elizabeth_surficial_points.shx' |132 |2011-11-17 14:51:58.000000000 -0500
</code>./CCSWCD GIS DATA/GIS - Data Layers/Surficial_Geology_By_Quadrangle/cape_elizabeth_surficial/cape_elizabeth_surficial_thin_drift.dbf' |313698 |2011-11-17 14:51:58.000000000 -0500
<code>./CCSWCD GIS DATA/GIS - Data Layers/Surficial_Geology_By_Quadrangle/cape_elizabeth_surficial/cape_elizabeth_surficial_thin_drift.htm' |24124 |2011-11-17 14:51:58.000000000 -0500
</code>./CCSWCD GIS DATA/GIS - Data Layers/Surficial_Geology_By_Quadrangle/cape_elizabeth_surficial/cape_elizabeth_surficial_thin_drift.prj' |424 |2011-11-17 14:51:58.000000000 -0500

MDB files:
---------|----------------|-------------
Filename|Filesize (bytes)|Modified
<code>./CCSWCD GIS DATA/Long Creek WMD GIS Files (from others)/Files from Acorn Engineering - Arc10/Burns/WESTBROOK/AcornEng.mdb' |26230784 |2010-10-15 17:26:52.000000000 -0400
</code>./Long Creek WMD GIS Files (from others)/Files from Acorn Engineering - Arc10/Burns/WESTBROOK/AcornEng.mdb' |26230784 |2010-10-15 17:26:52.000000000 -0400

GDB files:
---------|----------------|-------------
Filename|Filesize (bytes)|Modified
<code>./CCSWCD GIS DATA/GIS - Data Layers/Long_Creek/Hydrology/MeDEP_Watersheds.gdb' |0 |2012-11-05 10:58:02.000000000 -0500
</code>./CCSWCD GIS DATA/Long Creek WMD GIS Files (from others)/Files from Acorn Engineering - Arc10/Burns/SOPO/StormSystem.gdb' |0 |2012-11-05 10:53:04.000000000 -0500
<code>./CCSWCD GIS DATA/Long Creek WMD GIS Files (from others)/Files from Acorn Engineering - Arc10/Burns/SOPO/StormSystem.gdb/StormSystem.gdb' |0 |2012-11-05 10:54:00.000000000 -0500
</code>./Long Creek WMD GIS Files (from others)/Files from Acorn Engineering - Arc10/Burns/SOPO/StormSystem.gdb' |0 |2012-11-05 11:11:46.000000000 -0500
`./Long Creek WMD GIS Files (from others)/Files from Acorn Engineering - Arc10/Burns/SOPO/StormSystem.gdb/StormSystem.gdb' |0 |2012-11-05 11:11:58.000000000 -0500

**********************************************************************************************

ZIP file contents:
---------|----------------|-------------
./CCSWCD GIS DATA/GIS - Data Layers/Gray_Ag_Parcels.zip
Archive:  ./CCSWCD GIS DATA/GIS - Data Layers/Gray_Ag_Parcels.zip
Length   Method    Size  Cmpr    Date    Time   CRC-32   Name
--------  ------  ------- ---- ---------- ----- --------  ----
10853  Defl:N     2547  77% 06-22-2012 16:04 35d812ee  Gray_Ag_Parcels.shp.xml
284  Defl:N      191  33% 06-22-2012 16:04 bad83cd3  Gray_Ag_Parcels.shx
7713  Defl:N     1218  84% 06-22-2012 16:04 076f6d40  Gray_Ag_Parcels.dbf
424  Defl:N      267  37% 06-22-2012 16:04 3a60c58c  Gray_Ag_Parcels.prj
340  Defl:N      228  33% 06-22-2012 16:04 1ecabae6  Gray_Ag_Parcels.sbn
132  Defl:N       68  49% 06-22-2012 16:04 c14a7f51  Gray_Ag_Parcels.sbx
29680  Defl:N    18393  38% 06-22-2012 16:04 a1413591  Gray_Ag_Parcels.shp
--------          -------  ---                            -------
49426            22912  54%                            7 files

******************************
./CCSWCD GIS DATA/GIS - Data Layers/metwp24s.zip
Archive:  ./CCSWCD GIS DATA/GIS - Data Layers/metwp24s.zip
Length   Method    Size  Cmpr    Date    Time   CRC-32   Name
--------  ------  ------- ---- ---------- ----- --------  ----
1976450  Defl:N   163376  92% 09-02-2010 09:10 fd2bf1f6  metwp24l.dbf
424  Defl:N      267  37% 09-02-2010 09:10 3a60c58c  metwp24l.prj
151892  Defl:N    77302  49% 09-02-2010 09:11 6b9f9af1  metwp24l.sbn
8052  Defl:N     3681  54% 09-02-2010 09:11 bc9776cf  metwp24l.sbx
11677288  Defl:N  7667247  34% 09-02-2010 09:10 2205e768  metwp24l.shp
201558  Defl:N    27889  86% 09-02-2010 09:11 a6c25e1c  metwp24l.shp.xml
127588  Defl:N    68963  46% 09-02-2010 09:10 39cef881  metwp24l.shx
92750  Defl:N    19166  79% 03-30-2011 14:40 7dec3ff6  metwp24.txt
13826  Defl:N     3857  72% 03-30-2011 14:56 de7c22e4  metadata/GEOMCDCCD.txt
388834  Defl:N    35980  91% 03-30-2011 14:31 43f9adbd  geocodeslva.dbf
108844  Defl:N    27473  75% 03-30-2011 14:32 6bf89692  geocodeslva.txt
312502  Defl:N    35163  89% 03-30-2011 14:52 2f0988e9  geomcdccd.dbf
106531  Defl:N    26633  75% 03-30-2011 14:52 084f7157  geomcdccd.txt
11762  Defl:N     3523  70% 04-10-2008 10:05 6d7f73c8  metadata/GEOCODESLVA.txt
92750  Defl:N    19166  79% 03-30-2011 13:40 7dec3ff6  metadata/metwp24.txt
23979  Defl:N     4841  80% 11-17-2011 15:19 3ef4ade7  metadata/GEOCODES.txt
67500  Defl:N    38466  43% 11-17-2011 15:22 56a7c3e9  metwp24p.shx
196252  Defl:N    19399  90% 11-17-2011 15:24 5d76c145  geocodes.dbf
64121  Defl:N    15250  76% 11-17-2011 15:25 665b51ce  geocodes.txt
1449710  Defl:N   218568  85% 11-17-2011 15:22 e073b9cb  metwp24p.dbf
424  Defl:N      267  37% 11-17-2011 15:22 3a60c58c  metwp24p.prj
86580  Defl:N    34808  60% 11-17-2011 15:22 af460800  metwp24p.sbn
2876  Defl:N     1429  50% 11-17-2011 15:22 17c4188c  metwp24p.sbx
20694588  Defl:N 13774271  33% 11-17-2011 15:22 ff946047  metwp24p.shp
215257  Defl:N    31016  86% 11-17-2011 15:22 e15409e0  metwp24p.shp.xml
--------          -------  ---                            -------
38072338         22318001  41%                            25 files

******************************
./CCSWCD GIS DATA/GIS - Data Layers/municipal_separate_stormwater_sewer_systems_regulated_area_shapes.zip
Archive:  ./CCSWCD GIS DATA/GIS - Data Layers/municipal_separate_stormwater_sewer_systems_regulated_area_shapes.zip
Length   Method    Size  Cmpr    Date    Time   CRC-32   Name
--------  ------  ------- ---- ---------- ----- --------  ----
16756  Defl:N     2543  85% 02-01-2010 08:37 f20f1cf3  Municipal_Separate_Stormwater_Sewer_Systems_Regulated_Area.dbf
424  Defl:N      267  37% 02-01-2010 08:37 3a60c58c  Municipal_Separate_Stormwater_Sewer_Systems_Regulated_Area.prj
1188  Defl:N      661  44% 02-01-2010 08:37 b48e0074  Municipal_Separate_Stormwater_Sewer_Systems_Regulated_Area.sbn
156  Defl:N       90  42% 02-01-2010 08:37 529616f6  Municipal_Separate_Stormwater_Sewer_Systems_Regulated_Area.sbx
330612  Defl:N   257154  22% 02-01-2010 08:37 d4d24f38  Municipal_Separate_Stormwater_Sewer_Systems_Regulated_Area.shp
1012  Defl:N      633  38% 02-01-2010 08:37 156351a8  Municipal_Separate_Stormwater_Sewer_Systems_Regulated_Area.shx
--------          -------  ---                            -------
350148           261348  25%                            6 files

<snip>

******************************
```