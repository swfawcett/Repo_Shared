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