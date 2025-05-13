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

{: .box-note}
This is mostly a log for myself of stuff I don't do every day so I don't have to Google it all the time. 

{: .box-warning}
This is just a start and I'm going to add to it over time.
a. Setup Git if running for the first time


## Install Setup

```bash
git config --list
git config --global user.name "Mr. Bob"
git config --global user.email "admin@golinuxcloud.com"
git config --global core.editor nano
git config --global init.defaultBranch main
git config --list
cat .gitconfig
git config user.name


```

## Getting Started and Using

1. Initialize a directory with Git and point it to a remote, empty (like Github) repo that I created.

This assumes that you are working on a workstation (or in shell environment) where you have already setup your git globals. It also assumes that the remote repo is empty. It might error abut not pulling first. If the remote is empty, try a `git pull origin main` before the push.

If you’re using Git 2.28.0 or a later version, you can set the name of the default branch using -b.


```bash
git init -b main
# Adds the files in the local repository and stages them for commit. To unstage a file, use `git reset HEAD YOUR-FILE`.

git add .
git commit -m "First commit"
git remote add origin <remote repository URL>
git push -f origin main
```

or from Github itself, where the repo is called 'fitness'

```bash
echo "# fitness" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/johnzastrow/fitness.git
git push -u origin main
```


## Cleaning Up

I'm a bad person and I commit often AND I commit a lot of blobs as I use Github as a sort of backup as well as a way to move files between the literally ten computers I work on in a given week. The result is that my repos are HUUUGE and full of useless blobs. So, to shrink my repos I periodically have to trim the fat. Here is my working recipe.


Do this in Linux. Installing and running `git-filter-repo` in Windows is still weird. So clean in linux, then force push to the origin, then pull down to your other sets of code. `git-filter-repo` is a python program. But install it through apt on Ubuntu. Do not use `git-filter-branch` people says it's wonky and does odd things. I can confirm. Plus it's a lot more work to use.

#### 1. Install stuff
   
```bash 
sudo apt install git-filter-repo git-sizer ncdu
```

#### 2. Backup your data before playing in these dark arts
   
To create a backup, we simply make a complete copy of our repository. Open your command line, navigate to the directory containing your repository, and run:

```bash
git clone --mirror [your-repo-url] [backup-repo-name].git 
```

Also do this to your current working repo to have second backup. Backup this way too by compressing your local repo.

```bash
tar -cvzf weather-May11.tgz weather 
```

Save this `remote_origins.txt` file because for some reason git-filter-repo deletes your remote origin value! Maybe for safety reasons so you don't accidentally push when you don't want to

```bash
git remote -v >> ../remote_origins.txt

# see also 
git ls-remote --get-url origin

# or this for a lot of detail
git remote show origin
```

Here are some examples
{: .box-terminal}
<pre>
git remote -v
git ls-remote --get-url origin
git remote show origin

</pre>


#### 3. Checkout the starting state

Then check sizes using tools below. We'll work with a repo called `weather` now. Run the following commands to explore and document your current state. Do all this from the inside the root directory of your repo. The same one that contains `.git`. 

```bash
# Interactively explore how much space your repo is using from the file system level
ncdu /home/jcz/weather

# Another way to check the total space used by your repo
du -s --si

# Summarize the git objects before we clean out
git count-objects -v

# Another way to explore tree sizes in your repo
git-sizer

# Yet another way to explore the largest files in the repo
git ls-tree -r -t -l --full-name HEAD | sort -n -k 4 -r | head -n 5
```

Now identify the directories with the largest files, because approach will blow them away and amend the git history as if they never existed. Do more research if you want to selectively remove files or things that are more granular. 

#### 4. Clean, Expunge, Compress

In my case my `dumps` and `archive` directories accumulate the cruft I want to drop

```bash
# begin by analysing
git filter-repo --analyze
---> stopped here



3b. ls -lht .git/filter-repo/analysis/
1. less .git/filter-repo/analysis/directories-deleted-sizes.txt

2. git filter-repo --invert-paths --path dumps/ --path archive/
3. git filter-repo --analyze
4. head -n 10 .git/filter-repo/analysis/path-all-sizes.txt 
 	example 9. git filter-repo --invert-paths --path-regex '^assets\/lib\/mermaid\/(?!mermaid\.min\.js$).*'
5.  git gc --aggressive --prune=now
6.  git count-objects -v
7.  git remote add weather git@git.[url]
8.  git push origin --force --all
9.  git push origin --force --tags


git gc --aggressive --prune=now



# Resources

* (https://docs.github.com/en/migrations/importing-source-code/using-the-command-line-to-import-source-code/adding-locally-hosted-code-to-github)
* https://onenine.com/how-to-reduce-git-repository-size-safely/

https://www.golinuxcloud.com/reduce-git-repo-size-with-git-filter-branch/

https://ryanagibson.com/posts/shrink-git-repo/

https://sentry.io/answers/revert-a-git-repository-to-a-previous-commit/
https://andrewlock.net/rewriting-git-history-simply-with-git-filter-repo/
https://www.golinuxcloud.com/reduce-git-repo-size-with-git-filter-branch/






