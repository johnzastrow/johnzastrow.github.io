---
id: 22
title: 'Simple netstat'
date: '2008-07-05T20:32:20-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/2008/07/05/simple-netstat/'
permalink: /2008/07/05/simple-netstat/
categories:
    - Linux
---

```
netstat -tln | fgrep :10000 
```

on the box would tell you if the app is listening on port 10000. (And in  
particular if it is listening to port 10000 on all interfaces,  
or at least 127.0.0.1.