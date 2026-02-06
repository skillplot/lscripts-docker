
## Copyright (c) 2026 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## .bashrc custom configurations
###----------------------------------------------------------

### localhost config
[ -f ${HOME}/Documents/local/env.sh ] && source ${HOME}/Documents/local/env.sh


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/datahub/conda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/datahub/conda/etc/profile.d/conda.sh" ]; then
        . "/datahub/conda/etc/profile.d/conda.sh"
    else
        export PATH="/datahub/conda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
