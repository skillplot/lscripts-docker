---
title: "Design notes 2021: GPU observability: stats, thermals, profiling"
date: "2021-10-03 09:00:00 +0530"
categories:
  - Design Notes
tags:
  - design-notes
  - deep-dive
toc: true
---
GPU observability turns “it feels slow” into measurable facts.

## What to track
- GPU utilization
- memory usage
- power draw and thermals
- PCIe throughput (when available)

## Practical takeaway
If you can’t measure it, you can’t tune it — build stats commands into the toolchain.
