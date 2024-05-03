wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib"

sudo apt update

sudo apt install virtualbox-7.0


## https://www.linuxcapable.com/install-virtualbox-on-ubuntu-linux/
sudo apt install dirmngr ca-certificates software-properties-common apt-transport-https curl -y

curl -fSsL https://www.virtualbox.org/download/oracle_vbox_2016.asc | gpg --dearmor | sudo tee /usr/share/keyrings/virtualbox.gpg > /dev/null

echo "deb [arch=$( dpkg --print-architecture ) signed-by=/usr/share/keyrings/virtualbox.gpg] http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox-7.list

sudo apt update

sudo apt install virtualbox-7.0 linux-headers-$(uname -r) -y


apt-cache policy virtualbox-7.0
systemctl status vboxdrv

sudo systemctl enable vboxdrv --now

virtualbox


### Install VirtualBox Extension Pack on Ubuntu 22.04 or 20.04

vboxmanage -v | cut -dr -f1

### Replace each instance of ‘7.0.x’ in the URL with your specific VirtualBox version.
wget https://download.virtualbox.org/virtualbox/7.0.x/Oracle_VM_VirtualBox_Extension_Pack-7.0.x.vbox-extpack


sudo vboxmanage extpack install Oracle_VM_VirtualBox_Extension_Pack-7.0.x.vbox-extpack

vboxmanage list extpacks

sudo usermod -a -G vboxusers $USER

## groups $USER
