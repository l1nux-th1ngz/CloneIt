#!/bin/bash

# Create Git-Clones directory in the home folder
mkdir -p ~/Git-Clones

# Get the current username
current_user=$(whoami)

# Welcome message
echo "Hello $current_user"
echo "What are we doing today?"

options=("B) Just Cloning For Now" "A) I'll Be Cloning and Installing")

select opt in "${options[@]}"
do
    case $opt in
        "B) Just Cloning For Now")
            echo "You chose to just clone for now."
            
            # Get AUR repository URL from the user
            read -p "Enter AUR Repository URL: " aur_repo_url

            # Verify the input is not empty
            if [ -z "$aur_repo_url" ]; then
                echo "Repository URL cannot be empty. Exiting."
                exit 1
            fi

            # Extract the name of the repository from the URL
            repo_name=$(basename "$aur_repo_url" .git)

            # Set the chosen directory to the Git-Clones directory in the home folder
            chosen_directory=$HOME/Git-Clones/$repo_name

            # Clone the repository
            git clone "$aur_repo_url" "$chosen_directory" &
            
            break
            ;;
        "A) I'll Be Cloning and Installing")
            echo "You chose to clone and install."
            
            # Get AUR repository URL from the user
            read -p "Enter AUR Repository URL: " aur_repo_url

            # Verify the input is not empty
            if [ -z "$aur_repo_url" ]; then
                echo "Repository URL cannot be empty. Exiting."
                exit 1
            fi

            # Extract the name of the repository from the URL
            repo_name=$(basename "$aur_repo_url" .git)

            # Set the chosen directory to the Git-Clones directory in the home folder
            chosen_directory=$HOME/Git-Clones/$repo_name

            # Clone the repository
            git clone "$aur_repo_url" "$chosen_directory" &

            # Navigate to the downloaded directory
            cd "$chosen_directory" || exit 1

            # Build the AUR package
            makepkg -si

            # Check if the build was successful
            wait $!
            if [ $? -eq 0 ]; then
                # Ask the user if they want to copy the folder to .config
                read -p "Would you like to copy this folder to .config? (yes/no): " choice
                if [ "$choice" = "yes" ]; then
                    cp -r "$chosen_directory" "$HOME/.config/$(basename "$chosen_directory")" &
                    wait $!
                    echo "Folder copied to .config successfully."
                else
                    echo "Folder not copied."
                fi
            else
                read -p "Build failed. Would you like to see the build output? (yes/no): " choice
                if [ "$choice" = "yes" ]; then
                    # Display the build output
                    cat PKGBUILD
                fi
            fi
            
            break
            ;;
        *) echo "Invalid option $REPLY";;
    esac
done

# Wait for user input before exiting
read -p "Press any key to exit."
