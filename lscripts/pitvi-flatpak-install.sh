#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## pitivi - video editor
###----------------------------------------------------------
#
## References:
## * http://developer.pitivi.org/Install_with_flatpak.html?gi-language=undefined#getting-flatpak
###----------------------------------------------------------


function pitivi-flatpak-install.main() {
  # local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  # source ${LSCRIPTS}/lscripts.config.sh

  #source ${LSCRIPTS}/flatpak.install.sh

  flatpak install --user https://flathub.org/repo/appstream/org.pitivi.Pitivi.flatpakref

  ## run pitvi
  #flatpak run org.pitivi.Pitivi//stable

  ## updating
  #flatpak --user update org.pitivi.Pitivi

  ## uninstalling
  #flatpak --user uninstall org.pitivi.Pitivi stable
}

pitivi-flatpak-install.main "$@"
