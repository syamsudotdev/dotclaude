#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract fields from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Get just the directory name (like robbyrussell %c)
dir_name=$(basename "$cwd")

# ANSI colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
RESET='\033[0m'

# Function to get git info similar to robbyrussell theme
get_git_info() {
    if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
        branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
        if [ -n "$branch" ]; then
            if git -C "$cwd" diff-index --quiet HEAD -- 2>/dev/null; then
                printf " ${CYAN}git:(${GREEN}%s${CYAN})${RESET}" "$branch"
            else
                printf " ${CYAN}git:(${RED}%s${CYAN})${RESET} ${RED}✗${RESET}" "$branch"
            fi
        fi
    fi
}

# Build output
printf "${CYAN}%s${RESET}" "$dir_name"
get_git_info

# Model info
if [ -n "$model" ]; then
    printf " ${YELLOW}[%s]${RESET}" "$model"
fi

# Context usage
if [ -n "$used_pct" ]; then
    printf " ctx:%.0f%%" "$used_pct"
fi