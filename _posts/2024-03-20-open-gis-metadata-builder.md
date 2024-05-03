---
layout: post
title: Utilities for GIS data file discovery and documentation
subtitle: GIS metadata stubbing scripts using OSgeo tools
gh-badge: [star, fork, follow]
date: '2024-03-20T12:47:41-05:00'
tags: [gis]
comments: true
---

# UNDER CONSTRUCTION


I love geospatial metadata [https://gisgeography.com/gis-metadata/], both human (often narrative text) and machine metadata (derived from the data themselves, but written out for humans and machines to see). As a GIS user we spend a lot of time prospecting for usable data to meet our needs. Finding data is only the middle step in eventually using the data. Next you need to determine if those data meet your needs in terms of coverage (spatial and temporal), quality and technical considerations such as how the data were collected, pre/post processed, and later maintained. Good geospatial metadata can provide all of this if it is maintained. Really good human metadata, written by thoughtful humans, can be delightful to read - at least for me.

I'm shocked to say it, but I've always loved Esri's handling of metadata. Historically ArcMap made it straightforward to create at least some kind of metadata for each layer (both in file form and in databases), and then to maintain it. I actually used the option to automatically record processing steps from the software into the metadata for final versions of layers. I liked that it made well-formed XML to ride along with my files, and the same XML was stored in the arcane SDE tables (those I didn't like) with any layer ArcMap could read. 

