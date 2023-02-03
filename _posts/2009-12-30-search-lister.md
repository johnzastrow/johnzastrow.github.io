---
id: 70
title: 'Search lister'
date: '2009-12-30T12:56:15-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=70'
permalink: /2009/12/30/search-lister/
categories:
    - Linux
---

This little script needs a lot of help But it will recurse down through the current directory and create a listing of files, their folders, sizes, and modification dates and times. it was written to run on Windows under Cygwin.

```
<br />
#!/bin/sh<br />
# v1 jcz 30-dec-2009<br />
# This script will search for files of a certain type and create a text file of the results<br />
# TODO:<br />
#
```

\############################  
# enable for debugging #####  
\############################  
# set -vx

\############################  
# Global script variables block  
\############################  
# Date and other variables pretty self explanatory, S is seconds  
# date format is currently YYYYMMDD\_HHMMSS  
dater=$(date +%Y-%m-%d %H:%M:%S)  
dayer=$(date +%a)  
namer=$(whoami)  
hoster=$(hostname)  
directory=$(pwd)  
filenamer=$(date +%Y%m%d\_%H%M%S).txt  
# sets day of the week for incremental backups  
set $(date)

\############################  
# Clear the screen and introduce the user to the script  
\############################

clear  
echo ""  
echo "WELCOME TO THE FIND TO LIST SCRIPT"  
echo ""

\############################  
# Wait for the user to enter a new file extension and capture the value as a variable  
\############################  
echo -n "Enter file extension to search for, without the leading dot (e.g. txt): "  
read fileext

\############################  
# Wait for the user to enter a new file destination  
\############################  
echo -n "Enter a new log file destination without ending slash (e.g., /cygdrive/c ): "  
read filedest

\############################  
# Create the log file for the script named after the file extension  
\############################  
echo "—-" &gt;&gt; $filedest/$filenamer  
# echo "—-" &gt; $filedest/$fileext\_files\_from\_$directory\_on\_$dater.txt  
echo "File created on: "$dater &gt;&gt; $filedest/$filenamer  
echo "Setup script was run in: "$directory &gt;&gt; $filedest/$filenamer  
echo "By user" $namer &gt;&gt; $filedest/$filenamer  
echo "Searching for files ending in: " $fileext &gt;&gt; $filedest/$filenamer  
echo "This file was written to: " $filedest/$filenamer &gt;&gt; $filedest/$filenamer  
echo "\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*" &gt;&gt;$filedest/$filenamer  
echo "" &gt;&gt; $filedest/$filenamer

find . -name '\*.'$fileext -type f -print0 | xargs -0 stat -c 'file: %N | bytes: %s | modtime: %y' &gt;&gt; $filedest/$filenamer

echo -n "Hit enter to continue "  
read none

echo ""  
echo "\* Now I will show you the file and be done"  
echo ""  
echo -n "Hit enter to list or Ctrl-c to quit "  
read none  
less $filedest/$filenamer