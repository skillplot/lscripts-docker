# skplt.serversetup
> Ubuntu Server GPU or non GPU server setup guide using lscripts-docker bash shell script framework 

1. If there is an error of for `/cdrom` on `sudo apt update`, then comment the `CDROM` line in the file: `/etc/apt/sources.list`
    ```bash
    cat /etc/apt/sources.list
    sudo vi /etc/apt/sources.list
    ```
2. Install ubuntu-desktop
    ```bash
    sudo apt -y update
    sudo apt -y install ubuntu-desktop
    ```
3. Check the latest nvidia driver version, currently it was 535
    ```bash
    sudo apt -y install nvidia-driver-535
    ```
4. Install minimum server dependencies and lscripts
    ```bash
    bash <(curl -s https://raw.githubusercontent.com/skillplot/lscripts-docker/main/lscripts/banners/skplt.serversetup.sh)
    ```
5. source the bashrc. The CLI prompt will change and will show the skillplot banner, then execute this command
    ```bash
    source ~/.bashrc
    ```
6. Install dependencies by executing following command. **NOTE**: No need to reboot if it ask for; type `n`. Configure, verify, add repo keys, add repo - whenever it asks for different items.
    * SKIP: nvidia driver installation
    * Install docker-ce
    * Install docker-compose
    * Install python
    * Install python-virtualenvwrapper
    * Install nvidia-container-toolkit
    * SKIP: cuda stack installation
    ```bash
    lsd-stack.nvidia_cuda_python_docker
    ```
7. Install conda
    ```bash
    lsd-install.python-miniconda
    ```
8. Change the docker subnet if needed; refer following link
    * [https://gist.github.com/mangalbhaskar/ab1587521a41a8e648c2b9dcbdc8cffd](https://gist.github.com/mangalbhaskar/ab1587521a41a8e648c2b9dcbdc8cffd)
9. Cleanup
    * Remove the configuration lines from the `vi ~/.bashrc` file
        ```bash
        export LSCRIPTS_DOCKER="/tmp/codehub/external/lscripts-docker"
        [ -f ${LSCRIPTS_DOCKER}/lscripts/lscripts.env.sh ] && source ${LSCRIPTS_DOCKER}/lscripts/lscripts.env.sh
        ```
    * Remove `/tmp/codehub` directory created by the script containing `external/lscripts-docker from the system.
        ```bash
        rm -rf /tmp/codehub
        ```

