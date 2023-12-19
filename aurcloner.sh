#!/bin/bash

# Get the current username
current_user=$(whoami)

# Welcome message
whiptail --title "AUR Downloader" --msgbox --scrolltext --center "\
Hello $current_user

What are we doing today?

1. Just Cloning For Now
2. I'll Be Cloning and Installing" 25 80

# Get AUR repository URL and chosen directory from the user
aur_repo_url=$(whiptail --inputbox "Enter AUR Repository URL:" 10 60 --title "AUR Downloader" 3>&1 1>&2 2>&3)
chosen_directory=$(whiptail --inputbox "Enter Download Directory:" 10 60 --title "AUR Downloader" "$HOME/" 3>&1 1>&2 2>&3)

# Verify the input is not empty
if [ -z "$aur_repo_url" ] || [ -z "$chosen_directory" ]; then
    whiptail --msgbox "Repository URL and download directory cannot be empty. Exiting." 10 60 --title "Error" --exitstatus 1
    exit 1
fi

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
        # Ask the user if they want to copy the folder to .config
        if (whiptail --yesno "Would you like to copy this folder to .config?" 10 60 --title "Confirmation"); then
            sudo cp -r "$chosen_directory" "$HOME/.config/$(basename "$chosen_directory")"
            whiptail --msgbox "Folder copied to .config successfully." 10 60 --title "Success"
        else
            whiptail --msgbox "Folder not copied." 10 60 --title "Information"
        fi
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
