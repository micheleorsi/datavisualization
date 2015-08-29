INSTALLATION WATT
=================

This is a datavisualization to show the trend along the years (2007-2012) in California about how many residentials solar panels have been installed.
The data shown represents the Watt installed per popoulation

PRODUCE DATA
------------

In order to produce the data you need for datavisualization you should run this script.
This works only if you have are connected to internet and if you have a OS X operating system

```
./script.sh
```

ASSETS folder
=============

In this file there are several files that is not possible to automatically download from internet  

* installation-data.csv: it is the file produced by our study. It contains these columns:
** year
** zipcode
** city
** county
** installation_zip
** trend

DEMO
----

References
==========
http://www.census.gov/cgi-bin/geo/shapefiles2010/main
select ZIP Code Tabulation Areas
select 'California' 
unzip file 

ogr2ogr -f "GeoJSON" california_geojson.json tl_2010_06_zcta510.shp
topojson -o california_topojson.json california_geojson.json


