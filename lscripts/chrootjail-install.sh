#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## chrootjail
###----------------------------------------------------------
#
## References:
## * https://www.simplified.guide/ubuntu/build-chroot-environment
###----------------------------------------------------------


## Install debootstrap using apt.
sudo apt -y install debootstrap

jaildir="logs/chroot-ubuntu"
## Create a chroot folder
mkdir -p ${jaildir}

## Create a base Ubuntu system using debootstrap on the newly-created folder
## Change focal to any Ubuntu release code name that's still supported. List of Ubuntu releases
## https://wiki.ubuntu.com/Releases
# sudo debootstrap --variant=buildd focal ${jaildir}
sudo debootstrap --variant=buildd Bionic ${jaildir}


## Mount proc, sys and dev filesystem on to the base system.
sudo mount -t proc /proc ${jaildir}/proc
sudo mount --rbind /sys ${jaildir}/sys
sudo mount --rbind /dev ${jaildir}/dev

## chroot to the folder 
sudo chroot ${jaildir} /bin/bash

## Use the chroot environment as required.
# ls

## Unmount the mounted proc, sys and dev filesystem once exiting the chroot environment.
# sudo umount ${jaildir}/proc ${jaildir}/sys ${jaildir}/dev

## Remove the chroot folder if necessary.

