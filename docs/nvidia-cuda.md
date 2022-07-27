---
title: Nvidia CUDA
description: Nvidia CUDA stack installation and troubleshooting
---


# Nvidia CUDA


## Nvidia DRIVER versions

* 440 10.2
* 445 11.0
* 450 11.1
* 455 11.2
* 460 11.3
* 470 11.4
* 510 11.6
* 510 11.7



## LSD commands

* Find cuda compatible stack versions
    ```bash
    lsd-cuda.find_vers --cuda=11.1
    ```
* Cuda stack installation
    ```bash
    lsd-install.cuda-stack --cuda=11.1
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
