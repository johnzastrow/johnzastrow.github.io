---
id: 190
title: 'PostGIS Install and Cloning Ubuntu Systems Notes'
date: '2011-05-11T15:02:15-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/2011/05/11/postgis-install-and-cloning-ubuntu-systems-notes/'
permalink: /2011/05/11/postgis-install-and-cloning-ubuntu-systems-notes/
categories:
    - Database
    - Linux
---

\[cc lang=’bash’ \]sudo apt-get remove –purge\[/cc\]

\[cc lang=’bash’ \]apt-get install deborphan debfoster  
debfoster  
deborphan  
deborphan –guess-all\[/cc\]

\[cc lang=’bash’ \]apt-get autoremove  
sudo apt-get remove –purge postgresql-client  
sudo apt-get remove –purge postgresql-client-8.4  
sudo apt-get remove –purge postgresql-client-common  
apt-get clean\[/cc\]

still didn’t work.  
\[cc lang=’bash’ \]jcz@dell390:/usr/local/src/postgis-1.5.2$ ls -l /usr/bin/pg\*  
-rwxr-xr-x 1 root root 26260 2011-02-02 03:56 /usr/bin/pg  
-rwxr-xr-x 1 root root 25912 2011-04-20 10:27 /usr/bin/pg\_config  
-rwxr-xr-x 1 root root 13860 2010-07-06 20:21 /usr/bin/pgrep  
jcz@dell390:/usr/local/src/postgis-1.5.2$ sudo rm /usr/bin/pg\_config\[/cc\]

then  
\[cc lang=’bash’ \]sudo ln -s /usr/local/pgsql/bin/pg\_config /usr/bin/pg\_config  
apt-get install libxml2-dev\[/cc\]

and finally got  
\[cc lang=’bash’ \]PostGIS is now configured for i686-pc-linux-gnu

————– Compiler Info ————-  
C compiler: gcc -g -O2  
C++ compiler: g++ -g -O2

————– Dependencies ————–  
GEOS config: /usr/local/bin/geos-config  
GEOS version: 3.2.2  
PostgreSQL config: /usr/bin/pg\_config  
PostgreSQL version: PostgreSQL 9.0.4  
PROJ4 version: 47  
Libxml2 config: /usr/bin/xml2-config  
Libxml2 version: 2.7.7  
PostGIS debug level: 0

——– Documentation Generation ——–  
xsltproc:  
xsl style sheets:  
dblatex:  
convert: \[/cc\]

\[cc lang=’bash’ \]#!/bin/sh  
sudo ln -s /usr/local/pgsql/bin/createlang /usr/bin/createlang  
sudo ln -s /usr/local/pgsql/bin/dropdb /usr/bin/dropdb  
sudo ln -s /usr/local/pgsql/bin/initdb /usr/bin/initdb  
sudo ln -s /usr/local/pgsql/bin/pg\_ctl /usr/bin/pg\_ctl  
sudo ln -s /usr/local/pgsql/bin/createdb /usr/bin/createdb  
sudo ln -s /usr/local/pgsql/bin/createuser /usr/bin/createuser  
sudo ln -s /usr/local/pgsql/bin/pg\_dump /usr/bin/pg\_dump  
sudo ln -s /usr/local/pgsql/bin/pgsql2shp /usr/bin/pgsql2shp  
sudo ln -s /usr/local/pgsql/bin/pg\_upgrade /usr/bin/pg\_upgrade  
sudo ln -s /usr/local/pgsql/bin/shp2pgsql /usr/bin/shp2pgsql

/usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data  
/usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data &gt;logfile 2&gt;&amp;1 &amp;  
/usr/local/pgsql/bin/createdb test  
/usr/local/pgsql/bin/psql test

make  
make install  
createlang plpgsql yourtestdatabase  
psql -d yourtestdatabase -f postgis/postgis.sql  
psql -d yourtestdatabase -f spatial\_ref\_sys.sql\[/cc\]

