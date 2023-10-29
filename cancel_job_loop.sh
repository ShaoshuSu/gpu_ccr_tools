#!/bin/bash

# List of job IDs
job_ids=(13653511 13653512 13653513 13653514 13653515 13653516 13653517 13653518 13653519 13653520)


# Loop over each job ID
for id in "${job_ids[@]}"
do
   # Execute the cancel_job script with the current ID
   ./cancel_job.sh $id
   # Move the corresponding output file to the discard_logs folder
   mv "slurm-$id.out" discard_logs/
   
done