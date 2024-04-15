#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## tmux plugin manager
###----------------------------------------------------------


function tmux-plug-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )

  [[ ! -d ${HOME}/.tmux/plugins ]] && (
    (>&2 echo -e "Downloading tpm plugin manager for tmux..." )

    curl -fLo ~/.tmux/plugins/tpm/tpm --create-dirs \
        https://raw.githubusercontent.com/tmux-plugins/tpm/master/tpm

    cp -f ${LSCRIPTS}/core/config/dotfiles/.tmux.conf $HOME/.

  ) || (>&2 echo -e "Error in tpm installation" )
}

tmux-plug-install.main "$@"
