---
id: 27
title: 'Upgrade your debian sources.list'
date: '2008-07-05T20:38:31-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'https://johnzastrow.github.io/2008/07/05/upgrade-your-debian-sourceslist/'
permalink: /2008/07/05/upgrade-your-debian-sourceslist/
categories:
    - Linux
---

apt-spy is a program that benchmarks debian apt-get sources. Run this  
script when you need to find your bets local mirror for grabbing debian  
packages.

#!/bin/sh  
# jcz 2005-july-13  
#  
# This script will add the best debian servers to your sources.list file.  
# You should prune the file by hand when it's done.

# Date and other variables pretty self explanatory, S is seconds  
# date format is currently YYYYMMDD_HHMMSS  
 datearc=$(hostname)_sourcesbackup_$(date +%Y%m%d_%H%M%S).txt

cp /etc/apt/sources.list /etc/apt/sources.list.$datearc

# benchmarks 3 north american servers for downloading the testing debian packages  
# and will overwrite sources.list with the results  
apt-spy -d testing -a north-america -e 3

# the overwrite makes us copy back our favorites  
cat /etc/apt/sources.list.$datearc &gt;&gt; /etc/apt/sources.list

echo "Don't forget to prune /etc/apt/sources.list !!!"