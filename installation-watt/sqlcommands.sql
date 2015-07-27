-- import population
.mode csv
.import assets/ACS_12_5YR_B01003_with_ann.csv population

-- import installation
.mode csv
.import assets/installation-data.csv installation

-- more complex
-- SELECT T1.zipcode, T1.TREND, P1."2010 Census Population" FROM (
-- SELECT I1.zipcode AS ZIPCODE, ifnull(I2.trend, 0) AS TREND 
-- FROM (
-- SELECT zipcode, trend FROM installation GROUP BY zipcode
-- ) AS I1 LEFT OUTER JOIN installation AS I2 ON (I1.zipcode=I2.zipcode) AND (I2.year = 2007)
-- ) AS T1 INNER JOIN population P1 ON (T1.zipcode=P1."Zip Code ZCTA");

-- TODO: do left outer join on population
CREATE TABLE trend2007 AS SELECT I1.zipcode AS ZIPCODE, ifnull(I2.trend, 0) AS TREND, P1.Estimate AS POPULATION, ifnull(I2.trend, 0)*1.0/P1.Estimate AS RATIO
FROM (SELECT zipcode FROM installation GROUP BY zipcode) AS I1 
LEFT OUTER JOIN installation AS I2 ON (I1.zipcode=I2.zipcode) AND (I2.year = 2007)
LEFT OUTER JOIN population AS P1 ON (I1.zipcode=P1.Id2);

-- TODO: do left outer join on population
CREATE TABLE trend2012 AS SELECT I1.zipcode AS ZIPCODE, ifnull(I2.trend, I1.TREND1) AS TREND, P1.Estimate AS POPULATION, ifnull(I2.trend, I1.TREND1)*1.0/P1.Estimate AS RATIO
FROM (SELECT zipcode, MAX(trend) AS TREND1 FROM installation GROUP BY zipcode) AS I1 
LEFT OUTER JOIN installation AS I2 ON (I1.zipcode=I2.zipcode) AND (I2.year = 2012)
LEFT OUTER JOIN population AS P1 ON (I1.zipcode=P1.Id2);


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