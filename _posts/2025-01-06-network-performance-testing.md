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

### The Wireless Network

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


#### This worked. Trial 1: Sending from Windows to Linux with a single core on each

##### Receiver, on Linux

``` ntttcp -r -m 1,*,192.168.1.27 -t 60 -V ```

Only one core is used to emulate iperf3 and the V (verbose) 
After downloading the ntttcp.exe binary to Windows we can run it immediately as a sender in a command prompt:

##### Sender, on Windows

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

 We'll need to run CMD as administrator, open the firewall on the Windows machine to allow it to listen (receive), and the networking benchmark tool with other parameters:

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

### Wired testing

##### Floorplan 
[![Floorplan](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/floorplan.png)](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/floorplan.png)

##### Latency from router to remote PC over the wire

[![WiredLatency](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/l1l_wired_latency.png)](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/l1l_wired_latency.png)


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

### Two Linux VMs talking to each other 

Just for comparison, let's do a test that maxes out throughput. I'm going to up the core count on each end to `-m 4` to make sure were making enough bits to stress the virtual network.

CPU usage on the 4-core receiving VM hit 65% at peak, and was ingesting 7.82 Gbps of traffic. The sending VM is on the same Proxmox host, so this was likely all occuring over the internal bridge on the machine.. a virtual network. 
The receiving VM reported `16:06:22 INFO: throughpu: 61.92Gbps`

<pre>

jcz@xub2404:~$ ntttcp -r -m 4,*,192.168.1.27 -b 128K -N -t 300 -W 2 -C 2
NTTTCP for Linux 1.4.0
---------------------------------------------------------
16:01:08 INFO: 4 threads created
16:01:20 INFO: Test warmup completed.
16:06:20 INFO: Test run completed.
16:06:20 INFO: Test cooldown is in progress...
16:06:22 INFO: Test cycle finished.
16:06:22 INFO: #####  Totals:  #####
16:06:22 INFO: test duration    :300.28 seconds
16:06:22 INFO: total bytes      :2324240849720
**16:06:22 INFO:   throughput     :61.92Gbps**
16:06:22 INFO:   retrans segs   :2
16:06:22 INFO: cpu cores        :4
16:06:22 INFO:   cpu speed      :4699.976MHz
16:06:22 INFO:   user           :0.58%
16:06:22 INFO:   system         :10.38%
16:06:22 INFO:   idle           :80.37%
16:06:22 INFO:   iowait         :0.07%
16:06:22 INFO:   softirq        :8.57%
16:06:22 INFO:   cycles/byte    :0.48
16:06:22 INFO: cpu busy (all)   :87.98%
---------------------------------------------------------

jcz@gisdb:~$ ntttcp -s -m 4,*,192.168.1.27 -b 128K -N -t 300 -W 2 -C 2
NTTTCP for Linux 1.4.0
---------------------------------------------------------
21:01:18 INFO: Starting sender activity (no sync) ...
21:01:18 INFO: 4 threads created
21:01:18 INFO: 4 connections created in 620 microseconds
21:01:20 INFO: Test warmup completed.
21:06:20 INFO: Test run completed.
21:06:20 INFO: Test cooldown is in progress...
21:06:22 INFO: Test cycle finished.
21:06:22 INFO: 4 connections tested
21:06:22 INFO: #####  Totals:  #####
21:06:22 INFO: test duration    :300.06 seconds
21:06:22 INFO: total bytes      :2322617860096
21:06:22 INFO:   throughput     :61.92Gbps
21:06:22 INFO:   retrans segs   :25
21:06:22 INFO: cpu cores        :4
21:06:22 INFO:   cpu speed      :4699.976MHz
21:06:22 INFO:   user           :0.20%
21:06:22 INFO:   system         :11.56%
21:06:22 INFO:   idle           :87.73%
21:06:22 INFO:   iowait         :0.02%
21:06:22 INFO:   softirq        :0.47%
21:06:22 INFO:   cycles/byte    :0.30
21:06:22 INFO: cpu busy (all)   :46.88%
---------------------------------------------------------

</pre>

With 6 cores. It seems that the throughput actually went down. Maybe resource starvation since everything is happening on the same host? Except that CPU utilization 
on the host never went above 40% in any test, and memory stayed very low. This isn't hitting the NIC, so that's not a bottleneck here. Of course. there are LOT of bits being recorded, so this is just academic.

<pre>

jcz@xub2404:~$ ntttcp -r -m 6,*,192.168.1.27 -b 128K -N -t 300 -W 2 -C 2
NTTTCP for Linux 1.4.0
---------------------------------------------------------
16:16:33 INFO: 6 threads created
16:16:42 INFO: Test warmup completed.
16:21:43 INFO: Test run completed.
16:21:43 INFO: Test cooldown is in progress...
16:21:44 INFO: Test cycle finished.
16:21:44 INFO: #####  Totals:  #####
16:21:44 INFO: test duration    :300.27 seconds
16:21:44 INFO: total bytes      :2031269376776
16:21:44 INFO:   throughput     :54.12Gbps
16:21:44 INFO:   retrans segs   :1
16:21:44 INFO: cpu cores        :4
16:21:44 INFO:   cpu speed      :4699.976MHz
16:21:44 INFO:   user           :0.57%
16:21:44 INFO:   system         :9.69%
16:21:44 INFO:   idle           :84.36%
16:21:44 INFO:   iowait         :0.06%
16:21:44 INFO:   softirq        :5.29%
16:21:44 INFO:   cycles/byte    :0.43
16:21:44 INFO: cpu busy (all)   :69.33%
---------------------------------------------------------

