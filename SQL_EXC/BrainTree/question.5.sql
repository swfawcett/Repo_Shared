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

