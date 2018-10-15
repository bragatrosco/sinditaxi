#!/bin/bash
# Script que faz dumps de todo o banco de dados em arquivos separados
#Função = Backup do banco de dados Mysql
#Criado em 25-01-2018
#Autor = Jefferson Braga

USER="root"
PASSWORD="466874"
HOST="localhost"
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"
OUTPUT_DIR="/home/hermes/Yandex.Disk/mysql"
ID='1D5oA8O8vWZVUhlPHOnwZETbqRR6Oa7pl'

# Parse options
while getopts ":u:p:h:o:" opt; do
    case $opt in
        u)
            USER=$OPTARG
            ;;
        p)
            PASSWORD=$OPTARG
            ;;
        h)
            HOST=$OPTARG
            ;;
        o)
            OUTPUT_DIR=$OPTARG
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

VALIDATION_ERROR=false

if [ -z "$USER" ]; then
    echo "User has not been specified" >&2
    VALIDATION_ERROR=true
fi

if [ -z "$PASSWORD" ]; then
    echo "Password has not been specified" >&2
    VALIDATION_ERROR=true
fi

if [ -z "$OUTPUT_DIR" ]; then
    echo "Output dir has not been specified" >&2
    VALIDATION_ERROR=true
fi

if $VALIDATION_ERROR ; then
    exit 1
fi

dd=`date +%Y%m%d`

DBS="$($MYSQL -u $USER -h $HOST -p$PASSWORD -Bse 'show databases')"
for db in $DBS
do
    if [ $db != "information_schema" ]; then
  FILE=$OUTPUT_DIR/$db$dd.sql
        $MYSQLDUMP -u $USER -h $HOST -p$PASSWORD --skip-lock-tables $db > $FILE
    fi
done

# Delete all backups older than 7 days
find //home/hermes/Yandex.Disk/mysql -mtime +7 -exec rm -f {} \;

gdrive sync upload /home/hermes/Yandex.Disk $ID
