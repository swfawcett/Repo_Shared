select
name,
sex,
age,
height,
weight,
team,
sport,
games
from olympics.athlete_events
where age != 'NA' AND medal like '%Gold%'
order by age desc limit 20
