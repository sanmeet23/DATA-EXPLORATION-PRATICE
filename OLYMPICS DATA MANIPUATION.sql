

CREATE OR REPLACE TABLE OLYMPICS_HISTORY
(
    id          INT,
    name        VARCHAR,
    sex         VARCHAR,
    age         VARCHAR,
    height      VARCHAR,
    weight      VARCHAR,
    team        VARCHAR,
    noc         VARCHAR,
    games       VARCHAR,
    year        INT,
    season      VARCHAR,
    city        VARCHAR,
    sport       VARCHAR,
    event       VARCHAR,
    medal       VARCHAR
);

--DROP TABLE IF EXISTS OLYMPICS_HISTORY_NOC_REGIONS;
CREATE OR REPLACE TABLE  OLYMPICS_HISTORY_NOC_REGIONS
(
    noc         VARCHAR,
    region      VARCHAR,
    notes       VARCHAR
);

select * from OLYMPICS_HISTORY;
select * from OLYMPICS_HISTORY_NOC_REGIONS;

UPDATE OLYMPICS_HISTORY
SET AGE = 0 WHERE AGE = 'NA';


UPDATE OLYMPICS_HISTORY
SET MEDAL = 0 WHERE MEDAL = 'NA';

--- Q1 How many olympics games have been held?

SELECT COUNT(DISTINCT GAMES) FROM OLYMPICS_HISTORY;



--- Q2 List down all Olympics games held so far.

SELECT DISTINCT YEAR, SEASON, CITY 
FROM OLYMPICS_HISTORY
ORDER BY 1 ASC;


-- Q3 Mention the total no of nations who participated in each olympics game?

SELECT GAMES, COUNT(DISTINCT NR.REGION) PATICIPATED_NATIONS
FROM OLYMPICS_HISTORY OH JOIN olympics_history_noc_regions AS NR USING (NOC)
GROUP BY GAMES
ORDER BY GAMES;


-- Q4 Which year saw the highest and lowest no of countries participating in olympics 

SELECT A.LOWEST_COUNTRIES, B.HIGHEST_COUNTRIES
  
FROM  (
  SELECT GAMES, COUNT(DISTINCT NR.REGION) PATICIPATED_NATIONS, CONCAT(GAMES,' - ',PATICIPATED_NATIONS ) AS LOWEST_COUNTRIES
  FROM OLYMPICS_HISTORY OH JOIN olympics_history_noc_regions AS NR USING (NOC)
  GROUP BY GAMES
  
  ORDER BY PATICIPATED_NATIONS ASC LIMIT 1) A,
  
 (SELECT GAMES, COUNT(DISTINCT NR.REGION) PATICIPATED_NATIONS, CONCAT(GAMES,' - ',PATICIPATED_NATIONS ) AS HIGHEST_COUNTRIES
  FROM OLYMPICS_HISTORY OH JOIN olympics_history_noc_regions AS NR USING (NOC)
  GROUP BY GAMES
  
  ORDER BY PATICIPATED_NATIONS DESC LIMIT 1) B;
  
  
-- Q5 Which nation has participated in all of the olympic games


SELECT N.REGION, COUNT(DISTINCT OH.GAMES) AS TT 
FROM OLYMPICS_HISTORY AS OH
JOIN olympics_history_noc_regions AS N USING(NOC)
GROUP BY 1 
HAVING TT = (SELECT COUNT(DISTINCT GAMES) AS TOTAL FROM OLYMPICS_HISTORY )
;


-- Q6 Identify the number sport which was played in all summer olympics.

SELECT  SPORT, count(DISTINCT GAMES) FROM OLYMPICS_HISTORY
WHERE GAMES LIKE '%Summer'
GROUP BY 1
ORDER BY 2 DESC;


-- Q7 Which Sports were just played only once in the olympics.

SELECT  DISTINCT SPORT, count(DISTINCT GAMES) AS COUNT_OF_GAMES FROM OLYMPICS_HISTORY
GROUP BY 1
HAVING COUNT_OF_GAMES = 1
ORDER BY 1;

