---
title: Command map & UX patterns
date: "2026-01-18 09:00:00 +0530"
categories:
  - Docs
  - Field Manual
tags:
  - commands
  - ux
  - dry-run
  - safety
toc: true
---
Lscripts is intentionally **discoverable**: you should be able to skim the command namespace and “feel” what’s safe, what’s destructive, and what’s informational.

## How to discover commands

### 1) Use the website

- Open **Command Catalog**: `/cmds/`
- Press `/` and type part of the command name

### 2) Use the shell

Because these are shell functions, you can list them:

```bash
# list all functions starting with lsd-
compgen -A function | grep '^lsd-' | sort

# narrow to a module family
compgen -A function | grep '^lsd-python' | sort
```

## Naming patterns you’ll see

### Read-only / safe inspection

- `*.cfg.*` → show configuration / derived settings
- `*.status` → health/status check
- `*.list*` → enumerate things (envs, images, logs)

### Mutating actions

- `*.install` → install packages / layers
- `*.delete` / `*.purge*` → destructive (should prompt loudly)
- `*.bundle.*` → export/install artifacts (often for air‑gapped use)

## UX conventions (why it feels “safe”)

### A) “Plan before action”

Many commands print a plan first:

- what will be created
- where artifacts will be written
- which env will be mutated

This makes review easy in terminals and in logs.

### B) Confirmations default to “No”

Destructive operations should require explicit confirmation, often multiple times.

{: .prompt-danger }
If a command deletes environments, images, or files, it should never default to **Yes**.

### C) Dry-run where possible

Prefer commands that support `--dry-run=true` (or equivalent) when you’re new.

## Practical examples

### Example: Offline conda bundle install

```bash
lsd-python.conda.envs.bundle.install   --bundle=logs/offline-bundles/vlm-v1   --name=vlm-v1-test
```

### Example: Conda environment introspection

```bash
lsd-python.conda.envs.list-details
lsd-python.conda.cfg.show
```

### Example: NVIDIA GPU stats

```bash
lsd-nvidia.gpu.stats
```

## Next

Continue with: **System design: modules & conventions**.
