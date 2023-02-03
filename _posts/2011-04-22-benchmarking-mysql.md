---
id: 154
title: 'Benchmarking MySQL'
date: '2011-04-22T16:10:46-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'https://johnzastrow.github.io/2011/04/22/benchmarking-mysql/'
permalink: /2011/04/22/benchmarking-mysql/
categories:
    - Database
    - Uncategorized
---

So I'm trying to figure which old machine to turn into a little mySQL number cruncher. So, I'm going to do some clean installs of Ubuntu server on each and run this little script (with the same my.cnf) and see how they fair. Perhaps you will this useful, run it a few times.

```bash

#!/bin/sh  
# jcz 2011-April-22  
#  
# This script will time your MySQL database in a repeatable way  
#  
# Date and other variables pretty self explanatory, S is seconds  
# date format is currently YYYYMMDD_HHMMSS  
 dater=$(date +%Y%m%d_%H%M%S)  
 dayer=$(date +%a)  
 myhost=$(hostname)  
 directory=$(pwd)  
 outfile="slapout.txt"

# THE MYSQL USER  
 super="username"

# THE MYSQL SUPERPWORD  
 superword="password"

# THE MYSQL HOSTNAME or IP.  
 hoster="localhost"

echo "—————— BEGIN ——————–" &gt;&gt; $outfile  
date &gt;&gt; $outfile  
echo $myhost &gt;&gt; $outfile  
echo $directory &gt;&gt; $outfile

# COPY THE COMMAND BELOW  
mysqlslap -u$super -p$superword -h$hoster -v –concurrency=1 –iterations=2 –number-int-cols=4 –number-char-cols=5 –auto-generate-sql –auto-generate-sql-secondary-indexes=3 –engine=myisam,innodb –auto-generate-sql-add-autoincrement –auto-generate-sql-load-type=mixed –number-of-queries=2 &gt;&gt; $outfile

 echo "………………………….." &gt;&gt; $outfile  
 # PASTE THE COMMAND BELOW BETWEEN THE QUOTES OR EDIT BOTH. I CAN'T FIND ANOTHER WAY TO RECORD IT  
echo "mysqlslap -u$super -p$superword -h$hoster -v –concurrency=1 –iterations=2 –number-int-cols=4 –number-char-cols=5 –auto-generate-sql –auto-generate-sql-secondary-indexes=3 –engine=myisam,innodb –auto-generate-sql-add-autoincrement –auto-generate-sql-load-type=mixed –number-of-queries=2" &gt;&gt; $outfile  
echo "………………………….." &gt;&gt; $outfile  
echo "The above command was executed to produce the results above it." &gt;&gt; $outfile  
echo "—————— END ——————–" &gt;&gt; $outfile  
echo "" &gt;&gt; $outfile  
echo "" &gt;&gt; $outfile  
echo "" &gt;&gt; $outfile

[/cce_bash]

The above script makes output like below

—————— BEGIN ——————–  
Fri Apr 22 17:05:15 EDT 2011  
monitor  
/home/jcz  
Benchmark  
 Running for engine myisam  
 Average number of seconds to run all queries: 0.000 seconds  
 Minimum number of seconds to run all queries: 0.000 seconds  
 Maximum number of seconds to run all queries: 0.000 seconds  
 Number of clients running queries: 1  
 Average number of queries per client: 2

Benchmark  
 Running for engine innodb  
 Average number of seconds to run all queries: 0.045 seconds  
 Minimum number of seconds to run all queries: 0.041 seconds  
 Maximum number of seconds to run all queries: 0.050 seconds  
 Number of clients running queries: 1  
 Average number of queries per client: 2

…………………………..  
mysqlslap -u… -p… -hlocalhost -v –concurrency=1 –iterations=2 –number-int-cols=4 –number-char-cols=5 –auto-generate-sql –auto-generate-sql-secondary-indexes=3 –engine=myisam,innodb –auto-generate-sql-add-autoincrement –auto-generate-sql-load-type=mixed –number-of-queries=2  
…………………………..  
The above command was executed to produce the results above it.  
—————— END ——————–

