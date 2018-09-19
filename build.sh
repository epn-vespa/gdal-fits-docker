#!/bin/sh

##
# Install GDAL from within a docker container
#
# This script is designed to be run from within a docker container in order to
# install GDAL.
#

set -e

DIR=$(dirname "$(readlink -f "$0")")
#GDAL_VERSION=$(cat ${DIR}/gdal-checkout.txt)

#export DEBIAN_FRONTEND=noninteractive

# Set the locale. Required for subversion to work on the repository.
#update-locale LANG="C.UTF-8"
#dpkg-reconfigure locales
#. /etc/default/locale
#export LANG

# Install prerequisites.
dnf install -y \
#        software-properties-common \
#        wget \
        unzip \
#        subversion \
        ccache-devel \
        clang-devel \
#        patch \
        python3-devel \
        cfitsio-devel \
        automake \
        autoconf

# Everything happens under here.
cd /tmp

# Get GDAL.
git clone https://github.com/epn-vespa/gdal.git .

# Install GDAL.
cd /tmp/gdal/gdal
sh autogen.sh
make -j
make install

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
