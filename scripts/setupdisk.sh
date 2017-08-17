#!/usr/bin/env bash

# Format Disk
mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb
mkdir -p /mnt/disks/db

# Mount disk into directory
mount -o discard,defaults /dev/sdb /mnt/disks/db
chmod a+rwx /mnt/disks/db

# Re-mount on reboot
echo UUID=`sudo blkid -s UUID -o value /dev/sdb` /mnt/disks/db ext4 discard,defaults,nofail 0 2 | sudo tee -a /etc/fstab

# Create persistent directories for ArangoDB to store data and apps
mkdir -p /mnt/disks/db/data
chmod a+rwx /mnt/disks/db/data