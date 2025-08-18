---
layout: post
title: Creating a Custom QGIS Viewer
author: John Zastrow
subtitle: A simplified QGIS Experience for non-technical users
gh-badge: [star, fork, follow]
date: '2025-08-13T12:47:41-05:00'
tags: [qgis, gis, viewer, customization, open-source]
comments: false
---


**This is a living post. Check back for updates as I learned more.**

I've been doing GIS since 1994 and began with a platform then called [TNTmips](https://www.microimages.com/documentation/FeatureSummaries/index.htm). They have these great documents for [learning the platform](https://www.microimages.com/documentation/html/Categories/Terrain%20Analysis%20and%20Operations.htm) and they had a free viewer called [TNTatlas](https://www.microimages.com/documentation/Tutorials/tntatlx.pdf) that you could customize and distribute to clients, along with data. It was a great way to share data and maps with clients who didn't need all the tools of the full TNTmips platform. I haven't seen anything like that in other GIS platforms, so I wondered if I could do something similar with QGIS.

I've been using [QGIS](https://qgis.org) for years and have customized it to my liking. I recently wanted to make a simplified version of QGIS that I could use as a data viewer for clients who don't need all the tools and options that QGIS provides. I also wanted to make it easy to move between computers and operating systems (Windows and Linux).

<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/i6L84WMVka4?si=ds7lJqJ6ZdYIyosl" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## Process

1. Install all the things you want in your custom QGIS. This includes plugins, settings, and any other customizations you want to make.
   1. Create a geopackage with your favorite base maps and data to include in the custom QGIS.
   2. Connect to the geopackage and set up favorite layers and styles.
   3. Add any other data sources you want to include in the custom QGIS.
   4. Save the QGIS project into the geopackage.
   5. Customize the QGIS interface to remove unnecessary toolbars, panels, and menus.
   6. Set default project settings, such as coordinate reference systems and snapping options.
   7. Install and configure any plugins that you want to include in the custom QGIS
   8. Set up any custom styles, symbols, or templates that you want to include in the custom QGIS.
   9. Configure any other settings or options that you want to include in the custom QGIS.
   10. 
2. Locate your QGIS profile folder. This is where all your settings and customizations are
3. Copy the profile folder to a new location. This will be your custom QGIS profile.
4. Create a batch file (Windows) or shell script (Linux) to launch QGIS
5. Distribute the custom QGIS profile and the batch file/shell script to your clients.
6. Instruct your clients to place the custom profile folder in a location of their choice and run the batch file/shell script to launch QGIS with the custom profile.
7. Enjoy a simplified QGIS experience!
8. When you need to update the custom QGIS, simply update your original QGIS installation and copy the updated profile folder to your custom location.
9.  Redistribute the updated custom QGIS profile and batch file/shell script to your clients.
10. Instruct your clients to replace their existing custom profile folder with the updated one and run the batch file/shell script to launch the updated QGIS with the custom profile.
11. Repeat steps 8-10 as needed to keep your custom QGIS up to date.
12. Consider using a version control system (like Git) to manage changes to your custom QGIS profile and batch file/shell script. This will make it easier to track changes and revert to previous versions if needed.
13. Document any customizations or changes you make to the custom QGIS profile and batch file/shell script. This will help you remember what you've done and make it easier to share with others.
14. Test the custom QGIS profile and batch file/shell script on different computers and operating systems to ensure compatibility and functionality.
15. Provide support and assistance to your clients as needed to help them use the custom QGIS effectively.
16. Gather feedback from your clients to improve the custom QGIS experience and make any necessary adjustments.
17. Share your custom QGIS profile and batch file/shell script with the QGIS community
18. Consider creating a website or repository to host and share your custom QGIS profile and batch file/shell script with others who may find it useful.
19. Stay up to date with the latest QGIS releases and updates to ensure compatibility with your
20. custom QGIS profile and batch file/shell script.
21. 