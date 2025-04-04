#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
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
##
## Some commonly used packages:
###-----------------------------
## texlive-science: Useful for scientific papers.
## texlive-math-extra: For advanced math formatting.
## texlive-bibtex-extra: For bibliographies.
## texlive-publishers: For specific publisher formats.
## texlive-pictures: For drawing with tikz.
#
## Common Useful Package Bundles
###-----------------------------
## texlive-latex-extra: Includes useful LaTeX packages such as caption, multirow, and wrapfig.
## texlive-fonts-recommended: Essential for good font support.
## texlive-fonts-extra: Additional fonts for your LaTeX documents.
## cm-super: auto font expansion, ensure you're using scalable fonts. You can force the use of scalable fonts by installing the cm-super package, which provides scalable versions of the Computer Modern fonts.
#
## LatexMk is a Perl script that automates the process of building LaTeX documents.
## It simplifies the compilation of .tex files into PDF (or other formats) by managing the sequence of required LaTeX runs,
## as well as related tasks like running BibTeX, makeindex, or other tools for generating bibliographies, indices, and glossaries.
##----------------------------------------------------------


function latex-apt-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  sudo apt -y install texlive-latex-recommended texlive texlive-pictures texlive-latex-extra texlive-lang-english
  sudo apt -y install texlive-fonts-recommended texlive-fonts-extra cm-super
  sudo apt -y install texlive-science
  sudo apt -y install texlive-bibtex-extra biber

  ## latexmk - package that automates the process of building LaTeX documents
  sudo apt -y install latexmk

  # sudo apt -y install texlive-full texlive-latex-extra-doc perl-tk

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
  # texlive-latex-extra-doc perl-tk

  ## TeX-LaTeX Editorss
  # source ${LSCRIPTS}/latex-editors-apt-install.sh
}

latex-apt-install.main "$@"
