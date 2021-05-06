#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## docker:: create container for platerecognizer
###----------------------------------------------------------

# docker run -e TOKEN=$(uuid) --rm platerecognizer/alpr:latest /bin/bash
# /license

docker run -d -it \
  --name platerecognizer \
  --net host \
  --add-host alpr-docker:127.0.0.1 \
  --hostname $(hostname) \
  --shm-size 2G \
  -e TOKEN=$(uuid) \
  -e DISPLAY=:0 \
  -e HOST_PERMS=$(id -u):$(id -g) \
  -e HUSER=${HUSER} \
  -e HUSER_ID=${HUSER_ID} \
  -e HUSER_GRP=${HUSER_GRP} \
  -e HUSER_GRP_ID=${HUSER_GRP_ID} \
  -e DUSER=${USER} \
  -e DUSER_ID=$(id -u ${DUSER}) \
  -e DUSER_GRP=$(id -gn ${DUSER}) \
  -e DUSER_GRP_ID=$(id -g ${DUSER}) \
  -e DUSER_HOME=/home/${USER} \
  -v ${HOME}/.cache:${HOME}/.cache \
  -v /dev:/dev \
  -v /media:/media \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  -v /etc/localtime:/etc/localtime:ro \
  -v /usr/src:/usr/src \
  -v /lib/modules:/lib/modules \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /:/aimldl-dat/temp/platerecognizer \
  platerecognizer/alpr:latest


