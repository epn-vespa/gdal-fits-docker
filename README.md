# GDAL FITS Docker Images

This is a Fedora derived image containing the Geospatial Data Abstraction
Library (GDAL) compiled with the improved FITS driver. The build process is
based on that defined
[here](https://voparis-confluence.obspm.fr/display/VES/GDAL+with+FITS).

Python3 bindings are also built.
QGIS will coming soon

## Download

```
$ git clone https://github.com/epn-vespa/gdal-fits-docker.git
$ cd gdal-fits-docker
$ git checkout fedora
```

## Build

```
$ ./build_docker.sh [user] [user_id]
```

The container will not run commands as root, if you need to correctly access
your data stored in the current directory, you will need to add user and user_id
as the current user and user_id.

## Usage

Running the container without any arguments will by default output the GDAL
version string as well as the supported raster and vector formats:

    docker run gdal-fits

The following command will open a bash shell in a Fedora based environment
with GDAL available:

    docker run -t -i gdal-fits /bin/bash

You will most likely want to work with data on the host system from within the
docker container, in which case run the container with the -v option. Assuming
you have a raster called `test.fits` in your current working directory on your
host system, running the following command should invoke `gdalinfo` on
`test.fits`:

    docker run -v $(pwd):/data gdal-fits gdalinfo test.fits

This works because the current working directory is set to `/data` in the
container, and you have mapped the current working directory on your host to
`/data`.

### Troubleshooting

#### On Linux

- Permission denied when trying to connect to the socket: see [Docker postinstall documentation](https://docs.docker.com/install/linux/linux-postinstall/)
- Permission denied on directories and files: create a user with the same name UID and GID
as the owner of the directory and the files.
- Permission denied on directories and files (still, on Fedora): this is a SElinux issue
see [this page](https://medium.com/@gloriapalmagonzalez/permission-denied-on-accessing-host-directory-in-docker-5ca5ee76e8b1)

#### On Windows

- The input device is not a TTY: if you are using mintty, try prefixing the command with
'winpty', see the solution [here](https://willi.am/blog/2016/08/08/docker-for-windows-interactive-sessions-in-mintty-git-bash/).
- No matching manifest for unknown in the manifest list entries: your docker is configured
to work with Windows containers, this is a linux container so switch to linux containers in
docker configuration.
- Strange errors in executing shell scripts: check your clone configuration for EOL in git
for windows, must be "checkout as is, push as Unix style".
