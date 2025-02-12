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


