---
id: 805
title: 'ArcMap 10.2 slowness'
date: '2014-03-06T11:56:22-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=805'
permalink: /2014/03/06/arcmap-10-2-slowness/
categories:
    - 'Data processing'
    - Database
    - GIS
    - Uncategorized
---

We’ve been experiencing <del>some</del> a lot of slowness with ArcMap 10.2 across many Windows 7 (64-bit of course) Pro and Enterprise machines. So my colleague has done a lot of research, phone calling (with Esri), and troubleshooting to arrive at the following helpful information. If you having some weird and annoying slowness in 10.2 (or perhaps even 10.1) some of the options below may help you. We’re not convinced that these tips have solved our problems, but they seem to help.

**1. Try not to use Personal Geodatabases (PGDB) (.mdb) format.**

We wish that Esri would issue proper warnings about using PGDBs rather than just exhibiting odd behaviors and slowness. But, display, selection, and geoprocessing issues exist when using .mdb files in 10.2 (issues were also encountered in v10.1, too). These issues seem to be related to performance (e.g., on machines with both spinning disks and SSDs: about 60 seconds to open a 100 record, 500kb shapefile, another 60 seconds to export (locally)) which then may or may not contribute to the overall flaky behavior that we get in the desktop (i.e., random features just not appearing in the map).

Apparently switching between geoprocessing in the foreground (32-bit) versus the background (64-bit) switches between 32 and 64-bit processing. The default is background processing.This makes sense now finding out that personal geodatabases files are unsupported in v10.2 with 64-bit AND background anything. See the docs below. The upside is converting .mdb to file geodatabase (.gdb) appears to have fixed the problems.

[![ArcGIS64-bit_docs](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2014/03/ArcGIS64-bit_docs-300x181.jpg)](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2014/03/ArcGIS64-bit_docs.jpg)**Solution:** Don’t use PGDBs and if you do, set everything to run in the FOREGROUND, which forces operations to be done in 32-bit mode. Switching to foreground brought the speeds back to near instantaneous (un-checking the enable background processing in the screen shot below).

[![ArcGIS64-bit_docs2](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2014/03/ArcGIS64-bit_docs2-243x300.jpg)](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2014/03/ArcGIS64-bit_docs2.jpg)

Given that SQLite (Spatialite and Geopackage) are now or soon will be nearly first-class citizens for storing for use in Arc\*, if you need true database functions (like joins, views/queries) the various SQLite formats might be a good eventual replacement for PGDBs.. and dare I say even Shapefiles! Much will depend on how seamless Esri makes using them. Right now it’s actually quite SEAMFUL.

**2. Don’t update metadata if you don’t have to**

Also the Arc Map default is to update metadata anytime you touch a file. We turned this off and likely has aided in performance enhancement as well. The improvement seemed to be “noticeable” but not what you’d call terrific.

**3. Rename your home**

This is a more hard-core version of replacing normal.mxt. But it seems to be what is needed if that doesn’t resolve additional flaky/slow behaviors.

Be aware that renaming the Esri folders is a factory reset of ArcGIS, and therefore all third party tools, custom scripts, and/ or custom toolbars currently installed will need to be re-installed as a result. Also, you will need to re-connect all existing folder connections.

\*\*\*Renaming the esri Folder in the C: drive\*\*\*

1\. Open Control Panel &gt; Appearance and Personalization &gt; Folder Options &gt; View Tab

2\. Select the radio button to Show hidden files, folders, and drives

3\. Right-click on the Windows Start Icon &gt; Windows Explorer

4\. Navigate to C:/Users/YourUsername/AppData/Roaming/esri

\*\*If the AppData folder is not visible, you may need to perform the following steps to display the general toolbar: Organize menu &gt; Layout &gt; Menu Bar. Then to display the AppData folder, choose the Tools menu &gt; View Tab &gt; Show Hidden files, folders, or drives &gt; Apply &gt; OK

5\. Right click on the esri folder and select rename. rename the folder.

HTH