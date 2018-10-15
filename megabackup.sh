#!/bin/bash

SERVER="DellSinditaxi"
DAYS_TO_BACKUP=7
WORKING_DIR="/media/Storage/Backups"

BACKUP_MYSQL="true"
MYSQL_USER="root"
MYSQL_PASSWORD="466874"

DOMAINS_FOLDER="/var/www"
ATOM="/usr/shar/nginx/atom"
ETC="/etc"
OPT="/opt/wildfly"
PROSINDW="/prosindw"
##################################
# Create local working directory and collect all data
rm -rf ${WORKING_DIR}
mkdir ${WORKING_DIR}
cd ${WORKING_DIR}

# Backup /etc folder
cd /
tar cJf ${WORKING_DIR}/etc.tar.gx etc
cd - > /dev/null

# Backup MySQL
if [ "${BACKUP_MYSQL}" = "true" ]
then
        mkdir ${WORKING_DIR}/mysql
        for db in $(mysql -u${MYSQL_USER} -p${MYSQL_PASSWORD} -e 'show databases;' | grep -Ev "^(Database|mysql|information_schema|performance_schema|phpmyadmin)$")
        do
                #echo "processing ${db}"
                mysqldump --opt -u${MYSQL_USER} -p${MYSQL_PASSWORD} "${db}" | gzip > ${WORKING_DIR}/mysql/${db}_$(date +%F_%T).sql.gz
        done
        #echo "all db now"
        mysqldump --opt -u${MYSQL_USER} -p${MYSQL_PASSWORD} --events --ignore-table=mysql.event --all-databases | gzip > ${WORKING_DIR}/mysql/ALL_DATABASES_$(date +%F_%T).sql.gz
fi

# Backup domains
mkdir ${WORKING_DIR}/domains
for folder in $(find ${DOMAINS_FOLDER} -mindepth 1 -maxdepth 1 -type d)
do
        cd $(dirname ${folder})
        tar cJf ${WORKING_DIR}/domains/$(basename ${folder}).tar.xz $(basename ${folder})
        cd - > /dev/null
done
##################################

# Backup Atom
mkdir ${WORKING_DIR}/atom
for folder in $(find ${ATOM} -mindepth 1 -maxdepth 1 -type d)
do
        cd $(dirname ${folder})
        tar cJf ${WORKING_DIR}/atom/$(basename ${folder}).tar.xz $(basename ${folder})
        cd - > /dev/null
done
##################################

# Backup Etc
mkdir ${WORKING_DIR}/etc
for folder in $(find ${ETC} -mindepth 1 -maxdepth 1 -type d)
do
        cd $(dirname ${folder})
        tar cJf ${WORKING_DIR}/etc/$(basename ${folder}).tar.xz $(basename ${folder})
        cd - > /dev/null
done
##################################

# Backup Opt
mkdir ${WORKING_DIR}/opt
for folder in $(find ${OPT} -mindepth 1 -maxdepth 1 -type d)
do
        cd $(dirname ${folder})
        tar cJf ${WORKING_DIR}/opt/$(basename ${folder}).tar.xz $(basename ${folder})
        cd - > /dev/null
done
##################################

# Backup ProsindW
mkdir ${WORKING_DIR}/
for folder in $(find ${PROSINDW} -mindepth 1 -maxdepth 1 -type d)
do
        cd $(dirname ${folder})
        tar cJf ${WORKING_DIR}/prosindw/$(basename ${folder}).tar.xz $(basename ${folder})
        cd - > /dev/null
done
##################################

# Workaround to prevent dbus error messages
export $(dbus-launch)

# Create base backup folder
[ -z "$(megals --reload /Root/backup_${SERVER})" ] && megamkdir /Root/backup_${SERVER}

# Remove old logs
while [ $(megals --reload /Root/backup_${SERVER} | grep -E "/Root/backup_${SERVER}/[0-9]{4}-[0-9]{2}-[0-9]{2}$" | wc -l) -gt ${DAYS_TO_BACKUP} ]
do
        TO_REMOVE=$(megals --reload /Root/backup_${SERVER} | grep -E "/Root/backup_${SERVER}/[0-9]{4}-[0-9]{2}-[0-9]{2}$" | sort | head -n 1)
        megarm ${TO_REMOVE}
done

# Create remote folder
curday=$(date +%F)
megamkdir /Root/backup_${SERVER}/${curday} 2> /dev/null

# Backup now!!!
megacopy --reload --no-progress -l ${WORKING_DIR} -r /Root/backup_${SERVER}/${curday} > /dev/null

# Kill DBUS session daemon (workaround)
kill ${DBUS_SESSION_BUS_PID}
rm -f ${DBUS_SESSION_BUS_ADDRESS}

# Clean local environment
rm -rf ${WORKING_DIR}
exit 0
