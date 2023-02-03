---
id: 87
title: 'SYSSTAT: SAR/IOSTAT'
date: '2010-02-25T13:30:48-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'https://johnzastrow.github.io/2010/02/25/sysstat-sariostat/'
permalink: /2010/02/25/sysstat-sariostat/
categories:
    - Uncategorized
tags:
    - Linux
---

The pidstat command is used to monitor processes and threads currently being managed by the Linux kernel. It can also monitor the children of those processes and threads.

With its -d option, pidstat can report I/O statistics, providing that you have a recent Linux kernel (2.6.20+) with the option CONFIG\_TASK\_IO\_ACCOUNTING compiled in. So imagine that your system is undergoing heavy I/O and you want to know which tasks are generating them. You could then enter the following command:

```
$ pidstat -d 2
Linux 2.6.20 (localhost)    09/26/2007
```

```
10:13:31 AM       PID   kB_rd/s   kB_wr/s kB_ccwr/s  Command
10:13:31 AM     15625      1.98  16164.36      0.00  dd
```

```
10:13:33 AM       PID   kB_rd/s   kB_wr/s kB_ccwr/s  Command
10:13:33 AM     15625      4.00  20556.00      0.00  dd
```

```
10:13:35 AM       PID   kB_rd/s   kB_wr/s kB_ccwr/s  Command
10:13:35 AM     15625      0.00  10642.00      0.00  dd
```

When no PID's are explicitly selected on the command line (as in the case above), the pidstat command examines all the tasks managed by the system but displays only those whose statistics are varying during the interval of time.

The sar utility (System Activity Reporter) is a system activity reporter that is quite popular with HP/UX and Solaris, and sar is also available for AIX. Just like top, sar gives detailed information about Oracle tasks from the UNIX level. You will be able to see the overall consumption of CPU, disk, memory, and Journal File System (JFS) buffer usage. There are three major flags that you can use with sar:

- **sar –u** Shows CPU activity
- **sar –w** Shows swapping activity
- **sar –b** Shows buffer activity

NOTE: Each flavor of UNIX has a different implementation of sar. For example, some of the key flags used in the Sun version of sar are not available on HP/UX. The examples in this book show the HP/UX version of sar.

The output from sar reports usually shows a time-based snapshot of activity. This is true for all reports that you'll see in this section. When you issue the **sar** command, you pass two numeric arguments. The first represents the time interval between samples, and the second represents the number of samples to take. For example:

L 6-4

sar –u 10 5

The **sar** command in this example is requesting five samples taken at 10-second intervals.

### sar –w: The Memory Switching and Swapping Activity Report

The **sar –w** command is especially useful if you suspect that your database server  
is experiencing a memory shortage. The following example shows the swapping activity report that you get from sar:

L 6-6

&gt;sar -w 5 5

HP-UX corp-hp1 B.11.00 U 9000/800 12/25/01

07:19:33 swpin/s bswin/s swpot/s bswot/s pswch/s  
07:19:38 0.00 0.0 0.00 0.0 261  
07:19:43 0.00 0.0 0.00 0.0 231  
07:19:48 0.00 0.0 0.00 0.0 326  
07:19:53 0.00 0.0 0.00 0.0 403  
07:19:58 0.00 0.0 0.00 0.0 264

Average 0.00 0.0 0.00 0.0 297

The column descriptions are as follows:

- **swpin/s** Number of process swap-ins per second.
- **swpot/s** Number of process swap-outs per second.
- **bswin/s** Number of 512-byte swap-ins per second.
- **bswot/s** Number of 512-byte swap-outs per second.
- **pswch/s** Number of process context switches per second.

With sar you can watch realtime the network usage:

```
# sar -n DEV 1 0
Linux 2.6.22-15-generic (xXxXx)  07/09/2008
```

```
11:26:36 AM     IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s
11:26:37 AM        lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00
11:26:37 AM      eth0      5.05      0.00      0.86      0.00      0.00      0.00      0.00
```

```
11:26:37 AM     IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s
11:26:38 AM        lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00
11:26:38 AM      eth0      4.00      0.00      0.45      0.00      0.00      0.00      0.00
```

iostat  
Display a single history since boot report for all CPU and  
Devices.

iostat -d 2  
Display a continuous device report at two second intervals.

iostat -d 2 6  
Display six reports at two second intervals for all devices.

iostat -x hda hdb 2 6  
Display six reports of extended statistics at two second inter-  
vals for devices hda and hdb.

iostat -p sda 2 6  
Display six reports at two second intervals for device sda and  
all its partitions (sda1, etc.)

### Display Disk IO Statistics using sar command

```
# sar –d

Linux 2.6.9-42.ELsmp (dev-db)        01/01/2009
12:00:01 AM    DEV              tps    rd_sec/s  wr_sec/s
12:05:01 AM    dev2-0           1.65      1.28     45.43
12:10:01 AM    dev8-1          4.08      8.11     21.81

Skipped..

Average:       dev2-0           4.66    120.77     69.45
Average:       dev8-1          1.89      3.17      8.02


<h3>Display networking Statistics using sar command</h3>
# sar -n DEV | more

Linux 2.6.9-42.ELsmp (dev-db)        01/01/2009
12:00:01 AM     IFACE   rxpck/s   txpck/s   rxbyt/s   txbyt/s   rxcmp/s   txcmp/
s  rxmcst/s
12:05:01 AM        lo      0.17      0.16     25.31     23.33      0.00      0.0
0      0.00
12:10:01 AM      eth0     52.92     53.64  10169.74  12178.57      0.00      0.0
0      0.00

# sar -n SOCK |more

Linux 2.6.9-42.ELsmp (dev-db)        01/01/2009
12:00:01 AM    totsck    tcpsck    udpsck    rawsck   ip-frag
12:05:01 AM        50        13         3         0         0
12:10:01 AM        50        13         4         0         0
12:15:01 AM        53        13         5         0         0
```