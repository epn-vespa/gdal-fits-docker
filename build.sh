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
        ccache patchelf \
        cfitsio-devel \
        jasper-devel \
        llvm-devel patch gcc-c++ \
        libtool automake \
        autoconf \
        make cmake qt5-devel \
        clang expat-devel proj-devel gsl-devel python3-future qwt-devel sip-devel \
        python3-devel qca-qt5-devel qca-qt5-ossl python3-qt5-devel python3-sip-devel \
        ant flex bison geos-devel libzip-devel libsqlite3x-devel qt5-qtserialport-devel.x86_64 \
        python3-qscintilla-qt5-devel qscintilla-qt5-devel python3-qscintilla-devel python3-qscintilla-qt5 \
        libspatialite-devel spatialindex-devel qt5-qtwebkit-devel qt5-qtlocation-devel qt5-qttools-static \
        python3-astropy python3-numpy python3-matplotlib qt5-qt3d-devel sqlite-devel qt5-qtsvg-devel \
        python3-jupyterlab-launcher.noarch qt5-qtxmlpatterns-devel postgresql-devel python3-psycopg2 python3-PyYAML \
        python3-pygments python3-jinja2 python3-OWSLib  qwt-qt5-devel qtkeychain-qt5-devel firefox

dnf update -y

# Everything happens under here.
cd /usr/local/src/gdal-fits-docker/
ls

# Compile and install the last version of proj
# See https://trac.osgeo.org/gdal/wiki/BuildingOnUnixGDAL25dev
cd proj.4
./autogen.sh
CXXFLAGS="-DPROJ_RENAME_SYMBOLS -O2" CFLAGS=$CXXFLAGS ./configure --disable-static --prefix=/usr/
make -j 7 #-s
make -s install
cd /usr/lib64
# Rename the library to libinternalproj
mv libproj.so.13.1.1 libinternalproj.so.13.1.1
ln -s libinternalproj.so.13.1.1 libinternalproj.so.13
ln -s libinternalproj.so.13.1.1 libinternalproj.so
rm -f libproj.*
cd /usr/lib64
ln -s /usr/lib/libinternalproj* .
patchelf --set-soname libinternalproj.so libinternalproj.so

# Install GDAL.
cd /usr/local/src/gdal-fits-docker/gdal/gdal
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
# Commented out waiting for qgis compatibility for proj6
#cd QGIS-ltr-3_4
#mkdir build-master; cd build-master;
#cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DWITH_GRASS7=FALSE ../
#make -j 7
#make -s install

# Linking libraries in standard path
#cd /usr/lib64
#ln -s /usr/lib/libqgis* .

# allow access from localhost
#xhost + 127.0.0.1
# export DISPLAY
#export DISPLAY=localhost:0

# Clean up.
dnf autoremove -y
dnf clean all

