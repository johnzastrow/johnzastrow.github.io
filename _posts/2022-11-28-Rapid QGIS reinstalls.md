---
layout: post
title: Rapid QGIS reinstalls - Portable settings and profiles
subtitle: Moving or reinstalling Qgis just got easier for me
gh-badge: [star, fork, follow]
tags: [qgis, gis]
comments: false
---

This is a living post. Check back for updates as I learned more.

I find myself installing Qgis several times per year, and sometimes monthly (long story) and then spend the next day or two setting things up the way I like them. I knew that years ago the story around rapidly copying settings from one install to the next wasn't perfect, but I recently looked at it again.

I believe that the current condition is better and looks like the following. 

Here is the directory structure of a profile (settings) for the user SimpleUser. Since I stripped down the toolbars to make a simple data explorer out of Qgis, it  made the QGISCUSTOMIZATIONS.ini files for me.

![](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/33c585aa4d205f3ae771b5187e70c634cfc0a7c7.png)

The user profile folder seems to contain all settings, plugins, and caches used by the user. To experiment I simply copied my *default* user folder (64MB) to *CopiedDefaultUser* 

![](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/8f83f436b35dc2dfcce00f9e79e45496a86fa37e.png)

and then chose that user under *Settings/User Profiles*

![](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/308488efb711756927c44c0f20bc29af43e8b550.png)

Here is the default user screenshot showing the toolbars and plugins installed

![](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/default_user.png)



Here is the copied default user after simply copying the profile

![](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/copied_user.png)


