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

For a few reasons I've been collecting and archiving meterological data from sites near me from here [[http://www.wxqa.com/](http://www.wxqa.com/ )] and here  [[https://weather.gladstonefamily.net/](https://weather.gladstonefamily.net/)]. I display these data for myself and others here [[https://northredoubt.com/weather/](https://northredoubt.com/weather)]

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
The LEAD .... OVER thing in the subquery is very cool.


```sql
CREATE VIEW `v_gaps_KPWM` AS
SELECT `t`.`dt_utc` AS `GapStart`,
       `t`.`NextDateTime` AS `GapEnd`,
       timestampdiff(SECOND, `t`.`dt_utc`, `t`.`NextDateTime`) AS `SizeInSecond`,
       -- Of course dividing time diff in seconds by 3600 translates the difference, or gap, into hours
       timestampdiff(SECOND, `t`.`dt_utc`, `t`.`NextDateTime`) / 3600 AS `SizeInHours`,
       -- Setting a fixed field to name the station to set the data up for the UNION in the next step
       'KPWM' AS `STATION`
FROM
-- I was so excited when a a helpful DBA suggested the lead... over approach on Stackexchange. Huge performance leap over my last approach
  (SELECT `KPWM`.`dt_utc` AS `dt_utc`,
          lead(`KPWM`.`dt_utc`, 1) OVER (
                                         ORDER BY `KPWM`.`dt_utc`) AS `NextDateTime`
   FROM `KPWM`
   ORDER BY `KPWM`.`dt_utc`) `t`
   -- Leave behind the small gaps due to transmission errors as I aggregate enough they don't bother me
   -- for me, small is less than 11,000 seconds.
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
->snip<-
| 2024-07-13 13:51:00 | 2024-07-14 00:51:00 |        39600 |     11.0000 | KPWM    |
| 2024-07-25 03:51:00 | 2024-07-25 09:51:00 |        21600 |      6.0000 | KPWM    |
+---------------------+---------------------+--------------+-------------+---------+
56 rows in set (0.060 sec) 83330 Records
</pre>


Then I union the results from all the stations I collect and care about.


```sql
CREATE algorithm=undefined DEFINER=`jcz`@`%` SQL SECURITY DEFINER VIEW `v_gaps_all_stations` AS
SELECT `v_gaps_e4279`.`gapstart` AS `gapstart`,
       `v_gaps_e4279`.`gapend` AS `gapend`,
       `v_gaps_e4279`.`sizeinsecond` AS `sizeinsecond`,
       `v_gaps_e4279`.`sizeinhours` AS `sizeinhours`,
       `v_gaps_e4279`.`station` AS `station`
FROM `v_gaps_e4279`
UNION
SELECT `v_gaps_e4229`.`gapstart` AS `gapstart`,
       `v_gaps_e4229`.`gapend` AS `gapend`,
       `v_gaps_e4229`.`sizeinsecond` AS `sizeinsecond`,
       `v_gaps_e4229`.`sizeinhours` AS `sizeinhours`,
       `v_gaps_e4229`.`station` AS `station`
FROM `v_gaps_e4229`
UNION
SELECT `v_gaps_g5290`.`gapstart` AS `gapstart`,
       `v_gaps_g5290`.`gapend` AS `gapend`,
       `v_gaps_g5290`.`sizeinsecond` AS `sizeinsecond`,
       `v_gaps_g5290`.`sizeinhours` AS `sizeinhours`,
       `v_gaps_g5290`.`station` AS `station`
FROM `v_gaps_g5290`
UNION
SELECT `v_gaps_g5544`.`gapstart` AS `gapstart`,
       `v_gaps_g5544`.`gapend` AS `gapend`,
       `v_gaps_g5544`.`sizeinsecond` AS `sizeinsecond`,
       `v_gaps_g5544`.`sizeinhours` AS `sizeinhours`,
       `v_gaps_g5544`.`station` AS `station`
FROM `v_gaps_g5544`
UNION
SELECT `v_gaps_kpwm`.`gapstart` AS `gapstart`,
       `v_gaps_kpwm`.`gapend` AS `gapend`,
       `v_gaps_kpwm`.`sizeinsecond` AS `sizeinsecond`,
       `v_gaps_kpwm`.`sizeinhours` AS `sizeinhours`,
       `v_gaps_kpwm`.`station` AS `station`