-- 8. Fetch the total no of sports played in each olympic games.

SELECT GAMES, COUNT(DISTINCT SPORT) FROM OLYMPICS_HISTORY
GROUP BY 1
ORDER BY 2 DESC;


-- Q9 Fetch oldest athletes to win a gold medal
SELECT * FROM
(
SELECT * FROM OLYMPICS_HISTORY
 WHERE MEDAL = 'Gold' )
 
WHERE AGE = (SELECT AGE FROM (SELECT * FROM OLYMPICS_HISTORY
             WHERE MEDAL = 'Gold' ) ORDER BY 1 DESC LIMIT 1);



-- Q10 Find the Ratio of male and female athletes participated in all olympic games.

SELECT CONCAT(ROUND(A.TOTAL_M/B.TOTAL_F,2),' : ' , ROUND(B.TOTAL_F/B.TOTAL_F,2) ) AS RATIO_M_TO_F FROM
(SELECT DISTINCT SEX, COUNT(GAMES) AS TOTAL_M FROM OLYMPICS_HISTORY
WHERE SEX = 'M'
GROUP BY 1) A,

(SELECT DISTINCT SEX, COUNT( GAMES) AS TOTAL_F FROM OLYMPICS_HISTORY
WHERE SEX = 'F'
GROUP BY 1) B;



-- Q11 Fetch the top 5 athletes who have won the most gold medals.

SELECT NAME, TEAM, TOTAL FROM (
SELECT NAME, TEAM, COUNT( MEDAL) AS TOTAL, DENSE_RANK() OVER(ORDER BY TOTAL DESC) AS RANK
FROM OLYMPICS_HISTORY
WHERE MEDAL = 'Gold'
GROUP BY 1,2)
WHERE RANK <= 5
ORDER BY 3 DESC;



-- Q12 Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).

SELECT NAME,TEAM,SUM(GOLD_MEDAL + SILVER_MEDAL + BRONZE_MEDAL) AS TOTAL , DENSE_RANK() OVER (ORDER BY TOTAL DESC) FROM
(SELECT NAME,TEAM, CASE WHEN MEDAL = 'Gold' THEN 1 ELSE 0 END AS GOLD_MEDAL, CASE WHEN MEDAL = 'Silver' THEN 1 ELSE 0 END AS SILVER_MEDAL,
CASE WHEN MEDAL = 'Bronze' THEN 1 ELSE 0 END AS BRONZE_MEDAL
FROM OLYMPICS_HISTORY
)
GROUP BY 1,2
ORDER BY TOTAL DESC
;

-- 2 ways to do the Q12

SELECT NAME, TEAM, TOTAL FROM (
SELECT NAME, TEAM, COUNT( MEDAL) AS TOTAL, DENSE_RANK() OVER(ORDER BY TOTAL DESC) AS RANK
FROM OLYMPICS_HISTORY
WHERE MEDAL IN ('Gold','Silver','Bronze')
GROUP BY 1,2)
WHERE RANK <= 5
ORDER BY 3 DESC;


-- Q13 Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.

SELECT N.REGION , COUNT(MEDAL) AS TOTAL, ROW_NUMBER() OVER(ORDER BY TOTAL DESC) AS RANK
FROM OLYMPICS_HISTORY
JOIN olympics_history_noc_regions N USING(NOC)
WHERE MEDAL IN('Gold','Silver','Bronze')
GROUP BY 1
ORDER BY 2 DESC LIMIT 5;


-- Q14 List down total gold, silver and bronze medals won by each country.