jcz@gisdb:~$ ntttcp -s -m 6,*,192.168.1.27 -b 128K -N -t 300 -W 2 -C 2
NTTTCP for Linux 1.4.0
---------------------------------------------------------
21:16:40 INFO: Starting sender activity (no sync) ...
21:16:40 INFO: 6 threads created
21:16:40 INFO: 6 connections created in 748 microseconds
21:16:42 INFO: Test warmup completed.
21:21:42 INFO: Test run completed.
21:21:42 INFO: Test cooldown is in progress...
21:21:44 INFO: Test cycle finished.
21:21:44 INFO: 6 connections tested
21:21:44 INFO: #####  Totals:  #####
21:21:44 INFO: test duration    :300.09 seconds
21:21:44 INFO: total bytes      :2030016004096
21:21:44 INFO:   throughput     :54.12Gbps
21:21:44 INFO:   retrans segs   :0
21:21:44 INFO: cpu cores        :4
21:21:44 INFO:   cpu speed      :4699.976MHz
21:21:44 INFO:   user           :0.20%
21:21:44 INFO:   system         :11.91%
21:21:44 INFO:   idle           :87.44%
21:21:44 INFO:   iowait         :0.02%
21:21:44 INFO:   softirq        :0.40%
21:21:44 INFO:   cycles/byte    :0.35
21:21:44 INFO: cpu busy (all)   :48.25%
---------------------------------------------------------


</pre>

And with 2 cores.

CPU usage on the 2-core receiving VM hit 77% at peak, and was ingesting 8.63 Gbps of traffic.  
The receiving VM reported `16:28:42 INFO: throughput :68.91Gbps`. So fewer cores made more traffic?

<pre>

jcz@xub2404:~$ ntttcp -r -m 2,*,192.168.1.27 -b 128K -N -t 300 -W 2 -C 2
NTTTCP for Linux 1.4.0
---------------------------------------------------------
16:23:28 INFO: 2 threads created
16:23:40 INFO: Test warmup completed.
16:28:40 INFO: Test run completed.
16:28:40 INFO: Test cooldown is in progress...
16:28:42 INFO: Test cycle finished.
16:28:42 INFO: #####  Totals:  #####
16:28:42 INFO: test duration    :300.44 seconds
16:28:42 INFO: total bytes      :2587987722000
16:28:42 INFO:   throughput     :68.91Gbps
16:28:42 INFO:   retrans segs   :2
16:28:42 INFO: cpu cores        :4
16:28:42 INFO:   cpu speed      :4699.976MHz
16:28:42 INFO:   user           :0.57%
16:28:42 INFO:   system         :10.77%
16:28:42 INFO:   idle           :82.09%
16:28:42 INFO:   iowait         :0.01%
16:28:42 INFO:   softirq        :6.53%
16:28:42 INFO:   cycles/byte    :0.39
16:28:42 INFO: cpu busy (all)   :77.79%
---------------------------------------------------------


jcz@gisdb:~$ ntttcp -s -m 2,*,192.168.1.27 -b 128K -N -t 300 -W 2 -C 2
NTTTCP for Linux 1.4.0
---------------------------------------------------------
21:23:38 INFO: Starting sender activity (no sync) ...
21:23:38 INFO: 2 threads created
21:23:38 INFO: 2 connections created in 602 microseconds
21:23:40 INFO: Test warmup completed.
21:28:40 INFO: Test run completed.
21:28:40 INFO: Test cooldown is in progress...
21:28:42 INFO: Test cycle finished.
21:28:42 INFO: 2 connections tested
21:28:42 INFO: #####  Totals:  #####
21:28:42 INFO: test duration    :300.25 seconds
21:28:42 INFO: total bytes      :2586434732032
21:28:42 INFO:   throughput     :68.91Gbps
21:28:42 INFO:   retrans segs   :13
21:28:42 INFO: cpu cores        :4
21:28:42 INFO:   cpu speed      :4699.976MHz
21:28:42 INFO:   user           :0.18%
21:28:42 INFO:   system         :11.60%
21:28:42 INFO:   idle           :87.83%
21:28:42 INFO:   iowait         :0.02%
21:28:42 INFO:   softirq        :0.35%
21:28:42 INFO:   cycles/byte    :0.27
21:28:42 INFO: cpu busy (all)   :46.00%
---------------------------------------------------------

</pre>

##### Stressing out the Proxmox Host: Receiving VM
[![4,6,2 Core Testing](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/receiver_usage.png)](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/receiver_usage.png)