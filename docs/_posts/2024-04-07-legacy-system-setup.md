---
title: [Legacy] Minimal workstation setup
date: "2024-04-07 09:00:00 +0530"
categories:
  - Archive
  - Lscripts-docker
tags:
  - legacy
  - lscripts-docker
  - system-setup
toc: true
---
{: .prompt-warning }
This is an **archived** post migrated from the previous minima-based site. It may describe older workflows or legacy setups.

## Installations

```bash
sudo apt -y update && sudo apt -y install --no-install-recommends \
  build-essential \
  ca-certificates \
  gnupg \
  gnupg2 \
  wget \
  curl \
  rsync \
  unzip \
  zip \
  git \
  grep \
  feh \
  tree \
  sudo \
  jq \
  openssh-server \
  gcc \
  vim 2>/dev/null
```

This streamlined list focuses on the essentials for a functional remote workstation with development capabilities, without unnecessary overhead. Adjust further based on your specific use case or if you know more about what you won't need.



## Essential Packages

* **openssh-server**: For SSH server support.
* **curl** and **wget**: Command-line tools for downloading files.
* **ca-certificates**: Allows SSL-based applications to check for the authenticity of SSL connections.
* **gnupg**, **gnupg2**: Tools for encryption, providing a secure transport mechanism for key management.
* **sudo**: Allows privilege management, essential for managing permissions.

## Developer Tools (if needed)

* **git**: For version control.
* **build-essential**: Includes the GCC compiler and related tools, necessary if you compile software.
* **gcc**: Included in build-essential, but listed for clarity.
* **pkg-config**: Helps in compiling applications and libraries.
* **zip**, **unzip**, **rsync**: For handling file archives and synchronization.

## Optional Utilities (could be removed based on need)

* **vim** or **vim-gtk**: Text editors. If GUI support isn't required, `vim` alone is sufficient.
* **tree**: Helpful for visualizing directory structures.
* **jq**: Command-line JSON processor.
* **feh**: Lightweight image viewer, useful if you handle image files directly on the server.
* **locate**: Quick file searching utility, needs to be updated with `updatedb` regularly.

## Likely Unnecessary (consider removing unless specifically needed)

* **apt-transport-https**: Now redundant in newer versions of Ubuntu as HTTPS support is built into `apt`.
* **software-properties-common**: Typically used for managing PPAs and not necessary unless you add PPAs.
* **automake**: Necessary only if you frequently compile from source.
* **uuid**: Rarely needed unless specifically required by other applications.
* **apt-utils**: Generally used in Docker environments or specific apt configuration scenarios.
