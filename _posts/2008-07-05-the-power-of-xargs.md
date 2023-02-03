---
id: 12
title: 'The power of xargs'
date: '2008-07-05T19:16:30-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'https://johnzastrow.github.io/2008/07/05/the-power-of-xargs/'
permalink: /2008/07/05/the-power-of-xargs/
categories:
    - Linux
---

Excerpted (stolen) from

xargs is your friend. Using xargs, you can pull off feats of greatness  
and not have to write a script to do it. xargs can take care of things  
right on the command line. Though I focus mainly on files in this  
article (it's what I use it for almost exclusively), it's important to  
remember that xargs acts on standard input, which could mean lines  
redirected from /var/log/messages or urls or whatever else you can  
manage to point in its direction.

$ &gt; rpm -qa | grep mozilla | xargs -n1 -p rpm -e –nodeps

What this says in English, is "Using RPM, query all (-qa) packages,  
look for mozilla in the package name, and send the results one at a  
time (-n1), to RPM's uninstall command, and I don't care about  
dependencies, thank you very much ("rpm -e –nodeps"). Also, in case  
there's something that contains the word "mozilla" that I DON'T want  
erased, prompt me (-p) before uninstalling." The above command saves  
you from having to manually list the packages containing the string  
"mozilla," then manually running separate "rpm -e" commands against  
them one at a time.

$ &gt; find / -name \*.mp3 -type f -print | xargs tar -cvzf mp3z.tar.gz

This finds all the mp3z on my entire drive and puts 'em all in a tar  
file, and then I can untar them wherever I want 🙂 I actually could've  
piped that xargs "tar" line into a "tar xvzf" line to automatically  
untar them. I also could've left out the "-type f" if I had grip set up  
to use a custom directory structure that I wanted to preserve. You get  
the idea 🙂 PS – this works for other types of files, too, like finding  
all the files that belong to you, tarring them and sending the tar to a  
backup somewhere, so it does have legitimate use.

$&gt; ls \*.mp3 | xargs -n1 -i cp {} backup/.

This command takes all of the MP3 files in the current directory, and  
feeds them one at a time (-n1) to the cp command, where the file  
argument coming in from ls will replace the curly braces. Notice I  
didn't specify a string with "-i." I don't think I've ever had to. The  
default string that xargs will look to replace when using the -i flag  
is the curly braces. As your command lines get a little more complex,  
or you start using xargs in scripts, there are a couple of useful  
troubleshooting flags you may find helpful if you run into issues. One,  
the -p flag, will prompt you for a yes or no before executing a command  
on anything. The other, which is a real life saver, is "-t," and it  
does NOT prompt you for a yes or no (unless you use it with -p), but it  
will output the command it's trying to execute, so if something isn't  
quite right, you'll be able to spot it right away. Comments:

$ &gt; rpm -qa | grep mozilla | xargs -n1 -p rpm -e –nodeps

How about:

rpm -e –nodeps `rpm -qa|grep mozilla`

or if you want a prompt:

for pkg in `rpm -qa`  
do  
 echo "Remove package $pkg? (y/n)"  
 read ans  
 if [ "$ans" == "y" ]; then  
 rpm -e –nodeps $pkg  
 fi  
done

Far clearer. The use for xargs is cases where you want to use tools  
(such as GNU Grep) which have limits on the amount of input they can  
take. For example:

grep foo `find / -type f -print`

might be too much for grep to cope with;

find / -type f -print | xargs grep foo   
&gt; ls \*.mp3 | xargs -n1 -i cp {} backup/.