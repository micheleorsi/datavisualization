-- export trend 2007
.headers on
.mode csv
.output output/trend2007.csv
SELECT * FROM trend2007;

-- export trend 2012
.headers on
.mode csv
.output output/trend2012.csv
SELECT * FROM trend2012;

-- export trend county 2007
.headers on
.mode csv
.output output/trendcounty2007.csv
SELECT * FROM trendcounty2007;

-- export trend county 2012
.headers on
.mode csv
.output output/trendcounty2012.csv
SELECT * FROM trendcounty2012;

