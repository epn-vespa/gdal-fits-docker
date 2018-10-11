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
        make cmake qt5-devel \
        clang expat-devel proj-devel gsl-devel python3-future qwt-devel sip-devel \
        python3-devel qca-qt5-devel qca-qt5-ossl python3-qt5-devel python3-sip-devel \
        ant flex bison geos-devel libzip-devel libsqlite3x-devel \
        python3-qscintilla-qt5-devel qscintilla-qt5-devel python3-qscintilla-devel python3-qscintilla-qt5 \
        libspatialite-devel spatialindex-devel \
        python3-astropy python3-numpy python3-matplotlib \
        python3-jupyterlab-launcher.noarch \
        firefox

# Everything happens under here.
cd /usr/local/src/gdal-fits-docker/
ls

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
cd /usr/local/src/gdal-fits-docker/

# Install QGIS
#cd QGIS-final-3_2_3
#mkdir build-master; cd build-master;
#cmake -DGDAL_CONFIG=/usr/local/bin/gdal-config -DGDAL_CONFIG_PREFER_PATH=/usr/local/bin -DGDAL_INCLUDE_DIR=/usr/local/include -DGDAL_LIBRARY=/usr/local/lib/libgdal.so -DWITH_GRASS7=FALSE ../
#make -j 4
#make -s install

# Linking libraries in standardpath (because python is looking there)
cd /usr/lib64
ln -s /usr/local/lib/libgdal* .

# allow access from localhost
#xhost + 127.0.0.1
# export DISPLAY
#export DISPLAY=localhost:0

# Clean up.
dnf autoremove -y
dnf clean all

