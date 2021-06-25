#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
#
## References:
## server certificate verification failed. CAfile: /etc/ssl/certs/ca-certificates.crt CRLfile: none
## https://stackoverflow.com/questions/21181231/server-certificate-verification-failed-cafile-etc-ssl-certs-ca-certificates-c
###----------------------------------------------------------


function gitlab.get.cert.main() {
  ## for verbose output from git:
  export GIT_CURL_VERBOSE=1

  local hostname=XXX
  echo "Enter gitlab/github repo hostname (ex: www.github.com):"
  read hostname

  local port=443
  local trust_cert_file_location=$(curl-config --ca)
  echo "trust_cert_file_location: ${trust_cert_file_location}"

  [[ -z "${hostname}" ]] && {
    ## To check the CA (Certificate Authority issuer), type a:
    local CAIssuers=`echo -n | openssl s_client -showcerts -connect ${hostname}:${port} -servername ${hostname} \
      2>/dev/null  | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' \
      | openssl x509 -noout -text | grep "CA Issuers" | head -1`

    echo "CAIssuers: ${CAIssuers}"
    # sudo bash -c "echo -n | openssl s_client -showcerts -connect ${hostname}:${port} -servername ${hostname} \
    #     2>/dev/null  | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p'  \
    #     >> ${trust_cert_file_location}"

    # curl https://mysite.com/git/test.git
    # wget https://mysite.com/git/test.git

    # ## To test
    # export GIT_SSL_NO_VERIFY=1
    # #or
    # git config --global http.sslverify false

    # openssl s_client -showcerts -servername www.github.com -connect www.github.com:443
  }
}

gitlab.get.cert.main
