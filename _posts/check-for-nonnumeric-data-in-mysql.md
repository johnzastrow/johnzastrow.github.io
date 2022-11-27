---
layout: post
title: Check for non-numeric data in mysql
description: ""
published: 2011-08-22
redirect_from: 
            - https://northredoubt.com/n/2011/08/22/check-for-non-numeric-data-in-mysql/
categories: "Data processing, Database"
hero: ../../../defaultHero.jpg
---
This will list the non-numeric data values in a mysql column.

```sql
select * from `tablename` where concat(”,`columnname` * 1) <> `columnname`

```

![](http://img.zemanta.com/pixy.gif?x-id=dda9f3a7-b810-8363-8180-8096b9010999)
