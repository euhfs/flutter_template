#!/bin/bash

# Ask for commit message
echo "Enter a commit message: "
read COMMIT_MESSAGE

git add .
git commit -m "$COMMIT_MESSAGE"
git pull
git push