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

``` sed -e '/^[^+-]/d' ```



### Rant

I don't know why such a fundamental thing as network performance measurement in this age is such a confusing, hot mess, with crappy hard tools. We're ALL doing video calls these days and Internet access is more critical than most other services. 

So please someone develop cheap/free, easy, and ideally unified tool to help isolate issues and bonus for recommending possible corrective actions in Small-Office-Home-Office types of topologies. Imagine knitting together functions from <i>iperf/ntttcp</i> for throughput (except have it be something new written in <i>Rust</i> in some kind of a unified way so the commands, outputs, behaviors match across platforms) with something like a modern <i>Smokeping</i> for latency/quality, but with hop awareness too like <i>pathping</i> , but in a unified interface with sensible defaults so that it just discovers other monitoring devices and works. Then chain the results together.

It could run from say three (3) raspberry pi's (on the LAN, some wired, some wifi) and maybe a $5 VPS at Linode/Digital Ocean. Each node would be the same, they'd talk and gather stats and be aware of where they on the topology. Then present results with some vision on variance across time (then re-run in different positions to check for variance across space). Bonus points for making recommendations, "This wifi leg from a Pi in the living room is the cause of the latency and dropped packets to the internet, not your internet connection because once it hits the router everything is with good ranges (X,Y)"

### Resources

Use the links to the *different* Github projects at the bottom if you want to try this either for Windows or Linux or both. For Windows you can just download and run the .exe. For Linux they couldn't be bothered to provide binaries and I'm not getting anything searching. But it's simple matter of downloading the source code, expanding the .zip, go into the src/ directory, then ``` make/sudo make install ```


### Results

I'm putting the summary here in this table for those that like to read the end of the book first.

| Test Name                                       | Source Host                                | End Host                                                                                | Command | Throughput(MB/s)  |Retransmits | Errors | Avg. CPU %  |
|----|-------------|----------|---------|------------|---------------|----------------|------------------|------------------|-----------------|-----------------|-----------------------|
| Trial 1. Hello world using two internal hosts  | Sending from Windows over 2.4 Ghz Wifi to   |  Linux VM wire attached to the router, each with one core, in verbose mode, for 60 secs | ntttcp.exe -s -m 1,*,192.168.1.27 -l 128K -t 60 -ns --> ntttcp -r -m 1,*,192.168.1.27 -t 60 -V        |  4.749  |  12   | 0 | 14.704   |
| Trial 2. This also worked. Reversing the flow. From Linux to Windows, but need to open Windows firewall first   |  Linux VM on wired                          |      Windows on wifi   | ntttcp -s -m 1,*,192.168.1.39 -b 128K -N -t 60 -V --> ntttcp.exe -r -m 1,*,192.168.1.39 -ns -t 60 -V  |         |                  |      |   |
| Trial 3a. 2.4 Ghz vs. 5 Ghz Wifi. This time on 2.4 Ghz [Ch. 3  (2.4 GHz, 20 MHz) 2x2 WiFi 4 -59 dBm] |  Sending from the Linux VM           | Receiving on the Windows 11 Lenovo 1 Liter    |  ntttcp -s -m 2,*,192.168.1.39 -b 128K -N -t 60 -W 2 -C 2 --> ./ntttcp.exe -r -m 2,*,192.168.1.39 -ns -t 60 -cd 2 -wu 2       |     8.816       |      0         |          0                    |      9.633                 |
| Trial 3b. This time on 5Ghz. Though signal strength is lower. [Ch. 48  (5 GHz, 80 MHz) 2x2 WiFi 5 -84 dBm] |  Sending from the Linux VM           | Receiving on the Windows 11 Lenovo 1 Liter    |  ntttcp -s -m 2,*,192.168.1.39 -b 128K -N -t 60 -W 2 -C 2 --> ./ntttcp.exe -r -m 2,*,192.168.1.39 -ns -t 60 -cd 2 -wu 2       |      24.363       |      2         |      0                    |      9.743                 |



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

The results above don't show MB/s here, so we'll go with 31.79 Mbps, which is being sent by a 4 CPU (not using that many) linux VM on a 1 year old, otherwise idling AMD workstation running Proxmox hardwired to the Unifi Dream Machine that the 1 liter is wifing to.



{: .box-terminal}
<pre>

