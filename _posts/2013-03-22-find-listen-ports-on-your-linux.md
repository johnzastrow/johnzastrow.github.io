---
id: 697
title: 'Find listen ports on your linux'
date: '2013-03-22T13:41:58-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=697'
permalink: /2013/03/22/find-listen-ports-on-your-linux/
categories:
    - Linux
---

For example, if you only want to see TCP connections, use netstat –tcp.  
This shows a list of TCP connections to and from your machine. The following example shows connections to our machine on ports 993 (imaps), 143 (imap), 110 (pop3), 25 (smtp), and 22 (ssh).It also shows a connection from our machine to a remote machine on port 389 (ldap).

Note: To speed things up you can use the –numeric option to avoid having to do name resolution on addresses and display the IP only.

Code Listing 1: netstat –tcp

```
% netstat --tcp --numeric  
Active Internet connections (w/o servers)  
Proto Recv-Q Send-Q Local Address           Foreign Address         State       
tcp        0      0 192.168.128.152:993     192.168.128.120:3853   ESTABLISHED
tcp        0      0 192.168.128.152:143     192.168.128.194:3076   ESTABLISHED
tcp        0      0 192.168.128.152:45771   192.168.128.34:389      TIME_WAIT
tcp        0      0 192.168.128.152:110     192.168.33.123:3521     TIME_WAIT
tcp        0      0 192.168.128.152:25      192.168.231.27:44221    TIME_WAIT
tcp        0    256 192.168.128.152:22      192.168.128.78:47258   ESTABLISHED
```

If you want to see what (TCP) ports your machine is listening on, use netstat –tcp –listening.  
Another useful flag to add to this is –programs which indicates which process is listening on the specified port.  
The following example shows a machine listening on ports 80 (www), 443 (https), 22 (ssh), and 25 (smtp);

Code Listing 2: netstat –tcp –listening –programs

```
# sudo netstat --tcp --listening --programs
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address   Foreign Address   State     PID/Program name
tcp        0      0 *:www           *:*               LISTEN    28826/apache2
tcp        0      0 *:ssh           *:*               LISTEN    26604/sshd
tcp        0      0 *:smtp          *:*               LISTEN    6836/
tcp        0      0 *:https         *:*               LISTEN    28826/apache2
```

Note: Using –all displays both connections and listening ports.

The next example uses netstat –route to display the routing table. For most people, this will show one IP and and the gateway address but if you have more than one interface or have multiple IPs assigned to an interface, this command can help troubleshoot network routing problems.

Code Listing 3: netstat –route

```
% netstat --route
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
192.168.1.0     0.0.0.0         255.255.255.0   U     0      0        0 eth0
0.0.0.0         192.168.1.1     0.0.0.0         UG    1      0        0 eth0
```

The last example of netstat uses the –statistics flag to display networking statistics. Using this flag by itself displays all IP, TCP, UDP, and ICMP connection statistics.  
To just show some basic information. For example purposes, only the output from –raw is displayed here.  
Combined with the uptime command, this can be used to get an overview of how much traffic your machine is handling on a daily basis.

## netstat command to find open ports

```
# netstat --listen
```

  
To display open ports and established TCP connections, enter:  
```
$ netstat -vatn
```

  
To display only open UDP ports try the following command:  
```
$ netstat -vaun
```

  
If you want to see FQDN (full dns hostname), try removing the -n flag:  
```
$ netstat -vat
```

So far I like this one the best. You need sudo to see the programs that are listening

sudo netstat -tple

or

sudo netstat -lnptu