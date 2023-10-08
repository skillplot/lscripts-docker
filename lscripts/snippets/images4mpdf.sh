#!/bin/bash

# pdfimages -all in.pdf /tmp/out
# pdfimages -j in.pdf /tmp/out
# poppler-utils


pdftoppm -v
pdftoppm -jpeg -jpegopt quality=100 -r 300 $1 .
