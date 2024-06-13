# for debian:
#echo "Europe/Oslo" > /etc/timezone
#dpkg-reconfigure -f noninteractive tzdata
#sed -i -e "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen
#sed -i -e "s/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/" /etc/locale.gen 
#sed -i -e "s/# nb_NO.UTF-8 UTF-8/nb_NO.UTF-8 UTF-8/" /etc/locale.gen 
#echo "LANG="en_US.UTF-8"">/etc/default/locale
#dpkg-reconfigure --frontend=noninteractive locales
#update-locale LANG=en_US.UTF-8

echo "This file is meant to be run ONCE upon being chrooted in arch. Some information is spit out to do stuff manually, as some stuff is too finnicky to script."

# time and locale
echo "Setting up locale and time"
ln -sf /usr/share/zoneinfo/Europe/Oslo /etc/localtime
hwclock --systohc
sed -i -e "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen
sed -i -e "s/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/" /etc/locale.gen
sed -i -e "s/# nb_NO.UTF-8 UTF-8/nb_NO.UTF-8 UTF-8/" /etc/locale.gen
echo "LANG=\"en_US.UTF-8\"" > /etc/default/locale
locale-gen
echo "Done with locale and time"

# hostname and user
echo "Enter root passwrod: "
passwd -s 
read -p "Enter the hostname: " hostname
echo $hostname > /etc/hostname
pacman -S zsh
read -p "Enter your username: " username
useradd -m -G wheel -s /bin/zsh $username
echo "Enter your user password: " 
passwd -s dotconfig

# network
pacman -S iwd
# somehow dns didnt work last time
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
# dhcp is not enabled by default with iwd
echo "[General]" >> /etc/iwd/main.conf
echo "EnableNetworkConfiguration=true" >> /etc/iwd/main.conf
echo "Next boot iwtctl will be available, connect with iwctl station wlan0 connect SSID"

# pacman
# echo "Enabling multilib repository
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
pacman -Syu

# info section
echo "Now some manual instructions: "

# encrypted disks
pacman -S grub efibootmgr os-prober
echo "Add encrypt flag to hooks in /etc/mkinitcpio.conf (before filesystems), make sure keyboard flag is there"
echo "Run mkinitcpio -p"
echo "Add the following line to /etc/default/grub (replace LUKSUUID with the actual luks partition)"
echo "cryptdevice=UUID={LUKSUUID}:cryptroot root=/dev/mapper/cryptroot"
echo "Uncomment GRUB_ENABLE_CRYPTODISK=y in /etc/default/grub"
echo "Run grub-install --target=x86_64-efi --efi-directory=/boot"
echo "grub-mkconfig -o /boot/grub/grub.cfg"

# ssh keys
echo "chown -R $username:$username dotfiles/_private/.ssh/"
echo "chmod 700 dotfiles/_private/.ssh"
echo "chmod 644 dotfiles/_private/.ssh/dotconfig404.pub"
echo "chmod 600 dotfiles/_private/.ssh/dotconfig404"
