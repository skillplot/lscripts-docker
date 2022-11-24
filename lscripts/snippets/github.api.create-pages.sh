#!/bin/bash


# https://docs.github.com/en/rest/pages#create-a-github-pages-site

# curl \
#   -X POST \
#   -H "Accept: application/vnd.github+json" \
#   -H "Authorization: Bearer <YOUR-TOKEN>" \
#   https://api.github.com/repos/OWNER/REPO/pages \
#   -d '{"source":{"branch":"main","path":"/docs"}}'

# curl \
#   -X PUT \
#   -H "Accept: application/vnd.github+json" \
#   -H "Authorization: Bearer <YOUR-TOKEN>" \
#   https://api.github.com/repos/OWNER/REPO/pages \
#   -d '{"cname":"octocatblog.com","source":{"branch":"main","path":"/"}}'

owner=$1
[[ ! -z ${owner} ]] || owner="skillplot"
# echo "owner: ${owner}"

curl \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $(cat ~/.cred/github.auth)" \
  https://api.github.com/repos/${owner}/$(basename $PWD)/pages \
  -d '{"cname":"blah.skillplot.org", "source":{"branch":"main","path":"/docs"}}'
