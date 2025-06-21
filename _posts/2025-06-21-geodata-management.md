---
layout: post
title: GeoData Management Plan
subtitle: General plan for non-technical non-profits
gh-badge: [star, fork, follow]
date: '2025-06-21T12:47:41-05:00'
tags: [GIS, data, geospatial, management]
comments: true
---

# GeoData Management Plan

This document provides a clear, practical approach for ORGANIZATION to manage geospatial data. The goal is to keep data organized, accessible, and easy to use for all staff, regardless of technical background. This plan is designed to be updated as data needs and stewardship practices evolve.

## Contents

- Introduction
- Goals
- Data Structure & Standards
- Directory Structure
- File Formats
- Coordinate Reference Systems (CRS)
- Attribute Standards
- User Roles & Permissions
- Metadata
- Appendix

## Introduction

ORGANIZATION uses this plan to ensure geospatial data is stored in a consistent, logical, and well-documented way. The structure is designed to be intuitive for new users and flexible enough to adapt as needs change. The plan is updated as data stewardship practices evolve.

## Goals

- Make data easy to find and use, so anyone can quickly access authoritative data for mapping and analysis.
- Use consistent, self-explanatory file and folder names to minimize extra documentation.
- Improve the consistency and reliability of data deliverables.
- Ensure data formats and structures are portable and compatible with a wide range of software 
- Focus on basic technology standards and reduce need for recurring or ongoing financial costs towards 3rd party products and services.

## Data Structure & Standards

### Directory Structure

- **PROJECTS**: Organized by year and project name. Contains final deliverables only. Files are read-only and should not be changed. If further work is needed, copy files elsewhere.
- **MAIN**: Organized by subject and year. Stores the most current, validated, and approved data. Data is updated only when new versions are available, new files are added, or problematic data is removed. Each year’s data is archived for historical reference.
- **WORKING**: Used for intermediate processing. Copy data from MAIN or PROJECTS before editing.

**Example:**

```text
DATA/
  ├── PROJECTS/
  │     └── 2022/
  │         ├── project_A/
  │         └── project_B/
  └── MAIN/
        ├── biota_ecological/2022/
        ├── boundaries/2022/
        └── ...
```

Data in MAIN is read-only and only updated per stewardship guidelines. Yearly folders allow for historical tracking.

### Subject Directories

Subject directories in MAIN are based on common GIS categories (e.g., boundaries, biota_ecological, cadastre, climate, cultural_demographic, elevation, facilities_structures, geophysical, imagery, inlandwaters, land_characteristics, locations, natresources_farming, oceans, planning, transportation, utilities). Use lower-case names and avoid special characters.

### Directory Creation Script

Use the following script to create the recommended directory structure:

```bash
mkdir -p DATA/MAIN/biota_ecological/2022
mkdir -p DATA/MAIN/boundaries/2022
mkdir -p DATA/MAIN/cadastre/2022
mkdir -p DATA/MAIN/climate/2022
mkdir -p DATA/MAIN/cultural_demographic/2022
mkdir -p DATA/MAIN/elevation/2022
mkdir -p DATA/MAIN/facilities_structures/2022
mkdir -p DATA/MAIN/geophysical/2022
mkdir -p DATA/MAIN/imagery/2022
mkdir -p DATA/MAIN/inlandwaters/2022
mkdir -p DATA/MAIN/land_characteristics/2022
mkdir -p DATA/MAIN/locations/2022
mkdir -p DATA/MAIN/natresources_farming/2022
mkdir -p DATA/MAIN/oceans/2022
mkdir -p DATA/MAIN/planning/2022
mkdir -p DATA/MAIN/transportation/2022
mkdir -p DATA/MAIN/utilities/2022
mkdir -p DATA/PROJECTS/2022/project_a
mkdir -p DATA/PROJECTS/2022/project_b
```

## File Formats

ORGANIZATION uses open, stable, and widely supported formats to maximize compatibility:

- **Vector:** Shapefile, Geopackage, FileGeodatabase
- **Raster:** GeoTIFF, MrSid

**Avoid:**

- Esri Personal geodatabase (.mdb)
- Spatialite (use Geopackage instead)

## Coordinate Reference Systems (CRS)

Most data uses EPSG:26919 (NAD83 / UTM zone 19N). This CRS is suitable for general mapping and analysis. Use other CRSs only if required for specific projects.

## Attribute Standards

Recommended fields for all vector layers (keep field names short for Shapefile compatibility):

| Field      | Type         | Description                                 | Example           |
|------------|--------------|---------------------------------------------|-------------------|
| NAME       | Text (50)    | Unique feature name (for maps)              | West Gate         |
| TYPE       | Text (50)    | Feature type (from a picklist)              | Invasive Plant    |
| USERC      | Text (50)    | User who created the record                 | PSMITH            |
| DATEC      | Date/Text    | Date created (YYYY-MM-DD)                   | 2022-10-13        |
| USERU      | Text (50)    | User who last updated the record            | JJONES            |
| DATEU      | Date/Text    | Date updated (YYYY-MM-DD)                   | 2022-11-20        |
| NOTES      | Text (250)   | Additional notes                            | Gate moved 2001   |
| CONDITION  | Text (50)    | Feature condition (e.g., Good, Poor)        | Good              |
| STATUS     | Text (50)    | Feature status (e.g., ACTIVE, INACTIVE)     | INACTIVE          |

## User Roles & Permissions

| Role                | Description                                                      |
|---------------------|------------------------------------------------------------------|
| Data Administrators | Manage data systems and access. May also edit data.              |
| Data Editors        | Edit, analyze, and create data.                                  |
| Field Workers       | View data and submit field forms.                                |
| Data Viewers        | View online GIS data and static maps.                            |
| Crowd Source        | (Future) Submit field data.                                      |

## Metadata

Metadata describes each dataset’s content, creation, editing, extent, and access. Use simple, human-readable Markdown files (e.g., `layername.md.txt`) alongside each data file. These should include basic sections: description, creation date, update history, attributes, and licensing. Automated scripts can generate initial metadata; users should update details as needed.

## Appendix

### Bash Script for Inventorying Data Files

```bash
# Add your script here to automate file inventory
```

### GIS Metadata Example

For a file named `area_of_interest.shp`, create `area_of_interest.md.txt` with:

```markdown
# area_of_interest.shp
## Description
## Creation Date
## Update History
## Attributes
## License
```

---

This plan is a living document. Update it as ORGANIZATION’s data management needs change.
