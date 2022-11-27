---
id: 64
title: 'How to set a static IP in Ubuntu from the shell'
date: '2008-12-04T19:49:06-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=64'
permalink: /2008/12/04/how-to-set-a-static-ip-in-ubuntu-from-the-shell-2/
categories:
    - Linux
---

Edit

```
<br />
/etc/network/interfaces
```

and adjust it to your needs (in this example setup I will use the IP address 192.168.0.100):

```
# This file describes the network interfaces available on your system<br />
# and how to activate them. For more information, see interfaces(5).
```

```
# The loopback network interface<br />
auto lo<br />
iface lo inet loopback
```

```
# This is a list of hotpluggable network interfaces.<br />
# They will be activated automatically by the hotplug subsystem.<br />
mapping hotplug<br />
script grep<br />
map eth0
```

```
<br />
# The primary network interface<br />
auto eth0<br />
iface eth0 inet static<br />
address 192.168.0.100<br />
netmask 255.255.255.0<br />
network 192.168.0.0<br />
broadcast 192.168.0.255<br />
gateway 192.168.0.1
```

Then do

```
sudo /etc/init.d/networking restart
```

to restart the network.