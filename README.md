# GDAL FITS Docker Images

This is a Fedora derived image containing the Geospatial Data Abstraction
Library (GDAL) compiled with the improved FITS driver. The build process is
based on that defined
[here](https://voparis-confluence.obspm.fr/display/VES/GDAL+with+FITS).

Python bindings are also built.
QGIS will coming soon

## Download

```
$ git clone https://github.com/epn-vespa/gdal-fits-docker.git
$ cd gdal-fits-docker
$ git checkout <your-preferred-distro-branch>
$ ./build_docker.sh
```

## Usage

Running the container without any arguments will by default output the GDAL
version string as well as the supported raster and vector formats:

    docker run epn-vespa/gdal-fits

The following command will open a bash shell in a Fedora based environment
with GDAL available:

    docker run -t -i epn-vespa/gdal-fits /bin/bash

You will most likely want to work with data on the host system from within the
docker container, in which case run the container with the -v option. Assuming
you have a raster called `test.fits` in your current working directory on your
host system, running the following command should invoke `gdalinfo` on
`test.fits`:

    docker run -v $(pwd):/data epn-vespa/gdal-fits gdalinfo test.fits

This works because the current working directory is set to `/data` in the
container, and you have mapped the current working directory on your host to
`/data`.

Note that the image tagged `latest`, GDAL represents the latest code *at the
time the image was built*. If you want to include the most up-to-date commits
then you need to build the docker image yourself locally along these lines:

    docker build -t geodata/gdal:local git://github.com/epn-vespa/gdal-fits-docker/