But going back years [https://gis.stackexchange.com/questions/40994/standard-for-storing-human-metadata-in-spatial-databases], I've dreamed of similar solutions for open source GIS. Now that I don't use Esri software any longer, that need is even more acute.

https://archaeogeek.github.io/qgis-uk-glasgow-2016-metadata/#/

https://gis.stackexchange.com/questions/465082/adding-metadata-that-describes-each-attribute-field-in-qgis
https://mapscaping.com/symbology-and-metadata-in-a-geopackage-in-qgis/




### Latest filelister.sh

```bash
#!/bin/sh
# jcz 2007-May-10
# jcz 2012-June-16
# jcz 2022-Nov-24
# listfiles.sh

# set -vx # turns on verbose output
# Variables pretty self explanatory, S is seconds
dater=$(date +%Y-%m-%d-%H-%M-%S)
dayer=$(date +%a)
namer=$(hostname)
startdir=$(pwd)
logprefix=listedfiles

# Below, recall that -iname tells find to ignore case
# However, the finds that use regex to group different file extensions
# are case sensitive

{
echo "# * WELCOME TO THE FILELISTING SCRIPT FOR THE HOSTNAME" $namer
echo "THE CORRECT USAGE IN A *NIX (CYWGIN) SHELL ENVIRONMENT WOULD BE SOMETHING LIKE"
echo "THE FOLLOWING."
echo "./listfiles.sh "
echo "THE SCRIPT WILL CREATE A UNIQUELY NAMED OUTPUT FILE "
echo "--------------------------------------------------"
echo ""
echo "I am running on: " $dater, $dater
echo "--------------------------------------------------"
echo "Open this file in a spreadsheet program like Excel" 
echo "and use a pipe ( | ) delimited text format"
echo "RESULTS WILL BE SAVED TO" $startdir
echo "--------------------------------------------------"
echo ""
echo "## Searched on:" $(date)
echo "## On system:" $namer
echo "## From the directory:" $startdir
echo " --------------------------------------"
echo ""
echo "## Directories space use: "

du -h --max-depth=2
echo " --------------------------------------"

echo ""
echo "## All Directories are:"
find ./* -type d
echo " --------------------------------------"
echo ""
echo ""
echo ""
echo "## All Directories in tree format:"
echo " --------------------------------------"
tree -d
echo " --------------------------------------"
echo ""
echo ""
echo ""
echo "## Shapefiles:"
echo " ---------|----------------|-------------"
echo "Filename|Filesize (bytes)|Modified"
find ./* -type f -iname \*.shp -print0 | xargs -0  stat -c '%N |%s |%y' 
echo "**********************************************************************************************"
echo "END Shapefiles"

echo ""
echo ""
echo "## PDFs:"
echo " ---------|----------------|-------------"
echo "Filename|Filesize (bytes)|Modified"
find ./* -type f -iname \*.pdf -print0 | xargs -0  stat -c '%N |%s |%y' 
echo "**********************************************************************************************"
echo "END PDF files:"
echo ""
echo ""
echo "## ZIP files:"
echo " ---------|----------------|-------------"
echo "Filename|Filesize (bytes)|Modified"
find ./* -type f -iname \*.zip -print0 | xargs -0  stat -c '%N |%s |%y' 
echo "**********************************************************************************************"
echo "END ZIP files:"
echo ""
echo ""
echo "## Access Databases and Personal Geodatabases files:"
echo " ---------|----------------|-------------"
echo "Filename|Filesize (bytes)|Modified"
find ./* -type f \( -iname "*mdb" -o -iname "*accdb" \) -print0 | xargs -0  stat -c '%N |%s |%y' 
echo "**********************************************************************************************"
echo "END Access Databases and Personal Geodatabases files files:"
echo ""
echo ""
echo "## GDB files:"
echo " ---------|----------------|-------------"
echo "Filename|Filesize (bytes)|Modified"
find ./* -type d -iname \*.gdb -print0 | xargs -0  stat -c '%N |%s |%y' 
echo ""
echo ""
echo "**********************************************************************************************"
echo "END GDB files:"
echo "**********************************************************************************************"
echo ""
echo ""
echo "## TIFs:"
echo " ---------|----------------|-------------"
echo "Filename|Filesize (bytes)|Modified"
find ./* -type f -iname \*.tif -print0 | xargs -0  stat -c '%N |%s |%y' 
echo "**********************************************************************************************"
echo "END TIFs"
echo ""
echo ""
echo "## GeoPackages, Spatialite and SQLite DBs"
echo " ---------|----------------|-------------"
echo "Filename|Filesize (bytes)|Modified"
find ./* -type f -regex  '.*\(db\|sqlite\|gpkg\|db3\)$' ! -regex  '\(.*mdb\|.*gdb\|.*ldb\|.*idb\|.*accdb\)$' ! -iname Thumbs.db -print0 | xargs -0  stat -c '%N |%s |%y' 
echo "**********************************************************************************************"
echo "END Geopackages"
echo ""
echo ""
echo ""
echo "## GeoPackages:"
echo " ---------|----------------|-------------"
echo "Filename|Filesize (bytes)|Modified"
find ./* -type f -iname \*.gpkg -print0 | xargs -0  stat -c '%N |%s |%y' 
echo "**********************************************************************************************"
echo "END Geopackages"
echo ""
echo ""
echo ""
echo "## XML:"
echo " ---------|----------------|-------------"
echo "Filename|Filesize (bytes)|Modified"
find ./* -type f -iname \*.xml -print0 | xargs -0  stat -c '%N |%s |%y' 
echo "**********************************************************************************************"
echo "END XMLs"
echo ""
echo ""
echo ""
echo ""
echo "## DOCs:"
echo " ---------|----------------|-------------"
echo "Filename|Filesize (bytes)|Modified"
find ./* -type f -iname \*.doc* -print0 | xargs -0  stat -c '%N |%s |%y' 
echo "**********************************************************************************************"
echo "END DOCs"
echo ""
echo ""
echo ""
echo "## XLSs:"
echo " ---------|----------------|-------------"
echo "Filename|Filesize (bytes)|Modified"
find ./* -type f -iname \*.xls* -print0 | xargs -0  stat -c '%N |%s |%y' 
echo "**********************************************************************************************"
echo "END XLSs"
echo ""
echo ""
echo ""
echo "## MXDs:"
echo " ---------|----------------|-------------"
echo "Filename|Filesize (bytes)|Modified"
find ./* -type f -iname \*.mxd -print0 | xargs -0  stat -c '%N |%s |%y' 
echo "**********************************************************************************************"
echo "END MXDs"
echo ""
echo ""
echo ""
echo "## ZIP file contents (what is actually in the .zip files):"
echo " ---------|----------------|-------------"
find ./* -type f -iname \*.zip |while read D; do cd "$D"; echo "$D"; unzip -lv "$D"; echo ""; echo ""; echo "******************************"; done
echo "**********************************************************************************************"
echo "END ZIP file contents:"
echo "## Now I will list all files. Paste these pipe ( | ) delimited rows into Excel"
echo ""
echo ""
echo "Filename|Filesize (bytes)|Modified"
find ./* -type f -print0 | xargs -0  stat -c '%N |%s |%y' 
echo ""
} >> $logprefix$dater.txt.md

```

### latest createmeta.sh

```bash
#!/bin/bash
# jcz 13-sep-05
# jcz 10-apr-23
# copies a template metadata text file named
# after each .shp file found
# in current and subdirectories through recursion
# based on zipall.sh
# This script needs a BASH shell interpreter
# and base utils (find, realpath, etc.) to run.
# It will run on linux, possibly MacOS, and Windows
# if something like http://cygwin.com/ is installed.
# Usage: from a command line in the directpry above
# where data files are stored, type the following:
# ./createmeta.sh
##################################
clear 

echo " ******************************* "
echo " this app copies a template metadata text file named,"
echo " after each .shp file found "
echo " in current and subdirectories."
echo " ******************************* "
###  

echo "Enter the top-level directory you'd to create metadata for: "
echo "You are currently in: "; pwd
echo "For example something like the following when running through BASH on Windows, /c/Users/br8kw/OneDrive/Documents/"

read -r startingdir
cd "$startingdir"

hoster=$(hostname)
echo "Run on computer: " "$hoster" >> metalog.txt
startdir=$(pwd)
echo "Starting in this directory and below: " "$startdir" >> metalog.txt
daty=$(date +%a_%F-%H:%M:%S)
echo "At the following date and time:$daty" >> metalog.txt
namer=$(whoami)
echo "By this user: " "$namer" >> metalog.txt
echo "*********************" >> metalog.txt

find . -type f \( -name "*.shp" -o -name "*.tif" -o -name "*.pl" \) | while read -r gis_file; do
   # TODO: this line replaces the shp extension in the metadata filename. Find a way to elegantly
   # do that for the other file types.
    md_file="$(dirname "$gis_file")/$(basename "$gis_file" .shp).md.txt"
   echo "$md_file"
      # if the metadata file exist, skip all below and don't write into the file

if [ ! -e "$md_file" ]; then
# ogrinfo can generate basic metadata from the data file. It is installed with the GDAL utilities 
# often with Qgis. Make sure the utilities are on the 
# path so the command can find them.

filestats=$(stat -c '%y' "$gis_file")
metainfo=$(ogrinfo -ro -al -so "$gis_file")

# metalog is a limited log of what this script does when it is run
echo "$md_file" >> metalog.txt
echo "#########" >> metalog.txt

# previous versions used a more elegent echo approach, but they stopped working.

echo -e "# Title: Some Good Title. Edit everything in this file \n" > "$md_file"
echo "Edit this file and remove this line. File is formatted using MarkDown for human readability -> https://www.markdownguide.org/getting-started/"  >> "$md_file"
echo "" >> "$md_file"
echo "## Edit Date: " >> "$md_file"
echo "" >> "$md_file"
echo "Data edited on: $filestats" >> "$md_file"
echo "" >> "$md_file"
echo "Metadata edited on: $daty" >> "$md_file"
echo "" >> "$md_file"
echo "## Edited By: " >> "$md_file"
echo "" >> "$md_file"

echo "## Creation Date: " >> "$md_file"
echo "" >> "$md_file"
echo "Example: April 20, 2010 " >> "$md_file"
echo "" >> "$md_file"
echo "## Created By: " >> "$md_file"
echo "" >> "$md_file"
echo "$namer" >> "$md_file"
echo "Example: John Zastrow " >> "$md_file"
echo "" >> "$md_file"
echo "## Abstract " >> "$md_file"
echo "" >> "$md_file"
echo "    What: what has been recorded and in what form. Should immediately convey precisely what the resource is." >> "$md_file"
echo "" >> "$md_file"
echo "    Where: description of spatial coverage; whether the coverage is even or variable" >> "$md_file"
echo "" >> "$md_file"
echo "    When: period over which the data were collected." >> "$md_file"
echo "" >> "$md_file"
echo "    How: brief description of methodology. " >> "$md_file"
echo "" >> "$md_file"
 echo "   Why: what purpose was the data collected? Who will find the data useful?" >> "$md_file"
echo "" >> "$md_file"
echo "    Who: parties responsible for the collection and interpretation of data." >> "$md_file"
echo "" >> "$md_file"
echo "    Completeness: any data absent from the dataset? which data are included or excluded, and why. " >> "$md_file"
echo "" >> "$md_file"
echo "## Spatial Extent" >> "$md_file"
echo "" >> "$md_file"
echo " The extents of the Great Pond Mountain Trust property at time the data were collected. North, East, South, West coordinates or description" >> "$md_file"
echo "" >> "$md_file"
echo "## Contact information " >> "$md_file"
echo "" >> "$md_file"
echo "## History " >> "$md_file"
echo "" >> "$md_file"
echo "Date and description of edits, with editor" >> "$md_file"
echo "" >> "$md_file"
echo "" >> "$md_file"
echo "" >> "$md_file"
echo " ****************** OGRINFO OUTPUT ******************** ">> "$md_file"
 echo "$metainfo" >> "$md_file"
fi

done
```

metalog.txt
```
Run on computer:  proxwin10
Starting in this directory and below:  /cygdrive/z/GreatPondTrust/GIS_ReorgB
At the following date and time:Thu_2023-04-27-14:23:38
By this user:  br8kw
*********************
./DATA/MAIN/Biota_Ecological/2022/Ecological/communities.md.txt
#########
./DATA/MAIN/Biota_Ecological/2022/Ecological/Core.md.txt
#########
./DATA/MAIN/Biota_Ecological/2022/Ecological/management concerns.md.txt
#########
./DATA/MAIN/Biota_Ecological/2022/Ecological/monitor points.md.txt
#########
./DATA/MAIN/Biota_Ecological/2022/Ecological/nwi.md.txt
#########
./DATA/MAIN/Biota_Ecological/2022/Ecological/reserve1.md.txt
#########
./DATA/MAIN/Biota_Ecological/2022/Ecological/Sensitive Plants.md.txt
#########
./DATA/MAIN/Biota_Ecological/2022/Ecological/spec.mgmt.zone.md.txt
#########
./DATA/MAIN/Boundaries/2022/GPMCT/ARCHIVE/Bounds_GPMCT-2014.md.txt
#########
./DATA/MAIN/Boundaries/2022/GPMCT/ARCHIVE/property_boyle_poly.md.txt
```

listed files output

```
# * WELCOME TO THE FILELISTING SCRIPT FOR THE HOSTNAME proxwin10
THE CORRECT USAGE IN A *NIX (CYWGIN) SHELL ENVIRONMENT WOULD BE SOMETHING LIKE
THE FOLLOWING.
./listfiles.sh 
THE SCRIPT WILL CREATE A UNIQUELY NAMED OUTPUT FILE 
--------------------------------------------------

I am running on:  2023-04-27-13-59-20, 2023-04-27-13-59-20
--------------------------------------------------
Open this file in a spreadsheet program like Excel
and use a pipe ( | ) delimited text format
RESULTS WILL BE SAVED TO /cygdrive/z/GreatPondTrust/GIS_ReorgB
--------------------------------------------------

## Searched on: Thu Apr 27 13:59:26 EDT 2023
## On system: proxwin10
## From the directory: /cygdrive/z/GreatPondTrust/GIS_ReorgB
 --------------------------------------

## Directories space use: 
4.7G	./DATA/MAIN
1.7G	./DATA/PROJECTS
6.4G	./DATA
6.4G	.
 --------------------------------------

## All Directories are:
./DATA
./DATA/MAIN
./DATA/MAIN/Biota_Ecological
./DATA/MAIN/Biota_Ecological/2022
./DATA/MAIN/Biota_Ecological/2022/Ecological
./DATA/MAIN/Boundaries
./DATA/MAIN/Boundaries/2022
./DATA/MAIN/Boundaries/2022/GPMCT
<snip>
./DATA/PROJECTS/2022/Wildlands Trail Run
 --------------------------------------



## All Directories in tree format:
 --------------------------------------
.
└── DATA
    ├── MAIN
    │   ├── Biota_Ecological
    │   │   └── 2022
    │   │       └── Ecological
    │   ├── Boundaries
    │   │   └── 2022
    │   │       ├── GPMCT
    │   │       │   └── ARCHIVE
    │   │       └── State
    │   ├── Cadastre
    │   │   └── 2022
    │   ├── Climate
    │   │   └── 2022
    │   ├── Cultural_Demographic
    │   │   └── 2022
    │   ├── Elevation
    │   │   └── 2022
    │   │       ├── Aspects
    │   │       ├── Contours
    │   │       ├── DEM
    │   │       │   ├── BranchLakeDEM
    │   │       │   │   ├── aspct_branch
    │   │       │   │   ├── brnchlkaspect
    │   │       │   │   ├── info
    │   │       │   │   └── slope_branch
    │   │       │   ├── BrewerLakeDEM
    │   │       │   │   ├── aspct_brewlk
    │   │       │   │   ├── info
    │   │       │   │   └── slope_bwrlk
    │   │       │   ├── BucksportDEM
    │   │       │   │   ├── aspt_bkpt
    │   │       │   │   ├── info
    │   │       │   │   └── slope_bkpt
    │   │       │   ├── OrlandDEM
    │   │       │   │   ├── aspect_orland
    │   │       │   │   ├── info
    │   │       │   │   ├── orlandaspect
    │   │       │   │   └── slope_orland
    │   │       │   ├── brewlk_hills
    │   │       │   └── orld_hills
    │   │       ├── SlopePosition
    │   │       ├── SlopeShape
    │   │       └── Slopes
    │   ├── Facilities_Structures
    │   │   └── 2022
    │   ├── GRAPHICS
    │   │   ├── GPMCT Logos
    │   │   └── LJP Custom Map Icons
    │   ├── GeoPhysical
    │   │   └── 2022
    │   │       ├── HancockCtySoils
    │   │       │   ├── SoilSitePro
    │   │       │   │   ├── SpatialGeodatabase.idb
    │   │       │   │   │   ├── c_1
    │   │       │   │   │   ├── c_2
    │   │       │   │   │   ├── c_3
    │   │       │   │   │   └── c_4
    │   │       │   │   ├── aspectrecls
    │   │       │   │   ├── brewlkcurv
    │   │       │   │   ├── brnchlkcurv
    │   │       │   │   ├── curvreclass
    │   │       │   │   ├── gpmct_dem
    │   │       │   │   ├── gpmctaspect
    │   │       │   │   ├── gpmctslppct
    │   │       │   │   ├── info
    │   │       │   │   ├── orlaspect
    │   │       │   │   ├── orlcurvtin
    │   │       │   │   └── slppctreclass
    │   │       │   ├── info
    │   │       │   ├── orland_curv
    │   │       │   ├── orlfstatprof
    │   │       │   ├── orlplan
    │   │       │   ├── orlprofile
    │   │       │   └── soil_me611
    │   │       │       ├── spatial
    │   │       │       └── tabular
    │   │       └── Soil-Site
    │   ├── Imagery
    │   │   └── 2022
    │   │       ├── LiDAR Ascii Files
    │   │       ├── Orland-2ftOrthos
    │   │       ├── USGS Maps
    │   │       └── USGS_QuadRaster
    │   ├── InlandWaters
    │   │   └── 2022
    │   │       ├── drainage
    │   │       ├── lakes
    │   │       ├── streams
    │   │       │   ├── StateBufferZones_Orland
    │   │       │   └── ephemeral
    │   │       └── wetlands
    │   ├── Land_Characteristics
    │   │   └── 2022
    │   │       └── BiophysicalRegions
    │   ├── Locations
    │   │   └── 2022
    │   ├── MAPDOCUMENTS_STYLES
    │   ├── NatResources_Farming
    │   │   └── 2022
    │   │       ├── BiotaMonitoringManagement
    │   │       └── Forestry
    │   │           ├── ForestCover-Stands
    │   │           ├── ForestCoverClassification
    │   │           │   ├── 2012CIRImagery
    │   │           │   ├── 2012CanopyData
    │   │           │   │   └── canopy_data
    │   │           │   │       ├── corr_dem_heights
    │   │           │   │       │   └── info
    │   │           │   │       ├── corr_dem_stats
    │   │           │   │       ├── orig_dem_heights
    │   │           │   │       │   └── info
    │   │           │   │       └── orig_dem_stats
    │   │           │   ├── 2012Shapefiles
    │   │           │   ├── Communities-Ecosystems
    │   │           │   │   ├── EcologialGISdata
    │   │           │   │   └── Wildflowers
    │   │           │   ├── Stand_Geodatabases
    │   │           │   ├── brnchslp20
    │   │           │   ├── info
    │   │           │   ├── orldslp20
    │   │           │   ├── pca_ortho
    │   │           │   ├── pca_orthoc1
    │   │           │   ├── pca_orthoc2
    │   │           │   └── pca_orthoc3
    │   │           └── ForestMgt
    │   ├── Oceans
    │   │   └── 2022
    │   ├── Planning
    │   │   └── 2022
    │   │       ├── Mountain Bike Trail Planning
    │   │       └── Proposed Trails
    │   ├── Transportation
    │   │   └── 2022
    │   │       ├── Roads
    │   │       ├── Trails
    │   │       │   ├── Leah Trails Layer
    │   │       │   │   └── trails_shapefile
    │   │       │   ├── MeadMtnTinCanTrail
    │   │       │   └── Snowmobile Trails
    │   │       └── Ungated Access
    │   └── Utilities
    │       └── 2022
    └── PROJECTS
        └── 2022
            ├── 2013RaceCourse
            ├── 2017StormDamage
            ├── 2018_earlier_roger
            ├── 2022 Property Survey
            ├── 2022Oct_TestMobileMap
            │   ├── CSV
            │   ├── CompactTileCache
            │   │   └── Layers
            │   │       └── _alllayers
            │   │           ├── L00
            │   │           ├── L01
            │   │           ├── L02
            │   │           ├── L03
            │   │           ├── L04
            │   │           ├── L05
            │   │           ├── L06
            │   │           ├── L07
            │   │           ├── L08
            │   │           ├── L09
            │   │           ├── L10
            │   │           ├── L11
            │   │           ├── L12
            │   │           ├── L13
            │   │           ├── L14
            │   │           ├── L15
            │   │           └── L16
            │   ├── esriinfo
            │   │   └── thumbnail
            │   └── servicedescriptions
            │       └── mapserver
            ├── Acquisitions
            │   ├── BellaProp_Orland
            │   │   ├── BellaPics
            │   │   ├── Bella_SurveyData
            │   │   └── ForestManagement_DR-West
            │   ├── BoyleLot
            │   ├── BriggsLot
            │   ├── CampanellaLot
            │   │   ├── SampleData
            │   │   ├── aspectcls
            │   │   ├── camp_hillshd
            │   │   ├── info
            │   │   └── slopecls
            │   ├── ChapmanFarm
            │   ├── DePaoloLot
            │   ├── GinnLot
            │   ├── GoodwinBlock
            │   ├── GottParcel
            │   ├── HedgehogMtn
            │   ├── Joost_VeronaPoint
            │   ├── KimballLot
            │   ├── LeachLot
            │   ├── McAllianLot
            │   └── R-MercerWoodlot
            ├── BrookTroutRestoration
            ├── CascadeBrook_PreTmt
            ├── Cheri'sBrook
            ├── CulvertInventory
            │   └── GPMCT Culvert Inventory copy.numbers
            │       ├── Data
            │       └── Metadata
            ├── Forest ManagementPlan
            │   ├── DeadRiver
            │   │   └── DR ForMgtPlanUpdates
            │   │       └── DRupdates2020-2023
            │   ├── Hothole
            │   │   └── HH_ForMgtPlanUpdates
            │   │       ├── Update2019
            │   │       ├── Update2020
            │   │       └── Update2021
            │   ├── LandEthicPrinciples
            │   ├── ManagedForestGISdata
            │   │   ├── brnchlkslp%
            │   │   ├── brwlkslp%
            │   │   ├── demslp%
            │   │   ├── info
            │   │   ├── orlndslp%
            │   │   └── slp%tin
            │   ├── NRCS_MgtPlanSupport
            │   ├── References
            │   └── StrategicReserves
            ├── GPS_Data4Review
            │   └── UnitDownloadJan2020
            ├── HillsideBrookSkidTrls-PreTmt
            ├── HillsideHorseTrail
            ├── Macallian Piece
            ├── OldDRsubdivPlan
            ├── RoadMaintenance
            │   ├── Maintenance
            │   │   ├── 2021
            │   │   └── Flag Hill Crossing
            │   └── RoadPics
            ├── Streams-Riparian
            ├── Wildlands Snowshoe Race
            ├── Wildlands Trail Run
            ├── orlandaspect
            ├── orlandplan
            └── orlandprofile

243 directories
 --------------------------------------



## Shapefiles:
 ---------|----------------|-------------
Filename|Filesize (bytes)|Modified
'./DATA/MAIN/Biota_Ecological/2022/Ecological/communities.shp' |76236 |2012-04-18 16:51:08.000000000 -0400
'./DATA/MAIN/Biota_Ecological/2022/Ecological/Core.shp' |6380 |2015-03-30 14:37:58.000000000 -0400
'./DATA/MAIN/Biota_Ecological/2022/Ecological/management concerns.shp' |884 |2020-05-26 09:34:04.000000000 -0400
'./DATA/MAIN/Biota_Ecological/2022/Ecological/monitor points.shp' |2116 |2006-12-19 22:27:28.000000000 -0500
'./DATA/MAIN/Biota_Ecological/2022/Ecological/nwi.shp' |33403140 |2006-12-19 22:27:10.000000000 -0500
'./DATA/MAIN/Biota_Ecological/2022/Ecological/reserve1.shp' |6380 |2006-12-19 22:27:28.000000000 -0500
'./DATA/MAIN/Biota_Ecological/2022/Ecological/Sensitive Plants.shp' |632 |2006-12-19 22:27:28.000000000 -0500
'./DATA/MAIN/Biota_Ecological/2022/Ecological/spec.mgmt.zone.shp' |139648 |2006-12-19 22:27:10.000000000 -0500
'./DATA/MAIN/Boundaries/2022/GPMCT/ARCHIVE/Bounds_GPMCT-2014.shp' |1876 |2016-11-30 08:53:02.000000000 -0500
<snip>
'./DATA/PROJECTS/2022/Wildlands Trail Run/2_mile_trail_run_route.shp' |4228 |2022-09-28 14:10:43.000000000 -0400
'./DATA/PROJECTS/2022/Wildlands Trail Run/full_trail_run_route.shp' |51724 |2022-09-28 14:10:42.000000000 -0400
**********************************************************************************************
END Shapefiles

<other file types here>

## Access Databases and Personal Geodatabases files:
 ---------|----------------|-------------
Filename|Filesize (bytes)|Modified
'./DATA/MAIN/Biota_Ecological/2022/Ecological/GtPondTrustEcoClassGeodatabase.mdb' |1929216 |2023-01-10 12:59:34.573022900 -0500
'./DATA/MAIN/GeoPhysical/2022/HancockCtySoils/SoilSitePro/SpatialGeodatabase.mdb' |696320 |2018-09-26 13:02:02.000000000 -0400
'./DATA/MAIN/GeoPhysical/2022/HancockCtySoils/soil_me611/soildb_ME_2002.mdb' |45309952 |2022-05-26 12:21:26.000000000 -0400
'./DATA/MAIN/NatResources_Farming/2022/BiotaMonitoringManagement/GtPondTrustEcoClassGeodatabase.mdb' |1904640 |2021-01-06 13:57:29.000000000 -0500
'./DATA/MAIN/NatResources_Farming/2022/Forestry/ForestCover-Stands/GPT_Stands2015Geodatabase.mdb' |3280896 |2022-02-01 16:34:18.000000000 -0500
'./DATA/MAIN/NatResources_Farming/2022/Forestry/ForestCoverClassification/Communities-DibbleRees2006.accdb' |417792 |2014-06-17 10:10:02.000000000 -0400
'./DATA/MAIN/NatResources_Farming/2022/Forestry/ForestCoverClassification/Communities-Ecosystems/Communities-DibbleRees2006.accdb' |446464 |2021-01-23 13:00:50.000000000 -0500
'./DATA/MAIN/NatResources_Farming/2022/Forestry/ForestCoverClassification/Communities-Ecosystems/EcologialGISdata/GtPondTrustClassifiedGeodatabase.mdb' |1466368 |2015-04-22 12:06:00.000000000 -0400
'./DATA/MAIN/NatResources_Farming/2022/Forestry/ForestCoverClassification/Communities-Ecosystems/EcologialGISdata/GtPondTrustEcoClassGeodatabase.mdb' |1486848 |2020-11-07 15:31:06.000000000 -0500
'./DATA/MAIN/NatResources_Farming/2022/Forestry/ForestCoverClassification/Stands2012_InitialMapping.accdb' |2449408 |2016-09-01 15:06:22.000000000 -0400
'./DATA/MAIN/NatResources_Farming/2022/Forestry/ForestCoverClassification/Stands2015_Clip.mdb' |311296 |2016-09-01 14:54:09.000000000 -0400
'./DATA/MAIN/NatResources_Farming/2022/Forestry/ForestCoverClassification/Stand_Geodatabases/GPT_Stands2015Geodatabase.mdb' |3416064 |2022-04-21 11:08:50.000000000 -0400
'./DATA/PROJECTS/2022/Acquisitions/CampanellaLot/SampleData/Campanella2015.mdb' |12967936 |2018-03-15 10:04:48.000000000 -0400
'./DATA/PROJECTS/2022/Forest ManagementPlan/2012CoverTypes.accdb' |782336 |2012-09-09 14:01:50.000000000 -0400
'./DATA/PROJECTS/2022/Forest ManagementPlan/DeadRiver/DeadRiver.mdb' |45993984 |2017-02-18 14:06:28.000000000 -0500
'./DATA/PROJECTS/2022/Forest ManagementPlan/Hothole/HotholeForested.mdb' |29380608 |2017-02-02 13:35:14.000000000 -0500
**********************************************************************************************
END Access Databases and Personal Geodatabases files files:


## GDB files:
 ---------|----------------|-------------
Filename|Filesize (bytes)|Modified


**********************************************************************************************
END GDB files:
**********************************************************************************************


## TIFs:
 ---------|----------------|-------------
Filename|Filesize (bytes)|Modified
'./DATA/MAIN/Imagery/2022/USGS_QuadRaster/USGS_BK.TIF' |7244781 |2006-12-19 22:27:22.000000000 -0500
'./DATA/MAIN/Imagery/2022/USGS_QuadRaster/USGS_BL.TIF' |5303063 |2006-12-19 22:27:24.000000000 -0500
'./DATA/MAIN/Imagery/2022/USGS_QuadRaster/USGS_BR.TIF' |5666271 |2006-12-19 22:27:24.000000000 -0500
<snip>
'./DATA/PROJECTS/2022/2018_earlier_roger/USGS_OR.TIF' |5760601 |2006-12-19 22:27:26.000000000 -0500
**********************************************************************************************
END TIFs


## GeoPackages, Spatialite and SQLite DBs
 ---------|----------------|-------------
Filename|Filesize (bytes)|Modified
'./DATA/MAIN/MAPDOCUMENTS_STYLES/qgis_map_projects.gpkg' |0 |2023-02-02 16:06:51.792821000 -0500
**********************************************************************************************
END Geopackages



## GeoPackages:
 ---------|----------------|-------------
Filename|Filesize (bytes)|Modified
'./DATA/MAIN/MAPDOCUMENTS_STYLES/qgis_map_projects.gpkg' |0 |2023-02-02 16:06:51.792821000 -0500
**********************************************************************************************
END Geopackages


