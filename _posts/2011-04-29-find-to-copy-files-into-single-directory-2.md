---
id: 77
title: 'find to copy files into single directory'
date: '2011-04-29T12:12:00-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=77'
permalink: /2011/04/29/find-to-copy-files-into-single-directory-2/
categories:
    - Linux
---

Useful little one liners. This one makes copy of subset of dir/ and below based on finding files that match the criteria. In this case, I wanted all .doc files copied into a single place.

I run most of this stuff in Windows on Cygwin, so I use the:

```bash


-print0 | xargs -0

```

part to handle the spaces in file and directory names.

```bash


find /cygdrive/f/dir1/ -name '*.doc' -print0 | xargs -0 cp -a --target-directory=/cygdrive/c/Temp --parents

```