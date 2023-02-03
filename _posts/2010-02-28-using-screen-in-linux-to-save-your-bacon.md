---
id: 90
title: 'Using screen in Linux to save your bacon'
date: '2010-02-28T23:08:58-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=90'
permalink: /2010/02/28/using-screen-in-linux-to-save-your-bacon/
categories:
    - Linux
---

Tonight I'm being plagued by dropped ssh connections. 2 minutes of work, them bam everything goes away. I've seen screen used in the past, but never had to use its power until tonight. Ask any seasoned sysadmin and they'll tell you that screen has saved their bacon many times, and it did for me tonight. I'm definitely adding it to my toolbelt. Hopefully it stays around a little longer.

From http://www.rackaid.com/resources/linux-screen-tutorial-and-how-to/

<div>## Linux Screen Tutorial and How To

Posted by Jeff H. 01/01/2008

</div><div><script type="text/javascript">// <![CDATA[
tweetmeme_source = 'rackaid';
// ]]></script> <script src="http://tweetmeme.com/i/scripts/button.js" type="text/javascript"></script></div>### Using Linux Screen for Session Management

### Lost your shell connection? Need multiple shell sessions?

You are logged into your remote server via SSH and happily plucking along at your keyboard and then it happens. Suddenly, the characters stop moving and then you get the dreaded "Connection Closed" message. You have just lost your session. You were halfway through some task and now you have to start over. Ugh. Well you can prevent this from happening by using screen. The Linux screen tool can not only save you from disconnection disasters, but it also can increase your productivity by using multiple windows within one SSH session.

### Linux Screen for Session Management!

