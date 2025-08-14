---
layout: post
title: Rapid QGIS reinstalls - Portable settings and profiles
subtitle: Customizing, moving or reinstalling Qgis just got easier for me
gh-badge: [star, fork, follow]
tags: [qgis, gis]
comments: false
---

**This is a living post. Check back for updates as I learned more.**

Last updated: 2025-08-14

I find myself installing [Qgis](https://qgis.org) several times per year, and sometimes monthly (long story) and then spend the next day or two setting things up the way I like them. I knew that years ago the story around rapidly copying settings from one install to the next wasn't perfect, but I recently looked at it again.

I believe that the current condition is better and looks like the following. It's based on reusing a single directory that contains everything (I think) you need to redeploy Qgis with all your customizations. [Work with User Profiles](https://docs.qgis.org/3.40/en/docs/user_manual/introduction/qgis_configuration.html#user-profiles) in the Qgis documentation for the authoritative information. See also [pygis for user profiles](https://qgis.org/pyqgis/3.40/core/QgsUserProfileManager.html), [blog from developer, Nyall Dawson](https://nyalldawson.net/2022/11/28/qgis-user-profiles-are-here/), [and](https://www.northrivergeographic.com/qgis-profiles/), [also a tutorial](https://www.spatialnasir.com/2024/04/how-create-manage-user-profiles-qgis.html), [cli-style](https://gis.stackexchange.com/questions/374226/launching-qgis-with-specific-user-profile), and [a video tutorial](https://youtu.be/mKTRHL5YLjI?si=zaF3Gjilk38qkIVB), and [another video](https://youtu.be/9qJBPY2fjoY?si=U1mxJwkSWEt5hB4W).

This paragraph from the docs is informative. The isolation, including installed plugins, is nice so that I can create profiles for the particular work that I'm doing and have the tools appear exactly as I like them for that job.

*"As each user profile contains isolated settings, plugins and history they can be great for different workflows, demos, users of the same machine, or testing settings, etc. And you can switch from one to the other by selecting them in the Settings ► User Profiles menu. You can also run QGIS with a specific user profile from the command line.*

*Unless changed, the profile of the last closed QGIS session will be used in the following QGIS sessions."* The information about the last closed profile is important because it means that you can switch profiles and then close Qgis, and the next time you start Qgis it will use that profile. This information is stored in the *profiles.ini* file in the user profile directory, with content like this:

```
[core]
lastProfile=AdvancedUser
```

Here is the directory structure of a profile (settings) for the user *SimpleUser*. Since I stripped down the toolbars to make a simple data explorer out of Qgis, it  made the *QGISCUSTOMIZATIONS.ini* file for me.

![](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/33c585aa4d205f3ae771b5187e70c634cfc0a7c7.png)

The user profile folder seems to contain all settings, plugins, and caches used by the user. To experiment I simply copied my *default* user folder (64MB) to *CopiedDefaultUser*. 

![](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/8f83f436b35dc2dfcce00f9e79e45496a86fa37e.png)

and then chose that user under *Settings/User Profiles*

![](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/308488efb711756927c44c0f20bc29af43e8b550.png)

Here is the default user screenshot showing the toolbars and plugins installed

![](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/default_user.png)

Here is the copied default user after simply copying the profile. Notice the top of screen where the profile name is shown. The toolbars and plugins are the same as the default user.

![](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/copied_user.png)

When you switch between profiles, Qgis spawns a new instance under that profile name.

![](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/SwitchingUsers.png)

BTW, I spend about half my time in Linux ([Ubuntu MATE](https://ubuntu-mate.org/) flavor to be exact) and here is profiles look like in Linux - pretty much the same but under the user home directory under *.local/share/QGIS/QGIS3/profiles/*

![](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/QgisProfilesMATE.png)
