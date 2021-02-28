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

if [ -z "$2" ]
  then
    echo "Missing name of volume group"
    exit 1
fi

DISK="/dev/$1"

#create PV
sudo pvcreate $DISK

# create VG
sudo vgcreate $2 $DISK

# create LVM
sudo lvcreate -l 100%FREE -n $2 $2

# format lvm
sudo mkfs.ext4 /dev/$2/$2


sudo mkdir -p /mnt/$2

# mount lvm
sudo mount /dev/$2/$2 /mnt/$2


echo "All Done"


#/var/lib/rancher/k3s

#./setup-disks.sh sdb rancher


# sudo blkid
#    # Copy the uuid for the disk and update it in the /etc/fstab
#    # UUID=7ae0f736-6722-4c5a-a2a7-e9bc4a4dd95a /mnt/rancher ext4 defaults 0 0
#    sudo vi /etc/fstab

#sudo mkdir -p /var/lib/rancher/

#sudo ln -s /mnt/rancher/ /var/lib/

#sudo rm /var/lib/rancher/
