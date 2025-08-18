/* PROJECT BRIEF: BABY NAMES ANALYSIS

The Situation: 	I am hired as a Data Analyst for a popular baby names website that collects data on the names
that parent give their children each year.
The Assignment: The Baby Names website is about to release its annual baby names report/
I am asked to dig into the baby names data to produce some interesting findings about baby names over the years
to share in the report.
The Objectives:	 
1. Track Changes in popularity
2. Compare popularity across decades.
3. Compare popularity across regions
4. Dig into some unique names.

*/

-- -------------------------------------------------------------------------------------------------------------
/* OBJECTIVE 1: Track Changes in popularity*/

-- Tasks:
-- 1) Find the overall most popular girl and boy names and show how they have changed in popularity rankings over the years

SELECT * FROM names;

SELECT 	 Name, SUM(Births) AS num_babies
FROM	 names
WHERE	 Gender = 'F'
GROUP BY 1
ORDER BY 2 DESC
LIMIT	 1;

SELECT 	 Name, SUM(Births) AS num_babies
FROM	 names
WHERE	 Gender = 'M'
GROUP BY 1
ORDER BY 2 DESC
LIMIT	 1; 

WITH girl_names AS (SELECT 	 Year, Name, SUM(Births) AS num_babies
					FROM 	 names
					WHERE	 Gender = 'F'
					GROUP BY 1,2),
     popularity AS (SELECT 	Year, Name,
					ROW_NUMBER() OVER(PARTITION BY Year ORDER BY num_babies DESC) AS popularity
					FROM 	girl_names)
SELECT	*
FROM 	popularity
WHERE	Name = 'Jessica';


WITH boy_names AS (SELECT 	 Year, Name, SUM(Births) AS num_babies
					FROM 	 names
					WHERE	 Gender = 'M'
					GROUP BY 1,2),
     popularity AS (SELECT 	Year, Name,
					ROW_NUMBER() OVER(PARTITION BY Year ORDER BY num_babies DESC) AS popularity
					FROM 	boy_names)
SELECT	*
FROM 	popularity
WHERE	Name = 'Michael';

-- 2) Find the names with the biggest jumps in popularity from the first year of the data set to the last year
WITH names_1980 AS(
		WITH all_names AS ( SELECT 	 Year, Name, SUM(Births) AS num_babies
							FROM 	 names
							GROUP BY 1,2)
		SELECT 	Year, Name,
				ROW_NUMBER() OVER(PARTITION BY Year ORDER BY num_babies DESC) AS popularity
        FROM 	all_names        
		WHERE	YEAR = 1980),
	names_2009 AS(
		WITH all_names AS ( SELECT 	 Year, Name, SUM(Births) AS num_babies
							FROM 	 names
							GROUP BY 1,2)
		SELECT 	Year, Name,
				ROW_NUMBER() OVER(PARTITION BY Year ORDER BY num_babies DESC) AS popularity
        FROM 	all_names        
		WHERE	YEAR = 2009)
SELECT	 t1.Year, t1.Name, t1.popularity,
		 t2.Year, t2.Name, t2.popularity,
		 CAST(t2.popularity AS SIGNED) - CAST(t1.popularity AS SIGNED) AS difference	
FROM 	 names_1980 AS t1 
			INNER JOIN names_2009 AS t2 ON t1.Name = t2.Name
ORDER BY 7 ASC;


-- -------------------------------------------------------------------------------------------------------------
/*OBJECTIVE 2: Compare popularity across decades*/

-- Tasks:
--  1) For each year, return the 3 most popular girl names and 3 most popular boy names
WITH all_names AS (SELECT 	 Year, Gender, Name, SUM(Births) AS sum_babies
					FROM 	 names
					GROUP BY 1,2,3),
	top_three  	AS( SELECT 	Year, Gender, Name, sum_babies,
					ROW_NUMBER() OVER(PARTITION BY Year, Gender ORDER BY sum_babies DESC) AS popularity
					FROM 	all_names)
SELECT	*
FROM 	top_three
WHERE popularity <= 3;


--  2) For each decade, return the 3 most popular girl names and 3 most popular boy names

