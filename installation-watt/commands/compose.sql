-- import population 2011
-- .mode csv
-- .import assets/ACS_11_5YR_B01003_with_ann.csv population2011

-- import California population 2012
.mode csv
.import assets/ACS_12_5YR_B01003_with_ann.csv population2012

-- import installation data
CREATE TABLE installation(
  year INT NOT NULL,
  zipcode CHAR(5) NOT NULL,
  city TEXT,
  county TEXT,
  installation_zip NUMERIC NOT NULL,
  trend NUMERIC NOT NULL
);

.mode csv
.import assets/installation-data.csv installation

-- import zip mapping all over US
CREATE TABLE zipmapping(
  ZCTA5 CHAR(5) NOT NULL,
  STATE CHAR(2) NOT NULL,
  COUNTY CHAR(3) NOT NULL,
  GEOID NUMERIC NOT NULL,
  POPPT NUMERIC NOT NULL,
  HUPT NUMERIC NOT NULL,
  AREAPT NUMERIC NOT NULL,
  AREALANDPT NUMERIC NOT NULL,
  ZPOP NUMERIC NOT NULL,
  ZHU NUMERIC NOT NULL,
  ZAREA NUMERIC NOT NULL,
  ZAREALAND NUMERIC NOT NULL,
  COPOP NUMERIC NOT NULL,
  COHU NUMERIC NOT NULL,
  COAREA NUMERIC NOT NULL,
  COAREALAND NUMERIC NOT NULL,
  ZPOPPCT NUMERIC NOT NULL,
  ZHUPCT NUMERIC NOT NULL,
  ZAREAPCT NUMERIC NOT NULL,
  ZAREALANDPCT NUMERIC NOT NULL,
  COPOPPCT NUMERIC NOT NULL,
  COHUPCT NUMERIC NOT NULL,
  COAREAPCT NUMERIC NOT NULL,
  COAREALANDPCT NUMERIC NOT NULL
);

.mode csv
.import csv/zcta_county_rel_10.csv zipmapping

-- table with all zipcode matching all the years
CREATE TABLE full_mapping_zip_year AS
  SELECT zipcode, year
  FROM (SELECT DISTINCT zipcode FROM installation)
  CROSS JOIN (SELECT DISTINCT year FROM installation);

-- table with all zipcode of year 2007 with all the trends fixed (it means that if the zipcode was not present, in this table the trend value is 0)
CREATE TABLE trend_2007 (
  year INT NOT NULL,
  zipcode CHAR(5) NOT NULL,
  TREND2007 NUMERIC NOT NULL
);

-- table with all zipcode of year 2008 with all the trends fixed (it means that if the zipcode was not present, in this table the trend value is the one in 2007)
CREATE TABLE trend_2008 (
  year INT NOT NULL,
  zipcode CHAR(5) NOT NULL,
  TREND2008 NUMERIC NOT NULL
);

-- table with all zipcode of year 2009 with all the trends fixed (it means that if the zipcode was not present, in this table the trend value is the one in 2008)
CREATE TABLE trend_2009 (
  year INT NOT NULL,
  zipcode CHAR(5) NOT NULL,
  TREND2009 NUMERIC NOT NULL
);

-- table with all zipcode of year 2010 with all the trends fixed (it means that if the zipcode was not present, in this table the trend value is the one in 2009)
CREATE TABLE trend_2010 (
  year INT NOT NULL,
  zipcode CHAR(5) NOT NULL,
  TREND2010 NUMERIC NOT NULL
);

-- table with all zipcode of year 2011 with all the trends fixed (it means that if the zipcode was not present, in this table the trend value is the one in 2010)
CREATE TABLE trend_2011 (
  year INT NOT NULL,
  zipcode CHAR(5) NOT NULL,
  TREND2011 NUMERIC NOT NULL
);

-- table with all zipcode of year 2012 with all the trends fixed (it means that if the zipcode was not present, in this table the trend value is the one in 2011)
CREATE TABLE trend_2012 (
  year INT NOT NULL,
  zipcode CHAR(5) NOT NULL,
  TREND2012 NUMERIC NOT NULL
);

INSERT INTO trend_2007
  SELECT I1.year, I1.zipcode AS ZIPCODE, ifnull(I2.TREND07,0) AS TREND2007
  FROM (SELECT zipcode, year FROM full_mapping_zip_year WHERE year=2007) AS I1
    LEFT OUTER JOIN (SELECT zipcode, trend AS TREND07 FROM installation WHERE year=2007 GROUP BY zipcode) AS I2 ON (I1.zipcode=I2.zipcode);

INSERT INTO trend_2008
  SELECT I1.year, I1.zipcode AS ZIPCODE, ifnull(I2.TREND08,0) AS TREND2008
  FROM (SELECT zipcode, year FROM full_mapping_zip_year WHERE year=2008) AS I1
    LEFT OUTER JOIN (SELECT zipcode, MAX(trend) AS TREND08 FROM installation WHERE year<=2008 GROUP BY zipcode) AS I2 ON (I1.zipcode=I2.zipcode);

