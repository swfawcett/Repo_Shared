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
            