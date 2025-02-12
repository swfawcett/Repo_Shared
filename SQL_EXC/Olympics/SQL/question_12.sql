SELECT
name,
COUNT(medal) cn
FROM olympics.athlete_events 
WHERE medal != 'NA'
group by name
order by cn DESC