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


function lsd-lscripts.alias.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  ###-------
  alias lt='ls -lrth'
  alias l='ls -lrth'
  alias lpwd='ls -d -1 ${PWD}/*'
  alias lpwdf='ls -d -1 ${PWD}/*.*'
  ###-------
  alias lsd-cd="cd ${LSCRIPTS}"
  ###----------------------------------------------------------
  ## lsd-python => _python_ module
  ###----------------------------------------------------------
  alias lsd-python.venv.name="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.python.venv.name $@"
  alias lsd-python.venv.list="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.python.venv.list $@"
  ##
  alias lsd-python.create.virtualenv="source ${LSCRIPTS}/python-virtualenvwrapper-install.sh"
  ##
  alias lsd-python.kill="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.kill.python"
  alias lsd-python.ls.pycache="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.ls.pycache"
  alias lsd-python.ls.egg="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.ls.egg"
  alias lsd-python.rm.pycache="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.rm.pycache"
  alias lsd-python.rm.egg="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.rm.egg"
  ###----------------------------------------------------------
  ## lsd-admin
  ###----------------------------------------------------------
  alias lsd-admin.mkdir-datadirs="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.dir.admin.mkdir-datadirs"
  alias lsd-admin.mkdir-osdirs="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.dir.admin.mkdir-osdirs"
  alias lsd-admin.mkalias-datadirs="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.dir.admin.mkalias-datadirs"
  alias lsd-admin.mkalias-osdirs="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.dir.admin.mkalias-osdirs"
  ###-------
  alias lsd-admin.create-login-user="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.system.admin.create-login-user $@"
  alias lsd-admin.create-nologin-user="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.system.admin.create-nologin-user $@"
  alias lsd-admin.restrict-cmds-for-sudo-user="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.system.admin.restrict-cmds-for-sudo-user $@"
  ###----------------------------------------------------------
  ## lsd-cfg => from different module
  ###----------------------------------------------------------
  alias lsd-cfg.color="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.color.get__vars"
  alias lsd-cfg.docker="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docker.get__vars"
  alias lsd-cfg.nvidia="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.nvidia.get__vars"
  alias lsd-cfg.system="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.system.get__vars"
  alias lsd-cfg.typeformats="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.typeformats.get__vars"
  alias lsd-cfg.basepath="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.dir.basepath.get__vars"
  ###----------------------------------------------------------
  ## lsd-git => _git_ module
  ###----------------------------------------------------------
  alias lsd-git.pull="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.git-pull"
  alias lsd-git.repo-pull="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.git.repo-pull"
  ###----------------------------------------------------------
  ## lsd-nvidia => _nvidia_ module
  ###----------------------------------------------------------
  alias lsd-nvidia.cfg="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.nvidia.get__vars"
  alias lsd-nvidia.gpu.info="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.nvidia.get__driver_info"
  alias lsd-nvidia.gpu.stats="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.nvidia.get__gpu_stats $1"
  alias lsd-nvidia.driver.avail="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.nvidia.get__driver_avail"
  ###----------------------------------------------------------
  ## lsd-cuda => _cuda_ module
  ###----------------------------------------------------------
  alias lsd-cuda.cfg="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.cuda.get__vars $@"
  alias lsd-cuda.vers="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.cuda.get__cuda_vers $@"
  alias lsd-cuda.avail="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.cuda.get__cuda_vers_avail $@"
  alias lsd-cuda.admin.__purge_cuda_stack="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.lsd-mod.cuda.purge_cuda_stack $@"
  alias lsd-cuda.select="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.system.select__cuda $@"
  alias lsd-cuda.config="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.cuda.cuda-config $@"
  alias lsd-cuda.verify="bash ${LSCRIPTS}/cuda-stack-verify.sh"
  ###----------------------------------------------------------
  ## lsd-apt => _apt_ module
  ###----------------------------------------------------------
  alias lsd-apt.search="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.apt.search"
  alias lsd-apt.guess="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.apt.guess"
  alias lsd-apt.ppa-add="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.apt.add-repo"
  alias lsd-apt.ppa-list="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.apt.get-repo ls"
  alias lsd-apt.ppa-remove="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.apt.get-repo rm"
  ###----------------------------------------------------------
  ## lsd-date => _date_ module
  ###----------------------------------------------------------
  alias lsd-dir.cfg="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.dir.basepath.get__vars"
  alias lsd-dir.get-datadirs-paths="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.dir.get-datadirs-paths"
  alias lsd-dir.get-osdirs-paths="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.dir.get-osdirs-paths"
  ###-------
  alias lsd-dir.admin.mkdir-datadirs="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.dir.admin.mkdir-datadirs"
  alias lsd-dir.admin.mkdir-osdirs="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.dir.admin.mkdir-osdirs"
  alias lsd-dir.admin.mkalias-datadirs="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.dir.admin.mkalias-datadirs"
  alias lsd-dir.admin.mkalias-osdirs="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.dir.admin.mkalias-osdirs"
  ###----------------------------------------------------------
  ## lsd-date => _date_ module
  ###----------------------------------------------------------
  alias lsd-date.cfg="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.typeformats.get__vars"
  alias lsd-date.timestamp="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.date.get__timestamp"
  alias lsd-date.timestamp.millisec="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.date.get__timestamp_millisec"
  alias lsd-date.timestamp.microsec="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.date.get__timestamp_microsec"
  alias lsd-date.timestamp.nanosec="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.date.get__timestamp_nanosec"
  ###----------------------------------------------------------
  ## lsd-system, lsd-select => _system_ module
  ###----------------------------------------------------------
  alias lsd-system.cfg="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.system.get__vars"
  alias lsd-system.cpu.cores="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.system.get__cpu_cores"
  alias lsd-system.cpu.threads="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.system.get__numthreads"
  alias lsd-system.df.json="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.system.df_json"
  alias lsd-system.ip="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.system.get__ip"
  alias lsd-system.osinfo="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.system.get__osinfo"
  alias lsd-system.info="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.system.get__info"
  ###-------
  alias lsd-system.admin.create-login-user="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.system.admin.create-login-user $@"
  alias lsd-system.admin.create-nologin-user="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.system.admin.create-nologin-user $@"
  alias lsd-system.admin.restrict-cmds-for-sudo-user="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.system.admin.restrict-cmds-for-sudo-user $@"
  ###-------
  alias lsd-select.cuda="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.system.select__cuda"
  alias lsd-select.gcc="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.system.select__gcc"
  alias lsd-select.bazel="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.system.select__bazel"
  ###----------------------------------------------------------
  ## lsd-docker => _docker_ module
  ###----------------------------------------------------------
  alias lsd-docker.cfg="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docker.get__vars"
  alias lsd-docker.osvers="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docker.get__os_vers_avail"
  ###-------
  alias lsd-docker.container.delete-all="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docker.container.delete-all"
  alias lsd-docker.container.delete-byimage="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docker.container.delete-byimage $@"
  alias lsd-docker.container.exec="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docker.container.exec"
  alias lsd-docker.container.exec-byname="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docker.container.exec-byname"
  alias lsd-docker.container.list="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docker.container.list"
  alias lsd-docker.container.list-ids="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docker.container.list-ids"
  alias lsd-docker.container.list-ids-all="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docker.container.list-ids-all"
  alias lsd-docker.container.status="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docker.container.status"
  alias lsd-docker.container.stop-all="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docker.container.stop-all"
  alias lsd-docker.container.test="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docker.container.test"
  ###-------
  alias lsd-docker.image.build="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docker.image.build"
  ###----------------------------------------------------------
  ## lsd-stack => _stack_ module
  ###----------------------------------------------------------
  alias lsd-stack.cfg="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.stack.get__vars $@"
  alias lsd-stack.list="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.stack.list $@"
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
  ###----------------------------------------------------------
  ## lsd-test => tests/ package
  ###----------------------------------------------------------
  # alias lsd-test.all="bash ${LSCRIPTS}/tests/test.all.sh"
  alias lsd-test.argparse="bash ${LSCRIPTS}/tests/test.argparse.sh"
  alias lsd-test.cuda_config_supported="bash ${LSCRIPTS}/tests/test.cuda_config_supported.sh"
  alias lsd-test.dir="bash ${LSCRIPTS}/tests/test._dir_.sh"
  alias lsd-test.echo="bash ${LSCRIPTS}/tests/test.echo.sh Namaste "
  alias lsd-test.fio="bash ${LSCRIPTS}/tests/test._fio_.sh"
  alias lsd-test.log="bash ${LSCRIPTS}/tests/test._log_.sh"
  alias lsd-test.system="bash ${LSCRIPTS}/tests/test._system_.sh"
  ###----------------------------------------------------------
  ## lsd-utils => _utils_ module
  ###----------------------------------------------------------
  alias lsd-utils.pid="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.pid"
  alias lsd-utils.kill="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.kill"
  alias lsd-utils.kill.python="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.kill.python"
  alias lsd-utils.ls="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.ls"
  alias lsd-utils.ls.pycache="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.ls.pycache"
  alias lsd-utils.ls.egg="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.ls.egg"
  alias lsd-utils.rm.pycache="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.rm.pycache"
  alias lsd-utils.rm.egg="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.rm.egg"
  alias lsd-utils.trash="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.trash"
  alias lsd-utils.image.resize="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.image.resize"
  alias lsd-utils.image.pdf="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.image.pdf"
  alias lsd-utils.date.get="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.date.get"
  alias lsd-utils.system.info="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.system.info"
  alias lsd-utils.id.salt="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.id.salt"
  alias lsd-utils.id.get="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.id.get"
  alias lsd-utils.id.uuid="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.id.uuid"
  alias lsd-utils.id.filename="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.id.filename"
  alias lsd-utils.id.filename-tmp="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.id.filename-tmp"
}
