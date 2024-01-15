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

```bash 
fdisk -l /dev/vda | grep ^/dev
GPT PMBR size mismatch (67108863 != 335544319) will be corrected by w(rite).
/dev/vda1      34     2047     2014 1007K BIOS boot
/dev/vda2    2048   262143   260096  127M EFI System
/dev/vda3  262144 67108830 66846687 31.9G Linux LVM
```

Resize the partition 3 (LVM PV) to occupy the whole remaining space of the hard drive)

```bash
parted /dev/vda
(parted) print
Warning: Not all of the space available to /dev/vda appears to be used, you can
fix the GPT to use all of the space (an extra 268435456 blocks) or continue
with the current setting? 
Fix/Ignore? F 
(parted) resizepart 3 100%
(parted) quit
```
#### Example without EFI
Another example without EFI using parted:

```bash
parted /dev/vda
(parted) print
Number  Start   End     Size    Type      File system  Flags
1       1049kB  538MB   537MB   primary   fat32        boot
2       539MB   21.5GB  20.9GB  extended
3       539MB   21.5GB  20.9GB  logical                lvm
```
Resize the 2nd partition, first (extended):

```bash
(parted) resizepart 2 100%
(parted) resizepart 3 100%
```

Check the new partition table

```bash
(parted) print
Number  Start   End     Size    Type      File system  Flags
1       1049kB  538MB   537MB   primary   fat32        boot
2       539MB   26.8GB  26.3GB  extended
3       539MB   26.8GB  26.3GB  logical                lvm
(parted) quit
```



<!-- [![Example](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/linref1.jpg)](https://raw.githubusercontent.com/johnzastrow/johnzastrow.github.io/master/assets/uploads/linref1.jpg)
*Figure 1. The real data* as shown in QGIS. -->


### Other useful commands and their output

```bash fdisk -l ```

```bash lsblk```


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
 