```bash
lsd-python.conda.envs.bundle.verify \
  --bundle=logs/offline-bundles/vlm-v1

lsd-python.conda.envs.bundle.install \
  --bundle=logs/offline-bundles/vlm-v1 \
  --name=vlm-v1-test \
  --dry-run

conda env list | grep vlm-v1-test   # should be empty

lsd-python.conda.envs.bundle.install \
  --bundle=logs/offline-bundles/vlm-v1 \
  --name=vlm-v1-test


      conda run -n "$name" pip install \
        --no-index \
        --no-deps \
        --no-build-isolation \
        --find-links "$bundle/TORCH/wheels" \
        -r "$bundle/TORCH/requirements.torch.txt"
```
