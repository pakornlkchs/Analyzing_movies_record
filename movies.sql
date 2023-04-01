-- preview data from three imported datasets
SELECT *
FROM movies
LIMIT 100;

SELECT *
FROM character
LIMIT 100;

SELECT *
FROM actor
LIMIT 100;

-- find if there are any duplicated movie that might skew our further analysis
SELECT 
	title,
    	COUNT(title) AS total
FROM movies
GROUP BY title 
HAVING total > 1;
-- [there are 8 movies that appeared more than once.]

-- check if these movies is really duplicated
SELECT *
FROM movies
WHERE title IN (
	SELECT title
  	FROM (
  		SELECT
			title,
    		COUNT(title) AS total
		FROM movies
		GROUP BY title 
		HAVING total > 1
     )
)
ORDER BY title;
-- [the result shows that only Jurassic Park III have quite the same detail.]

-- After searching on the internet, the correct data might be the one with 5.9 rating so I will remove Jurassic Park III with movieid = 99
DELETE FROM movies
WHERE movieid = 99;

-- check if movieid = 99 is deleted
SELECT *
FROM movies
WHERE movieid = 99;

-- also check in character table if there is Jurassic Park III with movieid = 99
SELECT *
FROM character
WHERE movieid = 99;

-- all data are cleaned, next step is exploratory data analysis

-- EDA
-- What is the average run time for all movies?
SELECT 
	ROUND(AVG(runtime),2) AS average_runtime
FROM movies;

-- What is the average runtime for each genre?
SELECT 
	genre,
    	ROUND(AVG(runtime),2) AS average_runtime
FROM movies
GROUP BY genre
ORDER BY average_runtime;

-- TOP 10 movies with the most profit
SELECT
	title,
    	(gross - budget) AS profit
FROM movies
ORDER BY profit DESC
LIMIT 10;

-- TOP 10 actors who played in the most movie
SELECT 
	a.name,
    	COUNT(m.title) as number_of_movie_played,
    	ROUND(AVG(rating),2) AS mean_rating
FROM actor AS a
Left JOIN character AS c 
	ON a.actorid = c.actorid
LEFT JOIN movies as m
	ON c.movieid = m.movieid
GROUP BY a.name
ORDER BY number_of_movie_played DESC
LIMIT 10;

-- Who has played in movies the most? and what are that movies?
SELECT 
	a.name,
	m.title,
    	m.release_date,
    	COUNT(m.title) OVER(PARTITION BY a.name) AS movies_played
FROM actor AS a
LEFT JOIN character AS c 
	ON a.actorid = c.actorid
LEFT JOIN movies as m
	ON c.movieid = m.movieid
ORDER BY movies_played DESC;
