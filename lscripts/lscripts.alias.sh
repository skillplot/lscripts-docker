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
  ##
  alias lsd-python.create.virtualenv="source ${LSCRIPTS}/python-virtualenvwrapper-install.sh"
  ##
  alias lsd-nvidia.gpu.info="bash ${LSCRIPTS}/exec_cmd.sh cmd=_nvidia_.get__driver_info"
  alias lsd-nvidia.gpu.stats="bash ${LSCRIPTS}/exec_cmd.sh cmd=_nvidia_.get__gpu_stats $1"
  alias lsd-nvidia.cuda.vers="bash ${LSCRIPTS}/exec_cmd.sh cmd=_nvidia_.get__cuda_vers"
  alias lsd-nvidia.cuda.avail="bash ${LSCRIPTS}/exec_cmd.sh cmd=_nvidia_.get__cuda_vers_avail"
  alias lsd-nvidia.driver.avail="bash ${LSCRIPTS}/exec_cmd.sh cmd=_nvidia_.get__driver_avail"
  ##
  alias lsd-select.cuda="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.select__cuda"
  alias lsd-select.gcc="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.select__gcc"
  alias lsd-select.bazel="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.select__bazel"
  ##
  alias lsd-apt.search="bash ${LSCRIPTS}/exec_cmd.sh cmd=_apt_.search"
  alias lsd-apt.guess="bash ${LSCRIPTS}/exec_cmd.sh cmd=_apt_.guess"
  alias lsd-apt.ppa-add="bash ${LSCRIPTS}/exec_cmd.sh cmd=_apt_.add-repo"
  alias lsd-apt.ppa-list="bash ${LSCRIPTS}/exec_cmd.sh cmd=_apt_.get-repo ls"
  alias lsd-apt.ppa-remove="bash ${LSCRIPTS}/exec_cmd.sh cmd=_apt_.get-repo rm"
  ##
  alias lsd-date.timestamp="bash ${LSCRIPTS}/exec_cmd.sh cmd=_date_.get__timestamp"
  alias lsd-date.timestamp.millisec="bash ${LSCRIPTS}/exec_cmd.sh cmd=_date_.get__timestamp_millisec"
  alias lsd-date.timestamp.microsec="bash ${LSCRIPTS}/exec_cmd.sh cmd=_date_.get__timestamp_microsec"
  alias lsd-date.timestamp.nanosec="bash ${LSCRIPTS}/exec_cmd.sh cmd=_date_.get__timestamp_nanosec"
  ##
  alias lsd-system.cpu.cores="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.get__cpu_cores"
  alias lsd-system.cpu.threads="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.get__numthreads"
  alias lsd-system.ip="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.get__ip"
  alias lsd-system.df.json="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.df_json"
  alias lsd-system.osinfo="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.get__osinfo"
  ##
  alias lsd-cfg.system="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.get__vars"
  alias lsd-cfg.color="bash ${LSCRIPTS}/exec_cmd.sh cmd=_color_.get__vars"
  alias lsd-cfg.typeformats="bash ${LSCRIPTS}/exec_cmd.sh cmd=_typeformats_.get__vars"
  ##
  alias lsd-docker.container.delete-byimage="bash ${LSCRIPTS}/exec_cmd.sh cmd=_docker_.container_delete_byimage $@"
  alias lsd-docker.container.delete-all="bash ${LSCRIPTS}/exec_cmd.sh cmd=_docker_.container_delete_all"
  alias lsd-docker.container.stop-all="bash ${LSCRIPTS}/exec_cmd.sh cmd=_docker_.container_stop_all"
  alias lsd-docker.container.list-ids-all="bash ${LSCRIPTS}/exec_cmd.sh cmd=_docker_.list_container_ids_all"
  alias lsd-docker.container.list-ids="bash ${LSCRIPTS}/exec_cmd.sh cmd=_docker_.list_container_ids"
  alias lsd-docker.container.list="bash ${LSCRIPTS}/exec_cmd.sh cmd=_docker_.list_container_all"
  alias lsd-docker.container.exec-byname="bash ${LSCRIPTS}/exec_cmd.sh cmd=_docker_.list_container_exec"
  alias lsd-docker.container.status="bash ${LSCRIPTS}/exec_cmd.sh cmd=_docker_.list_container_status"
  alias lsd-docker.container.test="bash ${LSCRIPTS}/exec_cmd.sh cmd=_docker_.container_test"
  ##
  alias lsd-id.filename="bash ${LSCRIPTS}/exec_cmd.sh cmd=_fio_.filename"
  alias lsd-id.filename-tmp="bash ${LSCRIPTS}/exec_cmd.sh cmd=_fio_.filename-tmp"
  ##
  alias lsd-stack.list="bash ${LSCRIPTS}/exec_cmd.sh cmd=_stack_.list $@"
  ## snippet alias
  alias lsd-cmd.dummy="bash ${LSCRIPTS}/snippets/dummy.sh"
  alias lsd-cmd.git.get.repo-urls="bash ${LSCRIPTS}/snippets/git.get.repo-urls.sh"
  alias lsd-cmd.git.repoviz="bash ${LSCRIPTS}/snippets/git.repoviz.sh"
  alias lsd-cmd.gitlab.get.cert="bash ${LSCRIPTS}/snippets/gitlab.get.cert.sh"
  alias lsd-cmd.menu-navigation="bash ${LSCRIPTS}/snippets/menu-navigation.sh"
  alias lsd-cmd.monitoring-cmds="bash ${LSCRIPTS}/snippets/monitoring-cmds.sh"
  alias lsd-cmd.mount.smb="bash ${LSCRIPTS}/snippets/mount.smb.sh"
  alias lsd-cmd.mount.ssh="bash ${LSCRIPTS}/snippets/mount.ssh.sh"
  alias lsd-cmd.pm="bash ${LSCRIPTS}/snippets/pm.sh"
  alias lsd-cmd.ppa.get.repo="bash ${LSCRIPTS}/snippets/ppa.get.repo.sh"
  alias lsd-cmd.python.venvname.generate="bash ${LSCRIPTS}/snippets/python.venvname.generate.sh"
  alias lsd-cmd.python.list.venv="bash ${LSCRIPTS}/snippets/python.list.venv.sh"
  ## tests alias
  # alias lsd-test.all="bash ${LSCRIPTS}/tests/test.all.sh"
  alias lsd-test.argparse="bash ${LSCRIPTS}/tests/test.argparse.sh"
  alias lsd-test.cuda_config_supported="bash ${LSCRIPTS}/tests/test.cuda_config_supported.sh"
  alias lsd-test._dir_="bash ${LSCRIPTS}/tests/test._dir_.sh"
  alias lsd-test.echo="bash ${LSCRIPTS}/tests/test.echo.sh Namaste "
  alias lsd-test._fio_="bash ${LSCRIPTS}/tests/test._fio_.sh"
  alias lsd-test._log_="bash ${LSCRIPTS}/tests/test._log_.sh"
  alias lsd-test._system_="bash ${LSCRIPTS}/tests/test._system_.sh"
}


lscripts.alias.main "$@"
