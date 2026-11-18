#!/bin/bash

umask 077

BACKUP_DIR="/var/backups/school-site"
TIMESTAMP=$(date +%F_%H-%M-%S)

TEMP="$BACKUP_DIR/.partial-$TIMESTAMP"
DEST="$BACKUP_DIR/$TIMESTAMP"

# Create a directory and copy website files from A
if mkdir "$TEMP" && rsync -a --no-owner --no-group \
    --exclude='.git/' \
    --exclude='.venv/' \
    --exclude='__pycache__/' \
    --exclude='.env*' \
    --exclude='*.pem' \
    --exclude='*.key' \
    --exclude='*.sql*' \
    -e "ssh -i /home/webbackup/.ssh/pull_ed25519 -o BatchMode=yes" \
    backupread@192.168.1.194:/var/www/school-site/ "$TEMP/" \
    && mv "$TEMP" "$DEST"; then

    echo "$(date): SUCCESS $DEST" >> "$BACKUP_DIR/backup.log"

else
    echo "$(date): FAILED $TIMESTAMP" >> "$BACKUP_DIR/backup.log"
    exit 1
fi
