#!/bin/bash

# Function to clone the AUR repository and install the package
clone_and_install() {
    repo_url="$1"
    chosen_directory="$2"

    # Start a timer to measure the overall duration
    # start_time=$(date +%s)

    # Clone the repository using SSH
    GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no" git clone "$repo_url" "$chosen_directory"

    # Navigate to the downloaded directory
    cd "$chosen_directory" || exit 1

    # Build and install the AUR package
    makepkg -si

    # Sleep until the package has finished installing
    while [ ! -x "$(command -v paru)" ]; do
        sleep 1
    done

    # Check if the installation was successful
    if [ $? -eq 0 ]; then
        # Ask the user if they want to copy the folder to .config
        whiptail --yesno "Would you like to copy this folder to .config?" 10 60 --title "Confirmation"
        response=$?

        # Interpret the user's response
        if [ $response -eq 0 ]; then
            cp -r "$chosen_directory" "$HOME/.config/$(basename "$chosen_directory")"
            whiptail --msgbox "Folder copied to .config successfully." 10 60 --title "Success"
        else
            whiptail --msgbox "Folder not copied." 10 60 --title "Information"
        fi
    else
        whiptail --msgbox "Installation failed. Please check the build output." 10 60 --title "Error"
    fi

    # End the timer
    # end_time=$(date +%s)

    # Calculate the duration
    # duration=$((end_time - start_time))

    # Display the overall duration
    whiptail --msgbox "Process completed." 10 60 --title "Duration"
}

# Rest of the script remains unchanged...