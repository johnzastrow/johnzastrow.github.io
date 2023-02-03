---
id: 24
title: 'Running cygwin cron from windows as a service'
date: '2008-07-05T20:34:25-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'https://johnzastrow.github.io/2008/07/05/running-cygwin-cron-from-windows-as-a-service/'
permalink: /2008/07/05/running-cygwin-cron-from-windows-as-a-service/
categories:
    - Linux
---

2 Running cygwin cron from windows as a service  
Cron is a program for running scripts or programs at certain times. For cron to be able to do this,  
it has to be running when the machine is on. This is done by adding cron as a service. Open a  
bash terminal. Write:

cygrunsrv -I cron -p /usr/sbin/cron -a  
(do cygrunsrv –help to better understand).

Now we need to setup cron so it runs what we want. If you don't like vi you should do export

Type crontab to better understand cron's options

In a text editor, write the following to a file called cronrun.txt

SHELL=/bin/bash  
PATH=/sbin:/bin:/usr/sbin:/usr/bin  
MAILTO=root  
HOME=/

0 3 \* \* \* /bin/backup &gt; /dev/null 2&gt;&amp;1

Then type  
crontab cronrun.txt to load your job. Type crontab -l to list your jobs

The first line tells cron to run the commands in bash, second is the path cron searches for  
programs, third who to mail on error and fourth which directory to default to The last line is a  
cron line which tells cron to run backup at 0300 each day and don't report anything even if there  
is an error. Lets have a look at how its done.

\* \* \* \* \* command line  
| | | | |  
| | | | |- weekday (0-6)  
| | | |- month (1-12)  
| | |- dayofmonth (1-31)  
| |- hours (1-23)  
|- minutes (0-59)

The first five entries correspond to times, an \* means any time. For example the entry "0 1 \* \*  
0" correspond to 0100 am on a Sunday. You can also separate times with comma, for example "  
0 1 \* \* 1,3,5 /bin/backup" runs the backup script 0100 on Monday ,Wednesday and Friday. The  
&gt; /dev/null redirects standard output from backup to a black hole, the 2&gt;&amp;1 redirects standard  
error to standard output from backup, thus redirecting standard error to a black hole.