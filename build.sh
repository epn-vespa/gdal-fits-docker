#!/bin/bash

##
# Install GDAL from within a docker container
#
# This script is designed to be run from within a docker container in order to
# install GDAL.
#

set -e

DIR=$(dirname "$(readlink -f "$0")")

export DEBIAN_FRONTEND=noninteractive

# Install prerequisites.
apt-get update -y
apt-get install -y \
        software-properties-common bison ca-certificates cmake cmake-curses-gui dh-python doxygen expect \
        unzip flex git graphviz libexiv2-dev libexpat1-dev libfcgi-dev libgeos-dev libgsl-dev \
        ccache libosgearth-dev libpq-dev libproj-dev libqca-qt5-2-dev libqca-qt5-2-plugins \
        libcfitsio-dev libqt5opengl5-dev libqt5scintilla2-dev libqt5serialport5-dev \
        llvm-dev patch g++ libqt5sql5-sqlite libqt5svg5-dev libqt5webkit5-dev libqt5xmlpatterns5-dev \
        libqwt-qt5-dev libspatialindex-dev libspatialite-dev libsqlite3-dev libsqlite3-mod-spatialite \
        automake libyaml-tiny-perl libzip-dev locales ninja-build ocl-icd-opencl-dev opencl-headers \
        autoconf pkg-config poppler-utils pyqt5-dev pyqt5-dev-tools pyqt5.qsci-dev python-autopep8 \
        make python3-dateutil python3-dev python3-future python3-httplib2 python3-jinja2 \
        python3-all-dev python3-markupsafe python3-mock python3-nose2 python3-owslib python3-plotly \
        ant python3-psycopg2 python3-pygments python3-pyproj python3-pyqt5 python3-pyqt5.qsci \
        python3-astropy python3-numpy python3-matplotlib python3-pyqt5.qtsql python3-pyqt5.qtsvg \
        firefox jupyter-notebook python3-pyqt5.qtwebkit python3-requests python3-sip \
        python3-sip-dev python3-six python3-termcolor python3-tz python3-yaml qt3d-assimpsceneimport-plugin \
        qt3d-defaultgeometryloader-plugin qt3d-gltfsceneio-plugin qt3d-scene2d-plugin qt3d5-dev qt5-default \
        qt5keychain-dev qtbase5-dev qtbase5-private-dev qtpositioning5-dev qttools5-dev qttools5-dev-tools \
        saga spawn-fcgi txt2tags xauth xfonts-100dpi xfonts-75dpi xfonts-base xfonts-scalable xvfb

# everything happens under here.
cd /usr/local/src/gdal-fits-docker/

# Install GDAL.
cd gdal/gdal
./autogen.sh
./configure --prefix=/usr/
make -j 7 #-s
make -s install

# Compile python bindings
cd swig/python
python3 setup.py build
python3 setup.py install
cd /usr/local/src/gdal-fits-docker/

# Install QGIS
cd QGIS-ltr-3_4
mkdir build-master; cd build-master;
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DWITH_GRASS7=FALSE ../
make -j 7
make -s install

# Linking libraries in standardpath
#cd /usr/lib64
#ln -s /usr/lib/libqgis* .

# Clean up.
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/partial/* /tmp/* /var/tmp/*

