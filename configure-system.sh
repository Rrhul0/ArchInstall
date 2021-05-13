echo "Just sit and see is any error"
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc
sed -i 's/#en_US.UTF-8/en_US.UTF-8/g' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "ArchLinux" > /etc/hostname
echo "127.0.0.1	localhost
::1		localhost
127.0.1.1	ArchLinux.localdomain	ArchLinux" > /etc/hosts
echo "set root password (when type you cant see it in terminal)"
passwd
echo "Brand of our cpu 1)Intel 2)amd"
echo "press 1 or 2 accordingly"
read cpu
if [[ $cpu -eq 1 ]]
then
    pacman -Syu grub intel-ucode --noconfirm
elif [[ $cpu -eq 2 ]]
then
    pacman -Syu grub amd-ucode --noconfirm
else
    pacman -Syu grub intel-ucode amd-ucode --noconfirm
fi
grub-install --target=x86_64-efi --efi-directory=/boot/efi --boot-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg

echo "Which DE you want to install (gnome, kde, xfce)"
read de
if [[ $de == gnome ]]
then 
    pacman -Syu gnome sudo bluez --noconfirm
    systemctl enable gdm --force
elif [[ $de == kde ]]
then
    pacman -Syu xorg plasma plasma-wayland-session kde-applications sudo bluez --noconfirm
    systemctl enable sddm --force
else
    pacman -Syu $de sudo blues --noconfirm
    echo "dont forgot to enable respective display manager"
fi
systemctl enable NetworkManager --force
systemctl enable bluetooth --force

echo "Adding user to ArchLinux"
echo "Enter username without space"
read user
useradd -m $user
echo "Enter password for user $user"
passwd $user
echo "you need to manually edit sudoer for give user admin permissions to run sudo"
echo 'run "EDITOR=nano visudo" and user specification should be look like this'
echo "##
## User privilege specification
##
root ALL=(ALL) ALL
$user ALL=(ALL) ALL
## Uncomment to allow members of group wheel to execute any command
%wheel ALL=(ALL) ALL
"
exit 0
