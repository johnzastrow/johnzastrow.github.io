---
id: 651
title: 'Importing EPA WQX Domains into MySQL Tables'
date: '2013-02-19T16:40:13-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=651'
permalink: /2013/02/19/importing-epa-wqx-domains-into-mysql-tables/
categories:
    - 'Data processing'
    - Database
    - 'water quality'
---

I wanted fresh [WQX](http://www.epa.gov/storet/wqx/) domain values from the [STORET web service](http://www.epa.gov/storet/tools.html) that are updated daily ( [http://www.epa.gov/storet/wqx/wqx\_getdomainvalueswebservice.html](http://www.epa.gov/storet/wqx/wqx_getdomainvalueswebservice.html) ) – which are provided in XML format. But, it’s not a friendly format for most software. Excel and Access “see it” but they don’t make useful tables out of them. It turns out that MySQL’s LOAD XML command (<https://dev.mysql.com/doc/refman/5.5/en/load-xml.html>) works for this, but you need to change the structure of the XML a bit. When the manual says that the XML must be one of the 3 formats – it’s not kidding and it’s not as flexible as the text makes it sound. So, the following instructions and horribly-brute force script will transform the EPA XML files into something that MySQL will understand and then load the data for you.

First I created this table to hold my data (you might need to add more columns).

```
<pre class="lang:mysql decode:true" title="A basic table to hold the values. You might need to add more columns">CREATE TABLE `wqx21_domains` (
  `DOM_ID` int(11) NOT NULL AUTO_INCREMENT,
  `WQXElementName` varchar(500) DEFAULT NULL,
  `UniqueIdentifier` varchar(500) DEFAULT NULL,
  `Code` varchar(500) DEFAULT NULL,
  `Type` varchar(500) DEFAULT NULL,
  `TribalCode` varchar(500) DEFAULT NULL,
  `LastChangeDate` varchar(500) DEFAULT NULL,
  `Description` varchar(500) DEFAULT NULL,
  `Name` varchar(500) DEFAULT NULL,
  `ContextCode` varchar(500) DEFAULT NULL,
  `QualifierType` varchar(500) DEFAULT NULL,
  `Rank` varchar(500) DEFAULT NULL,
  `ExternalID` varchar(500) DEFAULT NULL,
  `STORETID` varchar(500) DEFAULT NULL,
  `SRSID` varchar(500) DEFAULT NULL,
  `SampleFractionRequired` varchar(500) DEFAULT NULL,
  `PickList` varchar(500) DEFAULT NULL,
  `CASNumber` varchar(500) DEFAULT NULL,
  `CountyFIPSCode` varchar(500) DEFAULT NULL,
  `CountyName` varchar(500) DEFAULT NULL,
  `StateCode` varchar(500) DEFAULT NULL,
  `CREATED_DT` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`DOM_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=52401 DEFAULT CHARSET=utf8
```

then run the following bash code from within a directory that looks like below.

 [![WQX XML domain file list](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2013/02/wqx_file_list-188x300.png)](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2013/02/wqx_file_list.png)<figcaption class="wp-caption-text" id="caption-attachment-657">WQX XML domain file list</figcaption> 

in the last sed line below, note that you must reset the delimeter to | (or something besides / as you need to escape those chars in the values you need to replace. This is the easiest way I think.

**UPDATE:** the post following this one shows how to [create the directory of .zip files this script needs](https://johnzastrow.github.io/2013/02/20/wget-examples/ "Wget examples") with a one-liner using wget.

```
<pre class="lang:sh decode:true" title="bash script to run through all the .zip files and load them to mysql">#!/bin/sh
clear
# optional stuff for checking output
# echo "I see this many zip files: "
# ls *.zip | wc -l
# echo "and they are: "
# ls *.zip
echo ""
echo ""
echo ""
echo ""

echo "************* START ******************"
pwd
echo ""
for zipper in *.zip
do
echo $zipper
echo ""
mkdir "$zipper"_folder
echo ""

unzip -u $zipper -d "$zipper"_folder
echo ""
echo ""
cd "$zipper"_folder
pwd
# I'm going to just leave these around as the directories are easy to delete later.
cat Results.xml | sed -e 's|WQXElementRowColumn|field|' > Results2.xml
cat Results2.xml | sed -e 's/WQXElementRowColumn>/field>/' > Results3.xml
cat Results3.xml | sed -e 's/colname="/name="/' > Results4.xml
cat Results4.xml | sed -e 's/value="/">/' > Results5.xml
cat Results5.xml | sed -e 's/" ">/">/' > Results6.xml
cat Results6.xml | sed -e 's|"></field>|</field>|' > Results7.xml
mysql -uuser -p'password' --local-infile -e "use wqx;LOAD XML LOCAL INFILE 'Results7.xml' INTO TABLE wqx21_domains ROWS IDENTIFIED BY '<WQXElementRow>';"
# rm *.xml
cd ..
echo ""
pwd
echo " ----- DONE ------- "$zipper
done
mysqldump -uuser -p'password' wqx > wqx_lookup_dump.sql
```

and you will get a MySQL table with contents as follows

```
<pre class="lang:default decode:true">+---------------------------------+---------+
| WQXElementName                  | Records |
+---------------------------------+---------+
| ActivityGroupType               |       8 |
| ActivityMedia                   |      16 |
| ActivityMediaSubdivision        |      64 |
| ActivityType                    |     100 |
| AddressType                     |       6 |
| AnalyticalMethod                |    6204 |
| Assemblage                      |      15 |
| BiologicalIntent                |       6 |
| CellForm                        |       5 |
| CellShape                       |      10 |
| Characteristic                  |    3766 |
| CharacteristicPickListValue     |    1747 |
| ContainerColor                  |       7 |
| ContainerType                   |      33 |
| Country                         |      16 |
| County                          |    3292 |
| Detection/QuantitationLimitType |      12 |
| ElectronicAddressType           |       3 |
| FrequencyClassDescriptor        |      65 |
| Habit                           |       9 |
| HorizontalCollectionMethod      |      38 |
| HorizontalReferenceDatum        |      16 |
| MeasurementUnit                 |     335 |
| MethodSpeciation                |      15 |
| MetricType                      |      21 |
| MetricTypeContext               |       3 |
| MonitoringLocationType          |      73 |
| NetType                         |       3 |
| Organization                    |     817 |
| PhoneType                       |      10 |
| ReferenceLocationType           |       4 |
| RelativeDepth                   |      16 |
| ResultDetectionCondition        |       5 |
| ResultLabComment                |      34 |
| ResultMeasureQualifier          |      53 |
| ResultStatisticalBase           |      28 |
| ResultStatus                    |      17 |
| ResultTemperatureBasis          |      19 |
| ResultTimeBasis                 |     106 |
| ResultValueType                 |       5 |
| ResultWeightBasis               |       4 |
| SampleCollectionEquipment       |     177 |
| SampleFraction                  |      24 |
| SampleTissueAnatomy             |      83 |
| SamplingDesignType              |       2 |
| State                           |      68 |
| Taxon                           |   65502 |
| ThermalPreservative             |      20 |
| TimeZone                        |      46 |
| ToxicityTestType                |       4 |
| Tribe                           |    1126 |
| VerticalCollectionMethod        |      28 |
| VerticalReferenceDatum          |      12 |
| Voltinism                       |      10 |
| WellFormationType               |       6 |
| WellType                        |      40 |
+---------------------------------+---------+
56 rows in set (0.92 sec)
```

**Other resources:**

<http://stackoverflow.com/questions/8582837/load-xml-local-infile-with-inconsistent-column-names>

<http://blog.mclaughlinsoftware.com/2010/09/26/load-xml-local-infile/>