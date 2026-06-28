-- Netflix Data Analysis using SQL
-- Solutions of 16 business problems

--1. Find all content without a director
       SELECT * 
 FROM netflix
 WHERE 
      director IS NULL;
-- 2. List all movies released in a specific year (e.g., 2020)
    SELECT
	 		type,
			 title,
			 release_year
	 FROM netflix
	 WHERE 
	 		type = 'Movie'
			AND
	 		release_year = 2020;
  
-- 3. Find the most common rating for movies and TV shows
    SELECT 
			type,
			 rating
	FROM 
	(
	 SELECT 
	 		type,
			 rating,
			 COUNT(*),
			 RANK()  OVER(PARTITION BY type ORDER BY COUNT(*) DESC ) AS ranking
	 FROM netflix
	 GROUP BY 1,2
	 ) t
	  WHERE ranking = 1;

-- 4. Count the number of Movies vs TV Shows
      SELECT 
  		type, COUNT(*)  AS total_count
  FROM netflix
  GROUP BY type;

-- 5. Find the top 5 countries with the most content on Netflix
    SELECT
	 		UNNEST(STRING_TO_ARRAY (country,',')) AS  new_country,    --string to array convert string in array used when single column has multiple values with separater
			COUNT(show_id) as total_content                             --unnest is used covert array elements into separate row.
	 FROM netflix
	 GROUP BY country
	 ORDER BY total_content DESC
	 LIMIT 5;

	  SELECT 
	   UNNEST(STRING_TO_ARRAY (country,',')) AS  new_country
	   FROM netflix;

-- 6. Find content added in the last 5 years
    SELECT * ,
      TO_DATE(date_added,'Month DD,YYYY') as new_date   --convert its into date type
    FROM netflix
	WHERE
	   TO_DATE(date_added,'Month DD,YYYY') >=CURRENT_DATE - INTERVAL '5 YEARS ' ;

-- 7. Identify the longest movie
      SELECT
    type,
    SPLIT_PART(duration, ' ', 1)::INT AS duration1  
FROM netflix
WHERE 	 type = 'Movie'
   AND 	 duration IS NOT NULL
ORDER BY duration1 DESC   
LIMIT 1;

-- 8. List all TV shows with more than 5 seasons
     SELECT * 
      FROM  netflix
       where type = 'TV Show'
	           AND
	         SPLIT_PART(duration,' ',1)::INT > 5;  -- THE logic is select only TV shows then apply
	   									                          	--split_part which gives first part of season then 
											                           --convert it to the number using INT and apply condition on that number >5
											   
-- 9. Find all the movies/TV shows by director 'Rajiv Chilaka'!
     select * from netflix
	 where  director ILIKE '%Rajiv Chilaka%';


-- 10. Count the number of content items in each genre
    	 SELECT  
	 		UNNEST(STRING_TO_ARRAY(listed_in,',')) AS genre,
			 count(show_id) AS total_content
	  FROM netflix
	   GROUP BY genre
	   ORDER BY total_content DESC;


-- 11.Find each year and the average numbers of content release in India on netflix. 
-- return top 5 year with highest avg content release!
    SELECT
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
    COUNT(*) AS content_released,
    ROUND(
	     COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country ILIKE '%India%')::numeric *100 ,2
    ) AS avg_content_per_year
FROM netflix
WHERE country ILIKE '%India%'
  AND date_added IS NOT NULL
GROUP BY 1
ORDER BY content_released DESC
LIMIT 5;


-- 12. List all movies that are documentaries
  
  SELECT *
  FROM NETFLIX
  WHERE listed_in ILIKE '%Documentaries%'

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
    SELECT * FROM  netflix
  WHERE casts ILIKE '%Salman Khan%'    --ilike check both A And a
      AND
	   release_year > EXTRACT(YEAR FROM CURRENT_DATE) -10    --data may chages due to current_date is used 

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
       
    SELECT     
   			UNNEST(STRING_TO_ARRAY(casts,','))  AS actors ,   
			 COUNT(*) AS total_content
   FROM netflix
  WHERE country ILIKE '%India%'
      AND
	     type ILIKE '%Movie%'
   GROUP BY 1
   ORDER BY 2 DESC
   LIMIT 10;


-- 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.

  WITH new_cte
AS (
 SELECT *,
 CASE
      WHEN description ILIKE '%skill%' OR
	        description ILIKE '%violence%' THEN 'Bad_content'
		     ELSE  'Good_Content'
		     END category
	       FROM netflix
)
SELECT category,
 COUNT(*)   AS total_content
	FROM new_cte
	GROUP BY 1;

--16. For India, find the number of Netflix titles added each year and return the top 5 years with the highest content releases.

SELECT
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
    COUNT(*) AS content_released
FROM netflix
WHERE  country ILIKE '%India%'
     AND date_added IS NOT NULL
GROUP BY 1
ORDER BY content_released DESC
LIMIT 5;





