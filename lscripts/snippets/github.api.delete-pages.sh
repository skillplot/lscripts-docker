#!/bin/bash

# https://docs.github.com/en/rest/pages#delete-a-github-pages-site

owner=$1
[[ ! -z ${owner} ]] || owner="skillplot"
# echo "owner: ${owner}"

curl \
  -X DELETE \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $(cat ~/.cred/github.auth)" \
  https://api.github.com/repos/${owner}/$(basename $PWD)/pages
