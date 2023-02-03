---
id: 61
title: 'UPDATE_ON column in MySQL with trigger'
date: '2008-09-19T15:23:31-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'https://johnzastrow.github.io/2008/09/19/update_on-column-in-mysql-with-trigger/'
permalink: /2008/09/19/update_on-column-in-mysql-with-trigger/
categories:
    - Uncategorized
---

I needed to update a column with the date and time whenever a record changed in my database. So here is the recipe for the trigger in MySQL 5.0.

DELIMITER $$

CREATE  
 /\*[DEFINER = { user | CURRENT_USER }]\*/  
 TRIGGER `my_database`.`UpdatedOn` BEFORE UPDATE  
 ON `my_database`.`my_table`  
 FOR EACH ROW BEGIN  
set NEW.update_on = now();  
 END$$

DELIMITER ;