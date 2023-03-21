### Remote Server File Search and Download Script
#This is a Bash script that allows the user to search for a file on a remote server and download it to a local folder on their computer. Additionally, the script also converts the downloaded file to .zip format for easier storage and transportation.

###Usage
##To use the script, follow these steps:

#Run the script using the command bash file_search_download.sh.
#Choose the SSH key to use for authentication.
#Select the remote server to search for the file.
# Enter the name of the file to search for.
# If the file is found, confirm whether to download it or not.
# If confirmed, the file will be downloaded to the local folder and converted to .zip format.
# Dependencies
##This script requires the following dependencies:

Bash shell
ssh command
scp command
zip command
Configuration
Before using the script, make sure to configure the following variables:

destination_folder: the path to the local folder where the downloaded files will be stored.
available_keys: the list of available SSH keys for authentication.
servers: the list of remote servers and their corresponding IP addresses.
Notes
The script uses the sudo command to search for files on the remote server. Make sure to configure the server to allow sudo access for the specified SSH key.
The script searches for files recursively from the root directory (/) on the remote server. Make sure to specify the correct file name to avoid long search times or incorrect results.
The script overwrites any existing files with the same name in the local folder.