br8kw@lenov1liter MINGW64 ~/Downloads
$ ./ntttcp.exe -r -m 1,*,192.168.1.39 -ns -t 60 -V
Copyright Version 5.40
buffers_length: 65536
num_buffers_to_send: 9223372036854775807
send_socket_buff: -1
recv_socket_buff: -1
port: 5001
sync_port: 0
no_sync: 1
wait_timeout_milliseconds: 600000
async_flag: 0
verbose_flag: 1
wsa_flag: 0
use_ipv6_flag: 0
send_flag: 0
udp_flag: 0
udp_unconnected_flag: 0
verify_data_flag: 0
wait_all_flag: 0
run_time: 60000
warmup_time: 0
cooldown_time: 0
dash_n_timeout: 10800000
bind_sender_flag: 0
sender_name:
max_active_threads: 1
no_delay: 0
node_affinity: -1
udp_uso_size: 0
udp_receive_coalescing: 0
tp_flag: 0
use_hvsocket_flag: 0
no_stdio_buffer: 0
throughput_Bpms: 0
cpu_burn: 0
latency_measurement: 0
use_io_compl_ports: 0
cpu_from_idle_flag: 0
get_estats: 0
qos_flag: 0
packet_period: 0
jitter_measurement: 0
mapping[0]: 1
1/6/2025 15:21:19 proc_speed: 1296 MHz
1/6/2025 15:21:19 SetupThreads
1/6/2025 15:21:19 Threads: 1    Processor: -1   Host: 192.168.1.39
1/6/2025 15:21:19 created thread 0 port 5001
1/6/2025 15:21:19 StartSenderReceiver start thread 0 port 5001
1/6/2025 15:21:19 SetupNet port 5001
1/6/2025 15:21:19 bound to port 5001
1/6/2025 15:21:19 listening on port 5001
1/6/2025 15:21:40 accepted connection on port 5001
1/6/2025 15:21:40 SetupNet complete on port 5001
1/6/2025 15:21:40 All threads ready!
1/6/2025 15:21:40 Network activity progressing...
1/6/2025 15:21:40 test start
1/6/2025 15:21:40 start recording results for sample 0
1/6/2025 15:22:40 stop recording results for sample 0
1/6/2025 15:22:40 test finish
1/6/2025 15:22:40 StartSenderReceiver done thread 0 port 5001
1/6/2025 15:22:40 PrintOutput


Thread  Time(s) Throughput(KB/s) Avg B / Compl
======  ======= ================ =============
     0    0.000            0.000     38631.154


#####  Totals:  #####


   Bytes(MEG)    realtime(s) Avg Frame Size Throughput(MB/s)
================ =========== ============== ================
      225.507065      60.017       1442.286            3.757


Throughput(Buffers/s) Cycles/Byte       Buffers
===================== =========== =============
               60.118     476.831      3608.113


DPCs(count/s) Pkts(num/DPC)   Intr(count/s) Pkts(num/intr)
============= ============= =============== ==============
     7218.051         0.378       21676.515          0.126


Packets Sent Packets Received Retransmits Errors Avg. CPU %
============ ================ =========== ====== ==========
       13928           163949           0     90     12.080

</pre>

The results from the receiver (Windows) above show 3.757 MB/s and 60.118 Mbps (I think), but 90 errors which is interesting. CPU in 

{: .box-terminal}
<pre>

### Trial 3. Fluctuations

#################### TEST RUN 1 ######################################

br8kw@lenov1liter MINGW64 ~/Downloads
$ ./ntttcp.exe -r -m 1,*,192.168.1.39 -ns -t 60 -V


1/6/2025 19:1:42 proc_speed: 1296 MHz
1/6/2025 19:1:42 Threads: 1     Processor: -1   Host: 192.168.1.39


#####  Totals:  #####


   Bytes(MEG)    realtime(s) Avg Frame Size Throughput(MB/s)
================ =========== ============== ================
      583.981575      60.003       1443.910            9.733

Throughput(Buffers/s) Cycles/Byte       Buffers
===================== =========== =============
              155.721     206.882      9343.705

Packets Sent Packets Received Retransmits Errors Avg. CPU %
============ ================ =========== ====== ==========
       29957           424091          13      0     13.576
	   
	   



jcz@xub2404:~$ ntttcp -s -m 1,*,192.168.1.39 -b 128K -N -t 60 -V
NTTTCP for Linux 1.4.0
---------------------------------------------------------

connections:                     1 X 1 X 1
cpu affinity:                    *
server address:                  192.168.1.39
domain:                          IPv4

19:01:45 INFO: 1 threads created
19:01:45 DBG : New connection: local:47124 [socket:3] --> 192.168.1.39:5001
19:01:45 INFO: 1 connections created in 2281 microseconds
19:02:45 INFO: Test run completed.
19:02:45 INFO: Test cycle finished.
19:02:45 INFO:  Thread  Time(s) Throughput
19:02:45 INFO:  ======  ======= ==========
19:02:45 INFO:  0        60.00   82.14Mbps
19:02:45 INFO: 1 connections tested
19:02:45 INFO: #####  Totals:  #####
19:02:45 INFO: test duration    :60.00 seconds
19:02:45 INFO: total bytes      :616038400
19:02:45 INFO:   throughput     :82.14Mbps
19:02:45 INFO:   retrans segs   :8
19:02:45 INFO: cpu cores        :4
19:02:45 INFO:   cpu speed      :4699.976MHz
19:02:45 INFO:   user           :4.52%
19:02:45 INFO:   system         :0.34%
19:02:45 INFO:   idle           :95.11%
19:02:45 INFO:   iowait         :0.01%
19:02:45 INFO:   softirq        :0.02%
19:02:45 INFO:   cycles/byte    :89.51
19:02:45 INFO: cpu busy (all)   :1.10%



#################### TEST RUN 2 ######################################

