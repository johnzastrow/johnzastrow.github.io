---
id: 29
title: 'Paths on Linux'
date: '2008-07-05T20:40:37-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'https://johnzastrow.github.io/2008/07/05/paths-on-linux/'
permalink: /2008/07/05/paths-on-linux/
categories:
    - Linux
---

Today I'm going to do a test install of the J2EE mapserver-like  
facilities provided by geoserver version 1.3 Rc2. I recently installed  
java and the JDK on this machine, so I still need to set JAVA_HOME in  
the path. I do this so rarely everytime I need to do it I have to look  
it up.

I use the BASH shell, so all of this applies to BASH on linux.

Type env to see a listing of your curent environment, including your path:

actinella:/opt/java# env  
SSH_AGENT_PID=5592  
HZ=100  
KDE_MULTIHEAD=false  
TERM=xterm  
SHELL=/bin/bash  
GTK2_RC_FILES=/etc/gtk-2.0/gtkrc:/home/jcz/.gtkrc-2.0:/home/jcz/.kde/share/config/gtkrc  
GS_LIB=/home/jcz/.fonts  
GTK_RC_FILES=/etc/gtk/gtkrc:/home/jcz/.gtkrc:/home/jcz/.kde/share/config/gtkrc  
HUSHLOGIN=FALSE  
WINDOWID=4194309  
KDE_FULL_SESSION=true  
USER=root  
XCURSOR_SIZE=  
SSH_AUTH_SOCK=/tmp/ssh-vBaaqD5569/agent.5569  
SESSION_MANAGER=local/actinella.homelinux.org:/tmp/.ICE-unix/5643  
KONSOLE_DCOP=DCOPRef(konsole-10017,konsole)  
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/X11R6/bin:/usr/local/sbin:/usr/local/bin:/usr/games  
MAIL=/var/mail/jcz  
PWD=/opt/java  
KONSOLE_DCOP_SESSION=DCOPRef(konsole-10017,session-1)  
LANG=C  
HOME=/root  
SHLVL=5  
LANGUAGE=us  
XCURSOR_THEME=default  
LOGNAME=jcz  
DISPLAY=:0.0  
XAUTHORITY=/home/jcz/.Xauthority  
COLORTERM=  
_=/usr/bin/env  
OLDPWD=/opt

I set JAVA_HOME to point to the directory the extraction just created.  
Ie, if I was in /opt/java when I ran the extraction, it would have  
created a directory named java, so I would set JAVA_HOME to /opt/java.

export JAVA_HOME="/opt/java"

You may want to edit your path to set this enironment variable  
permanently. To do that (again, assuming the Bash shell), edit  
.bash_profile in your home directory, and add the JAVA_HOME setting  
there. On my debian system I stuck this in /etc/profile . Ie:

JAVA_HOME=/opt/java

Then change the PATH statement to include the JAVA_HOME setting. Ie, from:  
PATH=$PATH:$HOME/bin:/usr/local/iperf

to  
PATH=$PATH:$HOME/bin:$JAVA_HOME/bin:/usr/local/iperf

Then "source" your copy of .bash_profile to invoke the changes:  
source .bash_profile

or in my case

source /etc/profile

then type env to see the changes.