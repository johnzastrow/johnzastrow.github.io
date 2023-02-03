---
id: 152
title: 'Run queries in sequence in Access'
date: '2011-04-22T15:31:04-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'https://johnzastrow.github.io/2011/04/22/run-queries-in-sequence-in-access/'
permalink: /2011/04/22/run-queries-in-sequence-in-access/
categories:
    - Uncategorized
---

I've gotten so used to using "real" databases, that I find myself frustrated when I have to switch back to Microsoft Access. But, hey, it's good for a lot of things.

Annoyingly, if you just want to run some SQL back-to-back, or one after another, you have to call it in VBA. So, create a module and do something silly like.

Sub update_results()  
DoCmd.SetWarnings False  
DoCmd.OpenQuery "q_1-4000"  
DoCmd.OpenQuery "q_4001-8000"  
DoCmd.OpenQuery "q_the_rest"  
DoCmd.SetWarnings True  
End Sub

The SetWarnings stuff stops pop ups from annoying you about the fact that you are going to update some data.

![](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2011/04/access_queries.png)

