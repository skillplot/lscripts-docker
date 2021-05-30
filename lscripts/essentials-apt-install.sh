#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Install Lscripts utilities and softwares
###----------------------------------------------------------


function essentials-apt-install.main() {
  ##sudo apt -y update
  sudo apt -y install openssh-client openssh-server
  sudo apt -y install dos2unix
  sudo apt -y install tree
  sudo apt -y install chromium-browser
  sudo apt -y install unrar
  sudo apt -y install aptitude
  sudo apt -y install uuid

  ## exif tool
  sudo apt -y install libimage-exiftool-perl

  ## Used in openCV
  sudo apt -y install doxygen doxygen-gui
  sudo apt -y install graphviz

  ## Misc
  sudo apt -y install libexif-dev
  sudo apt -y install ntp
  sudo apt -y install libconfig++-dev
  sudo apt -y install kino

  ## for software builds
  sudo apt -y install cmake-curses-gui

  ## Admin system utils:
  sudo apt -y install htop
  sudo apt -y install apcalc

  ## For gnome Ubuntu >= 17
  sudo apt -y install gnome-tweak-tool

  ## sudo apt install gnome-shell-extension-weather
  ## start gnome-tweaks by
  # gnome-tweaks

  sudo apt -y install dconf-editor

  ## cmd image viewer
  sudo apt -y install feh

  ## openvpn
  sudo apt -y install openvpn

  ## * Enabe "New Document" Option
  ## https://linuxconfig.org/how-to-create-desktop-shortcut-launcher-on-ubuntu-18-04-bionic-beaver-linux
  touch $HOME/Templates/Empty\ Document

  ## https://stackoverflow.com/questions/7106012/download-a-single-folder-or-directory-from-a-github-repo
  sudo apt -y install subversion
  sudo apt -y install libcanberra-gtk-module

  [[ $LINUX_ID == 'Kali' ]] && (
    sudo apt -y install pepperflashplugin-nonfree
    sudo apt -y install libreoffice
    ## PDF viewer
    sudo apt -y install evince
    ## Enable network browser in Thunar File Browser
    sudo apt -y install gvfs-backends gvfs-bin gvfs-fuse
    ## Fix for: _log_.error while loading shared libraries: libgconf-2.so.4: cannot open shared object file: No such file or directory
    sudo apt -y install libgconf-2-4
  )

  sudo apt -y install neofetch
  sudo apt -y install exuberant-ctags

  ## multiplexer
  # sudo apt install byobu
  # sudo apt install screen

  ## web based terminal
  # sudo apt install shellinabox
}

essentials-apt-install.main "$@"
