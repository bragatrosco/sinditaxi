#!/usr/bin/env bash
set -e;

if [  $# -le 2 ] 
then 
    echo "Usage: ./backup.sh [platform] [gdrive folder id] [file to backup]";
    exit 1;
fi 

# Arguments
directory=`dirname "$0"`
gdrive=$directory/gdrive-$1
backup_directory_id=$2
file_to_backup=$3

# Backs up the current file
#$gdrive upload --parent $backup_directory_id $file_to_backup;

hundred_days_ago=`python -c 'from datetime import datetime as dt, timedelta as delta; print((dt.now() - delta(days=2)).strftime("%Y-%m-%d"))'`;
expired_backups=`gdrive list -m 1000 --query " ('$backup_directory_id' in parents) and trashed = false and modifiedTime < '$hundred_days_ago'" --order "modifiedTime asc" --no-header | cut -d ' ' -f1`;

# Deletes backups that are more than 100 days old.
while read -r backup_id; do
    echo Deleting $backup_id;
    gdrive delete $backup_id;
done <<< "$expired_backups"
