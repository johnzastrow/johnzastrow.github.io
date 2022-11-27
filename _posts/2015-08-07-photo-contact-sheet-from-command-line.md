---
id: 872
title: 'Photo contact sheet from command line'
date: '2015-08-07T14:47:54-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=872'
permalink: /2015/08/07/photo-contact-sheet-from-command-line/
categories:
    - Cywgin
    - 'Data processing'
    - 'Home and Family'
    - Linux
---

Recently I needed to inventory a bunch of equipment at a client so I went armed with camera and took a bunch of pictures and notes and came home. Ultimately what I wanted was one or more files containing thumbnails of each image along with the filename below it to include in the report. I suspected that there was a command line way to do this – in Windows – and there is. Through the power of [Cygwin](https://www.cygwin.com/) (a surprisingly complete Linux CLI environment that runs on Windows), the magic of [Imagemagick](http://studio.imagemagick.org/script/index.php) and the guidance from the post below, I created my own recipe.

<http://blog.patdavid.net/2013/04/using-imagemagick-to-create-contact.html>

Here is my command line to transform a directory of .jpg files into a few (3 in my case) contact sheets also in jpg format.

```
montage -verbose -label '%f' -font Helvetica -pointsize 16 -background '#ffffff' -fill 'black' -tile 3x4 -define jpeg:size=400x400 -geometry 400x400 -auto-orient *.jpg contact-light.jpg
```

Read the blog above and Imagemagick docs to explain the switches. I did change a few things in the blog’s example. I bumped up the resolutions of the images, (and hence the contact sheet) a bit, made it black text on white, bigger font, and limited the images to 3×4 pics per page using the tile options.

Since I used Cygwin on Windows I installed all the Imagemagick utils through the easy to use Cygwin installer, as well as Ghostscript and all the fonts I could find for it.

Below is the result.

[![contact-dark2-2b](http://northredoubt.com/n/wp-content/uploads/2015/08/contact-dark2-2b-214x300.jpg)](http://northredoubt.com/n/wp-content/uploads/2015/08/contact-dark2-2b.jpg)