---
id: 573
title: 'Spatialite and Triggers to Update Data'
date: '2012-10-19T00:08:08-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=573'
permalink: /2012/10/19/spatialite-and-triggers-to-update-data/
categories:
    - 'Data processing'
    - Database
    - GIS
    - Spatialite
    - Uncategorized
---

I finally decided to do a little demo here of a common feature I need on a lot of projects. We often have systems that maintain point locations of things (create, update, delete, view them) and having attributes of spatial relationship automatically applied to them is often quite handy. For example, in a system that tracks illegal dumping observations, knowing the county that dots of the sightings falls into (because the counties regulate dumping) would be handy thing to know immediately for reporting and filtering. We used to ask users to know what county their point (e.g., position of trash sighting) was in. But it’s a lot nicer (and perhaps more accurate) to do some simple spatial magic for the user.

I spend time worrying about water quality so in this example I want to what small watershed (12-digit hydrologic unit code or HUC 12’s) my Points of Interest (POIs) fall into. I also want to know what date and time the record was created or updated on. Consider the following basic map. Blue polygons are HUC12s and the stars are my POIs – both stored in the same sqlite/spatialite file (a single .db or .sqlite file).

![](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/10/101912_0507_Spatialitea1.png)

Note that I have an unique, incrementing primary key column (PKUID), then NAME and TYPE columns. We don’t see it, but there is also a Geometry column to store the coordinates of my points.

Now I’ll add two columns to store the HUC12 and DATE and TIME of the edits to the points.


```sql ALTER TABLE "mypois" ADD COLUMN HUC_12 TEXT;
ALTER TABLE "mypois" ADD COLUMN UPDATE_DT DATETIME; 
```

Here is the full structure now.


```sql
CREATE TABLE "mypois"(
pkuid integer primary key autoincrement,

"NAME" text,
"TYPE" text,
"geometry" POINT,
UPDATE_DT DATETIME,
HUC_12 TEXT)
```

Now my attribute table looks like this.

![](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/10/101912_0507_Spatialitea2.png)

OK. So I’ve got a place to store these attributes. Now let’s apply the database triggers. We’ll create to add the data during an INSERT operation, and another for an UPDATE. Note that triggers must be uniquely named in a Sqlite database. So, I’ve prefixed my triggers with the table name.

![](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/10/101912_0507_Spatialitea3.png)

And here’s the code.


```sql

CREATE TRIGGER mypois_UPD_UDT_HUC12 AFTER UPDATE ON mypois
BEGIN
UPDATE mypois SET UPDATE_DT = DATETIME ('NOW')
WHERE rowid = new.rowid ;
UPDATE mypois SET HUC_12 =
(
SELECT cumberland_huc12.HUC_12
FROM cumberland_huc12, mypois
WHERE ST_Intersects (
mypois.geometry, cumberland_huc12.Geometry)
AND mypois.ROWID = NEW.ROWID
)
WHERE mypois.ROWID = NEW.ROWID;
END

```

and


```sql

CREATE TRIGGER mypois_INS_UDT_HUC12 AFTER INSERT ON mypois
BEGIN
UPDATE mypois SET UPDATE_DT = DATETIME ('NOW')
WHERE rowid = new.rowid ;
UPDATE mypois SET HUC_12 =
(
SELECT cumberland_huc12.HUC_12
FROM cumberland_huc12, mypois
WHERE ST_Intersects (
mypois.geometry, cumberland_huc12.Geometry)
AND mypois.ROWID = NEW.ROWID
)
WHERE mypois.ROWID = NEW.ROWID;
END

```

Now let me use Qgis to enter a new point. The screen below is just filling in the non-calculated attributes.

 [![No need to fill in the attributes that will be set by the trigger](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/10/editing_4trigger-300x221.png)](http://northredoubt.com/n/2012/10/19/spatialite-and-triggers-to-update-data/editing_4trigger/)<figcaption class="wp-caption-text" id="caption-attachment-628">No need to fill in the attributes that will be set by the trigger</figcaption></figure>

Here’s a quick screen to show how to start and end an editing session in Qgis. You must Save your edits to commit them and fire the trigger.

 ![](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/10/101912_0507_Spatialitea5.png)<figcaption class="wp-caption-text">Don’t forget to SAVE your edits, or the triggers won’t fire.</figcaption></figure>

 [![saved_edits_trigger](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/10/saved_edits_trigger-300x169.png)](http://northredoubt.com/n/2012/10/19/spatialite-and-triggers-to-update-data/saved_edits_trigger/)<figcaption class="wp-caption-text" id="caption-attachment-627">Voila. The triggered attributes were updated.</figcaption></figure>