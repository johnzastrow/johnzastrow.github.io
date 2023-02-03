---
id: 6
title: 'SQL: My Oracle quick reference'
date: '2008-07-05T18:52:56-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'https://johnzastrow.github.io/2008/07/05/sql-my-oracle-quick-reference-2/'
permalink: /2008/07/05/sql-my-oracle-quick-reference-2/
categories:
    - Database
---

<font face="Courier New">SET PAGESIZE 400</font>

SET LINESIZE 120

SPOOL C:\\TEMP\\FILENAME.TXT

SPOOL OFF

ED

SAVE -&gt; ALT-F4

/

SELECT \* FROM TAB

SELECT MAX(LENGTH FIELDNAME) FROM TABLE

COLUMN FIELDNAME FORMAT A25 (FOR TEXT)