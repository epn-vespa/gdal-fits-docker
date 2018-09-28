##
# geodata/gdal
#
# This creates an Ubuntu derived base image that installs the latest GDAL
# subversion checkout compiled with a broad range of drivers.  The build process
# is based on that defined in
# <https://github.com/OSGeo/gdal/blob/trunk/.travis.yml>
#

# Ubuntu 18.04 Bionic
FROM ubuntu:bionic

MAINTAINER Chiara Marmo <chiara.marmo@u-psud.fr>

# Install the application.
RUN ls /usr/local/src/
ADD . /usr/local/src/gdal-fits-docker/
RUN /usr/local/src/gdal-fits-docker/build.sh

# Externally accessible data is by default put in /data
WORKDIR /data
VOLUME ["/data"]

# Create local user : UID and USER are arguments
ARG USER_ID=1000
ARG USER=user
RUN groupadd -r -g ${USER_ID} ${USER}
RUN useradd -r -u ${USER_ID} -g ${USER} -d /data/${USER} ${USER}

# Run from USER
USER ${USER}

# Output version and capabilities by default.
CMD gdalinfo --version && gdalinfo --formats && ogrinfo --formats
