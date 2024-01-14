---
title: Nvidia CUDA
description: Nvidia CUDA stack installation and troubleshooting
---


# Nvidia CUDA




## Nvidia DRIVER versions

|Driver Version | Compatibility with CUDA version |
|:---|:---|
|440 | 10.2 |
|445 | 11.0 |
|450 | 11.1 |
|455 | 11.2 |
|460 | 11.3 |
|470 | 11.4 |
|510 | 11.6 |
|510 | 11.7 |
|535 | 12.2 |


## Nvidia CUDA Repos

* Nvidia apt repo limits the cuda < 11.0 version to ubuntu18.04 version and hence, if you want use those versions on OS > 18.04 you would need to set the dist and os version specifically to 18.04 as given below. This has been observed since introduction of CUDA 12.0+ version.


| OS | Minimum cuda support | CUDA Repo |
|:---|:---|:---|
| Ubuntu 18.04 | 10.0 onwards | https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 |
| Ubuntu 20.04 | 11.0 onwards | https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64 |
| Ubuntu 22.04 | 11.8 onwards | https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64 |


* So if you need CUDA verrsion 10.0 and < 11.0 on Ubuntu 20.04; you need to add ubuntu1804 repo and install respective cuda stack compatible versions only. Therefore, you need to provide specific versions for each package for a specific cuda version from that repo, and if you do not mention the version then it wil try to install the latest version and will break the installation.

## LSD commands

`apt-cache search` and `apt-cache policy` commands helps to identify version for different packages. This is simplified in the following commands if you ever need to pick the version manually.

* Find cuda compatible stack versions
    ```bash
    lsd-cuda.find_vers --cuda=11.1
    ```
* Cuda stack installation
    ```bash
    lsd-install.cuda-stack --cuda=11.1
    ```


## CUDA Stack Installation


**NOTE**

* CUDA stack installs: cuda, cudnn and tensorRT with required dependent packages
* It is recommended to install multiple and configure multiple CUDA version due to different CUDA requirements for different frameworks and DNN architectures.
* If you want multiple CUDA version, you ALWAYS needs to install from minimum CUDA version and incrementally install the higher version. This is because the different packages incrementally gets upgraded accordingly preserving the backward compatibility; this behavior is tested to be working OK.
* The version compatibility of different packages for different CUDA version, across different ubuntu OS version has been identified by working out the details and tested on different hardware and GPU versions. And, it's highly recommended to follow the script rather then manual installation of each version.

At the time of this writing [04th Jan 2024]:
* `11.8` cuda-samples is not present
* `11.1` does not have compatible tensortRT packages



### Ubuntu 20.04 LTS

```bash
## 10.0
lsd-install.cuda-stack --dist=ubuntu1804 --os=ubuntu18.04 --cuda=10.0

## 10.2
lsd-install.cuda-stack --dist=ubuntu1804 --os=ubuntu18.04 --cuda=10.2

## 11.0
lsd-install.cuda-stack --dist=ubuntu2004 --os=ubuntu20.04 --cuda=11.0

## 11.1, tensorRT is not available for it
lsd-install.cuda-stack --dist=ubuntu2004 --os=ubuntu20.04 --cuda=11.1

## 11.4
lsd-install.cuda-stack --dist=ubuntu2004 --os=ubuntu20.04 --cuda=11.4

## 11.8
lsd-install.cuda-stack --dist=ubuntu2004 --os=ubuntu20.04 --cuda=11.8


## 12.0 => TODO
```


## Multiple CUDA selection

If you have configured the multiple cuda installation during CUDA stack installation, then you can select which version of CUDA to be used. Only one CUDA version can be activated at a time. It uses `update-alternatives` to configure multiple CUDA version.

```bash
lsd-cuda.select
```


## Errors

```bash
Err:4 https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64  InRelease                              
  The following signatures couldn't be verified because the public key is not available: NO_PUBKEY A4B469963BF863CC

W: GPG error: https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64  InRelease: The following signatures couldn't be verified because the public key is not available: NO_PUBKEY A4B469963BF863CC
E: The repository 'https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64  InRelease' is no longer signed.
N: Updating from such a repository can't be done securely, and is therefore disabled by default.
N: See apt-secure(8) manpage for repository creation and user configuration details.
```
