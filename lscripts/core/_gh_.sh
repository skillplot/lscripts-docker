#!/bin/bash

## Copyright (c) 2025 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## GitHub utilities (multi-account support)
###----------------------------------------------------------


##----------------------------------------------------------
## GitHub Auth (multi-account)
## Usage: lsd-mod.gh.auth <username>
##----------------------------------------------------------
function lsd-mod.gh.auth() {
  local username="$1"

  if [[ -z "${username}" ]]; then
    echo "Usage: lsd-mod.gh.auth <username>"
    return 1
  fi

  # Validate token exists
  if [[ ! -f ~/.cred/github.${username} ]]; then
    echo "[ERROR] GitHub token not found: ~/.cred/github.${username}"
    return 1
  fi

  echo "🔑 Authenticating GitHub user: ${username}"

  curl -s -H "Authorization: token $(cat ~/.cred/github.${username})" https://api.github.com/user

  GH_CONFIG_DIR=~/.config/gh-${username} \
    gh auth login --hostname github.com --git-protocol ssh --with-token < ~/.cred/github.${username}
}


##----------------------------------------------------------
## GitHub Repo View
## Usage: lsd-mod.gh.view <username> <reponame>
##----------------------------------------------------------
function lsd-mod.gh.view() {
  local username="$1"
  local reponame="$2"

  if [[ -z "${username}" || -z "${reponame}" ]]; then
    echo "Usage: lsd-mod.gh.view <username> <reponame>"
    return 1
  fi

  GH_CONFIG_DIR=~/.config/gh-${username} \
    gh repo view ${username}/${reponame}
}


##----------------------------------------------------------
## GitHub Push (multi-account)
## Usage: lsd-mod.gh.push <username>
##----------------------------------------------------------
function lsd-mod.gh.push() {
  local username="$1"

  if [[ -z "${username}" ]]; then
    echo "Usage: lsd-mod.gh.push <username>"
    return 1
  fi

  GH_CONFIG_DIR=~/.config/gh-${username} \
    git push
}


##----------------------------------------------------------
## Git Remote URL (HTTPS)
## Usage: lsd-mod.gh.set-url-https <username> <reponame>
##----------------------------------------------------------
function lsd-mod.gh.set-url-https() {
  local username="$1"
  local reponame="$2"

  if [[ -z "${username}" || -z "${reponame}" ]]; then
    echo "Usage: lsd-mod.gh.set-url-https <username> <reponame>"
    return 1
  fi

  git remote set-url origin https://${username}@github.com/${username}/${reponame}.git
}


##----------------------------------------------------------
## Git Remote URL (SSH)
## Usage: lsd-mod.gh.set-url-ssh <username> <reponame>
##----------------------------------------------------------
function lsd-mod.gh.set-url-ssh() {
  local username="$1"
  local reponame="$2"

  if [[ -z "${username}" || -z "${reponame}" ]]; then
    echo "Usage: lsd-mod.gh.set-url-ssh <username> <reponame>"
    return 1
  fi

  git remote set-url origin git@github.com:${username}/${reponame}.git
}


##----------------------------------------------------------
## GitHub Repo create-repo (from current dir)
## Usage: lsd-mod.gh.create-repo <username>
##----------------------------------------------------------
function lsd-mod.gh.create-repo() {
  local username="$1"
  local reponame="$(basename "$PWD")"

  [[ -z "${username}" ]] && {
    lsd-mod.log.echo "Usage: lsd-mod.gh.create-repo <username>"
    return 1
  }

  lsd-mod.log.info "Creating PRIVATE GitHub repo for user: ${username}, repo: ${reponame}"

  ## Copy gitignore / gitattributes
  lsd-mod.gh.copy-gitignore
  ### lsd-mod.gh.copy-gitattributes

  ## Init git repo if needed
  [[ -d .git ]] || { git init && lsd-mod.log.ok "Initialized new git repo"; }

  ## Show status + confirm
  git status
  lsd-mod.fio.yes_or_no_loop "Proceed with staging and committing all files" || {
    lsd-mod.log.warn "Aborted by user."
    return 1
  }

  ## Stage + commit
  git add -A && git commit -m "Initial commit" && lsd-mod.log.ok "Initial commit done"

  # Branch main
  git branch -M main

  ## Create the repo on GitHub (PRIVATE by default)
  curl -s -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $(cat ~/.cred/github.${username})" \
    https://api.github.com/user/repos \
    -d '{"name":"'${reponame}'","description":"created from lscripts","private":true,"has_issues":true,"has_projects":true,"has_wiki":false}' \
    && lsd-mod.log.ok "Private repo created on GitHub: ${username}/${reponame}" \
    || { lsd-mod.log.error "Failed to create GitHub repo"; return 1; }

  ## Set remote via HTTPS
  lsd-mod.gh.set-url-https "${username}" "${reponame}"

  ## Push
  lsd-mod.gh.push "${username}"

  lsd-mod.log.success "Repo successfully created, private by default: https://github.com/${username}/${reponame}.git"
}

