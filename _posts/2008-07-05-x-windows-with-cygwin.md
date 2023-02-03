---
id: 23
title: 'X windows with Cygwin'
date: '2008-07-05T20:33:04-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'https://johnzastrow.github.io/2008/07/05/x-windows-with-cygwin/'
permalink: /2008/07/05/x-windows-with-cygwin/
categories:
    - Linux
---

PC XStation Configuration  
Download the CygWin setup.exe from http://www.cygwin.com.

Install, making sure to select all the XFree86 optional packages.

If you need root access add the following entry into the /etc/securettys file on each server:

&lt;client-name&gt;:0  
From the command promot on the PC do the following:

set PATH=PATH;c:\\cygwin\\bin;c:\\cygwin\\usr\\X11R6\\bin  
XWin.exe :0 -query &lt;server-name&gt;  
The X environment should start in a new window.

Many Linux distributions do not start XDMCP by default. To allow XDMCP  
access from Cygwin edit the "/etc/X11/gdm/gdm.conf" file. Under the  
"[xdmcp]" section set "Enable=true".

If you are starting any X applications during the session you will need  
to set the DISPLAY environment variable. Remember, you are acting as an  
XStation, not the server itself, so this variable must be set as  
follows:

DISPLAY=&lt;client-name&gt;:0.0; export DISPLAY