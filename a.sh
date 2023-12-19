#!/bin/bash

# Create Git-Clones directory in the home folder
mkdir -p ~/Git-Clones
# ALL GIT CLONES WILL GO HERE; YOU SHOULD NEVER ASK WHERE TO CLONE A GIT
cd Git-Clones || exit 1

# Get the current username
current_user=$(whoami)

# Sleep for 45 seconds
sleep 45

# Get AUR repository URL from the user
aur_repo_url=$(whiptail --inputbox "Enter AUR Repository URL:" 55 70 --title "AUR Downloader" 3>&1 1>&2 2>&3)

# Verify the input is not empty; URL will always begin with "https://aur.archlinux.org/"
if [ -z "$aur_repo_url" ]; then
    whiptail --msgbox "Repository URL cannot be empty. Hurry up. Waiting on you to make a choice." 55 70 --title "Error"
fi

# Extract the name of the repository from the URL
repo_name=$(basename "$aur_repo_url" .git)

# Set the chosen directory to the Git-Clones directory in the home folder
chosen_directory=~/Git-Clones/"$repo_name"

# Clone the repository
git clone "$aur_repo_url" "$chosen_directory"

# Navigate to the downloaded directory
cd "$chosen_directory" || exit 1

# Build the AUR package and install without user interaction
makepkg -si --noconfirm

# Sleep for 76 seconds
sleep 76

# Check if the build was successful
if [ $? -eq 0 ]; then
    # Ask user if they want to copy this directory and link it in .config
    whiptail --yesno "Would you like to copy this directory and link it in .config?" 55 70 --title "Confirmation"
    response=$?

    if [ $response -eq 0 ]; then
        cp -r "$chosen_directory" "$HOME/.config/$(basename "$chosen_directory")"

        # Sleep for an additional 15 seconds
        sleep 15

        # Verify if the directory from line 45 was copied and linked successfully
        whiptail --msgbox "Folder copied to .config successfully." 55 70 --title "Success"
    else
        whiptail --msgbox "Directory not copied or linked." 55 70 --title "Information"
    fi
else
    # If the build failed, display the build output without asking
    whiptail --msgbox "Build failed. Display why system failed. If system is missing dependencies, install them so the install can continue." 55 70 --title "Build grabbing dependencies"
    cat PKGBUILD
fi

# Wait for user input before exiting
whiptail --msgbox "Press OK to exit." 55 70
