##
# epn-vespa/gdal-fits
#
# This creates a Fedora derived base image that installs the GDAL
# git clone compiled with the improved FITS driver.  The build process
# is based on that defined in
# <https://voparis-confluence.obspm.fr/display/VES/GDAL+with+FITS>
#

# Fedora 28
FROM fedora:28

MAINTAINER Chiara Marmo <chiara.marmo@u-psud.fr>

# Install the application.
ADD . /usr/local/src/gdal-fits-docker/
RUN /usr/local/src/gdal-fits-docker/build.sh

# Externally accessible data is by default put in /data
WORKDIR /data
VOLUME ["/data"]

# Output version and capabilities by default.
CMD gdalinfo --version && gdalinfo --formats && ogrinfo --formats
