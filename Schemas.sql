-- SCHEMAS of Netflix
CREATE DATABASE Netflix_Analysis;
use Netflix_Analysis;


SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;


create table netfilx (
    show_id varchar(6),
	type varchar(10),
	title varchar(150),
	director varchar(208),
	cast varchar(1000),
	country	varchar(150),
    date_added	varchar(50),
    release_year int,	
    rating varchar(10),	
    duration varchar(15),	
    listed_in varchar(25),	
    descriptions varchar(250)
);

SELECT*FROM netfilx;

-- 1. Count the number of Movies vs TV Shows
select type,length(type) as total
from netfilx
group by 1;

SELECT COUNT(*) AS total_rows FROM netfilx;

DESCRIBE netfilx;
SELECT @@sql_mode;
SET SESSION sql_mode = 'STRICT_ALL_TABLES';

-- 2. Find the most common rating for movies and TV shows
select type,
rating
from (
select type,
 rating,
count(*),
rank() over(partition by type order by count(*) desc) as ranking
from netfilx
group by 1,2
) as t1
where ranking = 1;

-- 3. List all movies released in a specific year (e.g., 2020)
select * from netfilx
where type = 'Movie'
and
release_year <= 2020;

-- 4. Identify the longest movie

select *
from netfilx
where type = 'Movie'
and
duration=(select max(duration) from netfilx);

-- 5. Find content added in the last 5 years
SELECT *
FROM netfilx
WHERE STR_TO_DATE(date_added, '%M %d, %Y') >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR);

-- 6. Find all the movies/TV shows by director 'Kirsten Johnson'!

select *
from netfilx
where director = 'Kirsten Johnson';

-- 7. List all TV shows with more than 5 seasons

SELECT type, duration,title
FROM netfilx
WHERE type = 'TV Show'
  AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5;

-- 8. Count the number of content items in each genre

WITH RECURSIVE split_genre AS (
    SELECT
        show_id,
        TRIM(SUBSTRING_INDEX(listed_in, ',', 1)) AS genre,
        SUBSTRING(listed_in, LENGTH(SUBSTRING_INDEX(listed_in, ',', 1)) + 2) AS remaining
    FROM netfilx
    WHERE listed_in IS NOT NULL

    UNION ALL

    SELECT
        show_id,
        TRIM(SUBSTRING_INDEX(remaining, ',', 1)),
        SUBSTRING(remaining, LENGTH(SUBSTRING_INDEX(remaining, ',', 1)) + 2)
    FROM split_genre
    WHERE remaining != ''
)

SELECT 
    genre,
    COUNT(*) AS total_content
FROM split_genre
GROUP BY genre
ORDER BY total_content DESC;
-- 9. List all movies that are documentaries
select title,type,listed_in
from netfilx
where type = 'Movie'
and 
listed_in = 'Documentaries';

-- 10. Find all content without a director

SELECT *
FROM netfilx
WHERE director IS NULL;




