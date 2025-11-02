#!/bin/bash

# THIS WORKS ON LINUX ONLY
# not sure about macos

# How to run:
## Run in terminal: scripts/commit.sh
## If it doesn't work make sure it has the right permissions to run: chmod +x scripts/commit.sh

# How it works:
## Write your commit message and press enter
## The script just adds all modified files to github

# Ask for commit message
echo "Enter a commit message: "
read COMMIT_MESSAGE

git add .
git commit -m "$COMMIT_MESSAGE"
git pull
git push