---
id: 197
title: 'Use Excel&#8217;s MID and FIND to extract characters from varying positions'
date: '2011-07-08T12:28:13-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'https://johnzastrow.github.io/2011/07/08/use-excels-mid-and-find-to-extract-characters-from-varying-positions/'
permalink: /2011/07/08/use-excels-mid-and-find-to-extract-characters-from-varying-positions/
categories:
    - 'Data processing'
---

Use this to grab the values after a certain value, of the whole string the value doesn't exist. The concatenation ensure that the value is always found. The final Len(A1) forces the entire length of the string after the value to be shown regardless of what it it. the final A1 in the formula shows the entire string if the value is not found anywhere in the string.

**IF(FIND(".",CONCATENATE(A1,".")) &lt;= LEN(A1), MID(A1, FIND(".", A1) + 1,LEN(A1)), A1)**

| hhhh.yuuuu | yuuuu |
|---|---|
| hhgff.1.2.3 | 1.2.3 |
| fgdfgf.fdgdfg.fgfd | fdgdfg.fgfd |
| t.6364y | 6364y |
| A888999 | A888999 |

Use this to find values between two values.  
**MID(A8,FIND("(",A8)+1,FIND(")",A8)-FIND("(",A8)-1)**

| <span style="color: #000000;">555 (999-0000)</span> | 999-0000 |
|---|---|

This one find text always to the right of a value (assumes within the last 5 chars) of a string.

| **<span style="color: #000000;">IF(FIND(".",CONCATENATE(A13,".")) &lt;= LEN(A13),RIGHT(A13,FIND(".",RIGHT(A13,5))+2),A13)</span>** |
|---|
| <span style="color: #000000;">filename.doc</span> | .doc |
| <span style="color: #000000;">hfhg/fghfgh/hh</span> | hfhg/fghfgh/hh |

