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

This is mostly a log for myself of stuff I don't do every day so I don't have to Google it all the time. The first article at the bottom is where I poached most of this content from. His article pretty much says it all - including that commands and binaries differ between Linux and Windows. This video also explains more. 

I don't know why such a fundamental thing as network performance measurement in this age is such a confusing, hot mess, with crappy hard tools. We're ALL doing video calls these days and Internet access is more critical than most other services.

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

The results above don't show MB/s here, so we'll go with 31.79 Mbps, which is being sent by a 4 CPU linux VM on a 1 year old, otherwise idling AMD workstation running Proxmox hardwired to the Unifi Dream Machine that the 1 liter is wifing to.



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

The results from the receiver (Windows) above show 3.757 MB/s and 60.118 Mbps (I think), but 90 errors which is interesting.

# Resources

* (https://www.cnx-software.com/2024/04/22/testing-ntttcp-iperf3-alternative-windows-11-linux/)
* (https://github.com/microsoft/ntttcp) for the Windows client
* (https://github.com/microsoft/ntttcp-for-linux) for the Linux client
