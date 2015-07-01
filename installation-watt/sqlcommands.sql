-- import population
.mode csv
.import source/2010+Census+Population+By+Zipcode+(ZCTA).csv population

-- import installation
.mode csv
.import assets/installation-data.csv installation

-- export trend 2007
.headers on
.mode csv
.output output/trend2007.csv
-- more complex
-- SELECT T1.zipcode, T1.TREND, P1."2010 Census Population" FROM (
-- SELECT I1.zipcode AS ZIPCODE, ifnull(I2.trend, 0) AS TREND 
-- FROM (
-- SELECT zipcode, trend FROM installation GROUP BY zipcode
-- ) AS I1 LEFT OUTER JOIN installation AS I2 ON (I1.zipcode=I2.zipcode) AND (I2.year = 2007)
-- ) AS T1 INNER JOIN population P1 ON (T1.zipcode=P1."Zip Code ZCTA");

-- easier
SELECT I1.zipcode AS ZIPCODE, ifnull(I2.trend, 0) AS TREND, P1."2010 Census Population" AS POPULATION
FROM (
SELECT zipcode, trend FROM installation GROUP BY zipcode
) AS I1 LEFT OUTER JOIN installation AS I2 ON (I1.zipcode=I2.zipcode) AND (I2.year = 2007)
INNER JOIN population P1 ON (I1.zipcode=P1."Zip Code ZCTA");

-- export trend 2012
.headers on
.mode csv
.output output/trend2012.csv
SELECT I1.zipcode AS ZIPCODE, ifnull(I2.trend, I1.TREND1) AS TREND, P1."2010 Census Population" AS POPULATION 
FROM (
SELECT zipcode, MAX(trend) AS TREND1 FROM installation GROUP BY zipcode
) AS I1 LEFT OUTER JOIN installation AS I2 ON (I1.zipcode=I2.zipcode) AND (I2.year = 2012)
INNER JOIN population P1 ON (I1.zipcode=P1."Zip Code ZCTA");