#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Credit:
## * https://unix.stackexchange.com/a/378638
## * https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html#index-shopt
###----------------------------------------------------------

## This builtin allows you to change additional shell optional behavior.
shopt -s direxpand


sudo apt install acpi
acpi -b

sudo apt install upower
upower --version
## To identify the battery identifier on your system, you can use the upower command along with the --enumerate option. Here's how you can do it:
upower --enumerate

## Once installed, you can use the following command to display battery information, including the percentage of charge remaining:
upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "state|percentage"