br8kw@lenov1liter MINGW64 ~/Downloads
$ ./ntttcp.exe -r -m 1,*,192.168.1.39 -ns -t 60 -V
Copyright Version 5.40
buffers_length: 65536
num_buffers_to_send: 9223372036854775807
send_socket_buff: -1
recv_socket_buff: -1
port: 5001
sync_port: 0
no_sync: 1
wait_timeout_milliseconds: 600000
async_flag: 0
verbose_flag: 1
wsa_flag: 0
use_ipv6_flag: 0
send_flag: 0
udp_flag: 0
udp_unconnected_flag: 0
verify_data_flag: 0
wait_all_flag: 0
run_time: 60000
warmup_time: 0
cooldown_time: 0
dash_n_timeout: 10800000
bind_sender_flag: 0
sender_name:
max_active_threads: 1
no_delay: 0
node_affinity: -1
udp_uso_size: 0
udp_receive_coalescing: 0
tp_flag: 0
use_hvsocket_flag: 0
no_stdio_buffer: 0
throughput_Bpms: 0
cpu_burn: 0
latency_measurement: 0
use_io_compl_ports: 0
cpu_from_idle_flag: 0
get_estats: 0
qos_flag: 0
packet_period: 0
jitter_measurement: 0
mapping[0]: 1
1/6/2025 19:4:17 proc_speed: 1296 MHz
1/6/2025 19:4:17 SetupThreads
1/6/2025 19:4:17 Threads: 1     Processor: -1   Host: 192.168.1.39
1/6/2025 19:4:17 created thread 0 port 5001
1/6/2025 19:4:17 StartSenderReceiver start thread 0 port 5001
1/6/2025 19:4:17 SetupNet port 5001
1/6/2025 19:4:17 bound to port 5001
1/6/2025 19:4:17 listening on port 5001
1/6/2025 19:5:31 accepted connection on port 5001
1/6/2025 19:5:31 SetupNet complete on port 5001
1/6/2025 19:5:31 All threads ready!
1/6/2025 19:5:31 Network activity progressing...
1/6/2025 19:5:31 test start
1/6/2025 19:5:31 start recording results for sample 0
1/6/2025 19:6:31 stop recording results for sample 0
1/6/2025 19:6:31 test finish
1/6/2025 19:6:31 StartSenderReceiver done thread 0 port 5001
1/6/2025 19:6:31 PrintOutput


Thread  Time(s) Throughput(KB/s) Avg B / Compl
======  ======= ================ =============
     0    0.000            0.000     38960.945


#####  Totals:  #####


   Bytes(MEG)    realtime(s) Avg Frame Size Throughput(MB/s)
================ =========== ============== ================
      529.436600      60.016       1445.854            8.822


Throughput(Buffers/s) Cycles/Byte       Buffers
===================== =========== =============
              141.146     171.621      8470.986


DPCs(count/s) Pkts(num/DPC)   Intr(count/s) Pkts(num/intr)
============= ============= =============== ==============
     5027.281         1.273       15637.448          0.409


Packets Sent Packets Received Retransmits Errors Avg. CPU %
============ ================ =========== ====== ==========
       28375           383963          16      0     10.208
	   
	   
	   
	   
	   
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
19:05:31 DBG : user limits for maximum number of open files: soft: 1024; hard: 1048576
19:05:31 INFO: Starting sender activity (no sync) ...
19:05:31 INFO: 1 threads created
19:05:31 DBG : New connection: local:47630 [socket:3] --> 192.168.1.39:5001
19:05:31 INFO: 1 connections created in 2269 microseconds
19:06:31 INFO: Test run completed.
19:06:31 INFO: Test cycle finished.
19:06:31 INFO:  Thread  Time(s) Throughput
19:06:31 INFO:  ======  ======= ==========
19:06:31 INFO:  0        60.00   74.31Mbps
19:06:31 INFO: 1 connections tested
19:06:31 INFO: #####  Totals:  #####
19:06:31 INFO: test duration    :60.00 seconds
19:06:31 INFO: total bytes      :557318144
19:06:31 INFO:   throughput     :74.31Mbps
19:06:31 INFO:   retrans segs   :19
19:06:31 INFO: cpu cores        :4
19:06:31 INFO:   cpu speed      :4699.976MHz
19:06:31 INFO:   user           :4.76%
19:06:31 INFO:   system         :0.30%
19:06:31 INFO:   idle           :94.91%
19:06:31 INFO:   iowait         :0.01%
19:06:31 INFO:   softirq        :0.01%
19:06:31 INFO:   cycles/byte    :102.95
19:06:31 INFO: cpu busy (all)   :1.15%
19:06:31 INFO: tcpi rtt         :60561 us
---------------------------------------------------------


#################### TEST RUN 3 ######################################

br8kw@lenov1liter MINGW64 ~/Downloads
$ ./ntttcp.exe -r -m 1,*,192.168.1.39 -ns -t 60 -V
Copyright Version 5.40
buffers_length: 65536
num_buffers_to_send: 9223372036854775807
send_socket_buff: -1
recv_socket_buff: -1
port: 5001
sync_port: 0
no_sync: 1
wait_timeout_milliseconds: 600000
async_flag: 0
verbose_flag: 1
wsa_flag: 0
use_ipv6_flag: 0
send_flag: 0
udp_flag: 0
udp_unconnected_flag: 0
verify_data_flag: 0
wait_all_flag: 0
run_time: 60000
warmup_time: 0
cooldown_time: 0
dash_n_timeout: 10800000
bind_sender_flag: 0
sender_name:
max_active_threads: 1
no_delay: 0
node_affinity: -1
udp_uso_size: 0
udp_receive_coalescing: 0
tp_flag: 0
use_hvsocket_flag: 0
no_stdio_buffer: 0
throughput_Bpms: 0
cpu_burn: 0
latency_measurement: 0
use_io_compl_ports: 0
cpu_from_idle_flag: 0
get_estats: 0
qos_flag: 0
packet_period: 0
jitter_measurement: 0
mapping[0]: 1
1/6/2025 19:13:48 proc_speed: 1296 MHz
1/6/2025 19:13:48 SetupThreads
1/6/2025 19:13:48 Threads: 1    Processor: -1   Host: 192.168.1.39
1/6/2025 19:13:48 created thread 0 port 5001
1/6/2025 19:13:48 StartSenderReceiver start thread 0 port 5001
1/6/2025 19:13:48 SetupNet port 5001
1/6/2025 19:13:48 bound to port 5001
1/6/2025 19:13:48 listening on port 5001
1/6/2025 19:13:52 accepted connection on port 5001
1/6/2025 19:13:52 SetupNet complete on port 5001
1/6/2025 19:13:52 All threads ready!
1/6/2025 19:13:52 Network activity progressing...
1/6/2025 19:13:52 test start
1/6/2025 19:13:52 start recording results for sample 0
1/6/2025 19:14:52 stop recording results for sample 0
1/6/2025 19:14:52 test finish
1/6/2025 19:14:52 StartSenderReceiver done thread 0 port 5001
1/6/2025 19:14:52 PrintOutput


