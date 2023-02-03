---
id: 30
title: 'Bash shell script for creating a poor man&#8217;s CD-ROM (removable media) catalog for linux'
date: '2008-07-05T20:42:10-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'https://johnzastrow.github.io/2008/07/05/bash-shell-script-for-creating-a-poor-mans-cd-rom-removable-media-catalog-for-linux/'
permalink: /2008/07/05/bash-shell-script-for-creating-a-poor-mans-cd-rom-removable-media-catalog-for-linux/
categories:
    - Linux
---

\#!/bin/sh  
# jcz 2004-jan-12

# assumes iso9660 CD-ROM  
mount -t iso9660 -r /dev/cdrom /mnt/cdrom

echo "Disc Mounted. Run this program, then grep keywords in the "  
echo "cdcatalogs directory to find which CD-ROM some file "  
echo "is on. "

# makes the directory to store the catalog files  
mkdir cdcatalogs

# runs volname (part of the eject program) to extract the volume label information  
cd=$(volname /dev/cdrom)

# enter user defined CD label (something written on the CD itself)  
echo -n "Enter written CD-ROM label and any notes from the disc itself: "  
read labler

# trims white space after the name always written out by volname  
cdshort=$(echo $cd | sed -e 's/\[ntr \]\*$//')  
echo $cdshort  
echo $cdshort"\_catalog.txt"  
disk=$cdshort"\_catalog.txt"  
echo $disk  
echo $labler  
echo "Disk Volume Label: "$cdshort &gt; $disk  
echo "Label and Notes on Disc: " $labler &gt;&gt; $disk  
echo " ——————————————" &gt;&gt; $disk  
echo "——– &lt;&lt;&lt;&lt;END DISC ENTRY&gt;&gt;&gt; ————" &gt;&gt; $disk  
echo " ——————————————" &gt;&gt; $disk  
echo " " &gt;&gt; $disk

# keeps only relevant columns from ls, and date is in a fixed length format which is understandable   
# by M$ Office products if needed  
ls -ghGR –full-time /mnt/cdrom | awk '{ print $1 "t" $3 "t"$4 " " $5 "t"$7 $8 $9 $10 $11 }'&gt;&gt; $disk

# fixes the line endings for windows if you want read the catalogs directly in Notepad  
unix2dos $disk

# moves file to consistent directory  
mv $disk cdcatalogs/

ls -lht cdcatalogs/

umount /mnt/cdrom  
# ejects the disk when done to prepare for next disk  
eject