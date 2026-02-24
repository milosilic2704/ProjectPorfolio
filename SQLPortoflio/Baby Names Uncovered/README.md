# 👶 Baby Names Uncovered: A SQL Journey Through Naming Trends

<div align="center">

![MySQL](https://img.shields.io/badge/MySQL-Expert-orange?style=for-the-badge&logo=mysql)
![Data Analysis](https://img.shields.io/badge/Data%20Analysis-Advanced-green?style=for-the-badge)
![Demographics](https://img.shields.io/badge/Demographics-Research-blue?style=for-the-badge)
![Complexity](https://img.shields.io/badge/Complexity-⭐⭐⭐-lightgray?style=for-the-badge)

</div>

---

## Introduction

Dive into 30 years of American baby names! Focusing on naming trends from 1980 to 2009, this project explores **top names over time**, **decade-defining champions**, **regional preferences**, and **unique naming patterns** in the United States.

SQL queries? Check them out here: [BabyName_Project_Milos_Analysis.sql](https://github.com/milosilic2704/ProjectPorfolio/blob/main/SQLPortoflio/Baby%20Names%20Uncovered/BabyName_Project_Milos_Analysis.sql)

---

## Background

Driven by curiosity about how cultural shifts reflect in the names parents choose for their children, this project was built to explore demographic data and uncover patterns in baby-naming trends spanning three decades. The dataset covers birth records from all U.S. states between 1980 and 2009.

### The questions I wanted to answer through my SQL queries:

1. What are the all-time most popular names, and how did their rankings change year by year?
2. Which names rose the most in popularity between 1980 and 2009?
3. What were the top names for each decade?
4. Which names are most popular in each U.S. region?
5. What are the most popular androgynous (gender-neutral) names, and which states favour the name "Chris"?

---

## Tools I Used

For my deep dive into three decades of naming data, I harnessed the power of several key tools:

- **SQL** — The backbone of my analysis, allowing me to query the database and extract meaningful insights.
- **MySQL** — The chosen database management system, ideal for handling the large birth records dataset.
- **MySQL Workbench** — My go-to environment for writing, executing, and testing SQL queries.
- **Git & GitHub** — Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

---

## The Analysis

Each query for this project aimed at investigating a specific aspect of American baby-naming trends. Here's how I approached each question:

---

### 1. What are the all-time most popular names, and how did they change over time?

To identify the all-time champions, I queried total births by name for each gender, then tracked their year-by-year popularity rankings using window functions.

**Female Champion Query:**
```sql
SELECT   Name, SUM(Births) AS num_babies
FROM     names
WHERE    Gender = 'F'
GROUP BY 1
ORDER BY 2 DESC
LIMIT    1;
```

**🏆 Result: Jessica** — The all-time most popular girl's name!

**Male Champion Query:**
```sql
SELECT   Name, SUM(Births) AS num_babies
FROM     names
WHERE    Gender = 'M'
GROUP BY 1
ORDER BY 2 DESC
LIMIT    1;
```

**🏆 Result: Michael** — The all-time most popular boy's name!

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

#### Key Findings

- **Michael dominated every decade** — His ranking never fell below #2 over the entire 30-year period, making him the most consistent top-tier name in the dataset.
- **Jessica peaked sharply in the late 1980s** — She held the #1 spot for several consecutive years before a steady decline throughout the 2000s, illustrating how cultural moments drive naming booms.
- **Name longevity at the top is rare** — Maintaining a top-10 ranking over 30 years is the exception, not the rule, as new names continuously displace established ones.

#### Which Names Rose the Most in Popularity?

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

#### Key Findings

- **Generational names dominate the risers** — The biggest movers tend to be names associated with cultural icons, TV characters, or celebrity children who became famous between 1980 and 2009.
- **Some 1980 top names virtually disappeared** — Several names that ranked in the top 50 in 1980 had dropped hundreds of positions by 2009, demonstrating how quickly naming fashions can reverse.
- **Gender-neutral names gained ground** — Several unisex names appeared in the rising-star list, reflecting a broader cultural shift toward gender-flexible naming conventions.

---

### 2. What were the top names for each decade?

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

#### Key Findings

- **Female naming trends shifted dramatically** — Jessica and Jennifer defined the 1980s, but Emily and Madison became the defining names of the 2000s, showing a clear cultural pivot over just two decades.
- **Michael's dominance spanned two decades** — For both the 1980s and 1990s, Michael maintained the #1 spot for boys before Jacob dethroned him in the 2000s.
- **Each decade has a distinct naming identity** — The top-3 lists share almost no overlap between the 1980s and 2000s, demonstrating that naming trends are driven by generational cultural forces rather than timeless preferences.

---

### 3. Which names are most popular in each U.S. region?

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

#### Key Findings

- **The South leads in total births** — With the largest population base, Southern states contribute the most births, but their naming preferences lean towards traditional, classic names compared to coastal regions.
- **Regional naming identity is distinct** — The Pacific region shows stronger preference for modern and multicultural names, while New England and the Midwest favour more traditional choices.
- **A few national favourites transcend regions** — Names like Michael and Jessica appear in nearly every region's top 3, suggesting some names achieve true national cultural resonance rather than regional popularity.

---

### 4. What are the most popular androgynous names, and what unique patterns exist?

To find the most popular gender-neutral names, I created separate CTEs for male and female names, then used an INNER JOIN to identify names shared across both genders.

```sql
WITH female AS (
    SELECT  Gender, Name, SUM(Births) AS sum_babies
    FROM    Names
    WHERE   Gender = 'F'
    GROUP BY 1, 2
),
male AS (
    SELECT  Gender, Name, SUM(Births) AS sum_babies
    FROM    Names
    WHERE   Gender = 'M'
    GROUP BY 1, 2
)
SELECT  f.Name,
        f.sum_babies + m.sum_babies AS total_babies
FROM    female AS f
INNER JOIN male AS m ON f.name = m.name
ORDER BY 2 DESC
LIMIT 10;
```
<img width="199" height="211" alt="image" src="https://github.com/user-attachments/assets/545a6442-977b-4a88-b071-328cf435b0d4" />


#### Name Length Analysis

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



#### Finding the State with the Most "Chris" Babies

For my final analysis, I did a fun investigation to find the state with the highest percentage of babies named "Chris."

```sql
WITH total_names AS (
    SELECT  State, SUM(Births) AS sum_names
    FROM    names
    GROUP BY 1
),
chris_names AS (
    SELECT  State, SUM(Births) AS chris_names
    FROM    names
    WHERE   Name = 'Chris'
    GROUP BY 1
)
SELECT  tn.State,
        tn.sum_names AS total_sum_names,
        cn.chris_names AS total_chris_names,
        cn.chris_names / tn.sum_names * 100 AS pct_chris_in_total
FROM    total_names AS tn
INNER JOIN chris_names AS cn ON tn.State = cn.State
ORDER BY 4 DESC
LIMIT 1;
```

#### Key Findings

- **Jordan leads androgynous names by a wide margin** — The combined male and female birth count for Jordan far exceeds other gender-neutral names, confirming it as the most popular unisex name in the dataset.
- **Extremely long names are culturally concentrated** — Franciscojavier's dominance in the 15-character category reflects Hispanic naming traditions that combine compound names, pointing to a culturally specific pattern.
- **Short names favour simplicity** — The most popular 2-character name, Ty, shows that parents who choose abbreviated names converge on a small set of classics rather than inventing novel options.

---

## What I Learned

This project significantly expanded my SQL toolkit and deepened my understanding of how to draw cultural insights from demographic data:

- **Window functions are essential for ranking** — `ROW_NUMBER() OVER(PARTITION BY ...)` became my most-used tool throughout this project, allowing me to calculate relative rankings within groups (by year, decade, and region) without requiring separate subqueries for each group.
- **CTEs enable readable, layered logic** — Building multi-step analyses as stacked CTEs (even nested CTEs for the rising-stars query) made complex logic far easier to write, read, and debug than equivalent inline subqueries.
- **Data cleaning is part of every analysis** — The regional analysis required handling a missing state (`MI`) and standardising region names before any meaningful results could be produced, reinforcing that real-world data always needs preparation.
- **Simple questions reveal complex patterns** — "What is the most popular name?" sounds straightforward, but exploring the answer across time, region, and gender turned a single question into a multi-layered story about American culture over three decades.

---

## Conclusion

This exploration of 30 years of American baby names revealed clear, fascinating patterns for anyone interested in demographics, culture, or data-driven storytelling:

1. **Michael and Jessica are the undisputed champions of the era** — They dominated overall rankings and held #1 spots across multiple years and decades, making them the defining names of the 1980s and 1990s.
2. **Every decade has a distinct naming identity** — The top names of the 2000s (Emily, Madison, Jacob) share almost no overlap with those of the 1980s, reflecting how deeply cultural shifts influence naming decisions.
3. **Region shapes identity** — Where a child is born significantly influences what name they receive, with coastal and Southern states showing meaningfully different naming preferences.
4. **Names rise and fall like trends** — Even the most popular names experience a lifecycle of rise, peak, and decline, demonstrating that naming fashions move in generational waves.
5. **Data storytelling applies to everyday life** — This project reinforced that SQL's power extends beyond business analytics into any domain where human behaviour leaves a data trail. Baby names are a surprisingly rich window into how society changes over time.

---

<div align="center">

**🔗 [View Complete Code Repository](https://github.com/milosilic2704/ProjectPorfolio/blob/main/SQLPortoflio/Baby%20Names%20Uncovered/BabyName_Project_Milos_Analysis.sql)**  
**📊 [Back to SQL Projects Portfolio](https://github.com/milosilic2704/ProjectPorfolio/tree/main/SQLPortoflio)**

</div>
