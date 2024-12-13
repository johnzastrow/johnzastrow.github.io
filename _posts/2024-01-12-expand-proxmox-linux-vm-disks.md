---
layout: post
title: Expand Linux VM Disk under Proxmox VE
subtitle: Notes for myself as I need to keep looking this up
gh-badge: [star, fork, follow]
date: '2024-01-12T12:47:41-05:00'
tags: [linux]
comments: true
---
Updated: 12-Dec-2024

Sources: 
**1** <https://pve.proxmox.com/wiki/Resize_disks>, 
**2** <https://packetpushers.net/blog/ubuntu-extend-your-default-lvm-space/>

I'm writing this down because I do this about every six months and spend a day looking it up and breaking stuff every time. I use LVM and ext4 file system in my VMs.

## Expansion Process

If I enlarge the hard disk, once I have added the disk plate, my partition table and file system knows nothing about the new size, so I have to act inside the VM to fix it.

If I reduce (shrink) the hard disk, of course removing the last disk plate will probably destroy my file system and remove the data in it! So in this case it is paramount to act in the VM in advance, reducing the file system and the partition size. SystemRescueCD comes very handy for it, just add its iso as cd-rom of my VM and set boot priority to CD-ROM.

Shrinking disks is not supported by the PVE API and has to be done manually."

## 1. Resizing guest disk

#### qm command (or use the resize command in the GUI)

You can resize my disks online or offline with command line:

```qm resize <vmid> <disk> <size>```

example: to add 5G to my virtio0 disk on vmid100:

```qm resize 100 virtio0 +5G```

For virtio disks, Linux should see the new size online without reboot with kernel >= 3.6

## 2. Enlarge the partition(s) in the virtual disk

We will assume I am using LVM on the storage and the VM OS is using ext4 filesystem.

#### Online for Linux Guests

Here we will enlarge a LVM PV partition, but the procedure is the same for every kind of partitions. Note that the partition I want to enlarge should be at the end of the disk. If I want to enlarge a partition which is anywhere on the disk, use the offline method.

Check that the kernel has detected the change of the hard drive size
(here we use VirtIO so the hard drive is named vda)

```bash dmesg | grep vda```

```

[3982.979046] vda: detected capacity change from 34359738368 to 171798691840

```

#### Example with EFI

Print the current partition table

{: .box-terminal}
<pre>
fdisk -l /dev/vda | grep ^/dev

GPT PMBR size mismatch (67108863 != 335544319) will be corrected by w(rite).
/dev/vda1      34     2047     2014 1007K BIOS boot
/dev/vda2    2048   262143   260096  127M EFI System
/dev/vda3  262144 67108830 66846687 31.9G Linux LVM
</pre>

Resize the partition 3 (LVM PV) to occupy the whole remaining space of the hard drive)

{: .box-terminal}
<pre>

parted /dev/vda

(parted) print
Warning: Not all of the space available to /dev/vda appears to be used, I can
fix the GPT to use all of the space (an extra 268435456 blocks) or continue
with the current setting?
Fix/Ignore? F
(parted) resizepart 3 100%
(parted) quit
</pre>

#### Example without EFI

Another example without EFI using parted:

{: .box-terminal}
<pre>
parted /dev/vda
(parted) print
Number  Start   End     Size    Type      File system  Flags
1       1049kB  538MB   537MB   primary   fat32        boot
2       539MB   21.5GB  20.9GB  extended
3       539MB   21.5GB  20.9GB  logical                lvm
</pre>

Resize the 2nd partition, first (extended):

{: .box-terminal}
<pre>
(parted) resizepart 2 100%
(parted) resizepart 3 100%
</pre>

Check the new partition table

{: .box-terminal}
<pre>
(parted) print
Number  Start   End     Size    Type      File system  Flags
1       1049kB  538MB   537MB   primary   fat32        boot
2       539MB   26.8GB  26.3GB  extended
3       539MB   26.8GB  26.3GB  logical                lvm
(parted) quit
</pre>

