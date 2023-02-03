---
id: 238
title: 'Remove all foreign keys from MySQL database'
date: '2011-10-27T14:23:29-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'https://johnzastrow.github.io/2011/10/27/remove-all-foreign-keys-from-mysql-database/'
permalink: /2011/10/27/remove-all-foreign-keys-from-mysql-database/
categories:
    - 'Data processing'
    - Database
---

I needed to load some lookup data into a MySQL database littered with foreign keys. So I copied the empty DB and ran the output of the following:  
```sql  
SELECT CONCAT('alter table ',table_schema,'.',table_name,' DROP FOREIGN KEY ',constraint_name,';')  
FROM information_schema.table_constraints  
WHERE constraint_type='FOREIGN KEY' AND table_schema = 'MY_DATABASE_NAME_HERE'; \
```

I loaded the values, and dumped just the values (only insert statements) that I will use to populate the version of the DB with my FK's intact.

