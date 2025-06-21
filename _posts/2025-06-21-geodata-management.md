---
layout: post
title: GeoData Management Plan
subtitle: General plan for non-technical non-profits
gh-badge: [star, fork, follow]
date: '2025-06-21T12:47:41-05:00'
tags: [GIS, data, geospatial, management]
comments: true
---



# **CONTENTS** {#contents}

[CONTENTS](#contents)

[TODOs](#todos)

[INTRODUCTION](#introduction)

[GOALS](#goals)

[SPECIFICATIONS and DATA STANDARDS](#specifications-and-data-standards)

[Data Directory Structures](#data-directory-structures)

[Subdirectories of the MAIN top-level directory](#subdirectories-of-the-main-top-level-directory)

[Directory creation script](#directory-creation-script)

[Formats to be avoided](#formats-to-be-avoided)

[GIS Data Coordinate Reference Systems (CRS)](#gis-data-coordinate-reference-systems-\(crs\))

[EPSG:26919 \- NAD83 / UTM zone 19N (from https://epsg.io/26919-1721)](#epsg:26919---nad83-/-utm-zone-19n-\(from-https://epsg.io/26919-1721\))

[Common Attribute Data Structures and Types](#common-attribute-data-structures-and-types)

[User, Groups, and Permissions](#user,-groups,-and-permissions)

[APPENDIX](#appendix)

[BASH Shell Script for Inventorying Data Files](#bash-shell-script-for-inventorying-data-files)

[GIS Metadata](#gis-metadata)

# 

# **TODOs** {#todos}

* Identify authoritative, current layers for summary views/basemaps: environmental and nat res management, land cover  
* Improve descriptions of the contents of each layer being maintained. \- In progress  
* Add references to each figure and table  
* Denote layers used for common base map and make them available in an online viewer  
* Change MAIN subject directories to be lowercase, revise creation script  
* Re-reference Leah’s data to make sure all present \- In progress

# **INTRODUCTION** {#introduction}

This plan describes how Great Pond Mountain Conservation Trust (GPMCT) consolidated and organized geospatial data to follow a consistent, intuitive, and documented structure. This structure, and associated guidance, are used throughout GPMCT and its projects to store and maintain an authoritative data repository that remains interoperable with as many users and software as possible. This plan is meant to evolve and be revised as data stewardship changes at GPMCT.

# **GOALS** {#goals}

The focus of the data management approach is on managing data as a simple-yet-structured collection of data, with flexible conventions to allow adaptations to changing data and uses. These design attributes will be balanced against providing enough rigor so that the structures provide predictability and standardized organization for end users and systems.  Because of the many potential consumers of the data, and the heterogeneous nature of the software environments, the portability of the structures and the data formats of the physical files must be considered.  More detailed objectives responding to existing issues are the following:

The following detailed objectives were considered during the design:

* Data structures will be accessible and easy to understand, such that the casual GIS user, new to GPMCT, will be able to quickly locate authoritative data to build maps and conduct desktop analysis with limited guidance. This ease of use should increase opportunities for additional staff to easily use the data and trust that they are using the most recent, validated, complete, and approved data available.  
* Data files, substructures, and their names should be consistent and self-documenting to reduce the need for extensive, layer-specific documentation for casual use.   
* The design should improve the consistency, retrievability, and understandability of deliverables to and from GPMCT. 


# **SPECIFICATIONS and DATA STANDARDS** {#specifications-and-data-standards}

## **Data Directory Structures** {#data-directory-structures}

The design of the structures defined below was inspired by concepts found in the Spatial Data Standards for Facilities, Infrastructure, and Environment (SDSFIE) version 2.6 ([https://www.sdsfieonline.org/](https://www.sdsfieonline.org/)), related Geofidelis guidance, the former Maine State GIS Catalog public geospatial data access pages ([http://www.maine.gov/megis/catalog/](http://www.maine.gov/megis/catalog/)), and the ISO 19115 Topic Categories specification ([ISO 19115 Topic Category (usgs.gov)](https://apps.usgs.gov/thesaurus/thesaurus-full.php?thcode=15) ). Note that many computer systems are case-sensitive, so the convention is to keep names in lower-case letters, and not begin with numbers or special characters, except the directories.

**PROJECTS** \- directories by delivery year then project name containing final products from either GPMCT or other parties. *Files in these project directories are intended to be final deliverables and not meant to be working files. They should never change and never be added to.*

Project files may be any type of data as well as documents. These files should be considered read-only and stored exactly as delivered without changes, additions, or restructuring. Files should be copied from the PROJECTS directories to other places outside the PROJECTS tree if used for further work aside from simple display. 

**MAIN** \- directories by subject and then by year containing finalized, authoritative data that is the most recent, validated, complete, and approved data owned by GPMCT. Subdirectories may be created to group related files. *Files in these MAIN directories should only change when 1\) a new final version is available (edit), 2\) new authoritative files are added to GPMCT’s holdings (add), or 3\) data should be removed because they are deemed too problematic for use (delete).*

**Example Directory Tree**

├── DATA  
│   ├── PROJECTS  
│   │   └── 2022  
│   │       ├── project\_A  
│   │       └── project\_B  
│   └── MAIN  
│       ├── biota\_ecological  
│       │   └── 2022  
│       ├── boundaries  
│       │   └── 2022  
│       │       └── ag\_districts  
│       │           ├── agALLny2022.cpg  
│       │           ├── agALLny2022.dbf  
│       │           ├── agALLny2022.prj  
│       │           ├── agALLny2022.shp  
│       │           ├── agALLny2022.shx

Data should be considered read-only until replaced by a newer finalized version. Data can be displayed from the MAIN tree, but should not be edited there. Data will be updated following GPMCT data stewardship guidelines from the data management plan, or as improvements become available, until the end of the year. Then the year directories are copied to make the next year unless the data did not change in the prior year, in which case no change is made and data remain in the prior year’s directory. This approach allows for historical change tracking at the cost of increased data storage and allows references to historical data to remain intact.

**Working** \- any directories created outside of PROJECTS and MAIN used for intermediate processing. Input data should be copied from the MAIN or PROJECTS trees before being used in processing.


​                                                                                                                                                   	

### Subdirectories of the MAIN top-level directory {#subdirectories-of-the-main-top-level-directory}

| SDSFIE 2.6 Classes | Maine State GIS Entity Classes | ISO 19115 Topic Category | GPMCT Subject Directory Name (layer prefix) | GPMCT Layer Prefix | Contents |
| ----- | ----- | :---: | :---: | :---: | ----- |
| Organisms, Ecology | Biologic and ecologic ⁄ Environment and conservation | biota | **biota\_ecological** | bio | Biological, ecological, Environmental, conservation. Not natural resource management. Flora or fauna in the natural environment, for example, wildlife, vegetation, biological sciences, ecology, wilderness, sea life, wetlands, habitat, and biological resources. |
| Boundary | Administrative and political boundaries | boundaries | **boundaries** | bnd | Administrative and political boundaries. County Boundaries, Trust Boundaries. Legal land descriptions, for example, political and administrative boundaries, governmental units, marine boundaries, voting districts, school districts, international boundaries |
| Cadastre | Cadastral and land planning | planningCadastre | **cadastre** | cad | Parcels, Zoning, Street addresses. Information used for appropriate actions for future use of the land, for example, land use maps, zoning maps, cadastral surveys, land ownership, parcels, easements, tax maps, federal land ownership status, public land conveyance records |
| Climate | \-- | climatologyMeteorologyAtmosphere | **climate** | cli | Meteorological data, but not physical installations. Processes and phenomena of the atmosphere, for example, cloud cover, weather, climate, atmospheric conditions, climate change, precipitation |
| Cultural, Demographic | Cultural, society, and demographic | society | **cultural\_demographic** | cul | Characteristics of society and culture, for example, settlements, housing, anthropology, archaeology, education, traditional beliefs, manners and customs, demographic data, tourism, recreational areas and activities, parks, recreational trails, historical sites, cultural resources, social impact assessments, crime and justice, law enforcement, census information, immigration, ethnicity. |
|  | Elevation and derived products | elevation | **elevation** | ele | LIDAR, DEM, Slope products. Height above or below sea level, for example, altitude, bathymetry, digital elevation models, slope, derived products, DEMs, TINs |
| Real Property | Facilities and structures | structure | **facilities\_structures** | fac | Man-made construction, for example, buildings, museums, churches, factories, housing, monuments, shops, towers, building footprints, architectural and structural plans |
| Geology | Geological and geophysical | geoscientificInformation | **geophysical** | geo | Information pertaining to earth sciences, for example geophysical features and processes, geology, minerals, sciences dealing with the composition, structure and origin of the earth's rocks, risks of earthquakes, volcanic activity, landslides, gravity information, soils, permafrost, hydrogeology, groundwater, erosion |
| Hazards | \-- | \-- | Not used |  | Not used |
| Visual Sensor, Landform | Imagery, base maps, and land cover | imageryBaseMapsEarthCover | **imagery** | img | Base maps, for example land/earth cover, topographic maps, imagery, unclassified images, annotations, digital ortho imagery |
| Hydrography | Oceans and estuaries ⁄ Inland water resources | inlandWaters | **inlandwaters** | inw | Surface freshwater. Inland water features, drainage systems and characteristics, for example, rivers and glaciers, salt lakes, water utilization plans, dams, currents, floods and flood hazards, water quality, hydrographic charts, watersheds, wetlands, hydrography |
| LandStatus | \-- | \-- | **land\_characteristics** | lnd | Land use, impervious surface. Not ecological, natural resources, or geophysical. |
| Geodetic | Locations and geodetic networks | location | **locations** | loc | Geodetic points, social/societal point of interest, historical features. Positional information and services, for example, addresses, geodetic networks, geodetic control points, postal zones, and services, place names, geographic names |
|  | \-- | farming, economy | **natresources\_farming** | nat | Forestry, fisheries. Management towards preservation, yield/standing crop/harvestable biomass assessment, not biological or ecological. Includes Farming as Rearing of animals or cultivation of plants, for example, agriculture, irrigation, aquaculture, plantations, herding, pests and diseases affecting crops and livestock; and Economy as Economic activities, conditions, and employment, for example, production, labor, revenue, business, commerce, industry, tourism and ecotourism, forestry, fisheries, commercial or subsistence hunting, exploration and exploitation of resources such as minerals, oil and gas |
|  |  | environment | **environment** | env | Environmental resources, protection, and conservation, for example, environmental pollution, waste storage and treatment, environmental impact assessment, monitoring environmental risk, nature reserves, landscape, water quality, air quality, environmental modeling |
|  |  | health | Not used |  | Health, health services, human ecology, and safety, for example disease and illness, factors affecting health, hygiene, substance abuse, mental and physical health, health services, health care providers, public health |
|  |  | intelligenceMilitary | Not used |  | Military bases, structures, activities, for example barracks, training grounds, military transportation, information collection |
|  |  | oceans | **oceans** | oce | Features and characteristics of salt water bodies (excluding inland waters), for example tides, tidal waves, coastal information, reefs, maritime, outer continental shelf submerged lands, shoreline |
| Future Projects | \-- | \-- | **planning** | pla | Features of future work that may be incorporated into other data when completed |
| Improvement | Transportation networks | transportation | **transportation** | trn | Means and aids for conveying persons or goods, for example roads, airports/airstrips, shipping routes, tunnels nautical charts, vehicle or vessel location, aeronautical charts, railways |
| Utilities, Communications | Utility and communication networks | utilitiesCommunication | **utilities** | uti | Energy, water and waste systems and communications infrastructure and services, for example hydroelectricity, geothermal, solar and nuclear sources of energy, water purification and distribution, sewage collection and disposal, electricity and gas distribution, data communication, telecommunication, radio, communication networks |

 Prefixes to group layers by subject especially for systems with flat data containers and without  concepts of directories or datasets. An example would be spatial databases where layers are simply a list of tables. 

 

### Directory creation script {#directory-creation-script}

mkdir \-p DATA/MAIN/biota\_ecological/2022  
mkdir \-p DATA/MAIN/boundaries/2022  
mkdir \-p DATA/MAIN/cadastre/2022  
mkdir \-p DATA/MAIN/climate/2022  
mkdir \-p DATA/MAIN/cultural\_demographic/2022  
mkdir \-p DATA/MAIN/elevation/2022  
mkdir \-p DATA/MAIN/facilities\_dtructures/2022  
mkdir \-p DATA/MAIN/geophysical/2022  
mkdir \-p DATA/MAIN/imagery/2022  
mkdir \-p DATA/MAIN/inlandwaters/2022  
mkdir \-p DATA/MAIN/land\_characteristics/2022  
mkdir \-p DATA/MAIN/locations/2022  
mkdir \-p DATA/MAIN/natresources\_farming/2022  
mkdir \-p DATA/MAIN/oceans/2022  
mkdir \-p DATA/MAIN/planning/2022  
mkdir \-p DATA/MAIN/transportation/2022  
mkdir \-p DATA/MAIN/utilities/2022

mkdir \-p DATA/PROJECTS/2022/project\_a  
mkdir \-p DATA/PROJECTS/2022/project\_b

## 

**GIS Data File Formats (add links)**

GPMCT relies on a range of software to manage the wildlands. Currently, this software includes proprietary solutions such as Esri’s ArcGIS Pro (version 3), Precisely’s MapInfo Pro, and Microsoft Office. It also increasingly includes free, open-source software such as QGIS. Data is often exchanged within the organization between these solutions and likely others in the future. These data are also exchanged with other organizations with undetermined software platforms. In all cases, accounting for older proprietary and open-source platforms must be considered as technological and financial limitations are very real for non-profit organizations. Therefore, maintaining data interoperability within GPMCT over time, as well as in other organizations, mitigates the risk of rendering valuable data unusable in the face of software formats that shift over time and between platforms. Therefore, GPMCT standardizes on the most stable, openly documented, and broadly supported data formats available at a given time. At the present time, 

* Vector \- Shapefile, Geopackage, FileGeodatabase  
* Raster \- GeoTIFF, MrSid

  ### Formats to be avoided {#formats-to-be-avoided}

* Esri Personal geodatabase (.mdb) \- Esri has deprecated due to reliance on COM and 32-bit software. Poor support by 3rd parties  
* Spatialite \- Replaced by Geopackages (.gpkg) as a more compatible, single-file format that is still queryable through basic SQL commands.

## **GIS Data Coordinate Reference Systems (CRS)** {#gis-data-coordinate-reference-systems-(crs)}

Much of the historical data owned by GPMCT uses the “EPSG:26919 \- NAD83 / UTM zone 19N” coordinate reference system to store the data in. For current cartographic uses, maintaining data in this general-purpose CRS seems appropriate until the need arises to shift to a more localized, updated, projected CRS.

#### EPSG:26919 \- NAD83 / UTM zone 19N (from [https://epsg.io/26919-1721](https://epsg.io/26919-1721))  {#epsg:26919---nad83-/-utm-zone-19n-(from-https://epsg.io/26919-1721)}

* Unit: metre  
* Geodetic CRS: NAD83  
* Datum: North American Datum 1983  
* Ellipsoid: GRS 1980  
* Prime meridian: Greenwich  
* Data source: EPSG  
* Revision date: 2007-05-29  
* Scope: Engineering survey, topographic mapping.  
* Remarks: Replaces NAD27 / UTM zone 19N. For accuracies better than 1m replaced by NAD83(CSRS) / UTM zone 19N in Canada and NAD83(HARN) / UTM zone 19N in US.  
* Area of use: North America \- between 72°W and 66°W \- onshore and offshore. Canada \- Labrador; New Brunswick; Nova Scotia; Nunavut; Quebec. Puerto Rico. United States (USA) \- Connecticut; Maine; Massachusetts; New Hampshire; New York (Long Island); Rhode Island; Vermont.  
* Coordinate system: Cartesian 2D CS. Axes: easting, northing (E,N). Orientations: east, north. UoM: m.

| OGC WKT Spec | Esri WKT ( and .prj text) |
| ----- | ----- |
| **PROJCS**\["NAD83 / UTM zone 19N",     **GEOGCS**\["NAD83",         **DATUM**\["North\_American\_Datum\_1983",             **SPHEROID**\["GRS 1980",6378137,298.257222101\],             **TOWGS84**\[0,0,0,0,0,0,0\]\],         **PRIMEM**\["Greenwich",0,             AUTHORITY\["EPSG","8901"\]\],         **UNIT**\["degree",0.0174532925199433,             AUTHORITY\["EPSG","9122"\]\],         AUTHORITY\["EPSG","4269"\]\],     **PROJECTION**\["Transverse\_Mercator"\],     **PARAMETER**\["latitude\_of\_origin",0\],     **PARAMETER**\["central\_meridian",-69\],     **PARAMETER**\["scale\_factor",0.9996\],     **PARAMETER**\["false\_easting",500000\],     **PARAMETER**\["false\_northing",0\],     **UNIT**\["metre",1,         AUTHORITY\["EPSG","9001"\]\],     **AXIS**\["Easting",EAST\],     **AXIS**\["Northing",NORTH\],     AUTHORITY\["EPSG","26919"\]\]  | **PROJCS**\["NAD\_1983\_UTM\_Zone\_19N",     **GEOGCS**\["GCS\_North\_American\_1983",         **DATUM**\["D\_North\_American\_1983",             **SPHEROID**\["GRS\_1980",6378137.0,298.257222101\]\],         **PRIMEM**\["Greenwich",0.0\],         **UNIT**\["Degree",0.0174532925199433\]\],     **PROJECTION**\["Transverse\_Mercator"\],     **PARAMETER**\["False\_Easting",500000.0\],     **PARAMETER**\["False\_Northing",0.0\],     **PARAMETER**\["Central\_Meridian",-69.0\],     **PARAMETER**\["Scale\_Factor",0.9996\],     **PARAMETER**\["Latitude\_Of\_Origin",0.0\],     **UNIT**\["Meter",1.0\]\] .prj file text PROJCS\["NAD83 / UTM zone 19N",GEOGCS\["NAD83",DATUM\["North\_American\_Datum\_1983",SPHEROID\["GRS 1980",6378137,298.257222101,AUTHORITY\["EPSG","7019"\]\],AUTHORITY\["EPSG","6269"\]\],PRIMEM\["Greenwich",0,AUTHORITY\["EPSG","8901"\]\],UNIT\["degree",0.0174532925199433,AUTHORITY\["EPSG","9122"\]\],AUTHORITY\["EPSG","4269"\]\],PROJECTION\["Transverse\_Mercator"\],PARAMETER\["latitude\_of\_origin",0\],PARAMETER\["central\_meridian",-69\],PARAMETER\["scale\_factor",0.9996\],PARAMETER\["false\_easting",500000\],PARAMETER\["false\_northing",0\],UNIT\["metre",1,AUTHORITY\["EPSG","9001"\]\],AXIS\["Easting",EAST\],AXIS\["Northing",NORTH\],AUTHORITY\["EPSG","26919"\]\] |

## **Common Attribute Data Structures and Types** {#common-attribute-data-structures-and-types}

Recommended fields for every layer of vector data. Field names cannot exceed 10 characters in Shapefile dBase files – keep field names short.

| Field Name | Type | Usage | Optionality | Example |
| ----- | ----- | ----- | ----- | ----- |
| NAME | Text/String (50) | Unique name of feature if the feature can be named. Suitable for naming in a map. | Optional  | West Gate Welcome Sign |
| TYPE | Text/String (50) | Used for composite layers of similar features. Chosen from a picklist of possible values to maintain consistency. Not needed if single types | Optional  | In a layer of invasive plant sightings, pick the name of the invasive plant.  |
| USERC | Text/String (50) | Names or initials of users/staff who recorded the data record. | Required | Polly Smith recorded the observation using the field app so PSMITH is entered. |
| DATEC | DATE or Text/String (12) | Date the feature was initially recorded (created). If the field is text, store as YYYY-MM-DD | Required | Polly Smith recorded the observation using the field app on October 13, 2022\. So 2022-10-13 is entered. |
| USERU | Text/String (50) | Names or initials of users/staff who edited the data record. | Required. Empty if there are no changes. | Jake Jones updated the observation using the GIS app so JJONES is entered. |
| DATEU | DATE or Text/String (12) | Date the feature was updated. If the field is text, store as YYYY-MM-DD | Required. Empty if there are no changes. | PJake Jones updated the observation using the GIS app on November 20, 2022\. So 2022-11-20 is entered. |
| NOTES | Text/String (250) | Notes about the feature including later information such as an explanation of status or reasons for updates | Optional | In 2001 the gate was moved ten feet to the south due to erosion. In 2008 the gate was removed and the status was set to INACTIVE. |
| CONDITION | Text/String (50) | A single entry that describes the condition of the feature to be used for analysis. Possible values from a list defined for the layer. Possibly: Excellent, Good, Fair, Poor, or similar. | Optional | Good |
| STATUS | Text/String (50) | A single entry that describes the status of the feature to be used for analysis and display. Possible values from a list defined for the layer. Possibly: ACTIVE, INACTIVE, or similar. | Optional  | INACTIVE |

 **Managed GIS Layers**  
As Changes Occur \- ACO

| Filename | Modified | Managed Layer | Notes | Update Frequency | Authoritative Data Type and Format | Authoritative Location |
| ----- | ----- | ----- | ----- | ----- | ----- | ----- |
| /MAIN/Boundaries/2022/GPMCT/property\_wildlands\_poly.shp | 09/28/22 | Wildlands Property Boundary | ~~Fix topology bow tie, then in good shape.~~ ADD AOI Layer | ACO | Polygon Shapefile | File server at office |
| /MAIN/Biota\_Ecological/2022/Ecological/communities.shp | 04/18/12 | Ecological communities |   | 5-year and ACO | Polygon Shapefile | File server at office |
| /MAIN/Biota\_Ecological/2022/Ecological/Sensitive Plants.shp | 12/19/06 | Sensitive plants |   | 5-years and ACO | Polygon Shapefile | File server at office |
| /MAIN/Biota\_Ecological/2022/Ecological/management concerns.shp | 05/26/20 | Management concerns |   | ACO | Point layer  | Cloud TBD, Bring to file server periodically |
| /MAIN/Biota\_Ecological/2022/Ecological/monitor points.shp | 12/19/06 | Monitoring Points |   | 2-years and ACO | Point layer  | Cloud TBD, Bring to file server periodically |
| /MAIN/Biota\_Ecological/2022/Ecological/spec.mgmt.zone.shp | 12/19/06 | Special Management Zone | This seems good. What is it? | ACO | Polygon Shapefile | File server at office |
| /MAIN/Facilities\_Structures/2022/Culverts\_24Oct2014update.shp | 05/06/20 | Culverts |  (existence and condition. Present and Historical) | ACO | Point layer  | Cloud TBD, Bring to file server periodically |
| /MAIN/Facilities\_Structures/2022/GPT\_Bridges.shp | 05/09/22 | Bridges |  (existence and condition. Present and Historical) | ACO | Point layer  | Cloud TBD, Bring to file server periodically |
| /MAIN/Facilities\_Structures/2022/PossGravelSource.shp | 12/16/19 | Gravel Source | Is this a useful layer? | ACO | Polygon Shapefile | File server at office |
| /MAIN/Facilities\_Structures/2022/facilities\_wildlands\_point.shp | 09/28/22 | Owned Facilities and Structures | Looks great. Types: Campsite, Children's Area, Gate, Mountain Bike Access, Outhouse,  Parking, Public boat access, Picnic area, Trailhead. Standardize attributes | ACO | Point layer  | Cloud TBD, Bring to file server periodically |
| /MAIN/Locations/2022/summits\_wildlands\_point.shp | 09/28/22 | Summits | Change and include geographic points of interest layer (summits, rock outcrops, springs, etc.)? | ACO | Point Shapefile | File server at office |
| /MAIN/Transportation/2022/Roads/roads\_trails\_wildlands\_crop.shp | 09/28/22 | Roads and Trails | Which is best composite roads layer | ACO | Line Shapefile | File server at office |
| /MAIN/Transportation/2022/Roads/wildlands\_main\_roads.shp | 09/28/22 | Roads | Which is best composite roads layer | ACO | Line Shapefile | File server at office |
| /MAIN/Transportation/2022/Ungated Access/UnGatedAccessPts.shp | 07/30/20 | Ungated Access Points |   | ACO | Point layer  | Cloud TBD, Bring to file server periodically |
| /MAIN/Transportation/2022/Trails/trails\_wildlands\_segments.shp | 09/28/22 | Trails | This might be best trail layer | ACOr | Line Shapefile | File server at office |
| /MAIN/Land\_Characteristics/2022/meadows\_poly.shp | 09/28/22 | Meadows  | (but should be part of unified land cover layer?) | ACO | Polygon Shapefile | File server at office |
| /MAIN/InlandWaters/2022/drainage.shp | 02/08/17 | Catchment Drainage | Surface waters/ hydrography layers seem to need a lot of work | ACO | Polygon Shapefile | File server at office |
| /MAIN/InlandWaters/2022/streams/rivers.shp | 04/08/16 | Rivers (and Streams?) | Surface waters/ hydrography layers seem to need a lot of work | ACO | Line Shapefile | File server at office |
| /MAIN/InlandWaters/2022/streams/stream.shp | 12/19/06 | Rivers (and Streams?) | Surface waters/ hydrography layers seem to need a lot of work | ACO | Line Shapefile | File server at office |
| /MAIN/InlandWaters/2022/lakes/lakes\_ponds\_poly.shp | 09/28/22 | Lake and Ponds | Surface waters/ hydrography layers seem to need a lot of work | ACO | Polygon Shapefile | File server at office |
| /MAIN/InlandWaters/2022/wetlands/wetlands\_poly.shp | 09/28/22 | Wetlands | (compare to NWI) | ACO | Polygon Shapefile | File server at office |
| /MAIN/NatResources\_Farming/2022/BiotaMonitoringManagement/management concerns.shp | 05/26/20 | Management Concerns. Explain/DeDupe |   |  |   |   |
| /MAIN/NatResources\_Farming/2022/BiotaMonitoringManagement/monitor points.shp | 12/19/06 | Monitoring points. Explain/DeDupe |   |   |   |   |

# 

### User, Groups, and Permissions {#user,-groups,-and-permissions}

| User Count | Type | Description |  |
| ----- | ----- | ----- | ----- |
| 2 | Data Administrators | Administers data systems: Google, Synology, Backup, GIS data systems, and file access. May also be a data editor. |  |
| 3 | Data Editors | Edits, analyses and occasionally creates data files/layers in Google and GIS |  |
| 6 | Field Workers | View spatial data, submit field GIS forms. Works in Google Workspace |  |
| 10 | Data Viewers (future) | Views online GIS data and static maps. Works in Google workspace |  |
| X | Crowd Source field collectors (future) | Views spatial data, submits field GIS forms |  |

# 

# **APPENDIX** {#appendix}

## **BASH Shell Script for Inventorying Data Files** {#bash-shell-script-for-inventorying-data-files}



## **GIS Metadata** {#gis-metadata}

GIS metadata are records that describe aspects of any data set used in geospatial analysis such as content topics, creation and editing methods (history and lineage), data descriptions, extents, attributes, and licensing and access descriptions. Unfortunately, there are numerous standards for the elements of metadata records, and also a multitude of file formats and storage approaches for the metadata \- almost none of which are interoperable outside of the software platform in which they were created. However, the most important target platform to be compatible with is the humans using the data in question. Therefore, shell metadata files were created for all Shapefiles and TIFF files using a script and with the file extension of .md.txt and prefixed by the data file name. These text files were initially created by a script and they can be read with formatting using Markdown notation. The files have the most basic metadata sections and they filed in what automated information could be found by the script.  The remaining details should be completed and maintained by users.

For example, the Shapefile called “*gpmct\_area\_of\_interest.shp” would cause the creation of the file* “gpmct\_area\_of\_interest.md.txt” *alongside it with the following contents, where \# denotes Heading 1, and \#\# denotes Heading 2 for example. Notice that extensive editing is required.*

|      |
| :--- |
