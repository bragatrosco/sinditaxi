#!/bin/bash

VERSION="1.9.98"

apt-get install -y build-essential pkg-config libglib2.0-dev libssl-dev libcurl4-openssl-dev libfuse-dev glib-networking

wget http://megatools.megous.com/builds/megatools-${VERSION}.tar.gz
tar xzf megatools-${VERSION}.tar.gz
cd megatools-${VERSION}
./configure && make && make install && ldconfig
