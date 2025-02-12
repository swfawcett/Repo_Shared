-- 1. Data Integrity Checking & Cleanup

-- Alphabetically list all of the country codes in the continent_map table that appear more than once. 
-- Display any values where country_code is null as country_code = "FOO" and make this row appear first in the list, 
-- even though it should alphabetically sort to the middle. Provide the results of this query as your answer.

with foo as (SELECT
            CASE WHEN country_code = '' THEN 'FOO'
            ELSE country_code end as country_code,
            continent_code
            FROM braintree.continent_map),
      ct as (SELECT
            country_code,
            count(country_code) cnt
            from foo
            GROUP BY country_code)
SELECT
country_code
from ct
where cnt > 1
order by cnt desc, country_code


-- 2. List the countries ranked 10-12 in each continent by the percent of year-over-year growth descending from 2011 to 2012.

-- The percent of growth should be calculated as: ((2012 gdp - 2011 gdp) / 2011 gdp)

-- The list should include the columns:

-- rank
-- continent_name
-- country_code
-- country_name
-- growth_percent

with cte as (SELECT
            co.continent_name,
            cu.country_code,
            cu.country_name,
            pc.year,
            pc.gdp_per_capita
            FROM braintree.continent_map cm JOIN
            braintree.continents co ON co.continent_code = cm.continent_code
            JOIN braintree.countries cu on cu.country_code = cm.country_code
            JOIN braintree.per_capita pc ON pc.country_code = cu.country_code
            WHERE pc.year BETWEEN 2011 AND 2012),
ct11 as (SELECT 
        continent_name,
        country_code,
        country_name,
        year,
        gdp_per_capita
        FROM cte
        WHERE year = 2011),
ct12 as (SELECT
        continent_name,
        country_code,
        country_name,
        year,
        gdp_per_capita
        FROM cte
        WHERE year = 2012),
rez as (SELECT
        ct11.continent_name,
        ct11.country_code,
        ct11.country_name,
        Round((ct12.gdp_per_capita - ct11.gdp_per_capita)/ct11.gdp_per_capita*100,2) growth_percent
        FROM ct11 JOIN ct12
        ON ct11.continent_name = ct12.continent_name 
        and ct11.country_code = ct12.country_code),
fin as (SELECT
RANK()OVER(PARTITION BY continent_name ORDER BY growth_percent DESC) rnk,
continent_name,
country_code,
country_name,
CONCAT(growth_percent,'%') growth_percent
FROM rez)
SELECT
*
FROM fin
where rnk BETWEEN 10 AND 12


-- For the year 2012, create a 3 column, 1 row report showing the percent share of gdp_per_capita for the following regions:

-- (i) Asia, (ii) Europe, (iii) the Rest of the World. Your result should look something like

-- Asia	Europe	Rest of World
-- 25.0%	25.0%	50.0%

with cte as (SELECT
            co.continent_name,
            cu.country_code,
            cu.country_name,
            pc.year,
            pc.gdp_per_capita
            FROM braintree.continent_map cm JOIN
            braintree.continents co ON co.continent_code = cm.continent_code
            JOIN braintree.countries cu on cu.country_code = cm.country_code
            JOIN braintree.per_capita pc ON pc.country_code = cu.country_code
            WHERE pc.year = 2012),
all_gdp as (SELECT DISTINCT
           continent_name,
           SUM(gdp_per_capita)over(PARTITION BY continent_name) cont_gdp 
           from cte) 

SELECT
concat(round((select cont_gdp FROM all_gdp where continent_name = 'Asia')/sum(cont_gdp)*100,1),'%') as 'Asia',
concat(round((select cont_gdp FROM all_gdp where continent_name = 'Europe')/sum(cont_gdp)*100,1),'%') as 'Europe',
concat(round((select sum(cont_gdp) FROM all_gdp where continent_name not in ('Asia','Europe'))/sum(cont_gdp)*100,1),'%') as 'Rest of World'
from all_gdp


-- 4a. What is the count of countries and sum of their related gdp_per_capita values for the
--  year 2007 where the string 'an' (case insensitive) appears anywhere in the country name?

WITH cte AS (SELECT
            co.continent_name,
            cu.country_code,
            cu.country_name,
            pc.year,
            pc.gdp_per_capita
            FROM braintree.continent_map cm JOIN
            braintree.continents co ON co.continent_code = cm.continent_code
            JOIN braintree.countries cu on cu.country_code = cm.country_code
            JOIN braintree.per_capita pc ON pc.country_code = cu.country_code
            WHERE cu.country_name LIKE '%an%' AND pc.year = 2007)
SELECT
COUNT(*),
CONCAT('$',ROUND(SUM(gdp_per_capita),2))
FROM cte


-- 4b. Repeat question 4a, but this time make the query case sensitive.

WITH cte AS (SELECT
            co.continent_name,
            cu.country_code,
            cu.country_name,
            pc.year,
            pc.gdp_per_capita
            FROM braintree.continent_map cm JOIN
            braintree.continents co ON co.continent_code = cm.continent_code
            JOIN braintree.countries cu on cu.country_code = cm.country_code
            JOIN braintree.per_capita pc ON pc.country_code = cu.country_code
            WHERE cu.country_name LIKE BINARY'%an%' AND pc.year = 2007)
SELECT
COUNT(*),
CONCAT('$',ROUND(SUM(gdp_per_capita),2))
FROM cte


-- 5. Find the sum of gpd_per_capita by year and the count of countries for each year that have non-null gdp_per_capita
--  where (i) the year is before 2012 and (ii) the country has a null gdp_per_capita in 2012. 

-- Your result should have the columns:

-- year
-- country_count
-- total

WITH cte AS(SELECT
            country_name,
            year,
            gdp_per_capita
            FROM braintree.countries c LEFT JOIN
            braintree.per_capita pc ON pc.country_code = c.country_code
)
SELECT
year,
COUNT(DISTINCT country_name) country_count,
CONCAT('$',ROUND(SUM(gdp_per_capita),2)) total
FROM cte
WHERE year != 2012 
AND country_name NOT IN (select country_name FROM cte WHERE year = 2012)
GROUP BY year


-- 6. All in a single query, execute all of the steps below and provide the results as your final answer:

-- a. create a single list of all per_capita records for year 2009 that includes columns:

-- continent_name
-- country_code
-- country_name
-- gdp_per_capita
-- b. order this list by:

-- continent_name ascending
-- characters 2 through 4 (inclusive) of the country_name descending
-- c. create a running total of gdp_per_capita by continent_name

-- d. return only the first record from the ordered list for which each continent's running total of gdp_per_capita meets or exceeds $70,000.00 with the following columns:

-- continent_name
-- country_code
-- country_name
-- gdp_per_capita
-- running_total

WITH cte AS  (SELECT
            co.continent_name,
            cu.country_code,
            cu.country_name,
            pc.year,
            pc.gdp_per_capita
            FROM braintree.continent_map cm JOIN
            braintree.continents co ON co.continent_code = cm.continent_code
            JOIN braintree.countries cu on cu.country_code = cm.country_code
            JOIN braintree.per_capita pc ON pc.country_code = cu.country_code
            WHERE pc.year = 2009)

SELECT
continent_name,
country_code,
country_name,
ROUND(gdp_per_capita,2) gdp_per_capita,
ROUND(SUM(gdp_per_capita)OVER(PARTITION BY continent_name ORDER BY country_name),2) running_gdp
FROM cte
order by continent_name, RIGHT(LEFT(country_name,4),2) desc

