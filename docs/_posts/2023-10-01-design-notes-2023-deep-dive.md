---
title: "Design notes 2023: Performance tuning: IO, CPU pinning, NUMA"
date: "2023-10-01 09:00:00 +0530"
categories:
  - Design Notes
tags:
  - design-notes
  - deep-dive
toc: true
---
Performance is a systems problem.

## Tuning checklist
- storage layout and cache behavior
- CPU affinity / pinning
- NUMA locality
- container runtime flags

## Practical takeaway
Build repeatable benchmarks into your workflow so changes are measurable.
