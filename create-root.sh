#!/bin/bash

echo "this script will not change disk partition size, add or delete so we suggest to do partition manually before running this script"
sleep 5

echo "testing your internet connection"
if [[ $(ping -w 2 google.com | grep -c transmitted) -eq 1 ]]
then
    echo 'connected to internet'
else
    echo 'not connected to internet'
    echo 'if you have wifi try using "man iwctl"'
fi

echo "make sure your partitions ready"
echo "mounting partitions in /mnt"
lsblk
echo "enter EFI partition name like sda1 or sda2 (commonly this partition is in size of 200MB to 1GB and found in starting of disk)"
read efi
echo "enter root partition name just like before like sda1 or sda2"
read root
echo "enter filesystem type for root partition eg. ext4, btrfs (default ext4) WARNING:All data of this partition will be destroyed"
read fs-root
echo "enter home partition name (if not have dedicated home partiton just leave it empty)"
read home
if [[ $home == ]]
echo "we will use"
