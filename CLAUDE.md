# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal blog built with **Beautiful Jekyll** (v6.0.1), a Jekyll-based static site generator. The site is called "GeoNotes" and focuses on topics related to GIS, databases, Linux, data management, and water/environmental science. It's hosted on GitHub Pages and uses the Beautiful Jekyll theme framework.

## Development Commands

### Local Development

```bash
# Install dependencies (requires Ruby and Bundler)
bundle install

# Run local development server (typically on http://localhost:4000)
bundle exec jekyll serve

# Build the site for production
bundle exec jekyll build
```

### Content Management

```bash
# Create a new blog post in _posts/
# File must follow naming convention: YEAR-MONTH-DAY-title.md
# Example: 2025-01-15-new-post-title.md

# Preview changes locally before committing
bundle exec jekyll serve --drafts

# Check the git status
git status
```

## Architecture

### Directory Structure

- **`_posts/`** - Blog posts in markdown format (YEAR-MONTH-DAY-title.md naming required)
- **`_layouts/`** - Page templates (base.html, post.html, page.html, home.html, minimal.html)
- **`_includes/`** - Reusable HTML partials (comments, analytics, social buttons, etc.)
- **`_data/`** - Data files (ui-text.yml for internationalization)
- **`assets/`** - Static assets (CSS, JavaScript, images, uploads)
  - `assets/css/` - Stylesheets (Beautiful Jekyll theme CSS)
  - `assets/js/` - JavaScript files (includes mermaid.js for diagrams)
  - `assets/img/` - Site images
  - `assets/uploads/` - Uploaded content
- **`_config.yml`** - Main Jekyll configuration file
- **`index.html`** - Homepage using 'home' layout

### Key Configuration

The site is configured via `_config.yml`:
- Site title: "GeoNotes"
- Author: John Zastrow
- Timezone: America/Toronto
- Permalink structure: `/:year-:month-:day-:title/`
- Pagination: 10 posts per page
- Markdown: kramdown with GFM input
- Mermaid diagram support enabled

### Blog Post Format

All blog posts must include YAML front matter at the top:

```yaml
---
layout: post
title: Your Post Title
subtitle: Optional subtitle
date: '2025-01-15T12:00:00-05:00'
tags: [linux, database, gis]
categories:
    - Category Name
comments: true
---
```

Common tags used on this site:
- linux, database, gis, postgresql, PostGIS, Spatialite
- geodata, spatial, data management
- python, mysql, MariaDB
- weather, water quality, environmental
- networking, windows

### Theme System

This site uses the Beautiful Jekyll theme with customizations:
- Avatar: `/assets/img/ytown.jpg`
- Google Analytics: G-D47TEJ1NKB
- Mermaid.js for diagrams (loaded via `/assets/js/mermaid.js`)
- RSS feed enabled
- Post search enabled in navbar
- Comments enabled by default on posts

### Page Layouts

- **post** - Blog post with social sharing, comments, tags
- **page** - Static page (like aboutme.md)
- **home** - Homepage displaying blog post feed
- **minimal** - Minimal styling without navbar/footer
- **base** - Base template for all layouts

## Content Creation Guidelines

### Creating New Blog Posts

1. Create file in `_posts/` with naming: `YYYY-MM-DD-title-with-dashes.md`
2. Add YAML front matter with at minimum: layout, title, date
3. Use tags array for categorization: `tags: [tag1, tag2]`
4. Write content in markdown below the front matter
5. Mermaid diagrams are supported - wrap in code blocks with `mermaid` language tag

### Creating New Pages

1. Create `.md` file in root directory (e.g., `newpage.md`)
2. Add YAML front matter with `layout: page`
3. Page will be available at `https://johnzastrow.github.io/newpage`

### Supported Front Matter Parameters

Common parameters (from Beautiful Jekyll):
- `title` - Page/post title
- `subtitle` - Appears under title
- `tags` - Array of tags for posts
- `cover-img` - Full-width header image
- `thumbnail-img` - Thumbnail for post feed
- `comments` - Enable/disable comments (default: true for posts)
- `gh-badge` - GitHub buttons: [star, fork, follow]
- `readtime` - Show estimated reading time
- `mathjax` - Enable LaTeX formula support

## Dependencies

Key dependencies from `beautiful-jekyll-theme.gemspec`:
- jekyll >= 3.9.3
- jekyll-paginate ~> 1.1
- jekyll-sitemap ~> 1.4
- kramdown ~> 2.3
- kramdown-parser-gfm ~> 1.1
- webrick ~> 1.8

## Deployment

This site is deployed via GitHub Pages. Changes pushed to the `master` branch are automatically built and deployed by GitHub Pages.

## Custom Features

- **Mermaid Diagrams**: Enabled via `mermaid: true` in `_config.yml` and loaded through `/assets/js/mermaid.js`
- **Navigation**: Configured in `_config.yml` under `navbar-links`
- **Color Scheme**: Customized colors defined in `_config.yml` (page-col, text-col, link-col, etc.)
