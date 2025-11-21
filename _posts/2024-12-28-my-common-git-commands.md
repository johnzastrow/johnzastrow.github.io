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

nothing added to commit but untracked files present (use "git add" to track)


</pre>

It looks like as far as git is concerned were pretty clean. but 


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
```


# Resources

* (https://docs.github.com/en/migrations/importing-source-code/using-the-command-line-to-import-source-code/adding-locally-hosted-code-to-github)
* https://onenine.com/how-to-reduce-git-repository-size-safely/

https://www.golinuxcloud.com/reduce-git-repo-size-with-git-filter-branch/

https://ryanagibson.com/posts/shrink-git-repo/

https://sentry.io/answers/revert-a-git-repository-to-a-previous-commit/
https://andrewlock.net/rewriting-git-history-simply-with-git-filter-repo/
https://www.golinuxcloud.com/reduce-git-repo-size-with-git-filter-branch/



$ git filter-repo --invert-paths --path dumps/ --path archive/
$ du -s --si
37M	.




	

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




Use LazyGit to visualize git repos and merge conflicts on remote hosts without a GUI

https://github.com/jesseduffield/lazygit

```bash
sudo apt install lazygit
lazygit
```




