---
id: 238
title: 'Remove all foreign keys from MySQL database'
date: '2011-10-27T14:23:29-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/2011/10/27/remove-all-foreign-keys-from-mysql-database/'
permalink: /2011/10/27/remove-all-foreign-keys-from-mysql-database/
categories:
    - 'Data processing'
    - Database
---

I needed to load some lookup data into a MySQL database littered with foreign keys. So I copied the empty DB and ran the output of the following:  
 \[cc lang=’sql’ \]  
SELECT CONCAT(‘alter table ‘,table\_schema,’.’,table\_name,’ DROP FOREIGN KEY ‘,constraint\_name,’;’)  
FROM information\_schema.table\_constraints  
WHERE constraint\_type=’FOREIGN KEY’ AND table\_schema = ‘MY\_DATABASE\_NAME\_HERE’; \[/cc\]

I loaded the values, and dumped just the values (only insert statements) that I will use to populate the version of the DB with my FK’s intact.

