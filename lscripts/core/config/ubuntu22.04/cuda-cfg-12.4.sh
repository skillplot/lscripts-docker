#!/bin/bash

## Copyright (c) 2025 mangalbhaskar. All Rights Reserved.
## __author__ = 'mangalbhaskar'
## ----------------------------------------------------------------
## CUDA Stack 12.4, Nvidia Driver: >=550 (Ubuntu 24.04 Noble)
## Compatible with cuDNN 8.9.6, TensorRT 10.0.1, NCCL 2.21.5+
## ----------------------------------------------------------------

local OS="ubuntu24.04"
local CUDA_OS_REL="ubuntu2404"

## ----------------------------------------------------------------
## CUDA
## ----------------------------------------------------------------
local CUDA_VER="12.4"
local CUDA_PKG="${CUDA_VER}.1-1"
local CUDA_REL=$(echo ${CUDA_VER} | tr . -) ## 12-4
local CUDA_VERSION="${CUDA_VER}"

local CUDA_CORE_PKG_VERSION="${CUDA_REL}=${CUDA_PKG}"
local CUDA_PKG_VERSION="${CUDA_CORE_PKG_VERSION}"
local CUDA_CUBLAS_PKG_VERSION="${CUDA_PKG_VERSION}"

local NVML_VERSION="${CUDA_REL}=${CUDA_VER}.127-1"

## ----------------------------------------------------------------
## cuDNN
## ----------------------------------------------------------------
local CUDNN_VER="8"
local CUDNN_MAJOR_VERSION="${CUDNN_VER}"
local CUDNN_VERSION="8.9.6.50"
local CUDNN_PKG="${CUDNN_VERSION}-1+cuda${CUDA_VER}"

## ----------------------------------------------------------------
## NCCL
## ----------------------------------------------------------------
local NCCL_VERSION="2.21.5"
local NCCL_PKG="${NCCL_VERSION}-1+cuda${CUDA_VER}"

## ----------------------------------------------------------------
## TensorRT
## ----------------------------------------------------------------
local TENSORRT_VER="10"
local LIBNVINFER_VERSION="10.0.1"
local LIBNVINFER_PKG="${LIBNVINFER_VERSION}-1+cuda${CUDA_VER}"

## Optional TensorRT Plugins & Parsers
local TENSORRT_PLUGIN_VERSION="10.0.1"
local TENSORRT_PLUGIN_PKG="${TENSORRT_PLUGIN_VERSION}-1+cuda${CUDA_VER}"

## ----------------------------------------------------------------
## AI Frameworks - optional overrides
## ----------------------------------------------------------------
local TF_VER="2.16"
local TENSORFLOW_VER="${TF_VER}"
local TF_RELEASE="v${TF_VER}"
local TF_BAZEL_VER="6.5.0"

local KERAS_VER="2.15.0"
local PYTORCH_VER="2.3.0"

## bazel configuration
local BAZEL_VER="${TF_BAZEL_VER}"
local BAZEL_URL="https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VER}/bazel-${BAZEL_VER}-installer-linux-x86_64.sh"

## ----------------------------------------------------------------
## Dockerfile configuration
## ----------------------------------------------------------------
local __OS="${OS}"
local __NVIDIA_WHICHONE="devel" ## base, runtime, devel
local __NVIDIA_IMAGE_TAG="${CUDA_VER}-${__NVIDIA_WHICHONE}-${__OS}"
local __NVIDIA_CUDA_IMAGE_NAME="nvidia/cuda"
local __NVIDIA_BASE_IMAGE="${__NVIDIA_CUDA_IMAGE_NAME}:${__NVIDIA_IMAGE_TAG}"

local DOCKER_BLD_IMG_TAG="${__NVIDIA_IMAGE_TAG}"

local __PATH="/usr/local/nvidia/bin:/usr/local/cuda/bin"
local __LD_LIBRARY_PATH_1="/usr/local/nvidia/lib:/usr/local/nvidia/lib64"
local __LD_LIBRARY_PATH_2="/usr/local/cuda/extras/CUPTI/lib64:/usr/local/cuda/lib64"
local __LIBRARY_PATH="/usr/local/cuda/lib64/stubs"

## nvidia-container-runtime settings
local __NVIDIA_VISIBLE_DEVICES="all"
local __NVIDIA_DRIVER_CAPABILITIES="compute,utility"
local __NVIDIA_REQUIRE_CUDA="cuda>=${CUDA_VER} brand=tesla,driver>=550,driver<560"

## TensorFlow build config (if used)
# local __TF_NEED_CUDA="1"
# local __TF_NEED_TENSORRT="1"
# local __TF_CUDA_COMPUTE_CAPABILITIES="7.5,8.0,8.6,8.9"
# local __TF_CUDA_VERSION="${CUDA_VER}"
# local __TF_CUDNN_VERSION="${CUDNN_VER}"
# local __DEBIAN_FRONTEND="noninteractive"
# local __FORCE_CUDA="1"
# local __TORCH_CUDA_ARCH_LIST="Ampere;Hopper"
# local __FVCORE_CACHE="/tmp"
