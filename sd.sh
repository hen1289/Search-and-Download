#!/bin/bash

# define the path to the search folder
destination_folder="/home/$USER/search"

# create the search folder if it doesn't exist
mkdir -p "$destination_folder"

# list the available keys in the .ssh folder and ask the user which one to use
available_keys=($(ls /home/$USER/.ssh/*.pem))
echo "Available keys:"
for ((i=0; i<${#available_keys[@]}; i++)); do
    echo "$((i+1))) ${available_keys[$i]}"
done

read -p "Enter the number of the key you want to use: " key_number
key_file="${available_keys[$((${key_number}-1))]}"

# define the IPs of the servers
declare -A servers=(
    ["Proto"]="10.20.1.43"
    ["Fatec_NA"]="10.20.1.79"
    ["Sebrae"]="10.20.1.64"
    ["Sebrae_PI"]="10.20.0.201"
    ["Senar_GO"]="10.20.0.201"
    ["Etec"]="10.20.1.30"
    ["Senar_BA"]="10.20.1.40"
    ["Senar_CE"]="10.20.1.40"
    ["Senar_NA"]="10.20.1.41"
    ["Senar_MS"]="10.20.0.201"
)

# display the list of servers and ask the user to select one
echo "Select the server where you want to search for the file:"
i=1
for key in "${!servers[@]}"; do
    echo "$i) $key - ${servers[$key]}"
    i=$((i+1))
done

read -p "Enter the server number: " server_number

# get the IP of the selected server
selected_key=$(echo ${!servers[@]} | cut -d " " -f $server_number)
server_ip="${servers[$selected_key]}"

# ask the user to enter the name of the file to search for
read -p "Enter the name of the file you want to find: " file_name

# define the file search command
command="ssh -i ${key_file} root@${server_ip} 'sudo find / -name ${file_name} 2>/dev/null'"

# execute the command and capture the output
output=$(eval $command)

# check if the file was found
if [ -n "$output" ]; then
    # get the full path of the found file
    file_path=$(echo $output | tr -d '\r')
    
    # define the path to the destination file
    destination_file="${destination_folder}/$(basename ${file_path})"

    # ask the user to confirm the file download
    read -p "Do you want to download the file? (y/n): " confirm_download
    if [[ $confirm_download == "y" || $confirm_download == "Y" ]]; then
        # copy the file to the destination folder
        copy_command="scp -i ${key_file} root@${server_ip}:${file_path} ${destination_file}"
        eval $copy_command

        # convert the file to .zip
        zip_file="${destination_file}.zip"
        zip_command="zip ${zip_file} ${destination_file}"
        eval $zip_command
        rm $destination_file

        echo "File successfully copied and converted to ${zip_file}"
    else
        echo "File download cancelled."
    fi
else
    echo "File not found on the server."
fi
