#!/bin/bash

# Get the number from command-line argument
JobID=$1

# Print the JobID
echo "Cancel Job: $JobID"

scancel -M faculty $JobID
scancel $JobID
# mv "slurm-$JobID.out" discard_logs/
