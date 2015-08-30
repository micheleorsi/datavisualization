-- import population 2011
.mode csv
.import assets/ACS_11_5YR_B01003_with_ann.csv population2011

-- import population 2012
.mode csv
.import assets/ACS_12_5YR_B01003_with_ann.csv population2012

-- import installation data
.mode csv
.import assets/installation-data.csv installation

-- import zip mapping 
.mode csv
.import csv/zcta_county_rel_10.csv zipmapping


-- create installation data file with county code and population (POPPT: the population of that specific zipcode on that specific county)
CREATE TABLE installationcounties AS 
SELECT I.zipcode AS ZIPCODE, I.year AS YEAR, I.installation_zip AS INSTALLATION, I.trend AS TREND, Z.STATE AS STATE, Z.POPPT AS POPULATION, Z.GEOID AS COUNTY
FROM installation AS I 
INNER JOIN zipmapping AS Z ON (I.zipcode=Z.ZCTA5);

-- create installation2007 table, where there is a zipcode and a value for trend07
CREATE TABLE installation2007 AS 
SELECT I1.zipcode AS ZIPCODE, ifnull(I2.trend, 0) AS TREND2007
FROM (SELECT zipcode FROM installation GROUP BY zipcode) AS I1 
LEFT OUTER JOIN installation AS I2 ON (I1.zipcode=I2.zipcode) AND (I2.year = 2007);

-- create installation2007 table, where there is a zipcode and a value for trend12
CREATE TABLE installation2012 AS 
SELECT I1.zipcode AS ZIPCODE, ifnull(I2.trend, I1.TREND12) AS TREND2012
FROM (SELECT zipcode, MAX(trend) AS TREND12 FROM installation GROUP BY zipcode) AS I1
LEFT OUTER JOIN installation AS I2 ON (I1.zipcode=I2.zipcode) AND (I2.year = 2012);

-- zipcode, a value for population and one for the ratio
CREATE TABLE trend2007 AS 
SELECT I1.ZIPCODE AS ZIPCODE, TREND2007, ifnull(P1.Estimate, -100) AS POPULATION, ifnull(TREND2007*1.0/P1.Estimate, -100) AS RATIO
FROM installation2007 AS I1
LEFT OUTER JOIN population2012 AS P1 ON (I1.ZIPCODE=P1.Id2);

CREATE TABLE trend2012 AS 
SELECT I1.ZIPCODE AS ZIPCODE, TREND2012, ifnull(P1.Estimate, -100) AS POPULATION, ifnull(TREND2012*1.0/P1.Estimate, -100) AS RATIO
FROM installation2012 AS I1
LEFT OUTER JOIN population2012 AS P1 ON (I1.zipcode=P1.Id2);

CREATE TABLE trendcounty2007 AS 
SELECT COUNTY, SUM(I1.TREND2007) AS TREND, SUM(I2.POPULATION) AS POPULATION, SUM(I1.TREND2007)*1.0/SUM(I2.POPULATION) AS RATIO
FROM installation2007 AS I1
INNER JOIN installationcounties AS I2 ON (I1.ZIPCODE=I2.ZIPCODE)
GROUP BY COUNTY;

CREATE TABLE trendcounty2012 AS 
SELECT COUNTY, SUM(I1.TREND2012) AS TREND, SUM(I2.POPULATION) AS POPULATION, SUM(I1.TREND2012)*1.0/SUM(I2.POPULATION) AS RATIO
FROM installation2012 AS I1
INNER JOIN installationcounties AS I2 ON (I1.ZIPCODE=I2.ZIPCODE)
GROUP BY COUNTY;

-- Threeshold
-- SELECT *  FROM trend2012 ORDER BY RATIO ASC LIMIT 191;
-- SELECT *  FROM trend2012 ORDER BY RATIO ASC LIMIT 351; 
-- SELECT *  FROM trend2012 ORDER BY RATIO ASC LIMIT 511; 
-- SELECT *  FROM trend2012 ORDER BY RATIO ASC LIMIT 671; 
-- SELECT *  FROM trend2012 ORDER BY RATIO ASC LIMIT 831; 
-- SELECT *  FROM trend2012 ORDER BY RATIO ASC LIMIT 991;
-- SELECT *  FROM trend2012 ORDER BY RATIO ASC LIMIT 1151;
-- SELECT *  FROM trend2012 ORDER BY RATIO ASC LIMIT 1311;