# [{'Comment': '', 'Created': 1598340031, 'CreatedBy': '/bin/sh -c #(nop)  CMD ["./start.sh"]', 'Id': 'sha256:9abf16d571c2fb5bc6152cdb471d5d4cfe8ddd6631ff765e743211d4c9c68857', 'Size': 0, 'Tags': ['platerecognizer/alpr:latest']}, {'Comment': '', 'Created': 1598340030, 'CreatedBy': '/bin/sh -c #(nop) COPY dir:ce916613b1ac109f6c6c4eff50b30e4e482555650053c18c5980335ce643b3ca in /app ', 'Id': '<missing>', 'Size': 77921200, 'Tags': None}, {'Comment': '', 'Created': 1594113002, 'CreatedBy': '/bin/sh -c #(nop) COPY dir:c5558a661aa23d47f5f5433cd956cdbf05a51cfbe7ef0d2dedf75100f5673e2d in /app/openvino ', 'Id': '<missing>', 'Size': 101654386, 'Tags': None}, {'Comment': '', 'Created': 1594113001, 'CreatedBy': '/bin/sh -c #(nop)  VOLUME [/license]', 'Id': '<missing>', 'Size': 0, 'Tags': None}, {'Comment': '', 'Created': 1594113001, 'CreatedBy': '/bin/sh -c mkdir /license', 'Id': '<missing>', 'Size': 0, 'Tags': None}, {'Comment': '', 'Created': 1594112999, 'CreatedBy': '/bin/sh -c #(nop) WORKDIR /app', 'Id': '<missing>', 'Size': 0, 'Tags': None}, {'Comment': '', 'Created': 1594112999, 'CreatedBy': '/bin/sh -c #(nop)  STOPSIGNAL SIGTERM', 'Id': '<missing>', 'Size': 0, 'Tags': None}, {'Comment': '', 'Created': 1594112999, 'CreatedBy': '/bin/sh -c #(nop)  ENV LD_LIBRARY_PATH=openvino', 'Id': '<missing>', 'Size': 0, 'Tags': None}, {'Comment': '', 'Created': 1594112999, 'CreatedBy': '/bin/sh -c #(nop)  ENV TF_CPP_MIN_LOG_LEVEL=3', 'Id': '<missing>', 'Size': 0, 'Tags': None}, {'Comment': '', 'Created': 1594112998, 'CreatedBy': '/bin/sh -c #(nop)  EXPOSE 8081', 'Id': '<missing>', 'Size': 0, 'Tags': None}, {'Comment': '', 'Created': 1594112998, 'CreatedBy': '/bin/sh -c #(nop)  EXPOSE 8080', 'Id': '<missing>', 'Size': 0, 'Tags': None}, {'Comment': '', 'Created': 1594112998, 'CreatedBy': '/bin/sh -c pip install --no-cache-dir     psutil rollbar==0.14.7', 'Id': '<missing>', 'Size': 2039241, 'Tags': None}, {'Comment': '', 'Created': 1592814953, 'CreatedBy': '/bin/sh -c pip install --no-cache-dir     Pillow-simd==6.2.2.post1 ntplib requests cryptography tornado==4.5.3 future==0.17.1', 'Id': '<missing>', 'Size': 11730869, 'Tags': None}, {'Comment': '', 'Created': 1592814929, 'CreatedBy': '/bin/sh -c apt install -y curl zlib1g-dev libjpeg-dev', 'Id': '<missing>', 'Size': 6052133, 'Tags': None}, {'Comment': '', 'Created': 1592814923, 'CreatedBy': '/bin/sh -c apt update', 'Id': '<missing>', 'Size': 8131275, 'Tags': None}, {'Comment': '', 'Created': 1580151950, 'CreatedBy': '|6 PIP=pip3 PYTHON=python3 TF_PACKAGE=tensorflow TF_PACKAGE_VERSION=1.15.2 USE_PYTHON_3_NOT_2=1 _PY_SUFFIX=3 /bin/sh -c chmod a+rwx /etc/bash.bashrc', 'Id': '<missing>', 'Size': 1766, 'Tags': None}, {'Comment': '', 'Created': 1580151949, 'CreatedBy': '/bin/sh -c #(nop) COPY file:047ef865f497d1863e2fed9632d6c6a527e608eeb21737beec7d28fbd7626f09 in /etc/bash.bashrc ', 'Id': '<missing>', 'Size': 1766, 'Tags': None}, {'Comment': '', 'Created': 1580151948, 'CreatedBy': '|6 PIP=pip3 PYTHON=python3 TF_PACKAGE=tensorflow TF_PACKAGE_VERSION=1.15.2 USE_PYTHON_3_NOT_2=1 _PY_SUFFIX=3 /bin/sh -c ${PIP} install ${TF_PACKAGE}${TF_PACKAGE_VERSION:+==${TF_PACKAGE_VERSION}}', 'Id': '<missing>', 'Size': 704003337, 'Tags': None}, {'Comment': '', 'Created': 1580151915, 'CreatedBy': '/bin/sh -c #(nop)  ARG TF_PACKAGE_VERSION=', 'Id': '<missing>', 'Size': 0, 'Tags': None}, {'Comment': '', 'Created': 1580151915, 'CreatedBy': '/bin/sh -c #(nop)  ARG TF_PACKAGE=tensorflow', 'Id': '<missing>', 'Size': 0, 'Tags': None}, {'Comment': '', 'Created': 1580151915, 'CreatedBy': '|4 PIP=pip3 PYTHON=python3 USE_PYTHON_3_NOT_2=1 _PY_SUFFIX=3 /bin/sh -c ln -s $(which ${PYTHON}) /usr/local/bin/python', 'Id': '<missing>', 'Size': 16, 'Tags': None}, {'Comment': '', 'Created': 1580151914, 'CreatedBy': '|4 PIP=pip3 PYTHON=python3 USE_PYTHON_3_NOT_2=1 _PY_SUFFIX=3 /bin/sh -c ${PIP} --no-cache-dir install --upgrade     pip     setuptools', 'Id': '<missing>', 'Size': 10690980, 'Tags': None}, {'Comment': '', 'Created': 1580151909, 'CreatedBy': '|4 PIP=pip3 PYTHON=python3 USE_PYTHON_3_NOT_2=1 _PY_SUFFIX=3 /bin/sh -c apt-get update && apt-get install -y     ${PYTHON}     ${PYTHON}-pip', 'Id': '<missing>', 'Size': 404908006, 'Tags': None}, {'Comment': '', 'Created': 1580151842, 'CreatedBy': '/bin/sh -c #(nop)  ENV LANG=C.UTF-8', 'Id': '<missing>', 'Size': 0, 'Tags': None}, {'Comment': '', 'Created': 1580151842, 'CreatedBy': '/bin/sh -c #(nop)  ARG PIP=pip3', 'Id': '<missing>', 'Size': 0, 'Tags': None}, {'Comment': '', 'Created': 1580151842, 'CreatedBy': '/bin/sh -c #(nop)  ARG PYTHON=python3', 'Id': '<missing>', 'Size': 0, 'Tags': None}, {'Comment': '', 'Created': 1580151842, 'CreatedBy': '/bin/sh -c #(nop)  ARG _PY_SUFFIX=3', 'Id': '<missing>', 'Size': 0, 'Tags': None}, {'Comment': '', 'Created': 1580151652, 'CreatedBy': '/bin/sh -c #(nop)  ARG USE_PYTHON_3_NOT_2', 'Id': '<missing>', 'Size': 0, 'Tags': None}, {'Comment': '', 'Created': 1579137634, 'CreatedBy': '/bin/sh -c #(nop)  CMD ["/bin/bash"]', 'Id': '<missing>', 'Size': 0, 'Tags': None}, {'Comment': '', 'Created': 1579137634, 'CreatedBy': "/bin/sh -c mkdir -p /run/systemd && echo 'docker' > /run/systemd/container", 'Id': '<missing>', 'Size': 7, 'Tags': None}, {'Comment': '', 'Created': 1579137633, 'CreatedBy': '/bin/sh -c set -xe \t\t&& echo \'#!/bin/sh\' > /usr/sbin/policy-rc.d \t&& echo \'exit 101\' >> /usr/sbin/policy-rc.d \t&& chmod +x /usr/sbin/policy-rc.d \t\t&& dpkg-divert --local --rename --add /sbin/initctl \t&& cp -a /usr/sbin/policy-rc.d /sbin/initctl \t&& sed -i \'s/^exit.*/exit 0/\' /sbin/initctl \t\t&& echo \'force-unsafe-io\' > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup \t\t&& echo \'DPkg::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };\' > /etc/apt/apt.conf.d/docker-clean \t&& echo \'APT::Update::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };\' >> /etc/apt/apt.conf.d/docker-clean \t&& echo \'Dir::Cache::pkgcache ""; Dir::Cache::srcpkgcache "";\' >> /etc/apt/apt.conf.d/docker-clean \t\t&& echo \'Acquire::Languages "none";\' > /etc/apt/apt.conf.d/docker-no-languages \t\t&& echo \'Acquire::GzipIndexes "true"; Acquire::CompressionTypes::Order:: "gz";\' > /etc/apt/apt.conf.d/docker-gzip-indexes \t\t&& echo \'Apt::AutoRemove::SuggestsImportant "false";\' > /etc/apt/apt.conf.d/docker-autoremove-suggests', 'Id': '<missing>', 'Size': 745, 'Tags': None}, {'Comment': '', 'Created': 1579137632, 'CreatedBy': '/bin/sh -c [ -z "$(apt-get indextargets)" ]', 'Id': '<missing>', 'Size': 987485, 'Tags': None}, {'Comment': '', 'Created': 1579137631, 'CreatedBy': '/bin/sh -c #(nop) ADD file:08e718ed0796013f5957a1be7da3bef6225f3d82d8be0a86a7114e5caad50cbc in / ', 'Id': '<missing>', 'Size': 63206511, 'Tags': None}]
