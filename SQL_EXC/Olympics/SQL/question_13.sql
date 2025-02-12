SELECT
noc,
COUNT(medal) cn
FROM olympics.athlete_events 
WHERE medal != 'NA'
group by noc
order by cn DESC limit 5