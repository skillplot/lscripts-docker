sudo vi /etc/apt/apt.conf.d/20auto-upgrades


sudo systemctl stop unattended-upgrades.service
sudo systemctl disable unattended-upgrades.service
sudo systemctl status unattended-upgrades

