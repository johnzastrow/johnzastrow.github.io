---
id: 79
title: 'Find to copy files into single directory'
date: '2010-01-20T16:49:16-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=79'
permalink: /2010/01/20/find-to-copy-files-into-single-directory/
categories:
    - Linux
---

Makes copy of subset of dir/ and below with files that match the criteria. It keeps the nested directory structure. Uses

```
-print0 | xargs -0

to handle spaces in Windows names
```

```
find /cygdrive/f/dir1/ -name '*.doc' -print0 | xargs -0 cp -a --target-directory=/cygdrive/c/Temp --parents
```