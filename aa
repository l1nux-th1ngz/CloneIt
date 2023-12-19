#!/bin/bash

# Function to clone the AUR repository
clone_repo() {
    repo_url="$1"
    chosen_directory="$2"

    # Clone the repository
    git clone "$repo_url" "$chosen_directory"
}

# Function to clone the AUR repository and install the package
clone_and_install() {
    repo_url="$1"
    chosen_directory="$2"

    # Clone the repository
    git clone "$repo_url" "$chosen_directory"

    # Install the AUR package
    cd "$chosen_directory" || exit 1
    makepkg -si
}

# Get the current username
current_user=$(whoami)

# Welcome message
whiptail --title "AUR Downloader" --msgbox --scrolltext --center "\
##################################################################### Hello $current_user #####################################################################

What are we doing today?

1. Just Cloning For Now
2. I'll Be Cloning and Installing" 25 80

# Get AUR repository URL and chosen directory from user
aur_repo_url=$(whiptail --inputbox "Enter AUR Repository URL:" 10 60 --title "AUR Downloader" 3>&1 1>&2 2>&3)
chosen_directory=$(whiptail --inputbox "Enter Download Directory:" 10 60 --title "AUR Downloader" 3>&1 1>&2 2>&3)

# Verify the input is not empty
if [ -z "$aur_repo_url" ] || [ -z "$chosen_directory" ]; then
    whiptail --msgbox "Repository URL and download directory cannot be empty. Exiting." 10 60 --title "Error" --exitstatus 1
    exit 1
fi

# Display a radiolist to choose the operation
operation=$(whiptail --title "Choose Operation" --radiolist "Select an operation:" 15 60 2 \
    "1" "Just Cloning For Now" ON \
    "2" "I'll Be Cloning and Installing" OFF 3>&1 1>&2 2>&3)

# Process user's choice
case $operation in
    "1")
        # Clone the repository
        clone_repo "$aur_repo_url" "$chosen_directory"
        whiptail --msgbox "Repository cloned successfully." 10 60 --title "Success"
        ;;
    "2")
        # Clone the repository and install the AUR package
        clone_and_install "$aur_repo_url" "$chosen_directory"

        # Ask the user if they want to copy and link the folder in .config
        whiptail --yesno "Hello! Would you like to copy and link this folder in your .config?" 10 60 --title "Confirmation"
        response=$?

        # Interpret the user's response
        if [ $response -eq 0 ]; then
            cp -r "$chosen_directory" "$HOME/.config/"
            ln -s "$HOME/.config/$(basename "$aur_repo_url" .git)" "$HOME/"
            whiptail --msgbox "Folder copied and linked successfully." 10 60 --title "Success"
        else
            whiptail --msgbox "Folder not copied or linked." 10 60 --title "Information"
        fi
        ;;
    *)
        whiptail --msgbox "Invalid option. Exiting." 10 60 --title "Error"
        exit 1
        ;;
esac

# Wait for user input before exiting
whiptail --msgbox "Press OK to exit." 10 60