WITH decades AS(SELECT	
					CASE
						WHEN Year BETWEEN 1980 AND 1989 THEN '1980s'
						WHEN Year BETWEEN 1990 AND 1999 THEN '1990s'
						WHEN Year BETWEEN 2000 AND 2010 THEN '2000s'
						ELSE 'None'
					END AS decade,
					Gender, Name, SUM(Births) AS sum_babies
					FROM 	 names
					GROUP BY 1,2,3),
	popularity AS(SELECT	decade, Gender, Name, sum_babies,
							ROW_NUMBER() OVER(PARTITION BY decade, Gender ORDER BY sum_babies DESC) AS ranking
				  FROM	decades)
SELECT 	*
FROM	popularity
WHERE	ranking <= 3;




-- ------------------------------------------------------------------------------------------------------------
/* OBJECTIVE 3: Compare popularity across regions */

-- Tasks: 
-- 1) Return the number of babies born in each of the six regions (NOTE: The state of MI should be in the Midwest region)
SELECT 	* FROM 	regions;
SELECT DISTINCT Region from regions;

WITH clean_regions 	 AS	(SELECT 	State,
						 CASE WHEN Region = 'New England' THEN 'New_England' ELSE Region END AS clean_region
						 FROM	regions
                         UNION
                         SELECT 'MI' AS State, 'Midwest' AS Region)
SELECT 	 cr.clean_region, SUM(Births) AS sum_babies 
FROM	 names AS n LEFT JOIN clean_regions AS cr ON n.State = cr.State
GROUP BY 1
ORDER BY 2 DESC;


-- 2) Return the 3 most popular girl names and 3 most popular boy names within each region
WITH clean_regions 	 AS	(SELECT 	State,
						 CASE WHEN Region = 'New England' THEN 'New_England' ELSE Region END AS clean_region
						 FROM	regions
                         UNION
                         SELECT 'MI' AS State, 'Midwest' AS Region),
	baby_names_region AS(SELECT 	 cr.clean_region, n.Gender, n.Name, SUM(Births) AS sum_babies 
						 FROM	 names AS n LEFT JOIN clean_regions AS cr
													ON n.State = cr.State
						GROUP BY 1,2, 3),
	popularity		AS (SELECT	clean_region, GEnder, Name, Sum_babies,
						ROW_NUMBER() OVER (PARTITION BY clean_region, Gender ORDER BY sum_babies DESC) AS popularity
						FROM	baby_names_region)
SELECT	*
FROM	popularity
WHERE 	popularity < 4;


-- -----------------------------------------------------------------------------------------------------------
/* OBJECTIVE 4: Explore unique names in the dataset */

-- Tasks:
-- 1) Find the 10 most popular androgynous names (names given to both females and males)

WITH	female AS (SELECT 	Gender, Name, SUM(Births) AS sum_babies
				   FROM		Names
				   WHERE	Gender = 'F'
                   GROUP BY	1,2),
		male	AS (SELECT 	Gender, Name, SUM(Births) AS sum_babies
				   FROM		Names
				   WHERE	Gender = 'M'
                   GROUP BY	1,2)
SELECT 	f.Name,
		f.sum_babies + m.sum_babies AS total_babies
FROM	female AS f
			INNER JOIN male AS m ON f.name = m.name
ORDER BY 2 DESC
LIMIT 	10;


-- 2) Find the length of the shortest and longest names, and identify the most popular short names (those with the fewest characters) and long names (those with the most characters)

-- Shortest = 2; Longest = 15

SELECT		DISTINCT Name, SUM(Births) AS num_babies, LENGTH(Name) AS name_lengths
FROM		Names
WHERE		LENGTH(Name) = 15
GROUP BY	1
ORDER BY	2 DESC;	

SELECT		DISTINCT Name, SUM(Births) AS num_babies, LENGTH(Name) AS name_lengths
FROM		Names
WHERE		LENGTH(Name) = 2
GROUP BY	1
ORDER BY	2 DESC;	


-- 3) The founder of Maven Analytics is named Chris. Find the state with the highest percent of babies named "Chris"


WITH 	total_names AS (SELECT 	 State, SUM(Births) AS sum_names
						FROM	 names
                        GROUP BY 1),
		chris_names AS 	(SELECT  State, SUM(Births) AS chris_names
						FROM	 names
                        WHERE	 Name = 'Chris'
                        GROUP BY 1)
SELECT	 tn.State,
		 tn.sum_names AS total_sum_names,
         cn.chris_names AS total_chris_names,
         cn.chris_names/tn.sum_names * 100 AS pct_chris_in_total
FROM	 total_names AS tn
			INNER JOIN chris_names AS cn ON tn.State = cn.State
ORDER BY 4 DESC
LIMIT	 1;


