SELECT
year,
season,
COUNT(DISTINCT noc)
FROM olympics.athlete_events
GROUP BY year,season
