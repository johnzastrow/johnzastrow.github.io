---
id: 216
title: 'Read the Descriptions from all columns in MS Access database'
date: '2011-07-25T09:15:18-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=216'
permalink: /2011/07/25/read-the-descriptions-from-all-columns-in-ms-access-database/
categories:
    - Database
    - GIS
---

From one of my developers. This VBA (couldn't find an approach in .Net) will loop through all the tables and write out the description from all the fields.

TODO's include grabbing descriptions for tables and then tweaking below to create ALTER statements so that the comments can be applied to a server RDBMS after migration from Access (since almost none of the migration utilities I've seen migrate this documentation from Access).

Option Explicit

```vb
call readAllTables  
Public Function readAllTables()

Dim DB As Database, tbl As TableDef, fld As DAO.Field

Dim RS As Recordset  
Dim Table As String  
Dim allDesc As String

Set DB = CurrentDb()

For Each tbl In DB.TableDefs  
If Left$(tbl.Name, 4) &lt;&gt; "MSys" Then  
'Debug.Print "In Table " &amp; tbl.Name '&amp; " " &amp; tbl.DateCreated &amp; " " &amp; tbl.LastUpdated &amp; " " &amp; tbl.RecordCount  
allDesc = allDesc &amp; vbNewLine &amp; "Table:" &amp; tbl.Name  
' optional code to print all the fields  
On Error Resume Next  
For Each fld In tbl.Fields  
'Debug.Print fld.Name  
allDesc = allDesc &amp; vbNewLine &amp; fld.Name &amp; ":" &amp; fld.Properties("Description")  
Next fld  
End If  
Next tbl

WriteToATextFile (allDesc)  
End Function

Sub WriteToATextFile(ByVal outputStr)  
'first set a string which contains the path to the file you want to create.  
'this example creates one and stores it in the root directory  
Dim MyFile As String  
MyFile = "c:\\" &amp; "TableFieldsWithDesc.txt"  
'set and open file for output  
Dim fnum As Integer  
fnum = FreeFile()  
Open MyFile For Output As fnum  
'write project info and then a blank line. Note the comma is required  
Write #fnum, outputStr  
Write #fnum,  
Close #fnum  
End Sub\

```