Thread  Time(s) Throughput(KB/s) Avg B / Compl
======  ======= ================ =============
     0    0.000            0.000     39615.316


#####  Totals:  #####


   Bytes(MEG)    realtime(s) Avg Frame Size Throughput(MB/s)
================ =========== ============== ================
      562.734734      60.014       1439.431            9.377


Throughput(Buffers/s) Cycles/Byte       Buffers
===================== =========== =============
              150.028     151.171      9003.756


DPCs(count/s) Pkts(num/DPC)   Intr(count/s) Pkts(num/intr)
============= ============= =============== ==============
     4635.950         1.473       14920.416          0.458


Packets Sent Packets Received Retransmits Errors Avg. CPU %
============ ================ =========== ====== ==========
       29969           409933          13      0      9.557
	   


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
19:13:52 DBG : user limits for maximum number of open files: soft: 1024; hard: 1048576
19:13:52 INFO: Starting sender activity (no sync) ...
19:13:52 INFO: 1 threads created
19:13:52 DBG : New connection: local:58336 [socket:3] --> 192.168.1.39:5001
19:13:52 INFO: 1 connections created in 1701 microseconds
19:14:52 INFO: Test run completed.
19:14:52 INFO: Test cycle finished.
19:14:52 INFO:  Thread  Time(s) Throughput
19:14:52 INFO:  ======  ======= ==========
19:14:52 INFO:  0        60.00   79.03Mbps
19:14:52 INFO: 1 connections tested
19:14:52 INFO: #####  Totals:  #####
19:14:52 INFO: test duration    :60.00 seconds
19:14:52 INFO: total bytes      :592707584
19:14:52 INFO:   throughput     :79.03Mbps
19:14:52 INFO:   retrans segs   :13
19:14:52 INFO: cpu cores        :4
19:14:52 INFO:   cpu speed      :4699.976MHz
19:14:52 INFO:   user           :4.56%
19:14:52 INFO:   system         :0.32%
19:14:52 INFO:   idle           :95.08%
19:14:52 INFO:   iowait         :0.02%
19:14:52 INFO:   softirq        :0.02%
19:14:52 INFO:   cycles/byte    :93.59
19:14:52 INFO: cpu busy (all)   :1.12%
19:14:52 INFO: tcpi rtt         :28863 us
---------------------------------------------------------

</pre>

{: .box-terminal}
<pre>

########## TEST RUN 4 With 2 Second Warm Up and 2 Second Cool Down ##############

br8kw@lenov1liter MINGW64 ~/Downloads
$ ./ntttcp.exe -r -m 1,*,192.168.1.39 -ns -t 60 -V -cd 2 -wu 2
Copyright Version 5.40
buffers_length: 65536
num_buffers_to_send: 9223372036854775807
send_socket_buff: -1
recv_socket_buff: -1
port: 5001
sync_port: 0
no_sync: 1
wait_timeout_milliseconds: 600000
async_flag: 0
verbose_flag: 1
wsa_flag: 0
use_ipv6_flag: 0
send_flag: 0
udp_flag: 0
udp_unconnected_flag: 0
verify_data_flag: 0
wait_all_flag: 0
run_time: 60000
warmup_time: 2000
cooldown_time: 2000
dash_n_timeout: 10800000
bind_sender_flag: 0
sender_name:
max_active_threads: 1
no_delay: 0
node_affinity: -1
udp_uso_size: 0
udp_receive_coalescing: 0
tp_flag: 0
use_hvsocket_flag: 0
no_stdio_buffer: 0
throughput_Bpms: 0
cpu_burn: 0
latency_measurement: 0
use_io_compl_ports: 0
cpu_from_idle_flag: 0
get_estats: 0
qos_flag: 0
packet_period: 0
jitter_measurement: 0
mapping[0]: 1
1/6/2025 19:18:15 proc_speed: 1296 MHz
1/6/2025 19:18:15 SetupThreads
1/6/2025 19:18:15 Threads: 1    Processor: -1   Host: 192.168.1.39
1/6/2025 19:18:15 created thread 0 port 5001
1/6/2025 19:18:15 StartSenderReceiver start thread 0 port 5001
1/6/2025 19:18:15 SetupNet port 5001
1/6/2025 19:18:15 bound to port 5001
1/6/2025 19:18:15 listening on port 5001
1/6/2025 19:18:20 accepted connection on port 5001
1/6/2025 19:18:20 SetupNet complete on port 5001
1/6/2025 19:18:20 All threads ready!
1/6/2025 19:18:20 Network activity progressing...
1/6/2025 19:18:20 test start
1/6/2025 19:18:20 test warmup
1/6/2025 19:18:22 start recording results for sample 0
1/6/2025 19:19:22 stop recording results for sample 0
1/6/2025 19:19:22 test cooldown
1/6/2025 19:19:24 test finish
1/6/2025 19:19:24 StartSenderReceiver done thread 0 port 5001
1/6/2025 19:19:24 PrintOutput


