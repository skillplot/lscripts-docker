#!/bin/bash


## https://askubuntu.com/questions/534658/undo-update-alternatives
update-alternatives --list cuda
update-alternatives --list gcc

sudo update-alternatives --remove-all gcc
sudo update-alternatives --remove-all cuda



python -c 'import torch; print(torch.config.show())'

wget -nc -q https://github.com/facebookresearch/detectron2/raw/master/detectron2/utils/collect_env.py && python collect_env.py


https://github.com/facebookresearch/detectron2/issues/2980


