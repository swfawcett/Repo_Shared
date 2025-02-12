select
sport,
count(distinct games) cn
from olympics.athlete_events
GROUP BY sport
having cn = 1
