---
id: 31
title: 'Postgis data loader from shapefile bash shell script'
date: '2008-07-05T20:43:16-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/2008/07/05/postgis-data-loader-from-shapefile-bash-shell-script/'
permalink: /2008/07/05/postgis-data-loader-from-shapefile-bash-shell-script/
categories:
    - GIS
---

Run this script in a directory of shp files to create STDOUT that will load them all into postgis

——————————————————  
\#!/bin/sh  
\# jcz aug 24, 2005  
\# clip off the “.shp” file extensions before use  
\# drops existing shapes if they are the same name

for z in `ls \*.shp  
do  
 echo “shp2pgsql $z $z &gt; $z.sql”  
echo “psql -d -f $z.sql”  
done