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
