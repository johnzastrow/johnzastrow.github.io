---
id: 35
title: 'Optimize all tables in a database, Part 2'
date: '2008-07-05T20:47:17-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'https://johnzastrow.github.io/2008/07/05/optimize-all-tables-in-a-database-part-2/'
permalink: /2008/07/05/optimize-all-tables-in-a-database-part-2/
categories:
    - Database
---

Ok, not being satisfied with my first exploration of a global "do something" mysql script I asked the community for help.

The result is posted below, and here are the links that got me here.  
<http://www.linuxquestions.org/questions/showthread.php?p=2668261#post2668261>  
<http://www.linuxforums.org/forum/linux-programming-scripting/85836-loop-within-loop-mysql-ops.html#post445403>

Here is the final example script that optimizes (or replace optimize  
with your favorite command like backup, alter table to InnoDB, etc.)  
all tables in all databases on a server except the core mysql databases  
or others that you exclude.

\#!/bin/sh  
MUSER="USER"  
MPASS="PASSWORD"  
MHOST="localhost"  
MYSQL="$(which mysql)"  
# the Bs makes the output appear without the formatting  
# and header row.  
# Step 1: list all databases EXCEPT core mysql tables and others that can be added  
DBS="$($MYSQL -u$MUSER -p$MPASS -Bse 'show databases' | egrep -v 'information\_schema|mysql|test')"

for db in ${DBS\[@\]}  
do

# Step 2: list all tables in the databases  
 echo "$MYSQL -u$MUSER -p$MPASS $db -Bse 'show tables'"  
 TABLENAMES="$($MYSQL -u$MUSER -p$MPASS $db -Bse 'show tables')"  
 echo "\[START DATABASE\]"  
 echo "Database: "$db  
 echo ${TABLENAMES\[@\]}

# Step 3: perform an optimize (or other op) for all tables returned

 for TABLENAME in ${TABLENAMES\[@\]}  
 do  
 echo $TABLENAME  
 $MYSQL -u$MUSER -p$MPASS $db -Bse "optimize TABLE $TABLENAME;"   
 done  
 echo "\[END DATABASE\]"  
done