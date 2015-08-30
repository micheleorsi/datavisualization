
default: output/ca.topo.json output/trend2007.csv output/trend2012.csv output/trendcounty2007.csv output/trendcounty2012.csv

# topojson to work in the dataviz
output/ca.topo.json: shp/ca/counties.shp shp/tl_2010_06_zcta510.shp
	mkdir -p $(dir $@)
	node_modules/.bin/topojson \
		--id-property ZCTA5CE10 -p -o $@ shp/ca/counties.shp shp/tl_2010_06_zcta510.shp

# mapping from zip to counties
csv/zcta_county_rel_10.csv:
	mkdir -p $(dir $@)
	curl 'http://www2.census.gov/geo/docs/maps-data/data/rel/zcta_county_rel_10.txt' -o $@.download
	mv $@.download csv/zcta_county_rel_10.csv

# DB needed to export output CSV files
db/installation.db: csv/zcta_county_rel_10.csv
	mkdir -p $(dir $@)
	sqlite3 $@ < commands/compose.sql
	
# trend files (to use in dataviz)
output/%.csv: db/installation.db
	mkdir -p $(dir $@)
	mkdir -p tmp
	rm tmp/export.sql
	echo ".headers on" >> tmp/export.sql
	echo ".mode csv" >> tmp/export.sql
	echo ".output $(basename $@).csv" >> tmp/export.sql
	echo "SELECT * FROM $(basename $(notdir $@));" >> tmp/export.sql
	sqlite3 db/installation.db < tmp/export.sql
	
# shape file with California zip code
zip/tl_2010_06_zcta510.zip:
	mkdir -p $(dir $@)
	curl 'http://www2.census.gov/geo/tiger/TIGER2010/ZCTA5/2010/$(notdir $@)' -o $@.download
	mv $@.download $@

shp/tl_2010_06_zcta510.shp: zip/tl_2010_06_zcta510.zip

shp/tl_2010_06_zcta510.shp:
	rm -rf $(basename $@)
	mkdir -p $(basename $@)
	unzip -d $(basename $@) $<
	for file in $(basename $@)/*; do chmod 644 $$file; mv $$file $(basename $@).$${file##*.}; done
	rmdir $(basename $@)
	touch $@

gz/%.tar.gz:
	mkdir -p $(dir $@)
	curl 'http://dds.cr.usgs.gov/pub/data/nationalatlas/$(notdir $@)' -o $@.download
	mv $@.download $@

shp/us/counties-unfiltered.shp: gz/countyp010_nt00795.tar.gz	

# remove water counties (e.g., Great Lakes)
shp/us/counties.shp: shp/us/counties-unfiltered.shp
	rm -f $@
	ogr2ogr -f 'ESRI Shapefile' -where "FIPS NOT LIKE '%000'" $@ $<	

shp/us/%.shp:
	rm -rf $(basename $@)
	mkdir -p $(basename $@)
	tar -xzm -C $(basename $@) -f $<
	for file in $(basename $@)/*; do chmod 644 $$file; mv $$file $(basename $@).$${file##*.}; done
	rmdir $(basename $@)

# shape file with California counties
shp/%/counties.shp: shp/us/counties.shp
	mkdir -p $(dir $@)
	rm -f $@
	ogr2ogr -f 'ESRI Shapefile' -where "STATE = '`echo $* | tr a-z A-Z`'" $@ $<
	
clean:
	rm -fR csv
	rm -fR db
	rm -fR gz
	rm -fR output
	rm -fR shp
	rm -fR zip

