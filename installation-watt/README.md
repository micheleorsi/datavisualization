HOW TO CREATE ASSETS
====================
```
./script.sh
```

ASSETS folder
=============
In this file there are files where our study starts from  


References
==========
http://www.census.gov/cgi-bin/geo/shapefiles2010/main
select ZIP Code Tabulation Areas
select 'California' 
unzip file 

ogr2ogr -f "GeoJSON" california_geojson.json tl_2010_06_zcta510.shp
topojson -o california_topojson.json california_geojson.json


