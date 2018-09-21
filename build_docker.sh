# ignore the gdal directory
echo 'gdal/' > gdal/.gitignore
# copy the gdal source locally
git clone https://github.com/epn-vespa/gdal.git
# this removes almost 200MB of git history
rm -rf gdal/.git
docker build gdal:fits .
