---
title: "Operations: validation & troubleshooting"
date: "2026-02-01 09:00:00 +0530"
categories:
  - Docs
  - Field Manual
tags:
  - validation
  - pip
  - offline
  - troubleshooting
toc: true
---
This chapter focuses on **what “done” looks like** after you install something.

## A simple validation checklist

### 1) Confirm the environment you think you’re using

```bash
which python
python -V
```

If you’re operating on a conda env:

```bash
conda env list
conda info
```

### 2) List installed Python packages

For an environment `ENV_NAME`:

```bash
conda run -n ENV_NAME pip list
conda run -n ENV_NAME pip freeze --all > logs/ENV_NAME.pip.freeze.txt
```

### 3) Dependency integrity

```bash
conda run -n ENV_NAME pip check
```

{: .prompt-warning }
`pip check` is strict. In offline/HPC environments you may hit packages that are installed but not fully compatible with the platform.
Treat failures as **signals**: either fix the wheel set, or explicitly document the exception.

### 4) Runtime imports (smoke tests)

```bash
conda run -n ENV_NAME python - <<'PY'
import sys
print("python:", sys.version)
try:
    import torch
    print("torch:", torch.__version__)
    print("cuda :", torch.version.cuda)
    print("cuda_available:", torch.cuda.is_available())
except Exception as e:
    print("torch import failed:", e)
PY
```

If you use video/AV pipelines:

```bash
conda run -n ENV_NAME python -c "import cv2; print(cv2.__version__)"
conda run -n ENV_NAME python -c "import decord; print(decord.__version__)"
```

## Offline bundle install: recommended validation UX

When an installer is running offline, validation should be **part of the UX**:

1. Ask whether the user wants validation (`--validate=true|false`)
2. Print a **summary** of the environment:
   - python / numpy / torch / cuda
   - total package counts
   - `pip check` status
3. Save reports to `logs/` for audit

This is especially important when the environment is large (GPU stacks, VLM stacks, etc.).

## Troubleshooting patterns

### “Package is not supported on this platform”

This usually means:

- wrong wheel platform tag (e.g. x86_64 wheel on arm64 machine)
- ABI/glibc mismatch
- package expects system libraries that aren’t present

Fixes:

- rebuild the wheel for the correct target
- split the dependency into optional groups (base vs gpu vs multimedia)
- gate the install behind an explicit flag (e.g. `--with-video=true`)

### “pip can’t find dependency in offline mode”

If you see failures like “Could not find a version that satisfies …”:

- add the missing wheel to the offline bundle’s wheel directory, **or**
- install base wheels first, then install the large package with `--no-deps`, **or**
- provide both wheel directories in `--find-links` so dependencies are visible.

## Next

Browse **Offline Bundles** and **Conda governance** chapters for deeper details.
