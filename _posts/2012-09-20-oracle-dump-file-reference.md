---
id: 550
title: 'Oracle Dump File Reference'
date: '2012-09-20T12:03:34-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=550'
permalink: /2012/09/20/oracle-dump-file-reference/
categories:
    - Database
---

```
john.zastrow@DIVL-GY4K3R1 ~
 $ imp help=yes
```

```
Import: Release 11.2.0.1.0 - Production on Thu Sep 20 12:36:00 2012
```

```
Copyright (c) 1982, 2009, Oracle and/or its affiliates. All rights reserved.
```

```
You can let Import prompt you for parameters by entering the IMP
 command followed by your username/password:
```

```
Example: IMP SCOTT/TIGER
```

```
Or, you can control how Import runs by entering the IMP command followed
 by various arguments. To specify parameters, you use keywords:
```

```
Format: IMP KEYWORD=value or KEYWORD=(value1,value2,...,valueN)
 Example: IMP SCOTT/TIGER IGNORE=Y TABLES=(EMP,DEPT) FULL=N
 or TABLES=(T1:P1,T1:P2), if T1 is partitioned table
```

```
USERID must be the first parameter on the command line.
```

```
Keyword Description (Default) Keyword Description (Default)
 --------------------------------------------------------------------------
 USERID username/password FULL import entire file (N)
 BUFFER size of data buffer FROMUSER list of owner usernames
 FILE input files (EXPDAT.DMP) TOUSER list of usernames
 SHOW just list file contents (N) TABLES list of table names
 IGNORE ignore create errors (N) RECORDLENGTH length of IO record
 GRANTS import grants (Y) INCTYPE incremental import type
 INDEXES import indexes (Y) COMMIT commit array insert (N)
 ROWS import data rows (Y) PARFILE parameter filename
 LOG log file of screen output CONSTRAINTS import constraints (Y)
 DESTROY overwrite tablespace data file (N)
 INDEXFILE write table/index info to specified file
 SKIP_UNUSABLE_INDEXES skip maintenance of unusable indexes (N)
 FEEDBACK display progress every x rows(0)
 TOID_NOVALIDATE skip validation of specified type ids
 FILESIZE maximum size of each dump file
 STATISTICS import precomputed statistics (always)
 RESUMABLE suspend when a space related error is encountered(N)
 RESUMABLE_NAME text string used to identify resumable statement
 RESUMABLE_TIMEOUT wait time for RESUMABLE
 COMPILE compile procedures, packages, and functions (Y)
 STREAMS_CONFIGURATION import streams general metadata (Y)
 STREAMS_INSTANTIATION import streams instantiation metadata (N)
 DATA_ONLY import only data (N)
```

```
The following keywords only apply to transportable tablespaces
 TRANSPORT_TABLESPACE import transportable tablespace metadata (N)
 TABLESPACES tablespaces to be transported into database
 DATAFILES datafiles to be transported into database
 TTS_OWNERS users that own data in the transportable tablespace set
```

So

```
imp scott/tiger file=emp.dmp fromuser=scott touser=scott tables=dept
```

Imports the file emp.dmp via user scott (password = tiger) and sticks it in scott's schema.

See

[http://www.orafaq.com/wiki/Import_Export_FAQ](http://www.orafaq.com/wiki/Import_Export_FAQ)

for more info