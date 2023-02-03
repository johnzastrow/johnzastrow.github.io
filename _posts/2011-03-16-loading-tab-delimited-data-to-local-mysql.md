---
id: 132
title: 'Loading tab-delimited data to local MySQL'
date: '2011-03-16T10:17:15-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'https://johnzastrow.github.io/2011/03/16/loading-tab-delimited-data-to-local-mysql/'
permalink: /2011/03/16/loading-tab-delimited-data-to-local-mysql/
categories:
    - Uncategorized
---

I'm looking at some data from the Avian Knowledge Network and Microsoft Access just isn't up to dealing with the volume of records. So I switched over to MySQL.

I'm using the Positive Observation Essentials format as queried from their database. Here's an example of the data: ![](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2011/03/data_example.png)

I did use a sed command (created and verified in Excel) on the original files to fix the spaces in the column names (if you are in the business of making data for people, never, ever, ever, ever create large tabular files with spaces or special characters in the column names. Avoid dashes as well, and preferably use all caps). Note that the commands below will REPLACE your files. So be sure to back up your originals in case anything goes wrong.

find . -name '\*AKN\*' -exec sed -i 's/Record\\ Number/Record_Number/g' {} \\;  
find . -name '\*AKN\*' -exec sed -i 's/Global\\ Unique\\ Identifier/Global_Unique_Identifier/g' {} \\;  
find . -name '\*AKN\*' -exec sed -i 's/Collection\\ Code/Collection_Code/g' {} \\;  
find . -name '\*AKN\*' -exec sed -i 's/Scientific\\ Name/Scientific_Name/g' {} \\;  
find . -name '\*AKN\*' -exec sed -i 's/Latitude/Latitude/g' {} \\;  
find . -name '\*AKN\*' -exec sed -i 's/Longitude/Longitude/g' {} \\;  
find . -name '\*AKN\*' -exec sed -i 's/Country/Country/g' {} \\;  
find . -name '\*AKN\*' -exec sed -i 's/State\\ Province/State_Province/g' {} \\;  
find . -name '\*AKN\*' -exec sed -i 's/Observation\\ Count/Observation_Count/g' {} \\;  
find . -name '\*AKN\*' -exec sed -i 's/Obs\\ Count\\ At\\ Least/Obs_Count_At_Least/g' {} \\;  
find . -name '\*AKN\*' -exec sed -i 's/Obs\\ Count\\ At\\ Most/Obs_Count_At_Most/g' {} \\;  
find . -name '\*AKN\*' -exec sed -i 's/Observation\\ Date/Observation_Date/g' {} \\;  
find . -name '\*AKN\*' -exec sed -i 's/Duration\\ In\\ Hours/Duration_In_Hours/g' {} \\;  
find . -name '\*AKN\*' -exec sed -i 's/Time\\ Observations\\ Started/Time_Observations_Started/g' {} \\;  
find . -name '\*AKN\*' -exec sed -i 's/Time\\ Observations\\ Ended/Time_Observations_Ended/g' {} \\;  
find . -name '\*AKN\*' -exec sed -i 's/Sampling\\ Event\\ Identifier/Sampling_Event_Identifier/g' {} \\;

Then I create a basic staging table (commands also from Excel). I don't know why I used InnoDB, when MyIsam would have been faster. But, notice the absence of indexes for faster loading.

CREATE TABLE `nv_akn` (  
 `Record_Number` VARCHAR(30) DEFAULT NULL,  
 `Global_Unique_Identifier` VARCHAR(30) DEFAULT NULL,  
 `Collection_Code` VARCHAR(30) DEFAULT NULL,  
 `Scientific_Name` VARCHAR(150) DEFAULT NULL,  
 `Latitude` VARCHAR(30) DEFAULT NULL,  
 `Longitude` VARCHAR(30) DEFAULT NULL,  
 `Country` VARCHAR(50) DEFAULT NULL,  
 `State_Province` VARCHAR(50) DEFAULT NULL,  
 `Observation_Count` VARCHAR(30) DEFAULT NULL,  
 `Obs_Count_At_Least` VARCHAR(30) DEFAULT NULL,  
 `Obs_Count_At_Most` VARCHAR(30) DEFAULT NULL,  
 `Observation_Date` VARCHAR(30) DEFAULT NULL,  
 `Duration_In_Hours` VARCHAR(30) DEFAULT NULL,  
 `Time_Observations_Started` VARCHAR(30) DEFAULT NULL,  
 `Time_Observations_Ended` VARCHAR(30) DEFAULT NULL,  
 `Sampling_Event_Identifier` VARCHAR(50) DEFAULT NULL  
) ENGINE=INNODB DEFAULT CHARSET=latin1

I'm just doing this locally, so XAMPP is my friend. So from the xampp /mysql/bin directory, I ran mysql.exe. I chose my database and ran the following on the text files produced by the above sed cleaners.

mysql&gt; LOAD DATA LOCAL INFILE 'c:/xampp/mysql/bin/Nevada_Pos_obs_Essent_15-MAR-2011.txt' INTO TABLE nv_akn  
FIELDS TERMINATED BY '\\t'  
LINES TERMINATED BY '\
' IGNORE 1 LINES;

I used LOCAL since the database is on my workstation. Note the full path to the windows file, with forward slashes. Fields are tab-delimited, lines seem to just use carriage returns (or at least it doesn't look like I need another line ender) and I'm ignoring the column header row.