SELECT COUNTRY, SUM(GOLD_MEDAL) AS GOLD, SUM(SILVER_MEDAL) AS SILVER, SUM(BRONZE_MEDAL)  AS BRONZE FROM
(SELECT  N.REGION AS COUNTRY, CASE WHEN MEDAL = 'Gold' THEN 1 ELSE 0 END AS GOLD_MEDAL, CASE WHEN MEDAL = 'Silver' THEN 1 ELSE 0 END AS SILVER_MEDAL,
CASE WHEN MEDAL = 'Bronze' THEN 1 ELSE 0 END AS BRONZE_MEDAL
FROM OLYMPICS_HISTORY OH
JOIN olympics_history_noc_regions N USING(NOC)
)
GROUP BY 1
HAVING  GOLD + SILVER + BRONZE > 0
ORDER BY GOLD desc;


----------Q15 List down total gold, silver and bronze medals won by each country corresponding to each olympic games.


SELECT GAMES , COUNTRY, SUM(GOLD_MEDAL) AS GOLD, SUM(SILVER_MEDAL) AS SILVER, SUM(BRONZE_MEDAL)  AS BRONZE FROM
(SELECT  GAMES, N.REGION AS COUNTRY, CASE WHEN MEDAL = 'Gold' THEN 1 ELSE 0 END AS GOLD_MEDAL, CASE WHEN MEDAL = 'Silver' THEN 1 ELSE 0 END AS SILVER_MEDAL,
CASE WHEN MEDAL = 'Bronze' THEN 1 ELSE 0 END AS BRONZE_MEDAL
FROM OLYMPICS_HISTORY OH
JOIN olympics_history_noc_regions N USING(NOC)
)
GROUP BY 1,2
HAVING GOLD+SILVER+BRONZE > 0
ORDER BY 1,2 ASC;



--Q16 Which countries have never won gold medal but have won silver/bronze medals?


SELECT  COUNTRY, SUM(GOLD_MEDAL) AS GOLD, SUM(SILVER_MEDAL) AS SILVER, SUM(BRONZE_MEDAL)  AS BRONZE FROM
(SELECT  N.REGION AS COUNTRY, CASE WHEN MEDAL = 'Gold' THEN 1 ELSE 0 END AS GOLD_MEDAL, CASE WHEN MEDAL = 'Silver' THEN 1 ELSE 0 END AS SILVER_MEDAL,
CASE WHEN MEDAL = 'Bronze' THEN 1 ELSE 0 END AS BRONZE_MEDAL
FROM OLYMPICS_HISTORY OH
JOIN olympics_history_noc_regions N USING(NOC)
)
GROUP BY 1
HAVING  GOLD = 0 AND (SILVER >0 or BRONZE > 0)
ORDER BY 3 ASC,4 DESC;


-- Q17  In which Sport/event, India has won highest medals.


SELECT SPORT, COUNT(MEDAL)
FROM OLYMPICS_HISTORY
JOIN olympics_history_noc_regions N USING(NOC)
WHERE N.REGION = 'India' AND MEDAL IN ('Gold','Silver','Bronze') 
GROUP BY 1
ORDER BY 2 DESC LIMIT 1 ;

---------1F MUTIPULE SPOTS HAVE SAME NO OF MEDALS
SELECT SPORT, TOTAL FROM
(SELECT SPORT, COUNT(MEDAL) AS TOTAL, DENSE_RANK() OVER(ORDER BY TOTAL DESC) AS RANKS
FROM OLYMPICS_HISTORY
JOIN olympics_history_noc_regions N USING(NOC)
WHERE N.REGION = 'India' AND MEDAL IN ('Gold','Silver','Bronze') 
GROUP BY 1
ORDER BY 2 DESC
)
WHERE RANKS =1;


select * from olympics_history where team ;

-- Q18 Break down all olympic games where India won medal for Hockey and how many medals in each olympic games


SELECT N.REGION, SPORT, GAMES, COUNT(MEDAL) AS TOTAL_MEDAL_WON
FROM OLYMPICS_HISTORY
JOIN olympics_history_noc_regions N USING(NOC)
WHERE TEAM = 'India' AND SPORT = 'Hockey' AND MEDAL IN ('Gold','Silver','Bronze')
GROUP BY 1,2,3
ORDER BY 4 DESC;









