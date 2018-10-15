#!/bin/bash
#Função = Backup do banco de dados ProsindW
#Criado em 25-01-2018
#Autor = Jefferson Braga
#Versão 1.0
#START
TIME=`date +%b-%d-%y`
FILENAME=prosindw-$TIME.tar.gz
SRCDIR=/prosindw
DESDIR=/home/hermes/Yandex.Disk/prosindw


FILENAME2=etc-$TIME.tar.gz
SRCDIR2=/etc
DESDIR2=/home/hermes/Yandex.Disk/etc

FILENAME3=acervo-$TIME.tar.gz
SRCDIR3=/usr/share/nginx/atom/uploads
DESDIR3=/home/hermes/atom

FILENAME4=48taxi-$TIME.tar.gz
SRCDIR4=/var/www/html/48taxi
DESDIR4=/home/hermes/Yandex.Disk/48taxi

cd $DESDIR && tar -cpzf $FILENAME  $SRCDIR
cd $DESDIR2 && tar -cpzf $FILENAME2  $SRCDIR2
cd $DESDIR3 && tar -cpzf $FILENAME3  $SRCDIR3
cd $DESDIR4 && tar -cpzf $FILENAME4  $SRCDIR4

# Deleta os arquivos anteriores a 7 dias
find /home/hermes/Yandex.Disk/prosindw -mtime +7 -exec rm -f {} \;
find /home/hermes/Yandex.Disk/etc -mtime +7 -exec rm -f {} \;
find /home/hermes/atom -mtime +2 -exec rm -f {} \;
find /home/hermes/Yandex.Disk/48taxi -mtime +1 -exec rm -f {} \;
#END

