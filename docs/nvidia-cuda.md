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



## LSD commands

* Find cuda compatible stack versions
    ```bash
    lsd-cuda.find_vers --cuda=11.1
    ```
* Cuda stack installation
    ```bash
    lsd-install.cuda-stack --cuda=11.1
    ```

## CUDA Stack Installation

* Nvidia apt repo limits the cuda < 11.0 version to ubuntu18.04 version and hence, if you want use those versions on OS > 18.04 you would need to set the dist and os version specifically to 18.04 as given below. This has been observed since introduction of CUDA 12.0+ version.


### Ubuntu 20.04 LTS

```bash
## 10.0
lsd-install.cuda-stack --dist=ubuntu1804 --os=ubuntu18.04 --cuda=10.0

## 10.2
lsd-install.cuda-stack --dist=ubuntu1804 --os=ubuntu18.04 --cuda=10.2

## 11.0
lsd-install.cuda-stack --dist=ubuntu2004 --os=ubuntu20.04 --cuda=11.0
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
