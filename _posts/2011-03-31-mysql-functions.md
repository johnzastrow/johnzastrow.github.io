---
id: 141
title: 'MySQL Functions'
date: '2011-03-31T13:48:01-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/2011/03/31/mysql-functions/'
permalink: /2011/03/31/mysql-functions/
categories:
    - Database
    - Uncategorized
---

I just want to record these for future reference. I’m actually using the first now.

From the MySQL 5.0 Online manual

An example of how to make the first letter in a string uppercase – analogous to UCFIRST

\[cce\_sql\]

SELECT CONCAT(UPPER(SUBSTRING(firstName, 1, 1)), LOWER(SUBSTRING(firstName FROM 2))) AS properFirstName

\[/cce\_sql\]

a user-defined function in MySQL 5.0+ similar to PHP’s substr\_count(), since I could not find an equivalent native function in MySQL. (If there is one please tell me!!!)

\[cce\_sql\]

delimiter ||  
DROP FUNCTION IF EXISTS substrCount||  
CREATE FUNCTION substrCount(s VARCHAR(255), ss VARCHAR(255)) RETURNS TINYINT(3) UNSIGNED LANGUAGE SQL NOT DETERMINISTIC READS SQL DATA  
BEGIN  
DECLARE count TINYINT(3) UNSIGNED;  
DECLARE offset TINYINT(3) UNSIGNED;  
DECLARE CONTINUE HANDLER FOR SQLSTATE ‘02000’ SET s = NULL;

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

\[/cce\_sql\]

Use like this:

\[cce\_sql\]

SELECT substrCount(‘/this/is/a/path’, ‘/’) `count`;

\[/cce\_sql\]

`count` would return 4 in this case. Can be used in such cases where you might want to find the “depth” of a path, or for many other uses.

It’s pretty easy to create your own string functions for many examples listed here

\[cce\_sql\]  
\## Count substrings

CREATE FUNCTION substrCount(x varchar(255), delim varchar(12)) returns int  
return (length(x)-length(REPLACE(x, delim, ”)))/length(delim);

SELECT substrCount(‘/this/is/a/path’, ‘/’) as count;

\[/cce\_sql\]

+——-+  
| count |  
+——-+  
| 4 |  
+——-+

\[cce\_sql\]

SELECT substrCount(‘/this/is/a/path’, ‘is’) as count;

\[/cce\_sql\]

+——-+  
| count |  
+——-+  
| 2 |  
+——-+

\[cce\_sql\]

\## Split delimited strings

CREATE FUNCTION strSplit(x varchar(255), delim varchar(12), pos int) returns varchar(255)  
return replace(substring(substring\_index(x, delim, pos), length(substring\_index(x, delim, pos – 1)) + 1), delim, ”);

select strSplit(“aaa,b,cc,d”, ‘,’, 2) as second;

\[/cce\_sql\]

+——–+  
| second |  
+——–+  
| b |  
+——–+

\[cce\_sql\]

select strSplit(“a|bb|ccc|dd”, ‘|’, 3) as third;

\[/cce\_sql\]

+——-+  
| third |  
+——-+  
| ccc |  
+——-+

\[cce\_sql\]

select strSplit(“aaa,b,cc,d”, ‘,’, 7) as 7th;

\[/cce\_sql\]

+——+  
| 7th |  
+——+  
| NULL |  
+——+

\[cce\_sql\]

\## Upper case first letter, UCFIRST or INITCAP

CREATE FUNCTION ucfirst(x varchar(255)) returns varchar(255)  
return concat( upper(substring(x,1,1)),lower(substring(x,2)) );

select ucfirst(“TEST”);

\[/cce\_sql\]

+—————–+  
| ucfirst(“TEST”) |  
+—————–+  
| Test |  
+—————–+

\[cce\_sql\]

\##Or a more complicated example, this will repeat an insert after every nth position.

drop function insert2;  
DELIMITER //  
CREATE FUNCTION insert2(str text, pos int, delimit varchar(124))  
RETURNS text  
DETERMINISTIC  
BEGIN  
DECLARE i INT DEFAULT 1;  
DECLARE str\_len INT;  
DECLARE out\_str text default ”;  
SET str\_len=length(str);  
WHILE(i&lt;str\_len) DO  
SET out\_str=CONCAT(out\_str, SUBSTR(str, i,pos), delimit);  
SET i=i+pos;  
END WHILE;  
— trim delimiter from end of string  
SET out\_str=TRIM(trailing delimit from out\_str);  
RETURN(out\_str);  
END//  
DELIMITER ;

select insert2(“ATGCATACAGTTATTTGA”, 3, ” “) as seq2;

\[/cce\_sql\]

+————————-+  
| seq2 |  
+————————-+  
| ATG CAT ACA GTT ATT TGA |  
+————————-+

—————————-

