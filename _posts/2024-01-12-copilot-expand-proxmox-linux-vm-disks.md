---
layout: post
title: Expand Linux VM Disk under Proxmox VE
subtitle: Step-by-step guide for expanding disk space in Linux VMs
date: '2024-01-12T12:47:41-05:00'
tags: [linux, proxmox]
---

Updated: 30-Jan-2025

Sources:
- <https://pve.proxmox.com/wiki/Resize_disks>
- <https://packetpushers.net/blog/ubuntu-extend-your-default-lvm-space/>

## Overview

This guide covers expanding disk space for Linux VMs running on Proxmox VE with ext4 filesystems. The process differs depending on whether your guest uses LVM (common with Ubuntu Server installs) or partitions directly.

Check your setup with `lsblk`. If you see `lvm` in the TYPE column, follow the **With LVM** section. Otherwise, follow the **Without LVM** section.

## Step 1: Expand the Virtual Disk in Proxmox

On the Proxmox host, expand the VM's disk:

```bash
qm resize <vmid> <disk> +<size>
# Example: add 10GB to VM 100's first virtio disk
qm resize 100 virtio0 +10G
```

Or use the GUI: VM → Hardware → Hard Disk → Resize.

## Step 2: Rescan the Disk Inside the Guest

The guest OS needs to detect the new disk size:

```bash
# For virtio disks (vda)
echo 1 > /sys/class/block/vda/device/rescan

# For SCSI disks (sda)
echo 1 > /sys/class/block/sda/device/rescan
```

Verify the new size:

```bash
lsblk
```

## With LVM (Ubuntu Server Default)

Typical layout:

```
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
vda                       252:0    0   77G  0 disk
├─vda1                    252:1    0    1M  0 part
├─vda2                    252:2    0    2G  0 part /boot
└─vda3                    252:3    0   75G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0   65G  0 lvm  /
```

### Step 3a: Expand the Partition

Resize the partition containing the LVM physical volume (usually partition 3):

```bash
parted /dev/vda resizepart 3 100%
```

Or interactively:

```bash
parted /dev/vda
(parted) print        # confirm partition numbers
(parted) resizepart 3 100%
(parted) quit
```

### Step 4a: Resize the LVM Physical Volume

```bash
pvresize /dev/vda3
```

Verify free space appeared in the volume group:

```bash
vgdisplay
```

### Step 5a: Extend the Logical Volume

Use all available space:

```bash
lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
```

Or add a specific amount:

```bash
lvextend -L +10G /dev/ubuntu-vg/ubuntu-lv
```

### Step 6a: Resize the Filesystem

```bash
resize2fs /dev/ubuntu-vg/ubuntu-lv
```

## Without LVM (Direct Partition)

Typical layout:

```
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
vda    252:0    0   50G  0 disk
├─vda1 252:1    0  512M  0 part /boot/efi
└─vda2 252:2    0 49.5G  0 part /
```

### Step 3b: Expand the Partition

Use `growpart` (from cloud-guest-utils) to expand the root partition:

```bash
growpart /dev/vda 2
```

Or with parted:

```bash
parted /dev/vda resizepart 2 100%
```

### Step 4b: Resize the Filesystem

```bash
resize2fs /dev/vda2
```

## Verify the Changes

```bash
df -h
lsblk
```

Your root filesystem should now show the expanded size.

## Notes

- Always back up important data before resizing.
- Shrinking disks is risky and not covered here.
- A reboot may be required if the kernel doesn't recognize changes.
