---
id: 63
title: 'How to set a static IP in Ubuntu from the shell'
date: '2005-02-09T04:40:00-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/2005/02/09/how-to-set-a-static-ip-in-ubuntu-from-the-shell/'
permalink: /2005/02/09/how-to-set-a-static-ip-in-ubuntu-from-the-shell/
categories:
    - Linux
---

<div class="post-body">Edit ```
<span class="punct">/</span><span class="regex">etc</span><span class="punct">/</span><span class="ident">network</span><span class="punct">/</span><span class="ident">interfaces</span>  and adjust it to your needs (in this example setup I will use the IP address  192.168.0.100):<br /><br /><span class="comment"># This file describes the network interfaces available on your system</span><br /><span class="comment"># and how to activate them. For more information, see interfaces(5).</span><br /><br /><span class="comment"># The loopback network interface</span><br /><span class="ident">auto</span> <span class="ident">lo</span><br /><span class="ident">iface</span> <span class="ident">lo</span> <span class="ident">inet</span> <span class="ident">loopback</span><br /><br /><span class="comment"># This is a list of hotpluggable network interfaces.</span><br /><span class="comment"># They will be activated automatically by the hotplug subsystem.</span><br /><span class="ident">mapping</span> <span class="ident">hotplug</span><br />        <span class="ident">script</span> <span class="ident">grep</span><br />        <span class="ident">map</span> <span class="ident">eth0</span><br /><br /><span class="comment"># The primary network interface</span><br /><span class="ident">auto</span> <span class="ident">eth0</span><br /><span class="ident">iface</span> <span class="ident">eth0</span> <span class="ident">inet</span> <span class="ident">static</span><br />        <span class="ident">address</span> <span class="number">192.168</span><span class="punct">.</span><span class="number">0.100</span><br />        <span class="ident">netmask</span> <span class="number">255.255</span><span class="punct">.</span><span class="number">255.0</span><br />        <span class="ident">network</span> <span class="number">192.168</span><span class="punct">.</span><span class="number">0.0</span><br />        <span class="ident">broadcast</span> <span class="number">192.168</span><span class="punct">.</span><span class="number">0.255</span><br />        <span class="ident">gateway</span> <span class="number">192.168</span><span class="punct">.</span><span class="number">0.1</span><br /><br />Then do<br /><br /><span class="ident">sudo</span> <span class="punct">/</span><span class="ident">etc</span><span class="punct">/</span><span class="ident">init</span><span class="punct">.</span><span class="ident">d</span><span class="punct">/</span><span class="ident">networking</span> <span class="ident">restart</span><br /><br />to restart the network.<br /><br />
```

</div>