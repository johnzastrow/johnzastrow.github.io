---
id: 8
title: 'Handy shell file lister for cygwin or *NIX'
date: '2008-07-05T18:59:44-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'https://johnzastrow.github.io/2008/07/05/handy-shell-file-lister-for-cygwin-or-nix/'
permalink: /2008/07/05/handy-shell-file-lister-for-cygwin-or-nix/
categories:
    - Uncategorized
tags:
    - ''
---

This tip is useful for any system with a useful implementaion of

```
ls, wc, and awk
```

. However, some options may need to be modified. For example, the ```
ls
```

 options work best on linux, though they suffice on my cygwin install on Windows when my username does not have a space in it The commands for running this trick usefully on cygwin/windows is:

```
ls -ghGR --full-time | awk '{ print $1"\t" $3 "\t" $4 "\t" $7 $8 $9 $10 $11 $12 }' | unix2dos > filelist.txt && wc -l filelist.txt >&gt; filelist.txt
```

 to produce the following listing:

[snip]  
<font color="#009900"><small><font face="Courier New">total   
-rwx——+ 16K 2008-06-09 Export_Output.shp.xml  
drwx——+ 0 2008-06-24 java  
drwx——+ 0 2008-06-24 licenses  
-rwx——+ 42K 2008-05-29 openoffice.org-activex.cab  
-rwx——+ 1.8M 2008-05-29 openoffice.org-base.cab  
-rwx——+ 18M 2008-05-29 openoffice.org-core05.cab  
-rwx——+ 28M 2008-05-29 openoffice.org-core06.cab  
-rwx——+ 3.7M 2008-05-29 openoffice.org-core07.cab  
-rwx——+ 2.4M 2008-05-29 openoffice.org-writer.cab  
-rwx——+ 37K 2008-05-29 openoffice.org-xsltfilter.cab  
-rwx——+ 4.2M 2008-05-29 openofficeorg24.msi  
drwx——+ 0 2008-06-24 readmes  
-rwx——+ 217 2008-05-29 setup.ini  
-rwx——+ 500K 2008-06-19 stormwater.mdb</font></small></font>

./java:   
total   
-rwx——+ 16M 2008-01-15 jre-6u4-windows-i586-p.exe

./licenses:   
total

158 filelist.txt