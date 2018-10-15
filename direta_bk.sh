#!/bin/sh

#Our temporary backups will be arhived in this folder
TMPBACKUP='/backup/'
#Website to backup (used only for naming purposes)
SITE='direta'
#Directory that will be archived and backed up
BACKUPDIR='/prosindw'
#Remote Google Drive directory ID where the file will be uploaded
ID='0BxKlSxLllnJLakc4enNGM2oxTU0'

if [ ! -d "$TMPBACKUP" ]; then
        mkdir $TMPBACKUP
fi

cd $TMPBACKUP
#Archive the directory
tar -zcf "$SITE-$(date '+%Y-%m-%d').tar.gz" $BACKUPDIR

# upload to google drive and delete the source file
gdrive upload "$SITE-$(date '+%Y-%m-%d').tar.gz" -p $ID 

#limpar arquivos locais
rm -rf $TMPBACKUP
mkdir $TMPBACKUP
