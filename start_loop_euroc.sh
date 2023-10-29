#!/bin/bash

# Array of dataset names
dataset_names=("MH_01_easy" "MH_02_easy" "MH_03_medium" "MH_04_difficult" "MH_05_difficult" "V1_01_easy" "V1_02_medium" "V1_03_difficult" "V2_01_easy" "V2_02_medium" "V2_03_difficult")
dataset_names=("V2_02_medium")
# dataset_names=("V2_03_difficult")
# scale_states=("true")



# Path to the file to be modified
file_path="./train_vo_pvgo_euroc.script"

    # Loop through the dataset names
    for ds_name in "${dataset_names[@]}"; do
        echo "Running ${ds_name}"

        # Replace content in the file using sed
        sed -i "s/ds_name=FILENAME_NAME/ds_name=$ds_name/g" "$file_path"

    # # Break the loop if ds_name is equal to "MH_03_medium"
        # if [[ "$ds_name" == "MH_03_medium" ]]; then
        #     break
        # fi

    sbatch train_vo_pvgo_euroc.script 

        # Generate a sed command to perform the replacement
        sed_command="s/ds_name=$ds_name/ds_name=FILENAME_NAME/g"
        
        # Replace content in the file using sed
        sed -i "$sed_command" "$file_path"

done