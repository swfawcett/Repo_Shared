select
noc,
count(distinct games) total_games
from olympics.athlete_events
GROUP BY noc
having total_games = (select count(distinct games)
                      from olympics.athlete_events)