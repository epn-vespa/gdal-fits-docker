# Parsing arguments in command line
options=''

if [ $1 ]
then
  USER=$1
  options=`echo "$options --build-arg USER=$USER"`
fi

if [ $2 ]
then
  USER_ID=$2
  options=`echo "$options --build-arg USER_ID=$USER_ID"`
fi

# ignore the gdal directory
echo 'gdal/' > .gitignore
echo 'QGIS*/' >> .gitignore

# copy the gdal source locally
git clone https://github.com/epn-vespa/gdal.git
# this removes almost 200MB of git history
rm -rf gdal/.git

# copy and extract the qgis latest version source locally
wget -nc https://github.com/qgis/QGIS/archive/ltr-3_4.tar.gz
tar zxvf ltr-3_4.tar.gz


echo "Running: docker build $options -t gdal-fits ."
docker build $options -t gdal-fits .

