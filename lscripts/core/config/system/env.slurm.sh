#!/bin/bash

## Copyright (c) 2026 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## === HPC Environment Setup ===
###----------------------------------------------------------


module load cuda/12.8

## GCC 11 toolchain from your conda env
export GCC11_ENV=$HOME/datahub/conda/envs/gcc11
export PATH=$GCC11_ENV/bin:$PATH
export CC=$GCC11_ENV/bin/x86_64-conda-linux-gnu-gcc
export CXX=$GCC11_ENV/bin/x86_64-conda-linux-gnu-g++

## Conda environment
source /nfs_home/software/miniconda/etc/profile.d/conda.sh
conda config --show envs_dirs

export CUDA_HOME=/nfs_home/software/install/cuda/12.8
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH


[[ $PS1 ]] && {
  which nvcc
  nvcc -V
  $CC --version
}
