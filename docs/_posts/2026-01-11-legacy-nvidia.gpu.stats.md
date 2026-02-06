---
title: [Legacy] Nvidia GPU Stats Rolling Logger
date: "2026-01-11 09:00:00 +0530"
categories:
  - Archive
  - Lscripts-docker
tags:
  - legacy
  - lscripts-docker
  - nvidia.gpu.stats
toc: true
---
{: .prompt-warning }
This is an **archived** post migrated from the previous minima-based site. It may describe older workflows or legacy setups.

```bash
## default (1s, 100MB)
lsd-nvidia.gpu.stats-log

## 2s interval, default size
lsd-nvidia.gpu.stats-log 2

## 1s interval, 50MB rolling
lsd-nvidia.gpu.stats-log 1 --size=50

## env-based default
export LSD_NVIDIA_GPUSTATS_LOG_MB=500
lsd-nvidia.gpu.stats-log
```
