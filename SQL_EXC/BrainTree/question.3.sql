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