## 3. Enlarge the filesystem(s) in the partitions on the virtual disk

If I did not resize the filesystem in step 2

#### Online for Linux guests with LVM

Enlarge the physical volume to occupy the whole available space in the partition:

```pvresize /dev/vda3```

List logical volumes:

{: .box-terminal}
<pre>
lvdisplay
 --- Logical volume ---
 LV Path                /dev/{volume group name}/root
 LV Name                root
 VG Name                {volume group name}
 LV UUID                DXSq3l-Rufb-...
 LV Write Access        read/write
 LV Creation host, time ...
 LV Status              available
 # open                 1
 LV Size                <19.50 GiB
 Current LE             4991
 Segments               1
 Allocation             inherit
 Read ahead sectors     auto
 - currently set to     256
 Block device           253:0
</pre>

I've noted that in Ubuntu Server the Volume Group Name does not end in root as Ubuntu Desktop does.

Here is Ubuntu Server

{: .box-terminal}
<pre>

--- Logical volume ---
  LV Path                /dev/ubuntu-vg/ubuntu-lv
  LV Name                ubuntu-lv
  VG Name                ubuntu-vg
  LV UUID                DoMD3y-0lmV-osy5-mwOj-hMs9-ruaV-S8ufTu
  LV Write Access        read/write
  LV Creation host, time ubuntu-server, 2022-01-24 21:59:57 +0000
  LV Status              available
  # open                 1
  LV Size                <66.00 GiB
  Current LE             16895
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0

</pre>

and here is Ubuntu Desktop (Ubuntu Mate)

{: .box-terminal}
<pre>
 --- Logical volume ---
  LV Path                /dev/vgubuntu-mate/root
  LV Name                root
  VG Name                vgubuntu-mate
  LV UUID                Z270jO-SCGC-cttK-Vtac-m2gF-zILg-dPA9xO
  LV Write Access        read/write
  LV Creation host, time ubuntu-mate, 2023-11-19 18:59:16 -0500
  LV Status              available
  # open                 1
  LV Size                <55.77 GiB
  Current LE             14276
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:0
</pre>

Enlarge the logical volume and the filesystem (the file system can be mounted, works with ext4 and xfs). Replace "{volume group name}" with my specific volume group name:

This command will increase the partition up by 20GB

```lvresize --size +20G --resizefs /dev/{volume group name}/root```

Use all the remaining space on the volume group

```lvresize --extents +100%FREE --resizefs /dev/{volume group name}/root```

Online for Linux guests without LVM
Enlarge the filesystem (in this case root is on vda1)
An ext4 file system may be grown while mounted using the resize2fs command:

``` resize2fs /mount/device size ```

```bash
resize2fs /dev/vda1
```

<!-- [![Example](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/linref1.jpg)](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/linref1.jpg)
*Figure 1. The real data* as shown in QGIS. -->

# From the second article

## For just Ubuntu/Debian and assumes there is free space in the partition

See the second link above. The default Ubuntu installer settings may not use my entire root partition available to it. So I may use these commands to expand the usable space to grab up all the free space that may be left in the partition.

A. Start by checking my root filesystem free space with ```df -h ```
 Here I am using 32% or 20GB/65GB of the file System
 
 
 {: .box-terminal}
<pre>
 jcz@lamp:~$ df -h
Filesystem                         Size  Used Avail Use% Mounted on
tmpfs                              383M  1.7M  381M   1% /run
/dev/mapper/ubuntu--vg-ubuntu--lv   65G   20G   43G  32% /
tmpfs                              1.9G     0  1.9G   0% /dev/shm
tmpfs                              5.0M     0  5.0M   0% /run/lock
/dev/vda2                          974M  182M  725M  21% /boot
tmpfs                              382M   12K  382M   1% /run/user/1000
</pre>

