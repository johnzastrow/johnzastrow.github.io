---
id: 132
title: 'Loading tab-delimited data to local MySQL'
date: '2011-03-16T10:17:15-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/2011/03/16/loading-tab-delimited-data-to-local-mysql/'
permalink: /2011/03/16/loading-tab-delimited-data-to-local-mysql/
categories:
    - Uncategorized
---

I’m looking at some data from the Avian Knowledge Network and Microsoft Access just isn’t up to dealing with the volume of records. So I switched over to MySQL.

I’m using the Positive Observation Essentials format as queried from their database. Here’s an example of the data: ![](http://northredoubt.com/n/wp-content/uploads/2011/03/data_example.png)

I did use a sed command (created and verified in Excel) on the original files to fix the spaces in the column names (if you are in the business of making data for people, never, ever, ever, ever create large tabular files with spaces or special characters in the column names. Avoid dashes as well, and preferably use all caps). Note that the commands below will REPLACE your files. So be sure to back up your originals in case anything goes wrong.

find . -name ‘\*AKN\*’ -exec sed -i ‘s/Record\\ Number/Record\_Number/g’ {} \\;  
find . -name ‘\*AKN\*’ -exec sed -i ‘s/Global\\ Unique\\ Identifier/Global\_Unique\_Identifier/g’ {} \\;  
find . -name ‘\*AKN\*’ -exec sed -i ‘s/Collection\\ Code/Collection\_Code/g’ {} \\;  
find . -name ‘\*AKN\*’ -exec sed -i ‘s/Scientific\\ Name/Scientific\_Name/g’ {} \\;  
find . -name ‘\*AKN\*’ -exec sed -i ‘s/Latitude/Latitude/g’ {} \\;  
find . -name ‘\*AKN\*’ -exec sed -i ‘s/Longitude/Longitude/g’ {} \\;  
find . -name ‘\*AKN\*’ -exec sed -i ‘s/Country/Country/g’ {} \\;  
find . -name ‘\*AKN\*’ -exec sed -i ‘s/State\\ Province/State\_Province/g’ {} \\;  
find . -name ‘\*AKN\*’ -exec sed -i ‘s/Observation\\ Count/Observation\_Count/g’ {} \\;  
find . -name ‘\*AKN\*’ -exec sed -i ‘s/Obs\\ Count\\ At\\ Least/Obs\_Count\_At\_Least/g’ {} \\;  
find . -name ‘\*AKN\*’ -exec sed -i ‘s/Obs\\ Count\\ At\\ Most/Obs\_Count\_At\_Most/g’ {} \\;  
find . -name ‘\*AKN\*’ -exec sed -i ‘s/Observation\\ Date/Observation\_Date/g’ {} \\;  
find . -name ‘\*AKN\*’ -exec sed -i ‘s/Duration\\ In\\ Hours/Duration\_In\_Hours/g’ {} \\;  
find . -name ‘\*AKN\*’ -exec sed -i ‘s/Time\\ Observations\\ Started/Time\_Observations\_Started/g’ {} \\;  
find . -name ‘\*AKN\*’ -exec sed -i ‘s/Time\\ Observations\\ Ended/Time\_Observations\_Ended/g’ {} \\;  
find . -name ‘\*AKN\*’ -exec sed -i ‘s/Sampling\\ Event\\ Identifier/Sampling\_Event\_Identifier/g’ {} \\;

Then I create a basic staging table (commands also from Excel). I don’t know why I used InnoDB, when MyIsam would have been faster. But, notice the absence of indexes for faster loading.

CREATE TABLE `nv\_akn` (  
 `Record\_Number` VARCHAR(30) DEFAULT NULL,  
 `Global\_Unique\_Identifier` VARCHAR(30) DEFAULT NULL,  
 `Collection\_Code` VARCHAR(30) DEFAULT NULL,  
 `Scientific\_Name` VARCHAR(150) DEFAULT NULL,  
 `Latitude` VARCHAR(30) DEFAULT NULL,  
 `Longitude` VARCHAR(30) DEFAULT NULL,  
 `Country` VARCHAR(50) DEFAULT NULL,  
 `State\_Province` VARCHAR(50) DEFAULT NULL,  
 `Observation\_Count` VARCHAR(30) DEFAULT NULL,  
 `Obs\_Count\_At\_Least` VARCHAR(30) DEFAULT NULL,  
 `Obs\_Count\_At\_Most` VARCHAR(30) DEFAULT NULL,  
 `Observation\_Date` VARCHAR(30) DEFAULT NULL,  
 `Duration\_In\_Hours` VARCHAR(30) DEFAULT NULL,  
 `Time\_Observations\_Started` VARCHAR(30) DEFAULT NULL,  
 `Time\_Observations\_Ended` VARCHAR(30) DEFAULT NULL,  
 `Sampling\_Event\_Identifier` VARCHAR(50) DEFAULT NULL  
) ENGINE=INNODB DEFAULT CHARSET=latin1

I’m just doing this locally, so XAMPP is my friend. So from the xampp /mysql/bin directory, I ran mysql.exe. I chose my database and ran the following on the text files produced by the above sed cleaners.

mysql&gt; LOAD DATA LOCAL INFILE ‘c:/xampp/mysql/bin/Nevada\_Pos\_obs\_Essent\_15-MAR-2011.txt’ INTO TABLE nv\_akn  
FIELDS TERMINATED BY ‘\\t’  
LINES TERMINATED BY ‘\\n’ IGNORE 1 LINES;

I used LOCAL since the database is on my workstation. Note the full path to the windows file, with forward slashes. Fields are tab-delimited, lines seem to just use carriage returns (or at least it doesn’t look like I need another line ender) and I’m ignoring the column header row.

<div class="zemanta-pixie">![](http://img.zemanta.com/pixy.gif?x-id=f9368272-1492-847d-9091-49726d62d833)</div>