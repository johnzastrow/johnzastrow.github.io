---
id: 618
title: 'Spatialite wishlist for 2013'
date: '2013-04-01T10:01:02-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=618'
permalink: /2013/04/01/spatialite-wishlist-for-2013/
categories:
    - 'Data processing'
    - Database
    - GIS
    - Spatialite
    - Uncategorized
---

The Spatialite project and its family of products is progressing and gaining a larger following by the day. Growth seems to be coming from its apparent target audience – mobile developers (though I rely on it for desktop use). This is likely to only snowball as Spatialite acceptance increases and it gets woven into increasing numbers of projects and workflows. Sandro and Brad and maybe a small handful of others are making methodical and incremental progress advancing it. It’s quality is improving and its features and capabilities are growing like the weeds in my yard. But, Spatialite and its team can be so much more. So here is my wish list based on more than two years of watching and using it.

First let me say that I’m truly writing in the spirit of constructive observations. I don’t want to be critical of the current project members as their patience and generosity are amazing. But beyond that, Sandro is the father of the project and,of course Spatialite is his to run any way he wishes.

So here are some wishlist items.

**Simpler, default use of spatial indexes in queries:** Right now in Spatialite you have to use sub-queries to use spatial indexes in your queries. It’s not the end of the world, and it does allow you a certain flexibility in crafting your code. But, they are easy to screw up and frankly it’s more typing for something that you want to do <del>often </del>nearly always. Other spatial DBs just use the indexes by default.

