---
layout: post
title: Finding and Filling Gaps in Timeseries Data Using MariaDB
subtitle: Utilities for fixing time series data
gh-badge: [star, fork, follow]
date: '2024-12-26T12:47:41-05:00'
tags: [weather, data, timeseries, database]
comments: true
---

# Utilities for finding and filling data gaps in timeseries data

For a few reasons I've been collecting and archiving meterological data from sites near me from here http://www.wxqa.com/  and here https://weather.gladstonefamily.net/. I display these data for myself and others here https://northredoubt.com/weather/

I fetch the records several times each data and load them into these tables, 


{: .box-terminal}
<pre>

MariaDB [weather]> show tables;
+---------------------------+
| Tables_in_weather         |
+---------------------------+
| BARDHAM                   |
| E1248                     |
| E4229                     |
| E4279                     |
| G5290                     |
| G5544                     |
| KPWM                      |
</pre>

each with identical structures as follows:
{: .box-terminal}
<pre>

MariaDB [weather]> ```desc KPWM```;
+---------------+--------------+------+-----+---------------------+-------------------------------+
| Field         | Type         | Null | Key | Default             | Extra                         |
+---------------+--------------+------+-----+---------------------+-------------------------------+
| id            | int(11)      | NO   | PRI | NULL                | auto_increment                |
| dt_utc        | datetime     | YES  | UNI | NULL                |                               |
| pressure_mbar | double       | YES  |     | NULL                |                               |
| temp_f        | double       | YES  |     | NULL                |                               |
| dewpoint_f    | double       | YES  |     | NULL                |                               |
| humid_perc    | double       | YES  |     | NULL                |                               |
| windsp_mph    | double       | YES  |     | NULL                |                               |
| windir_deg    | double       | YES  |     | NULL                |                               |
| a_press_mbar  | double       | YES  |     | NULL                |                               |
| a_temp_f      | double       | YES  |     | NULL                |                               |
| a_dewp_f      | double       | YES  |     | NULL                |                               |
| a_humid_perc  | double       | YES  |     | NULL                |                               |
| a_windsp_mph  | double       | YES  |     | NULL                |                               |
| a_windir_deg  | double       | YES  |     | NULL                |                               |
| ts            | timestamp    | NO   |     | current_timestamp() | on update current_timestamp() |
| notes         | varchar(250) | YES  |     | NULL                |                               |
+---------------+--------------+------+-----+---------------------+-------------------------------+
16 rows in set (0.001 sec)
</pre>

and

```sql


/*DDL Information*/
-------------------

CREATE TABLE `KPWM` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dt_utc` datetime DEFAULT NULL,
  `pressure_mbar` double DEFAULT NULL,
  `temp_f` double DEFAULT NULL,
  `dewpoint_f` double DEFAULT NULL,
  `humid_perc` double DEFAULT NULL,
  `windsp_mph` double DEFAULT NULL,
  `windir_deg` double DEFAULT NULL,
  `a_press_mbar` double DEFAULT NULL,
  `a_temp_f` double DEFAULT NULL,
  `a_dewp_f` double DEFAULT NULL,
  `a_humid_perc` double DEFAULT NULL,
  `a_windsp_mph` double DEFAULT NULL,
  `a_windir_deg` double DEFAULT NULL,
  `ts` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `notes` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_dt` (`dt_utc`) COMMENT 'Helps keep dupe data out'
) ENGINE=InnoDB AUTO_INCREMENT=140813 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci CHECKSUM=1 COMMENT='The table for raw data'
```



I love geospatial metadata [[https://gisgeography.com/gis-metadata/](https://https://gisgeography.com/gis-metadata/)], both human (often narrative text) and machine metadata (derived from the data themselves, but written out for humans and machines to see). As a GIS user we spend a lot of time prospecting for usable data to meet our needs. Finding data is only the middle step in eventually using the data. Next you need to determine if those data meet your needs in terms of coverage (spatial and temporal), quality and technical considerations such as how the data were collected, pre/post processed, and later maintained. Good geospatial metadata can provide all of this if it is maintained. Really good human metadata, written by thoughtful humans, can be delightful to read - at least for me.