# NFS Config

- Install NFS server
    ```shell
    sudo apt-get install nfs-common nfs-kernel-server
    ```

- Setup any extra disks
    ```shell
    wget https://raw.githubusercontent.com/rogerrum/homelab-infrastructure/main/nfs-conf/01-setup-disks.sh
    chmod +x 01-setup-disks.sh
    ./01-setup-disks.sh <disk>
    ```
  
- Auto Mount the disk
    ```shell
    sudo blkid
    # Copy the uuid for the disk and update it in the /etc/fstab
    # UUID=d9b88cac-3370-45ca-ac13-ca31450367be /mnt/data ext4 defaults 0 0
    sudo vi /etc/fstab
    ```

- Setup NFS mount
    ```shell
    # Setup NFS mount point
    sudo mkdir -p /export/dell-nfs
    sudo chmod +777 - R /export
    sudo chmod +777 -R /export/dell-nfs
  
    # Add NFS mount - copy the next line to /etc/fstab
    /mnt/data    /export/dell-nfs   none    bind  0  0
    
    sudo vi /etc/fstab
  
    # add following to /etc/exports
    /export          192.168.1.0/24(rw,fsid=0,insecure,no_subtree_check,async)
    /export/dell-nfs 192.168.1.0/24(rw,nohide,insecure,no_subtree_check,async)
    /export          192.168.50.0/24(rw,fsid=0,insecure,no_subtree_check,async)
    /export/dell-nfs 192.168.50.0/24(rw,nohide,insecure,no_subtree_check,async)
  
    sudo vi /etc/exports
    ```

- Restart NSF Server
    ```shell
    sudo systemctl restart nfs-server.service
    ```
  
- Testing
    ```shell
    echo "Can you see this?" >> /export/dell-nfs/nfs_test
  
    # mount on other nodes
    mount -t nfs -o proto=tcp,port=2049 192.168.50.107:/export/dell-nfs /dell-nfs
  
   ```

## Samba Share

- Install packages
    ```shell
    sudo apt install samba samba-common-bin smbclient cifs-utils
    ```

- Add Samba mapping
    ```shell

    # Edit /etc/samba/smb.conf and add the following to end of the file
    sudo vi /etc/samba/smb.conf
  
    [share]
      path = /export/dell-nfs
      read only = no
      public = yes
      writable = yes


    ```
