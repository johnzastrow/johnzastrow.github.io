---
layout: post
title: Utilities for GIS data file discovery and documentation
subtitle: GIS metadata stubbing scripts using OSgeo tools
gh-badge: [star, fork, follow]
date: '2024-03-20T12:47:41-05:00'
tags: [gis]
comments: true
---

I love geospatial metadata [https://gisgeography.com/gis-metadata/], both human (often narrative text) and machine metadata (derived from the data themselves, but written out for humans and machines to see). As a GIS user we spend a lot of time prospecting for usable data to meet our needs. Finding data is only the middle step in eventually using the data. Next you need to determine if those data meet your needs in terms of coverage (spatial and temporal), quality and technical considerations such as how the data were collected, pre/post processed, and later maintained. Good geospatial metadata can provide all of this if it is maintained. Really good human metadata, written by thoughtful humans, can be delightful to read - at least for me.

I'm shocked to say it, but I've always loved Esri's handling of metadata. Historically ArcMap made it straightforward to create at least some kind of metadata for each layer (both in file form and in databases), and then to maintain it. I actually used the option to automatically record processing steps from the software into the metadata for final versions of layers. I liked that it made well-formed XML to ride along with my files, and the same XML was stored in the arcane SDE tables (those I didn't like) with any layer ArcMap could read. 

But going back years [https://gis.stackexchange.com/questions/40994/standard-for-storing-human-metadata-in-spatial-databases], I've dreamed of similar solutions for open source GIS. Now that I don't use Esri software any longer, that need is even more acute.

https://archaeogeek.github.io/qgis-uk-glasgow-2016-metadata/#/

https://gis.stackexchange.com/questions/465082/adding-metadata-that-describes-each-attribute-field-in-qgis
https://mapscaping.com/symbology-and-metadata-in-a-geopackage-in-qgis/




