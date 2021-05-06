FROM platerecognizer/alpr:latest
ADD file:08e718ed0796013f5957a1be7da3bef6225f3d82d8be0a86a7114e5caad50cbc in /
RUN /bin/sh -c [ -z "$(apt-get indextargets)" ]
RUN /bin/sh -c set -xe    \
    && echo '#!/bin/sh' > /usr/sbin/policy-rc.d   \
    && echo 'exit 101' >> /usr/sbin/policy-rc.d   \
    && chmod +x /usr/sbin/policy-rc.d     \
    && dpkg-divert --local --rename --add /sbin/initctl   \
    && cp -a /usr/sbin/policy-rc.d /sbin/initctl  \
    && sed -i 's/^exit.*/exit 0/' /sbin/initctl     \
    && echo 'force-unsafe-io' > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup     \
    && echo 'DPkg::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' > /etc/apt/apt.conf.d/docker-clean   \
    && echo 'APT::Update::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' >> /etc/apt/apt.conf.d/docker-clean   \
    && echo 'Dir::Cache::pkgcache ""; Dir::Cache::srcpkgcache "";' >> /etc/apt/apt.conf.d/docker-clean    \
    && echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/docker-no-languages    \
    && echo 'Acquire::GzipIndexes "true"; Acquire::CompressionTypes::Order:: "gz";' > /etc/apt/apt.conf.d/docker-gzip-indexes     \
    && echo 'Apt::AutoRemove::SuggestsImportant "false";' > /etc/apt/apt.conf.d/docker-autoremove-suggests
RUN /bin/sh -c mkdir -p /run/systemd \
    && echo 'docker' > /run/systemd/container
CMD ["/bin/bash"]
ARG USE_PYTHON_3_NOT_2
ARG _PY_SUFFIX=3
ARG PYTHON=python3
ARG PIP=pip3
ENV LANG=C.UTF-8
RUN |4 PIP=pip3 PYTHON=python3 USE_PYTHON_3_NOT_2=1 _PY_SUFFIX=3 /bin/sh -c apt-get update \
    && apt-get install -y     ${PYTHON}     ${PYTHON}-pip
RUN |4 PIP=pip3 PYTHON=python3 USE_PYTHON_3_NOT_2=1 _PY_SUFFIX=3 /bin/sh -c ${PIP} --no-cache-dir install --upgrade     pip     setuptools
RUN |4 PIP=pip3 PYTHON=python3 USE_PYTHON_3_NOT_2=1 _PY_SUFFIX=3 /bin/sh -c ln -s $(which ${PYTHON}) /usr/local/bin/python
ARG TF_PACKAGE=tensorflow
ARG TF_PACKAGE_VERSION=
RUN |6 PIP=pip3 PYTHON=python3 TF_PACKAGE=tensorflow TF_PACKAGE_VERSION=1.15.2 USE_PYTHON_3_NOT_2=1 _PY_SUFFIX=3 /bin/sh -c ${PIP} install ${TF_PACKAGE}${TF_PACKAGE_VERSION:+==${TF_PACKAGE_VERSION}}
COPY file:047ef865f497d1863e2fed9632d6c6a527e608eeb21737beec7d28fbd7626f09 in /etc/bash.bashrc
RUN |6 PIP=pip3 PYTHON=python3 TF_PACKAGE=tensorflow TF_PACKAGE_VERSION=1.15.2 USE_PYTHON_3_NOT_2=1 _PY_SUFFIX=3 /bin/sh -c chmod a+rwx /etc/bash.bashrc
RUN /bin/sh -c apt update
RUN /bin/sh -c apt install -y curl zlib1g-dev libjpeg-dev
RUN /bin/sh -c pip install --no-cache-dir     Pillow-simd==6.2.2.post1 ntplib requests cryptography tornado==4.5.3 future==0.17.1
RUN /bin/sh -c pip install --no-cache-dir     psutil rollbar==0.14.7
EXPOSE 8080
EXPOSE 8081
ENV TF_CPP_MIN_LOG_LEVEL=3
ENV LD_LIBRARY_PATH=openvino
STOPSIGNAL SIGTERM
WORKDIR /app
RUN /bin/sh -c mkdir /license
VOLUME [/license]
COPY dir:c5558a661aa23d47f5f5433cd956cdbf05a51cfbe7ef0d2dedf75100f5673e2d in /app/openvino
COPY dir:ce916613b1ac109f6c6c4eff50b30e4e482555650053c18c5980335ce643b3ca in /app
CMD ["./start.sh"]
