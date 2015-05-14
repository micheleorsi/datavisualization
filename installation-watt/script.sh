#!/bin/sh

if [ ! -f "source/tl_2014_06_place/tl_2014_06_place.shp" ]
then
    echo "Downloading shape file .."
    wget -P source http://www2.census.gov/geo/tiger/TIGER2014/PLACE/tl_2014_06_place.zip

    echo "Unzipping archive .."
    unzip source/tl_2014_06_place.zip -d source/tl_2014_06_place
    rm source/tl_2014_06_place.zip
fi

if [ ! -f "cities.geojson" ]
then
    ogr2ogr -f GeoJSON cities.geojson source/tl_2014_06_place/tl_2014_06_place.shp
fi

if [ ! -f "cities.json" ]
then
    topojson -s 7e-9 --id-property=+GEOID -o cities.json -- cities.geojson
fi

