#!/bin/bash

# Create Git-Clones directory in the home folder
mkdir -p ~/Git-Clones

# Get the current username
current_user=$(whoami)

# Welcome message
whiptail --title "AUR Downloader" --msgbox --scrolltext --center "\
Hello $current_user

What are we doing today?

1. Just Cloning For Now
2. I'll Be Cloning and Installing" 25 80

# Get AUR repository URL from the user
aur_repo_url=$(whiptail --inputbox "Enter AUR Repository URL:" 10 60 --title "AUR Downloader" 3>&1 1>&2 2>&3)

# Verify the input is not empty
if [ -z "$aur_repo_url" ]; then
    whiptail --msgbox "Repository URL cannot be empty. Exiting." 10 60 --title "Error" --exitstatus 1
    exit 1
fi

# Extract the name of the repository from the URL
repo_name=$(basename "$aur_repo_url" .git)

# Set the chosen directory to the Git-Clones directory in the home folder
chosen_directory="~/Git-Clones/$repo_name"

# Clone the repository
git clone "$aur_repo_url" "$chosen_directory"

# Navigate to the downloaded directory
cd "$chosen_directory" || exit 1

# Build the AUR package
makepkg -s

# Check if the build was successful
if [ $? -eq 0 ]; then
    # Install the AUR package
    sudo makepkg -si

    # Check if the installation was successful
    if [ $? -eq 0 ]; then
        # Clean up the directory after installation
        rm -rf "$chosen_directory"
        whiptail --msgbox "Installation successful and directory cleaned." 10 60 --title "Success"
    else
        whiptail --msgbox "Installation failed. Please check the build output." 10 60 --title "Error"
    fi
else
    if (whiptail --yesno "Build failed. Would you like to see the build output?" 10 60 --title "Build Failed"); then
        # Display the build output
        cat PKGBUILD
    fi
fi

# Wait for user input before exiting
whiptail --msgbox "Press OK to exit." 10 60
