# Installation watt

This datavisualization shows resindential solar panels installed in California between 2007-2012. 
Data is expressed in Watt installed per population 

## Data visualization

<table>
<tr height="162">
<td>ZIP code 2007<br><a href="http://micheleorsi.github.io/datavisualization/installation-watt/index2007.html"><img src="https://cloud.githubusercontent.com/assets/1033117/14233041/0c81f1d0-f9b5-11e5-80ed-4d643ba1babf.png"></a></td>
<td>ZIP code 2012<br><a href="http://micheleorsi.github.io/datavisualization/installation-watt/index2012.html"><img src="https://cloud.githubusercontent.com/assets/1033117/14233042/10ac2a3c-f9b5-11e5-845b-c5bee229e595.png"></a></td>
</tr>
<tr height="162">
<td>Sonoma County 2007<br><a href="http://micheleorsi.github.io/datavisualization/installation-watt/sonoma2007.html"><img src="https://cloud.githubusercontent.com/assets/1033117/14233043/10af84a2-f9b5-11e5-800b-4332b0a66e62.png"></a></td>
<td>Sonoma County 2012<br><a href="http://micheleorsi.github.io/datavisualization/installation-watt/sonoma2012.html"><img src="https://cloud.githubusercontent.com/assets/1033117/14233044/114b641c-f9b5-11e5-9e8f-905366666629.png"></a></td>
</tr>
</table>

## Usage

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
sudo apt-get install nodejs npm nodejs-legacy curl unzip sqlite gdal-bin git
```

Then, clone this repository and install its dependencies:

```bash
git clone https://github.com/micheleorsi/datavisualization.git
cd datavisualization/installation-watt
npm install
```

## Build

You can generate all the data needed with this command
```bash
make
```

### Run locally

You should run a local server
```bash
make run
```

Then you should visit the HTML files (this works only locally on your machine) at 
* [index2007.html](http://localhost:8000/index2007.html) 
* [index2012.html](http://localhost:8000/index2012.html)
* [sonoma2007.html](http://localhost:8000/sonoma2007.html)
* [sonoma2012.html](http://localhost:8000/sonoma2012.html)


## ASSETS

In this folder there are several files that is not possible to automatically download from internet.


### installation-data.csv

The study starts from these data: https://www.californiasolarstatistics.ca.gov
This is the file produced by our study.

It contains the following columns:
  * `year`: the year when the installation has been performed
  * `zipcode`: the zipcode where the installation has been performed
  * `city`: the city where the installation has been performed
  * `county`: the county where the installation has been performed
  * `installation_zip`: the installation of that specific year in that specific zipcode
  * `trend`: the sum along the years for that specific zipcode

### PEP_2013_PEPANNRES_with_ann.csv

Information regarding population by county in California.

The file is available [here](http://factfinder.census.gov/faces/tableservices/jsf/pages/productview.xhtml?src=CF)

It containes the following columns:
* `GEO.id`
* `GEO.id2`
* `GEO.display-label`
* `rescen42010`
* `resbase42010`
* `respop72010`
* `respop72011`
* `respop72012`
* `respop72013`

### population_by_city.csv

Information regarding population by city in California.

The file is available [here](http://www.city-data.com/city/California.html), with filter `All cities`

It contains the following columns:
* `CITY`: the California city
* `POPULATION`: the amount of population

## Data downloaded

### zcta_county_rel_10.csv

Information available [here](https://www.census.gov/geo/maps-data/data/zcta_rel_layout.html)

It contains the following columns:
* `ZCTA5`
* `STATE`
* `COUNTY`
* `GEOID`
* `POPPT`
* `HUPT`
* `AREAPT`
* `AREALANDPT`
* `ZPOP`
* `ZHU`
* `ZAREA`
* `ZAREALAND`
* `COPOP`
* `COHU`
* `COAREA`
* `COAREALAND`
* `ZPOPPCT`
* `ZHUPCT`
* `ZAREAPCT`
* `ZAREALANDPCT`
* `COPOPPCT`
* `COHUPCT`
* `COAREAPCT`
* `COAREALANDPCT`


## References

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
* [how to extract zip files for california](http://tech.taskrabbit.com/blog/2014/12/04/maps-for-data-exploration/)
* [California population density](http://bl.ocks.org/mbostock/5562380)
* [Albers Equal-Area Conic](http://bl.ocks.org/mbostock/3734308)
* [Lambert Conformal Conic](http://bl.ocks.org/mbostock/3734321)
* [california sample map](http://shancarter.github.io/ucb-dataviz-fall-2013/classes/interactive-maps/)
* [merge csv with shp to obtain topojson](http://bl.ocks.org/mbostock/5562380)
* [add properties to topojson](http://stackoverflow.com/questions/18444261/how-to-add-properties-to-topojson-file)
* [russia choropleth](http://bl.ocks.org/KoGor/5685876)
* [topojson repo](https://github.com/mbostock/topojson)
* [National Atlas and U.S. Census Bureau script download](https://github.com/mbostock/us-atlas)
