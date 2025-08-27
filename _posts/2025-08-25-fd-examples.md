---
title: 'Installing fd replacement for find on Windows and Using it'
subtitle: It's more than a find replacement
date: '2025-08-25T15:02:15-05:00'
author: 'John C. Zastrow'
layout: post
gh-badge: [star, fork, follow]
tags: [linux, windows, cli, tools, management]
comments: true
---


On my list of utility tools to install on a new system is `fd`, [fd](https://github.com/sharkdp/fd) a simple, fast and user-friendly alternative to `find`. It's written in Rust and is available on multiple platforms including Windows, Linux, and macOS.

# Installation on Windows

via Winget:

`winget install sharkdp.fd`

For the rest I'm going to blatantly copy from the [fd github page]((https://github.com/sharkdp/fd)

## How to use

First, to get an overview of all available command line options, you can either run
[`fd -h`](#command-line-options) for a concise help message or `fd --help` for a more detailed
version.

### Simple search

*fd* is designed to find entries in your filesystem. The most basic search you can perform is to
run *fd* with a single argument: the search pattern. For example, assume that you want to find an
old script of yours (the name included `netflix`):
``` bash
> fd netfl
Software/python/imdb-ratings/netflix-details.py
```
If called with just a single argument like this, *fd* searches the current directory recursively
for any entries that *contain* the pattern `netfl`.

## Command execution

Instead of just showing the search results, you often want to *do something* with them. `fd`
provides two ways to execute external commands for each of your search results:

* The `-x`/`--exec` option runs an external command *for each of the search results* (in parallel).
* The `-X`/`--exec-batch` option launches the external command once, with *all search results as arguments*.

#### Examples

Recursively find all zip archives and unpack them:
``` bash
fd -e zip -x unzip
```

## Deleting files

You can use `fd` to remove all files and directories that are matched by your search pattern.
If you only want to remove files, you can use the `--exec-batch`/`-X` option to call `rm`. For
example, to recursively remove all `.DS_Store` files, run:
``` bash
> fd -H '^\.DS_Store$' -tf -X rm
```
If you are unsure, always call `fd` without `-X rm` first. Alternatively, use `rm`s "interactive"
option:
``` bash
> fd -H '^\.DS_Store$' -tf -X rm -i
```

If you also want to remove a certain class of directories, you can use the same technique. You will
have to use `rm`s `--recursive`/`-r` flag to remove directories.

> [!NOTE]
> There are scenarios where using `fd … -X rm -r` can cause race conditions: if you have a
path like `…/foo/bar/foo/…` and want to remove all directories named `foo`, you can end up in a
situation where the outer `foo` directory is removed first, leading to (harmless) *"'foo/bar/foo':
No such file or directory"* errors in the `rm` call.

### Command-line options

This is the output of `fd -h`. To see the full set of command-line options, use `fd --help` which
also includes a much more detailed help text.
