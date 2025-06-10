#!/usr/bin/env bash

set -e # Exit on any error
set -x

NAME="$1"
URL="$2"
BRANCH="$3"

echo "Merging $NAME from $URL..."

# Add remote and fetch branches
git remote add -f "$NAME" "$URL"

# Create a temporary branch from the remote main branch
git checkout -b "$NAME-branch" "$NAME/$BRANCH"

# Move all files into a subdirectory (excluding .git)
mkdir -p "$NAME"
shopt -s dotglob                         # Include hidden files except .git
ls -A | xargs -I{} git mv {} "$NAME/" -k # Ignore errors if empty

# Commit the changes
git commit -am "Merged $NAME into subdirectory $NAME"

# Merge into main branch
git checkout master
git merge --allow-unrelated-histories --no-edit --no-ff "$NAME-branch"

# Cleanup
git branch -D "$NAME-branch"
git remote remove "$NAME"
