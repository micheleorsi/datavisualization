#!/bin/sh

brew install wget
brew install gdal
npm update -g topojson

# download source file
if [ ! -f "source/tl_2010_06_zcta510.shp" ]
then
    echo "Downloading shape file .."
    wget -NP source http://www2.census.gov/geo/tiger/TIGER2010/ZCTA5/2010/tl_2010_06_zcta510.zip
	unzip "source/tl_2010_06_zcta510.zip" -d source
fi

mkdir -p working

# create topojson for california
if [ ! -f "working/CA_zip.topo.json" ]
then
	ogr2ogr -f "GeoJSON" working/CA_zip.json source/tl_2010_06_zcta510.shp tl_2010_06_zcta510
	topojson -p -o working/CA_zip.topo.json working/CA_zip.json
fi


