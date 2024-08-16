---
id: 46
title: 'Putting your own content into a website with Google Maps'
date: '2008-07-21T21:43:17-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'https://johnzastrow.github.io/2008/07/21/putting-your-own-content-into-a-website-with-google-maps/'
permalink: /2008/07/21/putting-your-own-content-into-a-website-with-google-maps/
categories:
    - GIS
    - Web
---

So I'm doing a little research tonight on some requirements for a client:

1\. Embed a map in the client's home page (non-database driven ASP.Net which is essentially HTML) that depicts the county's watersheds and some number of additional layers  
2\. Let users click each watershed polygon to trigger an event that leads to them learning more about the conditions within the polygon (think old school image maps). This could be as simple as take the user to a static HTML page about the watershed.

The client currently supports ArcIMS (v9.1) and Google Maps. There is no immediate plan to move to ArcGIS server, though we will learn more next week.

I think that embedding ESRI in their pages for such a simple need is overkill and the client has already won awards for their use of Google Maps. So I'm researching options to use the Google Maps API and Google Gadgets to meet their needs

- See these links for some impressive examples. Note the use of non-Google data, and the events tied to the polygons. We might have enough here to work with.
- <http://code.google.com/apis/maps/documentation/demogallery.html>
- 
- [http://maps.forum.nu/gm_main.html](http://maps.forum.nu/gm_main.html) – looks like dynamic polys may be KML.
- 
- <http://gmaps-samples.googlecode.com/svn/trunk/poly/statemap.html> – click a state to see the GPolygon interaction
- 
- Looks like GPolygon might be enough. Not sure where the geometry has to come from to capture the events though. Can we just send KML and have the API figure out which polygons had the click?
- <http://code.google.com/apis/maps/documentation/reference.html#GPolygon>
- <http://gmaps-samples.googlecode.com/svn/trunk/poly/clickable.html>
- 
- This link seems to suggest options for feeding ArcIMS into Google Maps. Not bad.
- [http://www.mapdex.org/blog/index.cfm?mode=cat&amp;category_id= F4D2DF9D-A091-9FBE-E92623681946F858](http://www.mapdex.org/blog/index.cfm?mode=cat&category_id=F4D2DF9D-A091-9FBE-E92623681946F858)
- 
- 
- Here is a classic write up as well
- 
- 
- 
- If we just want to create static tiles (prolly all that is needed) we can use this in combination with ArcMap (or combine it with our internal developer's tile generator which is probably superior to it).
- <http://arcscripts.esri.com/details.asp?dbid=15524>
