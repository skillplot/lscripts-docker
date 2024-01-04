#!/bin/bash

## poppler-utils - PDF utilities (based on Poppler)
sudo apt install poppler-utils

## Images from PDF
# pdftoppm -v
# pdftoppm -jpeg -jpegopt quality=100 -r 300 $1 .

## pdfimages -j ${fullfilename} ${outputdir}/

## pdfgrep - search in pdf files for strings matching a regular expression
sudo apt install pdfgrep

## pdfgrep "example" /my/pdf/files/*.pdf


## pdftk - transitional package for pdftk, a tool for manipulating PDF documents
sudo apt install pdftk

## merge or concatenate multiple PDF to single PDF
## pdftk 1-6.pdf 6-10.pdf cat output tut-9-sol.pdf
