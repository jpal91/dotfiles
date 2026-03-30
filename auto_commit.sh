#!/bin/bash

# Add to cronjob
# 0 * * * * DOTFILES_DIR="..." /path/to/dotfiles/auto_commit.sh

# Define the directory where your dotfiles are located
cd "$DOTFILES_DIR" || { echo "Directory not found"; exit 1; }

# Check for uncommitted changes
if [[ -z $(/usr/bin/git status --porcelain) ]]; then
    # 1a. No changes? Just pull and exit.
    /usr/bin/git pull origin main
    exit 0
fi

# 1b. Changes exist.
# We use 'stash push -u' to include untracked files.
/usr/bin/git stash push -u -m "Auto-stash before sync"

# Pull the latest from remote
/usr/bin/git pull origin main

# Attempt to re-apply the local changes
if ! /usr/bin/git stash pop; then
    # If there is a conflict, we force the local (stashed) changes to take precedence.
    # In a stash pop, '--theirs' represents the stashed content.
    echo "Conflict detected, preferring local changes..."
    /usr/bin/git checkout --theirs .

    # Mark the conflicts as resolved
    /usr/bin/git add -A
fi

# 3. Stage everything again (to catch files from successful pop or checkout)
/usr/bin/git add -A

# 4. Formulate the commit message
# We use /usr/bin/git diff --cached because the changes are now staged
CHANGED_FILES=$(/usr/bin/git diff --cached --name-only | tr '\n' ',' | sed 's/,$//' | sed 's/,/, /g')

# If for some reason CHANGED_FILES is empty (e.g. after a merge that resulted in no change)
if [[ -z "$CHANGED_FILES" ]]; then
    exit 0
fi

COMMIT_MSG="Updated $CHANGED_FILES"

# Commit the changes
/usr/bin/git commit -m "$COMMIT_MSG"

# 5. Push to the remote repository
/usr/bin/git push origin main
