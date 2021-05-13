#!/bin/bash

echo "this script will not change disk partition size, add or delete so we suggest to do partition manually before running this script"
sleep 5

echo "testing your internet connection"
ping -c 1 google.com >/dev/null
if [[ $? -eq 0 ]]
then
    echo 'connected to internet'
else
    echo 'not connected to internet'
    echo 'if you have wifi try using "man iwctl"'
    exit 0
fi

echo "IF YOU SEE ANY OTHER PROCESS THAT YOU NOT WANT WE SUGGEST YOU TO RESTART THIS SCRIPT RIGHT AWAY" > finalview
echo "#!/bin/bash" > finalscript
echo "make sure your partitions ready"
echo "mounting partitions in /mnt"
lsblk
echo "enter EFI partition name like sda1 or sda2 or lvme(commonly this partition is in size of 200MB to 1GB and found in starting of disk)"
read efi
echo "enter root partition name just like before like sda1 or sda2 or lvme"
read root
echo "enter filesystem type for root partition eg. ext4, btrfs 'if not sure what to use just use ext4' WARNING:All data of this partition will be destroyed"
read fsroot


echo "> your root partition (/dev/$root) will be formated with $fsroot file system WARNING:All data inside this partition will be destroyed" >> finalview
echo "mkfs.$fsroot /dev/$root
mount /dev/$root /mnt" >> finalscript
echo "> your EFI partition (/dev/$efi) will be mounted at /boot/efi and will not be formated" >> finalview
echo "mkdir -p /mnt/boot/efi
mount /dev/$efi /mnt/boot/efi" >> finalscript

echo "enter home partition name (if not have dedicated home partiton just leave it empty)"
lsblk
read home
if [[ -n $home ]]
then
    echo "Want to format your root partition? 'Yes OR No' Recommandation:NO"
    read fhome
    if [[ $fhome = yes ]] || [[ $fhome = Yes ]] || [[ $fhome = Y ]] || [[ $fhome = y ]]
    then
        echo "enter filesystem type for home partition eg. ext4, btrfs 'if not sure what to use just use ext4' WARNING:All data of this partition will be destroyed"
        read fshome
        echo "> your home partition (/dev/$home) will be formated with $fshome and will be mounted at /home" >> finalview
        echo "mkfs.$fshome /dev/$home" >> finalscript
    else
        echo "> your home partition (/dev/$home) will be mounted at /home" >> finalview
    fi
    echo "mkdir -p /mnt/home
mount /dev/$home /mnt/home" >> finalscript
fi
echo "> installing base(base for archlinux), linux-firmware(firmware for linux), linux(kernel), nano(for text editor)" >> finalview
echo "pacstrap /mnt base linux-firmware linux nano" >> finalscript
echo "> at final fstab file will be placed at /etc/fstab for automatic mount root and home at system startup" >> finalview
echo "genfstab -U /mnt >> /mnt/etc/fstab" >> finalscript
echo "press any key to start the processes" >> finalview
echo 'echo "If you not see any error your archlinux root must be created successfully"' >> finalscript
clear
cat finalview
read stop
bash finalscript

