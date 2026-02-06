---
title: "Design notes 2022: MQTT and lightweight telemetry"
date: "2022-10-02 09:00:00 +0530"
categories:
  - Design Notes
  - 2022
tags:
  - design-notes
  - 2022
  - deep-dive
toc: true
---
Small devices (RPi-class) add constraints: CPU-only, memory pressure, and flaky networks.

## Practical takeaway
Treat edge as a first-class target: minimal dependencies, clear pinning, and low-IO defaults.
