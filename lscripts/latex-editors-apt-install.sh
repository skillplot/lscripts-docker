#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##__doc__='latex.md'
###----------------------------------------------------------
## TeX-LaTeX Editors
###----------------------------------------------------------
#
## References:
## * https://itsfoss.com/latex-editors-linux/
##----------------------------------------------------------


function latex-editors-apt-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  ## Todo:: check latex is installed or not, otherwise install latex first
  sudo apt -y install texmaker
  sudo apt -y install lyx
  sudo apt -y install texstudio
  sudo apt -y install kile
  sudo apt -y install gummi
  sudo apt -y install gedit-latex-plugin
  sudo apt -y install texworks texworks-scripting-python texworks-help-en
  #
  ## latexila - LaTeX editor designed for the GNOME desktop
  sudo apt -y install latexila
  #
  ### latex drawing
  ## latexdraw - vector drawing program for LaTeX using PSTricks; requires java
  sudo apt -y install latexdraw
  sudo apt -y install xfig
  #
  ### utilities
  sudo apt -y install latexdiff latex2html klatexformula gnuhtml2latex preview-latex-style
  #
  # sudo apt -y install latexdiff
  # sudo apt -y install latex2html
  # ## klatexformula - GUI to easily get an image from a LaTeX formula or equation
  # sudo apt -y install klatexformula
  # ## gnuhtml2latex - Convert HTML files to LaTeX
  # sudo apt -y install gnuhtml2latex
  # ## preview-latex-style - extraction of elements from LaTeX documents as graphics
  # sudo apt -y install preview-latex-style

  ## gedit-latex-plugin - gedit plugin for composing and compiling LaTeX documents
  ## geany-plugin-latex - improved LaTeX support plugin for Geany
  ## fcitx-table-latex - Flexible Input Method Framework - LaTeX table
  ## doxygen-latex - Documentation system for C, C++, Java, Python and other languages
  ## csv2latex - command-line CSV to LaTeX file converter
  ## asciidoc-dblatex - Asciidoc package including dblatex dependencies
  ## texlive-latex-base - TeX Live: LaTeX fundamental packages
  ## texlive-latex-base-doc - TeX Live: Documentation files for texlive-latex-base
  ## texlive-latex-recommended - TeX Live: LaTeX recommended packages
  ## texlive-latex-recommended-doc - TeX Live: Documentation files for texlive-latex-recommended
}

latex-editors-apt-install.main "$@"
