#!/bin/bash

mydomain="${_SKPLT_SKILLPLOT_DN}"
myhostname="gateway"
gdapikey="${_GODADDY__API_KEY}:${_GODADDY__API_SECRET}"
logdest="local7.info"


## This script uses ipify.org to determine your current IP address (they return results in a code-friendly way) then compares to the current IP setting in GoDaddy. If they do not match, it uses the API to change the IP address.
myip=`curl -s "https://api.ipify.org"`
dnsdata=`curl -s -X GET -H "Authorization: sso-key ${gdapikey}" "https://api.godaddy.com/v1/domains/${mydomain}/records/A/${myhostname}"`
gdip=`echo $dnsdata | cut -d ',' -f 1 | tr -d '"' | cut -d ":" -f 2`
echo "`date '+%Y-%m-%d %H:%M:%S'` - Current External IP is $myip, GoDaddy DNS IP is $gdip"

if [ "$gdip" != "$myip" -a "$myip" != "" ]; then
  echo "IP has changed!! Updating on GoDaddy"
  curl -s -X PUT "https://api.godaddy.com/v1/domains/${mydomain}/records/A/${myhostname}" -H "Authorization: sso-key ${gdapikey}" -H "Content-Type: application/json" -d "[{\"data\": \"${myip}\"}]"
  logger -p $logdest "Changed IP on ${hostname}.${mydomain} from ${gdip} to ${myip}"
fi
