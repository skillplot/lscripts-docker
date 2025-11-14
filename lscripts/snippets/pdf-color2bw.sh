#!/bin/bash

## Copyright (c) 2025 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------


gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 \
  -dProcessColorModel=/DeviceGray \
  -dColorConversionStrategy=/Gray \
  -dNOPAUSE -dBATCH \
  -sOutputFile=output_bw.pdf $1
