---
title: "Design notes 2022: Edge and small devices"
date: "2022-04-03 09:00:00 +0530"
categories:
  - Design Notes
  - 2022
tags:
  - design-notes
  - 2022
  - principles
toc: true
---
This is a snapshot of the ideas that shaped Lscripts in **2022**.

## What stayed constant

- **Make the plan visible** before you execute it
- Prefer **small, composable commands** over giant scripts
- Keep **logs and manifests** as first-class artifacts

## What evolved

- Better defaults around confirmation prompts
- Cleaner separation of modules (`lsd-docker`, `lsd-cuda`, `lsd-python`, …)
- More emphasis on **reproducibility**: pinned envs, explicit locks, offline wheels

## Why it matters

A system like this is less about “clever automation” and more about **reducing cognitive load**:

- new machines feel familiar
- troubleshooting starts from artifacts, not guesswork
- teams can share a common operational vocabulary

## Practical takeaway

If you add a new command, ship it with:

- a dry-run path (when feasible)
- a validation step (smoke test)
- a short doc note (what/why/how)

> Next: see the deep dive note for 2022 or jump to the 2026 Field Manual series.
