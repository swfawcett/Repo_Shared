select
sport,
count(distinct games) cn
from olympics.athlete_events
WHERE games like '%Summer'
GROUP BY sport
having cn = (SELECT count(DISTINCT games)
             from olympics.athlete_events 
             where games like '%Summer')