FROM `v_gaps_kpwm`
ORDER BY `gapstart`
```


Which makes output like this. Combining the gap data and sorting by the gap dates let me choose nearby stations that don't have gaps in the same periods.


{: .box-terminal}
<pre>
MariaDB [weather]> select * from v_gaps_all_stations;
+---------------------+---------------------+--------------+-------------+---------+
| GapStart            | GapEnd              | SizeInSecond | SizeInHours | STATION |
+---------------------+---------------------+--------------+-------------+---------+
| 2017-10-10 08:28:00 | 2017-10-11 00:14:00 |        56760 |     15.7667 | E4279   |
| 2017-10-10 08:30:00 | 2017-10-11 00:02:00 |        55920 |     15.5333 | E4229   |
| 2017-10-30 11:26:00 | 2017-11-02 00:13:00 |       218820 |     60.7833 | E4229   |
| 2017-11-11 23:51:00 | 2017-11-12 05:51:00 |        21600 |      6.0000 | KPWM    |
| 2017-12-20 18:48:00 | 2017-12-22 00:06:00 |       105480 |     29.3000 | E4229   |
| 2017-12-20 18:51:00 | 2017-12-22 00:51:00 |       108000 |     30.0000 | KPWM    |
| 2017-12-20 18:54:00 | 2017-12-22 00:13:00 |       105540 |     29.3167 | E4279   |
->snip<-
| 2018-10-16 08:46:00 | 2018-10-16 12:31:00 |        13500 |      3.7500 | E4229   |
| 2019-06-17 01:51:00 | 2019-06-24 03:51:00 |       612000 |    170.0000 | KPWM    |
| 2019-06-17 02:30:00 | 2019-06-26 00:16:00 |       769560 |    213.7667 | E4229   |
| 2019-06-17 02:30:00 | 2019-06-26 00:15:00 |       769500 |    213.7500 | E4279   |
| 2019-06-24 20:51:00 | 2019-06-25 16:28:00 |        70620 |     19.6167 | KPWM    |
| 2019-09-22 12:45:00 | 2019-09-23 00:45:00 |        43200 |     12.0000 | E4229   |
| 2019-09-22 12:45:00 | 2019-09-23 00:45:00 |        43200 |     12.0000 | E4279   |
| 2019-09-24 23:46:00 | 2019-11-25 21:45:00 |      5349540 |   1485.9833 | E4229   |
| 2019-12-01 05:45:00 | 2019-12-01 13:45:00 |        28800 |      8.0000 | E4229   |
| 2019-12-01 05:48:00 | 2019-12-01 13:46:00 |        28680 |      7.9667 | E4279   |
| 2019-12-01 05:51:00 | 2019-12-01 13:51:00 |        28800 |      8.0000 | KPWM    |
| 2020-01-17 01:51:00 | 2020-01-17 11:51:00 |        36000 |     10.0000 | KPWM    |
| 2020-01-18 04:51:00 | 2020-01-18 09:50:00 |        17940 |      4.9833 | KPWM    |
| 2020-01-19 04:51:00 | 2020-01-19 09:51:00 |        18000 |      5.0000 | KPWM    |
| 2020-02-03 06:30:00 | 2020-02-03 16:02:00 |        34320 |      9.5333 | E4279   |
->snip<-
| 2020-04-29 16:15:00 | 2020-04-29 20:31:00 |        15360 |      4.2667 | E4279   |
| 2020-11-25 14:30:00 | 2020-11-26 06:30:00 |        57600 |     16.0000 | E4229   |
| 2020-11-25 14:30:00 | 2020-11-26 06:30:00 |        57600 |     16.0000 | E4279   |
| 2020-12-05 22:45:00 | 2020-12-15 07:01:00 |       807360 |    224.2667 | E4279   |
| 2021-03-24 10:46:00 | 2021-03-24 18:01:00 |        26100 |      7.2500 | E4279   |
| 2021-03-24 10:46:00 | 2021-03-24 18:31:00 |        27900 |      7.7500 | E4229   |
->snip<-
| 2022-10-04 20:15:00 | 2022-10-05 10:15:00 |        50400 |     14.0000 | E4279   |
| 2022-12-23 16:15:00 | 2022-12-24 18:00:00 |        92700 |     25.7500 | E4279   |
| 2023-06-21 04:51:00 | 2023-06-23 00:51:00 |       158400 |     44.0000 | KPWM    |
| 2023-06-21 05:15:00 | 2023-06-23 00:15:00 |       154800 |     43.0000 | E4229   |
| 2023-06-21 05:15:00 | 2023-06-23 00:15:00 |       154800 |     43.0000 | E4279   |
| 2023-08-04 21:30:00 | 2023-08-05 00:45:00 |        11700 |      3.2500 | E4229   |
| 2024-01-04 02:51:00 | 2024-01-16 00:51:00 |      1029600 |    286.0000 | KPWM    |
| 2024-01-04 05:15:00 | 2024-01-15 15:15:00 |       986400 |    274.0000 | E4279   |
| 2024-01-04 05:15:00 | 2024-01-15 15:15:00 |       986400 |    274.0000 | E4229   |
| 2024-01-16 14:51:00 | 2024-01-17 00:00:00 |        32940 |      9.1500 | KPWM    |
| 2024-01-17 14:51:00 | 2024-01-18 00:51:00 |        36000 |     10.0000 | KPWM    |
->snip<-
| 2024-02-04 14:51:00 | 2024-02-05 00:51:00 |        36000 |     10.0000 | KPWM    |
| 2024-02-05 14:51:00 | 2024-02-06 00:51:00 |        36000 |     10.0000 | KPWM    |
| 2024-02-06 14:51:00 | 2024-02-07 00:51:00 |        36000 |     10.0000 | KPWM    |
->snip<-
| 2024-09-20 04:30:00 | 2024-11-12 18:30:00 |      4629600 |   1286.0000 | E4279   |
| 2024-09-24 04:45:00 | 2024-11-12 18:30:00 |      4283100 |   1189.7500 | G5290   |
| 2024-12-03 13:45:00 | 2024-12-04 00:45:00 |        39600 |     11.0000 | E4229   |
| 2024-12-03 15:35:00 | 2024-12-04 00:45:00 |        33000 |      9.1667 | E4279   |
| 2024-12-04 13:40:00 | 2024-12-05 00:40:00 |        39600 |     11.0000 | G5544   |
| 2024-12-04 13:45:00 | 2024-12-05 00:45:00 |        39600 |     11.0000 | E4279   |
| 2024-12-04 13:45:00 | 2024-12-05 00:45:00 |        39600 |     11.0000 | E4229   |
| 2024-12-04 13:55:00 | 2024-12-05 00:40:00 |        38700 |     10.7500 | G5290   |
+---------------------+---------------------+--------------+-------------+---------+
130 rows in set (0.383 sec)
</pre>


Here is an insert query that lets me use the gap date and TIME to fill gaps from nearby stations. I just made this query, so don't try to match it to the table above

```sql
INSERT INTO e4229 (`dt_utc`, `pressure_mbar`, `temp_f`, `dewpoint_f`, `humid_perc`, `windsp_mph`, `windir_deg`, `a_press_mbar`, `a_temp_f`, `a_dewp_f`, `a_humid_perc` , `a_windsp_mph`, `a_windir_deg`, `notes`)
SELECT `dt_utc`,
       `pressure_mbar`,
       `temp_f`,
       `dewpoint_f`,
       `humid_perc`,
       `windsp_mph`,
       `windir_deg`,
       `a_press_mbar`,
       `a_temp_f`,
       `a_dewp_f`,
       `a_humid_perc` ,
       `a_windsp_mph`,
       `a_windir_deg`,
       'From KPWM for hole 2024-09-24 04:45:01 to 2024-11-12 18:29:00' AS notes
       -- the above note gives me some lineage for data, and of course flagging if I want to exclude it
FROM kpwm
WHERE kpwm.dt_utc BETWEEN cast('2024-09-24 04:45:01' AS datetime) AND cast('2024-11-12 18:29:00' AS datetime);
```