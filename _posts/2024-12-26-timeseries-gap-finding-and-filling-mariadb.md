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

MariaDB [weather]> desc KPWM;
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

Here is a view I use to find data gaps (11,000 seconds defines the "gap" in this case). It is much faster than my old method.

```sql
CREATE ALGORITHM=UNDEFINED DEFINER=`jcz`@`%` SQL SECURITY DEFINER VIEW `v_gaps_KPWM` AS
SELECT `t`.`dt_utc` AS `GapStart`,
       `t`.`NextDateTime` AS `GapEnd`,
       timestampdiff(SECOND, `t`.`dt_utc`, `t`.`NextDateTime`) AS `SizeInSecond`,
       timestampdiff(SECOND, `t`.`dt_utc`, `t`.`NextDateTime`) / 3600 AS `SizeInHours`,
       'KPWM' AS `STATION`
FROM
  (SELECT `KPWM`.`dt_utc` AS `dt_utc`,
          lead(`KPWM`.`dt_utc`, 1) OVER (
                                         ORDER BY `KPWM`.`dt_utc`) AS `NextDateTime`
   FROM `KPWM`
   ORDER BY `KPWM`.`dt_utc`) `t`
WHERE timestampdiff(SECOND, `t`.`dt_utc`, `t`.`NextDateTime`) > 11000
```

it makes output as below

{: .box-terminal}
<pre>

MariaDB [weather]> select * from v_gaps_KPWM;
+---------------------+---------------------+--------------+-------------+---------+
| GapStart            | GapEnd              | SizeInSecond | SizeInHours | STATION |
+---------------------+---------------------+--------------+-------------+---------+
| 2017-11-11 23:51:00 | 2017-11-12 05:51:00 |        21600 |      6.0000 | KPWM    |
| 2017-12-20 18:51:00 | 2017-12-22 00:51:00 |       108000 |     30.0000 | KPWM    |
| 2017-12-31 09:23:00 | 2017-12-31 23:51:00 |        52080 |     14.4667 | KPWM    |
| 2018-01-01 05:51:00 | 2018-01-01 16:51:00 |        39600 |     11.0000 | KPWM    |
| 2018-02-26 14:51:00 | 2018-02-26 22:51:00 |        28800 |      8.0000 | KPWM    |
| 2018-02-26 23:51:00 | 2018-02-28 00:51:00 |        90000 |     25.0000 | KPWM    |
| 2018-03-04 18:51:00 | 2018-03-06 00:51:00 |       108000 |     30.0000 | KPWM    |
| 2018-04-06 01:51:00 | 2018-04-08 00:51:00 |       169200 |     47.0000 | KPWM    |
| 2018-05-09 03:53:00 | 2018-05-09 07:51:00 |        14280 |      3.9667 | KPWM    |
| 2018-09-14 20:51:00 | 2018-09-15 00:51:00 |        14400 |      4.0000 | KPWM    |
| 2019-06-17 01:51:00 | 2019-06-24 03:51:00 |       612000 |    170.0000 | KPWM    |
| 2019-06-24 20:51:00 | 2019-06-25 16:28:00 |        70620 |     19.6167 | KPWM    |
| 2019-12-01 05:51:00 | 2019-12-01 13:51:00 |        28800 |      8.0000 | KPWM    |
| 2020-01-17 01:51:00 | 2020-01-17 11:51:00 |        36000 |     10.0000 | KPWM    |
| 2020-01-18 04:51:00 | 2020-01-18 09:50:00 |        17940 |      4.9833 | KPWM    |
| 2020-01-19 04:51:00 | 2020-01-19 09:51:00 |        18000 |      5.0000 | KPWM    |
| 2023-06-21 04:51:00 | 2023-06-23 00:51:00 |       158400 |     44.0000 | KPWM    |
| 2024-01-04 02:51:00 | 2024-01-16 00:51:00 |      1029600 |    286.0000 | KPWM    |
| 2024-01-16 14:51:00 | 2024-01-17 00:00:00 |        32940 |      9.1500 | KPWM    |
| 2024-01-17 14:51:00 | 2024-01-18 00:51:00 |        36000 |     10.0000 | KPWM    |
| 2024-01-18 14:51:00 | 2024-01-19 00:51:00 |        36000 |     10.0000 | KPWM    |
<snip>
| 2024-07-13 13:51:00 | 2024-07-14 00:51:00 |        39600 |     11.0000 | KPWM    |
| 2024-07-25 03:51:00 | 2024-07-25 09:51:00 |        21600 |      6.0000 | KPWM    |
+---------------------+---------------------+--------------+-------------+---------+
56 rows in set (0.060 sec)

</pre>

I love geospatial metadata [[https://gisgeography.com/gis-metadata/](https://https://gisgeography.com/gis-metadata/)], both human (often narrative text) and machine metadata (derived from the data themselves, but written out for humans and machines to see). As a GIS user we spend a lot of time prospecting for usable data to meet our needs. Finding data is only the middle step in eventually using the data. Next you need to determine if those data meet your needs in terms of coverage (spatial and temporal), quality and technical considerations such as how the data were collected, pre/post processed, and later maintained. Good geospatial metadata can provide all of this if it is maintained. Really good human metadata, written by thoughtful humans, can be delightful to read - at least for me.