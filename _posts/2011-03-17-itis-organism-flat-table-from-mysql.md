---
id: 134
title: 'ITIS Organism Flat table from MySQL'
date: '2011-03-17T15:03:30-05:00'
author: 'John C. Zastrow'
layout: post
guid: 'https://johnzastrow.github.io/2011/03/17/itis-organism-flat-table-from-mysql/'
permalink: /2011/03/17/itis-organism-flat-table-from-mysql/
categories:
    - Uncategorized
---

I need to make a table to look up common (vernacular) names for some organisms. So I imported the USGS ITIS database from text files into MySQL and created this little view. Hopefully this helps someone else.

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v\_flat\_table` AS   
SELECT  
 `taxonomic\_units`.`tsn` AS `tsn`,  
 `taxonomic\_units`.`unit\_ind1` AS `unit\_ind1`,  
 `taxonomic\_units`.`unit\_name1` AS `unit\_name1`,  
 `taxonomic\_units`.`unit\_ind2` AS `unit\_ind2`,  
 `taxonomic\_units`.`unit\_name2` AS `unit\_name2`,  
 `taxonomic\_units`.`unit\_ind3` AS `unit\_ind3`,  
 `taxonomic\_units`.`unit\_name3` AS `unit\_name3`,  
 `taxonomic\_units`.`unit\_ind4` AS `unit\_ind4`,  
 `taxonomic\_units`.`parent\_tsn` AS `parent\_tsn`,  
 `taxonomic\_units`.`update\_date` AS `update\_date`,  
 `taxon\_unit\_types`.`rank\_name` AS `rank\_name`,  
 `vernaculars`.`vernacular\_name` AS `vernacular\_name`,  
 `longnames`.`completename` AS `completename`  
FROM (((`taxon\_unit\_types`  
 JOIN `taxonomic\_units`  
 ON (((`taxon\_unit\_types`.`rank\_id` = `taxonomic\_units`.`rank\_id`)  
 AND (`taxon\_unit\_types`.`kingdom\_id` = `taxonomic\_units`.`kingdom\_id`))))  
 LEFT JOIN `vernaculars`  
 ON ((`vernaculars`.`tsn` = `taxonomic\_units`.`tsn`)))  
 LEFT JOIN `longnames`  
 ON ((`longnames`.`tsn` = `taxonomic\_units`.`tsn`)))

