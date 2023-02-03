---
id: 783
title: 'Postgres database from itis.gov'
date: '2014-01-29T15:22:30-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=783'
permalink: /2014/01/29/postgres-database-from-itis-gov/
categories:
    - 'Data processing'
    - Database
    - Uncategorized
---

This might save you some head aches. The postgresql database dump of the taxonomic universe (according to the USGS) from <http://www.itis.gov/> is provided in a latin1 character encoding (specifically it tries to create a database as ENCODING = 'LATIN1' LC_COLLATE = 'en_US.ISO8859-1' LC_CTYPE = 'en_US.ISO8859-1' ). In order to bring this dump into a modern Postgres instance you'll likely have to deal with the encoding being different in the dump versus your system. Rather than changing the locale of your entire database (which is likely UTF-8). It's easier to change the encoding of the SQL file they give you.

Using this excellent reference:  
<http://stackoverflow.com/questions/64860/best-way-to-convert-text-files-between-character-sets>

I went right for iconv and this worked for me on my ubuntu 12.04 (after installing recode which might have brought in some additional encodings that weren't there before).

```
<pre class="lang:sh decode:true crayon-selected">iconv -f latin1 -t UTF-8 ITIS.sql > ITIS-utf8.sql
```

Then you have to edit the SQL dump file to remove references that enforce the encoding so that the database will just use its defaults when you load it.