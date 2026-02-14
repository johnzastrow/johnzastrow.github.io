---
layout: post
title: My Common and Not so Common Git Commands
subtitle: Another note card for myself
gh-badge: [star, fork, follow]
date: '2024-12-28T12:47:41-05:00'
tags: [git, data]
comments: true
---


{: .box-note}
This is mostly a log for myself of stuff I don't do every day so I don't have to Google it all the time.

{: .box-warning}
This is just a start and I'm going to add to it over time.

# Git from Scratch

Setup Git if running for the first time

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

## Getting Started

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

here are same instructions said slightly differently.

```bash
# Connecting a local git-tracked directory to a remote repo. 
# 1. create the remote myrepo without any starting files
# 2. `git init` then `git add .` then `git commit -m "Initial commit"` the local directory to starting tracking (careful to exclude sensitive files)
# the do the following to connect it to the remote origin and get the files into the service
git remote add origin git@github.com:myaccount/myrepo.git
git remote -v
git push -u origin main
```

## Settings to help git run on shared web hosting services

```bash
# shared hosting providers limit threads and memory, so doing git operations can fail as git expects multiple cores.
# this config can solve that, but also slows some git operations. These worked for me.
git config --global pack.windowMemory "100m"
git config --global pack.packSizeLimit "100m"
git config --global pack.threads "1"
```



# Cleaning After Making a Mess

I'm a bad person and I commit too often AND I commit a lot of blobs as I use Github as a sort of backup as well as an FTP server. The result is that my repos are HUUUGE and full of useless blobs. So, to shrink my repos I periodically have to trim the fat. Here is an approach I'm developing.

## Where Are We Starting

Do this in Linux. Installing and running `git-filter-repo` in Windows is still weird. So clean in linux, then force push to the origin, then pull down to your other sets of code. `git-filter-repo` is a python program. But install it through apt on Ubuntu. Do not use `git-filter-branch` people says it's wonky and does odd things. I can confirm. Plus it's a lot more work to use.

We'll work with a repo called `weather` now.

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
git ls-remote --get-url origin  >> ../remote_origins.txt

