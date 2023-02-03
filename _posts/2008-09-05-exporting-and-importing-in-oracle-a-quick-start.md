---
id: 58
title: 'Exporting and Importing in Oracle: A Quick Start'
date: '2008-09-05T14:35:00-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=58'
permalink: /2008/09/05/exporting-and-importing-in-oracle-a-quick-start/
categories:
    - Database
---

I do this about twice per year and every time I have to look back at my notes to remember how. Maybe you are in the same boat. So, to save us both some trouble I'm going to blog my notes on the subject here.

**exp schemaname/password@instance FILE=d:\\mydump.dmp [follow instructions]**  
Give the file a name after FILE, most of the rest of the defaults are fine in the interactive prompting that exp will provide

For example, given a user called *mike*, his schema will be called *mike* in Oracle. The instance value is the same as is listed in the tnsnames.ora file in your Oracle client installation.

If you are using the free Oracle version called Oracle XE, the instance name will be *XE*  
so given the example above,

**exp mike/password@XE FILE=d:\\mydump.dmp**

Now to import

 **imp differentschemaname/password@instance fromuser=schemaname touser=differentschemaname FILE=d:\\mydump.dmp**

This example imports the dump file into a schema with a different name than what we exported from.

So here is an import example with an export from a schema called mike to a schema called tim

**imp time/password@XE fromuser=mike touser=tim FILE=d:\\mydump.dmp**

To see the command line options for exp, enter exp help=y as below  
 **exp help=y**

You can let Export prompt you for parameters by entering the EXP  
command followed by your username/password:

Example: EXP SCOTT/TIGER

Or, you can control how Export runs by entering the EXP command followed  
by various arguments. To specify parameters, you use keywords:

Format: EXP KEYWORD=value or KEYWORD=(value1,value2,…,valueN)  
Example: EXP SCOTT/TIGER GRANTS=Y TABLES=(EMP,DEPT,MGR)  
or TABLES=(T1:P1,T1:P2), if T1 is partitioned table

USERID must be the first parameter on the command line.

Keyword Description (Default) Keyword Description (Default)  
————————————————————————–  
USERID username/password FULL export entire file (N)  
BUFFER size of data buffer OWNER list of owner usernames  
FILE output files (EXPDAT.DMP) TABLES list of table names  
COMPRESS import into one extent (Y) RECORDLENGTH length of IO record  
GRANTS export grants (Y) INCTYPE incremental export type  
INDEXES export indexes (Y) RECORD track incr. export (Y)  
DIRECT direct path (N) TRIGGERS export triggers (Y)  
LOG log file of screen output STATISTICS analyze objects (ESTIMATE)  
ROWS export data rows (Y) PARFILE parameter filename  
CONSISTENT cross-table consistency(N) CONSTRAINTS export constraints (Y)

OBJECT_CONSISTENT transaction set to read only during object export (N)  
FEEDBACK display progress every x rows (0)  
FILESIZE maximum size of each dump file  
FLASHBACK_SCN SCN used to set session snapshot back to  
FLASHBACK_TIME time used to get the SCN closest to the specified time  
QUERY select clause used to export a subset of a table  
RESUMABLE suspend when a space related error is encountered(N)  
RESUMABLE_NAME text string used to identify resumable statement  
RESUMABLE_TIMEOUT wait time for RESUMABLE  
TTS_FULL_CHECK perform full or partial dependency check for TTS  
TABLESPACES list of tablespaces to export  
TRANSPORT_TABLESPACE export transportable tablespace metadata (N)  
TEMPLATE template name which invokes iAS mode export

Export terminated successfully without warnings.

To see the command line options for imp, enter imp help=y as below

$ imp help=y

Example: IMP SCOTT/TIGER

Or, you can control how Import runs by entering the IMP command followed  
by various arguments. To specify parameters, you use keywords:

Format: IMP KEYWORD=value or KEYWORD=(value1,value2,…,valueN)  
Example: IMP SCOTT/TIGER IGNORE=Y TABLES=(EMP,DEPT) FULL=N  
or TABLES=(T1:P1,T1:P2), if T1 is partitioned table

USERID must be the first parameter on the command line.

Keyword Description (Default) Keyword Description (Default)  
————————————————————————–  
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

The following keywords only apply to transportable tablespaces  
TRANSPORT_TABLESPACE import transportable tablespace metadata (N)  
TABLESPACES tablespaces to be transported into database  
DATAFILES datafiles to be transported into database  
TTS_OWNERS users that own data in the transportable tablespace set