SELECT
region,
sport,
event,
COUNT(CASE WHEN medal != 'NA' THEN 1 END) medal_cnt
FROM olympics.athlete_events ae JOIN olympics.noc_regions nr 
ON nr.NOC = ae.noc
where region = 'India'
group by region, sport, event
having medal_cnt > 0 
order by medal_cnt desc limit 1

