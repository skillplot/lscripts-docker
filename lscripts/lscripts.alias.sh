#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Alias for system configurations and convenience utilities
##----------------------------------------------------------
#
## References:
## https://stackoverflow.com/questions/7131670/make-a-bash-alias-that-takes-a-parameter
## https://stackoverflow.com/questions/2013547/assigning-default-values-to-shell-variables-with-a-single-command-in-bash
## https://github.com/mrbvrz/cheat-sheet/blob/master/cheat/install-pbcopy-pbpaste-ubuntu.md
###----------------------------------------------------------


function lsd-lscripts.alias.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  ###-------
  alias lt='ls -lrth'
  alias l='ls -lrth'
  alias lpwd='ls -d -1 ${PWD}/*'
  alias lpwdf='ls -d -1 ${PWD}/*.*'
  ##
  alias pbcopy='xsel --clipboard --input'
  alias pbpaste='xsel --clipboard --output'
  ###-------
  alias lsd-cd="cd ${LSCRIPTS}"
  ###----------------------------------------------------------
  ## lsd-python => _python_ module
  ###----------------------------------------------------------
  alias lsd-python.venv.name="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.python.venv.name $@"
  alias lsd-python.venv.list="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.python.venv.list $@"
  alias lsd-python.path="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.python.path $@"
  alias lsd-python.list="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.python.list $@"
  alias lsd-python.find_vers="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.python.find_vers $@"
  ##
  # alias lsd-python.create.virtualenv="source ${LSCRIPTS}/python-virtualenvwrapper-install.sh"
  alias lsd-python.create.virtualenv="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.python.virtualenvwrapper.create $@"
  alias lsd-python.test.virtualenv="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.python.virtualenvwrapper.test $@"
  ##
  alias lsd-python.create.condaenv="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.python.conda.create $@"
  alias lsd-python.create.condaenv-hpc="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.python.conda.create.hpc $@"
  ##
  alias lsd-python.kill="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.kill.python"
  alias lsd-python.ls.pycache="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.ls.pycache"
  alias lsd-python.ls.egg="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.ls.egg"
  alias lsd-python.rm.pycache="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.rm.pycache"
  alias lsd-python.rm.egg="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.rm.egg"
  ##
  alias lsd-python.libs.test-pytorch="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.python.libs.test-pytorch $@"
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
  ## lsd-gh => _gh_ module
  ###----------------------------------------------------------
  alias lsd-github.auth="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.gh.auth $@"
  alias lsd-github.view="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.gh.view $@"
  alias lsd-github.push="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.gh.push $@"
  alias lsd-github.set-url-https="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.gh.set-url-https $@"
  alias lsd-github.set-url-ssh="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.gh.set-url-ssh $@"

  alias lsd-github.create-repo="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.gh.create-repo $@"
  alias lsd-github.create-org-repo="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.gh.create-org-repo $@"

  alias lsd-github.copy-gitignore="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.gh.copy-gitignore $@"
  alias lsd-github.copy-gitattributes="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.gh.copy-gitattributes $@"

  alias lsd-github.create-pages="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.gh.create-pages $@"
  alias lsd-github.delete-pages="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.gh.delete-pages $@"
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
  alias lsd-cuda.find_vers="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.cuda.find_vers $@"
  alias lsd-cuda.admin.__purge_cuda_stack="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.lsd-mod.cuda.purge_cuda_stack $@"
  alias lsd-cuda.select="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.system.select__cuda $@"
  alias lsd-cuda.config="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.cuda.cuda-config $@"
  alias lsd-cuda.verify="bash ${LSCRIPTS}/cuda-stack-verify.sh"
  alias lsd-cuda.addrepo-key="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.cuda.addrepo-key $@"
  alias lsd-cuda.addrepo="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.cuda.addrepo $@"
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
  alias lsd-date.get="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.date.get"
  alias lsd-date.get-full="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.date.get__full"
  alias lsd-date.get-blog="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.date.get__blog"
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
  alias lsd-system.ip-public="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.system.get__ip-public"
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
  alias lsd-docker.verify="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docker.verify"
  ###-------
  alias lsd-docker.get.local_volumes="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docker.local_volumes"
  alias lsd-docker.get.port_maps="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docker.port_maps"
  alias lsd-docker.get.envvars="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docker.envvars"
  alias lsd-docker.get.restart_policy="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docker.restart_policy"
  alias lsd-docker.get.enable_nvidia_gpu="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docker.enable_nvidia_gpu"
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
  alias lsd-docker.container.create="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docker.container.create $@"
  ###-------
  alias lsd-docker.image.build-dev-ubuntu22.04="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docker.image.build --from=ubuntu:22.04"
  alias lsd-docker.image.build.skplt-dev.min="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docker.image.build $@"
  ###-------
  alias lsd-docker.user.fix="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docker.userfix $@"
  alias lsd-docker.user.add2sudoer="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docker.adduser_to_sudoer $@"
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
  alias lsd-lcd="source ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.lcd $@"
  ###-------
  alias lsd-utils.youtube-download-mp3="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.youtube-download-mp3"
  alias lsd-utils.count-lines="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.count-lines"
  alias lsd-utils.random="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.random"
  alias lsd-utils.size="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.size"
  alias lsd-utils.pid="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.pid"
  alias lsd-utils.kill="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.kill"
  alias lsd-utils.kill.python="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.kill.python"
  alias lsd-utils.ls="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.ls"
  alias lsd-utils.lsdir="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.lsdir"
  alias lsd-utils.ls.pycache="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.ls.pycache"
  alias lsd-utils.ls.egg="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.ls.egg"
  alias lsd-utils.rm.pycache="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.rm.pycache"
  alias lsd-utils.rm.egg="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.rm.egg"
  alias lsd-utils.rm.node_modules="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.rm.node_modules"
  alias lsd-utils.rm._site="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.rm._site"
  alias lsd-utils.trash="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.trash"
  alias lsd-utils.image.resize="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.image.resize"
  alias lsd-utils.image.pdf="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.image.pdf"
  alias lsd-utils.image.tiff2cog="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.image.tiff2cog"
  alias lsd-utils.date.get="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.date.get"
  alias lsd-utils.convert-utf8="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.convert-utf8"
  alias lsd-utils.system.info="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.system.info"
  alias lsd-utils.id.salt="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.id.salt"
  alias lsd-utils.id.get="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.id.get"
  alias lsd-utils.id.uuid="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.id.uuid"
  alias lsd-utils.id.filename="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.id.filename"
  alias lsd-utils.id.filename-tmp="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.id.filename-tmp"
  alias lsd-utils.cmds="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.cmds lsd"
  alias lsd-utils.python.venvname="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.python.venvname $@"
  alias lsd-utils.pdf.images="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.pdf.images"
  ###---utils.epoch
  alias lsd-utils.epoch._normalize_secs="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.epoch._normalize_secs $@"
  alias lsd-utils.epoch.to-utc="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.epoch.to-utc $@"
  alias lsd-utils.epoch.to-local="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.epoch.to-local $@"
  alias lsd-utils.epoch.show="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.epoch.show $@"
  ###---TODO: move to _tmux_ module
  alias lsd-tmux.4p="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.tmux-4pane"
  alias lsd-tmux.3p="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.utils.tmux-3pane"
  ###----------------------------------------------------------
  ## lsd-docs => _docs_ module
  ###----------------------------------------------------------
  alias lsd-docs.mkdocs="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docs.mkdocs $@"
  alias lsd-docs.asciidoc.create_pdf="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docs.asciidoc.create_pdf $@"
  alias lsd-docs.mkdocs.link="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docs.mkdocs.link $@"
  alias lsd-docs.mkdocs.deploy="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docs.mkdocs.deploy $@"
  alias lsd-docs.admin.update="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docs.update $@"
  alias lsd-docs.cmds="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docs.update.get__cmds $@"
  alias lsd-docs.markdown2latex="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docs.pandoc.markdown2latex $@"
  ###---
  alias lsd-search-cmds="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.docs.search.cmds $@"
  ###----------------------------------------------------------
  ## lsd-systemd => _systemd_ module
  ###----------------------------------------------------------
  alias lsd-systemd.list-enabled="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.systemd.list-enabled"
  alias lsd-systemd.list-running="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.systemd.list-running"
  alias lsd-systemd.list-active="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.systemd.list-active"
  alias lsd-systemd.list-all="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.systemd.list-all"
  #
  alias lsd-systemd.list-dependencies="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.systemd.list-dependencies $@"
  alias lsd-systemd.cat="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.systemd.cat $@"
  alias lsd-systemd.nvm-config="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.systemd.nvm.create-service-config $@"
  ###----------------------------------------------------------
  ## lsd-crypto => _crypto_ module
  ###----------------------------------------------------------
  alias lsd-crypto.keygen="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.crypto.ssh-keygen $@"
  alias lsd-crypto.encrypt="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.crypto.openssl-encrypt $@"
  alias lsd-crypto.decrypt="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.crypto.openssl-decrypt $@"
  alias lsd-crypto.copykey="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.crypto.ssh-copy-id $@"
  ###----------------------------------------------------------
  ## lsd-virtualbox => _virtualbox_ module
  ###----------------------------------------------------------
  alias lsd-virtualbox.create-vm="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.virtualbox.create-vm $@"
  ###----------------------------------------------------------
  ## lsd-perf => _perf_ module
  ###----------------------------------------------------------
  alias lsd-perf.time="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.perf.time $@"
  alias lsd-perf.time-verbose="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.perf.time-verbose $@"
  alias lsd-perf.time-append="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.perf.time-append $@"
  alias lsd-perf.psrecord="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.perf.psrecord $@"
  ###----------------------------------------------------------
  ## lsd-www => _www_ module
  ###----------------------------------------------------------
  ###---www.clone-site
  alias lsd-www.clone-site.static="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.www.clone-site.static $@"
  alias lsd-www.clone-site.capture-website="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.www.clone-site.capture-website $@"
  alias lsd-www.clone-site.browsertrix="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.www.clone-site.browsertrix $@"
  alias lsd-www.clone-site.list="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.www.clone-site.list $@"
  alias lsd-www.site-info="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.www.site.info $@"
  alias lsd-www.site-fingerprint="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.www.site.fingerprint $@"
  ###----------------------------------------------------------
  ## lsd-hpc => _hpc_ module
  ###----------------------------------------------------------
  ### GROUP 1: SUBMIT
  alias lsd-hpc.submit.generate-slurm-template="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.submit.generate-slurm-template $@"
  alias lsd-hpc.submit.run-job="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.submit.run-job $@"
  alias lsd-hpc.submit.run-sh="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.submit.run-sh $@"
  alias lsd-hpc.submit.run-py="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.submit.run-py $@"
  alias lsd-hpc.submit.run-batch="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.submit.run-batch $@"
  alias lsd-hpc.submit.run-dependent="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.submit.run-dependent $@"
  ### GROUP 2: MONITOR
  alias lsd-hpc.monitor.list-jobs="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.monitor.list-jobs $@"
  alias lsd-hpc.monitor.describe-job="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.monitor.describe-job $@"
  alias lsd-hpc.monitor.tail-job="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.monitor.tail-job $@"
  alias lsd-hpc.monitor.history="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.monitor.history $@"
  alias lsd-hpc.monitor.stats="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.monitor.stats $@"
  ### GROUP 3: MANAGE
  alias lsd-hpc.manage.cancel-job="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.manage.cancel-job $@"
  alias lsd-hpc.manage.cancel-all="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.manage.cancel-all $@"
  alias lsd-hpc.manage.requeue-job="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.manage.requeue-job $@"
  alias lsd-hpc.manage.purge-old="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.manage.purge-old $@"
  alias lsd-hpc.manage.resubmit="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.manage.resubmit $@"
  ### GROUP 4: AUDIT
  alias lsd-hpc.audit.save-job-metadata="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.audit.save-job-metadata $@"
  alias lsd-hpc.audit.load-job-metadata="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.audit.load-job-metadata $@"
  alias lsd-hpc.audit.export-report="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.audit.export-report $@"
  alias lsd-hpc.audit.view-log="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.audit.view-log $@"
  alias lsd-hpc.audit.summary="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.audit.summary $@"
  ### GROUP 5: RESOURCE
  alias lsd-hpc.resource.cluster-status="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.resource.cluster-status $@"
  alias lsd-hpc.resource.list-gpus="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.resource.list-gpus $@"
  alias lsd-hpc.resource.list-partitions="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.resource.list-partitions $@"
  alias lsd-hpc.resource.user-quota="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.resource.user-quota $@"
  alias lsd-hpc.resource.capacity-overview="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.resource.capacity-overview $@"
  ### GROUP 6: SCHEDULE
  alias lsd-hpc.schedule.chain-jobs="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.schedule.chain-jobs $@"
  alias lsd-hpc.schedule.schedule-job="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.schedule.schedule-job $@"
  alias lsd-hpc.schedule.batch-submit="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.schedule.batch-submit $@"
  alias lsd-hpc.schedule.workflow="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.schedule.workflow $@"
  ### GROUP 7: HELP
  alias lsd-hpc.help.main="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.help.main $@"
  alias lsd-hpc.help.submit="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.help.submit $@"
  alias lsd-hpc.help.monitor="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.help.monitor $@"
  alias lsd-hpc.help.manage="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.help.manage $@"
  alias lsd-hpc.help.audit="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.help.audit $@"
  alias lsd-hpc.help.resource="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.help.resource $@"
  alias lsd-hpc.help.schedule="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.help.schedule $@"
  ### GROUP 8: TEST
  alias lsd-hpc.test.env="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.test.env $@"
  alias lsd-hpc.test.template="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.test.template $@"
  alias lsd-hpc.test.submit-dryrun="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.test.submit-dryrun $@"
  alias lsd-hpc.test.all="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.test.all $@"
  ### GROUP 9: DEBUG
  alias lsd-hpc.debug.env="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.debug.env $@"
  alias lsd-hpc.debug.job-context="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.debug.job-context $@"
  alias lsd-hpc.debug.show-template="bash ${LSCRIPTS}/exec_cmd.sh cmd=lsd-mod.hpc.debug.show-template $@"
  ###----------------------------------------------------------
}
