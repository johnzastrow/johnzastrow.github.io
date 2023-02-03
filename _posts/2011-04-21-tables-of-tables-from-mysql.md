---
id: 145
title: 'Tables of Tables from MySQL'
date: '2011-04-21T15:47:57-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'https://johnzastrow.github.io/2011/04/21/tables-of-tables-from-mysql/'
permalink: /2011/04/21/tables-of-tables-from-mysql/
categories:
    - Database
    - Uncategorized
---

From Matthew Crowley on the MySQl forums (<http://forums.mysql.com/read.php?101,8004>), this php script will output a DESC of all databases and tables in MySQL. It needs some formatting for the output, but it works and might be handy later. I really just need to get around to figuring out how to do this in a procedure or something.

```php

$connection = mysql_connect("localhost","root","PASSWORD");

$showDB = mysql_query("show databases");  
if($myrow=mysql_fetch_array($showDB))  
{  
do  
{  
$DB = $myrow["Database"];  
echo "$DB \
";  
$showTable = mysql_query("show tables from $DB");  
if($myrow=mysql_fetch_array($showTable))  
{  
do  
{  
$col = "Tables_in_".$DB;  
$Table = $myrow["$col"];  
echo "$Table \
";  
$describeTable = mysql_query("describe $DB.$Table");  
if($myrow=mysql_fetch_array($describeTable))  
{  
do  
{  
$field = $myrow["Field"];  
$type = $myrow["Type"];  
$null = $myrow["Null"];  
$key = $myrow["Key"];  
$default = $myrow["Default"];  
$extra = $myrow["Extra"];  
echo "$field \\t $type \\t $null \\t $key \\t $default \\t $extra \
";  
}  
while ($myrow=mysql_fetch_array($describeTable));  
}  
}  
while ($myrow=mysql_fetch_array($showTable));  
}  
}  
while ($myrow=mysql_fetch_array($showDB));  
}

```
