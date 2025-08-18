# 👶 Baby Names Uncovered: A SQL Journey Through Naming Trends

<div align="center">

![MySQL](https://img.shields.io/badge/MySQL-Expert-orange?style=for-the-badge&logo=mysql)
![Data Analysis](https://img.shields.io/badge/Data%20Analysis-Advanced-green?style=for-the-badge)
![Demographics](https://img.shields.io/badge/Demographics-Research-blue?style=for-the-badge)
![Complexity](https://img.shields.io/badge/Complexity-⭐⭐⭐-yellow?style=for-the-badge)

</div>

---

## 📋 Project Overview

**Role**: Data Analyst for a popular baby names website  
**Database**: MySQL  
**Time Period**: 1980-2009 (30 years of data)  
**Industry**: Demographics & Social Analysis

I was hired as a Data Analyst for a popular baby names website that collects data on the names that parents give their children each year. Using my skills in MySQL, I explored the data to uncover fascinating trends spanning three decades.

---

## 🎯 Project Objectives

1. **📈 Track Changes in Popularity** - Identify top names and their journeys over time
2. **📅 Compare Popularity Across Decades** - Discover era-defining naming trends  
3. **🗺️ Compare Popularity Across Regions** - Explore geographical preferences
4. **🔍 Dig into Unique Names** - Investigate special cases and anomalies

---

## 🚀 Key Findings & Analysis

### 1. 📈 Tracking Changes in Popularity

#### Finding the All-Time Champions

To start, I needed to find the single most popular name for girls and boys across the entire dataset. I wrote a simple but powerful query to count all the births for each name and then picked the one with the highest count.

**Female Champion Query:**
```sql
SELECT   Name, SUM(Births) AS num_babies
FROM     names
WHERE    Gender = 'F'
GROUP BY 1
ORDER BY 2 DESC
LIMIT    1;
```

**🏆 Result: Jessica** - The all-time most popular girl's name!

**Male Champion Query:**
```sql
SELECT   Name, SUM(Births) AS num_babies
FROM     names
WHERE    Gender = 'M'
GROUP BY 1
ORDER BY 2 DESC
LIMIT    1;
```

**🏆 Result: Michael** - The all-time most popular boy's name!

#### The Rise and Fall of a Star

But just because Jessica and Michael were the overall winners, it doesn't mean they were number one every single year. I was curious to see their journey year by year. Were they always at the top, or did their popularity change over time?

**Jessica's Popularity Journey:**
```sql
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
```

**Michael's Popularity Journey:**
```sql
WITH boy_names AS ( SELECT   Year, Name, SUM(Births) AS num_babies
                    FROM     names
                    WHERE    Gender = 'M'
                    GROUP BY 1,2),
    popularity AS ( SELECT  Year, Name,
                            ROW_NUMBER() OVER(PARTITION BY Year ORDER BY num_babies DESC) AS popularity
                    FROM    boy_names
)
SELECT  *
FROM    popularity
WHERE   Name = 'Michael';
```

**💡 Insight**: These queries revealed that while Michael was consistently a top name, Jessica had a clear peak in the 1980s and 1990s before her popularity started to fade in the 2000s. It proves that even the biggest names can become less common over time.
<img width="386" height="525" alt="image" src="https://github.com/user-attachments/assets/ad33e861-3af3-4c2b-a1b7-592d1836c2dd" />

#### Finding the Rising Stars

Finally, I wanted to find the "rising stars"—the names that made the biggest leap in popularity. Which names were not very popular in 1980 but became super trendy by 2009?

```sql
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
FROM 	   names_1980 AS t1 
			      INNER JOIN names_2009 AS t2 ON t1.Name = t2.Name
ORDER BY 7 ASC;

```

**💡 Insight**: This analysis perfectly captures the ever-changing story of baby names, showing how parents' tastes evolve over time.
<img width="501" height="287" alt="image" src="https://github.com/user-attachments/assets/76f6d831-5510-4ec4-8de0-fa293ae6a3da" />

---

### 2. 📅 Comparing Popularity Across Decades

#### The Yearly "Top 3": A Snapshot in Time

I wanted a quick look at the top names for every single year in my data. Who were the top 3 girls and top 3 boys each year?

```sql
WITH all_names AS (
    SELECT   Year, Gender, Name, SUM(Births) AS sum_babies
    FROM     names
    GROUP BY 1,2,3
),
top_three AS(
    SELECT  Year, Gender, Name, sum_babies,
            ROW_NUMBER() OVER(PARTITION BY Year, Gender ORDER BY sum_babies DESC) AS popularity
    FROM    all_names
)
SELECT  *
FROM    top_three
WHERE   popularity <= 3;
```
<img width="395" height="429" alt="image" src="https://github.com/user-attachments/assets/3ced2d97-3e60-4004-99e5-003d94dbddd4" />

#### The Decade-Defining Names: The True Icons of an Era

While yearly trends are interesting, they can change quickly. I wanted to find the names that didn't just define a year, but an entire decade.

```sql
WITH decades AS(
    SELECT  
        CASE
            WHEN Year BETWEEN 1980 AND 1989 THEN '1980s'
            WHEN Year BETWEEN 1990 AND 1999 THEN '1990s'
            WHEN Year BETWEEN 2000 AND 2010 THEN '2000s'
            ELSE 'None'
        END AS decade,
        Gender, Name, SUM(Births) AS sum_babies
    FROM     names
    GROUP BY 1,2,3
),
popularity AS(
    SELECT   decade, Gender, Name, sum_babies,
             ROW_NUMBER() OVER(PARTITION BY decade, Gender ORDER BY sum_babies DESC) AS ranking
    FROM     decades
)
SELECT  *
FROM    popularity
WHERE   ranking <= 3;
```

**💡 Insight**: This showed that while "Jessica" and "Jennifer" were queens of the 80s, by the 2000s, names like "Emily" and "Madison" had taken over the throne. For boys, "Michael" was a king for a long time, but new champions like "Jacob" emerged in the new millennium.
<img width="440" height="353" alt="image" src="https://github.com/user-attachments/assets/3f74cf83-d4a9-4f73-a56f-8aafc69bc4e3" />

---

### 3. 🗺️ Comparing Popularity Across Regions

#### Mapping America: Regional Baby Distribution

Before finding the most popular names by region, I first needed to clean and organize my geographical data.

```sql

WITH clean_regions 	 AS	(SELECT 	State,
						                      CASE WHEN Region = 'New England' THEN 'New_England' ELSE Region END AS clean_region
						             FROM	    regions
                         UNION
                         SELECT   'MI' AS State, 'Midwest' AS Region)
SELECT 	 cr.clean_region, SUM(Births) AS sum_babies 
FROM	 names AS n LEFT JOIN clean_regions AS cr ON n.State = cr.State
GROUP BY 1
ORDER BY 2 DESC;
```
<img width="202" height="177" alt="image" src="https://github.com/user-attachments/assets/37c6b7f4-b150-4037-8a18-ac962970a8df" />

#### Finding the Regional Champions

I wanted to find the top 3 most popular girl names and top 3 boy names for each of the six regions.

```sql
WITH clean_regions 	 AS	(SELECT 	State,
                                  CASE WHEN Region = 'New England' THEN 'New_England' ELSE Region END AS clean_region
						             FROM	    regions
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
```

**💡 Insight**: This confirmed that what's popular in the 'South' might be very different from what's popular in the 'Pacific'. When it comes to baby names, location definitely matters!

<img width="424" height="464" alt="image" src="https://github.com/user-attachments/assets/fd77bba8-ffbd-4ca7-97e2-3efe6290fd81" />

---

### 4. 🔍 Exploring Unique Names

#### One Name, Two Genders: The Most Popular Androgynous Names

I was curious about androgynous names—names that are given to both boys and girls. To find the most popular ones, I created separate lists for male and female names, then used an INNER JOIN to find shared names.

```sql
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
```
<img width="199" height="211" alt="image" src="https://github.com/user-attachments/assets/545a6442-977b-4a88-b071-328cf435b0d4" />


#### From Short and Sweet to Long and Grand

**Most Popular Long Name (15 characters):**
```sql
SELECT		DISTINCT Name, SUM(Births) AS num_babies, LENGTH(Name) AS name_lengths
FROM		Names
WHERE		LENGTH(Name) = 15
GROUP BY	1
ORDER BY	2 DESC;	

```
**🏆 Result: Franciscojavier**

<img width="286" height="141" alt="image" src="https://github.com/user-attachments/assets/9e2771fc-2f23-4f5e-bbc5-8b6d264d8a20" />


**Most Popular Short Name (2 characters):**
```sql
SELECT		DISTINCT Name, SUM(Births) AS num_babies, LENGTH(Name) AS name_lengths
FROM		Names
WHERE		LENGTH(Name) = 2
GROUP BY	1
ORDER BY	2 DESC;

```
**🏆 Result: Ty**

<img width="241" height="224" alt="image" src="https://github.com/user-attachments/assets/ddc9893b-f449-4904-8240-b986e1f9d4b5" />



#### A Personal Quest: Finding the "Chris"

For my final analysis, I did a fun investigation inspired by the founder of Maven Analytics. I wanted to find the state with the highest percentage of babies named "Chris."

```sql
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
```

---

## 🎓 Technical Skills Demonstrated

- **Complex CTEs** - Multi-level Common Table Expressions
- **Window Functions** - ROW_NUMBER(), PARTITION BY
- **Advanced JOINs** - INNER JOIN, LEFT JOIN for data integration
- **Data Cleaning** - Handling missing data and standardization
- **Statistical Analysis** - Percentage calculations and rankings
- **Time Series Analysis** - Trend identification across decades

---

## 💡 Key Business Insights

**📊 Cultural Trends**
- Name popularity follows clear generational patterns
- Even top names experience significant rise and fall cycles
- Regional preferences reflect cultural diversity across America

**📈 Data-Driven Discoveries**
- Jessica dominated the 80s-90s but declined in the 2000s
- Michael showed remarkable consistency across all decades
- Androgynous names represent a significant naming category
- Geographic location strongly influences name preferences

**🔮 Implications for Business**
- Baby product companies can target regional preferences
- Trend forecasting possible through historical pattern analysis
- Cultural shift indicators valuable for marketing strategies

---

## 🏁 Conclusion

This project was a fascinating journey through 30 years of American naming trends. Using SQL to dig deep into the data revealed that baby names are far more than just labels—they're cultural artifacts that tell the story of our evolving society.

From discovering the rise and fall of name royalty like Jessica and Michael, to uncovering regional preferences and the charm of both ultra-short and impressively long names, this analysis proved that **data is full of interesting stories about our lives and our culture**.

The project showcased advanced SQL techniques including complex CTEs, window functions, and multi-table joins while delivering actionable insights about demographic trends and cultural patterns.

---

<div align="center">

**🔗 [View Complete Code Repository](https://github.com/milosilic2704/ProjectPorfolio/blob/main/SQLPortoflio/Baby%20Names%20Uncovered/BabyName_Project_Milos_Analysis.sql)**  
**📊 [Back to SQL Projects Portfolio](https://github.com/milosilic2704/ProjectPorfolio/tree/main/SQLPortoflio)**

</div>
