#!/bin/bash

# Check if svn is installed
if ! command -v svn &> /dev/null; then
    echo "Subversion (svn) is not installed. Please install it first."
    exit 1
fi

# GitHub repository URL
repo_url="https://github.com/username/repository"

# Folder path within the repository to download
folder_path="path/to/folder"

# Destination folder on your local machine
destination_folder="local_folder"

# Hide the git clone command
echo "Downloading folder from GitHub..."

# Perform svn export
svn export "$repo_url/trunk/$folder_path" "$destination_folder" --quiet

# Provide success message
echo "Folder downloaded successfully to: $destination_folder"
