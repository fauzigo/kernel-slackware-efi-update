# kernel-slackware-efi-update
kernel update script for slackware 

## 1. QuickStart
```
git clone git@github.com:fauzigo/kernel-slackware-efi-update.git

```

## Table of contents

- [1. QuickStart](#1-quickstart)
- [2. Overview](#2-overview)
  - [2.1 Get it and compile it](#21-get-it-and-compile-it)
  - [2.2 Swiitch Kernel](#22-switch-kernel)
- [3. Usage](#3-usage)


## 2. Overview 

### 2.1 Get it and compile it

kernelCompiler.sh would download and compile the source, it may require some manual intervention if the new kernel has new features that your current kernel doesn't, you'll be promped as you normally would if you compile the kernel manually following this [Documentation](https://docs.slackware.com/howtos:slackware_admin:kernelbuilding). I use huge kernels, therefore I name them that way, if you use different one youmay want to rename the var. The scrip would zcat what's in /proc/config.gz into the working directory. I'm assuming that changes/addition between MINOR versions are not as much as to make this script cumbersome torun.

Also my computer uses EFI, so no need to run lilo everytime. for no efi computers, this script would need some love if you want to make it work in one run.

This script shouldn't screw up any active slackware installation, but it might.

Common sense if you use this. It worth noting that ad the end, mkinitrd is ran, change this line accordingly *IMPORTANT*


### 2.2 switch 

switchKernel.sh would make a switch between current kernel and the version you tell it to. Again, I use efi, which makes thing super simpler and easier.


## 3. Usage

```
kernelCompiler.sh 4.15.7
switchKernel.sh 4.15.7
```

