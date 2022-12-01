---
id: 313
title: 'Spatialite and Spatial Indexes'
date: '2012-01-18T23:11:32-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=313'
permalink: /2012/01/18/spatialite-and-spatial-indexes/
categories:
    - 'Data processing'
    - Database
    - GIS
    - Linux
    - Spatialite
    - Uncategorized
---

*This post is part of a series [\[1\]](http://northredoubt.com/n/2012/01/16/example-with-php-and-spatialite-part-1/ "Example with PHP and Spatialite, part 1"), [\[2\]](http://northredoubt.com/n/2012/01/17/example-with-php-and-spatialite-part-2/ "Example with PHP and Spatialite, part 2"), [\[3\]](http://northredoubt.com/n/2012/01/18/spatialite-and-spatial-indexes/ "Spatialite and Spatial Indexes"), [\[4\]](http://northredoubt.com/n/2012/01/20/spatialite-speed-test/ "Spatialite Speed Test")*

Tonight I continued dabbling with my little project and experimenting with spatial indexes in Spatialite. I quickly realized that while using indexes benefitted the queries, the questions were too easy and the queries were finishing very quickly regardless of using indexes or not (nice problem to have). Therefore, the benefits of using the indexes were being swamped out by little errors in timings.

So, I made a bigger dataset. As shown below, the number of features I’m testing against went from 183 to 2429. You’d think that would be enough, but stay tuned…

<figure aria-describedby="caption-attachment-317" class="wp-caption alignnone" id="attachment_317" style="width: 300px">[![Bigger sheds](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/biggersheds-300x196.png "Bigger sheds")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/biggersheds.png)<figcaption class="wp-caption-text" id="caption-attachment-317">A bigger, badder testing dataset. Note the previous data set at 183 features (purple) and the much larger count of features in the new, blue polys.</figcaption></figure>

So, armed with this larger dataset I proceeded to test sensitivity to using indexes.

I dinked around with trying to write own my R-tree index queries (the “some index” examples below) and they helped. Then Sandro (author of spatialite) replied to a post I made seeking guidance. There he re-wrote my query (best examples below)and suggested I read about a new, easier way to use spatial indexes here [http://www.gaia-gis.it/gaia-<wbr></wbr>sins/SpatialIndex-Update.pdf](http://www.gaia-gis.it/gaia-sins/SpatialIndex-Update.pdf)

## The Original Query

So here is the original query.

```
<pre class="lang:default decode:true ">SELECT HU_12_NAME FROM huc12
WHERE ST_Contains(Geometry, MakePoint(-70.250,43.802)) = 1
```

Faced with 2429 polygons, the original query takes about 1.9 seconds on average. My goal is to get results back from anywhere in the country in 1 second or less. Clearly this type of query isn’t going to cut it.

<figure aria-describedby="caption-attachment-316" class="wp-caption alignnone" id="attachment_316" style="width: 300px">[![Timings without index](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/noindex-300x101.png "Timings without index")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/noindex.png)<figcaption class="wp-caption-text" id="caption-attachment-316">Timings without index</figcaption></figure>

I’m also including the explain plans here. Obviously without an index the query has to do a full scan of the table to figure out which records it needs. Scans are bad. Scans of many records are very bad.

<figure aria-describedby="caption-attachment-322" class="wp-caption alignnone" id="attachment_322" style="width: 300px">[![Explain plan with no index](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/explain_noindex-300x61.png "Explain plan with no index")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/explain_noindex.png)<figcaption class="wp-caption-text" id="caption-attachment-322">Explain plan with no index</figcaption></figure>

## A Better Query

Ok, so to scan less you need to do some filtering based on something to reduce the records you’re talking to. In this case, we use the bboxes from the index tables to grab a more limited set of features to actually perform the more intensive ST\_Contains test with just to make sure the point ACTUALLY falls within the set of polygons the BBOX suggests.

```
<pre class="lang:default decode:true">SELECT HU_12_NAME FROM huc12
WHERE ST_Contains(Geometry, MakePoint(-70.250,43.802))
AND
ROWID IN (
SELECT pkid from idx_huc12_Geometry where xmin < -69 and xmax > -71)
```

OK, now I was getting ~1.1 seconds pretty reliably. Yep, that’s detectable change between the two queries. So, we have enough records to see the benefits of the improved queries. This was an improvement, but not enough.

<figure aria-describedby="caption-attachment-315" class="wp-caption alignnone" id="attachment_315" style="width: 300px">[![Timings with some index](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/betterindex-300x144.png "Timings with some index")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/betterindex.png)<figcaption class="wp-caption-text" id="caption-attachment-315">Timings with some index</figcaption></figure>

The explain plan gets better. We see the filtering and while we’re scanning, it’s more manageable.

<figure aria-describedby="caption-attachment-321" class="wp-caption alignnone" id="attachment_321" style="width: 300px">[![Explain plan with some index](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/explain_better-300x119.png "Explain plan with some index")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/explain_better.png)<figcaption class="wp-caption-text" id="caption-attachment-321">Explain plan with some index</figcaption></figure>

##  Best Query

So then came Sandro’s reply. In it he guided me to this type of query.. which rocks.

```
<pre class="lang:default decode:true ">SELECT HU_12_NAME FROM huc12
WHERE ST_Contains(Geometry, MakePoint(-70.250,43.802)) = 1
AND ROWID IN (
SELECT ROWID
FROM SpatialIndex
WHERE f_table_name = 'huc12'
AND search_frame = MakePoint(-70.250,43.802));
```

And here we see true magic. The original query with no indexes ran for 1.9 seconds. Some index sped things up to 1.1. Now, hold on to your socks, Sandro’s more proper query comes in at 0.16 seconds. That kind of performance really gives me hope.

<figure aria-describedby="caption-attachment-314" class="wp-caption alignnone" id="attachment_314" style="width: 300px">[![Timings with some index](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/bestindex-300x142.png "Timings with best index")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/bestindex.png)<figcaption class="wp-caption-text" id="caption-attachment-314">Timings with some index</figcaption></figure>

We don’t learn too much more from the explain plan. But hey, who needs to ask more questions of that kind of speed up.

<figure aria-describedby="caption-attachment-320" class="wp-caption alignnone" id="attachment_320" style="width: 300px">[![Explain plan with optimal virtual index](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/explain_best-300x127.png "Explain plan with optimal virtual index")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/explain_best.png)<figcaption class="wp-caption-text" id="caption-attachment-320">Explain plan with optimal virtual index</figcaption></figure>

That was fun. What does it do when stuck into PHP?

First let’s just do the same old “no index” version.

<figure aria-describedby="caption-attachment-335" class="wp-caption alignnone" id="attachment_335" style="width: 300px">[![PHP page with more features and no index in query](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/php_noindex-300x220.png "PHP page with more features and no index in query")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/php_noindex.png)<figcaption class="wp-caption-text" id="caption-attachment-335">PHP page with more features and no index in query</figcaption></figure>

About 2.5 seconds on average. No surprises there.

How about with some spatial index.

<figure aria-describedby="caption-attachment-334" class="wp-caption alignnone" id="attachment_334" style="width: 719px">[![PHP page with more features and some spatial index in query](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/php_someindex.png "PHP page with more features and some spatial index in query")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/php_someindex.png)<figcaption class="wp-caption-text" id="caption-attachment-334">PHP page with more features and some spatial index in query</figcaption></figure>

About 1.8 seconds on average. Shaved quite a bit off, but we’re still way over the 1 second goal. How about with Sandro’s query?

<figure aria-describedby="caption-attachment-333" class="wp-caption alignnone" id="attachment_333" style="width: 744px">[![PHP page with more features and best spatial index in query](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/php_bestindex.png "PHP page with more features and best spatial index in query")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/php_bestindex.png)<figcaption class="wp-caption-text" id="caption-attachment-333">PHP page with more features and best spatial index in query</figcaption></figure>

Cool. We’re below the 1 second mark. I even saw a 0.7 second timing every so often. But, we’re very close to 1 second, so I’m starting to sweat a little. But wait, there’s more. I’ve still got those little filler queries happening on the page, and one of them is a bulky SELECT DISTINCT which is going to scan my larger dataset now. So, what happens when we get rid the crud?

<figure aria-describedby="caption-attachment-332" class="wp-caption alignnone" id="attachment_332" style="width: 744px">[![PHP page with more features, best spatial index, and extra queries removed](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/php_simple_best.png "PHP page with more features, best spatial index, and extra queries removed")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/php_simple_best.png)<figcaption class="wp-caption-text" id="caption-attachment-332">PHP page with more features, best spatial index, and extra queries removed</figcaption></figure>

Yes! At 0.26 seconds we’re way below 1 second again. Phew! What about the original query? What happens when we remove the cruft from that page but still use the un-optimized query?

<figure aria-describedby="caption-attachment-338" class="wp-caption alignnone" id="attachment_338" style="width: 514px">[![PHP page with no index, but extra queries removed](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/php_simple_no_index.png "PHP page with no index, but extra queries removed")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2012/01/php_simple_no_index.png)<figcaption class="wp-caption-text" id="caption-attachment-338">PHP page with no index, but extra queries removed</figcaption></figure>

1.9 seconds. Some improvement from the first page, but not where we need it. No worries, we’re moving on!