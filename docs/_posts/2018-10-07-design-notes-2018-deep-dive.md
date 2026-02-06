---
title: "Design notes 2018: CUDA stack sanity: drivers → runtime → frameworks"
date: "2018-10-07 09:00:00 +0530"
categories:
  - Design Notes
  - 2018
tags:
  - design-notes
  - 2018
  - deep-dive
toc: true
---
CUDA failures are rarely “mysterious” if you validate the stack in layers.

## The CUDA sanity ladder

1. **Hardware**: GPU visible (`lspci`, `nvidia-smi`)
2. **Driver**: correct driver version
3. **Runtime**: `libcuda` / persistence
4. **Framework**: torch sees CUDA, can allocate, can run kernels
5. **App**: your model runs and matches expected throughput

## Practical takeaway
Write checks that stop at the first broken layer — and print *exactly* what to fix.
