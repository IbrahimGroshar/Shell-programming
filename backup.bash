#!/usr/bin/env bash

# Ensure an argument is provided
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Assign variables
DIR="$1"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="/tmp/backup_${TIMESTAMP}.tar.gz"

# Check if directory exists
if [[ ! -d "$DIR" ]]; then
    echo "Error: Directory '$DIR' does not exist."
    exit 2
fi

# Check if backup file already exists
if [[ -f "$BACKUP_FILE" ]]; then
    echo "Error: Backup file '$BACKUP_FILE' already exists."
    exit 3
fi

# Start timing the backup
START_TIME=$(date +%s)

# Create the backup
tar -czf "$BACKUP_FILE" "$DIR"

# Stop timing
END_TIME=$(date +%s)
ELAPSED_TIME=$((END_TIME - START_TIME))

# Print success message
echo "Backup completed: $BACKUP_FILE"
echo "Time taken: ${ELAPSED_TIME} seconds."
