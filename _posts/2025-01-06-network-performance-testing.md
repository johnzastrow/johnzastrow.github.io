---
layout: post
title: My attempts to measure my home networking speed
subtitle: To hard wire or not (wifi)
gh-badge: [star, fork, follow]
date: '2025-01-06T12:47:41-05:00'
tags: [linux, windows, networking]
comments: true
---

## My attempt to measure network performance at home

This is mostly a log for myself of stuff I don't do every day so I don't have to Google it all the time. The first article at the bottom where I am poaching this from pretty much says it all. This video also explains more. I don't know why such a fundamental thing as network performance measure in this age is such a confusing, hot mess, with crappy tools.

<iframe width="560" height="315" src="https://www.youtube.com/embed/HvDHQXuoSoQ?si=d_I7QGqlLuuxDi4w" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>



### This worked. Trial 1: Sending from Windows to Linux with a single core on each

#### Receiver, on Linux

``` ntttcp -r -m 1,*,192.168.1.27 -t 60 -V ```

Only one core is used to emulate iperf3 and the V (verbose) 
After downloading the ntttcp.exe binary to Windows we can run it immediately as a sender in a command prompt:

#### Sender, on Windows

``` ntttcp.exe -s -m 1,*,192.168.1.27 -l 128K -t 60 -ns ```

#### Results as shown on the sender

{: .box-terminal}
<pre>

br8kw@lenov1liter MINGW64 ~/Downloads
$ ./ntttcp.exe -s -m 1,*,192.168.1.27 -l 128K -t 60 -ns
Copyright Version 5.40
Network activity progressing...


Thread  Time(s) Throughput(KB/s) Avg B / Compl
======  ======= ================ =============
     0    0.000            0.000    131072.000


#####  Totals:  #####


   Bytes(MEG)    realtime(s) Avg Frame Size Throughput(MB/s)
================ =========== ============== ================
      285.000000      60.011       1422.133            4.749


Throughput(Buffers/s) Cycles/Byte       Buffers
===================== =========== =============
               37.993     459.217      2280.000


DPCs(count/s) Pkts(num/DPC)   Intr(count/s) Pkts(num/intr)
============= ============= =============== ==============
     6027.242         0.268       18748.908          0.086


Packets Sent Packets Received Retransmits Errors Avg. CPU %
============ ================ =========== ====== ==========
      210138            96956          12      0     14.704

</pre>


The parts we are most interested in are the following:

{: .box-terminal}
<pre>

 Throughput(MB/s)
================
           4.749


Throughput(Buffers/s) 
===================== 
               37.993 


Retransmits Errors Avg. CPU %
 =========== ====== ==========
         12      0     14.704

</pre>

This is what appeared on the receiver on linux

{: .box-terminal}
<pre>

jcz@xub2404:~/Downloads/ntttcp-for-linux-master/src$ ntttcp -r -m 1,*,192.168.1.27 -t 60 -V
NTTTCP for Linux 1.4.0
---------------------------------------------------------
*** receiver role
ports:				 1
cpu affinity:			 *
server address:			 192.168.1.27
domain:				 IPv4
protocol:			 TCP
server port starting at:	 5001
receiver socket buffer (bytes):	 65536
test warm-up (sec):		 no
test duration (sec):		 60
test cool-down (sec):		 no
show system tcp retransmit:	 no
quiet mode:			 disabled
verbose mode:			 enabled
---------------------------------------------------------
14:32:00 DBG : user limits for maximum number of open files: soft: 1024; hard: 1048576
14:32:00 DBG : Interface:[lo]	Address: 127.0.0.1
14:32:00 DBG : Interface:[ens18]	Address: 192.168.1.27
14:32:00 INFO: 2 threads created
14:32:00 DBG : ntttcp server is listening on 192.168.1.27:5000
14:32:00 DBG : ntttcp server is listening on 192.168.1.27:5001
14:32:24 DBG : New connection: 192.168.1.39:52055 --> local:5001 [socket 6]
14:33:24 DBG : socket closed: 6

</pre>


### Reversing the flow

 We’ll need to run CMD as administrator, open the firewall on the Windows machine to allow it to listen (receive), and the networking benchmark tool with other parameters:

