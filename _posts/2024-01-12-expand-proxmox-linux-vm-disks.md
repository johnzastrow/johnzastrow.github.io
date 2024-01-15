---
layout: post
title: Expand Linux VM Disk under Proxmox VE
subtitle: Notes for myself as I need to keep looking this up
gh-badge: [star, fork, follow]
date: '2024-01-12T12:47:41-05:00'
tags: [linux]
comments: true
---

Sources: https://pve.proxmox.com/wiki/Resize_disks , 

I'm writing this down because I do this about every six months and spend a day looking it up and breaking stuff every time. I use LVM and ext4 file system in my VMs.

# Expansion Process

<i>"If you enlarge the hard disk, once you have added the disk plate, your partition table and file system knows nothing about the new size, so you have to act inside the VM to fix it.

If you reduce (shrink) the hard disk, of course removing the last disk plate will probably destroy your file system and remove the data in it! So in this case it is paramount to act in the VM in advance, reducing the file system and the partition size. SystemRescueCD comes very handy for it, just add its iso as cdrom of your VM and set boot priority to CD-ROM.

Shrinking disks is not supported by the PVE API and has to be done manually."</i>

## 1. Resizing guest disk
#### qm command (or use the resize command in the GUI)
You can resize your disks online or offline with command line:

```qm resize <vmid> <disk> <size> ```

example: to add 5G to your virtio0 disk on vmid100:

```qm resize 100 virtio0 +5G```

For virtio disks, Linux should see the new size online without reboot with kernel >= 3.6

## 2. Enlarge the partition(s) in the virtual disk

We will assume you are using LVM on the storage and the VM OS is using ext4 filesystem.


#### Online for Linux Guests
Here we will enlarge a LVM PV partition, but the procedure is the same for every kind of partitions. Note that the partition you want to enlarge should be at the end of the disk. If you want to enlarge a partition which is anywhere on the disk, use the offline method.

Check that the kernel has detected the change of the hard drive size
(here we use VirtIO so the hard drive is named vda)

```bash dmesg | grep vda ```

```
[ 3982.979046] vda: detected capacity change from 34359738368 to 171798691840
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
Warning: Not all of the space available to /dev/vda appears to be used, you can
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
If you did not resize the filesystem in step 2

#### Online for Linux guests with LVM
Enlarge the physical volume to occupy the whole available space in the partition:

```bash pvresize /dev/vda3```

List logical volumes:

```bash lvdisplay```

{: .box-terminal}
<pre>
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

Enlarge the logical volume and the filesystem (the file system can be mounted, works with ext4 and xfs). Replace "{volume group name}" with your specific volume group name:

```bash 
#This command will increase the partition up by 20GB
lvresize --size +20G --resizefs /dev/{volume group name}/root 
#Use all the remaining space on the volume group
lvresize --extents +100%FREE --resizefs /dev/{volume group name}/root
```

Online for Linux guests without LVM
Enlarge the filesystem (in this case root is on vda1)
An ext4 file system may be grown while mounted using the resize2fs command:

``` resize2fs /mount/device size ```

```bash
resize2fs /dev/vda1
```

<!-- [![Example](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/linref1.jpg)](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/linref1.jpg)
*Figure 1. The real data* as shown in QGIS. -->


### Other useful commands and their output

- [x] Read the Markdown guide
- [ ] Review the style guide
- [ ] Stay awesome!



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




```bash
growpart /dev/sda 3
pvresize /dev/sda3
lvextend -l +100%FREE /dev/pve/root
resize2fs /dev/mapper/pve-root
```

**Proxmox - Virtualization Orchestration Platform**
  - Show Notes
      - https://wiki.opensourceisawesome.com/books/virtualization-virtual-machines/page/install-and-setup-proxmox-virtualization-os
  - Home Page - https://www.proxmox.com/en/
 