#!/bin/bash

# Backup Script: Backs up user-specified directories and logs the process.

# Constant Variables
BACKUP_DIR="/home/ahmad-al-soub/assignmentThree/backup"  # Directory to store the backups
LOG_FILE="$BACKUP_DIR/backup_log.txt"  # Log file to track process
DATE=$(date +'%Y-%m-%d_%H-%M-%S')  # Current timestamp for naming backups


mkdir -p "$BACKUP_DIR" # Create the backup directory if it doesn't exist

# Function to log messages
log_message() {
    echo "$1" | tee -a "$LOG_FILE"
}

# Start the script
log_message "Backup Script Started: $DATE"

# Check if directories are provided as arguments
if [ $# -eq 0 ]; then
    log_message "Error: No directories specified for backup."
    exit 1
fi

# Loop through user-specified directories and back them up
for DIR in "$@"; do
    if [ -d "$DIR" ]; then
        # Define the backup file name
        BACKUP_FILE="$BACKUP_DIR/$(basename "$DIR")_$DATE.tar.gz"

        # Compress the directory into a tar.gz file
        tar -czf "$BACKUP_FILE" "$DIR" 2>>"$LOG_FILE"
        if [ $? -eq 0 ]; then
            BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
            log_message "Backup successful for: $DIR (Size: $BACKUP_SIZE)"
        else
            log_message "Error: Failed to backup $DIR"
        fi
    else
        log_message "Error: Directory $DIR does not exist."
    fi
done

# End The Script
log_message "Backup Script Completed: $DATE"
exit 0