Thread  Time(s) Throughput(KB/s) Avg B / Compl
======  ======= ================ =============
     0    0.000            0.000     38074.583


#####  Totals:  #####


   Bytes(MEG)    realtime(s) Avg Frame Size Throughput(MB/s)
================ =========== ============== ================
      503.121780      60.007       1444.962            8.384


Throughput(Buffers/s) Cycles/Byte       Buffers
===================== =========== =============
              134.151     183.668      8049.948


DPCs(count/s) Pkts(num/DPC)   Intr(count/s) Pkts(num/intr)
============= ============= =============== ==============
     5295.055         1.149       16266.074          0.374


Packets Sent Packets Received Retransmits Errors Avg. CPU %
============ ================ =========== ====== ==========
       27463           365104          15      0     10.383
	   
	   


jcz@xub2404:~$ ntttcp -s -m 1,*,192.168.1.39 -b 128K -N -t 60 -V -W 2 -C 2
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
test warm-up (sec):              2
test duration (sec):             60
test cool-down (sec):            2
show system tcp retransmit:      no
quiet mode:                      disabled
verbose mode:                    enabled
---------------------------------------------------------
19:18:20 DBG : user limits for maximum number of open files: soft: 1024; hard: 1048576
19:18:20 INFO: Starting sender activity (no sync) ...
19:18:20 INFO: 1 threads created
19:18:20 DBG : New connection: local:58278 [socket:3] --> 192.168.1.39:5001
19:18:20 INFO: 1 connections created in 3378 microseconds
19:18:22 INFO: Test warmup completed.
19:19:22 INFO: Test run completed.
19:19:22 INFO: Test cooldown is in progress...
19:19:24 INFO: Test cycle finished.
19:19:24 INFO:  Thread  Time(s) Throughput
19:19:24 INFO:  ======  ======= ==========
19:19:24 INFO:  0        60.09   70.21Mbps
19:19:24 INFO: 1 connections tested
19:19:24 INFO: #####  Totals:  #####
19:19:24 INFO: test duration    :60.09 seconds
19:19:24 INFO: total bytes      :527302656
19:19:24 INFO:   throughput     :70.21Mbps
19:19:24 INFO:   retrans segs   :236
19:19:24 INFO: cpu cores        :4
19:19:24 INFO:   cpu speed      :4699.976MHz
19:19:24 INFO:   user           :5.12%
19:19:24 INFO:   system         :0.37%
19:19:24 INFO:   idle           :94.41%
19:19:24 INFO:   iowait         :0.08%
19:19:24 INFO:   softirq        :0.02%
19:19:24 INFO:   cycles/byte    :119.78
19:19:24 INFO: cpu busy (all)   :1.09%
19:19:24 INFO: tcpi rtt         :51796 us
---------------------------------------------------------

</pre>

{: .box-terminal}
<pre>

# TEST RUN 4 With 2 Second Warm Up and 2 Second Cool Down w/ Latency measurement #

br8kw@lenov1liter MINGW64 ~/Downloads
$ ./ntttcp.exe -r -m 1,*,192.168.1.39 -ns -t 60 -V -cd 2 -wu 2 -lm
Copyright Version 5.40
buffers_length: 65536
num_buffers_to_send: 9223372036854775807
send_socket_buff: -1
recv_socket_buff: -1
port: 5001
sync_port: 0
no_sync: 1
wait_timeout_milliseconds: 600000
async_flag: 0
verbose_flag: 1
wsa_flag: 0
use_ipv6_flag: 0
send_flag: 0
udp_flag: 0
udp_unconnected_flag: 0
verify_data_flag: 0
wait_all_flag: 0
run_time: 60000
warmup_time: 2000
cooldown_time: 2000
dash_n_timeout: 10800000
bind_sender_flag: 0
sender_name:
max_active_threads: 1
no_delay: 0
node_affinity: -1
udp_uso_size: 0
udp_receive_coalescing: 0
tp_flag: 0
use_hvsocket_flag: 0
no_stdio_buffer: 0
throughput_Bpms: 0
cpu_burn: 0
latency_measurement: 1
use_io_compl_ports: 0
cpu_from_idle_flag: 0
get_estats: 0
qos_flag: 0
packet_period: 0
jitter_measurement: 0
mapping[0]: 1
1/6/2025 19:24:14 proc_speed: 1296 MHz
1/6/2025 19:24:14 SetupThreads
1/6/2025 19:24:14 Threads: 1    Processor: -1   Host: 192.168.1.39
1/6/2025 19:24:14 created thread 0 port 5001
1/6/2025 19:24:14 StartSenderReceiver start thread 0 port 5001
1/6/2025 19:24:14 SetupNet port 5001
1/6/2025 19:24:14 bound to port 5001
1/6/2025 19:24:14 listening on port 5001
1/6/2025 19:24:19 accepted connection on port 5001
1/6/2025 19:24:19 SetupNet complete on port 5001
1/6/2025 19:24:19 All threads ready!
1/6/2025 19:24:19 Network activity progressing...
1/6/2025 19:24:19 test start
1/6/2025 19:24:19 test warmup
1/6/2025 19:24:21 start recording results for sample 0
1/6/2025 19:25:21 stop recording results for sample 0
1/6/2025 19:25:21 test cooldown
1/6/2025 19:25:23 test finish
1/6/2025 19:25:23 StartSenderReceiver done thread 0 port 5001
1/6/2025 19:25:23 PrintOutput

                                               Latency(ns)