# or this for a lot of detail
git remote show origin  >> ../remote_origins.txt
cat ../remote_origins.txt
```

Here are some examples

{: .box-terminal}
<pre>
jcz@lamp:~/weather$ git remote -v
origin  git@github.com:johnzastrow/weather.git (fetch)
origin  git@github.com:johnzastrow/weather.git (push)

jcz@lamp:~/weather$ git ls-remote --get-url origin
git@github.com:johnzastrow/weather.git

jcz@lamp:~/weather$ git remote show origin
* remote origin
  Fetch URL: git@github.com:johnzastrow/weather.git
  Push  URL: git@github.com:johnzastrow/weather.git
  HEAD branch: master
  Remote branches:
    baseline                                        tracked
    master                                          tracked
  Local branch configured for 'git pull':
    master merges with remote master
  Local ref configured for 'git push':
    master pushes to master (local out of date)
</pre>

#### 3. Checkout the starting state

Then check sizes using tools below. Run the following commands to explore and document your current state. Do all this from the inside the root directory of your repo. The same one that contains `.git`.

{: .box-terminal}
<pre>
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
</pre>

Here are some more examples

{: .box-terminal}
<pre>
ncdu 1.19 ~ Use the arrow keys to navigate, press ? for help
--- /home/jcz/Documents/github/weather ---------------------------------------------------------------------------------
    1.7 GiB [#################] /.git
  111.1 MiB [#                ] /archive
  101.5 MiB [#                ] /dumps
   15.5 MiB [                 ]  lazygit
   12.4 MiB [                 ] /working
   11.7 MiB [                 ] /images
    9.0 MiB [                 ] /jobs
    3.1 MiB [                 ] /imports
    1.0 MiB [                 ] /static_data
  540.0 KiB [                 ]  60daily_temps_compare_years_claude.png
  528.0 KiB [                 ]  60daily_temps_compare_years_copilot.png
  516.0 KiB [                 ]  annual_energy_plot.png
  508.0 KiB [                 ]  weekly_E4279_elect_temp_ranges.png
  504.0 KiB [                 ]  weekly_kpwm_elect_temp_ranges.png
  468.0 KiB [                 ]  60daily_temps_compare_years.png
  464.0 KiB [                 ]  weekly_E4229_elect_temp_ranges.png
  436.0 KiB [                 ] /app
  408.0 KiB [                 ]  e4229weekly_temps_compare_years.png
  392.0 KiB [                 ]  e4279weekly_temps_compare_years.png
  372.0 KiB [                 ]  kpwmweekly_temps_compare_years.png
  316.0 KiB [                 ]  daily_e4229_elect_temp.png
  316.0 KiB [                 ]  monthly_stacked_energy_use.png
  276.0 KiB [                 ]  kpwm_daily_elect_temp.png
  260.0 KiB [                 ]  bardham_weekly_electric_temp_ranges.png
  260.0 KiB [                 ]  monthly_dollars_per_kwh.png

jcz@lamp:~/weather$ du -s --si
2.1G    .

jcz@lamp:~/weather$ git count-objects -v
count: 948
size: 975780
in-pack: 1456
packs: 1
size-pack: 757701
prune-packable: 0
garbage: 0
size-garbage: 0

jcz@lamp:~/weather$ git-sizer
Processing blobs: 1201
Processing trees: 722
Processing commits: 476
Matching commits to trees: 476
Processing annotated tags: 0
Processing references: 7
| Name                         | Value     | Level of concern               |
| ---------------------------- | --------- | ------------------------------ |
| Biggest objects              |           |                                |
| * Blobs                      |           |                                |
|   * Maximum size         [1] |  43.8 MiB | ****                           |

[1]  07b731c6310bd79243eac3d52f7209b2cedc08b2 (151178f37da3c26c0e0e97dd16447e4fb6b7b87c:dumps/weather-15Oct2019.sql)

jcz@lamp:~/weather$ git ls-tree -r -t -l --full-name HEAD | sort -n -k 4 -r | head -n 5
100644 blob 14bb748925d2ec1f9f5177f8b53278c6e49352d8 26572582   dumps/weather-09May2025.sql.gz
100644 blob 3cbfa6baf374764310b169dc4ed608f3dd0fa7ee 26553761   dumps/weather-08May2025.sql.gz
100644 blob 43e25da893f25f28d003c6871769ee07ca2c21c5 26041304   dumps/weather-07May2025.sql.gz
100644 blob 55d9fe63004cba4824fb764e116bf7685a43d2b7 26035963   dumps/weather-06May2025.sql.gz
100644 blob a71dbfeeb918fb746c3e5135cb2b26ae22f06cfb 25980610   archive/weather-05May2025.sql.gz
</pre>

Now identify the directories with the largest files. The approach below will blow them away and amend the git history as if they never existed -- be warned. Do more research if you want to selectively remove files or things that are more granular.

#### 4. Clean, Expunge, Compress

In my case my `dumps` and `archive` directories typically accumulate the cruft I want to drop. Let's confirm that.

```bash
# begin by analysing
git filter-repo --analyze
```

{: .box-terminal}
<pre>
jcz@lamp:~/weather$ git filter-repo --analyze
Processed 1201 blob sizes
Processed 476 commits

jcz@lamp:~/weather/.git/filter-repo/analysis$ ls -lht
total 212K
-rw-rw-r-- 1 jcz jcz 109K May 13 12:54 blob-shas-and-paths.txt
-rw-rw-r-- 1 jcz jcz  43K May 13 12:54 path-all-sizes.txt
-rw-rw-r-- 1 jcz jcz 1.7K May 13 12:54 extensions-all-sizes.txt
-rw-rw-r-- 1 jcz jcz  25K May 13 12:54 path-deleted-sizes.txt
-rw-rw-r-- 1 jcz jcz 1.3K May 13 12:54 directories-all-sizes.txt
-rw-rw-r-- 1 jcz jcz  509 May 13 12:54 extensions-deleted-sizes.txt
-rw-rw-r-- 1 jcz jcz  193 May 13 12:54 directories-deleted-sizes.txt
-rw-rw-r-- 1 jcz jcz 3.4K May 13 12:54 README
-rw-rw-r-- 1 jcz jcz 6.1K May 13 12:54 renames.txt
</pre>

Then you can try these commands. Some of these are really incriminating for me, like the one below.

```
jcz@lamp:~/weather$ less .git/filter-repo/analysis/directories-deleted-sizes.txt
jcz@lamp:~/weather$ less .git/filter-repo/analysis/blob-shas-and-paths.txt
jcz@lamp:~/weather$ less .git/filter-repo/analysis/path-all-sizes.txt
jcz@lamp:~/weather$ less .git/filter-repo/analysis/path-deleted-sizes.txt
jcz@lamp:~/weather$ less .git/filter-repo/analysis/README
```

{: .box-terminal}
<pre>
jcz@lamp:~/weather$ less .git/filter-repo/analysis/blob-shas-and-paths.txt

=== Files by sha and associated pathnames in reverse size ===
Format: sha, unpacked size, packed size, filename(s) object stored as
  14bb748925d2ec1f9f5177f8b53278c6e49352d8   26572582   25516501 dumps/weather-09May2025.sql.gz
  3cbfa6baf374764310b169dc4ed608f3dd0fa7ee   26553761   25495734 dumps/weather-08May2025.sql.gz
  43e25da893f25f28d003c6871769ee07ca2c21c5   26041304   25342898 dumps/weather-07May2025.sql.gz
  55d9fe63004cba4824fb764e116bf7685a43d2b7   26035963   25336991 dumps/weather-06May2025.sql.gz
  a71dbfeeb918fb746c3e5135cb2b26ae22f06cfb   25980610   25293898 archive/weather-05May2025.sql.gz
  3bcc6d472864017fefa2aa11bb2e54a5acec78bd   25972633   25282833 archive/weather-04May2025.sql.gz
  d095614d37501dcc50d2fd267a00064ab5f81e46   25961112   25273456 archive/weather-03May2025.sql.gz
  e092148ed252a0bc0d71342b035547b99b42688f   25943882   25257668 archive/weather-02May2025.sql.gz
  22875baa2c396cd790bf48cf9b31f9d2e9202d63   25931531   25243838 archive/weather-01May2025.sql.gz
  60435ab3cd5190ca0ef29ae1307ba80f72499649   25924811   25236304 archive/weather-30Apr2025.sql.gz
  783b689f9348906c66a4389c395df013b17665f8   25469636   24783745 dumps/weather-09Apr2025.sql.gz
  1f4b41839c6d85aecae695ef0ac32704be345941   25169254   24484055 dumps/weather-25Jan2025.sql.gz
  57d8871d430fe3ca4bb78acd49c14469108ac36f   24766310   24082958 dumps/weather-24Dec2024.sql.gz
  5452e3cd3c939292186ca11aa8eb596e158e1e37   20225522   19562033 dumps/weather-09Dec2024.sql.gz
</pre>

## Cleaning Up

Confirmed. I have a lot of low hanging fruit in my `dumps/` and `archive/` directories.

1. less .git/filter-repo/analysis/directories-deleted-sizes.txt

2. git filter-repo --invert-paths --path dumps/ --path archive/

{: .box-terminal}
<pre>
jcz@lamp:~/weather$ git filter-repo --force --invert-paths --path dumps/ --path archive/
Parsed 481 commits
New history written in 0.09 seconds; now repacking/cleaning...
Repacking your repo and cleaning out old unneeded objects
HEAD is now at 2c7875b Merge branch 'master' of https://github.com/johnzastrow/weather
Enumerating objects: 1905, done.
Counting objects: 100% (1905/1905), done.
Delta compression using up to 2 threads
Compressing objects: 100% (1080/1080), done.
Writing objects: 100% (1905/1905), done.
Total 1905 (delta 1114), reused 1433 (delta 806), pack-reused 0
Completely finished after 2.76 seconds.

</pre>

Now let's check the results

{: .box-terminal}
<pre>
jcz@lamp:~/weather$ du -s --si
385M    .

jcz@lamp:~/weather$ git count-objects -v
count: 0
size: 0
in-pack: 1905
packs: 1
size-pack: 94206
prune-packable: 0
garbage: 0
size-garbage: 0

jcz@lamp:~/weather$ git ls-tree -r -t -l --full-name HEAD | sort -n -k 4 -r | head -n 5
100755 blob fc397af9a792138358c8edb2dc8ae6259a343a12 16289792   lazygit
100644 blob 87847dd9668f287a41d23d4bfc000ac58f42ad23 12987594   working/12Nov2021WeatherDump_w_procs.tgz
100644 blob 4166218429103ee6383318f9782e6ab2b76fda61 8357986    images/weather_diagram.svg
100644 blob d031763bc56c8560ca44ff10bddb9f55e7b94552 3541163    images/weather_diagram2.svg
100644 blob b9b32dfe379a15fbad06dc7690a23bb99be52b85 1450208    imports/data_bardham.csv

jcz@lamp:~/weather$ git sizer
Processing blobs: 1007
Processing trees: 508
Processing commits: 390
Matching commits to trees: 390
Processing annotated tags: 0
Processing references: 395
| Name                         | Value     | Level of concern               |
| ---------------------------- | --------- | ------------------------------ |
| Biggest objects              |           |                                |
| * Blobs                      |           |                                |
|   * Maximum size         [1] |  30.8 MiB | ***                            |

[1]  e00710be8a656101c113fb95d6bc930a5b56557b (refs/replace/200bd0c1977662cfce28da0048a93bba9ae6577e:7March2019_weatherdump_pi.sql)

jcz@lamp:~/weather$ git status
On branch master
Untracked files:
  (use "git add <file>..." to include in what will be committed)
        archive/
        dumps/
  </file>

nothing added to commit but untracked files present (use "git add" to track)
</pre>

It looks like as far as git is concerned, we're pretty clean. But let's try this

{: .box-terminal}
<pre>
3. git filter-repo --analyze
4. head -n 10 .git/filter-repo/analysis/path-all-sizes.txt
  example 9. git filter-repo --invert-paths --path-regex '^assets\/lib\/mermaid\/(?!mermaid\.min\.js$).*'
5.  git gc --aggressive --prune=now
6.  git count-objects -v
7.  git remote add weather git@git.[url]

git remote add origin git@github.com:johnzastrow/weather.git

jcz@lamp:~/weather$ git push
fatal: The current branch master has no upstream branch.
To push the current branch and set the remote as upstream, use

    git push --set-upstream origin master

To have this happen automatically for branches without a tracking
upstream, see 'push.autoSetupRemote' in 'git help config'.

8.  git push origin --force --all
9.  git push origin --force --tags

jcz@lamp:~/weather$ git push origin --force --all
Enumerating objects: 1905, done.
Counting objects: 100% (1905/1905), done.
Delta compression using up to 2 threads
Compressing objects: 100% (772/772), done.
Writing objects: 100% (1905/1905), 91.95 MiB | 1007.00 KiB/s, done.
Total 1905 (delta 1114), reused 1905 (delta 1114), pack-reused 0
remote: Resolving deltas: 100% (1114/1114), done.
To github.com:johnzastrow/weather.git
 + f243c82...08406a0 baseline -> baseline (forced update)
 + 864ee0d...2c7875b master -> master (forced update)
 * [new branch]      dependabot/pip/pillow-9.3.0 -> dependabot/pip/pillow-9.3.0

git gc --aggressive --prune=now
</pre>

# Resources

* (<https://docs.github.com/en/migrations/importing-source-code/using-the-command-line-to-import-source-code/adding-locally-hosted-code-to-github>)
* <https://onenine.com/how-to-reduce-git-repository-size-safely/>

<https://www.golinuxcloud.com/reduce-git-repo-size-with-git-filter-branch/>

<https://ryanagibson.com/posts/shrink-git-repo/>

<https://sentry.io/answers/revert-a-git-repository-to-a-previous-commit/>
<https://andrewlock.net/rewriting-git-history-simply-with-git-filter-repo/>
<https://www.golinuxcloud.com/reduce-git-repo-size-with-git-filter-branch/>

## More testing

{: .box-terminal}
<pre>
$ git filter-repo --invert-paths --path dumps/ --path archive/
$ du -s --si
37M .

ncdu /home/jcz/weather

jcz@lamp:~/weather$ git filter-repo --analyze
Processed 1201 blob sizes
Processed 476 commits

jcz@lamp:~/weather/.git/filter-repo/analysis$ ls -lht
total 212K
-rw-rw-r-- 1 jcz jcz 109K May 13 12:54 blob-shas-and-paths.txt
-rw-rw-r-- 1 jcz jcz  43K May 13 12:54 path-all-sizes.txt
-rw-rw-r-- 1 jcz jcz 1.7K May 13 12:54 extensions-all-sizes.txt
-rw-rw-r-- 1 jcz jcz  25K May 13 12:54 path-deleted-sizes.txt
-rw-rw-r-- 1 jcz jcz 1.3K May 13 12:54 directories-all-sizes.txt
-rw-rw-r-- 1 jcz jcz  509 May 13 12:54 extensions-deleted-sizes.txt
-rw-rw-r-- 1 jcz jcz  193 May 13 12:54 directories-deleted-sizes.txt
-rw-rw-r-- 1 jcz jcz 3.4K May 13 12:54 README
-rw-rw-r-- 1 jcz jcz 6.1K May 13 12:54 renames.txt
</pre>

## Branching - for fun and development

**Creating a new branch:**
From the current branch: To create a new branch based on the current branch you are on, use the following command:

```bash
    git branch <new-branch-name>
