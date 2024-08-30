source /etc/profile
export PS1="(chroot) ${PS1}"
mkdir /efi
echo "Assuming you have uefi support, if not stop now and modify the script"
sleep 3
# replace with (mount $bootpath /boot)
mount $bootpath /efi
echo " Installing a Gentoo ebuild repository snapshot from the web"
sleep 2
emerge-webrsync
sleep 1
echo "Selecting mirrors"
sleep 1
emerge --ask --verbose --oneshot app-portage/mirrorselect
mirrorselect -i -o >> /etc/portage/make.conf
echo "



"
echo "Updating the Gentoo ebuild repository"
sleep 1
emerge --sync
printf '\033c'
echo "Select Profile



"
eselect profile list
read -p "what profile to use: " profile
eselect profile set $profile
echo "




"
echo "check if selected profile is correct: $profile"
sleep 2
printf '\033c'
echo "Not Adding a binary package host"
sleep 2
echo "



"
emerge --info | grep ^USE
echo "



"
echo "Configure your USE flags in make.conf"
echo "VIDEO_CARDS=your graphics drivers    in your make.conf"
sleep 3
echo "Configure the ACCEPT_LICENSE variable in make.conf"
echo "ACCEPT_LICENSE="*""> /etc/portage/make.conf
sleep 3
nano /etc/portage/make.conf
mkdir /etc/portage/package.license
printf '\033c'
echo "Updating the @world set"
echo "


"
sleep 2
emerge --ask --verbose --update --deep --newuse @world
echo "



"
echo "Configuring timezone"
sleep 2
ls /usr/share/zoneinfo
read -p "Enter your zone name: " zonename
ls /usr/share/zoneinfo/$zonename
read -p "Enter your country: " country
echo $zonename/$country > /etc/timezone
emerge --config sys-libs/timezone-data
nano /etc/locale.gen
printf '\033c'
echo "Generating Locale"
echo "


"
locale-gen
eselect locale list
read -p "select locale: " locale
eselect locale set $locale
env-update && source /etc/profile && export PS1="(chroot) ${PS1}"
printf '\033c'
echo "Installing Kernel"
sleep 2
echo "


"
emerge --ask sys-kernel/linux-firmware sys-apps/pciutils sys-firmware/intel-microcode sys-kernel/gentoo-sources
echo "


"
printf '\033c'
cd /usr/src/linux
eselect kernel list
echo "

"
read -p "select kernel: " kernel
eselect kernel set $kernel
make menuconfig
printf '\033c'
echo "Compiling kernel now....."
sleep 2
make && make modules_install
make install
echo "



"
echo "Edit your fstab"
sleep 3
nano /etc/fstab
read -p "Enter hostname: " hostname
echo $hostname > /etc/hostname
emerge --ask net-misc/dhcpcd net-wireless/wpa_supplicant
rc-update add dhcpcd default
rc-service dhcpcd start
rc-update add wpa_supplicant default
rc-service wpa_supplicant start
echo 'Enter root password'
passwd
emerge --ask --verbose sys-boot/grub
echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf
grub-install /dev/sda
grub-install --target=x86_64-efi --efi-directory=/efi
grub-mkconfig -o /boot/grub/grub.cfg
exit
cd
umount -l /mnt/gentoo/dev{/shm,/pts,}
umount -R /mnt/gentoo
read -p "Installation was complete,reboot? [y/n]" final
if [[$final = y]] then;
   echo "rebooting ...."
   sleep 2
   reboot
fi
