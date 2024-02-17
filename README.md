# CCR and GPU tools  Documentation

Welcome to the `CCR and GPU tools` repository, where we provide a collection of utilities designed to enhance your experience with GPUs and CCR (Computational Cluster Resources).

## Configuring Unused GPUs as Primary Display Units

To set specific GPUs as the only ones recognized by your system, ensuring that other GPUs remain unused, follow these steps:

1. Make the script executable:
   ```bash
   chmod +x set_cuda_device.sh
   ```
2. Execute the script:
   ```bash
   ./set_cuda_device.sh
   ```

### Excluding Specific GPUs

If you wish to exclude certain GPUs from being used, such as GPU 0, you can modify the script by uncommenting the following lines:

```bash
if [[ $id -eq 0 ]]; then
    continue
fi
```

### Excluding Multiple GPUs

To exclude multiple specific GPUs from use, uncomment the relevant section of the script and adjust the GPU IDs as necessary:

```bash
if [[ $id -eq 2 ]] || [[ $id -eq 3 ]] || [[ $id -eq 5 ]] || [[ $id -eq 6 ]] || [[ $id -eq 7 ]]; then
    continue
fi
```