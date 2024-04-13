#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## vim
###----------------------------------------------------------


function vim-apt-install.main() {
  ##sudo apt -y update
  ##sudo apt -y remove vim vim-gtk && sudo apt-get -y autoremove
  sudo apt -yqq install vim vim-gtk

  ## TBD: this may receates the file, hence risks loosing existing configurations
  ## sudo sh -c 'echo "set expandtab\nset tabstop=2\nset nu\n" > /etc/vim/vimrc.local'

  # :set tabstop=4
  # :set shiftwidth=4
  # :set expandtab

  # curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  #     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

vim-apt-install.main "$@"