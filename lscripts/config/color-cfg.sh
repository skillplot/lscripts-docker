#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## color code configurations
###----------------------------------------------------------


local nocolor='\e[0m'    # text reset

###-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## regular                bold                      underline                high intensity             boldhigh intens           background                high intensity backgrounds
###-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local bla='\e[0;30m';     local bbla='\e[1;30m';    local ubla='\e[4;30m';    local ibla='\e[0;90m';    local bibla='\e[1;90m';   local on_bla='\e[40m';    local on_ibla='\e[0;100m';
local red='\e[0;31m';     local bred='\e[1;31m';    local ured='\e[4;31m';    local ired='\e[0;91m';    local bired='\e[1;91m';   local on_red='\e[41m';    local on_ired='\e[0;101m';
local gre='\e[0;32m';     local bgre='\e[1;32m';    local ugre='\e[4;32m';    local igre='\e[0;92m';    local bigre='\e[1;92m';   local on_gre='\e[42m';    local on_igre='\e[0;102m';
local yel='\e[0;33m';     local byel='\e[1;33m';    local uyel='\e[4;33m';    local iyel='\e[0;93m';    local biyel='\e[1;93m';   local on_yel='\e[43m';    local on_iyel='\e[0;103m';
local blu='\e[0;34m';     local bblu='\e[1;34m';    local ublu='\e[4;34m';    local iblu='\e[0;94m';    local biblu='\e[1;94m';   local on_blu='\e[44m';    local on_iblu='\e[0;104m';
local pur='\e[0;35m';     local bpur='\e[1;35m';    local upur='\e[4;35m';    local ipur='\e[0;95m';    local bipur='\e[1;95m';   local on_pur='\e[45m';    local on_ipur='\e[0;105m';
local cya='\e[0;36m';     local bcya='\e[1;36m';    local ucya='\e[4;36m';    local icya='\e[0;96m';    local bicya='\e[1;96m';   local on_cya='\e[46m';    local on_icya='\e[0;106m';
local whi='\e[0;37m';     local bwhi='\e[1;37m';    local uwhi='\e[4;37m';    local iwhi='\e[0;97m';    local biwhi='\e[1;97m';   local on_whi='\e[47m';    local on_iwhi='\e[0;107m';
