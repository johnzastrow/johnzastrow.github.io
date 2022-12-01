---
id: 224
title: 'Check for non-numeric data in mysql'
date: '2011-08-22T11:49:09-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/2011/08/22/check-for-non-numeric-data-in-mysql/'
permalink: /2011/08/22/check-for-non-numeric-data-in-mysql/
categories:
    - 'Data processing'
    - Database
---

This will list the non-numeric data values in a mysql column.

```sql select \* from `tablename` where concat(”,`columnname` \* 1) &lt;&gt; `columnname`\```

