#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Alias for system configurations and convenience utilities
##----------------------------------------------------------
#
## References:
## https://stackoverflow.com/questions/7131670/make-a-bash-alias-that-takes-a-parameter
## https://stackoverflow.com/questions/2013547/assigning-default-values-to-shell-variables-with-a-single-command-in-bash
###----------------------------------------------------------


function lscripts.alias.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  ##
  alias lt='ls -lrth'
  alias l='ls -lrth'
  alias lpwd='ls -d -1 ${PWD}/*'
  alias lpwdf='ls -d -1 ${PWD}/*.*'
  ##
  alias lsd-cd="cd ${LSCRIPTS}"
  ###----------------------------------------------------------
  ## convinience
  ###----------------------------------------------------------
  alias lsd-python.create.virtualenv="source ${LSCRIPTS}/python-virtualenvwrapper-install.sh"
  ###----------------------------------------------------------
  ## lsd-cfg => from different module
  ###----------------------------------------------------------
  alias lsd-cfg.color="bash ${LSCRIPTS}/exec_cmd.sh cmd=_color_.get__vars"
  alias lsd-cfg.docker="bash ${LSCRIPTS}/exec_cmd.sh cmd=_docker_.get__vars"
  alias lsd-cfg.nvidia="bash ${LSCRIPTS}/exec_cmd.sh cmd=_nvidia_.get__vars"
  alias lsd-cfg.system="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.get__vars"
  alias lsd-cfg.typeformats="bash ${LSCRIPTS}/exec_cmd.sh cmd=_typeformats_.get__vars"
  ###----------------------------------------------------------
  ## lsd-nvidia => _nvidia_ module
  ###----------------------------------------------------------
  alias lsd-nvidia.cfg="bash ${LSCRIPTS}/exec_cmd.sh cmd=_nvidia_.get__vars"
  alias lsd-nvidia.gpu.info="bash ${LSCRIPTS}/exec_cmd.sh cmd=_nvidia_.get__driver_info"
  alias lsd-nvidia.gpu.stats="bash ${LSCRIPTS}/exec_cmd.sh cmd=_nvidia_.get__gpu_stats $1"
  alias lsd-nvidia.cuda.vers="bash ${LSCRIPTS}/exec_cmd.sh cmd=_nvidia_.get__cuda_vers"
  alias lsd-nvidia.cuda.avail="bash ${LSCRIPTS}/exec_cmd.sh cmd=_nvidia_.get__cuda_vers_avail"
  alias lsd-nvidia.driver.avail="bash ${LSCRIPTS}/exec_cmd.sh cmd=_nvidia_.get__driver_avail"
  ###----------------------------------------------------------
  ## lsd-apt => _apt_ module
  ###----------------------------------------------------------
  alias lsd-apt.search="bash ${LSCRIPTS}/exec_cmd.sh cmd=_apt_.search"
  alias lsd-apt.guess="bash ${LSCRIPTS}/exec_cmd.sh cmd=_apt_.guess"
  alias lsd-apt.ppa-add="bash ${LSCRIPTS}/exec_cmd.sh cmd=_apt_.add-repo"
  alias lsd-apt.ppa-list="bash ${LSCRIPTS}/exec_cmd.sh cmd=_apt_.get-repo ls"
  alias lsd-apt.ppa-remove="bash ${LSCRIPTS}/exec_cmd.sh cmd=_apt_.get-repo rm"
  ###----------------------------------------------------------
  ## lsd-date => _date_ module
  ###----------------------------------------------------------
  alias lsd-date.cfg="bash ${LSCRIPTS}/exec_cmd.sh cmd=_typeformats_.get__vars"
  alias lsd-date.timestamp="bash ${LSCRIPTS}/exec_cmd.sh cmd=_date_.get__timestamp"
  alias lsd-date.timestamp.millisec="bash ${LSCRIPTS}/exec_cmd.sh cmd=_date_.get__timestamp_millisec"
  alias lsd-date.timestamp.microsec="bash ${LSCRIPTS}/exec_cmd.sh cmd=_date_.get__timestamp_microsec"
  alias lsd-date.timestamp.nanosec="bash ${LSCRIPTS}/exec_cmd.sh cmd=_date_.get__timestamp_nanosec"
  ###----------------------------------------------------------
  ## lsd-system, lsd-select => _system_ module
  ###----------------------------------------------------------
  alias lsd-system.cfg="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.get__vars"
  alias lsd-system.cpu.cores="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.get__cpu_cores"
  alias lsd-system.cpu.threads="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.get__numthreads"
  alias lsd-system.df.json="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.df_json"
  alias lsd-system.ip="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.get__ip"
  alias lsd-system.osinfo="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.get__osinfo"
  ##
  alias lsd-select.cuda="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.select__cuda"
  alias lsd-select.gcc="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.select__gcc"
  alias lsd-select.bazel="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.select__bazel"
  ###----------------------------------------------------------
  ## lsd-docker => _docker_ module
  ###----------------------------------------------------------
  alias lsd-docker.cfg="bash ${LSCRIPTS}/exec_cmd.sh cmd=_docker_.get__vars"
  alias lsd-docker.osvers="bash ${LSCRIPTS}/exec_cmd.sh cmd=_docker_.get__os_vers_avail"
  #
  alias lsd-docker.container.delete-all="bash ${LSCRIPTS}/exec_cmd.sh cmd=_docker_.container.delete-all"
  alias lsd-docker.container.delete-byimage="bash ${LSCRIPTS}/exec_cmd.sh cmd=_docker_.container.delete-byimage $@"
  alias lsd-docker.container.exec="bash ${LSCRIPTS}/exec_cmd.sh cmd=_docker_.container.exec"
  alias lsd-docker.container.exec-byname="bash ${LSCRIPTS}/exec_cmd.sh cmd=_docker_.container.exec-byname"
  alias lsd-docker.container.list="bash ${LSCRIPTS}/exec_cmd.sh cmd=_docker_.container.list"
  alias lsd-docker.container.list-ids="bash ${LSCRIPTS}/exec_cmd.sh cmd=_docker_.container.list-ids"
  alias lsd-docker.container.list-ids-all="bash ${LSCRIPTS}/exec_cmd.sh cmd=_docker_.container.list-ids-all"
  alias lsd-docker.container.status="bash ${LSCRIPTS}/exec_cmd.sh cmd=_docker_.container.status"
  alias lsd-docker.container.stop-all="bash ${LSCRIPTS}/exec_cmd.sh cmd=_docker_.container.stop-all"
  alias lsd-docker.container.test="bash ${LSCRIPTS}/exec_cmd.sh cmd=_docker_.container.test"
  #
  alias lsd-docker.image.build="bash ${LSCRIPTS}/exec_cmd.sh cmd=_docker_.image.build"
  ###----------------------------------------------------------
  ## lsd-stack => _stack_ module
  ###----------------------------------------------------------
  alias lsd-stack.list="bash ${LSCRIPTS}/exec_cmd.sh cmd=_stack_.list $@"
  ###----------------------------------------------------------
  ## lsd-cmd => snippets/ package
  ###----------------------------------------------------------
  alias lsd-cmd.dummy="bash ${LSCRIPTS}/snippets/dummy.sh"
  alias lsd-cmd.git.get.repo-urls="bash ${LSCRIPTS}/snippets/git.get.repo-urls.sh"
  alias lsd-cmd.git.repoviz="bash ${LSCRIPTS}/snippets/git.repoviz.sh"
  alias lsd-cmd.gitlab.get.cert="bash ${LSCRIPTS}/snippets/gitlab.get.cert.sh"
  alias lsd-cmd.menu-navigation="bash ${LSCRIPTS}/snippets/menu-navigation.sh"
  alias lsd-cmd.monitoring-cmds="bash ${LSCRIPTS}/snippets/monitoring-cmds.sh"
  alias lsd-cmd.mount.smb="bash ${LSCRIPTS}/snippets/mount.smb.sh"
  alias lsd-cmd.mount.ssh="bash ${LSCRIPTS}/snippets/mount.ssh.sh"
  alias lsd-cmd.pm="bash ${LSCRIPTS}/snippets/pm.sh"
  alias lsd-cmd.python.venvname.generate="bash ${LSCRIPTS}/snippets/python.venvname.generate.sh"
  alias lsd-cmd.python.list.venv="bash ${LSCRIPTS}/snippets/python.list.venv.sh"
  ###----------------------------------------------------------
  ## lsd-test => tests/ package
  ###----------------------------------------------------------
  # alias lsd-test.all="bash ${LSCRIPTS}/tests/test.all.sh"
  alias lsd-test.argparse="bash ${LSCRIPTS}/tests/test.argparse.sh"
  alias lsd-test.cuda_config_supported="bash ${LSCRIPTS}/tests/test.cuda_config_supported.sh"
  alias lsd-test._dir_="bash ${LSCRIPTS}/tests/test._dir_.sh"
  alias lsd-test.echo="bash ${LSCRIPTS}/tests/test.echo.sh Namaste "
  alias lsd-test._fio_="bash ${LSCRIPTS}/tests/test._fio_.sh"
  alias lsd-test._log_="bash ${LSCRIPTS}/tests/test._log_.sh"
  alias lsd-test._system_="bash ${LSCRIPTS}/tests/test._system_.sh"
  ###----------------------------------------------------------
  ## lsd-utils => _utils_ module
  ###----------------------------------------------------------
  alias lsd-utils.pid="bash ${LSCRIPTS}/exec_cmd.sh cmd=_utils_.pid"
  alias lsd-utils.kill="bash ${LSCRIPTS}/exec_cmd.sh cmd=_utils_.kill"
  alias lsd-utils.kill.python="bash ${LSCRIPTS}/exec_cmd.sh cmd=_utils_.kill.python"
  alias lsd-utils.kill.python="bash ${LSCRIPTS}/exec_cmd.sh cmd=_utils_.kill.python"
  alias lsd-utils.ls="bash ${LSCRIPTS}/exec_cmd.sh cmd=_utils_.ls"
  alias lsd-utils.ls.pycache="bash ${LSCRIPTS}/exec_cmd.sh cmd=_utils_.ls.pycache"
  alias lsd-utils.ls.egg="bash ${LSCRIPTS}/exec_cmd.sh cmd=_utils_.ls.egg"
  alias lsd-utils.rm.pycache="bash ${LSCRIPTS}/exec_cmd.sh cmd=_utils_.rm.pycache"
  alias lsd-utils.rm.egg="bash ${LSCRIPTS}/exec_cmd.sh cmd=_utils_.rm.egg"
  alias lsd-utils.trash="bash ${LSCRIPTS}/exec_cmd.sh cmd=_utils_.trash"
  alias lsd-utils.image.resize="bash ${LSCRIPTS}/exec_cmd.sh cmd=_utils_.image.resize"
  alias lsd-utils.image.pdf="bash ${LSCRIPTS}/exec_cmd.sh cmd=_utils_.image.pdf"
  alias lsd-utils.date.get="bash ${LSCRIPTS}/exec_cmd.sh cmd=_utils_.date.get"
  alias lsd-utils.system.info="bash ${LSCRIPTS}/exec_cmd.sh cmd=_utils_.system.info"
  alias lsd-utils.id.salt="bash ${LSCRIPTS}/exec_cmd.sh cmd=_utils_.id.salt"
  alias lsd-utils.id.get="bash ${LSCRIPTS}/exec_cmd.sh cmd=_utils_.id.get"
  alias lsd-utils.id.uuid="bash ${LSCRIPTS}/exec_cmd.sh cmd=_utils_.id.uuid"
  alias lsd-utils.id.filename="bash ${LSCRIPTS}/exec_cmd.sh cmd=_utils_.id.filename"
  alias lsd-utils.id.filename-tmp="bash ${LSCRIPTS}/exec_cmd.sh cmd=_utils_.id.filename-tmp"
}

lscripts.alias.main "$@"
