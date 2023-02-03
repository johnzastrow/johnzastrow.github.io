---
id: 15
title: 'Automate your life'
date: '2008-07-05T20:17:21-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'https://johnzastrow.github.io/2008/07/05/automate-your-life/'
permalink: /2008/07/05/automate-your-life/
categories:
    - Linux
---

***What is crontab?***

If you've worked with Perl  
scripts I'm sure you've heard or seen the words "cron",

"crontab", or "cron job" before. If not, you'll learn  
something new today!

The

crontab command allows you to tell your server to execute a file at a specific

time, as often as you want – like once a day or once a minute. Most commonly,  
crontab

is used to execute a cgi script to perform a certain task repeatedly rather than

doing it manually. Saves a lot of time!

*NOTE:* many hosting  
companies disable crontab on their hosting accounts because

it is often abused. Using it to repeatedly execute a file takes up precious cpu

time and if misused can slow down a server immensely. However, if you talk to  
your

hosting company and let them know what file you are going to run they more than

likely will be happy to enable crontab on your system. If they won't, then you  
might want to think about getting a dedicated server…

***Where do I start?***

To use crontab, you have  
to be able to telnet into your server. This is accomplished

in Windows by going to Start-&gt;Run and typing in "telnet yourdomain.com"  
and hitting

"OK". A new window will pop up and you will have to put in your  
username and password.

If you normally use an FTP client, usually it's the same username and password.

If successful. you will  
then get a command prompt: $

First, you can see the  
crontab usage info by typing in "crontab" and hitting return.

Here's what it looks like on my server:

usage: crontab [-u user]  
file

crontab [-u user] { -e | -l | -r }

-e (edit user's crontab)

-l (list user's crontab)

-r (delete user's crontab)

So, if you type:

crontab -l

you will get a list of the crontab jobs already running on your system. Try it  
out. You probably don't have any running so you will get an empty list…

***How do I set up a  
crontab job?***

While you can edit the crontab file directly through telnet, I've found that the  
easiest way for a beginner to start a crontab job is to create a text file  
containing your crontab instructions, upload it to your main directory, telnet  
into your system, and then just type:

crontab myfile.txt

and the crontab job will  
be created.

***So what do I put in the text file? What is the syntax?***

This text file will  
minimally only have to have one line containing the information

for your cron job. Here is a run down of the syntax:

0 1 \* \* \* /path/to/cgi-bin/yourscript.cgi

| | | | |

| | | | |________________ day of week

| | | |__________________ month of year

| | |____________________ day of month

| |______________________ hour of day

|________________________ minute of hour

The \* in the above example  
basically means "every". So, in this example the script would execute  
\*every\* month, \*every\* day of the week, \*every\* day of the month, and then ONLY  
at hour 1 of the day. So – this script would execute once a day at 1 am in the  
morning.

Say you wanted to execute  
it 4 times a day, you would type in:

0 1,7,13,19 \* \* \* /path/to/cgi-bin/autocron.cgi

This executes autocron.cgi  
four times a day about every 6 hours. Notice that

you can use commas to add in more times – but always keep the spaces to  
delineate

the time frames.

Another example, to  
execute autocron.cgi twice a month:

0 1 1,15 \* \* /path/to/cgi-bin/autocron.cgi

This line would execute  
the file on the 1st and 15th of the month at 1AM.

***Can I run multiple  
crontab jobs?***

In a nutshell – YES! Just  
add multiple lines to the text file using the syntax above for every

script that you would like to run. Make sure that the paths to the scripts are

correct and you've double checked your time settings.

***How can I tell that it's working?***

Simple, after you have  
executed the text file with your one line crontab, just

type:

crontab  
-l

At your command prompt and you will see something like this:

# (cronjob.txt installed on Tue Apr 11 21:19:12 2000)

# (Cron version — $Id: crontab.c,v 2.13 1994/01/17 03:20:37 vixie Exp $)

0 1 \* \* \* /path/to/cgi-bin/yourscript.cgi

All of the running jobs  
will be listed.

***Can I edit my  
crontab file through telnet?***

Yes, however, I prefer to  
just delete the current crontab file and create a new

one with a new text file. Just type:

crontab  
-e

and your crontab file editor will pop up and you can edit the file. Some telnet

clients make it hard to edit this file though – which is why I just delete

and recreate my crontab file.

***How do I delete a crontab file?***

This is easy! At the  
telnet prompt, type:

crontab  
-r

and the crontab file will be completely deleted. You can check this by using the

"crontab -l" command. And of course, you can recreate your file by  
typing

"crontab myfile.txt". (or whatever you named the text file containing  
your

crontab lines)