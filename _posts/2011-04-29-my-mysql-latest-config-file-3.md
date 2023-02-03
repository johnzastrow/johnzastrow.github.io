---
id: 184
title: 'My MySQL latest config file'
date: '2011-04-29T12:07:38-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'https://johnzastrow.github.io/2011/04/29/my-mysql-latest-config-file-3/'
permalink: /2011/04/29/my-mysql-latest-config-file-3/
categories:
    - Database
    - Linux
---

I never record this stuff and I always wish I did. So here's a working MySQL config file that I'm using on a linux virtual machine with 2GB of memory. Notes and all so I don't keep having to look stuff up.

```bash
# MySQL config file for APPSRV VPS with 2GB of memory  
# 25-March 25-2011  
# jcz.  
# For MySQL 5.1  
# The following options will be passed to all MySQL clients  
[client]  
port = 3306  
socket = /var/lib/mysql/mysql.sock
```

```bash  
[mysqld_safe]  
log-error=/var/log/mysqld.log  
pid-file=/var/run/mysqld/mysqld.pid

# Here follows entries for some specific programs

# The MySQL server  
[mysqld]  
port = 3306  
socket = /var/lib/mysql/mysql.sock  
skip-external-locking = 1  
max_allowed_packet = 1M  
table_open_cache = 256  
socket = /var/lib/mysql/mysql.sock  
user = mysql  
# Disabling symbolic-links is recommended to prevent assorted security risks  
symbolic-links=0

# Error log file (need dash in variable name)  
log-error = /var/log/mysql/mysqld.err

# Server directories  
# leave commented out unless you know what you are doing  
# basedir = /usr/  
datadir=/var/lib/mysql  
# tmpdir = /home/poplar/mysql/tmp

# Log slow queries, time threshold set by 'long_query_time',  
slow-query-log = 1  
slow_query_log_file = /var/log/mysql/slow-queries.log  
log_output = FILE # 5.1 only  
long_query_time = 3

# Enable this to get a log of all the statements coming from a client,  
# this should be used for debugging only as it generates a lot of stuff  
# very quickly  
#log = /var/log/mysql/queries.log

# Replication Master Server (default)  
# binary logging is required for replication  
# but we're not going to replicate

# required unique id between 1 and 2^32 – 1  
# defaults to 1 if master-host is not set  
# but will not function as a master if omitted  
# server-id = 1

# Replication Slave (comment out master section to use this)  
# Not used here – deleted – jcz – 25-mar-2011

# Binary log and replication log file names prefix. We'll binary log just to have it.  
log_bin = /var/log/mysql/binary_logs/server1-appsrv-bin

# Binary log format, see:  
#   
# http://dev.mysql.com/doc/refman/5.1/en/replication-sbr-rbr.html  
binlog_format = mixed # 5.1 only  
   
# Binary log cache size  
binlog_cache_size = 1M

# Join buffer size for index-less joins  
join_buffer_size = 8M  
   
   
# Set the default character set to utf8, but we'll run with latin1 as it is default and OK  
# leave commented out unless you know what you are doing  
# default_character_set = utf8  
   
# Set the server character set, but we'll run with latin1 as it is default and OK  
# leave commented out unless you know what you are doing  
# character_set_server = utf8  
   
# Set the default collation to utf8_general_ci  
# leave commented out unless you know what you are doing  
# default_collation = utf8_general_ci

# Set the names to utf8 when a client connects  
# leave commented out unless you know what you are doing  
# init_connect = 'SET NAMES utf8; SET sql_mode = STRICT_TRANS_TABLES'

# Try number of CPU's\*2 for thread_concurrency  
thread_concurrency = 8

# The maximum amount of concurrent sessions the MySQL server will  
# allow. One of these connections will be reserved for a user with  
# SUPER privileges to allow the administrator to login even if the  
# connection limit has been reached.  
max_connections=200

# Query cache, disabled for now  
# query_cache_size = 0  
# query_cache_type = 1  
# query_cache_limit = 2M

# Query cache is used to cache SELECT results and later return them  
# without actual executing the same query once again. Having the query  
# cache enabled may result in significant speed improvements, if your  
# have a lot of identical queries and rarely changing tables. See the  
# "Qcache_lowmem_prunes" status variable to check if the current value  
# is high enough for your load.  
# Note: In case your tables change very often or if your queries are  
# textually different every time, the query cache may result in a  
# slowdown instead of a performance improvement.  
query_cache_size=0

# Maximum size for internal (in-memory) temporary tables. If a table  
# grows larger than this value, it is automatically converted to disk  
# based table This limitation is for a single table. There can be many  
# of them.  
tmp_table_size=100M

# Set the SQL mode to strict  
sql-mode="STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"

# Don't listen on a TCP/IP port at all. This can be a security enhancement,  
# if all processes that need to connect to mysqld run on the same host.  
# All interaction with mysqld must be made via Unix sockets or named pipes.  
# Note that using this option without enabling named pipes on Windows  
# (via the "enable-named-pipe" option) will render mysqld useless!  
#   
#skip-networking

#*** MyISAM Specific options

# MyISAM options, see:  
# http://dev.mysql.com/doc/refman/5.1/en/myisam-start.html  
# reasonable defaults here, real values below:  
# key_buffer_size = 256M  
# read_buffer_size = 2M  
# read_rnd_buffer_size = 8M  
# myisam_sort_buffer_size = 128M  
# bulk_insert_buffer_size = 64M  
# myisam_max_sort_file_size = 10G  
# myisam_repair_threads = 2  
##### myisam_recover_options = DEFAULT

# The maximum size of the temporary file MySQL is allowed to use while  
# recreating the index (during REPAIR, ALTER TABLE or LOAD DATA INFILE.  
# If the file-size would be bigger than this, the index will be created  
# through the key cache (which is slower).  
myisam_max_sort_file_size=100G

# If the temporary file used for fast index creation would be bigger  
# than using the key cache by the amount specified here, then prefer the  
# key cache method. This is mainly used to force long character keys in  
# large tables to use the slower key cache method to create the index.  
myisam_sort_buffer_size=172M

# Size of the Key Buffer, used to cache index blocks for MyISAM tables.  
# Do not set it larger than 30% of your available memory, as some memory  
# is also required by the OS to cache rows. Even if you're not using  
# MyISAM tables, you should still set it to 8-64M as it will also be  
# used for internal temporary disk tables.  
key_buffer_size=310M

# Size of the buffer used for doing full table scans of MyISAM tables.  
# Allocated per thread, if a full scan is needed.  
read_buffer_size=64K  
read_rnd_buffer_size=256K

# This buffer is allocated when MySQL needs to rebuild the index in  
# REPAIR, OPTIMZE, ALTER table statements as well as in LOAD DATA INFILE  
# into an empty table. It is allocated per thread so be careful with  
# large settings.  
sort_buffer_size=256K

# Uncomment SOME of the following if you are using InnoDB tables  
# leave commented out unless you know what you are doing  
#innodb_data_home_dir = /var/lib/mysql/  
# this should likely be bigger  
innodb_data_file_path = ibdata1:50M:autoextend  
#innodb_log_group_home_dir = /var/lib/mysql/  
#innodb_additional_mem_pool_size = 20M  
# Set .._log_file_size to 25 % of buffer pool size  
#innodb_log_file_size = 64M  
#innodb_log_buffer_size = 8M  
#innodb_flush_log_at_trx_commit = 1  
#innodb_lock_wait_timeout = 50

#*** INNODB Specific options ***

# Additional memory pool that is used by InnoDB to store metadata  
# information. If InnoDB requires more memory for this purpose it will  
# start to allocate it from the OS. As this is fast enough on most  
# recent operating systems, you normally do not need to change this  
# value. SHOW INNODB STATUS will display the current amount used.  
innodb_additional_mem_pool_size=25M

# If set to 1, InnoDB will flush (fsync) the transaction logs to the  
# disk at each commit, which offers full ACID behavior. If you are  
# willing to compromise this safety, and you are running small  
# transactions, you may set this to 0 or 2 to reduce disk I/O to the  
# logs. Value 0 means that the log is only written to the log file and  
# the log file flushed to disk approximately once per second. Value 2  
# means the log is written to the log file at each commit, but the log  
# file is only flushed to disk approximately once per second.  
innodb_flush_log_at_trx_commit=1

# The size of the buffer InnoDB uses for buffering log data. As soon as  
# it is full, InnoDB will have to flush it to disk. As it is flushed  
# once per second anyway, it does not make sense to have it very large  
# (even with long transactions).  
innodb_log_buffer_size=8M

# InnoDB, unlike MyISAM, uses a buffer pool to cache both indexes and  
# row data. The bigger you set this the less disk I/O is needed to  
# access data in tables. On a dedicated database server you may set this  
# parameter up to 80% of the machine physical memory size. Do not set it  
# too large, though, because competition of the physical memory may  
# cause paging in the operating system. Note that on 32bit systems you  
# might be limited to 2-3.5G of user level memory per process, so do not  
# set it too high. You can set .._buffer_pool_size up to 50 – 80 %  
# of RAM but beware of setting memory usage too high.   
innodb_buffer_pool_size=400M

# Size of each log file in a log group. You should set the combined size  
# of log files to about 25%-100% of your buffer pool size to avoid  
# unneeded buffer pool flush activity on log file overwrite. However,  
# note that a larger logfile size will increase the time needed for the  
# recovery process.  
innodb_log_file_size=120M

# Number of threads allowed inside the InnoDB kernel. The optimal value  
# depends highly on the application, hardware as well as the OS  
# scheduler properties. A too high value may lead to thread thrashing.  
innodb_thread_concurrency=10

# See http://dev.mysql.com/doc/refman/5.1/en/forcing-innodb-recovery.html   
# If there is database page corruption, it is possible that the corruption   
# might cause SELECT \* FROM tbl_name statements or InnoDB   
# background operations to crash or assert, or even cause InnoDB   
# roll-forward recovery to crash. In such cases, you can use the   
# innodb_force_recovery option to force the InnoDB storage engine to   
# start up while preventing background operations from running, so   
# that you are able to dump your tables. For example, you can add the   
# following line to the [mysqld] section of your option file   
# before restarting the server:  
#  
# innodb_force_recovery = 4

[safe_mysqld]  
# Log file  
 err_log = /var/log/mysql/safe_mysqld.err

[mysqldump]  
quick  
max_allowed_packet = 16M

[mysql]  
no-auto-rehash  
# Remove the next comment character if you are not familiar with SQL  
#safe-updates

[myisamchk]  
key_buffer_size = 128M  
sort_buffer_size = 128M  
read_buffer = 2M  
write_buffer = 2M

[mysqlhotcopy]  
interactive-timeout

# 4. Disappearing MySQL host tables  
# I've seen this happen a few times. Probably some kind of freakish MyISAM bug.  
# Easily fixed with:  
# /usr/local/bin/mysql_install_db

# Once you have corrupt InnoDB tables that are preventing your database from starting, you should follow this five step process:

# Step 1: Add this line to your /etc/my.cnf configuration file:  
# innodb_force_recovery = 4

# Step 2: Restart MySQL. Your database will now start, but with innodb_force_recovery,   
# all INSERTs and UPDATEs will be ignored.  
# Step 3: Dump all tables  
# Step 4: Shutdown database and delete the data directory. Run mysql_install_db to create MySQL default tables  
# Step 5: Remove the innodb_force_recovery line from your /etc/my.cnf file and restart the  
# database. (It should start normally now)  
# Step 6: Restore everything from your backup

# Now we can restart the database:

# /usr/local/bin/mysqld_safe &amp;

# (Note: If MySQL doesn't restart, keep increasing the innodb_force_recovery number until you get to innodb_force_recovery = 8)

# Save all data into a temporary alldb.sql (this next command can take a while to finish):

# mysqldump –force –compress –triggers –routines –create-options -uUSERNAME -pPASSWORD –all-databases &gt; /usr/alldb.sql

# Shutdown the database again:

# mysqladmin -uUSERNAME -pPASSWORD shutdown

# Delete the database directory. (Note: In my case   
# the data was under /usr/local/var. Your setup may be different.   
# Make sure you're deleting the correct directory)

# rm -fdr /usr/local/var

# Recreate the database directory and install MySQL basic tables

# mkdir /usr/local/var  
# chown -R mysql:mysql /usr/local/var  
# /usr/local/bin/mysql_install_db  
# chown -R mysql:mysql /usr/local/var

# Remove innodb_force_recovery from /etc/my.cnf and restart database:

# /usr/local/bin/mysqld_safe &amp;

# Import all the data back (this next command can take a while to finish):

# mysql -uroot –compress &lt; /usr/alldb.sql

# And finally – flush MySQL privileges (because we're also updating the MySQL table)

# /usr/local/bin/mysqladmin -uroot flush-privileges

# –

# Note: For best results, add port=8819 (or any other random number)   
# to /etc/my.cnf before restarting MySQL and then add –port=8819 to the mysqldump command.   
# This way you avoid the MySQL database getting hit with queries while the repair is in progress.

