#!/bin/bash

## Copyright (c) 2026 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## VPN and cred functions
###----------------------------------------------------------

###----------------------------------------------------------
## lsd-mod.vpn utilities
###----------------------------------------------------------
function lsd-mod.vpn.connect-openfortivpn() {
  local _cred="${1:-$_CRED__OPENFORTIVPN_FILE}"
  [ -f ${_cred} ] && {
    source ${_cred}
    sudo openfortivpn ${__OPENFORTIVPN_SOCKET__} -u ${__OPENFORTIVPN_USERNAME__} --trusted-cert ${__OPENFORTIVPN_TRUSTED_CERT__}
  } || echo "File does not exists:: ${_cred}"
}

function lsd-mod.vpn.connect-openvpn() {
  local _cred="${1:-$_CRED__OPENVPN_FILE}"
  [ -f ${_cred} ] && {
    sudo openvpn --config ${_cred}
  } || echo "File does not exists:: ${_cred}"
}
