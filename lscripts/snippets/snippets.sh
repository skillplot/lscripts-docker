#!/bin/bash


## https://askubuntu.com/questions/534658/undo-update-alternatives
update-alternatives --list cuda
update-alternatives --list gcc

sudo update-alternatives --remove-all gcc
sudo update-alternatives --remove-all cuda



python -c 'import torch; print(torch.config.show())'

wget -nc -q https://github.com/facebookresearch/detectron2/raw/master/detectron2/utils/collect_env.py && python collect_env.py


https://github.com/facebookresearch/detectron2/issues/2980




https://askubuntu.com/questions/413358/disk-is-full-but-cannot-find-big-files-or-folders
## disk space monitoring
sudo du -sch /root/*
du -sch .[!.]* * |sort -h
#
#https://askubuntu.com/questions/36111/whats-a-command-line-way-to-find-large-files-directories-to-remove-and-free-up
find / -size +10M -size -12M -ls
#
sudo du -sx /* 2>/dev/null | sort -n
#
sudo du -aBM 2>/dev/null | sort -nr | head -n 10




## System I/O


sysctl vm.swappiness

sudo sysctl vm.swappiness=80

vm.overcommit_memory = 2
vm.overcommit_ratio = 10

/etc/sysctl.conf



free -h


ls -al ~/.local/share/gnome-shell/extensions

