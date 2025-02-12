-- 1. How many Olympics games have been held? List down all Olympics games held
-- so far and where they were held.

select distinct
games,
city
from olympics.athlete_events ae left join olympics.noc_regions nc  
on ae.noc = nc.NOC
order by games


-- 2. Which athlete from India won the most medals in Olympics (till 2016)?

SELECT
name,
team,
sum(case when medal is not null then 1 else 0 end) md_cnt
from olympics.athlete_events ae
where team = 'India' and year != 2016
group by team, name
order by md_cnt desc limit 1


-- 3. Mention the total no of nations who participated in each Olympics game?

SELECT
year,
season,
COUNT(DISTINCT noc)
FROM olympics.athlete_events
GROUP BY year,season


-- 4. Which year saw the highest and lowest no of countries participating in Olympics?

with noc_year as (SELECT year, COUNT(DISTINCT noc) cn FROM olympics.athlete_events GROUP BY year),
mn_y as (SELECT year min_year, cn mn_cn from noc_year where cn = (select min(cn) from noc_year)),
mx_y as (SELECT year max_year, cn mx_cn from noc_year where cn = (select max(cn) from noc_year))
select * from mn_y CROSS join mx_y


-- 5. Which nation has participated in all of the Olympics games?

select
noc,
count(distinct games) total_games
from olympics.athlete_events
GROUP BY noc
having total_games = (select count(distinct games)
                      from olympics.athlete_events)


-- 6. Identify the sport which was played in all summer Olympics

select
sport,
count(distinct games) cn
from olympics.athlete_events
WHERE games like '%Summer'
GROUP BY sport
having cn = (SELECT count(DISTINCT games)
             from olympics.athlete_events 
             where games like '%Summer')


-- 7. Which Sports were just played only once in the Olympics?

select
sport,
count(distinct games) cn
from olympics.athlete_events
GROUP BY sport
having cn = 1


-- 8. Fetch the total no of sports played in each Olympics games.

select
games,
count(distinct sport) cn
from olympics.athlete_events
GROUP BY games

-- 9. Fetch details of the oldest athletes to win a gold medal.

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


-- 10.Find the Ratio of male and female athletes participated in all Olympics games.

select
year,
season,
round(COUNT(CASE WHEN sex = 'F' THEN 1 END)/COUNT(*)*100,2) ct_female,
round(COUNT(CASE WHEN sex = 'M' THEN 1 END)/COUNT(*)*100,2) ct_male
from olympics.athlete_events
GROUP BY year, season
ORDER BY year


-- 11.Fetch the top 5 athletes who have won the most gold medals

SELECT
name,
COUNT(medal) cn
FROM olympics.athlete_events 
WHERE medal = 'Gold'
group by name
order by cn DESC limit 5


-- 12.Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).

SELECT
name,
COUNT(medal) cn
FROM olympics.athlete_events 
WHERE medal != 'NA'
group by name
order by cn DESC limit 5


-- 13.Fetch the top 5 most successful countries in Olympics. Success is defined
--  by no. of medals won.

SELECT
noc,
COUNT(medal) cn
FROM olympics.athlete_events 
WHERE medal != 'NA'
group by noc
order by cn DESC limit 5


-- 14.List down total gold, silver and bronze medals won by each country.

SELECT
noc,
COUNT(CASE WHEN medal = 'Gold' THEN 1 END) gd_cnt,
COUNT(CASE WHEN medal = 'Silver' THEN 1 END) slv_cnt,
COUNT(CASE WHEN medal = 'Bronze' THEN 1 END) brz_cnt
FROM olympics.athlete_events
group by noc


-- 15.List down total gold, silver and bronze medals won by each country
-- corresponding to each Olympics games.

SELECT
noc,
games,
COUNT(CASE WHEN medal = 'Gold' THEN 1 END) gd_cnt,
COUNT(CASE WHEN medal = 'Silver' THEN 1 END) slv_cnt,
COUNT(CASE WHEN medal = 'Bronze' THEN 1 END) brz_cnt
FROM olympics.athlete_events
group by noc, games
order by noc


-- 16.Identify which country won the most gold, most silver and
-- most bronze medals in each Olympics games.

