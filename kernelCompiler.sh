#!/bin/bash


if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

if [ ! -z $1 ];
then
	VERSION=$1
else
	echo "Umm, Do you know what you are doing?"
	exit 1
fi


if [ -d /usr/src/linux-${VERSION} ];
then
	echo "It seems like the destination folder already exist, be careful if you want to download and compile something you already have"
	exit 1
fi

MAKE=$(command -v make) 
CP=$(command -v cp)
WGET=$(command -v wget)
TAR=$(command -v tar)
CURL=$(command -v curl)
ZCAT=$(command -v zcat)

DESTINATION="/tmp/linux-${VERSION}.tar.xz"

MAYOR=$(echo ${VERSION} |cut -d. -f1)

# Perhaps there is a better way to get the tar, but as for now let's use this
URL="https://cdn.kernel.org/pub/linux/kernel/v${MAYOR}.x/linux-${VERSION}.tar.xz"
echo ${URL}
#     https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.0.4.tar.xz


#echo "$CURL -O ${DESTINATION} $URL"
#$CURL $URL --output ${DESTINATION} 
$WGET -O ${DESTINATION} $URL
$TAR xvf ${DESTINATION} -C /usr/src


cd /usr/src/linux-${VERSION}

#exit
$ZCAT /proc/config.gz > .config

yes '' |$MAKE oldconfig

$MAKE bzImage modules
$MAKE modules_install
$CP arch/x86/boot/bzImage /boot/vmlinuz-huge-${VERSION}
$CP System.map /boot/System.map-huge-${VERSION}
$CP .config /boot/config-huge-${VERSION}

/sbin/mkinitrd -c -k ${VERSION} -f ext4 -r luksnvme0n1p3 -m ext4 -C /dev/nvme0n1p3 -u -o /boot/initrd-${VERSION}.gz -h /dev/nvme0n1p4

$CP /boot/initrd-${VERSION}.gz /boot/efi/EFI/Slackware
$CP /boot/vmlinuz-huge-${VERSION} /boot/efi/EFI/Slackware