Thread  Time(s) Throughput(KB/s) Avg B / Compl        Avg        Min        Max
======  ======= ================ ============= ========== ========== ==========
     0    0.000            0.000     39931.789    3962586       4000   82592400


#####  Totals:  #####


   Bytes(MEG)    realtime(s) Avg Frame Size Throughput(MB/s)
================ =========== ============== ================
      576.636459      60.011       1445.463            9.609

Latency(ns)
       Avg        Min        Max
========== ========== ==========
   3962586       4000   82592400


Throughput(Buffers/s) Cycles/Byte       Buffers
===================== =========== =============
              153.742     152.784      9226.183


DPCs(count/s) Pkts(num/DPC)   Intr(count/s) Pkts(num/intr)
============= ============= =============== ==============
     5192.997         1.342       15820.648          0.441


Packets Sent Packets Received Retransmits Errors Avg. CPU %
============ ================ =========== ====== ==========
       30154           418307           7      0      9.898
	   


jcz@xub2404:~$ ntttcp -s -m 1,*,192.168.1.39 -b 128K -N -t 60 -V -W 2 -C 2
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
test warm-up (sec):              2
test duration (sec):             60
test cool-down (sec):            2
show system tcp retransmit:      no
quiet mode:                      disabled
verbose mode:                    enabled
---------------------------------------------------------
19:24:19 DBG : user limits for maximum number of open files: soft: 1024; hard: 1048576
19:24:19 INFO: Starting sender activity (no sync) ...
19:24:19 INFO: 1 threads created
19:24:19 DBG : New connection: local:34614 [socket:3] --> 192.168.1.39:5001
19:24:19 INFO: 1 connections created in 2817 microseconds
19:24:21 INFO: Test warmup completed.
19:25:21 INFO: Test run completed.
19:25:21 INFO: Test cooldown is in progress...
19:25:23 INFO: Test cycle finished.
19:25:23 INFO:  Thread  Time(s) Throughput
19:25:23 INFO:  ======  ======= ==========
19:25:23 INFO:  0        60.04   80.88Mbps
19:25:23 INFO: 1 connections tested
19:25:23 INFO: #####  Totals:  #####
19:25:23 INFO: test duration    :60.04 seconds
19:25:23 INFO: total bytes      :606994432
19:25:23 INFO:   throughput     :80.88Mbps
19:25:23 INFO:   retrans segs   :197
19:25:23 INFO: cpu cores        :4
19:25:23 INFO:   cpu speed      :4699.976MHz
19:25:23 INFO:   user           :4.34%
19:25:23 INFO:   system         :0.29%
19:25:23 INFO:   idle           :95.34%
19:25:23 INFO:   iowait         :0.02%
19:25:23 INFO:   softirq        :0.02%
19:25:23 INFO:   cycles/byte    :86.72
19:25:23 INFO: cpu busy (all)   :1.09%
19:25:23 INFO: tcpi rtt         :37717 us
---------------------------------------------------------

</pre>

# RUN 4 With 2 Second Warm Up and 2 Second Cool Down w/ Latency measurement & Jitter #

br8kw@lenov1liter MINGW64 ~/Downloads
$ ./ntttcp.exe -r -m 1,*,192.168.1.39 -ns -t 60 -V -cd 2 -wu 2 -lm -jm jitter.csv
Copyright Version 5.40
buffers_length: 65536
num_buffers_to_send: 9223372036854775807
send_socket_buff: -1
recv_socket_buff: -1
port: 5001
sync_port: 0
no_sync: 1
wait_timeout_milliseconds: 600000
async_flag: 0
verbose_flag: 1
wsa_flag: 0
use_ipv6_flag: 0
send_flag: 0
udp_flag: 0
udp_unconnected_flag: 0
verify_data_flag: 0
wait_all_flag: 0
run_time: 60000
warmup_time: 2000
cooldown_time: 2000
dash_n_timeout: 10800000
bind_sender_flag: 0
sender_name:
max_active_threads: 1
no_delay: 0
node_affinity: -1
udp_uso_size: 0
udp_receive_coalescing: 0
tp_flag: 0
use_hvsocket_flag: 0
no_stdio_buffer: 0
throughput_Bpms: 0
cpu_burn: 0
latency_measurement: 1
use_io_compl_ports: 0
cpu_from_idle_flag: 0
get_estats: 0
qos_flag: 0
packet_period: 0
jitter_measurement: 1
mapping[0]: 1
1/6/2025 19:27:1 proc_speed: 1296 MHz
1/6/2025 19:27:1 SetupThreads
1/6/2025 19:27:1 Threads: 1     Processor: -1   Host: 192.168.1.39
1/6/2025 19:27:1 created thread 0 port 5001
1/6/2025 19:27:1 StartSenderReceiver start thread 0 port 5001
1/6/2025 19:27:1 SetupNet port 5001
1/6/2025 19:27:1 bound to port 5001
1/6/2025 19:27:1 listening on port 5001
1/6/2025 19:27:9 accepted connection on port 5001
1/6/2025 19:27:9 SetupNet complete on port 5001
1/6/2025 19:27:9 All threads ready!
1/6/2025 19:27:9 Network activity progressing...
1/6/2025 19:27:9 test start
1/6/2025 19:27:9 test warmup
1/6/2025 19:27:11 start recording results for sample 0
1/6/2025 19:28:11 stop recording results for sample 0
1/6/2025 19:28:11 test cooldown
1/6/2025 19:28:13 test finish
1/6/2025 19:28:13 StartSenderReceiver done thread 0 port 5001
1/6/2025 19:28:13 PrintOutput

                                               Latency(ns)
