---
layout: post
title: Speeding up Qgis Mapped Drives
author: John Zastrow
subtitle: More is not always better
gh-badge: [star, fork, follow]
date: '2025-08-20T12:47:41-05:00'
tags: [qgis, gis, viewer, customization, open-source]
comments: false
---


Mostly a note to self, but maybe it will help someone else. Everytime I setup a new install of Qgis on a new OS, I map into my massive network drive that has all my data on it. I have a lot of data, and I have a lot of directories and subdirectories. 

BUT.. Qgis hates it.

My goldfish memory always forgets that this is a bad idea and I spend day looking for exotic fixes. Invariably I come back to creating a decicated mapped drive that only has the directories I need for my QGIS project, which solves the problem every time.

Mr. AI will now tell you why this is a problem and how to fix it.

Mapped drives with deep directory structures can cause QGIS to take a long time to start up. This is because QGIS tries to read all the directories and files in the mapped drive when it starts up, which can take a long time if there are many files and directories. Eventually, QGIS will time out and stop trying to read the mapped drive, but this can take a long time and cause QGIS to be unresponsive during startup, but also it can cause QGIS to crash if the mapped drive is too slow to respond, or just keep the little spinning wheel going indefinitely.

Qgis relies on the operating system to read the mapped drives, so there is not much you can do in QGIS to speed this up. However, you can try the following:

1. **Reduce the number of files and directories in the mapped drive**: If you have a lot of files and directories in the mapped drive, try to reduce the number of files and directories by moving them to other locations or deleting unnecessary files.
2. **Create a shallower / smaller mapped drive**: Probably the best solution is to create a shallower or smaller mapped drive. This can be done by creating a new mapped drive that only contains the directories and files you need for your QGIS project. This will reduce the number of files and directories that QGIS has to read when it starts up, which can significantly speed up startup time.
3. **Use a local copy of the data**: If you have a lot of data
4. on the mapped drive, consider copying the data to a local drive and using that instead. This can significantly speed up QGIS startup, as it will not have to read the mapped drive at all.
5. **Use a network drive instead of a mapped drive**: If you are using a mapped drive, consider using a network drive instead. This can help speed up QGIS startup, as the operating system will not have to read the mapped drive at all.
