INSTALLATION WATT
=================
This is a datavisualization to show the trend along the years (2007-2012) in California about how many residentials solar panels have been installed.
The data shown represents the Watt installed per popoulation

Data visualization
------------------
[Watt/population per zipcode in 2007](http://micheleorsi.github.io/datavisualization/installation-watt/index2007.html)

[Watt/population per zipcode in 2007](http://micheleorsi.github.io/datavisualization/installation-watt/index2012.html)

Installing via Homebrew
-----------------------
Before you'll need to install Node.js, GDAL and Sqlite. 
Here’s how to do that using [Homebrew](http://brew.sh/) on Mac OS X:

```bash
brew install node gdal sqlite wget
```

Then, clone this repository and install its dependencies:

```bash
git clone https://github.com/micheleorsi/datavisualization.git
cd datavisualization/installation-watt
npm install topojson
```

ASSETS folder
-------------

In this file there are several files that is not possible to automatically download from internet  

* installation-data.csv: it is the file produced by our study. It contains these columns:
  * year
  * zipcode
  * city
  * county
  * installation_zip
  * trend
* ACS_12_5YR_B01003_with_ann.csv: information regarding population
* ca folder: all the shapefile needed for California

References
==========
http://www.census.gov/cgi-bin/geo/shapefiles2010/main
select ZIP Code Tabulation Areas
select 'California' 
unzip file 

```bash
ogr2ogr -f "GeoJSON" california_geojson.json tl_2010_06_zcta510.shp
topojson -o california_topojson.json california_geojson.json
```

* [climate map produced by Berkely](http://coolclimate.berkeley.edu/maps)
* [tool to select the best colors](http://colorbrewer2.org/)
* [Choropleth Maps](http://synthesis.sbecker.net/articles/2012/07/18/learning-d3-part-7-choropleth-maps)
* [let’s make a map](http://bost.ocks.org/mike/map/)
* [mapping town and cities](http://techslides.com/mapping-town-boundaries-with-d3)
* [presentation on geojson](http://lyzidiamond.com/geojson-in-maps/#83)
* [tutorial for geodata and d3js](http://www.tnoda.com/blog/2013-12-07)
* [GUI for GeoJSON and TopoJSON](http://shancarter.github.io/distillery)
* [geo projections](https://github.com/mbostock/d3/wiki/Geo-Projections)
* [how to extract zip files for california](http://tech.taskrabbit.com/blog/2014/12/04/maps-for-data-* exploration/)
* [California population density](http://bl.ocks.org/mbostock/5562380)
* [Albers Equal-Area Conic](http://bl.ocks.org/mbostock/3734308)
* [Lambert Conformal Conic](http://bl.ocks.org/mbostock/3734321)
* [california sample map](http://shancarter.github.io/ucb-dataviz-fall-2013/classes/interactive-maps/)
* [merge csv with shp to obtain topojson](http://bl.ocks.org/mbostock/5562380)
* [add properties to topojson](http://stackoverflow.com/questions/18444261/how-to-add-properties-to-topojson-file)
* [russia choropleth](http://bl.ocks.org/KoGor/5685876)
* [topojson repo](https://github.com/mbostock/topojson)
* [National Atlas and U.S. Census Bureau script download](https://github.com/mbostock/us-atlas)