Thread  Time(s) Throughput(KB/s) Avg B / Compl        Avg        Min        Max
======  ======= ================ ============= ========== ========== ==========
     0    0.000            0.000     40378.110    4191780       2700  446026100


#####  Totals:  #####


   Bytes(MEG)    realtime(s) Avg Frame Size Throughput(MB/s)
================ =========== ============== ================
      551.235809      60.012       1446.149            9.185

Latency(ns)
       Avg        Min        Max
========== ========== ==========
   4191780       2700  446026100


Throughput(Buffers/s) Cycles/Byte       Buffers
===================== =========== =============
              146.967     150.786      8819.773


DPCs(count/s) Pkts(num/DPC)   Intr(count/s) Pkts(num/intr)
============= ============= =============== ==============
     5011.094         1.329       15337.604          0.434


Packets Sent Packets Received Retransmits Errors Avg. CPU %
============ ================ =========== ====== ==========
       29901           399691          10      0      9.338
	   
	   
jcz@xub2404:~$ ntttcp -s -m 1,*,192.168.1.39 -b 128K -N -t 60 -V -W 2 -C 2
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
test warm-up (sec):              2
test duration (sec):             60
test cool-down (sec):            2
show system tcp retransmit:      no
quiet mode:                      disabled
verbose mode:                    enabled
---------------------------------------------------------
19:27:09 DBG : user limits for maximum number of open files: soft: 1024; hard: 1048576
19:27:09 INFO: Starting sender activity (no sync) ...
19:27:09 INFO: 1 threads created
19:27:09 DBG : New connection: local:60428 [socket:3] --> 192.168.1.39:5001
19:27:09 INFO: 1 connections created in 2843 microseconds
19:27:11 INFO: Test warmup completed.
19:28:11 INFO: Test run completed.
19:28:11 INFO: Test cooldown is in progress...
19:28:13 INFO: Test cycle finished.
19:28:13 INFO:  Thread  Time(s) Throughput
19:28:13 INFO:  ======  ======= ==========
19:28:13 INFO:  0        60.07   77.40Mbps
19:28:13 INFO: 1 connections tested
19:28:13 INFO: #####  Totals:  #####
19:28:13 INFO: test duration    :60.07 seconds
19:28:13 INFO: total bytes      :581173248
19:28:13 INFO:   throughput     :77.40Mbps
19:28:13 INFO:   retrans segs   :75
19:28:13 INFO: cpu cores        :4
19:28:13 INFO:   cpu speed      :4699.976MHz
19:28:13 INFO:   user           :5.10%
19:28:13 INFO:   system         :0.40%
19:28:13 INFO:   idle           :94.44%
19:28:13 INFO:   iowait         :0.04%
19:28:13 INFO:   softirq        :0.02%
19:28:13 INFO:   cycles/byte    :108.02
19:28:13 INFO: cpu busy (all)   :1.10%
19:28:13 INFO: tcpi rtt         :47773 us
---------------------------------------------------------	   


# RUN 4 With 2 Second Warm Up and 2 Second Cool Down w/ Latency measurement, more Proc #

br8kw@lenov1liter MINGW64 ~/Downloads
$ ./ntttcp.exe -r -m 2,*,192.168.1.39 -ns -t 60 -V -cd 2 -wu 2 -lm
Copyright Version 5.40
buffers_length: 65536
num_buffers_to_send: 9223372036854775807
send_socket_buff: -1
recv_socket_buff: -1
port: 5001
sync_port: 0
no_sync: 1
wait_timeout_milliseconds: 600000
async_flag: 0
verbose_flag: 1
wsa_flag: 0
use_ipv6_flag: 0
send_flag: 0
udp_flag: 0
udp_unconnected_flag: 0
verify_data_flag: 0
wait_all_flag: 0
run_time: 60000
warmup_time: 2000
cooldown_time: 2000
dash_n_timeout: 10800000
bind_sender_flag: 0
sender_name:
max_active_threads: 2
no_delay: 0
node_affinity: -1
udp_uso_size: 0
udp_receive_coalescing: 0
tp_flag: 0
use_hvsocket_flag: 0
no_stdio_buffer: 0
throughput_Bpms: 0
cpu_burn: 0
latency_measurement: 1
use_io_compl_ports: 0
cpu_from_idle_flag: 0
get_estats: 0
qos_flag: 0
packet_period: 0
jitter_measurement: 0
mapping[0]: 2
1/6/2025 19:32:46 proc_speed: 1296 MHz
1/6/2025 19:32:46 SetupThreads
1/6/2025 19:32:46 Threads: 2    Processor: -1   Host: 192.168.1.39
1/6/2025 19:32:46 created thread 0 port 5001
1/6/2025 19:32:46 StartSenderReceiver start thread 0 port 5001
1/6/2025 19:32:46 created thread 1 port 5002
1/6/2025 19:32:46 SetupNet port 5001
1/6/2025 19:32:46 StartSenderReceiver start thread 1 port 5002
1/6/2025 19:32:46 SetupNet port 5002
1/6/2025 19:32:46 bound to port 5002
1/6/2025 19:32:46 bound to port 5001
1/6/2025 19:32:46 listening on port 5002
1/6/2025 19:32:46 listening on port 5001
1/6/2025 19:33:0 accepted connection on port 5002
1/6/2025 19:33:0 SetupNet complete on port 5002
1/6/2025 19:33:0 accepted connection on port 5001
1/6/2025 19:33:0 SetupNet complete on port 5001
1/6/2025 19:33:0 All threads ready!
1/6/2025 19:33:0 Network activity progressing...
1/6/2025 19:33:0 test start
1/6/2025 19:33:0 test warmup
1/6/2025 19:33:2 start recording results for sample 0
1/6/2025 19:34:2 stop recording results for sample 0
1/6/2025 19:34:2 test cooldown
1/6/2025 19:34:4 test finish
1/6/2025 19:34:4 StartSenderReceiver done thread 1 port 5002
1/6/2025 19:34:4 StartSenderReceiver done thread 0 port 5001
1/6/2025 19:34:4 PrintOutput

                                               Latency(ns)
