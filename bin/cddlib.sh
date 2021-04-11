#!/bin/sh

INSTALL_PREFIX=${HOME}/.local
CDD_VERSION=cddlib-0.94m
wget https://github.com/cddlib/cddlib/releases/download/0.94m/${CDD_VERSION}.tar.gz
tar zxf ${CDD_VERSION}.tar.gz
cd ${CDD_VERSION}
./configure --prefix=${INSTALL_PREFIX}
make install
ln -s ${INSTALL_PREFIX}/include/cddlib ${INSTALL_PREFIX}/include/cdd