**A GIS GUI that makes full use of the capabilities** – The core Spatialite offers lots of cool little utility functions (i.e., **[SanitizeGeometry, ST\_IsValid, etc.](http://www.gaia-gis.it/gaia-sins/spatialite-sql-4.0.0.html#p10))**  in addition to the standard geoprocessing ones and they accessible from the command line via SQL statements. Now I’m fine with the command line, but I haven’t done GIS with flashing cursor in years. Sandro provides a nice little set of GUI tools, and I think he likes writing them. But they don’t expose ALL of the latest functions as I’m sure these take time to include. I’d rather the vast array of libspatialite functions get exposed through a single, go-to application instead of having to keep a few GUI utilities laying around or bounce between flashing cursors and mice. So, I’m really hoping for GUI controls in Qgis that will let me harness all of the power in Spatialite functions from within Qgis without having to keep both Qgis and a terminal open. This is going to get even more critical if the Geopackage spec gets cleaned up and goes anywhere.

**Larger Developer Community:** Spatialite really seems to be a labor of love to Sandro – and it shows with his support of user questions on the support list on [Google Groups](https://groups.google.com/forum/?fromgroups#!forum/spatialite-users). Similarly, development seems to be guided mostly by Sandro’s needs — which is fine to an extent. But the development road map lacks transparency – which is to say that it’s not missing, just needs some more daylight and/or planning. Users might have some inkling of major new initiatives that Sandro and Brad are working on when they have the time to write about them in an email or a wiki entry. But there is no complete public road map, no true work log, and mostly we hear about new tweaks such as SQL functions only after they are released. You can kinda see what HAS happened if you watch the [Fossil timelines](https://www.gaia-gis.it/fossil/libspatialite/timeline) – But this isn’t ideal. So, I am hopeful that this project will mature into one having a larger, interactive, transparent, diverse and functional developer community and that Sandro can and will allow other minds to influence the direction that future Spatialite development takes. In short, I think *<span style="text-decoration: underline;">the guys need help with the standard mechanics of OSS projects (development, documentation, outreach, etc.)</span>.*

**Documentation:** There used to be extensive documentation in verbose narrative form on scattered, stand-alone pages on the Spatialite site, but much of it is outdated. Sandro tries to keep up documenting the new features and changes, but I do think that more documentation would help. It would also be help if the documentation were provided in a more structured (perhaps even hierarchical) format instead of scattered across the Google Group email list and un-structured partially linked, non-hierarchical pages in the old Spatialite site and the new Fossil-based wiki. I’ve always been a big fan of the documentation provided by the folks at [PHP](http://php.net/manual/en/function.exif-imagetype.php) and [MySQL](http://dev.mysql.com/doc/refman/5.5/en/control-flow-functions.html). I tried once to contribute to writing documentation, but I’m not doing my personal and professional life well enough, and so I didn’t get very far.

**Better support for MS VC++ in general and non-manual support for system.data.sqlite:** Sandro and the other guys don’t like doing Windows. I get it. But people really want to be able get Spatialite happily integrated into their .Net development life – and these are people who don’t do ./configure \\ make \\ make install in their sleep. Sandro has posted notes for working with his project files in Visual Studio, but they frighten Microsoft-only folks. Sebastian\* found agony with this and created some additional work (<https://bitbucket.org/mayastudios>) to help him do Windows. But I hope that someone steps up to help the current project members maintain parallel builds and projects targeted at better supporting Windows and other platforms. Sandro and Brad maintain the core libs and do what they can to assist integration with other platforms. So some dedicated downstream maintainers for other platforms and builds are really needed.

**Less is more:** Honestly, Spatialite already has just about every spatial functions a person could want for 80% of their needs. It’s really quite complete that way. So, my personal wish is that the supporting documentation, utilities, interfaces, linkages and platforms get a little more attention now. But I think now that we are the reference implementation for vectors in the new OGC Geopackage spec more energy will likely be diverted there instead of shoring up these existing ancillary things – at least until new developers and helpers get involved.

So these are just a few items on my wishlist. We’ll see if the future takes us to places where they addressed or become irrelevant.

————————————-

\* From Sebastian about his bitbucket “It contains a VS 2010 solution to compile Spatialite. You need Mercurial though to check it out. Just downloading it from bitbucket won’t work because the repository uses sub repositories (which aren’t included in the download).” (you need to install mercurial to successfully work with his repos. If you’re just looking to clone (check out) the repository, use “hg clone \[url\] \[dir\]” or use [TortoiseHg](http://tortoisehg.bitbucket.org/)): The new tip (newest revision) builds Spatialite 4.0.0 on Windows.

- The repository ***spatialite-lib-windows*** just compiles the native (unmanaged) “spatialite.dll” – along with “sqlite.dll”, if you need it. The same is true for the<span style="text-decoration: underline;"> **“spatialite-lib-android”** </span>(former “spatialite-android-lib”) repository, just for Android. The repository “spatialite-android-java” (former “spatialite-android”) is obsolete.
- SQLite.Net started as a port of the Java SQLite bindings with the goal to allow it to be used cross-platform. At the time of writing, I was fairely new to SQLite and I couldn’t get “system.data.sqlite” compiled (AFAIK). So I sticked with my own implementation.
- <div><div>&gt;Does [sqlite.net](http://sqlite.net/) let me call spatialite more directly through .Net?</div><div><span style="font-family: arial, sans-serif;"> – No, that’s what [spatialite.net](https://bitbucket.org/mayastudios/spatialite.net) is for. It allows you to directly bind/obtain geometry objects (provided by NTS) to/from the database.</span></div></div><div><div><span style="font-family: arial, sans-serif;">&gt;</span>Are you also the author of the other projects I see at Maya Studios?</div></div><div> -Yes, I’m the author of all of them.</div>
- If you’re just looking for the Spatialite binaries, you can download them here: [https://bitbucket.org/<wbr></wbr>mayastudios/files/src](https://bitbucket.org/mayastudios/files/src)
- Sebastian just recently posted this to the Spatialite Google Group for those needing Spatialite on Windows. 
    - “Just a quick note for people looking for a way to compile Spatialite 4 on Windows (with Visual Studio) or Android. I’ve compiled project files/build files for both and placed them in public Mercurial repositories: 
        - For Windows: [https://bitbucket.org/<wbr></wbr>mayastudios/spatialite-lib-<wbr></wbr>windows](https://bitbucket.org/mayastudios/spatialite-lib-windows)  
            $ hg clone [https://bitbucket.org/<wbr></wbr>mayastudios/spatialite-lib-<wbr></wbr>windows](https://bitbucket.org/mayastudios/spatialite-lib-windows)
        - For Android: [https://bitbucket.org/<wbr></wbr>mayastudios/spatialite-lib-<wbr></wbr>android](https://bitbucket.org/mayastudios/spatialite-lib-android)  
            $ hg clone [https://bitbucket.org/<wbr></wbr>mayastudios/spatialite-lib-<wbr></wbr>android](https://bitbucket.org/mayastudios/spatialite-lib-android)
        
        You need [Mercurial](http://mercurial.selenic.com/) (hg) to check out these repositories. You cannot just download them, as they contain sub repositories that won’t be included in the download.
        
        If you’re just interested in the resulting binary, you can download them here:
        
        [https://bitbucket.org/<wbr></wbr>mayastudios/files/src](https://bitbucket.org/mayastudios/files/src)“
- Also see: **\[SpatiaLite-Users\] SpatiaLite v4 with c# on VS2012.** ***Vittorio Maniezzo via googlegroups.com.***
    
    ***Apr 10, 2013***
- To spatialite-users.  
    As a couple of people asked me for this, maybe there are more out there interested.  
    I uploaded on my server (at [http://astarte.csr.unibo.it/snippets/testSpatialite4.zip ](http://astarte.csr.unibo.it/snippets/testSpatialite4.zip))  
    a very bare VS2012 c# project using SL 4.0.0. It’s not that much complete: the 32 bit version works fine, the 64 bit not yet. But in the near future I won’t have time to work on this, so maybe someone can help.  
    Cheers,  
    Vittorio