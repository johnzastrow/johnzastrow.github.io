---
id: 25
title: 'Simple grep and search &#038; replace'
date: '2008-07-05T20:36:36-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/2008/07/05/simple-grep-and-search-replace/'
permalink: /2008/07/05/simple-grep-and-search-replace/
categories:
    - Linux
---

grep -Hn -e ” int” \*.c\* \*.h

searches for the string “int” files ending in .c\* or .h in the the current directory directory

Returns:

! P8.CPP:52: cerr &lt;&lt; “cannot allocate int \*p1” &lt;&lt; endl ;  
 ! P8.CPP:59: } //format =&gt; int \*p = new int\[100\];  
 ! P9.CPP:9:inline int sumup( int x, int y)  
 ! P9.CPP:17: int i1 = 10, i2 = 20, sum = 0;  
 ! functions.h:3:int doTotal(int x1, int x2)  
 ! functions.h:12:float doAverage(int x1, int x2)  
 ! functions.h:19:int doDifference(int x1, int x2)

In case you want to search through some text files in a series of  
directories replacing one set of text for another in each of the files,  
try this shell script.

\#!/bin/sh  
for file in `grep -liR “someword” ./\*`;   
do  
 sed ‘s/someword/someother\_word/g’ $file &gt; tmp/$$ &amp;&amp; mv tmp/$$ $file  
done