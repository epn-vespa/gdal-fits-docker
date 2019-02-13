# GDAL FITS Docker Images

This is an Ubuntu derived image containing the Geospatial Data Abstraction
Library (GDAL) compiled with the improved FITS driver. The build process is
based on that defined
[here](https://voparis-confluence.obspm.fr/display/VES/GDAL+with+FITS).

Python bindings and QGIS are also built.

NOTA BENE: QGIS compilation is on-hold, waiting for PROJ6 compatibility.

## Download

```
$ git clone https://github.com/epn-vespa/gdal-fits-docker.git
$ cd gdal-fits-docker
$ git checkout ubuntu
```

## Build

```
$ ./build_docker.sh [user] [user_id]
```

The container will not run commands as root, if you need to correctly access your data stored in the current directory, you will need to add user and user_id as the current user and user_id. By default user is 'user' and user_id is 1000.

## Usage

Running the container with X server and diplay set will open QGIS:

    docker run --rm -it -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix:1 gdal-fits

The following command will open a bash shell in a Fedora based environment with GDAL and QGIS available:

    docker run --rm -it -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix:1 gdal-fits /bin/bash

You will most likely want to work with data on the host system from within the
docker container, in which case run the container with the -v option. Assuming
you have a raster called `test.fits` in your current working directory on your
host system, running the following command should invoke `gdalinfo` on
`test.fits`:

    docker run -v $(pwd):/data gdal-fits gdalinfo test.fits

This works because the current working directory is set to `/data` in the
container, and you have mapped the current working directory on your host to
`/data`.

Similarly

    docker run --rm -it -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix:0 -v $(pwd):/data gdal-fits

will open QGIS making available the data in your current directory in the `/data` volume.

Alternatively you can use [dockeri](https://github.com/chbrandt/dockeri) to easily start the graphical interface:

    dockeri gdal-fits

will directly open QGIS.

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
- docker.exe: Error response from daemon: Mount denied: The source path "C:/;C" doesn't exist and is not known to Docker: check the solution [here](https://blogs.msdn.microsoft.com/stevelasker/2016/06/14/configuring-docker-for-windows-volumes/)
