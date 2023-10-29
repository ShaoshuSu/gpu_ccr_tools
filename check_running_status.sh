# Read job IDs from the text file into a list
job_ids=()
job_status=()
scales=()
portions=()
exps=()

input_file="experiment_job_ids.txt"  # Replace with your input file name
# echo -e "Experiment Name: \t\t Job ID"
# define the search term
search_term="Total time consume:"
pending_flag=" PD   "
no_GPU_falg="No CUDA GPUs are available"
cancel_flag="CANCELLED AT"

while read -r line; do
    experiment_name=$(echo "$line" | awk '{print $1}')
    exps+=( "$experiment_name" )
    job_id=$(echo "$line" | awk '{print $2}')
    scale=$(echo "$line" | awk '{print $3}')
    portion=$(echo "$line" | awk '{print $4}')
    
    output=$(./check_jobid.sh "$job_id")

    job_ids+=("$job_id")
    scales+=( "$scale" )
    portions+=( "$portion" )
    if [[ $output == *' R '* ]]; then
        job_status+=("RUNNING")
    elif [[ $output == *' PD '* ]]; then
        job_status+=("PENDING")
    else
        filename="slurm-$job_id.out"

        if grep -q "$search_term" "$filename"; then
            job_status+=("DONE")
        elif grep -q "$cancel_flag" "$filename"; then
            job_status+=("CAL")
        elif grep -q "$no_GPU_flag" "$filename"; then
            job_status+=("No GPU")
        else
            job_status+=("UnDIE")
        fi
    fi
done < "$input_file"

echo -e "\nExpName\t\t\tJOB_ID\t\tST"
for ((i=0; i<${#job_ids[@]}; i++)); do
    exp_name="${exps[i]}"
    job_id="${job_ids[i]}"
    status="${job_status[i]}"
    scale="${scales[i]}"
    portion="${portions[i]}"
    echo -e "$exp_name\t$job_id\t$status\t$scale\t$portion"
done