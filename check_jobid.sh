# Get the job ID from the command-line argument
job_id=$1

# Echo the entered job ID
# echo "Checking job ID: $job_id"

squeue -M faculty --job $job_id
# squeue --job $job_id