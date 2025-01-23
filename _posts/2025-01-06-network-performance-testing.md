---
layout: post
title: Measuring my home network performance
subtitle: To hard wire or not (wifi)
gh-badge: [star, fork, follow]
date: '2025-01-06T12:47:41-05:00'
tags: [linux, windows, networking]
comments: true
---

## Measuring my home network performance

### Background

This is mostly a log for myself of stuff I don't do every day so I don't have to Google it all the time. The first article at the bottom is where I poached most of this content from. His article pretty much says it all - including that commands and binaries differ between Linux and Windows. This video also explains more.

<iframe width="560" height="315" src="https://www.youtube.com/embed/HvDHQXuoSoQ?si=d_I7QGqlLuuxDi4w" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

{: .box-warning}
This is just a start of my network benchmarking journey, especially as I'm adding hard wiring to my office hopefully this month. I'll log my methods and results over time here.


### Rant

I don't know why such a fundamental thing as network performance measurement in this age is such a confusing, hot mess, with crappy hard tools. We're ALL doing video calls these days and Internet access is more critical than most other services. 

So please someone develop cheap/free, easy, and ideally unified tool to help isolate issues and bonus for recommending possible corrective actions in Small-Office-Home-Office types of topologies. Imagine knitting together functions from <i>iperf/ntttcp</i> for throughput (except have it be something new written in <i>Rust</i> in some kind of a unified way so the commands, outputs, behaviors match across platforms) with something like a modern <i>Smokeping</i> for latency/quality, but with hop awareness too like <i>pathping</i> , but in a unified interface with sensible defaults so that it just discovers other monitoring devices and works. Then chain the results together.

It could run from say three (3) raspberry pi's (on the LAN, some wired, some wifi) and maybe a $5 VPS at Linode/Digital Ocean. Each node would be the same, they'd talk and gather stats and be aware of where they on the topology. Then present results with some vision on variance across time (then re-run in different positions to check for variance across space). Bonus points for making recommendations, "This wifi leg from a Pi in the living room is the cause of the latency and dropped packets to the internet, not your internet connection because once it hits the router everything is with good ranges (X,Y)"

### Resources and Methods

Use the links to the *different* Github projects at the bottom if you want to try this either for Windows or Linux or both. For Windows you can just download and run the .exe. For Linux they couldn't be bothered to provide binaries and I'm not getting anything searching. But it's simple matter of downloading the source code, expanding the .zip, go into the src/ directory, then ``` make/sudo make install ```

For this testing I'll present the results from ntttcp, both Linux and Windows variants, under a few scenarios.

### The Network

Just a snap of what I'm testing

[![Topology](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/testing_topology_wifi.png)](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/testing_topology_wifi.png)

### Results

Summary table of the tests. Note the asterisks in the commands are getting markdown'd so I had to escape them.

| Test Name                                       | Source Host                                | End Host                                                                                | Command | Throughput(MB/s)  |Retransmits | Errors | Avg. CPU %  |
|----|-------------|----------|---------|------------|---------------|----------------|------------------|------------------|-----------------|-----------------|-----------------------|
| **Trial 1. Hello world using two internal hosts**  | Sending from Windows over 2.4 Ghz Wifi to   |  Linux VM wire attached to the router, each with one core, in verbose mode, for 60 secs | ntttcp.exe -s -m 1,\*,192.168.1.27 -l 128K -t 60 -ns --> ntttcp -r -m 1,\*,192.168.1.27 -t 60 -V        |  4.749  |  12   | 0 | 14.704   |
| **Trial 2. This also worked. Reversing the flow. From Linux to Windows, but need to open Windows firewall first**   |  Linux VM on wired                          |      Windows on wifi   | ntttcp -s -m 1,\*,192.168.1.39 -b 128K -N -t 60 -V --> ntttcp.exe -r -m 1,\*,192.168.1.39 -ns -t 60 -V  |   8.822      |      16            |   0   |  10.208 |
| **Trial 3a. 2.4 Ghz vs. 5 Ghz Wifi. This time on 2.4 Ghz** [Ch. 3  (2.4 GHz, 20 MHz) 2x2 WiFi 4 -59 dBm] |  Sending from the Linux VM           | Receiving on the Windows 11 Lenovo 1 Liter    |  ntttcp -s -m 2,\*,192.168.1.39 -b 128K -N -t 60 -W 2 -C 2 --> ./ntttcp.exe -r -m 2,\*,192.168.1.39 -ns -t 60 -cd 2 -wu 2       |     8.816       |      0         |          0                    |      9.633                 |
| **Trial 3b. This time on 5Ghz. Though signal strength is lower.** [Ch. 48  (5 GHz, 80 MHz) 2x2 WiFi 5 -84 dBm] |  Sending from the Linux VM           | Receiving on the Windows 11 Lenovo 1 Liter    |  ntttcp -s -m 2,\*,192.168.1.39 -b 128K -N -t 60 -W 2 -C 2 --> ./ntttcp.exe -r -m 2,\*,192.168.1.39 -ns -t 60 -cd 2 -wu 2       |      24.363       |      2         |      0                    |      9.743                 |