##----------------------------------------------------------
## Create Org Repo (PRIVATE by default)
## Usage: lsd-mod.gh.create-org-repo <orgname>
##----------------------------------------------------------
function lsd-mod.gh.create-org-repo() {
  local org="$1"
  local reponame="$(basename "$PWD")"
  [[ -z "${org}" ]] && { lsd-mod.log.echo "Usage: lsd-mod.gh.create-org-repo <orgname>"; return 1; }

  curl -s -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $(cat ~/.cred/github.${org})" \
    https://api.github.com/orgs/${org}/repos \
    -d '{"name":"'${reponame}'","description":"created from lscripts","private":true,"has_issues":true,"has_projects":true,"has_wiki":false}' \
    && lsd-mod.log.success "Private org repo created: ${org}/${reponame}" \
    || lsd-mod.log.error "Failed to create org repo"
}

##----------------------------------------------------------
## Copy .gitignore template
##----------------------------------------------------------
function lsd-mod.gh.copy-gitignore() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  local src="${LSCRIPTS}/config/dotfiles/gitignore"
  local dst=".gitignore"
  [[ -f "${src}" ]] && cp "${src}" "${dst}" && lsd-mod.log.ok "Copied gitignore → ${dst}" \
                    || lsd-mod.log.warn "gitignore template not found at: ${src}"
}

##----------------------------------------------------------
## Copy .gitattributes template
##----------------------------------------------------------
function lsd-mod.gh.copy-gitattributes() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  local src="${LSCRIPTS}/config/dotfiles/gitattributes"
  local dst=".gitattributes"
  [[ -f "${src}" ]] && cp "${src}" "${dst}" && lsd-mod.log.ok "Copied gitattributes → ${dst}" \
                    || lsd-mod.log.warn "gitattributes template not found at: ${src}"
}

##----------------------------------------------------------
## Create GitHub Pages for repo
## Usage: lsd-mod.gh.create-pages <username>
##----------------------------------------------------------
function lsd-mod.gh.create-pages() {
  local username="$1"
  local reponame="$(basename "$PWD")"
  [[ -z "${username}" ]] && { lsd-mod.log.echo "Usage: lsd-mod.gh.create-pages <username>"; return 1; }

  curl -s -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $(cat ~/.cred/github.${username})" \
    https://api.github.com/repos/${username}/${reponame}/pages \
    -d '{"source":{"branch":"main","path":"/docs"}}' \
    && lsd-mod.log.success "GitHub Pages created for ${username}/${reponame}" \
    || lsd-mod.log.error "Failed to create GitHub Pages"
}

##----------------------------------------------------------
## Delete GitHub Pages for repo
## Usage: lsd-mod.gh.delete-pages <username>
##----------------------------------------------------------
function lsd-mod.gh.delete-pages() {
  local username="$1"
  local reponame="$(basename "$PWD")"
  [[ -z "${username}" ]] && { lsd-mod.log.echo "Usage: lsd-mod.gh.delete-pages <username>"; return 1; }

  curl -s -X DELETE \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $(cat ~/.cred/github.${username})" \
    https://api.github.com/repos/${username}/${reponame}/pages \
    && lsd-mod.log.success "GitHub Pages deleted for ${username}/${reponame}" \
    || lsd-mod.log.error "Failed to delete GitHub Pages"
}
