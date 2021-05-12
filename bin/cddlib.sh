#!/bin/sh

#=============================================================================
# Copyright (C) 2021, Robotic Systems Lab, ETH Zurich
# All rights reserved.
# http://www.rsl.ethz.ch
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================

# Exits if error occurs
set -e

# Set package root path
DIR="$(dirname "$( realpath "$0" )" )"

# Define default configuration
VERSION=0.94m
PREFIX=$HOME/.local

# Parse arguments
for i in "$@"
do
case $i in
  --prefix=*)
    PREFIX=$(eval realpath -m "${i#*=}")
    shift # past argument=value
    ;;
  --version=*)
    VERSION=${i#*=}
    shift # past argument=value
    ;;
  *)
    echo "[cddlib.sh]: Error: Unknown argument(s)"
    exit 1
    ;;
esac
done

# Helper variables
CDDLIB=cddlib-$VERSION
TAR=$CDDLIB.tar.gz

# Download and extract source files
cd $DIR
wget https://github.com/cddlib/cddlib/releases/download/$VERSION/$TAR
tar zxf $TAR

# Build and install
cd $CDDLIB
./configure --prefix=$PREFIX
make install

# We create a symlink in order to resolve include directory path
ln -s $PREFIX/include/cddlib $PREFIX/include/cdd

# Cleanup
rm $DIR/$TAR
rm -r $DIR/$CDDLIB

# EOF
