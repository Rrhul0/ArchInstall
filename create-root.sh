#!/bin/bash

echo "this script will not change disk partition size, add or delete so we suggest to do partition manually before running this script"
sleep 5

echo "testing your internet connection"
ping -c 1 google.com
if [[ $? -eq 1 ]]
then
    echo 'connected to internet'
else
    echo 'not connected to internet'
    echo 'if you have wifi try using "man iwctl"'
fi

echo "make sure your partitions ready"
echo "mounting partitions in /mnt"
lsblk
echo "enter EFI partition name like sda1 or sda2 or lvme(commonly this partition is in size of 200MB to 1GB and found in starting of disk)"
read efi
echo "enter root partition name just like before like sda1 or sda2 or lvme"
read root
echo "enter filesystem type for root partition eg. ext4, btrfs 'if not sure what to use just use ext4' WARNING:All data of this partition will be destroyed"
read fsroot
mkfs.$fsroot /dev/$root
mount /dev/$root /mnt
mkdir -p /mnt/boot/efi
mount /dev/$efi /mnt/boot/efi
echo "enter home partition name (if not have dedicated home partiton just leave it empty)"
lsblk
read home
if [[ $home == sd* ]] | [[ $home == lvme* ]]
then
    echo "enter filesystem type for home partition eg. ext4, btrfs 'if not sure what to use just use ext4' WARNING:All data of this partition will be destroyed"
    read fshome
    mkfs.$fshome /dev/$home
    mkdir -p /mnt/home
    mount /dev/$home /mnt/home
 fi
pacstrap /mnt base linux-firmware linux nano
genfstab -U /mnt >> /mnt/etc/fstab
echo "If you not see any error Then your ArchLinux Root must be successfully created"

