#!/bin/sh

# db stuff
rm working/*.db
rm output/*.csv
brew install sqlite

# geo stuff
brew install gdal
npm update -g topojson

# other stuff
brew install wget

# download population by zip code
if [ ! -f "source/2010+Census+Population+By+Zipcode+(ZCTA).csv" ]
then
    # Download population file
    wget -NP source https://s3.amazonaws.com/SplitwiseBlogJB/2010+Census+Population+By+Zipcode+\(ZCTA\).csv
fi

mkdir -p output
mkdir -p source
mkdir -p working

# download source file
if [ ! -f "source/tl_2010_06_zcta510.shp" ]
then
    # Download shape file
    wget -NP source http://www2.census.gov/geo/tiger/TIGER2010/ZCTA5/2010/tl_2010_06_zcta510.zip
    # unzip to source dir
	unzip "source/tl_2010_06_zcta510.zip" -d source
fi

# create topojson for california
if [ ! -f "output/CA_zip.topo.json" ]
then
	# create a new file called 'CA_zip.json' in 'GeoJSON' format 
	ogr2ogr -f "GeoJSON" working/CA_zip.json source/tl_2010_06_zcta510.shp
	# transform file called 'CA_zip.json' into topojson 'CA_zip.topo.json'
	topojson -p -o output/CA_zip.topo.json working/CA_zip.json
fi

# create DB and applied sql commands in order to export csv final files
sqlite3 working/installation.db < sqlcommands.sql

