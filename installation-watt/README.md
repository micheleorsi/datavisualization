Installation watt
=================
This datavisualization shows resindential solar panels installed in California between 2007-2012. Data is expressed in Watt installed per population 

Data visualization
------------------
* [Watt/population per zipcode in 2007](http://micheleorsi.github.io/datavisualization/installation-watt/index2007.html)
* [Watt/population per zipcode in 2012](http://micheleorsi.github.io/datavisualization/installation-watt/index2012.html)

Installing via Homebrew
-----------------------
Before to start you'll need to install some tools.

### On Mac OS X
Here's how to do that using [Homebrew](http://brew.sh/):

```bash
brew install node gdal sqlite git
```

### On Debian/Ubuntu Linux
Here's how to do that on Ubuntu Linux:

```bash
sudo apt-get update
sudo apt-get install nodejs npm curl sqlite gdal-bin git
```

Then, clone this repository and install its dependencies:

```bash
git clone https://github.com/micheleorsi/datavisualization.git
cd datavisualization/installation-watt
npm install
```

Make targets
------------
In order to see the datavisualization you need three files:
* output/ca.topo.json 
* output/trend2007.csv 
* output/trend2012.csv

You can generate them with this command
```bash
make
```


ASSETS folder
-------------
In this file there are several files that is not possible to automatically download from internet  

* installation-data.csv: it is the file produced by our study. It contains these columns:
  * year: the year when the installation has been performed
  * zipcode: the zipcode where the installation has been performed 
  * city: the city where the installation has been performed
  * county: the county where the installation has been performed
  * installation_zip: the installation of that specific year in that specific zipcode
  * trend: the sum along the years for that specific zipcode
  
  The study starts from these data: https://www.californiasolarstatistics.ca.gov
  
* ACS_12_5YR_B01003_with_ann.csv, ACS_11_5YR_B01003_with_ann.csv: information regarding population for each zipcode. To download:
  1. Go to factfinder2.census.gov (pay attention that from some specific internet providers the website is not available)
  2. Find where it says "American Community Survey" and click "get data »"
  3. Click the blue "Geographies" button on the left
  4. In the pop-up, select 5-Digit ZIP Code Tabulation Area - 860 in the "geographic type" menu
  5. Select California in the resulting "state" menu
  6. Click "All 5-Digit ZIP Code Tabulation Areas fully within/partially within California~5-Digit ZCTA~860~2012"
  7. Click the "ADD TO YOUR SELECTIONS" button
  8. Click "CLOSE" to dismiss the pop-up
  9. Click the blue "Topics" button on the left
  10. In the pop-up, expand the "People" submenu
  11. Expand the "Basic Count/Estimate" submenu
  12. Click "Population Total"
  13. Click "CLOSE" to dismiss the pop-up
  14. In the table, click on the 2012 and 2011 ACS 5-year estimate named "TOTAL POPULATION"
  15. On the next page, click the "Download" link under "Actions"
  16. In the pop-up, click "OK"
  17. Wait for it to "build" your file
  18. When it's ready, click "DOWNLOAD"
  19. Finally, expand the downloaded zip file and you will find the three files
  
References
==========
I used a lot of resources to help diving in the field of data visualization and geospatial data.

Here they are:
* [climate map produced by Berkely](http://coolclimate.berkeley.edu/maps)
* [tool to select the best colors](http://colorbrewer2.org/)
* [Choropleth Maps](http://synthesis.sbecker.net/articles/2012/07/18/learning-d3-part-7-choropleth-maps)
* [let's make a map](http://bost.ocks.org/mike/map/)
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

