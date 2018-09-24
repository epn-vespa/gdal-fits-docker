#!/bin/bash

##
# Install GDAL from within a docker container
#
# This script is designed to be run from within a docker container in order to
# install GDAL. It delegates to `before_install.sh` and `install.sh` which are
# patched from the Travis CI configuration in the GDAL repository.
#

set -e

DIR=$(dirname "$(readlink -f "$0")")

export DEBIAN_FRONTEND=noninteractive

# Set the locale. Required for subversion to work on the repository.
update-locale LANG="C.UTF-8"
dpkg-reconfigure locales
. /etc/default/locale
export LANG

# Install prerequisites.
apt-get update -y
apt-get install -y \
        software-properties-common \
        unzip \
        ccache \
        cfitsio-dev \
        llvm-dev patch libcfitsio3-dev g++\
        patch \
        automake \
        autoconf \
        make \
        python-dev \
        ant
        #python3-astropy python3-numpy python3-matplotlib jupyter-notebook

# everything happens under here.
cd /usr/local/src/gdal-fits-docker/

# Install GDAL.
cd gdal/gdal
./autogen.sh
sh configure # that was missing see [linux - config.status not found - Super User](https://superuser.com/a/272116)
make -j
make install

# Compile python bindings
cd swig/python
python3 setup.py build
python3 setup.py install

# Linking libraries in standardpath (because python is looking there)
cd /usr/lib64
ln -s /usr/local/lib64/libgdal* .

# Apply our build patches.
#patch ./gdal/ci/travis/trusty_clang/before_install.sh ${DIR}/before_install.sh.patch
#patch ./gdal/ci/travis/trusty_clang/install.sh ${DIR}/install.sh.patch

# Do the build.
#. ./gdal/ci/travis/trusty_clang/before_install.sh
#. ./gdal/ci/travis/trusty_clang/install.sh


# Clean up.
#apt-get autoremove -y
#apt-get clean
#rm -rf /var/lib/apt/lists/partial/* /tmp/* /var/tmp/*
