#!/bin/bash

## https://realpython.com/intro-to-pyenv/

sudo apt -y --no-install-recommends install \
  make \
  build-essential \
  libssl-dev \
  zlib1g-dev \
  \libbz2-dev \
  libreadline-dev \
  libsqlite3-dev \
  wget \
  curl \
  llvm \
  libncurses5-dev \
  libncursesw5-dev \
  xz-utils \
  tk-dev \
  libffi-dev \
  liblzma-dev \
  python-openssl


curl https://pyenv.run | bash


pyenv install --list | grep " 3\.[678]"

ls ~/.pyenv/versions/

pyenv versions

python -V
which python
pyenv which python

pyenv commands
pyenv shims --help


# pyenv install 3.6.8

pyenv versions
pyenv version

pyenv which pip


## The global command sets the global Python version. This can be overridden with other commands, but is useful for ensuring you use a particular Python version by default. If you wanted to use 3.6.8 by default, then you could run this:
pyenv global 3.6.8


## The local command is often used to set an application-specific Python version. You could use it to set the version to 2.7.15:
pyenv local 2.7.15


## The shell command is used to set a shell-specific Python version. For example, if you wanted to test out the 3.8-dev version of Python, you can do this:
## This command activates the version specified by setting the PYENV_VERSION environment variable. This command overwrites any applications or global settings you may have. If you want to deactivate the version, you can use the --unset flag.
pyenv shell 3.8-dev



cat ~/.pyenv/version


# Here’s what you need to know:

# pyenv manages multiple versions of Python itself.
# virtualenv/venv manages virtual environments for a specific Python version.
# pyenv-virtualenv manages virtual environments for across varying versions of Python.

pip install virtualenv virtualenvwrapper
