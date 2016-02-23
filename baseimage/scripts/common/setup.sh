#!/bin/bash

# ALERT: if you encounter an error like:
# error: [Errno 1] Operation not permitted: 'cf_update.egg-info/requires.txt'
# The proper fix is to remove any "root" owned directories under your update-cli directory
# as source mount-points only work for directories owned by the user running vagrant

# Stop on first error
set -e

# Update the entire system to the latest releases
apt-get update -qq

# add OBC PPAs
add-apt-repository ppa:openblockchain/third-party

# install git
apt-get install --yes git

# Set Go environment variables needed by other scripts
export GOPATH="/opt/gopath"
export GOROOT="/opt/go/"
PATH=$GOROOT/bin:$GOPATH/bin:$PATH

#install golang
#apt-get install --yes golang
mkdir -p $GOPATH
mkdir -p $GOROOT

#ARCH=`uname -m | sed 's|i686|386|' | sed 's|x86_64|amd64|'`
ARCH=amd64
GO_VER=1.6

cd /tmp
wget --quiet --no-check-certificate https://storage.googleapis.com/golang/go$GO_VER.linux-${ARCH}.tar.gz
tar -xvf go$GO_VER.linux-${ARCH}.tar.gz
mv go $GOROOT
chmod 775 $GOROOT
rm go$GO_VER.linux-${ARCH}.tar.gz

# Install NodeJS
#cd /tmp
#ver=0.12.7 #Replace this with the latest version available
#wget -c http://nodejs.org/dist/v$ver/node-v$ver.tar.gz #This is to download the source code.
#tar -xzf node-v$ver.tar.gz
#rm node-v$ver.tar.gz
#cd node-v$ver
#./configure && make && sudo make install
#cd /tmp && rm -rf node-v$ver

NODE_VER=0.12.7
NODE_PACKAGE=node-v$NODE_VER-linux-x64.tar.gz
TEMP_DIR=/tmp
SRC_PATH=$TEMP_DIR/$NODE_PACKAGE

cd $TEMP_DIR
# First remove any prior packages downloaded in case of failure
rm -f node*.tar.gz
wget --quiet https://nodejs.org/dist/v$NODE_VER/$NODE_PACKAGE
cd /usr/local && sudo tar --strip-components 1 -xzf $SRC_PATH
#rm $SRC_PATH

# Install GRPC

# ----------------------------------------------------------------
# NOTE: For instructions, see https://github.com/google/protobufy
#
# ----------------------------------------------------------------

# First install protoc
cd /tmp
git clone https://github.com/google/protobuf.git
cd protobuf
git checkout 12fb61b292d7ec4cb14b0d60e58ed5c35adda3b7
#unzip needed for ./autogen.sh
apt-get install -y unzip
apt-get install -y autoconf
apt-get install -y build-essential libtool
./autogen.sh
# NOTE: By default, the package will be installed to /usr/local. However, on many platforms, /usr/local/lib is not part of LD_LIBRARY_PATH.
# You can add it, but it may be easier to just install to /usr instead.
#
# To do this, invoke configure as follows:
#
# ./configure --prefix=/usr
#
#./configure
./configure --prefix=/usr

make
make check
make install
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# Install rocksdb
apt-get install -y librocksdb4.1 libsnappy-dev zlib1g-dev libbz2-dev
