# Find the first unused GPU
FIRST_UNUSED_GPU=$(nvidia-smi --query-gpu=index --format=csv,noheader,nounits | while read id; do
    # Skip certain GPU(s)
    if [[ $id -eq 0 ]]; then
    # if [[ $id -eq 2 ]] || [[ $id -eq 3 ]] || [[ $id -eq 5 ]] || [[ $id -eq 6 ]] || [[ $id -eq 7 ]]    ; then
        continue
    fi
    
    # Check if this GPU ID has any processes
    if ! nvidia-smi -i $id --query-compute-apps=pid --format=csv,noheader,nounits | grep -q '[0-9]'; then
        echo "$id"
        break
    fi
done)

# Check if we found an unused GPU
if [[ -z $FIRST_UNUSED_GPU ]]; then
    echo "No unused GPUs found."
    exit 1
else
    export CUDA_VISIBLE_DEVICES=$FIRST_UNUSED_GPU
    echo "Set CUDA_VISIBLE_DEVICES to $CUDA_VISIBLE_DEVICES"
fi