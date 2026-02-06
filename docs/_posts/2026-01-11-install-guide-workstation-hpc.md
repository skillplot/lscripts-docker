---
title: "Install Guide: workstation + HPC"
date: "2026-01-11 09:00:00 +0530"
categories:
  - Docs
  - Field Manual
tags:
  - install
  - setup
  - hpc
  - docker
  - cuda
toc: true
pin: true
---
This chapter focuses on **getting Lscripts running safely** on:

- a workstation (Ubuntu recommended)
- a shared multi-user machine
- an HPC cluster (where you may not have root)

{: .prompt-info }
Lscripts is designed to be *read-only by default* and *explicitly interactive* when it needs to mutate your system.

## 1) Clone the repository

Recommended layout (customize as you like):

```text
/codehub
  /external
    /lscripts-docker
/datahub
  /logs
  /models
```

Clone:

```bash
mkdir -p /codehub/external
cd /codehub/external
git clone https://github.com/skillplot/lscripts-docker.git
cd lscripts-docker
```

## 2) Load the environment

For the current shell session:

```bash
source env.sh
```

To make it persistent, add it to your shell profile:

```bash
echo 'source /codehub/external/lscripts-docker/env.sh' >> ~/.bashrc
source ~/.bashrc
```

{: .prompt-warning }
If your environment uses `zsh`, load it from `~/.zshrc` instead.

## 3) Optional: run the interactive installer

The installer can create base directories, install packages, and clone repos.

```bash
bash install.sh -c /codehub -d /datahub
```

Because this can involve **root access**, the installer will prompt you before anything destructive.

## 4) Validate the machine

Run these read-only checks:

```bash
# OS / system
lsd-cfg.system

# Docker presence and daemon access
lsd-cfg.docker

# NVIDIA GPU (if present)
lsd-cfg.nvidia
```

If you have NVIDIA hardware, also validate runtime visibility:

```bash
nvidia-smi
```

## 5) Local docs development (optional)

If you want to preview the docs locally:

```bash
cd docs
bundle install
bundle exec jekyll serve --livereload
```

Then open the local URL printed by Jekyll.

{: .prompt-tip }
For GitHub Pages deployment, the repo includes a GitHub Actions workflow that builds from `/docs` and publishes to Pages.

## Next

Continue with: **Command map & UX patterns**.
