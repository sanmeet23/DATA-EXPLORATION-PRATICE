CREATE DATABASE movie
use movie 

CREATE OR REPLACE TABLE actor(
act_id INT,
act_fname VARCHAR(25),
act_lname VARCHAR(25),
act_gender CHAR(20))

CREATE OR REPLACE TABLE CASTS( 
act_id INT,
mov_id INT,
ROLES VARCHAR(30))



CREATE OR REPLACE TABLE DIRECTOR(
dir_id INT,
dir_fname VARCHAR(30),
dir_Lname VARCHAR(30))


CREATE OR REPLACE TABLE GENRES(
gen_id INT,
gen_title VARCHAR(30))



CREATE OR REPLACE TABLE MOVIES(
mov_id INT,
mov_title VARCHAR(30),
mov_year INT,
mov_time INT,
mov_lang CHAR(20),
RELEASE_DATE DATE,
mov_rel_country CHAR(10))
 
 
SELECT * FROM MOVIES_NEW



CREATE OR REPLACE TABLE MOVIES_NEW(
mov_id INT,
mov_title VARCHAR(30),
mov_year INT,
mov_time INT,
mov_lang CHAR(20),
RELEASE_DATE DATE,
mov_rel_country CHAR(10))
 


SELECT * FROM MOVIES

CREATE OR REPLACE TABLE MOV_DIR(
dir_id INT,
mov_id INT)


CREATE OR REPLACE TABLE MOVIE_GENRE(
mov_id INT,
gen_id INT)


CREATE OR REPLACE TABLE RATINGS(
mov_id INT,
rev_id INT,
rev_stars FLOAT,
num_o_ratings INT)

SELECT * FROM RATINGS

CREATE OR REPLACE TABLE REVIEWER(
rev_id INT,
rev_name VARCHAR(30))

SELECT * FROM movies WHERE YEAR(RELEASE_DATE) > 1995




-- Q1
SELECT * FROM movies WHERE mov_year > 1995 AND mov_time > 120 AND UCASE(mov_title) LIKE "%A%"


-- Q2
SELECT a.* FROM actor AS A JOIN casts AS C ON A.ACT_ID = C.ACT_ID 
JOIN movies AS M ON M.MOV_ID= C.MOV_ID
WHERE mov_title = "Chinatown"


-- Q3

SELECT * FROM ratings 
ORDER BY num_o_ratings DESC LIMIT 1


-- Q4

SELECT * FROM movies
WHERE mov_rel_country = 'UK'
ORDER BY mov_year ASC LIMIT 7


-- Q5

UPDATE MOVIES
SET MOV_LANG = 'Chinese'
WHERE MOV_LANG = 'Japanese' AND MOV_YEAR = 2001



-- Q6

SELECT g.gen_title,MAX(m.mov_time) AS max_duation,COUNT(mg.mov_id) as total_count FROM genres g 
JOIN movie_genre AS mg ON g.gen_id = mg.gen_id
JOIN movies AS m ON m.mov_id = mg.mov_id
GROUP BY 1
ORDER BY 3 desc



-- q7

CREATE OR REPLACE VIEW ACTOR_INFO AS
SELECT DISTINCT A.act_fname, A.act_lname,m.mov_title, C.ROLES FROM actor AS A JOIN casts AS C ON A.ACT_ID = C.ACT_ID 
JOIN movies AS M ON M.MOV_ID= C.MOV_ID
SELECT * FROM actor_INFO

-- Q8

select * from movies where RELEASE_DATE < ('1995-03-31');


--- Q9


SELECT DISTINCT A.act_fname, A.act_lname, C.ROLES FROM actor AS A JOIN casts AS C ON A.ACT_ID = C.ACT_ID 
JOIN movies AS M ON M.MOV_ID= C.MOV_ID
WHERE act_gender != "M"

-- Q10

INSERT INTO casts
VALUES (126,936,"Darth Vader"),
(140,939,"Sarah Connor"),
(135,942,"Ethan Hunt"),
(131,930,"Travis Bickle"),
(144,941,"Antoine Doinel")

SELECT * FROM casts