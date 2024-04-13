#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## _github_ functions - github APIs
###----------------------------------------------------------


function lsd-mod.github.delete-pages() {
  # https://docs.github.com/en/rest/pages#delete-a-github-pages-site

  local owner=$1
  [[ ! -z ${owner} ]] || owner="skillplot"

  lsd-mod.log.echo "owner: ${owner}"
  lsd-mod.log.echo "repo name: $(basename $PWD)"

  curl \
    -X DELETE \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $(cat ~/.cred/github.auth)" \
    https://api.github.com/repos/${owner}/$(basename $PWD)/pages
}


function lsd-mod.github.create-pages() {
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

  local owner=$1
  [[ ! -z ${owner} ]] || owner="skillplot"

  lsd-mod.log.echo "owner: ${owner}"
  lsd-mod.log.echo "repo name: $(basename $PWD)"

  # ls -1 ~/.cred/github.auth &>/dev/null

  ## TODO: cname
  curl \
    -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $(cat ~/.cred/github.auth)" \
    https://api.github.com/repos/${owner}/$(basename $PWD)/pages \
    -d '{"cname":"blah.skillplot.org", "source":{"branch":"main","path":"/docs"}}'


}
function lsd-mod.github.create-org-repo() {
  ## https://docs.github.com/en/rest/repos/repos#create-an-organization-repository
  # curl \
  #   -X POST \
  #   -H "Accept: application/vnd.github+json" \
  #   -H "Authorization: Bearer <YOUR-TOKEN>" \
  #   https://api.github.com/orgs/ORG/repos \
  #   -d '{"name":"Hello-World","description":"This is your first repository","homepage":"https://github.com","private":false,"has_issues":true,"has_projects":true,"has_wiki":true}'

  local owner=$1
  [[ ! -z ${owner} ]] || owner="skillplot"

  lsd-mod.log.echo "owner: ${owner}"
  lsd-mod.log.echo "repo name: $(basename $PWD)"

  ## TODO: homepage
  curl \
    -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $(cat ~/.cred/github.auth)" \
    https://api.github.com/orgs/${owner}/repos \
    -d '{"name":"'$(basename $PWD)'","description":"created from command line","homepage":"https://blah.skillplot.org","private":false,"has_issues":true,"has_projects":true,"has_wiki":false, "is_template": true}'
}


function lsd-mod.github.init() {
  git init
  git add -A
  git commit -m "first commit"
  git branch -M main
  git remote add origin https://github.com/${owner}/$(basename $PWD).git
  git push -u origin main
}
