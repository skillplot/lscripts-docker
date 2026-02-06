---
title: "Design notes 2017: Logs, prompts, and safe defaults"
date: "2017-10-01 09:00:00 +0530"
categories:
  - Design Notes
tags:
  - design-notes
  - deep-dive
toc: true
---
The “UX” of shell tooling isn’t colors — it’s predictability.

## Prompts
Destructive commands should:
- print a bright warning
- default to **No**
- require explicit confirmation

## Logging
Logs should be:
- timestamped
- grouped per task
- easy to attach to bug reports

## Practical takeaway
If a user can’t answer “what happened?” after a failure by reading `logs/`, the tool needs better UX.
