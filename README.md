# Netflix Movies and TV Shows Data Analysis using SQL

![](logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY 1;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
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
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
select * from netfilx
where type = 'Movie'
and
release_year <= 2020;
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Identify the Longest Movie

```sql
select *
from netfilx
where type = 'Movie'
and
duration=(select max(duration) from netfilx);
```

**Objective:** Find the movie with the longest duration.

### 5. Find Content Added in the Last 5 Years

```sql
SELECT *
FROM netfilx
WHERE STR_TO_DATE(date_added, '%M %d, %Y') >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR);

```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 6. Find All Movies/TV Shows by Director 'Kirsten Johnson'

```sql
select *
from netfilx
where director = 'Kirsten Johnson';
```

**Objective:** List all content directed by 'Kirsten Johnson'.

### 7. List All TV Shows with More Than 5 Seasons

```sql
SELECT type, duration,title
FROM netfilx
WHERE type = 'TV Show'
  AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5;
```

**Objective:** Identify TV shows with more than 5 seasons.

### 8. Count the Number of Content Items in Each Genre

```sql
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

```

**Objective:** Count the number of content items in each genre.

### 9. List All Movies that are Documentaries

```sql
select title,type,listed_in
from netfilx
where type = 'Movie'
and 
listed_in = 'Documentaries';
```

**Objective:** Retrieve all movies classified as documentaries.

### 10. Find All Content Without a Director

```sql
SELECT *
FROM netfilx
WHERE director IS NULL;
```
**Objective:** List content that does not have a director.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.



## Author - Jyotirmay Das


