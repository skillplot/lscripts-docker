## Roadmap
> Todo items


* To make better is to create select list of commands being exposed and not the actual function name using associative array and provide menu to the user to select which command to excecute
* Share the python virtual environment with the host machine
* Package and release to apt repo


**Docker**
* Check if docker with same hostname inside docker is valid for multiple container networking or docker hostname for each container is to be different; in other words what's the implication of hostname being same or different inside the docker container


**Features/Enhancements/Issues**
* Help menu pre script
* Able to execute individual function in a particular script, same should appear in the help menu
* Parameter information of each script
* Python non-system default installation - 3.7+ on Ubuntu 18.04 and 3.6 on Ubuntu 20.04 using tar file
* `CTRL+C` on user prompt exists the terminal which is bad user expereince
* `.bashrc`  local to the `lscripts-docker` system and overriding option from system's `.bashrc`
* Other `.dot` files configuration local to the `lscripts-docker` system and overriding option from system's `.bashrc`
  * nodejs
  * vim editor
* Custom builds for GIS and other stack local to `lscripts-docker` and configurable to system level
* `chroot jail` setup option for the `lscripts-docker` to run and execute in isolated environments


**Issues to be fixed**
* Ubuntu 20.04, or in many systems, `virtaulenvwrapper` gets isntalled at `$HOME/.local/bin` but it is not in the PATH environment variable, hence `mkvirtualenv` command fails and exists abruptly.
  ```bash
  ## add in ~/.bashrc file
  export PATH=$HOME/.local/bin:$PATH
  ```
* Installation of `nvidia-container-toolkit` has some logic issues - repo key to be added and then the repo; repo is not getting added through the script
* Cuda installer issues
  * lsd-stack.nvidia ==> cuda installer expects cuda version to be installed
  * cuda stack for ubuntu 20.04 still needs to add 18.04 OS distribution repo