![Screenshot of Linux Screen Terminal](http://www.rackaid.com/files/resources/screen.png)

Linux Screen showing the GNU page for Linux Screen Itself

Linux Screen Can Save you from that Lost Connection

### What is Screen for Linux?

As the man page states, "Screen is a full-screen window manager that multiplexes a physical terminal between several processes (typically interactive shells)." This can be a life saver when working on your dedicated server. Screen has a several great features for helping you administer your server more productively and safely. I am going to discuss the three features (multiple windows, logging, sessions) that I use the most but be sure to see the man page for full details.

### Installing Screen on Linux

Chances are that you already have screen on your system. On most Red Hat distributions you can find it in /usr/bin/screen. To see if screen is in your path, you can use the which command:

```
[admin@ensim admin]$ which screen
```

If you do not have screen, then you can install it easily from an RPM or the package file for your system. On Cobalt Raq servers, you can safely use the RedHat RPMS appropriate for your system.  
Screen RPMs: rpmfind  
Screen Web site: [GNU Screen](http://www.gnu.org/software/screen/)

As you probably already have screen or can use an RPM, I am not going to cover the building of screen from source. Lets get on to how to use screen.

### Using Screen

Screen is started from the command line just like any other command:

```
[admin@gigan admin]$ screen
```

You may or may not get a text message about screen. If you do not, then you probably think nothing has happened, but it has. You are now inside of a window within screen. This functions just like a normal shell except for a few special characters. Screen uses the command "Ctrl-A" as a signal to send commands to screen instead of the shell. To get help, just use "Ctrl-A" then "?". You should now have the screen help page.

Screen key bindings, page 1 of 2.

```
               Command key:  ^A   Literal ^A:  a
```

```
break      ^B b       lockscreen ^X x       reset      Z
clear      C          log        H          screen     ^C c
colon      :          login      L          select     " '
copy       ^[ [       meta       a          silence    _
detach     ^D d       monitor    M          split      S
digraph    ^V         next       ^@ ^N sp n suspend    ^Z z
displays   *          number     N          time       ^T t
fit        F          only       Q          title      A
flow       ^F f       other      ^A         vbell      ^G
focus      ^I         pow_break  B          version    v
help       ?          pow_detach D          width      W
history            prev       ^P p ^?    windows    ^W w
info       i          readbuf    <          wrap       ^R r
kill       K          redisplay  ^L l       writebuf   >
lastmsg    ^M m       remove     X          xoff       ^S s
license    ,          removebuf  =          xon        ^Q q
                 [Press Space for next page; Return to end.]
```

Key bindings are the commands the screen accepts after you hit "Ctrl-A". You can reconfigure these keys to your liking using a .screenrc file, but I just use the defaults.

### Multiple Windows

Screen, like many windows managers, can support multiple windows. This is very useful for doing many tasks at the same time without opening new sessions. As a systems manager, I often have four or five SSH sessions going at the same time. In each of the shell, I may be running two or three tasks. Without screen, that would require 15 SSH sessions, logins, windows, etc. With screen, each system gets its own single session and I use screen to manage different tasks on that system.

To open a new window, you just use "Ctrl-A" "c". This will create a new window for you with your default prompt. For example, I can be running top and then open a new window to do other things. Top stays running! It is still there. To try this for yourself, start up screen and then run top. (Note: I have truncated some screens to save space.)

Start top

```
  Mem:   506028K av,  500596K used,    5432K free,
    0K shrd,   11752K buff
    Swap: 1020116K av,   53320K used,  966796K free
              393660K cached
```

```
     PID USER     PRI  NI  SIZE  RSS SHARE STAT %CPU %ME
     6538 root      25   0  1892 1892   596 R    49.1  0.3
     6614 root      16   0  1544 1544   668 S    28.3  0.3
     7198 admin     15   0  1108 1104   828 R     5.6  0.2
```

Now open a new window with "Ctrl-A" "c"

```
[admin@ensim admin]$
```

To get back to top, use "Ctrl-A "n"

```
   Mem:   506028K av,  500588K used,    5440K free,
    0K shrd,   11960K buff
    Swap: 1020116K av,   53320K used,  966796K free
              392220K cached
```

```
     PID USER     PRI  NI  SIZE  RSS SHARE STAT %CPU %ME
     6538 root      25   0  1892 1892   596 R    48.3  0.3
     6614 root      15   0  1544 1544   668 S    30.7  0.3
```

You can create several windows and toggle through them with "Ctrl-A" "n" for the next window or "Ctrl-A" "p" for the previous window. Each process will keep running while your work elsewhere.

### Leaving Screen

There are two ways to get out of screen. The first is just like logging out of a shell. You kill the window with "Ctrl-A" "K" or "exit" will work on some systems. This will kill the current windows. If you have other windows, you will drop into one of those. If this is the last window, then you will exit screen.

The second way to leave screen is to detach from a windows. This method leaves the process running and simple closes the window. If you have really long processes, you need to close your SSH program, you can detach from the window using "Ctrl-A" "d". This will drop you into your shell. All screen windows are still there and you can re-attach to them later.

### Attaching to Sessions

So you are using screen now and compiling that program. It is taking forever and suddenly your connection drops. Don't worry screen will keep the compilation going. Login to your system and use the screen listing tool to see what sessions are running:

```
[root@gigan root]# screen -ls
There are screens on:
        31619.ttyp2.gigan       (Detached)
        4731.ttyp2.gigan        (Detached)
2 Sockets in /tmp/screens/S-root.
```

Here you see I have two different screen sessions. To re-attach to a session, use the re-attach command:

```
[root@gigan root]#screen -r 31619.ttyp2.gigan
```

Just use screen with the -r flag and the session name. You are now re-attached to the screen. A nice thing about this, is you can re-attach from anywhere. If you are at work or a clients office, you can use screen to start a job and then logout. When you get back to your office or home, you can login and get back to work.

### Screen Logging

As a consultant, I find it important to keep track of what I do to someone's server. Fortunately, screen makes this easy. Using "Ctrl-A" "H", creates a running log of the session. Screen will keep appending data to the file through multiple sessions. Using the log function is very useful for capturing what you have done, especially if you are making a lot of changes. If something goes awry, you can look back through your logs.

### Linux Screen Tips

Just wanted to mention to other cool tricks you can do with screen. Screen can monitor a window for activity or lack thereof. This is great if you are downloading large files, compiling, or watching for output. If you are downloading something or compiling, you can watch for silence. To start the monitor, go to the screen you want to monitor and use "Ctrl-A" "M" to look for activity or "Ctrl-A" "_" to monitor for silence. Then open or switch to a new window. When the monitor detects activity or silence, you will get an alert at the bottom with the window number. To quickly go to that window, use "Ctrl-A" " (thats a quote mark, ctrl-a then a "). After you do this, just type in the number of the window and enter. To stop monitoring, go to that window and undo the monitor with the same command. For example, to stop monitoring for activity you would use "Ctrl-A" "M" again.

### Reference

Screen was covered recently in Linux Magazine by Adam Lazur (Jan 2003, Issue 105). Much of his information was adapted for this rackTIP. Other information was collected from the man pages.