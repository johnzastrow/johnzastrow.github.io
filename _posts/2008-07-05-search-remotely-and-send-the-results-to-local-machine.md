---
id: 11
title: 'Search remotely and send the results to local machine'
date: '2008-07-05T19:15:11-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/2008/07/05/search-remotely-and-send-the-results-to-local-machine/'
permalink: /2008/07/05/search-remotely-and-send-the-results-to-local-machine/
categories:
    - Linux
---

If you want to grep (search) through a log file while you’re ssh’d in  
to a server and then get that output to yourself on your workstation. I  
usually do “grep … &gt; ~/file.txt” and then scp it over.

But you can also do:

 ssh remotehost -l remoteuser “grep regexpr logfile” &gt; localfilename

Or if you are already on the remote but want the file to end up locally:

 grep … | ssh localhost cat \\&gt;file.txt

~ from the gang at Milwaukee LUG