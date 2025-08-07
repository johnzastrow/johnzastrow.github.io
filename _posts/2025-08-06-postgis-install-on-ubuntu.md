---
title: 'PostGIS Install on Ubuntu Systems Notes'
date: '2025-08-06T15:02:15-05:00'
author: 'John C. Zastrow'
layout: post
categories:
    - Database
    - Linux
    - GIS
---

Updated notes for installing PostGIS on Ubuntu 24.04 systems.
The next step is to add the Postgresql repository to your system.

### Manual Repository Configuration
To install PostGIS on Ubuntu, you need to add the PostgreSQL Global Development Group (PGDG) repository. This is necessary because the default Ubuntu repositories may not have the latest version of PostGIS.

Create /etc/apt/sources.list.d/pgdg.list. The distributions are called codename-pgdg. In the example, replace bookworm with the actual distribution you are using. 24.04 = noble

```bash
. /etc/os-release
sudo sh -c "echo 'deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $VERSION_CODENAME-pgdg main' >> /etc/apt/sources.list.d/pgdg.list"

sudo apt update
sudo apt upgrade

sudo apt install curl ca-certificates
sudo install -d /usr/share/postgresql-common/pgdg
# Add the PostgreSQL signing key
sudo apt install gnupg

sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc

sudo apt install postgresql-17 postgresql-17-postgis-3 postgresql-17-postgis-3-scripts
```

### PostGIS Installation
To install PostGIS, you can use the following command:

```bash
sudo apt install postgis postgresql-17-postgis-3
```
### PostGIS Configuration

### PostgreSQL User and Database Configuration
After installing PostGIS, you need to configure it for your PostgreSQL database. First, ensure that you have a PostgreSQL user and database set up. You can create a new user and database with the following commands:


```bash
sudo -u postgres createuser myuser -P
sudo -u postgres createdb mydatabase -O myuser
```
Replace `myuser` with your desired username and `mydatabase` with your desired database name. The `-P` option will prompt you to set a password for the user.

### Create a schema for PostGIS


```bash
sudo -u postgres psql -d mydatabase -c "CREATE SCHEMA myschema;"
```
Replace `myschema` with the name of your schema.


To grant permissions to the spatial user, run the following commands:
```bash
psql mydatabase -c "GRANT ALL PRIVILEGES ON DATABASE mydatabase TO spatial_user;" 
psql mydatabase -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA myschema TO spatial_user;" 
psql mydatabase -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA myschema TO spatial_user;" 
```

#### Create a new linux user and let that user drive postgres

```bash
sudo adduser spatial_user
```

### Create a PostgreSQL User with Superuser Privileges

To create a PostgreSQL user with superuser privileges, you can follow these steps:

```bash
sudo su - postgres
psql
CREATE USER spatial_user WITH SUPERUSER PASSWORD 'new_password';
```

This command creates a new PostgreSQL user named `spatial_user` with superuser privileges and sets the password to `new_password`. Make sure to replace `new_password` with a secure password of your choice.


### Create a Linux User and Add to PostgreSQL Group
To create a Linux user that can manage PostgreSQL, you can follow these steps:
```bash
sudo adduser spatial_user
sudo usermod -aG postgres spatial_user
```

### Create a Linux User and Add to Sudo Group
To create a Linux user that can run commands with superuser privileges, you can follow these steps:
```bash

adduser spatial_user
sudo usermod -aG sudo spatial_user

Log back into postgres and set the user we made before in postgres to be a super user

sudo su - postgres
psql
ALTER USER spatial_user WITH PASSWORD 'new_password';
ALTER USER spatial_user WITH SUPERUSER;

Now we need to let postgres listen to the world 

### Enable PostGIS in Your Database
To enable PostGIS in your PostgreSQL database, you need to run the following commands:

```bash
sudo -u postgres psql -d mydatabase -c "CREATE EXTENSION postgis;"
sudo -u postgres psql -d mydatabase -c "CREATE EXTENSION postgis_topology;"
```
Replace `mydatabase` with the name of your database. This will enable the PostGIS extension and the PostGIS topology extension in your database.


### Verify Installation
To verify that PostGIS is installed correctly, you can run the following command:


To verify that PostGIS has been successfully installed and configured, run the following command:
```bash
psql mydatabase -c "SELECT PostGIS_version();" 
SELECT * from information_schema.schemata;
```

This should return the version of PostGIS that you have installed.

### Additional Notes
- Make sure that your PostgreSQL service is running. You can check its status with:
```bash
sudo systemctl status postgresql
```
- If you encounter any issues, check the PostgreSQL logs for more information. The logs are usually located in `/var/log/postgresql/`.
- If you need to create a new database with PostGIS enabled, you can do so with the following command:

```bash
sudo -u postgres createdb mydatabase -T template_postgis
```
- Replace `mydatabase` with the name of your database.


### Intalling PGAdmin4
To install PGAdmin4, you can follow these steps:

```bash
#
# Setup the repository
#

# Install the public key for the repository (if not done previously):
curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg

# Create the repository configuration file:
sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'

#
# Install pgAdmin
#

# Install for both desktop and web modes:
sudo apt install pgadmin4

# Install for desktop mode only:
sudo apt install pgadmin4-desktop

# Install for web mode only: 
sudo apt install pgadmin4-web 

# Configure the webserver, if you installed pgadmin4-web:
sudo /usr/pgadmin4/bin/setup-web.sh

```

Now we need to let postgres listen to the world 

We'll use webmin, but then shut it down.

curl -o webmin-setup-repo.sh https://raw.githubusercontent.com/webmin/webmin/master/webmin-setup-repo.sh
sh webmin-setup-repo.sh
 

Update config based on VM using
PGTune - calculate configuration for PostgreSQL based on the maximum performance for a given hardware configuration

 

Here's one for Nano VM at Linode. Stick this in postgresql.conf in /etc

Comment existing values for these. Listen address lets the world talk to postgres
# DB Version: 17
# OS Type: linux
# DB Type: dw
# Total Memory (RAM): 1 GB
# CPUs num: 1
# Connections num: 20
# Data Storage: ssd
 
```bash
listen_addresses = '*'          # what IP address(es) to listen on;
max_connections = 20
shared_buffers = 256MB
effective_cache_size = 768MB
maintenance_work_mem = 128MB
checkpoint_completion_target = 0.9
wal_buffers = 7864kB
default_statistics_target = 500
random_page_cost = 1.1
effective_io_concurrency = 200
work_mem = 4681kB
huge_pages = off
min_wal_size = 4GB
max_wal_size = 16GB
```
### Allow Remote Connections
To allow remote connections to your PostgreSQL database, you need to modify the `pg_hba.conf` file. This file controls client authentication and access permissions.
```bash
nano pg_hba.conf
```



    then put in the following value
```bash
# TYPE  DATABASE        USER            ADDRESS                 METHOD
host    all     all     0.0.0.0/0       md5
```
This line allows all users to connect to all databases from any IP address using MD5 password authentication. Adjust the `ADDRESS` field as necessary for your security requirements.
### Restart PostgreSQL Service
After making changes to the configuration files, you need to restart the PostgreSQL service for the changes to take effect:

```bash

    
sudo systemctl restart postgresql