---
id: 26
title: 'Changing run levels at boot time'
date: '2008-07-05T20:37:34-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'https://johnzastrow.github.io/2008/07/05/changing-run-levels-at-boot-time/'
permalink: /2008/07/05/changing-run-levels-at-boot-time/
categories:
    - Linux
---

As with most stories on this site, I use my stories to store notes on  
things that I keep needing to lookup and that might help others.

This one is how to change the default startup runlevel of a debian (via  
knoppix distribution). In this case I want it to stop booting into  
graphical mode, or boot into runlevel 3.

The “/etc/inittab” file tells init which runlevel to start the system at and describes the processes to be run at each runlevel.

So, according to

\# Default runlevel. The runlevels used by RHS are:  
 # 0 – halt (Do NOT set initdefault to this)  
 # 1 – Single user mode  
 # 2 – Multiuser, without NFS (The same as 3, if you do not have networking)  
 # 3 – Full multiuser mode  
 # 4 – unused  
 # 5 – X11  
 # 6 – reboot (Do NOT set initdefault to this)

 the entry

 id:3:initdefault:

would boot into multiuser mode, without X windows starting which is what I want.