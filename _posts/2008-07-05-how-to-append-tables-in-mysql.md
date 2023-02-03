---
id: 7
title: 'How to append tables in Mysql'
date: '2008-07-05T18:58:01-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'https://johnzastrow.github.io/2008/07/05/how-to-append-tables-in-mysql/'
permalink: /2008/07/05/how-to-append-tables-in-mysql/
categories:
    - Database
---

For those of you that have puzzled over how to append tables in Mysql like an Access ‘Append’ query, start here:

```
insert into table1 select * from table2;<br />
```

Where table1 and table2 are identical. This might fail if you use an auto-incrementing counter on both.