```

This command creates the new branch but does not automatically switch you to it.
From the current branch and switching to it immediately: To create a new branch and switch to it in one step, use:

```bash
    git checkout -b <new-branch-name>
```

This is a common and convenient way to start working on a new feature or fix.
From a specific commit: If you need to create a branch from a particular point in the repository's history (a specific commit), you first need the commit's SHA-1 identifier. You can find this using git log. Once you have the commit ID, use:

```bash
    git branch <new-branch-name> <commit-id>
```

You would then need to manually switch to this branch using git checkout <new-branch-name>.
Switching between branches:

To move from one branch to another, use the git checkout command:

```bash
git checkout <existing-branch-name>
```

**Viewing branches:**

To see a list of all local branches in your repository and identify the currently active branch (indicated by an asterisk), use:

```bash
git branch
```

**Pushing a new local branch to a remote repository:**

If you want your new local branch to be available on a remote repository (like GitHub or GitLab), you need to push it:

```bash
git push -u origin <new-branch-name>
```

The -u flag sets the upstream tracking, so future git push and git pull commands for this branch will automatically know which remote branch to interact with.


## Merging a Development branch back into Main branch

Merging a development branch into the main branch in Git involves integrating the changes from the development branch into the main branch. This process typically follows these steps:
Ensure main branch is up-to-date locally:

```bash
    git checkout main
    git pull origin main
