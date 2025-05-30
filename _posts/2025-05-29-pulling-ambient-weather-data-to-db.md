---
layout: post
title: Downloading Ambient Weather Station Data into MariaDB/MySQL
subtitle: A python script
gh-badge: [star, fork, follow]
date: '2025-05-29T12:47:41-05:00'
tags: [database, data management, python, MariaDB, MySQL, Weather]
comments: true
---


I bought an [Ambient Weather WS-2902 Home Wi-Fi Weather Station with Wi-Fi Remote Monitoring and Alerts](https://ambientweather.com/ws-2902-smart-weather-station) as an entry level station that I could use to log my own data from. Unfortunately it seems the data has to go to the cloud before you can grab it.

I found this PHP script somewhere (can't recall where now) which I then asked Mr. Copilot to convert python (below). I hope this helps you. Both scripts load data into a table structure exactly as shown at the bottom.

```php
<?php
//php 5.6 compatible
$debug = true;  //until this runs smoothly, look at system emails to get details if running in crontab

// this script needs php8.1-curl installed to work as well

// MAC Address:C8:C9:A3:16:B8:XX
// API Key: b3c0c4cbe4af495dbdb5597d72d5a7d6a6516aa76c874edaa1aee8a7acaeb4XX
// Application Key: 49cc82371bb4405b8f94442ed7aea30aa08d41cbe7af40a98994f0916116a9XX

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

//set this to your timezone
date_default_timezone_set('America/New_York');

//enter your Ambient api key and app key information
$site['AWNdid']   = 'id'; // your xx:xx:xx:xx:xx:xx device ID on Ambientweather.net
$site['AWNkey']   = 'apikey';    //apiKey - request this from Ambient
$site['SWXAWNAPPID'] = 'appkey';  //applicationKey - request this from Ambient

//set your mysql database variables
$hostname = 'IP or hostname'; //usually localhost
$database = 'weather';
$password = 'password';
$username = 'user';
$table = 'zastmet';  
   
//connect to mysql
$link = mysqli_connect($hostname, $username, $password, $database);
if($link === false){ die("ERROR: Could not connect. " . mysqli_connect_error()); }

//get unix timestamp for last entry
$sql_last = 'SELECT dateutc FROM `'.$table.'` WHERE dateutc=(SELECT MAX(dateutc) FROM `'.$table.'`);';
$result = mysqli_query($link,$sql_last); 
$row = mysqli_fetch_array($result);
$last_update = $row['dateutc'];
date_default_timezone_set('UTC');  //I think time() is the unix timestamp independant of timezone, but just to be sure . . . ) AW stores timestamps UTC
$now = time();
date_default_timezone_set('America/New_York'); //now switch it back

$limit = floor( ($now - $last_update)/300 );  //database has a new record every 300 seconds
if ($limit > 288) {$limit = 288;}  //max number of records
if ($limit == 0) { 
    echo "\nThere is no time gap in the database presently, ending script.<br> \n";
    exit();
}
$end_date = time()*1000;              // UTC by default and the timestamp is in microseconds on the Ambient server

/////////////////////////////////////////////////////////
///////////// URLs from AW to get data //////////////////
/////////////////////////////////////////////////////////

// Provides a list of the user's available devices along with each device's most recent data.
$AWNDEVurl = 'https://api.ambientweather.net/v1/devices/'.
             '?applicationKey='.$site['SWXAWNAPPID'].
             '&apiKey='.$site['AWNkey'];
//We won't use this, but I put it in here in case I want it later

// Fetch data for a given device. Data is stored in 5 or 30 minute increments.
// https://api.ambientweather.net/v1/devices/macAddress?apiKey=&applicationKey=&endDate=&limit=288
$AWNurl = 'https://api.ambientweather.net/v1/devices/'.$site['AWNdid']. 
    '?applicationKey='.$site['SWXAWNAPPID'].
		'&apiKey='.$site['AWNkey'];
$AWNurl = $AWNurl.'&endDate='.$end_date;
$AWNurl = $AWNurl.'&limit='.$limit;

echo 'URL to fetch is :'.$AWNurl.'<br><br>';
if ($debug) {
    echo "\nThe last row in the MySQL database is from: ".date('g:ia jS F Y', $last_update )."<br> \n";
    echo "Current system time is: ".date('g:ia jS F Y', $now )."<br> \n";
    echo "Thus, we will be trying to add ".$limit." records to the MySQL database.<br> \n";
}

// FROM AW DOCUMENTATION:
//A list of all possible fields is here: 
//   https://github.com/ambient-weather/api-docs/wiki/Device-Data-Specs

// QUERY DEVICE DATA:
//https://api.ambientweather.net/v1/devices/macAddress?apiKey=&applicationKey=&endDate=&limit=288

//      endDate = 
//          The most recent datetime. Results descend from there. 
//          If left blank, the most recent results will be returned. 
//          Date format should be in milliseconds since the epoch or 
//          string representations outlined here: 
//          https://momentjs.com/docs/#/parsing/string/
//          Note: datetimes are stored in UTC.

//      limit = 
//          The maximum number of results to return (max: 288) Default: 288.


list($RC,$data) = AWN_fetchData($AWNurl); // do the data fetch 

if($RC == 0 || $RC == 429) {
    if ($debug) { 
        echo "\nDid not get any data - RC = ".$RC.". Exiting script\n"; 
    }
    exit();
    $weather_dataJSON = '';
}
elseif($RC == 200) {
    $weather_dataJSON = json_decode($data, true); //this means we got data y'all!!
} 
elseif ($RC = 401 || $RC = 404) {
		//$json = json_decode($content);
    if ($debug) { 
        print "\nError: Ambientweather.net returns ERROR: ".$RC.". Exiting script\n"; 
    }
    exit();
    $weather_dataJSON = '';
}
else {
    if ($debug) {echo "\nAWN_fetchData error, RC = ".$RC." on fetch of ".$AWNurl.". Exiting script\n"; }
    exit();
    $weather_dataJSON = ''; 
}

if($weather_dataJSON){   //assuming we got weather data back...use the first array data set to get the data names. That way if a weather sensor is not reporting, we don't get a row mismatch error from mysql
    $sql = 'INSERT IGNORE INTO '.$table.' (';  //We're building the mysql insert statement!!!
    foreach ($weather_dataJSON[0] as $server_column_name=>$server_value ) {  //use the first data set to get this info
        $server_columns_arr[] = $server_column_name;   //we'll need an array of the data headings to call the actual values from the data arrays later. . .
        $sql = $sql.' '.$server_column_name.',';   //and adding column names to the statement
        
        // comment below out after debugging
        // echo "<br>\n Server Column Names: ".$server_column_name." <br>\n";
    }
    $sql = rtrim($sql, ',');      // get rid of that last comma to avoid an error . . . .
    $sql = $sql.') ';             // and close the parenthesis
}

if($weather_dataJSON){
    $sql = $sql.'VALUES ';
    $data_set_counter = 0;
    //if ($debug) { echo "\nEnding date/time for the data we got = ".date('g:ia \o\n l jS F Y', ($weather_dataJSON[0]['dateutc']/1000) )." \n"; }
    foreach ($weather_dataJSON as $key=>$data_arr) {     //here $key is going to be an integer
        $date = ($data_arr['dateutc']/1000) - 25200;
        $date = ($data_arr['dateutc']/1000);
        $date = date('g:ia \o\n l jS F Y', $date);
        //echo '<p>At '.$date.':<br>';
        $sql = $sql.' (';
        //foreach ($data_arr as $measure=>$value){
        foreach ($server_columns_arr as $value){     //loop through the keys of the data we got from the server
            //if($measure == 'date' || $measure == 'lastRain' ) {
            if($value == 'date' || $value == 'lastRain' ) {
                //$value = str_replace('T', ' ', $value);
                //$value = str_replace('.000Z', '', $value);
                //$value = '\''.$value.'\'';
                $data_arr[$value] = str_replace('T', ' ', $data_arr[$value]);  //make date into a mysql format
                $data_arr[$value] = str_replace('.000Z', '', $data_arr[$value]);  //make date into a mysql format
                $data_arr[$value] = '\''.$data_arr[$value].'\''; //escape the quotes
                //probably should mysqli_real_escape_string this stuff . . .
            }
            if($value == 'loc') { $data_arr[$value] = '\''.$data_arr[$value].'\'';}
            if($value == 'dateutc') { $data_arr[$value] = $data_arr[$value]/1000;}

            // comment line below when not testing
           // echo $value.' = '.$data_arr[$value].', ';
            $sql = $sql.' '.$data_arr[$value].',';
        } 
        $sql = rtrim($sql, ',');      // get rid of that last comma to avoid an error . . . .     
        $sql = $sql.'),';
        $data_set_counter++;
        //echo '</p>';       
    }
    $sql = rtrim($sql, ',');      // get rid of that last comma to avoid an error . . . .     
}
if ($debug) { echo "\nWith api limit set to ".$limit.", API rest call sent us ".$data_set_counter." records in total \n"; }
$last = count($weather_dataJSON)-1;
if ($debug) { 
    echo "\nStarting date/time for the API data we got = ".date('g:ia jS F Y', ($weather_dataJSON[$last]['dateutc']/1000) )." \n"; 
    echo "Ending date/time for the API data we got = ".date('g:ia jS F Y', ($weather_dataJSON[0]['dateutc']/1000) )." \n";
}
// debug statement
echo '<br><br><br><br>MySQL statement =<br><br>'.$sql;

if (mysqli_query($link, $sql)) {
    if ($debug) { echo "\nMySQL query: ".mysqli_affected_rows($link)." new rows added successfully. \n"; }
} 
else {
    if ($debug) { echo "\nError: ".$sql."<br>".mysqli_error($link)." \n"; }
}

//see if there is a data gap > 7 minutes in the data stream
//$last_update = $row['dateutc']; //remember this from above?
$first_record_added = $weather_dataJSON[$last]['dateutc']/1000;
$data_gap = $first_record_added - $last_update;
if($data_gap < 430) {
    if ($debug) {
        echo "\nData appears to be in continuity - time gap between the last record on the database and the new added data rows is ".$data_gap." seconds. (".($data_gap/60)." minutes). \n\n\n"; 
    }
}
else {
    if ($debug) {
        echo "\nThere may be a data continuity issue, the time gap was '.$data_gap.' You may want to check data. \n\n\n"; 
    }
}

mysqli_close($link); //close it down, nuthin' to see here . . .
////////////////////////////////////////////////////////////
////////////////////////// FUNKSHINS ///////////////////////
////////////////////////////////////////////////////////////


function AWN_fetchData($AWNurl) {
    $numberOfSeconds = 3; //you may have to futz with this depending on your server connectivity
    $ch = curl_init();    
    curl_setopt($ch, CURLOPT_URL, $AWNurl); // connect to provided URL
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0); // don't verify peer certificate
    curl_setopt($ch, CURLOPT_USERAGENT, 'horca.net');   
    curl_setopt($ch, CURLOPT_HTTPHEADER, array( "Accept: text/plain,application/json" ) ); // request LD-JSON format :
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true); // return the data transfer
    curl_setopt($ch, CURLOPT_NOBODY, false); // set nobody
    curl_setopt($ch, CURLOPT_HEADER, FALSE);
    curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, $numberOfSeconds); //  connection timeout
    curl_setopt($ch, CURLOPT_TIMEOUT, $numberOfSeconds); //  data timeout
        
    $data = curl_exec($ch); // execute session
    $cinfo = curl_getinfo($ch); // get info on curl exec. 
    if(isset($cinfo['http_code'])) { $RC = $cinfo['http_code']; } 
    else { $RC = 0; }
    $to_return = array($RC,$data);    
    curl_close($ch);    
    return $to_return; 
}

// Table Design. The table needs to be very bare (columns must match JSON keys, all columns must be nullable
// triggers broke my arrays for some reason) for the SQL to work. Use a view on the table to get fancy.

/* CREATE TABLE `zastmet` (
    `dateutc` bigint(20) DEFAULT NULL,
    `tempf` double DEFAULT NULL,
    `humidity` double DEFAULT NULL,
    `windspeedmph` double DEFAULT NULL,
    `windgustmph` double DEFAULT NULL,
    `maxdailygust` double DEFAULT NULL,
    `winddir` double DEFAULT NULL,
    `uv` double DEFAULT NULL,
    `solarradiation` double DEFAULT NULL,
    `hourlyrainin` double DEFAULT NULL,
    `eventrainin` double DEFAULT NULL,
    `dailyrainin` double DEFAULT NULL,
    `weeklyrainin` double DEFAULT NULL,
    `monthlyrainin` double DEFAULT NULL,
    `yearlyrainin` double DEFAULT NULL,
    `totalrainin` double DEFAULT NULL,
    `battout` double DEFAULT NULL,
    `tempinf` double DEFAULT NULL,
    `humidityin` double DEFAULT NULL,
    `baromrelin` double DEFAULT NULL,
    `baromabsin` double DEFAULT NULL,
    `feelsLike` double DEFAULT NULL,
    `dewPoint` double DEFAULT NULL,
    `feelsLikein` double DEFAULT NULL,
    `dewPointin` double DEFAULT NULL,
    `lastRain` timestamp NULL ,
    `date` timestamp NULL DEFAULT '0000-00-00 00:00:00',
    -- uniq key to keep dupes out
    UNIQUE KEY `uniq_recs` (`dateutc`,`tempf`,`humidity`,`windspeedmph`,`windgustmph`)
  )  */

?>
```

and now the python version

```python
#!/usr/bin/env python3
"""
errors on 5/7

The error AttributeError: module 'time' has no attribute 'tzset' arises
because the time.tzset() function is not available on all
operating systems. Specifically, it is typically found on Unix-like
systems (e.g., Linux, macOS) but not on Windows. This function is used to
change the time zone settings.


Alternative Libraries: Use libraries like pytz or datetime for time zone handling,
as they offer cross-platform compatibility.

Python

import datetime
import pytz

timezone = pytz.timezone('America/Los_Angeles')
datetime_object = datetime.datetime.now(timezone)
print(datetime_object.strftime("%Y-%m-%d %H:%M:%S %Z%z"))


Ambient Weather Data Fetcher and Database Writer
===============================================

This script fetches weather data from the Ambient Weather API and stores it in a MariaDB database.
It is a Python equivalent of a PHP script that performs the same function.

Summary of Operations:
---------------------
1. Connects to a MariaDB database to find the timestamp of the most recent weather record
2. Calculates how many new records need to be fetched (based on 5-minute intervals)
3. Constructs an API request to the Ambient Weather API
4. Fetches the weather data in JSON format
5. Processes the data, including converting timestamps and formatting field values
6. Constructs and executes an SQL INSERT statement to add the new records to the database
7. Checks for data continuity by examining time gaps between records
8. Logs all operations, errors, and warnings to a log file

The script maintains the same functionality as the original PHP implementation while adding
robust error handling and comprehensive logging capabilities.

Requirements:
------------
- Python 3.6 or later (compatible up to 3.12)
- Required packages: requests, mysql-connector-python
- Network access to Ambient Weather API
- Write access to a MariaDB/MySQL database
- Permissions to create log files in the script directory

Configuration:
-------------
- API credentials are defined in the 'site' dictionary
- Database connection parameters are defined in 'db_config'
- Debug mode can be enabled/disabled with the 'debug' variable
- Logging is always enabled and rotates files when they reach size limits

Compatible with Python 3.12 or earlier
"""


# pip install requests mysql-connector-python mysql-connector

import requests
import mysql.connector
import time
import datetime
import logging
from logging.handlers import RotatingFileHandler
import os
import sys

# Configure logger
log_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), "ambient.log")
logging.basicConfig(
    handlers=[RotatingFileHandler(log_file, maxBytes=10485760, backupCount=5)],
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)
logger = logging.getLogger(__name__)

# Debug mode - set to True for detailed output
debug = True

# Set timezone to America/New_York
os.environ["TZ"] = "America/New_York"
time.tzset()

# Ambient Weather API credentials
site = {
    "AWNdid": "id",  # MAC Address
    "AWNkey": "apikey",  # API Key
    "SWXAWNAPPID": "app id",  # Application Key
}

# MySQL database configuration
db_config = {
    "host": "ip or hostname",
    "database": "weather",
    "user": "user",
    "password": "password",
    "table": "zastmet",
}


def fetch_weather_data(url, timeout=3):
    """
    Fetch data from Ambient Weather API

    Args:
        url (str): The URL to fetch data from
        timeout (int): Timeout in seconds for the request

    Returns:
        tuple: (status_code, data)
    """
    try:
        headers = {"User-Agent": "horca.net", "Accept": "text/plain,application/json"}

        response = requests.get(url, headers=headers, timeout=timeout, verify=False)
        return response.status_code, (
            response.json() if response.status_code == 200 else response.text
        )
    except Exception as e:
        logger.error(f"Error fetching data: {str(e)}")
        return 0, str(e)


def main():
    """Main function to fetch and store weather data"""
    try:
        # Connect to MySQL database
        connection = mysql.connector.connect(
            **{k: v for k, v in db_config.items() if k != "table"}
        )
        cursor = connection.cursor(dictionary=True)

        if connection.is_connected():
            logger.info("Connected to MySQL database")
            if debug:
                print("Connected to MySQL database")

        # Get the latest record timestamp from database
        table = db_config["table"]
        sql_last = f"SELECT dateutc FROM `{table}` WHERE dateutc=(SELECT MAX(dateutc) FROM `{table}`)"
        cursor.execute(sql_last)
        row = cursor.fetchone()

        if row is None:
            logger.warning("No existing records found in database")
            last_update = 0
        else:
            last_update = row["dateutc"]

        # Get current timestamp (UTC)
        now = int(time.time())

        # Calculate how many records to fetch (every 5 minutes = 300 seconds)
        limit = min(288, (now - last_update) // 300)

        if limit == 0:
            msg = "There is no time gap in the database presently, ending script."
            if debug:
                print(msg)
            logger.info(msg)
            return

        # Current time in milliseconds (for API)
        end_date = int(time.time() * 1000)

        # Construct the API URL
        awn_url = (
            f"https://api.ambientweather.net/v1/devices/{site['AWNdid']}"
            f"?applicationKey={site['SWXAWNAPPID']}"
            f"&apiKey={site['AWNkey']}"
            f"&endDate={end_date}"
            f"&limit={limit}"
        )

        if debug:
            print(f"URL to fetch is: {awn_url}")
            print(
                f"The last row in the MySQL database is from: {datetime.datetime.fromtimestamp(last_update).strftime('%I:%M%p %d %B %Y')}"
            )
            print(
                f"Current system time is: {datetime.datetime.fromtimestamp(now).strftime('%I:%M%p %d %B %Y')}"
            )
            print(
                f"Thus, we will be trying to add {limit} records to the MySQL database."
            )

        logger.info(f"Attempting to fetch {limit} records from Ambient Weather API")

        # Fetch the data
        status_code, data = fetch_weather_data(awn_url)

        if status_code == 0 or status_code == 429:
            msg = f"Did not get any data - Status Code = {status_code}. Exiting script"
            if debug:
                print(msg)
            logger.error(msg)
            return

        elif status_code == 401 or status_code == 404:
            msg = f"Error: Ambientweather.net returns ERROR: {status_code}. Exiting script"
            if debug:
                print(msg)
            logger.error(msg)
            return

        elif status_code != 200:
            msg = f"AWN_fetchData error, Status Code = {status_code} on fetch of {awn_url}. Exiting script"
            if debug:
                print(msg)
            logger.error(msg)
            return

        if not data or len(data) == 0:
            msg = "No data returned from API"
            if debug:
                print(msg)
            logger.warning(msg)
            return

        # Process the data
        # First, prepare column names for SQL insert
        columns = list(data[0].keys())

        # Build SQL insert statement
        sql = f"INSERT IGNORE INTO {table} ("
        sql += ", ".join(columns)
        sql += ") VALUES "

        # Prepare values for each record
        value_lists = []
        for record in data:
            # Process specific fields
            if "date" in record:
                record["date"] = record["date"].replace("T", " ").replace(".000Z", "")

            if "lastRain" in record:
                record["lastRain"] = (
                    record["lastRain"].replace("T", " ").replace(".000Z", "")
                )

            if "dateutc" in record:
                record["dateutc"] = int(
                    record["dateutc"] / 1000
                )  # Convert to unix timestamp

            # Format values for SQL
            values = []
            for col in columns:
                if col in ("date", "lastRain", "loc") and record[col] is not None:
                    values.append(f"'{record[col]}'")
                elif record[col] is None:
                    values.append("NULL")
                else:
                    values.append(str(record[col]))

            value_lists.append(f"({', '.join(values)})")

        # Complete the SQL statement
        sql += ", ".join(value_lists)

        if debug:
            print(
                f"With api limit set to {limit}, API rest call sent us {len(data)} records in total"
            )

            if len(data) > 0:
                last_idx = len(data) - 1
                print(
                    f"Starting date/time for the API data we got = {datetime.datetime.fromtimestamp(data[last_idx]['dateutc']/1000).strftime('%I:%M%p %d %B %Y')}"
                )
                print(
                    f"Ending date/time for the API data we got = {datetime.datetime.fromtimestamp(data[0]['dateutc']/1000).strftime('%I:%M%p %d %B %Y')}"
                )

        # Execute the SQL
        try:
            cursor.execute(sql)
            connection.commit()
            affected_rows = cursor.rowcount

            msg = f"MySQL query: {affected_rows} new rows added successfully."
            if debug:
                print(msg)
            logger.info(msg)

            # Check for data gap
            if len(data) > 0:
                first_record_added = data[len(data) - 1]["dateutc"]
                data_gap = first_record_added - last_update

                if data_gap < 430:  # Less than ~7 minutes
                    msg = f"Data appears to be in continuity - time gap between the last record on the database and the new added data rows is {data_gap} seconds. ({data_gap/60:.2f} minutes)."
                    if debug:
                        print(msg)
                    logger.info(msg)
                else:
                    msg = f"There may be a data continuity issue, the time gap was {data_gap} seconds ({data_gap/60:.2f} minutes). You may want to check data."
                    if debug:
                        print(msg)
                    logger.warning(msg)

        except mysql.connector.Error as err:
            msg = f"Error executing SQL: {err}"
            if debug:
                print(msg)
            logger.error(msg)

    except Exception as e:
        logger.error(f"Unexpected error: {str(e)}")
        if debug:
            print(f"Unexpected error: {str(e)}")

    finally:
        # Close the database connection
        if "connection" in locals() and connection.is_connected():
            cursor.close()
            connection.close()
            logger.info("MySQL connection closed")
            if debug:
                print("MySQL connection closed")


if __name__ == "__main__":
    # Import requests with SSL warning suppression
    import urllib3

    urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

    logger.info("Script started")
    main()
    logger.info("Script completed")

```

here is an example of the log it writes in the directory that it is run in

```bash
2025-05-08 19:34:19 - INFO - Script started
2025-05-08 19:34:19 - INFO - Connected to MySQL database
2025-05-08 19:34:19 - INFO - Attempting to fetch 134 records from Ambient Weather API
2025-05-08 19:34:20 - INFO - MySQL query: 134 new rows added successfully.
2025-05-08 19:34:20 - INFO - Data appears to be in continuity - time gap between the last record on the database and the new added data rows is 300 seconds. (5.00 minutes).
2025-05-08 19:34:20 - INFO - MySQL connection closed
2025-05-08 19:34:20 - INFO - Script completed

```

Here is the table it loads into

```sql

CREATE TABLE `zastmet` (
  `dateutc` bigint(20) DEFAULT NULL,
  `tempf` double DEFAULT NULL,
  `humidity` double DEFAULT NULL,
  `windspeedmph` double DEFAULT NULL,
  `windgustmph` double DEFAULT NULL,
  `maxdailygust` double DEFAULT NULL,
  `winddir` double DEFAULT NULL,
  `uv` double DEFAULT NULL,
  `solarradiation` double DEFAULT NULL,
  `hourlyrainin` double DEFAULT NULL,
  `eventrainin` double DEFAULT NULL,
  `dailyrainin` double DEFAULT NULL,
  `weeklyrainin` double DEFAULT NULL,
  `monthlyrainin` double DEFAULT NULL,
  `yearlyrainin` double DEFAULT NULL,
  `totalrainin` double DEFAULT NULL,
  `battout` double DEFAULT NULL,
  `tempinf` double DEFAULT NULL,
  `humidityin` double DEFAULT NULL,
  `baromrelin` double DEFAULT NULL,
  `baromabsin` double DEFAULT NULL,
  `feelsLike` double DEFAULT NULL,
  `dewPoint` double DEFAULT NULL,
  `feelsLikein` double DEFAULT NULL,
  `dewPointin` double DEFAULT NULL,
  `lastRain` timestamp NULL DEFAULT current_timestamp(),
  `date` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `auto_import` char(1) DEFAULT NULL,
  `notes` varchar(250) DEFAULT NULL,
  UNIQUE KEY `uniq_recs` (`dateutc`,`tempf`,`humidity`,`windspeedmph`,`windgustmph`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci
```

Here's a view to summarize the data into daily values

```sql
CREATE ALGORITHM=UNDEFINED DEFINER=`user`@`%` SQL SECURITY DEFINER VIEW `v_zastmet_daily` AS
  (SELECT cast(`zastmet`.`date` AS date) AS `dater`,
          cast(`zastmet`.`date` AS date) AS `d_utc`,
          dayofyear(cast(`zastmet`.`date` AS date)) AS `day_of_year`,
          round(avg(`zastmet`.`tempf`), 2) AS `tempf_davg`,
          min(`zastmet`.`tempf`) AS `tempf_dmin`,
          max(`zastmet`.`tempf`) AS `tempf_dmax`,
          avg(`zastmet`.`tempf`) AS `temp_f_davg`,
          65 - avg(`zastmet`.`tempf`) AS `hdd_d65`,
          70 - avg(`zastmet`.`tempf`) AS `hdd_d70`,
          avg(`zastmet`.`tempf`) - 65 AS `cdd_d65`,
          avg(`zastmet`.`tempf`) - 70 AS `cdd_d70`,
          avg(`zastmet`.`tempf`) - 80 AS `cdd_d80`,
          min(`zastmet`.`tempf`) AS `temp_f_dmin`,
          max(`zastmet`.`tempf`) AS `temp_f_dmax`,
          round(avg(`zastmet`.`humidity`), 3) AS `humidity_davg`,
          min(`zastmet`.`humidity`) AS `humidity_dmin`,
          max(`zastmet`.`humidity`) AS `humidity_dmax`,
          round(avg(`zastmet`.`windspeedmph`), 2) AS `windspeedmph_davg`,
          avg(`zastmet`.`windspeedmph`) AS `windsp_mph_davg`,
          round(avg(`zastmet`.`windgustmph`), 2) AS `windgust_davg`,
          avg(`zastmet`.`maxdailygust`) AS `maxdailygust_davg`,
          avg(`zastmet`.`winddir`) AS `winddir_davg`,
          avg(`zastmet`.`uv`) AS `uv_davg`,
          avg(`zastmet`.`solarradiation`) AS `solarradiation_davg`,
          min(`zastmet`.`solarradiation`) AS `solarradiation_dmin`,
          max(`zastmet`.`solarradiation`) AS `solarradiation_dmax`,
          avg(`zastmet`.`hourlyrainin`) AS `hourlyrainin_davg`,
          avg(`zastmet`.`eventrainin`) AS `eventrainin_davg`,
          avg(`zastmet`.`dailyrainin`) AS `dailyrainin_davg`,
          avg(`zastmet`.`weeklyrainin`) AS `weeklyrainin_davg`,
          avg(`zastmet`.`monthlyrainin`) AS `monthlyrain_davg`,
          avg(`zastmet`.`yearlyrainin`) AS `yearlyrain_davg`,
          avg(`zastmet`.`totalrainin`) AS `totalrainin_davg`,
          avg(`zastmet`.`battout`) AS `battout_davg`,
          min(`zastmet`.`battout`) AS `battout_dmin`,
          max(`zastmet`.`battout`) AS `battout_dmax`,
          avg(`zastmet`.`tempinf`) AS `tempfin_davg`,
          min(`zastmet`.`tempinf`) AS `tempfin_dmin`,
          max(`zastmet`.`tempinf`) AS `tempfin_dmax`,
          avg(`zastmet`.`humidityin`) AS `humidityin_davg`,
          avg(`zastmet`.`baromrelin`) AS `baromrelin_davg`,
          min(`zastmet`.`baromrelin`) AS `baromrelin_dmin`,
          max(`zastmet`.`baromrelin`) AS `baromrelin_dmax`,
          avg(`zastmet`.`baromabsin`) AS `baromabsin_davg`,
          avg(`zastmet`.`feelsLike`) AS `feelslike_davg`,
          min(`zastmet`.`feelsLike`) AS `feelslike_dmin`,
          max(`zastmet`.`feelsLike`) AS `feelslike_dmax`,
          avg(`zastmet`.`dewPoint`) AS `dewpoint_davg`,
          avg(`zastmet`.`feelsLikein`) AS `feelslikein_davg`,
          avg(`zastmet`.`dewPointin`) AS `dewpointin_davg`,
          max(`zastmet`.`lastRain`) AS `lastrain_max`,
          count(`zastmet`.`date`) AS `recs`
   FROM `zastmet`
   GROUP BY cast(`zastmet`.`date` AS date)
   ORDER BY cast(`zastmet`.`date` AS date) DESC)

   ```