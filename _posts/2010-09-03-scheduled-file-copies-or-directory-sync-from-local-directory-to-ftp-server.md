---
id: 93
title: 'Scheduled file copies or directory sync from local directory to FTP server'
date: '2010-09-03T21:02:37-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=93'
permalink: /2010/09/03/scheduled-file-copies-or-directory-sync-from-local-directory-to-ftp-server/
categories:
    - Linux
---

If you have a remote FTP server that you need to put files into, and you don't want to deal with SCP/SFTP passkeys, [lftp ](http://lftp.yar.ru/)(http://lftp.yar.ru/) on the local client machine might be for you. It comes with most linux distros (I found it using yum simply as lftp) and one of its most useful traits is to be able to mirror the remote FTP directory to your local one, and vice versa (through –reverse mirror). Here's some examples:

# verbosely mirror files from FTP server to local dir. -d to show FTP responses  
lftp -d -u ftpusername,password -e "mirror –only-newer –verbose /home/ftpusername/tmp /home/localusername/tmp" ftphost.com&amp;

# more quietly mirror files \*to\* FTP server from local dir.  
lftp -u ftpusername,password -e "mirror –reverse –only-newer /home/localusername/tmp tmp" ftphost.com&amp;

Notice the ampersand, which sends the command to the background so you don't have to keep the terminal window open.

Here are some more links:

[http://www.softpanorama.org/Net/Application\_layer/Ftp/lftp.shtml](http://www.softpanorama.org/Net/Application_layer/Ftp/lftp.shtml)  
<http://www.linux.com/archive/articles/122169>  
[http://how-to.wikia.com/wiki/How\_to\_use\_lftp\_as\_a\_sftp\_client](http://how-to.wikia.com/wiki/How_to_use_lftp_as_a_sftp_client)  
[http://www.gsp.com/cgi-bin/man.cgi?section=1&amp;topic=lftp](http://www.gsp.com/cgi-bin/man.cgi?section=1&topic=lftp)