B. Check for existing free space on my Volume Group, run the command ```vgdisplay``` and check for free space. Here I can see I have 16.00 GiB of free space (Free PE) ready to be used. If I don’t have any free space, move on to the next section to use some free space from an extended physical (or virtual) disk.

 {: .box-terminal}
<pre>

root@pbs:~# vgdisplay
  --- Volume group ---
  VG Name               pbs
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  3
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                2
  Open LV               2
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <199.00 GiB
  PE Size               4.00 MiB
  Total PE              50943
  Alloc PE / Size       46847 / <183.00 GiB
  Free  PE / Size       4096 / 16.00 GiB  <---
  VG UUID               pUCnBq-dYv7-wN3m-NTvy-XFwD-YT2e-UOku16
  
</pre>

C. Use up any free space on my Volume Group (VG) for my root Logical Volume (LV), first run the ```lvdisplay``` command and check the Logical Volume (LV) size, then run ```lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv``` to extend the LV (from the LV Path) to the maximum size usable, then run ```lvdisplay``` one more time to make sure it changed.


 {: .box-terminal}
<pre>

root@pbs:~# lvdisplay

  --- Logical volume ---
  LV Path                /dev/pbs/root
  LV Name                root
  VG Name                pbs
  LV UUID                80mBRo-cMoc-OIST-hn7j-ootY-dH8E-TghShK
  LV Write Access        read/write
  LV Creation host, time proxmox, 2024-11-17 16:05:04 -0500
  LV Status              available
  # open                 1
  LV Size                <179.00 GiB   <---
  Current LE             45823
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:1
</pre>

Let's use up the remaining free space

 {: .box-terminal}
<pre>

root@pbs:~# lvdisplay
root@pbs:~# lvextend -l +100%FREE /dev/pbs/root
  Size of logical volume pbs/root changed from <179.00 GiB (45823 extents) to <195.00 GiB (49919 extents).
  Logical volume pbs/root successfully resized.
  
  </pre>
  
  That seemed to work. Let's check it to verify.
  
   {: .box-terminal}
<pre>
  
  root@pbs:~# lvdisplay
    --- Logical volume ---
  LV Path                /dev/pbs/root
  LV Name                root
  VG Name                pbs
  LV UUID                80mBRo-cMoc-OIST-hn7j-ootY-dH8E-TghShK
  LV Write Access        read/write
  LV Creation host, time proxmox, 2024-11-17 16:05:04 -0500
  LV Status              available
  # open                 1
  LV Size                <195.00 GiB
  Current LE             49919
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:1
  
  </pre>
  
D. Now I have increased the size of the block volume where the root filesystem resides, but I still need to extend the filesystem on top of it. First, I will run ```df -h``` to verify my (almost full) root file system, then I will run ```resize2fs /dev/mapper/pbs-root``` to extend my filesystem, and run ```df -h``` one more time to make sure I'm successful. of course I'm using Debian here as installed on a test instance of Proxmox Backup Server that I'm going to blow away.
  
   {: .box-terminal}
<pre>
root@pbs:~# df -h
Filesystem            Size  Used Avail Use% Mounted on
udev                  1.9G     0  1.9G   0% /dev
tmpfs                 382M  692K  381M   1% /run
/dev/mapper/pbs-root  176G  2.0G  165G   2% /
tmpfs                 1.9G     0  1.9G   0% /dev/shm
tmpfs                 5.0M     0  5.0M   0% /run/lock
efivarfs              256K   60K  192K  24% /sys/firmware/efi/efivars
/dev/sda2            1022M   12M 1011M   2% /boot/efi
tmpfs                 382M     0  382M   0% /run/user/0

</pre>

OK, below looks good!

 {: .box-terminal}
