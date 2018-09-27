#!/bin/sh

##
# Install GDAL from within a docker container
#
# This script is designed to be run from within a docker container in order to
# install GDAL.
#

set -e

DIR=$(dirname "$(readlink -f "$0")")

# Install prerequisites.
dnf install -y unzip \
        ccache \
        cfitsio-devel \
        jasper-devel \
        llvm-devel patch gcc-c++ \
        automake \
        autoconf \
        make \
        python3-devel \
        ant \
        python3-astropy python3-numpy python3-matplotlib \
        python3-jupyterlab-launcher.noarch

# Everything happens under here.
cd /usr/local/src/gdal-fits-docker/

# Install GDAL.
cd gdal/gdal
./autogen.sh
./configure
make -j 4 #-s
make -s install

# Compile python bindings
cd swig/python
python3 setup.py build
python3 setup.py install

# Linking libraries in standardpath (because python is looking there)
cd /usr/lib64
ln -s /usr/local/lib64/libgdal* .

# Clean up.
dnf autoremove -y
dnf clean all

