#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## vim plugins
###----------------------------------------------------------


function vim-plug-install.main() {

  [[ ! -d ${HOME}/.vim/autoload ]] && (
    (>&2 echo -e "Downloading vim-plug plugin manager for vim..." )

    curl -fLo ${HOME}/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  ) || (>&2 echo -e "Error in vim-plug installation" )
}

vim-plug-install.main "$@"