<pre>
root@pbs:~# resize2fs /dev/mapper/pbs-root
resize2fs 1.47.0 (5-Feb-2023)
Filesystem at /dev/mapper/pbs-root is mounted on /; on-line resizing required
old_desc_blocks = 23, new_desc_blocks = 25
The filesystem on /dev/mapper/pbs-root is now 51117056 (4k) blocks long.

root@pbs:~# df -h
Filesystem            Size  Used Avail Use% Mounted on
udev                  1.9G     0  1.9G   0% /dev
tmpfs                 382M  692K  381M   1% /run
/dev/mapper/pbs-root  191G  2.0G  180G   2% /
tmpfs                 1.9G     0  1.9G   0% /dev/shm
tmpfs                 5.0M     0  5.0M   0% /run/lock
efivarfs              256K   60K  192K  24% /sys/firmware/efi/efivars
/dev/sda2            1022M   12M 1011M   2% /boot/efi
tmpfs                 382M     0  382M   0% /run/user/0
</pre>

Great! I just allocated the free space left behind by the installer to my root filesystem. If this is still not enough space, I will continue on to the next section to allocate more space by extending an underlying disk.


### Use Space from Extended Physical (or Virtual) Disk

*Using examples from the author *

A. First I might need to increase the size of the disk being presented to the Linux OS. This is most likely done by expanding the virtual disk in KVM/VMWare/Hyper-V or by adjusting my RAID controller / storage system to increase the volume size. You can often do this while Linux is running; without shutting down or restarting. 

B. Once that is done, I may need to get Linux to rescan the disk for the new free space. Check for free space by running ```cfdisk``` and see if there is free space listed, use “q” to exit once I’re done.

[![cfdisk.png](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/cfdisk.png)](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/cfdisk.png)


If I don’t see free space listed, then I initiate a rescan of ```/dev/sda```  with ```echo 1>/sys/class/block/sda/device/rescan``` . Once done, rerun ```cfdisk``` and I should see the free space listed.

[![free-partition-space-scan.jpg](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/free-partition-space-scan.jpg)](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/free-partition-space-scan.jpg)


C. Select my ```/dev/sda3``` partition from the list and then select “Resize” from the bottom menu. Hit ENTER and it will prompt me to confirm the new size. Hit ENTER again and I will now see the ```/dev/sda3``` partition with a new larger size.

* Select ***“Write”*** from the bottom menu, type ***yes*** to confirm, and hit ***ENTER***. Then use ***“q”*** to exit the program.

D. Now that the LVM partition backing the ```/dev/sda3``` Physical Volume (PV) has been extended, we need to extend the PV itself. Run ```pvresize /dev/sda3``` to do this and then use ```pvdisplay``` to check the new size.



[![free-partition-space-scan.jpg](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/free-partition-space-scan.jpg)](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/free-partition-space-scan.jpg)

As I can see above, my PV has been increased from 98.5GB to 198.5GB. Now let’s check the Volume Group (VG) free space with ```vgdisplay```.

[![vg-space-vgdisplay.jpg](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/vg-space-vgdisplay.jpg)](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/vg-space-vgdisplay.jpg)

We can see above that the VG has 100GB of free space. Now let’s check the size of our upstream Logical Volume (LV) using ```lvdisplay```.

E. Now we extend the LV to use up all the VG’s free space with ```lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv```, and then check the LV one more time with ```lvdisplay``` to make sure it has been extended.


[![lv-size-lvdisplay.jpg](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/lv-size-lvdisplay.jpg)](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/lv-size-lvdisplay.jpg)


F. At this point, the block volume underpinning our root filesystem has been extended, but the filesystem itself has not been resized to fit that new volume. To do this, run ```df -h``` to check the current size of the file system, then run ```resize2fs /dev/mapper/ubuntu–vg-ubuntu–lv``` to resize it, and ```df -h``` one more time to check the new file system available space.



[![extend-filesystem-resize2fs.jpg](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/extend-filesystem-resize2fs.jpg)](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/_posts/img/extend-filesystem-resize2fs.jpg)

