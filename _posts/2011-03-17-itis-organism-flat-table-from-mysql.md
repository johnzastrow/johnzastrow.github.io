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

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_flat_table` AS   
SELECT  
 `taxonomic_units`.`tsn` AS `tsn`,  
 `taxonomic_units`.`unit_ind1` AS `unit_ind1`,  
 `taxonomic_units`.`unit_name1` AS `unit_name1`,  
 `taxonomic_units`.`unit_ind2` AS `unit_ind2`,  
 `taxonomic_units`.`unit_name2` AS `unit_name2`,  
 `taxonomic_units`.`unit_ind3` AS `unit_ind3`,  
 `taxonomic_units`.`unit_name3` AS `unit_name3`,  
 `taxonomic_units`.`unit_ind4` AS `unit_ind4`,  
 `taxonomic_units`.`parent_tsn` AS `parent_tsn`,  
 `taxonomic_units`.`update_date` AS `update_date`,  
 `taxon_unit_types`.`rank_name` AS `rank_name`,  
 `vernaculars`.`vernacular_name` AS `vernacular_name`,  
 `longnames`.`completename` AS `completename`  
FROM (((`taxon_unit_types`  
 JOIN `taxonomic_units`  
 ON (((`taxon_unit_types`.`rank_id` = `taxonomic_units`.`rank_id`)  
 AND (`taxon_unit_types`.`kingdom_id` = `taxonomic_units`.`kingdom_id`))))  
 LEFT JOIN `vernaculars`  
 ON ((`vernaculars`.`tsn` = `taxonomic_units`.`tsn`)))  
 LEFT JOIN `longnames`  
 ON ((`longnames`.`tsn` = `taxonomic_units`.`tsn`)))

