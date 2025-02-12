select
year,
season,
round(COUNT(CASE WHEN sex = 'F' THEN 1 END)/COUNT(*)*100,2) ct_female,
round(COUNT(CASE WHEN sex = 'M' THEN 1 END)/COUNT(*)*100,2) ct_male
from olympics.athlete_events
GROUP BY year, season
ORDER BY year