INSERT INTO trend_2009
  SELECT I1.year, I1.zipcode AS ZIPCODE, ifnull(I2.TREND09,0) AS TREND2009
  FROM (SELECT zipcode, year FROM full_mapping_zip_year WHERE year=2009) AS I1
    LEFT OUTER JOIN (SELECT zipcode, MAX(trend) AS TREND09 FROM installation WHERE year<=2009 GROUP BY zipcode) AS I2 ON (I1.zipcode=I2.zipcode);

INSERT INTO trend_2010
  SELECT I1.year, I1.zipcode AS ZIPCODE, ifnull(I2.TREND10,0) AS TREND2010
  FROM (SELECT zipcode, year FROM full_mapping_zip_year WHERE year=2010) AS I1
    LEFT OUTER JOIN (SELECT zipcode, MAX(trend) AS TREND10 FROM installation WHERE year<=2010 GROUP BY zipcode) AS I2 ON (I1.zipcode=I2.zipcode);

INSERT INTO trend_2011
  SELECT I1.year, I1.zipcode AS ZIPCODE, ifnull(I2.TREND11,0) AS TREND2011
  FROM (SELECT zipcode, year FROM full_mapping_zip_year WHERE year=2011) AS I1
    LEFT OUTER JOIN (SELECT zipcode, MAX(trend) AS TREND11 FROM installation WHERE year<=2011 GROUP BY zipcode) AS I2 ON (I1.zipcode=I2.zipcode);

INSERT INTO trend_2012
  SELECT I1.year, I1.zipcode AS ZIPCODE, ifnull(I2.TREND12,0) AS TREND2012
  FROM (SELECT zipcode, year FROM full_mapping_zip_year WHERE year=2012) AS I1
    LEFT OUTER JOIN (SELECT zipcode, MAX(trend) AS TREND12 FROM installation WHERE year<=2012 GROUP BY zipcode) AS I2 ON (I1.zipcode=I2.zipcode);

-- zipcode, a value for population and one for the ratio
CREATE TABLE trend2007 AS
SELECT I1.ZIPCODE AS ZIPCODE, I1.TREND2007, ifnull(P1.Estimate, -100) AS POPULATION, ifnull(I1.TREND2007*1.0/P1.Estimate, -100) AS RATIO
FROM trend_2007 AS I1
LEFT OUTER JOIN population2012 AS P1 ON (I1.ZIPCODE=P1.Id2);

CREATE TABLE trend2012 AS
SELECT I1.ZIPCODE AS ZIPCODE, I1.TREND2012, ifnull(P1.Estimate, -100) AS POPULATION, ifnull(I1.TREND2012*1.0/P1.Estimate, -100) AS RATIO
FROM trend_2012 AS I1
LEFT OUTER JOIN population2012 AS P1 ON (I1.zipcode=P1.Id2);

-- Description: installation data + codes for county, state and population data per zipcode, restricted for California state
-- INSTALLATION: installation per zipcode per year
-- TREND: trend per zipcode per year
-- STATE: state code
-- POPULATION: population of that specific zipcode (on that specific county)
-- COUNTY: county code
CREATE TABLE installationcounties AS
SELECT I.zipcode AS ZIPCODE, I.year AS YEAR, I.installation_zip AS INSTALLATION, I.trend AS TREND, Z.STATE AS STATE, Z.POPPT AS POPULATION, Z.GEOID AS COUNTY
FROM installation AS I
INNER JOIN zipmapping AS Z ON (I.zipcode=Z.ZCTA5)
WHERE Z.STATE="06";

-- trend by county only in California in 2007
CREATE TABLE trendcounty2007 AS
SELECT COUNTY, SUM(I1.TREND2007) AS TREND, SUM(I2.POPULATION) AS POPULATION, SUM(I1.TREND2007)*1.0/SUM(I2.POPULATION) AS RATIO
FROM trend_2007 AS I1
INNER JOIN installationcounties AS I2 ON (I1.ZIPCODE=I2.ZIPCODE)
GROUP BY COUNTY;

-- trend by county only in California in 2012
CREATE TABLE trendcounty2012 AS
SELECT COUNTY, SUM(I1.TREND2012) AS TREND, SUM(I2.POPULATION) AS POPULATION, SUM(I1.TREND2012)*1.0/SUM(I2.POPULATION) AS RATIO
FROM trend_2012 AS I1
INNER JOIN installationcounties AS I2 ON (I1.ZIPCODE=I2.ZIPCODE)
GROUP BY COUNTY;

-- installation grouped by county and year
CREATE TABLE installationbycountybyyear AS
SELECT Z.GEOID AS COUNTY_ID, I.year AS YEAR, SUM(I.installation_zip) AS INSTALLATION, Z.STATE AS STATE,
  SUM(Z.POPPT) AS POPULATION, SUM(I.installation_zip)*1.0/SUM(Z.POPPT) AS INSTALLATION_RATIO
FROM installation AS I
INNER JOIN zipmapping AS Z ON (I.zipcode=Z.ZCTA5)
WHERE Z.STATE="06"
GROUP BY COUNTY_ID,YEAR;
