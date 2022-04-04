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

ln -s System.map-huge-${VERSION} System.map
ln -s config-huge-${VERSION} config 
ln -s initrd-${VERSION}.gz initrd.gz
ln -s vmlinuz-huge-${VERSION} vmlinuz-huge 
ln -s vmlinuz-huge-${VERSION} vmlinuz

#cd /boot/efi/EFI/Slackware
#
#if [ -z $2 ];
#then
#	old=$(uname -r)
#else
#	old=$2
#fi
#
#mv initrd.gz initrd-${old}.gz
#mv vmlinuz vmlinuz-huge-${old}
#
#mv initrd-${VERSION}.gz initrd.gz
#mv vmlinuz-huge-${VERSION} vmlinuz

$(command -v grub-mkconfig) -o /boot/grub/grub.cfg
