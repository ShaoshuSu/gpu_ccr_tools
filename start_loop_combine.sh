#!/bin/bash

# Array of dataset names
dataset_names=("MH_01_easy" "MH_02_easy" "MH_03_medium" "MH_04_difficult" "MH_05_difficult" "V1_01_easy" "V1_02_medium" "V1_03_difficult" "V2_01_easy" "V2_02_medium" "V2_03_difficult")
# dataset_names=("MH_01_easy")

dates=("2011_10_03" "2011_10_03" "2011_10_03" "2011_09_26" "2011_09_30" "2011_09_30" "2011_09_30" "2011_09_30" "2011_09_30" "2011_09_30" "2011_09_30")
drives=("27" "42" "34" "67" "16" "18" "20" "27" "28" "33" "34")

# dates=("2011_10_03")
# drives=("27")


scale_states=("false")
portions=(0.25)


list_enable=(0 1 2 3 4 5 6 7 8 9 10)
# list_enable=(0 1 2 3 9)

# Path to the file to be modified

# for idx in ${!scale_states[*]}; do
for scale_state in "${scale_states[@]}"; do
    exps=()
    job_ids=()
    # scale_state=scale_state
    portion=${portions[$idx]}

    echo -e "\nScale: ${scale_state}"
    echo -e "Portion: ${portion}"

    # EuRoc
    # file_path="./train_vo_pvgo_euroc_loop.script"

    # for ds_name in "${dataset_names[@]}"; do
    for traj_idx in {0..10}; do
        ds_name=${dataset_names[$traj_idx]}

        if ! printf '%s\n' "${list_enable[@]}" | grep -w -q "^${traj_idx}$"; then
            echo "skip $ds_name"
            continue
        else
            echo "Running ${ds_name}"
            exps+=( "EuRoc_$ds_name" )

            output=$(sbatch train_vo_pvgo_euroc_loop_para.script $ds_name ${portions[$idx]} ${scale_state})
            job_id=$(echo "$output" | grep -oE '[0-9]+')
            echo "Submit Job ID: $job_id"
            job_ids+=("$job_id")
        fi
    done

    # KITTI       
    # for traj_idx in {0..10}; do

    #     ds_date=${dates[$traj_idx]}
    #     ds_idx=${drives[$traj_idx]}

    #     formatted_number=$(printf "%02d" $traj_idx)
    #     result="KITTI_${formatted_number}"

    #     # Check if the index is in the list
    #     if ! printf '%s\n' "${list_enable[@]}" | grep -w -q "^${traj_idx}$"; then
    #         echo "skip $result"
    #         continue
    #     else
    #         echo "running $result"
            
    #         # output=$(sbatch train_vo_pvgo_kitti_loop_para.script $ds_date $ds_idx ${portions[$idx]} ${scale_state})
    #         # job_id=$(echo "$output" | grep -oE '[0-9]+')
    #         # echo "Submit Job ID: $job_id"
            
    #         exps+=( $result)
    #         job_ids+=("$job_id")

    #     fi
    # done


    output_file="experiment_job_ids2.txt" 
    for ((i=0; i<${#exps[@]}; i++)); do
        experiment_name="${exps[i]}"
        job_id="${job_ids[i]}"
        echo -e "$experiment_name\t\t$job_id\t\t$scale_state\t\t$portion" >> "$output_file"
    done


done


echo "Saved to $output_file"

while read -r line; do
    experiment_name=$(echo "$line" | awk '{print $1}')
    job_id=$(echo "$line" | awk '{print $2}')
    # ./cancel_job.sh $job_id
    echo "Experiment Name: $experiment_name Job ID: $job_id"
done < "$output_file"

