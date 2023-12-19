#!/bin/bash

# Function to clone the Codeberg repository
clone_repo() {
    repo_url="$1"
    username="$2"
    password="$3"

    # Use username and password (or access token) for authentication
    git clone "https://$username:$password@$repo_url"
}

# Ask the user if they want to log in
whiptail --title "Codeberg Clone" --yesno "Would you like to login to your Codeberg account?" 10 60 \
    --yes-button "\e[32mYES\e[0m" \
    --no-button "\e[31mNO\e[0m"

response=$?

if [ $response -eq 0 ]; then
    # If yes, ask for username and password
    username=$(whiptail --inputbox "Enter your Codeberg username:" 10 60 3>&1 1>&2 2>&3)
    password=$(whiptail --passwordbox "Enter your Codeberg password:" 10 60 3>&1 1>&2 2>&3)
else
    # If no, set empty values
    username=""
    password=""
fi

# Next screen: Codeberg list (you can implement the list here)

# Your logic for cloning the repository goes here
