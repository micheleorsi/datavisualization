#!/bin/sh

# db stuff
rm working/*.db
rm output/*.csv
brew install sqlite

# geo stuff
rm working/CA_zip.json
rm output/CA_zip.topo.json
rm working/ca-projected.shp
rm working/merge.shp
rm working/ca.json
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

# create DB and applied sql commands in order to export csv final files
sqlite3 working/installation.db < sqlcommands.sql

# create topojson for california
if [ ! -f "output/CA_zip.topo.json" ]
then
	# merge counties shp and california zip shp into topojson
	topojson -p -o output/ca.topo.json assets/ca/counties.shp source/tl_2010_06_zcta510.shp

	# merge two shapefils
	# ogr2ogr working/merge.shp source/tl_2010_06_zcta510.shp
	# ogr2ogr -update -append working/merge.shp assets/ca/counties.shp -nln merge
	# create a new file in 'GeoJSON' format, called 'ca.json' from file 'working/merge.shp'
	#ogr2ogr -f "GeoJSON" working/ca.json working/merge.shp
	# generate a shapefile in projected coordinates (california albers)
	#ogr2ogr -f 'ESRI Shapefile' -t_srs 'EPSG:3310' working/ca-projected.shp source/tl_2010_06_zcta510.shp
	
	
	# merging trend2007 file with geojson file
	#topojson -e output/trend2007.csv --id-property ZCTA5CE10,ZIPCODE -p -o output/CA_zip_2007.json -- source/tl_2010_06_zcta510.shp
	# merging trend2007 file with geojson file
	#topojson -e output/trend2012.csv --id-property ZCTA5CE10,ZIPCODE -p -o output/CA_zip_2012.json -- source/tl_2010_06_zcta510.shp
fi


