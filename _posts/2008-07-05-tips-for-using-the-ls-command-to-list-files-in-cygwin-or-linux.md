---
id: 28
title: 'Tips for using the ls command to list files in Cygwin or Linux'
date: '2008-07-05T20:39:40-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/2008/07/05/tips-for-using-the-ls-command-to-list-files-in-cygwin-or-linux/'
permalink: /2008/07/05/tips-for-using-the-ls-command-to-list-files-in-cygwin-or-linux/
categories:
    - Linux
---

Classify

ls –classify or ls -F will append characters to files to show their type:

 \* / directory  
 \* \* executable

Code: ls -F  
directory/ me.jpeg script.sh\*

ls –color=tty

Will color the ‘ls’ output. Directories are blue, regular files stay black (or white) and executable files are green.

Make an Alias of your prefered method.

Example:

alias ls=’ls –color=tty –classify’

List only directories

ls -d \*/

Will list only dentries ended by a “/”, and with the “-d” option, will not descend into the next level of directory.