---
id: 141
title: 'MySQL Functions'
date: '2011-03-31T13:48:01-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'https://johnzastrow.github.io/2011/03/31/mysql-functions/'
permalink: /2011/03/31/mysql-functions/
categories:
    - Database
    - Uncategorized
---

I just want to record these for future reference. I'm actually using the first now.

From the MySQL 5.0 Online manual

An example of how to make the first letter in a string uppercase – analogous to UCFIRST

[cce_sql]

SELECT CONCAT(UPPER(SUBSTRING(firstName, 1, 1)), LOWER(SUBSTRING(firstName FROM 2))) AS properFirstName

[/cce_sql]

a user-defined function in MySQL 5.0+ similar to PHP's substr_count(), since I could not find an equivalent native function in MySQL. (If there is one please tell me!!!)

[cce_sql]

delimiter ||  
DROP FUNCTION IF EXISTS substrCount||  
CREATE FUNCTION substrCount(s VARCHAR(255), ss VARCHAR(255)) RETURNS TINYINT(3) UNSIGNED LANGUAGE SQL NOT DETERMINISTIC READS SQL DATA  
BEGIN  
DECLARE count TINYINT(3) UNSIGNED;  
DECLARE offset TINYINT(3) UNSIGNED;  
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET s = NULL;

SET count = 0;  
SET offset = 1;

REPEAT  
IF NOT ISNULL(s) AND offset &gt; 0 THEN  
SET offset = LOCATE(ss, s, offset);  
IF offset &gt; 0 THEN  
SET count = count + 1;  
SET offset = offset + 1;  
END IF;  
END IF;  
UNTIL ISNULL(s) OR offset = 0 END REPEAT;

RETURN count;  
END;

||

delimiter ;

[/cce_sql]

Use like this:

[cce_sql]

SELECT substrCount('/this/is/a/path', '/') `count`;

[/cce_sql]

`count` would return 4 in this case. Can be used in such cases where you might want to find the "depth" of a path, or for many other uses.

It's pretty easy to create your own string functions for many examples listed here

[cce_sql]  
## Count substrings

CREATE FUNCTION substrCount(x varchar(255), delim varchar(12)) returns int  
return (length(x)-length(REPLACE(x, delim, ")))/length(delim);

SELECT substrCount('/this/is/a/path', '/') as count;

[/cce_sql]

+——-+  
| count |  
+——-+  
| 4 |  
+——-+

[cce_sql]

SELECT substrCount('/this/is/a/path', 'is') as count;

[/cce_sql]

+——-+  
| count |  
+——-+  
| 2 |  
+——-+

[cce_sql]

## Split delimited strings

CREATE FUNCTION strSplit(x varchar(255), delim varchar(12), pos int) returns varchar(255)  
return replace(substring(substring_index(x, delim, pos), length(substring_index(x, delim, pos – 1)) + 1), delim, ");

select strSplit("aaa,b,cc,d", ',', 2) as second;

[/cce_sql]

+——–+  
| second |  
+——–+  
| b |  
+——–+

[cce_sql]

select strSplit("a|bb|ccc|dd", '|', 3) as third;

[/cce_sql]

+——-+  
| third |  
+——-+  
| ccc |  
+——-+

[cce_sql]

select strSplit("aaa,b,cc,d", ',', 7) as 7th;

[/cce_sql]

+——+  
| 7th |  
+——+  
| NULL |  
+——+

[cce_sql]

## Upper case first letter, UCFIRST or INITCAP

CREATE FUNCTION ucfirst(x varchar(255)) returns varchar(255)  
return concat( upper(substring(x,1,1)),lower(substring(x,2)) );

select ucfirst("TEST");

[/cce_sql]

+—————–+  
| ucfirst("TEST") |  
+—————–+  
| Test |  
+—————–+

[cce_sql]

##Or a more complicated example, this will repeat an insert after every nth position.

drop function insert2;  
DELIMITER //  
CREATE FUNCTION insert2(str text, pos int, delimit varchar(124))  
RETURNS text  
DETERMINISTIC  
BEGIN  
DECLARE i INT DEFAULT 1;  
DECLARE str_len INT;  
DECLARE out_str text default ";  
SET str_len=length(str);  
WHILE(i&lt;str_len) DO  
SET out_str=CONCAT(out_str, SUBSTR(str, i,pos), delimit);  
SET i=i+pos;  
END WHILE;  
— trim delimiter from end of string  
SET out_str=TRIM(trailing delimit from out_str);  
RETURN(out_str);  
END//  
DELIMITER ;

select insert2("ATGCATACAGTTATTTGA", 3, " ") as seq2;

[/cce_sql]

+————————-+  
| seq2 |  
+————————-+  
| ATG CAT ACA GTT ATT TGA |  
+————————-+

—————————-

