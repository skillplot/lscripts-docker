---
title: "Design notes 2024: Reproducibility under constraints: pins and manifests"
date: "2024-10-06 09:00:00 +0530"
categories:
  - Design Notes
tags:
  - design-notes
  - deep-dive
toc: true
---
Modern ML stacks move fast. Reproducibility requires *discipline*.

## What helps
- explicit environment locks
- split requirements (base vs torch vs optional)
- immutable offline bundles for air-gapped installs

## Practical takeaway
Prefer “install from artifacts” over “install from the internet.”