### This worked. Trial 1: Sending from Windows to Linux with a single core on each

#### Receiver, on Linux

``` ntttcp -r -m 1,*,192.168.1.27 -t 60 -V ```

Only one core is used to emulate iperf3 and the V (verbose) 
After downloading the ntttcp.exe binary to Windows we can run it immediately as a sender in a command prompt:

#### Sender, on Windows

``` ntttcp.exe -s -m 1,*,192.168.1.27 -l 128K -t 60 -ns ```

#### Some results

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

The parts we are most interested in are the following. Looks like 4.749 MB/s or 37.993 Mbps (?) leaving my Lenovo 1 liter with "11th Gen Intel(R) Core(TM) i5-11400T @ 1.30GHz   1.30 GHz" and wifi over "Intel(R) Wi-Fi 6 AX201 160MHz" at 2.4 Ghz oddly skipping the Unifi Wifi 6 WAP I have two floors directly below, instead connecting further away also two floors below to the Unifi Dream Machine instead.

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

### Trial 2. This also worked. Reversing the flow

 We’ll need to run CMD as administrator, open the firewall on the Windows machine to allow it to listen (receive), and the networking benchmark tool with other parameters:

``` netsh advfirewall firewall add rule program=C:\Users\username\Downloads\ntttcp.exe name="ntttcp" protocol=any dir=in action=allow enable=yes profile=ANY ```

#### Receiver, on Windows

then, for Receiver on Windows

``` ntttcp.exe -r -m 1,*,192.168.1.39 -ns -t 60 -V ```

#### Sender, on Linux

and the sender on linux, which is quite different

``` ntttcp -s -m 1,*,192.168.1.39 -b 128K -N -t 60 -V ```

#### The run as shown on the sender, here linux, and in progress. I like the log that update at the hottom with the `-V` (verbose). It shows `Real-time throughput: 26.11Mbps` which I'm not sure how useful or accurate it is, but it's cute.

{: .box-terminal}
<pre>

jcz@xub2404:~$ ntttcp -s -m 1,*,192.168.1.39 -b 128K -N -t 60 -V
NTTTCP for Linux 1.4.0

15:21:36 DBG : user limits for maximum number of open files: soft: 1024; hard: 1048576
15:21:36 INFO: Starting sender activity (no sync) ...
15:21:36 INFO: 1 threads created
15:21:36 DBG : New connection: local:41826 [socket:3] --> 192.168.1.39:5001
15:21:36 INFO: 1 connections created in 142708 microseconds
Real-time throughput: 26.11Mbps
</pre>

#### The final results as shown on the sender, here linux, just for reference. 

I think you actually report from the receiver side.

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

### Router Details

* Model: UDM
* UniFi OS Version: 4.1.13
* Processor: ARM 64-bit 4 cores, Processor - Arm Cortex-A57 Quad-Core at 1.7 GHz 
* Memory: 1.78 GB / 2.05 GB
* Internal Storage: 2.42 GB / 10.1 GB
* Temperature: 65°C
* CPU Load: 22%
* Max rated throughput (according to forums): The UDM IDS/IPS is limited to 850Mbps. Anecdotes show closer to 1000 Mbps
TX Power 
   - 2.4 GHz - 23 dBm
   -   5 GHz - 26 dBm
* Antenna - (1) Dual-Band, Quad-Polarity Antenna
* Antenna Gain
   - 2.4 GHz - 3 dBi
   -  5 GHz - 4.5 dBi 
* Wi-Fi Standards - 802.11 a/b/g/n/ac/ac-wave2
* Wireless Security - WEP, WPA-PSK, WPA-Enterprise (WPA/WPA2, TKIP/AES), 802.11w/PMF


# Resources

* [https://www.cnx-software.com/2024/04/22/testing-ntttcp-iperf3-alternative-windows-11-linux/](https://www.cnx-software.com/2024/04/22/testing-ntttcp-iperf3-alternative-windows-11-linux/)
* [https://github.com/microsoft/ntttcp](https://github.com/microsoft/ntttcp) for the Windows client
* [https://github.com/microsoft/ntttcp-for-linux](https://github.com/microsoft/ntttcp-for-linux) for the Linux client
* [https://www.pingplotter.com/](https://www.pingplotter.com/) Ping Plotter. Good Windows client for monitoring network latency health. 
* [https://oss.oetiker.ch/smokeping/](https://oss.oetiker.ch/smokeping/) Smokeping. Functional but dated and annoying for also monitoring latency. Runs on Docker though...