how to generate a list of installed packages and use it to reinstall packages  
\[cc lang=’bash’ \]sudo apt-get update  
sudo apt-get dist-upgrade  
sudo dpkg –get-selections | grep -v deinstall | awk ‘{print $1}’ &gt; 164.ubuntu-files\_b.txt  
sudo cat 164.ubuntu-files\_b.txt | xargs sudo aptitude install\[/cc\]

NOTE: WordPress interprets two dashes (- -) as one dash (–). When you’re putting this into your CLI, make sure it’s dropping two dashes ‘- -’ without the space between them.

———————————————————————–

Update 20-Aug-2011

One liners install process instructions for Ubuntu 11

wget http://postgis.refractions.net/download/postgis-1.5.3.tar.gz  
wget  
wget http://download.osgeo.org/geos/geos-3.3.0.tar.bz2  
wget http://download.osgeo.org/proj/proj-4.7.0.tar.gz

<span style="color: #000000;"><span style="font-family: Nimbus Mono L,monospace;"><span style="font-size: x-small;">sudo apt-get install libreadline6-dev zlib1g-dev libxml2 libxml2-dev bison openssl libssl-dev  
sudo apt-get yum install -y  
</span></span></span>

<span style="color: #000000;"><span style="font-family: Nimbus Mono L,monospace;"><span style="font-size: x-small;">  
<span style="color: #000000;"><span style="font-family: Nimbus Mono L,monospace;"><span style="font-size: x-small;">mkdir -p /usr/local/src</span></span></span></span></span></span>

<span style="color: #000000;"><span style="font-family: Nimbus Mono L,monospace;"><span style="font-size: x-small;"><span style="color: #000000;"><span style="font-family: Nimbus Mono L,monospace;"><span style="font-size: x-small;">cd /usr/local/src</span></span></span></span></span></span>

<span style="color: #000000;"><span style="font-family: Nimbus Mono L,monospace;"><span style="font-size: x-small;"><span style="color: #000000;"><span style="font-family: Nimbus Mono L,monospace;"><span style="font-size: x-small;">tar zxvf postgresql-8.3.7.tar.gz</span></span></span></span></span></span>

<span style="color: #000000;"><span style="font-family: Nimbus Mono L,monospace;"><span style="font-size: x-small;"><span style="color: #000000;"><span style="font-family: Nimbus Mono L,monospace;"><span style="font-size: x-small;">cd postgresql-8.3.7</span></span></span></span></span></span>

<span style="color: #000000;"><span style="font-family: Nimbus Mono L,monospace;"><span style="font-size: x-small;">./configure –with-openssl –enable-integer-datetimes</span></span></span>

make

make install

<span style="color: #000000;"><span style="font-family: Nimbus Mono L,monospace;"><span style="font-size: x-small;">cd /usr/local/src/postgresql-8.3.7/contrib/</span></span></span>

make all

make install

<span style="color: #000000;"><span style="font-family: Nimbus Mono L,monospace;"><span style="font-size: x-small;">cp /usr/local/src/postgresql-8.3.7/contrib/start-scripts/linux /etc/init.d/postgresql</span></span></span>

<span style="color: #000000;"><span style="font-family: Nimbus Mono L,monospace;"><span style="font-size: x-small;">chmod 775 /etc/init.d/postgresql</span></span></span>

<span style="color: #000000;"><span style="font-family: Nimbus Mono L,monospace;"><span style="font-size: x-small;">update-rc.d /etc/init.d/postgresql defaults</span></span></span>

<span style="color: #000000;"><span style="font-family: Nimbus Mono L,monospace;"><span style="font-size: x-small;">adduser postgres -d /usr/local/pgsql</span></span></span>

<span style="color: #000000;"><span style="color: #000000;"><span style="font-family: Nimbus Mono L,monospace;"><span style="font-size: x-small;">echo ‘PATH=$PATH:/usr/local/pgsql/bin; export PATH’ &gt; /etc/profile.d/postgresql.sh  
echo ‘MANPATH=$MANPATH:/usr/local/pgsql/man; export MANPATH &gt;&gt; /etc/profile.d/pgmanual.sh</span></span></span></span>

