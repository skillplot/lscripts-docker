#!/bin/bash

envname=$1
[[ ! -z ${envname}  ]] || envname=nerfstudio
echo "compute: ${envname}"


conda create --name ${envname} -y python=3.8
conda activate ${envname}

# conda deactivate
python -m pip install --upgrade pip


## ~/.bashrc configuration for conda: WIP

# export PY_CONDA_PATH=${__DATAHUB_ROOT__}/conda/envs
# export CONDA_ENVS_PATH=${PY_CONDA_PATH}
# export LSCRIPTS__PYCONDA_PATH=${CONDA_ENVS_PATH}
# # >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/mnt/vol1/datahub/conda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/mnt/vol1/datahub/conda/etc/profile.d/conda.sh" ]; then
#         . "/mnt/vol1/datahub/conda/etc/profile.d/conda.sh"
#     else
#         export PATH="/mnt/vol1/datahub/conda/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# # <<< conda initialize <<<

