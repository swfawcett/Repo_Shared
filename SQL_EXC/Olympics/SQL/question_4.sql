with noc_year as (SELECT year, COUNT(DISTINCT noc) cn FROM olympics.athlete_events GROUP BY year),
mn_y as (SELECT year min_year, cn mn_cn from noc_year where cn = (select min(cn) from noc_year)),
mx_y as (SELECT year max_year, cn mx_cn from noc_year where cn = (select max(cn) from noc_year))
select * from mn_y CROSS join mx_y
