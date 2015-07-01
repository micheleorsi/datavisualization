#!/bin/sh

# db stuff
rm working/*.db
rm output/*.csv
brew install sqlite

# geo stuff
brew install gdal
#npm install -g topojson

# other stuff
brew install wget

# download population by zip code
if [ ! -f "source/2010+Census+Population+By+Zipcode+(ZCTA).csv" ]
then
    echo "Downloading population file .."
    wget -NP source https://s3.amazonaws.com/SplitwiseBlogJB/2010+Census+Population+By+Zipcode+\(ZCTA\).csv
fi

mkdir -p output
mkdir -p source
mkdir -p working

# download source file
if [ ! -f "source/tl_2010_06_zcta510.shp" ]
then
    echo "Downloading shape file .."
    wget -NP source http://www2.census.gov/geo/tiger/TIGER2010/ZCTA5/2010/tl_2010_06_zcta510.zip
	unzip "source/tl_2010_06_zcta510.zip" -d source
fi

# create topojson for california
if [ ! -f "output/CA_zip.topo.json" ]
then
	ogr2ogr -f "GeoJSON" working/CA_zip.json source/tl_2010_06_zcta510.shp tl_2010_06_zcta510
	topojson -p -o output/CA_zip.topo.json working/CA_zip.json
fi

# create DB
sqlite3 working/installation.db < sqlcommands.sql

