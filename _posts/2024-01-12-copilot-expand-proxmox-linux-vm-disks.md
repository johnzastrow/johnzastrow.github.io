---
layout: post
title: Expand Linux VM Disk under Proxmox VE, coauthored with GitHub Copilot
subtitle: Step-by-step guide for expanding disk space in Linux VMs
gh-badge: [star, fork, follow]
date: '2024-01-12T12:47:41-05:00'
tags: [linux]
comments: true
---
Updated: 12-Dec-2024

Sources:  
**1** <https://pve.proxmox.com/wiki/Resize_disks>  
**2** <https://packetpushers.net/blog/ubuntu-extend-your-default-lvm-space/>

## 1. Introduction

Expanding disk space in a Linux VM under Proxmox VE is a common task, especially as storage needs grow over time. This guide walks through the process of safely increasing disk size, updating partitions, and resizing filesystems, with a focus on LVM and ext4 setups.

## 2. Discovery: Why and When to Expand

You might want to expand your VM disk if:
- Your root filesystem is running out of space (`df -h` shows high usage).
- You need more storage for applications or data.
- The installer left unused space on your disk or volume group.

Before making changes, check your current disk, partition, and volume group status.

## 3. Documenting Current State

### Check Disk and Partition Layout

```bash
fdisk -l
lsblk
```

Sample output:
```
NAME                      MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
vda                       252:0    0    67G  0 disk
├─vda1                    252:1    0     1M  0 part
├─vda2                    252:2    0     1G  0 part /boot
└─vda3                    252:3    0    66G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0    66G  0 lvm  /
```

### Check Filesystem Usage

```bash
df -h
```

### Check LVM Volume Group and Logical Volume

```bash
vgdisplay
lvdisplay
```

Look for free space in your VG and current LV size.

## 4. Completing the Changes

### Step 1: Expand the Virtual Disk in Proxmox

Use the GUI or CLI:

```bash
qm resize <vmid> <disk> +<size>
# Example: qm resize 100 virtio0 +5G
```

### Step 2: Rescan Disk and Update Partition Table

Inside the VM, rescan the disk:

```bash
dmesg | grep vda
# Or for /dev/sda:
echo 1 > /sys/class/block/sda/device/rescan
```

Use `cfdisk` or `parted` to resize the partition:

#### With EFI (GPT):

```bash
parted /dev/vda
(parted) print
(parted) resizepart 3 100%
(parted) quit
```

#### Without EFI (MBR):

```bash
parted /dev/vda
(parted) resizepart 2 100%
(parted) resizepart 3 100%
(parted) quit
```

### Step 3: Resize LVM Physical Volume

```bash
pvresize /dev/vda3
```

### Step 4: Extend Logical Volume

Use all free space:

```bash
lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
```
Or add a specific size:

```bash
lvresize --size +20G --resizefs /dev/ubuntu-vg/ubuntu-lv
```

### Step 5: Resize the Filesystem

For ext4:

```bash
resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
```

## 5. Documenting the Final State

Re-run the following to confirm changes:

```bash
df -h
lvdisplay
vgdisplay
fdisk -l
lsblk
```

Your root filesystem should now reflect the expanded space.

## Useful Commands Reference

```bash
growpart /dev/sda 3
pvresize /dev/sda3
lvextend -l +100%FREE /dev/pve/root
resize2fs /dev/mapper/pve-root
```

## Notes

- Always back up important data before resizing disks or partitions.
- Shrinking disks is risky and not supported by the PVE API; use SystemRescueCD if needed.
- For more details, see the [Proxmox Wiki](https://pve.proxmox.com/wiki/Resize_disks).

---

*This workflow ensures you safely expand your VM disk, update partitions, and grow your filesystem, with checks before and after each
