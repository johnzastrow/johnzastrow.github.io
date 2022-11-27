---
id: 13
title: 'Linux.com: Bugs in your shell script?'
date: '2008-07-05T20:09:45-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/2008/07/05/linuxcom-bugs-in-your-shell-script/'
permalink: /2008/07/05/linuxcom-bugs-in-your-shell-script/
categories:
    - Linux
---

By: Larry Reckner   
Topics: Shell   
Subsection: Intermediate   
If your writing a shell script and want to watch exactly what is going on (very usefull for debugging purposes), add the line

```
set -vx
```

 in the beginning of the script.

The shell script will then output what it’s doing so you can watch.

This can also be done via command line by doing

```
</p>
<p>sh -x filename
```