# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

**GeoNotes** - A personal blog built with Beautiful Jekyll (v6.0.1), focusing on GIS, databases, Linux, data management, and water/environmental science. Hosted on GitHub Pages.

## Development Commands

```bash
# Install dependencies
bundle install

# Local development server (http://localhost:4000)
bundle exec jekyll serve

# Preview including draft posts
bundle exec jekyll serve --drafts

# Build for production
bundle exec jekyll build
```

## Creating Blog Posts

Posts live in `_posts/` with required naming: `YYYY-MM-DD-title-with-dashes.md`

**Required front matter:**

```yaml
---
layout: post
title: Your Post Title
subtitle: Optional subtitle
date: '2025-01-15T12:00:00-05:00'
tags: [linux, database, gis]
---
```

**Common tags:** linux, database, gis, postgresql, PostGIS, Spatialite, geodata, spatial, data management, python, mysql, MariaDB, weather, water quality, environmental, networking, windows

Draft posts go in `_drafts/` (no date prefix needed in filename). Preview with `bundle exec jekyll serve --drafts`.

**Optional front matter:**
- `cover-img` - Full-width header image
- `thumbnail-img` - Thumbnail for post feed
- `gh-badge: [star, fork, follow]` - GitHub buttons
- `readtime: true` - Show reading time estimate
- `mathjax: true` - Enable LaTeX formulas

**Mermaid diagrams:** Wrap in code blocks with `mermaid` language tag.

## Creating Static Pages

Create `.md` files in root directory with `layout: page` front matter. Available at `https://johnzastrow.github.io/<filename>`.

## Key Files

- `_config.yml` - Site configuration (title, author, navbar, colors, analytics)
- `_layouts/` - Templates: post, page, home, minimal, base
- `_includes/` - Reusable HTML partials
- `assets/js/mermaid.js` - Mermaid diagram support

## Deployment

Push to `master` branch. GitHub Pages automatically builds and deploys.
