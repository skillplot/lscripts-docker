#!/bin/bash

url="https://fw.bits-pilani.ac.in:8090/httpclient.html"
username=$1
password=$2

curl -X POST ${url} -H "Content-Type: application/x-www-form-urlencoded" -d "mode=191&username=${username}&password=${password}&a=1663910594595&producttype=0" 

