# Lscripts Docker
> Linux Scripts For Deep Learning Projects

## [lscripts.skillplot.org](https://skillplot.github.io/lscripts-docker)

* [Introduction to Lscripts Docker](docs/_posts/2021-05-07-introduction-to-lscripts-docker.md)
* [Quick start](docs/_posts/2021-05-08-quick-start.md)
* [System design](docs/_posts/2021-05-09-system-design.md)
* [System Setup](docs/_posts/2021-06-18-system-setup.md)
* [Color Codes](docs/_posts/2021-06-18-color-codes.md)
* [Lscript Docker](docs/_posts/2021-06-21-lscript-docker.md)
* [Tools Stack](docs/_posts/2021-07-04-tools-stack.md)



## About

`Lscripts Docker` or `lsd` is a collection of shell scipts, designed to be installed per-user, and invoked per-shell. `lsd` **should work** on any POSIX-compliant shell (sh, dash, ksh, zsh, bash), but it's developed and tested on `bash` in particular to `Ubuntu 18.04 LTS`.


## Configuration Option
> environment variables


```bash
export LSCRIPTS__BASENAME="lsdhub"
export LSCRIPTS__ROOT="/boozo-hub"
##
export LSCRIPTS__BANNER=1
export LSCRIPTS__BANNER_TYPE="skillplot-1"
##
export LSCRIPTS__DEBUG=1
export LSCRIPTS__LOG_LEVEL=8
##
export LSCRIPTS__VMHOME=""
export LSCRIPTS__PYVENV_PATH=""
export LSCRIPTS__WSGIPYTHONPATH=""
export LSCRIPTS__WSGIPYTHONHOME=""
export LSCRIPTS__ANDROID_HOME=""
export LSCRIPTS__APACHE_HOME=""
export LSCRIPTS__WWW_HOME=""
export LSCRIPTS__DOWNLOADS=""
export LSCRIPTS__EXTERNAL_HOME=""
```


## Installation

To install or update `lsd`, you should run the install script. To do that, you may either download and run the script manually, or use the following `cURL` or `Wget` command:


```bash
## Install the pre-requisite if not available
sudo apt -y update
sudo apt -y install curl
sudo apt -y install wget
```

```bash
curl -o- https://raw.githubusercontent.com/skillplot/lscripts-docker/main/install.sh | bash
sudo bash <(curl -s https://raw.githubusercontent.com/skillplot/lscripts-docker/main/install.sh)
```

```bash
wget -qO- https://raw.githubusercontent.com/skillplot/lscripts-docker/main/install.sh | bash
sudo bash <(wget -qO- https://raw.githubusercontent.com/skillplot/lscripts-docker/main/install.sh)
```

Running either of the above commands downloads a script and runs it. The script clones the `lscripts-docker` repository to `~/.lscripts-docker`, and attempts to add the source lines from the snippet below to the correct profile file: `~/.bash_profile`, `~/.zshrc`, `~/.profile`, or `~/.bashrc`).
* bash: `source ~/.bashrc`
* zsh: `source ~/.zshrc`
* ksh: `. ~/.profile`


1. Clone the repo
    ```bash
    git clone https://github.com/skillplot/lscripts-docker.git
    ```
2. Put the following in the end of the `~/.bashrc` file. Change the path where you cloned the repo:
    ```bash
    export LSCRIPTS_DOCKER="/<replace_this_with_basepath>/lscripts-docker"
    [ -f ${LSCRIPTS_DOCKER}/lscripts/lscripts.env.sh ] && source ${LSCRIPTS_DOCKER}/lscripts/lscripts.env.sh
    ```


## Verify Installation

To verify that `lscripts-docker` has been installed, do:

```bash
command -v lsd-ls
```


## Standalone Scripts

1. `wget` or `curl` is required if you are using direct execution of script from the URL. Install `wget` or `curl`, if they are not installed already. These utilities may not be installed on system newly installed.
    ```bash
    sudo apt -y update
    sudo apt -y install wget
    sudo apt -y install curl
    ```
2. Fingerprint Banner: Useful for having system fingerprint displayed while taking screenshots for lab assignments. It can be directly executed with the following command (internet access required)
    * Directly execute
        ```bash
        ## using curl
        bash <(curl -s https://raw.githubusercontent.com/skillplot/lscripts-docker/main/lscripts/banners/skplt.fingerprint.sh)
        ## using wget
        bash <(wget -qO- https://raw.githubusercontent.com/skillplot/lscripts-docker/main/lscripts/banners/skplt.fingerprint.sh)
        ```
    * Download it manually and execute
        ```bash
        ## Otherwise, they can download the script and execute it
        https://raw.githubusercontent.com/skillplot/lscripts-docker/main/lscripts/banners/skplt.fingerprint.sh
        ```
3. Server Setup with Banner
    * Directly execute
        ```bash
        ## using wget
        bash <(wget -qO- https://raw.githubusercontent.com/skillplot/lscripts-docker/main/lscripts/banners/skplt.serversetup.sh)
        ## using curl
        bash <(curl -s https://raw.githubusercontent.com/skillplot/lscripts-docker/main/lscripts/banners/skplt.serversetup.sh)
        ```
    * Download it manually and execute
        ```bash
        ## Otherwise, they can download the script and execute it
        https://raw.githubusercontent.com/skillplot/lscripts-docker/main/lscripts/banners/skplt.serversetup.sh
        ```
4. Add Login User to the system interactively
    * Directly execute
        ```bash
        bash <(curl -s https://raw.githubusercontent.com/skillplot/lscripts-docker/main/lscripts/banners/skplt.adduser.sh)
        ```
    * Download it manually and execute
        ```bash
        ## Otherwise, they can download the script and execute it
        https://raw.githubusercontent.com/skillplot/lscripts-docker/main/lscripts/banners/skplt.adduser.sh
        ```


## Copyright and License Terms

Content under `/docs` directory under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License. To view a copy of this license, visit link:https://creativecommons.org/licenses/by-ncsa/3.0[https://creativecommons.org/licenses/by-ncsa/3.0 ].

All other content under [License](LICENSE) terms.

```
Copyright 2016-2024 Bhaskar Mangal (a.k.a. mangalbhaskar). All rights reserved.
__author__ = 'mangalbhaskar'
```
