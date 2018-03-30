#!/bin/bash


if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

if [ ! -z $1 ];
then
	VERSION=$1
else
	echo "Umm, do you what you are doing?"
	exit 1
fi

MAKE=$(which make) 
CP=$(which cp)
WGET=$(which wget)
TAR=$(which tar)

DESTINATION="/tmp/linux-${VERSION}.tar.xz"


# Perhaps there is a better way to get the tar, but as for now let's use this
URL="https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-${VERSION}.tar.xz"

$WGET -O ${DESTINATION} $URL
$TAR xvf ${DESTINATION} -C /usr/src


cd /usr/src/linux-${VERSION}

#exit
$(which zcat) /proc/config.gz > .config

$MAKE oldconfig

$MAKE bzImage modules
$MAKE modules_install
$CP arch/x86/boot/bzImage /boot/vmlinuz-huge-${VERSION}
$CP System.map /boot/System.map-huge-${VERSION}
$CP .config /boot/config-huge-${VERSION}

/sbin/mkinitrd -c -k ${VERSION} -f ext4 -r luksnvme0n1p4 -m ext4 -C /dev/nvme0n1p4 -u -o /boot/initrd-${VERSION}.gz -h /dev/nvme0n1p5

$CP /boot/initrd-${VERSION}.gz /boot/efi/EFI/Slackware
$CP /boot/vmlinuz-huge-${VERSION} /boot/efi/EFI/Slackware

