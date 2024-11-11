#!/bin/bash

# Define variables
GITHUB_URL="https://raw.githubusercontent.com/rogerrum/homelab-infrastructure/refs/heads/main/tracker/metrics.sh"
TARGET_DIR="$HOME/.tracker"
TARGET_FILE="$TARGET_DIR/metrics.sh"
CRON_JOB="*/15 * * * * $TARGET_FILE"

# Create the target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Download the file from GitHub
curl -o "$TARGET_FILE" "$GITHUB_URL"

# Make the downloaded file executable
chmod +x "$TARGET_FILE"

# Add the cron job
(crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
