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

Updated notes for installing PostGIS on Ubuntu 24.04 systems with .deb packages.

### Manual Repository Configuration
Install the latest PostGIS on Ubuntu by adding the PostgreSQL Global Development Group (PGDG) repository. 

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
```

### PostGIS Installation
To install PostGIS, you can use the following command:

```bash
sudo apt install postgresql-17 postgresql-17-postgis-3 postgresql-17-postgis-3-scripts
```
### PostgreSQL User and Database Configuration
After installing PostGIS, you need to configure it for your PostgreSQL database. First, ensure that you have a PostgreSQL user and database set up. You can create a new user and database with the following commands:


```bash
sudo -u postgres createuser spatial_user -P
sudo -u postgres createdb mydatabase -O spatial_user
```
Replace `spatial_user` with your desired username and `mydatabase` with your desired database name. The `-P` option will prompt you to set a password for the user.

### Create a schema for PostGIS

In Postgres, schemas live as a sub-container in the database. The public schema is always there, but we recommend using named schemas for better isolation (security) and ease of separately backing up 


```bash
sudo -u postgres psql -d mydatabase -c "CREATE SCHEMA myschema;"
```
Replace `myschema` with the name of your schema.


To grant permissions to the spatial user, run the following commands:
```sql
psql mydatabase -c "GRANT ALL PRIVILEGES ON DATABASE mydatabase TO spatial_user;" 
psql mydatabase -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA myschema TO spatial_user;" 
psql mydatabase -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA myschema TO spatial_user;" 
```

#### Create a new linux user and let that user drive postgres

```bash
sudo adduser spatial_user
```


### Create a Linux User and Add to PostgreSQL Group
To create a Linux user that can manage PostgreSQL, you can follow these steps:
```bash
sudo adduser spatial_user
sudo usermod -aG postgres spatial_user
```

### Alter a PostgreSQL User to have Superuser Privileges
To create a Linux user that can run commands with superuser privileges, you can follow these steps.

Log back into postgres and set the user we made before in postgres to be a super user

```sql
sudo su - postgres
psql
-- ALTER USER spatial_user WITH PASSWORD 'new_password'; -- This is needed if you didn't set -- the right password above
ALTER USER spatial_user WITH SUPERUSER;

```
### Enable PostGIS (and topology) in Your Database
To enable PostGIS in your PostgreSQL database, you need to run the following commands:

```bash
sudo -u postgres psql -d mydatabase -c "CREATE EXTENSION postgis;"
sudo -u postgres psql -d mydatabase -c "CREATE EXTENSION postgis_topology;"
```

Replace `mydatabase` with the name of your database. This will enable the PostGIS extension and the PostGIS topology extension in your database.


### Verify PostGIS Installation

To verify that PostGIS has been successfully installed and configured, run the following commands:
```bash
psql mydatabase -c "SELECT PostGIS_version();" 
psql mydatabase -c "SELECT * from information_schema.schemata;"
```

This should return the version of PostGIS that you have installed.

```bash
sudo -u postgres createdb mydatabase -T template_postgis
```
- Replace `mydatabase` with the name of your database.



### Let PostgreSQL listen to everyone (allow remote connections)

Do this only on your protected intranet or if you know what you are doing. It will let world see your database!

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

Sometimes we install and use [webmin](https://webmin.com/) but then shut it down as it's a powerful tool for hackers... and you.

```bash 
curl -o webmin-setup-repo.sh https://raw.githubusercontent.com/webmin/webmin/master/webmin-setup-repo.sh
sh webmin-setup-repo.sh
```


### Update PostgreSQL Config for your Rig

Calculate sane starting configs for postgres using
PGTune - https://pgtune.leopard.in.ua/ to calculate configuration for PostgreSQL based on the maximum performance for a given hardware configuration

 
Here's one for a tiny Nano VM at Linode. Stick this in postgresql.conf in /etc

```bash
Comment existing values for these. Listen address lets the world talk to postgres
# DB Version: 17
# OS Type: linux
# DB Type: dw
# Total Memory (RAM): 1 GB
# CPUs num: 1
# Connections num: 20
# Data Storage: ssd
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

### Running PostgreSQL - finish this section
- Make sure that your PostgreSQL service is running. You can check its status with:
```bash
sudo systemctl status postgresql
```
- If you encounter any issues, check the PostgreSQL logs for more information. The logs are usually located in `/var/log/postgresql/`.
- If you need to create a new database with PostGIS enabled, you can do so with the following command, assuming the template has postgis installed into it:

### Restart PostgreSQL Service
After making changes to the configuration files, you need to restart the PostgreSQL service for the changes to take effect:

```bash
sudo systemctl restart postgresql
```


### Installing PGAdmin4 - finish this section
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

