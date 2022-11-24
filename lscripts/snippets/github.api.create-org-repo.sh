#!/bin/bash

# https://docs.github.com/en/rest/repos/repos#create-an-organization-repository
# curl \
#   -X POST \
#   -H "Accept: application/vnd.github+json" \
#   -H "Authorization: Bearer <YOUR-TOKEN>" \
#   https://api.github.com/orgs/ORG/repos \
#   -d '{"name":"Hello-World","description":"This is your first repository","homepage":"https://github.com","private":false,"has_issues":true,"has_projects":true,"has_wiki":true}'


owner=$1
[[ ! -z ${owner} ]] || owner="skillplot"
# echo "owner: ${owner}"

curl \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $(cat ~/.cred/github.auth)" \
  https://api.github.com/orgs/${owner}/repos \
  -d '{"name":"'$(basename $PWD)'","description":"created from command line","homepage":"https://blah.skillplot.org","private":false,"has_issues":true,"has_projects":true,"has_wiki":false, "is_template": true}'


git init
git add -A
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/${owner}/$(basename $PWD).git
git push -u origin main
