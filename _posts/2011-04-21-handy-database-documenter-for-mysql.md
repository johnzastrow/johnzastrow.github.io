---
id: 143
title: 'Handy database documenter for MySQL'
date: '2011-04-21T14:39:45-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/2011/04/21/handy-database-documenter-for-mysql/'
permalink: /2011/04/21/handy-database-documenter-for-mysql/
categories:
    - Database
---

UPDATE: see the next iteration on this project [\[here\]](http://northredoubt.com/n/2011/07/18/handy-database-documenterprofiler-for-mysql-cont/ "Handy database documenter/profiler for mysql, cont.")

Here’s a view that will spit out just about everything MySQL (5.1) knows about the tables and fields it maintains for you. The first field can be joined to the output of something like

```
SELECT * FROM AZ_CA_NV_UT_species_LOCAL PROCEDURE ANALYSE(10000, 4000);
```

to see before and after “optimal” [(1)](http://www.mysqlperformanceblog.com/2009/03/23/procedure-analyse/) [(2)](http://dave-stokes.blogspot.com/2008/02/procedure-analyse.html) field types and lengths predicted by the internal <span style="text-decoration: underline;">**PROCEDURE ANALYSE.**</span>

```
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_field_table_data` AS
SELECT
CONCAT_WS('.',`tables`.`TABLE_SCHEMA`,`columns`.`TABLE_NAME`,`columns`.`COLUMN_NAME`) AS `FIELD_NAME`,
`tables`.`TABLE_COMMENT`             AS `TABLE_COMMENT`,
`columns`.`TABLE_NAME`               AS `TABLE_NAME`,
`columns`.`COLUMN_NAME`              AS `COLUMN_NAME`,
`columns`.`COLUMN_TYPE`              AS `COLUMN_TYPE`,
`columns`.`DATA_TYPE`                AS `DATA_TYPE`,
`columns`.`COLUMN_KEY`               AS `COLUMN_KEY`,
`tables`.`TABLE_SCHEMA`              AS `TABLE_SCHEMA`,
`tables`.`TABLE_TYPE`                AS `TABLE_TYPE`,
`tables`.`ENGINE`                    AS `ENGINE`,
`tables`.`VERSION`                   AS `VERSION`,
`tables`.`ROW_FORMAT`                AS `ROW_FORMAT`,
`tables`.`TABLE_ROWS`                AS `TABLE_ROWS`,
`tables`.`AVG_ROW_LENGTH`            AS `AVG_ROW_LENGTH`,
`tables`.`DATA_LENGTH`               AS `DATA_LENGTH`,
`tables`.`MAX_DATA_LENGTH`           AS `MAX_DATA_LENGTH`,
`tables`.`INDEX_LENGTH`              AS `INDEX_LENGTH`,
`tables`.`AUTO_INCREMENT`            AS `AUTO_INCREMENT`,
`tables`.`CREATE_TIME`               AS `CREATE_TIME`,
`tables`.`UPDATE_TIME`               AS `UPDATE_TIME`,
`tables`.`TABLE_COLLATION`           AS `TABLE_COLLATION`,
`tables`.`CHECKSUM`                  AS `CHECKSUM`,
`tables`.`CREATE_OPTIONS`            AS `CREATE_OPTIONS`,
`columns`.`ORDINAL_POSITION`         AS `ORDINAL_POSITION`,
`columns`.`COLUMN_DEFAULT`           AS `COLUMN_DEFAULT`,
`columns`.`IS_NULLABLE`              AS `IS_NULLABLE`,
`columns`.`CHARACTER_MAXIMUM_LENGTH` AS `CHARACTER_MAXIMUM_LENGTH`,
`columns`.`CHARACTER_OCTET_LENGTH`   AS `CHARACTER_OCTET_LENGTH`,
`columns`.`NUMERIC_PRECISION`        AS `NUMERIC_PRECISION`,
`columns`.`NUMERIC_SCALE`            AS `NUMERIC_SCALE`,
`columns`.`CHARACTER_SET_NAME`       AS `CHARACTER_SET_NAME`,
`columns`.`COLLATION_NAME`           AS `COLLATION_NAME`,
`columns`.`EXTRA`                    AS `EXTRA`,
`columns`.`PRIVILEGES`               AS `PRIVILEGES`,
`columns`.`COLUMN_COMMENT`           AS `COLUMN_COMMENT`,
NOW()                                AS `RUN_DATETIME`
FROM (`information_schema`.`tables`
JOIN `information_schema`.`columns`
ON (((`tables`.`TABLE_SCHEMA` = `columns`.`TABLE_SCHEMA`)
AND (`tables`.`TABLE_NAME` = `columns`.`TABLE_NAME`))))
```

