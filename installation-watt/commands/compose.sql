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

-- import zip mapping all over US with population informations
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

-- trend2007 over population
CREATE TABLE trend_2007_on_population(
  ZIPCODE CHAR(5) NOT NULL,
  TREND2007 NUMERIC NOT NULL,
  POPULATION NUMERIC NOT NULL,
  RATIO NUMERIC NOT NULL
);

-- some zipcodes reported in the CSI database are not reported in the us census bureau database.
-- For these missing values we used '-100'
INSERT INTO trend_2007_on_population
SELECT I1.ZIPCODE AS ZIPCODE, I1.TREND2007 AS TREND2007, ifnull(P.ZIP_POPULATION, -100) AS POPULATION, ifnull(I1.TREND2007*1.0/P.ZIP_POPULATION, -100) AS RATIO
FROM trend_2007 AS I1
LEFT OUTER JOIN (SELECT ZCTA5, SUM(POPPT) AS ZIP_POPULATION FROM zipmapping WHERE STATE="06" GROUP BY ZCTA5) AS P ON (I1.ZIPCODE=P.ZCTA5);

-- trend2012 over population
CREATE TABLE trend_2012_on_population(
  ZIPCODE CHAR(5) NOT NULL,
  TREND2012 NUMERIC NOT NULL,
  POPULATION NUMERIC NOT NULL,
  RATIO NUMERIC NOT NULL
);

-- some zipcodes reported in the CSI database are not reported in the us census bureau database.
-- For these missing values we used '-100'
INSERT INTO trend_2012_on_population
SELECT I1.ZIPCODE AS ZIPCODE, I1.TREND2012 AS TREND2012, ifnull(P.ZIP_POPULATION, -100) AS POPULATION, ifnull(I1.TREND2012*1.0/P.ZIP_POPULATION, -100) AS RATIO
FROM trend_2012 AS I1
LEFT OUTER JOIN (SELECT ZCTA5, SUM(POPPT) AS ZIP_POPULATION FROM zipmapping WHERE STATE="06" GROUP BY ZCTA5) AS P ON (I1.ZIPCODE=P.ZCTA5);

