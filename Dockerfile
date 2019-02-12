##
# epn-vespa/gdal-fits
#
# This creates a Fedora derived base image that installs the GDAL
# git clone compiled with the improved FITS driver.  The build process
# is based on that defined in
# <https://voparis-confluence.obspm.fr/display/VES/GDAL+with+FITS>
#

# Fedora 29
FROM fedora:29

MAINTAINER Chiara Marmo <chiara.marmo@u-psud.fr>

# Install the application.
ADD . /usr/local/src/gdal-fits-docker/
RUN /usr/local/src/gdal-fits-docker/build.sh

# Externally accessible data is by default put in /data
WORKDIR /data
VOLUME ["/data"]

# Create local user : UID and USER are arguments
ARG USER_ID=1000
ARG USER=user
RUN groupadd -r -g ${USER_ID} ${USER}     &&\
    useradd -r -u ${USER_ID} -g ${USER}     \
            -m -d /home/${USER} ${USER}

# Run from USER
USER ${USER}

# Open QGIS FITS compatible by default
#CMD qgis

# gdalinfo version
CMD gdalinfo --version

