select
games,
count(distinct sport) cn
from olympics.athlete_events
GROUP BY games
