#!/bin/bash
#
# Verificação do serviço Wildfly
#

jboss=`ps axu | grep Standalone | grep -v grep`;

# Testando se o Jboss está rodando

if [ "$jboss" ];
then
    echo "Jboss ON"
else
    echo "Jboss OFF" 
    sudo service wildfly start
fi
