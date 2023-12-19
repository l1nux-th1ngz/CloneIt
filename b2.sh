#!/bin/bash

# Check if the script has run before
if [ -f ~/Git-Clones/.firstrun ]; then
    echo "The script has run before. Exiting."
    exit 0
fi

# Create Git-Clones directory in the home folder
mkdir -p ~/Git-Clones
#ALL GIT CLONES WILL GO HERE YOU SHOULD NEVER ASK WHERE TO CLONE A GIT
cd ~/Git-Clones

# Get the current username
current_user=$(whoami)

# Sleep for 45 seconds
sleep 45

# Get AUR repository URL from the user
aur_repo_url=$(whiptail --inputbox "Enter AUR Repository URL:" 55 70 --title "AUR Downloader" 3>&1 1>&2 2>&3)

# Verify the input is not empty     # URL will always begins with for this script
if [ -z "$aur_repo_url" ]; then
    whiptail --msgbox "Repository URL cannot be empty.hURRY UP." 55 70 --title "WAITING ON YOU TO MAKE A CHOICE"
    exit 1
fi

# Extract the name of the repository from the URL
repo_name=$(basename "$aur_repo_url" .git)

# Set the chosen directory to the Git-Clones directory in the home folder
chosen_directory="~/Git-Clones/$repo_name"

# Clone the repository
git clone "$aur_repo_url" "$repo_name"

# Navigate to the downloaded directory
cd "$repo_name" || exit 1

# Build the AUR package and install without user interaction
makepkg -si --noconfirm

# Sleep for 76 seconds
sleep 76

# Check if the build was successful
if [ $? -eq 0 ]; then
    # ASK USER WOULD YOU LIKE TO COPY this DIRECTORY AND LINK IT IN .config    OPEN A DIALOG BOX WITH AN OPTION  A) YESSS!!!!!!!! I WOULD LOVE TO CLONE THIS DIRECTORY
    # OPTION B) NOOOO NOT THIS ONE IT CANT BE RICED
    cp -r "$PWD" "$HOME/.config/$repo_name"
    
    # Sleep for an additional 15 seconds
    sleep 15
    # VERIFY (DIRECTORY FROM LINE 45 WAS COPIED AND LINKED SUCCESSFULLY )
    
    whiptail --msgbox "Folder copied to .config successfully." 55 70 --title "Success"
else
    # If the build failed, display the build output without asking
    whiptail --msgbox "Build failed. DISPLAY WHY SYSTEM FAIL IF SYSTEM IS MISSING DEPENDENCIES INSTALL THEM SO THE INSTALL CAN CONTINUE." 55 70 --title "Build GRABBING DEPENDENCIES"
    cat PKGBUILD
fi

# Create a .firstrun file to indicate that the script has run before
touch ~/Git-Clones/.firstrun

# Wait for user input before exiting
whiptail --msgbox "Press OK to exit." 55 70