And there I go. I’ve now taken an expanded physical (or virtual) disk and moved that free space all the way up through the LVM abstraction layers to be used by my (critically full) root file system. 


## Other useful commands and their output

{: .box-terminal}
<pre>
fdisk -l
Disk /dev/vda: 67 GiB, 71940702208 bytes, 140509184 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: D1A6933C-7817-4756-AA1B-5D924F3054B0

Device       Start       End   Sectors Size Type
/dev/vda1     2048      4095      2048   1M BIOS boot
/dev/vda2     4096   2101247   2097152   1G Linux filesystem
/dev/vda3  2101248 140509150 138407903  66G Linux filesystem

Disk /dev/mapper/ubuntu--vg-ubuntu--lv: 66 GiB, 70862766080 bytes, 138403840 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
</pre>

{: .box-terminal}
<pre>
lsblk
NAME                      MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
loop0                       7:0    0   1.9M  1 loop /snap/bottom/759
loop1                       7:1    0     4K  1 loop /snap/bare/5
loop2                       7:2    0   1.9M  1 loop /snap/btop/655
loop3                       7:3    0   9.6M  1 loop /snap/canonical-livepatch/246
loop4                       7:4    0 105.8M  1 loop /snap/core/16202
loop5                       7:5    0  63.9M  1 loop /snap/core20/2105
loop6                       7:6    0  74.1M  1 loop /snap/core22/1033
loop7                       7:7    0 152.1M  1 loop /snap/lxd/26200
loop8                       7:8    0  40.4M  1 loop /snap/snapd/20671
vda                       252:0    0    67G  0 disk
├─vda1                    252:1    0     1M  0 part
├─vda2                    252:2    0     1G  0 part /boot
└─vda3                    252:3    0    66G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0    66G  0 lvm  /
</pre>


#### Volume and Partition Commands

```bash
growpart /dev/sda 3
pvresize /dev/sda3
lvextend -l +100%FREE /dev/pve/root
resize2fs /dev/mapper/pve-root
```

* Try also `vgs`  vgs — Display information about volume groups. Add -v or -vv or -vvv to see more details. And `lvs`  lvs — Display information about logical volumes, also with -v and -vv to see more.

* Note that lvresize can be used for both shrinking and/or extending while lvextend can only be used for extending.

* There are two separate things:

    - The filesystem, a data structure that provides a way to store distinct named files, and the block device (disk, partition, LVM volume) on inside of which the filesystem lies

    - `resize2fs` resizes the filesystem, i.e. it modifies the data structures there to make use of new space, or to fit them in a smaller space. It doesn't affect the size of the underlying device.

    - `lvresize` resizes an LVM volume, but it doesn't care at all what lies within it.

    - So, to reduce a volume, you have to first reduce the filesystem to a new size (resize2fs), and after that you can resize the volume to the new size (lvresize). Doing it the other way would trash the filesystem when the device was resized.

    - But to increase the size of a volume, you first resize the volume, and then the filesystem. Doing it the other way, you couldn't make the filesystem larger since there was no new space for it to use (yet).

* `resize2fs` is for ext filesystems, not partitions. `resize2fs` should be used first only when you want to shrink the fs: shrink fs first, shrink the partition/LV second. when enlarging a fs, do the reverse - enlarge partition/LV, enlarge fs. lvresize resizes a logical volume (a virtual disk); resize2fs resizes an ext filesystem. Clearly to increase a filessystem, you need to extend space first; if you want to shrink, the other way around. 


* see also `vgchange` and `pvmove`  as discussed here <https://serverfault.com/questions/519172/how-to-change-volumegroup-pe-size>




### Proxmox - Virtualization Orchestration Platform

- Show Notes
  - <https://wiki.opensourceisawesome.com/books/virtualization-virtual-machines/page/install-and-setup-proxmox-virtualization-os>
- Home Page - <https://www.proxmox.com/en/>
