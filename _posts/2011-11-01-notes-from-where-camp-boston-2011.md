---
id: 245
title: 'Notes from Where Camp Boston 2011'
date: '2011-11-01T09:36:07-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=245'
permalink: /2011/11/01/notes-from-where-camp-boston-2011/
categories:
    - 'Data processing'
    - Database
    - GIS
    - Spatialite
    - Thoughts
    - Web
tags:
    - Boston
    - GIS
    - mapping
    - 'Open Source'
    - spatial
    - 'Where Camp'
---

I had a great time at this [little event](http://www.wherecampboston.com/ "Where Camp Boston 2011") and it was good prep for the Maine GIS User group's [Ignite](http://megug.org/events/ "Maine Ignite Spatial") meeting tonight. Hopefully I'll be able to attend more stuff like this in the future. But, before then, I'd better get some materials together about [Spatialite](http://www.gaia-gis.it/spatialite/ "Spatialite sqlite with spatial") in return for the kind gentleman giving the spatial sql talk at my request (from the session board).

So what follows are my notes from Where Camp Boston 2011, and in generally chronological order.

[![Session board](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2011/11/IMAG0087-150x150.jpg "IMAG0087")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2011/11/IMAG0087.jpg) 

The session board at Where camp Boston 2011

- **Geocouch** – finally heard someone using this spatially-enabled, NoSQL data storage technology. It does seem that many NoSQL solutions have at least X,Y spatial capabilities and data types. I'm kinda torn between Cassandra and MongoDB. Although, there are SOoo many commercial/cloud offerings out there if you just want to store points. See below
- — **CouchDB** – <http://couchdb.apache.org/>
- **Open Geo Portal**. could be interesting. <http://opengeoportal.org/>
- **Fascinating use of VGI/Crowd sourcing to collect hi-res data.** Now if they can just harness all that information and use it effectively. Hopefully the Where Camp Boston folks can post some slides from the keynotes. I missed a lot of detail from this one. <http://publiclaboratory.org/home>
- — **Tools** – Had some great tools for rapid georeferencing and other processing of Kite-collected images, etc. <http://publiclaboratory.org/tools>
- — **Your [nearest] Superfund** – <http://macwright.org/superfund/>
- — **Firebird commander** for RC remote sensing with a $300 HD video camera – <http://www.amazon.com/Firebird-Commander-2-RTF-Electric/dp/B000AUO7B8>

- **Google Refine** for cleansing dirty data. I'm totally going to use this – <http://code.google.com/p/google-refine/>
- **Open street map geocoder** – <http://wiki.openstreetmap.org/wiki/Nominatim>
- **Cartodb**, yet another point-in-cloud service – <http://cartodb.com/>
- **Request Tracker**, flexible OSS for (not just software) issue tracking. We are quite happy hacking on [Mantis](http://mantisbt.org), but I met a Best Practical engineer at this conf. and spoke with a few attendees who use rt. Turns out people still develop successful commercial products in Perl (but not your grandma's perl CGIs) <http://bestpractical.com/rt/>
- **Tilemill** and carto for styling – very cool and hip as presented by Tom MacWright (<http://www.wherecampboston.com/keynote-speakers/>) – <http://mapbox.com/>
- **AppInventor** – Rapid Android app development for non-developers – Presentation by Daniel Sheehan, MIT GIS Lab about rapidly building Android apps. I saw this years ago but needed a little push like this presentation to take it for a spin. I hope MIT is able to keep it going after Google sends it back home. – [**Appinventorbeta.Com**](http://appinventorbeta.com)
- — scratch – basic programming
- — starlogo TNG (java)
- — appspot.com -to store data – but now fusion tables
- — Fusion tables – will limit to several hundred megs of geodata
- — Change setting/app on phone to allow unknown sources and development
- — Kinda useful – [http://gmaps-samples.googlecode.com/svn/trunk/fusiontables/fusiontableslayer_builder.html](http://gmaps-samples.googlecode.com/svn/trunk/fusiontables/fusiontableslayer_builder.html)

- **jQuery Geo**. Yep, might turn into our JS mapping toolkit of choice. Very nice, and very jQuery compliant. Definitely takes the "less is more approach" It can use Esri tiles and internal builds have mobile app builder with geo ready templates. These might get released – <http://jquerygeo.com/>
- — See also:
- — <http://modestmaps.com/>
- — <http://polymaps.org/>
- — <http://mbostock.github.com/d3/>
- — <http://leaflet.cloudmade.com/>


[![sailing, snow, halloween, boston, crazy, awesome!](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2011/11/IMAG0085-150x150.jpg "IMAG0085")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2011/11/IMAG0085.jpg)sailing, snow, halloween, boston, crazy, awesome!

Crazy folks out sailing. When I left at 6pm-ish it was raining hard with snow mixed in and nearly dark out – they were still sailing. I take my hand off to them.

[**Tom McWright**](http://developmentseed.org) keynote speaker: technology, spatial curmudgeon

- — **Tilemill**– <http://mapbox.com/tilemill/docs/manual/>
- — **Vizzuality** interesting- <http://vizzuality.com>
- — **Carto** – is styling language for mapnik and tilemill (incestual rship here). But jQuery Geo is going to use [SVG CSS style sheets](http://tutorials.jenkov.com/svg/svg-and-css.html) – <http://developmentseed.org/blog/2011/feb/09/introducing-carto-css-map-styling-language/>
    - **Metro Area OSM Extracts**. I need to contact him to add Portland, MAINE to the list – <http://metro.teczno.com/>
    - **The OSM data** – <http://planet.osm.org>
    
    
    - **Vector in the browser** is limited to Google maps WebGL. Nothing else out there yet.
    - **Cartodb IS postgis**
    
    
    - **Spatialite** license is terrible… hmm
    
    
    - **No more projections** in data, just in presentation
    - **Node.js** – all the cool kids do it, and github
    - Check out **wax** on github
    - Bones – ruby on rails with JavaScript. runs on browser and server – <https://github.com/developmentseed/bones#readme>

<span style="color: #666699;">**&lt;Soapbox&gt;: Data without metadata are useless crap**</span>

<span style="color: #666699;">There was some talk about various projects using (1) publicly available historical data, or (2) data from a range of public, crowd-sourced, etc sources. There were also related discussions about **collecting** data for broad public use (use case 2). But all the discussions left out an important topic — which is a common malady in many discussions in the open, free, non-government (not necessarily related, but often coincident concepts) circles: ***documentation/metadata***. I love open data. But when I use it, I need to have convenient, parse-able, understandable, hopefully standards-based information about this stuff I am about to use. It doesn't have to be <span style="text-decoration: underline; color: #99ccff;">[<span style="color: #99ccff; text-decoration: underline;">elaborate</span>](http://www.fgdc.gov/metadata/documents/preparing-for-international-metadata-guidance.pdf "19115 NAP, FGDC")</span>, but it needs to be present. </span>

<span style="color: #666699;">I wish the spatial community would agree on some simple, general, common approach to ***<span style="text-decoration: underline;">embed</span>*** metadata right into the data so that the two could never be separated. When you create/maintain/manage/supply data, you'd better assume responsibility for the metadata and the data, as they should be two sides of the same coin. So, in your spatial DBs, maybe always include a table called.. DOCUMENTATION, link to the information_schema and create records contains Dublin Core RDF, or SOMETHING. Now I just need to follow my own advice…  
</span>

<span style="color: #666699;">**&lt;/Soapbox&gt;**</span>

<span style="text-decoration: underline; color: #666699;">See:</span>

- <http://www.bridges.state.mn.us/metadata.html>
- [http://www.geomapp.net/docs/MetadataComparison_200903.pdf](http://www.geomapp.net/docs/MetadataComparison_200903.pdf)
- <http://www.bridges.state.mn.us/catalog.html>
- [http://gis.hsr.ch/wiki/OSGeodata_metadata_exchange_model](http://gis.hsr.ch/wiki/OSGeodata_metadata_exchange_model)
- [http://proceedings.esri.com/library/userconf/feduc10/papers/tech/feduc2010nap19115_arcgis.pdf](http://proceedings.esri.com/library/userconf/feduc10/papers/tech/feduc2010nap19115_arcgis.pdf)

<span style="text-decoration: underline;">**Scratch pad** </span>

- — <http://vmx.cx/cgi-bin/blog/index.cgi/geocouch-the-future-is-now%3A2010-05-03%3Aen%2CCouchDB%2CPython%2CErlang%2Cgeo>
- — See also: <http://nosql.mypopescu.com/post/392418792/translate-sql-to-mongodb-mapreduce>
- — <http://nosql.mypopescu.com/post/3083405951/an-introduction-to-the-hadoop-distributed-file-system>
- — <http://nosql.mypopescu.com/post/10982497586/the-oracle-nosql-database-11g>
- — <http://stackoverflow.com/questions/4905519/how-to-represent-spatial-data-in-cassandra>
- — <http://stackoverflow.com/questions/7903712/spatial-data-with-mongodb-or-cassandra>
- — <http://www.readwriteweb.com/cloud/2011/02/video-simplegeo-cassandra.php>
- — <http://pkghosh.wordpress.com/2010/12/28/geo-spatial-indexing-with-mongodb/>
- — <http://www.mail-archive.com/user@cassandra.apache.org/msg09705.html>
- — <http://stamen.com/>