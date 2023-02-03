---
id: 18
title: 'Reformatting a text field in Microsoft Access to be a true date'
date: '2008-07-05T20:24:22-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'https://johnzastrow.github.io/2008/07/05/reformatting-a-text-field-in-microsoft-access-to-be-a-true-date/'
permalink: /2008/07/05/reformatting-a-text-field-in-microsoft-access-to-be-a-true-date/
categories:
    - Database
---

I had a text field (DATEOLD) with values like 20030526, that were dates in YYYYMMDD.

I needed these values to exist in a true datetime field in Microsoft  
Access. So I created a new field called NEWDATE of the date/time type.

Then I ran the query below to convert the numbers.

UPDATE Itec_data1  
SET [NEWDATE] = format(DateSerial (left([DATEOLD],4), mid([DATEOLD],5,2), right([DATEOLD],2)),"yyyy/mm/dd");

Because dates and times are stored as integers and decimals  
respectively, with two datetime fields (DATE and TIME) you can create a  
third and final datetime field (DATETIMER) simply by adding them.

UPDATE Itec_data1  
SET [DATETIMER] = [DATE]+[TIME];