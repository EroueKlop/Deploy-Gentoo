echo "Gentooooooo"
read -p "Your screen will be cleared, continue? [y/n]" answer
if [[ $answer = y ]] ; then
  echo "Bye bye tux"
  sleep 2
  printf '\033c'
fi


echo "Configuring Network


"
ip addr
read -p "


Enter the name of your interface: " interface
echo "$interface is your selected interface "
read -p "proceed ?  "
touch wpa_supplicant-$interface.conf
echo "ctrl_interface=/run/wpa_supplicant
update_config=1" >> wpa_supplicant-$interface.conf
read -p "Enter you wifi name: " wifi
read -p "Enter your password: " pass
wpa_passphrase $wifi $pass >> wpa_supplicant-$interface.conf
wpa_supplicant -B -i $interface -c wpa_supplicant-$interface.conf
printf '\033c'
echo "Configuring Disk


"
lsblk
read -p "Choose your disk(enter the whole path): " diskpath
cgdisk $diskpath
printf '\033c'
lsblk
echo "


"
read -p "Enter the boot partition: " bootpath
echo "Formatting boot partiton $bootpath"
mkfs.fat -F32 $bootpath
echo "


"
lsblk
read -p "Enter the swap partition: " swappath
echo "Formatting swap partiton $swappath"
mkswap $swappath
swapon $swappath
echo "


"
lsblk
read -p "Enter the root partition: " rootpath
echo "Formatting swap partiton $rootpath"
mkfs.ext4 $rootpath
echo "


"
echo "Mounting Partitions"
mkdir --parents /mnt/gentoo
mkdir --parents /mnt/gentoo/efi
mount $rootpath /mnt/gentoo
cd /mnt/gentoo
echo "


"
echo "Setting date and time"
chronyd -q
echo "Check if date if correct if not stop and then continue"
date
sleep 4
printf '\033c'
echo "Download required tar ball"
sleep 3
links https://www.gentoo.org/downloads/
echo "




"
echo "Extracting tarball"
sleep 2
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner
echo "Extraction complete"
sleep 2
printf '\033c'
echo "Configure your [make.conf]"
sleep 3
nano /mnt/gentoo/etc/portage/make.conf
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/
mount --types proc /proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev
mount --bind /run /mnt/gentoo/run
mount --make-slave /mnt/gentoo/run
printf '\033c'
echo "Chrooting Now"
sleep 2
mv ./deploy-2.sh /mnt/gentoo
printf '\033c'
printf 'Now execute deploy-2.sh'
sleep 1
chroot /mnt/gentoo /bin/bash
