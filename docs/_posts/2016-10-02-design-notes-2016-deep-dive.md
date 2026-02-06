---
title: "Design notes 2016: Docker as a reproducible substrate"
date: "2016-10-02 09:00:00 +0530"
categories:
  - Design Notes
tags:
  - design-notes
  - deep-dive
toc: true
---
In the early days, Docker was the fastest way to make a workstation feel “portable.”

## Core patterns

### 1) Keep the host minimal
Install only what you must on the host (drivers, docker runtime). Everything else lives in images.

### 2) Treat images like artifacts
- tag them deterministically
- record build args
- keep a changelog of “what changed”

### 3) Mount intent, not chaos
Mount only the directories you need (`/datahub`, `/codehub`) and keep container paths consistent.

## Practical takeaway

If you can express a workflow as:

- a container image
- a small run wrapper
- a validation step

…you’ve made it reproducible.
