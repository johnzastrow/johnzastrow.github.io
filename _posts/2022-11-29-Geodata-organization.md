---
layout: post
title: Organizing spatial data (or just data) for organizations
subtitle: My approach for keeping data from spawling like basket of socks
gh-badge: [star, fork, follow]
tags: [geodata, gis, spatial, data management]
comments: false
---

**This is a living post. Check back for updates as I learned more.**

#### Data Directory Structures

{: .box-note}

I've used this approach several times with years between and each time I have to develop it from memory. So I'm going to put it here for future use and revision. Hopefully it helps you too.



The design of the structures defined below should directly  in this document were inspired by concepts found in the [Spatial Data Standards for Facilities, Infrastructure, and Environment (SDSFIE) version 2.6](https://www.sdsfieonline.org/) , related Geofidelis guidance, and the [Maine State GIS Catalog]([Maine Office of GIS]([Data Catalog](https://www.maine.gov/geolib/catalog.html))) public geospatial data access pages . 

**DELIVERABLES** - directories by delivery year then project name containing final products from either GPMCT or other parties. Files in these project directories should never change and never be added to.

Products may be data as well as documents. Data should be considered read-only - stored exactly as delivered without changes, additions, or restructuring. Data to be used should be copied into working directories outside the DELIVERABLES tree.

```
 2019
     Project_Name_A
     Project_Name_B
 2020
     Project_Name_C
     Project_Name_ D
```

**MAIN** - directories by subject then by year containing finalized, authoritative data that is the most recent, validated, complete, and approved data owned by GPMCT. Files in these subject directories should only change when 1) a new final version is available, 2) new authoritative files are added to GPMCT’s holdings, or 3) data should be removed because they are deemed too problematic for use.

Data should be considered read-only until replaced by a newer finalized version. Data can be displayed from the MAIN tree, but should not be edited there. The MAIN tree should not contain working data. Data will be updated following GPMCT data stewardship guidelines from the data management plan, or as improvements become available, until the end of the year. Then the year directories are copied to make the next year unless the data did not change in the prior year. This approach allows for historical change tracking at the cost of increased data storage.

**Working** - any directories created outside of DELIVERABLES and MAIN used for intermediate processing. Input data should be copied from the MAIN or DELIVERABLES trees before used in processing. 

{: .box-warning}
From an older version of SDSFIE than is current. I can't access SDSFIE materials any more as it's primarily a function for federal organizations, like defense installations, and the current useful tools and documentation are largely locked away... because how a base stores information about their roads and swampy hazards is a matter of national security it seems.

| SDSFIE 2.6 Classes        | Maine State GIS Entity Classes                       | GPMCT Subject Directory Name | Contents                                                                                                        |
| ------------------------- | ---------------------------------------------------- | ---------------------------- | --------------------------------------------------------------------------------------------------------------- |
| Boundary                  | Administrative and political boundaries              | Boundaries                   | Administrative and political boundaries. County Boundaries, Trust boundaries                                    |
| Organisms, Ecology        | Biologic and ecologic ⁄ Environment and conservation | Biota_Ecological             | Biological, ecological, Environmental, conservation. Not natural resource management                            |
| Cadastre                  | Cadastral and land planning                          | Cadastre                     | Parcels, Zoning, Street addresses                                                                               |
| Cultural, Demographic     | Cultural, society, and demographic                   | Cultural_Demographic         | Consider replacing with Locations                                                                               |
|                           | Elevation and derived products                       | Elevation                    | LIDAR, DEM, Slope products.                                                                                     |
| Real Property             | Facilities and structures                            | Facilities_Structures        |                                                                                                                 |
| Geology                   | Geological and geophysical                           | GeoPhysical                  |                                                                                                                 |
| Visual Sensor, Landform   | Imagery, base maps, and land cover                   | Imagery                      |                                                                                                                 |
| Geodetic                  | Locations and geodetic networks                      | Locations                    | Geodetic points, social/societal point of interest, historical features                                         |
| Hydrography               | Oceans and estuaries ⁄ Inland water resources        | Hydrography                  | Marine and surface freshwater. Including                                                                        |
| Improvement               | Transportation networks                              | Transportation               |                                                                                                                 |
| Utilities, Communications | Utility and communication networks                   | Utilities                    |                                                                                                                 |
| LandStatus                | --                                                   | Land_Characteristics         | Land use, impervious surface. Not ecological, natural resources, or geophysical.                                |
| Future Projects           | --                                                   | Planning                     | Features of future work that may be incorporated into other data when completed                                 |
| Climate                   | --                                                   | Climate                      | Meteorological data, but not physical installations.                                                            |
| Hazards                   | --                                                   | Hazards                      | Not used                                                                                                        |
|                           | --                                                   | Natural_Resources            | Forestry, fisheries. Towards yield / standing crop/harvestable biomass assessment, not biological or ecological |

Creation Scripts

```bash
mkdir -p DATA/MAIN/Boundaries/2022
mkdir -p DATA/MAIN/Biota_Ecological/2022
mkdir -p DATA/MAIN/Cadastre/2022
mkdir -p DATA/MAIN/Cultural_Demographic/2022
mkdir -p DATA/MAIN/Elevation/2022
mkdir -p DATA/MAIN/Facilities_Structures/2022
mkdir -p DATA/MAIN/GeoPhysical/2022
mkdir -p DATA/MAIN/Imagery/2022
mkdir -p DATA/MAIN/Locations/2022
mkdir -p DATA/MAIN/Hydrography/2022
mkdir -p DATA/MAIN/Transportation/2022
mkdir -p DATA/MAIN/Utilities/2022
mkdir -p DATA/MAIN/Land_Characteristics/2022
mkdir -p DATA/MAIN/Planning/2022
mkdir -p DATA/MAIN/Climate/2022
mkdir -p DATA/MAIN/Hazards/2022
mkdir -p DATA/MAIN/Natural_Resources/2022
mkdir -p DATA/DELIVERABLES/2022/Project_A
mkdir -p DATA/DELIVERABLES/2022/Project_B
```