chmod 775 /etc/profile.d/postgresql.sh  
chmod 775 /etc/profile.d/pgmanual.sh

<span style="color: #000000;"><span style="color: #000000;"><span style="font-family: Nimbus Mono L,monospace;"><span style="font-size: x-small;">mkdir -p /var/log/pgsql  
chown -R postgres:postgres /var/log/pgsql/</span></span></span></span>

<span style="color: #000000;"><span style="color: #000000;"><span style="font-family: Nimbus Mono L,monospace;"><span style="font-size: x-small;">mkdir /usr/local/pgsql/data</span></span></span></span>

<span style="color: #000000;"><span style="color: #000000;"><span style="font-family: Nimbus Mono L,monospace;"><span style="font-size: x-small;">chown -R postgres:postgres /usr/local/pgsql/data</span></span></span></span>

<span style="color: #000000;"><span style="color: #000000;"><span style="font-family: Nimbus Mono L,monospace;"><span style="font-size: x-small;">su – postgres</span></span></span></span>

<span style="color: #000000;"><span style="color: #000000;"><span style="font-family: Nimbus Mono L,monospace;"><span style="font-size: x-small;">/usr/local/pgsql/bin/initdb -U postgres -E=UTF8 /usr/local/pgsql/data</span></span></span></span>

<span style="color: #000000;">These steps should be done as the postgres user. As root, issue: `su – postgres` (no password needed)</span>, t<span style="color: #000000;">he postgresql.conf and pg\_hba.conf configuration files are located in /usr/local/pgsql/data/</span>

<span style="color: #000000;">Using the ‘[nano](http://www.nano-editor.org/dist/v1.2/nano.1.html)‘ editor, (or vi), modify the postgresql.conf to allow the installation to listen for remote connections. Also, while we’re in here let’s configure the logging to create the log file in /var/log/pgsql/. The main cause of not being able to connect to a PostgreSQL database is because of a misconfiguration in this file.</span>

<span style="color: #000000;"><span style="color: #000000;"><span style="font-family: Nimbus Mono L,monospace;"><span style="font-size: x-small;"> listen\_addresses = ‘\*’  
port = 5432  
log\_destination = ‘stderr’  
logging\_collector = on  
log\_directory = ‘/var/log/pgsql/’  
log\_filename = ‘postgresql-%Y-%m-%d’  
log\_line\_prefix = ‘ %t %d %u ‘</span></span></span></span>

<span style="color: #000000;">Now, edit the pg\_hba.conf and configure some network rules. Add the line in <span style="color: #ff0000;">red</span> to match your LAN address range. Set access from other computers to use [md5 authentication](http://en.wikipedia.org/wiki/MD5). You can also set the other methods to md5, (and others) but for managability, leave the local connections set to ‘trust’ for now. The order of rules in this file matters.</span>

<span style="color: #000000;"><span style="color: #000000;"><span style="font-family: Nimbus Mono L,monospace;"><span style="font-size: x-small;">\# TYPE DATABASE USER CIDR-ADDRESS METHOD  
\# “local” is for Unix domain socket connections only  
local all all trust  
\# IPv4 local connections:  
host all all 127.0.0.1/32 trust  
<span style="color: #ff0000;">host all all 192.168.0.0/24 md5</span>  
\# IPv6 local connections:  
host all all ::1/128 trust </span></span></span></span>

<span style="color: #000000;"><span style="color: #000000;"><span style="font-family: Nimbus Mono L,monospace;"><span style="font-size: x-small;">/etc/init.d/postgresql start</span></span></span></span>

<div class="zemanta-pixie">![](http://img.zemanta.com/pixy.gif?x-id=37c7bedc-c127-8b4e-b541-1b99f5be40a5)</div>