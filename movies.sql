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
-- [there are 8 movies that appeared more than 1 times.]

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
-- [the result shows that only Jurassic Park III has quite the same detail.]

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
