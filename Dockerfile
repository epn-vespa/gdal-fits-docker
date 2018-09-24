##
# geodata/gdal
#
# This creates an Ubuntu derived base image that installs the latest GDAL
# subversion checkout compiled with a broad range of drivers.  The build process
# is based on that defined in
# <https://github.com/OSGeo/gdal/blob/trunk/.travis.yml>
#

# Ubuntu 14.04 Trusty Tahyr
FROM ubuntu:trusty

MAINTAINER Chiara Marmo <chiara.marmo@u-psud.fr>

# Install the application.
RUN ls /usr/local/src/
ADD . /usr/local/src/gdal-fits-docker/
RUN /usr/local/src/gdal-fits-docker/build.sh

# Externally accessible data is by default put in /data
WORKDIR /data
VOLUME ["/data"]

# Output version and capabilities by default.
CMD gdalinfo --version && gdalinfo --formats && ogrinfo --formats