WITH medals as (SELECT
                    region,
                    games,
                    COUNT(CASE WHEN medal = 'Gold' THEN 1 END) gd_cnt,
                    COUNT(CASE WHEN medal = 'Silver' THEN 1 END) slv_cnt,
                    COUNT(CASE WHEN medal = 'Bronze' THEN 1 END) brz_cnt
                    FROM olympics.athlete_events ae JOIN olympics.noc_regions nr
                    ON ae.noc = nr.noc
                    group by region, games),
mx as (SELECT games, MAX(gd_cnt)gd, MAX(slv_cnt)slv, MAX(brz_cnt) brz from medals GROUP BY games),
mx_gd as (SELECT region, games, gd_cnt from medals where (games, gd_cnt) in (select games, gd from mx)),
mx_slv as (SELECT region, games, slv_cnt from medals where (games, slv_cnt) in (select games, slv from mx)),
mx_brz as (SELECT region, games, brz_cnt from medals where (games, brz_cnt) in (select games, brz from mx)),
cal as (select DISTINCT games from olympics.athlete_events)
SELECT
cal.games,
mx_gd.region gd_rec,
gd_cnt,
mx_slv.region slv_rec,
slv_cnt,
mx_brz.region brz_rec,
brz_cnt
from mx_slv RIGHT JOIN cal
ON cal.games = mx_slv.games
LEFT JOIN mx_gd ON mx_gd.games = cal.games
LEFT JOIN mx_brz ON mx_brz.games = cal.games
order by cal.games


-- 17.Identify which country won the most gold, most silver, most bronze medals and
-- the most medals in each Olympics games.

WITH medals as (SELECT
                    region,
                    games,
                    COUNT(CASE WHEN medal = 'Gold' THEN 1 END) gd_cnt,
                    COUNT(CASE WHEN medal = 'Silver' THEN 1 END) slv_cnt,
                    COUNT(CASE WHEN medal = 'Bronze' THEN 1 END) brz_cnt
                    FROM olympics.athlete_events ae JOIN olympics.noc_regions nr
                    ON nr.noc = ae.noc
                    group by region, games),
tot as (select region, games, gd_cnt + slv_cnt + brz_cnt as tot_med from medals group by region, games),
mx_tot as (select region, games, tot_med from tot where (games,tot_med) in (select games, max(tot_med) from tot group by games)),
mx as (SELECT games, MAX(gd_cnt)gd, MAX(slv_cnt)slv, MAX(brz_cnt) brz from medals GROUP BY games),
mx_gd as (SELECT region, games, gd_cnt from medals where (games, gd_cnt) in (select games, gd from mx)),
mx_slv as (SELECT region, games, slv_cnt from medals where (games, slv_cnt) in (select games, slv from mx)),
mx_brz as (SELECT region, games, brz_cnt from medals where (games, brz_cnt) in (select games, brz from mx)),
cal as (select DISTINCT games from olympics.athlete_events)
SELECT
cal.games,
mx_gd.region gd_region,
gd_cnt,
mx_slv.region slv_region,
slv_cnt,
mx_brz.region brz_region,
brz_cnt,
mx_tot.region all_medal,
tot_med
from mx_slv RIGHT JOIN cal
ON cal.games = mx_slv.games
LEFT JOIN mx_gd ON mx_gd.games = cal.games
LEFT JOIN mx_brz ON mx_brz.games = cal.games
RIGHT JOIN mx_tot ON mx_tot.games = cal.games
order by cal.games

-- 18.Which countries have never won gold medal but have won silver/bronze medals?

SELECT
region,
COUNT(CASE WHEN medal = 'Gold' THEN 1 END) gd_cnt,
COUNT(CASE WHEN medal = 'Silver' THEN 1 END) slv_cnt,
COUNT(CASE WHEN medal = 'Bronze' THEN 1 END) brz_cnt
FROM olympics.athlete_events ae JOIN olympics.noc_regions nr 
ON nr.NOC = ae.noc
group by region
having gd_cnt = 0 and (slv_cnt > 0 or brz_cnt > 0)


-- 19.In which Sport/event, India has won highest medals.

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


-- 20.Break down all Olympics games where India won medal for Hockey and how
-- many medals in each Olympics games.

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