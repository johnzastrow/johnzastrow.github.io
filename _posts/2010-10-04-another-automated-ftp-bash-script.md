---
id: 106
title: 'Another automated FTP bash script'
date: '2010-10-04T07:00:27-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=106'
permalink: /2010/10/04/another-automated-ftp-bash-script/
categories:
    - Linux
---

from <http://www.stratigery.com/scripting.ftp.html>

Another solution from the site above for performing FTP PUTs on a schedule.

## The Problem

The problem I always encountered in scripting ftp transfers involved getting a password to the ftp server. Typical ftp client programs under Unix, Linux, Solaris and NetBSD all read the ftp password from <kbd>/dev/tty</kbd>.

## Example Working Script

```
<kbd>#!/bin/sh
HOST='ftp.users.qwest.net'
USER='yourid'
PASSWD='yourpw'
FILE='file.txt'

ftp -n $HOST <<END_SCRIPT
quote USER $USER
quote PASS $PASSWD
put $FILE
quit
END_SCRIPT
exit 0
</kbd>
```

## The Tricks

Getting the password to the ftp server without having the ftp client program read the password from <kbd>/dev/tty</kbd> requires two tricks:

1. Using the <kbd>-n</kbd> option on the ftp client program to prevent the ftp client from trying to log in immediately. That way, the ftp client does not ask for a user ID and password. No use of <kbd>/dev/tty</kbd>.
2. Use the ftp client program command <kbd>quote</kbd> to send user ID and password to the ftp server.

## Control of ftp by a shell script

One obvious improvement would have the ftp client program controlled by the shell script. I don’t think that would comprise an impossible task, but I also don’t think that it would have much value. Scripting ftp transfer using [expect](http://expect.nist.gov/) might cause you less pain, except that it is sensitive to the environment that it is run in. Changes to default program inputs and outputs can break it.

- - - - - -

### Alternative #1

I saw a second way of doing this in a usenet article:

```
<kbd>#!/bin/sh
USER=userid
PASSWD=userpw
ftp -n f2dev <<SCRIPT
user $USER $PASSWD
binary
get some.file
quit
SCRIPT
</kbd>
```

It still uses the “-n” trick, but it sends user ID and password in the same “user” command.

- - - - - -

### Alternative #2

**Use a .netrc file**

Linux, Unix and BSD users have the alternative of using a <kbd>.netrc</kbd> file. The ftp man page documents the format of <kbd>.netrc</kbd>. To accomplish the task of using ftp in a shell script you would have to fill out a <kbd>.netrc</kbd> file something like this:

```
<kbd>
machine something.else.com
login myid
password mypassword
</kbd>
```

ftp demands that <kbd>.netrc</kbd> not have group or world read or write permissions:

```
<kbd>
$ ls -l .netrc
-rw-------    1 bediger  users          51 Dec 16 13:30 .netrc
</kbd>
```

Using a <kbd>.netrc</kbd> file has a few problems that may or may not prevent you from using it.

- A shell scripkt that does FTP using .netrc is no longer self-contained. You have to keep track of two files, which means that bugs can be less than obvious.
- ftp reads it’s user ID’s <kbd>.netrc</kbd>. If you develop your script under a given user ID, then put it in production under a second user ID, you have to coordinate .netrc file contents between those two user IDs.

- - - - - -

### Alternative #3

Apparently, the [Ckermit](http://www.columbia.edu/kermit/ck80.html) program from Columbia University understands FTP. You could use Ckermit to [script FTP transfers](http://www.columbia.edu/kermit/ftpscripts.html). This looks to have advantages and disadvantages. On the “pro” side, it appears that Ckermit can exit on various errors, like unknown user IDs, or bad passwords. On the “con” side, you have to have Ckermit. I don’t recall that it had a too onerous install, but it doesn’t come with many Linux distros these days, and it probably doesn’t come with any vendor Unix.

See also <http://www.linuxforums.org/forum/programming-scripting/106665-automatic-ftp-upload-via-script.html>

```
<pre dir="ltr">#!/bin/bash
# puts the file bookmarks.html
cd $HOME/.mozilla/firefox/
cd ./*.default/
UDIRX=`pwd`
HOST='www.linuxforums.org'
USER='core-wizard'
PASSWD='leethaxor'
<span style="color: brown;">BASENAME=$(basename $UDIRX)
echo '$UDIRX is' $UDIRX
echo '$BASENAME is' $BASENAME</span>

ftp -n -v $HOST << EOT
ascii
user $USER $PASSWD
prompt
mkdir .mozilla
cd .mozilla
mkdir firefox
cd firefox
mkdir <span style="color: brown;">$BASENAME</span>
cd <span style="color: brown;">$BASENAME</span>
put bookmarks.html
bye
EOT
sleep 12
```

- - - - - -