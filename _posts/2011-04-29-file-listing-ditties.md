---
id: 95
title: 'File listing ditties'
date: '2011-04-29T10:56:37-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'http://northredoubt.com/n/?p=95'
permalink: /2011/04/29/file-listing-ditties/
categories:
    - Linux
---

Here are some simple bash scripts to list files into a text files that can be used to catalog stuff. Most of the time I use the last one.   
```bash

filer=$(find . -mtime -1)  
sizer=$(ls -lah $filer | awk '{ print $5″\\t" $6″\\t" $7″\\t" $8″\\t" $9″\\t\
" }')  
echo $sizer

```

or this one

```bash  
ls -ghG –full-time | awk '{ print $1″\\t" $3 "\\t" $4 "\\t" $7 $8 $9 $10 $11 $12 "\
" }' &gt; files.txt  
cat files.txt  
```

The script above makes output as follows. The extra lines just made it easier for me to read. This one will output files with spaces in the name by removing the spaces (lumping the words together). If you don't like that, just put the " " between $7 $8 $9 etc. above.
```

> 
> [john.zastrow@appsrv ~]$ cat files.txt
> total
> 
> 
> 
> drwxr-xr-x.     4.0K    2011-03-24      Desktop
> 
> 
> 
> drwxr-xr-x.     4.0K    2011-03-24      Documents
> 
> 
> 
> drwxr-xr-x.     4.0K    2011-03-24      Downloads
> 
> 
> 
> -rwxrwxrwx      126     2011-04-29      filer1.sh
> 
> 
> 
> -rwxrwxrwx      158     2011-04-29      filer2.sh
> 
> 
> 
> -rwxrwxrwx      123     2011-04-29      filer3.sh
> 
> 
> 
> -rw-rw-r--      0       2011-04-29      files.txt
> 
> 
> 
> -rwxrwxrwx      73      2011-04-29      inter.sh
> 
```

Then this script



```bash  
#!/bin/sh  
date &gt; statfile.txt  
echo -e "File_type \\t Modified_date \\t Change_date \\t File_bytes \\t File_name" &gt;&gt; statfile.txt  
stat –printf "%F \\t %y \\t %z \\t %s \\t %N\
" \* &gt;&gt; statfile.txt  
cat statfile.txt

```


 is just a little different and produces the following output. Notice that in both script I'm using tabs so these text files should come into a spreadsheet program nicely as below. Also notice the use of –printf so that I can embed the tabs right into stat's output thereby more gracefully handling filenames with spaces in them (plus I quote them for good measure). A good use of this would be to combine find with it.

[![](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2011/04/stater_output-300x101.png "stater_output")](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/2011/04/stater_output.png)