``` netsh advfirewall firewall add rule program=C:\Users\username\Downloads\ntttcp.exe name="ntttcp" protocol=any dir=in action=allow enable=yes profile=ANY ```

#### Receiver, on Windows

then, for Receiver on Windows

``` ntttcp.exe -r -m 1,*,192.168.1.39 -ns -t 60 -V ```

#### Sender, on Linux

and the sender on linux, which is quite different

``` ntttcp -s -m 1,*,192.168.1.39 -b 128K -N -t 60 -V ```

#### The run as shown on the sender, here linux

{: .box-terminal}
<pre>

jcz@xub2404:~$ ntttcp -s -m 1,*,192.168.1.39 -b 128K -N -t 60 -V
NTTTCP for Linux 1.4.0
---------------------------------------------------------
*** sender role
*** no sender/receiver synch
connections:                     1 X 1 X 1
cpu affinity:                    *
server address:                  192.168.1.39
domain:                          IPv4
protocol:                        TCP
server port starting at:         5001
sender socket buffer (bytes):    131072
test warm-up (sec):              no
test duration (sec):             60
test cool-down (sec):            no
show system tcp retransmit:      no
quiet mode:                      disabled
verbose mode:                    enabled
---------------------------------------------------------
15:21:36 DBG : user limits for maximum number of open files: soft: 1024; hard: 1048576
15:21:36 INFO: Starting sender activity (no sync) ...
15:21:36 INFO: 1 threads created
15:21:36 DBG : New connection: local:41826 [socket:3] --> 192.168.1.39:5001
15:21:36 INFO: 1 connections created in 142708 microseconds
Real-time throughput: 26.11Mbps
</pre>

#### The results as shown on the sender, here linux

{: .box-terminal}
<pre>

jcz@xub2404:~$ ntttcp -s -m 1,*,192.168.1.39 -b 128K -N -t 60 -V
NTTTCP for Linux 1.4.0
---------------------------------------------------------
*** sender role
*** no sender/receiver synch
connections:                     1 X 1 X 1
cpu affinity:                    *
server address:                  192.168.1.39
domain:                          IPv4
protocol:                        TCP
server port starting at:         5001
sender socket buffer (bytes):    131072
test warm-up (sec):              no
test duration (sec):             60
test cool-down (sec):            no
show system tcp retransmit:      no
quiet mode:                      disabled
verbose mode:                    enabled
---------------------------------------------------------
15:21:36 DBG : user limits for maximum number of open files: soft: 1024; hard: 1048576
15:21:36 INFO: Starting sender activity (no sync) ...
15:21:36 INFO: 1 threads created
15:21:36 DBG : New connection: local:41826 [socket:3] --> 192.168.1.39:5001
15:21:36 INFO: 1 connections created in 142708 microseconds
15:22:36 INFO: Test run completed.
15:22:36 INFO: Test cycle finished.
15:22:36 INFO:  Thread  Time(s) Throughput
15:22:36 INFO:  ======  ======= ==========
15:22:36 INFO:  0        60.00   31.79Mbps
15:22:36 INFO: 1 connections tested
15:22:36 INFO: #####  Totals:  #####
15:22:36 INFO: test duration    :60.00 seconds
15:22:36 INFO: total bytes      :238419968
15:22:36 INFO:   throughput     :31.79Mbps
15:22:36 INFO:   retrans segs   :805
15:22:36 INFO: cpu cores        :4
15:22:36 INFO:   cpu speed      :4699.976MHz
15:22:36 INFO:   user           :5.13%
15:22:36 INFO:   system         :0.34%
15:22:36 INFO:   idle           :94.49%
15:22:36 INFO:   iowait         :0.02%
15:22:36 INFO:   softirq        :0.02%
15:22:36 INFO:   cycles/byte    :260.48
15:22:36 INFO: cpu busy (all)   :1.04%
15:22:36 INFO: tcpi rtt         :30470 us
---------------------------------------------------------

</pre>

# Resources

* (https://www.cnx-software.com/2024/04/22/testing-ntttcp-iperf3-alternative-windows-11-linux/)
* (https://github.com/microsoft/ntttcp) for the Windows client
* (https://github.com/microsoft/ntttcp-for-linux) for the Linux client
