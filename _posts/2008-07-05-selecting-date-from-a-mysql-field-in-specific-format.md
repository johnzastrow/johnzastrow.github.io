---
id: 16
title: 'Selecting Date from a Mysql field in specific format'
date: '2008-07-05T20:19:40-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/2008/07/05/selecting-date-from-a-mysql-field-in-specific-format/'
permalink: /2008/07/05/selecting-date-from-a-mysql-field-in-specific-format/
categories:
    - Database
---

I had a membership table with users and the datetime at which they  
joined the site. I needed to get a count of members joining per month,  
so I did this:

```
<br />
SELECT DATE_FORMAT( regdate, '%b %Y' ) <br />
AS<br />
MONTH , count( uid ) AS Users <br />
FROM gl_users <br />
GROUP BY MONTH  LIMIT 0 , 30<br />
```

Which resulted in

SQL result

 **SQL-query:** SELECT DATE\_FORMAT( regdate, ‘%b %Y’ ) AS  
MONTH , count( uid ) AS Users  
FROM gl\_users  
GROUP BY MONTH LIMIT 0, 30;

| MONTH | Users |
|---|---|
| Apr 2004 | 41 |
| Dec 2003 | 39 |
| Feb 2004 | 41 |
| Jan 2003 | 3 |
| Jan 2004 | 64 |
| Jul 2004 | 7 |
| Jun 2004 | 53 |
| Mar 2004 | 45 |
| May 2004 | 47 |
| Nov 2003 | 51 |
| Oct 2003 | 1 |

And here are some more resources that I found.

[  
http://dev.mysql.com/doc/mysql/en/Date\_and\_time\_functions.html](http://dev.mysql.com/doc/refman/5.1/en/date-and-time-functions.html)  
[  
http://www.sitepoint.com/forums/archive/index.php/t-164068](http://www.sitepoint.com/forums/archive/index.php/t-164068)

[  
http://www.databasejournal.com/features/mysql/article.php/10897\_2190421\_2](http://www.databasejournal.com/features/mysql/article.php/10897_2190421_2)