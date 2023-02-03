---
id: 433
title: 'exif from pictures for GIS'
date: '2012-04-19T08:38:47-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=433'
permalink: /2012/04/19/exif-from-pictures-for-gis/
categories:
    - 'Data processing'
    - Database
    - GIS
---

I'm going to do a little Open Street Mapping of my area – focusing on the many parks and landtrust areas around. So I've been thinking about options to document locations and such. Of course I have a rockin HTC EVO 4G with on-board GPS. So, I'm thinking that in addition to logging coordinates with my [GPSLogger](https://play.google.com/store/apps/details?id=com.mendhak.gpslogger&hl=en) app I'm going to try to use my phone and the on-board GPS to grab locations through photos as a rapid way to input and ground truth stuff. Once I end up with a directory full of images, I want a handy script or utility to batch extract all of the coordinates from the embedded EXIF info in the image header.

Enter the <del>utility amazing</del> swiss army tool **exiftool (**<http://www.sno.phy.queensu.ca/~phil/exiftool/>) Its capabilities are too long to cover here. But suffice it to say, this one tool does pretty much everything I need. Here's what I'm doing.

Imagine the command as follows:

```
exiftool -csv -c "%+.8f" SourceFile -CameraID -CreateDate -CreationTime -DateAcquired -DateTimeOriginal -Directory -ExifByteOrder -ExifImageHeight -ExifImageWidth -FileName -FileSize -GPSAltitude -GPSAltitudeRef -GPSDateStamp -GPSDateTime -GPSLatitude -GPSLatitudeRef -GPSLongitude -GPSLongitudeRef -GPSMapDatum -GPSPosition -GPSProcessingMethod -GPSSatellites -GPSTimeStamp -GPSVersionID -ImageHeight -ImageSize -ImageUniqueID -ImageWidth -Make -Model -Subject -XPKeywords -r Pictures > ~/myphotorecords.csv
```

where:

**-c "%.8f"** = change coordinate format to decimal degrees with 8 places of precision  
**-TAGNAME** = write out values for this EXIF tag  
**-csv** = output all tags in tabular CSV format suitable for working in Excel or QGIS  
**-r** = recurse through all DIRECTORIES named next  
**&gt;** = output to this .csv file.  
**~** = my home directory in. In this case I'm running on Windows 7 with Cygwin. So the actual file path to find the file from Windows is c:\\cygwin\\home\\jcz  
**myphotorecords.csv** = the output file

below is the example of a run using the above command

[![](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/04/cygwin_exiftool-300x84.gif "cygwin_exiftool")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/04/cygwin_exiftool.gif)

below is example output with some fields clipped

[![](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/04/example_exiftool_output-300x4.gif "example_exiftool_output")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/04/example_exiftool_output.gif)  
This should import nicely into my GIS of choice where I will QC the data. Then I'll proceed to my favorite Open Street Map edit and start submitting.

PS. the GPSlogger tool saves tracks as KML and GPX, in addition to somehow also directly submitting to Open Street Map with tags… something I'll have to play around with.