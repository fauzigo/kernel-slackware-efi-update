#!/bin/bash

if [ "$EUID" -ne 0 ];
	then echo "Please run as root"
	exit
fi

if [ -z $1 ];
then
	echo "Do you know what you are doing?"
	exit 1
else
	VERSION=$1
fi


cd /boot
unlink /boot/System.map
unlink /boot/config
unlink /boot/initrd.gz
unlink /boot/vmlinuz
unlink /boot/vmlinuz-huge

# This seems unnecessary but good for later in case you want
# to check what "SHOULD" be the kernel loaded at some point

ln -s System.map-huge-${VERSION} System.map
ln -s config-huge-${VERSION} config 
ln -s initrd-${VERSION}.gz initrd.gz
ln -s vmlinuz-huge-${VERSION} vmlinuz-huge 
ln -s vmlinuz-huge-${VERSION} vmlinuz

# let's create a back up of the current grub in case something
# goes south
cp -p /boot/grub/grub.cfg /boot/grub/grub.cfg_$(date -u +"%Y-%m-%d")
$(command -v grub-mkconfig) -o /boot/grub/grub.cfg
