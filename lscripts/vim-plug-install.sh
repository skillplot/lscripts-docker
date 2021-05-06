#!/bin/bash

##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Vim plugins
###----------------------------------------------------------


[[ ! -d ${HOME}/.vim/autoload ]] && (
  (>&2 echo -e "Downloading vim-plug plugin manager for vim..." )

  curl -fLo ${HOME}/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
) || (>&2 echo -e "Error in vim-plug installation" )
