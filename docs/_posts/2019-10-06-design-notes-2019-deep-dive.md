---
title: "Design notes 2019: Air-gapped thinking: offline-first packaging"
date: "2019-10-06 09:00:00 +0530"
categories:
  - Design Notes
tags:
  - design-notes
  - deep-dive
toc: true
---
Air-gapped environments force honesty.

## Offline-first means:
- every dependency is an artifact
- every artifact has a checksum
- every install has a validation report

## Practical takeaway
If you can install your stack without internet, you have real reproducibility.