Thread  Time(s) Throughput(KB/s) Avg B / Compl        Avg        Min        Max
======  ======= ================ ============= ========== ========== ==========
     0    0.000            0.000     14640.606    3398442       4900  109570400
     1    0.000            0.000     17123.995    3158149       2600   92853900


#####  Totals:  #####


   Bytes(MEG)    realtime(s) Avg Frame Size Throughput(MB/s)
================ =========== ============== ================
      556.695969      60.004       1444.335            9.278

Latency(ns)
       Avg        Min        Max
========== ========== ==========
   3273893       2600  109570400


Throughput(Buffers/s) Cycles/Byte       Buffers
===================== =========== =============
              148.442     138.379      8907.135


DPCs(count/s) Pkts(num/DPC)   Intr(count/s) Pkts(num/intr)
============= ============= =============== ==============
     3135.519         2.148       11361.574          0.593


Packets Sent Packets Received Retransmits Errors Avg. CPU %
============ ================ =========== ====== ==========
       43735           404157          12      0      8.656


jcz@xub2404:~$ ntttcp -s -m 2,*,192.168.1.39 -b 128K -N -t 60 -V -W 2 -C 2
NTTTCP for Linux 1.4.0
---------------------------------------------------------
*** sender role
*** no sender/receiver synch
connections:                     2 X 1 X 1
cpu affinity:                    *
server address:                  192.168.1.39
domain:                          IPv4
protocol:                        TCP
server port starting at:         5001
sender socket buffer (bytes):    131072
test warm-up (sec):              2
test duration (sec):             60
test cool-down (sec):            2
show system tcp retransmit:      no
quiet mode:                      disabled
verbose mode:                    enabled
---------------------------------------------------------
19:33:00 DBG : user limits for maximum number of open files: soft: 1024; hard: 1048576
19:33:00 INFO: Starting sender activity (no sync) ...
19:33:00 INFO: 2 threads created
19:33:00 DBG : New connection: local:48438 [socket:3] --> 192.168.1.39:5002
19:33:00 DBG : New connection: local:52302 [socket:4] --> 192.168.1.39:5001
19:33:00 INFO: 2 connections created in 3381 microseconds
19:33:02 INFO: Test warmup completed.
19:34:02 INFO: Test run completed.
19:34:02 INFO: Test cooldown is in progress...
19:34:04 INFO: Test cycle finished.
19:34:04 INFO:  Thread  Time(s) Throughput
19:34:04 INFO:  ======  ======= ==========
19:34:04 INFO:  0        60.10   34.44Mbps
19:34:04 INFO:  1        60.10   43.52Mbps
19:34:04 INFO: 2 connections tested
19:34:04 INFO: #####  Totals:  #####
19:34:04 INFO: test duration    :60.10 seconds
19:34:04 INFO: total bytes      :585629696
19:34:04 INFO:   throughput     :77.96Mbps
19:34:04 INFO:   retrans segs   :11
19:34:04 INFO: cpu cores        :4
19:34:04 INFO:   cpu speed      :4699.976MHz
19:34:04 INFO:   user           :5.09%
19:34:04 INFO:   system         :0.38%
19:34:04 INFO:   idle           :94.47%
19:34:04 INFO:   iowait         :0.03%
19:34:04 INFO:   softirq        :0.03%
19:34:04 INFO:   cycles/byte    :106.74
19:34:04 INFO: cpu busy (all)   :1.15%
19:34:04 INFO: tcpi rtt         :73786 us
---------------------------------------------------------


# Resources

* [https://www.cnx-software.com/2024/04/22/testing-ntttcp-iperf3-alternative-windows-11-linux/](https://www.cnx-software.com/2024/04/22/testing-ntttcp-iperf3-alternative-windows-11-linux/)
* [https://github.com/microsoft/ntttcp](https://github.com/microsoft/ntttcp) for the Windows client
* [https://github.com/microsoft/ntttcp-for-linux](https://github.com/microsoft/ntttcp-for-linux) for the Linux client
