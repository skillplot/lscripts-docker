#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##__doc__='latex.md'
###----------------------------------------------------------
## TeX is a typesetting system. LaTeX is a high-quality typesetting system.
## MiKTeX is implementation of TeX/LaTeX and related programs. 
###----------------------------------------------------------
#
## References:
## * https://www.latex-project.org/
## * https://tug.org/texlive/tlmgr.html
## * https://miktex.org
## * https://itsfoss.com/latex-editors-linux/
## * https://linuxconfig.org/how-to-install-latex-on-ubuntu-18-04-bionic-beaver-linux
##----------------------------------------------------------


function latex-apt-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  sudo apt -y install texlive-latex-recommended texlive texlive-pictures texlive-latex-extra
  sudo apt -y install texlive-fonts-recommended texlive-fonts-extra
  # sudo apt -y install texlive-full

  # texlive-base
  # texlive-latex-recommended
  # texlive
  # texlive-latex-extra
  # texlive-full ## 4GB+
  # ##
  # texlive-publishers
  # texlive-science
  # texlive-pstricks
  # texlive-pictures

  ## TeX-LaTeX Editorss
  # source ${LSCRIPTS}/latex-editors-apt-install.sh
}

latex-apt-install.main "$@"
