SELECT
games,
region,
sport,
COUNT(CASE WHEN medal != 'NA' THEN 1 END) medal_cnt
FROM olympics.athlete_events ae JOIN olympics.noc_regions nr 
ON nr.NOC = ae.noc
where region = 'India' and sport = 'Hockey'
group by games, region, sport
having medal_cnt > 0
order by games

