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

\[cce\_php\]

$connection = mysql\_connect("localhost","root","PASSWORD");

$showDB = mysql\_query("show databases");  
if($myrow=mysql\_fetch\_array($showDB))  
{  
do  
{  
$DB = $myrow\["Database"\];  
echo "$DB \\n";  
$showTable = mysql\_query("show tables from $DB");  
if($myrow=mysql\_fetch\_array($showTable))  
{  
do  
{  
$col = "Tables\_in\_".$DB;  
$Table = $myrow\["$col"\];  
echo "$Table \\n";  
$describeTable = mysql\_query("describe $DB.$Table");  
if($myrow=mysql\_fetch\_array($describeTable))  
{  
do  
{  
$field = $myrow\["Field"\];  
$type = $myrow\["Type"\];  
$null = $myrow\["Null"\];  
$key = $myrow\["Key"\];  
$default = $myrow\["Default"\];  
$extra = $myrow\["Extra"\];  
echo "$field \\t $type \\t $null \\t $key \\t $default \\t $extra \\n";  
}  
while ($myrow=mysql\_fetch\_array($describeTable));  
}  
}  
while ($myrow=mysql\_fetch\_array($showTable));  
}  
}  
while ($myrow=mysql\_fetch\_array($showDB));  
}

\[/cce\_php\]

