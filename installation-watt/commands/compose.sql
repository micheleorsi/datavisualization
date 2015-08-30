-- import population 2011
.mode csv
.import assets/ACS_11_5YR_B01003_with_ann.csv population2011

-- import population 2012
.mode csv
.import assets/ACS_12_5YR_B01003_with_ann.csv population2012

-- import installation data
.mode csv
.import assets/installation-data.csv installation


-- more complex
-- SELECT T1.zipcode, T1.TREND, P1."2010 Census Population" FROM (
-- SELECT I1.zipcode AS ZIPCODE, ifnull(I2.trend, 0) AS TREND 
-- FROM (
-- SELECT zipcode, trend FROM installation GROUP BY zipcode
-- ) AS I1 LEFT OUTER JOIN installation AS I2 ON (I1.zipcode=I2.zipcode) AND (I2.year = 2007)
-- ) AS T1 INNER JOIN population2012 P1 ON (T1.zipcode=P1."Zip Code ZCTA");

-- create installation2007 table, where there is a zipcode and a value for trend07
CREATE TABLE installation2007 AS SELECT I1.zipcode AS ZIPCODE, ifnull(I2.trend, 0) AS TREND2007
FROM (SELECT zipcode FROM installation GROUP BY zipcode) AS I1 
LEFT OUTER JOIN installation AS I2 ON (I1.zipcode=I2.zipcode) AND (I2.year = 2007);


-- create installation2007 table, where there is a zipcode, a value for trend07, a value for population and one for the ratio
CREATE TABLE trend2007 AS SELECT I1.ZIPCODE AS ZIPCODE, TREND2007, ifnull(P1.Estimate, -100) AS POPULATION, ifnull(TREND2007*1.0/P1.Estimate, -100) AS RATIO
FROM installation2007 AS I1
LEFT OUTER JOIN population2012 AS P1 ON (I1.ZIPCODE=P1.Id2);

CREATE TABLE installation2012 AS SELECT I1.zipcode AS ZIPCODE, ifnull(I2.trend, I1.TREND12) AS TREND2012
FROM (SELECT zipcode, MAX(trend) AS TREND12 FROM installation GROUP BY zipcode) AS I1
LEFT OUTER JOIN installation AS I2 ON (I1.zipcode=I2.zipcode) AND (I2.year = 2012);

CREATE TABLE trend2012 AS SELECT I1.ZIPCODE AS ZIPCODE, TREND2012, ifnull(P1.Estimate, -100) AS POPULATION, ifnull(TREND2012*1.0/P1.Estimate, -100) AS RATIO
FROM installation2012 AS I1
LEFT OUTER JOIN population2012 AS P1 ON (I1.zipcode=P1.Id2);

-- Temp query:
-- SELECT COUNT(*) FROM (SELECT zipcode FROM installation GROUP BY zipcode) -> 1401

-- SELECT COUNT(*) FROM (SELECT Id2 FROM population2012 GROUP BY Id2) -> 1769


-- SELECT I1.zipcode AS ZIPCODE, ifnull(I2.trend, 0) AS TREND, P1.Estimate AS POPULATION, ifnull(I2.trend, 0)*1.0/P1.Estimate AS RATIO
-- FROM (SELECT zipcode FROM installation GROUP BY zipcode) AS I1 
-- LEFT OUTER JOIN population2012 AS P1 ON (I1.zipcode=P1.Id2)
-- LEFT OUTER JOIN installation AS I2 ON (I1.zipcode=I2.zipcode) AND (I2.year = 2007);

-- SELECT zipcode FROM installation GROUP BY zipcode EXCEPT SELECT zipcode FROM trend2007;

-- SELECT COUNT(*) FROM (SELECT zipcode FROM trend2007) -> 1401

-- Threeshold
-- SELECT *  FROM trend2012 ORDER BY RATIO ASC LIMIT 191;
-- SELECT *  FROM trend2012 ORDER BY RATIO ASC LIMIT 351; 
-- SELECT *  FROM trend2012 ORDER BY RATIO ASC LIMIT 511; 
-- SELECT *  FROM trend2012 ORDER BY RATIO ASC LIMIT 671; 
-- SELECT *  FROM trend2012 ORDER BY RATIO ASC LIMIT 831; 
-- SELECT *  FROM trend2012 ORDER BY RATIO ASC LIMIT 991;
-- SELECT *  FROM trend2012 ORDER BY RATIO ASC LIMIT 1151;
-- SELECT *  FROM trend2012 ORDER BY RATIO ASC LIMIT 1311;


