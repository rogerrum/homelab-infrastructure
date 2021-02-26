#!/usr/bin/env bash

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit 1
fi

if [ -z "$1" ]
  then
    echo "Missing DISK NAME eg (sdb1, sdc1, sdc2)"
    exit 1
fi

DISK="/dev/$1"

#create PV
sudo pvcreate $DISK

# create VG
sudo vgcreate data $DISK

# create LVM
sudo lvcreate -l 100%FREE -n data data

# format lvm
sudo mkfs.ext4 /dev/data/data


sudo mkdir -p /mnt/data

# mount lvm
sudo mount /dev/data/data /mnt/data


echo "All Done"
