# Read job IDs from the text file into a list
job_ids=()
job_status=()
# while IFS= read -r line; do
#     job_ids+=("$line")
# done < job_ids.txt

# # Display the job IDs
# echo "Job IDs read from file:"
# for job_id in "${job_ids[@]}"; do
#     echo "$job_id"
#     ./cancel_job.sh "$job_id"
# done


input_file="cancel_job_ids_list.txt"  # Replace with your input file name
# echo -e "Experiment Name: \t\t Job ID"
while read -r line; do
    experiment_name=$(echo "$line" | awk '{print $1}')
    exps+=( "$experiment_name" )
    job_id=$(echo "$line" | awk '{print $2}')
    ./cancel_job.sh "$job_id"

    mv "slurm-$job_id.out" discard_logs/
    
    # output=$(./check_jobid.sh "$job_id")
    # job_ids+=("$job_id")
    # if [[ $output == *' ST '*R* ]]; then
    #     # echo "$job_id   RUNNING"
    #     job_status+=("RUNNING")
    # else
    #     # echo "$job_id   DIE"
    #     job_status+=("DIE")
    # fi

done < "$input_file"