```

Ensure development branch is up-to-date locally (optional but good practice):

```bash
    git checkout development
    git pull origin development
```

If you've made local changes on development not yet pushed, you would push them first:

```bash
    git push origin development
```

Switch to the main branch.

```bash
    git checkout main
```

Merge the development branch into main.

```bash
    git merge development
```

If there are no conflicts, Git will automatically create a merge commit.
If conflicts arise, you must resolve them manually. Git will guide you through the files with conflicts. After resolving, git add <conflicted-file> for each resolved file, and then git commit to finalize the merge.

Push the merged main branch to the remote repository:

```bash
    git push origin main
```

This sequence of commands ensures that the main branch on your local and remote repositories reflects the integrated changes from the development branch.


# Using Git
Merging and conflicts

[https://stackoverflow.com/questions/161813/how-do-i-resolve-merge-conflicts-in-a-git-repository](https://stackoverflow.com/questions/161813/how-do-i-resolve-merge-conflicts-in-a-git-repository)

[https://weblog.masukomi.org/2008/07/12/handling-and-avoiding-conflicts-in-git/](https://weblog.masukomi.org/2008/07/12/handling-and-avoiding-conflicts-in-git/)

### vimdiff

Vim has a built-in diff mode that can be used to compare and merge files. When working with Git, you can use `vimdiff` to resolve merge conflicts or compare different versions of files.
Here are some useful commands and tips for using `vimdiff` effectively:

**Starting vimdiff:**
To start `vimdiff`, you can use the following command in your terminal:
```bash
vimdiff file1 file2
```

This will open `file1` and `file2` in split windows, highlighting the differences between them.
| `:diffthis` | Type in each split window to diff existing buffers |
| `:diffoff` | Type to turn off diff mode |

Use **Ctrl**+**w**, **Ctrl**+**w** to switch between windows. [Via](https://amjith.blogspot.com/2008/08/quick-and-dirty-vimdiff-tutorial.html).

### **Navigating**

|     |     |
| --- | --- |
| `]c` | Jump to Next difference |
| `[c` | Jump to Previous difference |

### **Editing**

|     |     |
| --- | --- |
| `do` | Diff Obtain!  <br>Pull the changes to the current file. |
| `dp` | Diff Put!  <br>Push the changes to the other file. |
| `:diffupdate` or `:diffu` | Re-scan the files for differences. |
| `ZQ` | Quit without checking changes |

### **Folds, Unfolding and Quitting**

|     |     |
| --- | --- |
| `zo` _/_ `zO` | Open (the fold) |
| `zc` _/_ `zC` | Close (the fold) |
| `za` _/_ `zA` | Toggle (the fold) |
| `zv` | Open folds for this line |
| `zM` | Close all |
| `zR` | Open all |
| `zm` | Fold more _(foldlevel += 1)_ |
| `zr` | Fold less _(foldlevel -= 1)_ |
| `zx` | Update folds |
| `:q` | Quit the current window/buffer. |
| `:qa` | Quit **all** windows/buffers. |
| `:qa!` | Force quit all, discarding any unsaved changes. |
| `:wq` | Write (save) the current file and then quit the window
| `:xa` or `:wqa` | Write all modified files and quit all windows. |


### Vimdiff for Git Merge Conflicts

When you have merge conflicts in Git, you can use `vimdiff` to visually compare and resolve them. Here’s a quick guide on how to use `vimdiff` effectively for this purpose.    

**Configuring Git to Use vimdiff:**
To set `vimdiff` as your default merge tool in Git, run the following command:
```bash
git config --global merge.tool vimdiff
git config --global mergetool.prompt false
```


**Basic Concepts:**
*   In a Git merge conflict, you typically have three versions of a file:
    
    *   **LOCAL**: Your version (the one in your current branch).
    *   **REMOTE**: The incoming version (the one from the branch you are merging).
    *   **BASE**: The common ancestor version (the original file before both changes).
    *   **MERGED**: The file with conflict markers that Git creates.
    *   `vimdiff` will open these versions in split windows for comparison.
  

**Starting vimdiff with Git:**
To open `vimdiff` for resolving merge conflicts, you can use the following Git command:

```bash
    git mergetool
```

*   `:diffg RE`: get from REMOTE
*   `:diffg BA`: get from BASE
*   `:diffg LO`: get from LOCAL

**Using vimdiff:**
  
  * You can navigate between these windows and use commands to resolve conflicts.
    *   `<C-w> h/j/k/l`: Navigate between split windows.
    *   `:qa`: Quit all windows.
    *   `:qa!`: Force quit all windows (discarding changes).
    *   `:wqa`: Write (save) all changes and quit.
    *   `:set diffopt+=iwhite`: Ignore whitespace differences.
    *   `:set wrap`: Wrap lines in the current window.
    *   `:syn off`: Disable syntax highlighting for better visibility of differences.
    *   `:set diffopt+=iwhite`: Ignore whitespace differences.
    *   `:set wrap`: Wrap lines in the current window.
    *   `:syn off`: Disable syntax highlighting for better visibility of differences.
    *   `:set diffopt+=iwhite`: Ignore whitespace differences.
* 

### Difference between `do`/`dp` and `:diffget`/`:diffput`

`do` and `dp` are **normal mode shortcuts** for the ex-mode commands `:diffget` and `:diffput`, respectively. The key difference lies in their interaction with the current selection and their usage in multi-way (3 or more files) diff scenarios.

**Normal Mode Commands (**`**do**` **and** `**dp**`**)**

*   **Mode:** Used in normal mode (press `Esc` to ensure you are in normal mode).
*   **Scope:** Operate on the entire "hunk" (block of differences) where your cursor is currently located.
*   **Simplicity:** They are quick, single-command operations, designed for speed and convenience when working in a two-way diff.
*   **Usage:**
    
    *   `do`: "Diff Obtain". Gets the change from the _other_ window and applies it to the _current_ window's buffer at the cursor position.
    *   `dp`: "Diff Put". Puts the change from the _current_ window's buffer into the _other_ window's buffer.

**Ex-Mode Commands (**`**:diffget**` **and** `**:diffput**`**)**

*   **Mode:** Used as colon commands (ex-mode).
*   **Scope:**
    
    *   When used without arguments in a two-way diff, they function identically to `do` and `dp`, operating on the current hunk.
    *   Their primary advantage is their ability to accept a range (e.g., in visual mode, using `V` to select lines, then typing `:diffget`) or a specific buffer name/number as an argument. This allows for more granular control, such as copying only a few lines from a larger hunk, or specifying which exact buffer to obtain from/put to.
*   **Flexibility:** Essential for managing **three-way diffs** (like when resolving Git merge conflicts), where you need to explicitly state which of the multiple alternative buffers (e.g., local version, remote version, or the merge result) you want to use.

**Summary of Differences**

| **Feature** | `**do**` **/** `**dp**` | `**:diffget**` **/** `**:diffput**` |
| --- | --- | --- |
| **Mode** | Normal mode (quick keys) | Ex-mode (colon commands) |
| **Scope (default)** | Current difference "hunk" | Current difference "hunk" |
| **Arguments** | No arguments; works on adjacent buffer by default | Can accept a range or a specific buffer name/number |
| **Multi-way Diffs** | Less effective, as they don't specify _which_ other buffer to use | Required for specifying source/destination buffers precisely |

In short, `do` and `dp` are convenient shortcuts for simple two-file comparisons, while `:diffget` and `:diffput` offer advanced control for complex merging situations or specific line-range operations.

[](https://labs.google.com/search/experiment/22)

## Lazygit
Lazygit is a simple terminal UI for git commands, written in Go with the gocui library. It aims to provide a fast and intuitive way to interact with git repositories without needing to remember complex command-line syntax.

**In short, lazygit is awesome**

```bashbash
sudo apt install lazygit
lazygit
```
https://github.com/jesseduffield/lazygit

## Sending a local git repo to a new remote (Github)

### Using the Github CLI

First install the Github CLI tool, `gh`. Then you can use the `gh repo create` command to create a new repository on GitHub and optionally clone it locally.

* [Linux instructions](https://github.com/cli/cli/blob/trunk/docs/install_linux.md)
* [MacOS instructions](https://github.com/cli/cli/blob/trunk/docs/install_mac.md)
* [Windows instructions](https://github.com/cli/cli/blob/trunk/docs/install_windows.md) 
* [Github CLI documentation](https://cli.github.com/manual/gh_repo_create)
* [Github CLI repo create documentation](https://cli.github.com/manual/gh_repo_create)


#### Examples
```bash
# Create a repository interactively
$ gh repo create

# Create a new remote repository and clone it locally
$ gh repo create my-project --public --clone

# Create a new remote repository in a different organization
$ gh repo create my-org/my-project --public
```

#### Reference
```
gh repo create
gh repo create [<name>] [flags]
```
Create a new GitHub repository.

To create a repository interactively, use gh repo create with no arguments.

To create a remote repository non-interactively, supply the repository name and one of `--public, --private, or --internal`. Pass `--clone` to clone the new repository locally.

If the OWNER/ portion of the OWNER/REPO name argument is omitted, it defaults to the name of the authenticating user.

To create a remote repository from an existing local repository, specify the source directory with `--source`. By default, the remote repository name will be the name of the source directory.

Pass `--push` to push any local commits to the new repository. If the repo is bare, this will mirror all refs.

For language or platform .gitignore templates to use with `--gitignore`, visit [GitHub gitignore](https://github.com/github/gitignore).

For license keywords to use with `--license`, run `gh repo license list` or visit [Choose a License](https://choosealicense.com).

The repo is created with the configured repository default branch, see [Managing the default branch name for your repositories](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-user-account-settingsmanaging-the-default-branch-name-for-your-repositories)       .

##### Options

* `--add-readme`
Add a README file to the new repository

* `-c, --clone`
Clone the new repository to the current directory

* `-d, --description <string>`
Description of the repository

* `--disable-issues`
Disable issues in the new repository

* `--disable-wiki`
Disable wiki in the new repository

* `-g, --gitignore <string>`
Specify a gitignore template for the repository

* `-h, --homepage <URL>`
Repository home page URL

* `--include-all-branches`
Include all branches from template repository

* `--internal`
Make the new repository internal

* `-l, --license <string>`
Specify an Open Source License for the repository

* `--private`
Make the new repository private

* `--public`
Make the new repository public

* `--push`
Push local commits to the new repository

* `-r, --remote <string>`
Specify remote name for the new repository

* `-s, --source <string>`
Specify path to local repository to use as source

* `-t, --team <name>`
The name of the organization team to be granted access

* `-p, --template <repository>`
Make the new repository based on a template repository


ALIASES
* `gh repo create` is also available as `gh repo new`.

### Using the Git command line tool

#### Creating a new repository on GitHub and adding it as a remote to your local repository
It's often easier to first create a new repository on GitHub using the web interface, and then add it as a remote to your local repository. Here are the steps to do that:
1. Go to GitHub and create a new repository. You can choose to initialize it with a README, .gitignore, or license if you want, but it's not necessary if you already have a local repository.
2. Once the repository is created, you'll be taken to the repository page. Click on the
3. "Code" button and copy the URL of the repository (either HTTPS or SSH, depending on your preference, though SSH works better most of the time for later operations).
4. Open your terminal and navigate to your local repository.
5. Add the GitHub repository as a remote to your local repository using the following command:
6. ```bash
git remote add origin <repository-url>
# for example:
# git remote add origin https://github.com/username/repository.git
```
Replace `<repository-url>` with the URL you copied from GitHub.
7. Now you can push your local commits to the GitHub repository using:
```bash
git push -u origin master # the standard and default name is now main
```
This command pushes your local `master` branch to the `origin` remote (the GitHub repository) and sets it as the upstream branch for future pushes.
8. If you have other branches, you can push them as well using:
```bash
git push -u origin <branch-name>
```
Replace `<branch-name>` with the name of the branch you want to push. See branching above for more details on working with branches.

#### Creating a new repository on GitHub from an existing local repository
If you want to send a locally created repository to GitHub, you
can use the Github CLI tool (`gh`) or the plain Git command line tool, hereafter just called `git`. 

Here's how to do it using just git commands:
1. First, make sure you have git installed and authenticated with your GitHub account.
2. Open your terminal and navigate to your local repository.
3. Use the following command to create a new repository on GitHub from your local repository:

```bash
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin <repository-url>
# for example:
# git remote add origin https://github.com/username/repository.git 

git push -u origin main
```
* Replace `<repository-url>` with the URL of your GitHub repository. 
* The `git init` command initializes a new Git repository in your local directory. 
* The `git add .` command stages all files for the initial commit. 
* The `git commit -m "Initial commit"` command creates the initial commit. 
* The `git branch -M main` command renames the default branch to `main`. 
* The `git remote add origin <repository-url>` command adds the GitHub repository as a remote. 
* Finally, the `git push -u origin main` command pushes the initial commit to GitHub and sets the upstream branch.  
  
```
This command pushes your local `main` branch to the `origin` remote (the GitHub repository) and sets it as the upstream branch for future pushes.
1. If you have other branches, you can push them as well using:
```bash
git push -u origin <branch-name>
```
Replace `<branch-name>` with the name of the branch you want to push.       

Update: looks like you can't push without the repo existing already in Github

```
> git push -u origin master
remote: Repository not found.
fatal: repository 'https://github.com/johnzastrow/deleteme2.git/' not found
```