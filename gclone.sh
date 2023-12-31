#!/bin/bash

echo "1. Clone the entire repository"
echo "2. Clone a single folder from the repository"
echo "3. Clone multiple single files from the repository"
echo "Please enter your choice (1-3):"

read CHOICE

echo "Enter the Git link:"
read REPO_URL

case $CHOICE in
  1)
    # Clone the entire repository
    git clone $REPO_URL
    ;;
  2)
    # Clone a single folder from the repository
    echo "Enter the folder path:"
    read FOLDER_PATH
    git clone $REPO_URL --filter=blob:none --no-checkout
    cd $(basename "$REPO_URL" .git)
    git checkout master -- $FOLDER_PATH
    ;;
  3)
    # Clone multiple single files from the repository
    echo "Enter the file paths (separated by spaces):"
    read FILE_PATHS
    git clone $REPO_URL --filter=blob:none --no-checkout
    cd $(basename "$REPO_URL" .git)
    for FILE_PATH in $FILE_PATHS; do
      git checkout master -- $FILE_PATH
    done
    ;;
  *)
    echo "Invalid choice."
    ;;
esac
