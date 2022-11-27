---
id: 60
title: 'Auto File transfer/copying with SCP'
date: '2008-09-19T13:45:49-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/2008/09/19/auto-file-transfercopying-with-scp/'
permalink: /2008/09/19/auto-file-transfercopying-with-scp/
categories:
    - Uncategorized
---

Here is a

<font face="Arial" size="2"><span style="font-size: 10pt; font-family: Arial;">Here is a script (below) you can use to copy dump files between machines using scp from an  
automated script. Please see attached. The script usage is as  
follows:</span></font>

**<font face="Arial" size="2"><span style="font-weight: bold; font-size: 10pt; font-family: Arial;"><font face="Courier New">./auto\_scp.sh   
local\_file user@host:remote\_folder   
user\_password</font></span></font>**

<font face="Arial" size="2"><span style="font-size: 10pt; font-family: Arial;">or<font face="Courier New"></font></span></font>

**<font face="Arial" size="2"><span style="font-weight: bold; font-size: 10pt; font-family: Arial;"><font face="Courier New">./auto\_scp.sh   
user@host:remote\_file local\_folder   
user\_password</font></span></font>**

<font face="Arial" size="2"><span style="font-size: 10pt; font-family: Arial;">Example:</span></font>

<font face="Arial" size="2"><span style="font-size: 10pt; font-family: Arial;"><font face="Courier New">**./auto\_scp.sh dump.dmp [oracle@hostname:/U01/oracle](mailto:oracle@ttdffxs-klamath.tetratech-ffx.com:/U01/oracle "mailto:oracle@ttdffxs-klamath.tetratech-ffx.com:/U01/oracle")  
 &lt;oracle password&gt;**</font></span></font>

and here is the script  
————————————————–

```
#!/usr/bin/expect -f</p>
<p># connect via scp<br />spawn scp "[lindex $argv 0]" "[lindex $argv 1]" <br />#############################################<br />expect {<br />-re ".*es.*o.*" {<br />exp_send "yes\r"<br />exp_continue<br />}<br />-re ".*sword.*" {<br />exp_send "[lindex $argv 2]\r"<br />}<br />}<br />interact<br />
```