---
id: 534
title: 'List my files'
date: '2012-06-15T06:14:58-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=534'
permalink: /2012/06/15/list-my-files/
categories:
    - 'Data processing'
    - Linux
---

About three times a year I need to make a listing of files in a directory. Usually this is because I need to do something to them and I need a checklist. Or I just need to tell someone what files are there.

So, back in 2002 I made this little script. Enjoy.

```bash

#!/bin/sh
# jcz 2012-June-16
# listfiles.sh

# Variables pretty self explanatory, S is seconds
dater=$(date +%Y-%m-%d)
dayer=$(date +%a)
namer=$(hostname)
startdir=$(pwd)

echo "* WELCOME TO THE FILELISTING SCRIPT FOR THE HOSTNAME" $namer
echo "* THE CORRECT USAGE IN A *NIX (CYWGIN) SHELL ENVIRONMENT WOULD BE SOMETHING LIKE"
echo "* listfiles.sh > /cygdrive/c/prvi/metlist.txt"
echo "* --------------------------------------------------"
echo "* Open this file in a spreadsheet program like Excel"
echo "* and use a pipe ( | ) delimited text format"
echo "* RESULTS WILL BE SAVED TO" $startdir
echo "* --------------------------------------------------"
echo ""
echo "Directories space use:"

# display directory disk usage drilling down one level from where the script is run
du -h --max-depth=1
echo " --------------------------------------"
echo ""

# Sometimes I care what all the directories are
echo "All Directories are:"
find ./* -type d
echo " --------------------------------------"
echo ""
echo "Searched on:" $(date)
echo "On system:" $namer
echo "From the directory:" $startdir
echo " --------------------------------------"
echo ""

# Output found files in a list that Excel would appreciate
echo "Filename|Filesize (bytes)|Modified"
find ./* -type f -print0 | xargs -0  stat -c '%N |%s |%y'

```

Here it is being used in Cygwin on windows

[![](http://northredoubt.com/n/wp-content/uploads/2012/06/listfiles-300x128.gif "listfiles")](http://northredoubt.com/n/wp-content/uploads/2012/06/listfiles.gif)