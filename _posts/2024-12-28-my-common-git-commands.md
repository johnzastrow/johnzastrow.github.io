---
layout: post
title: My Common and Not so Common Git Commands
subtitle: Another note card for myself
gh-badge: [star, fork, follow]
date: '2024-12-28T12:47:41-05:00'
tags: [git, data]
comments: true
---

# My common (and not so common) Git commands. 

This is mostly a log for myself of stuff I don't do every day so I don't have to Google it all the time.

1. Initialize a directory with Git and point it to a remote, empty (like Github) repo that I created.

This assumes that you are working on a workstation (or in shell environment) where you have already setup your git globals. It also assumes that the remote repo is empty. It might error abut not pulling first. If the remote is empty, try a `git pull origin main` before the push.



```bash
git init
git add .
git commit -m "my commit"
git remote add origin <remote repository URL>
git push -f origin main
```

# Resources

* (https://docs.github.com/en/migrations/importing-source-code/using-the-command-line-to-import-source-code/adding-locally-hosted-code-to-github)








